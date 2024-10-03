#read lib
read_liberty -lib lib/sky130.lib

read_verilog verilog/Multiplier_8x8.v

synth -top Multiplier_8x8

abc  -liberty lib/sky130.lib
#write_table table.csv
#sta -liberty lib/sky130.lib

write_verilog -noattr synthesis/sky130/verilog/Multiplier_8x8.v

show  -prefix synthesis/sky130/dot/Multiplier_8x8 -colors 2 -width -format dot 

tee -o synthesis/sky130/report/Multiplier_8x8.json stat  -liberty "lib/sky130.lib" -json 
