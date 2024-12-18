#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing


### List aLL the packages names
# Compiling a Cross-Toolchain.. (used in step2.2)
export Binutils_P1="binutils-2.43.1"         # contains a linker, an assembler, and other tools for handling object files.
export GCC_P1="gcc-14.2.0"                   # contains the GNU compiler collection, which includes the C and C++ compilers.
export GCC_V="14.2.0"
    export GCC_P1_mpfr="mpfr-4.2.1"             # multiple-precision floating-point computations (needed on the host only not the target)
    export GCC_P1_gmp="gmp-6.3.0"               # dependency of mpfr (needed on the host only not the target)
    export GCC_P1_mpc="mpc-1.3.1"               # computation of complex numbers (needed on the host only not the target)
export Linux_Kernel="linux-6.10.5"           # expose the kernel's API for use by Glibc.
export Glibc_Tool="glibc-2.40"               # contains the main C library. This library provides the basic routines for allocating memory, searching directories, opening and closing files, reading and writing files, string handling, pattern matching, arithmetic, and so on.
export Glibc_V="2.40"
export Libstdc_Tool="libstdc++"              # from gcc-14.2.0 and it is the standard C++ library. It is needed to compile C++ code (part of GCC is written in C++), but we had to defer its installation when we built gcc-pass1 because Libstdc++ depends on Glibc, which was not yet available in the target directory.

# Cross Compiling Temporary Tools (used in step2.2)
export M4_Tool="m4-1.4.19"                   # contains a macro processor.
export Ncurses_Tool="ncurses-6.5"            # contains libraries for terminal-independent handling of character screens.
export Bash_Tool="bash-5.2.32"               # contains the Bourne-Again Shell
export Coreutils_Tool="coreutils-9.5"        # contains the basic utility programs needed by every operating system.
export Diffutils_Tool="diffutils-3.10"       # contains programs that show the differences between files or directories.
export File_Tool="file-5.45"                 # contains a utility for determining the type of a given file or files.
export Findutils_Tool="findutils-4.10.0"     # programs to find files. Programs are provided to search through all the files in a directory tree and to create, maintain, and search a database (often faster than the recursive find, but unreliable unless the database has been updated recently). Findutils also supplies the xargs program, which can be used to run a specified command on each file selected by a search.
export Gawk_Tool="gawk-5.3.0"                # contains programs for manipulating text files.
export Grep_Tool="grep-3.11"                 # contains programs for searching through the contents of files.
export Gzip_Tool="gzip-1.13"                 # contains programs for compressing and decompressing files.
export Make_Tool="make-4.4.1"                # contains a program for controlling the generation of executables and other non-source files of a package from source files.
export Patch_Tool="patch-2.7.6"              # contains a program for modifying or creating files by applying a “patch” file typically created by the diff program.
export Sed_Tool="sed-4.9"                    # contains stream editor.
export Tar_Tool="tar-1.35"                   # the ability to create tar archives as well as perform various other kinds of archive manipulation
export Xz_Tool="xz-5.6.2"                    # contains programs for compressing and decompressing files
export Binutils_P2="binutils-2.43.1"         # contains a linker, an assembler, and other tools for handling object files.
export GCC_P2="gcc-14.2.0"
    export GCC_P2_mpfr="mpfr-4.2.1"
    export GCC_P2_gmp="gmp-6.3.0"
    export GCC_P2_mpc="mpc-1.3.1"

# Entering Chroot and Building Additional Temporary Tools (used in step 4)
export Gettext_Tool="gettext-0.22.5"         # contains utilities for internationalization and localization. These allow programs to be compiled with NLS (Native Language Support), enabling them to output messages in the user's native language.
export Bison_Tool="bison-3.8.2"              # contains a parser generator.
export Perl_Tool="perl-5.40.0"               # contains the Practical Extraction and Report Language.
export Perl_V="5.40"
export Python_Tool="Python-3.12.5"           # contains the Python development environment
export Texinfo_Tool="texinfo-7.1"            # contains programs for reading, writing, and converting info pages.
export Util_linux="util-linux-2.40.2"        # contains miscellaneous utility programs.



