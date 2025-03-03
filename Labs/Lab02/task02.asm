.model small
.stack 100h
.data
    msg db '9', ' ', '$'
.code
main PROC
    mov ax, SEG @data
    mov ds, ax
    mov dx, offset msg
    mov ah, 9
    mov di, offset msg
    mov cl, [di]

print_loop:
    int 21h
    dec cx
    mov [di], cl
    cmp cx, 2fh
    jne print_loop


    mov ax, 4Ch
    int 21h

main ENDP
end main
