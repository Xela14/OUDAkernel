.intel_syntax noprefix

# Load the IDT through code because of a shortcoming of the ELF format.
# Can't take a 32bit pointer from an interrupt handler and split it into 2 16bit halves when
# trying to define the IDT through a macro in the .data section.
.section .text
.global define_idt
define_idt:
	push ebp
	mov ebp, esp
	push eax
	push ebx
	push ecx
	push edi

	sub esp, 8						# Space for arguments to store_isr_pointer func
	mov ebx, offset idt_bottom
	mov ecx, 31

.align 4
exception_handlers:
	lea edi, [ebx + 8 * ecx - 6 ]	# skip first 2 bytes to later load them with the isr; subtract 6 because ecx will, at lowest, be 1 so we will skip the first 8 bytes of our IDT if we dont
	mov eax, 0x0008					# GDT entry
	stosw
	mov eax, 0x8E00 				# unused + flags
	stosw
	mov eax, 0x0000                 # upper 16 bits of the isr address will most likely resolve to 0, might have to fix this
	stosw
	loop exception_handlers

	lea ebx, [ebx + 0xF0 * 8]		# Set offset to F0 (IRQ0)
	mov ecx, 15

#TODO: disable the 2 unused IRQs
irq_handlers:
	lea edi, [ebx + 8 * ecx - 6]
	mov eax, 0x0008					# GDT entry
	stosw
	mov eax, 0x8E00 				# unused + flags
	stosw
	mov eax, 0x0000                 # upper 16 bits of the isr address will most likely resolve to 0, might have to fix this
	stosw
	loop irq_handlers

.align 0

	push offset irq_pic1
	push 0xF0						
	call store_isr_pointer

	push offset kb_handler
	push 0xF1						
	call store_isr_pointer

	push offset irq_pic1
	push 0xF2						
	call store_isr_pointer

	push offset irq_pic1
	push 0xF3						
	call store_isr_pointer

	push offset irq_pic1
	push 0xF4						
	call store_isr_pointer

	push offset irq_pic1
	push 0xF5						
	call store_isr_pointer

	push offset irq_pic1
	push 0xF6						
	call store_isr_pointer

	push offset irq_pic1
	push 0xF7						
	call store_isr_pointer

	push offset irq_pic2
	push 0xF8						
	call store_isr_pointer

	push offset irq_pic2
	push 0xF9						
	call store_isr_pointer

	push offset irq_pic2
	push 0xFA						
	call store_isr_pointer

	push offset irq_pic2
	push 0xFB						
	call store_isr_pointer

	push offset irq_pic2
	push 0xFC						
	call store_isr_pointer

	push offset irq_pic2
	push 0xFD						
	call store_isr_pointer

	push offset irq_pic2
	push 0xFE						
	call store_isr_pointer

	push offset isr0
	push 0
	call store_isr_pointer

	push offset isr1
	push 1
	call store_isr_pointer

	push offset isr2
	push 2
	call store_isr_pointer

	push offset isr3
	push 3
	call store_isr_pointer

	push offset isr3
	push 4
	call store_isr_pointer

	push offset isr3
	push 5
	call store_isr_pointer

	push offset isr3
	push 6
	call store_isr_pointer

	push offset isr3
	push 7
	call store_isr_pointer

	push offset isr3
	push 8
	call store_isr_pointer

	push offset isr3
	push 9
	call store_isr_pointer

	push offset isr3
	push 10
	call store_isr_pointer

	push offset isr3
	push 11
	call store_isr_pointer

	push offset isr3
	push 12
	call store_isr_pointer

	push offset isr3
	push 13
	call store_isr_pointer

	push offset isr3
	push 14
	call store_isr_pointer

	push offset isr3
	push 15
	call store_isr_pointer

	push offset isr3
	push 16
	call store_isr_pointer

	push offset isr3
	push 17
	call store_isr_pointer

	push offset isr3
	push 18
	call store_isr_pointer

	push offset isr3
	push 19
	call store_isr_pointer

	pop edi
	pop ecx
	pop ebx
	pop eax
	leave
	ret



# First pushed argument = offset to isr
# Second pushed argument = index into the IDT
store_isr_pointer:
	push ebp			
	mov ebp, esp					# Getting easy access to pushed arguments
	push eax
	push ebx
	push ecx
	push edx
	push edi

	mov ebx, offset idt_bottom
	mov ecx, [ebp + 0x8]
	mov eax, [ebp + 0xC]
	lea edi, [ebx + 8 * ecx + 0]	# Put the base address of the IDT entry at index ecx into edi
	mov edx, eax 					# Save the EAX register
	and eax, 0xFFFF 				# Take the lowest 16 bits and store them at IDT[i] + 0
	stosw
	mov eax, edx
	shr eax, 16
	and eax, 0xFFFF					# Take the highest 16 bits and store them at IDT[i] + 6
	add edi, 4						# add 4 to edi because the previous stosw also added 2 to edi bringing us to offset IDT[i]+0x6 (upper 2 bytes of the ISR ptr are stored here)
	stosw

	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax
	leave
	ret 8