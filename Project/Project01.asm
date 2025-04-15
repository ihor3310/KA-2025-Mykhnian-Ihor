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
	temp db 12 dup(0)
	numbers dw 100 dup(0)
	count dw 0
	num_buffer db 12 dup(0), '$'

.code
main proc
	mov ax, @data
	mov ds, ax
	mov word ptr [sum_low], 0
	mov word ptr [sum_high], 0
	mov word ptr [count], 0
	mov bx, 80h
	mov cl, byte ptr es:[bx]
	cmp cx, 0
	jne cont_main
	jmp exit
cont_main:
	xor si, si
	inc bx
skip:
	cmp byte ptr es:[bx], ' '
	jne copy
	inc bx
	loop skip
copy:
	cmp cx, 0
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
	jnc cont_open
	jmp exit
cont_open:
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
	je display_sum
	call bubble_sort
	call display_numbers
display_sum:
	mov ah, 9
	lea dx, result
	int 21h
process_result:
	mov ax, word ptr [sum_high]
	and ax, 8000h
	mov byte ptr [is_negative], 0
	jz positive_result
	mov byte ptr [is_negative], 1
	mov ax, word ptr [sum_low]
	mov dx, word ptr [sum_high]
	not ax
	not dx
	add ax, 1
	adc dx, 0
	mov word ptr [sum_low], ax
	mov word ptr [sum_high], dx
positive_result:
	xor di, di
convert_loop:
	mov ax, word ptr [sum_high]
	xor dx, dx
	mov bx, 10
	div bx
	mov word ptr [sum_high], ax
	mov ax, word ptr [sum_low]
	div bx
	mov word ptr [sum_low], ax
	add dl, '0'
	mov byte ptr [temp+di], dl
	inc di
	mov ax, word ptr [sum_high]
	or ax, word ptr [sum_low]
	jnz convert_loop
	lea si, result
	cmp byte ptr [is_negative], 0
	jz skip_minus
	mov byte ptr [si], '-'
	inc si
skip_minus:
	dec di
copy_digits:
	cmp di, 0
	jl finish_output
	mov al, byte ptr [temp+di]
	mov byte ptr [si], al
	inc si
	dec di
	jmp copy_digits
finish_output:
	cmp si, offset result
	jne output_result
	mov byte ptr [result], '0'
	inc si
output_result:
	;mov byte ptr [si], '$'
	;mov ah, 9
	;lea dx, result
	;int 21h
	jmp exit
exit:
	mov ah, 3Eh
	mov bx, save_id
	int 21h
	mov ah, 4Ch
	int 21h
main endp

skip_spaces proc
skip_space_loop:
	mov al, [si]
	cmp al, ' '
	jne skip_space_done
	inc si
	jmp skip_space_loop
skip_space_done:
	ret
skip_spaces endp

convert_number proc
	xor bx, bx
	xor dx, dx
	mov cl, 0
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
	push ax
	mov ax, bx
	mov bx, 10
	mul bx
	mov bx, ax
	or dx, dx
	jnz handle_overflow
	pop ax
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
    not bx
	add bx, 1
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
	mov bx, 10
	test ax, 8000h
	jz pos_number
	mov dl, '-'
	mov ah, 02h
	int 21h
	neg ax
pos_number:
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
	cmp cx, 0
	jnz display_loop
	mov dl, 13
	mov ah, 02h
	int 21h
	mov dl, 10
	mov ah, 02h
	int 21h
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret
display_numbers endp


end main
