# qt.mk -- Build with Qt tools and libs
#
# Configuration variables:
#
# QT_VERSION	Major version of Qt (5 or 6, default: 6)
# MOC		Full path to 'moc' (default: auto-detect)
# RCC		Full path to 'rcc' (default: auto-detect)
#
# Project variables:
#
# name_QT_VERSION	Major Qt version (default: QT_VERSION)
# name_USE_QT		Qt modules to link, always implies "Core"
#			example: Gui Widgets
# name_USE_QT5		Qt modules only for Qt5
# name_USE_QT6		Qt modules only for Qt6
# name_QT_CFLAGS	Automatically added CFLAGS
#			(default: -fPIC, empty for static builds)
# name_QT_CXXFLAGS	Automatically added CXXFLAGS
#			(default: $(name_QT_CFLAGS) -fno-exceptions -fno-rtti)
# name_MOCMODULES	Modules to pre-process with 'moc'
# name_MOCMODE		How to include moc-generated code:
#			bundle		compile and link all moc-generated
#					code in one bundled compilation unit
#			single		compile and link one compilation unit
#					per moc module
#			included	don't add any compilation unit
#					This requires adding an explicit
#					#include "moc_<foo>.cpp"
#					at the bottom of each moc module
#			(default: bundle)
# name_QRC		List of resource files to process with 'rcc'
#

ZIMK__USE_QT_DEPENDS = pkgconfig preproc

SINGLECONFVARS += QT_VERSION MOC RCC
DEFAULT_QT_VERSION ?= 6

ZIMK__QT_MOCMODES := bundle single included

define ZIMK__QRCRULES

$$($(_T)_OBJDIR)$$(PSEP)$1_qrc.cpp: \
		$$($(_T)_SRCDIR)$$(PSEP)$1.qrc \
		| $$(_$(_T)_DIRS) $(_T)_prebuild
	$$(VGEN)
	$$(VR)$$($(_T)_RCC) -o $$@ --name $$(notdir $$(basename $$@)) $$<

$$($(_T)_OBJDIR)$$(PSEP)$1_qrc.o: \
		$$($(_T)_OBJDIR)$$(PSEP)$1_qrc.cpp $$($(_T)_MAKEFILES) \
		$$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS) $(_T)_prebuild
	$$(VCXX)
	$$(VR)$$(CXX) -c -o$$@ $$(_$(_T)_CXXFLAGS) \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) $$($(_T)_$$(PLATFORM)_CXXFLAGS_STATIC) \
		$$($(_T)_CXXFLAGS_STATIC) $$(CXXFLAGS_STATIC) \
		$$($(_T)_$$(PLATFORM)_CXXFLAGS) $$($(_T)_CXXFLAGS) \
		$$(CXXFLAGS) $$<

$$($(_T)_OBJDIR)$$(PSEP)$1_qrc_s.o: \
		$$($(_T)_OBJDIR)$$(PSEP)$1_qrc.cpp $$($(_T)_MAKEFILES) \
		$$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS) $(_T)_prebuild
	$$(VCXX)
	$$(VR)$$(CXX) -c -o$$@ $$(_$(_T)_CXXFLAGS) \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) $$($(_T)_$$(PLATFORM)_CXXFLAGS_SHARED) \
		$$($(_T)_CXXFLAGS_SHARED) $$(CXXFLAGS_SHARED) \
		$$($(_T)_$$(PLATFORM)_CXXFLAGS) $$($(_T)_CXXFLAGS) \
		$$(CXXFLAGS) $$<
endef

define ZIMK__QT_MOCBUNDLEINC

$(ZIMK__TAB)$(VR)$(ECHOTO)#include $(ELQT)$1$(ELQT)$(ETOEND) >>$2
endef
ZIMK__QT_MOCPATH=$(ZIMK__BASEDIR)$(PSEP)$($1_OBJDIR)$(PSEP)moc_$2.cpp
define ZIMK__QT_MOCBUNDLERULE
$$($(_T)_OBJDIR)$$(PSEP)moc_bundle_$(_T).cpp: $$(foreach \
	m,$$($(_T)_MOCMODULES),$$($(_T)_OBJDIR)$$(PSEP)moc_$$m.cpp) \
	$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) \
	| $$($(_T)_OBJDIR) $$($(_T)_DEPS) $(_T)_prebuild
	$$(VGEN)
	$$(VR)$$(ECHOTO)// generated moc bundle$$(ETOEND) >$$@$$(foreach \
		m,$$($(_T)_MOCMODULES),$$(call ZIMK__QT_MOCBUNDLEINC,$$(call \
		ZIMK__QT_MOCPATH,$(_T),$$m),$$@))
endef

