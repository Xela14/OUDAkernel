.intel_syntax noprefix

# TODO: acknowledge the interrupt for the master pic and slave pic as well; in their respective handlers of course
# TODO: fix every interrupt handler

.extern printf

.section .data
msg:
.asciz "Interrupt Occured"


.section .text
# Common ISR code
isr_common_stub:
    # 1. Save CPU state
	pusha
	mov ax, ds
	push eax
	mov ax, 0x10  # kernel data segment descriptor
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	
    # 2. Call C handler
	call isr_handler
	
    # 3. Restore state
	pop eax 
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	popa
	add esp, 8 # Cleans up the pushed error code and pushed ISR number

	sti
	iret # pops 5 things at once: CS, EIP, EFLAGS, SS, and ESP


isr_handler:
    push offset msg
    call printf
    add esp, 4
    ret


.global irq_pic1
.global irq_pic2
.global isr0
.global isr1
.global isr2
.global isr3
.global isr4
.global isr5
.global isr6
.global isr7
.global isr8
.global isr9
.global isr10
.global isr11
.global isr12
.global isr13
.global isr14
.global isr15
.global isr16
.global isr17
.global isr18


# 0: Divide By Zero Exception
isr0:
    cli
    push 0
    push 0
    jmp isr_common_stub

# 1: Debug Exception
isr1:
    cli
    push 0
    push 1
    jmp isr_common_stub

# 2: Non Maskable Interrupt Exception
isr2:
    cli
    push 0
    push 2
    jmp isr_common_stub

# 3: Int 3 Exception
isr3:
    cli
    push 0
    push 3
    jmp isr_common_stub

# 4: INTO Exception
isr4:
    cli
    push 0
    push 4
    jmp isr_common_stub

# 5: Out of Bounds Exception
isr5:
    cli
    push 0
    push 5
    jmp isr_common_stub

# 6: Invalid Opcode Exception
isr6:
    cli
    push 0
    push 6
    jmp isr_common_stub

# 7: Coprocessor Not Available Exception
isr7:
    cli
    push 0
    push 7
    jmp isr_common_stub

# 8: Double Fault Exception (With Error Code!)
isr8:
    cli
    push 8
    jmp isr_common_stub

# 9: Coprocessor Segment Overrun Exception
isr9:
    cli
    push 0
    push 9
    jmp isr_common_stub

# 10: Bad TSS Exception (With Error Code!)
isr10:
    cli
    push 10
    jmp isr_common_stub

# 11: Segment Not Present Exception (With Error Code!)
isr11:
    cli
    push 11
    jmp isr_common_stub

# 12: Stack Fault Exception (With Error Code!)
isr12:
    cli
    push 12
    jmp isr_common_stub

# 13: General Protection Fault Exception (With Error Code!)
isr13:
    cli
    push 13
    jmp isr_common_stub

# 14: Page Fault Exception (With Error Code!)
isr14:
    cli
    push 14
    jmp isr_common_stub

# 15: Reserved Exception
isr15:
    cli
    push 0
    push 15
    jmp isr_common_stub

# 16: Floating Point Exception
isr16:
    cli
    push 0
    push 16
    jmp isr_common_stub

# 17: Alignment Check Exception
isr17:
    cli
    push 0
    push 17
    jmp isr_common_stub

# 18: Machine Check Exception
isr18:
    cli
    push 0
    push 18
    jmp isr_common_stub


irq_pic1:
    cli
    push 0
    push 0
    push eax
    mov al, 0x20
    out 0x20, al
    pop eax
    jmp isr_common_stub

irq_pic2:
    cli
    push 0
    push 0
    push eax
    mov al, 0x20
    out 0xA0, al
    out 0x20, al
    pop eax
    jmp isr_common_stub