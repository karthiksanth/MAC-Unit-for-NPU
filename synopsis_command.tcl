#read lib
read_liberty -lib lib/synopsis.lib

read_verilog verilog/Look_Ahead_Adder.v

synth -top Look_Ahead_Adder

abc  -liberty lib/synopsis.lib

write_verilog -noattr synthesis/synopsis/verilog/Look_Ahead_Adder.v

show -prefix synthesis/synopsis/dot/Look_Ahead_Adder -notitle -colors 2 -width -format dot
