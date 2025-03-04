.model small
.stack 100h
.data
.code
main proc
    xor dx, dx  
   
    mov ah, 4Ch    
    int 21h
main endp 
end main
