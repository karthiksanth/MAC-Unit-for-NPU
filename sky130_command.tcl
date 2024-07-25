#read lib
read_liberty -lib lib/sky130.lib

read_verilog verilog/Look_Ahead_Adder.v

synth -top Look_Ahead_Adder

abc  -liberty lib/sky130.lib

write_verilog -noattr synthesis/sky130/verilog/Look_Ahead_Adder.v

show -prefix synthesis/sky130/dot/Look_Ahead_Adder -notitle -colors 2 -width -format dot
