const std = @import("std");

pub fn build(b: *std.build.Builder) !void {
    const src = "src/kernel.zig";

    const exe = b.addExecutable("stabili.elf", src);
    const tests = b.addTest(src);
    exe.setBuildMode(b.standardReleaseOptions());

    // https://github.com/ziglang/zig/issues/4715
    exe.link_function_sections = true;

    exe.addPackagePath("arch", "src/arch.zig");
    exe.addPackagePath("kernel", "src/kernel.zig");

    exe.setLinkerScriptPath("src/link.ld");
    exe.setTarget(.{
        .cpu_arch   = .x86_64,
        .os_tag     = .freestanding,
        .abi        = .none,
    });

    b.step("test", "run tests").dependOn(&tests.step);
    exe.install();
}