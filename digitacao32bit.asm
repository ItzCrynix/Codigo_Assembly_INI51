.MODEL small
.STACK 100h
.DATA
    pergunta DB 'Digite o numero: $'
    numeroMenor DW 0
    numeroMaior DW 0
    maxCaracter DW 10

.CODE
    mov ax, @data
    mov ds, ax
    
    mov dx, offset pergunta
    mov ah, 9
    int 21h

    mov cx, 0

    digitacao:
        mov ah, 1
        int 21h

        mov dx, 0

        cmp al, 13          ; comparo o char com ENTER
        je prepararPilhaMenor

        inc cx
        cmp cx, maxCaracter ; chegou no limite
        jge prepararPilhaMenor

        sub al, 48          ; transforma o char do numero no numero em si
        mov bx, 0           ; zera o bx
        mov bl, al          ; salva o digito no bl para uso

        ; Em um comando de MUL, o resultado da multiplicaçao de 2 numeros de 16 bits resulta em um de 32, a parte maior vai para o dx e a menor pro ax

        mov ax, numeroMenor ; bota o numero digitado menor
        mov dx, 10
        mul dx              ; abre espaço pra botar o novo digito
        add al, bl          ; adiciona o numero digitado no numero menor
        mov numeroMenor, ax ; guarda o valor da nova parte menor
        
        cmp dx, 0 ; se dessa multiplicação teve um produto com mais de 5 digitos, o dx não vai estar vazio
        jne adicionarDigitoParteMaior

        jmp digitacao

    adicionarDigitoParteMaior:
        mov ax, numeroMaior ; pega o numero da parte maior
        mov bx, dx ; guarda o valor no bx para nao perde-lo na multiplicaçao

        mov dx, 10
        mul dx ; multiplica ax por 10 para podermos adicionar o novo digito

        add ax, bx ; adiciona o digito
        mov numeroMaior, ax ; guarda o valor da nova parte maior

        jmp digitacao

    prepararPilhaMenor: ; na pilha, a parte menor deve estar por ultimo para aparecer na frente, por isso eh montada primeiro
        mov ax, numeroMenor ; pega o numero da parte menor
        mov cx, maxCaracter ; para o loop

        salvarMaior:
            dec cx
            cmp cx, 5 ; deu o limite de digitos da parte maior
            je prepararPilhaMaior

            mov bx, 10 ; divide ax por 10
            div bx ; o resto da divisão (no caso o digito) vai para o dx

            push dx ; adiciona o numero na pilha
            mov dx, 0

            jmp salvarMaior

    prepararPilhaMaior:
        mov ax, numeroMaior
        
        salvarMenor:
            dec cx
            cmp cx, 0 ; final do numero
            je escrever

            mov bx, 10 ; divide ax por 10
            div bx ; o resto da divisão (no caso o digito) vai para o dx

            push dx ; adiciona o numero na pilha
            mov dx, 0

            jmp salvarMenor

    escrever:
        mov dx, 10
        mov ah, 02h
        int 21h

        mov cx, maxCaracter

        loopEscrever:
            dec cx
            cmp cx, 0
            je finaliza

            pop dx
            add dx, 48

            mov ah, 02h
            int 21h

            jmp loopEscrever

    finaliza:
    mov ah, 4Ch
    int 21h
END