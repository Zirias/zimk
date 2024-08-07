# pkgconfig.mk -- handle pkg-config dependencies and generating own .pc files
#
# Configuration variables:
#
# PKGCONFIG	Name or full path to the 'pkg-config' tool
# 		(default: pkg-config, searched in the initial PATH)
# pkgconfigdir	Where to install own .pc files
# 		(default: $(prefix)/lib/pkgconfig)
#
# Project variables:
#
# name_PKGDEPS		Packages to depend on, automatically adding CFLAGS
# 			and libraries to link
# name_PKGSTATICDEPS	The same, but used for static builds
# name_PKGCONFIG	Own .pc file to generate/install, only supported for
# 			libraries of type "library" (not plugins etc)
# 			(default: $(pkgconfigdir)/<name>.pc)
#

FALLBACKTOOLS += PKGCONFIG
SINGLECONFVARS += pkgconfigdir

DEFAULT_PKGCONFIG ?= pkg-config

define ZIMK__USE_PKGCONFIG_DIRS

ifeq ($$(PORTABLE),1)
pkgconfigdir ?= $$(prefix)
else
pkgconfigdir ?= $$(prefix)$$(PSEP)lib$$(PSEP)pkgconfig
endif
endef

define ZIMK__USE_PKGCONFIG
ifeq ($$($(_T)_LIBTYPE),library)
$(_T)_PKGCONFIG ?= $$(pkgconfigdir)$$(PSEP)$(_T).pc
else
$(_T)_PKGCONFIG :=
endif

ifneq ($$(strip $$($(_T)_PKGCONFIG)),)
$(_T)_install_pkgconfig:
	$$(eval _ZIMK_0 := $$(DESTDIR)$$($(_T)_PKGCONFIG))
	$$(VINST)
	$$(VR)$$(INSTDIR) $$(dir $$(_ZIMK_0))
	$$(VR)$$(ECHOTO)libdir=$$($$($(_T)_INSTALLDIRNAME)dir)$$(ETOEND) \
		>$$(DESTDIR)$$($(_T)_PKGCONFIG)
	$$(VR)$$(ECHOTO)includedir=$$($(_T)_HEADERTGTBASEDIR)$$(ETOEND) \
		>>$$(DESTDIR)$$($(_T)_PKGCONFIG)
	$$(VR)echo >>$$(DESTDIR)$$($(_T)_PKGCONFIG)
	$$(VR)$$(ECHOTO)Name: $(_T)$$(ETOEND) >>$$(DESTDIR)$$($(_T)_PKGCONFIG)
	$$(VR)$$(ECHOTO)Description: $$($(_T)_DESCRIPTION)$$(ETOEND) \
		>>$$(DESTDIR)$$($(_T)_PKGCONFIG)
	$$(VR)$$(ECHOTO)Version: $$($(_T)_VERSION)$$(ETOEND) \
		>>$$(DESTDIR)$$($(_T)_PKGCONFIG)
	$$(VR)$$(ECHOTO)Cflags: -I\$$$${includedir}$$(ETOEND) \
		>>$$(DESTDIR)$$($(_T)_PKGCONFIG)
	$$(VR)$$(ECHOTO)Libs: -L\$$$${libdir} -l$(_T)$$(ETOEND) \
		>>$$(DESTDIR)$$($(_T)_PKGCONFIG)

$$($(_T)_INSTALLWITH):: $(_T)_install_pkgconfig

.PHONY: $(_T)_install_pkgconfig

endif
endef

define ZIMK__USE_PKGCONFIG_POST

ifeq ($$(strip $$(PKGCONFIG)),)
$$(error Required tool 'pkg-config' not found, please install pkg-config\
	or pkgconf)
endif

ifneq ($$(strip $$($(_T)_PKGDEPS)),)
ifneq ($(filter-out $(NOBUILDTARGETS),$(MAKECMDGOALS)),)
$(_T)_PKGSTATUS := $$(shell $$(PKGCONFIG) --exists '$$($(_T)_PKGDEPS)';\
	echo $$$$?)
ifneq ($$($(_T)_PKGSTATUS),0)
$$(error $$(shell $$(PKGCONFIG) --print-errors --exists '$$($(_T)_PKGDEPS)')\
Required packages for $(_T) not found)
endif
$(_T)_PKGCFLAGS := $$(shell $$(PKGCONFIG) --cflags '$$($(_T)_PKGDEPS)')
_$(_T)_CFLAGS += $$($(_T)_PKGCFLAGS)
_$(_T)_CXXFLAGS += $$($(_T)_PKGCFLAGS)
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
_$(_T)_CFLAGS += $$($(_T)_PKGCFLAGS)
_$(_T)_CXXFLAGS += $$($(_T)_PKGCFLAGS)
$(_T)_PKGSTATICLINKFLAGS += $$(shell $$(PKGCONFIG) --libs\
	'$$($(_T)_PKGSTATICDEPS)')
endif
endif
endef
