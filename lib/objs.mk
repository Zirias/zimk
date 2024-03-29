PREPROC_MOC_suffix := moc
PREPROC_MOC_intype := h
PREPROC_MOC_outtype := cpp
PREPROC_MOC_preproc := $(MOC)

ZIMK__EMPTY:=
ZIMK__COMMA:=,

define ZIMK__SUBRULE

$1: $1.in $$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE)
	$$(VSUB)
	$$(VR)$$(MAKE) --no-print-directory -f $$(ZIMKPATH)scripts/sub.mk \
		SUB_LIST="$$($(_T)_SUB_LIST)" $$< >$$@

$(_T)_sub: $1
endef

define ZIMK__GENRULE_EXP3

$2: $3 $1 $$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE)
	$$(VGEN)
	$$(VR)$1 $4
$(_T)_sub: $2
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

define ZIMK__PREPROCRULE

$$($(_T)_OBJDIR)$$(PSEP)$1_$$(PREPROC_$$($(_T)_PREPROC)_suffix).$$(PREPROC_$$($(_T)_PREPROC)_outtype): \
		$$($(_T)_PPSRCDIR)$$(PSEP)$1$2.$$(PREPROC_$$($(_T)_PREPROC)_intype) \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) \
	| $$(_$(_T)_DIRS) $$($(_T)_DEPS)
	$$(VGEN)
	$$(VR)$$(PREPROC_$$($(_T)_PREPROC)_preproc) \
		$$($(_T)_PREPROCFLAGS) $$< >$$@
endef

define ZIMK__C_OBJRULES

$$($(_T)_OBJDIR)$$(PSEP)$1$3.d: $$($(_T)_$2)$$(PSEP)$1$3.c $(_T)_sub \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VDEP)
	$$(VR)$$(CC) -MM -MT"$$@ $$(@:.d=.o)" -MF$$@ \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) $$($(_T)_$$(PLATFORM)_CFLAGS) $$($(_T)_CFLAGS) \
		$$(CFLAGS) $$<

$$($(_T)_OBJDIR)$$(PSEP)$1$3.o: $$($(_T)_$2)$$(PSEP)$1$3.c $(_T)_sub \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VCC)
	$$(VR)$$(CC) -c -o$$@ \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) \
		$$($(_T)_$$(PLATFORM)_CFLAGS_STATIC) $$($(_T)_CFLAGS_STATIC) \
		$$(CFLAGS_STATIC) \
		$$($(_T)_$$(PLATFORM)_CFLAGS) $$($(_T)_CFLAGS) $$(CFLAGS) \
		$$<

$$($(_T)_OBJDIR)$$(PSEP)$1$3_s.o: $$($(_T)_$2)$$(PSEP)$1$3.c $(_T)_sub \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VCC)
	$$(VR)$$(CC) -c -o$$@ \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) \
		$$($(_T)_$$(PLATFORM)_CFLAGS_SHARED) $$($(_T)_CFLAGS_SHARED) \
		$$(CFLAGS_SHARED) \
		$$($(_T)_$$(PLATFORM)_CFLAGS) $$($(_T)_CFLAGS) $$(CFLAGS) \
		$$<
endef

define ZIMK__CXX_OBJRULES

$$($(_T)_OBJDIR)$$(PSEP)$1$3.d: $$($(_T)_$2)$$(PSEP)$1$3.cpp $(_T)_sub \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VDEP)
	$$(VR)$$(CXX) -MM -MT"$$@ $$(@:.d=.o)" -MF$$@ \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) $$($(_T)_$$(PLATFORM)_CXXFLAGS) \
		$$($(_T)_CXXFLAGS) $$(CXXFLAGS) $$<

$$($(_T)_OBJDIR)$$(PSEP)$1$3.o: $$($(_T)_$2)$$(PSEP)$1$3.cpp $(_T)_sub \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VCXX)
	$$(VR)$$(CXX) -c -o$$@ \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) \
		$$($(_T)_$$(PLATFORM)_CXXFLAGS_STATIC) \
		$$($(_T)_CXXFLAGS_STATIC) $$(CXXFLAGS_STATIC) \
		$$($(_T)_$$(PLATFORM)_CXXFLAGS) $$($(_T)_CXXFLAGS) \
		$$(CXXFLAGS) $$<

