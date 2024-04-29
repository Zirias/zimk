# man.mk -- compress and install manpages
#
# Configuration variables:
#
# GZIP		Name or full path to the 'gzip' tool
#		(default: gzip, searched in the initial PATH)
# mandir	Base installation directory for manpages
#		(default: $(datarootdir)/man)
# mansectdir	Installation directory for section manpages, with %s% replaced
#		by the section number/name
#		(default: $(mandir)/man%s%)
#
# Project variables:
#
# name_MANSUFX		Suffix for manpages, with %s% replaced by the section
#			number/name (default: .%s%)
# name_INSTALLMANWITH	Target to use for installing manpages
#			(default: install)
# name_MANSECT		Man sections of manpages for 'name' (e.g. "1")
#			(default: empty)
# name_MAN1 (_MAN2 ...)	Manpages for individual sections, without the suffix
#

SINGLECONFVARS += mandir mansectdir
HOSTTOOLS += GZIP
DEFAULT_GZIP ?= gzip

define ZIMK__USE_MAN_DIRS

mandir ?= $$(datarootdir)$$(PSEP)man
mansectdir ?= $$(mandir)$$(PSEP)man%s%
endef

define ZIMK__MAN_INST_RECIPE_LINE

$(ZIMK__TAB)$$(eval _ZIMK_1 := $$(DESTDIR)$$($(_T)_$1dir))
$(ZIMK__TAB)$$(eval _ZIMK_0 := $$(_ZIMK_1)$$(PSEP)$$(notdir $2).gz)
$(ZIMK__TAB)$$(VINST)
$(ZIMK__TAB)$$(VR)$$(call instfile,$2,$$(_ZIMK_1),664)
$(ZIMK__TAB)$$(VR)$$(GZIP) -9f $$(basename $$(_ZIMK_0))
endef

define ZIMK__USE_MAN
$(_T)_MANSUFX ?= .%s%
$(_T)_INSTALLMANWITH ?= install
$(_T)_mandir ?= $$(mandir)

$$(foreach s,$$($(_T)_MANSECT),$$(eval $(_T)_man$$sdir ?= $$$$(subst \
	%s%,$$s,$(mansectdir))))

$(_T)__ALLMAN := $$(foreach _S,$$($(_T)_MANSECT),$$($(_T)_MAN$$(_S)))
ifneq ($$(strip $$($(_T)__ALLMAN)),)
ifeq ($$(GZIP),)
$(_T)_install_man::
	$$(eval _ZIMK_0 := gzip not found, not compressing manpages)
	@$$(VWRN)

endif
$$(foreach _S,$$($(_T)_MANSECT),$$(if $$(strip \
	$$($(_T)_MAN$$(_S))),$$(eval $$(_T)_install_man:: $$(foreach \
	_M,$$(addsuffix $$(subst \
	%s%,$$(_S),$$($(_T)_MANSUFX)),$$($(_T)_MAN$$(_S))),$$(call \
	$$(if $$(GZIP),ZIMK__MAN_INST_RECIPE_LINE,ZIMK__INSTEXTRARECIPELINE) \
	,man$$(_S),$$($$(_T)_SRCDIR)$$(PSEP)$$(_M))))))

$$($(_T)_INSTALLMANWITH):: $(_T)_install_man
endif

.PHONY: $(_T)_install_man

endef

