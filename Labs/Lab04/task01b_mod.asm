.model small
.stack 100h
.data
    array dw 56 dup(0)
.code
calc proc 
    mov ax, 2
    mul bx
    mov cx, dx
    add cx, 3
    mul cx
    ret
calc endp

write_ax proc 
    push ax
    push bx
    push dx
    mov cx, dx
    mov ax, 8
    mul cx
    add ax, bx
    shl ax, 1
    lea di, array
    add di, ax
    pop dx
    pop bx
    pop ax
    mov [di], ax
    ret
write_ax endp

main proc
    mov ax, @data
    mov ds, ax
    lea di, array
    xor dx, dx
    mov cx, 7
    mov bp, 56

row_loop:
    push dx
    mov bx, 0
    mov si, 8

inner_loop:
    call calc
    call write_ax
    inc bx
    dec bp
    cmp bp, 0
    je end_prog
    loop inner_loop

    pop dx
    inc dx
    loop row_loop

end_prog:
    mov ax, 4Ch
    int 21h
main endp
end main
