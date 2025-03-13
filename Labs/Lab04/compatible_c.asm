.model small
.stack 100h
.data 
    f_num dw 6   
    s_num dw -4   

.code
main proc  
    mov ax, @data   
    mov ds, ax      

    mov ax, s_num    
    push ax          
    mov ax, f_num   
    push ax          

    call multiply    

    add sp, 4       

    and dx, dx       
    jns end_prog   
    neg ax            

end_prog:
    mov ah, 4Ch      
    int 21h

main endp

multiply proc
    push bp            
    mov bp, sp         

    mov ax, [bp+4]      
    mov bx, [bp+6]     
    imul bx            

    pop bp             
    ret            
multiply endp
end main
