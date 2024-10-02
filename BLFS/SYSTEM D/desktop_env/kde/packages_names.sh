#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

## Pre-requirement :
export PKG_icu="icu" "4c-75_1-src"          # The International Components for Unicode (ICU) package is a mature, widely used set of C/C++ libraries providing Unicode and Globalization support for software applications. ICU is widely portable and gives applications the same results on all platforms.
export PKG_Valgrind="valgrind-3.23.0"       # Valgrind is an instrumentation framework for building dynamic analysis tools. There are Valgrind tools that can automatically detect many memory management and threading bugs, and profile programs in detail. Valgrind can also be used to build new tools.
export PKG_libxml="libxml2-2.13.3"          # The libxml2 package contains libraries and utilities used for parsing XML files.
export PKG_nghttp2="nghttp2-1.62.1"         # an implementation of HTTP/2 and its header compression algorithm, HPACK.
export PKG_libuv="libuv-v1.48.0"            # is a multi-platform support library with a focus on asynchronous I/O
export PKG_libarchive="libarchive-3.7.4"    # The libarchive library provides a single interface for reading/writing various compression formats.
export PKG_libunistring="libunistring-1.2"  # is a library that provides functions for manipulating Unicode strings and for manipulating C strings according to the Unicode standard.
export PKG_libidn2="libidn2-2.3.7"          # libidn2 is a package designed for internationalized string handling based on standards from the Internet Engineering Task Force (IETF)'s IDN working group, designed for internationalized domain names.
export PKG_libpsl="libpsl-0.21.5"           # The libpsl package provides a library for accessing and resolving information from the Public Suffix List (PSL). The PSL is a set of domain names beyond the standard suffixes, such as .com.
export PKG_curl="curl-8.9.1"                # The cURL package contains an utility and a library used for transferring files with URL syntax to any of the following protocols: DICT, FILE, FTP, FTPS, GOPHER, GOPHERS, HTTP, HTTPS, IMAP, IMAPS, LDAP, LDAPS, MQTT, POP3, POP3S, RTSP, SMB, SMBS, SMTP, SMPTS, TELNET, and TFTP. Its ability to both download and upload files can be incorporated into other programs to support functions like streaming media.
export PKG_CMake="cmake-3.30.2"             # The CMake package contains a modern toolset used for generating Makefiles. It is a successor of the auto-generated configure script and aims to be platform- and compiler-independent. A significant user of CMake is KDE since version 4.
export PKG_Extra_cmake="xtra-cmake-modules-6.5.0" # contains extra CMake modules used by KDE Frameworks and other packages.
export PKG_xcb_proto="xcb-proto-1.17.0" 767 *req   # The xcb-proto package provides the XML-XCB protocol descriptions that libxcb uses to generate the majority of its code and API.
export PKG_util_macros="util-macros-1.20.1" 764 *req # The util-macros package contains the m4 macros used by all of the Xorg packages.
export PKG_xorg_proto="xorgproto-2024.1"    # provides the header files required to build the X Window system, and to allow other applications to build against the installed X Window system.
export PKG_libxau="libXau-1.0.11"           # a library implementing the X11 Authorization Protocol. This is useful for restricting client access to the display.
export PKG_libXdmcp="libXdmcp-1.1.5"        # contains a library implementing the X Display Manager Control Protocol. This is useful for allowing clients to interact with the X Display Manager.
export PKG_libxcb="libxcb-1.17.0"           # an interface to the X Window System protocol, which replaces the current Xlib interface. Xlib can also use XCB as a transport layer, allowing software to make requests and receive responses with both.
export PKG_freetype=""
export PKG_Fontconfig="" 301
export PKG_Xorg_lib="" 769
export PKG_Qt="" 871
export PKG_Glib=""
export PKG_phonon="" 909
export PKG_
export PKG_
export PKG_
export PKG_
export PKG_
export PKG_
export PKG_
export PKG_

## KDE : 
