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

import logging
import os
import tempfile


log_dir =  tempfile.mkdtemp(prefix='phywhisperer')

logging.basicConfig(level=logging.WARNING)
cw_formatter = logging.Formatter("(%(name)s %(levelname)s|File %(filename)s:%(lineno)d) %(message)s")

other_logger = logging.getLogger("PhyWhisperer Other")
pw_logger = logging.getLogger("PhyWhisperer")

phywhisperer_loggers = [
    logging.getLogger("PhyWhisperer"),
    logging.getLogger("PhyWhisperer Other"),

]
for logger in phywhisperer_loggers:
    logger.setLevel(logging.WARNING)
    strmhndlr = logging.StreamHandler()
    strmhndlr.setLevel(logging.DEBUG)
    strmhndlr.setFormatter(cw_formatter)
   
    try:
        os.makedirs(os.path.join(log_dir, "phywhisperer/logs"), exist_ok=True)
    except FileExistsError:
        pass
    
    filehndlr = logging.FileHandler(os.path.join(log_dir, "phywhisperer/logs", logger.name + ".log"), mode='w')
    filehndlr.setFormatter(cw_formatter)
    logger.propagate = False

    logger.handlers = [strmhndlr, filehndlr]

def set_all_log_levels(level):
    for logger in phywhisperer_loggers:
        logger.handlers[0].setLevel(level)
