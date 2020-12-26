.model small
.stack 100h

; ----------------------------------- MACROS --------------------------------------------- ;
print macro cadena
    ; nombre macro param, param2
    mov ah, 09h
    mov dx, @data
    mov ds, dx
    mov dx, offset cadena
    int 21h    
endm

getch macro 
    mov ah, 01h
    int 21h
endm

getlinea macro arreglo
    LOCAL NuevoChar, FinOT
    xor si, si; si = 0

    NuevoChar:
        getch
        cmp al, 0dh
        je FinOT ; si es enter, termino de una

        mov arreglo[si], al
        inc si; si++
        jmp NuevoChar

    FinOT:
        mov al, 24h
        mov arreglo[si], ah
endm

getruta macro arreglo
    LOCAL NuevoChar, FinOT
    xor si, si; si = 0

    NuevoChar:
        getch
        cmp al, 0dh
        je FinOT ; si es enter, termino de una

        mov arreglo[si], al
        inc si; si++
        jmp NuevoChar

    FinOT:
        mov al, 00h
        mov arreglo[si], ah

endm

openfile macro buffer, handler

    xor ax, ax
    xor dx, dx

    mov ah, 3dh
    mov al, 02h
    mov dx, offset buffer
    int 21h
    jc Error19
    mov handler, ax
    
endm

closefile macro handler
    mov  ah, 3eh
    mov  bx, handler
    int  21h      
    jc Error20
endm

; ----------------------------------- DATA ----------------------------------------------- ;
; acá defino todas las variables
.data 
    ; db -> dato type 8 bits
    ; dw -> word 16bits
    ; dd -> double word 32bits

    ;archivos
    fileInit db 1400 dup(32)
    gameInit db "plis.txt", 00h
    bufferInit db 50 dup('$')
    handlerInit dw ?

    ;entrada
    bufferEntrada db 50 dup('$')
    handlerEntrada dw ?

    ;usuario
    anombre db 9 dup('$'), '$'
    acontrasenia db 4 dup('$'), '$'

    ; menu general (1)
    bienvenida db 09,'BiENVENIDO AL PROYECTO FINAL!! :D', 00h, 0Ah, '$'
    msg1 db 09,'1) Ingresa', 00h, 0Ah, '$'
	msg2 db 09,'2) Registrate', 00h, 0Ah, '$'
	msg3 db 09,'3) Salir', 00h, 0Ah, '$'

    ;menu de ingreso (2) y registro (3)
    msg4 db 09,'Ingresa tu nombre de usuario', 00h, 0Ah, '$'
    msg5 db 09,'Ingresa tu contrasenia', 00h, 0Ah, '$'
    msg6 db 09,'Confirma tu contrasenia', 00h, 0Ah, '$'
    msg17 db 09,'Usuario o contrasenia incorrectos :c', 00h, 0Ah, '$'

    ;sesión de usuario
    msg7 db 09,'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA', 00h, 0Ah, '$'
    msg8 db 09,'FACULTAD DE INGENIERÍA', 00h, 0Ah, '$'
    msg9 db 09,'CIENCIAS Y SISTEMAS', 00h, 0Ah, '$'
    msg10 db 09,'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES', 00h, 0Ah, '$'
    msg11 db 09,'NOMBRE: YASMIN ELISA MONTERROSO ESCOBEDO', 00h, 0Ah, '$'
    msg12 db 09,'CARNET: 201801385', 00h, 0Ah, '$'
    msg13 db 09,'SECCION A', 00h, 0Ah, '$'

    msg14 db 09, '1) Iniciar Juego', 00h, 0Ah, '$'
    msg15 db 09,'2) Cargar Juego', 00h, 0Ah, '$'
    msg16 db 09, '3) Salir', 00h, 0Ah, '$'

    ;cargarJuego
    msg22 db 09, 'Ingresa la ruta de tu archivo', 00h, 0Ah, '$'

    ;sesion de admin
    msg18 db 09, 'BIENVENIDO ADMINISTRADOR', 00h, 0Ah, '$'
    
    ;errores
    msg19 db 09, 'error al abrir', 00h, 0Ah, '$'
    msg20 db 09, 'arror al cerrar', 00h, 0Ah, '$'
    msg21 db 09, 'error al escribir', 00h, 0Ah, '$'

    
    msg23 db 09, '0', 00h, 0Ah, '$'
    msg24 db 09, '0', 00h, 0Ah, '$'
    msg25 db 09, '0', 00h, 0Ah, '$'
    msg26 db 09, '0', 00h, 0Ah, '$'
    msg27 db 09, '0', 00h, 0Ah, '$'





    ;extras
    salto db 00h, 0Ah, '$'
    msgf db 'fin :3', 00h, 0Ah, '$'


; ----------------------------------- CODE ----------------------------------------------- ;
.code 
    main proc
    Menu1: 

        print salto
        print bienvenida
        print salto
        print msg1
        print msg2
        print msg3

        getch

        print salto

        sub al,48
    
        cmp al, 1
        je Menu2
        cmp al, 2
        je Menu3
        cmp al, 3  
        je Salir


        jmp Menu1

    Menu2:

        print salto
        print salto

        ;print msg4

        ; aca recibo el nombre
        ;getlinea anombre

        ;print msg5

        ; aca recibo la contraseña
        ;getlinea acontrasenia

        print msg22
        ;getruta bufferInit

        openfile gameInit, handlerInit
        ;pa cerrar->closefile handlerInit
        closefile handlerInit

        print salto
        print msgf
        ;print anombre
        ;print acontrasenia
        print msgf
        print salto


        jmp Menu4
    Menu3: 

        print salto
        print salto

        print msg4

        ; aca recibo el nombre
        getlinea anombre

        print msg5

        ; aca recibo la contraseña
        getlinea acontrasenia

        print salto
        print anombre
        print acontrasenia

        print msgf
        print msgf

        jmp Menu1  
    Menu4: 

        print salto
        print salto

        print msg7
        print msg8
        print msg9
        print msg10
        print msg11
        print msg12
        print msg13

        print salto

        print msg14
        print msg15
        print msg16

        getch

        print salto

        sub al,48
    
        cmp al, 1
        ;inicio juego

        cmp al, 2
        je CargarJuego


        cmp al, 3  
        je Salir

        jmp Menu1
    CargarJuego:

        print msg22
        getruta bufferEntrada
        ;print bufferEntrada
        print salto

        ;openfile bufferEntrada, handlerEntrada


        jmp Menu4
    InicioJuego:

        jmp Menu1
    Menu5:
        jmp Menu1
    Salir:
        mov ah, 4ch
        int 21h

    Error19:
        print msg19
        jmp Menu1
    Error20:
        print msg20
        jmp Menu1
    Error21:
        print msg21
        jmp Menu1
    main endp
end
