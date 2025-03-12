.model small
.stack 100h
.data 
    f_num dw 6   
    s_num dw -4   
.code

save_regs proc
    push ax       
    push bx     
    push dx        
    ret
save_regs endp

restore_regs proc
    pop dx         
    pop bx          
    pop ax        
    ret
restore_regs endp

main proc  
    mov ax, @data   
    mov ds, ax      

    mov ax, f_num   
    push ax          
    mov ax, s_num    
    push ax          

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

    call save_regs  
    call restore_regs  

end_prog:
    mov ah, 4Ch      
    int 21h
main endp
end main
