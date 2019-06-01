import phywhisperer.interface.naeusb as NAE
import phywhisperer.interface.program_fpga as LLINT
import sys
import os
from phywhisperer.interface.bootloader_sam3u import Samba
from zipfile import ZipFile

#include once implemented
# from phywhisperer.firmware.phywhisperer import getsome

class Usb(object):
    """PhyWhisperer-USB Interface"""


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


    def set_usb_mode_hs(self, use_hs):
        """Set USB PHY to High-Speed Mode"""
        pass

    def set_usb_mode_fs(self, use_fs):
        """Set USB PHY to Full-Speed Mode"""
        self.set_usb_mode_hs(False)

    def sniff_usb_traffic(self, bytes):
        """Set USB Sniffer Mode"""
        pass
