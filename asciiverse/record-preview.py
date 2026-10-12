#!/usr/bin/env python3
"""Records asciiverse/tinyfugue.cast, TinyFugue's catalog preview, at 100x30
(hub/RECORDING.md): `tf mud.lysator.liu.se 2000`, showing tf starting and
NannyMUD's greeting, then /quit. Nothing is sent to the MUD beyond
connecting. Usage, from the repo root after asciiverse/build-static.sh:
    python3 asciiverse/record-preview.py"""
import os, pty, shutil, struct, fcntl, select, tempfile, termios, time

root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
home = tempfile.mkdtemp()
env = dict(os.environ, HOME=home, TERM="xterm-256color", COLORTERM="truecolor", LANG="C.UTF-8",
           TFLIBDIR=f"{root}/build/tf-lib")
keys = [(9.0, b"/quit\r"), (2.0, b"")]

pid, fd = pty.fork()
if pid == 0:
    os.execvpe("asciinema", ["asciinema", "rec", "--overwrite", "-q", "-i", "2",
        "--capture-env", "TERM,COLORTERM,LANG", "-c", f"{root}/build/tf mud.lysator.liu.se 2000",
        f"{root}/asciiverse/tinyfugue.cast"], env)
fcntl.ioctl(fd, termios.TIOCSWINSZ, struct.pack("HHHH", 30, 100, 0, 0))
for wait, key in keys:
    end = time.time() + wait
    while time.time() < end:
        r, _, _ = select.select([fd], [], [], 0.05)
        if r:
            try: os.read(fd, 65536)
            except OSError: break
    if key: os.write(fd, key)
try: os.waitpid(pid, 0)
except ChildProcessError: pass
shutil.rmtree(home)
