define ZIMK__USES_INCLUDE
ifeq ($$(filter $1,$$(_ZIMK__USES_INCLUDED)),)
_USES_FILE := $$(wildcard $$(ZIMKPATH)lib/uses/$1.mk)
ifeq ($$(_USES_FILE),)
$$(error Unknown uses $1 requested)
endif
include $$(_USES_FILE)
_ZIMK__USES_INCLUDED += $1
_USES_VAR := ZIMK__USE_$$(call toupper,$1)
ZIMK__USES_DIRS := $$(ZIMK__USES_DIRS)$$($$(_USES_VAR)_DIRS)
$$(foreach d,$$($$(_USES_VAR)_DEPENDS),$$(eval $$(call ZIMK__USES_INCLUDE,$$d)))
endif
endef

define ZIMK__USES_LOAD
ifeq ($$(filter $1,$$(_ZIMK__USES_INCLUDED)),)
$$(error USES=$1 needs to be defined before including zimk)
endif
ifeq ($$(filter $1,$$(_$(_T)_USES_LOAD)),)
_USES_VAR := ZIMK__USE_$$(call toupper,$1)
$$(eval $$($$(_USES_VAR)))
_$(_T)_USES_POST := $$(_$(_T)_USES_POST) $$(_USES_VAR)_POST
_$(_T)_USES_LOAD += $1
endif
$$(foreach d,$$($$(_USES_VAR)_DEPENDS),$$(eval $$(call ZIMK__USES_LOAD,$$d)))
endef

define ZIMK__USES
$(_T)_USES ?= $$(USES)
$$(foreach u,$$($(_T)_USES),$$(eval $$(call ZIMK__USES_LOAD,$$u)))
$$(foreach p,$$(_$(_T)_USES_POST),$$(eval $$($$p)))
endef

$(foreach u,$(USES),$(eval $(call ZIMK__USES_INCLUDE,$u)))
