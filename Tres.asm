.model small
.stack 100h

; ----------------------------------- MACROS --------------------------------------------- ;

;   GENERALES ----------------------------------
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

clearscreeennormal macro 
    mov cx, 30
    clearnormal:
        print salto
        loop clearnormal

endm

getnumeros macro arreglo

    LOCAL NuevoChar, FinOT, Again, Nops

    Again: 
        xor si, si; si = 0
        NuevoChar:
            getch
            cmp al, 0dh
            je FinOT ; si es enter, termino de una

            cmp al, 48
            jb Nops

            cmp al, 57
            ja Nops

            mov arreglo[si], al
            inc si; si++
            jmp NuevoChar        
        Nops:
            print salto
            print msg33
            jmp Again

        FinOT:
            mov al, 24h
            mov arreglo[si], ah
endm

imprimirNumero macro numero

    mov numaux1, 0
    mov numaux2, 0

    splitearNumero numero, numaux1, numaux2

    add numaux1, 48
    add numaux2, 48

    printNum numaux1
    printNum numaux2
endm

;   FILES ----------------------------------
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

;   PILA ----------------------------------
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

; VALIDACIONES DE USUARIO ----------------------------------

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
            xor si, si
            inc di
            ;print msgf2
            jmp Comparador

        Sip:
            inc si
            inc di

            ;print msgf

            jmp Comparador
    
    Comparador2:
        xor si, si
        xor di, di
        xor al, al
        xor ah, ah

        Magia:
            mov al, contraseniaEntrada[si]
            mov ah, texto[di]

            cmp si, 4
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
                xor si, si
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

yausuario macro userEntrado, texto

    LOCAL Noiwales, Iwales, ComparadorUS, NopsUS, SipUS, FinUS

    xor si, si
    xor di, di

    ComparadorUS:
        mov al, userEntrado[si]
        mov ah, texto[di]

        cmp si, 6
        je IwalesUS

        cmp al, 0
        je NoiwalesUS
        cmp ah, 0
        je NoiwalesUS

        cmp al, '$'
        je NoiwalesUS
        cmp ah, '$'
        je NoiwalesUS

        cmp al, ah
        je SipUS

        jmp NopsUS

        NopsUS: 
            inc di
            ;print msgf2
            jmp ComparadorUS

        SipUS:
            inc si
            inc di

            ;print msgf

            jmp ComparadorUS

    
    NoiwalesUS: ;si no coincide con nada el cosito
        jmp FinUS
    IwalesUS: 
        print salto
        print msg34
        print salto
        jmp Menu3

    FinUS:
        ;holaa

endm

;   NIVELES ----------------------------------

verniveles macro    

    imprimirNumero timen1
    print salto 
    imprimirNumero tobstac1
    print salto 
    imprimirNumero tprice1
    print salto
    imprimirNumero pobstac1
    print salto
    imprimirNumero pprice1
    print salto 
    print salto
    imprimirNumero timen2
    print salto 
    imprimirNumero tobstac2
    print salto 
    imprimirNumero tprice2
    print salto
    imprimirNumero pobstac2
    print salto
    imprimirNumero pprice2
    print salto 
    print salto
    imprimirNumero timen3
    print salto 
    imprimirNumero tobstac3
    print salto 
    imprimirNumero tprice3
    print salto
    imprimirNumero pobstac3
    print salto
    imprimirNumero pprice3
endm

resetniveles macro
    mov timen1, 0
    mov timen2, 0
    mov timen3, 0

    mov tobstac1, 0
    mov tobstac2, 0
    mov tobstac3, 0

    mov tprice1, 0
    mov tprice2, 0
    mov tprice3, 0

    mov pobstac1, 0
    mov pobstac2, 0
    mov pobstac3, 0

    mov pprice1, 0
    mov pprice2, 0
    mov pprice3, 0    

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
                sub timen1, 48
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
                    print salto
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
                sub tobstac1, 48
                xor al, al
                xor ah, ah
                jmp tpremio1
            tob2:

                xor cl, cl
                xor bl, bl

                mov cl, tobstac1 ; coso de las decenas
                sub cl, 48  

                juntarnumeros     

                sub al, 48      

                add bl, al
                mov byte ptr[tobstac1], bl

                inc si
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
                sub tprice1, 48
                xor al, al
                xor ah, ah
                jmp pobstaculos1
            tpr2:

                xor cl, cl
                xor bl, bl

                mov cl, tprice1 ; coso de las decenas
                sub cl, 48  

                juntarnumeros     

                sub al, 48      

                add bl, al
                mov byte ptr[tprice1], bl

                inc si
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
                sub pobstac1, 48
                xor al, al
                xor ah, ah
                jmp ppremios1
            pob2:

                xor cl, cl
                xor bl, bl

                mov cl, pobstac1 ; coso de las decenas
                sub cl, 48  

                juntarnumeros     

                sub al, 48      

                add bl, al
                mov byte ptr[pobstac1], bl

                inc si

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
                sub pprice1, 48
                xor al, al
                xor ah, ah
                print msgf
                print salto
                inc si
                jmp nvl0
            ppr2:
                xor cl, cl
                xor bl, bl

                mov cl, pprice1 ; coso de las decenas
                sub cl, 48  

                juntarnumeros     

                sub al, 48      

                add bl, al
                mov byte ptr[pprice1], bl
                inc si

                print msgf
                print salto

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
                sub timen2, 48
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
                    print tab
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
                sub tobstac2, 48
                xor al, al
                xor ah, ah
                jmp tpremio2
            tob22:

                xor cl, cl
                xor bl, bl

                mov cl, tobstac2 ; coso de las decenas
                sub cl, 48  

                juntarnumeros     

                sub al, 48      

                add bl, al
                mov byte ptr[tobstac2], bl

                cmp tobstac2, 58
                je chi3

                inc si
                jmp tpremio2

                chi3:
                    print msgf2
                    print msgf2
                    print tab
                    inc si
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
                sub tprice2, 48
                xor al, al
                xor ah, ah
                jmp pobstaculos2
            tpr22:

                xor cl, cl
                xor bl, bl

                mov cl, tprice2 ; coso de las decenas
                sub cl, 48  

                juntarnumeros     

                sub al, 48      

                add bl, al
                mov byte ptr[tprice2], bl

                cmp tprice2, 47
                je chi4

                inc si
                jmp pobstaculos2

                chi4:
                    print msgf2
                    print msgf2
                    print tab
                    inc si
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
                sub pobstac2, 48
                xor al, al
                xor ah, ah
                jmp ppremios2
            pob22:

                xor cl, cl
                xor bl, bl

                mov cl, pobstac2 ; coso de las decenas
                sub cl, 48  

                juntarnumeros     

                sub al, 48      

                add bl, al
                mov byte ptr[pobstac2], bl

                cmp pobstac2, 25
                je chi5

                inc si
                jmp ppremios2

                chi5:
                    print msgf2
                    print msgf2
                    print tab
                    inc si
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
                sub pprice2, 48
                xor al, al
                xor ah, ah
                print msgf
                print salto
                inc si
                jmp nvl0
            ppr22:
                xor cl, cl
                xor bl, bl

                mov cl, pprice2 ; coso de las decenas
                sub cl, 48  

                juntarnumeros     

                sub al, 48      

                add bl, al
                mov byte ptr[pprice2], bl

                cmp pprice2, 36
                je chi6

                print msgf
                print salto
                inc si
                jmp nvl0

                chi6:
                    print msgf2
                    print msgf2
                    print tab
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
                sub timen3, 48
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
                sub tobstac3, 48
                xor al, al
                xor ah, ah
                jmp tpremio3
            tob32:

                xor cl, cl
                xor bl, bl

                mov cl, tobstac3 ; coso de las decenas
                sub cl, 48  

                juntarnumeros     

                sub al, 48      

                add bl, al
                mov byte ptr[tobstac3], bl

                inc si
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
                sub tprice3, 48
                xor al, al
                xor ah, ah
                jmp pobstaculos3
            tpr32:

                xor cl, cl
                xor bl, bl

                mov cl, tprice3 ; coso de las decenas
                sub cl, 48  

                juntarnumeros     

                sub al, 48      

                add bl, al
                mov byte ptr[tprice3], bl

                inc si
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
                sub pobstac3, 48
                xor al, al
                xor ah, ah
                jmp ppremios3
            pob32:
                xor cl, cl
                xor bl, bl

                mov cl, pobstac3 ; coso de las decenas
                sub cl, 48  

                juntarnumeros     

                sub al, 48      

                add bl, al
                mov byte ptr[pobstac3], bl

                inc si
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
                sub pprice3, 48
                xor al, al
                xor ah, ah
                print msgf
                print salto
                inc si
                jmp finn
            ppr32:
                xor cl, cl
                xor bl, bl

                mov cl, pprice3 ; coso de las decenas
                sub cl, 48  

                juntarnumeros     

                sub al, 48      

                add bl, al
                mov byte ptr[pprice3], bl

                inc si
                jmp finn      
    oopsie:
        print msg21
        jmp Menu4
    finn:
        print salto
        print salto
        
        verniveles
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

