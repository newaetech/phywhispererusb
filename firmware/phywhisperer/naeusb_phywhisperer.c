#include "naeusb_phywhisperer.h"
extern uint8_t USB_PWR_STATE;

void ctrl_change_pwr(void) {
    switch (udd_g_ctrlreq.req.wValue) {
    case 0x00: //USB power off
        PIOA->PIO_CODR = (1 << F_VBHOST); //disable sniff power
        PIOA->PIO_CODR = (1 << F_VB5V); //disable host power
        USB_PWR_STATE = 0;
        break;
    case 0x01: //Use 5V power
        PIOA->PIO_CODR = (1 << F_VBHOST); //disable sniff power
        PIOA->PIO_SODR = (1 << F_VB5V); //enable host power
        USB_PWR_STATE = 1;
        break;
    case 0x02: //Use host power
        PIOA->PIO_CODR = (1 << F_VB5V); //disable host power
        PIOA->PIO_SODR = (1 << F_VBHOST); //enable sniff power
        USB_PWR_STATE = 2;
        break;
    }

}

void ctrl_fpga_reset (void) {
    gpio_set_pin_high(PIN_EBI_USB_SPARE0);
    gpio_set_pin_low(PIN_EBI_USB_SPARE0);
}

bool phywhisperer_setup_out_received(void) {
    switch (udd_g_ctrlreq.req.bRequest) {
    case REQ_CHANGE_PWR:
        //TODO
        udd_g_ctrlreq.callback = ctrl_change_pwr;
        return true;

    case REQ_FPGA_RESET:
        udd_g_ctrlreq.callback = ctrl_fpga_reset;
        return true;

    default:
        return false;
    }
    return false;
}

bool phywhisperer_setup_in_received(void)
{
    switch (udd_g_ctrlreq.req.bRequest) {

    default:
        return false;
    }
    return false;
}

void phywhisperer_register_handlers(void)
{
    naeusb_add_in_handler(phywhisperer_setup_in_received);
    naeusb_add_out_handler(phywhisperer_setup_out_received);
}