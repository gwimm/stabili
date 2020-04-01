# include "vga.h"
# include "misc.h"
# include "lib.h"
# include "intdef.h"

struct vga_entry {
    u8 data;
    union {
        u8 color;
        struct {
            u8 fg : 4;
            u8 bg : 4;
        };
    };
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

void vga_write_string(i8* str) {
    usize len = str_len(str);
    for (usize i = 0; i < len; i++) {
        fb[i] = (struct vga_entry) {
            .data = str[i],
            .fg = VGA_COLOR_GREEN,
            .bg = VGA_COLOR_BLACK,
        };
    }
}