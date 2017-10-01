.intel_syntax noprefix

# Scancode reference: https://www.win.tue.nl/~aeb/linux/kbd/scancodes-1.html

.extern putchar
.extern TerminalRemoveChar

.align 4
.section .data
# No need for trailing 0 because this string will never be printed
# Every NULL character represents a key that doesn't have a character associated with it (tab, enter.. etc)
kb_chars_lower:
.ascii "1234567890-=\0\0qwertyuiop[]\n\0asdfghjkl;'`\0\\zxcvbnm,./"


.text
.global kb_handler
kb_handler:
	push ebp
	mov ebp, esp
	push eax
	push ebx
	push edx

	xor eax, eax
	xor edx, edx

	in al, 0x60
	
	cmp al, 0x0E
	jz backspace
	cmp al, 0x39
	jz space
	cmp al, 0x36	# check if the code is inside of the lower case bounds
	ja end
	

	mov ebx, offset kb_chars_lower
	call process_kb_code

end:
    mov al, 0x20
    out 0x20, al

    pop edx
    pop ebx
    pop eax
    leave
    iret


process_kb_code:
	sub al, 0x2
	mov dl, [ebx + eax]
	push edx
	call putchar
	add esp, 4
	ret

space:
	push 0x20
	call putchar
	add esp, 4
	jmp end

backspace:
	call TerminalRemoveChar
	jmp end

