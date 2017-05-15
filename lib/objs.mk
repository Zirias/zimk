PREPROC_MOC_suffix := moc
PREPROC_MOC_intype := h
PREPROC_MOC_outtype := cpp
PREPROC_MOC_preproc := $(MOC)

define OBJRULES

$(_T)_MAKEFILES ?= $$(ZIMK__MK)
$(_T)_SRCDIR ?= $$(patsubst %$$(PSEP),%,$$(ZIMK__DIR))
$(_T)_SRCDIR := $$(strip $$($(_T)_SRCDIR))
$(_T)_OBJDIR ?= $$(OBJDIR)$$(PSEP)$$($(_T)_SRCDIR)

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

ifeq ($$(PLATFORM),win32)
ifneq ($$(strip $$($(_T)_win32_RES)),)
$(_T)_SOURCES += $$(addprefix $$($(_T)_SRCDIR)$$(PSEP), \
	$$(addsuffix .rc,$$($(_T)_win32_RES)))
$(_T)_OBJS += $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix .o,$$($(_T)_win32_RES)))
$(_T)_SOBJS += $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
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
	$$(addsuffix _$$(PREPROC_$$($(_T)_PREPROC)_suffix).c, \
	$$($(_T)_PREPROCMODULES))) \
	$$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix _$$(PLATFORM)_$$(PREPROC_$$($(_T)_PREPROC)_suffix).c, \
	$$($(_T)_PLATFORMPREPROCMODULES)))

CLEAN += $$($(_T)_PPSOURCES)

$$($(_T)_OBJDIR)$$(PSEP)%_$$(PREPROC_$$($(_T)_PREPROC)_suffix).$$(PREPROC_$$($(_T)_PREPROC)_outtype): \
		$$($(_T)_PPSRCDIR)$$(PSEP)%.$$(PREPROC_$$($(_T)_PREPROC)_intype) \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) \
	| $$(_$(_T)_DIRS) $$($(_T)_DEPS)
	$$(VGEN)
	$$(VR)$$(PREPROC_$$($(_T)_PREPROC)_preproc) \
		$$($(_T)_PREPROCFLAGS) $$< >$$@

endif

CLEAN += $$($(_T)_OBJS:.o=.d) $$($(_T)_OBJS)

OUTFILES := $$($(_T)_OBJS)
$(DIRRULES)

%.o: %.c

$$($(_T)_OBJDIR)$$(PSEP)%.d: $$($(_T)_SRCDIR)$$(PSEP)%.c \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VDEP)
	$$(VR)$$(CROSS_COMPILE)$$(CC) -MM -MT"$$@ $$(@:.d=.o)" -MF$$@ \
		$$($(_T)_$$(PLATFORM)_CFLAGS) $$($(_T)_CFLAGS) $$(CFLAGS) \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) $$<

$$($(_T)_OBJDIR)$$(PSEP)%.d: $$($(_T)_SRCDIR)$$(PSEP)%.cpp \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VDEP)
	$$(VR)$$(CROSS_COMPILE)$$(CXX) -MM -MT"$$@ $$(@:.d=.o)" -MF$$@ \
		$$($(_T)_$$(PLATFORM)_CXXFLAGS) $$($(_T)_CXXFLAGS) $$(CXXFLAGS) \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) $$<

$$($(_T)_OBJDIR)$$(PSEP)%.d: $$($(_T)_SRCDIR)$$(PSEP)%.S \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VDEP)
	$$(VR)$$(CROSS_COMPILE)$$(CC) -MM -MT"$$@ $$(@:.d=.o)" -MF$$@ \
		$$($(_T)_$$(PLATFORM)_CFLAGS) $$($(_T)_CFLAGS) $$(CFLAGS) \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) $$<

$$($(_T)_OBJDIR)$$(PSEP)%.d: $$($(_T)_SRCDIR)$$(PSEP)%.rc \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VDEP)
	$$(VR)$$(CROSS_COMPILE)$$(CPP) -MM -MT"$$@ $$(@:.d=.o)" -MF$$@ \
		$$($(_T)_$$(PLATFORM)_CFLAGS) $$($(_T)_CFLAGS) $$(CFLAGS) \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) $$<

