transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/QuartusCode/HW1 {D:/QuartusCode/HW1/HW1.v}
vlog -vlog01compat -work work +incdir+D:/QuartusCode/HW1 {D:/QuartusCode/HW1/edge_detect.v}

