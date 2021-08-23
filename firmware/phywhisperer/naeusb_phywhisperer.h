#pragma once
#include "naeusb/naeusb.h"
#include "naeusb/naeusb_openadc.h"
#define REQ_CHANGE_PWR 0x24
#define REQ_FPGA_RESET 0x25

void phywhisperer_register_handlers(void);