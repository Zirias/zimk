# fdofiles.mk -- Install some files according to freedesktop.org specs
#
# This implements installation of .desktop files, shared MIME info databases
# and icons (for both file types and the application itself).
#
# Configuration variables:
#
# UPD_MIMEDB		Name or full path to the 'update-mime-database'
# 			utility. When available and MIME database files
# 			are installed, this is automatically called.
# 			(default: update-mime-database, searched in PATH)
# icondir		Where to install icons
# 			(default: $(datarootdir)/icons/hicolor)
# iconsubdir		Subdirectory for application icons
# 			(default: apps)
# mimeiconsubdir	Subdirectory for MIME-type icons
# 			(default: mimetypes)
# desktopdir		Where to install desktop files
# 			(default: $(datarootdir)/applications)
# mimedir		Base directory of the MIME database
# 			(default: $(datarootdir)/mime)
# sharedmimeinfodir	Where to install MIME database files
# 			(default: $(mimedir)/packages)
#
# Project variables:
#
# name_ICON		Application icon name (default: <name>)
# name_ICONSRCDIR	Path to icons in the source
# 			(default: $(name_SRCDIR)/icons)
# name_ICONSIZES	Available sizes of application icons (default: unset)
# 			(example: 256x256 48x48 32x32 16x16)
# name_ICONTYPES	File types of application icons (default: png)
# name_MIMEICONS	Names of MIME-type icons (default: unset)
# name_MIMEICONSIZES	Available sizes of MIME-type icons
# 			(default: same as name_ICONSIZES)
# name_MIMEICONTYPES	File types of MIME-type icons
# 			(default: same as name_ICONTYPES)
# name_SHAREDMIMEINFO	MIME info files to install, without .xml suffix
# 			(default: unset)
# name_MIMEDIR		Path to MIME info files in the source
# 			(default: $(name_SRCDIR)/mime)
# name_DESKTOPFILE	Desktop file to install, without .desktop suffix
# 			(default: unset)
#

SINGLECONFVARS += icondir iconsubdir mimeiconsubdir \
		  desktopdir mimedir sharedmimeinfodir
HOSTTOOLS += UPD_MIMEDB

DEFAULT_UPD_MIMEDB ?= update-mime-database

define ZIMK__USE_FDOFILES_DIRS

ifeq ($$(PORTABLE),1)
icondir ?= $$(datarootdir)$$(PSEP)icons
desktopdir ?= $$(datarootdir)
mimedir ?= $$(datarootdir)$$(PSEP)mime
sharedmimeinfodir ?= $$(mimedir)
else
icondir ?= $$(datarootdir)$$(PSEP)icons$$(PSEP)hicolor
iconsubdir ?= apps
mimeiconsubdir ?= mimetypes
desktopdir ?= $$(datarootdir)$$(PSEP)applications
mimedir ?= $$(datarootdir)$$(PSEP)mime
sharedmimeinfodir ?= $$(mimedir)$$(PSEP)packages
endif
endef

define ZIMK__ICON_INST_RECIPE_LINE

$(ZIMK__TAB)$$(eval _ZIMK_1 := $$(DESTDIR)$$(icondir)$$(PSEP)$(_S)$$(PSEP)$$(iconsubdir))
$(ZIMK__TAB)$$(eval _ZIMK_0 := $$(_ZIMK_1)$$(PSEP)$(_I))
$(ZIMK__TAB)$$(VINST)
$(ZIMK__TAB)$$(VR)$$(call \
	instfile,$$($(_T)_ICONSRCDIR)$$(PSEP)$(_S)$$(PSEP)$(_I),$$(dir \
	$$(_ZIMK_1)$$(PSEP)$(_I)),664)
endef

define ZIMK__MIMEICON_INST_RECIPE_LINE

$(ZIMK__TAB)$$(eval _ZIMK_1 := $$(DESTDIR)$$(icondir)$$(PSEP)$(_S)$$(PSEP)$$(mimeiconsubdir))
$(ZIMK__TAB)$$(eval _ZIMK_0 := $$(_ZIMK_1)$$(PSEP)$(_I))
$(ZIMK__TAB)$$(VINST)
$(ZIMK__TAB)$$(VR)$$(call \
	instfile,$$($(_T)_ICONSRCDIR)$$(PSEP)$(_S)$$(PSEP)$(_I),$$(dir \
	$$(_ZIMK_1)$$(PSEP)$(_I)),664)
endef

define ZIMK__USE_FDOFILES
$(_T)_ICON ?= $(_T)
$(_T)_ICONSRCDIR ?= $$($(_T)_SRCDIR)$$(PSEP)icons
$(_T)_ICONTYPES ?= png
$(_T)_MIMEICONSIZES ?= $$($(_T)_ICONSIZES)
$(_T)_MIMEICONTYPES ?= $$($(_T)_ICONTYPES)
$(_T)_MIMEDIR ?= $$($(_T)_SRCDIR)$$(PSEP)mime

ifneq ($$(strip $$($(_T)_INSTALLWITH)),)
ifneq ($$(PLATFORM),win32)
ifneq ($$(strip $$($(_T)_DESKTOPFILE)),)
$$($(_T)_INSTALLWITH):: $(_T)_installdesktop

endif
ifneq ($$(strip $$($(_T)_ICONSIZES)),)
_$(_T)_ICONS_INSTALL := $$(addprefix $$($(_T)_ICON).,$$($(_T)_ICONTYPES))

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
ifeq ($$(PORTABLE),0)
ifneq ($$(UPD_MIMEDB),)
	$$(VR)$$(UPD_MIMEDB) $$(mimedir)
endif
endif
endif
endif
endif

.PHONY: $(_T)_installdesktop $(_T)_installicons $(_T)_installmimeicons \
	$(_T)_installsharedmimeinfo
endef

