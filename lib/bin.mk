define BINRULES
$(OBJRULES)

$(_T)_TARGET ?= $(_T)
$(_T)_TGTDIR ?= $$(BINDIR)
$(_T)_BUILDWITH ?= all
$(_T)_STRIPWITH ?= strip

$(BUILDDEPS)
$(LINKFLAGS)

$(_T)_EXE := $$($(_T)_TGTDIR)$$(PSEP)$$($(_T)_TARGET)$$(EXE)

$(_T): $$($(_T)_EXE)

.PHONY: $(_T)

OUTFILES := $$($(_T)_EXE)
$(DIRRULES)

ifneq ($$(strip $$($(_T)_BUILDWITH)),)
$$($(_T)_BUILDWITH):: $$($(_T)_EXE)

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

endef

# vim: noet:si:ts=8:sts=8:sw=8
