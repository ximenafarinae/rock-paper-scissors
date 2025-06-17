.8086
.model small
.stack 100h

.data
Bienvenido   db "PIEDRA, PAPEL O TIJERA!!", 24h
ingresarNick db "INGRESE SU NICKNAME: ", 24h
tecla        db "PRESS ENTER...", 24h
elegir       db "INGRESE SU OPCION", 0dh, 24h
OPC          db "1.PIEDRA      "
             db "2.PAPEL       "
             db "3.TIJERA      ", 24h
empate       db "EMPATE!!!!!!!", 24h
perdiste     db "PERDISTE!!!!!", 24h
ganaste      db "GANASTE!!!!!!", 24h
vuelve       db "VUELVE A JUGAR PRESIONE S, PARA SALIR PRESIONE N: ", 24h
varPiedra    db "PIEDRA", 0dh, 0ah, 24H
varPapel     db "PAPEL", 0dh, 0ah, 24H
varTijera    db "TIJERA", 0dh, 0ah, 24H
varVersus    db "VS", 0dh, 0ah, 24H
score        db "0:0", 0dh, 0ah, 24h
puntaje      db "------------SCORE------------", 0dh, 0ah, 24h
jugadores    db "          VS INTEL 8086", 0dh, 0ah, 24h
varError     db "EL NUMERO INGRESADO NO ES VALIDO", 0dh, 0ah, 24h
nickname     db 10 dup(24h)
theme       DW  659,6    ; E5 ♫ corchea
            DW  659,6    ; E5
            DW    0,6    ; silencio
            DW  659,6    ; E5
            DW    0,12   ; silencio negra
            DW  523,6    ; C5
            DW  659,6    ; E5
            DW  784,12   ; G5 negra
            DW  392,12   ; G4
            DW    0,12   ; silencio negra

            DW  523,6    ; C5
            DW  392,6    ; G4
            DW    0,6    ; silencio
            DW  330,6    ; E4
            DW    0,12   ; silencio negra
            DW  440,6    ; A4
            DW  494,12   ; B4
            DW  466,6    ; Bb4
            DW  440,12   ; A4

            DW  392,6    ; G4
            DW  659,6    ; E5
            DW  784,6    ; G5
            DW  880,6    ; A5
            DW  698,6    ; F5
            DW  784,6    ; G5
            DW    0,6    ; silencio

            DW  659,6    ; E5
            DW    0,6    ; silencio
            DW  523,6    ; C5
            DW  587,6    ; D5
            DW  494,12   ; B4
            DW    0,12   ; silencio

            DW  523,6    ; C5
            DW  392,6    ; G4
            DW  330,6    ; E4
            DW  294,6    ; D4
            DW  262,12   ; C4
            DW 0FFFFh,0  ; <— fin de tabla

.code
 extrn RANDOM:proc
 extrn bordeSup:proc
 extrn bordeInf:proc
 extrn imprimir:proc
 extrn ubicarCentro:proc
 extrn ubicarj1:proc
 extrn ubicarCom:proc
 extrn ubicarVs:proc
 extrn ingresoNick:proc
 extrn compara:proc
 extrn getMainIntro:proc
 extrn playSequence:proc

main proc
   mov ax, @data
   mov ds, ax

   call getMainIntro

   lea si, theme
   call playSequence

int 80h               ;LLAMA A LA INT 80 QUE LIMPIA LA PANTALLA----------------------------------------------
xor ax, ax
call bordeSup         ;LLAMA AL BORDE SUPERIOR --------------------------------------------------------------
xor ax, ax
call bordeInf         ;LLAMA AL BORDE INFERIOR --------------------------------------------------------------

mov ah, 02h           ;UBICA AL CURSOR ----------------------------------------------------------------------
mov dh, 10
mov dl, 26
int 10h

