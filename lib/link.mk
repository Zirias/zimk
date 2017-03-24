define LINKFLAGS

ifneq ($$(strip $$($(_T)_STATICLIBS)),)
_$(_T)_LINK+=-Wl,-Bstatic $$(addprefix -l,$$($(_T)_STATICLIBS)) -Wl,-Bdynamic
endif

ifneq ($$(strip $$($(_T)_LIBS)),)
_$(_T)_LINK+=$$(addprefix -l,$$($(_T)_LIBS))
endif

ifneq ($$(strip $$($(_T)_$$(PLATFORM)_LIBS)),)
_$(_T)_LINK+=$$(addprefix -l,$$($(_T)_$$(PLATFORM)_LIBS))
endif

endef
