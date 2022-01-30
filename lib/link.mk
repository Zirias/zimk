define LINKFLAGS

undefine _$(_T)_STATICLIBS
undefine _$(_T)_LIBS

ifneq ($$(strip $$($(_T)_STATICLIBS)),)
_$(_T)_STATICLIBS += $$($(_T)_STATICLIBS)
endif

ifneq ($$(strip $$($(_T)_LIBS)),)
_$(_T)_LIBS += $$($(_T)_LIBS)
endif

ifneq ($$(strip $$($(_T)_$$(PLATFORM)_STATICLIBS)),)
_$(_T)_STATICLIBS += $$($(_T)_$$(PLATFORM)_STATICLIBS)
endif

ifneq ($$(strip $$($(_T)_$$(BFMT_PLATFORM)_STATICLIBS)),)
_$(_T)_STATICLIBS += $$($(_T)_$$(BFMT_PLATFORM)_STATICLIBS)
endif

ifneq ($$(strip $$($(_T)_$$(PLATFORM)_LIBS)),)
_$(_T)_LIBS += $$($(_T)_$$(PLATFORM)_LIBS)
endif

ifneq ($$(strip $$($(_T)_$$(BFMT_PLATFORM)_LIBS)),)
_$(_T)_LIBS += $$($(_T)_$$(BFMT_PLATFORM)_LIBS)
endif

ifdef STATIC
$(_T)_STATIC:=1
endif

ifdef $(_T)_STATIC
_$(_T)_LINK+=-static
endif

ifneq ($$(strip $$(_$(_T)_STATICLIBS)),)
ifdef $(_T)_STATIC
_$(_T)_LINK+=$$(addprefix -l,$$(_$(_T)_STATICLIBS))
else
_$(_T)_LINK+=-Wl,-Bstatic $$(addprefix -l,$$(_$(_T)_STATICLIBS)) -Wl,-Bdynamic
endif
endif

ifneq ($$(strip $$(_$(_T)_LIBS)),)
_$(_T)_LINK+=$$(addprefix -l,$$(_$(_T)_LIBS))
endif

ifneq ($$(strip $$($(_T)_PKGSTATICLINKFLAGS)),)
ifdef $(_T)_STATIC
_$(_T)_LINK+=$$($(_T)_PKGSTATICLINKFLAGS)
else
_$(_T)_LINK+=-Wl,-Bstatic $$($(_T)_PKGSTATICLINKFLAGS) -Wl,-Bdynamic
endif
endif

ifneq ($$(strip $$($(_T)_PKGLINKFLAGS)),)
_$(_T)_LINK+=$$($(_T)_PKGLINKFLAGS)
endif

endef
