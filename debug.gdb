symbol-file ouda.sym
target remote localhost:1234
set disassembly-flavor intel
b _start
c
layout asm