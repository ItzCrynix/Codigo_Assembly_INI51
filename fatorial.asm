.MODEL small
.STACK 100h
.DATA
    quantosCaracteres DW 0
    frasefatorial DB 'Fatorial de 16 bits: $'
    frasePassouLimite DB 'Esse numero passou do limite aceito $'
    fraseContinuar DB 'Continuar? [S/N] $'

.CODE
    mov ax, @data
    mov ds, ax

    inicio:

    mov quantosCaracteres, 0
    mov dx, 10 ; da um newline
    mov ah, 02h
    int 21h

    mov dx, offset frasefatorial
    mov ah, 9
    int 21h ; printamos a frase inicial

    mov ah, 1
    int 21h

    cmp al, 13 ; verifica se apertou enter
    je terminar

    sub al, 48 ; transforma o caracter no numero
    mov cx, 0
    mov cl, al ; inicia o cx com o numero do ax para o loop

    cmp cx, 8
    jg passouDoLimite


    mov ax, 1 ; inicia ax para realizar o fatorial
    fatorial:
        mul cx ; multiplica ax pelos numeros do fatorial
        sub cx, 1 ; decrementa cx
        cmp cx, 1 ; Compara cx com o numero para ver se chegou ou não no final
        jne fatorial

    guardar:
            cmp ax, 0 ; guardou tudo?
            je escrever

            inc quantosCaracteres

            mov bx, 10
            div bx ; divide ax por 10

            push dx ;pega o resto da divisão (no caso o ultimo digito) e joga pra pilha
            mov dx, 0
            jmp guardar

    escrever:
        mov dx, 10 ; da um newline
        mov ah, 02h
        int 21h

        mov cx, quantosCaracteres
        escreveLoop:
            cmp cx, 0
            je continuar
            dec cx

            pop dx
            add dx, 48

            mov ah, 02h
            int 21h

            jmp escreveLoop

    passouDoLimite:
        mov dx, 10 ; da um newline
        mov ah, 02h
        int 21h

        mov dx, offset frasePassouLimite
        mov ah, 9
        int 21h

    continuar:
        mov dx, 10 ; da um newline
        mov ah, 02h
        int 21h

        mov dx, offset fraseContinuar
        mov ah, 9
        int 21h

        mov ah, 1 ; espera a resposta se ira voltar do começo
        int 21h

        cmp al, 'S'
        je inicio
        cmp al, 's'
        je inicio

        cmp al, 'N'
        je terminar
        cmp al, 's'
        je terminar


    terminar:
        mov ah, 4Ch
        int 21h
END