# Installing Basic System Software (OP_ optional)
export OP_Man_pages="man-pages-6.9.1"      # ***contains over 2,400 man pages.
export OP_Iana_Etc="iana-etc-20240806"     # ***provides data for network services and protocols.
export OP_Glibc="glibc-2.40"               # ***contains the main C library. This library provides the basic routines for allocating memory, searching directories, opening and closing files, reading and writing files, string handling, pattern matching, arithmetic, and so on. (Note :: uses locals ?)
export OP_Zlib="zlib-1.3.1"                # *contains compression and decompression routines used by some programs
export OP_Bzip="bzip2-1.0.8"               # **contains programs for compressing and decompressing files. Compressing text files with bzip2 yields a much better compression percentage than with the traditional gzip.
export OP_Xz="xz-5.6.2"                    # ****contains programs for compressing and decompressing files. It provides capabilities for the lzma and the newer xz compression formats. Compressing text files with xz yields a better compression percentage than with the traditional gzip or bzip2 commands.
export OP_Zstd="zstd-1.5.6"                # ***a real-time compression algorithm, providing high compression ratios. It offers a very wide range of compression / speed trade-offs, while being backed by a very fast decoder.
export OP_Lz4="lz4-1.10.0"                 #  a lossless compression algorithm, providing compression speed greater than 500 MB/s per core. It features an extremely fast decoder, with speed in multiple GB/s per core. Lz4 can work with Zstandard to allow both algorithms to compress data faster.
export OP_File="file-5.45"                 # ****contains a utility for determining the type of a given file or files.
export OP_Readline="readline-8.2.13"       # ****a set of libraries that offer command-line editing and history capabilities.
export OR_M4="m4-1.4.19"                   # contains a macro processor. (NOTE:: use?)
export OP_Bc="bc-6.7.6"                    # contains an arbitrary precision numeric processing language.(NOTE:: use?)
export OP_Flex="flex-2.6.4"                # ***contains a utility for generating programs that recognize patterns in text.
export OP_Tcl="tcl8.6.14"                  # **contains the Tool Command Language, a robust general-purpose scripting language. The Expect package is written in Tcl (pronounced "tickle")
export OP_Expect="expect5.45.4"            # ***contains tools for automating, via scripted dialogues, interactive applications such as telnet, ftp, passwd, fsck, rlogin, and tip. Expect is also useful for testing these same applications as well as easing all sorts of tasks that are prohibitively difficult with anything else. The DejaGnu framework is written in Expect.
export OP_DejaGNU="dejagnu-1.6.3"          # **contains a framework for running test suites on GNU tools. It is written in expect, which itself uses Tcl (Tool Command Language).
export OP_Pkgconf="pkgconf-2.3.0"          # ***is a successor to pkg-config and contains a tool for passing the include path and/or library paths to build tools during the configure and make phases of package installations.
export OP_Binutils="binutils-2.43.1"       # ****contains a linker, an assembler, and other tools for handling object files.
export OP_GMP="gmp-6.3.0"                  # **contains math libraries. These have useful functions for arbitrary precision arithmetic.
export OP_MPFR="mpfr-4.2.1"                # **contains functions for multiple precision math.
export OP_MPC="mpc-1.3.1"                  # ****contains a library for the arithmetic of complex numbers with arbitrarily high precision and correct rounding of the result.
export OP_Attr="attr-2.5.2"                # **contains utilities to administer the extended attributes of filesystem objects.
export OP_Acl="acl-2.3.2"                  # *****contains utilities to administer Access Control Lists, which are used to define fine-grained discretionary access rights for files and directories. 
export OP_Libcap="libcap-2.70"             # ***implements the userspace interface to the POSIX 1003.1e capabilities available in Linux kernels. These capabilities partition the all-powerful root privilege into a set of distinct privileges.
export OP_Libxcrypt="libxcrypt-4.4.36"     # **contains a modern library for one-way hashing of passwords.
export OP_Shadow="shadow-4.16.0"           # **contains programs for handling passwords in a secure way.
export OP_GCC="gcc-14.2.0"                 # ***contains the GNU compiler collection, which includes the C and C++ compilers.
export OP_Ncurses="ncurses-6.5"            # ***contains libraries for terminal-independent handling of character screens.
export OP_Sed="sed-4.9"                    # **contains stream editor. (Note:: used to replace strings in files)
export OP_Psmisc="psmisc-23.7"             # ***contains programs for displaying information about running processes.
export OP_Gettext="gettext-0.22.5"         # ****contains utilities for internationalization and localization. These allow programs to be compiled with NLS (Native Language Support), enabling them to output messages in the user's native language.
export OP_Bison="bison-3.8.2"              # **contains a parser generator.
export OP_Grep="grep-3.11"                 # **contains programs for searching through the contents of files.
export OP_Bash="bash-5.2.32"               # *****contains the Bourne-Again Shell
export OP_Libtool="libtool-2.4.7"          # **contains the GNU generic library support script. It makes the use of shared libraries simpler with a consistent, portable interface.
export OP_GDBM="gdbm-1.24"                 # ***contains the GNU Database Manager. It is a library of database functions that uses extensible hashing and works like the standard UNIX dbm. The library provides primitives for storing key/data pairs, searching and retrieving the data by its key and deleting a key along with its data.
export OP_Gperf="gperf-3.1"                # ****generates a perfect hash function from a key set.
export OP_Expat="expat-2.6.2"              # **contains a stream oriented C library for parsing XML.
export OP_Inetutils="inetutils-2.5"        # ***contains programs for basic networking.
export OP_Less="less-661"                  # **contains a text file viewer. (Note::for man commands)
export OP_Perl="perl-5.40.0"               # *contains the Practical Extraction and Report Language.
export OP_XML="XML-Parser-2.47"            # *module is a Perl interface to James Clark's XML parser, Expat.
export OP_Intltool="intltool-0.51.0"       # **internationalization tool used for extracting translatable strings from source files.
export OP_Autoconf="autoconf-2.72"         # **contains programs for producing shell scripts that can automatically configure source code.
export OP_Automake="automake-1.17"         # **contains programs for generating Makefiles for use with Autoconf.
export OP_OpenSSL="openssl-3.3.1"          # *****contains management tools and libraries relating to cryptography. These are useful for providing cryptographic functions to other packages, such as OpenSSH, email applications, and web browsers (for accessing HTTPS sites).
export OP_Kmod="kmod-33"                   # *****contains libraries and utilities for loading kernel modules
export OP_Libelf="elfutils-0.191"          # a library for handling ELF (Executable and Linkable Format) files. (NOTE:: The use ?)
export OP_Libffi="libffi-3.4.6"            # ***provides a portable, high level programming interface to various calling conventions. This allows a programmer to call any function specified by a call interface description at run time. FFI stands for Foreign Function Interface. An FFI allows a program written in one language to call a program written in another language. Specifically, Libffi can provide a bridge between an interpreter like Perl, or Python, and shared library subroutines written in C, or C++.
export OP_Python="Python-3.12.5"           # **contains the Python development environment. It is useful for object-oriented programming, writing scripts, prototyping large programs, and developing entire applications. Python is an interpreted computer language.
export OP_Python_docs="python-3.12.5"           
export OP_Flit_Core="flit_core-3.9.0"      # **is the distribution-building parts of Flit (a packaging tool for simple Python modules).
export OP_Wheel="wheel-0.44.0"             # *is a Python library that is the reference implementation of the Python wheel packaging standard.
export OP_Setuptools="setuptools-72.2.0"   # *a tool used to download, build, install, upgrade, and uninstall Python packages.
export OP_Ninja="ninja-1.12.1"             # *is a small build system with a focus on speed.
export OP_Meson="meson-1.5.1"              # ***an open source build system designed to be both extremely fast and as user friendly as possible.
export OP_Coreutils="coreutils-9.5"        # *****package contains the basic utility programs needed by every operating system.
export OP_Check="check-0.15.2"             # *unit testing framework for C.
export OP_Diffutils="diffutils-3.10"       # *****contains programs that show the differences between files or directories.
export OP_Gawk="gawk-5.3.0"                # *contains programs for manipulating text files.
export OP_Findutils="findutils-4.10.0"     # *****contains programs to find files. Programs are provided to search through all the files in a directory tree and to create, maintain, and search a database (often faster than the recursive find, but unreliable unless the database has been updated recently). Findutils also supplies the xargs program, which can be used to run a specified command on each file selected by a search.
export OP_Groff="groff-1.23.0"             # **contains programs for processing and formatting text and images.
export OP_GRUB="grub-2.12"                 # *****contains the GRand Unified Bootloader.
    export OP_Which="which-2.21"            # shows the full path of (shell) commands installed in your PATH
    export OP_Libping="libpng-1.6.43"       # contains libraries used by other programs for reading and writing PNG files. The PNG format was designed as a replacement for GIF and, to a lesser extent, TIFF, with many improvements and extensions and lack of patent problems.
        export OP_Libping_patch="libpng-1.6.43"
    export OP_Harfbuzz="harfbuzz-9.0.0"     # contains an OpenType text shaping engine.
    export OP_Freetype="freetype-2.13.3"    # contains a library which allows applications to properly render TrueType fonts.
        export OP_Freetype_docs="freetype-doc-2.13.3"
    export OP_Popt="popt-1.19"              # contains the popt libraries which are used by some programs to parse command-line options.
    export OP_Mandoc="mandoc-1.14.6"        # an utility to format manual pages.
    export OP_Efivar="efivar-39"            # provides tools and libraries to manipulate EFI variables.
    export OP_Efibootmgr="efibootmgr-18"    # provides tools and libraries to manipulate EFI variables.
