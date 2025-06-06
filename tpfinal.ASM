.8086
.model small
.stack 100h

.data

Bienvenido db "PIEDRA, PAPEL O TIJERA!!",24h
tecla db "PRESS ENTER...",24h
elegir db"INGRESE SU OPCION",0dh,24h
OPC db"1.PIEDRA      "
    db "2.PAPEL      "
    db "3.TIJERA     ",24h
empate db "EMPATE!!!!!!",24h
perdiste db "PERDISTE!!!!!",24h
ganaste db "GANASTE!!!!!!",24h
vuelve db "VUELVE A JUGAR PRESIONE S, PARA SALIR PRESIONE N",24h
varPiedra db "PIEDRA",0DH, 0AH,24H
varPapel db "PAPEL",0DH, 0AH,24H
varTijera db "TIJERA",0DH, 0AH,24H
varVersus db "VS",0DH, 0AH,24H
score db "0:0", 0dh,0ah,24h
puntaje db "---------SCORE------------", 0dh,0ah,24h
varError db "EL NUMERO INGRESADO NO ES VALIDO",0dh,0ah,24h
.code

 extrn RANDOM:proc
 extrn bordeSup:proc
 extrn bordeInf:proc
 extrn imprimir:proc
 extrn ubicarCentro:proc
 extrn ubicarj1:proc
 extrn ubicarCom:proc
 extrn ubicarVs:proc
 extrn ubicarCursor1:proc
 extrn ubicarCursor2:proc


     main proc
        mov ax, @data
        mov ds, ax


;----------------------LLAMA A LA INT 80 QUE LIMPIA LA PANTALLA----------------------------------------------
int 80h

xor ax, ax
call bordeSup         ;LLAMA AL BORDE SUPERIOR ---------------------------------------------------------------
xor ax, ax
call bordeInf         ;LLAMA AL BORDE INFERIOR ---------------------------------------------------------------

;----------------------UBICA AL CURSOR ----------------------------------------------------------------------
mov ah,02h
mov dh,10
mov dl,26
int 10h


mov bx,offset bienvenido ;IMPRIME CARTEL DE BIENVENIDA 
call imprimir ;LLAMA A LA FUNCION IMPRIMIR PARA IMPRIMIR EL CARTEL DE INICIO DEL JUEGO -----------------------


;----------------------UBICA AL CURSOR ----------------------------------------------------------------------
mov ah,02h
mov dh,15
mov dl,30
int 10h

mov ah,09h
mov dx,offset tecla ;IMPRIME CARTEL PARA PRESIONAR ENTER ----------------------------------------------------
int 21h
mov ah, 01h
int 21h

cmp al, 0dh ;COMPARA LO QUE VIENE POR TECLADO CON ENTER
jmp sigue

xor si, si
xor di, di

sigue:
;----------------------LLAMA A LA INT 80 QUE LIMPIA LA PANTALLA----------------------------------------------

int 80h


call bordeSup ;LLAMA AL BORDE SUPERIOR ----------------------------------------------------------------------
call bordeInf ;LLAMA AL BORDE INFERIOR ----------------------------------------------------------------------



;----------------------UBICA AL CURSOR ----------------------------------------------------------------------
call ubicarCursor1

mov ah,09h
mov dx,offset elegir ;IMPRIME CARTEL PARA ELEGIR OPCION -------------------------------------------------------
int 21h

;----------------------UBICA AL CURSOR ----------------------------------------------------------------------
mov ah,02h
mov dh,15
mov dl,15
int 10h

mov ah,09h

mov dx,offset OPC ;IMPRIME CARTEL PIEDRA -- PAPEL -- TIJERA -------------------------------------------------
int 21h

;----------------------UBICA AL CURSOR ----------------------------------------------------------------------
mov ah,02h
mov dh,22
mov dl,0
int 10h


;----------------------IMPRIME BORDE INFERIOR ---------------------------------------------------------------
mov ah,09h
mov al,'='
mov bl,10
mov cx,80
int 10h

;----------------------UBICA AL CURSOR ----------------------------------------------------------------------

mov ah,02h
mov dh,23
mov dl,0
int 10h
;----------------------SALTO PARA CONTROLAR ERRORES DE INGRESO POR TECLADO-----------------------------------
mal:
xor al,al
mov ah, 01h
int 21h

cmp al, '1'
je va
cmp al, '2'
je va
cmp al, '3'
je va                 ;* VER PARA CONTROLAR ERROR DE ENTER hacer cartel de error 
mov bx, offset varError
call imprimir
jmp mal
va:
mov bl, al; --------EN BL TENGO LA OPCION ELEGIDA POR EL USUARIO -------------------------------------------



