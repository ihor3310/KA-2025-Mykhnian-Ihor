.model small
.stack 100h

.code
main PROC
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx

    mov ax, 100
    mov bx, 50
    add bx, ax

increment_cx:
    inc cx
    cmp cx, 40
    jnz increment_cx

    sub bx, cx

    mov ax, 4c00h
    int 21h

main ENDP
end main
