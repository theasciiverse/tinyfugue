#!/bin/sh
# Builds TinyFugue on macOS with no libraries beyond the system's own:
# pcre2 and openssl come from Homebrew as static archives, ncurses and zlib
# from the system. Run from the repository root on a macOS runner.
# Leaves build/tf and build/tf-lib, like build-static.sh.
set -eu
brew install pcre2 openssl@3 autoconf automake >/dev/null
# a folder holding only the static archives, searched first, so the linker
# takes them instead of Homebrew's dylibs
static="$PWD/.static-libs"; mkdir -p "$static"
for f in "$(brew --prefix pcre2)/lib/libpcre2-8.a" "$(brew --prefix openssl@3)/lib/libssl.a" \
         "$(brew --prefix openssl@3)/lib/libcrypto.a"; do
  ln -sf "$f" "$static/"
done
# see build-static.sh: the 2007 configure needs regenerating for today's compilers
AUTOHEADER=true autoreconf -fi >/dev/null 2>&1
./configure --prefix=/usr --datadir=/usr/share --enable-256colors --enable-ssl \
  CPPFLAGS="-I$(brew --prefix pcre2)/include -I$(brew --prefix openssl@3)/include" \
  LDFLAGS="-L$static" >/dev/null
grep -q "define STDC_HEADERS 1" src/tfconfig.h
make >/dev/null
mkdir -p build
cp src/tf build/tf
strip build/tf
rm -rf build/tf-lib && cp -r tf-lib build/tf-lib
otool -L build/tf
if otool -L build/tf | tail -n +2 | grep -v -E "^\s*/(usr/lib|System/Library)/"; then
  echo "tf links a library outside the system" >&2; exit 1
fi
