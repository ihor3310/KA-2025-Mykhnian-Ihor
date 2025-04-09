.model tiny
.stack 100h
.code
org 100h
start:
    lea si, num        
    lea di, newNum      

    mov dx, offset num  
    mov ah, 09h         
    int 21h

shift_right:
    mov al, [si]          
    mov dl, al            
    mov ah, 02h           
    int 21h           

    inc si                
    mov al, [si]          
    mov dl, al             
    mov ah, 02h          
    int 21h            

    mov ah, 4Ch        
    int 21h

num db '413$', 0          
newNum db 10 dup(0)        
end start
