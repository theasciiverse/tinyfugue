#!/bin/sh
# Builds a fully static TinyFugue in Alpine: ncurses, pcre2, openssl and
# zlib come as Alpine's static libraries. Run from the repository root
# inside alpine:3.22:
#   docker run --rm -v "$PWD":/src -w /src alpine:3.22 sh asciiverse/build-static.sh
# Leaves the binary at build/tf and the macro library at build/tf-lib.
# The compiled-in library path is /usr/share/tf-lib (where the system
# packages put it); av launches tf with -Ltf-lib instead.
set -eu
apk add --no-cache build-base ncurses-dev ncurses-static pcre2-dev pcre2-static \
  openssl-dev openssl-libs-static zlib-dev zlib-static autoconf automake >/dev/null
# The shipped 2007 configure tests for standard headers with code GCC 14
# rejects, then decides there are none. Like Debian (debhelper's
# dh_autoreconf, with AUTOHEADER=true), regenerate it with today's autoconf.
AUTOHEADER=true autoreconf -fi >/dev/null 2>&1
# musl defines caddr_t (used by src/malloc.c) only with _GNU_SOURCE.
# --enable-256colors and --enable-ssl as in Debian's tf5.
./configure --prefix=/usr --datadir=/usr/share --enable-256colors --enable-ssl \
  CFLAGS="-O2 -D_GNU_SOURCE" LDFLAGS="-static" >/dev/null
grep -q "define STDC_HEADERS 1" src/tfconfig.h
make >/dev/null
mkdir -p build
cp src/tf build/tf
strip build/tf
rm -rf build/tf-lib && cp -r tf-lib build/tf-lib
