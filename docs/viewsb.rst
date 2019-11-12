.. _viewsb:

################
ViewSB Interface
################

The open-source ViewSB project at https://github.com/usb-tools/ViewSB can be used as a visual
front-end for PhyWhisperer. It currently works on Linux/Mac only, and could be started as such:

    viewsb.sh phywhisperer --pattern 45 --mask 255
    
You can specify other front-ends, including a prototype QT-based GUI:

    viewsb.sh phywhisperer --pattern 45 --mask 255 qt
    
