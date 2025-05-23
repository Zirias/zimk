MAKECMDGOALS ?= _zimk__dummy

-include global.cfg

undefine ZIMK__EMPTY
ZIMK__EMPTY :=
ZIMK__TAB := $(ZIMK__EMPTY)	$(ZIMK__EMPTY)
ZIMK__SPACE := $(ZIMK__EMPTY) $(ZIMK__EMPTY)

define ZIMK__NORMALIZEBOOLCONFVARS
ifdef $(_cv)
ZIMK__TMP_$(_cv) := $$($(_cv))
override undefine $(_cv)
$(_cv) := $$(call tobool,$$(ZIMK__TMP_$(_cv)))
endif
endef
$(foreach _cv,$(BOOLCONFVARS),$(eval $(ZIMK__NORMALIZEBOOLCONFVARS)))

#default config
DEFAULT_BUILDCFG ?= release
BUILDCFG ?= $(DEFAULT_BUILDCFG)
BUILDCFG := $(strip $(BUILDCFG))

ZIMK__BUILDCFG := $(filter $(BUILDCFG),$(BUILDCFGS))
ifndef ZIMK__BUILDCFG
$(error Unknown BUILDCFG $(BUILDCFG))
endif

ZIMK__DOUBLECONFVARS := $(filter $(SINGLECONFVARS),$(LISTCONFVARS))
ifdef ZIMK__DOUBLECONFVARS
$(error variables can't be in both SINGLECONFVARS and LISTCONFVARS: $(ZIMK__DOUBLECONFVARS))
endif

USERCONFIG:=$(BUILDCFG).cfg
ZIMK__CFGCACHE:=.cache_$(BUILDCFG).cfg

define ZIMK__WRITECACHELINE

$(ZIMK__TAB)$$(VR)$$(ECHOTO)C_$(_cv) := $$(call echoesc,$($(_cv)))$$(ETOEND) >>$$(ZIMK__CFGCACHE)
endef
define ZIMK__WRITECACHE
$$(ZIMK__CFGCACHE):
	$$(VR)$$(ECHOTO)# generated file, do not edit!$$(ETOEND) >$$(ZIMK__CFGCACHE)$(foreach _cv,$(CONFVARS),$(if $(strip $($(_cv))),$(ZIMK__WRITECACHELINE),))
endef
define ZIMK__WRITECFGLINE

$(ZIMK__TAB)$$(VR)$$(ECHOTO)export $(_cv) ?= $$(call echoesc,$($(_cv)))$$(ETOEND) >>$$(USERCONFIG)
endef
define ZIMK__WRITECFG
$(ZIMK__CFGTARGET): $$(USERCONFIG)
	$$(VCFG)
	$$(VR)$$(ECHOTO)# generated file, do not edit!$$(ETOEND) >$$(USERCONFIG)$(foreach _cv,$(CONFVARS),$(if $(strip $($(_cv))),$(ZIMK__WRITECFGLINE),))
endef
define ZIMK__WRITECFGTAG
undefine ZIMK__CFGTAG
$$(foreach _cv,$$(BOOLCONFVARS_ON), \
    $$(if $$(filter 0,$$($$(_cv))),$$(eval ZIMK__CFGTAG += $$(_cv)=$$$$(strip $$$$($$(_cv)))),))
$$(foreach _cv,$$(BOOLCONFVARS_OFF), \
    $$(if $$(filter 1,$$($$(_cv))),$$(eval ZIMK__CFGTAG += $$(_cv)=$$$$(strip $$$$($$(_cv)))),))
$$(foreach _cv,$$(SINGLECONFVARS) $$(LISTCONFVARS), \
    $$(if $$($$(_cv)),$$(eval ZIMK__CFGTAG += $$(_cv)=$$$$(strip $$$$($$(_cv)))),))
ifdef ZIMK__CFGTAG
ZIMK__CFGTAG := $$(ZIMK__PRWHITE)[$$(ZIMK__PRLRED)$$(BUILDCFG)$$(ZIMK__PRWHITE): $$(ZIMK__PRBROWN)$$(ZIMK__CFGTAG)$$(ZIMK__PRWHITE)]$$(ZIMK__PRNORM)
else
ZIMK__CFGTAG := $$(ZIMK__PRWHITE)[$$(ZIMK__PRLRED)$$(BUILDCFG)$$(ZIMK__PRWHITE)]$$(ZIMK__PRNORM)
endif
ZIMK__EMPTY :=
ZIMK__CFGMSG := $$(ZIMK__EMPTY)   $$(ZIMK__PRBOLD)$$(ZIMK__PRYELLOW)[CFG]$$(ZIMK__PRNORM)  $$(ZIMK__CFGTAG)
$$(info $$(ZIMK__CFGMSG))
endef

ZIMK__PATHCACHE:=.path-cache
ifndef MAKE_RESTARTS
ifneq ($(filter-out $(NOBUILDTARGETS),$(MAKECMDGOALS)),)
$(file >$(ZIMK__PATHCACHE),ZIMK__ENVPATH:=$(ZIMK__ENVPATH))
endif
endif
CLEAN += $(ZIMK__PATHCACHE)
DISTCLEAN += $(ZIMK__PATHCACHE)
-include $(ZIMK__PATHCACHE)

# save userconfig
ZIMK__CFGTARGET := _build_config
$(eval $(ZIMK__WRITECFG))

-include $(USERCONFIG)

ZIMK__CFGTARGET := _build_changeconfig
$(eval $(ZIMK__WRITECFG))

config: global.cfg _build_config
	$(VCFG)
	$(VR)$(ECHOTO)# generated file, do not edit!$(ETOEND) >$<
	$(VR)$(ECHOTO)BUILDCFG ?= $(BUILDCFG)$(ETOEND) >>$<

changeconfig: global.cfg _build_changeconfig
	$(VCFG)
	$(VR)$(ECHOTO)# generated file, do not edit!$(ETOEND) >$<
	$(VR)$(ECHOTO)BUILDCFG ?= $(BUILDCFG)$(ETOEND) >>$<

global.cfg: ;

$(USERCONFIG): ;

DEFAULT_CC ?= cc
DEFAULT_CXX ?= c++
DEFAULT_CPP ?= cpp
DEFAULT_AR ?= ar
DEFAULT_INSTALL ?= install
DEFAULT_STRIP ?= strip
DEFAULT_OBJCOPY ?= objcopy
DEFAULT_OBJDUMP ?= objdump
DEFAULT_WINDRES ?= windres
DEFAULT_GIT ?= git
DEFAULT_SH ?= $(if $(CROSS_COMPILE),$(or $(ZIMK__POSIXSH),/bin/sh),/bin/sh)
DEFAULT_HOSTSH ?= $(if $(CROSS_COMPILE),,$(SH))
DEFAULT_DEFGOAL ?= all
$(foreach t,$(filter HOST%,$(HOSTTOOLS)),$(eval DEFAULT_$t ?= \
	$$(or $$($(subst HOST,,$t)),$$(DEFAULT_$(subst HOST,,$t)))))
DEFAULT_CSTD ?= c11
DEFAULT_CXXSTD ?= c++17

DEFAULT_CFLAGS ?= -Wall -Wextra -Wshadow -pedantic
DEFAULT_CXXFLAGS ?= -Wall -Wextra -pedantic
DEFAULT_LDFLAGS ?= #

PLATFORM_win32_CFLAGS ?= -Wno-pedantic-ms-format
PLATFORM_win32_CXXFLAGS ?= -Wno-pedantic-ms-format
PLATFORM_win32_LDFLAGS ?= -static-libgcc -static-libstdc++

BUILD_debug_CFLAGS ?= -g3 -O0
BUILD_debug_CXXFLAGS ?= -g3 -O0
BUILD_debug_DEFINES ?= -DDEBUG

HAVE_CUSTOM_release_FLAGS:=$(strip \
$(BUILD_release_CFLAGS)$(BUILD_release_CXXFLAGS)$(BUILD_release_LDFLAGS))
BUILD_release_DEFGOAL ?= strip
BUILD_release_CFLAGS ?= -g0 -O2
BUILD_release_CXXFLAGS ?= -g0 -O2
BUILD_release_LDFLAGS ?= -O2
BUILD_release_DEFINES ?= -DNDEBUG

_ZIMK__TESTHCC:=$(call expandtool,$(or \
	       $(HOSTCC),$(DEFAULT_HOSTCC),$(BUILD_$(BUILDCFG)_HOSTCC)))
ifneq ($(strip $(_ZIMK__TESTHCC)),)
ZIMK__HDEFDEFINES:= $(shell $(_ZIMK__TESTHCC) -dM -E - $(CMDNOIN))
endif
ifeq ($(filter _WIN32,$(ZIMK__HDEFDEFINES)),)
HOSTPLATFORM:= posix
HOSTEXE:=
else
HOSTPLATFORM:= win32
HOSTEXE:=.exe
endif

ifeq ($(HOSTBUILD),1)
PLATFORM:= $(HOSTPLATFORM)
EXE:= $(HOSTEXE)
_ZIMK__TESTCC:=$(_ZIMK__TESTHCC)
else
_ZIMK__TESTCC:=$(call expandtool,$(CROSS_COMPILE)$(or \
	       $(CC),$(DEFAULT_CC),$(BUILD_$(BUILDCFG)_CC)))
ifeq ($(strip $(_ZIMK__TESTCC)),)
$(error No C compiler found, try giving CC=<name>)
endif
ZIMK__DEFDEFINES:= $(shell $(_ZIMK__TESTCC) -dM -E - $(CMDNOIN))
ifeq ($(filter _WIN32,$(ZIMK__DEFDEFINES)),)
PLATFORM:= posix
EXE:=
else
PLATFORM:= win32
EXE:=.exe
endif
endif

ifeq ($(BUILDCFG),release)
ifeq ($(HAVE_CUSTOM_release_FLAGS),)
ifneq ($(filter-out $(NOBUILDTARGETS),$(MAKECMDGOALS)),)
HAVE_GC_SECTIONS:=$(shell $(_ZIMK__TESTCC) -Wl,--gc-sections \
		  -ozimk_compiletest $(ZIMKPATH)tests/empty.c $(CMDOK))
ifeq ($(strip $(HAVE_GC_SECTIONS)),ok)
BUILD_release_CFLAGS+= -ffunction-sections -fdata-sections
BUILD_release_CXXFLAGS+= -ffunction-sections -fdata-sections
BUILD_release_LDFLAGS+= -Wl,--gc-sections
endif
$(shell $(RMF) zimk_compiletest $(CMDQUIET))
endif
endif
endif

ifeq ($(filter __CYGWIN__,$(ZIMK__DEFDEFINES)),)
BFMT_PLATFORM:= $(PLATFORM)
else
BFMT_PLATFORM:= win32
endif

ifeq ($(PLATFORM),win32)
BOOLCONFVARS_OFF := $(filter-out PORTABLE,$(BOOLCONFVARS_OFF))
BOOLCONFVARS_ON += PORTABLE
endif

define ZIMK__UPDATEBOOLCONFVARS
ifndef $(_cv)
$(_cv) := $$(if $$(filter $(_cv),$$(filter-out \
	$$(BOOLCONFVARS_OFF),$$(BOOLCONFVARS_ON))),1,0)
endif
endef
$(foreach _cv,$(BOOLCONFVARS),$(eval $(ZIMK__UPDATEBOOLCONFVARS)))

# save / compare config cache
ifneq ($(filter-out $(NOBUILDTARGETS),$(MAKECMDGOALS)),)
$(eval $(ZIMK__WRITECACHE))

-include $(ZIMK__CFGCACHE)

ifneq ($(foreach _cv,$(CONFVARS),$(_cv):$(strip $(C_$(_cv)))),$(foreach _cv,$(CONFVARS),$(_cv):$(strip $($(_cv)))))
.PHONY: $(ZIMK__CFGCACHE)
endif
endif

ifndef MAKE_RESTARTS
ifneq ($(filter-out $(filter-out config changeconfig,$(NOBUILDTARGETS)),$(MAKECMDGOALS)),)
$(eval $(ZIMK__WRITECFGTAG))
endif
endif

ifneq ($(PREFIX),)
prefix ?= $(PREFIX)
endif

ifeq ($(PORTABLE),1)
DESTDIR ?= dist
exec_prefix ?= $(prefix)
bindir ?= $(exec_prefix)
sbindir ?= $(exec_prefix)
libexecdir ?= $(exec_prefix)
datarootdir ?= $(prefix)
sysconfdir ?= $(prefix)
sharedstatedir ?= $(prefix)
localstatedir ?= $(prefix)
runstatedir ?= $(localstatedir)
includedir ?= $(prefix)
docrootdir ?= $(datarootdir)
libdir ?= $(exec_prefix)
localedir ?= $(datarootdir)
else
prefix ?= $(PSEP)usr$(PSEP)local
exec_prefix ?= $(prefix)
bindir ?= $(exec_prefix)$(PSEP)bin
sbindir ?= $(exec_prefix)$(PSEP)sbin
libexecdir ?= $(exec_prefix)$(PSEP)libexec
datarootdir ?= $(prefix)$(PSEP)share
sysconfdir ?= $(prefix)$(PSEP)etc
sharedstatedir ?= $(prefix)$(PSEP)com
localstatedir ?= $(prefix)$(PSEP)var
runstatedir ?= $(localstatedir)$(PSEP)run
includedir ?= $(prefix)$(PSEP)include
docrootdir ?= $(datarootdir)$(PSEP)doc
libdir ?= $(exec_prefix)$(PSEP)lib
localedir ?= $(datarootdir)$(PSEP)locale
endif
$(eval $(ZIMK__USES_DIRS))

_ZIMK__TESTARCHCC:= $(if $(filter \
		    1,$(HOSTBUILD)),$(_ZIMK__TESTHCC),$(_ZIMK__TESTCC))
TARGETARCH:= $(strip $(if \
	     $(_ZIMK__TESTARCHCC),$(shell $(_ZIMK__TESTARCHCC) \
	     -dumpmachine $(CMDNOERR))))
ifeq ($(TARGETARCH),)
TARGETARCH:= unknown
endif

_ZIMK__TOCNM:=$(or $(OBJCOPY),$(DEFAULT_OBJCOPY)$(BUILD_$(BUILDCFG)_OBJCOPY))
_ZIMK__TODNM:=$(or $(OBJDUMP),$(DEFAULT_OBJDUMP)$(BUILD_$(BUILDCFG)_OBJDUMP))
_ZIMK__TESTOBJCOPY:=$(or $(call expandtool,$(CROSS_COMPILE)$(_ZIMK__TOCNM)), \
		    $(call expandtool,$(_ZIMK__TOCNM)))
_ZIMK__TESTOBJDUMP:=$(or $(call expandtool,$(CROSS_COMPILE)$(_ZIMK__TODNM)), \
		    $(call expandtool,$(_ZIMK__TODNM)))
ifdef POSIXSHELL
_ZIMK__TESTOBJ:=$(if $(_ZIMK__TESTOBJCOPY),$(_ZIMK__TESTOBJCOPY)\
		--info,false) || $(if \
		$(_ZIMK__TESTOBJDUMP),$(_ZIMK__TESTOBJDUMP) -i,false)
TARGETBFD:= $(strip $(shell (\
	    $(_ZIMK__TESTOBJ)) 2>/dev/null | head -n 2 | tail -n 1))
TARGETBARCH:= $(strip $(shell (\
	      $(_ZIMK__TESTOBJ)) 2>/dev/null | head -n 4 | tail -n 1))
else
TARGETBFD:= $(strip $(subst 2:,,$(shell \
	    $(_ZIMK__TESTOBJCOPY) --info | findstr /n "." | findstr "^2:")))
TARGETBARCH:= $(strip $(subst 4:,,$(shell \
	      $(_ZIMK__TESTOBJCOPY) --info | findstr /n "." | findstr "^4:")))
endif

OBJBASEDIR ?= obj
BINBASEDIR ?= bin
LIBBASEDIR ?= lib
TESTBASEDIR ?= test

OBJDIR ?= $(OBJBASEDIR)$(PSEP)$(TARGETARCH)$(PSEP)$(BUILDCFG)
BINDIR ?= $(BINBASEDIR)$(PSEP)$(TARGETARCH)$(PSEP)$(BUILDCFG)
LIBDIR ?= $(LIBBASEDIR)$(PSEP)$(TARGETARCH)$(PSEP)$(BUILDCFG)
TESTDIR ?= $(TESTBASEDIR)$(PSEP)$(TARGETARCH)$(PSEP)$(BUILDCFG)

define ZIMK__UPDATESINGLECFGVARS
ifeq ($$(strip $$(origin $(_cv))$$($(_cv))),command line)
override undefine $(_cv)
endif
$(_cv) := $$(or $$($(_cv)),$$(BUILD_$(BUILDCFG)_$(_cv)))
$(_cv) := $$(or $$($(_cv)),$$(PLATFORM_$(PLATFORM)_$(_cv)))
$(_cv) := $$(or $$($(_cv)),$$(DEFAULT_$(_cv)))
endef
$(foreach _cv,$(BOOLCONFVARS) $(SINGLECONFVARS),$(eval $(ZIMK__UPDATESINGLECFGVARS)))

define ZIMK__UPDATELISTCFGVARS
ifeq ($$(strip $$(origin $(_cv))$$($(_cv))),command line)
override undefine $(_cv)
endif
override $(_cv) := $$(or $$($(_cv)),$$(DEFAULT_$(_cv)))
override $(_cv) := $$(strip $$(BUILD_$(BUILDCFG)_$(_cv)) $$($(_cv)))
override $(_cv) := $$(strip $$(PLATFORM_$(PLATFORM)_$(_cv)) $$($(_cv)))
endef
$(foreach _cv,$(LISTCONFVARS),$(eval $(ZIMK__UPDATELISTCFGVARS)))
override LDFLAGS += -L$(LIBDIR)

ifneq ($(filter showconfig,$(MAKECMDGOALS)),)
$(foreach _cv,BUILDCFG PLATFORM TARGETARCH BFMT_PLATFORM $(CONFVARS),$(info $(_cv) = $($(_cv))))
endif

.DEFAULT_GOAL := $(DEFGOAL)
CLEAN += $(ZIMK__CFGCACHE)

showconfig:
	@:

define ZIMK__UPDATEHOSTTOOL
ifeq ($$(strip $$(origin $1)),command line)
override undefine $1
endif
$1:=$$(call expandtool,$($1))
endef
$(foreach t,$(HOSTTOOLS),$(eval $(call ZIMK__UPDATEHOSTTOOL,$t)))

define ZIMK__UPDATECROSSTOOL
ifeq ($$(strip $$(origin $1)),command line)
override undefine $1
endif
$1:=$$(call expandtool,$(CROSS_COMPILE)$($1))
endef
$(foreach t,$(CROSSTOOLS),$(eval $(call ZIMK__UPDATECROSSTOOL,$t)))

define ZIMK__UPDATEFALLBACKTOOL
ifeq ($$(strip $$(origin $1)),command line)
override undefine $1
endif
$1:=$$(or $$(call expandtool,$(CROSS_COMPILE)$($1)),$$(call expandtool,$($1)))
endef
$(foreach t,$(FALLBACKTOOLS),$(eval $(call ZIMK__UPDATEFALLBACKTOOL,$t)))

ifeq ($(HOSTBUILD),1)
$(foreach t,$(filter HOST%,$(HOSTTOOLS)),$(eval $(subst HOST,,$t):=$$($t)))
endif

$(foreach _cv,$(ZIMK__EXPORTVARS),$(eval export $(_cv)))

ifneq ($(filter-out $(NOBUILDTARGETS),$(MAKECMDGOALS)),)
ifdef POSIXSHELL
_ZIMK__INSTTYPE=$(shell file $(INSTALL) $(CMDNOERR))
# We want BSD-style install, so we can probably rule out shell scripts
ifneq ($(findstring commands text,$(_ZIMK__INSTTYPE))$(findstring \
	script,$(_ZIMK__INSTTYPE)),)
INSTALL:=
endif
ifeq ($(INSTALL),)
INSTDIR:=$(MDP)
INSTALL=$(SHELL) $(ZIMKPATH)scripts/inst.sh
endif
endif
endif

.PHONY: config changeconfig _build_config _build_changeconfig _cfg_message showconfig

# vim: noet:si:ts=8:sts=8:sw=8
