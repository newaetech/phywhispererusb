create_clock -period 16.000 -name fe_clk -waveform {0.000 8.000} [get_nets fe_clk]
create_clock -period 10.000 -name usb_clk -waveform {0.000 5.000} [get_nets usb_clk]
create_generated_clock -name trigger_clk [get_pins U_trigger_clock/inst/mmcm_adv_inst/CLKOUT0]

set_clock_groups -asynchronous \
                 -group [get_clocks usb_clk] \
                 -group [get_clocks trigger_clk]

set_clock_groups -asynchronous \
                 -group [get_clocks usb_clk] \
                 -group [get_clocks fe_clk]

set_clock_groups -asynchronous \
                 -group [get_clocks trigger_clk] \
                 -group [get_clocks fe_clk]

set_property BITSTREAM.CONFIG.USR_ACCESS TIMESTAMP [current_design]

set_property IOSTANDARD LVCMOS33 [get_ports *]

set_property PACKAGE_PIN A10 [get_ports {fe_data[1]}]
set_property PACKAGE_PIN A12 [get_ports fe_dppd]
set_property PACKAGE_PIN A13 [get_ports fe_rxerror]
set_property PACKAGE_PIN B10 [get_ports {fe_data[3]}]
set_property PACKAGE_PIN B11 [get_ports fe_sessvld]
set_property PACKAGE_PIN B13 [get_ports fe_vbusvld]
set_property PACKAGE_PIN B14 [get_ports fe_xcvrsel0]
set_property PACKAGE_PIN C10 [get_ports {fe_data[0]}]
set_property PACKAGE_PIN C11 [get_ports {fe_data[4]}]
set_property PACKAGE_PIN C12 [get_ports fe_dmpd]
set_property PACKAGE_PIN C14 [get_ports fe_termsel]
set_property PACKAGE_PIN D10 [get_ports {fe_data[2]}]
set_property PACKAGE_PIN D13 [get_ports fe_txrdy]
set_property PACKAGE_PIN D14 [get_ports fe_suspendn]
set_property PACKAGE_PIN E11 [get_ports {fe_data[5]}]
set_property PACKAGE_PIN E13 [get_ports fe_txvalid]
set_property PACKAGE_PIN F11 [get_ports {fe_data[6]}]
set_property PACKAGE_PIN F13 [get_ports fe_reset]
set_property PACKAGE_PIN F14 [get_ports fe_xcvrsel1]
set_property PACKAGE_PIN G14 [get_ports fe_chrgvbus]
set_property PACKAGE_PIN H13 [get_ports fe_clk]
set_property PACKAGE_PIN H14 [get_ports fe_rxactive]
set_property PACKAGE_PIN J12 [get_ports fe_dischrgvbus]
set_property PACKAGE_PIN J13 [get_ports fe_opmode1]
set_property PACKAGE_PIN J14 [get_ports fe_opmode0]
set_property PACKAGE_PIN K11 [get_ports {fe_data[7]}]
set_property PACKAGE_PIN K12 [get_ports fe_sessend]
set_property PACKAGE_PIN L12 [get_ports fe_hostdisc]
set_property PACKAGE_PIN L13 [get_ports fe_id_dig]
set_property PACKAGE_PIN L14 [get_ports fe_idpullup]
set_property PACKAGE_PIN M11 [get_ports fe_rxvalid]
set_property PACKAGE_PIN M14 [get_ports fe_linestate1]
set_property PACKAGE_PIN N14 [get_ports fe_linestate0]

set_property PACKAGE_PIN P13 [get_ports {userio_d[0]}]
set_property PACKAGE_PIN M12 [get_ports {userio_d[1]}]
set_property PACKAGE_PIN P12 [get_ports {userio_d[2]}]
set_property PACKAGE_PIN N11 [get_ports {userio_d[3]}]
set_property PACKAGE_PIN P11 [get_ports {userio_d[4]}]
set_property PACKAGE_PIN N10 [get_ports {userio_d[5]}]
set_property PACKAGE_PIN P10 [get_ports {userio_d[6]}]
set_property PACKAGE_PIN M10 [get_ports {userio_d[7]}]
set_property PACKAGE_PIN G11 [get_ports userio_clk]

set_property PACKAGE_PIN D1 [get_ports usb_clk]
set_property PACKAGE_PIN N4 [get_ports {USB_Data[7]}]
set_property PACKAGE_PIN P5 [get_ports {USB_Data[6]}]
set_property PACKAGE_PIN B5 [get_ports {USB_Data[5]}]
set_property PACKAGE_PIN J2 [get_ports {USB_Data[4]}]
set_property PACKAGE_PIN J1 [get_ports {USB_Data[3]}]
set_property PACKAGE_PIN H3 [get_ports {USB_Data[2]}]
set_property PACKAGE_PIN A5 [get_ports {USB_Data[1]}]
set_property PACKAGE_PIN B6 [get_ports {USB_Data[0]}]

