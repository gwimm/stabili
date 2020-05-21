pub const entry = @import("kernel/entry.zig").entry;
pub const log = @import("kernel/log.zig");

const builtin = @import("builtin");

comptime {
    _ = @import("arch.zig").boot;
}

pub fn panic(msg: []const u8, trace: ?*builtin.StackTrace) noreturn {
    @setCold(true);
    @import("kernel/panic.zig").panic(trace, "{}", .{msg});
}