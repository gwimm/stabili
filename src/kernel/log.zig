const std       = @import("std");
const serial    = @import("serial.zig");

pub const Level = enum {
    info,
    debug,
    warning,
    @"error",
};

pub fn log(
    comptime level: Level,
    comptime format: []const u8,
    args: var
) void {
    std.fmt.format(
        serial.Port.Writer(.COM1),
        "[" ++ @tagName(level) ++ "] " ++ format ++ "\n",
        args
    ) catch unreachable;
}