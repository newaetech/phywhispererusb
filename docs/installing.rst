.. _installing:

#############
Installation
#############

Before installing, grab prerequisites for your platform:


 * :ref:`GNU/Linux <prerequisites-linux>`
 * :ref:`Windows <prerequisites-windows>`
 * :ref:`Mac <prerequisites-mac>`

Then install:

 * :ref:`Installation <install_phywhisperer>`

*************
Prerequisites
*************

.. _prerequisites-linux:

=========
GNU/Linux
=========

Python
======

On Linux installing Python and the the associated package is straightforward.
Typically, you can install them from the package manager (ie. apt-get,
yum, ...).

On Ubuntu or similar:

.. code:: bash

    sudo apt install python3 python3-pip

Git
===

If you want the newest PhyWhisperer updates before they make it to release,
grab git as well:

.. code:: bash
    
    sudo apt install git


Packages
========

There are some packages required for **phywhisperer** and its dependencies such
as **pyusb** to work. Install using:

.. code:: bash

    sudo apt install libusb-dev make


Hardware Drivers
================

The driver for Linux is built in; however, you need to allow your user account
to access the peripheral.  

If you have a recent ChipWhisperer installation, you don't need to do anything
-- the hardware driver installation steps you would have done there cover
PhyWhisperer as well.

Otherwise, after you've `installed PhyWhisperer <#_install_phywhisperer>`_,
follow the instructions in `drivers/99-newae.rules <https://github.com/newaetech/phywhispererusb/blob/master/drivers/99-newae.rules>`_.


.. _prerequisites-windows:

==============
Windows Manual
==============

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

Git
===

If you want the newest PhyWhisperer updates before they make it to release,
grab git as well: https://git-scm.com/download/win


Installing Hardware Drivers
===========================

On firmware >= 1.1, drivers will be installed automatically upon plugging in
your PhyWhisperer to Windows 8 or newer. Otherwise, drivers can be downloaded as a .zip file for Windows. To install them:

1. Unzip the zip-file somewhere. Also remember where.
2. Open your Device Manager.
3. Find the device in the list, it should appear with a yellow exclamation mark under "Other devices".
4. Double-click on the device.
5. Hit "Update Driver"
6. Select "Browse my computer for driver software".
7. Point the wizard to the folder you unzipped, ensure the "look in subfolders" option is selected.

.. _releases: https://github.com/newaetech/phywhispererusb/tree/master/drivers

.. _prerequisites-mac:

========
Mac OS X
========

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

MacOS's default outdated Python usually interferes with the desired
Python version (Python 3.6 or newer required and 3.7.x recommended).
As such, we recommend using pyenv to install Python.

You can get pyenv via brew:

.. code:: bash

    brew install pyenv

From there you can use pyenv to install the desired Python version (3.7.3 in this case):

.. code:: bash

    pyenv install 3.7.3
    pyenv global 3.7.3

In addition, you'll want to add the following lines to your shell's startup file 
(usually .bashrc or .zshrc) to ensure that pyenv sets your shell's path correctly
at startup:

.. code:: bash

    if command -v pyenv 1>/dev/null 2>&1; then
        eval "$(pyenv init -)"
    fi


***********************
Installing PhyWhisperer
***********************

.. _install_phywhisperer:

You can either grab phywhisperer from pip, which installs the latest full release:

.. code:: bash

    pip install phywhisperer

Or, if you want the latest updates before they make it to a full release, install via git:

.. code:: bash

    git clone https://github.com/newaetech/phywhispererusb
    cd phywhispererusb
    python setup.py develop
