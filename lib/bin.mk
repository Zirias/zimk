define BINRULES
$(OBJRULES)

$(_T)_TARGET ?= $(_T)
$(_T)_ICON ?= $(_T)
$(_T)_ICONSRCDIR ?= $$($(_T)_SRCDIR)$$(PSEP)icons
$(_T)_ICONTYPES ?= png
$(_T)_MIMEICONSIZES ?= $$($(_T)_ICONSIZES)
$(_T)_MIMEICONTYPES ?= $$($(_T)_ICONTYPES)
$(_T)_LIBDIR ?= $$(LIBDIR)
$(_T)_MIMEDIR ?= $$($(_T)_SRCDIR)$$(PSEP)mime
$(_T)_BUILDWITH ?= all
ifeq ($$($(_T)_NOBUILD),1)
$(_T)_TGTDIR ?= $$($(_T)_SRCDIR)
else
$(_T)_TGTDIR ?= $$(BINDIR)
$(_T)_STRIPWITH ?= strip
endif
$(_T)_INSTALLWITH ?= install
$(_T)_INSTALLDIRNAME ?= bin

$(BUILDDEPS)
$(LINKFLAGS)

$(_T)_EXE := $$($(_T)_TGTDIR)$$(PSEP)$$($(_T)_TARGET)$$(EXE)

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

ifneq ($$(PLATFORM),win32)
ifneq ($$(strip $$($(_T)_DESKTOPFILE)),)
$$($(_T)_INSTALLWITH):: $(_T)_installdesktop

endif
ifneq ($$(strip $$($(_T)_ICONSIZES)),)
_$(_T)_ICONS_INSTALL := $$(addprefix $$($(_T)_ICON).,$$($(_T)_ICONTYPES))

ifndef ZIMK__ICON_INST_RECIPE_LINE
define ZIMK__ICON_INST_RECIPE_LINE

$$(ZIMK__TAB)$$$$(eval _ZIMK_1 := $$$$(DESTDIR)$$$$(icondir)$$$$(PSEP)$$(_S)$$$$(PSEP)$$$$(iconsubdir))
$$(ZIMK__TAB)$$$$(eval _ZIMK_0 := $$$$(_ZIMK_1)$$$$(PSEP)$$(_I))
$$(ZIMK__TAB)$$$$(VINST)
$$(ZIMK__TAB)$$$$(VR)$$$$(call instfile,$$$$($$(_T)_ICONSRCDIR)$$$$(PSEP)$$(_S)$$$$(PSEP)$$(_I),$$$$(dir $$$$(_ZIMK_1)$$$$(PSEP)$$(_I)),664)
endef
endif

$$(eval $$(_T)_installicons: $$(foreach \
	_S,$$($$(_T)_ICONSIZES),$$(addprefix \
	$$($$(_T)_ICONSRCDIR)$$(PSEP)$$(_S)$$(PSEP),\
	$$(_$$(_T)_ICONS_INSTALL)))$$(foreach \
	_S,$$($$(_T)_ICONSIZES),$$(foreach \
	_I,$$(_$$(_T)_ICONS_INSTALL),$$(ZIMK__ICON_INST_RECIPE_LINE))))

$$($(_T)_INSTALLWITH):: $(_T)_installicons

endif
ifneq ($$(strip $$($(_T)_MIMEICONS)),)
_$(_T)_MIMEICONS_INSTALL := $$(foreach _MI,$$($$(_T)_MIMEICONS),\
	$$(addprefix $$(_MI).,$$($(_T)_MIMEICONTYPES)))

ifndef ZIMK__MIMEICON_INST_RECIPE_LINE
define ZIMK__MIMEICON_INST_RECIPE_LINE

$$(ZIMK__TAB)$$$$(eval _ZIMK_1 := $$$$(DESTDIR)$$$$(icondir)$$$$(PSEP)$$(_S)$$$$(PSEP)$$$$(mimeiconsubdir))
$$(ZIMK__TAB)$$$$(eval _ZIMK_0 := $$$$(_ZIMK_1)$$$$(PSEP)$$(_I))
$$(ZIMK__TAB)$$$$(VINST)
$$(ZIMK__TAB)$$$$(VR)$$$$(call instfile,$$$$($$(_T)_ICONSRCDIR)$$$$(PSEP)$$(_S)$$$$(PSEP)$$(_I),$$$$(dir $$$$(_ZIMK_1)$$$$(PSEP)$$(_I)),664)
endef
endif

$$(eval $$(_T)_installmimeicons: $$(foreach \
	_S,$$($$(_T)_MIMEICONSIZES),$$(addprefix \
	$$($$(_T)_ICONSRCDIR)$$(PSEP)$$(_S)$$(PSEP),\
	$$(_$$(_T)_MIMEICONS_INSTALL)))$$(foreach \
	_S,$$($$(_T)_MIMEICONSIZES),$$(foreach \
	_I,$$(_$$(_T)_MIMEICONS_INSTALL),$$(ZIMK__MIMEICON_INST_RECIPE_LINE))))

$$($(_T)_INSTALLWITH):: $(_T)_installmimeicons

endif
ifneq ($$(strip $$($(_T)_SHAREDMIMEINFO)),)
$$($(_T)_INSTALLWITH):: $(_T)_installsharedmimeinfo

endif
endif
endif

ifneq ($$(strip $$($(_T)_STRIPWITH)),)
$$($(_T)_STRIPWITH):: $$($(_T)_EXE)
	$$(VSTRP)
	$$(VR)$$(STRIP) --strip-all $$<

endif

ifeq ($$($(_T)_NOBUILD),1)
$$($(_T)_BUILDWITH):: $(_T)_sub

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

$(_T)_installdesktop: $$($(_T)_SRCDIR)$$(PSEP)$$($(_T)_DESKTOPFILE).desktop
	$$(eval _ZIMK_1 := $$(DESTDIR)$$(desktopdir))
	$$(eval _ZIMK_0 := $$(_ZIMK_1)$$(PSEP)$$(<F))
	$$(VINST)
	$$(VR)$$(call instfile,$$<,$$(_ZIMK_1),644)

$(_T)_installsharedmimeinfo: \
	$$($(_T)_MIMEDIR)$$(PSEP)$$($(_T)_SHAREDMIMEINFO).xml
	$$(eval _ZIMK_1 := $$(DESTDIR)$$(sharedmimeinfodir))
	$$(eval _ZIMK_0 := $$(_ZIMK_1)$$(PSEP)$$(<F))
	$$(VINST)
	$$(VR)$$(call instfile,$$<,$$(_ZIMK_1),644)
ifeq ($$(strip $$(DESTDIR)),)
ifeq ($$(filter-out 0 false FALSE no NO,$$(PORTABLE)),)
	-update-mime-database $$(mimedir)
endif
endif

.PHONY: $(_T) $(_T)_install $(_T)_installdesktop $(_T)_installicons \
	$(_T)_installmimeicons $(_T)_installsharedmimeinfo

endef

# vim: noet:si:ts=8:sts=8:sw=8