$$($(_T)_OBJDIR)$$(PSEP)$1$3_s.o: $$($(_T)_$2)$$(PSEP)$1$3.cpp $(_T)_sub \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VCXX)
	$$(VR)$$(CXX) -c -o$$@ \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) \
		$$($(_T)_$$(PLATFORM)_CXXFLAGS_SHARED) \
		$$($(_T)_CXXFLAGS_SHARED) $$(CXXFLAGS_SHARED) \
		$$($(_T)_$$(PLATFORM)_CXXFLAGS) $$($(_T)_CXXFLAGS) \
		$$(CXXFLAGS) $$<
endef

define ZIMK__ASM_OBJRULES

$$($(_T)_OBJDIR)$$(PSEP)$1$3.d: $$($(_T)_$2)$$(PSEP)$1$3.S $(_T)_sub \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VDEP)
	$$(VR)$$(CC) -MM -MT"$$@ $$(@:.d=.o)" -MF$$@ \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) $$($(_T)_$$(PLATFORM)_CFLAGS) $$($(_T)_CFLAGS) \
		$$(CFLAGS) $$<

$$($(_T)_OBJDIR)$$(PSEP)$1$3.o: $$($(_T)_$2)$$(PSEP)$1$3.S $(_T)_sub \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VCAS)
	$$(VR)$$(CC) -c -o$$@ \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) \
		$$($(_T)_$$(PLATFORM)_CFLAGS_STATIC) $$($(_T)_CFLAGS_STATIC) \
		$$(CFLAGS_STATIC) \
		$$($(_T)_$$(PLATFORM)_CFLAGS) $$($(_T)_CFLAGS) $$(CFLAGS) \
		$$<

$$($(_T)_OBJDIR)$$(PSEP)$1$3_s.o: $$($(_T)_$2)$$(PSEP)$1$3.S $(_T)_sub \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VCAS)
	$$(VR)$$(CC) -c -o$$@ \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) \
		$$($(_T)_$$(PLATFORM)_CFLAGS_SHARED) $$($(_T)_CFLAGS_SHARED) \
		$$(CFLAGS_SHARED) \
		$$($(_T)_$$(PLATFORM)_CFLAGS) $$($(_T)_CFLAGS) $$(CFLAGS) \
		$$<
endef

define ZIMK__RESRULE

$$($(_T)_OBJDIR)$$(PSEP)$1.o: $$($(_T)_SRCDIR)$$(PSEP)$1$2 $(_T)_sub \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VGEN)
	$$(VR)$$(OBJCOPY) -Ibinary -O$(TARGETBFD) -B$(TARGETBARCH) $$< $$@

endef

ifeq ($(PLATFORM),win32)
define ZIMK__WINDRESRULE
CLEAN += $$($(_T)_OBJDIR)$$(PSEP)$1.o

$$($(_T)_OBJDIR)$$(PSEP)$1.o: $$($(_T)_SRCDIR)$$(PSEP)$1.rc $(_T)_sub \
    $$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VRES)
	$$(VR)$$(WINDRES) $$< $$@

endef
endif

define ZIMK__QRCRULES

$$($(_T)_OBJDIR)$$(PSEP)$1_qrc.cpp: \
		$$($(_T)_SRCDIR)$$(PSEP)$1.qrc $(_T)_sub \
		| $$(_$(_T)_DIRS)
	$$(VGEN)
	$$(VR)$$(RCC) -o $$@ --name $$(notdir $$(basename $$@)) $$<

$$($(_T)_OBJDIR)$$(PSEP)$1_qrc.o: \
		$$($(_T)_OBJDIR)$$(PSEP)$1_qrc.cpp $(_T)_sub \
		$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VCXX)
	$$(VR)$$(CXX) -c -o$$@ \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) $$($(_T)_$$(PLATFORM)_CXXFLAGS_STATIC) \
		$$($(_T)_CXXFLAGS_STATIC) $$(CXXFLAGS_STATIC) \
		$$($(_T)_$$(PLATFORM)_CXXFLAGS) $$($(_T)_CXXFLAGS) \
		$$(CXXFLAGS) $$<

