const arch      = @import("arch");
const multiboot = @import("../../multiboot.zig");

// fengb: "Yuck lol"
export const MULTIBOOT_HEADER: [3]u32 linksection(".multiboot") = [_]u32{
    multiboot.HEADER_MAGIC,
    0,
    ~multiboot.HEADER_MAGIC + 1,
};

var stack: [16 * 1024]u8 align(16) = undefined;

export fn entry() callconv(.Naked) noreturn {
    @call(.{
            .modifier = .never_inline,
            .stack = stack[0..]
        },
        @import("kernel").entry,
        .{},
    );
    @call(.{ .modifier = .always_inline }, arch.halt, .{});
}