# include "multiboot.h"
# include "misc.h"

align(4)
section(".multiboot")
struct multiboot_header multiboot_header = {
    .magic = MULTIBOOT_HEADER_MAGIC,
    .flags = 0,
    .checksum = -MULTIBOOT_HEADER_MAGIC
};