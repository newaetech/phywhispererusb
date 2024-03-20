# Copyright (c) 2019-2024, NewAE Technology Inc
# All rights reserved.
#
#
# Find this and more at newae.com - this file is part of the PhyWhisperer-USB
# project, https://github.com/newaetech/phywhispererusb
#
#    This file is part of PhyWhisperer-USB.
#
#    PhyWhisperer-USB is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    PhyWhisperer-USB is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Lesser General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with PhyWhisperer-USB.  If not, see <http://www.gnu.org/licenses/>.
#=================================================

import phywhisperer.util as util
import phywhisperer.interface.naeusb as NAE
import phywhisperer.interface.program_fpga as LLINT
import os
import re
from .logging import *
import pkg_resources
import threading
import time
from phywhisperer.interface.bootloader_sam3u import Samba
from phywhisperer.sniffer import USBSniffer, USBSimplePrintSink
from phywhisperer.protocol import PWPacketDispatcher, PWPacketHandler, IncompletePacket
from zipfile import ZipFile
from phywhisperer.firmware.phywhisperer import getsome
from collections import OrderedDict


class Usb(PWPacketDispatcher):
    """PhyWhisperer-USB Interface"""


    MAX_PATTERN_LENGTH = 64

    def __init__ (self, viewsb=False):
        """ Set up PhyWhisperer-USB device.
        
        Args:
            viewsb: Should only be set to 'True' when this is called by ViewSB.
        """
        self.viewsb = viewsb
        self.addpattern = False
        self.usb_trigger_freq = 240E6 #internal frequency used for trigger ticks
        self.expected_verilog_matches = 82
        self.slurp_defines()
        self._power_source = 'off'
        self.userio = userio(self)
        self.trigger = trigger(self)
        self.pattern = pattern(self)
        self._set_defaults()
        # Set up the PW device to handle packets in ViewSB:
        if viewsb:
            super().__init__(verbose=False)
            self.sniffer = USBSniffer()
            self.register_packet_handler(self.sniffer)

    def _set_defaults(self):
        self.stat_pattern_match_value = 0
        self.entries_captured = 0
        self._trigger_clock_phase_shift = 0
        self._prev_addr = self.REG_DUMMY
        self._num_pm_triggers = 1
        self._pattern = None
        self._mask = None

    def _dict_repr(self):
        rtn = OrderedDict()
        rtn['fpga_buildtime']       = self.fpga_buildtime
        rtn['usb_mode']             = self.usb_mode
        rtn['power_source']         = self.power_source
        rtn['capture_size']         = self.capture_size
        rtn['capture_delay']        = self.capture_delay
        rtn['capture_enabled']      = self.capture_enabled
        rtn['fifo_errors']          = self.fifo_errors
        rtn['pattern']              = self.pattern._dict_repr()
        rtn['trigger']              = self.trigger._dict_repr()
        rtn['userio']               = self.userio._dict_repr()
        return rtn

    def __repr__(self):
        return util.dict_to_str(self._dict_repr())

    def __str__(self):
        return self.__repr__()


    @property
    def fpga_buildtime(self):
        return self.get_fpga_buildtime()

    @property 
    def usb_mode(self):
        return self.get_usb_mode()

    @usb_mode.setter 
    def usb_mode(self, value):
        self.set_usb_mode(value)

    @property 
    def power_source(self):
        """Power source for target. NOTE: status changes via pushbutton are not reflected here.
        """
        return self._power_source

    @power_source.setter 
    def power_source(self, value):
        self.set_power_source(value)

    @property 
    def capture_size(self):
        return self.get_capture_size()

    @capture_size.setter 
    def capture_size(self, value):
        self.set_capture_size(value)

    @property 
    def capture_delay(self):
        return self.get_capture_delay()

    @capture_delay.setter 
    def capture_delay(self, value):
        self.set_capture_delay(value)

    @property 
    def capture_enabled(self):
        return self.get_capture_enabled()

    @capture_enabled.setter 
    def capture_enabled(self, value):
        self.set_capture_enabled(value)

    @property
    def fifo_errors(self):
        """Flag whether an underflow or overflow occured on the capture FIFO.
        """
        raw = self.read_reg(self.REG_SNIFF_FIFO_STAT, 1)[0]
        status = ''
        if (raw & 2) >> 1: 
            status += 'fifo_underflow, '
        if (raw & 16) >> 4: 
            status += ' fifo_overflow, '
        if status == '':
            status = None
        return status



    #def set_stat_pattern(self, pattern, mask=0x1f): (ALSO NEED TO SPLIT)
    #def stat_pattern_matched(self):


    def slurp_defines(self):
        """ Parse Verilog defines file so we can access register and bit
        definitions by name and avoid 'magic numbers'.
        """
        self.verilog_define_matches = 0
        defines_files = [pkg_resources.resource_filename('phywhisperer', 'firmware/defines_pw.v'),
                         pkg_resources.resource_filename('phywhisperer', 'firmware/defines_usb.v')]
        for i,defines_file in enumerate(defines_files):
            defines = open(defines_file, 'r')
            define_regex_base  =   re.compile(r'`define')
            define_regex_reg   =   re.compile(r'`define\s+?REG_')
            define_regex_radix =   re.compile(r'`define\s+?(\w+).+?\'([bdh])([0-9a-fA-F]+)')
            define_regex_noradix = re.compile(r'`define\s+?(\w+?)\s+?(\d+?)')
            for define in defines:
                if define_regex_base.search(define):
                    reg = define_regex_reg.search(define)
                    match = define_regex_radix.search(define)
                    if reg:
                        if i == 0:
                            block_offset = self.MAIN_REG_SELECT << 6
                        else:
                            block_offset = self.USB_REG_SELECT << 6
                    else:
                        block_offset = 0
                    if match:
                        self.verilog_define_matches += 1
                        if match.group(2) == 'b':
                            radix = 2
                        elif match.group(2) == 'h':
                            radix = 16
                        else:
                            radix = 10
                        setattr(self, match.group(1), int(match.group(3),radix) + block_offset)
                    else:
                        match = define_regex_noradix.search(define)
                        if match:
                            self.verilog_define_matches += 1
                            setattr(self, match.group(1), int(match.group(2),10) + block_offset)
                        else:
                            pw_logger.warning("Couldn't parse line: %s", define)
            defines.close()
        assert self.verilog_define_matches == self.expected_verilog_matches, "Trouble parsing Verilog defines files: didn't find the right number of defines (expected %d, got %d)." % (self.expected_verilog_matches, self.verilog_define_matches)


    def con(self, PID=0xC610, sn=None, program_fpga=True, bitstream_file=None):
        """Connect to PhyWhisperer-USB. Raises error if multiple detected

        Args:
            PID (int, optional): USB PID of PhyWhisperer, defaults to 0xC610 (NewAE standard).
            sn (int, option):  Serial Number of PhyWhisperer, required when multiple
                PhyWhisperers are connected.
            program_fpga (bool, option): Specifies whether or not to program the FPGA with
                the default firmware when we connect. Set to False if using custom bitstream.
        """

        self.usb = NAE.NAEUSB()
        self.usb.con(idProduct=[PID], serial_number=sn)
        self._llint = LLINT.PhyWhispererUSB(self.usb)

        if program_fpga:
            if bitstream_file is None:
                with ZipFile(getsome("phywhisperer-firmware.zip")) as myzip:
                    with myzip.open('phywhisperer_top.bit') as bitstream:
                        self._llint.FPGAProgram(bitstream)
                pass
            else:
                print("Programming custom bit stream '%s'" % bitstream_file)
                with open(bitstream_file,"rb") as bitstream:
                    self._llint.FPGAProgram(bitstream) 

        self.write_reg(self.REG_COUNT_WRITES, [1])


    def set_power_source(self, src):
        """Set power source for target. Can also be accessed via the power_source property.

        Args:
            src (str):
              * "5V" for power from this computer (via 'Control' USB port).
              * "host" for power from the host of the connection we're sniffing.
              * "off" for no power.
        """
        if src == "5V":
            self._llint.changePowerSource(self._llint.PWR_SRC_5V)
        elif src == "host":
            self._llint.changePowerSource(self._llint.PWR_SRC_HOST)
        elif src == "off" or src is None or src == False:
            self._llint.changePowerSource(self._llint.PWR_SRC_OFF)
        else:
            raise AttributeError("Unknown source %s, valid sources: '5V', 'host', 'off'")
        self._power_source = src


    def reset_fpga(self):
        """ Reset FPGA registers to defaults, use liberally to clear incorrect states.
        """
        #self._llint.resetFPGA()
        self.write_reg(self.REG_RESET_REG, [1])
        self.write_reg(self.REG_RESET_REG, [0])
        self.write_reg(self.REG_COUNT_WRITES, [1])
        self._set_defaults()

    def load_bitstream(self, bitfile):
        """Load bitstream onto FPGA"""
        if not os.path.isfile(bitfile):
            raise ValueError("Cannot find specified bitfile {}".format(bitfile))

        bitstream = open(bitfile, "rb")
        self._llint.FPGAProgram(bitstream)
        pass


    def auto_program(self):
        """ Erases the firmware of the onboard SAM3U, and reprograms it with default firmware

        Attempts to autodetect the COM PORT that the SAM3U shows up as. If this fails, it will
        be necessary to flash new firmware via :code:`program_sam3u`
        """
        import time, serial.tools.list_ports
        before = serial.tools.list_ports.comports()
        before = [b.device for b in before]
        time.sleep(0.5)
        self.erase_sam3u()
        time.sleep(1.5)
        after = serial.tools.list_ports.comports()
        after = [a.device for a in after]
        candidate = list(set(before) ^ set(after))
        if len(candidate) == 0:
            raise OSError("Could not detect COMPORT. Continue using programmer.program()")
        com = candidate[0]
        print("Detected com port {}".format(com))
        self.program_sam3u(com)
        
        
    def erase_sam3u(self):
        """Erase the SAM3U Firmware, which forces it into bootloader mode."""
        self._llint.eraseFW(confirm=True)

    def program_sam3u(self, port, fw_path=None):
        """Program the SAM3U Firmware assuming device is in bootloader mode.
        
        Args:
            port (str): Serial port name, such as 'COM36' or '/dev/ttyACM0'.        

            fw_path (str): Path to firmware binary to program the sam3u with.
                            If None, use default firmware. Defaults to None.
        """

        fw_data = None
        print("Opening firmware...")

        if fw_path is None:
            print("Firmware not specified. Using firmware/phywhisperer.py")
            fw_data = getsome("phywhisperer-SAM3U1C.bin").read()
        else:
            if not os.path.isfile(fw_path):
                raise ValueError("Cannot find specified firmware file {}".format(fw_path))
            fw_data = open(fw_path, "rb").read()

        sam = Samba()
        print("Opened!\nConnecting...")
        sam.con(port)
        print("Connected!\nErasing...")
        sam.erase()
        print("Erased!\nProgramming file {}...".format(fw_path))
        sam.write(fw_data)
        print("Programmed!\nVerifying...")
        if sam.verify(fw_data):
            print("Verify OK!")
            sam.flash.setBootFlash(True)
            print("Bootloader disabled. Please power cycle device.")
        else:
            print("Verify FAILED!")

        sam.ser.close()


    def set_usb_mode(self, mode='auto'):
        """Set USB PHY speed. Can also be accessed via the usb_mode property.
        
        Args:
            mode (str):
                 * "LS": manually set the PHY to low speed.
                 * "FS": manually set the PHY to full speed.
                 * "HS": manually set the PHY to high speed.
                 * "auto": Default. PW will attempt to automatically determine the
                       speed when the target is connected. Mode must be set to
                       'auto' prior to connecting or powering up the target,
                       otherwise speed cannot be determined correctly. Setting
                       the mode to 'auto' actively causes PW to try to
                       determine the speed.
        """
        if mode == 'auto':
           self.write_reg(self.REG_USB_SPEED, [self.USB_SPEED_AUTO])
        elif mode == 'LS':
           self.write_reg(self.REG_USB_SPEED, [self.USB_SPEED_LS])
        elif mode == 'FS':
           self.write_reg(self.REG_USB_SPEED, [self.USB_SPEED_FS])
        elif mode == 'HS':
           self.write_reg(self.REG_USB_SPEED, [self.USB_SPEED_HS])
        else:
           raise ValueError('Invalid mode %s; specify auto, LS, FS, or HS.' % mode)
        pass


    def write_reg(self, address, data):
        """Write a PhyWhisperer register.
        
        Args:
            address: int
            data: bytes
        """
        # consecutive multi-byte accesses to the same register can pose a problem,
        # so we throw in a dummy read to avoid it:
        if address == self._prev_addr:
            self.usb.cmdReadMem(self.REG_DUMMY, 1)
        self._prev_addr = address
        return self.usb.cmdWriteMem(address, data)


    def read_reg(self, address, size=1):
        """Reads a PhyWhisperer register.
        
        Args:
            address: int
            size: int, number of bytes to read
        Returns:
        """
        # consecutive multi-byte accesses to the same register can pose a problem,
        # so we throw in a dummy read to avoid it, EXCEPT when we're reading the FIFO
        if address == self._prev_addr and address != self.REG_SNIFF_FIFO_RD:
            self.usb.cmdReadMem(self.REG_DUMMY, 1)
        self._prev_addr = address
        return self.usb.cmdReadMem(address, size)


    def get_usb_mode(self):
        """Returns USB PHY speed.
           Return values:

               - 'auto': the speed has not been determined yet (was the mode set
                   to 'auto' _before_ the target was connected or powered up?).
               - 'LS': low speed
               - 'FS': full speed
               - 'HS: high speed
        
        """
        value = self.read_reg(self.REG_USB_SPEED)[0]
        if value == self.USB_SPEED_AUTO:
            return 'auto'
        elif value == self.USB_SPEED_LS:
            return 'LS'
        elif value == self.USB_SPEED_FS:
            return 'FS'
        elif value == self.USB_SPEED_HS:
            return 'HS'
        else:
            raise ValueError('Internal error: REG_USB_SPEED register contains invalid value %d.' % value)


    def read_capture_data(self, entries=0, verbose=False, blocking=False, burst_size=8192, timeout=5):
        """Read from USB capture memory.
        
        Args:
            blocking (bool, optional):
                * True: wait for data to be available before reading (slower).
                * False: read immediately, with underflow protection, all of the captured
                  data, until PW tells us we've read everything that it captured ('entries' is ignored).
            entries (int, optional): When blocking=True, number of capture entries to read. If not specified, 
                 read all the captured data. Cannot be greater than capture size, as set 
                 by set_capture_size().
            burst_size (int, optional): When blocking=False, size of burst FIFO reads, defaults to 8192.
            timeout (int, optional): timeout in seconds (ignored if 0, defaults to 5)
            verbose (bool, optional): Print extra debug info.
        
        Returns: List of captured entries. Each list element is itself a 3-element list,
        containing the 3 bytes that make up a capture entry. Can be parsed by split_packets()
        or split_data(). See software/phywhisperer/firmware/defines.v for definition of the FIFO
        data fields.

        """
        data = []
        starttime = time.time()
        self.entries_captured = 0

        if blocking:
            entries_read = 0

            if not entries:
                entries = self.capture_size
            elif entries > self.capture_size:
                raise ValueError('Error: requested to read %d entries but only %d were captured.' % (entries, self.capture_size))

            while entries_read < entries:
                while self.fifo_empty():
                    if timeout and time.time() - starttime > timeout:
                        pw_logger.warning("Capture timed out!")
                        break
                data.append(self.read_reg(self.REG_SNIFF_FIFO_RD, 4)[1:4])
                entries_read += 1

        else:
            notdone = True
            early_exit = False
            raw = []
            while notdone:
                raw.extend(self.read_reg(self.REG_SNIFF_FIFO_RD, 4*burst_size))
                # check CAPTURE_DONE and EMPTY flags on last entry read:
                bitmask = 2**self.FE_FIFO_STAT_CAPTURE_DONE + 2**self.FE_FIFO_STAT_EMPTY
                if raw[-1] & bitmask == bitmask:
                    notdone = False
                    # did we also overflow?
                    if raw[-1] & 2**self.FE_FIFO_STAT_OVERFLOW_BLOCKED:
                        pw_logger.warning("FIFO overflowed, capture stopped.")
                        early_exit = True
                elif timeout and time.time() - starttime > timeout:
                    pw_logger.warning("Capture timed out!")
                    notdone = False
                    early_exit = True
            # reformat the return array and at the same time, filter out the (possibly numerous) empty FIFO reads:
            for i in range(int(len(raw)/4)):
                if raw[i*4+3] & 3 != self.FE_FIFO_CMD_STRM:
                    data.append(raw[i*4+1:i*4+4])
            self.entries_captured = len(data)
            if early_exit:
                pw_logger.warning("%d entries captured." % self.entries_captured)

        if len(data): # maybe we only got empty reads
            if data[-1][2] & 2**self.FE_FIFO_STAT_UNDERFLOW:
                pw_logger.warning("Capture FIFO underflowed!")

        return data


    def split_data(self, rawdata, verbose=False):
        """Split raw USB capture data into data events and times, stat events and times.

        Args:
            rawdata: list of lists, e.g. obtained from read_capture_data()
        Returns:
            4-tuple of lists:
                0. data event times
                1. data bytes corresponding to data event times
                2. USB status update times
                3. USB status bytes corresponding to status update times
        """
        timestep = 0
        data_bytes = []
        data_times = []
        stat_bytes = []
        stat_times = []
        last_flags = 0xff

        for raw in rawdata:
            command = raw[2] & 0x3
            if (command == self.FE_FIFO_CMD_DATA):
                data = raw[1]
                ts = raw[0] & 0x7
                timestep += ts
                flags = (raw[0] & 0xf8) >> 3
                if verbose:
                   print("%8d   flags=%02x data=%02x"%(timestep, flags, data))
                # only log flags if they've changed:
                if flags != last_flags:
                   stat_bytes.append(flags)
                   stat_times.append(timestep)
                   last_flags = flags
                data_bytes.append(data)
                data_times.append(timestep)
            elif (command == self.FE_FIFO_CMD_STAT):
                ts = raw[0] & 0x7
                timestep += ts
                flags = (raw[0] & 0xf8) >> 3
                if verbose:
                   print("%8d   flags=%02x"%(timestep, flags))
                stat_bytes.append(flags)
                stat_times.append(timestep)
                last_flags = flags
            elif (command == self.FE_FIFO_CMD_TIME):
                ts = raw[0] + (raw[1] << 8)
                #Unlike stat and data commands, we don't add one here; if we did
                #we'd be overcounting in the common case where a time command immediately
                #preceeds a stat or data command. Consequence is that timestep will be off
                #by one in the case of lone time commands (which is rare, and inconsequential
                #in practice).
                timestep += ts
                if verbose:
                   print("%8d" % timestep)
            elif (command == self.FE_FIFO_CMD_STRM):
                # nothing to do or report
                # CAUTION: don't even print a status in verbose mode because we can be
                # receiving TONS of these!
                pass
            else:
                print ("ERROR: unknown command (%d)" % command) 

        return (data_times, data_bytes, stat_times, stat_bytes)


    def split_packets(self, rawdata):
        """Split raw USB capture data into packets.
        
        Args:
            rawdata: list of lists, e.g. obtained from read_capture_data()
        Returns:
            list
                Each list element is one packet and is presented in a dictionary with the following keys:
                    * 'timestamp'
                    * 'size' in bytes
                    * 'contents' list of bytes
        """
        # operates destructively so make a copy:
        rawdata_copy = rawdata[:]
        handler = PWPacketHandler()
        packets = []
        incomplete = False
        while rawdata_copy and not incomplete:
            # use ViewSB code to avoid duplicating it here:
            try:
                packets.append(handler.handle_bytes_received(defines=self, data=rawdata_copy))
            except IncompletePacket:
                incomplete = True
                continue
        return packets


    def print_packets(self, packets):
        """Print packets using USBSimplePrintSink from ViewSB/pyopenvizsla.
        Args:
            packets: list of dictionaries, e.g. obtained from split_packets()
        """
        printer = USBSimplePrintSink(highspeed=self.get_usb_mode() == 'HS')
        for packet in packets:
            printer.handle_usb_packet(ts=packet['timestamp'], buf=bytearray(packet['contents']), flags=(packet['flags']))


    @staticmethod
    def print_flags(stat_byte):
        """Print bitfields of USB status flags byte.
        """
        print('vbus_valid = %d' % (1 if stat_byte & 0x10 else 0))
        print('sess_end   = %d' % (1 if stat_byte & 0x08 else 0))
        print('sess_valid = %d' % (1 if stat_byte & 0x04 else 0))
        print('rx_error   = %d' % (1 if stat_byte & 0x02 else 0))
        print('rx_active  = %d' % (1 if stat_byte & 0x01 else 0))


    def set_capture_size(self, size=16376):
        """Set how many events to capture (events include data, USB status, and timestamps).
        Can also be accessed via the capture_size property.
        
        Args:
            size(int, option): number of events to capture. 0 = unlimited (until overflow). Max = 2^24-1. Since the capture FIFO can hold 16376 events, setting this to > 16376 may result in overflow.

        """
        if (size >= 2**24) or (size < 0):
            raise ValueError('Illegal size value.')
        self.write_reg(self.REG_CAPTURE_LEN, int.to_bytes(size, length=3, byteorder='little'))

    def get_capture_size(self):
        return int.from_bytes(self.read_reg(self.REG_CAPTURE_LEN, 3), byteorder='little')


    def ns_trigger(self, delay_in_ns):
        """Convert a nS number to delay or width cycles for set_trigger_sequence()"""
        cycles = (float(delay_in_ns) * 1.0E-9) / (1.0 / float(self.usb_trigger_freq))
        return round(cycles)

    def us_trigger(self, delay_in_us):
        """Convert a uS number to delay or width cycles for set_trigger_sequence()"""
        cycles = (float(delay_in_us) * 1.0E-6) / (1.0 / float(self.usb_trigger_freq))
        return round(cycles)

    def ms_trigger(self, delay_in_ms):
        """Convert a mS number to delay or width cycles for set_trigger_sequence()"""
        cycles = (float(delay_in_ms) * 1.0E-3) / (1.0 / float(self.usb_trigger_freq))
        return round(cycles)

    def set_trigger(self, num_triggers=1, delays=[0], widths=[1], enable=True):
        pw_logger.warning("use set_trigger_sequence() instead (API changed for clarity)")
        self.set_trigger_sequence(num_triggers, delays, widths, enable)

    def set_trigger_sequence(self, num_triggers=1, delays=[0], widths=[1], enable=True):
        """Program the output trigger sequence that is issued when a pattern
        match occurs.  For each pattern match event, up to 8 pulse(s) of
        programmable delay and width are issued. Both delay and width are
        measured in clock cycles of USB-derived 240 MHz clock. Note that this
        is a different time base than set_capture_delay(), which uses a 60 MHz
        clock!  The capture delay is automatically set to match the first trigger
        delay; use set_capture_delay to set it to a different value. Use
        ns_trigger(), us_trigger(), and ms_trigger() to convert values as
        needed.
        Can also be accessed via the trigger.enable, trigger.num_triggers,
        trigger.delays, and trigger.widths properties.
        
        Args:
            num_triggers (int): number of trigger pulses, from 1 to 8.
            delay (list of ints): delay for each trigger pulse; each element in range [0, 2^20-1] cycles 
                (only first element can be zero).
            width (list of ints): width for each trigger pulse; each element in range [1, 2^17-1] cycles.
            enable (bool, optional): set to 'False' to disable trigger generation on hardware pins.

        Examples:
            (a) To set obtain three 2-cycle-wide pulses, each 3 cycles apart, starting immediately after a
                pattern match:
                set_trigger_sequence(num_triggers=3, delays=[0,3,3], widths=[2,2,2])
            (b) To set obtain a 1-cycle wide pulse 10 cycles after a pattern match, followed by a 2-cycle wide
                pulse 20 cycles later:
                set_trigger_sequence(num_triggers=2, delays=[10,20], widths=[1,2])
        """
        if num_triggers > 8:
            raise ValueError('Maximum 8 trigger pulses.')
        if len(delays) != num_triggers or len(widths) != num_triggers:
            raise ValueError('Number of elements in delays and widths must match num_triggers.')

        data = 0
        for i in range(num_triggers):
            delay = delays[i]
            if (delay >= 2**20) or (delay < 0) or (delay < 1 and i > 0):
                raise ValueError('Illegal delay value.')
            data += delay << i*24
        self.write_reg(self.REG_TRIGGER_DELAY, int.to_bytes(data, length=3*num_triggers, byteorder='little'))

        data = 0
        for i in range(num_triggers):
            width = widths[i]
            if (width >= 2**17) or (width < 1):
                raise ValueError('Illegal width value.')
            data += width << i*24
        self.write_reg(self.REG_TRIGGER_WIDTH, int.to_bytes(data, length=3*num_triggers, byteorder='little'))

        self.write_reg(self.REG_NUM_TRIGGERS, [num_triggers])
        self.set_capture_delay(int(delays[0]/4))
        if enable == True:
            self.write_reg(self.REG_TRIGGER_ENABLE, [1])
        else:
            self.write_reg(self.REG_TRIGGER_ENABLE, [0])


    def set_capture_delay(self, delay):
        """Program the capture delay, measured in clock cycles of USB-derived 60 MHz clock.
        Note that this is a different time base than set_trigger_sequence(), which uses a 240 MHz clock!
        Can also be accessed via the capture_delay property.
        
        Args:
            delay (int): range in [0, 2^18-1] cycles of 60 MHz clock.
        """
        if (delay >= 2**18) or (delay < 0):
            raise ValueError('Illegal delay value.')
        self.write_reg(self.REG_CAPTURE_DELAY, int.to_bytes(delay, length=3, byteorder='little'))

    def get_capture_delay(self):
        return int.from_bytes(self.read_reg(self.REG_CAPTURE_DELAY, 3), byteorder='little')

    def set_num_pm_triggers(self, num):
        if num > 2**16 -1:
            raise ValueError("Maximum is 2**16-1")
        elif num == -1:
            num = 2**16-1
        self._num_pm_triggers = num
        self.write_reg(self.REG_NUM_PM_TRIGGERS, int.to_bytes(num, length=2, byteorder='little'))

    def get_num_pm_triggers_seen(self):
        """ Number of pattern match triggers generated. Resets upon arming.
        """
        return int.from_bytes(self.read_reg(self.REG_NUM_PM_TRIGGERS, 2), byteorder='little') - 1 # not a typo, HW records +1

    def set_capture_enabled(self, enable):
        """ Set whether USB events are captured or not.
        Can also be accessed via the capture_enabled property.

        Args:
            enable (bool)
        """
        if enable:
            raw = [0]
        else:
            raw = [1]
        self.write_reg(self.REG_CAPTURE_OFF, raw)

    def get_capture_enabled(self):
        if self.read_reg(self.REG_CAPTURE_OFF, 1)[0]:
            return True
        else:
            return False

    def set_pattern(self, pattern, mask=None):
        """Set the pattern and its bitmask used for capture and trigger output.
        
        Args:
            pattern (list of ints): list of between 1 and 64 bytes 
            mask (list, optional): list of bytes, must have same size as 'pattern' if
                set. Defaults to [0xff]*len(pattern) if not set.
        """
        if mask is None:
            mask = [0xFF] * len(pattern)
        
        if len(pattern) != len(mask):
            raise ValueError('pattern and mask must be of same size.')
        elif len(pattern) > self.MAX_PATTERN_LENGTH:
            raise ValueError('pattern and mask cannot be more than 64 bytes.')
        # extend the mask to full width (cheaper to do here than in HW):
        mask = [0]* (self.MAX_PATTERN_LENGTH - len(mask)) + mask
        self.write_reg(self.REG_PATTERN, pattern[::-1])
        self.write_reg(self.REG_PATTERN_MASK, mask[::-1])
        self.write_reg(self.REG_PATTERN_BYTES, [len(pattern)])
        self._pattern = pattern
        self._mask = mask


    def arm(self, value=True):
        """Arm PhyWhisperer for capture and optionally generating a trigger.
        Use set_pattern to program the pattern and bitmask which will initiate
        the capture and/or trigger operation.
        Use set_trigger_sequence to program the trigger parameters.
        Use set_capture_size and set_capture_delay to program the capture parameters.

        Args:
            value (bool): True/False = arm/disarm

        Raises:
            ValueError: if trying to arm an already armed PhyWhisperer.
        """
        if value:
            value = [1]
            if self.read_reg(self.REG_ARM, 1)[0]:
                raise ValueError("Already armed! (use arm(False) to disarm)")
        else:
            value = [0]
        self.write_reg(self.REG_ARM, value)


    def check_fifo_errors(self, underflow=0, overflow=0):
        """Check whether an underflow or overflow occured on the capture FIFO.
        
        Args:
            underflow (int, optional): expected status, 0 or 1
            overflow (int, optional): expected status, 0 or 1
        """
        status = self.read_reg(self.REG_SNIFF_FIFO_STAT, 1)[0]
        fifo_underflow = (status & 2) >> 1
        fifo_overflow = (status & 16) >> 4
        assert fifo_underflow == underflow
        assert fifo_overflow == overflow

    def get_fifo_errors(self):
        """Flag whether an underflow or overflow occured on the capture FIFO.
        """
        raw = self.read_reg(self.REG_SNIFF_FIFO_STAT, 1)[0]
        status = ''
        if (raw & 2) >> 1: 
            status += 'fifo_underflow, '
        if (status & 16) >> 4: 
            status += ' fifo_overflow, '
        if status == '':
            status = None
        return status


    def fifo_empty(self):
        """Returns True if the capture FIFO is empty, False otherwise.
        """
        if self.read_reg(self.REG_SNIFF_FIFO_STAT, 1)[0] & 1:
            return True
        else:
            return False


    def fifo_over_empty_threshold(self):
        """Returns True if the capture FIFO has more entries than the empty threshold (128).
        """
        fifo_stat = self.read_reg(self.REG_SNIFF_FIFO_STAT, 1)[0]
        fifo_empty = fifo_stat & 1
        fifo_empty_threshold = fifo_stat & 4
        if fifo_empty or fifo_empty_threshold:
            return False
        else:
            return True


    def armed(self):
        """Returns True if the PhyWhisperer is armed.
        """
        if self.read_reg(self.REG_ARM, 1)[0]:
            return True
        else:
            return False


    def wait_disarmed(self):
        """Blocks until armed() returns false.
        """
        while self.armed():
            pass


    def get_fpga_buildtime(self):
        """Returns date and time when FPGA bitfile was generated.
        """
        raw = self.read_reg(self.REG_BUILDTIME, 4)
        # definitions: Xilinx XAPP1232
        day = raw[3] >> 3
        month = ((raw[3] & 0x7) << 1) + (raw[2] >> 7)
        year = ((raw[2] >> 1) & 0x3f) + 2000
        hour = ((raw[2] & 0x1) << 4) + (raw[1] >> 4)
        minute = ((raw[1] & 0xf) << 2) + (raw[0] >> 6)
        return "{}/{}/{}, {}:{}".format(month, day, year, hour, minute)


    def trigger_clock_phase_shift(self, steps=1):
        """Shifts the trigger clock phase (and by extension the output trigger)
        in steps of 18.6ps (18.6 ps = 1/960 MHz / 56). Can also be accessed via
        the trigger.clock_phase property.
        
        Args:
            steps (int): Number of steps to shift the phase (positive or negative integer).
        """
        if not type(steps) == int or steps == 0:
            raise ValueError('Illegal steps value, must be non-zero integer.')
        if steps > 0:
            value = [1]
            self._trigger_clock_phase_shift += steps
        else:
            value = [0]
            self._trigger_clock_phase_shift -= steps
        for i in range(abs(steps)):
            self.write_reg(self.REG_TRIG_CLK_PHASE_SHIFT, value)
            while (self.read_reg(self.REG_TRIG_CLK_PHASE_SHIFT, 1)[0] == 1):
                # phase shift incomplete; wait:
                pass


    def set_stat_pattern(self, pattern, mask=0x1f):
        """ Set a 5-bit pattern and mask for the USB status lines.
        
        Args:
            pattern (int): 5-bit number
            mask (int): non-zero 5-bit number (default: 0x1f)
        """
        if pattern < 0 or pattern > 0x1f:
            raise ValueError('Illegal pattern value, must be <= 0x1f.')
        if mask < 1 or mask > 0x1f:
            raise ValueError('Illegal mask value, must be <= 0x1f and > 0.')
        self.write_reg(self.REG_STAT_PATTERN, [pattern, mask])


    def stat_pattern_matched(self):
        """ Returns 1 if a stat pattern match occurred (automatically resets to 0 when armed,
        and when a new match pattern is written).
        Actual match value is stored in self.stat_pattern_match_value.
        """
        matched, value = self.read_reg(self.REG_STAT_MATCH, 2)
        self.stat_pattern_match_value = value
        return matched



    def register_sink(self, event_sink):
        """ ViewSB: Registers a USBEventSink to receive any USB events. 
        
        Args:
            event_sink (sniffer.USBEventSink): The sniffer.USBEventSink object to receive any USB events that occur.
        """
        self.sniffer.register_sink(event_sink)


    def _device_stop_capture(self):
        # nothing to do?
        pass


    def run_capture(self, size=16376, burst=True, pattern=[0], mask=[0], timeout=5, statistics_callback=None, statistics_period=0.1, halt_callback=lambda _ : False, ):
        """ Runs a capture for ViewSB, including power cycling the device to catch the descriptors.
        
        Runs following internally::
        
            self.reset_fpga()
            self.set_power_source("host")
            self.set_power_source("off")
            time.sleep(0.5)
            self.set_usb_mode("auto")
            self.set_capture_size(size)
            self.arm()
            self.set_trigger_sequence(enable=False)
            self.set_pattern(pattern=pattern, mask=mask)
            self.set_power_source("host")
            time.sleep(0.25)
        
        """


        self.reset_fpga()
        self.set_power_source("host")
        self.set_power_source("off")
        time.sleep(0.5)
        self.set_usb_mode("auto")
        self.set_capture_size(size)
        self.arm()
        self.set_trigger_sequence(enable=False)
        self.set_pattern(pattern=pattern, mask=mask)
        self.set_power_source("host")
        time.sleep(0.25)
        self.entries_captured = 0

        self._start_comms_thread(burst, timeout)

        elapsed_time = 0.0
        try:

            # Continue until the user-supplied halt condition is met.
            while not halt_callback(elapsed_time): 

                # If we have a statistics callback, call it.
                if callable(statistics_callback):
                    statistics_callback(self, elapsed_time)

                # Wait for the next statistics-interval to occur.
                time.sleep(statistics_period)
                elapsed_time = elapsed_time + statistics_period

        finally:
            self._device_stop_capture()


    def __comms_thread_body(self, burst, timeout=5, burst_size=8192):
        """ ViewSB internal function that executes as our comms thread.
        
        Args:
            burst (bool): If True, read all FIFO at once, then pass on to decoder and frontend;
                     otherwise, read smaller chunks and process them concurrently.
            burst_size (int): Number of entries to read at a time when burst=False
        """

        if burst:
            self.wait_disarmed()
            rawdata = self.read_capture_data()
            self.handle_incoming_bytes(rawdata)

        else:
            notdone = True
            early_exit = False
            starttime = time.time()
            while notdone:
                raw = self.read_reg(self.REG_SNIFF_FIFO_RD, 4*burst_size)
                bitmask = 2**self.FE_FIFO_STAT_CAPTURE_DONE + 2**self.FE_FIFO_STAT_EMPTY
                if raw[-3] & bitmask == bitmask:
                    notdone = False
                    if raw[-3] & 2**self.FE_FIFO_STAT_OVERFLOW_BLOCKED:
                        pw_logger.warning("FIFO overflowed, capture stopped")
                        early_exit = True
                elif timeout and time.time() - starttime > timeout:
                    pw_logger.warning("Capture timed out!")
                    early_exit = True
                    notdone = False
                # filter out the empty FIFO reads:
                rawdata = []
                for i in range(int(len(raw)/4)):
                    if raw[i*4+3] & 3 != self.FE_FIFO_CMD_STRM:
                        rawdata.append(raw[i*4+1:i*4+4])
                self.handle_incoming_bytes(rawdata)
                self.entries_captured += len(rawdata)
                if early_exit:
                    pw_logger.warning("%d entries captured." % self.entries_captured)


    def _start_comms_thread(self, burst, timeout):
        """ ViewSB: start the background thread that handles our core communication. """

        self.commthread = threading.Thread(target=self.__comms_thread_body, args=[burst, timeout], daemon=True)
        self.__comm_term = False
        self.__comm_exc = None

        self.commthread.start()

        self.__comm_term = False


    def close(self):
        """ Terminates our connection to the PhyWhisperer device. """

        if self.viewsb:
            self.__comm_term = True
            self.commthread.join()
        self.usb.close()


