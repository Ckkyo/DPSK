create_clock -period 20.000 -name sys_clk [get_ports sys_clk]

set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports sys_clk]
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS33} [get_ports rst_n]

set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports rx]
set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports tx]

set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports led]

set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33} [get_ports {adc_data[0]}]
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports {adc_data[1]}]
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS33} [get_ports {adc_data[2]}]
set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS33} [get_ports {adc_data[3]}]
set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVCMOS33} [get_ports {adc_data[4]}]
set_property -dict {PACKAGE_PIN A20 IOSTANDARD LVCMOS33} [get_ports {adc_data[5]}]
set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS33} [get_ports {adc_data[6]}]
set_property -dict {PACKAGE_PIN C20 IOSTANDARD LVCMOS33} [get_ports {adc_data[7]}]
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS33} [get_ports adc_otr]
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS33} [get_ports adc_clk]


set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports dac_clk]
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33} [get_ports {dac_data[7]}]
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33} [get_ports {dac_data[6]}]
set_property -dict {PACKAGE_PIN L20 IOSTANDARD LVCMOS33} [get_ports {dac_data[5]}]
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS33} [get_ports {dac_data[4]}]
set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVCMOS33} [get_ports {dac_data[3]}]
set_property -dict {PACKAGE_PIN F17 IOSTANDARD LVCMOS33} [get_ports {dac_data[2]}]
set_property -dict {PACKAGE_PIN H20 IOSTANDARD LVCMOS33} [get_ports {dac_data[1]}]
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS33} [get_ports {dac_data[0]}]


set_multicycle_path -from [get_pins {u_costas/i_lpf/delay_pipeline_reg[20][15]/C}] -to [get_pins {u_costas/u_lf/acc_reg[25]/D}] 3
set_multicycle_path -from [get_pins {u_costas/i_lpf/delay_pipeline_reg[20][15]/C}] -to [get_pins {u_costas/u_lf/acc_reg[25]/D}] 3
set_multicycle_path -from [get_pins {u_costas/i_lpf/delay_pipeline_reg[20][15]/C}] -to [get_pins {u_costas/u_lf/acc_reg[27]/D}] 3
set_multicycle_path -from [get_pins {u_costas/i_lpf/delay_pipeline_reg[20][15]/C}] -to [get_pins {u_costas/u_lf/acc_reg[26]/D}] 3
set_multicycle_path -from [get_pins {u_costas/i_lpf/delay_pipeline_reg[20][15]/C}] -to [get_pins {u_costas/u_lf/acc_reg[24]/D}] 3
set_multicycle_path -from [get_pins {u_costas/i_lpf/delay_pipeline_reg[20][15]/C}] -to [get_pins {u_costas/u_lf/acc_reg[21]/D}] 3
set_multicycle_path -from [get_pins {u_costas/i_lpf/delay_pipeline_reg[20][15]/C}] -to [get_pins {u_costas/u_lf/acc_reg[23]/D}] 3
set_multicycle_path -from [get_pins {u_costas/i_lpf/delay_pipeline_reg[20][15]/C}] -to [get_pins {u_costas/u_lf/acc_reg[20]/D}] 3
set_multicycle_path -from [get_pins {u_costas/i_lpf/delay_pipeline_reg[20][15]/C}] -to [get_pins {u_costas/u_lf/acc_reg[17]/D}] 3
set_multicycle_path -from [get_pins {u_costas/i_lpf/delay_pipeline_reg[20][15]/C}] -to [get_pins {u_costas/u_lf/acc_reg[19]/D}] 3
