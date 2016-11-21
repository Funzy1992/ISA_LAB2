analyze -f vhdl -lib WORK ../src/globals.vhd 
analyze -f vhdl -lib WORK ../src/unfolded_fir.vhd
set power_preserve_rtl_hier_names true
elaborate Unfolded_FIR_pipe -arch BEHAVIOR -lib WORK
create_clock -name MY_CLK -period 0 CLK
set_dont_touch_network MY_CLK
set_clock_uncertainty  0.07 [get_clocks MY_CLK]
set_input_delay 0.5 -max -clock MY_CLK [remove_from_collection  [all_inputs] CLK]
set_output_delay 0.5 -max -clock MY_CLK [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]
#set_implementation DW01_add/rpl [find cell *add_*]
#set_implementation DW02_mult/csa [find cell *add_*]
compile
ungroup -all -flatten
set_dont_touch X_3k_2_reg_0*
set_dont_touch X_3k_1_reg_0*
set_dont_touch X_3k_0_reg_0*
set_dont_touch DOUT*
optimize_registers 
#report_resources > ../report/report_resources.txt
#create_clock -name MY_CLK -period 5.335429669 CLK
report_timing -significant_digits 10 > ../report/report_timing.txt
report_area > ../report/report_area.txt
report_power > ../report/report_power.txt
change_names -hierarchy -rules verilog
write_sdf ../netlist/fir.sdf
write -f verilog -hierarchy -output ../netlist/fir.v
write_sdc ../netlist/fir.sdc

