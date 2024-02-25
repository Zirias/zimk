ifndef NCOL

ifdef POSIXSHELL
undefine zimk__tcap
ZIMK__PRNORM := $(shell tput me 2>/dev/null)
ifeq ($(.SHELLSTATUS),0)
zimk__tcap = $(shell tput $1 2>/dev/null)
else
ZIMK__PRNORM := $(shell tput sgr0 2>/dev/null)
ifeq ($(.SHELLSTATUS),0)
zimk__tcap = $(shell tput $2 2>/dev/null)
endif
endif
ifdef zimk__tcap
ZIMK__PRBOLD := $(call zimk__tcap,md,bold)
ZIMK__COLORS := $(call toint,$(call zimk__tcap,Co,colors))
ifneq ($(call geq,$(ZIMK__COLORS),8),)
ZIMK__PRRED := $(call zimk__tcap,AF 1,setaf 1)
ZIMK__PRGREEN := $(call zimk__tcap,AF 2,setaf 2)
ZIMK__PRBROWN := $(call zimk__tcap,AF 3,setaf 3)
ZIMK__PRBLUE := $(call zimk__tcap,AF 4,setaf 4)
ZIMK__PRMAGENTA := $(call zimk__tcap,AF 5,setaf 5)
ZIMK__PRCYAN := $(call zimk__tcap,AF 6,setaf 6)
ZIMK__PRLGRAY := $(call zimk__tcap,AF 7,setaf 7)
ifneq ($(call geq,$(ZIMK__COLORS),16),)
ZIMK__PRGRAY := $(call zimk__tcap,AF 8,setaf 8)
ZIMK__PRLRED := $(call zimk__tcap,AF 9,setaf 9)
ZIMK__PRLGREEN := $(call zimk__tcap,AF 10,setaf 10)
ZIMK__PRYELLOW := $(call zimk__tcap,AF 11,setaf 11)
ZIMK__PRLBLUE := $(call zimk__tcap,AF 12,setaf 12)
ZIMK__PRLMAGENTA := $(call zimk__tcap,AF 13,setaf 13)
ZIMK__PRLCYAN := $(call zimk__tcap,AF 14,setaf 14)
ZIMK__PRWHITE := $(call zimk__tcap,AF 15,setaf 15)
else
ZIMK__PRGRAY := $(ZIMK__PRLGRAY)
ZIMK__PRLRED := $(ZIMK__PRRED)
ZIMK__PRLGREEN := $(ZIMK__PRGREEN)
ZIMK__PRYELLOW := $(ZIMK__PRBROWN)
ZIMK__PRLBLUE := $(ZIMK__PRBLUE)
ZIMK__PRLMAGENTA := $(ZIMK__PRMAGENTA)
ZIMK__PRLCYAN := $(ZIMK__PRCYAN)
ZIMK__PRWHITE := $(ZIMK__PRLGRAY)
endif
endif
endif
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
