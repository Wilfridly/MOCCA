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
	gcc -w -E -DADDRWD=$(ADDRWD) -DVALWD=$(VALWD) -DLASTPT=$(LASTPT) $(MODEL)_data.vhd.c\
	| grep -v "^#" > $(MODEL)_data.vhd
	vasy -a -I vhd -p -o $(MODEL)_data $(MODEL)_data
	vasy -a -I vhd -p -o $(MODEL)_core $(MODEL)_core
	vasy -a -I vhd -p -o $(MODEL)_tb   $(MODEL)_tb  
	asimut	$(MODEL)_tb $(MODEL)_tb $(MODEL)_tbres |\
	awk '/pattern/{printf("->"$$3" "$$4"\r")}END{print}'
	@grep ": ?1" $(MODEL)_tbres.pat || echo "Lucky no error"

clean:
	rm  Makefile.*\
		$(MODEL)_core.vbe\
		$(MODEL)_data.vbe\
		$(MODEL)_data.vhd\
		$(MODEL)_tb.vst\
		$(MODEL)_tb.pat\
		$(MODEL)_tbres.pat\
		default.pat\
		rom rom.txt\
		2> /dev/null || true
