const arch      = @import("arch.zig");
const interrupt = @import("interrupt.zig");

noinline fn pageFault() callconv(.Interrupt) void {
    @panic("page fault");
}

pub fn init() void {
    log.log(.info, "initializing paging: start", .{});
    defer log.log(.info, "initializing paging: end", .{});

    interrupt.service_routine.register(.PageFault, pageFault);
}