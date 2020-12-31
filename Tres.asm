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

printNum macro num

    mov dl,num 
	;add dl,48		; convertir de decimal a ascii
	mov ah,02		;02 es como 09 pero para numeros
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
        mov arreglo[si], al

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

findUser macro userEntrado, contraseniaEntrada, texto

    LOCAL Noiwales, Iwales, Comparador, Nops, Sip

    ;PARA VER QUE SI TODO, NO CAMBIO EL DI, Y SI LLEGA A UN ; NEL

    xor si, si
    xor di, di

    ;mov al, userEntrado[di]
    ;cmp al, 'a'
    ;je Iwales ;--> esta cosa funciona

    ;mov ah, texto[di]
    ;cmp ah, 'a'
    ;je Iwales ;--> esta cosa funciona

    Comparador:
        mov al, userEntrado[si]
        mov ah, texto[di]

        cmp si, 6
        je Comparador2

        cmp al, 0
        je Noiwales
        cmp ah, 0
        je Noiwales

        cmp al, '$'
        je Noiwales
        cmp ah, '$'
        je Noiwales

        cmp al, ah
        je Sip

        jmp Nops

        Nops: 
            inc di
            print msgf2
            jmp Comparador

        Sip:
            inc si
            inc di

            print msgf

            jmp Comparador
    
    Comparador2:
        xor si, si
        xor di, di
        xor al, al
        xor ah, ah

        Magia:
            mov al, contraseniaEntrada[si]
            mov ah, texto[di]

            cmp si, 3
            je Iwales

            cmp al, 0
            je Noiwales
            cmp ah, 0
            je Noiwales

            cmp al, '$'
            je Noiwales
            cmp ah, '$'
            je Noiwales

            cmp al, ah
            je Sip2

            jmp Nops2

            Nops2: 
                inc di
                print msgf2
                jmp Magia

            Sip2:
                inc si
                inc di

                print msgf

                jmp Magia


    
    Noiwales: ;si no coincide con nada el cosito
        print salto
        print msg28
        print salto

        jmp Menu1
    Iwales: 
        jmp Menu4

endm

; MACROS EN PROCESO

verniveles macro    

    print tnivel1
    print salto 
    printNum tobstac1
    print salto 
    printNum tprice1
    print salto
    printNum pobstac1
    print salto
    printNum pprice1
    print salto 
    print salto
endm