mov bx, offset Bienvenido  ;IMPRIME CARTEL DE BIENVENIDA 
call imprimir              ;LLAMA A LA FUNCION IMPRIMIR PARA IMPRIMIR EL CARTEL DE INICIO DEL JUEGO -------

mov ah, 02h                ;UBICA AL CURSOR ---------------------------------------------------------------
mov dh, 11 ; Fila 11
mov dl, 26 ; Columna 0
int 10h

mov bx,offset ingresarNick ;IMPRIME INDICADOR PARA QUE EL USUARIO INGRESE SU APODO
call imprimir              ;LLAMA A LA FUNCION IMPRIMIR PARA IMPRIMIR EL CARTEL DE INICIO DEL JUEGO -------

mov dx, offset nickname    ;Atraves de dx retorno el texto q ingresa el usu. en el proce. "ingreso_texto"
call ingresoNick

mov al, nickname[0]
mov jugadores[5], al

mov al, nickname[1]
mov jugadores[6], al

mov al, nickname[2]
mov jugadores[7], al

mov al, nickname[3]
mov jugadores[8], al

teclaEnt:
mov ah, 02h           ;UBICA AL CURSOR ---------------------------------------------------------------------
mov dh, 15
mov dl, 30
int 10h

mov ah, 09h
mov dx, offset tecla  ;IMPRIME CARTEL PARA PRESIONAR ENTER -------------------------------------------------
int 21h

mov ah, 01h
int 21h

cmp al, 0dh           ;COMPARA LO QUE VIENE POR TECLADO CON ENTER
je sigue
jmp teclaEnt

sigue:  
xor si, si
xor di, di

int 80h              ;LLAMA A LA INT 80 QUE LIMPIA LA PANTALLA---------------------------------------------
call bordeSup        ;LLAMA AL BORDE SUPERIOR -------------------------------------------------------------
call bordeInf        ;LLAMA AL BORDE INFERIOR -------------------------------------------------------------

mov ah, 02h             ;UBICA AL CURSOR -----------------------------------------------------------------
mov dh, 4
mov dl, 25
int 10h

mov ah, 9
mov dx, offset puntaje
int 21h

mov ah, 02h              ;UBICA AL CURSOR ----------------------------------------------------------------
mov dh, 5
mov dl, 25
int 10h

mov ah, 9
mov dx, offset jugadores
int 21h

;mov bx, offset jugadores ;IMPRIME LOS JUGADORES
;call imprimir ;LLAMA A LA FUNCION IMPRIMIR-----------------------

mov ah, 02h           ;UBICA AL CURSOR JUGADOR 1 ---------------------------------------------------------
mov dh, 6
mov dl, 35
int 10h

mov ah, 9
mov dx, offset score
int 21h

mov ah, 02h          ;UBICA AL CURSOR ---------------------------------------------------------------------
mov dh, 10
mov dl, 30
int 10h

mov bx, offset elegir
call imprimir

mov ah, 02h          ;UBICA AL CURSOR ---------------------------------------------------------------------
mov dh, 15
mov dl, 22
int 10h

mov ah, 09h
mov dx, offset OPC  ;IMPRIME CARTEL PIEDRA -- PAPEL -- TIJERA --------------------------------------
int 21h

mov ah, 02h         ;UBICA AL CURSOR ---------------------------------------------------------------
mov dh, 22
mov dl, 0
int 10h

mov ah, 09h         ;IMPRIME BORDE INFERIOR --------------------------------------------------------
mov al, '*'
mov bl, 10
mov cx, 80
int 10h

mov ah, 02h          ;UBICA AL CURSOR --------------------------------------------------------------
mov dh, 23
mov dl, 0
int 10h

mal:                ;SALTO PARA CONTROLAR ERRORES DE INGRESO POR TECLADO-----------------------------
xor al, al
mov ah, 01h
int 21h

