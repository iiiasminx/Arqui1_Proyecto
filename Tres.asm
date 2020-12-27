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

pushtodo macro
    push si
    push ax
    push bx
    push cx
    push dx
endm

poptodo macro
    pop dx
    pop cx
    pop bx
    pop ax
    pop si
endm

emptystring macro array, tamanio

    LOCAL Looping

    pushtodo

    xor si, si
    xor cx, cx

    mov cx, tamanio

    Looping:
        mov array[si], '$'
        inc si
        loop Looping
    print array
    print msg23
    poptodo

endm

meterafile macro handler, tamanio, texto

    mov ah, 42h  ; "lseek"
    mov al, 2    ; position relative to end of file
    mov cx, 0    ; offset MSW
    mov dx, 0    ; offset LSW
    int 21h

    mov  ah, 40h
    mov  bx, handler
    mov  cx, tamanio
    mov  dx, offset texto
    int  21h

endm ;cuando vuelvo a abrir, empieza desde el inicio


; MACROS EN PROCESO

readfile macro handler, array, tamanio

    mov ah, 3fh
    mov bx, handler
    mov cx, tamanio
    mov dx, offset array
    int 21h
    jc Error21

    print array
    print salto
endm

adminpassword macro 

    xor si, si; si = 0

    getch
    sub al,48
    cmp al, 1
    jne wrongPass

    getch
    sub al,48
    cmp al, 2
    jne wrongPass

    getch
    sub al,48
    cmp al, 3
    jne wrongPass

    getch
    sub al,48
    cmp al, 4
    jne wrongPass

    jmp Menu5
endm


; ----------------------------------- DATA ----------------------------------------------- ;
; acá defino todas las variables
.data 
    ; db -> dato type 8 bits
    ; dw -> word 16bits
    ; dd -> double word 32bits

    ;archivos
    gameInit db "plis.txt", 00h
    ;gameInit db "Dos.asm", 00h ---> abre lo que esté adentro de bin
    handlerInit dw ?
    ;el por si acaso
    msg26 db 'admin', '$'
    

    ;entrada
    bufferEntrada db 50 dup('$')
    handlerEntrada dw ?

    ;usuario
    anombre db 6 dup('$'), '$'
    acontrasenia db 4 dup('$'), '$'
    ;nuevo
    nnombre db 9 dup('$'), '$'
    ncontrasenia db 4 dup('$'), '$'

    ; menu general (1)
    bienvenida db 09,'BiENVENIDO AL PROYECTO FINAL!! :D', 00h, 0Ah, '$'
    msg1 db 09,'1) Ingresa', 00h, 0Ah, '$'
	msg2 db 09,'2) Registrate', 00h, 0Ah, '$'
	msg3 db 09,'3) Salir', 00h, 0Ah, '$'

    ;menu de ingreso (2) y registro (3)
    msg4 db 09,'Ingresa tu nombre de usuario', 00h, 0Ah, '$'
    msg5 db 09,'Ingresa tu contrasenia', 00h, 0Ah, '$'
    ;msg6 db 09,'Confirma tu contrasenia', 00h, 0Ah, '$'
    msg17 db 09,'Usuario o contrasenia incorrectos :c', 00h, 0Ah, '$'

    ;sesión de usuario y admin
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

    msg31 db 09,'1) Top 10 puntos', 00h, 0Ah, '$'
    msg32 db 09,'2) Salir', 00h, 0Ah, '$'

    ;cargarJuego
    msg22 db 09, 'Ingresa la ruta de tu archivo', 00h, 0Ah, '$'
    msg27 db 09, 'admin', '$'

    ;sesion de admin
    msg18 db 09, 'BIENVENIDO ADMINISTRADOR', 00h, 0Ah, '$'
    
    ;errores
    msg19 db 09, 'error al abrir', 00h, 0Ah, '$'
    msg20 db 09, 'arror al cerrar', 00h, 0Ah, '$'
    msg21 db 09, 'error al leer', 00h, 0Ah, '$'

    
    msg23 db 09, '-', 00h, 0Ah, '$'
    msg24 db 09, 59, 00h, 0Ah, '$'
    msg25 db 09, 'Usuario Registrado! :D', 00h, 0Ah, '$'

    msg28 db 09, 'Tu usuario o contrasenia no coinciden :c', 00h, 0Ah, '$'
    msg29 db 09, '1) Ingresar como usuario', 00h, 0Ah, '$'
    msg30 db 09,'2) Ingresar como admin', 00h, 0Ah, '$'

    

    msg33 db 09,'0', 00h, 0Ah, '$'
    msg34 db 09,'0', 00h, 0Ah, '$'
    msg35 db 09,'0', 00h, 0Ah, '$'


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
        je Menu6
        cmp al, 2
        je Menu3
        cmp al, 3  
        je Salir


        jmp Menu1
    Menu6:
        print salto
        print msg29 ;ingreso como usr
        print msg30 ;ingreso como admin

        getch

        print salto

        sub al,48
    
        cmp al, 1
        je Menu2
        cmp al, 2
        je Menu7

        jmp Menu6
    Menu7:
        ; si ingreso como admin
        print salto
        print msg4
        print msg27
        print salto
        print msg5

        ; aca recibo el 1234
        adminpassword

        jmp Menu1

    Menu2:

        print salto
        print salto

        print msg4

        ; aca recibo el nombre
        getlinea anombre

        print msg5

        ; aca recibo la contraseña
        getlinea acontrasenia
     
        ;ACÁ HAGO LA VALIDACIÓN
        openfile gameInit, handlerInit
        
        ;acá va la magia 
        
        


        ;borro contra y user no borro el user xq messirve pa despues
        emptystring acontrasenia, 4

        print salto


        jmp Menu4
    Menu3: 

        print salto
        print salto

        print msg4

        ; aca recibo el nombre
        getlinea nnombre

        print msg5

        ; aca recibo la contraseña
        getlinea ncontrasenia

        print salto
        print nnombre
        print ncontrasenia

        ;Metiendo cosas al file
        openfile gameInit, handlerInit

        ; user - contra ;
        meterafile handlerInit, 5, msg26
        meterafile handlerInit, 6, nnombre
        meterafile handlerInit, 2, msg23
        meterafile handlerInit, 4, ncontrasenia
        meterafile handlerInit, 2, msg24

        closefile handlerInit

        ;borro contra y user

        emptystring nnombre, 9
        emptystring ncontrasenia, 4


        print salto
        print msg25

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

        print msg31
        print msg32

        getch
        print salto

        sub al,48
    
        cmp al, 1
        je Ordenamiento
        cmp al, 2
        je Salir

        jmp Menu1
    Ordenamiento: 
        jmp Menu5
    Salir:
        mov ah, 4ch
        int 21h
    ; COSITOS EXTRAS    
    Error19:
        print msg19
        jmp Menu1
    Error20:
        print msg20
        jmp Menu1
    Error21:
        print msg21
        jmp Menu1
    wrongPass:
        print salto
        print msg28
        print salto
        print salto
        jmp Menu1
    main endp
end