class userio(util.DisableNewAttr):
    ''' USERIO-related settings.
    '''
    _name = 'PhyWhisperer USERIO settings'

    def __init__(self, main):
        super().__init__()
        self.main = main
        self.disable_newattr()

    def _dict_repr(self):
        rtn = OrderedDict()
        rtn['direction'] = self.direction
        rtn['data'] = self.data
        for i in range(8):
            rtn['D%d' % i] = self._pretty_print(i)
        return rtn

    def __repr__(self):
        return util.dict_to_str(self._dict_repr())

    def __str__(self):
        return self.__repr__()

    def _pretty_print(self, i):
        if self.direction[i] == 'I':
            status = 'input,  value='
        else:
            status = 'output, value='
        status += str(self.data[i])
        return status

    @property
    def data(self):
        """Get the status of the USERIO data pins (D0-D7), or set the value to
        be driven on USERIO pins when the pin's direction property is set to
        'O'.  Index <x> controls pin D<x>. You can set a single index, a slice
        of indices, or the full array.
        """
        return self._get_data()

    @data.setter
    def data(self, datas):
        self._set_data(datas)

    def _get_data(self):
        """Whether the specified USERIO pin is I/O.
        """
        datas = self._read_data()
        if type(datas) is int:
            return datas
        else:
            return util.Lister(datas, setter=self._set_data, getter=self._read_data)

    def _read_data(self):
        raw = self.main.read_reg(self.main.REG_USERIO_DATA, 1)[0]
        datas = []
        for bit in range(8):
            if raw & 2**bit:
                datas.append(1)
            else:
                datas.append(0)
        return datas

    def _set_data(self, datas):
        if len(datas) > 8:
            raise ValueError("Too many elements")
        raw = 0
        for i, item in enumerate(datas):
            if item == 1: raw += 2**i
        self.main.write_reg(self.main.REG_USERIO_DATA, [raw])


    @property
    def direction(self):
        """Set the direction of the USERIO data pins (D0-D7).
        Index <x> controls pin D<x>. You can set a single index,
        a slice of indices, or the full array. Use with care!

        Args:
            directions (string): set to 'I' to denote an input to PhyWhisperer, 
                or 'O' to denote driven by PhyWhisperer.
        """
        return self._get_direction()

    @direction.setter
    def direction(self, directions):
        self._set_direction(directions)

    def _get_direction(self):
        """Whether the specified USERIO pin is I/O.
        """
        directions = self._read_direction()
        if type(directions) is bool:
            return directions
        else:
            return util.Lister(directions, setter=self._set_direction, getter=self._read_direction)

    def _read_direction(self):
        raw = self.main.read_reg(self.main.REG_USERIO_PWDRIVEN, 1)[0]
        directions = []
        for bit in range(8):
            if raw & 2**bit:
                directions.append('O')
            else:
                directions.append('I')
        return directions

    def _set_direction(self, directions):
        if len(directions) > 8:
            raise ValueError("Too many elements")
        raw = 0
        for i, item in enumerate(directions):
            if item == 'O': raw += 2**i
        self.main.write_reg(self.main.REG_USERIO_PWDRIVEN, [raw])


