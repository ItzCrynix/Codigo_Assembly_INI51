.MODEL small
.STACK 100h
.DATA
    pergunta DB 'Digite o numero: $'
    numeroMenor DW 0
    numeroMaior DW 0
    qtdCaracter DW 0

.CODE
    mov ax, @data
    mov ds, ax
    
    mov dx, offset pergunta
    mov ah, 9
    int 21h

    mov cx, 0 ; inicializa um contador de caracteres

    digitacao:
        mov ah, 1
        int 21h

        cmp al, 13      ; comparo o char com ENTER
        je salvarMaior

        inc cx
        cmp cx, 5       ; ve se chegou na metade dos digitos (passou 16 bits)
        jg digitacaoMaior ; se sim ele vai colocar na parte maior

        sub al, 48      ; transforma o char do numero no numero em si
        mov bx, 0
        mov bl, al      ; salva o digito no dl para uso

        mov ax, numeroMenor  ; bota o numero digitado menor
        mov dx, 10
        mul dx          ; abre espaço pra botar o novo digito
        add ax, bx      ; adiciona o numero digitado no numero menor
        mov numeroMenor, ax

        inc qtdCaracter

        jmp digitacao

        digitacaoMaior:
            inc qtdCaracter
            cmp cx, 10 ; chegou no limite
            je salvarMaior

            sub al, 48      ; transforma o char do numero no numero em si
            mov bx, 0
            mov bl, al

            mov ax, numeroMaior ; pega a parte maior do numero
            mov dx, 10
            mul dx ; abre espaço pra botar o novo digito
            add ax, bx ; adiciona o numero digitado no numero maior
            mov numeroMaior, ax

            

            jmp digitacao

    salvarMaior:
        mov ax, numeroMaior
        
        guardarMaior:
            cmp ax, 0 ; guardou tudo?
            je salvarMenor

            mov bx, 10
            div bx ; divide ax por 10

            push dx ;pega o resto da divisão (no caso o ultimo digito) e joga pra pilha
            mov dx, 0
            jmp guardarMaior
    
    salvarMenor:
        mov ax, numeroMenor

        guardarMenor:
            cmp ax, 0 ; guardou tudo?
            je escrever

            mov bx, 10
            div bx ; divide ax por 10

            push dx ;pega o resto da divisão (no caso o ultimo digito) e joga pra pilha
            mov dx, 0
            jmp guardarMenor

    escrever:
        mov dx, 10 ; da um newline
        mov ah, 02h
        int 21h

        mov cx, qtdCaracter
        escreveMaior:
            cmp cx, 5
            je escreveMenor
            dec cx

            pop dx
            add dx, 48

            mov ah, 02h
            int 21h

            jmp escreveMaior
        
        escreveMenor:
            cmp cx, 0
            je finaliza
            dec cx

            pop dx
            add dx, 48

            mov ah, 02h
            int 21h

            jmp escreveMenor

    finaliza:
    mov ah, 4Ch
    int 21h
END
