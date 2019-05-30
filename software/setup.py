#!/usr/bin/env python

from setuptools import setup

setup(
    name = 'phywhisperer',
    version = '0.0.1',
    description = "PhyWhisperer USB Hardware Trigger",
    author = "Colin O'Flynn",
    author_email = 'coflynn@newae.com',
    license = 'GPLv3',
    url = 'http://www.PhyWhisperer.com',
    download_url='',
    packages = ['phywhisperer',
                'phywhisperer.interface',
                'phywhisperer.firmware'
                ],
    install_requires = [

        # pyusb could be removed from required list, but for most people it's needed
        # and it's not "too" bad (i.e., won't hurt on a cloud platform I think)
        'pyusb',
    ],
    scripts=[
    ],
)