class trigger(util.DisableNewAttr):
    ''' Trigger-related settings.
    '''
    _name = 'PhyWhisperer trigger settings'

    def __init__(self, main):
        super().__init__()
        self.main = main
        self.disable_newattr()

    def _dict_repr(self):
        rtn = OrderedDict()
        rtn['enable']               = self.enable
        rtn['num_triggers']         = self.num_triggers
        rtn['delays']               = self.delays
        rtn['widths']               = self.widths
        rtn['clock_phase']          = self.clock_phase
        rtn['num_pm_triggers']      = self.num_pm_triggers
        rtn['num_pm_triggers_seen'] = self.num_pm_triggers_seen
        return rtn

    def __repr__(self):
        return util.dict_to_str(self._dict_repr())

    def __str__(self):
        return self.__repr__()

    @property
    def clock_phase(self):
        """Wrapper for trigger_clock_phase_shift().
        """
        return self.main._trigger_clock_phase_shift

    @clock_phase.setter
    def clock_phase(self, phase):
        self.main.trigger_clock_phase_shift(phase)

    @property
    def enable(self):
        """Whether trigger output pins (Trig Out MCX and IO4) are driven when a
        pattern match occurs. Can also be set via set_trigger_sequence().
        """
        if self.main.read_reg(self.main.REG_TRIGGER_ENABLE, 1)[0]:
            return True
        else:
            return False

    @enable.setter
    def enable(self, val):
        if val:
            self.main.write_reg(self.main.REG_TRIGGER_ENABLE, [1])
        else:
            self.main.write_reg(self.main.REG_TRIGGER_ENABLE, [0])

    @property
    def num_triggers(self):
        """Number of output trigger pulses to generate when a pattern match
        occurs (maximum 8). Can also be set via set_trigger_sequence().
        """
        return self.main.read_reg(self.main.REG_NUM_TRIGGERS, 1)[0]

    @num_triggers.setter
    def num_triggers(self, val):
        if val > 8:
            raise ValueError('Maximum 8 trigger pulses.')
        self.main.write_reg(self.main.REG_NUM_TRIGGERS, [val])

    @property
    def delays(self):
        """Delays between the output trigger pulses that are generated when a
        pattern match occurs. Can also be set via set_trigger_sequence(). Unlike
        set_trigger_sequence(), this property does *not* adjust capture_delay.
        """
        return self._get_delays()

    @delays.setter
    def delays(self, val):
        self._set_delays(val)

    def _get_delays(self):
        """Whether the specified USERIO pin is I/O.
        """
        delays = self._read_delays()
        if type(delays) is int:
            return delays
        else:
            return util.Lister(delays, setter=self._set_delays, getter=self._read_delays)

    def _read_delays(self):
        raw = self.main.read_reg(self.main.REG_TRIGGER_DELAY, 3*8)
        delays = []
        for i in range(8):
            delays.append(int.from_bytes(raw[i*3:i*3+3], byteorder='little'))
        return delays

    def _set_delays(self, delays):
        if len(delays) > 8:
            raise ValueError("Too many elements")
        num = len(delays)
        data = 0
        for i in range(num):
            delay = delays[i]
            if delay == 0 and i > self.num_triggers - 1:
                pass
            elif (delay >= 2**20) or (delay < 0) or (delay < 1 and i > 0):
                raise ValueError('Illegal delay value (%d) for index %d' % (delay, i))
            data += delay << i*24
        self.main.write_reg(self.main.REG_TRIGGER_DELAY, int.to_bytes(data, length=3*num, byteorder='little'))


    @property
    def widths(self):
        """Widths of the output trigger pulses that are generated when a
        pattern match occurs. Can also be set via set_trigger_sequence().
        """
        return self._get_widths()

    @widths.setter
    def widths(self, val):
        self._set_widths(val)

    def _get_widths(self):
        """Whether the specified USERIO pin is I/O.
        """
        widths = self._read_widths()
        if type(widths) is int:
            return widths
        else:
            return util.Lister(widths, setter=self._set_widths, getter=self._read_widths)

    def _read_widths(self):
        raw = self.main.read_reg(self.main.REG_TRIGGER_WIDTH, 3*8)
        widths = []
        for i in range(8):
            widths.append(int.from_bytes(raw[i*3:i*3+3], byteorder='little'))
        return widths

    def _set_widths(self, widths):
        if len(widths) > 8:
            raise ValueError("Too many elements")
        num = len(widths)
        data = 0
        for i in range(num):
            width = widths[i]
            if width == 0 and i > self.num_triggers - 1:
                pass
            elif (width >= 2**17) or (width < 1):
                raise ValueError('Illegal width value (%d) for index %d' % (width, i))
            data += width << i*24
        self.main.write_reg(self.main.REG_TRIGGER_WIDTH, int.to_bytes(data, length=3*num, byteorder='little'))

    @property 
    def num_pm_triggers(self):
        """ Maximum number of pattern match triggers to generate. Defaults to
        1. Each pattern match triggers sets off a sequence of output triggers
        as specified by set_trigger_sequence().  This property allows triggers
        to be generated for multiple pattern match events without having to be
        re-armed. Can also be accessed via the num_pm_triggers property.

        Args:
            num (int): number of triggers; maximum 2**16-2, or set to -1 to
                generate an infinite number of triggers (until disarmed).
        """
        return self.main._num_pm_triggers

    @num_pm_triggers.setter 
    def num_pm_triggers(self, value):
        self.main.set_num_pm_triggers(value)

    @property 
    def num_pm_triggers_seen(self):
        """ Number of pattern match triggers generated. Resets upon arming.
        """
        return self.main.get_num_pm_triggers_seen()



