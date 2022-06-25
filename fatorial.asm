.MODEL small
.STACK 100h
.DATA
    numero DW 8
    quantosCaracteres DW 5
    frasefatorial DB 'Fatorial: $'

.CODE
    mov ax, @data
    mov ds, ax

    mov dx, offset frasefatorial
    mov ah, 9
    int 21h ; printamos a frase inicial

    mov ax, 1
    mov cx, numero ; inicia o cx com o numero do ax para o loop

    fatorial:
        mul cx ; multiplica ax pelos numeros do fatorial
        sub cx, 1 ; decrementa cx
        cmp cx, 1 ; Compara cx com o numero para ver se chegou ou não no final
        jne fatorial

    mov cx, 0
    mov dx, 0

    montarPilhaDeEscrita:
        ;verifica se já leu o número inteiro
        cmp cx, quantosCaracteres
        je escrever
         
        ;remove o último caracter do número
        mov bx, 10
        div bx
         
        ;coloca o número retirado na pilha
        push dx

        ;aumenta a contagem em 1
        inc cx
         
        ;limpa dx e recomeça
        mov dx, 0
        jmp montarPilhaDeEscrita

    escrever:
        ;verifica se escreveu o número inteiro
        cmp cx,0
        je terminar
         
        ;pega o último caracter inserido na pilha
        pop dx
         
        ;adiciona 48 ao número, conseguindo seu caracter
        add dx,48
         
        ;printa o número
        mov ah,02h
        int 21h
         
        ;diminui cx em 1 e avança pro próximo número da pilha
        dec cx
        jmp escrever

    terminar:
        mov ah, 4Ch
        int 21h
END