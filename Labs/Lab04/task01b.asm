.model small
.stack 100h
.data
    array dw 7*8 dup(0)  
.code
main:
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
    mov ax, 2            
    mul bx              
    mov cx, dx          
    add cx, 3           
    mul cx             
    mov [di], ax         
    add di, 2           
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
end main