insertLevels  macro texto

    xor si, si
    xor di, di
    xor al, al
    xor ah, ah

    ;mov al, userEntrado[di]
    ;cmp al, 'a'
    ;je Iwales ;--> esta cosa funciona

    ;mov ah, texto[di]
    ;cmp ah, 'a'
    ;je Iwales ;--> esta cosa funciona

    nvl0:

        ;leo hasta la coma
        mov al, texto[si]
        cmp al, 44 ;\,
        je nvl1

        inc si
        jmp nvl0 
    nvl1:   ; acá wacho que nivel es, solo 3 opciones
        inc si        
        mov al, texto[si]

        cmp al, 49 ;1
        je level1

        cmp al, 50 ;2
        je level2

        cmp al, 51 ;3
        je level3

        jmp oopsie    
    level1:
        inc si   ; estoy en una coma

        xor al, al
        xor ah, ah

        tnivel1: ;99, 9, 29
            inc si     
            mov al, texto[si] ;9,9,2

            mov timen1, al 

            inc si     
            mov al, texto[si] ;9, , ,9

            cmp al, 44 ;  ,
            je  tn1

            jmp tn2

            tn1:
                xor al, al
                xor ah, ah
                jmp tobstaculos1

            tn2: 

                xor cl, cl
                xor bl, bl

                mov cl, timen1 ; coso de las decenas
                sub cl, 48  

                juntarnumeros     

                sub al, 48      

                add bl, al
                mov byte ptr[timen1], bl

                cmp timen1, 56
                je chi

                inc si
                jmp tobstaculos1

                chi:
                    print msgf2
                    print msgf2
                    inc si
                    jmp tobstaculos1       
        tobstaculos1:
            inc si     
            mov al, texto[si] ;9,9,2

            ;print tobstac1
            mov tobstac1, al 
            ;print tobstac1

            inc si     
            mov al, texto[si] ;9, , ,9

            cmp al, 44 ;  ,
            je  tob1

            jmp tob2

            tob1:
                jmp tpremio1
            tob2:

                mov ah, tobstac1

                inc si
                xor al, al
                xor ah, ah

                jmp tpremio1    
        tpremio1:
            inc si     
            mov al, texto[si] ;9,9,2

            mov tprice1, al 

            inc si     
            mov al, texto[si] ;9, , ,9

            cmp al, 44 ;  ,
            je  tpr1

            jmp tpr2

            tpr1:
                jmp pobstaculos1
            tpr2:

                mov ah, tprice1

                inc si
                xor al, al
                xor ah, ah

                jmp pobstaculos1  
        pobstaculos1:
            inc si     
            mov al, texto[si] ;9,9,2

            mov pobstac1, al 

            inc si     
            mov al, texto[si] ;9, , ,9

            cmp al, 44 ;  ,
            je  pob1

            jmp pob2

            pob1:
                jmp ppremios1
            pob2:

                mov ah, pobstac1

                inc si
                xor al, al
                xor ah, ah

                jmp ppremios1 
        ppremios1:
            inc si     
            mov al, texto[si] ;9,9,2

            mov pprice1, al 

            inc si     
            mov al, texto[si] ;9, , ,9

            ;cmp al, 44 ;  ,
            ;je  ppr1

            cmp al, 59 ;  ;
            je  ppr1

            jmp ppr2

            ppr1:
                print msgf
                print salto
                inc si
                jmp nvl0
            ppr2:

                mov ah, pprice1

                print msgf
                print salto
                inc si
                jmp nvl0 
    level2:
        inc si   ; estoy en una coma

        xor al, al
        xor ah, ah

        tnivel2: ;99, 9, 29
            inc si     
            mov al, texto[si] ;9,9,2

            mov timen2, al 

            inc si     
            mov al, texto[si] ;9, , ,9

            cmp al, 44 ;  ,
            je  tn21

            jmp tn22

            tn21:
                xor al, al
                xor ah, ah
                jmp tobstaculos2

            tn22: 

                xor cl, cl
                xor bl, bl

                mov cl, timen2 ; coso de las decenas
                sub cl, 48  

                juntarnumeros     

                sub al, 48      

                add bl, al
                mov byte ptr[timen2], bl

                cmp timen2, 25
                je chi2

                inc si
                jmp tobstaculos2

                chi2:
                    print msgf2
                    print msgf2
                    inc si
                    jmp tobstaculos2      
        tobstaculos2:
            inc si     
            mov al, texto[si] ;9,9,2

            ;print tobstac1
            mov tobstac2, al 
            ;print tobstac1

            inc si     
            mov al, texto[si] ;9, , ,9

            cmp al, 44 ;  ,
            je  tob21

            jmp tob22

            tob21:
                jmp tpremio2
            tob22:

                mov ah, tobstac2

                inc si
                xor al, al
                xor ah, ah

                jmp tpremio2    
        tpremio2:
            inc si     
            mov al, texto[si] ;9,9,2

            mov tprice2, al 

            inc si     
            mov al, texto[si] ;9, , ,9

            cmp al, 44 ;  ,
            je  tpr21

            jmp tpr22

            tpr21:
                jmp pobstaculos2
            tpr22:

                mov ah, tprice2

                inc si
                xor al, al
                xor ah, ah

                jmp pobstaculos2 
        pobstaculos2:
            inc si     
            mov al, texto[si] ;9,9,2

            mov pobstac2, al 

            inc si     
            mov al, texto[si] ;9, , ,9

            cmp al, 44 ;  ,
            je  pob21

            jmp pob22

            pob21:
                jmp ppremios2
            pob22:

                mov ah, pobstac2

                inc si
                xor al, al
                xor ah, ah

                jmp ppremios2 
        ppremios2:
            inc si     
            mov al, texto[si] ;9,9,2

            mov pprice2, al 

            inc si     
            mov al, texto[si] ;9, , ,9

            ;cmp al, 44 ;  ,
            ;je  ppr1

            cmp al, 59 ;  ;
            je  ppr21

            jmp ppr22

            ppr21:
                print msgf
                print salto
                inc si
                jmp nvl0
            ppr22:

                mov ah, pprice2

                print msgf
                print salto
                inc si
                jmp nvl0 
    level3:
        inc si   ; estoy en una coma

        xor al, al
        xor ah, ah

        tnivel3: ;99, 9, 29
            inc si     
            mov al, texto[si] ;9,9,2

            mov timen3, al 

            inc si     
            mov al, texto[si] ;9, , ,9

            cmp al, 44 ;  ,
            je  tn31

            jmp tn32

            tn31:
                xor al, al
                xor ah, ah
                jmp tobstaculos3

            tn32: 

                xor cl, cl
                xor bl, bl

                mov cl, timen3 ; coso de las decenas
                sub cl, 48  

                juntarnumeros     

                sub al, 48      

                add bl, al
                mov byte ptr[timen3], bl

                cmp timen3, 55
                je chi3

                inc si
                jmp tobstaculos3

                chi3:
                    print msgf2
                    print msgf2
                    inc si
                    jmp tobstaculos3       
        tobstaculos3:
            inc si     
            mov al, texto[si] ;9,9,2

            ;print tobstac1
            mov tobstac3, al 
            ;print tobstac1

            inc si     
            mov al, texto[si] ;9, , ,9

            cmp al, 44 ;  ,
            je  tob31

            jmp tob32

            tob31:
                jmp tpremio3
            tob32:

                mov ah, tobstac3

                inc si
                xor al, al
                xor ah, ah

                jmp tpremio3    
        tpremio3:
            inc si     
            mov al, texto[si] ;9,9,2

            mov tprice3, al 

            inc si     
            mov al, texto[si] ;9, , ,9

            cmp al, 44 ;  ,
            je  tpr31

            jmp tpr32

            tpr31:
                jmp pobstaculos3
            tpr32:

                mov ah, tprice3

                inc si
                xor al, al
                xor ah, ah

                jmp pobstaculos3  
        pobstaculos3:
            inc si     
            mov al, texto[si] ;9,9,2

            mov pobstac3, al 

            inc si     
            mov al, texto[si] ;9, , ,9

            cmp al, 44 ;  ,
            je  pob31

            jmp pob32

            pob31:
                jmp ppremios3
            pob32:

                mov ah, pobstac3

                inc si
                xor al, al
                xor ah, ah

                jmp ppremios3 
        ppremios3:
            inc si     
            mov al, texto[si] ;9,9,2

            mov pprice3, al 

            inc si     
            mov al, texto[si] ;9, , ,9

            ;cmp al, 44 ;  ,
            ;je  ppr1

            cmp al, 59 ;  ;
            je  ppr31

            jmp ppr32

            ppr31:
                print msgf
                print salto
                inc si
                jmp finn
            ppr32:

                mov ah, pprice3

                print msgf
                print salto
                inc si
                jmp finn      
    oopsie:
        print msg21
        jmp Menu4
    finn:
        print salto
        verniveles
        ;placeholder because yikes
        print msgf
        print msgf2
        print salto
        getch

