CFLAGS=-Wall -O3 -std=c99 #-DDEBUG
LDFLAGS=-lm
MODEL=cordic
ADDRWD  = 8#		bit width of addresses for the rom
VALWD   = 8#		bit width of operands for the rom
CYCLES  = 4000 #	number of cycles to simulate (should be suffisant for all triplets)
VALNB   = $(shell awk -v ADDRWD=$(ADDRWD) 'BEGIN{print int((2**ADDRWD)/3) }')
LASTPT  = $(shell awk -v VALNB=$(VALNB) 'BEGIN{print 3*VALNB-1}')

help:
	@echo ""
	@echo "  Cordic model validation"
	@echo "  -----------------------"
	@echo "  Usage: make <plot|valid_cor|valid_net|clean>"
	@echo "  - plot      : test if the cordic algorithm gives the right values"
	@echo "  - valid_cor : valid the vhdl behavior with generated patterns"
	@echo "  - valid_net : valid the control and datapath netlist with patterns"
	@echo "  - clean     : delete all generated files"
	@echo ""

plot: cercle
	./cercle
# 	gnuplot \
#             -e 'plot [-130:130] [-130:130] "$(MODEL).dat" with lines;'\
#             -e 'replot "cossin.dat" with lines;' \
#             -e 'pause -1' 
	gnuplot -e "set terminal pngcairo size 800,800; set output 'plot.png'; plot [-130:130] [-130:130] 'cordic.dat' with lines; replot 'cossin.dat' with lines; set output"


cercle:
	cc $(CFLAGS) cercle.c $(LDFLAGS) -o cercle

valid_cor: 
	vasy -a -I vhd -p -o $(MODEL)_cor $(MODEL)_cor 
	export PATNAME=$(MODEL)_cor DECSIG; genpat $(MODEL)_pat
	asimut -b $(MODEL)_cor $(MODEL)_cor $(MODEL)_cor_res

valid_net:
	$(CC) $(CFLAGS) rom.c -lm -o rom
	./rom	$(ADDRWD) $(VALWD) > rom.txt
	export PATNAME=$(MODEL)_net; genpat $(MODEL)_pat
	 
	vasy -a -I vhd -p -o $(MODEL)_dp $(MODEL)_dp 
	vasy -a -I vhd -p -o $(MODEL)_ctl $(MODEL)_ctl 
	vasy -a -I vhd -p -o $(MODEL)_net $(MODEL)_net

	asimut $(MODEL)_net $(MODEL)_net $(MODEL)_net_res

error :
	awk '/: \?/ {err++} {total++} END {printf("Erreurs : %d / %d (%.2f%%)\n", err, total, (err/total)*100)}' $(MODEL)_tbres.pat
	
potatoe:
	$(CC) $(CFLAGS) rom.c -lm -o rom
	./rom	$(ADDRWD) $(VALWD) > rom.txt
	export PATNAME=$(MODEL)_tb ADDRWD=$(ADDRWD) VALWD=$(VALWD) CYCLES=$(CYCLES); genpat $(MODEL)_pat2
	gcc -w -E -DADDRWD=$(ADDRWD) -DVALWD=$(VALWD) -DLASTPT=$(LASTPT) $(MODEL)_data.vhd.c | grep -v "^#" > $(MODEL)_data.vhd
	
# 	vasy -a -I vhd -p -o cordic_cor cordic_cor
	vasy -a -I vhd -p -o $(MODEL)_ctl $(MODEL)_ctl
	vasy -a -I vhd -p -o $(MODEL)_dp $(MODEL)_dp
	vasy -a -I vhd -p -o $(MODEL)_net $(MODEL)_net
	vasy -a -I vhd -p -o $(MODEL)_data $(MODEL)_data 

	vasy -a -I vhd -p -o $(MODEL)_tb   $(MODEL)_tb 

	vasy -a -I vhd -p -o one_in_three_out one_in_three_out
	vasy -a -I vhd -p -o two_in_one_out two_in_one_out

	asimut $(MODEL)_tb $(MODEL)_tb $(MODEL)_tbres | awk '/pattern/{printf("->"$$3" "$$4"\r")}END{print}'
	@grep ": ?1" $(MODEL)_tbres.pat || echo "Lucky no error"

	
synthesis:
	boom $(MODEL)_ctl $(MODEL)_ctl_boom
	boog $(MODEL)_ctl_boom $(MODEL)_ctl_boog
	loon $(MODEL)_ctl_boog $(MODEL)_ctl 

	boom $(MODEL)_dp $(MODEL)_dp_boom
	boog $(MODEL)_dp_boom $(MODEL)_dp_boog
	loon $(MODEL)_dp_boog $(MODEL)_dp
	
	rm $(MODEL)_ctl_boom.*
	rm $(MODEL)_ctl_boog.*
	rm $(MODEL)_dp_boom.*
	rm $(MODEL)_dp_boog.*

post_synth:
#Cherche dans le CATAL
	asimut $(MODEL)_net $(MODEL)_net $(MODEL)_net_res2


clean:
	rm  *.dat *~ cercle Makefile.*\
		$(MODEL)_cor.vbe \
		$(MODEL)_cor.pat $(MODEL)_cor_res.pat \
		$(MODEL)_dp.vbe $(MODEL)_ctl.vbe $(MODEL)_net.vst \
		$(MODEL)_net.pat $(MODEL)_net_res.pat \
		${MODEL}_tb_model.vbe\
		*.xsc \
		*.vst \
		*.pat \
		.txt \
		*.vbe \
		a.out
