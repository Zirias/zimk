# zimk - zirias' make

This is a small build system for software written in C, based only on
GNU make. It provides compatibility with POSIX systems as well as Windows
out of the box. See the provided minimal example for how to use it in your
project.

## How to invoke a build

simply type `make`. This will build `all` with default configurations for
release.

### Configure your build

#### 1. BUILDCFG

zimk supports different build configurations that are created in different
output directories. The configurations `debug` and `release` are always
available. The project's main Makefile can specify additional configurations.

Example for a debug build:

        make BUILDCFG=debug

#### 2. CROSS\_COMPILE

If you specify a value for `CROSS_COMPILE`, it is prepended to any invocation
of a toolchain tool (like the C or C++ compiler). This way, it's easy to do
cross builds when you have the appropriate cross toolchain installed.

Example cross-compiling for windows 64bit with MinGW64 on a \*nix host:

        make CROSS_COMPILE=x86_64-w64-mingw32-

#### 3. CC, CXX, CPP, AR, STRIP, MOC

These variables set the basic toolchain tools to use:

 - `CC` -- the C compiler, defaults to `cc`
 - `CXX` -- the C++ compiler, defaults to `c++`
 - `CPP` -- the C preprocessor, defaults to `cpp`
 - `AR` -- the static lib archiver, defaults to `ar`
 - `STRIP` -- the stripping tool, defaults to `strip`
 - `MOC` -- the Qt meta object compiler, defaults to `moc`

Example for building with `clang`:

        make CC=clang CXX=clang++

#### 4. CFLAGS, CXXFLAGS, DEFINES, INCLUDES, LDFLAGS

These are additional flags to pass to the toolchain tools:

 - `CFLAGS` -- passed during C compilation step
 - `CXXFLAGS` -- passed during C++ compilation step
 - `DEFINES` -- passed during both C and C++ compilation, for additional
                preprocessor defines.
 - `INCLUDES` -- passed during both C and C++ compilation, for additional
                 include paths
 - `LDFLAGS` -- passed during linking step

Example for building optimized for size:

        make CFLAGS=-Os CXXFLAGS=-Os

#### 5. runtime directories

zimk supports a standard set of runtime directories with the following default
values for a \*nix buid:

        prefix ?= /usr/local
        exec_prefix ?= $(prefix)
        bindir ?= $(exec_prefix)/bin
        sbindir ?= $(exec_prefix)/sbin
        libexecdir ?= $(exec_prefix)/libexec
        datarootdir ?= $(prefix)/share
        sysconfdir ?= $(prefix)/etc
        sharedstatedir ?= $(prefix)/com
        localstatedir ?= $(prefix)/var
        runstatedir ?= $(localstatedir)/run
        includedir ?= $(prefix)/include
        docrootdir ?= $(datarootdir)/doc
        libdir ?= $(exec_prefix)/lib
        localedir ?= $(datarootdir)/locale

When building for windows, they are all set to the current directory by
default. You can override them from the make commandline as well.

#### 6. additional configuration variables

A project's makefile can specify other configuration variables of two
different types. *Single configuration variables* are those that only allow
one value, if you specify a value at the command line, it overrides the
default. This is for example the case with `CC`, `CXX`, `prefix`, etc.
*List configuration variables* are appended to, when you specify them on the
commandline. Examples for this type of variables are `CFLAGS`, `DEFINES`, etc.

#### 7. managing configurations

zimk provides the special targets `config`, `changeconfig` and `showconfig`
for managing configurations. It's possible to save a set of configuration
variables independently for each `BUILDCFG`.

The `config` target is for saving configuration values. For example, if always
want to create debug builds with some additional define, use

        make BUILDCFG=debug DEFINES=-DMYDEBUGDEFINE config

If you want to modify your configuration without repeating all variables
again, you can use the `changeconfig` target. The following command will
change the current configuration to use size-optimized builds:

        make CFGLAGS=-Os changeconfig

This can also be used to switch to another `BUILDCFG` without changing any
other configuration variables:

        make BUILDCFG=release changeconfig

The `showconfig` target finally dumps all relevant configuration variables in
their processed form, that is, including all default values.

### Default targets

Targets always available in zimk are

 - `all` -- build the default set
 - `strip` -- strip debugging symbols
 - `clean` -- delete all compiled object files and other intermediaries
 - `distclean` -- remove all output directories **and saved configurations**
 - `install` -- install the project, respecting `DESTDIR`
 - `install-strip` -- install the project stripped
 - `config`, `changeconfig`, `showconfig` -- see above

## How to use zimk in your own project

(TODO)

For now, you can refer to the minimal example here and of course the source
itself.

A *real world* usage example can be found in my ongoing project
[pocas](https://github.com/zirias/pocas).

