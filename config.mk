ROOT_PATH   := /home/Alex/os/
UTIL_PREFIX := /home/Alex/opt/cross/bin/

#GAS works the same as NASM with intel prefix
AS      := $(UTIL_PREFIX)i686-elf-as
CC      := $(UTIL_PREFIX)i686-elf-gcc
LD      := $(UTIL_PREFIX)i686-elf-ld
AR      := $(UTIL_PREFIX)i686-elf-ar

# Enable all warnings
WARN  		  :=  -Wall -Wextra -Wattributes -Wbuiltin-macro-redefined -Wcast-align 				     \
		          -Wdiv-by-zero -Wdouble-promotion -Wenum-compare -Wfloat-equal -Winit-self              \
		          -Wint-to-pointer-cast -Wlogical-op -Wmissing-braces -Wmissing-field-initializers       \
		          -Woverflow -Wpointer-arith -Wredundant-decls -Wreturn-type -Wshadow -Wsign-compare     \
		          -Wtype-limits -Wuninitialized -Wwrite-strings                                          \
		          -Wno-unused-parameter -Wno-unused-variable -Wno-multichar -Wno-unused-but-set-variable \
		          -Wimplicit-int -Wjump-misses-init -Wpointer-sign         						         \
		          -Wpointer-to-int-cast -Wmissing-parameter-type

DISABLED_WARN :=  -Wno-unused-label -Wno-discarded-qualifiers

PATH_LIBC         := $(ROOT_PATH)lib/libc/
PATH_LIBC_HEADERS := $(ROOT_PATH)lib/libc/include/
PATH_KERNEL_INCL  := $(ROOT_PATH)kernel/include/
INCLUDE           := -I$(PATH_KERNEL_INCL) -I$(PATH_LIBC_HEADERS)

LIBFLAGS := -nostdlib -lk -lgcc 
CFLAGS   := -ffreestanding -masm=intel -pedantic -std=c99 -O2 -g $(INCLUDE) -Werror $(WARN) $(LIBFLAGS) $(DISABLED_WARN)