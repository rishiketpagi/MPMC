section .data
msg1 db 'Enter 5 elements in array: '
msg1len equ $-msg1
msg2 db 'Enter number to be searched: ' 
msg2len equ $-msg2
msg3 db 'Number found at index: ' 
msg3len equ $-msg3
msg4 db 'Number not found' 
msg4len equ $-msg4
newline db '',10 
n1 equ $-newline
msg5 db ': not found'
msg5len equ $-msg5
msg6 db 'index '
msg6len equ $-msg6
msg_found db ': found'
msg_found_len equ $-msg_found

%macro write 2
    mov eax, 4          
    mov ebx, 1         
    mov ecx, %1          
    mov edx, %2          
    int 80h             
%endmacro
 
%macro read 2
    mov eax, 3        
    mov ebx, 0        
    mov ecx, %1         
    mov edx, %2       
    int 80h              
%endmacro

section .bss
arr resb 5
searche resb 10
i resb 1
index resb 2
element resb 2
num resb 10
temp resb 5

section .text
global _start

input:
    mov byte[i], 0
    mov esi, arr     
    l_input:
        read element, 2   
        mov ebx, [element]
        sub ebx, '0'      
        mov [esi], ebx   
        inc esi         
        inc byte[i]
        mov al, [i]    
        cmp al, 5    
        jl l_input      
    mov byte[i], 0
    mov esi, arr
ret

linear_search:
    mov ecx, 5         
    mov esi, 0         
    
search_loop:
   
    push ecx
    
 
    write msg6, msg6len
    add esi, '0'              
    mov [index], esi
    write index, 1
    sub esi, '0' 
    
  
    movzx edi, byte[arr+esi]
    mov [temp], edi           
    mov al, [temp]          
    mov bl, [searche]
    sub bl, '0'
    cmp al, bl
    

    jne near element_not_found
    
 
    write msg_found, msg_found_len
    write newline, n1
    
   
    write msg3, msg3len
    add esi, '0'              
    mov [index], esi
    write index, 1
    write newline, n1
    
  
    mov eax, 1
    mov ebx, 0
    int 80h
    
element_not_found:
   
    write msg5, msg5len
    write newline, n1
    
   
    pop ecx
    inc esi
    dec ecx
    jnz near search_loop
    
    ret

_start:
    write msg1, msg1len           
    call input                 
    write msg2, msg2len       
    read searche, 10                
    call linear_search            
    write msg4, msg4len            
    write newline, n1
    mov eax, 1                
    mov ebx, 0
    int 80h