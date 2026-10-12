# TinyFugue (Asciiverse packaging)

TinyFugue 5.0 beta 8, Ken Keys' classic programmable MUD client, with
Debian's patches, packaged for the Asciiverse catalog (kind `program`,
topic `mud-client`) and as system packages. Not our code: keep changes
small and list every one in PATCHES.md.

- No upstream repository exists; history starts from the release tarball
  (tag `5.0b8`), then Debian's patches (tag `debian/5.0b8-14`), then ours.
  `origin` is github.com/theasciiverse/tinyfugue; `debian` is Debian's tf5
  packaging repo, salsa.debian.org/rra/tf5 (its Vcs-Git).
- Release: tag `v5.0b8-av.<n>` and push it.
- Local static build: `docker run --rm -v "$PWD":/src -w /src alpine:3.22
  sh asciiverse/build-static.sh` leaves `build/tf` and `build/tf-lib`.
  It rewrites configure and other generated files: `git checkout` them
  afterwards.
- tf needs an absolute TFLIBDIR; av starts it through `asciiverse/tinyfugue`.
- Connect: `tf <host> <port>`, or `/connect` inside tf.
