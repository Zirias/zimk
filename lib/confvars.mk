define ZIMK__UNIQ
$(strip $(eval undefine __ZIMK__UNIQ__SEEN)$(foreach \
    _v,$1,$(if $(filter $(_v),$(__ZIMK__UNIQ__SEEN)),,$(eval \
        __ZIMK__UNIQ__SEEN += $(_v))))$(__ZIMK__UNIQ__SEEN))
endef
CROSSTOOLS += CC CXX CPP
FALLBACKTOOLS += AR STRIP OBJCOPY OBJDUMP WINDRES
HOSTTOOLS += GIT INSTALL $(addprefix HOST,$(CROSSTOOLS) $(FALLBACKTOOLS))
SINGLECONFVARS += prefix exec_prefix bindir sbindir libexecdir datarootdir \
		  sysconfdir sharedstatedir localstatedir runstatedir \
		  includedir docrootdir libdir localedir
BOOLCONFVARS_ON := $(call ZIMK__UNIQ,SHAREDLIBS $(BOOLCONFVARS_ON))
BOOLCONFVARS_OFF := $(call ZIMK__UNIQ,PORTABLE STATIC STATICLIBS HOSTBUILD \
		    $(BOOLCONFVARS_OFF))
BOOLCONFVARS := $(BOOLCONFVARS_ON) $(BOOLCONFVARS_OFF)
SINGLECONFVARS := $(call ZIMK__UNIQ,DEFGOAL SH HOSTSH CSTD CXXSTD \
		  $(HOSTTOOLS) $(CROSSTOOLS) $(FALLBACKTOOLS) $(SINGLECONFVARS))
LISTCONFVARS := $(call ZIMK__UNIQ,CFLAGS CXXFLAGS DEFINES INCLUDES LDFLAGS \
		$(LISTCONFVARS))
CONFVARS := $(BOOLCONFVARS) $(SINGLECONFVARS) $(LISTCONFVARS)
BUILDCFGS := $(call ZIMK__UNIQ,release debug $(BUILDCFGS))
NOBUILDTARGETS := $(sort clean distclean dist config changeconfig showconfig \
		  _build_config _build_changeconfig $(NOBUILDTARGETS))

$(foreach _cv,$(CONFVARS),$(if $($(_cv)),$(eval export $(_cv))))

ZIMK__EXPORTVARS := #
ifndef POSIXSHELL
$(foreach _cv,$(filter-out SH HOSTSH,$(CONFVARS)),$(if \
	$($(_cv)),$(eval ZIMK__EXPORTVARS := $(ZIMK__EXPORTVARS) $(_cv))))
endif

# vim: noet:si:ts=8:sts=8:sw=8