define ZIMK__USE_QT
$(_T)_QT_VERSION ?= $(QT_VERSION)
ifeq ($$(filter 5 6,$$($(_T)_QT_VERSION)),)
$$(error Invalid QT_VERSION '$$($(_T)_QT_VERSION)' selected for $(_T))
endif
$(_T)_QT_CORE := Qt$$($(_T)_QT_VERSION)Core
ifneq ($(filter-out $(NOBUILDTARGETS),$(MAKECMDGOALS)),)
$(_T)_PKGSTATUS := $$(shell $$(PKGCONFIG) --exists $$($(_T)_QT_CORE);\
        echo $$$$?)
ifneq ($$($(_T)_PKGSTATUS),0)
$$(error $$(shell $$(PKGCONFIG) --print-errors --exists $$($(_T)_QT_CORE))\
Required packages for $(_T) not found)
endif
$(_T)_QT_TOOLDIR := $$(shell $$(PKGCONFIG) --variable=libexecdir \
	$$($(_T)_QT_CORE))
$(_T)_QT_TOOLDIR := $$(or $$($(_T)_QT_TOOLDIR),$$(shell \
	$$(PKGCONFIG) --variable=host_bins $$($(_T)_QT_CORE)))
$(_T)_RCC := $$(or $$(RCC),$$(call findtool,rcc,$$($(_T)_QT_TOOLDIR)),$$(call \
	findtool,rcc-qt$$($(_T)_VERSION)))
$(_T)_PKGDEPS += $$(addprefix Qt$$($(_T)_QT_VERSION),Core \
	$$($(_T)_USE_QT) $$($(_T)_USE_QT$$($(_T)_QT_VERSION)))
endif

ifneq ($(STATIC),1)
$(_T)_QT_CFLAGS ?= -fPIC
endif
$(_T)_CFLAGS += $$($(_T)_QT_CFLAGS)
$(_T)_QT_CXXFLAGS ?= $$($(_T)_QT_CFLAGS) -fno-exceptions -fno-rtti
$(_T)_CXXFLAGS += $$($(_T)_QT_CXXFLAGS)

ifneq ($$($(_T)_MOCMODULES),)
$(_T)_MOCMODE ?= $$(firstword $$(ZIMK__QT_MOCMODES))
ifeq ($$(filter $$($(_T)_MOCMODE),$$(ZIMK__QT_MOCMODES)),)
$$(error Invalid MOCMODE for $(_T): $$($(_T)_MOCMODE))
endif
$(_T)_MOC := $$(or $$(MOC),$$(call findtool,moc,$$($(_T)_QT_TOOLDIR)),$$(call \
	findtool,moc-qt$$($(_T)_VERSION)))
PREPROC_$(_T)_MOC_tool = $$($(_T)_MOC)
PREPROC_$(_T)_MOC_prefix = moc_
PREPROC_$(_T)_MOC_intype = h
PREPROC_$(_T)_MOC_outtype = cpp
ifeq ($$($(_T)_MOCMODE),bundle)
$(_T)_OBJS += $$($(_T)_OBJDIR)$$(PSEP)moc_bundle_$(_T).o
$$(eval $$(call ZIMK__CXX_OBJRULES,moc_bundle_$(_T),OBJDIR))
$$(eval $$(ZIMK__QT_MOCBUNDLERULE))
endif
ifeq ($$($(_T)_MOCMODE),single)
PREPROC_$(_T)_MOC_addbuild = 1
endif
ifeq ($$($(_T)_MOCMODE),included)
PREPROC_$(_T)_MOC_args = -i $$2 >$$1
$(_T)_INCLUDES += -I$$($(_T)_OBJDIR)
$$(foreach m,$$($(_T)_MOCMODULES),$$(eval \
	$$($(_T)_OBJDIR)$$(PSEP)$$m.o $$($(_T)_OBJDIR)$$(PSEP)$$m_s.o: \
	$$($(_T)_OBJDIR)$$(PSEP)moc_$$m.cpp))
else
PREPROC_$(_T)_MOC_args = "-p$$(ZIMK__BASEDIR)$$(PSEP)$$($(_T)_SRCDIR)" $$2 >$$1
endif
$(_T)_PREPROC += $(_T)_MOC
$(_T)_$(_T)_MOC_MODULES = $$($(_T)_MOCMODULES)
$(_T)_CXXMODULES += $$($(_T)_MOCMODULES)
endif

ifneq ($$(strip $$($(_T)_QRC)),)
$(_T)_ROBJS += $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix _qrc.o,$$($(_T)_QRC)))
$(_T)_QRCSOURCE := $$(addprefix $$($(_T)_OBJDIR)$$(PSEP), \
	$$(addsuffix _qrc.cpp,$$($(_T)_QRC)))
CLEAN += $$($(_T)_QRCSOURCE)
endif

ifneq ($$(strip $$($(_T)_QRC)),)
$$(eval $$(foreach q,$$($(_T)_QRC),$$(call ZIMK__QRCRULES,$$q)))
endif

endef

# vim: noet:si:ts=8:sts=8:sw=8
