# gen.mk -- Generic mechanism for generating files during build
#
# This allows generating arbitrary files by calling external tools.
#
# Project variables:
#
#   defining a generator:
#
# GEN_FOO_tool		The tool to call for generator "FOO"
# GEN_FOO_args		A make function for the tool's commandline arguments.
# 			$1 is the output file, $2 .. $n are input files.
# 			(default: >$1 <$2)
# GEN_FOO_obj		If set, generator "FOO" creates files in the project's
# 			object dir, otherwise in the source dir.
# 			(default: unset)
#
#   using a generator:
#
# name_GEN		A list of generators to use for project "name",
#			example: name_GEN=FOO
# name_FOO_FILES	A list of files to process with generator "FOO"
# 			in the form:
# 			<output>:<input_1>[:<input_2>[:...[<input_n>]]]
#

ZIMK__EMPTY:=
ZIMK__COMMA:=,

define ZIMK__GENRULE_EXP3

$2: $3 $1 $$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE)
	$$(VGEN)
	$$(VR)$1 $4
$(_T)_prebuild: $2
endef
ZIMK__GENRULE_EXP2=$(call ZIMK__GENRULE_EXP3,$(subst \
		   /,$(PSEP),$(GEN_$1_tool)),$2,$3,$(if \
		   $(GEN_$1_args),$$(call GEN_$1_args,$2,$(subst \
		   $(ZIMK__EMPTY) ,$(ZIMK__COMMA),$3)),>$2 <$3))
ZIMK__GENRULE_EXP1=$(call ZIMK__GENRULE_EXP2,$1,$($(_T)_$(if \
		   $(GEN_$1_obj),OBJ,SRC)DIR)$(PSEP)$(firstword \
		   $2),$(addprefix $($(_T)_SRCDIR)$(PSEP),$(wordlist \
		   2,$(words $2),$2)))
ZIMK__GENRULE=$(call ZIMK__GENRULE_EXP1,$1,$(subst :, ,$2))

define ZIMK__USE_GEN

$(_T)__ALLGEN :=
ifneq ($$(strip $$($(_T)_GEN)),)
$(_T)__ALLGEN := $$(foreach _G,$$($(_T)_GEN),$$(addprefix \
	$$($(_T)_$$(if $$(GEN_$$(_G)_obj),OBJ,SRC)DIR)$$(PSEP),$$(foreach \
	_P,$$($(_T)_$$(_G)_FILES),$$(firstword $$(subst :, ,$$(_P))))))
ifneq ($$(strip $$($(_T)__ALLGEN)),)
CLEAN += $$($(_T)__ALLGEN)
DISTCLEAN += $$($(_T)__ALLGEN)
$$(eval $$(foreach _G,$$($(_T)_GEN),$$(foreach \
	_P,$$($(_T)_$$(_G)_FILES),$$(call \
	ZIMK__GENRULE,$$(_G),$$(_P)))))
endif
endif
endef
