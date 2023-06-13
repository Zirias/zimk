all::

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
ifneq ($(filter-out $(NOBUILDTARGETS),$(MAKECMDGOALS)),)
ifneq ($(shell git --version $(CMDNOERR)),)
ZIMKSUBMODULECFG:=$(shell $(READ) $(ZIMKPATH).git $(CMDNOERR))
ifeq ($(words $(ZIMKSUBMODULECFG)),2)
ZIMKSUBMODULEGITDIR:=$(realpath $(ZIMKPATH)$(lastword $(ZIMKSUBMODULECFG)))
ifneq ($(ZIMKSUBMODULEGITDIR),)
$(ZIMKPATH)zimk.mk: $(ZIMKSUBMODULEGITDIR)/FETCH_HEAD
	$(VGIT)
	$(VR)git submodule update $(ZIMKPATH)
	$(VR)$(call touch,$@)
endif
endif
endif
endif
endif

install:: all

install-strip:: strip install

clean::
	$(RMF) $(CLEAN)

distclean::
	$(RMF) .cache_*.cfg
	$(RMF) *.cfg
	$(RMFR) $(BINBASEDIR)
	$(RMFR) $(LIBBASEDIR)
	$(RMFR) $(TESTBASEDIR)
	$(RMFR) $(OBJBASEDIR)

strip:: all

ifdef POSIXSHELL
DISTVERSIONPREFIX?=v
dist:
	@$(SHELL) $(ZIMKPATH)scripts/mkdist.sh $(DISTVERSIONPREFIX) $(PKGNAME)

else
dist:

ifneq ($(filter dist,$(MAKECMDGOALS)),)
$(error The dist target is only supported with POSIX shells)
endif
endif

.PHONY: all sharedlibs staticlibs stripsharedlibs stripstaticlibs strip \
	install installsharedlibs installstaticlibs install-strip \
	clean distclean dist
.SUFFIXES:

# vim: noet:si:ts=8:sts=8:sw=8
