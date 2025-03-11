.model small
.stack 100h
.data
    array dw 20 dup(0)

.code
main proc 
    mov ax, @data
    mov ds, ax

    mov bx, 1
    lea si, array 
    mov cx, 20

fill_array:
    mov [si], bx 
    add bx, 3
    add si, 2
    loop fill_array

    mov ax, 4Ch
    int 21h

main endp
end main
