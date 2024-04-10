PREPROC_MOC_suffix := moc
PREPROC_MOC_intype := h
PREPROC_MOC_outtype := cpp

define ZIMK__QRCRULES

$$($(_T)_OBJDIR)$$(PSEP)$1_qrc.cpp: \
		$$($(_T)_SRCDIR)$$(PSEP)$1.qrc $(_T)_sub \
		| $$(_$(_T)_DIRS)
	$$(VGEN)
	$$(VR)$$($(_T)_RCC) -o $$@ --name $$(notdir $$(basename $$@)) $$<

$$($(_T)_OBJDIR)$$(PSEP)$1_qrc.o: \
		$$($(_T)_OBJDIR)$$(PSEP)$1_qrc.cpp $(_T)_sub \
		$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VCXX)
	$$(VR)$$(CXX) -c -o$$@ $$(_$(_T)_CXXFLAGS) \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) $$($(_T)_$$(PLATFORM)_CXXFLAGS_STATIC) \
		$$($(_T)_CXXFLAGS_STATIC) $$(CXXFLAGS_STATIC) \
		$$($(_T)_$$(PLATFORM)_CXXFLAGS) $$($(_T)_CXXFLAGS) \
		$$(CXXFLAGS) $$<

$$($(_T)_OBJDIR)$$(PSEP)$1_qrc_s.o: \
		$$($(_T)_OBJDIR)$$(PSEP)$1_qrc.cpp $(_T)_sub \
		$$($(_T)_MAKEFILES) $$(ZIMK__CFGCACHE) | $$(_$(_T)_DIRS)
	$$(VCXX)
	$$(VR)$$(CXX) -c -o$$@ $$(_$(_T)_CXXFLAGS) \
		$$($(_T)_$$(PLATFORM)_DEFINES) $$($(_T)_DEFINES) $$(DEFINES) \
		$$($(_T)_$$(PLATFORM)_INCLUDES) $$($(_T)_INCLUDES) \
		$$(INCLUDES) $$($(_T)_$$(PLATFORM)_CXXFLAGS_SHARED) \
		$$($(_T)_CXXFLAGS_SHARED) $$(CXXFLAGS_SHARED) \
		$$($(_T)_$$(PLATFORM)_CXXFLAGS) $$($(_T)_CXXFLAGS) \
		$$(CXXFLAGS) $$<
endef

define ZIMK__USE_QT
$(_T)_QT_VERSION ?= $(QT_VERSION)
$(_T)_QT_VERSION := $$(or $$(filter 5,$$($(_T)_QT_VERSION)),6)
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
ifneq ($$($(_T)_MOCMODULES),)
$(_T)_PREPROC = MOC
$(_T)_PREPROCFLAGS ?= -p.
$(_T)_INCLUDES += -I$$($(_T)_PPSRCDIR)
$(_T)_PREPROCMODULES += $$($(_T)_MOCMODULES)
$(_T)_CXXMODULES += $$($(_T)_MOCMODULES)
$(_T)_MOC := $$(or $$(MOC),$$(call findtool,moc,$$($(_T)_QT_TOOLDIR)),$$(call \
	findtool,moc-qt$$($(_T)_VERSION)))
PREPROC_MOC_preproc := $$($(_T)_MOC)
endif
$(_T)_RCC := $$(or $$(RCC),$$(call findtool,rcc,$$($(_T)_QT_TOOLDIR)),$$(call \
	findtool,rcc-qt$$($(_T)_VERSION)))
$(_T)_PKGDEPS += $$(addprefix Qt$$($(_T)_QT_VERSION),Core \
	$$($(_T)_USE_QT) $$($(_T)_USE_QT$$($(_T)_QT_VERSION)))
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