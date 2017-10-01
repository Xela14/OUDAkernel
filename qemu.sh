#!/bin/sh
set -e 															# Exit immediately if a function doesn't succeed
echo "Running qemu"
flags=""
if [[ $# -gt 0 && $1 == "debug" ]]; then
	flags="-s -S"
	debug=1											# Pause the cpu at start up and set QEMU to listen on for remote debugging on port 1234
fi

"C:/Program Files/qemu/qemu-system-i386.exe" -kernel C:/cygwin/home/Alex/os/kernel/ouda.kernel $flags & #run in background

if [[ debug -eq 1 ]]; then
	gdb -x debug.gdb
fi
