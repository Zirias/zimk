define BINRULES
$(_T)_TARGET ?= $(_T)
$(_T)_LIBDIR ?= $$(LIBDIR)
$(_T)_BUILDWITH ?= all
ifeq ($$($(_T)_NOBUILD),1)
$(_T)_TGTDIR ?= $$($(_T)_SRCDIR)
else
$(_T)_TGTDIR ?= $$(BINDIR)
$(_T)_STRIPWITH ?= strip
endif
$(_T)_INSTALLWITH ?= install
$(_T)_INSTALLDIRNAME ?= bin
$(_T)_MANSECT ?= 1

$(OBJRULES)
$(BUILDDEPS)
$(LINKFLAGS)

$(_T)_EXE := $$($(_T)_TGTDIR)$$(PSEP)$$($(_T)_TARGET)$$(EXE)
$(_T)_STRPSTAMP := $$($(_T)_TGTDIR)$$(PSEP).$$($(_T)_TARGET)$$(EXE).stripped

$(_T): $$($(_T)_EXE)

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
$$($(_T)_STRPSTAMP): $$($(_T)_EXE)
	$$(VSTRP)
	$$(VR)$$(STRIP) --strip-all $$< $(CMDQUIET) || $(STRIP) $$<
	$$(VR)$$(STAMP) $$@

$$($(_T)_STRIPWITH):: $$($(_T)_STRPSTAMP)

endif

ifeq ($$($(_T)_NOBUILD),1)
$$($(_T)_BUILDWITH):: $(_T)_prebuild

else
ifeq ($$(BFMT_PLATFORM),win32)
$$($(_T)_EXE): $$($(_T)_OBJS) $$($(_T)_ROBJS) $$(_$(_T)_DEPS) | $$(_$(_T)_DIRS)
	$$(VCCLD)
	$$(VR)$$($$($(_T)_LINKERFRONT)) -o$$@ \
		-Wl,--out-implib,$$($(_T)_IMPLIB) \
		$$($(_T)_$$(PLATFORM)_LDFLAGS) $$($(_T)_LDFLAGS) $$(LDFLAGS) \
		$$($(_T)_OBJS) $$($(_T)_ROBJS) $$(_$(_T)_LINK)

else
$$($(_T)_EXE): $$($(_T)_OBJS) $$($(_T)_ROBJS) $$(_$(_T)_DEPS) | $$(_$(_T)_DIRS)
	$$(VCCLD)
	$$(VR)$$($$($(_T)_LINKERFRONT)) -o$$@ \
		$$($(_T)_$$(PLATFORM)_LDFLAGS) $$($(_T)_LDFLAGS) $$(LDFLAGS) \
		$$($(_T)_OBJS) $$($(_T)_ROBJS) $$(_$(_T)_LINK)

endif
endif

$(_T)_install: $$($(_T)_EXE)
	$$(eval _ZIMK_1 := $$(DESTDIR)$$($$($(_T)_INSTALLDIRNAME)dir))
	$$(eval _ZIMK_0 := $$(_ZIMK_1)$$(PSEP)$$(<F))
	$$(VINST)
	$$(VR)$$(call instfile,$$<,$$(_ZIMK_1),755)

.PHONY: $(_T) $(_T)_install

endef

# vim: noet:si:ts=8:sts=8:sw=8
