ZIMKPATH:=$(subst /zimk.mk,,$(lastword $(MAKEFILE_LIST)))
ifneq ($(ZIMKPATH),)
ZIMKPATH:=$(ZIMKPATH)/
endif

ifeq ($(origin CC),default)
undefine CC
endif
ifeq ($(origin CXX),default)
undefine CXX
endif
ifeq ($(origin CPP),default)
undefine CPP
endif
ifeq ($(origin AR),default)
undefine AR
endif

-include defaults.mk
include $(ZIMKPATH)lib/funcs.mk
include $(ZIMKPATH)lib/platform.mk
ifndef ZIMK__RECURSE
include $(ZIMKPATH)lib/pretty.mk
include $(ZIMKPATH)lib/config.mk
include $(ZIMKPATH)lib/silent.mk
include $(ZIMKPATH)lib/objs.mk
include $(ZIMKPATH)lib/dirs.mk
include $(ZIMKPATH)lib/deps.mk
include $(ZIMKPATH)lib/link.mk
include $(ZIMKPATH)lib/bin.mk
include $(ZIMKPATH)lib/lib.mk

ifndef MAKE_RESTARTS
ifneq ($(GIT),)
ifneq ($(filter-out $(NOBUILDTARGETS),$(MAKECMDGOALS)),)
ifneq ($(shell $(GIT) --version $(CMDNOERR)),)
ZIMKSUBMODULECFG:=$(shell $(READ) $(subst /,$(PSEP),$(ZIMKPATH)).git $(CMDNOERR))
ifeq ($(words $(ZIMKSUBMODULECFG)),2)
ZIMKSUBMODULEGITDIR:=$(realpath $(ZIMKPATH)$(lastword $(ZIMKSUBMODULECFG)))
ifneq ($(ZIMKSUBMODULEGITDIR),)
$(ZIMKPATH)zimk.mk: $(ZIMKSUBMODULEGITDIR)/FETCH_HEAD
	$(VGIT)
	$(VR)$(GIT) submodule update $(ZIMKPATH)
	$(VR)$(call touch,$(subst /,$(PSEP),$@))
endif
endif
endif
endif
endif
endif

install:: all
strip:: all

define ZIMK__CLEANLINE

$(ZIMK__TAB)$(VRM)
$(ZIMK__TAB)$(VR)$(call rmfile,$1)
endef
ZIMK__CLEANRECIPE=@:$(foreach f,$1\
	,$(eval _ZIMK_0:=$f)$(call ZIMK__CLEANLINE,$f))

clean::
	$(call ZIMK__CLEANRECIPE,$(CLEAN))

ZIMK__CONFIGS=$(foreach c,$(BUILDCFGS),.cache_$c.cfg $c.cfg) global.cfg
ZIMK__DISTCLEAN=$(BINBASEDIR) $(LIBBASEDIR) $(TESTBASEDIR) $(OBJBASEDIR)
define ZIMK__DISTCLEANLINE

$(ZIMK__TAB)$(VRMDR)
$(ZIMK__TAB)$(VR)$(call rmdir,$1)
endef
ZIMK__DISTCLEANRECIPE=@:$(foreach d,$1\
	,$(eval _ZIMK_0:=$d)$(call ZIMK__DISTCLEANLINE,$d))

distclean::
	$(call ZIMK__CLEANRECIPE,$(DISTCLEAN) $(ZIMK__CONFIGS))
	$(call ZIMK__DISTCLEANRECIPE,$(ZIMK__DISTCLEAN))

ifdef POSIXSHELL
DISTVERSIONPREFIX?=v
TAR:=$(call findtool,tar)
dist:
	@GIT="${GIT}" TAR="${TAR}" $(SHELL) \
		$(ZIMKPATH)scripts/mkdist.sh $(DISTVERSIONPREFIX) $(PKGNAME)

else
dist:

ifneq ($(filter dist,$(MAKECMDGOALS)),)
$(error The dist target is only supported with POSIX shells)
endif
endif

.PHONY: all sharedlibs staticlibs stripsharedlibs stripstaticlibs strip \
	install installsharedlibs installstaticlibs clean distclean dist
.SUFFIXES:

else
zinc:=
endif # ZIMK__RECURSE

# vim: noet:si:ts=8:sts=8:sw=8
