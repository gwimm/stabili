const arch      = @import("arch");
const builtin   = @import("builtin");

const log       = @import("log.zig");

pub fn panic(
    stack_trace: ?*builtin.StackTrace,
    comptime format: []const u8,
    args: var
) noreturn {
    @setCold(true);
    log.log(.@"error", "kernel panic: " ++ format ++ "\n", args);
    if (stack_trace) |trace| {
        var last_addr: u64 = 0;
        for (trace.instruction_addresses) |ret_addr| {
            if (ret_addr != last_addr) {
                log.log(.@"error", "{x}\n", .{ret_addr});
            }
            last_addr = ret_addr;
        }
    }
    arch.halt();
}