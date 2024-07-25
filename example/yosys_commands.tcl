# read modules from Verilog file
read_verilog Booth_Radix_Table.v

# elaborate design hierarchy
hierarchy -check -top Booth_Radix_Table

# translate processes to netlists
#proc

# mapping to internal cell library
#techmap
#opt
#read_verilog -lib cmos_cells.v
#synth

# mapping flip-flops to NangateOpenCellLibrary_typical.lib 
# for eg. always block
dfflibmap -liberty sky130.lib

# mapping logic to NangateOpenCellLibrary_typical.lib 
# for eg. assign block
abc -liberty sky130.lib
 opt
# remove unused cells and wires
clean

# Write the current design to a Verilog file
write_verilog -noattr  synth_example.v 

write_json synth.json
show -prefix synth -notitle -colors 2 -width -format dot
#xdot synth.dot

