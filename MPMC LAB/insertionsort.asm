section .data
	msg db "Enter number of elements: "     ; Prompt message for input
	msglen equ $-msg                        ; Length of prompt message
	msg2 db "Enter the elements in the array: " ; Prompt message for array elements
	msg2len equ $-msg2                      ; Length of array elements prompt
	msg3 db "The sorted array : "         ; Prompt message for sorted array
	msg3len equ $-msg3                      ; Length of sorted array prompt
	msg4 db "Pass "                          ; Prompt message for pass number during sorting
	msg4len equ $-msg4                      ; Length of pass prompt
	msg5 db " : "                            ; Separator between pass number and array elements
	msg5len equ $-msg5                      ; Length of separator
	newline db 10                            ; Newline character
	space db ' '	                           ; Space character

%macro write 2                              ; Macro for writing to stdout
	mov eax,4
	mov ebx,1
	mov ecx,%1
	mov edx,%2
	int 80h
%endmacro
	
%macro read 2                               ; Macro for reading from stdin
	mov eax,3
	mov ebx,2
	mov ecx,%1
	mov edx,%2
	int 80h
	mov eax,3
	mov ebx,2
	mov ecx,trash
	mov edx,1
	int 80h
%endmacro
	
input:
	write msg2,msg2len                    ; Display prompt for array elements
	mov [i],dword '0'                     ; Initialize loop counter
loop1:
	mov esi,[i]                           ; Move loop counter to esi
	cmp esi,[n]                           ; Compare loop counter with number of elements
	jge end                               ; If loop counter >= number of elements, end loop
	sub esi,'0'                           ; Convert loop counter to character
	add esi,arr                           ; Calculate array index
	read esi,1                            ; Read one character from stdin
	inc dword[i]                         ; Increment loop counter
	jmp loop1	                          ; Repeat loop
end:
	ret                                   ; Return

display:
	mov [i],dword '0'                    ; Initialize loop counter
loop2:
	mov esi,[i]                          ; Move loop counter to esi
	cmp esi,[n]                          ; Compare loop counter with number of elements
	jge end2                             ; If loop counter >= number of elements, end loop
	sub esi,'0'                          ; Convert loop counter to character
	add esi,arr                          ; Calculate array index
	write esi,1                          ; Display array element
	write space,1                        ; Display space
	inc dword[i]                        ; Increment loop counter
	jmp loop2	                         ; Repeat loop
end2:
	write newline,1	                     ; Display newline character
	ret                                  ; Return

insertion_sort:
	mov eax,1 		                     ; Initialize loop counter (outer loop)
	mov bl,[n]		                     ; Load number of elements into bl
	sub bl,'0'		                     ; Convert number of elements to integer
loop3:
	cmp al,bl		                     ; Compare loop counter with number of elements
	jge end3			                 ; If loop counter >= number of elements, end loop
	pushad		                         ; Push registers to stack
	write msg4,msg4len		             ; Display "Pass" message
	write j,9		                     ; Display pass number
	write msg5,msg5len		             ; Display separator
	call display		                 ; Display array
	popad		                         ; Pop registers from stack
	mov ecx,0		                     ; Initialize inner loop counter
	mov cl,al		                     ; Move outer loop counter to cl
	sub cl,1		                     ; Decrement inner loop counter
	mov dl,[arr+eax]		             ; Load current element into dl
loop4:
	cmp cl,0		                     ; Compare inner loop counter with 0
	jl update			                 ; If inner loop counter < 0, update array
	cmp dl,[arr+ecx]		             ; Compare current element with previous element
	jge update			                 ; If current element >= previous element, update array
	mov dh,[arr+ecx]		             ; Load previous element into dh
	mov [arr+ecx+1],dh		             ; Move previous element one position ahead
	dec ecx			                     ; Decrement inner loop counter
	jmp loop4			                 ; Repeat inner loop
update:
	mov [arr+ecx+1],dl		             ; Move current element to correct position
	inc al			                     ; Increment outer loop counter
	inc byte[j]		                     ; Increment pass number
	jmp loop3			                 ; Repeat outer loop
end3:
	write msg4,msg4len		             ; Display "Pass" message
	write j,9		                     ; Display pass number
	write msg5,msg5len		             ; Display separator
	call display		                 ; Display sorted array
	ret			                         ; Return

section .bss
	n resb 4		                     ; Number of elements (4 bytes)
	arr resb 10		                     ; Array to store elements (10 bytes)
	i resb 4			                     ; Loop counter (4 bytes)
	j resb 9			                     ; Pass number (9 bytes)
	trash resb 1	                         ; Buffer to discard unwanted characters

section .text
global _start

_start:
	write msg,msglen		                 ; Display prompt for number of elements
	read n,1		                         ; Read number of elements from stdin
	mov eax,'0'		                     ; Initialize pass number
	mov [j],eax		                     ; Store pass number
	call input		                         ; Call input subroutine to read array elements
	write newline,1		                 ; Display newline character
	call insertion_sort	                 ; Call insertion sort subroutine
	write newline,1		                 ; Display newline character
	write msg3,msg3len		             ; Display prompt for sorted array
	call display		                     ; Display sorted array
	mov eax,1		                         ; Exit syscall
	mov ebx,0		                         ; Exit code
	int 80h			                         ; Execute syscall

