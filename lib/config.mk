define ZIMK__UNIQ
$(strip $(eval undefine __ZIMK__UNIQ__SEEN)$(foreach \
    _v,$1,$(if $(filter $(_v),$(__ZIMK__UNIQ__SEEN)),,$(eval \
        __ZIMK__UNIQ__SEEN += $(_v))))$(__ZIMK__UNIQ__SEEN))
endef
SINGLECONFVARS += prefix exec_prefix bindir sbindir libexecdir datarootdir \
		  sysconfdir sharedstatedir localstatedir runstatedir \
		  includedir docrootdir libdir localedir
SINGLECONFVARS := $(call ZIMK__UNIQ,CC CPP AR STRIP $(SINGLECONFVARS))
LISTCONFVARS := $(call ZIMK__UNIQ,CFLAGS DEFINES INCLUDES LDFLAGS $(LISTCONFVARS))
CONFVARS := $(SINGLECONFVARS) $(LISTCONFVARS)
BUILDCFGS := $(call ZIMK__UNIQ,release debug $(BUILDCFGS))
NOBUILDTARGETS := $(sort clean distclean config changeconfig _build_config _build_changeconfig showconfig $(NOBUILDTARGETS))
MAKECMDGOALS ?= all

-include global.cfg

undefine ZIMK__EMPTY
ZIMK__EMPTY :=
ZIMK__TAB := $(ZIMK__EMPTY)	$(ZIMK__EMPTY)

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
#' make vim syntax highlight happy
endif

USERCONFIG:=$(BUILDCFG).cfg
ZIMK__CFGCACHE:=.cache_$(BUILDCFG).cfg

define ZIMK__WRITECACHELINE

$(ZIMK__TAB)$$(VR)echo $$(EQT)C_$(_cv) := $$(strip $($(_cv)))$$(EQT) >>$$(ZIMK__CFGCACHE)
endef
define ZIMK__WRITECACHE
$$(ZIMK__CFGCACHE):
	$$(VR)echo $$(EQT)# generated file, do not edit!$$(EQT) >$$(ZIMK__CFGCACHE)$(foreach _cv,$(CONFVARS),$(if $(strip $($(_cv))),$(ZIMK__WRITECACHELINE),))
endef
define ZIMK__WRITECFGLINE

$(ZIMK__TAB)$$(VR)echo $$(EQT)$(_cv) ?= $$(strip $($(_cv)))$$(EQT) >>$$(USERCONFIG)
endef
define ZIMK__WRITECFG
$(ZIMK__CFGTARGET): $$(USERCONFIG)
	$$(VCFG)
	$$(VR)echo $$(EQT)# generated file, do not edit!$$(EQT) >$$(USERCONFIG)$(foreach _cv,$(CONFVARS),$(if $(strip $($(_cv))),$(ZIMK__WRITECFGLINE),))
endef
define ZIMK__WRITECFGTAG
undefine ZIMK__CFGTAG
$$(foreach _cv,$$(CONFVARS), \
    $$(if $$($$(_cv)),$$(eval ZIMK__CFGTAG += $$(_cv)=$$$$(strip $$$$($$(_cv)))),))
ifdef ZIMK__CFGTAG
ZIMK__CFGTAG := $$(ZIMK__PRBOLD)[$$(ZIMK__PRRED)$$(BUILDCFG)$$(ZIMK__PRNORM)$$(ZIMK__PRBOLD): $$(ZIMK__PRYELLOW)$$(ZIMK__CFGTAG)$$(ZIMK__PRNORM)$$(ZIMK__PRBOLD)]$$(ZIMK__PRNORM)
else
ZIMK__CFGTAG := $$(ZIMK__PRBOLD)[$$(ZIMK__PRRED)$$(BUILDCFG)$$(ZIMK__PRNORM)$$(ZIMK__PRBOLD)]$$(ZIMK__PRNORM)
endif
ZIMK__CFGMSG :=
ZIMK__CFGMSG +=
ZIMK__CFGMSG +=
ZIMK__CFGMSG += $$(ZIMK__PRBOLD)$$(ZIMK__PRYELLOW)[CFG]$$(ZIMK__PRNORM)  $$(ZIMK__CFGTAG)
$$(info $$(ZIMK__CFGMSG))
endef

ifndef MAKE_RESTARTS
ifneq ($(filter config,$(MAKECMDGOALS)),)
$(eval $(ZIMK__WRITECFGTAG))
endif
endif

# save userconfig
ZIMK__CFGTARGET := _build_config
$(eval $(ZIMK__WRITECFG))

-include $(USERCONFIG)

ZIMK__CFGTARGET := _build_changeconfig
$(eval $(ZIMK__WRITECFG))

# save / compare config cache
ifneq ($(filter-out $(NOBUILDTARGETS),$(MAKECMDGOALS)),)
$(eval $(ZIMK__WRITECACHE))

-include $(ZIMK__CFGCACHE)

