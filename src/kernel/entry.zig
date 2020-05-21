const arch      = @import("arch");

const serial    = @import("serial.zig");
const vga       = @import("vga.zig");
const panic     = @import("panic.zig");
const log       = @import("log.zig");

var three: u32 = 3;
var zero: u32 = 0;

///
/// kernel entry.
/// assumes that arch specific setup is done.
///
pub fn entry() void {
    @setRuntimeSafety(false);
    serial.init(.COM1, 3);
    log.log(.info, "kernel: start", .{});
    defer log.log(.info, "kernel: end", .{});

    arch.init();

    // log.log(.debug, "calling breakpoint", .{});
    // arch.breakpoint();
    // log.log(.debug, "interrupt successfully called", .{});
}