; ELECCION DEL JUGADOR --------------------------------------------------------------------
cmp al, '1'
je va
cmp al, '2'
je va
cmp al, '3'
je va                ;* VER PARA CONTROLAR ERROR DE ENTER hacer cartel de error 
mov bx, offset varError
call imprimir
jmp mal
va:
mov bl, al      ;EN BL TENGO LA OPCION ELEGIDA POR EL USUARIO ------------------------------

call RANDOM     ;LLAMO A LA FUNCION RANDOM -------------------------------------------------
int 80h         ;INTERRUPCION QUE LIMPIA LA PANTALLA ---------------------------------------
mov bh, dl      ;QUEDA EN BH LA OPCION DE LA CPU, QUE VIENE DE RANDOM ----------------------

;======================= IMPRIME LA OPCION QUE ELIGIO EL JUGADOR ===========================
        cmp bl, '1'
        je comespiedra
        cmp bl, '2'
        je comespapel
        cmp bl, '3'
        je comestijera
 comespiedra:
    call ubicarj1 ;------UBICA LA RESPUESTA DEL JUGADOR 1 EN LA PANTALLA ----------------------------------
    mov ah, 9 
    mov dl, offset varPiedra ;IMPRIME LA PALABRA "PIEDRA"--------------------------------------------------
    int 21h
    call ubicarVs ;IMPRIME LA PALABRA "VS"-----------------------------------------------------------------
    mov ah, 9
    mov dl, offset varVersus
    int 21h
    jmp prosigue
 comespapel:
     call ubicarj1 ;------UBICA LA RESPUESTA DEL JUGADOR 1 EN LA PANTALLA ---------------------------------
    mov ah, 9 
    mov dl, offset varPapel ;IMPRIME LA PALABRA "PAPEL"----------------------------------------------------
    int 21h
    call ubicarVs ;--------LLAMO A LA FUNCION QUE UBICA VS EN LA PANTALLA ----------------------------------
    mov ah, 9
    mov dl, offset varVersus ;IMPRIME LA PALABRA "VS"-----------------------------------------------------
    int 21h
    jmp prosigue
 comestijera:
    call ubicarj1 ;------UBICA LA RESPUESTA DEL JUGADOR 1 EN LA PANTALLA ---------------------------------
    mov ah, 9 
    mov dl, offset varTijera ;IMPRIME LA PALABRA "TIJERA"-------------------------------------------------
    int 21h
    call ubicarVs ;--------LLAMO A LA FUNCION QUE UBICA VS EN LA PANTALLA --------------------------------
    mov ah, 9
    mov dl, offset varVersus ;IMPRIME LA PALABRA "VS"-----------------------------------------------------
    int 21h
    jmp prosigue
;======================= IMPRIME LA OPCION QUE ELIGIO EL CPU ===========================
prosigue:    
        cmp bh, '1'
        je comespiedra2
        cmp bh, '2'
        je comespapel2
        cmp bh, '3'
        je comestijera2
 comespiedra2:
    call ubicarCom ; UBICA EN LA PANTALLA LA OPCION DE LA CPU ---------------------------------------------
    mov ah, 9 
    mov dl, offset varPiedra ;IMPRIME LA PALABRA "PIEDRA"--------------------------------------------------
    int 21h
    jmp comparajugadas
 comespapel2:
    call ubicarCom
    mov ah, 9 
    mov dl, offset varPapel ;IMPRIME LA PALABRA "PAPEL"----------------------------------------------------
    int 21h
    jmp comparajugadas
 comestijera2:
    call ubicarCom
    mov ah, 9 
    mov dl, offset varTijera ;IMPRIME LA PALABRA "TIJERA"--------------------------------------------------
    int 21h
    jmp comparajugadas

comparajugadas:
;=========================== C O M P A R A C I O N E S ==================================
call compara            ;Llamar a la funcion externa
;Evaluar resultado en AL
cmp AL, 0
je  emp
cmp AL, 1
je  gana
cmp AL, 2
je  lose

