.. _viewsb:

################
ViewSB Interface
################

The open-source ViewSB project at https://github.com/usb-tools/ViewSB can be used as a visual
front-end for PhyWhisperer. It currently works on Linux/Mac only, and could be started as such::

    viewsb.sh phywhisperer 
    
By default it starts capturing right away and fills its entire 8188-entry FIFO.
You can specify a pattern and mask to kick off the capture, as well as the capture size; for
example, to begin capturing 4000 events when [0x2d, 0x00] is seen::

    viewsb.sh phywhisperer --pattern 45 0 --mask 255 255 --size 4000

By default, incoming data is captured and processed concurrently. This allows for longer
captures. Setting size to 0 gives an unlimited capture -- until the PhyWhisperer's internal FIFO
overflows, or the capture times out (default of 5 seconds), whichever comes first.

The phywhisperer backend supports a few other options:

    - timeout: Capture timeout in seconds (0 = no timeout). Defaults to 5 seconds.
    - addpattern: If set, the capture pattern is inserted in the captured data. Otherwise,
        the captured data begins with what was seen after the pattern. Defaults off.
    - burst: wait for capture to be complete before reading the captured data
        (i.e. don't capture and process concurrently). With this option, captures
        are limited to a maximum of 8188. Defaults off.

Note that for high-speed targets, you may be able to capture considerably more data when not
using ViewSB, due to the additional overhead that ViewSB incurs.

As with all other ViewSB backends, you can specify a variety of front-ends,
including a prototype QT-based GUI::

    viewsb.sh phywhisperer qt --pattern 45 --mask 255
    
