# Usage :
#   make run NAME=mon_design

# Variables
NAME ?= design
ENV_SCRIPT = /soc/alliance/etc/profile.d/alc_env.sh

# Cibles principales
run:
# Environnement
	source $(ENV_SCRIPT);
	export MBK_IN_PH=ap;
	export MBK_OUT_LO=al;

# COUGAR

	cougar -t $(NAME); \

# YAGLE

	export MBK_IN_LO=al; \
	~encadr/yagle -s $(NAME)

# Nettoyage
clean:
	rm -f *.al *.vst
