#!/bin/bash

# this bash code was made by ATOUI Rayane to automate the operation of creating Linux from scratch with the help of LFS book v12 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing


### List aLL the packages names
# Compiling a Cross-Toolchain.. (used in step2.2)
export Binutils_P1="binutils-2.42"      # contains a linker, an assembler, and other tools for handling object files.
export GCC_P1="gcc-13.2.0"              # contains the GNU compiler collection, which includes the C and C++ compilers.
    export GCC_P1_mpfr="mpfr-4.2.1"
    export GCC_P1_gmp="gmp-6.3.0"
    export GCC_P1_mpc="mpc-1.3.1"
export Linux="linux-6.7.4"              # expose the kernel's API for use by Glibc.
export Glibc="glibc-2.39"               # contains the main C library. This library provides the basic routines for allocating memory, searching directories, opening and closing files, reading and writing files, string handling, pattern matching, arithmetic, and so on.
export Libstdc="libstdc++"              # from gcc-13.2.0 and it is the standard C++ library. It is needed to compile C++ code (part of GCC is written in C++), but we had to defer its installation when we built gcc-pass1 because Libstdc++ depends on Glibc, which was not yet available in the target directory.

# Cross Compiling Temporary Tools (used in step2.2)
export M4="m4-1.4.19"                   # contains a macro processor.
export Ncurses="ncurses-6.4-20230520"   # contains libraries for terminal-independent handling of character screens.
export Bash="bash-5.2.21"               # contains the Bourne-Again Shell
export Coreutils="coreutils-9.4"        # contains the basic utility programs needed by every operating system.
export Diffutils="diffutils-3.10"       # contains programs that show the differences between files or directories.
export File="file-5.45"                 # contains a utility for determining the type of a given file or files.
export Findutils="findutils-4.9.0"      # programs to find files. Programs are provided to search through all the files in a directory tree and to create, maintain, and search a database (often faster than the recursive find, but unreliable unless the database has been updated recently). Findutils also supplies the xargs program, which can be used to run a specified command on each file selected by a search.
export Gawk="gawk-5.3.0"                # contains programs for manipulating text files.
export Grep="grep-3.11"                 # contains programs for searching through the contents of files.
export Gzip="gzip-1.13"                 # contains programs for compressing and decompressing files.
export Make="make-4.4.1"                # contains a program for controlling the generation of executables and other non-source files of a package from source files.
export Patch="patch-2.7.6"              # contains a program for modifying or creating files by applying a “patch” file typically created by the diff program.
export Sed="sed-4.9"                    # contains stream editor.
export Tar="tar-1.35"                   # the ability to create tar archives as well as perform various other kinds of archive manipulation
export Xz="xz-5.4.6"                    # contains programs for compressing and decompressing files
export Binutils_P2="binutils-2.42"      # contains a linker, an assembler, and other tools for handling object files.
export GCC_P2="gcc-13.2.0"
    export GCC_P2_mpfr="mpfr-4.2.1"
    export GCC_P2_gmp="gmp-6.3.0"
    export GCC_P2_mpc="mpc-1.3.1"

# Entering Chroot and Building Additional Temporary Tools (used in step 4)
export Gettext="gettext-0.22.4"         # contains utilities for internationalization and localization. These allow programs to be compiled with NLS (Native Language Support), enabling them to output messages in the user's native language.
export Bison="bison-3.8.2"              # contains a parser generator.
export Perl="perl-5.38.2"               # contains the Practical Extraction and Report Language.
export Python="Python-3.12.2"           # contains the Python development environment
export Texinfo="texinfo-7.1"            # contains programs for reading, writing, and converting info pages.
export Util_linux="util-linux-2.39.3"   # contains miscellaneous utility programs.



