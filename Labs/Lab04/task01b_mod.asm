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
    call calc_value
    call write_value_to_array
    
    add si, 2            
    inc bp               
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

calc_value proc
    mov ax, sp          
    mov bx, bp          
    add bx, 3            
    mov cx, bx           
    mov bx, sp           
    mov dx, 2           
    mul bx               
    mul cx             
    ret
calc_value endp

write_value_to_array proc
    mov [si], ax
    ret
write_value_to_array endp

end_prog:
    mov ax, 4Ch
    int 21h
    
main endp
end main
