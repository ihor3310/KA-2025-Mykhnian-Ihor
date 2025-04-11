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
.code
main proc
	mov ax, @data
	mov ds, ax
	mov word ptr [sum_low], 0
	mov word ptr [sum_high], 0
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
proc_numbers:
	mov al, [si]
	cmp al, '$'
	jne continue_check1
	jmp process_result
continue_check1:
	cmp al, 0Dh
	jne continue_check2
	jmp process_result
continue_check2:
	cmp al, 0Ah
	jne continue_check3
	jmp process_result
continue_check3:
	cmp al, ' '
	jne start_number
	inc si
	jmp proc_numbers
start_number:
	call convert_number
	call add_to_sum
	jmp proc_numbers
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
	mov byte ptr [si], '$'
	mov ah, 9
	lea dx, result
	int 21h
	jmp exit
exit:
	mov ah, 3Eh
	mov bx, save_id
	int 21h
	mov ah, 4Ch
	int 21h
main endp
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
add_to_sum proc
	mov ax, bx
	cwd
	add word ptr [sum_low], ax
	adc word ptr [sum_high], dx
	inc si
	ret
add_to_sum endp
end main
