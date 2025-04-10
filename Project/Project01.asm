.model small
.stack 100h

.data
    newline db 0, '$'

.code
main proc
    mov ax, @data
    mov ds, ax
    
    mov bx, 80h
    xor cx, cx             
    mov cl, byte ptr es:[bx]
    
    cmp cx, 0
    je exit
    
    inc bx
output_loop:
    cmp cx, 0
    je output_done
    
    mov dl, byte ptr es:[bx]
    mov ah, 02h
    int 21h
    
    inc bx
    dec cx
    jmp output_loop
    
output_done:
    lea dx, newline
    mov ah, 09h
    int 21h
    
exit:
    mov ah, 4ch
    int 21h
main endp
end main
