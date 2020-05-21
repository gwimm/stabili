pub const gdt       = @import("i386/gdt.zig");
pub const interrupt = @import("i386/interrupt.zig");
pub const paging    = @import("i386/paging.zig");
pub const msr       = @import("i386/msr.zig");

pub const boot  = @import("i386/boot.zig");
pub const io    = @import("i386/io.zig");

pub const log   = @import("kernel.zig").log;

pub fn halt() noreturn {
    while (true) {
        asm volatile ("hlt");
    }
}

pub fn breakpoint() void {
    asm volatile ("int $3");
}

pub fn init() void {
    log.log(.info, "architecture specific setup: start", .{});
    defer log.log(.info, "architecture specific setup: end", .{});

    // interrupt.disable();

    gdt.init();
    // interrupt.init();

    // paging.init();

    // interrupt.enable();
}