juntarnumerosCentena macro

    LOCAL uno, dos, tres, cuatro, cinco, seis, siete, ocho, nueve, finjnc

    cmp cl, 1
    je uno
    cmp cl, 2
    je dos
    cmp cl, 3
    je tres
    cmp cl, 4
    je cuatro
    cmp cl, 5
    je cinco
    cmp cl, 6
    je seis
    cmp cl, 7
    je siete
    cmp cl, 8
    je ocho
    cmp cl, 9
    je nueve

    uno:
        ;print msgf 
        mov dx, 100
        jmp finjnc
    dos:
        mov dx, 200
        ;prin msgf2 
        jmp finjnc
    tres:
        ;print msgf 
        mov dx, 300
        jmp finjnc
    cuatro:
        mov dx, 400
        ;print msgf2
        jmp finjnc
    cinco:
        ;print msgf 
        mov dx, 500
        jmp finjnc
    seis:
        mov dx, 600
        ;print msgf2
        jmp finjnc
    siete:
        mov dx, 700
        ;print msgf 
        jmp finjnc
    ocho:
        mov dx, 800
        ;print msgf2
        jmp finjnc
    nueve:
        mov dx, 900
        ;print msgf 
        jmp finjnc

    finjnc:
        ; holaaa
endm

;   ORDENAR

meteraTopsIndi macro texto, array

    LOCAL fini, finii, mainmti

    mainmti:
        mov ah, texto[di]

        cmp ah, 0
        je fini
        cmp ah, '$'
        je fini

        mov array[si], ah
        inc di
        inc si

        cmp ah, 59
        je finii

        jmp mainmti
    fini:
        mov ax, 51        
    finii:
        xor si, si

endm

getPuntos macro array
    LOCAL maingp, fingpi, fingpii, fingpiii, fingpiv, fingpv, fingpvi, found     ;EL RESULTADO FINAL ESTÁ EN CX
    pushtodo

    ; DE ACÁ NUNCA EN LA VIDA VOY A USAR TRES DIGITOS PERO BUEH xd

    xor di, di
    xor al, al
    xor bl, bl
    xor cl, cl
    xor cx, cx

    maingp:
        mov al, array[di]
        inc di  ; si es, de una va metido en el numero

        cmp al, 0
        je fingpv

        cmp al, '$'
        je fingpv

        cmp al, 43
        je found

        jmp maingp
    found:  ; 517, 35, 2;
        xor al, al

        mov cl, array[di] ; 5, 3, 2

        inc di
        mov al, array[di] ; 1, 5, ;

        cmp al, 59
        je fingpi

        ;si es otro numero la segunda columna se pasa a bl
        mov bl, array[di] ; 1, 5, ;
        inc di

        mov al, array[di]   ; 7, ;
        cmp al, 59
        je fingpii

        jmp fingpiii


    fingpi:
        sub cl, 48

        ;mov cx, cl
        and cx, 0ffh
        jmp fingpiv
    fingpii:

        sub cl, 48

        mov al, bl ;al = 5
        juntarnumeros ; bl= 30

        sub al, 48

        add bl, al  ; 30+5
        ;mov cx, bl
        mov cl, bl ; cl = 35
        and cx, 0ffh
        jmp fingpiv

    fingpiii:

        sub cl, 48

        juntarnumerosCentena ;dx = 500

        sub bl, 48
        mov cl, bl ; cl = 1
        juntarnumeros ; bl = 10

        and bx, 0ffh
        ;add dx, bl  ;500+10
        add dx, bx  ;510

        sub al, 48
        ;add cx, al  ;510+7
        and ax, 0ffh
        add dx, ax  ;517


        mov cx, dx
        jmp fingpiv

    fingpiv:
        print msgf
        print tab
        jmp fingpvi
        ;mov word ptr[destino], cx
    fingpv:
        print msgf2
        print tab
        xor cx, cx
        ;mov word ptr[destino], cx
    fingpvi:
        ;
endm

