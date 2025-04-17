.model small
.stack 100h
.data
    newline db 10 dup(0)
    buffer db 255 dup(0), '$'
    save_id dw 0
    sum_low dw 0
    sum_high dw 0
    is_negative db 0
    result db 12 dup(0), '$'
    numbers dw 100 dup(0)
    count dw 0
    num_buffer db 12 dup(0), '$'
    num_count dw 0
    average_low dw 0
    average_high dw 0
.code
main proc
    mov ax, @data
    mov ds, ax
    xor ax, ax
    mov word ptr [sum_low], ax
    mov word ptr [sum_high], ax
    mov word ptr [count], ax
    mov word ptr [num_count], ax
    mov bx, 80h
    mov cl, byte ptr es:[bx]
    or cx, cx
    jnz cont_main
    jmp exit
cont_main:
    xor si, si
    inc bx
    mov al, ' '
skip:
    cmp byte ptr es:[bx], al
    jne copy
    inc bx
    loop skip
copy:
    or cx, cx
    je open
    mov dl, byte ptr es:[bx]
    mov newline[si], dl
    inc si
    inc bx
    loop copy
open:
    mov byte ptr [newline+si], 0
    mov ax, 3D00h
    lea dx, newline
    int 21h
    jc near_jump
    jmp skip_jump
near_jump:
    jmp exit
skip_jump:
    mov save_id, ax
read:
    mov ah, 3Fh
    mov bx, save_id
    mov cx, 254
    lea dx, buffer
    int 21h
    or ax, ax
    jz end_r
    mov di, ax
    mov byte ptr [buffer+di], '$'
    jmp read
end_r:
    lea si, buffer
extract_numbers:
    call skip_spaces
    mov al, [si]
    cmp al, '$'
    je sort_numbers
    cmp al, 0Dh
    je sort_numbers
    cmp al, 0Ah
    je sort_numbers
    push si
    call convert_number
    pop si
    mov di, word ptr [count]
    shl di, 1
    mov numbers[di], bx
    inc word ptr [count]
    inc word ptr [num_count]
    mov ax, bx
    cwd
    add word ptr [sum_low], ax
    adc word ptr [sum_high], dx
find_next:
    mov al, [si]
    cmp al, '0'
    jb found_next
    cmp al, '9'
    ja found_next
    inc si
    jmp find_next
found_next:
    jmp extract_numbers
sort_numbers:
    cmp word ptr [count], 0
    jne process_numbers
    jmp display_results
process_numbers:
    call bubble_sort
    call display_numbers
display_results:
    call average
    call display_average
    mov ax, num_count     
    xor dx, dx          
    mov cx, 2
    div cx           

    mov bx, 10
    lea di, num_buffer+11
    mov byte ptr [di], '$'
    dec di

conv_half_loop:
    xor dx, dx
    div bx
    add dl, '0'
    mov [di], dl
    dec di
    test ax, ax
    jnz conv_half_loop
    inc di

    mov ah, 09h
    mov dx, di
    int 21h
    jmp exit
exit:
    mov ah, 3Eh
    mov bx, save_id
    int 21h
    mov ah, 4Ch
    int 21h
main endp

skip_spaces proc
    mov al, ' '
skipSP_loop:
    cmp [si], al
    jne skipSP_d
    inc si
    jmp skipSP_loop
skipSP_d:
    ret
skip_spaces endp

convert_number proc
    xor bx, bx
    xor dx, dx
    xor cx, cx
    cmp byte ptr [si], '-'
    jne positive_number
    mov cl, 1
    inc si
positive_number:
parse_number:
    mov al, [si]
    cmp al, '0'
    jb end_convert
    cmp al, '9'
    ja end_convert
    mov ax, bx
    mov bx, 10
    mul bx
    mov bx, ax
    or dx, dx
    jnz handle_overflow
    mov al, [si]
    sub al, '0'
    xor ah, ah
    add bx, ax
    jc handle_overflow
    inc si
    jmp parse_number
handle_overflow:
    cmp cl, 1
    je negative_limit
    mov bx, 32767
    jmp end_convert
negative_limit:
    mov bx, 32768
end_convert:
    cmp cl, 1
    jne finish_convert
    neg bx
finish_convert:
    ret
convert_number endp

bubble_sort proc
    push ax
    push bx
    push cx
    push si
    mov cx, word ptr [count]
    dec cx
    jz sort_exit
outerLoop:
    push cx
    lea si, numbers
innerLoop:
    mov ax, [si]
    cmp ax, [si+2]
    jle nextiStep
    xchg ax, [si+2]
    mov [si], ax
nextiStep:
    add si, 2
    loop innerLoop
    pop cx
    loop outerLoop
sort_exit:
    pop si
    pop cx
    pop bx
    pop ax
    ret
bubble_sort endp

display_numbers proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    xor si, si
    mov cx, word ptr [count]
display_loop:
    mov ax, numbers[si]
    test ax, 8000h
    jz pos_number
    mov dl, '-'
    mov ah, 02h
    int 21h
    neg ax
pos_number:
    mov bx, 10
    mov di, offset num_buffer
    mov byte ptr [di], '$'
    dec di
digit_loop:
    xor dx, dx
    div bx
    add dl, '0'
    dec di
    mov [di], dl
    test ax, ax
    jnz digit_loop
    mov ah, 09h
    mov dx, di
    int 21h
    dec cx
    jz no_space
    mov dl, ' '
    mov ah, 02h
    int 21h
no_space:
    add si, 2
    or cx, cx
    jnz display_loop
    mov dl, 13
    mov ah, 02h
    int 21h
    mov dl, 10
    int 21h
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
display_numbers endp

average proc
    push ax
    push bx
    push cx
    push dx
    cmp word ptr [num_count], 0
    jne dvsn
    xor ax, ax
    mov word ptr [average_low], ax
    mov word ptr [average_high], ax
    jmp avg_done
dvsn:
    mov ax, word ptr [sum_low]
    mov dx, word ptr [sum_high]
    div word ptr [num_count]
    mov word ptr [average_low], ax
    mov word ptr [average_high], dx
avg_done:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
average endp

display_average proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    mov ax, word ptr [average_high]
    and ax, 8000h
    mov byte ptr [is_negative], 0
    jz pos_avg
    mov byte ptr [is_negative], 1
    mov ax, word ptr [average_low]
    mov dx, word ptr [average_high]
    neg dx
    neg ax
    sbb dx, 0
    mov word ptr [average_low], ax
    mov word ptr [average_high], dx
    mov dl, '-'
    mov ah, 02h
    int 21h
pos_avg:
    mov di, offset num_buffer
    mov byte ptr [di], '$'
    dec di
    mov ax, word ptr [average_low]
    mov dx, word ptr [average_high]
    or ax, dx
    jnz convert_avg
    dec di
    mov byte ptr [di], '0'
    jmp show_avg
convert_avg:
    mov ax, word ptr [average_high]
    xor dx, dx
    mov bx, 10
    div bx
    mov word ptr [average_high], ax
    mov ax, word ptr [average_low]
    div bx
    mov word ptr [average_low], ax
    add dl, '0'
    dec di
    mov [di], dl
    mov ax, word ptr [average_high]
    or ax, word ptr [average_low]
    jnz convert_avg
show_avg:
    mov ah, 09h
    mov dx, di
    int 21h
    mov dl, 13
    mov ah, 02h
    int 21h
    mov dl, 10
    int 21h
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
display_average endp
end main
