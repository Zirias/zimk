define BINRULES
$(OBJRULES)

$(_T)_TARGET ?= $(_T)
$(_T)_TGTDIR ?= $$(BINDIR)
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

$$($(_T)_EXE): $$($(_T)_OBJS) $$(_$(_T)_DEPS) | $$(_$(_T)_DIRS)
	$$(VCCLD)
	$$(VR)$$(CROSS_COMPILE)$$(CC) -o$$@ \
		$$($(_T)_$$(PLATFORM)_CFLAGS) $$($(_T)_CFLAGS) $$(CFLAGS) \
		$$($(_T)_$$(PLATFORM)_LDFLAGS) $$($(_T)_LDFLAGS) $$(LDFLAGS) \
		$$($(_T)_OBJS) $$(_$(_T)_LINK)

$(_T)_install: $$($(_T)_EXE)
	$$(eval _ZIMK_1 := $$(DESTDIR)$$($$($(_T)_INSTALLDIRNAME)dir))
	$$(eval _ZIMK_0 := $$(_ZIMK_1)$$(PSEP)$$(<F))
	$$(VINST)
	$$(VR)$$(call instfile,$$<,$$(_ZIMK_1),755)

endef

# vim: noet:si:ts=8:sts=8:sw=8