meteraTops macro texto

    LOCAl Finmet, Finmet2
   
    xor di, di
    xor si, si
    xor ah, ah
    xor ax, ax

    meteraTopsIndi texto, pts1
    cmp ax, 51
    je Finmet
    meteraTopsIndi texto, pts2
    cmp ax, 51
    je Finmet
    meteraTopsIndi texto, pts3
    cmp ax, 51
    je Finmet
    meteraTopsIndi texto, pts4
    cmp ax, 51
    je Finmet
    meteraTopsIndi texto, pts5
    cmp ax, 51
    je Finmet
    meteraTopsIndi texto, pts6
    cmp ax, 51
    je Finmet
    meteraTopsIndi texto, pts7
    cmp ax, 51
    je Finmet
    meteraTopsIndi texto, pts8
    cmp ax, 51
    je Finmet
    meteraTopsIndi texto, pts9
    cmp ax, 51
    je Finmet
    meteraTopsIndi texto, pts10
    cmp ax, 51
    je Finmet 

    ; si hay más cosos todavía
    ;mov ah, texto[di]
    ;cmp ah, 0
    ;je Finmet
    ;cmp ah, '$'
    ;je Finmet
    ; si si siguen

    Finmet:

        getPuntos pts1
        mov fpts1, cx
        getPuntos pts2
        mov fpts2, cx
        getPuntos pts3
        mov fpts3, cx
        getPuntos pts4
        mov fpts4, cx
        getPuntos pts5
        mov fpts5, cx
        getPuntos pts6
        mov fpts6, cx
        getPuntos pts7
        mov fpts7, cx
        getPuntos pts8
        mov fpts8, cx
        getPuntos pts9
        mov fpts9, cx
        getPuntos pts10
        mov fpts10, cx

        cmp fpts5, 30
        je wenas

        jmp Finmet2

        wenas:
            print salto
            print msg1        

    Finmet2:

       ; METIENDO A LOS ARRAYS QUE VAN A SERVIR EN LAS GRÁFICAS (?)

         meteraArrays puntosOrdBubble, puntosOrdQuick

         print puntosOrdBubble
         ;print puntosOrdQuick
        
        

endm

meteraArrays macro arraydestino, arraydestino2

    LOCAL mainMA

    xor si, si
    xor ax, ax

    mov ax, fpts1
    mov arraydestino[si], ax
    mov arraydestino2[si], ax
    inc si
    mov ax, fpts2
    mov arraydestino[si], ax
    mov arraydestino2[si], ax
    inc si
    mov ax, fpts3
    mov arraydestino[si], ax
    mov arraydestino2[si], ax
    inc si
    mov ax, fpts4
    mov arraydestino[si], ax
    mov arraydestino2[si], ax
    inc si
    mov ax, fpts5
    mov arraydestino[si], ax
    mov arraydestino2[si], ax
    inc si
    mov ax, fpts6
    mov arraydestino[si], ax
    mov arraydestino2[si], ax
    inc si
    mov ax, fpts7
    mov arraydestino[si], ax
    mov arraydestino2[si], ax
    inc si
    mov ax, fpts8
    mov arraydestino[si], ax
    mov arraydestino2[si], ax
    inc si
    mov ax, fpts9
    mov arraydestino[si], ax
    mov arraydestino2[si], ax
    inc si
    mov ax, fpts10
    mov arraydestino[si], ax
    mov arraydestino2[si], ax

    ;print salto
    ;print msgf
    ;print msgf
    ;print salto
endm

; MACROS EN PROCESO

intercambiar macro arreglo
    ;
endm

bubbleSort macro arr

    xor si, si  ;j
    xor di, di  ;k

    xor ax, ax
    xor bx, bx
    xor cx, cx
    mov bsaux, 00



endm

mostrarPuntos macro texto

    ;holaaa

endm

; MACROS DEL MODO VIDEO

; GENERALES

iniciarJuego macro 
    ;
    insertarTexto
    pintarCuadrito
    dibujarCarrito

    ;DIBUJANDO MONEDAS
    dibujarMoneda monedaX, monedaY
    dibujarMoneda monedaX2, monedaY2
    dibujarMoneda monedaX3, monedaY3
    dibujarMoneda monedaX4, monedaY4
    dibujarMoneda monedaX5, monedaY5
    dibujarMoneda monedaX6, monedaY6
    dibujarMoneda monedaX7, monedaY7

    ;DIBUJANDO OBSTACULOS
    dibujarObstaculo obstacX, obstacY
    dibujarObstaculo obstacX2, obstacY2
    dibujarObstaculo obstacX3, obstacY3
    dibujarObstaculo obstacX4, obstacY4
    dibujarObstaculo obstacX5, obstacY5
    dibujarObstaculo obstacX6, obstacY6
    dibujarObstaculo obstacX7, obstacY7
    
endm

pausa macro 

    LOCAL pausando, terminando, finfin

    pushtodo

    pausando:
        mov ah, 00h
        int 16h 

        cmp al, 32
        je terminando

        cmp al, 27 ;esc pa pausar la cosa
        jne pausando

        ;si si es esc sigue de largo y todo normal
        jmp finfin

        terminando:
            cestfini
            mov ax,3h
            int 10h ;salgo del modo video

            print msg51
            print salto
            print msg52
            print tab

            imprimirNumero puntosJugador

            getch

            jmp Menu4 ;voy al menu principal
    finfin:
        ;

    poptodo

endm

cestfini macro

    pushtodo

        ;METER TODAS LAS COSAS AL ARCHIVO DE HISTORIAL
        openfile pointsInit, handlerPoints

        meterafile handlerPoints, 7, anombre
        meterafile handlerPoints, 1, coma
        add numNivel, 48
        meterafile handlerPoints, 1, numNivel
        sub numNivel, 48
        meterafile handlerPoints, 1, mas

        mov numaux1, 0
        mov numaux2, 0

        splitearNumero puntosJugador, numaux1, numaux2

        add numaux1, 48
        add numaux2, 48

        meterafile handlerPoints, 1, numaux1
        meterafile handlerPoints, 1, numaux2

        meterafile handlerPoints, 1, puntoycoma

        closefile handlerPoints

    poptodo

endm

moverCarrito macro

    LOCAL checkMov, finmc

    mov ah, 01h
    int 16h     ;wacha si se esta presionando una key
    jz checkMov

    mov ah, 00h
    int 16h     ; si si, miro cual

    ;cmp al, 27 ;ver si es izquierda <-, 26 ->
    ;je moverIzquierda
    cmp al, 37 
    je moverIzquierda
    cmp al, 65
    je moverIzquierda
    cmp al, 97
    je moverIzquierda

    cmp al, 26
    je moverDerecha
    cmp al, 39
    je moverDerecha
    cmp al, 68
    je moverDerecha
    cmp al, 100 
    je moverDerecha  

    cmp al, 32 ;espacio pa finalizar la partida
    je finPartida

    cmp al, 27 ;esc pa pausar la cosa
    je pausaPartida 

    jmp checkMov

    moverIzquierda:
        ;escribirCaracter 3
        mov ax, carritoVelocidad
        sub carritoX, ax

        mov ax, pantallaLimiteIzq
        cmp carritoX, ax
        jle carritoLimizq

        jmp checkMov

        carritoLimizq:
            mov carritoX,  ax
            jmp checkMov
    moverDerecha:
        ;escribirCaracter 2
        mov ax, carritoVelocidad
        add carritoX, ax

        mov ax, pantallaLimiteDer
        sub ax, carritoAncho
        cmp carritoX, ax
        jge carritoLimder

        jmp checkMov

        carritoLimder:
            mov carritoX, ax
            jmp checkMov
    finPartida:
        cestfini
        mov ax,3h
	    int 10h ;salgo del modo video

        print msg51
        print salto
        print msg52
        print tab

        imprimirNumero puntosJugador

        getch

        jmp Menu4 ;voy al menu principal

    pausaPartida:

        pausa

    checkMov:
        ;

