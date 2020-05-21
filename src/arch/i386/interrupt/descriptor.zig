const std       = @import("std");
const testing   = std.testing;

pub const Descriptor = packed struct {
    base_low:   u16,
    selector:   u16,
    zero:       u8      = 0,
    gate_type:  Gate,
    segment:    u1,
    privilege:  Ring,
    present:    bool,
    base_high:  u16,

    const Ring = enum(u2) {
        kernel  = 0,
        user    = 3,
    };

    const Gate = enum(u4) {
        zero            = 0,
        task32          = 0b0101,
        interrupt16     = 0b0110,
        trap16          = 0b0111,
        interrupt32     = 0b1110,
        trap32          = 0b1111,
    };

    const Table = packed struct {
        limit:  u16,
        base:   u32,
    };
};

pub var table = std.mem.zeroes([256]Descriptor);

fn load(ptr: *const Descriptor.Table) void {
    asm volatile (
        \\  lidt (%[ptr])
        : : [ptr] "{ax}" (ptr)
    );
}

pub fn init() void {
    load(&Descriptor.Table{
        .limit  = table.len * @sizeOf(Descriptor) - 1,
        .base   = @ptrToInt(&table),
    });
}

test "Table size assertion" {
    testing.expect(@sizeOf(Descriptor.Table) == 6);
}