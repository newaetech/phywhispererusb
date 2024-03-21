# Driver Installation #

## Linux ##
If you have already installed ChipWhisperer and followed its driver instruction
installation instructions, you don't need to do anything else!


Otherwise, follow the instructions in [`99-newae.rules`](99-newae.rules):
- Unplug all NewAE hardware
- Copy [`99-newae.rules`](99-newae.rules) to `/etc/udev/rules.d/`
- Add your username to the chipwhisperer group:
    ```
    $ sudo usermod -aG chipwhisperer $USER
    ```
- Reset the udev system:
    ```
    $ sudo udevadm control --reload-rules
    ```
- Log in/out again for changes to take effect
- Connect hardware

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

