# Copyright (c) 2019, NewAE Technology Inc
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

"""
PhyWhisperer services -- asynchronous objects that receive data from the device
"""

import collections
from enum import Enum


class IncompletePacket(IOError):
    """ Exception used if we attempt to parse a packet that's insufficiently long to parse. """
    pass


class InappropriatePacket(IOError):
    """ Exception used if we attempt to parse a packet that's not appropriate for our handler."""
    pass


class PWPacketDispatcher:
    """
    Mix-in for a class that receives packets and then delegates to subordinate packet handlers.
    """

    def __init__(self, verbose=False, short_name=''):
        """ Set up our PacketDispatcher. """

        self.verbose = verbose
        self.short_name = short_name

        # Create a new empty list to store packets
        self._buffer = []

        # And create a new list of packet handlers.
        self._packet_handlers = []
        

    def register_packet_handler(self, handler):
        """ Registers a new packet handler for the PW comms. """
        self._packet_handlers.append(handler)


    def handle_incoming_bytes(self, rawdata):
        """ Handles receipt of new bytes from an I/O channel, passes
        assembled packets to registered packet handlers.

        Args: 
            rawdata: data read from PhyWhisperer (list of lists)
        """

        incomplete = False

        if self.verbose and rawdata:
            for i in rawdata:
                hexdump = " ".join("{:02X}".format(j) for j in i)
                print("{}> {}".format(self.short_name, hexdump))

        # Add the rx'd bytes to our buffer.
        self._buffer.extend(rawdata)

        # Dispatch all of the bytes we have -- noting that we may have bytes for multiple packets.
        while self._buffer and not incomplete:
            bytes_handled = 0

            # Give each of our handlers the opportunity to parse the current data.
            for handler in self._packet_handlers:
                try:
                    # pass self to handler in order to have access to Verilog defines:
                    packet = handler.handle_bytes_received(self, self._buffer)
                    bytes_handled = packet['size']
                    handler.handle_packet(packet)
                except IncompletePacket:
                    incomplete = True
                    continue

                # Consume the relevant number of bytes read...
                if bytes_handled:
                    if self.verbose:
                        print(" ---- {} handled {} bytes; {} bytes remain".format(
                            type(handler).__name__, bytes_handled, len(self._buffer)))
                    break



class PWPacketHandler:
    """
    Class representing an asynchronous data transmission/receipt service.
    Typically each service handles a specific kind of packet from the PW device.
    """

    def __init__(self):
        """ Set up the a PW packet handler. 
        Args: none
        """
        self._timestep = 0
        self._packet_bytes = []
        self._packet_start_time = 0
        self._in_packet = False
        self._packet_size = 0
        self._firstpacket = True

        # expected flag values:
        self._rx_error_expected = 0
        self._sess_valid_expected = 1
        self._sess_end_expected = 0
        self._vbus_valid_expected = 1


    def handle_bytes_received(self, defines, data, verbose=False):
        """ Attempts to handle a set of bytes received from the PW.
        Args:
            defines: phywhisperer.usb.Usb object
            data: raw data captured from PhyWhisperer (list of lists),
                which is consumed as packets are assembled from it
        Returns:
            A single packet (dictionary) if there is a complete packet in
            the input data; otherwise IncompletePacket() is raised.
        """

        if len(data) < 1:
            raise IncompletePacket()

        while len(data):
            entry = data.pop(0)
            command = entry[2] & 0x3

            if (command == defines.FE_FIFO_CMD_TIME):
                ts = entry[0] + (entry[1] << 8)
                #Unlike stat and data commands, we don't add one here; if we did
                #we'd be overcounting in the common case where a time command immediately
                #preceeds a stat or data command. Consequence is that timestep will be off
                #by one in the case of lone time commands (which is rare, and inconsequential
                #in practice).
                self._timestep += ts

            elif (command == defines.FE_FIFO_CMD_STRM):
                # nothing to do or report
                pass

            elif (command == defines.FE_FIFO_CMD_DATA) or (command == defines.FE_FIFO_CMD_STAT):
                rx_active = (entry[0] & 8) >> 3
                rx_error = (entry[0] & 16) >> 4
                sess_valid = (entry[0] & 32) >> 5
                sess_end = (entry[0] & 64) >> 6
                vbus_valid = (entry[0] & 128) >> 7
                ts = entry[0] & 0x7
                self._timestep += ts
                if rx_active and not self._in_packet:
                    self._in_packet = True
                    self._packet_start_time = self._timestep
                    self._rx_error_event = 0
                    self._sess_valid_event = 0
                    self._sess_end_event = 0
                    self._vbus_valid_event = 0
                elif not rx_active and self._in_packet:
                    self._in_packet = False
                    if self._firstpacket and defines.addpattern:
                        self._firstpacket = False
                        self._packet_bytes[0:0] = defines.pattern
                        self._packet_size += len(defines.pattern)
                    if verbose:
                        print("%d-byte packet at time %d: " % (self._packet_size, self._packet_start_time), end = '')
                        for byte in self._packet_bytes:
                            print(hex(byte), end=' ')
                        print()

                    # build up observed flags field:
                    flags = 0
                    if self._rx_error_event:
                        flags += 0x1
                    if self._sess_valid_event:
                        flags += 0x2
                    if self._sess_end_event:
                        flags += 0x4
                    if self._vbus_valid_event:
                        flags += 0x8

                    # build packet:
                    packet = {"timestamp": self._packet_start_time,
                              "size": self._packet_size,
                              "contents": self._packet_bytes,
                              "flags": flags}

                    # reset for next packet:
                    self._packet_bytes = []
                    self._packet_size = 0
                    # Don't call handle_packet here, for non-ViewSB use of this method.
                    # Each call of handle_bytes_received is meant to handle 0 or 1 packets, so we're done:
                    return packet

                # status flags: for each flag, there is an expected value; if during the packet we observe
                # a flag isn't set to its expected value, that's what will get shown when the packet is
                # printed
                if rx_active and self._in_packet:
                    if self._rx_error_expected != rx_error:
                        self._rx_error_event = 1
                    if self._sess_valid_expected != sess_valid:
                        self._sess_valid_event = 1
                    if self._sess_end_expected != sess_end:
                        self._sess_end_event = 1
                    if self._vbus_valid_expected != vbus_valid:
                        self._vbus_valid_event = 1

                if (command == defines.FE_FIFO_CMD_DATA):
                    self._packet_bytes.append(entry[1])
                    self._packet_size += 1

            else:
                print ("ERROR: unknown command (%d)" % command) 

        # if we get here, packet in buffer isn't complete yet:
        raise IncompletePacket()


