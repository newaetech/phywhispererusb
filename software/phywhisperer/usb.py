import phywhisperer.interface.naeusb as NAE
import phywhisperer.interface.program_fpga as LLINT
import sys
import os
import re
import logging
from phywhisperer.interface.bootloader_sam3u import Samba
from zipfile import ZipFile

#include once implemented
# from phywhisperer.firmware.phywhisperer import getsome

class Usb(object):
    """PhyWhisperer-USB Interface"""


    def __init__ (self):
        self.short_timestamps = [0] * 2**3
        self.long_timestamps = [0] * 2**16
        # parse Verilog defines file so we can access registers by name:
        self.registers = []
        self.matches = 0
        defines = open('../../hardware/fpga/hdl/defines.v', 'r')
        define_regex = re.compile(r'`define (\w+?)\s+?\d+?\'h([0-9a-fA-F]+)')
        for define in defines:
            match = define_regex.search(define)
            if match:
                self.matches += 1
                self.registers.append(dict(name=match.group(1), address=int(match.group(2),16)))
        defines.close()


    def con(self, PID=0xC521, sn=None, program_fpga=True):
        """Connect to PhyWhisperer-USB. Raises error if multiple detected

        PID : int
              Product ID of PhyWhisperer
        sn : int
             Serial Number of PhyWhisperer, required when multiple PhyWhisperers are connected.
        program_fpga : bool
                       Specifies whether or not to program the FPGA with the default firmware when we connect
        """

        self.usb = NAE.NAEUSB()
        self.usb.con(idProduct=[PID], serial_number=sn)
        self._llint = LLINT.PhyWhispererUSB(self.usb)

        if program_fpga:
            from phywhisperer.firmware.phywhisperer import getsome
            with ZipFile(getsome("phywhisperer-firmware.zip")) as myzip:
                with myzip.open('phywhisperer_top.bit') as bitstream:
                    self._llint.FPGAProgram(bitstream)
            pass
        pass


    def set_power_source(self, src):
        """Set power source for target.

        src : str
              "5V" for power from this computer
              "host" for power from the host of the connection we're sniffing
              "off" for USB power off
        """
        if src == "5V":
            self._llint.changePowerSource(self._llint.PWR_SRC_5V)
            pass
        elif src == "host":
            self._llint.changePowerSource(self._llint.PWR_SRC_HOST)
            pass
        elif src == "off" or src is None or src == False:
            self._llint.changePowerSource(self._llint.PWR_SRC_OFF)
            pass
        else:
            raise AttributeError("Unknown source %s, valid sources: '5V', 'host', 'off'")


    def reset_fpga(self):
        """ Pulse FPGA reset pin.
        """
        self._llint.resetFPGA()

    def load_bitstream(self, bitfile):
        """Load bitstream onto FPGA"""
        if not os.path.isfile(bitfile):
            raise ValueError("Cannot find specified bitfile {}".format(bitfile))

        bitstream = open(bitfile, "rb")
        self._llint.FPGAProgram(bitstream)
        pass


    def erase_sam3u(self):
        """Erase the SAM3U Firmware, which forces it into bootloader mode"""
        self._llint.eraseFW(confirm=True)

    def program_sam3u(self, port, fw_path=None):
        """Program the SAM3U Firmware assuming device is in bootloader mode"""
        fw_data = None
        print("Opening firmware...")

        if fw_path is None:
            print("Firmware not specified. Using firmware/phywhisperer.py")
            from phywhisperer.firmware.phywhisperer import getsome
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
        """Set USB PHY speed.
           mode: string
                 LS: manually set the PHY to low speed.
                 FS: manually set the PHY to full speed.
                 HS: manually set the PHY to high speed.
                 auto: Default. PW will attempt to automatically determine the
                       speed when the target is connected. Mode must be set to
                       'auto' prior to connecting the target, otherwise speed
                       cannot be determined correctly. Setting the mode to
                       'auto' actively causes PW to try to determine the speed.
        """
        if mode == 'auto':
           self.usb.cmdWriteMem(self.address('REG_USB_SPEED'), [0])
        elif mode == 'LS':
           self.usb.cmdWriteMem(self.address('REG_USB_SPEED'), [1])
        elif mode == 'FS':
           self.usb.cmdWriteMem(self.address('REG_USB_SPEED'), [2])
        elif mode == 'HS':
           self.usb.cmdWriteMem(self.address('REG_USB_SPEED'), [3])
        else:
           raise ValueError('Invalid mode %s; specify auto, LS, FS, or HS.' % mode)
        pass


    def get_usb_mode(self):
        """Returns USB PHY speed.
           A return value of 'auto' means that the speed has not been
           determined yet (was the mode set to 'auto' _before_ the target was
           connected or powered up?).
        """
        value = self.usb.cmdReadMem(self.address('REG_USB_SPEED'), 1)[0]
        if value == 0:
           return 'auto'
        elif value == 1:
           return 'LS'
        elif value == 2:
           return 'FS'
        elif value == 3:
           return 'HS'
        else:
           raise ValueError('Internal error: REG_USB_SPEED register contains invalid value %d.' % value)


    def sniff_usb_traffic(self, bytes):
        """Set USB Sniffer Mode"""
        pass


    def read_from_fifo(self, entries=1, verbose=False, single_burst=True):
        """Read from USB capture memory.
        entries: integer
                 values: 1 to 8192
        single_burst: True: read capture memory in a single burst (much faster).
                      False: read capture memory in 3-byte bursts (much slower).
        verbose: True or False
        """
        timestep = 0
        data_bytes = []
        data_times = []
        stat_bytes = []
        stat_times = []
        data_commands = 0
        stat_commands = 0
        time_commands = 0
        underflowed = False
        overflowed = False
        if single_burst:
            rawburst = self.usb.cmdReadMem(self.address('REG_SNIFF_FIFO_RD'), 4*entries)
        for i in range(entries):
            if single_burst:
                raw = rawburst[i*4:i*4+3]
            else:
                raw = self.usb.cmdReadMem(self.address('REG_SNIFF_FIFO_RD'), 3)
            command = raw[2] & 0x3
            if ((raw[2] & 8) >> 3) and not underflowed:
                logging.warning("Capture FIFO underflowed!")
                underflowed = True
            if ((raw[2] & 32) >> 5) and not overflowed:
                logging.warning("Capture FIFO overflow blocked!")
                overflowed = True
            if (command == 0): # data
                data = raw[1]
                ts = raw[0] & 0x7
                self.short_timestamps[ts] += 1
                #hardware reports the number of cycles between events, so to
                #obtain elapsed time we add one:
                timestep += (ts+1)
                flags = (raw[0] & 0xf8) >> 3
                if verbose:
                   print("%8d   flags=%02x data=%02x"%(timestep, flags, data))
                data_commands += 1
                data_bytes.append(data)
                data_times.append(timestep)
            elif (command == 1): # stat
                ts = raw[0] & 0x7
                self.short_timestamps[ts] += 1
                timestep += (ts+1)
                flags = (raw[0] & 0xf8) >> 3
                if verbose:
                   print("%8d   flags=%02x"%(timestep, flags))
                stat_commands += 1
                stat_bytes.append(flags)
                stat_times.append(timestep)
            elif (command == 2): # time
                ts = raw[0] + (raw[1] << 8)
                self.long_timestamps[ts] += 1
                #Unlike stat and data commands, we don't add one here; if we did
                #we'd be overcounting in the common case where a time command immediately
                #preceeds a stat or data command. Consequence is that timestep will be off
                #by one in the case of lone time commands (which is rare, and inconsequential
                #in practice).
                timestep += ts
                time_commands += 1
                if verbose:
                   print("%8d" % timestep)
            else:
                print ("ERROR: unknown command (%d)" % command) 
        return (data_times, data_bytes, stat_times, stat_bytes)


    def address(self, regname):
        """Get the address of an FPGA register, referenced by name as slurped from the FPGA defines file.
        """
        for register in self.registers:
            if register['name'] == regname:
                return register['address']
        raise ValueError('Cannot find a register named %s' % regname)


    def set_capture_size(self, size=8192):
        """Set how many events to capture (events include data, USB status, and timestamps).
        size: int
               range: [1, 8192]
        """
        if (size > 8192) or (size < 1):
            raise ValueError('Illegal size value.')
        size_bytes = [size & 255, (size >> 8) & 255]
        self.usb.cmdWriteMem(self.address('REG_CAPTURE_LEN'), size_bytes)


    def set_trigger(self, delay, width):
        """Program the output trigger delay and width. Both are measured in clock cycles of USB-derived 240 MHz clock.
        delay: int
               range: [0, 2^20-1]
        width: int
               range: [1, 2^17-1]
        """
        if (delay >= 2**20) or (delay < 0):
            raise ValueError('Illegal delay value.')
        if (width >= 2**17) or (width < 1):
            raise ValueError('Illegal width value.')
        delay_bytes = [delay & 255, (delay >> 8) & 255, (delay >> 16) & 255]
        width_bytes = [width & 255, (width >> 8) & 255, (width >> 16) & 255]
        self.usb.cmdWriteMem(self.address('REG_TRIGGER_DELAY'), delay_bytes)
        self.usb.cmdWriteMem(self.address('REG_TRIGGER_WIDTH'), width_bytes)


    def set_pattern(self, pattern, mask):
        """Set the pattern and its bitmask.
        pattern: list of between 1 and 64 bytes 
        mask: list of bytes, must have same size as 'pattern'
        """
        if len(pattern) != len(mask):
            raise ValueError('pattern and mask must be of same size.')
        elif len(pattern) > 64:
            raise ValueError('pattern and mask cannot be more than 64 bytes.')
        self.usb.cmdWriteMem(self.address('REG_PATTERN'), pattern)
        self.usb.cmdWriteMem(self.address('REG_PATTERN_MASK'), mask)
        self.usb.cmdWriteMem(self.address('REG_PATTERN_BYTES'), [len(pattern)])


    def arm(self, action):
        """Arm PhyWhisperer for capture or trigger.
        action: string
                values: 'capture', 'trigger', or 'NOP'
        """
        if action == 'capture':
           self.usb.cmdWriteMem(self.address('REG_PATTERN_ACTION'), [1])
        elif action == 'trigger':
           self.usb.cmdWriteMem(self.address('REG_PATTERN_ACTION'), [2])
        elif action == 'NOP':
           self.usb.cmdWriteMem(self.address('REG_PATTERN_ACTION'), [0])
        else:
            raise ValueError('Invalid action.')
        self.usb.cmdWriteMem(self.address('REG_ARM'), [1])


    def check_fifo_errors(self, underflow=0, overflow_blocked=0):
        """Check whether an underflow or overflow occured on the capture FIFO.
        (Overflows are blocked, underflows are not.)
        underflow: expected status, 0 or 1
        overflow_blocked: expected status, 0 or 1
        """
        status = self.usb.cmdReadMem(self.address('REG_SNIFF_FIFO_STAT'),1)[0]
        fifo_underflow = (status & 2) >> 1
        fifo_overflow_blocked = (status & 16) >> 4
        assert fifo_underflow == underflow
        assert fifo_overflow_blocked == overflow_blocked


