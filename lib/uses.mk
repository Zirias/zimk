define ZIMK__USES_LOAD
ifeq ($$(filter $1,(_$(_T)_USES_INCLUDED)),)
_USES_VAR := ZIMK__USE_$$(call toupper,$1)
ifndef $$(_USES_VAR)
_USES_FILE := $$(wildcard $$(ZIMKPATH)lib/uses/$1.mk)
ifeq ($$(_USES_FILE),)
$$(error Unknown uses $1 requested in $(_T)_USES)
endif
include $$(_USES_FILE)
endif
$$(eval $$($$(_USES_VAR)))
ifdef $$(_USES_VAR)_POST
_$(_T)_USES_POST += $$($$(_USES_VAR)_POST)
endif
_$(_T)_USES_INCLUDED += $1
endif
$$(foreach d,$$($$(_USES_VAR)_DEPENDS),$$(eval $$(call ZIMK__USES_LOAD,$$d)))
endef

define ZIMK__USES
$(foreach u,$($(_T)_USES),$(eval $(call ZIMK__USES_LOAD,$u)))
$(eval $(_$(_T)_USES_POST))
endef
