# preproc.mk -- Generic preprocessing mechanism
#
# This is subject to change as it currently only supports one single
# preprocessor per project, which is currently used by qt.mk for moc support.
#

define ZIMK__PREPROCRULE

$$($(_T)_OBJDIR)$$(PSEP)$1_$$(PREPROC_$$($(_T)_PREPROC)_suffix).$$(PREPROC_$$($(_T)_PREPROC)_outtype): \
		$$($(_T)_PPSRCDIR)$$(PSEP)$1$2.$$(PREPROC_$$($(_T)_PREPROC)_intype) \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) \
	| $$(_$(_T)_DIRS) $$($(_T)_DEPS)
	$$(VGEN)
	$$(VR)$$(PREPROC_$$($(_T)_PREPROC)_preproc) \
		$$($(_T)_PREPROCFLAGS) $$< >$$@
endef

define ZIMK__USE_PREPROC

ifneq ($$(strip $$($(_T)_PREPROC)),)
$(_T)_PPSRCDIR ?= $$($(_T)_SRCDIR)

$(_T)_OBJS += $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix _$$(PREPROC_$$($(_T)_PREPROC)_suffix).o, \
	$$($(_T)_PREPROCMODULES)))
$(_T)_SOBJS += $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix _$$(PREPROC_$$($(_T)_PREPROC)_suffix)_s.o, \
	$$($(_T)_PREPROCMODULES)))
$(_T)_OBJS += $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix _$$(PLATFORM)_$$(PREPROC_$$($(_T)_PREPROC)_suffix).o, \
	$$($(_T)_PLATFORMPREPROCMODULES)))
$(_T)_SOBJS += $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix _$$(PLATFORM)_$$(PREPROC_$$($(_T)_PREPROC)_suffix)_s.o, \
	$$($(_T)_PLATFORMPREPROCMODULES)))

$(_T)_PPSOURCES := $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix _$$(PREPROC_$$($(_T)_PREPROC)_suffix).$$(PREPROC_$$($(_T)_PREPROC)_outtype), \
	$$($(_T)_PREPROCMODULES))) \
	$$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix _$$(PLATFORM)_$$(PREPROC_$$($(_T)_PREPROC)_suffix).$$(PREPROC_$$($(_T)_PREPROC)_outtype), \
	$$($(_T)_PLATFORMPREPROCMODULES)))

$$(eval $$(foreach p,$$($(_T)_PREPROCMODULES),$$(call ZIMK__PREPROCRULE,$$p)))
$$(eval $$(foreach p,$$($(_T)_PLATFORMPREPROCMODULES),\
	$$(call ZIMK__PREPROCRULE,$$p,_$$(PLATFORM))))
CLEAN += $$($(_T)_PPSOURCES)

ifeq ($$(PREPROC_$$($(_T)_PREPROC)_outtype),c)
$$(eval $$(foreach m,$$($(_T)_PREPROCMODULES),\
	$$(call ZIMK__C_OBJRULES,$$m_$$(PREPROC_$$($(_T)_PREPROC)_suffix),OBJDIR)))
$$(eval $$(foreach m,$$($(_T)_PLATFORMPREPROCMODULES),\
	$$(call ZIMK__C_OBJRULES,$$m_$$(PREPROC_$$($(_T)_PREPROC)_suffix),OBJDIR,_$$(PLATFORM))))
else ifeq ($$(PREPROC_$$($(_T)_PREPROC)_outtype),cpp)
$$(eval $$(foreach m,$$($(_T)_PREPROCMODULES),\
	$$(call ZIMK__CXX_OBJRULES,$$m_$$(PREPROC_$$($(_T)_PREPROC)_suffix),OBJDIR)))
$$(eval $$(foreach m,$$($(_T)_PLATFORMPREPROCMODULES),\
	$$(call ZIMK__CXX_OBJRULES,$$m_$$(PREPROC_$$($(_T)_PREPROC)_suffix),OBJDIR,_$$(PLATFORM))))
else ifeq ($$(PREPROC_$$($(_T)_PREPROC)_outtype),S)
$$(eval $$(foreach m,$$($(_T)_PREPROCMODULES),\
	$$(call ZIMK__ASM_OBJRULES,$$m_$$(PREPROC_$$($(_T)_PREPROC)_suffix),OBJDIR)))
$$(eval $$(foreach m,$$($(_T)_PLATFORMPREPROCMODULES),\
	$$(call ZIMK__ASM_OBJRULES,$$m_$$(PREPROC_$$($(_T)_PREPROC)_suffix),OBJDIR,_$$(PLATFORM))))
endif
endif

endef
