# include "multiboot.h"
# include "misc.h"

align(MULTIBOOT_HEADER_ALIGN)
section(".multiboot")
struct multiboot_header multiboot_header = {
    .magic      = MULTIBOOT_HEADER_MAGIC,
    .flags      = 0,
    .checksum   = -MULTIBOOT_HEADER_MAGIC,
};