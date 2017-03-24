define LIBRULES
$(OBJRULES)

$(_T)_TARGET ?= $(_T)
$(_T)_V_MAJ ?= 1
$(_T)_V_MIN ?= 0
$(_T)_V_REV ?= 0
$(_T)_TGTDIR ?= $$(LIBDIR)
$(_T)_BINDIR ?= $$(BINDIR)
$(_T)_CFLAGS_SHARED ?= $$($(_T)_CFLAGS) -fPIC
$(_T)_BUILDWITH ?= all
$(_T)_BUILDSTATICWITH ?= staticlibs
$(_T)_STRIPWITH ?= strip

$(_T)_STATICLIB := $$($(_T)_TGTDIR)$$(PSEP)lib$(_T).a

$(BUILDDEPS)
$(LINKFLAGS)

ifeq ($$(PLATFORM),win32)
$(_T)_LIB := $$($(_T)_BINDIR)$$(PSEP)$(_T)-$$($(_T)_V_MAJ).dll

else
_$(_T)_V := $$($(_T)_V_MAJ).$$($(_T)_V_MIN).$$($(_T)_V_REV)
_$(_T)_LIB_FULL := $$($(_T)_TGTDIR)$$(PSEP)lib$(_T).so.$$(_$(_T)_V)
_$(_T)_LIB_MAJ := $$($(_T)_TGTDIR)$$(PSEP)lib$(_T).so.$$($(_T)_V_MAJ)
$(_T)_LIB := $$($(_T)_TGTDIR)$$(PSEP)lib$(_T).so

endif

OUTFILES := $$($(_T)_LIB) $$($(_T)_STATICLIB)
$(DIRRULES)

ifeq ($$(PLATFORM),win32)
$$($(_T)_STATICLIB): $$($(_T)_LIB)

$$($(_T)_LIB): $$($(_T)_SOBJS) $$(_$(_T)_DEPS) | $$(_$(_T)_DIRS)
	$$(VCCLD)
	$$(VR)$$(CROSS_COMPILE)$$(CC) -shared -o$$@ \
		-Wl,--out-implib,$$($(_T)_TGTDIR)$$(PSEP)lib$(_T).a \
		-Wl,--output-def,$$($(_T)_TGTDIR)$$(PSEP)$(_T).def \
		$$($(_T)_$$(PLATFORM)_CFLAGS) $$($(_T)_CFLAGS) $$(CFLAGS) \
		$$($(_T)_$$(PLATFORM)_LDFLAGS) $$($(_T)_LDFLAGS) $$(LDFLAGS) \
		$$($(_T)_SOBJS) $$(_$(_T)_LINK)

else
$$($(_T)_STATICLIB): $$($(_T)_OBJS) | $$(_$(_T)_DIRS)
	$$(VAR)
	$$(VR)$$(CROSS_COMPILE)$$(AR) rcs $$@1 $$^
	$$(VR)$$(RMF) $$@
	$$(VR)$$(MV) $$@1 $$@

$$($(_T)_LIB): $$(_$(_T)_LIB_MAJ)
	$$(VR)ln -fs lib$(_T).so.$$($(_T)_V_MAJ) $$@

$$(_$(_T)_LIB_MAJ): $$(_$(_T)_LIB_FULL)
	$$(VR)ln -fs lib$(_T).so.$$(_$(_T)_V) $$@

$$(_$(_T)_LIB_FULL): $$($(_T)_SOBJS) $$(_$(_T)_DEPS) | $$(_$(_T)_DIRS)
	$$(VCCLD)
	$$(VR)$$(CROSS_COMPILE)$$(CC) -shared -o$$@ \
		-Wl,-soname,lib$(_T).so.$$($(_T)_V_MAJ) \
		$$($(_T)_$$(PLATFORM)_CFLAGS) $$($(_T)_CFLAGS) $$(CFLAGS) \
		$$($(_T)_$$(PLATFORM)_LDFLAGS) $$($(_T)_LDFLAGS) $$(LDFLAGS) \
		$$($(_T)_SOBJS) $$(_$(_T)_LINK)

endif

$(_T): $$($(_T)_LIB)

static_$(_T): $$($(_T)_STATICLIB)

.PHONY: $(_T) static_$(_T)

ifneq ($$(strip $$($(_T)_BUILDWITH)),)
$$($(_T)_BUILDWITH):: $$($(_T)_LIB)

endif

ifneq ($$(strip $$($(_T)_BUILDSTATICWITH)),)
$$($(_T)_BUILDSTATICWITH):: $$($(_T)_STATICLIB)

endif

ifneq ($$(strip $$($(_T)_STRIPWITH)),)
$$($(_T)_STRIPWITH):: $$($(_T)_LIB)
	$$(VSTRP)
	$$(VR)$$(CROSS_COMPILE)$$(STRIP) --strip-unneeded $$<

ifneq ($$(strip $$($(_T)_BUILDSTATICWITH)),)
$$($(_T)_STRIPWITH):: $$($(_T)_STATICLIB)
	$$(VSTRP)
	$$(VR)$$(CROSS_COMPILE)$$(STRIP) --strip-unneeded $$<


endif

endif

endef

# vim: noet:si:ts=8:sts=8:sw=8
