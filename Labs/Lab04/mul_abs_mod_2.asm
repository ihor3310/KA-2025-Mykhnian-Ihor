.model small
.stack 100h
.data 
    f_num dw 6   
    s_num dw -4   
.code
main proc  
    mov ax, @data   
    mov ds, ax      

    mov ax, f_num   
    push ax          
    mov ax, s_num    
    push ax          

    push ax         
    push bx          
    push dx         

    pop bx          
    pop ax           
    imul bx      

    push ax          
    push dx          

    pop dx          
    pop ax           
    and dx, dx       
    jns end_prog   

    neg ax            

    pop dx         
    pop bx          
    pop ax         

end_prog:
    mov ah, 4Ch      
    int 21h
    
main endp
end main
