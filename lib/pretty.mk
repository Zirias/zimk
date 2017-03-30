ifndef NCOL
ifdef POSIXSHELL
ZIMK__PRNORM := $(shell tput sgr0)
ZIMK__PRBOLD := $(shell tput bold)
ZIMK__PRRED := $(shell tput setaf 1)
ZIMK__PRGREEN := $(shell tput setaf 2)
ZIMK__PRYELLOW := $(shell tput setaf 3)
ZIMK__PRBLUE := $(shell tput setaf 4)
ZIMK__PRMAGENTA := $(shell tput setaf 5)
ZIMK__PRCYAN := $(shell tput setaf 6)
ZIMK__PRWHITE := $(shell tput setaf 7)
endif
endif
