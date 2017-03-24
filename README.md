# zimk - zirias' make

This is a small build system for software written in C, based only on
GNU make. It provides compatibility with POSIX systems as well as Windows
out of the box. See the provided minimal example for how to use it in your
project.

## How to invoke a build

The standard targets `all`, `clean`, `distclean` and `strip` are defined
automatically. Some make variables are supported as well:

 - `CFG=DEBUG` (defaults to `RELEASE`): Build without optimizations and with
   debugging symbols instead.
 - `CROSS_COMPILE=x86_64-w64-mingw32-` (defaults to empty): Prefix to all
   toolchain invocations in order to cross compile for a different system.
 - `USECC=clang` (defaults to empty): use this as base name of the C compiler
   instead of just `cc`.
 - `USECFLAGS=-Os` (defaults to empty): Always add these `CFLAGS`.

There is more that can be tweaked, take a look at the source (`lib/config.mk`
is relevant here) for now. If you want to change the defaults, place them in
a file `defaults.mk` in the root directory of your project, for example:

	# use llvm/clang by default:
	USECC?=clang
	
	# build debugging configuration by default:
	CFG?=DEBUG