call RANDOM ;-------LLAMO A LA FUNCION RANDOM -------------------------------------------------------------
;----------------------LLAMA A LA INT 80 QUE LIMPIA LA PANTALLA----------------------------------------------
int 80h


;-------------QUEDA EN BH LA OPCION DE LA CPU, QUE VIENE DE RANDOM -------------------------------------------------------------
        mov bh, dl

;-------------------------IMPRIME LA OPCION QUE ELIGIO EL JUGADOR -------------------------------------------

        cmp bl, '1'
        je comespiedra
        cmp bl, '2'
        je comespapel
        cmp bl, '3'
        je comestijera



 comespiedra:
    call ubicarj1 ;------UBICA LA RESPUESTA DEL JUGADOR 1 EN LA PANTALLA ----------------------------------
    mov ah, 9 
    mov dl, offset varPiedra ;IMPRIME LA PALABRA "PIEDRA"-----------------------------------------------------
    int 21h
    call ubicarVs ;IMPRIME LA PALABRA "VS"-----------------------------------------------------
    mov ah, 9
    mov dl, offset varVersus
    int 21h
    jmp prosigue
 comespapel:
     call ubicarj1 ;------UBICA LA RESPUESTA DEL JUGADOR 1 EN LA PANTALLA ----------------------------------
    mov ah, 9 
    mov dl, offset varPapel ;IMPRIME LA PALABRA "PAPEL"-----------------------------------------------------
    int 21h
    call ubicarVs ;--------LLAMO A LA FUNCION QUE UBICA VS EN LA PANTALLA ----------------------------------
    mov ah, 9
    mov dl, offset varVersus ;IMPRIME LA PALABRA "VS"-----------------------------------------------------
    int 21h
    jmp prosigue
 comestijera:
    call ubicarj1 ;------UBICA LA RESPUESTA DEL JUGADOR 1 EN LA PANTALLA ----------------------------------
    mov ah, 9 
    mov dl, offset varTijera ;IMPRIME LA PALABRA "TIJERA"-----------------------------------------------------
    int 21h
    call ubicarVs ;--------LLAMO A LA FUNCION QUE UBICA VS EN LA PANTALLA ----------------------------------
    mov ah, 9
    mov dl, offset varVersus ;IMPRIME LA PALABRA "VS"-----------------------------------------------------
    int 21h
    jmp prosigue
prosigue:    
;------------------COMPARO LA RESPUESTA DE LA CPU CON LAS TRES POSIBILIDADES VALIDAS-------------------------
        cmp bh, '1'
        je comespiedra2
        cmp bh, '2'
        je comespapel2
        cmp bh, '3'
        je comestijera2



 comespiedra2:
 
    call ubicarCom ; UBICA EN LA PANTALLA LA OPCION DE LA CPU -----------------------------------------------

    mov ah, 9 
    mov dl, offset varPiedra ;IMPRIME LA PALABRA "PIEDRA"-----------------------------------------------------

    int 21h

    jmp prosigue2

 comespapel2:
 
    call ubicarCom

    mov ah, 9 
    mov dl, offset varPapel ;IMPRIME LA PALABRA "PAPEL"-----------------------------------------------------

    int 21h

    jmp prosigue2

 comestijera2:
 
    call ubicarCom

    mov ah, 9 
    mov dl, offset varTijera ;IMPRIME LA PALABRA "TIJERA"-----------------------------------------------------

    int 21h

    jmp prosigue2

prosigue2:           

        CMP   BL,   BH     ;COMPARO LAS DOS OPCIONES PARA VER SI HAY EMPATE ----------------------------------
        JE  emp
        


