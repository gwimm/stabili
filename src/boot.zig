const multiboot = @import("multiboot.zig")

export const HEADER = multiboot.Header{
    .magic      = multiboot.HEADER_MAGIC,
    .flags      = 0,
    .checksum   = -multiboot.HEADER_MAGIC,
};

export var KERNEL_STACK
    : [16 * 1024]u8 align(16) linksection(".bss.stack")
    = undefined;

extern fn kmain() void;

export fn _start() callconv(.Naked) noreturn {
    asm volatile (
        \\.extern KERNEL_STACK_END
        \\mov $KERNEL_STACK_END, %%esp
    );

    kmain();

    asm volatile (
        \\halt:
        \\  cli
        \\  hlt
        \\  jmp halt
    );
}