@ECHO OFF
tasm intClear.asm
tlink /t intClear.obj
intClear.com
tasm /zi tpfinal.asm
tasm /zi libtp.asm
tlink /v tpfinal.obj libtp.obj
tpfinal.exe