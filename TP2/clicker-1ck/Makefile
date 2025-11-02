include help.mk

ALLIANCE=/home/wixley/alliance/install
CMOS = $(ALLIANCE)/etc/cmos.rds
SLIB = $(ALLIANCE)/cells/sxlib
PLIB = $(ALLIANCE)/cells/pxlib

VASY = export MBK_WORK_LIB=.; vasy
XPAT = export MBK_WORK_LIB=.; xpat
ASIM = export MBK_WORK_LIB=.; MBK_CATA_LIB=$(SLIB); asimut
BOOM = export MBK_WORK_LIB=.; boom
BOOG = export MBK_WORK_LIB=. MBK_TARGET_LIB=$(SLIB); MBK_OUT_LO=vst; boog
XSCH = export MBK_WORK_LIB=. MBK_CATA_LIB=$(SLIB); xsch
PLACE= export MBK_WORK_LIB=. MBK_CATA_LIB=$(SLIB); ocp
ROUTE= export MBK_WORK_LIB=. MBK_CATA_LIB=$(SLIB); nero
RING = export MBK_WORK_LIB=. MBK_CATA_LIB=$(PLIB); ring
GRAAL= export MBK_WORK_LIB=. MBK_CATA_LIB=$(SLIB):$(PLIB); graal 
DRUC = export MBK_WORK_LIB=. MBK_CATA_LIB=$(SLIB):$(PLIB) RDS_TECHNO_NAME=$(CMOS); druc 
EXTC = export MBK_WORK_LIB=. MBK_CATA_LIB=$(SLIB):$(PLIB) RDS_TECHNO_NAME=$(CMOS) MBK_OUT_LO=vst;\
	   cougar -c
EXTT = export MBK_WORK_LIB=. MBK_CATA_LIB=$(SLIB):$(PLIB) RDS_TECHNO_NAME=$(CMOS) MBK_OUT_LO=spi;\
       cougar -t

#% Configuration 

MODEL ?= clicker#% Nom du modèle à créer
VERBOSE ?= 0

## Tout en une fois

all: ring ## Lance toutes les étapes de conceptions

## Etapes 

## > validation

vasy: ## Genere le vbe à partir du vhd
	$(VASY) -a -I vhd -p -o $(MODEL) $(MODEL)_v

simul_pat: vasy ## Simule un jeu de patterns écrit à la main
	$(ASIM) -b $(MODEL)_v patterns/$(MODEL) $(MODEL)_res
	@if [[ "$(VERBOSE)" == "1" ]]; then $(XPAT) -l $(MODEL)_res; fi

simul_gpat: vasy ## Simule un jeu de patterns générés
	export MODEL=$(MODEL) CYCLES=50 TYPE=BEH; genpat patterns/$(MODEL)
	$(ASIM) -b $(MODEL)_v $(MODEL)_gen $(MODEL)_gres
	@if [[ "$(VERBOSE)" == "1" ]]; then $(XPAT) -l $(MODEL)_gres; fi

## > Synthèse

synth: simul_gpat ## Synthétise pour produire la netlist de porte
	$(BOOM) $(MODEL)_v $(MODEL)_o
	$(BOOG) $(MODEL)_o $(MODEL)_o
	@if [[ "$(VERBOSE)" == "1" ]]; then $(XSCH) -l $(MODEL)_o; fi

place: synth ## Place les cellules du core
	$(PLACE) -margin 0.3 -mdl 10 -ring $(MODEL)_o $(MODEL)_p
	@if [[ "$(VERBOSE)" == "1" ]]; then $(GRAAL) -l $(MODEL)_p; fi

route: place ## Route le core
	$(ROUTE) -p $(MODEL)_p $(MODEL)_o $(MODEL)_o
	@if [[ "$(VERBOSE)" == "1" ]]; then $(GRAAL) -l $(MODEL)_o; fi

ring: route ## Route le core et les plots
	cpp $(MODEL).h -DCORE=$(MODEL)_o | grep -v "^#" > $(MODEL)_chip.vst
	cpp $(MODEL).h -DPLOT           | grep -v "^#" > $(MODEL)_chip.rin
	$(RING) $(MODEL)_chip $(MODEL)_chip
	$(GRAAL) -l $(MODEL)_chip
	@if [[ "$(VERBOSE)" == "1" ]]; then $(GRAAL) -l $(MODEL)_chip; fi

## > Vérification

druc: ring ## Vérifie les règles de dessin de tous le circuit
	$(DRUC) $(MODEL)_o

cougar_cell: ring ## Extraction du coeur jusqu'aux cellules
	$(EXTC) -c $(MODEL)_o $(MODEL)_x

resimul_pat: cougar_cell ## Simule un jeu de patterns écrit à la main
	$(ASIM) -zd $(MODEL)_x patterns/$(MODEL)x $(MODEL)_resx
	@if [[ "$(VERBOSE)" == "1" ]]; then $(XPAT) -l $(MODEL)_resx; fi

resimul_gpat: cougar_cell ## Simule un jeu de patterns générés
	export MODEL=$(MODEL) CYCLES=50 TYPE=NET; genpat patterns/$(MODEL)
	$(ASIM) -zd $(MODEL)_x $(MODEL)_genx $(MODEL)_gresx
	@if [[ "$(VERBOSE)" == "1" ]]; then $(XPAT) -l $(MODEL)_gresx; fi

## Divers

clean: ## Efface tous les fichiers intermédiaires
	rm -f $(MODEL)_*.* Makefile.* 

