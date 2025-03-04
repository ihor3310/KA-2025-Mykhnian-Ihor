.model small
.stack 100h
.data
    msg db '123', 0Dh, 0Ah, '$' 
    num dw 123                 
.code
main PROC
    mov ax, @data
    mov ds, ax                

print_loop:
    call num_to_str         
    mov dx, offset msg       
    mov ah, 9                    
    int 21h                   

    dec word ptr num              
    cmp word ptr num, 0            
    jge print_loop               

    mov ax, 4c00h                 
    int 21h

main ENDP

num_to_str PROC
    mov ax, num                   
    mov bx, 10                     

    mov di, offset msg             
    add di, 2                     

    mov cx, 3                      
conv_loop:
    mov dx, 0                      
    div bx                       
    add dl, '0'                     
    mov [di], dl                   
    dec di                          
    loop conv_loop                

    ret
num_to_str ENDP

end main
