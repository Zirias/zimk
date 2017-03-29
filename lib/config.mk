CONFVARS += BUILDCFG CC CFLAGS DEFINES INCLUDES LDFLAGS
BUILDCFGS += release debug

#default config
BUILDCFG ?= release
BUILDCFG := $(strip $(BUILDCFG))

ZIMK__BUILDCFG := $(filter $(BUILDCFG),$(BUILDCFGS))
ifndef ZIMK__BUILDCFG
$(error Unknown BUILDCFG $(BUILDCFG))
endif

CONFIG:=conf_$(BUILDCFG).mk

# save / compare config
ifneq ($(MAKECMDGOALS),clean)
ifneq ($(MAKECMDGOALS),distclean)
define ZIMK__WRITECFGLINE
echo $$(EQT)C_$(_cv) := $$(strip $($(_cv)))$$(EQT) >>$$(CONFIG) $$(CMDSEP)
endef
define ZIMK__WRITECFG
$$(CONFIG):
	$$(VGENT)
	$$(VR)echo $$(EQT)# generated file, do not edit!$$(EQT) >$$(CONFIG)
	$$(VR)$(foreach _cv,$(CONFVARS),$(ZIMK__WRITECFGLINE))
endef
$(eval $(ZIMK__WRITECFG))

-include $(CONFIG)

ifneq ($(foreach _cv,$(CONFVARS),$(_cv):$(strip $(C_$(_cv)))),$(foreach _cv,$(CONFVARS),$(_cv):$(strip $($(_cv)))))
.PHONY: $(CONFIG)
endif
endif
endif

define ZIMK__UPDATEVTAGS
ifeq ($(_cv),BUILDCFG)
VTAGS += $$($(_cv))
else
ifdef $(_cv)
VTAGS += $(_cv)=$$(strip $$($(_cv)))
endif
endif
endef
undefine VTAGS
$(foreach _cv,$(CONFVARS),$(eval $(ZIMK__UPDATEVTAGS)))
VTAGS := [$(VTAGS)]

CC ?= cc
AR ?= ar
STRIP ?= strip

CFLAGS ?= -std=c11 -Wall -Wextra -Wshadow -pedantic

BUILD_debug_CFLAGS ?= -g3 -O0
BUILD_debug_DEFINES ?= -DDEBUG

BUILD_release_CFLAGS ?= -g0 -O2 -flto -ffunction-sections -fdata-sections
BUILD_release_LDFLAGS ?= -O2 -flto -Wl,--gc-sections

define ZIMK__UPDATECFGVAR
ifneq ($(_cv),BUILDCFG)
$(_cv) += $$(BUILD_$$(BUILDCFG)_$(_cv))
endif
endef
$(foreach _cv,$(CONFVARS),$(eval $(ZIMK__UPDATECFGVAR)))

CLEAN += $(CONFIG)

OBJBASEDIR ?= obj
BINBASEDIR ?= bin
LIBBASEDIR ?= lib

TARGETARCH:= $(strip $(shell $(CROSS_COMPILE)$(CC) -dumpmachine))
ifeq ($(TARGETARCH),)
TARGETARCH:= unknown
endif

OBJDIR ?= $(OBJBASEDIR)$(PSEP)$(TARGETARCH)$(PSEP)$(BUILDCFG)
BINDIR ?= $(BINBASEDIR)$(PSEP)$(TARGETARCH)$(PSEP)$(BUILDCFG)
LIBDIR ?= $(LIBBASEDIR)$(PSEP)$(TARGETARCH)$(PSEP)$(BUILDCFG)

ifeq ($(PLATFORM),win32)
LDFLAGS+=-static-libgcc -static-libstdc++ -L$(LIBDIR)
DEFINES+=-DWIN32
else
LDFLAGS+=-L$(LIBDIR)
endif

# vim: noet:si:ts=8:sts=8:sw=8
