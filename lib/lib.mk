ZIMK__LIBTYPES := library plugin test

define LIBRULES
$(OBJRULES)

$(_T)_LIBTYPE ?= library
$(_T)_LIBTYPE := $$(strip $$($(_T)_LIBTYPE))
ifeq ($$(filter $$($(_T)_LIBTYPE),$$(ZIMK__LIBTYPES)),)
$$(error Unkown library type `$$($(_T)_LIBTYPE)' for `$(_T)'. \
	Supported library types are: $$(ZIMK__LIBTYPES))
endif

$(_T)_TARGET ?= $(_T)
$(_T)_V_MAJ ?= 1
$(_T)_V_MIN ?= 0
$(_T)_V_REV ?= 0
$(_T)_posix_CFLAGS_SHARED ?= -fPIC
$(_T)_posix_CXXFLAGS_SHARED ?= -fPIC
$(_T)_INSTALLDIRNAME ?= lib
$(_T)_INSTALLBINDIRNAME ?= bin
$(_T)_HEADERDIR ?= $$($(_T)_SRCDIR)
$(_T)_HEADERTGTDIR ?= $$(includedir)$$(PSEP)$(_T)

ifeq ($$($(_T)_LIBTYPE),library)
$(_T)_TGTDIR ?= $$(LIBDIR)
$(_T)_BINDIR ?= $$(BINDIR)
$(_T)_BUILDWITH ?= all
$(_T)_BUILDSTATICWITH ?= staticlibs
$(_T)_INSTALLWITH ?= install
$(_T)_INSTALLSTATICWITH ?= installstaticlibs
$(_T)_STRIPWITH ?= strip
endif

ifeq ($$($(_T)_LIBTYPE),plugin)
$(_T)_TGTDIR ?= $$(LIBDIR)
$(_T)_BINDIR ?= $$(BINDIR)
$(_T)_BUILDWITH ?= all
$(_T)_BUILDSTATICWITH :=
$(_T)_INSTALLWITH ?= install
$(_T)_INSTALLSTATICWITH :=
$(_T)_STRIPWITH ?= strip
endif

ifeq ($$($(_T)_LIBTYPE),test)
$(_T)_TGTDIR ?= $$(TESTDIR)
$(_T)_BINDIR ?= $$(TESTDIR)
$(_T)_BUILDWITH ?= tests
$(_T)_BUILDSTATICWITH :=
$(_T)_INSTALLWITH :=
$(_T)_INSTALLSTATICWITH :=
$(_T)_STRIPWITH :=
endif

ifeq ($$($(_T)_CXXMODULES),)
$(_T)_LDC := $$(CC)
$(_T)_VL = $$(VCCLD)
else
$(_T)_LDC := $$(CXX)
$(_T)_VL = $$(VCXLD)
endif

$(_T)_STATICLIB := $$($(_T)_TGTDIR)$$(PSEP)lib$(_T).a

$(BUILDDEPS)
$(LINKFLAGS)

ifeq ($$(PLATFORM),win32)
ifeq ($$($(_T)_LIBTYPE),library)
$(_T)_LIB := $$($(_T)_BINDIR)$$(PSEP)$(_T)-$$($(_T)_V_MAJ).dll
else
$(_T)_LIB := $$($(_T)_BINDIR)$$(PSEP)$(_T).dll
endif

else
ifeq ($$($(_T)_LIBTYPE),library)
_$(_T)_V := $$($(_T)_V_MAJ).$$($(_T)_V_MIN).$$($(_T)_V_REV)
_$(_T)_LIB_FULL := $$($(_T)_TGTDIR)$$(PSEP)lib$(_T).so.$$(_$(_T)_V)
_$(_T)_LIB_MAJ := $$($(_T)_TGTDIR)$$(PSEP)lib$(_T).so.$$($(_T)_V_MAJ)
else
_$(_T)_LIB_FULL := $$($(_T)_TGTDIR)$$(PSEP)lib$(_T).so
endif
$(_T)_LIB := $$($(_T)_TGTDIR)$$(PSEP)lib$(_T).so

endif

OUTFILES := $$($(_T)_LIB) $$($(_T)_STATICLIB)
$(DIRRULES)

$$($(_T)_STATICLIB): $$($(_T)_OBJS) | $$(_$(_T)_DIRS)
	$$(VAR)
	$$(VR)$$(CROSS_COMPILE)$$(AR) rcs $$@1 $$^
	$$(VR)$$(RMF) $$@ $$(CMDQUIET)
	$$(VR)$$(MV) $$@1 $$@ $$(CMDQUIET)

static_$(_T)_install: $$($(_T)_STATICLIB)
	$$(eval _ZIMK_1 := $$(DESTDIR)$$($$($(_T)_INSTALLDIRNAME)dir))
	$$(eval _ZIMK_0 := $$(_ZIMK_1)$$(PSEP)$$(<F))
	$$(VINST)
	$$(VR)$$(call instfile,$$<,$$(_ZIMK_1),644)

ifeq ($$(PLATFORM),win32)
$$($(_T)_LIB): $$($(_T)_SOBJS) $$(_$(_T)_DEPS) | $$(_$(_T)_DIRS)
	$$($(_T)_VL)
	$$(VR)$$(CROSS_COMPILE)$$($(_T)_LDC) -shared -o$$@ \
		-Wl,--out-implib,$$($(_T)_TGTDIR)$$(PSEP)lib$(_T).dll.a \
		-Wl,--output-def,$$($(_T)_TGTDIR)$$(PSEP)$(_T).def \
		$$($(_T)_$$(PLATFORM)_LDFLAGS) $$($(_T)_LDFLAGS) $$(LDFLAGS) \
		$$($(_T)_SOBJS) $$(_$(_T)_LINK)

$(_T)_install: $$($(_T)_LIB)
	$$(eval _ZIMK_1 := $$(DESTDIR)$$($$($(_T)_INSTALLBINDIRNAME)dir))
	$$(eval _ZIMK_0 := $$(_ZIMK_1)$$(PSEP)$$(<F))
	$$(VINST)
	$$(VR)$$(call instfile,$$<,$$(_ZIMK_1),755)
ifeq ($$($(T)_LIBTYPE),library)
	$$(eval _ZIMK_1 := $$(DESTDIR)$$($$($(_T)_INSTALLDIRNAME)dir))
	$$(eval _ZIMK_0 := $$(_ZIMK_1)$$(PSEP)lib$(_T).dll.a)
	$$(VINST)
	$$(VR)$$(call instfile,$$($(_T)_TGTDIR)$$(PSEP)lib$(_T).dll.a,$$(_ZIMK_1),644)
	$$(eval _ZIMK_0 := $$(_ZIMK_1)$$(PSEP)$(_T).def)
	$$(VINST)
	$$(VR)$$(call instfile,$$($(_T)_TGTDIR)$$(PSEP)$(_T).def,$$(_ZIMK_1),644)
endif

else
ifeq ($$($(_T)_LIBTYPE),library)
$$($(_T)_LIB): $$(_$(_T)_LIB_MAJ)
	$$(VR)ln -fs lib$(_T).so.$$($(_T)_V_MAJ) $$@

$$(_$(_T)_LIB_MAJ): $$(_$(_T)_LIB_FULL)
	$$(VR)ln -fs lib$(_T).so.$$(_$(_T)_V) $$@

endif

$$(_$(_T)_LIB_FULL): $$($(_T)_SOBJS) $$(_$(_T)_DEPS) | $$(_$(_T)_DIRS)
	$$($(_T)_VL)
	$$(VR)$$(CROSS_COMPILE)$$($(_T)_LDC) -shared -o$$@ \
		-Wl,-soname,lib$(_T).so.$$($(_T)_V_MAJ) \
		$$($(_T)_$$(PLATFORM)_LDFLAGS) $$($(_T)_LDFLAGS) $$(LDFLAGS) \
		$$($(_T)_SOBJS) $$(_$(_T)_LINK)

$(_T)_install: $$(_$(_T)_LIB_FULL)
	$$(eval _ZIMK_1 := $$(DESTDIR)$$($$($(_T)_INSTALLDIRNAME)dir))
	$$(eval _ZIMK_0 := $$(_ZIMK_1)$$(PSEP)$$(<F))
	$$(VINST)
	$$(VR)$$(call instfile,$$<,$$(_ZIMK_1),755)
	$$(VR)ln -fs lib$(_T).so.$$(_$(_T)_V) $$(_ZIMK_1)$$(PSEP)lib$(_T).so.$$($(_T)_V_MAJ)
	$$(VR)ln -fs lib$(_T).so.$$($(_T)_V_MAJ) $$(_ZIMK_1)$$(PSEP)lib$(_T).so

endif

$(_T): $$($(_T)_LIB)

static_$(_T): $$($(_T)_STATICLIB)

ifneq ($$(strip $$($(_T)_BUILDWITH)),)
$$($(_T)_BUILDWITH):: $(_T)

endif

ifneq ($$(strip $$($(_T)_BUILDSTATICWITH)),)
$$($(_T)_BUILDSTATICWITH):: static_$(_T)

endif

ifneq ($$(strip $$($(_T)_INSTALLWITH)),)
$$($(_T)_INSTALLWITH):: $(_T)_install

endif

ifneq ($$(strip $$($(_T)_INSTALLSTATICWITH)),)
$$($(_T)_INSTALLSTATICWITH):: static_$(_T)_install

endif

ifneq ($$(strip $$($(_T)_STRIPWITH)),)
$$($(_T)_STRIPWITH):: $$($(_T)_LIB)
	$$(VSTRP)
	$$(VR)$$(CROSS_COMPILE)$$(STRIP) --strip-unneeded $$<

endif

ifneq ($$(strip $$($(_T)_HEADERS_INSTALL)),)
_$(_T)_HEADERS_INSTALL := $$(addsuffix .h,$$(subst \
	/,$$(PSEP),$$($(_T)_HEADERS_INSTALL)))
_$(_T)_HEADERS_DSTPATH := $$(DESTDIR)$$(subst \
	/,$$(PSEP),$$($(_T)_HEADERTGTDIR))
_$(_T)_HEADERS_SRCPATH := $$(subst /,$$(PSEP),$$($(_T)_HEADERDIR))

ifndef ZIMK__HEADER_INST_RECIPE_LINE
define ZIMK__HEADER_INST_RECIPE_LINE

$$(ZIMK__TAB)$$$$(eval _ZIMK_1 := $$$$(_$$(_T)_HEADERS_DSTPATH))
$$(ZIMK__TAB)$$$$(eval _ZIMK_0 := $$$$(_ZIMK_1)$$$$(PSEP)$$(_H))
$$(ZIMK__TAB)$$$$(VINST)
$$(ZIMK__TAB)$$$$(VR)$$$$(call instfile,$$$$(_$$(_T)_HEADERS_SRCPATH)$$$$(PSEP)$$(_H),$$$$(dir $$$$(_ZIMK_1)$$$$(PSEP)$$(_H)),644)
endef
endif

$$(eval $$(_T)_install_headers: $$(addprefix \
	$$(_$$(_T)_HEADERS_SRCPATH)$$(PSEP), \
	$$(_$$(_T)_HEADERS_INSTALL))$$(foreach \
	_H,$$(_$$(_T)_HEADERS_INSTALL),$$(ZIMK__HEADER_INST_RECIPE_LINE)))

$$($(_T)_INSTALLWITH):: $(_T)_install_headers

endif

.PHONY: $(_T) static_$(_T) $(_T)_install static_$(_T)_install \
	$(_T)_install_headers

endef

# vim: noet:si:ts=8:sts=8:sw=8
