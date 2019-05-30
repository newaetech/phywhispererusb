
class usb(object):
    """PhyWhisperer-USB Interface"""
    
    
    def con(self, PID=123, sn=None, program_fpga=True)
        """Connect to PhyWhisperer-USB. Raises error if multiple detected"""
        pass
        
        
    def set_power_source(self, src):
    
        if src == "host":
            pass
        elif src == "sniff"
            pass
        elif src == "off" or src is None or src == False:
            pass
        else
            raise AttributeError("Unknown source %s, valid sources: 'host', 'sniff', 'off'")
            
            
            
    def load_bitstream(self, bitfile):
        pass
        
        
    def upgrade_sam3u(self, hexfile):
        pass
        
        
        
    def set_usb_mode_hs(self, use_hs):
        pass
        
    def set_usb_mode_fs(self, use_fs):
        self.set_usb_mode_hs(False)
        
    def sniff_usb_traffic(self, bytes):
        pass