endm

insertarTexto macro

    LOCAL unidad, decena, finiti

    pushtodo

    xor si, si
    xor cx, cx
    xor dl, dl

    mov dl, 2
    mov cx, 7

    inombre:

        moverCursor 2, dl
        escribirCaracter anombre[si]
        inc si
        inc dl

    Loop inombre

    moverCursor 2, dl
    escribirCaracter 32 ;space
    inc dl
    moverCursor 2, dl
    escribirCaracter 32 ;space
    inc dl
    moverCursor 2, dl
    escribirCaracter 32 ;space
    inc dl

    ;numero de nivel
        moverCursor 2, dl
        escribirCaracter 78;space
        inc dl
        moverCursor 2, dl
        add numNivel, 48
        escribirCaracter numNivel
        sub numNivel, 48
        inc dl

        moverCursor 2, dl
        escribirCaracter 32 ;space
        inc dl
        moverCursor 2, dl
        escribirCaracter 32 ;space
        inc dl
        moverCursor 2, dl
        escribirCaracter 32 ;space
        inc dl

    ; puntos

        mov numaux1, 0
        mov numaux2, 0

        splitearNumero puntosJugador, numaux1, numaux2
        moverCursor 2, dl
        escribirCaracter 48 ;0
        inc dl
        moverCursor 2, dl
        add numaux1, 48
        escribirCaracter numaux1 ;numaux1
        inc dl
        moverCursor 2, dl
        add numaux2, 48
        escribirCaracter numaux2 ;numaux2
        inc dl
    

    ;hora
    finiti: 

        moverCursor 2, dl
        escribirCaracter 32 ;space
        inc dl
        moverCursor 2, dl
        escribirCaracter 32 ;space
        inc dl
        moverCursor 2, dl
        escribirCaracter 32 ;space
        inc dl

        ;min
            
            mov numaux1, 0
            mov numaux2, 0
            splitearNumero minutos, numaux1, numaux2

            moverCursor 2, dl
            add numaux1, 48
            escribirCaracter numaux1 ;numaux1
            inc dl
            moverCursor 2, dl
            add numaux2, 48
            escribirCaracter numaux2 ;numaux2
            inc dl    
            moverCursor 2, dl
            escribirCaracter 58 ;space
            inc dl 
        ;sec

            mov numaux1, 0
            mov numaux2, 0
            splitearNumero segundos, numaux1, numaux2

            moverCursor 2, dl
            add numaux1, 48
            escribirCaracter numaux1 ;numaux1
            inc dl
            moverCursor 2, dl
            add numaux2, 48
            escribirCaracter numaux2 ;numaux2
            inc dl             
            

            moverCursor 2, dl
            escribirCaracter 58 ;space
            inc dl
        ;mili

            mov numaux1, 0
            mov numaux2, 0
            splitearNumero milisec, numaux1, numaux2

            moverCursor 2, dl
            add numaux1, 48
            escribirCaracter numaux1 ;numaux1
            inc dl
            moverCursor 2, dl
            add numaux2, 48
            escribirCaracter numaux2 ;numaux2
            inc dl  
            inctiempo milisec, segundospasados, segundos, minutos

        ;segundospasados
            moverCursor 2, dl
            escribirCaracter 32 ;space
            inc dl
            moverCursor 2, dl
            escribirCaracter 32 ;space
            inc dl
            moverCursor 2, dl
            escribirCaracter 32 ;space
            inc dl

            mov numaux1, 0
            mov numaux2, 0
            splitearNumero segundospasados, numaux1, numaux2

            moverCursor 2, dl
            add numaux1, 48
            escribirCaracter numaux1 ;numaux1
            inc dl
            moverCursor 2, dl
            add numaux2, 48
            escribirCaracter numaux2 ;numaux2
            inc dl 
              
    poptodo
endm

clearscreenvideo macro
    
    mov ax,13h
	int 10h

    ;mov ah, 08h  ;configuracion
    ;mov bh, 00h  ;bckgrnd color
    ;mov bl, 00h  ;black
    ;int 10h

endm

pintarNegro macro 

    LOCAL negro, finpn

    mov cx, pantallaJuegoX ;la columna inicial de x
    mov dx, pantallaJuegoY

    negro:        
        pintarPixel cx, dx, 00h
        inc cx
        mov ax, cx
        sub ax, pantallaJuegoX
        cmp ax, pantallaJAncho
        jng negro

        mov cx, pantallaJuegoX
        inc dx
        mov ax, dx
        sub ax, pantallaJuegoY
        cmp ax, pantallaJLargo
        jng negro

    finpm: 
        ;

endm

clearText macro

    LOCAL black, finct

    mov cx, pantallatextoX ;la columna inicial de x
    mov dx, pantallatextoY

    black:        
        pintarPixel cx, dx, 00h
        inc cx
        mov ax, cx
        sub ax, pantallatextoX
        cmp ax, pantallaTAncho
        jng black

        mov cx, pantallatextoX
        inc dx
        mov ax, dx
        sub ax, pantallatextoY
        cmp ax, pantallaTLargo
        jng black

    finct: 
        ;

endm

pintarCuadrito macro 

    ; vertical
    LOCAL uno, dos, tres, cuatro, rep2, rep3, rep4, finpc

    mov cx, 180

    uno:
        pintarPixel 20,cx,4fh

        cmp cx, 30
        je dos
    Loop uno

    dos:
        xor cx, cx
        mov cx, 180

        rep2:
            pintarPixel 300,cx,4fh

            cmp cx, 30
            je tres
        Loop rep2

    tres:
        xor cx, cx
        mov cx, 300

        rep3:
            pintarPixel cx,30,4fh

            cmp cx, 20
            je cuatro
        Loop rep3

    cuatro:

        xor cx, cx
        mov cx, 300

        rep4:
            pintarPixel cx,180,4fh

            cmp cx, 20
            je finpc
        Loop rep4
    finpc:
        ;
endm

pintarPixel macro x, y, color

    pushtodo

    mov ah,0ch	;funcion para pintar un pixel
	mov al, color	; definimos el color
	mov bh,0	; definimos la pagina	
	mov dx, y	; definimos coord y0
	mov cx, x	; definimos coord x0
	
	int 10h	

    poptodo

endm

escribirCaracter macro char

    pushtodo

    mov ah, 0Ah
    mov al, char
    mov bh,0
    mov cx, 1
    int 10h

    poptodo

endm

; VERIFICACIONES Y SEGUNDO PLANO

