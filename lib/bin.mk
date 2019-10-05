define BINRULES
$(OBJRULES)

$(_T)_TARGET ?= $(_T)
$(_T)_TGTDIR ?= $$(BINDIR)
$(_T)_LIBDIR ?= $$(LIBDIR)
$(_T)_BUILDWITH ?= all
$(_T)_STRIPWITH ?= strip
$(_T)_INSTALLWITH ?= install
$(_T)_INSTALLDIRNAME ?= bin

$(BUILDDEPS)
$(LINKFLAGS)

$(_T)_EXE := $$($(_T)_TGTDIR)$$(PSEP)$$($(_T)_TARGET)$$(EXE)

$(_T): $$($(_T)_EXE)

.PHONY: $(_T) $(_T)_install

OUTFILES := $$($(_T)_EXE)
ifeq ($$(BFMT_PLATFORM),win32)
$(_T)_IMPLIB := $$($(_T)_LIBDIR)$$(PSEP)lib$(_T).dll.a
OUTFILES += $$($(_T)_IMPLIB)
endif
$(DIRRULES)

ifneq ($$(strip $$($(_T)_BUILDWITH)),)
$$($(_T)_BUILDWITH):: $(_T)

endif

ifneq ($$(strip $$($(_T)_INSTALLWITH)),)
$$($(_T)_INSTALLWITH):: $(_T)_install

endif

ifneq ($$(strip $$($(_T)_STRIPWITH)),)
$$($(_T)_STRIPWITH):: $$($(_T)_EXE)
	$$(VSTRP)
	$$(VR)$$(CROSS_COMPILE)$$(STRIP) --strip-all $$<

endif

ifeq ($$(BFMT_PLATFORM),win32)
$$($(_T)_EXE): $$($(_T)_OBJS) $$(_$(_T)_DEPS) | $$(_$(_T)_DIRS)
	$$(VCCLD)
	$$(VR)$$(CROSS_COMPILE)$$($$($(_T)_LINKERFRONT)) -o$$@ \
		-Wl,--out-implib,$$($(_T)_IMPLIB) \
		$$($(_T)_$$(PLATFORM)_LDFLAGS) $$($(_T)_LDFLAGS) $$(LDFLAGS) \
		$$($(_T)_OBJS) $$(_$(_T)_LINK)

else
$$($(_T)_EXE): $$($(_T)_OBJS) $$(_$(_T)_DEPS) | $$(_$(_T)_DIRS)
	$$(VCCLD)
	$$(VR)$$(CROSS_COMPILE)$$($$($(_T)_LINKERFRONT)) -o$$@ \
		$$($(_T)_$$(PLATFORM)_LDFLAGS) $$($(_T)_LDFLAGS) $$(LDFLAGS) \
		$$($(_T)_OBJS) $$(_$(_T)_LINK)

endif

$(_T)_install: $$($(_T)_EXE)
	$$(eval _ZIMK_1 := $$(DESTDIR)$$($$($(_T)_INSTALLDIRNAME)dir))
	$$(eval _ZIMK_0 := $$(_ZIMK_1)$$(PSEP)$$(<F))
	$$(VINST)
	$$(VR)$$(call instfile,$$<,$$(_ZIMK_1),755)

endef

# vim: noet:si:ts=8:sts=8:sw=8
