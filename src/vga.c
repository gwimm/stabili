# include "vga.h"
# include "misc.h"
# include "lib.h"
# include "intdef.h"

struct vga_entry {
    i8 data;
    u8 fg : 4;
    u8 bg : 4;
} packed;

struct vga_entry* fb = (void*)CGA_BASE;

struct vga_ctx* vga_ctx_ini(struct vga_ctx* ctx) {
    *ctx = (struct vga_ctx) {
        .fb = (void*)CGA_BASE,
    };

    for (usize i = 0; i < 80 * 25; i++) {
        fb[i] = (struct vga_entry) {
            .data = ' ',
            .fg = VGA_COLOR_GREEN,
            .bg = VGA_COLOR_BLACK,
        };
    }

    return ctx;
}

void vga_write_entry_at(
    usize i,
    i8 c,
    enum vga_color fg,
    enum vga_color bg
    ) {
    fb[i] = (struct vga_entry) {
        .data = c,
        .fg = fg,
        .bg = bg,
    };
}

void vga_write_string(i8* str) {
    usize len = str_len(str);
    for (usize i = 0; i < len; i++) {
        vga_write_entry_at(i , str[i], VGA_COLOR_GREEN, VGA_COLOR_BLACK);
    }
}