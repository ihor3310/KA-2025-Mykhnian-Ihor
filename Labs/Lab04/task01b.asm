.model small
.stack 100h
.data
    array dw 7*8 dup(0)  
.code
main proc 
    mov ax, @data
    mov ds, ax
    lea si, array

    mov ax, 0  
    mov bx, 0
    mov bp, 0
    mov sp, 0

count_column:
    mov di, ax
    mov ax, bp
    mov bx, sp
    mov cx, 3        
    add cx, bx     
    mov dx, 2        
    mul dx           
    mov dx, dx        
    mov cx, cx     
    mul cx          
    inc bp  
    mov [si], di
    add si, 2    
    cmp bp, 7 
    jne count_column
    inc sp
    cmp sp, 8
    jne zero_col
    jmp end_prog

zero_col:
    mov ax, 0
    mov bp, 0
    jmp count_column


end_prog:
    mov ax, 4Ch
    int 21h

main endp
end main
