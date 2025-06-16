@ECHO OFF
tasm intClear.asm
tlink /t intClear.obj
intClear.com
tasm /zi tpfinal.asm
tasm /zi libtp.asm
tasm /zi intro.asm
tlink /v tpfinal.obj libtp.obj intro.obj
tpfinal.exe