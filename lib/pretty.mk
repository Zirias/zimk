ifndef NCOL

ifdef TERM
ZIMK__PRNORM := $(shell tput sgr0 || tput me)
ZIMK__PRBOLD := $(shell tput bold || tput md)
ZIMK__PRRED := $(shell tput setaf 1 || tput AF 1)
ZIMK__PRGREEN := $(shell tput setaf 2 || tput AF 2)
ZIMK__PRYELLOW := $(shell tput setaf 3 || tput AF 3)
ZIMK__PRBLUE := $(shell tput setaf 4 || tput AF 4)
ZIMK__PRMAGENTA := $(shell tput setaf 5 || tput AF 5)
ZIMK__PRCYAN := $(shell tput setaf 6 || tput AF 6)
ZIMK__PRWHITE := $(shell tput setaf 7 || tput AF 7)
else

ifeq ($(OS),Windows_NT)
ifneq ($(call geq,$(OSVER_MAJ),10),)
ZIMK__PRNORM := [0m
ZIMK__PRBOLD := [1m
ZIMK__PRRED := [91m
ZIMK__PRGREEN := [92m
ZIMK__PRYELLOW := [93m
ZIMK__PRBLUE := [94m
ZIMK__PRMAGENTA := [95m
ZIMK__PRCYAN := [96m
ZIMK__PRWHITE := [97m
endif # Windows 10
endif # Windows_NT

endif # TERM

endif # NCOL
