source "tcl/openroad/helpers.tcl"
source "tcl/openroad/flow_helpers.tcl"
#need to change
source "lib/sky130hd/sky130hd.vars" 

set design "Multiplier_4X4"
set top_module "Multiplier_4X4"
set synth_verilog "synthesis/sky130/verilog/Multiplier_4X4.v"
set sdc_file "sdc/sky130hs.sdc"
set die_area {0 0 100.13 100.8}
set core_area {10.07 11.2 90.25 91}

source -echo "tcl/openroad/floorPlan.tcl"
