ZIMKPATH:=$(subst /zimk.mk,,$(lastword $(MAKEFILE_LIST)))
ifneq ($(ZIMKPATH),)
ZIMKPATH:=$(ZIMKPATH)/
endif

ifndef ZIMK__BASEDIR
ZIMK__BASEDIR:=$(CURDIR)
export ZIMK__BASEDIR
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
include $(ZIMKPATH)lib/uses.mk
include $(ZIMKPATH)lib/objs.mk
include $(ZIMKPATH)lib/dirs.mk
include $(ZIMKPATH)lib/deps.mk
include $(ZIMKPATH)lib/link.mk
include $(ZIMKPATH)lib/bin.mk
include $(ZIMKPATH)lib/lib.mk

ifndef MAKE_RESTARTS
ifneq ($(GIT),)
ifneq ($(filter-out $(NOBUILDTARGETS) install installsharedlibs \
	installstaticlibs,$(MAKECMDGOALS)),)
ifneq ($(shell $(GIT) rev-parse --is-inside-work-tree $(CMDNOERR)),)
ZIMKSUBMODULECFG:=$(shell $(READ) $(subst /,$(PSEP),$(ZIMKPATH)).git $(CMDNOERR))
ifeq ($(words $(ZIMKSUBMODULECFG)),2)
ZIMKSUBMODULEGITDIR:=$(realpath $(ZIMKPATH)$(lastword $(ZIMKSUBMODULECFG)))
ifneq ($(ZIMKSUBMODULEGITDIR),)
ifneq ($(wildcard $(ZIMKSUBMODULEGITDIR)/FETCH_HEAD),)
$(subst /,$(PSEP),$(ZIMKPATH))zimk.mk: $(ZIMKSUBMODULEGITDIR)/FETCH_HEAD
	$(VGIT)
	$(VR)$(GIT) submodule update $(ZIMKPATH)
	$(VR)$(call touch, $@)
endif
endif
endif
endif
endif
endif
endif

install:: $(DEFGOAL)
strip:: all

$(foreach v,CLEAN DISTCLEAN DISTCLEANDIRS \
	,$(eval $v:=$$(subst /,$$(PSEP),$$($v))))

define ZIMK__SUBBUILDRULES

$$(subst /,$$(PSEP),$$($1_TARGET)): $$(subst /,$$(PSEP),$$($1_PREREQ))
	+@$$(MAKE) -C $$(subst /,$$(PSEP),$$($1_SRCDIR)) \
		$$(subst /,$$(PSEP),$$($1_MAKEARGS)) $$($1_MAKEGOAL)

sub_$1_clean:
	+@$$(MAKE) -C $$(subst /,$$(PSEP),$$($1_SRCDIR)) \
		$$(subst /,$$(PSEP),$$($1_MAKEARGS)) \
		$$(or $$($1_CLEANGOAL),clean)

.PHONY: sub_$1_clean
CLEANGOALS+= sub_$1_clean
endef
$(foreach _S,$(SUBBUILD),$(eval $(call ZIMK__SUBBUILDRULES,$(_S))))

define ZIMK__CLEANLINE

$(ZIMK__TAB)$(VRM)
$(ZIMK__TAB)$(VR)$(call rmfile,$1)
endef
ZIMK__CLEANRECIPE=@:$(foreach f,$1\
	,$(eval _ZIMK_0:=$f)$(call ZIMK__CLEANLINE,$f))

clean:: $(CLEANGOALS)
	$(call ZIMK__CLEANRECIPE,$(CLEAN))

ZIMK__CONFIGS=$(foreach c,$(BUILDCFGS),.cache_$c.cfg $c.cfg) global.cfg
ZIMK__DISTCLEAN=$(BINBASEDIR) $(LIBBASEDIR) $(TESTBASEDIR) $(OBJBASEDIR)
define ZIMK__DISTCLEANLINE

$(ZIMK__TAB)$(VRMDR)
$(ZIMK__TAB)$(VR)$(call rmdir,$1)
endef
ZIMK__DISTCLEANRECIPE=@:$(foreach d,$1\
	,$(eval _ZIMK_0:=$d)$(call ZIMK__DISTCLEANLINE,$d))

distclean:: $(CLEANGOALS) $(DISTCLEANGOALS)
	$(call ZIMK__CLEANRECIPE,$(DISTCLEAN) $(ZIMK__CONFIGS))
	$(call ZIMK__DISTCLEANRECIPE,$(DISTCLEANDIRS) $(ZIMK__DISTCLEAN))

ifdef POSIXSHELL
DISTVERSIONPREFIX?=v
TAR:=$(call findtool,tar)
dist:
	@GIT="$(GIT)" TAR="$(TAR)" NODIST="$(NODIST)" $(SHELL) \
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
