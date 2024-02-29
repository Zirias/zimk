define ZIMK__UNIQ
$(strip $(eval undefine __ZIMK__UNIQ__SEEN)$(foreach \
    _v,$1,$(if $(filter $(_v),$(__ZIMK__UNIQ__SEEN)),,$(eval \
        __ZIMK__UNIQ__SEEN += $(_v))))$(__ZIMK__UNIQ__SEEN))
endef
HOSTTOOLS += GIT
CROSSTOOLS += CC CXX CPP
FALLBACKTOOLS += AR STRIP OBJCOPY OBJDUMP PKGCONFIG WINDRES MOC RCC
SINGLECONFVARS += prefix exec_prefix bindir sbindir libexecdir datarootdir \
		  sysconfdir sharedstatedir localstatedir runstatedir \
		  includedir docrootdir libdir localedir pkgconfigdir \
		  icondir iconsubdir mimeiconsubdir desktopdir mimedir \
		  sharedmimeinfodir
BOOLCONFVARS_ON := $(call ZIMK__UNIQ,SHAREDLIBS $(BOOLCONFVARS_ON))
BOOLCONFVARS_OFF := $(call ZIMK__UNIQ,PORTABLE STATIC STATICLIBS \
		    $(BOOLCONFVARS_OFF))
BOOLCONFVARS := $(BOOLCONFVARS_ON) $(BOOLCONFVARS_OFF)
SINGLECONFVARS := $(call ZIMK__UNIQ,DEFGOAL SH HOSTSH \
		  $(HOSTTOOLS) $(CROSSTOOLS) $(FALLBACKTOOLS) $(SINGLECONFVARS))
LISTCONFVARS := $(call ZIMK__UNIQ,CFLAGS CXXFLAGS DEFINES INCLUDES LDFLAGS \
		$(LISTCONFVARS))
CONFVARS := $(BOOLCONFVARS) $(SINGLECONFVARS) $(LISTCONFVARS)
BUILDCFGS := $(call ZIMK__UNIQ,release debug $(BUILDCFGS))
NOBUILDTARGETS := $(sort clean distclean dist config changeconfig showconfig \
		  _build_config _build_changeconfig $(NOBUILDTARGETS))
MAKECMDGOALS ?= _zimk__dummy

-include global.cfg

undefine ZIMK__EMPTY
ZIMK__EMPTY :=
ZIMK__TAB := $(ZIMK__EMPTY)	$(ZIMK__EMPTY)

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

$(ZIMK__TAB)$$(VR)$$(ECHOTO)C_$(_cv) := $$(strip $($(_cv)))$$(ETOEND) >>$$(ZIMK__CFGCACHE)
endef
define ZIMK__WRITECACHE
$$(ZIMK__CFGCACHE):
	$$(VR)$$(ECHOTO)# generated file, do not edit!$$(ETOEND) >$$(ZIMK__CFGCACHE)$(foreach _cv,$(CONFVARS),$(if $(strip $($(_cv))),$(ZIMK__WRITECACHELINE),))
endef
define ZIMK__WRITECFGLINE

$(ZIMK__TAB)$$(VR)$$(ECHOTO)$(_cv) ?= $$(strip $($(_cv)))$$(ETOEND) >>$$(USERCONFIG)
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
ifneq ($(filter config,$(MAKECMDGOALS)),)
$(eval $(ZIMK__WRITECFGTAG))
endif
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
DEFAULT_STRIP ?= strip
DEFAULT_OBJCOPY ?= objcopy
DEFAULT_OBJDUMP ?= objdump
DEFAULT_PKGCONFIG ?= pkg-config
DEFAULT_WINDRES ?= windres
DEFAULT_MOC ?= moc
DEFAULT_RCC ?= rcc
DEFAULT_GIT ?= git
DEFAULT_SH ?= $(if $(CROSS_COMPILE),$(or $(ZIMK__POSIXSH),/bin/sh),/bin/sh)
DEFAULT_HOSTSH ?= $(if $(CROSS_COMPILE),,$(SH))
DEFAULT_DEFGOAL ?= all

DEFAULT_CFLAGS ?= -std=c11 -Wall -Wextra -Wshadow -pedantic
DEFAULT_CXXFLAGS ?= -std=c++11 -Wall -Wextra -pedantic
DEFAULT_LDFLAGS ?= -L$(LIBDIR)

PLATFORM_win32_CFLAGS ?= -Wno-pedantic-ms-format
PLATFORM_win32_CXXFLAGS ?= -Wno-pedantic-ms-format
PLATFORM_win32_LDFLAGS ?= -static-libgcc -static-libstdc++

BUILD_debug_CFLAGS ?= -g3 -O0
BUILD_debug_CXXFLAGS ?= -g3 -O0
BUILD_debug_DEFINES ?= -DDEBUG

