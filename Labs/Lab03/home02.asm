.model small
.stack 100h
.data
    a dw 10   
    b dw 90  
    c dw 80    

.code

; if ( (a >= 20 && a <= 50) || (b >= 100 && b < 200) )

main proc
    mov ax, @data
    mov ds, ax

    mov ax, [a]
    cmp ax, 20
    jl check_second_cond 
    cmp ax, 50
    jg check_second_cond

    jmp then_part

check_second_cond:
    mov ax, [b]
    cmp ax, 100
    jl else_part            
    cmp ax, 200
    jge else_part            

    jmp then_part

then_part:
    mov ax, [a]
    cmp ax, [b]
    jge skip_add       

    add word ptr [c], 50

skip_add:
    jmp end_if

else_part:
    mov word ptr [a], -1
    mov word ptr [b], -1

end_if:
    mov ax, 4c00h
    int 21h

main endp
end main
