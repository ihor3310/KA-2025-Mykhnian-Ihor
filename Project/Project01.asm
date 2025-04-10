.model small
.stack 100h
.data
  newline db 10 dup(0)
  buffer db 255 dup(0), '$'
  save_id dw 0
  tog_id db 0, 10, '$'
.code
main proc
  mov ax, @data
  mov ds, ax
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
  mov ah, 9
  lea dx, buffer
  int 21h
  jmp read
end_r:
  lea si, buffer
proc_numbers:
  mov al, [si]
  cmp al, '$'
  jne continue_check1
  jmp exit_from_process
continue_check1:
  cmp al, 0Dh
  jne continue_check2
  jmp exit_from_process
continue_check2:
  cmp al, 0Ah
  jne continue_check3
  jmp exit_from_process
continue_check3:
  cmp al, ' '
  jne start_number
  inc si
  jmp proc_numbers
start_number:
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
  jb end_of_number
  cmp al, '9'
  ja end_of_number
  push ax
  mov ax, bx
  mov bx, 10
  mul bx
  mov bx, ax
  or dx, dx
  jnz overflow_check
  pop ax
  sub al, '0'
  xor ah, ah
  add bx, ax
  jc overflow_check
  inc si
  jmp parse_number
overflow_check:
  cmp cl, 1
  je limit_negative
  mov bx, 32767
  jmp end_of_number
limit_negative:
  mov bx, 32768
end_of_number:
  cmp cl, 1
  jne print_binary
  not bx
  add bx, 1
print_binary:
  mov cx, 16
print_bin:
  shl bx, 1
  jc print_1
  mov dl, '0'
  jmp show_bit
print_1:
  mov dl, '1'
show_bit:
  mov ah, 02h
  int 21h
  loop print_bin
  jmp proc_numbers
skip_non_digit:
  inc si
  jmp proc_numbers
exit_from_process:
  jmp exit
exit:
  mov ah, 3Eh
  mov bx, save_id
  int 21h
  mov ah, 4Ch
  int 21h
main endp
end main
