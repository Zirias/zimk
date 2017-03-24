# define variables for target "hello"

# make command target for buidling only target "hello" (default: hello)
# hello_TARGET:=

# modules for target "hello" (the .c source files without extension)
hello_MODULES:= hello

# platform-specific modules for target "hello" (named module_PLATFORM.c,
# e.g. foobar_win32.c for the win32-specific implementation of module foobar)
# hello_PLATFORMMODULES:= foobar

# source directory for target "hello" (default: current directory)
# hello_SRCDIR:=

# object directory for target "hello" (default: global OBJDIR)
# hello_OBJDIR:=

# target directory for target "hello" (default: global BINDIR for building as
# executable binary and LIBDIR for building as shared or static library)
# hello_TGTDIR:=

# target directory for library files that normally go to BINDIR when building
# as shared library (default: global BINDIR)
# hello_BINDIR:=

# libraries to link with
# hello_LIBS:=

# other targets "hello" depends on
# hello_DEPS:=

# build "hello" with this phony target (default: all)
# hello_BUILDWITH:=

# strip "hello" with this phony target (default: strip)
# hello_STRIPWITH:=

# additional preprocessor defines for target "hello"
# hello_DEFINES:=

# additional preprocessor defines for target "hello" on platform "win32"
# hello_win32_DEFINES:=

# additional include search paths for target "hello"
# hello_INCLUDES:=

# additional include search paths for target "hello" on platform "win32"
# hello_win32_INCLUDES:=

# additional compiler flags for target "hello" as executable binary or static
# library
# hello_CFLAGS:=

# additional compiler flags for target "hello" as executable binary or static
# library on platform "win32"
# hello_win32_CFLAGS:=

# additional compiler flags for target "hello" as shared library
# hello_CFLAGS_SHARED:=

# additional compiler flags for target "hello" as shared library on
# platform "win32"
# hello_win32_CFLAGS_SHARED:=

# generate rules to build target "hello" as executable binary
$(call binrules, hello)

# generate rules to build target "hello" as shared or static library
# $(call librules, hello)

