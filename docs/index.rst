****************
PhyWhisperer-USB
****************

Welcome to the documentation for the PhyWhisperer-USB: Canada's best open-source
USB 2.0 hardware inspection tool. The PhyWhisperer-USB is designed to allow
you to perform complex triggering operations based on physical-layer USB 2.0
traffic.

After :ref:`installing <install>` PhyWhisperer-USB and setting up your
`hardware`_, you could perform a simple sniffing of USB descriptors being
read with the following:

.. code:: python


    >>> import phywhisperer.usb as pw
    >>> phy = pw.Usb()
    >>> phy.con()
    >>> phy.set_power_source("off")
    >>> phy.reset_fpga()
    >>> phy.set_usb_mode('HS')
    >>> phy.set_pattern([0x2d, 0x00])
    >>> phy.arm()
    >>> phy.set_power_source("host")
    #wait a second or two for device to enumerate
    >>> raw = phy.read_capture_data()
    >>> packets = phy.split_packets(raw)
    >>>printPackets = pw.USBSimplePrintSink(highspeed=phy.get_usb_mode() == 'HS')
    >>>for packet in packets:
    ...   printPackets.handle_usb_packet(ts=packet['timestamp'], buf=bytearray(packet['contents']), flags=0)
    
    ...

This example does a full sniffing via the Python command line. With this versatile
interface you can interface between other tools, as well as toggling the power of
the device and triggering on specific byte patterns.

You now have access to an object-oriented interface to configure the attached
hardware. To see what is possible with this interface check out the
:ref:`scope section <api-scope>` of the API documentation.

If you only want to use the sniffing capability, you can also use the open-source
ViewSB software started by Kate Temkin https://github.com/usb-tools/ViewSB. See the
page :ref:`ViewSB <viewsb>`

Documentation
=============

.. toctree::
    :maxdepth: 2

    getting-started
    installing
    viewsb
    api


Additional Information
======================

Here is more information about changes, and contribution.

.. toctree::
    :maxdepth: 2
    :glob:

    Change Log <changes.rst>