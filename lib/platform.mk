POSIXSHELL := $(if $(CROSS_COMPILE),$(HOSTSH),$(or $(HOSTSH),$(SH)))
ZIMK__POSIXSH :=
ifeq ($(POSIXSHELL),)
ifeq ($(shell getconf _POSIX_SHELL 2>&1),1)
ifeq ($(.SHELLSTATUS),0)
ifndef ZIMK__ISTTY
ZIMK__RECURSE=$(MAKE) --no-print-directory ZIMK__ISTTY=$1 $(MAKECMDGOALS)
all $(MAKECMDGOALS):
	+@[ -t 1 ] && $(call ZIMK__RECURSE,1) || $(call ZIMK__RECURSE,0)

.PHONY: all $(MAKECMDGOALS)
else
override undefine MAKEFLAGS
ZIMK__CHECKSHELLS := $(addsuffix /sh,$(subst \
		     :, ,$(shell getconf PATH 2>/dev/null)))
$(foreach s,$(ZIMK__CHECKSHELLS),$(if $(POSIXSHELL),,$(if \
	$(shell test -x "$s" && echo 1),$(eval POSIXSHELL:=$s))))
ZIMK__POSIXSH := $(POSIXSHELL)
endif
endif
endif
endif
ifeq ($(POSIXSHELL),)
undefine POSIXSHELL
endif

ifndef ZIMK__RECURSE
ifeq ($(OS),Windows_NT)
export MSYS_NO_PATHCONV=1
export CYGWIN_DISABLE_ARGUMENT_MANGLING=1
export MSYS2_ARG_CONV_EXCL=*
ifdef POSIXSHELL
_ZIMK_WINCMD := CMD /C
else
WIN32PATH:=$(shell CMD /C ECHO %SystemRoot%)\system32
WIN32SHELL:=$(WIN32PATH)\cmd.exe
SHELL:=$(WIN32SHELL)
_ZIMK_WINCMD :=
export .SHELLFLAGS=/C
export SHELL
ZIMK__ISTTY:=1
endif

OSVER := $(subst ],,$(lastword $(shell $(_ZIMK_WINCMD) ver)))
_ZIMK__OSVER := $(subst ., ,$(OSVER))
OSVER_MAJ := $(firstword $(_ZIMK__OSVER))
OSVER_MIN := $(word 2, $(_ZIMK__OSVER))
OSVER_REV := $(word 3, $(_ZIMK__OSVER))

else
ifndef POSIXSHELL
define ZIMK__POSIXSHMSG

*** No POSIX shell could be detected while not building on Windows

The zimk build system needs a POSIX compliant shell. Detection of the shell
can be overridden by passing variables to make:

HOSTSH:  Path to the POSIX shell on the build system
         Defaults to the value of SH when not cross-building
SH:      Path to the POSIX shell on the target system

If you know your system has a POSIX shell available, pass its full path in
one of these variables, e.g.

    make SH=/bin/sh

for the most commonly used path.

endef
$(info $(ZIMK__POSIXSHMSG))
$(error zimk only works with a POSIX shell or Windows CMD.EXE)
endif
endif

ZIMK__ENVPATH:=$(PATH)

ifdef POSIXSHELL
SHELL:=$(POSIXSHELL)
export SHELL
POSIXPATH:=$(shell getconf PATH 2>/dev/null)
ifeq ($(.SHELLSTATUS),0)
PATH:=$(POSIXPATH)
else
POSIXPATH:=
endif

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
ECHOTO := echo "
ETOEND := "
EQT := "
CMDQUIET := >/dev/null 2>&1
CODNOERR := 2>/dev/null
CMDNOIN := </dev/null

INSTALL ?= install
INSTDIR := $(INSTALL) -d

MAKE := PATH="$(ZIMK__ENVPATH)" $(MAKE)

findtool = $(shell PATH="$(ZIMK__ENVPATH)" command -v $1 2>/dev/null)
instfile = $(INSTDIR) $(2) $(CMDSEP) $(INSTALL) -m$(3) $(1) $(2)
rmfile = $(RMF) $(1)
rmdir = $(RMFR) $(1)
geq = $(shell if test $(1) -ge $(2); then echo 1; fi)

touch = touch $(1)

SYSNAME := $(shell uname 2>/dev/null)

else
PATH:=$(WIN32PATH)

CMDSEP := &
PSEP := \\
CPF := copy /y
RMF := del /f /q
RMFR := rd /s /q
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
ECHOTO := (echo 
ETOEND := )
EQT :=
CMDQUIET := >nul 2>nul & verify >nul
CMDNOERR := 2>nul & verify >nul
CMDNOIN := <nul

INSTDIR := $(MDP)

MAKE := set "PATH=$(ZIMK__ENVPATH)" & $(MAKE)

define _ZIMK__FINDTOOL
_ZIMK__TOOL:=$$(shell where "$(ZIMK__ENVPATH):$1" 2>NUL)
ifeq ($$(.SHELLSTATUS),2)
_ZIMK__TOOL:=$1
endif
ifneq ($$(_ZIMK__TOOL),)
ZIMK__EMPTY:=
_ZIMK__TOOL:=set "PATH=%PATH%;$$(subst ?, ,$$(dir \
	     $$(subst $$(ZIMK__EMPTY) ,?,$$(_ZIMK__TOOL))))" & $1
endif
endef
findtool = $(eval $(call _ZIMK__FINDTOOL,$1))$(_ZIMK__TOOL)
instfile = $(MDP) $(2) $(CMDQUIET) $(CMDSEP) copy $(1) $(2) $(CMDQUIET)
rmfile = $(RMF) $(1) $(CMDNOERR)
rmdir = $(RMFR) $(1) $(CMDNOERR)
geq = $(shell if $(1) geq $(2) echo 1)

touch = copy /b $(1)+,,$(1) $(CMDQUIET)

SYSNAME := $(shell uname 2>nul & verify >nul)

endif
endif

ZIMK__SUBDIR:= $(subst $(ZIMK__BASEDIR),,$(CURDIR))
ifneq ($(ZIMK__SUBDIR),)
ZIMK__SUBDIR:= $(patsubst /%,%,$(subst /,$(PSEP),$(ZIMK__SUBDIR)))$(PSEP)
endif

ifeq ($(ZIMK__ISTTY),1)
V?=0
COLORS?=1
else
V?=1
COLORS?=0
endif
