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

zero_start:
    lea si, array
    mov cx, 20

zero:
    mov [si], 0
    add si, 2
    loop zero

first_fib:
    lea si, array
    mov word ptr [si], 0
    add si, 2
    mov word ptr [si], 1
    add si, 2

    mov cx, 14
    mov bx, 0
    mov dx, 1

fill_fib:
    mov ax, bx
    add ax, dx

    mov [si], ax
    add si, 2
    mov bx, dx
    mov dx, ax 
    loop fill_fib

    mov ax, 4Ch
    int 21h

main endp
end main