;=======================================        
        CMP   BL,   '1' ;COMPARA PARA VER SI EL JUGADOR ELIGIO PIEDRA --------------------------------------
        JE  EQ1 
        CMP   BL,   '2' ;COMPARA PARA VER SI EL JUGADOR ELIGIO PAPEL --------------------------------------
        JE  EQ2
        CMP   BL,   '3';COMPARA PARA VER SI EL JUGADOR ELIGIO TIJERA --------------------------------------
        JE  EQ3
        
    EQ1:
        CMP   BH,   '2' ; COMPARA PARA VER SI LA CPU ELIGIO PAPEL ----------------------------------------
        JE  lose        ; PERDIO JUGADOR ----------------------------------------------------------------
        CMP   BH,   '3' ; COMPARA PARA VER SI LA CPU ELIGIO TIJERA ---------------------------------------
        JE  gana        ; GANO JUGADOR

    EQ2: 
        CMP   BH,   '1' ;COMPARA PARA VER SI LA CPU ELIGIO PIEDRA ----------------------------------------
        JE  gana        ;GANA JUGADOR -------------------------------------------------------------------
        CMP   BH,   '3' ;COMPARA PARA VER SI LA CPU ELIGIO TIJERA ----------------------------------------
        JE  lose        ; PIERDE JUGADOR ----------------------------------------------------------------
 
    EQ3:  
        CMP   BH,   '1' ; COMPARA PARA VER SI LA CPU ELIGIO PIEDRA --------------------------------------
        JE  lose        ; PIERDE JUGADOR ----------------------------------------------------------------
        CMP   BH,   '2' ; COMPARA PARA VER SI LA CPU ELIGIO PAPEL----------------------------------------
        JE  gana        ; GANA JUGADOR ------------------------------------------------------------------


emp:

call bordeSup ; LLAMA A LA FUNCION QUE IMPRIME EL BORDE SUPERIOR ---------------------------------------------

;----------------------UBICA AL CURSOR ----------------------------------------------------------------------
call ubicarCentro ;LLAMA A LA FUNCION QUE UBICA CURSOR EN CENTRO --------------------------------------------

mov bx,offset empate ; IMPRIME LA PALABRA EMPATE -----------------------------------------------------------
call imprimir 

jmp fin

;---------------En SI guardo las partidas ganadas de J1, y en Di guardo las partidas ganadas de COM
gana:

call bordeInf

call bordeSup

call ubicarCentro


mov bx,offset ganaste ; IMPRIME LA PALABRA GANASTE -----------------------------------------------------------

call imprimir
add score[0], 1 ;SUMO 1 A SCORE[O] CUANDO GANA EL JUGADOR -------------------------------------------------- 
jmp fin

lose:

call bordeSup

call ubicarCentro

mov bx,offset perdiste ; IMPRIME LA PALABRA PERDISTE -----------------------------------------------------------

call imprimir

call bordeInf
add score[2], 1 ;SUMO 1 CUANDO GANA LA CPU -----------------------------------------------------------------
jmp fin


fin:

 call bordeInf


;nin:*
mov ah,02h
mov dh,4
mov dl,25
int 10h


mov ah, 9
mov dx, offset puntaje
int 21h

;UBICA EL CURSOR DE JUGADOR 1-------------------------------------------------------------------------------
mov ah,02h
mov dh,5
mov dl,35
int 10h


mov ah, 9
mov dx, offset score
int 21h

mov ah,02h
mov dh,20
mov dl,30
int 10h

mov ah,09h
mov dx,offset tecla ;IMPRIMO LA PALABRA ENTER ---------------------------------------------------------------
int 21h
mov ah, 01h
int 21h

;----------------------------------COMPARA CON 3, EL SCORE DE JUGADOR, SI LLEGA A 3 GANA -------------------------------------
cmp score[0], 33h
je finfin1
;----------------------------------COMPARA CON 3, EL SCORE DE LA CPU, SI LLEGA A 3 GANA -------------------------------------
cmp score[2], 33h 
je finfin

jmp sigue

;-UBICA EL CURSOR ------------------------------------------------------------------------------------------

mov ah,02h
mov dh,23
mov dl,0
int 10h

finfin1:
;INTERRUPCION QUE LIMPIA LA PANTALLA -----------------------------------------------------------------------
int 80h

call ubicarCentro


mov bx,offset ganaste ;IMPRIME LA PALABRA GANASTE ---------------------------------------------------------
call imprimir

jmp volver

finfin:

int 80h

call ubicarCentro

mov bx,offset perdiste ; IMPRIME LA PALABRA PERDISTE -------------------------------------------------------
call imprimir

volver:
;UBICA EL CURSOR -------------------------------------------------------------------------------------------
mov ah,02h
mov dh,19
mov dl,14
int 10h


mov ah,09h

mov dx,offset VUELVE ;IMPRIME CARTEL DE LA POSIBILIDAD DE ELEGIR ENTRE VOLVER A JUGAR O SALIR DEL PROGRAMA-- 
;mov cx,10
int 21h

nin:
mov ah, 1
int 21h

cmp al, 'S'
je sis
cmp al, 's'
je sis
cmp al, 'N'
je nos
cmp al, 'n'
je nos
jmp nin ;*

sis:

jmp sigue

nos: 


    mov ax, 4c00h
    int 21h
    main endp



end