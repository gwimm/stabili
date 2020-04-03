const std       = @import("std");
const Builder   = std.build.Builder;

pub fn build(b: *Builder) !void {
    const exe = b.addObject("stabili", "src/stabili.zig");
    exe.setBuildMode(b.standardReleaseOptions());
    exe.setLinkerScriptPath("link.ld");
    exe.setTarget(std.zig.CrossTarget {
        .cpu_arch   = .x86_64,
        .os_tag     = .freestanding,
        .abi        = .none,
    });
}
