.. _installing:

#############
Prerequisites
#############

 * :ref:`GNU/Linux <prerequisites-linux>`
 * :ref:`Windows <prerequisites-windows>`
 * :ref:`Mac <prerequisites-mac>`

.. _prerequisites-linux:

*********
GNU/Linux
*********

There is only manual install available on GNU/Linux.

Python
======

On Linux installing Python and the the associated package is straightforward.
Typically, you can install them from the package manager (ie. apt-get,
yum, ...).

On Ubuntu or similar:

.. code:: bash

    sudo apt install python3 python3-pip


Packages
========

There are some packages required for **phywhisperer** and its dependencies such
as **pyusb** to work. Install using:

.. code:: bash

    sudo apt install libusb-dev make


Hardware Drivers
================

The driver for Linux is built in; however, you need to allow your user account to access the peripheral. To do so, you'll have to make a file called :code:`/etc/udev/rules.d/99-newae.rules`. The contents of this file should be (this includes other NewAE
products, you only really need the PhyWhisperer line):

.. code::

    # CW-Lite
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2b3e", ATTRS{idProduct}=="ace2", MODE="0664", GROUP="plugdev"

    # CW-1200
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2b3e", ATTRS{idProduct}=="ace3", MODE="0664", GROUP="plugdev"

    # CW-Nano
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2b3e", ATTRS{idProduct}=="ace0", MODE="0664", GROUP="plugdev"

    # CW-305 (Artix Target)
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2b3e", ATTRS{idProduct}=="c305", MODE="0664", GROUP="plugdev"
    
    # PhyWhisperer
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2b3e", ATTRS{idProduct}=="c610", MODE="0664", GROUP="plugdev"

    # CW-CR2
    SUBSYSTEM=="usb", ATTRS{idVendor}=="04b4", ATTRS{idProduct}=="8613", MODE="0664", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="221a", ATTRS{idProduct}=="0100", MODE="0664", GROUP="plugdev"

Alternatively, you can just copy :code:`phywhispererusb/drivers/99-newae.rules`
to :code:`/etc/udev/rules.d/`.

Then add your username to the plugdev group:

.. code:: bash

    sudo usermod -a -G plugdev YOUR-USERNAME

And reset the udev system:

.. code:: bash

    sudo udevadm control --reload-rules

Finally log out & in again for the group change to take effect.

You can always find the latest version of this file on
`Github <https://raw.githubusercontent.com/newaetech/chipwhisperer/master/hardware/99-newae.rules>`_.


.. _prerequisites-windows:

**************
Windows Manual
**************


Python
======

The recommend method of installing Python is to use a distribution
called `WinPython`_. This setup avoids installing Python globally, and
includes most of the software you will need. In addition it makes it
possible to install 32-bit and 64-bit Python on the same system with
minimal problems. This can be very useful as the 64-bit version is
handy for doing analysis on large data sets.

To install WinPython 3.7.x, Download a release in the 3.7.x branch
from the WinPython site. ChipWhisperer works with both 32-bit and
64-bit versions of Python.

Choose a reasonable location to install this to - note the default is
simply in the download directory. Instead it's recommended to find a
directory such as */WinPython32bit-3.7.1.0*, or into your local
directory such as *c:/Users/yourname/WinPython32bit-3.7.1.0*.

Go to your installation directory for WinPython, and run the shortcut
called *WinPython Command Prompt.exe*. This will give you a command
prompt which is setup to run Python along with associated scripts.

Optional: You can add the python.exe you just installed to your PATH.
To do so navigate to your installation folder, and run the *WinPython
Control Panel.exe* program. Then select **Advanced** -> **Register**
distribution. If you do not do this, you will have to run all commands
in this document via the *WinPython Command Prompt.exe*. If you plan
on running both 32-bit and 64-bit Python, you should not register
them. Instead explicitly call the correct Python by always running the
*WinPython Command Prompt.exe*, and then calling specific scripts or
notebooks.

.. _WinPython: http://winpython.sourceforge.net/


Installing Hardware Drivers
===========================

Drivers can be downloaded as a .zip file for Windows. To install them:

1. Unzip the zip-file somewhere. Also remember where.
2. Open your Device Manager.
3. Find the device in the list, it should appear with a yellow exclamation mark under "Other devices".
4. Double-click on the device.
5. Hit "Update Driver"
6. Select "Browse my computer for driver software".
7. Point the wizard to the folder you unzipped, ensure the "look in subfolders" option is selected.

.. _releases: https://github.com/newaetech/phywhispererusb/tree/master/drivers


ChipWhisperer
=============

Remember that any time you install packages for python during the installation,
use the *WinPython Command Prompt.exe*.

.. _prerequisites-mac:

********
Mac OS X
********

The Mac OS X instructions are similar to the :ref:`GNU/Linux <prerequisites-linux>`
once you have **brew** installed.

Brew
====

Open your bash terminal and paste this into the prompt:

.. code:: bash

    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

This snippet is taken directly from `brew's website`_. The script will guide
you through the installation.

.. _brew's website: https://brew.sh/

Packages
========

**libusb** is required by the **chipwhisperer** software to communicate with
the board. You can install it using **brew**:

.. code:: bash

    brew install libusb


Python
======

You will require a python version >= to 3.5. You can get the binary from the
`Python Software Foundation's website`_. Choose one of the stable versions that
has an installer for your machine. You can also run this command in your terminal:

.. code:: bash

    brew install python3

You will have to check the version this downloads. It is best to have python 3.7.x


.. code:: bash

    python --version

If this installs a version lower than 3.5, just download and manually install the
Python interpreter from the `Python Software Foundation's website`_. If you
download and install the python interpreter manually from the website it should
be available on the bash terminal after installation as:

.. code:: bash

    python3.7

or the equivalent for your version.

Compilers
=========

The compilers are also available on Mac OSx. The ARM compiler can be found
on the `ARM website`_. If needed, the AVR compiler can be installed as well
using:

.. code:: bash

    brew tap osx-cross/avr
    brew install avr-gcc

This brew install does not work for some older versions of Mac OS X. You will
have to find a different way to install the compilers.

ChipWhisperer
=============

You are now ready for :ref:`installing <install-repo>` ChipWhisperer.

.. _Python Software Foundation's website: https://www.python.org/downloads/mac-osx/
.. _ARM website: https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads


