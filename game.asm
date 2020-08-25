section .data
	prompt db "Enter your first guess.", 0x0a
	plen equ $ - prompt
	lower db "Try lower.", 0x0a
	llen equ $ - lower
	higher db "Try higher.", 0x0a
	hlen equ $ - higher
	correct db "Correct!", 0x0a
	clen equ $ - correct

section .bss
	ans resb 2
	guess resb 3

section .text
	global _start

_start:
	mov eax, 13
	push eax
	mov ebx, esp
	int 0x80
	pop eax
	mov [ans], al

	mov eax, dword [ans]
	xor edx, edx
	mov ebx, 10
	div ebx
	add edx, '0'
	mov [ans], edx

	xor edx, edx
	div ebx
	add edx, '0'
	mov [ans+1], edx

	; print prompt
	mov eax, 4				; sys_write
	mov ebx, 1				; stdout
	mov ecx, prompt			; prompt
	mov edx, plen			; length
	int 0x80				; syscall

gameloop:
	; get guess
	mov eax, 3				; sys_read
	mov ebx, 0				; stdin
	mov ecx, guess			; address
	mov edx, 3				; length
	int 0x80

	mov al, [guess]
	cmp [ans], al
	jl less
	jg greater
	jne gameloop
	mov al, [guess+1]
	cmp [ans+1], al
	jl less
	jg greater
	jne gameloop			; repeat

exit:
	mov eax, 4				; sys_write
	mov ebx, 1				; stdout
	mov ecx, correct		; prompt
	mov edx, clen			; length
	int 0x80				; syscall

	mov eax, 1				; sys_exit
	mov ebx, 0				; success
	int 0x80				; syscall

less:
	mov eax, 4				; sys_write
	mov ebx, 1				; stdout
	mov ecx, lower			; prompt
	mov edx, llen			; length
	int 0x80				; syscall

	jmp gameloop

greater:
	mov eax, 4				; sys_write
	mov ebx, 1				; stdout
	mov ecx, higher			; prompt
	mov edx, hlen			; length
	int 0x80				; syscall

	jmp gameloop