# Installing Basic System Software (OP_ optional)
export OP_Man_pages="man-pages-6.06"       # ***contains over 2,400 man pages.
export OP_Iana_Etc="iana-Etc-20240125"     # ***provides data for network services and protocols.
export OP_Glibc="glibc-2.39"               # ***contains the main C library. This library provides the basic routines for allocating memory, searching directories, opening and closing files, reading and writing files, string handling, pattern matching, arithmetic, and so on. (Note :: uses locals ?)
export OP_Zlib="zlib-1.3.1"                # *contains compression and decompression routines used by some programs
export OP_Bzip="bzip2-1.0.8"               # **contains programs for compressing and decompressing files. Compressing text files with bzip2 yields a much better compression percentage than with the traditional gzip.
export OP_Xz="xz-5.4.6"                    # ****contains programs for compressing and decompressing files. It provides capabilities for the lzma and the newer xz compression formats. Compressing text files with xz yields a better compression percentage than with the traditional gzip or bzip2 commands.
export OP_Zstd="zstd-1.5.5"                # ***a real-time compression algorithm, providing high compression ratios. It offers a very wide range of compression / speed trade-offs, while being backed by a very fast decoder.
export OP_File="file-5.45"                 # ****contains a utility for determining the type of a given file or files.
export OP_Readline="readline-8.2"          # ****a set of libraries that offer command-line editing and history capabilities.
export OR_M4="m4-1.4.19"                   # contains a macro processor. (NOTE:: use?)
export OP_BinutilsOP_Bc="bc-6.7.5"         # contains an arbitrary precision numeric processing language.(NOTE:: use?)
export OP_Flex="flex-2.6.4"                # ***contains a utility for generating programs that recognize patterns in text.
export OP_Tcl="tcl8.6.13-src"              # **contains the Tool Command Language, a robust general-purpose scripting language. The Expect package is written in Tcl (pronounced "tickle")
export OP_Expect="expect5.45.4"            # ***contains tools for automating, via scripted dialogues, interactive applications such as telnet, ftp, passwd, fsck, rlogin, and tip. Expect is also useful for testing these same applications as well as easing all sorts of tasks that are prohibitively difficult with anything else. The DejaGnu framework is written in Expect.
export OP_DejaGNU="dejagnu-1.6.3"          # **contains a framework for running test suites on GNU tools. It is written in expect, which itself uses Tcl (Tool Command Language).
export OP_Pkgconf="pkgconf-2.1.1"          # ***is a successor to pkg-config and contains a tool for passing the include path and/or library paths to build tools during the configure and make phases of package installations.
export OP_Binutils="binutils-2.42"         # ****contains a linker, an assembler, and other tools for handling object files.
export OP_GMP="gmp-6.3.0"                  # **contains math libraries. These have useful functions for arbitrary precision arithmetic.
export OP_MPFR="mpfr-4.2.1"                # **contains functions for multiple precision math.
export OP_MPC="mpc-1.3.1"                  # ****contains a library for the arithmetic of complex numbers with arbitrarily high precision and correct rounding of the result.
export OP_Attr="attr-2.5.2"                # **contains utilities to administer the extended attributes of filesystem objects.
export OP_Acl="acl-2.3.2"                  # *****contains utilities to administer Access Control Lists, which are used to define fine-grained discretionary access rights for files and directories. 
export OP_Libcap="libcap-2.69"             # ***implements the userspace interface to the POSIX 1003.1e capabilities available in Linux kernels. These capabilities partition the all-powerful root privilege into a set of distinct privileges.
export OP_Libxcrypt="libxcrypt-4.4.36"     # **contains a modern library for one-way hashing of passwords.
export OP_Shadow="shadow-4.14.5"           # **contains programs for handling passwords in a secure way.
export OP_GCC="gcc-13.2.0"                 # ***contains the GNU compiler collection, which includes the C and C++ compilers.
export OP_Ncurses="ncurses-6.4-20230520"   # ***contains libraries for terminal-independent handling of character screens.
export OP_Sed="sed-4.9"                    # **contains stream editor. (Note:: used to replace strings in files)
export OP_Psmisc="psmisc-23.6"             # ***contains programs for displaying information about running processes.
export OP_Gettext="gettext-0.22.4"         # ****contains utilities for internationalization and localization. These allow programs to be compiled with NLS (Native Language Support), enabling them to output messages in the user's native language.
export OP_Bison="bison-3.8.2"              # **contains a parser generator.
export OP_Grep="grep-3.11"                 # **contains programs for searching through the contents of files.
export OP_Bash="bash-5.2.21"               # *****contains the Bourne-Again Shell
export OP_Libtool="libtool-2.4.7"          # **contains the GNU generic library support script. It makes the use of shared libraries simpler with a consistent, portable interface.
export OP_GDBM="gdbm-1.23"                 # ***contains the GNU Database Manager. It is a library of database functions that uses extensible hashing and works like the standard UNIX dbm. The library provides primitives for storing key/data pairs, searching and retrieving the data by its key and deleting a key along with its data.
export OP_Gperf="gperf-3.1"                # ****generates a perfect hash function from a key set.
export OP_Expat="expat-2.6.2"              # **contains a stream oriented C library for parsing XML.
export OP_Inetutils="inetutils-2.5"        # ***contains programs for basic networking.
export OP_Less="Less-643"                  # **contains a text file viewer. (Note::for man commands)
export OP_Perl="perl-5.38.2"               # *contains the Practical Extraction and Report Language.
export OP_XML="XML-Parser-2.47"            # *module is a Perl interface to James Clark's XML parser, Expat.
export OP_Intltool="intltool-0.51.0"       # **internationalization tool used for extracting translatable strings from source files.
export OP_Autoconf="autoconf-2.72"         # **contains programs for producing shell scripts that can automatically configure source code.
export OP_Automake="automake-1.16.5"       # **contains programs for generating Makefiles for use with Autoconf.
export OP_OpenSSL="openssl-3.2.1"          # *****contains management tools and libraries relating to cryptography. These are useful for providing cryptographic functions to other packages, such as OpenSSH, email applications, and web browsers (for accessing HTTPS sites).
export OP_Kmod="Kmod-31"                   # *****contains libraries and utilities for loading kernel modules
export OP_Libelf="elfutils-0.190"          # a library for handling ELF (Executable and Linkable Format) files. (NOTE:: The use ?)
export OP_Libffi="libffi-3.4.4"            # ***provides a portable, high level programming interface to various calling conventions. This allows a programmer to call any function specified by a call interface description at run time. FFI stands for Foreign Function Interface. An FFI allows a program written in one language to call a program written in another language. Specifically, Libffi can provide a bridge between an interpreter like Perl, or Python, and shared library subroutines written in C, or C++.
export OP_Python="Python-3.12.2"           # **contains the Python development environment. It is useful for object-oriented programming, writing scripts, prototyping large programs, and developing entire applications. Python is an interpreted computer language.
export OP_Python_docs="python-3.12.2"           
export OP_Flit_Core="flit_core-3.9.0"      # **is the distribution-building parts of Flit (a packaging tool for simple Python modules).
export OP_Wheel="wheel-0.42.0"             # *is a Python library that is the reference implementation of the Python wheel packaging standard.
export OP_Setuptools="setuptools-69.1.0"   # *a tool used to download, build, install, upgrade, and uninstall Python packages.
export OP_Ninja="ninja-1.11.1"             # *is a small build system with a focus on speed.
export OP_Meson="meson-1.3.2"              # ***an open source build system designed to be both extremely fast and as user friendly as possible.
export OP_Coreutils="coreutils-9.4"        # *****package contains the basic utility programs needed by every operating system.
export OP_Check="check-0.15.2"             # *unit testing framework for C.
export OP_Diffutils="diffutils-3.10"       # *****contains programs that show the differences between files or directories.
export OP_Gawk="gawk-5.3.0"                # *contains programs for manipulating text files.
export OP_Findutils="findutils-4.9.0"      # *****contains programs to find files. Programs are provided to search through all the files in a directory tree and to create, maintain, and search a database (often faster than the recursive find, but unreliable unless the database has been updated recently). Findutils also supplies the xargs program, which can be used to run a specified command on each file selected by a search.
export OP_Groff="groff-1.23.0"             # **contains programs for processing and formatting text and images.
export OP_GRUB="grub-2.12"                 # *****contains the GRand Unified Bootloader.
    export OP_Which="which-2.21"
