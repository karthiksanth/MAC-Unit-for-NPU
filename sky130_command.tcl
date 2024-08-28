#read lib
read_liberty -lib lib/sky130.lib

read_verilog verilog/Multiplier_Sub_Module.v

synth -top Multiplier_Sub_Module

abc  -liberty lib/sky130.lib

write_verilog -noattr synthesis/sky130/verilog/Multiplier_Sub_Module_4.v

show -prefix synthesis/sky130/dot/Multiplier_Sub_Module_4 -notitle -colors 2 -width -format dot
tee -o synthesis/sky130/report/Multiplier_Sub_Module_rep_4.json stat  -liberty "lib/sky130.lib" -json