checarTiempo macro

    LOCAL nivl1, nivl2, nivl3, finct, siguiente, fincti

    pushtodo

    mov al, segundospasados
    
    ;VER EN QUE NIVEL ESTOY
    cmp numNivel, 1
    je nivl1
    cmp numnivel, 2
    je nivl2
    cmp numnivel, 3
    je nivl3

    jmp finct

    nivl1:
        ;escribirCaracter 200
        cmp al, timen1
        jae siguiente
        jmp fincti
    nivl2:
        ;escribirCaracter 201
        cmp al, timen2
        jae siguiente
        jmp fincti
    nivl3:
        ;escribirCaracter 202
        cmp al, timen3
        jae finct
        jmp fincti
    siguiente:
        mov segundospasados, 0
        inc numNivel
        jmp fincti
    finct:
        cestfini
        mov ax,3h
	    int 10h ;salgo del modo video

        print msg51
            print salto
            print msg52
            print tab

            imprimirNumero puntosJugador

            getch

        jmp Menu4 ;voy al menu principal

    fincti:
        ;

    poptodo

endm


moverCursor macro fila, columna

    pushtodo
    mov ah, 02h
    mov dh, fila
    mov dl, columna
    int 10h
    poptodo
endm

inctiempo macro chiquito, copia, grande, masgrande

    LOCAL iwalit, maxx, finiti

    inc chiquito
    inc copia
    inc segundosdePremio
    inc segundosdeObstaculo
    cmp chiquito, 60
    je iwalit

    jmp finiti

    iwalit:
        mov [chiquito], 0
        mov chiquito, 0
        inc grande

        cmp grande, 60
        je maxx

        jmp finiti

    maxx:
        mov [grande], 0
        mov grande, 0

        inc masgrande
    finiti:
        ;

endm

splitearNumero macro numero, decena, unidad

    LOCAL undigito, dosdigitos, finin

    pushtodo

    cmp numero, 9
    jbe undigito

    jmp dosdigitos

    undigito:
        xor al, al
        mov decena, 0
        mov al, numero
        mov unidad, al
        jmp finin
    dosdigitos:        
        
        xor ah, ah
        mov al, numero
        mov bl, 10
        div bl
        mov unidad, ah
        mov decena, al

        jmp finin      

    finin:
        ;
        poptodo

endm

dibujarCarrito macro

    LOCAL carritoHorizontal, findc

    mov cx, carritoX ;la columna inicial de x
    mov dx, carritoY

    carritoHorizontal:        
        pintarPixel cx, dx, 134
        inc cx
        mov ax, cx
        sub ax, carritoX
        cmp ax, carritoAncho
        jng carritoHorizontal

        mov cx, carritoX
        inc dx
        mov ax, dx
        sub ax, carritoY
        cmp ax, carritoLargo
        jng carritoHorizontal

    findc: 
        ;
endm


; NIVELES
vernivelesRapido macro

    LOCAL niv1, niv2, niv3, finvnr

    pushtodo

    cmp numNivel, 1
    je niv1
    cmp numNivel, 2
    je niv2
    cmp numNivel, 3
    je niv3

    niv1:
        mov numaux1, 0
        mov numaux2, 0

        splitearNumero timen1, numaux1, numaux2
        moverCursor 2, 3
        add numaux1, 48
        escribirCaracter numaux1 ;numaux1
        inc dl
        moverCursor 2, 4
        add numaux2, 48
        escribirCaracter numaux2 ;numaux2
        inc dl
        jmp finvnr
        
    niv2:
        mov numaux1, 0
        mov numaux2, 0

        splitearNumero timen2, numaux1, numaux2
        moverCursor 2, 3
        add numaux1, 48
        escribirCaracter numaux1 ;numaux1
        inc dl
        moverCursor 2, 4
        add numaux2, 48
        escribirCaracter numaux2 ;numaux2
        inc dl
        jmp finvnr
    niv3:
        mov numaux1, 0
        mov numaux2, 0

        splitearNumero timen3, numaux1, numaux2
        moverCursor 2, 3
        add numaux1, 48
        escribirCaracter numaux1 ;numaux1
        inc dl
        moverCursor 2, 4
        add numaux2, 48
        escribirCaracter numaux2 ;numaux2
        inc dl
        jmp finvnr
    finvnr:
        ;

    poptodo
endm

resetTodo macro
	mov carritox, 32
	mov carritoY, 156
    mov puntosJugador, 3
    mov numNivel, 1

    mov numaux1, 0
    mov numaux2, 0

    mov segundospasados, 0
    mov segundosdeObstaculo, 0
    mov segundosdePremio, 0
    
    mov minutos, 0
    mov segundos, 0
    mov milisec, 0
endm

; COLISIONES

dibujarMoneda macro monx, mony

    LOCAL moneda, findm

    mov cx, monx ;la columna inicial de x
    mov dx, mony

    moneda:        
        pintarPixel cx, dx, 0Eh
        inc cx
        mov ax, cx
        sub ax, monx
        cmp ax, monedasSize
        jng moneda

        mov cx, monx
        inc dx
        mov ax, dx
        sub ax, mony
        cmp ax, monedasSize
        jng moneda

    findm: 
        ;

endm

dibujarObstaculo macro obx, oby

    Local obstaculo, findo

    mov cx, obx
    mov dx, oby

    obstaculo:
        pintarPixel cx, dx, 02
        inc cx
        mov ax, cx
        sub ax, obx
        cmp ax, obstacSize
        jng obstaculo

        mov cx, obx
        inc dx
        mov ax, dx
        sub ax, oby
        cmp ax, obstacSize
        jng obstaculo


    findo:
        ;
endm

colisionesGeneral macro 

    checarPunto monedaX, monedaY, swm1
    checarPunto monedaX2, monedaY2, swm2
    checarPunto monedaX3, monedaY3, swm3
    checarPunto monedaX4, monedaY4, swm4
    checarPunto monedaX5, monedaY5, swm5
    checarPunto monedaX6, monedaY6, swm6
    checarPunto monedaX7, monedaY7, swm7

    checarColision obstacX, obstacY, swobs1
    checarColision obstacX2, obstacY2, swobs2
    checarColision obstacX3, obstacY3, swobs3
    checarColision obstacX4, obstacY4, swobs4
    checarColision obstacX5, obstacY5, swobs5
    checarColision obstacX6, obstacY6, swobs6
    checarColision obstacX7, obstacY7, swobs7

endm

checarPunto macro monedaxi, monedayi, codigo

    LOCAL izquierdo, derecho, fincp

    pushtodo

    ;maxx1 > minx2 && minx1 < maxx2 && maxy1 > miny2 && miny1 < maxy2
    ;carx+12 > monedax
    ;carrx < monedax+12
    ;carry+22 > moneday
    ;carry < moneday+

    derecho:

        mov ax, carritoX
        add ax, carritoAncho    ;maxCarrx > monedax
        cmp ax, monedaxi
		jng fincp

        mov ax, monedaxi
        add ax, monedasSize
        cmp carritox, ax
        jnl fincp     

        mov ax, carritoY
        add ax, carritoLargo
        cmp ax, monedayi
        jng fincp

        mov ax, monedayi
        add ax, monedasSize
        cmp carritoY, ax
        jnl fincp
        
        
        ;si sigo acá es porque si hay colision :D
        ;escribirCaracter 3
        meterPunto     
        mov monedayi, 32
        mov codigo, 0

    fincp:
        ;

    poptodo
