ifndef NCOL

ifdef TERM
ZIMK__PRNORM := $(shell tput sgr0 || tput me)
ZIMK__PRBOLD := $(shell tput bold || tput md)
ZIMK__PRRED := $(shell tput setaf 1 || tput AF 1)
ZIMK__PRGREEN := $(shell tput setaf 2 || tput AF 2)
ZIMK__PRBROWN := $(shell tput setaf 3 || tput AF 3)
ZIMK__PRBLUE := $(shell tput setaf 4 || tput AF 4)
ZIMK__PRMAGENTA := $(shell tput setaf 5 || tput AF 5)
ZIMK__PRCYAN := $(shell tput setaf 6 || tput AF 6)
ZIMK__PRLGRAY := $(shell tput setaf 7 || tput AF 7)
ZIMK__PRGRAY := $(shell tput setaf 8 || tput AF 8 || tput setaf 0 || tput Af 0)
ZIMK__PRLRED := $(shell tput setaf 9 || tput AF 9 || tput setaf 1 || tput AF 1)
ZIMK__PRLGREEN := $(shell tput setaf 10 || tput AF 10 || tput setaf 2 || tput AF 2)
ZIMK__PRYELLOW := $(shell tput setaf 11 || tput AF 11 || tput setaf 3 || tput AF 3)
ZIMK__PRLBLUE := $(shell tput setaf 12 || tput AF 12 || tput setaf 4 || tput AF 4)
ZIMK__PRLMAGENTA := $(shell tput setaf 13 || tput AF 13 || tput setaf 5 || tput AF 5)
ZIMK__PRLCYAN := $(shell tput setaf 14 || tput AF 14 || tput setaf 6 || tput AF 6)
ZIMK__PRWHITE := $(shell tput setaf 15 || tput AF 15 || tput setaf 7 || tput AF 7)
else

ifeq ($(OS),Windows_NT)
ifneq ($(call geq,$(OSVER_MAJ),10),)
ZIMK__PRNORM := [0m
ZIMK__PRBOLD := [1m
ZIMK__PRRED := [31m
ZIMK__PRGREEN := [32m
ZIMK__PRBROWN := [33m
ZIMK__PRBLUE := [34m
ZIMK__PRMAGENTA := [35m
ZIMK__PRCYAN := [36m
ZIMK__PRLGRAY := [37m
ZIMK__PRGRAY := [90m
ZIMK__PRLRED := [91m
ZIMK__PRLGREEN := [92m
ZIMK__PRYELLOW := [93m
ZIMK__PRLBLUE := [94m
ZIMK__PRLMAGENTA := [95m
ZIMK__PRLCYAN := [96m
ZIMK__PRWHITE := [97m
endif # Windows 10
endif # Windows_NT

endif # TERM

endif # NCOL