emp:
call bordeSup            ;LLAMA A LA FUNCION QUE IMPRIME EL BORDE SUPERIOR ------------------------------
call ubicarCentro        ;LLAMA A LA FUNCION QUE UBICA CURSOR EN CENTRO ---------------------------------
mov bx, offset empate    ;IMPRIME LA PALABRA EMPATE -----------------------------------------------------
call imprimir 

jmp fin

;---------------En SI guardo las partidas ganadas de J1, y en Di guardo las partidas ganadas de COM
gana:
call bordeInf
call bordeSup
call ubicarCentro
mov bx, offset ganaste ;IMPRIME LA PALABRA GANASTE -----------------------------------------------------
call imprimir
add score[0], 1        ;SUMO 1 A SCORE[O] CUANDO GANA EL JUGADOR ---------------------------------------

jmp fin

lose:
call bordeSup
call ubicarCentro
mov bx, offset perdiste ;IMPRIME LA PALABRA PERDISTE -------------------------------------------------
call imprimir
call bordeInf
add score[2], 1         ;SUMO 1 CUANDO GANA LA CPU ---------------------------------------------------

jmp fin

fin:
call bordeInf

mov ah, 02h             ;UBICA AL CURSOR -----------------------------------------------------------------
mov dh, 4
mov dl, 25
int 10h

mov ah, 9
mov dx, offset puntaje
int 21h

mov ah, 02h              ;UBICA AL CURSOR ----------------------------------------------------------------
mov dh, 5
mov dl, 25
int 10h

mov ah, 9
mov dx, offset jugadores
int 21h

;mov bx, offset jugadores ;IMPRIME LOS JUGADORES
;call imprimir ;LLAMA A LA FUNCION IMPRIMIR-----------------------

mov ah, 02h           ;UBICA AL CURSOR JUGADOR 1 ---------------------------------------------------------
mov dh, 6
mov dl, 35
int 10h

mov ah, 9
mov dx, offset score
int 21h

mov ah, 2              ;UBICA AL CURSOR ------------------------------------------------------------------
mov dh, 20
mov dl, 30
int 10h

mov ah, 9
mov dx, offset tecla   ;IMPRIMO LA PALABRA ENTER ---------------------------------------------------------
int 21h
mov ah, 01h
int 21h

cmp score[0], 33h      ;COMPARA CON 3, EL SCORE DE JUGADOR, SI LLEGA A 3 GANA ----------------------------
je finfin1
cmp score[2], 33h      ;COMPARA CON 3, EL SCORE DE LA CPU, SI LLEGA A 3 GANA -----------------------------
je finfin2

jmp sigue

mov ah, 2              ;UBICA AL CURSOR -----------------------------------------------------------------
mov dh, 23
mov dl, 0
int 10h

finfin1:
int 80h                ;INTERRUPCION QUE LIMPIA LA PANTALLA ---------------------------------------------
call ubicarCentro
mov bx, offset ganaste ;IMPRIME LA PALABRA GANASTE ------------------------------------------------------
call imprimir

jmp volver

finfin2:
int 80h
call ubicarCentro
mov bx, offset perdiste ;IMPRIME LA PALABRA PERDISTE -------------------------------------------------------
call imprimir

volver:
mov ah, 2            ;UBICA AL CURSOR -------------------------------------------------------------------
mov dh, 19
mov dl, 14
int 10h

mov ah, 9
mov dx, offset vuelve   ;IMPRIME CARTEL DE LA POSIBILIDAD DE ELEGIR ENTRE VOLVER A JUGAR O SALIR DEL PROGRAMA
int 21h

pregunto:
mov ah, 01h
int 21h

cmp al, 'S'
je sigojugando
cmp al, 's'
je sigojugando
cmp al, 'N'
je termina
cmp al, 'n'
je termina
jmp pregunto

sigojugando:
mov score[0], 30h
mov score[2], 30h

jmp sigue

termina: 
    int 80h
    mov ax, 4c00h
    int 21h
    main endp
end