endm

juntarnumeros macro 

    LOCAL uno1, dos1, tres1, cuatro1, cinco1, seis1, siete1, ocho1, nueve1, fiin1

    cmp cl, 1
    je uno1
    cmp cl, 2
    je dos1
    cmp cl, 3
    je tres1
    cmp cl, 4
    je cuatro1
    cmp cl, 5
    je cinco1
    cmp cl, 6
    je seis1
    cmp cl, 7
    je siete1
    cmp cl, 8
    je ocho1
    cmp cl, 9
    je nueve1

    uno1:
        ;print msgf 
        mov bl, 10
        jmp fiin1
    dos1:
        mov bl, 20
        ;print msgf2 
        jmp fiin1
    tres1:
        ;print msgf 
        mov bl, 30
        jmp fiin1
    cuatro1:
        mov bl, 40
        ;print msgf2
        jmp fiin1
    cinco1:
        ;print msgf 
        mov bl, 50
        jmp fiin1
    seis1:
        mov bl, 60
        ;print msgf2
        jmp fiin1
    siete1:
        mov bl, 70
        ;print msgf 
        jmp fiin1
    ocho1:
        mov bl, 80
        ;print msgf2
        jmp fiin1
    nueve1:
        mov bl, 90
        ;print msgf 
        jmp fiin1

    fiin1:
        ; holaaa
