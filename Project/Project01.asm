.model small
.stack 100h
.data
    newline db 10 dup(0)
    buffer db 255 dup(0), '$'
    save_id dw 0
.code
main proc
    mov ax, @data
    mov ds, ax
    mov bx, 80h
    mov cl, byte ptr es:[bx]
    cmp cx, 0
    je exit
    xor si, si
    inc bx
skip:
    cmp byte ptr es:[bx], ' '
    jne copy
    inc bx
    loop skip
copy:
    jcxz open
    mov dl, byte ptr es:[bx]
    mov newline[si], dl
    inc si
    inc bx
    loop copy
open:
    mov byte ptr [newline+si], 0
    mov ax, 3D00h
    lea dx, newline
    int 21h
    jc exit
    mov save_id, ax
read:
    mov ah, 3Fh
    mov bx, save_id
    mov cx, 254
    lea dx, buffer
    int 21h
    or ax, ax
    jz end_r
    mov di, ax
    mov byte ptr [buffer+di], '$'
    mov ah, 9
    lea dx, buffer
    int 21h
    jmp read
end_r:
    mov ah, 3Eh
    mov bx, save_id
    int 21h
exit:
    mov ah, 4Ch
    int 21h
main endp
end main
