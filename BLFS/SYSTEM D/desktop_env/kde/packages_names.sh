#!/bin/bash

# this bash code was made by chroot team to automate the operation of creating Linux from scratch with the help of LFS book v12.2 (https://www.linuxfromscratch.org/lfs)
# don't edit this file to insure that it works properly unless you know what are you doing

## Pre-requirement :
export PKG_icu="icu"                                        # The International Components for Unicode (ICU) package is a mature, widely used set of C/C++ libraries providing Unicode and Globalization support for software applications. ICU is widely portable and gives applications the same results on all platforms.
export PKG_Valgrind="valgrind-3.23.0"                       # Valgrind is an instrumentation framework for building dynamic analysis tools. There are Valgrind tools that can automatically detect many memory management and threading bugs, and profile programs in detail. Valgrind can also be used to build new tools.
export PKG_libxml="libxml2-2.13.3"                          # The libxml2 package contains libraries and utilities used for parsing XML files.
export PKG_nghttp2="nghttp2-1.62.1"                         # an implementation of HTTP/2 and its header compression algorithm, HPACK.
export PKG_libuv="libuv-v1.48.0"                            # is a multi-platform support library with a focus on asynchronous I/O
export PKG_libarchive="libarchive-3.7.4"                    # The libarchive library provides a single interface for reading/writing various compression formats.
export PKG_libunistring="libunistring-1.2"                  # is a library that provides functions for manipulating Unicode strings and for manipulating C strings according to the Unicode standard.
export PKG_libidn2="libidn2-2.3.7"                          # libidn2 is a package designed for internationalized string handling based on standards from the Internet Engineering Task Force (IETF)'s IDN working group, designed for internationalized domain names.
export PKG_libpsl="libpsl-0.21.5"                           # The libpsl package provides a library for accessing and resolving information from the Public Suffix List (PSL). The PSL is a set of domain names beyond the standard suffixes, such as .com.
export PKG_curl="curl-8.9.1"                                # The cURL package contains an utility and a library used for transferring files with URL syntax to any of the following protocols: DICT, FILE, FTP, FTPS, GOPHER, GOPHERS, HTTP, HTTPS, IMAP, IMAPS, LDAP, LDAPS, MQTT, POP3, POP3S, RTSP, SMB, SMBS, SMTP, SMPTS, TELNET, and TFTP. Its ability to both download and upload files can be incorporated into other programs to support functions like streaming media.
export PKG_CMake="cmake-3.30.2"                             # The CMake package contains a modern toolset used for generating Makefiles. It is a successor of the auto-generated configure script and aims to be platform- and compiler-independent. A significant user of CMake is KDE since version 4.
export PKG_Extra_cmake="extra-cmake-modules-6.5.0"          # contains extra CMake modules used by KDE Frameworks and other packages.

export PKG_xcb_proto="xcb-proto-1.17.0"                     # The xcb-proto package provides the XML-XCB protocol descriptions that libxcb uses to generate the majority of its code and API.
export PKG_util_macros="util-macros-1.20.1"                 # The util-macros package contains the m4 macros used by all of the Xorg packages.
export PKG_xorg_proto="xorgproto-2024.1"                    # provides the header files required to build the X Window system, and to allow other applications to build against the installed X Window system.
export PKG_libxau="libXau-1.0.11"                           # a library implementing the X11 Authorization Protocol. This is useful for restricting client access to the display.
export PKG_libXdmcp="libXdmcp-1.1.5"                        # contains a library implementing the X Display Manager Control Protocol. This is useful for allowing clients to interact with the X Display Manager.
export PKG_libxcb="libxcb-1.17.0"                           # an interface to the X Window System protocol, which replaces the current Xlib interface. Xlib can also use XCB as a transport layer, allowing software to make requests and receive responses with both.
export PKG_Fontconfig="fontconfig-2.15.0"                   # contains a library and support programs used for configuring and customizing font access.
export PKG_Xorg_lib="lib"                                   # library routines that are used within all X Window applications.
export PKG_Qt="qt-everywhere-src-6.7.2"                     # a cross-platform application framework that is widely used for developing application software with a graphical user interface (GUI) (in which cases Qt6 is classified as a widget toolkit), and also used for developing non-GUI programs such as command-line tools and consoles for servers.
export PKG_Packaging="packaging-24.1"                       # The Packaging library provides utilities that implement the interoperability specifications which have clearly one correct behaviour (PEP440) or benefit greatly from having a single shared implementation (PEP425). This includes utilities for version handling, specifiers, markers, tags, and requirements.
export PKG_shared_mime_info="shared-mime-info-2.4"          # contains a MIME database. This allows central updates of MIME information for all supporting applications
export PKG_desktop_file_utils="desktop-file-utils-0.27"     # contains command line utilities for working with Desktop entries. These utilities are used by Desktop Environments and other applications to manipulate the MIME-types application databases and help adhere to the Desktop Entry Specification.
export PKG_Glib="glib-2.80.4"                               # contains low-level libraries useful for providing data structure handling for C, portability wrappers and interfaces for runtime functionality such as an event loop, threads, dynamic loading and an object system.
export PKG_phonon="phonon-4.12.0"                           # multimedia API for KDE. It replaces the old aRts package. Phonon needs the VLC backend.

export PKG_vlc="vlc-3.0.21"                                 # is a media player, streamer, and encoder. It can play from many inputs, such as files, network streams, capture devices, desktops, or DVD, SVCD, VCD, and audio CD. It can use most audio and video codecs (MPEG 1/2/4, H264, VC-1, DivX, WMV, Vorbis, AC3, AAC, etc.), and it can also convert to different formats and/or send streams through the network.
export PKG_phonon_backend="phonon-backend-vlc-0.12.0"       # provides a Phonon backend which utilizes the VLC media framework.



export PKG_cracklib="cracklib-2.10.2"                       # contains a library used to enforce strong passwords by comparing user selected passwords to words in chosen word lists.
export PKG_libpwquality="libpwquality-1.4.5"                # provides common functions for password quality checking and also scoring them based on their apparent randomness. The library also provides a function for generating random passwords with good pronounceability.
export PKG_Linux_PAM="Linux-PAM-1.6.1"                      # contains Pluggable Authentication Modules used by the local system administrator to control how application programs authenticate users.
    # require re-build OP_D_SYS_D (lfs pkg) && reconf kernel
export PKG_Systemd="systemd-256.4"
export PKG_shadow="shadow-4.16.0"
export PKG_polkit="polkit-125"                              # Polkit is a toolkit for defining and handling authorizations. It is used for allowing unprivileged processes to communicate with privileged processes.
export PKG_polkit_qt="polkit-qt-1-0.200.0"
export PKG_
export PKG_
export PKG_
export PKG_
export PKG_
export PKG_
export PKG_
export PKG_
export PKG_

## KDE : 
