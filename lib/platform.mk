ifeq ($(OS),Windows_NT)

undefine POSIXSHELL
ifdef LANG
POSIXSHELL := 1
endif
ifdef BASH
POSIXSHELL := 1
endif

OSVER := $(subst ],,$(lastword $(shell cmd /c ver)))
_ZIMK__OSVER := $(subst ., ,$(OSVER))
OSVER_MAJ := $(firstword $(_ZIMK__OSVER))
OSVER_MIN := $(word 2, $(_ZIMK__OSVER))
OSVER_REV := $(word 3, $(_ZIMK__OSVER))

else

POSIXSHELL := 1

endif

ifdef POSIXSHELL

SYSNAME := $(shell uname 2>/dev/null)
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
EQT := "
#" make vim syntax highlight happy
CMDQUIET := >/dev/null 2>&1
CMDNOIN := </dev/null

INSTALL ?= install
INSTDIR := $(INSTALL) -d

instfile = $(INSTDIR) $(2) $(CMDSEP) $(INSTALL) -m$(3) $(1) $(2)
geq = $(shell if test $(1) -ge $(2); then echo 1; fi)

else

SYSNAME :=
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
EQT :=
CMDQUIET := >nul 2>nul & verify >nul
CMDNOIN := <nul

INSTDIR := $(MDP)

instfile = $(MDP) $(dir $(2)) $(CMDQUIET) $(CMDSEP) copy $(1) $(2) $(CMDQUIET)
geq = $(shell if $(1) geq $(2) echo 1)

endif

