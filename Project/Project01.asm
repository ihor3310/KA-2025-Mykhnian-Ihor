.model small
.stack 100h
.data
.code
start:
    mov ax, @data
    mov ds, ax
    mov ax, 413
    mov bx, ax
    mov cx, 16

print_bits:
    rol bx, 1
    jc swap1
    mov dl, '0'
    jmp done

swap1:
    mov dl, '1'

done:
    mov ah, 02h
    int 21h
    loop print_bits

    mov ah, 4Ch
    int 21h
end start
