# include "lib.h"

# include "vga.h"

# include "gdt.h"
# include "idt.h"

section(".bss.stack") u8 kernel_stack[16 * 1024];
int zero = 0, three = 3;

void kmain(void) {
    gdt_init();
    idt_init();
    vga_write_string("end, pwp");
}