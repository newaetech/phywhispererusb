****************
PhyWhisperer-USB
****************

Welcome to the documentation for the PhyWhisperer-USB: Canada's best open-source
USB 2.0 hardware inspection tool driven exclusively by Python. The PhyWhisperer-USB
is designed to allow you to perform complex triggering operations based on
physical-layer USB 2.0 traffic.

After :ref:`installing <installing>` PhyWhisperer-USB and setting up your
hardware, you could perform a simple sniffing of USB descriptors being
read with the following:

.. code:: python


    >>> import phywhisperer.usb as pw
    >>> phy = pw.Usb()
    >>> phy.con()
    >>> phy.addpattern = True #Adds captured data back, otherwise we capture 'after'
    >>> phy.set_power_source("off")
    >>> phy.reset_fpga()
    >>> phy.set_pattern([0x2d, 0x00])
    >>> phy.arm()
    >>> phy.set_power_source("host")
    #wait a second for device enumeration, 'capturing' LED goes out
    >>> raw = phy.read_capture_data()
    WARNING:root:Capture FIFO overflow. Capture stopped when overflow detected.
    >>> packets = phy.split_packets(raw)
    >>> printPackets = pw.USBSimplePrintSink(highspeed=phy.get_usb_mode() == 'HS')
    >>> for packet in packets:
    ...    printPackets.handle_usb_packet(ts=packet['timestamp'], buf=bytearray(packet['contents']), flags=0)
    ...
    [        ]   0.000000 d=  0.000000 [   .0 +  0.017] [  3] SETUP: 0.0
    [        ]   0.000000 d=  0.000000 [   .0 +  0.300] [ 11] DATA0: 80 06 00 01 00 00 40 00 dd 94
    [        ]   0.000001 d=  0.000001 [   .0 +  0.817] [  1] ACK
    [        ]   0.000005 d=  0.000004 [   .0 +  4.833] [  3] IN   : 0.0
    [        ]   0.000005 d=  0.000000 [   .0 +  5.250] [  1] NAK
    [        ]   0.000025 d=  0.000020 [   .0 + 25.333] [  3] IN   : 0.0
    [        ]   0.000026 d=  0.000000 [   .0 + 25.750] [  1] NAK
    [        ]   0.000046 d=  0.000021 [   .0 + 46.317] [  3] IN   : 0.0
    [        ]   0.000047 d=  0.000000 [   .0 + 46.733] [  1] NAK
    [        ]   0.000067 d=  0.000021 [   .0 + 67.317] [  3] IN   : 0.0
    [        ]   0.000068 d=  0.000000 [   .0 + 67.733] [  1] NAK
    [        ]   0.000088 d=  0.000021 [249   +  0.467] [  3] IN   : 0.0
    [        ]   0.000089 d=  0.000000 [249   +  0.867] [  1] NAK

This example does a full sniffing via the Python command line. With this versatile
interface you can interface between other tools, as well as toggling the power of
the device and triggering on specific byte patterns.

You can modify the FPGA to add new features, and script triggers with high-resolution
(~4.167nS step, plus some fine phase shift) offsets from packets being seen "on the wire".
This triggering makes it easy to use tools such as ChipWhisperer and ChipSHOUTER with USB
traffic.

If you only want to use the sniffing capability, you can also use the open-source
ViewSB software started by Kate Temkin https://github.com/usb-tools/ViewSB. See the
page :ref:`ViewSB <viewsb>` for more details.

Documentation
=============

.. toctree::
    :maxdepth: 2

    getting-started
    installing
    viewsb
    api
