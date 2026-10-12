# Changes from upstream

This is the Asciiverse packaging of TinyFugue 5.0 beta 8 by Ken Keys
(GPL-2.0-or-later), the last upstream release (2007, tinyfugue.sourceforge.net).
There is no upstream repository to track, so history here starts from the
release tarball as Debian distributes it (tf5_5.0beta8.orig.tar.gz, sha256
3750a114cf947b1e3d71cecbe258cb830c39f3186c369e368d4662de9c50d989), tagged
`5.0b8`.

## Debian's patches

Debian has kept TinyFugue building for years. Its 12 patches from
tf5 5.0beta8-14 (tf5_5.0beta8-14.debian.tar.xz, sha256
adcb6b2f12fa84494a0aae874c960b5fa874a7c3830e6aa645e9cad2ea11e07d) are
applied as one commit each, with their authors (Russ Allbery, Chris Lamb):
DESTDIR support, va_list use, man page and spelling fixes, a reproducible
build, the library install path, duplicate world_decl definitions, the
main_loop declaration, LDFLAGS for makehelp, the port to PCRE2 and a cast
for GCC 14. Tagged `debian/5.0b8-14`.

## Ours

- `src/malloc.c` includes `<sys/types.h>` for `caddr_t`. glibc declares it
  through headers port.h already pulls in; musl does not, so the static
  musl build failed. Worth offering to Debian.

## Packaging (new files)

- `asciiverse/build-static.sh`, `asciiverse/build-macos.sh`: static Linux
  and system-libraries-only macOS builds. Both regenerate configure with
  today's autoconf first, as Debian does: the 2007 configure tests for
  standard headers with code GCC 14 rejects.
- `asciiverse/tinyfugue`: the start script av launches. tf needs an
  absolute library path, so it sets TFLIBDIR to the tf-lib folder beside it.
- `asciiverse/nfpm.yaml`: .deb, .rpm, .apk and Arch packages named
  `tinyfugue-asciiverse`, installing /usr/bin/tf and /usr/share/tf-lib.
- `.github/workflows/release.yml`: builds all of it on a tag.

## Not built

- Windows: TinyFugue is a Unix program.
- Intel Macs: needs Homebrew's Intel libraries on the build runner.