export OP_Gzip="gzip-1.13"                 # **contains programs for compressing and decompressing files.
export OP_IPRoute="iproute2-6.10.0"        # ****contains programs for basic and advanced IPV4-based networking.
export OP_Kbd="kbd-2.6.4"                  # *****contains key-table files, console fonts, and keyboard utilities.
export OP_Libpipeline="libpipeline-1.5.7"  # ***contains a library for manipulating pipelines of subprocesses in a flexible and convenient way.
export OP_Make="make-4.4.1"                # *****contains a program for controlling the generation of executables and other non-source files of a package from source files.
export OP_Patch="patch-2.7.6"              # contains a program for modifying or creating files by applying a “patch” file typically created by the diff program. (Note:: the use)
export OP_Tar="tar-1.35"                   # ****provides the ability to create tar archives as well as perform various other kinds of archive manipulation. Tar can be used on previously created archives to extract files, to store additional files, or to update or list files which were already stored.
export Texinfo="texinfo-7.1"               # **contains programs for reading, writing, and converting info pages.
export OP_Vim="vim-9.1.0660"               # ***text editor.
export OP_MarkupSafe="MarkupSafe-2.1.5"    # *Python module that implements an XML/HTML/XHTML Markup safe string.
export OP_Jinja="jinja2-3.1.4"             # *Python module that implements a simple pythonic template language.
    export OP_D_SYS_D="systemd-256.4"
    export OP_D_DBus="dbus-1.14.10"         # D-Bus is a message bus system, a simple way for applications to talk to one another. D-Bus supplies both a system daemon (for events such as "new hardware device added" or "printer queue changed") and a per-user-login-session daemon (for general IPC needs among user applications). Also, the message bus is built on top of a general one-to-one message passing framework, which can be used by any two applications to communicate directly (without going through the message bus daemon).
