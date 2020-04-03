const std = @import("std")

pub const Level = enum {
    Info,
    Debug,
    Warning,
    Error,    
}

fn logCallback(ctx: void, str: []const u8) anyerror!void {
    serial.writeBytes(str, serial.Port.COM1)
}

pub fn log(
    comptime level: Level,
    comptime format: []const u8,
    args: var
) void {
    std.fmt.format(
        {},
        anyerror,
        logCallback,
        "[" ++ @tagName(level) ++ "] " ++ format, args
        ); catch unreachable;
}