ifneq ($(filter-out $(NOBUILDTARGETS),$(MAKECMDGOALS)),)
-include $$($(_T)_OBJS:.o=.d)
endif

ifeq ($$(PLATFORM),win32)
$$($(_T)_OBJDIR)$$(PSEP)%.o: $$($(_T)_SRCDIR)$$(PSEP)%.rc \
    $$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VRES)
	$$(VR)$$(CROSS_COMPILE)windres $$< $$@

endif

$$($(_T)_OBJDIR)$$(PSEP)%.o: $$($(_T)_SRCDIR)$$(PSEP)%.c \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VCC)
	$$(VR)$$(CROSS_COMPILE)$$(CC) -c -o$$@ \
		$$($(_T)_$$(PLATFORM)_CFLAGS_STATIC) $$($(_T)_CFLAGS_STATIC) \
		$$(CFLAGS_STATIC) \
		$$($(_T)_$$(PLATFORM)_CFLAGS) $$($(_T)_CFLAGS) $$(CFLAGS) \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) $$<

$$($(_T)_OBJDIR)$$(PSEP)%_s.o: $$($(_T)_SRCDIR)$$(PSEP)%.c \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VCC)
	$$(VR)$$(CROSS_COMPILE)$$(CC) -c -o$$@ \
		$$($(_T)_$$(PLATFORM)_CFLAGS_SHARED) $$($(_T)_CFLAGS_SHARED) \
		$$(CFLAGS_SHARED) \
		$$($(_T)_$$(PLATFORM)_CFLAGS) $$($(_T)_CFLAGS) $$(CFLAGS) \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) $$<

$$($(_T)_OBJDIR)$$(PSEP)%.o: $$($(_T)_SRCDIR)$$(PSEP)%.cpp \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VCXX)
	$$(VR)$$(CROSS_COMPILE)$$(CXX) -c -o$$@ \
		$$($(_T)_$$(PLATFORM)_CXXFLAGS_STATIC) $$($(_T)_CXXFLAGS_STATIC) \
		$$(CXXFLAGS_STATIC) \
		$$($(_T)_$$(PLATFORM)_CXXFLAGS) $$($(_T)_CXXFLAGS) $$(CXXFLAGS) \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) $$<

$$($(_T)_OBJDIR)$$(PSEP)%_s.o: $$($(_T)_SRCDIR)$$(PSEP)%.cpp \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VCXX)
	$$(VR)$$(CROSS_COMPILE)$$(CXX) -c -o$$@ \
		$$($(_T)_$$(PLATFORM)_CXXFLAGS_SHARED) $$($(_T)_CXXFLAGS_SHARED) \
		$$(CXXFLAGS_SHARED) \
		$$($(_T)_$$(PLATFORM)_CXXFLAGS) $$($(_T)_CXXFLAGS) $$(CXXFLAGS) \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) $$<

$$($(_T)_OBJDIR)$$(PSEP)%.o: $$($(_T)_SRCDIR)$$(PSEP)%.S \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VCAS)
	$$(VR)$$(CROSS_COMPILE)$$(CC) -c -o$$@ \
		$$($(_T)_$$(PLATFORM)_CFLAGS_STATIC) $$($(_T)_CFLAGS_STATIC) \
		$$(CFLAGS_STATIC) \
		$$($(_T)_$$(PLATFORM)_CFLAGS) $$($(_T)_CFLAGS) $$(CFLAGS) \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) $$<

$$($(_T)_OBJDIR)$$(PSEP)%_s.o: $$($(_T)_SRCDIR)$$(PSEP)%.S \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VCAS)
	$$(VR)$$(CROSS_COMPILE)$$(CC) -c -o$$@ \
		$$($(_T)_$$(PLATFORM)_CFLAGS_SHARED) $$($(_T)_CFLAGS_SHARED) \
		$$(CFLAGS_SHARED) \
		$$($(_T)_$$(PLATFORM)_CFLAGS) $$($(_T)_CFLAGS) $$(CFLAGS) \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) $$<

