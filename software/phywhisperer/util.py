# Copyright (c) 2024, NewAE Technology Inc
# All rights reserved.
#
#
# Find this and more at newae.com - this file is part of the PhyWhisperer-USB
# project, https://github.com/newaetech/phywhispererusb
#
#    This file is part of PhyWhisperer-USB.
#
#    PhyWhisperer-USB is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    PhyWhisperer-USB is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Lesser General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with PhyWhisperer-USB.  If not, see <http://www.gnu.org/licenses/>.
#=================================================

from typing import List
from .logging import *

class DisableNewAttr(object):
    """Provides an ability to disable setting new attributes in a class, useful to prevent typos.

    Usage:
    1. Make a class that inherits this class:
    >>> class MyClass(DisableNewAttr):
    >>>     # Your class definition here

    2. After setting up all attributes that your object needs, call disable_newattr():
    >>>     def __init__(self):
    >>>         self.my_attr = 123
    >>>         self.disable_newattr()

    3. Subclasses raise an AttributeError when trying to make a new attribute:
    >>> obj = MyClass()
    >>> #obj.my_new_attr = 456   <-- Raises AttributeError
    """
    _new_attributes_disabled = False
    _new_attributes_disabled_strict = False
    _read_only_attrs : List[str] = []

    def __init__(self):
        self._read_only_attrs = []
        self.enable_newattr()

    def disable_newattr(self):
        self._new_attributes_disabled = True
        self._new_attributes_disabled_strict = False

    def enable_newattr(self):
        self._new_attributes_disabled = False
        self._new_attributes_disabled_strict = False

    def disable_strict_newattr(self):
        self._new_attributes_disabled = True
        self._new_attributes_disabled_strict = True

    def add_read_only(self, name):
        if isinstance(name, list):
            for a in name:
                self.add_read_only(a)
            return
        if name in self._read_only_attrs:
            return
        self._read_only_attrs.append(name)

    def remove_read_only(self, name):
        if isinstance(name, list):
            for a in name:
                self.remove_read_only(a)
                return
        if name in self._read_only_attrs:
            self._read_only_attrs.remove(name)

    def __setattr__(self, name, value):
        if hasattr(self, '_new_attributes_disabled') and self._new_attributes_disabled and not hasattr(self, name):  # would this create a new attribute?
            #raise AttributeError("Attempt to set unknown attribute in %s"%self.__class__, name)
            other_logger.error("Setting unknown attribute {} in {}".format(name, self.__class__))
            if hasattr(self, '_new_attributes_disabled_strict') and self._new_attributes_disabled_strict and not hasattr(self, name):
                raise AttributeError("Attempt to set unknown attribute in %s"%self.__class__, name)
        if name in self._read_only_attrs:
            raise AttributeError("Attribute {} is read-only!".format(name))
        super(DisableNewAttr, self).__setattr__(name, value)


class Lister(list):
    """Class that behaves like a list, but can set individual elements using a getter/setter.
    """
    def __setitem__(self, *args, **kwargs):
        oldval = self._getter()
        oldval[args[0]] = args[1]
        self._setter(oldval)
        pass

    def __repr__(self):
        oldrepr = super().__repr__()
        return f"Lister({oldrepr})"

    def __init__(self, *args, **kwargs):
        if "getter" not in kwargs:
            raise KeyError("Lister requires a getter")
        if "setter" not in kwargs:
            raise KeyError("Lister requires a setter")
        
        self._getter = kwargs.pop("getter")
        self._setter = kwargs.pop("setter")
        super().__init__(*args, **kwargs)


def dict_to_str(input_dict, indent=""):
    """Turn a dictionary of attributes/status values into a pretty-printed
    string for use on the command line. Recursively pretty-prints dictionaries.

    This function is most useful with OrderedDicts as it keeps the same
    printing order.
    """

    # Find minimum width that fits all names
    min_width = 0
    for n in input_dict:
        min_width = max(min_width, len(str(n)))

    # Build string
    ret = ""
    for n in input_dict:
        if isinstance(input_dict[n], dict):
            ret += indent + str(n) + ' = '
            ret += '\n' + dict_to_str(input_dict[n], indent+"    ")
        else:
            ret += indent + str(n).ljust(min_width) + ' = '
            ret += str(input_dict[n]) + '\n'

    return ret

