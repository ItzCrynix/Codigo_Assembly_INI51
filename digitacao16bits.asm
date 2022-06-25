.MODEL small
.STACK 100h
.DATA
    pergunta            DB  'Digite um numero de 16 bits: $'
    foraDoLimite        DB  'Saiu do limite de 16 bits, ultimo numero registrado: $'
    numero              DW  24
    quantosCaracteres   DW  2
    estaNegativo        DB  0

.CODE
                mov ax,@data
                mov ds,ax
                jmp salvar

    salvar:     cmp     estaNegativo, 1 ; verifica se o número é negativo
                jne     prepararEscrita ; se não for, avança pra começar a escrever

                neg     numero ; se for, salva ele com seu valor negativo e avança pra começar a escrever
                jmp     prepararEscrita

    prepararEscrita:    mov ax, numero ; salva o número em ax e limpa cx e dx
                        mov cx, 0
                        mov dx, 0

                        cmp estaNegativo, 1 ; verifica se é negativo
                        je  escreverNegativo ; se for, avança pra escreverNegativo
                        jne montarPilhaDeEscrita ; se não for, avança pra escrever

    escreverNegativo:   mov dx, 45 ; printa um -
                        mov ah,02h
                        int 21h

                        neg numero ; salva o número como seu negativo, pegando assim seu valor positivo pra escrever
                        mov ax, numero ; salva o número em ax e limpa cx e dx
                        mov cx, 0
                        mov dx, 0

                        jmp montarPilhaDeEscrita

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
        
        terminar:   mov ah,4Ch ; selecionei acao de terminar o programa
                int 21h    ; executa a acao selecionada acima
END