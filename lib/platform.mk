ifeq ($(OS),Windows_NT)

PLATFORM := win32
undefine POSIXSHELL
ifdef LANG
POSIXSHELL := 1
endif
ifdef BASH
POSIXSHELL := 1
endif

EXE := .exe

else

PLATFORM := posix
POSIXSHELL := 1

EXE :=

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

else

SYSNAME :=
CMDSEP := &
PSEP := \\
CPF := copy /y
RMF := del /f /q
RMFR := -rd /s /q
MDP := -md
MV := ren
STAMP := copy /y NUL
XIF := if exist
XTHEN := (
XFI := )
CATIN := copy /b
CATADD := +
CATOUT :=
EQT :=
CMDQUIET := >nul 2>nul & verify >nul

endif