ifneq ($$(strip $$($(_T)_PREPROC)),)
$$($(_T)_OBJDIR)$$(PSEP)%_$$(PREPROC_$$($(_T)_PREPROC)_suffix).o: \
		$$($(_T)_OBJDIR)$$(PSEP)%_$$(PREPROC_$$($(_T)_PREPROC)_suffix).c \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VCC)
	$$(VR)$$(CROSS_COMPILE)$$(CC) -c -o$$@ \
		$$($(_T)_$$(PLATFORM)_CFLAGS_STATIC) $$($(_T)_CFLAGS_STATIC) \
		$$(CFLAGS_STATIC) \
		$$($(_T)_$$(PLATFORM)_CFLAGS) $$($(_T)_CFLAGS) $$(CFLAGS) \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) $$<

$$($(_T)_OBJDIR)$$(PSEP)%_$$(PREPROC_$$($(_T)_PREPROC)_suffix)_s.o: \
		$$($(_T)_OBJDIR)$$(PSEP)%_$$(PREPROC_$$($(_T)_PREPROC)_suffix).c \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VCC)
	$$(VR)$$(CROSS_COMPILE)$$(CC) -c -o$$@ \
		$$($(_T)_$$(PLATFORM)_CFLAGS_SHARED) $$($(_T)_CFLAGS_SHARED) \
		$$(CFLAGS_SHARED) \
		$$($(_T)_$$(PLATFORM)_CFLAGS) $$($(_T)_CFLAGS) $$(CFLAGS) \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) $$<

$$($(_T)_OBJDIR)$$(PSEP)%_$$(PREPROC_$$($(_T)_PREPROC)_suffix).o: \
		$$($(_T)_OBJDIR)$$(PSEP)%_$$(PREPROC_$$($(_T)_PREPROC)_suffix).cpp \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VCXX)
	$$(VR)$$(CROSS_COMPILE)$$(CC) -c -o$$@ \
		$$($(_T)_$$(PLATFORM)_CXXFLAGS_STATIC) $$($(_T)_CXXFLAGS_STATIC) \
		$$(CXXFLAGS_STATIC) \
		$$($(_T)_$$(PLATFORM)_CXXFLAGS) $$($(_T)_CXXFLAGS) $$(CXXFLAGS) \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) $$<

$$($(_T)_OBJDIR)$$(PSEP)%_$$(PREPROC_$$($(_T)_PREPROC)_suffix)_s.o: \
		$$($(_T)_OBJDIR)$$(PSEP)%_$$(PREPROC_$$($(_T)_PREPROC)_suffix).cpp \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VCXX)
	$$(VR)$$(CROSS_COMPILE)$$(CC) -c -o$$@ \
		$$($(_T)_$$(PLATFORM)_CXXFLAGS_SHARED) $$($(_T)_CXXFLAGS_SHARED) \
		$$(CXXFLAGS_SHARED) \
		$$($(_T)_$$(PLATFORM)_CXXFLAGS) $$($(_T)_CXXFLAGS) $$(CXXFLAGS) \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) $$<

$$($(_T)_OBJDIR)$$(PSEP)%_$$(PREPROC_$$($(_T)_PREPROC)_suffix).o: \
		$$($(_T)_OBJDIR)$$(PSEP)%_$$(PREPROC_$$($(_T)_PREPROC)_suffix).S \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VCC)
	$$(VR)$$(CROSS_COMPILE)$$(CC) -c -o$$@ \
		$$($(_T)_$$(PLATFORM)_CFLAGS_STATIC) $$($(_T)_CFLAGS_STATIC) \
		$$(CFLAGS_STATIC) \
		$$($(_T)_$$(PLATFORM)_CFLAGS) $$($(_T)_CFLAGS) $$(CFLAGS) \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) $$<

$$($(_T)_OBJDIR)$$(PSEP)%_$$(PREPROC_$$($(_T)_PREPROC)_suffix)_s.o: \
		$$($(_T)_OBJDIR)$$(PSEP)%_$$(PREPROC_$$($(_T)_PREPROC)_suffix).S \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VCC)
	$$(VR)$$(CROSS_COMPILE)$$(CC) -c -o$$@ \
		$$($(_T)_$$(PLATFORM)_CFLAGS_SHARED) $$($(_T)_CFLAGS_SHARED) \
		$$(CFLAGS_SHARED) \
		$$($(_T)_$$(PLATFORM)_CFLAGS) $$($(_T)_CFLAGS) $$(CFLAGS) \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) $$<

endif
endef

.SECONDARY:

# vim: noet:si:ts=8:sts=8:sw=8
