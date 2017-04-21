define LINKFLAGS

undefine _$(_T)_LIBS
undefine _$(_T)_STATICLIBS

ifneq ($$(strip $$($(_T)_LIBS)),)
_$(_T)_LIBS += $$($(_T)_LIBS)
endif

ifneq ($$(strip $$($(_T)_STATICLIBS)),)
_$(_T)_STATICLIBS += $$($(_T)_STATICLIBS)
endif

ifneq ($$(strip $$($(_T)_$$(PLATFORM)_LIBS)),)
_$(_T)_LIBS += $$($(_T)_$$(PLATFORM)_LIBS)
endif

ifneq ($$(strip $$($(_T)_$$(PLATFORM)_STATICLIBS)),)
_$(_T)_STATICLIBS += $$($(_T)_$$(PLATFORM)_STATICLIBS)
endif

ifneq ($$(strip $$(_$(_T)_LIBS)),)
_$(_T)_LINK+=$$(addprefix -l,$$(_$(_T)_LIBS))
endif

ifneq ($$(strip $$(_$(_T)_STATICLIBS)),)
_$(_T)_LINK+=-Wl,-Bstatic $$(addprefix -l,$$(_$(_T)_STATICLIBS))
endif

endef
