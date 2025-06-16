.8086
.model small
.stack 100h
.data
.code
    public random
    public CalcNew
    public bordeSup
    public bordeInf
    public imprimir
    public ubicarCentro
    public ubicarj1
    public ubicarCom
    public ubicarVs
    public ingresoNick
    public compara
;GENERA UN NUMERO ALEATORIO QUE VA A SER EL VALOR QUE ELIGE LA MAQUINA PARA JUGAR.
random PROC
;DEVUELVE UN NUMERO DE1 1 AL 3 EN DL
push bx
pushf
    MOV     AH, 00h   ; interrupt to get system timer in CX:DX 
    INT     1AH
    mov     bx, dx
    call    CalcNew   ; -> AX is a random number
    xor     dx, dx
    mov     cx, 3    
    div     cx        ; here dx contains the remainder - from 0 to 9
    add     dl, 31h   ; to ascii from '0' to '3'
   ; mov     ah, 02h   ; call interrupt to display a value in DL
    ;int     21h    
    popf
    pop bx
    ret
random endp

; ----------------
; inputs: none  (modifies PRN seed variable)TAS
; clobbers: DX.  returns: AX = next random number
CalcNew PROC
    mov     ax, 25173          ; LCG Multiplier
    mul     bx     ; DX:AX = LCG multiplier * seed
    add     ax, 13849          ; Add LCG increment value
    ; Modulo 65536, AX = (multiplier*seed+increment) mod 65536
    mov     bx, ax          ; Update seed = return value
    SHR     AX, 5
    ret 
CalcNew ENDP  

;description
bordeSup PROC
    push ax
    push bx
    push dx
    push cx
    pushf

    xor ax, ax
    xor bx, bx
    xor dx, dx
    xor cx, cx

;ubicar el cursor borde superior izq para dibujar la primera hilera
mov ah,02h
mov dh,2
mov dl,0
int 10h

;imprimir el ═ superior
mov ah,09h
mov al,'*'
mov bl,10
mov cx,80
int 10h
;------------------------------------------
;ubicar el cursor para dibujar la segunda hilera
mov ah,02h
mov dh,1
mov dl,0
int 10h


;imprimir el ═ superior
mov ah,09h
mov al,'*'
mov bl,10
mov cx,80
int 10h
    popf
    pop cx
    pop dx
    pop bx
    pop ax
ret
bordeSup ENDP

;description
bordeInf PROC
    push ax
    push bx
    push dx
    push cx
    pushf

    xor ax, ax
    xor bx, bx
    xor dx, dx
    xor cx, cx

        mov ah,02h
        mov dh,22
        mov dl,0
        int 10h

;imprimir el ═ inferior
mov ah,09h
mov al,'*'
mov bl,10
mov cx,80
int 10h
;------------------------------------------
;ubicar el cursor
;ub:
mov ah,02h
mov dh,23
mov dl,0
int 10h

;imprimir el ═ inferior
mov ah,09h
mov al,'*'
mov bl,10
mov cx,80
int 10h
    popf
    pop cx
    pop dx
    pop bx
    pop ax
ret
bordeInf ENDP

imprimir PROC
    ;recibe el offset de la variable en bx
    PUSH ax
    PUSH dx
    PUSH bx
arriba:
    cmp byte ptr [bx], 24h
    je fin
    mov ah, 2
    mov dl, byte ptr [bx]
    int 21h
    inc bx
jmp arriba

fin:
    POP bx
    POP dx
    POP ax
    ret
imprimir ENDP

;description
ubicarCentro PROC
    push ax
    push bx
    push dx
    push cx
    pushf

    xor ax, ax
    xor bx, bx
    xor dx, dx
    xor cx, cx

    mov ah,02h
    mov dh,14
    mov dl,31
    int 10h

    popf
    pop cx
    pop dx
    pop bx
    pop ax
    ret
ubicarCentro ENDP

ubicarj1 PROC
     push ax
    push bx
    push dx
    push cx
    pushf

    xor ax, ax
    xor bx, bx
    xor dx, dx
    xor cx, cx

    mov ah,02h
    mov dh,9
    mov dl,25
    int 10h

    popf
    pop cx
    pop dx
    pop bx
    pop ax
    ret
ubicarj1 ENDP

ubicarCom PROC
    push ax
    push bx
    push dx
    push cx
    pushf

    xor ax, ax
    xor bx, bx
    xor dx, dx
    xor cx, cx

    mov ah,02h
    mov dh,9
    mov dl,45
    int 10h

    popf
    pop cx
    pop dx
    pop bx
    pop ax
    ret
ubicarCom ENDP
;description
ubicarVs PROC
     push ax
    push bx
    push dx
    push cx
    pushf

    xor ax, ax
    xor bx, bx
    xor dx, dx
    xor cx, cx

    mov ah,02h
    mov dh,9
    mov dl,37
    int 10h

    popf
    pop cx
    pop dx
    pop bx
    pop ax
    ret
ubicarVs ENDP

ingresoNick proc

      push dx
      push bx
      push ax
      push cx

      mov bx,dx ; offset buffer_texto en bx

      mov ax,dx

      mov ax, 0
      limpiar_buffer:
      cmp ax,10
      je fin_limpieza_buffer
      mov byte ptr [bx], 20h
      inc bx
      inc ax
      jmp limpiar_buffer

      fin_limpieza_buffer:
      mov bx,dx ; offset buffer_texto en bx
      xor cx,cx

      ingreso_texto_usuario:
        mov ah,1
        int 21h
        cmp al, 0dh ; Si se presiona enter se finaliza el ingreso
        je ingreso_texto_fin


        mov byte ptr [bx], al
        inc bx
        inc cx

        cmp cx, 4 ; si la cantidad de caracteres ingresadas es igual a 4 finaliza el ingreso.
        je ingreso_texto_fin

        jmp ingreso_texto_usuario

      ingreso_texto_fin:
        pop cx
        pop ax
        pop bx
        pop dx

      ret
    ingresoNick endp

    compara PROC
        CMP BL, BH
        JNE no_empate
        
        ; Caso de empate
        MOV AL, 0
        RET

no_empate:
        ; Determinar elección del jugador
        CMP BL, '1'
        JE jugador_piedra
        CMP BL, '2'
        JE jugador_papel
        CMP BL, '3'
        JE jugador_tijera
        
        ; Opción inválida (tratar como derrota)
        MOV AL, 2
        RET

jugador_piedra:
        CMP BH, '2'
        JE cpu_gana
        CMP BH, '3'
        JE jugador_gana
        JMP opcion_invalida

jugador_papel:
        CMP BH, '1'
        JE jugador_gana
        CMP BH, '3'
        JE cpu_gana
        JMP opcion_invalida

jugador_tijera:
        CMP BH, '1'
        JE cpu_gana
        CMP BH, '2'
        JE jugador_gana
        JMP opcion_invalida

jugador_gana:
        MOV AL, 1
        RET

cpu_gana:
        MOV AL, 2
        RET

opcion_invalida:
        MOV AL, 2  ; Tratar opción inválida como derrota
        RET
compara ENDP

end