POSIXSHELL := $(if $(CROSS_COMPILE),$(HOSTSH),$(or $(HOSTSH),$(SH)))
ZIMK__POSIXSH :=
ifeq ($(POSIXSHELL),)
ifeq ($(shell getconf _POSIX_SHELL 2>&1 || echo ERR),1)
ifdef ZIMK__ISTTY
ZIMK__CHECKSHELLS := $(addsuffix /sh,$(subst \
		     :, ,$(shell getconf PATH 2>/dev/null)))
$(foreach s,$(ZIMK__CHECKSHELLS),$(if $(POSIXSHELL),,$(if \
	$(shell test -x "$s" && echo 1),$(eval POSIXSHELL:=$s))))
ZIMK__POSIXSH := $(POSIXSHELL)
else
POSIXSHELL := 1
endif
endif
endif
ifeq ($(POSIXSHELL),)
undefine POSIXSHELL
endif

ifdef POSIXSHELL
ifndef ZIMK__ISTTY
ZIMK__RECURSE=$(MAKE) --no-print-directory ZIMK__ISTTY=$1 $(MAKECMDGOALS)
all $(MAKECMDGOALS):
	+@if [ -t 1 ]; then $(call ZIMK__RECURSE,1); \
		       else $(call ZIMK__RECURSE,0); fi

.PHONY: all $(MAKECMDGOALS)
endif
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

_ZIMK__TOOLPATH := #

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
POSIXPATH:=$(shell getconf PATH 2>/dev/null || echo " ERR")
ifneq ($(lastword $(POSIXPATH)),ERR)
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
MV := mv -f
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
ELQT := \"
CMDQUIET := >/dev/null 2>&1
CMDNOERR := 2>/dev/null
CMDNOIN := </dev/null
CMDOK := >/dev/null 2>&1 && echo ok

INSTDIR = $(INSTALL) -d

MAKE := PATH="$(ZIMK__ENVPATH)" $(MAKE)

ifeq ($(OS),Windows_NT)
define _ZIMK__FINDTOOL
_ZIMK__TOOL:=$$(shell PATH="$2:$(ZIMK__ENVPATH)" command -v $1 2>/dev/null)
ifneq ($$(_ZIMK__TOOL),)
_ZIMK__TOOLDIR:=$$(dir $$(_ZIMK__TOOL))
ifeq ($$(filter $$(_ZIMK__TOOLDIR),$$(_ZIMK__TOOLPATH)),)
PATH:=$$(PATH):$$(_ZIMK__TOOLDIR)
_ZIMK__TOOLPATH:=$$(_ZIMK__TOOLPATH) $$(_ZIMK__TOOLDIR)
endif
endif
endef
findtool = $(eval $(call _ZIMK__FINDTOOL,$1))$(_ZIMK__TOOL)
else
findtool = $(shell PATH="$2:$(ZIMK__ENVPATH)" command -v $1 2>/dev/null)
endif
instfile = $(INSTDIR) $2 $(CMDSEP) $(INSTALL) -m$3 $1 $2$(if $4,/$4)
rmfile = $(RMF) $(1)
rmdir = $(RMFR) $(1)
geq = $(shell if test $(1) -ge $(2); then echo 1; fi)
echoesc = $(strip $(1))

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
MV := move /y
STAMP := copy /y NUL >nul
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
ELQT := "
CMDQUIET := >nul 2>nul & verify >nul
CMDNOERR := 2>nul & verify >nul
CMDNOIN := <nul
CMDOK := >nul 2>nul && echo ok

INSTDIR := $(MDP)

MAKE := set "PATH=$(ZIMK__ENVPATH)" & $(MAKE)

define _ZIMK__FINDTOOL
_ZIMK__TOOL:=$$(shell setlocal enabledelayedexpansion \
	     & where "$$(subst :,;,$2);$(ZIMK__ENVPATH):$1" 2>NUL\
	     & if !errorlevel!==2 (echo NOTFOUND))
ifeq ($$(lastword $$(_ZIMK__TOOL)),NOTFOUND)
_ZIMK__TOOL:=$1
endif
ifneq ($$(_ZIMK__TOOL),)
ZIMK__EMPTY:=
_ZIMK__TOOL:=set "PATH=%PATH%;$$(subst ?, ,$$(dir \
	     $$(subst $$(ZIMK__EMPTY) ,?,$$(_ZIMK__TOOL))))" & $1
endif
endef
findtool = $(eval $(call _ZIMK__FINDTOOL,$1))$(_ZIMK__TOOL)
instfile = $(MDP) $2 $(CMDQUIET) $(CMDSEP) copy $1 $2$(if $4,\\$4) $(CMDQUIET)
rmfile = $(RMF) $(1) $(CMDNOERR)
rmdir = $(RMFR) $(1) $(CMDNOERR)
geq = $(shell if $(1) geq $(2) echo 1)
echoesc = $(subst &,^&,$(strip $(1)))

touch = copy /b $(1)+,,$(1) $(CMDQUIET)

SYSNAME := $(shell uname 2>nul & verify >nul)

endif
endif

ZIMK__SUBDIR:= $(subst $(ZIMK__BASEDIR),,$(CURDIR))
ifneq ($(ZIMK__SUBDIR),)
ZIMK__SUBDIR:= $(subst /,$(PSEP),$(patsubst /%,%,$(ZIMK__SUBDIR)))$(PSEP)
endif

ifeq ($(ZIMK__ISTTY),1)
V?=0
COLORS?=1
else
V?=1
COLORS?=0
endif
