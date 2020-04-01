# include "lib.h"
# include "intdef.h"

usize str_len(i8* str) {
    u8* buf = (void*)str;
    usize len = 0;

    while (buf[len++]);

    return len;
}

void* memmove(void* dst, const void* src, u64 len) {
    const u8* s;
    u8* d;

	if (dst != src) {
        s = src;
        d = dst;
        while (len--) {
            *d++ = *s++;
        }
    }

    return dst;
}

void *memset(void *dst, u8 c, u64 len) {
	u8 *d = dst;

	for (; len; len--, d++) *d = c;

	return dst;
}

# include "vga.h"

usize k_fmt(const i8* fmt, ...) {
    // vga_write_string((i8*)fmt);
    return fmt[0];
}