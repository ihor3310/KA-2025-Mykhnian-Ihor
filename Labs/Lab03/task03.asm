.model small
.stack 100h
.data
    a dw 0FFFFh       
    b dw 8000h         
.code 
main proc
    mov ax, @data      
    mov ds, ax

    mov ax, [a]        
    mov cx, [b]        
    and ax, cx         
    cmp ax, cx         
    jne set_zero       

    mov word ptr [a], 1  
    jmp finish

set_zero:
    mov word ptr [a], 0  

finish:
    mov ah, 4Ch         
    int 21h
main endp
end main
