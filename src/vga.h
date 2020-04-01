# ifndef   __VGA_H__
# define   __VGA_H__

enum vga_color {
	VGA_COLOR_BLACK,
	VGA_COLOR_BLUE,
	VGA_COLOR_GREEN,
	VGA_COLOR_CYAN,
	VGA_COLOR_RED,
	VGA_COLOR_MAGENTA,
	VGA_COLOR_BROWN,
	VGA_COLOR_LIGHT_GREY,
	VGA_COLOR_DARK_GREY,
	VGA_COLOR_LIGHT_BLUE,
	VGA_COLOR_LIGHT_GREEN,
	VGA_COLOR_LIGHT_CYAN,
	VGA_COLOR_LIGHT_RED,
	VGA_COLOR_LIGHT_MAGENTA,
	VGA_COLOR_LIGHT_BROWN,
	VGA_COLOR_WHITE,
};

struct vga_ctx {
    struct vga_entry* fb;
	usize row;
	usize col;
};

# define CGA_BASE 0x000B8000

# define VGA_WIDTH 80
# define VGA_HEIGHT 25

struct vga_ctx* vga_ctx_ini(struct vga_ctx*);

void vga_write_entry_at(usize, i8, enum vga_color, enum vga_color);
void vga_write_string(i8*);

# endif // __VGA_H__