endm

meterPunto macro

    LOCAL nivl1, nivl2, nivl3, finmp

    pushtodo

    
    ;VER EN QUE NIVEL ESTOY
    cmp numNivel, 1
    je nivl1
    cmp numnivel, 2
    je nivl2
    cmp numnivel, 3
    je nivl3

    jmp finmp

    nivl1:
        mov bl, pprice1
        add puntosJugador, bl
        jmp finmp
    nivl2:
        mov bl, pprice2
        add puntosJugador, bl
        jmp finmp
    nivl3:
        mov bl, pprice2
        add puntosJugador, bl
        jmp finmp
    finmp:
        ;

    poptodo

endm

checarColision macro obstxi, obstyi, codigo

    LOCAL izquierdo, derecho, fincc

    pushtodo

    derecho:

        mov ax, carritoX
        add ax, carritoAncho    ;maxCarrx > monedax
        cmp ax, obstxi
		jng fincc

        mov ax, obstxi
        add ax, obstacSize
        cmp carritox, ax
        jnl fincc     

        mov ax, carritoY
        add ax, carritoLargo
        cmp ax, obstyi
        jng fincc

        mov ax, obstyi
        add ax, obstacSize
        cmp carritoY, ax
        jnl fincc
        
        
        ;si sigo acá es porque si hay colision :D
        ;escribirCaracter 3
        meterChoque 
        mov obstyi, 0
        mov codigo, 0  
    fincc:
        ;

    poptodo

endm

meterChoque macro

    LOCAL nivl1, nivl2, nivl3, finmc, ups, finmci

    pushtodo

    
    ;VER EN QUE NIVEL ESTOY
    cmp numNivel, 1
    je nivl1
    cmp numnivel, 2
    je nivl2
    cmp numnivel, 3
    je nivl3

    jmp finmc

    nivl1:
        mov bl, pobstac1
        sub puntosJugador, bl
        jmp finmc
    nivl2:
        mov bl, pobstac2
        sub puntosJugador, bl
        jmp finmc
    nivl3:
        mov bl, pobstac3
        sub puntosJugador, bl
        jmp finmc
    finmc:
        ; checar si es menor a 0

        cmp puntosJugador, 0
        jle ups

        jmp finmci

        ups:
            cestfini
            mov ax,3h
            int 10h ;salgo del modo video

            print msg51
            print salto
            print msg52
            print tab

            imprimirNumero puntosJugador

            getch

            jmp Menu4 ;voy al menu principal

        finmci:
            ;

    poptodo

endm

bajarMonedas macro

    LOCAL uno, dos, tres, cuatro, cinco, seis, siete, finbm, reset1, reset2, reset3, reset4, reset5, reset6, reset7

    uno:
        cmp swm1, 0 ;si no está activado, miro la siguiente
        je dos

        ;si si esta activado... swm1, 1
        add monedaY, 6

        cmp monedaY, 156
        jae reset1

        jmp dos

        reset1:
            mov monedaY, 32     ;regreso y reseteo chif
            mov swm1, 0

    dos:
        cmp swm2, 0 ;si no está activado, miro la siguiente
        je tres

        ;si si esta activado... swm1, 1
        add monedaY2, 6

        cmp monedaY2, 156
        jae reset2

        jmp tres

        reset2:
            mov monedaY2, 32     ;regreso y reseteo chif
            mov swm2, 0
    tres:
        cmp swm3, 0 ;si no está activado, miro la siguiente
        je cuatro

        ;si si esta activado... swm1, 1
        add monedaY3, 6

        cmp monedaY3, 156
        jae reset3

        jmp cuatro

        reset3:
            mov monedaY3, 33    ;regreso y reseteo chif
            mov swm3, 0
    cuatro:
        cmp swm4, 0 ;si no está activado, miro la siguiente
        je cinco

        ;si si esta activado... swm1, 1
        add monedaY4, 6

        cmp monedaY4, 156
        jae reset4

        jmp cinco

        reset4:
            mov monedaY4, 32     ;regreso y reseteo chif
            mov swm4, 0
    cinco:
        cmp swm5, 0 ;si no está activado, miro la siguiente
        je seis

        ;si si esta activado... swm1, 1
        add monedaY5, 6

        cmp monedaY5, 156
        jae reset5

        jmp seis

        reset5:
            mov monedaY5, 32     ;regreso y reseteo chif
            mov swm5, 0
    seis:
        cmp swm6, 0 ;si no está activado, miro la siguiente
        je siete

        ;si si esta activado... swm1, 1
        add monedaY6, 6

        cmp monedaY6, 156
        jae reset6

        jmp siete

        reset6:
            mov monedaY6, 32     ;regreso y reseteo chif
            mov swm6, 0
    siete:
        cmp swm7, 0 ;si no está activado, miro la siguiente
        je finbm

        ;si si esta activado... swm1, 1
        add monedaY7, 6

        cmp monedaY7, 156
        jae reset7

        jmp finbm

        reset7:
            mov monedaY7, 32     ;regreso y reseteo chif
            mov swm7, 0
    finbm:
        ;

endm

bajarObstaculos macro
    LOCAL uno, dos, tres, cuatro, cinco, seis, siete, finbm, reset1, reset2, reset3, reset4, reset5, reset6, reset7

    uno:
        cmp swobs1, 0 ;si no está activado, miro la siguiente
        je dos

        ;si si esta activado... swobs1, 1
        add obstacY, 6

        cmp obstacY, 156
        jae reset1

        jmp dos

        reset1:
            mov obstacY, 32     ;regreso y reseteo chif
            mov swobs1, 0

    dos:
        cmp swobs2, 0 ;si no está activado, miro la siguiente
        je tres

        ;si si esta activado... swobs1, 1
        add obstacY2, 6

        cmp obstacY2, 156
        jae reset2

        jmp tres

        reset2:
            mov obstacY2, 32     ;regreso y reseteo chif
            mov swobs2, 0
    tres:
        cmp swobs3, 0 ;si no está activado, miro la siguiente
        je cuatro

        ;si si esta activado... swobs1, 1
        add obstacY3, 6

        cmp obstacY3, 156
        jae reset3

        jmp cuatro

        reset3:
            mov obstacY3, 33    ;regreso y reseteo chif
            mov swobs3, 0
    cuatro:
        cmp swobs4, 0 ;si no está activado, miro la siguiente
        je cinco

        ;si si esta activado... swobs1, 1
        add obstacY4, 6

        cmp obstacY4, 156
        jae reset4

        jmp cinco

        reset4:
            mov obstacY4, 32     ;regreso y reseteo chif
            mov swobs4, 0
    cinco:
        cmp swobs5, 0 ;si no está activado, miro la siguiente
        je seis

        ;si si esta activado... swobs1, 1
        add obstacY5, 6

        cmp obstacY5, 156
        jae reset5

        jmp seis

        reset5:
            mov obstacY5, 32     ;regreso y reseteo chif
            mov swobs5, 0
    seis:
        cmp swobs6, 0 ;si no está activado, miro la siguiente
        je siete

        ;si si esta activado... swobs1, 1
        add obstacY6, 6

        cmp obstacY6, 156
        jae reset6

        jmp siete

        reset6:
            mov obstacY6, 32     ;regreso y reseteo chif
            mov swobs6, 0
    siete:
        cmp swobs7, 0 ;si no está activado, miro la siguiente
        je finbm

        ;si si esta activado... swobs1, 1
        add obstacY7, 6

        cmp obstacY7, 156
        jae reset7

        jmp finbm

        reset7:
            mov obstacY7, 32     ;regreso y reseteo chif
            mov swobs7, 0
    finbm:
        ;
    