# order as per schematic:
#set_property PACKAGE_PIN J3  [get_ports USB_Addr[7] ]
#set_property PACKAGE_PIN P4  [get_ports USB_Addr[6] ]
#set_property PACKAGE_PIN P3  [get_ports USB_Addr[5] ]
#set_property PACKAGE_PIN H2  [get_ports USB_Addr[4] ]
#set_property PACKAGE_PIN H1  [get_ports USB_Addr[3] ]
#set_property PACKAGE_PIN G1  [get_ports USB_Addr[2] ]
#set_property PACKAGE_PIN L2  [get_ports USB_Addr[1] ]
#set_property PACKAGE_PIN L1  [get_ports USB_Addr[0] ]

# corrected order:
set_property PACKAGE_PIN J3 [get_ports {USB_Addr[5]}]
set_property PACKAGE_PIN P4 [get_ports {USB_Addr[4]}]
set_property PACKAGE_PIN P3 [get_ports {USB_Addr[3]}]
set_property PACKAGE_PIN H2 [get_ports {USB_Addr[2]}]
set_property PACKAGE_PIN H1 [get_ports {USB_Addr[1]}]
set_property PACKAGE_PIN G1 [get_ports {USB_Addr[0]}]
set_property PACKAGE_PIN L1 [get_ports {USB_Addr[6]}]
set_property PACKAGE_PIN L2 [get_ports {USB_Addr[7]}]

set_property PACKAGE_PIN B3 [get_ports USB_nRD]
set_property PACKAGE_PIN B2 [get_ports USB_nWE]
set_property PACKAGE_PIN A3 [get_ports USB_nCS]

set_property PACKAGE_PIN K3 [get_ports USB_SPARE0]
set_property PACKAGE_PIN A4 [get_ports USB_SPARE1]

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

set_property PACKAGE_PIN P2 [get_ports cw_trig]
set_property PACKAGE_PIN B1 [get_ports cw_clk]

set_property PACKAGE_PIN M13 [get_ports mcx_trig]

set_property PACKAGE_PIN D2 [get_ports LED_TRIG]
set_property PACKAGE_PIN A2 [get_ports LED_CAP]

# Quasi-static output signals which don't need to be constrained.
# We do this to prevent 'no output delay' warnings in Vivado:
set_output_delay -clock fe_clk 0.0 [get_ports fe_xcvrsel1]
set_output_delay -clock fe_clk 0.0 [get_ports fe_xcvrsel0]
set_output_delay -clock fe_clk 0.0 [get_ports fe_termsel]
set_false_path -to [get_ports fe_xcvrsel1]
set_false_path -to [get_ports fe_xcvrsel0]
set_false_path -to [get_ports fe_termsel]

# Same for LEDs: they're not static but we don't care about timing 
# and don't want Vivado to warn or waste time/resources on them:
set_output_delay -clock fe_clk 0.0 [get_ports LED_TRIG]
set_output_delay -clock fe_clk 0.0 [get_ports LED_CAP]
set_false_path -to [get_ports LED_TRIG]
set_false_path -to [get_ports LED_CAP]

# FE input delays as per USB3500 spec:
set_input_delay -clock fe_clk -min 2.0 [get_ports fe_txrdy]
set_input_delay -clock fe_clk -min 2.0 [get_ports fe_rxactive]
set_input_delay -clock fe_clk -min 2.0 [get_ports fe_linestate0]
set_input_delay -clock fe_clk -min 2.0 [get_ports fe_linestate1]
set_input_delay -clock fe_clk -min 2.0 [get_ports fe_rxvalid]
set_input_delay -clock fe_clk -min 2.0 [get_ports fe_rxerror]
set_input_delay -clock fe_clk -min 2.0 [get_ports fe_data]
set_input_delay -clock fe_clk -max 5.0 -add_delay [get_ports fe_txrdy]
set_input_delay -clock fe_clk -max 5.0 -add_delay [get_ports fe_rxactive]
set_input_delay -clock fe_clk -max 5.0 -add_delay [get_ports fe_linestate0]
set_input_delay -clock fe_clk -max 5.0 -add_delay [get_ports fe_linestate1]
set_input_delay -clock fe_clk -max 5.0 -add_delay [get_ports fe_rxvalid]
set_input_delay -clock fe_clk -max 5.0 -add_delay [get_ports fe_rxerror]
set_input_delay -clock fe_clk -max 5.0 -add_delay [get_ports fe_data]

