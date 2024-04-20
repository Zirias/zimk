define ZIMK__USE_PKGCONFIG
endef

define ZIMK__USE_PKGCONFIG_POST
ifneq ($$(strip $$($(_T)_PKGDEPS)),)
ifneq ($(filter-out $(NOBUILDTARGETS),$(MAKECMDGOALS)),)
$(_T)_PKGSTATUS := $$(shell $$(PKGCONFIG) --exists '$$($(_T)_PKGDEPS)';\
	echo $$$$?)
ifneq ($$($(_T)_PKGSTATUS),0)
$$(error $$(shell $$(PKGCONFIG) --print-errors --exists '$$($(_T)_PKGDEPS)')\
Required packages for $(_T) not found)
endif
$(_T)_PKGCFLAGS := $$(shell $$(PKGCONFIG) --cflags '$$($(_T)_PKGDEPS)')
_$(_T)_CFLAGS += $$($(_T)_PKGCFLAGS)
_$(_T)_CXXFLAGS += $$($(_T)_PKGCFLAGS)
$(_T)_PKGLINKFLAGS += $$(shell $$(PKGCONFIG) --libs '$$($(_T)_PKGDEPS)')
endif
endif

ifneq ($$(strip $$($(_T)_PKGSTATICDEPS)),)
ifneq ($(filter-out $(NOBUILDTARGETS),$(MAKECMDGOALS)),)
$(_T)_PKGSTATUS := $$(shell $$(PKGCONFIG) --exists '$$($(_T)_PKGSTATICDEPS)';\
	echo $$$$?)
ifneq ($$($(_T)_PKGSTATUS),0)
$$(error $$(shell $$(PKGCONFIG) --print-errors\
	--exists '$$($(_T)_PKGSTATICDEPS)')\
Required packages for $(_T) not found)
endif
$(_T)_PKGCFLAGS := $$(shell $$(PKGCONFIG) --cflags '$$($(_T)_PKGSTATICDEPS)')
_$(_T)_CFLAGS += $$($(_T)_PKGCFLAGS)
_$(_T)_CXXFLAGS += $$($(_T)_PKGCFLAGS)
$(_T)_PKGSTATICLINKFLAGS += $$(shell $$(PKGCONFIG) --libs\
	'$$($(_T)_PKGSTATICDEPS)')
endif
endif
endef
