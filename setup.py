#!/usr/bin/env python

from setuptools import setup, find_packages

setup(
    name='phywhisperer',
    version='0.1.0',
    description="PhyWhisperer USB Hardware Trigger",
    long_description=open('README.md').read(),
    long_description_content_type='text/markdown',
    author="NewAE Technology Inc.",
    author_email='coflynn@newae.com',
    license='GPLv3',
    url='http://www.PhyWhisperer.com',
    packages=find_packages('software'),
    package_dir={'': 'software'},
    package_data={'': ['firmware/defines_usb.v', 'firmware/defines_pw.v']},
    install_requires=[
        'pyserial',
        'crcmod',
        'pyusb',
    ],
    project_urls={
        'Documentation': 'https://phywhispererusb.readthedocs.io',
        'Source': 'https://github.com/newaetech/phywhispererusb',
        'Issue Tracker': 'https://github.com/newaetech/phywhispererusb/issues',
    },
    python_requires='>3.4',
)
