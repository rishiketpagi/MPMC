section .data
	msg db "Enter number of elements: "      ; Prompt for entering number of elements
	msglen equ $-msg                         ; Length of the prompt
	msg2 db "Enter the elements in the array: "  ; Prompt for entering elements
	msg2len equ $-msg2                       ; Length of the prompt
	msg3 db "The sorted array : "          ; Prompt for displaying sorted array
	msg3len equ $-msg3                       ; Length of the prompt
	msg4 db "Pass "                           ; Prompt for displaying pass number
	msg4len equ $-msg4                       ; Length of the prompt
	msg5 db " : "                             ; Separator for pass number and array display
	msg5len equ $-msg5                       ; Length of the separator
	newline db 10                             ; Newline character
	space db ' '                              ; Space character

%macro write 2                               ; Macro for writing to stdout
	mov eax,4
	mov ebx,1
	mov ecx,%1
	mov edx,%2
	int 80h
%endmacro
	
%macro read 2                                ; Macro for reading from stdin
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
	write msg2,msg2len                      ; Write prompt for entering elements
	mov [i],dword 0                         ; Initialize loop counter i
loop1:
	mov esi,[i]                             ; Load current index into esi
	cmp esi,[n]                             ; Compare with number of elements
	jge end1                                ; If i >= n, end loop
	add esi,arr                             ; Calculate address of current element
	read esi,1                               ; Read one byte from stdin into current element
	inc dword[i]                            ; Increment i
	jmp loop1                               ; Repeat loop
end1:
	ret                                     ; Return

display:
	mov [i],dword 0                         ; Initialize loop counter i
loop2:
	mov esi,[i]                             ; Load current index into esi
	cmp esi,[n]                             ; Compare with number of elements
	jge end2                                ; If i >= n, end loop
	add esi,arr                             ; Calculate address of current element
	write esi,1                             ; Write current element to stdout
	write space,1                           ; Write space after element
	inc dword[i]                            ; Increment i
	jmp loop2                               ; Repeat loop
end2:
	write newline,1                         ; Write newline character
	ret                                     ; Return

selection_sort:
	mov eax,0                               ; Initialize pass counter
	mov bl,[n]                              ; Load number of elements
	sub bl,1                                ; Decrement by 1 to get last index
loop3:
	cmp al,bl                               ; Compare pass counter with last index
	jge end3                                ; If pass counter >= last index, end loop
	pushad                                  ; Save all general purpose registers
	write msg4,msg4len                     ; Write pass number
	write j,9                               ; Write pass number (as a character)
	write msg5,msg5len                     ; Write separator
	call display                            ; Display current state of array
	popad                                   ; Restore all general purpose registers
	mov ecx,0                               ; Initialize inner loop counter
	mov cl,al                               ; Load pass counter into cl
	add cl,1                                ; Increment by 1 to get start index for inner loop
	mov edi,arr                            ; Initialize destination index for swapping
	add edi,eax                             ; Add pass counter to base address of array
loop4:
	cmp cl,[n]                              ; Compare inner loop counter with number of elements
	jge update1                             ; If inner loop counter >= number of elements, go to update1
	mov esi,arr                            ; Initialize source index for swapping
	add esi,ecx                             ; Add inner loop counter to base address of array
	mov bh,[esi]                            ; Load value at source index
	mov dh,[edi]                            ; Load value at destination index
	cmp bh,dh                               ; Compare values
	jge update2                             ; If value at source index >= value at destination index, go to update2
	mov edi,arr                            ; Update destination index
	add edi,ecx                             ; Add inner loop counter to base address of array
update2:
	inc cl                                  ; Increment inner loop counter
	jmp loop4                               ; Repeat inner loop
update1:
	mov bh,[arr+eax]                       ; Load value at pass counter index
	mov dh,[edi]                            ; Load value at destination index
	mov [arr+eax],dh                       ; Swap values
	mov [edi],bh                            ; Swap values
	inc al                                  ; Increment pass counter
	inc byte[j]                             ; Increment pass counter (as a character)
	jmp loop3                               ; Repeat outer loop
end3:
	write msg4,msg4len                     ; Write pass number
	write j,9                               ; Write pass number (as a character)
	write msg5,msg5len                     ; Write separator
	call display                            ; Display final sorted array
	ret                                     ; Return

section .bss
	n resb 4                                ; Buffer for storing number of elements
	arr resb 10                             ; Buffer for storing array elements
	i resb 4                                ; Loop counter variable i
	j resb 9                                ; Pass counter variable j
	trash resb 1                            ; Trash buffer for reading unwanted characters

section .text
global _start

_start:
	write msg,msglen                        ; Write prompt for entering number of elements
	read n,1                                ; Read number of elements
	sub byte[n],'0'                        ; Convert character to integer
	mov eax,'0'                             ; Initialize pass counter (as a character)
	mov [j],eax                             ; Store pass counter
	call input                              ; Call input subroutine to read array elements
	write newline,1                         ; Write newline character
	call selection_sort                     ; Call selection_sort subroutine to sort array
	write newline,1                         ; Write newline character
	write msg3,msg3len                     ; Write prompt for displaying sorted array
	call display                            ; Call display subroutine to display sorted array
	mov eax,1                               ; Exit syscall
	mov ebx,0                               ; Exit code 0
	int 80h                                 ; Perform syscall
