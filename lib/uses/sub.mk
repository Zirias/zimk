# sub.mk -- Execute variable substitutions on input files
#
# This implements creating a file 'foo' from a file 'foo.in', replacing named
# variables enclosed in %% by given values, e.g. the string %%VERSION%% could
# be replaced with a value given for the variable VERSION.
#
# Project variables:
#
# name_SUB_FILES	A list of files to do substitutions in, without the
# 			.in suffix
# name_SUB_LIST		A list of variables to substitute in the form
# 			VAR=value.
#			The following default subsitutions are always appended:
#			VERSION=$(name_VERSION) V_MAJ=$(name_V_MAJ)
#			V_MIN=$(name_V_MIN) V_REV=$(name_V_REV) SH=$(SH)
#

define ZIMK__SUBRULE

$1: $1.in $$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE)
	$$(VSUB)
	$$(VR)$$(MAKE) --no-print-directory -f $$(ZIMKPATH)scripts/sub.mk \
		SUB_LIST="$$($(_T)_SUB_LIST)" $$< >$$@

$(_T)_prebuild: $1
endef

define ZIMK__USE_SUB
ifneq ($$(strip $$($(_T)_SUB_FILES)),)
CLEAN += $$(addprefix $$($(_T)_SRCDIR)$$(PSEP),$$($(_T)_SUB_FILES))
DISTCLEAN += $$(addprefix $$($(_T)_SRCDIR)$$(PSEP),$$($(_T)_SUB_FILES))
$(_T)_SUB_LIST += VERSION=$$($(_T)_VERSION) V_MAJ=$$($(_T)_V_MAJ) \
	V_MIN=$$($(_T)_V_MIN) V_REV=$$($(_T)_V_REV) SH=$$(SH)
$$(eval $$(foreach f,$$($(_T)_SUB_FILES),\
	$$(call ZIMK__SUBRULE,$$($(_T)_SRCDIR)$$(PSEP)$$(f))))
endif
endef