$$($(_T)_OBJDIR)$$(PSEP)$1_qrc_s.o: \
		$$($(_T)_OBJDIR)$$(PSEP)$1_qrc.cpp $(_T)_sub \
		$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VCXX)
	$$(VR)$$(CXX) -c -o$$@ \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) $$($(_T)_$$(PLATFORM)_CXXFLAGS_SHARED) \
		$$($(_T)_CXXFLAGS_SHARED) $$(CXXFLAGS_SHARED) \
		$$($(_T)_$$(PLATFORM)_CXXFLAGS) $$($(_T)_CXXFLAGS) \
		$$(CXXFLAGS) $$<
endef

define ZIMK__DOCS_INST_RECIPE_LINE

$(ZIMK__TAB)$$(eval _ZIMK_1 := $$(DESTDIR)$$($(_T)_docdir))
$(ZIMK__TAB)$$(eval _ZIMK_0 := $$(_ZIMK_1)$$(PSEP)$(_D))
$(ZIMK__TAB)$$(VINST)
$(ZIMK__TAB)$$(VR)$$(call instfile,$(_D),$$(dir $$(_ZIMK_1)$$(PSEP)$(_D)),664)
endef

define ZIMK__INSTEXTRARECIPELINE

$(ZIMK__TAB)$$(eval _ZIMK_1 := $$(DESTDIR)$$($(_T)_$1dir))
$(ZIMK__TAB)$$(eval _ZIMK_0 := $$(_ZIMK_1)$$(PSEP)$$(notdir $2))
$(ZIMK__TAB)$$(VINST)
$(ZIMK__TAB)$$(VR)$$(call instfile,$2,$$(_ZIMK_1),664)
endef

define ZIMK__MAN_INST_RECIPE_LINE

$(ZIMK__TAB)$$(eval _ZIMK_1 := $$(DESTDIR)$$($(_T)_$1dir))
$(ZIMK__TAB)$$(eval _ZIMK_0 := $$(_ZIMK_1)$$(PSEP)$$(notdir $2).gz)
$(ZIMK__TAB)$$(VINST)
$(ZIMK__TAB)$$(VR)$$(call instfile,$2,$$(_ZIMK_1),664)
$(ZIMK__TAB)$$(VR)$$(GZIP) -9f $$(basename $$(_ZIMK_0))
endef

define OBJRULES

ifeq ($$($(_T)_VERSION),)
$(_T)_V_MAJ ?= 1
$(_T)_V_MIN ?= 0
$(_T)_V_REV ?= 0
$(_T)_VERSION := $$($(_T)_V_MAJ).$$($(_T)_V_MIN).$$($(_T)_V_REV)
else
$(_T)_V_MAJ := $$(call version_maj,$$($(_T)_VERSION))
$(_T)_V_MIN := $$(call version_min,$$($(_T)_VERSION))
$(_T)_V_REV := $$(call version_rev,$$($(_T)_VERSION))
endif
$(_T)_MAKEFILES ?= $$(ZIMK__MK)
$(_T)_SRCDIR ?= $$(patsubst %$$(PSEP),%,$$(ZIMK__DIR))
$(_T)_SRCDIR := $$(strip $$($(_T)_SRCDIR))
$(_T)_OBJDIR ?= $$(OBJDIR)$$(PSEP)$$($(_T)_SRCDIR)
$(_T)_OBJDIR := $$(patsubst %$$(PSEP),%,$$($(_T)_OBJDIR))
ifeq ($$($(_T)_SRCDIR),)
$(_T)_SRCDIR := .$$(PSEP)
endif
ifneq ($$(strip $$($(_T)_CXXMODULES) $$($(_T)_PLATFORMCXXMODULES)),)
$(_T)_LINKERFRONT ?= CXX
else
$(_T)_LINKERFRONT ?= CC
endif
$(_T)_MANSUFX ?= .%s%
$(_T)_INSTALLDOCSWITH ?= install
$(_T)_INSTALLMANWITH ?= install
$(_T)_INSTALLEXTRAWITH ?= install