ifneq ($(foreach _cv,$(CONFVARS),$(_cv):$(strip $(C_$(_cv)))),$(foreach _cv,$(CONFVARS),$(_cv):$(strip $($(_cv)))))
.PHONY: $(ZIMK__CFGCACHE)
endif
endif

config: global.cfg _build_config
	$(VCFG)
	$(VR)echo $(EQT)# generated file, do not edit!$(EQT) >$<
	$(VR)echo $(EQT)BUILDCFG ?= $(BUILDCFG)$(EQT) >>$<

changeconfig: global.cfg _build_changeconfig
	$(VCFG)
	$(VR)echo $(EQT)# generated file, do not edit!$(EQT) >$<
	$(VR)echo $(EQT)BUILDCFG ?= $(BUILDCFG)$(EQT) >>$<

global.cfg: ;

$(USERCONFIG): ;

ifndef MAKE_RESTARTS
ifneq ($(filter-out $(filter-out changeconfig,$(NOBUILDTARGETS)),$(MAKECMDGOALS)),)
$(eval $(ZIMK__WRITECFGTAG))
endif
endif

DEFAULT_CC ?= cc
DEFAULT_CPP ?= cpp
DEFAULT_AR ?= ar
DEFAULT_STRIP ?= strip

DEFAULT_CFLAGS ?= -std=c11 -Wall -Wextra -Wshadow -pedantic
DEFAULT_LDFLAGS ?= -L$(LIBDIR)

PLATFORM_win32_CFLAGS ?= -Wno-pedantic-ms-format
PLATFORM_win32_LDFLAGS ?= -static-libgcc -static-libstdc++

BUILD_debug_CFLAGS ?= -g3 -O0
BUILD_debug_DEFINES ?= -DDEBUG

BUILD_release_CFLAGS ?= -g0 -O2 -ffunction-sections -fdata-sections
BUILD_release_LDFLAGS ?= -O2 -Wl,--gc-sections

ifdef POSIXSHELL
prefix ?= /usr/local
exec_prefix ?= $(prefix)
bindir ?= $(exec_prefix)/bin
sbindir ?= $(exec_prefix)/sbin
libexecdir ?= $(exec_prefix)/libexec
datarootdir ?= $(prefix)/share
sysconfdir ?= $(prefix)/etc
sharedstatedir ?= $(prefix)/com
localstatedir ?= $(prefix)/var
runstatedir ?= $(localstatedir)/run
includedir ?= $(prefix)/include
docrootdir ?= $(datarootdir)/doc
libdir ?= $(exec_prefix)/lib
localedir ?= $(datarootdir)/locale
else
DESTDIR ?= dist
prefix ?= $(PSEP).
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
endif

define ZIMK__UPDATESINGLECFGVARS
ifeq ($$(strip $$(origin $(_cv))$$($(_cv))),command line)
override undefine $(_cv)
endif
$(_cv) := $$(if $$($(_cv)),$$($(_cv)),$$(DEFAULT_$(_cv)))
$(_cv) := $$(if $$($(_cv)),$$($(_cv)),$$(PLATFORM_$(PLATFORM)_$(_cv)))
$(_cv) := $$(if $$($(_cv)),$$($(_cv)),$$(BUILD_$(BUILDCFG)_$(_cv)))
endef
$(foreach _cv,CC,$(eval $(ZIMK__UPDATESINGLECFGVARS)))
ZIMK__DEFDEFINES:= $(shell $(CROSS_COMPILE)$(CC) -dM -E - $(CMDNOIN))
ifeq ($(filter _WIN32,$(ZIMK__DEFDEFINES)),)
PLATFORM:= posix
EXE:=
else
PLATFORM:= win32
EXE:=.exe
endif

TARGETARCH:= $(strip $(shell $(CROSS_COMPILE)$(CC) -dumpmachine))
ifeq ($(TARGETARCH),)
TARGETARCH:= unknown
endif

OBJBASEDIR ?= obj
BINBASEDIR ?= bin
LIBBASEDIR ?= lib
TESTBASEDIR ?= test

OBJDIR ?= $(OBJBASEDIR)$(PSEP)$(TARGETARCH)$(PSEP)$(BUILDCFG)
BINDIR ?= $(BINBASEDIR)$(PSEP)$(TARGETARCH)$(PSEP)$(BUILDCFG)
LIBDIR ?= $(LIBBASEDIR)$(PSEP)$(TARGETARCH)$(PSEP)$(BUILDCFG)
TESTDIR ?= $(TESTBASEDIR)$(PSEP)$(TARGETARCH)$(PSEP)$(BUILDCFG)

$(foreach _cv,$(SINGLECONFVARS),$(eval $(ZIMK__UPDATESINGLECFGVARS)))

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
$(foreach _cv,BUILDCFG PLATFORM TARGETARCH $(CONFVARS),$(info $(_cv) = $($(_cv))))
endif

CLEAN += $(ZIMK__CFGCACHE)

showconfig:
	@:

.PHONY: config changeconfig _build_config _build_changeconfig _cfg_message showconfig

# vim: noet:si:ts=8:sts=8:sw=8