endm


; EN PROCESO X2

tiempoMonedas macro

    LOCAL nivl1, nivl2, nivl3, fincti, siguiente, fincti

    pushtodo

    mov al, segundosdePremio
    
    ;VER EN QUE NIVEL ESTOY
    cmp numNivel, 1
    je nivl1
    cmp numnivel, 2
    je nivl2
    cmp numnivel, 3
    je nivl3

    jmp fincti

    nivl1:
        ;escribirCaracter 200
        cmp al, tprice1
        jae siguiente
        jmp fincti
    nivl2:
        ;escribirCaracter 201
        cmp al, tprice2
        jae siguiente
        jmp fincti
    nivl3:
        ;escribirCaracter 202
        cmp al, tprice3
        jae siguiente
        jmp fincti
    siguiente:
        mov segundosdePremio, 0

        switchMonedas

        ;ACA ES DONDE MOV SWMS1, 1
        jmp fincti
    fincti:
        ;

    poptodo

endm

switchMonedas macro

    LOCAL uno, dos, tres, cuatro, cinco, seis, siete, finbm, reset

    pushtodo

    mov al, indexmoneda

    cmp al, 0
    je uno
    cmp al, 1
    je dos
    cmp al, 2
    je tres
    cmp al, 3
    je cuatro
    cmp al, 4
    je cinco
    cmp al, 5
    je seis
    cmp al, 6
    je siete

    jmp finbm

    uno:
        mov swm1, 1
        inc indexmoneda
        jmp finbm
    dos:
        mov swm2, 1
        inc indexmoneda
        jmp finbm
    tres:
        mov swm3, 1
        inc indexmoneda
        jmp finbm
    cuatro:
        mov swm4, 1
        inc indexmoneda
        jmp finbm
    cinco: 
        mov swm5, 1
        inc indexmoneda
        jmp finbm
    seis:
        mov swm6, 1
        inc indexmoneda
        jmp finbm
    siete:
        mov swm7, 1
        mov indexmoneda, 0
        jmp finbm
    finbm:
        ;

    poptodo

endm    

tiempoObstac macro

    LOCAL nivl1, nivl2, nivl3, fincti, siguiente, fincti

    pushtodo

    mov al, segundosdeObstaculo
    
    ;VER EN QUE NIVEL ESTOY
    cmp numNivel, 1
    je nivl1
    cmp numnivel, 2
    je nivl2
    cmp numnivel, 3
    je nivl3

    jmp fincti

    nivl1:
        ;escribirCaracter 200
        cmp al, tobstac1
        jae siguiente
        jmp fincti
    nivl2:
        ;escribirCaracter 201
        cmp al, tobstac2
        jae siguiente
        jmp fincti
    nivl3:
        ;escribirCaracter 202
        cmp al, tobstac3
        jae siguiente
        jmp fincti
    siguiente:
        mov segundosdeObstaculo, 0

        switchObstaculos

        ;ACA ES DONDE MOV SWMS1, 1
        jmp fincti
    fincti:
        ;

    poptodo

endm

