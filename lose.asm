.8086
.MODEL SMALL
.STACK 100h

.DATA

loseLose dw  756, 757, 758, 759, 760, 766, 767, 768, 769, 770 
         dw  838, 848   
         dw  918, 928          
         dw  998, 1002, 1003, 1004, 1008                 
         dw  1078, 1088                         
         dw  0FFFFh                           

longitudLose equ ($-loseLose)/2


.CODE

    public getLose

getLose proc
    pushf           ; salvar flags
    push    ax
    push    bx
    push    cx
    push    dx
    push    si
    push    di
    push    bp
    push    ds
    push    es

inicio:
    
    ; Modo video texto (03h)
    mov ax, 0003h
    int 10h

    mov cx, longitudLose
    mov si, offset loseLose
    mov dl, 01h

    call drawLose

    pop     es
    pop     ds
    pop     bp
    pop     di
    pop     si
    pop     dx
    pop     cx
    pop     bx
    pop     ax
    popf
    ret
getLose endp
    
; rutina simple de retardo
pausa2 PROC NEAR
    push cx
    mov cx, 7FFFh
delay:
    loop delay
    pop cx
    ret
pausa2 ENDP

drawLose PROC NEAR
    push ax
    push cx
    push dx
    push si
    push es

    mov     cx, cx             ; CX ya viene preparado con longitud
    mov     si, si             ; SI ya trae el offset del array
    mov     dl, dl             ; DL trae el color que pusiste antes de llamar

    mov     ax, 0B800h
    mov     es, ax

.loopPixel2:
    cmp   bx, 0FFFFh        ; ¿marca de fin?
    je    .doneIntro2

    mov     bx, [si]           ; leo (fila*80+col)
    shl     bx, 1              ; *2 para byte offset en video

    mov     byte ptr es:[bx], 219    ; █
    mov     byte ptr es:[bx+1], dl   ; atributo = color en DL

    call    pausa2

    add     si, 2              ; siguiente posición
    loop    .loopPixel2

.doneIntro2:
    pop     es
    pop     si
    pop     dx
    pop     cx
    pop     ax
    ret
drawLose ENDP

END inicio
