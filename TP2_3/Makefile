gtkwave :
	ghdl -a -v reset_sync.vhdl
	ghdl -a -v tb_reset_sync.vhdl
	ghdl -e -v tb_reset_sync
	ghdl -r tb_reset_sync --vcd=reset_sync.vcd --stop-time=200ns