class pattern(util.DisableNewAttr):
    ''' Pattern-related settings (read-only).
    '''
    _name = 'PhyWhisperer pattern settings'

    def __init__(self, main):
        super().__init__()
        self.main = main
        self.disable_newattr()

    def _dict_repr(self):
        rtn = OrderedDict()
        rtn['num_bytes'] = self.num_bytes
        rtn['pattern'] = self.pattern
        rtn['mask'] = self.mask
        return rtn

    def __repr__(self):
        return util.dict_to_str(self._dict_repr())

    def __str__(self):
        return self.__repr__()

    @property
    def num_bytes(self):
        """Number of bytes used for pattern matching. Read-only property; set via set_pattern().
        """
        return self.main.read_reg(self.main.REG_PATTERN_BYTES, 1)[0]

    @num_bytes.setter
    def num_bytes(self, phase):
        pw_logger.error("Can't set here, use set_pattern() instead.")


    @property
    def pattern(self):
        """Pattern used for pattern matching. Read-only property; set via set_pattern().
        """
        if self.num_bytes:
            return self.main.read_reg(self.main.REG_PATTERN, self.num_bytes)[::-1]
        else:
            return None

    @pattern.setter
    def pattern(self, phase):
        pw_logger.error("Can't set here, use set_pattern() instead.")


    @property
    def mask(self):
        """Mask used for pattern matching. Read-only property; set via set_pattern().
        """
        if self.num_bytes:
            return self.main.read_reg(self.main.REG_PATTERN_MASK, self.num_bytes)[::-1]
        else:
            return None

    @mask.setter
    def mask(self, phase):
        pw_logger.error("Can't set here, use set_pattern() instead.")




