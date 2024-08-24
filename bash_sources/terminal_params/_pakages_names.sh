#!/bin/bash

# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing


### List aLL the packages names
# Compiling a Cross-Toolchain..
export Binutils_P1="binutils-2.42"      # contains a linker, an assembler, and other tools for handling object files.
export GCC_P1="gcc-13.2.0"              # contains the GNU compiler collection, which includes the C and C++ compilers.
    export GCC_P1_mpfr="mpfr-4.2.1"
    export GCC_P1_gmp="gmp-6.3.0"
    export GCC_P1_mpc="mpc-1.3.1"
export Linux="linux-6.7.4"              # expose the kernel's API for use by Glibc.
export Glibc="glibc-2.39"               # contains the main C library. This library provides the basic routines for allocating memory, searching directories, opening and closing files, reading and writing files, string handling, pattern matching, arithmetic, and so on.
export Libstdc="libstdc++"              # from gcc-13.2.0 and it is the standard C++ library. It is needed to compile C++ code (part of GCC is written in C++), but we had to defer its installation when we built gcc-pass1 because Libstdc++ depends on Glibc, which was not yet available in the target directory.

# Cross Compiling Temporary Tools
export M4="m4-1.4.19"                   # contains a macro processor.
export Ncurses="ncurses-6.4-20230520"   # contains libraries for terminal-independent handling of character screens.
export Bash="bash-5.2.21"               # contains the Bourne-Again Shell
export Coreutils="coreutils-9.4"        # contains the basic utility programs needed by every operating system.
export Diffutils="Diffutils-3.10"       # contains programs that show the differences between files or directories.
export File="File-5.45"                 # contains a utility for determining the type of a given file or files.
export Findutils="Findutils-4.9.0"      # programs to find files. Programs are provided to search through all the files in a directory tree and to create, maintain, and search a database (often faster than the recursive find, but unreliable unless the database has been updated recently). Findutils also supplies the xargs program, which can be used to run a specified command on each file selected by a search.
export Gawk="Gawk-5.3.0"                # contains programs for manipulating text files.
export Grep="Grep-3.11"                 # contains programs for searching through the contents of files.
export Gzip="Gzip-1.13"                 # contains programs for compressing and decompressing files.
export Make="Make-4.4.1"                # contains a program for controlling the generation of executables and other non-source files of a package from source files.
export Patch="Patch-2.7.6"              # contains a program for modifying or creating files by applying a “patch” file typically created by the diff program.
export Sed="Sed-4.9"                    # contains stream editor.
export Tar="Tar-1.35"                   # the ability to create tar archives as well as perform various other kinds of archive manipulation
export Xz="Xz-5.4.6"                    # contains programs for compressing and decompressing files
export Binutils_P2="Binutils-2.42"      # contains a linker, an assembler, and other tools for handling object files.
export GCC_P2="GCC-13.2.0"
    export GCC_P2_mpfr="mpfr-4.2.1"
    export GCC_P2_gmp="gmp-6.3.0"
    export GCC_P2_mpc="mpc-1.3.1"

# Entering Chroot and Building Additional Temporary Tools

export Expat="expat-2.6.2"              #

