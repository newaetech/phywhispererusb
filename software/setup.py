#!/usr/bin/env python

from setuptools import setup

setup(
    name = 'phywhisperer',
    version = '0.1.0',
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
    include_package_data=True,
    install_requires = [
        'crcmod',
        'pyusb',
    ],
    scripts=[
    ],
)
