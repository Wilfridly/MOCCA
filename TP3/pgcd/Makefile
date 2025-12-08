CFLAGS	= -Wall -O3 -std=c99 #-DDEBUG
LDFLAGS	= -lm
	
MODEL	= pgcd#		model name to validate
ADDRWD  = 8#		bit width of addresses for the rom
VALWD   = 8#		bit width of operands for the rom
CYCLES  = 4000#		number of cycles to simulate (should be suffisant for all triplets)

# VALNB must contains the number of triplets [opa,opb,res]
# VALNB depends on the address width ADDRWD, since VALNB = (2**ADDRWD)/3
# LASTPT is the pointer (pgcd_data.pt) for the last res in rom (pgcd_data.pt is from 0 to 3*VALNB-1)
# the lines below show how to compute an expresssion in the makefile with awk command
VALNB   = $(shell awk -v ADDRWD=$(ADDRWD) 'BEGIN{print int((2**ADDRWD)/3) }')
LASTPT  = $(shell awk -v VALNB=$(VALNB) 'BEGIN{print 3*VALNB-1}')

valid_pgcd: 
	$(CC) $(CFLAGS) rom.c -o rom
	./rom	$(ADDRWD) $(VALWD) > rom.txt
	export PATNAME=$(MODEL)_tb ADDRWD=$(ADDRWD) VALWD=$(VALWD) CYCLES=$(CYCLES);\
	genpat $(MODEL)_pat
	gcc -w -E -DADDRWD=$(ADDRWD) -DVALWD=$(VALWD) -DLASTPT=$(LASTPT) $(MODEL)_data.vhd.c | grep -v "^#" > $(MODEL)_data.vhd
	vasy -a -I vhd -p -o $(MODEL)_data $(MODEL)_data
	vasy -a -I vhd -p -o $(MODEL)_core $(MODEL)_core
	vasy -a -I vhd -p -o $(MODEL)_tb   $(MODEL)_tb  
	asimut	$(MODEL)_tb $(MODEL)_tb $(MODEL)_tbres |\
	awk '/pattern/{printf("->"$$3" "$$4"\r")}END{print}'
	@grep ": ?1" $(MODEL)_tbres.pat || echo "Lucky no error"

synthesis:
## Method 1
# 	boom $(MODEL)_core $(MODEL)_core_o
# 	boog $(MODEL)_core_o $(MODEL)_core_o
# 	loon $(MODEL)_core_o $(MODEL)_core 

# 	boom $(MODEL)_data $(MODEL)_data_o
# 	boog $(MODEL)_data_o $(MODEL)_data_o
# 	loon $(MODEL)_data_o $(MODEL)_data

# 	vasy -a -I vst -p -o $(MODEL)_tb $(MODEL)_tb 

# 	asimut $(MODEL)_tb $(MODEL)_tb $(MODEL)_tbres

## Method 2
# Avec cette méthode il faut supprimer datalastpt qui est optimisé lors de la synthèse dans pgcd_pat.c
	boom $(MODEL)_core $(MODEL)_core
	boog $(MODEL)_core $(MODEL)_core
	loon $(MODEL)_core $(MODEL)_core_o 

	boom $(MODEL)_data $(MODEL)_data
	boog $(MODEL)_data $(MODEL)_data
	loon $(MODEL)_data $(MODEL)_data_o

	vasy -a -I vhd -p -o $(MODEL)_tb $(MODEL)_tb 

	asimut $(MODEL)_tb $(MODEL)_tb $(MODEL)_tbres
  
clean:
	rm  Makefile.*\
		$(MODEL)_core.vbe\
		$(MODEL)_data.vbe\
		$(MODEL)_data.vhd\
		$(MODEL)_tb.vst\
		$(MODEL)_tb.pat\
		$(MODEL)_tbres.pat\
		*.vst\
		*.xsc\
		default.pat\
		rom rom.txt\
		2> /dev/null || true
