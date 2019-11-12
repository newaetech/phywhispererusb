# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# http://www.sphinx-doc.org/en/master/config

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
import os
import sys
from glob import glob
import shutil
import re
from pathlib import Path
sys.path.insert(0, os.path.abspath('./../software'))


# -- Project information -----------------------------------------------------

project = 'PhyWhisperer-USB'
copyright = "2019, NewAE Technology Inc."
author = "NewAE Technology Inc."

# The full version, including alpha/beta/rc tags
release = '0.1.0'


# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
	'sphinx.ext.napoleon',
	'sphinx.ext.autodoc',
	'sphinx.ext.todo',
]

# explicitly set the master document to index.rst
master_doc = 'index'

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']


# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = 'alabaster'

html_theme_options = {
    'description': 'USB Triggering Device.',
    'fixed_sidebar': 'true',
    'logo': 'logo.png',
    'logo_name': 'true',
    'github_user': 'newaetech',
    'github_repo': 'phywhisperer',
    'github_banner': 'true',
    'github_button': 'true',
    'github_type': 'watch',
    'extra_nav_links': {
        'Our Source Code': 'https://github.com/newaetech/phywhisperer',
    },
    'sidebar_width': '265px',
    'page_width': '1000px',
}

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']

# configuration for todo extension
todo_include_todos = True

# remove module names
add_module_names = False

# side bar customization
html_sidebars = {
    'index': ['about.html', 'navigation.html', 'searchbox.html'],
    '**': ['about_short.html', 'localtoc.html', 'searchbox.html']
}

