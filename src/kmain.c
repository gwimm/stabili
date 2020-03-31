# include "intdef.h"
# include "vga.h"
# include "lib.h"
# include "gdt.h"

void kmain(void) {
    gdt_load();
    // vga_ctx_ini(&(struct vga_ctx){});
    vga_write_string("uwu, pls work");
}