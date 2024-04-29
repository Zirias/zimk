# preproc.mk -- Generic preprocessing mechanism
#
# This allows running some preprocessing tool on source files before they are
# compiled. In contrast to gen.mk, the focus is on actual preprocessing, so
# output and input names may only differ in extension and optional
# prefix/suffix and there's the possibility to automatically add the result
# to the build. This is used by qt.mk to implement moc support.
#
# Project variables:
#
#   defining a preprocessor:
#
# PREPROC_FOO_tool	The tool to call for preprocessor "FOO"
# PREPROC_FOO_args	A make function for the tool's commandline arguments.
# 			$1 is the output file, $2 the input file.
# 			(default: >$1 <$2)
# PREPROC_FOO_prefix	Optional prefix for the output name (default: unset)
# PREPROC_FOO_suffix	Optional suffix for the output name (default: unset)
# PREPROC_FOO_intype	Type (extension without dot) of input files
# PREPROC_FOO_outtype	Type (extension without dot) of output files
# PREPROC_FOO_addbuild	If set, the output files are automatically added to
# 			the build. For this to work, PREPROC_FOO_outtype must
# 			be one of c (C source), cpp (C++ source) or S
# 			(assembly source).
# 			(default: unset)
#
#   using a preprocessor:
#
# name_PREPROC		A list of preprocessors to use for project "name",
#			example: name_PREPROC=FOO
# name_FOO_SRCDIR	Source directory for files to be processed with
#			preprocessor FOO.
#			(default: $(name_SRCDIR))
# name_FOO_MODULES	Modules (base names without extension) to preprocess
#			with preprocessor FOO.
#

define ZIMK__PREPROCRULE_EXP1

$$($(_T)_OBJDIR)$$(PSEP)$2: $$($(_T)_$1_SRCDIR)$$(PSEP)$3 \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) \
	| $$(_$(_T)_DIRS) $$($(_T)_DEPS)
	$$(VGEN)
	$$(VR)$4 $$(call $5,$$@,$$<)
endef

ZIMK__PREPROC_DEFARGS = >$1 <$2
ZIMK__PREPROC_INFILE = $1.$(PREPROC_$2_intype)
ZIMK__PREPROC_OUTNM = $(PREPROC_$2_prefix)$1$(PREPROC_$2_suffix)
ZIMK__PREPROC_OUTFILE = $(call ZIMK__PREPROC_OUTNM,$1,$2).$(PREPROC_$2_outtype)

ZIMK__PREPROCRULE = $(call ZIMK__PREPROCRULE_EXP1,$2,$(call \
		    ZIMK__PREPROC_OUTFILE,$1,$2),$(call \
		    ZIMK__PREPROC_INFILE,$1,$2),$(PREPROC_$2_tool),$(if \
		    $(PREPROC_$2_args),PREPROC_$2_args,ZIMK__PREPROC_DEFARGS))

define ZIMK__ADD_PREPROC
$(_T)_$1_SRCDIR ?= $$($(_T)_SRCDIR)
ifneq ($$(PREPROC_$1_addbuild),)
$(_T)_OBJS += $$(foreach p,$$($(_T)_$1_MODULES),\
	$$($(_T)_OBJDIR)$$(PSEP)$$(call ZIMK__PREPROC_OUTNM,$$p,$1).o)
$(_T)_SOBJS += $$(foreach p,$$($(_T)_$1_MODULES),\
	$$($(_T)_OBJDIR)$$(PSEP)$$(call ZIMK__PREPROC_OUTNM,$$p,$1)_s.o)
ifeq ($$(PREPROC_$1_outtype),c)
$$(eval $$(foreach p,$$($(_T)_$1_MODULES),$$(call \
	ZIMK__C_OBJRULES,$$(call ZIMK__PREPROC_OUTNM,$$p,$1),OBJDIR)))
else ifeq ($$(PREPROC_$1_outtype),cpp)
$$(eval $$(foreach p,$$($(_T)_$1_MODULES),$$(call \
	ZIMK__CXX_OBJRULES,$$(call ZIMK__PREPROC_OUTNM,$$p,$1),OBJDIR)))
else ifeq ($$(PREPROC_$1_outtype),S)
$$(eval $$(foreach p,$$($(_T)_$1_MODULES),$$(call \
	ZIMK__ASM_OBJRULES,$$(call ZIMK__PREPROC_OUTNM,$$p,$1),OBJDIR)))
endif
endif
CLEAN += $$(foreach p,$$($(_T)_$1_MODULES),$$($(_T)_OBJDIR)$$(PSEP)$$(call \
	 ZIMK__PREPROC_OUTFILE,$$p,$1))
$$(eval $$(foreach p,$$($(_T)_$1_MODULES),$$(call ZIMK__PREPROCRULE,$$p,$1)))
endef

define ZIMK__USE_PREPROC
$$(eval $$(foreach p,$$($(_T)_PREPROC),$$(call ZIMK__ADD_PREPROC,$$p)))
endef