switchObstaculos macro 

    LOCAL uno, dos, tres, cuatro, cinco, seis, siete, finbm, reset

    pushtodo

    mov al, indexobstac

    cmp al, 0
    je uno
    cmp al, 1
    je dos
    cmp al, 2
    je tres
    cmp al, 3
    je cuatro
    cmp al, 4
    je cinco
    cmp al, 5
    je seis
    cmp al, 6
    je siete

    jmp finbm

    uno:
        mov swobs1, 1
        inc indexobstac
        jmp finbm
    dos:
        mov swobs2, 1
        inc indexobstac
        jmp finbm
    tres:
        mov swobs3, 1
        inc indexobstac
        jmp finbm
    cuatro:
        mov swobs4, 1
        inc indexobstac
        jmp finbm
    cinco: 
        mov swobs5, 1
        inc indexobstac
        jmp finbm
    seis:
        mov swobs6, 1
        inc indexobstac
        jmp finbm
    siete:
        mov swobs7, 1
        mov indexobstac, 0
        jmp finbm
    finbm:
        ;

    poptodo

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
        msg26 db 'wuxian', '$'

        ;entrada
        bufferEntrada db 50 dup(00h) ;esta es la ruta
        handlerEntrada dw ?
        fileEntrada db 1500 dup('$')
        entradaInit db "prueba.ply", 00h ;FUNCIONA!!
        ;entradaInit db "prueba.play", 00h

        ;puntos_ordenados
        ;pointsInit db "Puntos.rep", 00h
        pointsInit db "hist.rep", 00h
        handlerPoints dw ?
        filePoints db 1500 dup('$')
        coma db ',', '$'
        mas db '+', '$'
        puntoycoma db 59, '$'


    ;settings de niveles
    ; db 1-> 256, -128->127

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
    anombre db 7 dup(32);, '$'
    acontrasenia db 4 dup('32');, '$'
    ;nuevo
    nnombre db 7 dup(32);, '$'
    ncontrasenia db 4 dup(32);, '$'

    ; menu general (1)
        bienvenida db 09,'BiENVENIDO AL PROYECTO FINAL!! :D', 00h, 0Ah, '$'
        msg1 db 09,'1) Ingresa', 00h, 0Ah, '$'
        msg2 db 09,'2) Registrate', 00h, 0Ah, '$'
        msg3 db 09,'3) Salir', 00h, 0Ah, '$'

    ;menu de ingreso (2) y registro (3)
        msg4 db 09,'Ingresa tu nombre de usuario', 00h, 0Ah, '$'
        msg5 db 09,'Ingresa tu contrasenia', 00h, 0Ah, '$'
        msg17 db 09,'Usuario o contrasenia incorrectos :c', 00h, 0Ah, '$'
        
        msg25 db 09, 'Usuario Registrado! :D', 00h, 0Ah, '$'
        msg28 db 09, 'Tu usuario o contrasenia no coinciden :c', 00h, 0Ah, '$'
        msg29 db 09, '1) Ingresar como usuario', 00h, 0Ah, '$'
        msg30 db 09,'2) Ingresar como admin', 00h, 0Ah, '$'

        msg35 db 09,'INGRESO', 00h, 0Ah, '$'
        msg36 db 09,'REGISTRO', 00h, 0Ah, '$'

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
        msg33 db 09,'ERROR: la contraseña son solo numeros!! :c', 00h, 0Ah, '$'
        msg34 db 09,'ERROR: el usuario ya existe :c', 00h, 0Ah, '$'    


    ;mostrar puntos
        msg37 db 09,'TOP 10 PUNTOS', 00h, 0Ah, '$'
    
    ;strings donde esta todo
        pts1 db 15 dup('$')
        pts2 db 15 dup('$')
        pts3 db 15 dup('$')
        pts4 db 15 dup('$')
        pts5 db 15 dup('$')
        pts6 db 15 dup('$')
        pts7 db 15 dup('$')
        pts8 db 15 dup('$')
        pts9 db 15 dup('$')
        pts10 db 15 dup('$')

        ptsaux db 14 dup(32)
        ptsaux2 db 14 dup(32)

    ; cosos donde se guardan los puntos de pts

        fpts1 dw 0
        fpts2 dw 0
        fpts3 dw 0
        fpts4 dw 0
        fpts5 dw 0
        fpts6 dw 0
        fpts7 dw 0
        fpts8 dw 0
        fpts9 dw 0
        fpts10 dw 0

    ;ORDENAMIENTO

        bsaux dw 0
        bsaux2 dw 0
        puntosOrdBubble dw 10 dup(00h)
        puntosOrdQuick dw 10 dup(00h)

    ;graficas

    ;juego

        carritoX dw 22
        carritoY dw 156
        carritoAncho dw 0Ch   ;el carrito es de 12x22
        carritoLargo dw 16h
        carritoVelocidad dw 10h       

        pantallaJuegoX dw 22
        pantallaJuegoY dw 32
        pantallaJAncho dw 276
        pantallaJLargo dw 150
        pantallaLimiteIzq dw 22
        pantallaLimiteDer dw 290


        pantallatextoX dw 0
        pantallatextoY dw 0
        pantallaTAncho dw 310
        pantallaTLargo dw 28 

        timeAux db 0
        puntosJugador db 3
        numNivel db 1

        numaux1 db 0
        numaux2 db 0

        segundos db 0
	    minutos	db 0
        milisec db 0

        segundospasados db 0 ;para la cuenta de los niveles
        segundosdeObstaculo db 0
        segundosdePremio db 0

        ; MONEDAS = 6 (?) 6427513

            monedasSize dw 0Ch ; las monedas son de 12x12
            monedaX dw 86;286
            monedaY dw 32

            monedaX2 dw 166;246
            monedaY2 dw 32

            monedaX3 dw 246;206
            monedaY3 dw 32

            monedaX4 dw 46;166
            monedaY4 dw 32

            monedaX5 dw 126;126
            monedaY5 dw 32

            monedaX6 dw 286;86
            monedaY6 dw 32

            monedaX7 dw 206;46
            monedaY7 dw 32 


            swm1 db 0
            swm2 db 0
            swm3 db 0
            swm4 db 0
            swm5 db 0
            swm6 db 0
            swm7 db 0

            indexmoneda db 0

        ; OBSTACULOS = 6 (?) 1374526

            obstacSize dw 0Ch ;los obstaculos son de 12x12
            obstacX dw 22;22
            obstacY dw 32

            obstacX2 dw 102;62
            obstacY2 dw 32

            obstacX3 dw 262;102
            obstacY3 dw 32

            obstacX4 dw 142;142
            obstacY4 dw 32

            obstacX5 dw 182;182
            obstacY5 dw 32

            obstacX6 dw 62;222
            obstacY6 dw 32

            obstacX7 dw 222;262
            obstacY7 dw 32

            swobs1 db 0
            swobs2 db 0
            swobs3 db 0
            swobs4 db 0
            swobs5 db 0
            swobs6 db 0
            swobs7 db 0      

            indexobstac db 0     
    

    ;extras
        salto db 00h, 0Ah, '$'
        tab db 09, '$'
        msgf db ' ! ', '$' ;fin :3
        msgf2 db ' ? ', '$'; fin :c
        msg24 db 09, 59, 00h, 0Ah, '$'  ;  ;
        msg23 db 09, '-', 00h, 0Ah, '$'
        naux db 0
        msg51 db 09,'EL JUEGO HA TERMINADO :C', 00h, 0Ah, '$'
        msg52 db 09,'Tus puntos son: ', 00h, 0Ah, '$'
        msg53 db 09,'0', 00h, 0Ah, '$'


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
        print msg35

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
        print msg36

        print msg4

        ;Metiendo cosas al file
        openfile gameInit, handlerInit

        ; aca recibo el nombre
        getlinea nnombre

        ; leyendo
        readfile handlerInit, userInit, sizeof userInit
        ; todo está en userinit

        yausuario nnombre, userInit

        print salto
        print msg5

        ; aca recibo la contraseña
        getnumeros ncontrasenia

        print salto
        print nnombre
        print ncontrasenia


        ;Metiendo cosas al file
        ;openfile gameInit, handlerInit

        ; user - contra ;
        ;meterafile handlerInit, 5, msg26
        meterafile handlerInit, 7, nnombre
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
        je Menu1

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
        resetniveles
        insertLevels fileEntrada


        ;cerrando
        closefile handlerEntrada
        print salto


        jmp Menu4
    InicioJuego:

        clearscreenvideo
        resetTodo
        mov swm1, 1
        ;mov swm6, 1
        mov swobs1, 1


        verTiempo: 
            mov ah, 2ch ;get system time 
            int 21h
            ;CH = hora, CL = min, DH = sec, DL = milisec
            cmp dl, timeAux
            je verTiempo

            mov timeAux, dl
            ;clearscreenvideo
            pintarNegro
            clearText

            bajarMonedas
            bajarObstaculos
            
            iniciarJuego
            moverCarrito

            ;vernivelesRapido
            colisionesGeneral
            tiempoMonedas
            tiempoObstac
            checarTiempo  

            jmp verTiempo
        
        mov ax,3h
	    int 10h     ;salgo modo video


        jmp Menu4
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

        clearscreeennormal

        openfile pointsInit, handlerPoints
        ;leyendo
        readfile handlerPoints, filePoints, sizeof filePoints
        ;todo está en filepoints

        ;acá es que leo los puntos y los displayeo
        meteraTops filePoints        

        closefile handlerPoints

        getch
        ;si es barra espaciadora se va a las graficas
        cmp al, 32
        je graficas
 
        jmp Menu5
    Graficas:
        ;holi
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
