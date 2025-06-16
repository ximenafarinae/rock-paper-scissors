.8086
.MODEL SMALL
.STACK 100h

.DATA

piedra  dw 245, 246, 247, 248, 250, 252, 253, 254, 256, 257, 258, 261, 262, 263, 266, 267, 268, 269, 280, 281, 282  ; Ejemplo simplificado posiciones (fila 5, columnas pares)
        dw 325, 328, 330, 332, 336, 339, 341, 344, 346, 349, 359, 363
        dw 405, 406, 407, 408, 410, 412, 413, 414, 416, 419, 421, 422, 423, 426, 427, 428, 429, 438, 444
        dw 485, 490, 492, 496, 499, 501, 504, 506, 509, 517, 525
        dw 565, 570, 572, 573, 574, 576, 577, 578, 581, 584, 586, 589, 596, 597, 598, 599, 600, 601, 602, 603, 604, 605, 606, 0FFFFh

papel   dw 728, 729, 730, 731, 733, 734, 735, 736, 738, 739, 740, 741, 743, 744, 745, 746, 748, 760, 761, 762, 763, 764, 765, 766
        dw 808, 811, 813, 816, 818, 821, 823, 828, 839, 845
        dw 888, 889, 890, 891, 893, 894, 895, 896, 898, 899, 900, 901, 903, 904, 905, 906, 908, 918, 924
        dw 968, 973, 976, 978, 983, 988, 997, 1003
        dw 1048, 1053, 1056, 1058, 1063, 1064, 1065, 1066, 1068, 1069, 1070, 1071, 1076, 1077, 1078, 1079, 1080, 1081, 1082, 0FFFFh

tijera  dw 1210, 1211, 1212, 1214, 1218, 1220, 1221, 1222, 1223, 1225, 1226, 1227, 1230, 1231, 1232, 1233, 1240, 1244
        dw 1291, 1294, 1298, 1300, 1305, 1308, 1310, 1313, 1321, 1323
        dw 1371, 1374, 1378, 1380, 1381, 1382, 1383, 1385, 1386, 1387, 1390, 1391, 1392, 1393, 1399, 1400, 1402, 1404, 1405
        dw 1451, 1454, 1458, 1460, 1465, 1468, 1470, 1473, 1478, 1481, 1483, 1486
        dw 1531, 1534, 1536, 1537, 1538, 1540, 1541, 1542, 1543, 1545, 1548, 1550, 1553, 1559, 1560, 1564, 1565, 0FFFFh

otroMsj dw 290, 291, 292, 293, 295, 299, 301, 303, 304, 305, 309, 310
        dw 370, 373, 375, 379, 381, 383, 386, 388, 390
        dw 450, 451, 452, 453, 455, 460, 463, 464, 465, 470
        dw 530, 535, 540, 543, 546, 550
        dw 610, 615, 616, 617, 620, 623, 626, 629, 630, 631

        dw 780, 782, 785, 786, 787
        dw 860, 862, 865
        dw 940, 942, 945, 946, 947
        dw 1020, 1022, 1027
        dw 1101, 1105, 1106, 1107

        dw 1265, 1267, 1270, 1271, 1272, 1274, 1275, 1276
        dw 1345, 1347, 1350, 1352, 1354
        dw 1426, 1430, 1431, 1432, 1434, 1435, 1436
        dw 1505, 1507, 1510, 1512, 1514, 1516
        dw 1585, 1587, 1590, 1591, 1592, 1594, 1595, 1596


longitudPiedra equ ($-piedra)/2
longitudPapel equ ($-papel)/2
longitudTijera equ ($-tijera)/2
longitudOtroMsj equ ($-otroMsj)/2

;(fila * 80 + columna) * 2 [(6 x 80 + 5) x 2]

.CODE

    public getMainIntro

getMainIntro proc
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
    mov ax, @data
    mov ds, ax
    ; Modo video texto (03h)
    mov ax, 0003h
    int 10h

    mov cx, longitudPiedra
    mov si, offset piedra
    mov dl, 0Fh

    call getIntro

    mov cx, longitudPiedra
    mov si, offset piedra
    mov dl, 0Eh

    call getIntro

    mov cx, longitudPapel
    mov si, offset papel
    mov dl, 0Bh

    call getIntro

    mov cx, longitudTijera
    mov si, offset tijera
    mov dl, 0Dh

    call getIntro

    mov cx, longitudOtroMsj
    mov si, offset otroMsj
    mov dl, 0Ah

    call getIntro

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
getMainIntro endp
    
; rutina simple de retardo
pausa PROC NEAR
    push cx
    mov cx, 2F00h
delay:
    loop delay
    pop cx
    ret
pausa ENDP

getIntro PROC NEAR
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

.loopPixel:
    cmp   bx, 0FFFFh        ; ¿marca de fin?
    je    .doneIntro

    mov     bx, [si]           ; leo (fila*80+col)
    shl     bx, 1              ; *2 para byte offset en video

    mov     byte ptr es:[bx], 219    ; █
    mov     byte ptr es:[bx+1], dl   ; atributo = color en DL

    call    pausa

    add     si, 2              ; siguiente posición
    loop    .loopPixel

.doneIntro:
    pop     es
    pop     si
    pop     dx
    pop     cx
    pop     ax
    ret
getIntro ENDP

END inicio