export OP_Gzip="gzip-1.13"                 # contains programs for compressing and decompressing files.
export OP_IPRoute="iproute2-6.7.0"         # contains programs for basic and advanced IPV4-based networking.
export OP_Kbd="kbd-2.6.4"                  # contains key-table files, console fonts, and keyboard utilities.
export OP_Libpipeline="libpipeline-1.5.7"  # contains a library for manipulating pipelines of subprocesses in a flexible and convenient way.
export OP_Make="make-4.4.1"                # contains a program for controlling the generation of executables and other non-source files of a package from source files.
export OP_Patch="patch-2.7.6"              # contains a program for modifying or creating files by applying a “patch” file typically created by the diff program.
export OP_Tar="tar-1.35"                   # provides the ability to create tar archives as well as perform various other kinds of archive manipulation. Tar can be used on previously created archives to extract files, to store additional files, or to update or list files which were already stored.
export Texinfo="texinfo-7.1"               # contains programs for reading, writing, and converting info pages.
export OP_Vim="vim-9.1.0041"               # text editor.
export OP_MarkupSafe="markupsafe-2.1.5"    # Python module that implements an XML/HTML/XHTML Markup safe string.
export OP_Jinja="jinja2-3.1.3"             # Python module that implements a simple pythonic template language.
export OP_Udev="systemd-255.tar.xz"        # contains programs for dynamic creation of device nodes.
export OP_Man_DB="man_db-2.12.0"           # contains programs for finding and viewing man pages.
export OP_Procps_ng="procps-ng-4.0.4"      # contains programs for monitoring processes.
export OP_Util_linux="util-linux-2.39.3"   # contains miscellaneous utility programs. Among them are utilities for handling file systems, consoles, partitions, and messages.
export OP_E2fsprogs="e2fsprogs-1.47.0"     # contains the utilities for handling the ext2 file system. It also supports the ext3 and ext4 journaling file systems.
export OP_Sysklogd="sysklogd-1.5.1"        # contains programs for logging system messages, such as those emitted by the kernel when unusual things happen.
export OP_Sysvinit="sysvinit-3.08"         # contains programs for controlling the startup, running, and shutdown of the system.



#BLFS
export OP_CrackLib="cracklib-2.9.11"       # **contains a library used to enforce strong passwords by comparing user selected passwords to words in chosen word lists.
    export OP_CrackLib_words="cracklib-words-2.9.11"            # lib of passwords
    export OP_CrackLib_jhon_psw="john"
    export OP_CrackLib_cain_psw="cain"
    export OP_CrackLib_500_psw="500-worst-passwords"
    export OP_CrackLib_twitter_psw="twitter-banned"
    