ifeq ($(PORTABLE),1)
$(_T)_datadir ?= $$(datarootdir)
$(_T)_docdir ?= $$(docrootdir)
else
$(_T)_datadir ?= $$(datarootdir)$$(PSEP)$(_T)
$(_T)_docdir ?= $$(docrootdir)$$(PSEP)$(_T)
endif
$(_T)_localstatedir ?= $$(localstatedir)
$(_T)_runstatedir ?= $$(runstatedir)
$(_T)_sharedstatedir ?= $$(sharedstatedir)
$(_T)_sysconfdir ?= $$(sysconfdir)
$(_T)_mandir ?= $$(mandir)

$$(foreach s,$$($(_T)_MANSECT),$$(eval $(_T)_man$$sdir ?= $$$$(subst \
	%s%,$$s,$(mansectdir))))

ifneq ($$(strip $$($(_T)_PKGDEPS)),)
ifneq ($(filter-out $(NOBUILDTARGETS),$(MAKECMDGOALS)),)
$(_T)_PKGSTATUS := $$(shell $$(PKGCONFIG) --exists '$$($(_T)_PKGDEPS)';\
	echo $$$$?)
ifneq ($$($(_T)_PKGSTATUS),0)
$$(error $$(shell $$(PKGCONFIG) --print-errors --exists '$$($(_T)_PKGDEPS)')\
Required packages for $(_T) not found)
endif
$(_T)_PKGCFLAGS := $$(shell $$(PKGCONFIG) --cflags '$$($(_T)_PKGDEPS)')
$(_T)_CFLAGS += $$($(_T)_PKGCFLAGS)
$(_T)_CXXFLAGS += $$($(_T)_PKGCFLAGS)
$(_T)_PKGLINKFLAGS += $$(shell $$(PKGCONFIG) --libs '$$($(_T)_PKGDEPS)')
endif
endif

ifneq ($$(strip $$($(_T)_PKGSTATICDEPS)),)
ifneq ($(filter-out $(NOBUILDTARGETS),$(MAKECMDGOALS)),)
$(_T)_PKGSTATUS := $$(shell $$(PKGCONFIG) --exists '$$($(_T)_PKGSTATICDEPS)';\
	echo $$$$?)
ifneq ($$($(_T)_PKGSTATUS),0)
$$(error $$(shell $$(PKGCONFIG) --print-errors\
	--exists '$$($(_T)_PKGSTATICDEPS)')\
Required packages for $(_T) not found)
endif
$(_T)_PKGCFLAGS := $$(shell $$(PKGCONFIG) --cflags '$$($(_T)_PKGSTATICDEPS)')
$(_T)_CFLAGS += $$($(_T)_PKGCFLAGS)
$(_T)_CXXFLAGS += $$($(_T)_PKGCFLAGS)
$(_T)_PKGSTATICLINKFLAGS += $$(shell $$(PKGCONFIG) --libs\
	'$$($(_T)_PKGSTATICDEPS)')
endif
endif

$(_T)_SOURCES := $$(addprefix $$($(_T)_SRCDIR)$$(PSEP), \
	$$(addsuffix .c,$$($(_T)_MODULES)))
$(_T)_OBJS := $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix .o,$$($(_T)_MODULES)))
$(_T)_SOBJS := $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix _s.o,$$($(_T)_MODULES)))

ifneq ($$(strip $$($(_T)_CXXMODULES)),)
$(_T)_SOURCES += $$(addprefix $$($(_T)_SRCDIR)$$(PSEP), \
	$$(addsuffix .cpp,$$($(_T)_CXXMODULES)))
$(_T)_OBJS += $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix .o,$$($(_T)_CXXMODULES)))
$(_T)_SOBJS += $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix _s.o,$$($(_T)_CXXMODULES)))
endif

ifneq ($$(strip $$($(_T)_ASMMODULES)),)
$(_T)_SOURCES += $$(addprefix $$($(_T)_SRCDIR)$$(PSEP), \
	$$(addsuffix .S,$$($(_T)_ASMMODULES)))
$(_T)_OBJS += $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix .o,$$($(_T)_ASMMODULES)))
$(_T)_SOBJS += $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix _s.o,$$($(_T)_ASMMODULES)))
endif

