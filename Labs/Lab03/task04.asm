.model small
.stack 100h
.data
.code
main proc
    xor dx, dx    ; i used xor, because this operation between a register and itself always = zero.
   
    mov ah, 4Ch    
    int 21h
main endp 
end main
