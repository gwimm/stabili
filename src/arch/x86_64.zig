// pub const gdt       = @import("x86_64/gdt.zig");
// pub const interrupt = @import("x86_64/interrupt.zig");
// pub const paging    = @import("x86_64/paging.zig");
// pub const msr       = @import("x86_64/msr.zig");

// pub const boot  = @import("x86_64/boot.zig");
// pub const io    = @import("x86_64/io.zig");

pub fn halt() noreturn {
    while (true) {
        asm volatile ("hlt");
    }
}