BUILD_release_DEFGOAL ?= strip
BUILD_release_CFLAGS ?= -g0 -O2 -ffunction-sections -fdata-sections
BUILD_release_CXXFLAGS ?= -g0 -O2 -ffunction-sections -fdata-sections
BUILD_release_LDFLAGS ?= -O2 -Wl,--gc-sections

_ZIMK__TESTCC:=$(call findtool,$(CROSS_COMPILE)$(or \
	       $(CC),$(DEFAULT_CC),$(BUILD_$(BUILDCFG)_CC)))
ZIMK__DEFDEFINES:= $(shell $(_ZIMK__TESTCC) -dM -E - $(CMDNOIN))
ifeq ($(filter _WIN32,$(ZIMK__DEFDEFINES)),)
PLATFORM:= posix
EXE:=
else
PLATFORM:= win32
EXE:=.exe
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
ifneq ($(filter-out $(filter-out changeconfig,$(NOBUILDTARGETS)),$(MAKECMDGOALS)),)
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
pkgconfigdir ?= $(prefix)
icondir ?= $(datarootdir)$(PSEP)icons
desktopdir ?= $(datarootdir)
mimedir ?= $(datarootdir)$(PSEP)mime
sharedmimeinfodir ?= $(mimedir)
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
pkgconfigdir ?= $(prefix)$(PSEP)lib$(PSEP)pkgconfig
icondir ?= $(datarootdir)$(PSEP)icons$(PSEP)hicolor
iconsubdir ?= apps
mimeiconsubdir ?= mimetypes
desktopdir ?= $(datarootdir)$(PSEP)applications
mimedir ?= $(datarootdir)$(PSEP)mime
sharedmimeinfodir ?= $(mimedir)$(PSEP)packages
endif

TARGETARCH:= $(strip $(shell $(_ZIMK__TESTCC) -dumpmachine $(CMDNOERR)))
ifeq ($(TARGETARCH),)
TARGETARCH:= unknown
endif

_ZIMK__TOCNM:=$(or $(OBJCOPY),$(DEFAULT_OBJCOPY)$(BUILD_$(BUILDCFG)_OBJCOPY))
_ZIMK__TODNM:=$(or $(OBJDUMP),$(DEFAULT_OBJDUMP)$(BUILD_$(BUILDCFG)_OBJDUMP))
_ZIMK__TESTOBJCOPY:=$(or $(call findtool,$(CROSS_COMPILE)$(_ZIMK__TOCNM)), \
		    $(call findtool,$(_ZIMK__TOCNM)))
_ZIMK__TESTOBJDUMP:=$(or $(call findtool,$(CROSS_COMPILE)$(_ZIMK__TODNM)), \
		    $(call findtool,$(_ZIMK__TODNM)))
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
$(_cv) := $$(if $$($(_cv)),$$($(_cv)),$$(BUILD_$(BUILDCFG)_$(_cv)))
$(_cv) := $$(if $$($(_cv)),$$($(_cv)),$$(PLATFORM_$(PLATFORM)_$(_cv)))
$(_cv) := $$(if $$($(_cv)),$$($(_cv)),$$(DEFAULT_$(_cv)))
endef
$(foreach _cv,$(BOOLCONFVARS) $(SINGLECONFVARS),$(eval $(ZIMK__UPDATESINGLECFGVARS)))

define ZIMK__UPDATELISTCFGVARS
ifeq ($$(strip $$(origin $(_cv))$$($(_cv))),command line)
override undefine $(_cv)
endif
$(_cv) := $$(if $$($(_cv)),$$($(_cv)),$$(DEFAULT_$(_cv)))
$(_cv) := $$(strip $$(BUILD_$(BUILDCFG)_$(_cv)) $$($(_cv)))
$(_cv) := $$(strip $$(PLATFORM_$(PLATFORM)_$(_cv)) $$($(_cv)))
endef
$(foreach _cv,$(LISTCONFVARS),$(eval $(ZIMK__UPDATELISTCFGVARS)))

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
$1:=$$(call findtool,$($1))
endef
$(foreach t,MAKE $(HOSTTOOLS),$(eval $(call ZIMK__UPDATEHOSTTOOL,$t)))
export MAKE

define ZIMK__UPDATECROSSTOOL
ifeq ($$(strip $$(origin $1)),command line)
override undefine $1
endif
$1:=$$(call findtool,$(CROSS_COMPILE)$($1))
endef
$(foreach t,$(CROSSTOOLS),$(eval $(call ZIMK__UPDATECROSSTOOL,$t)))

define ZIMK__UPDATEFALLBACKTOOL
ifeq ($$(strip $$(origin $1)),command line)
override undefine $1
endif
$1:=$$(or $$(call findtool,$(CROSS_COMPILE)$($1)),$$(call findtool,$($1)))
endef
$(foreach t,$(FALLBACKTOOLS),$(eval $(call ZIMK__UPDATEFALLBACKTOOL,$t)))

.PHONY: config changeconfig _build_config _build_changeconfig _cfg_message showconfig

# vim: noet:si:ts=8:sts=8:sw=8
