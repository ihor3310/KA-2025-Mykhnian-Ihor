.model small
.stack 100h
.data
.code
main    proc
    mov ax, 100
    mov dx, 200
    mov bx, dx
    mov dx, ax
    mov ax, bx

    mov ah, 4Ch
    int 21h 
main    endp
end main
