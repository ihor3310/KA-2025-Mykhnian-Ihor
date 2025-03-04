.model small
.stack 100h
.data

.code
main proc

;xor allows to change values ​​without using additional registers 
;or memory by calculating the difference between registers.
;as the first step, i calculate the difference between ax and dx, 
;then alternately exchange their values ​​through successive xor operations.

    mov ax, 100
    mov dx, 200

    xor ax, dx      
    xor dx, ax    
    xor ax, dx   


    mov ah, 4Ch    
    int 21h
main endp
end main
