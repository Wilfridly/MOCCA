# 2. Load the libraries
#set_attribute library /users/soft/techno/dev/grenoble/hcmos9gp_920/CLOCK9GPHS_SNPS_AVT_4.1/SNPS/bc_1.32V_0C_wc_1.08V_125C/PHS/CLOCK9GPHS_Worst.lib
set_attribute lib_search_path /users/soft/techno/dev/grenoble/hcmos9gp_920/CORE9GPHS_SNPS_AVT_4.1.a/SNPS/bc_1.32V_0C_wc_1.08V_125C/PHS/
set_attribute library CORE9GPHS_Worst.lib

# 3. Load the design
#set rtl [list ~emad/mocca/TP2_3/SYNTH/rtl/mips_32_1p_mul_div_async_reset.vhd]

set rtl [list ~lyautey/M2_SESI/MOCCA/PART2/TP2_3/mips_32_1p_mul_div_async.vhd]

read_hdl -vhdl $rtl

# 4. Elaborate
elaborate MIPS_32_1P_MUL_DIV

# 5. Check design
check_design

# 6. Synthesis
synthesize -to_mapped

# 8. Report
report area
report timing -lint

read_sdc mips.sdc



