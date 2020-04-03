SRC_DIR = src
OBJ_DIR = obj

S_SRC = $(wildcard $(SRC_DIR)/*.s)
AS = nasm
ASF = -f elf32

C_SRC = $(wildcard $(SRC_DIR)/*.c)
CC = clang
CCF = 						\
	-m32					\
	-O2						\
	-include 'src/intdef.h' \
	-nostdlib 				\
	-nostdinc 				\
	-fno-builtin 			\
	-fno-stack-protector 	\
	-Wall 					\
	-Wextra 				\
	-Werror					\
	-c

OBJ = $(addprefix $(OBJ_DIR)/,	\
	$(C_SRC:$(SRC_DIR)/%=%.o)	\
	$(Z_SRC:$(SRC_DIR)/%=%.o)	\
	$(S_SRC:$(SRC_DIR)/%=%.o))
LD = ld
LDF = 				\
	-melf_i386		\
	-T

EMU = qemu-system-x86_64
EMUF = 					\
	-d int 				\
	-D ./tmp/emu.log

NAME = os

all: os.elf

check_multiboot: os.elf
	@if grub-file --is-x86-multiboot $<; 	\
	 then echo "is multiboot"; 				\
	 else echo "error: not multiboot"; 		\
	 fi

run: $(NAME).iso
	$(EMU) $(EMUF) -cdrom $<

$(NAME).iso: $(NAME).elf
	mkdir -p iso/boot/grub
	cp $< iso/boot/$<
	echo "												\
		set timeout=0\n									\
		menuentry \"$(NAME)\" {							\
			multiboot /boot/$< } 						\
	" > iso/boot/grub/grub.cfg
	grub-mkrescue -o $@ iso

$(NAME).elf: $(NAME).elf.ld $(OBJ)
	$(LD) -o $@ $(LDF) $^

$(OBJ_DIR)/%.c.o: $(SRC_DIR)/%.c $(OBJ_DIR)
	$(CC) -o $@ $(CCF) $<

$(OBJ_DIR)/%.s.o: $(SRC_DIR)/%.s $(OBJ_DIR)
	$(AS) -o $@ $(ASF) $<

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

clean:
	rm -rf $(OBJ_DIR) os.elf os.iso iso