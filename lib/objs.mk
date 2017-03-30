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

ifneq ($$(strip $$($(_T)_PLATFORMMODULES)),)
$(_T)_SOURCES += $$(addprefix $$($(_T)_SRCDIR)$$(PSEP), \
	$$(addsuffix _$$(PLATFORM).c,$$($(_T)_PLATFORMMODULES)))
$(_T)_OBJS += $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix _$$(PLATFORM).o,$$($(_T)_PLATFORMMODULES)))
$(_T)_SOBJS += $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix _$$(PLATFORM)_s.o,$$($(_T)_PLATFORMMODULES)))
endif

ifeq ($$(PLATFORM),win32)
ifneq ($$(strip $$($(_T)_win32_RES)),)
$(_T)_SOURCES += $$(addprefix $$($(_T)_SRCDIR)$$(PSEP), \
	$$(addsuffix .rc,$$($(_T)_win32_RES)))
$(_T)_OBJS += $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix .ro,$$($(_T)_win32_RES)))
endif
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

ifneq ($(filter-out $(NOBUILDTARGETS),$(MAKECMDGOALS)),)
-include $$($(_T)_OBJS:.o=.d)
endif

ifeq ($$(PLATFORM),win32)
$$($(_T)_OBJDIR)$$(PSEP)%.ro: $$($(_T)_SRCDIR)$$(PSEP)%.rc \
    $$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VRES)
	$$(VR)$$(CROSS_COMPILE)windres $$< $$@

endif

$$($(_T)_OBJDIR)$$(PSEP)%.o: $$($(_T)_SRCDIR)$$(PSEP)%.c \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VCC)
	$$(VR)$$(CROSS_COMPILE)$$(CC) -c -o$$@ \
		$$($(_T)_$$(PLATFORM)_CFLAGS) $$($(_T)_CFLAGS) $$(CFLAGS) \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) $$<

$$($(_T)_OBJDIR)$$(PSEP)%_s.o: $$($(_T)_SRCDIR)$$(PSEP)%.c \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VCC)
	$$(VR)$$(CROSS_COMPILE)$$(CC) -c -o$$@ \
		$$($(_T)_$$(PLATFORM)_CFLAGS_SHARED) $$($(_T)_CFLAGS_SHARED) \
		$$(CFLAGS) \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) $$<

endef

# vim: noet:si:ts=8:sts=8:sw=8
