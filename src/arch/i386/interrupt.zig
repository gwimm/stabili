pub const descriptor        = @import("interrupt/descriptor.zig");
pub const service_routine   = @import("interrupt/service_routine.zig");

const arch  = @import("../i386.zig");
const log   = arch.log;

pub const Context = struct {
    // instruction pointer
    ip: u32,
    cs: u32,
    // upper 32 bits of the FLAGS register
    rflags: u32,
    // old stack pointer
    sp: u32,
    ss: u32,
};

pub inline fn enable() void {
    asm volatile ("sti");
}

pub inline fn disable() void {
    asm volatile ("cli");
}

fn foo() callconv(.Interrupt) void {
    asm volatile (
        \\  mov $0x10, %%ax
        \\  mov  %%ax, %%ds
        \\  mov  %%ax, %%es
        \\  mov  %%ax, %%fs
        \\  mov  %%ax, %%gs
    )
    @panic("lol, please kill me");
}

pub fn init() void {
    log.log(.info, "initializing interrupt descriptor table: start", .{});
    defer log.log(.info, "initializing interrupt descriptor table: end", .{});

    service_routine.register(.breakpoint, foo);
    descriptor.init();

//      comptime var i = 0;
//      while (i <= 30) : (i += 1) {
//          switch (i) {
//              // 0...14, 16...19, 30 =>
//              0 =>
//                  service_routine.register(
//                      @intToEnum(service_routine.ServiceRoutine, i), foo),
//              else => {},
//          }
//      }
}