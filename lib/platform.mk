ifeq ($(OS),Windows_NT)

undefine POSIXSHELL
undefine _ZIMK_NOMANGLE
ifneq ($(strip $(filter %sh,$(basename $(realpath $(SHELL))))),)
POSIXSHELL := 1
_ZIMK_NOMANGLE := MSYS_NO_PATHCONV=1 CYGWIN_DISABLE_ARGUMENT_MANGLING=1 \
	MSYS2_ARG_CONV_EXCL="*"
endif

OSVER := $(subst ],,$(lastword $(shell $(_ZIMK_NOMANGLE) cmd /c ver)))
_ZIMK__OSVER := $(subst ., ,$(OSVER))
OSVER_MAJ := $(firstword $(_ZIMK__OSVER))
OSVER_MIN := $(word 2, $(_ZIMK__OSVER))
OSVER_REV := $(word 3, $(_ZIMK__OSVER))

else

POSIXSHELL := 1

endif

ifdef POSIXSHELL

CMDSEP := ;
PSEP := /
CPF := cp -f
RMF := rm -f
RMFR := rm -fr
MDP := mkdir -p
MV := mv
STAMP := touch
XIF := if [ -x
XTHEN := ]; then
XFI := ; fi
CATIN := cat
CATADD :=
CATOUT := >
READ := cat
EQT := "
#" make vim syntax highlight happy
CMDQUIET := >/dev/null 2>&1
CODNOERR := 2>/dev/null
CMDNOIN := </dev/null

INSTALL ?= install
INSTDIR := $(INSTALL) -d

instfile = $(INSTDIR) $(2) $(CMDSEP) $(INSTALL) -m$(3) $(1) $(2)
geq = $(shell if test $(1) -ge $(2); then echo 1; fi)

touch = touch $(1)

SYSNAME := $(shell uname 2>/dev/null)

else

CMDSEP := &
PSEP := \\
CPF := copy /y
RMF := del /f /q
RMFR := -rd /s /q
MDP := -md
MV := move
STAMP := copy /y NUL
XIF := if exist
XTHEN := (
XFI := )
CATIN := copy /b
CATADD := +
CATOUT :=
READ := type
EQT :=
CMDQUIET := >nul 2>nul & verify >nul
CMDNOERR := 2>nul & verify >nul
CMDNOIN := <nul

INSTDIR := $(MDP)

instfile = $(MDP) $(dir $(2)) $(CMDQUIET) $(CMDSEP) copy $(1) $(2) $(CMDQUIET)
geq = $(shell if $(1) geq $(2) echo 1)

touch = copy /b $(1) +,,

SYSNAME := $(shell uname 2>nul & verify >nul)

endif

