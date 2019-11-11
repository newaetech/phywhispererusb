# Driver Installation #

## Linux ##

 - Make a file called /etc/udev/rules.d/99-newae.rules . The contents of this file should be (this adds all NewAE Hardware):
    ```
    #allow users to claim the device
	# CW-Nano
	SUBSYSTEM=="usb", ATTRS{idVendor}=="2b3e", ATTRS{idProduct}=="ace0", MODE="0664", GROUP="plugdev"
	
	# CW-Lite
	SUBSYSTEM=="usb", ATTRS{idVendor}=="2b3e", ATTRS{idProduct}=="ace2", MODE="0664", GROUP="plugdev"
	
	# CW-1200
	SUBSYSTEM=="usb", ATTRS{idVendor}=="2b3e", ATTRS{idProduct}=="ace3", MODE="0664", GROUP="plugdev"
	
	# CW-305 (Artix Target)
	SUBSYSTEM=="usb", ATTRS{idVendor}=="2b3e", ATTRS{idProduct}=="c305", MODE="0664", GROUP="plugdev"
	
	# PhyWhisperer
	SUBSYSTEM=="usb", ATTRS{idVendor}=="2b3e", ATTRS{idProduct}=="c610", MODE="0664", GROUP="plugdev"
	
	#Ballistic Gel
	SUBSYSTEM=="usb", ATTRS{idVendor}=="2b3e", ATTRS{idProduct}=="c521", MODE="0664", GROUP="plugdev"
	
	# CW-CR2
	SUBSYSTEM=="usb", ATTRS{idVendor}=="04b4", ATTRS{idProduct}=="8613", MODE="0664", GROUP="plugdev"
	SUBSYSTEM=="usb", ATTRS{idVendor}=="221a", ATTRS{idProduct}=="0100", MODE="0664", GROUP="plugdev"

    ```
 - Add your username to the plugdev group:
    ```
    $ sudo usermod -a -G plugdev YOUR-USERNAME
    ```
 - And reset the udev system:
    ```
    $ sudo udevadm control --reload-rules
    ```

 - Finally log out & in again for the group change to take effect.

 - Connect the USB cable of your device.


## Windows ##

The attached USB drivers should work on any Windows system, both 32 and 64-bit. They are signed by NewAE Technology Inc.

We only store the **zip-file** in GIT, so you'll need to unzip it. This is done to avoid issues with line-ending changing causing the signatures to be invalid.

To install them:
 1. Unzip the zip-file somewhere. Also remember where.
 1. Open your Device Manager.
 1. Find the device in the list, it should appear with a yellow exclamation mark under "Other devices".
 1. Double-click on the device.
 1. Hit "Update Driver"
 1. Select "Browse my computer for driver software".
 1. Point the wizard to the folder you unzipped, ensure the "look in subfolders" option is selected.