export OP_Udev="systemd-256.4"             # contains programs for dynamic creation of device nodes.
export OP_Man_DB="man-db-2.12.1"           # ***contains programs for finding and viewing man pages.
export OP_Procps_ng="procps-ng-4.0.4"      # **contains programs for monitoring processes.
export OP_Util_linux="util-linux-2.40.2"   # contains miscellaneous utility programs. Among them are utilities for handling file systems, consoles, partitions, and messages.
export OP_E2fsprogs="e2fsprogs-1.47.1"     # ***contains the utilities for handling the ext2 file system. It also supports the ext3 and ext4 journaling file systems.
export OP_Sysklogd="sysklogd-2.6.1"        # ***contains programs for logging system messages, such as those emitted by the kernel when unusual things happen.
export OP_Sysvinit="sysvinit-3.10"         # *****contains programs for controlling the startup, running, and shutdown of the system.


# Pakages for System Configuration
export SC_LFS_Bootscripts="lfs-bootscripts-20240825"    # contains a set of scripts to start/stop the LFS system at bootup/shutdown. The configuration files and procedures needed to customize the boot process are described in the following sections.
export SC_BLFS_Bootscripts="blfs-bootscripts-20240416"  # contains the init scripts that are used throughout the BLFS book. It is assumed that you will be using the BLFS Bootscripts package in conjunction with a compatible LFS-Bootscripts package.

#BLFS
export OP_CrackLib="cracklib-2.9.11"                    # **contains a library used to enforce strong passwords by comparing user selected passwords to words in chosen word lists.
    export OP_CrackLib_words="cracklib-words-2.10.2"            # lib of passwords
    export OP_CrackLib_jhon_psw="john"
    export OP_CrackLib_cain_psw="cain"
    export OP_CrackLib_500_psw="500-worst-passwords"
    export OP_CrackLib_twitter_psw="twitter-banned"
export OP_dhcpcd="dhcpcd-10.0.8"                        # an implementation of the DHCP client specified in RFC2131. A DHCP client is useful for connecting your computer to a network which uses DHCP to assign network addresses. dhcpcd strives to be a fully featured, yet very lightweight DHCP client.
export OP_dosfstools="dosfstools-4.2"                   # contains various utilities for use with the FAT family of file systems. (Helps in Createing an Emergency Boot Disk)