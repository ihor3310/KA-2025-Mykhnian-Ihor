.model small
.stack 100h
.data
a dw -2
b db -2
.code
main    proc
    mov ax, @data  
    mov ds, ax
    mov ax, a
    mov bl, b
    cbw      
    add al, bl 

    mov ah, 4Ch
    int 21h 
main    endp
end main
