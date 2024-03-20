.. _api:

###
API
###

This is where the documentation for the public API functions, and classes lives.

Most properties are accessible via two APIs: a legacy API with function calls, and the newer property-based API.


PhyWhisperer-USB Main Interface
===============================

.. autoclass:: phywhisperer.usb.Usb
    :members:



phy.pattern
-----------

Class to inspect pattern settings.

.. autoclass:: phywhisperer.usb.pattern
    :members:



phy.trigger
-----------

Class to access trigger settings.

.. autoclass:: phywhisperer.usb.trigger
    :members:



phy.userio
----------

Class to access USERIO settings.

.. autoclass:: phywhisperer.usb.userio
    :members:


Firmware Update
===============

Use `auto_program()`:

    >>> import phywhisperer.usb as pw
    >>> phy = pw.Usb()
    >>> phy.con()
    >>> phy.auto_program()
    Detected com port /dev/ttyACM0
    Opening firmware...
    Firmware not specified. Using firmware/phywhisperer.py
    Opened!
    Connecting...
    Connected!
    Erasing...
    Erased!
    Programming file None...
    Programmed!
    Verifying...
    Verify OK!
    Bootloader disabled. Please power cycle device.