ifneq ($$(strip $$($(_T)_RESFILES)),)
$(_T)_ROBJS += $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix .o,$$($(_T)_RESFILES)))
endif

ifneq ($$(strip $$($(_T)_PLATFORMMODULES)),)
$(_T)_SOURCES += $$(addprefix $$($(_T)_SRCDIR)$$(PSEP), \
	$$(addsuffix _$$(PLATFORM).c,$$($(_T)_PLATFORMMODULES)))
$(_T)_OBJS += $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix _$$(PLATFORM).o,$$($(_T)_PLATFORMMODULES)))
$(_T)_SOBJS += $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix _$$(PLATFORM)_s.o,$$($(_T)_PLATFORMMODULES)))
endif

ifneq ($$(strip $$($(_T)_PLATFORMCXXMODULES)),)
$(_T)_SOURCES += $$(addprefix $$($(_T)_SRCDIR)$$(PSEP), \
	$$(addsuffix _$$(PLATFORM).cpp,$$($(_T)_PLATFORMCXXMODULES)))
$(_T)_OBJS += $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix _$$(PLATFORM).o,$$($(_T)_PLATFORMCXXMODULES)))
$(_T)_SOBJS += $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix _$$(PLATFORM)_s.o,$$($(_T)_PLATFORMCXXMODULES)))
endif

ifneq ($$(strip $$($(_T)_PLATFORMASMMODULES)),)
$(_T)_SOURCES += $$(addprefix $$($(_T)_SRCDIR)$$(PSEP), \
	$$(addsuffix _$$(PLATFORM).S,$$($(_T)_PLATFORMASMMODULES)))
$(_T)_OBJS += $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix _$$(PLATFORM).o,$$($(_T)_PLATFORMASMMODULES)))
$(_T)_SOBJS += $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix _$$(PLATFORM)_s.o,$$($(_T)_PLATFORMASMMODULES)))
endif

ifneq ($$(strip $$($(_T)_PLATFORMRESFILES)),)
$(_T)_ROBJS += $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix _$$(PLATFORM).o,$$($(_T)_PLATFORMRESFILES)))
endif

ifeq ($$(PLATFORM),win32)
ifneq ($$(strip $$($(_T)_win32_RES)),)
$(_T)_SOURCES += $$(addprefix $$($(_T)_SRCDIR)$$(PSEP), \
	$$(addsuffix .rc,$$($(_T)_win32_RES)))
$(_T)_ROBJS += $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix .o,$$($(_T)_win32_RES)))
endif
endif

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
endif

ifneq ($$(strip $$($(_T)_QRC)),)
$(_T)_ROBJS += $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix _qrc.o,$$($(_T)_QRC)))
$(_T)_QRCSOURCE := $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix _qrc.cpp,$$($(_T)_QRC)))
CLEAN += $$($(_T)_QRCSOURCE)
endif

CLEAN += $$($(_T)_OBJS:.o=.d) $$($(_T)_OBJS)

OUTFILES := $$($(_T)_OBJS)
$(DIRRULES)

%.o: %.c

$$(eval $$(foreach m,$$($(_T)_MODULES),\
	$$(call ZIMK__C_OBJRULES,$$m,SRCDIR)))
$$(eval $$(foreach m,$$($(_T)_PLATFORMMODULES),\
	$$(call ZIMK__C_OBJRULES,$$m,SRCDIR,_$$(PLATFORM))))
$$(eval $$(foreach m,$$($(_T)_CXXMODULES),\
	$$(call ZIMK__CXX_OBJRULES,$$m,SRCDIR)))
$$(eval $$(foreach m,$$($(_T)_PLATFORMCXXMODULES),\
	$$(call ZIMK__CXX_OBJRULES,$$m,SRCDIR,_$$(PLATFORM))))
$$(eval $$(foreach m,$$($(_T)_ASMMODULES),\
	$$(call ZIMK__ASM_OBJRULES,$$m,SRCDIR)))
