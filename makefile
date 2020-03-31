include conf.mk

SRC_DIR = src
OBJ_DIR = obj

S_SRC = $(wildcard $(SRC_DIR)/*.s)
AS = nasm
ASF = -f elf32

C_SRC = $(wildcard $(SRC_DIR)/*.c)
CC = clang
CCF = 						\
	-m32					\
	-include 'src/intdef.h' \
	-nostdlib 				\
	-nostdinc 				\
	-fno-builtin 			\
	-fno-stack-protector 	\
	-Wall 					\
	-Wextra 				\
	-Werror					\
	-c

Z_SRC = $(wildcard $(SRC_DIR)/*.z)
ZC = tmp/zig-linux-x86_64-0.5.0+d788b0cd8/zig
ZCF = 								\
	build-obj						\
	--strip							\
	--release-small					\
	-target x86_64-freestanding-none

OBJ = $(addprefix $(OBJ_DIR)/,	\
	$(C_SRC:$(SRC_DIR)/%=%.o)	\
	$(Z_SRC:$(SRC_DIR)/%=%.o)	\
	$(S_SRC:$(SRC_DIR)/%=%.o))
LD = ld
LDF = 				\
	-melf_i386		\
	-T

NAME = os

all: os.elf

check_multiboot: os.elf
	@if grub-file --is-x86-multiboot $<; 	\
	 then echo "is multiboot"; 				\
	 else echo "error: not multiboot"; 		\
	 fi

run: $(NAME).iso
	qemu-system-x86_64 -cdrom os.iso

$(NAME).iso: $(NAME).elf
	mkdir -p iso/boot/grub
	cp $(NAME).elf iso/boot/$(NAME).elf
	cp grub.cfg iso/boot/grub/grub.cfg
	grub-mkrescue -o $(NAME).iso iso

$(NAME).elf: $(NAME).elf.ld $(OBJ)
	$(LD) -o $@ $(LDF) $^

$(OBJ_DIR)/%.c.o: $(SRC_DIR)/%.c $(OBJ_DIR)
	$(CC) -o $@ $(CCF) $<

$(OBJ_DIR)/%.s.o: $(SRC_DIR)/%.s $(OBJ_DIR)
	$(AS) -o $@ $(ASF) $<

$(OBJ_DIR)/%.z.o: $(SRC_DIR)/%.z $(OBJ_DIR)
	$(ZC) --name $(@:%.o=%) $(ZCF) $<

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

clean:
	rm -rf $(OBJ_DIR) os.elf os.iso iso