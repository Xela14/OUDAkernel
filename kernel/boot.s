.intel_syntax noprefix


# Declare constants for the multiboot header.
.set ALIGN,    1<<0             # align loaded modules on page boundaries
.set MEMINFO,  1<<1             # provide memory map
.set FLAGS,    ALIGN | MEMINFO  # this is the Multiboot 'flag' field
.set MAGIC,    0x1BADB002       # 'magic number' lets bootloader find the header
.set CHECKSUM, -(MAGIC + FLAGS) # checksum of above, to prove we are multiboot


# https://www.gnu.org/software/grub/manual/multiboot/multiboot.html#Machine-state
#####################
####  MULTIBOOT  ####
#####################
.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM


#####################
#### STACK / IDT ####
#####################
.section .bss
.align 16
stack_bottom:
.skip 16384 # 16 KiB
stack_top:

.align 4
idt_bottom:	#FIXME: move this to bss maybe
.skip 2048
idt_top:



#####################
####     DATA    ####
#####################
.section .data

.global idt_bottom

idt_pointer:
.hword idt_top - idt_bottom - 1
.long idt_bottom


.align 4
gdt:
    # Put the pointer for lgdt in the null entry area
    .hword (gdt_end - gdt) + 1  # size
    .long gdt                   # offset
    .hword 0                    # Pad to 8bytes
    
    # code entry
    .hword 0xffff       		# limit 0:15
    .hword 0x0000      		 	# base 0:15
    .byte 0x00          		# base 16:23
    .byte 0x9A          		# RX
    .byte 0x4f          		# no pages / 32 bit protected mode
    .byte 0x00          		# base 24:31
    
    # data entry
    .hword 0xffff       		# limit 0:15
    .hword 0x0000       		# base 0:15
    .byte 0x00          		# base 16:23
    .byte 0x92         		    # RW
    .byte 0x4f          		# no pages / 32 bit protected mode
    .byte 0x00          		# base 24:31

gdt_end:



#####################
####    START    ####
#####################
.section .text
.global _start
_start:
	mov esp, offset stack_top

	lgdt gdt 					# load our own gdt, since the one the bios set up is no longer valid
	call define_idt				# Populate the IDT
	lidt idt_pointer			# Load the IDT
	call reprogram_pic			# Set PIC vector offsets to be Intel compliant; IRQ0-IRQ15 are at offset 0xF0-0xFF by default

	mov dl, 0x01				# PIC mask
	call mask_pic

	sti 						# Should be safe to re-enable the interrupts now
	call kernel_main
	
	
	# Keep the kernel running even if it returns from kernel_main
	# cli #if you disable interrupts here it wont accept anymore interrupts when the OS is idle
1:	hlt
	jmp 1b

.size _start, . - _start



#####################
####     PIC     ####
#####################

reprogram_pic:
	pusha
	# Send initialise command to both PICs
	mov   al , 0x11
	out   0x20 , al
	out   0xA0 , al

	# Set the vector offsets for both PICs					STEP #1
	mov   al , 0xF0
	out   0x21 , al
	mov   al , 0xF8
	out   0xA1 , al
	 
	# Tell pic1 that there's a slave pic on IRQ2			STEP #2
	mov   al , 0x04
	out   0x21 , al

	# Tell pic2 it's cascade identity						STEP #3
	mov   al , 0x02
	out   0xA1 , al

	# Environment flags (8086 mode)							STEP #4
	mov   al , 0x01
	out   0x21 , al
	out   0xA1 , al
	
	popa
	ret

mask_pic:
	in    al, 0x21
	or    al, dl			
	out   0x21, al
	ret