$$(eval $$(foreach m,$$($(_T)_PLATFORMASMMODULES),\
	$$(call ZIMK__ASM_OBJRULES,$$m,SRCDIR,_$$(PLATFORM))))
$$(eval $$(foreach r,$$($(_T)_RESFILES),$$(call ZIMK__RESRULE,$$r)))
$$(eval $$(foreach r,$$($(_T)_PLATFORMRESFILES),\
	$$(call ZIMK__RESRULE,$$r,_$$(PLATFORM))))
ifeq ($$(PLATFORM),win32)
$$(eval $$(foreach r,$$($(_T)_win32_RES),$$(call ZIMK__WINDRESRULE,$$r)))
endif


ifneq ($(filter-out $(NOBUILDTARGETS),$(MAKECMDGOALS)),)
ifneq ($$(strip $$($(_T)_MODULES) $$($(_T)_PLATFORMMODULES) \
	$$($(_T)_ASMMODULES) $$($(_T)_PLATFORMASMMODULES)),)
$$(if $$(CC),,$$(error No C compiler found!))
endif
ifneq ($$(strip $$($(_T)_CXXMODULES) $$($(_T)_PLATFORMCXXMODULES)),)
$$(if $$(CXX),,$$(error No C++ compiler found!))
endif
ifneq ($$(strip $$($(_T)_RESFILES) $$($(_T)_PLATFORMRESFILES)),)
$$(if $$(OBJCOPY),,$$(error No objcopy tool found!))
endif
ifeq ($$(PLATFORM),win32)
ifneq ($$(strip $$($(_T)_win32_RES)),)
$$(if $$(WINDRES),,$$(error No windres tool found!))
endif
endif
-include $$($(_T)_OBJS:.o=.d)
endif

ifneq ($$(strip $$($(_T)_PREPROC)),)
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

ifneq ($$(strip $$($(_T)_QRC)),)
$$(eval $$(foreach q,$$($(_T)_QRC),$$(call ZIMK__QRCRULES,$$q)))
endif

ifneq ($$(strip $$($(_T)_SUB_FILES)),)
CLEAN += $$(addprefix $$($(_T)_SRCDIR)$$(PSEP),$$($(_T)_SUB_FILES))
DISTCLEAN += $$(addprefix $$($(_T)_SRCDIR)$$(PSEP),$$($(_T)_SUB_FILES))
$(_T)_SUB_LIST += VERSION=$$($(_T)_VERSION) V_MAJ=$$($(_T)_V_MAJ) \
	V_MIN=$$($(_T)_V_MIN) V_REV=$$($(_T)_V_REV) SH=$$(SH)
$$(eval $$(foreach f,$$($(_T)_SUB_FILES),\
	$$(call ZIMK__SUBRULE,$$($(_T)_SRCDIR)$$(PSEP)$$(f))))
endif

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

ifeq ($$(strip $$($(_T)_SUB_FILES) $$($(_T)__ALLGEN)),)
$(_T)_sub: ;
endif

ifneq ($$(strip $$($(_T)_DOCS)),)
_$(_T)_DOCS_INSTALL := $$(subst /,$$(PSEP),$$($(_T)_DOCS))
$$(eval $$(_T)_install_docs: $$(_$$(_T)_DOCS_INSTALL)$$(foreach \
	_D,$$(_$$(_T)_DOCS_INSTALL),$$(ZIMK__DOCS_INST_RECIPE_LINE)))

$$($(_T)_INSTALLDOCSWITH):: $(_T)_install_docs
endif

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

ifneq ($$(strip $$($(_T)_EXTRADIRS)),)
$$(eval $$(_T)_installextra: $$(foreach \
	_D,$$($$(_T)_EXTRADIRS),$$(foreach \
	_F,$$($$(_T)_$$(_D)_FILES),$$(call \
	ZIMK__INSTEXTRARECIPELINE,$$(_D),$$($$(_T)_SRCDIR)$$(PSEP)$$(_F)))))

$$($(_T)_INSTALLEXTRAWITH):: $(_T)_installextra
endif

.PHONY: $(_T)_install_docs $(_T)_install_man $(_T)_installextra

endef

.SECONDARY:

# vim: noet:si:ts=8:sts=8:sw=8