endm


clearscreeennormal macro 
    mov cx, 30
    clearnormal:
        print salto
        loop clearnormal

endm

; MACROS DEL MODO VIDEO

moverCursor macro fila, columna
    mov ah, 02h
    mov dh, fila
    mov dl, columna
    int 10h
endm 

iniciarModoVideo macro

    ; modo 13h
    ;320 x 200x 256 colores
    ; c/ pixel un byte. 00h to ffh

    mov ah, 00h
    mov al, 18
    int 10h


endm


; INSERVIBLES POR EL MOMENTO

comparestrings macro txt1, txt2

    LOCAL Noiwales, Iwales, Fin

    push bx
    push BL
    push bh

    MOV BX,00
    MOV BL,txt1
    MOV BH,txt2

    CMP BL,BH
    jne Noiwales

    Noiwales: 
        mov ax, 0
        jmp Fin

    Iwales:
        mov ax, 1
        jmp Fin
    Fin:
        pop bx
        pop BL
        pop bh



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
    userInit db 1500 dup('$')
    ;el por si acaso
    msg26 db 'admin', '$'

    ;entrada
    bufferEntrada db 50 dup(00h)
    handlerEntrada dw ?
    fileEntrada db 1500 dup('$')
    entradaInit db "prueba.ply", 00h ;FUNCIONA!!
    ;entradaInit db "prueba.play", 00h

    ;settings de niveles
    ; db 1-> 256, -128->127

    naux db 0

    timen1 db 0
    tobstac1 db 0
    tprice1 db 0
    pobstac1 db 0
    pprice1 db 0; 2 dup('$')

    timen2 db 0
    tobstac2 db 0
    tprice2 db 0
    pobstac2 db 0
    pprice2 db 0;

    timen3 db 0
    tobstac3 db 0
    tprice3 db 0
    pobstac3 db 0
    pprice3 db 0;

    ;usuario
    anombre db 6 dup(32);, '$'
    acontrasenia db 4 dup('32');, '$'
    ;nuevo
    nnombre db 6 dup(32);, '$'
    ncontrasenia db 4 dup(32);, '$'

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
    tab db 09, '$'
    msgf db ' ! ', '$' ;fin :3
    msgf2 db ' ? ', '$'; fin :c
    msgPrueba db "hola-1234-0;"


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
        ;acá va la magia 
        openfile gameInit, handlerInit
        ; leyendo
        readfile handlerInit, userInit, sizeof userInit
        ; todo está en userinit
        findUser anombre, acontrasenia, userInit

        pushtodo
        closefile handlerInit 
        poptodo

        cmp ax, 1 ;si me regresa que comparó todo chido
        je Menu4

        cmp ax, 2
        je Menu1

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
        je InicioJuego

        cmp al, 2
        je CargarJuego

        cmp al, 3  
        je Salir

        jmp Menu4
    CargarJuego:

        print msg22
        getruta bufferEntrada


        print salto
        ;openfile entradaInit, handlerEntrada
        openfile bufferEntrada, handlerEntrada
        ; leyendo
        readfile handlerEntrada, fileEntrada, sizeof fileEntrada

        ;acá es donde separo las cosas por niveles y eso
        insertLevels fileEntrada


        ;cerrando
        closefile handlerEntrada
        print salto


        jmp Menu4
    InicioJuego:

        iniciarModoVideo

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
