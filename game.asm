section .data
	prompt db "Enter your first guess.", 0x0a
	plen equ $ - prompt
	lower db "Try lower.", 0x0a
	llen equ $ - lower
	higher db "Try higher.", 0x0a
	hlen equ $ - higher
	correct db "Correct!", 0x0a
	clen equ $ - correct

	base equ 10				; base to play game in
	digits equ 2			; number of digits in answer

section .bss
	ans resb digits
	guess resb digits+1

section .text
	global _start

_start:
	; generate random number
	mov eax, 13				; sys_time
	mov ebx, esp			; pointer 
	int 0x80				; syscall
	pop eax					; get system time
	mov ebx, base			; base to convert to
	mov ecx, 0				; start counter

toascii:
	; convert random number to ascii
	xor edx, edx			; clear edx
	div ebx					; divide number by base
	add edx, '0'			; convert remainder to ascii
	mov [ans+ecx], edx		; move digit to ans
	push edx				; push digit
	inc ecx					; increment counter
	cmp ecx, digits			; less than two?
	jl toascii				; repeat

	; print prompt
	push prompt				; prompt
	push plen				; length
	call print				; syscall

gameloop:
	; read guess
	mov eax, 3				; sys_read
	mov ebx, 0				; stdin
	mov ecx, guess			; address
	mov edx, digits+1		; length
	int 0x80				; syscall

	mov ecx, 0				; start counter

check:
	; compare guess to solution
	mov al, [guess+ecx]		; first digit
	cmp [ans+ecx], al		; compare
	jl less					; smaller?
	jg greater				; bigger?
	inc ecx					; increment counter
	cmp ecx, digits			; less than two?
	jl check				; repeat

exit:
	push correct			; "Correct!"
	push clen				; length
	call print				; print

	mov eax, 1				; sys_exit
	mov ebx, 0				; success
	int 0x80				; syscall

less:
	push lower				; "Try lower."
	push llen				; length
	call print				; print

	jmp gameloop			; repeat

greater:
	push higher				; "Try higher."
	push hlen				; length
	call print				; print

	jmp gameloop			; repeat

print:
	mov ebp, esp			; save esp
	add esp, 4

	mov eax, 4				; sys_write
	mov ebx, 1				; stdout
	pop edx					; length
	pop ecx					; string
	int 0x80				; syscall

	mov esp, ebp			; restore esp
	ret						; return
