#--------------------------------------------------------------------------------
# Add an help rule to document a Makefile
#
# There is two kind of messages
#
# 1) for configuration variables
# 	 add #% at the beginning of a line followed by any text
# 	 then put the VARIABLE the next lines this way:  
# 	 	VARIABLE = value#% comment
#
# 2) for rules
# 	 add ## at the beginning of a line followed by any text
# 	 then write each rule this way: 
# 	 	rule: ## help message
#
# Makefile Example
# ----------------
# include help.mk
#
# #% MAIN CONFIGURATION
# VAR1 = value1#% VAR1 is a example of variable
#
# #% OPTIONNAL CONFIGURATION
# VAR2 = value2#% VAR2 is a example of variable
#
# ## GENERIC RULES
# rule1: ## help message
# rule1: dependant files
#
# rule2: ## help message
# rule2: dependant files
#
# ## MISCELLANEOUS
# rule3: ## help message
#
#--------------------------------------------------------------------------------

SHELL := /bin/bash # Use bash syntax
R     := $(shell tput -Txterm setaf 1) # RED   
G     := $(shell tput -Txterm setaf 2) # GREEN 
Y     := $(shell tput -Txterm setaf 3) # YELLOW
C     := $(shell tput -Txterm setaf 6) # CYAN  
W     := $(shell tput -Txterm setaf 7) # WHITE 
Z     := $(shell tput -Txterm sgr0)    # RESET 

help: ## Show this help.
	@echo ''
	@echo 'Usage:'
	@echo '  ${Y}make ${G}<target>${Z}'
	@echo ''
	@awk 'BEGIN {FS="[ 	]*\\?=[ 	]*|#%"}\
		/^#% .*$$/ \
			{printf "%s:\n", substr($$0,4); next}\
		/^[A-Za-z_-].*=.*#%.*$$/ \
			{printf "  ${Y}%-15s?= ${R}%-12s${G}%s${Z}\n",$$1,$$2,$$3}' $(MAKEFILE_LIST)
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS=":.*?## "} \
		/^[a-zA-Z_-]+:.*?##.*$$/ \
			{printf "    ${Y}%-16s${G}%s${Z}\n", $$1, $$2;next}\
		/^## .*$$/ \
			{printf "  ${C}%s${Z}\n", substr($$1,4)}' $(MAKEFILE_LIST)
	@echo ''
