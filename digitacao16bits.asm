.MODEL small
.STACK 100h
.DATA
    pergunta            DB  'Digite um numero de 16 bits: $'
    foraDoLimite        DB  'Saiu do limite de 16 bits, ultimo numero registrado: $'
    numero DW 0
    qtdDigito DW 0
    Negativo DB  0

.CODE
    mov ax,@data
    mov ds,ax
    
    digitacao:
        mov ah, 1 ; faz o comando de pegar um char
        int 21h

        cmp al, '-' ; verifica se tem -, ou seja, negativar o numero
        je negativar

        jmp digitacao

    negativar:
        cmp qtdDigito, 0
        jne tiraNegativo

        mov negativo, 1 ; agora o numero é negativo

    tiraNegativo:
        mov negativo, 0
        jmp backspace

    backspace:
    
    terminar:
        mov ah, 4Ch
        int 21h
END