# There is no spec for these FE inputs:
set_input_delay -clock fe_clk 0.0 [get_ports fe_id_dig]
set_input_delay -clock fe_clk 0.0 [get_ports fe_hostdisc]
set_input_delay -clock fe_clk 0.0 [get_ports fe_sessend]
set_input_delay -clock fe_clk 0.0 [get_ports fe_sessvld]
set_input_delay -clock fe_clk 0.0 [get_ports fe_vbusvld]
set_false_path -from [get_ports fe_id_dig]
set_false_path -from [get_ports fe_hostdisc]
set_false_path -from [get_ports fe_sessend]
set_false_path -from [get_ports fe_sessvld]
set_false_path -from [get_ports fe_vbusvld]

# As per https://forums.xilinx.com/t5/Timing-Analysis/Is-a-false-path-constriaint-the-best-option-for-control-signals/td-p/929812:
set_output_delay -clock trigger_clk 0.0 [get_ports cw_trig]
set_output_delay -clock trigger_clk 0.0 [get_ports mcx_trig]
set_output_delay -clock usb_clk 0.0 [get_ports USB_Data]
set_output_delay -clock fe_clk 0.0 [get_ports cw_clk]
set_false_path -to [get_ports cw_trig]
set_false_path -to [get_ports mcx_trig]
set_false_path -to [get_ports USB_Data]
set_false_path -to [get_ports cw_clk]

#set_property IOB TRUE [get_ports cw_trig]
#set_property IOB TRUE [get_ports mcx_trig]
#set_property IOB TRUE [get_ports USB_Data]
#set_property IOB TRUE [get_ports cw_clk]

# No spec for these, seems sensible:
set_input_delay -clock usb_clk 2.0 [get_ports USB_Addr]
set_input_delay -clock usb_clk 2.0 [get_ports USB_Data]
set_input_delay -clock usb_clk 2.0 [get_ports USB_SPARE0]
set_input_delay -clock usb_clk 2.0 [get_ports USB_SPARE1]
set_input_delay -clock usb_clk 2.0 [get_ports USB_nCS]
set_input_delay -clock usb_clk 2.0 [get_ports USB_nRD]
set_input_delay -clock usb_clk 2.0 [get_ports USB_nWE]

# Unconstrain the userio* inouts:
set_input_delay -clock [get_clocks usb_clk] -add_delay 0.000 [get_ports {userio_d[0]}]
set_input_delay -clock [get_clocks usb_clk] -add_delay 0.000 [get_ports {userio_d[1]}]
set_input_delay -clock [get_clocks usb_clk] -add_delay 0.000 [get_ports {userio_d[2]}]
set_input_delay -clock [get_clocks usb_clk] -add_delay 0.000 [get_ports {userio_d[3]}]
set_input_delay -clock [get_clocks usb_clk] -add_delay 0.000 [get_ports {userio_d[4]}]
set_input_delay -clock [get_clocks usb_clk] -add_delay 0.000 [get_ports {userio_d[5]}]
set_input_delay -clock [get_clocks usb_clk] -add_delay 0.000 [get_ports {userio_d[6]}]
set_input_delay -clock [get_clocks usb_clk] -add_delay 0.000 [get_ports {userio_d[7]}]
set_input_delay -clock [get_clocks usb_clk] -add_delay 0.000 [get_ports {userio_clk}]
set_false_path -from [get_ports {userio_d[0]}]
set_false_path -from [get_ports {userio_d[1]}]
set_false_path -from [get_ports {userio_d[2]}]
set_false_path -from [get_ports {userio_d[3]}]
set_false_path -from [get_ports {userio_d[4]}]
set_false_path -from [get_ports {userio_d[5]}]
set_false_path -from [get_ports {userio_d[6]}]
set_false_path -from [get_ports {userio_d[7]}]
set_false_path -from [get_ports {userio_clk}]

set_output_delay -clock [get_clocks usb_clk] 0.0 [get_ports userio_d[0]]
set_output_delay -clock [get_clocks usb_clk] 0.0 [get_ports userio_d[1]]
set_output_delay -clock [get_clocks usb_clk] 0.0 [get_ports userio_d[2]]
set_output_delay -clock [get_clocks usb_clk] 0.0 [get_ports userio_d[3]]
set_output_delay -clock [get_clocks usb_clk] 0.0 [get_ports userio_d[4]]
set_output_delay -clock [get_clocks usb_clk] 0.0 [get_ports userio_d[5]]
set_output_delay -clock [get_clocks usb_clk] 0.0 [get_ports userio_d[6]]
set_output_delay -clock [get_clocks usb_clk] 0.0 [get_ports userio_d[7]]
set_false_path -to [get_ports userio_d[0]]
set_false_path -to [get_ports userio_d[1]]
set_false_path -to [get_ports userio_d[2]]
set_false_path -to [get_ports userio_d[3]]
set_false_path -to [get_ports userio_d[4]]
set_false_path -to [get_ports userio_d[5]]
set_false_path -to [get_ports userio_d[6]]
set_false_path -to [get_ports userio_d[7]]

