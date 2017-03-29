all::

ZIMKPATH:=$(subst /zimk.mk,,$(lastword $(MAKEFILE_LIST)))
ifneq ($(ZIMKPATH),)
ZIMKPATH:=$(ZIMKPATH)/
endif

ifeq ($(origin CC),default)
undefine CC
endif

-include defaults.mk
include $(ZIMKPATH)lib/platform.mk
include $(ZIMKPATH)lib/silent.mk
include $(ZIMKPATH)lib/config.mk
include $(ZIMKPATH)lib/objs.mk
include $(ZIMKPATH)lib/dirs.mk
include $(ZIMKPATH)lib/deps.mk
include $(ZIMKPATH)lib/link.mk
include $(ZIMKPATH)lib/bin.mk
include $(ZIMKPATH)lib/lib.mk
include $(ZIMKPATH)lib/funcs.mk

clean::
	$(RMF) $(CLEAN)

distclean::
	$(RMF) conf_*.mk
	$(RMFR) $(BINBASEDIR)
	$(RMFR) $(LIBBASEDIR)
	$(RMFR) $(OBJBASEDIR)

strip:: all

.PHONY: all staticlibs strip clean distclean
.SUFFIXES:

# vim: noet:si:ts=8:sts=8:sw=8
