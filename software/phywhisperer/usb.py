import phywhisperer.interface.naeusb as NAE
import phywhisperer.interface.program_fpga as LLINT
import sys
import os
from phywhisperer.interface.bootloader_sam3u import Samba

class usb(object):
    """PhyWhisperer-USB Interface"""


    def con(self, PID=123, sn=None, program_fpga=True):
        """Connect to PhyWhisperer-USB. Raises error if multiple detected

        PID : int
              Product ID of PhyWhisperer
        sn : int
             Serial Number of PhyWhisperer, required when multiple PhyWhisperers are connected.
        program_fpga : bool
                       Specifies whether or not to program the FPGA with the default firmware when we connect
        """

        self.usb = NAE.NAEUSB()
        self.usb.con(idProduct=[0xC521], serial_number=sn)
        self._llint = LLINT.PhyWhispererUSB(self.usb)

        if program_fpga:
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
        if not os.path.isfile(bitfile):
            raise ValueError("Cannot find specified bitfile {}".format(bitfile))

        bitstream = open(bitfile, "rb")
        self._llint.FPGAProgram(bitstream)
        pass


    def erase_sam3u(self):
        self._llint.eraseFW(confirm=True)

    def program_sam3u(self, port, fw_path):
        if not os.path.isfile(fw_path):
            raise ValueError("Cannot find specified firmware file {}".format(fw_path))
        sam = Samba()
        print("Opening firmware...")
        fw_data = open(fw_path, "rb").read()
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
        pass

    def set_usb_mode_fs(self, use_fs):
        self.set_usb_mode_hs(False)

    def sniff_usb_traffic(self, bytes):
        pass
