const std   = @import("std");

const arch  = @import("../i386.zig");
const log   = arch.log;

const Descriptor = packed struct {
    limit_low:  u16,
    base_low:   u24,
    access:     Access,
    limit_high: u4,
    flags:      Flags,
    base_high:  u8,

    const Access = packed struct {
        accessed:       bool, /// set by cpu.
        read_write:     bool, /// if executable ? readable : writable
        mdpl_or_stack:  bool, /// executable ? mdpl : stack
        executable:     bool, /// if set then code segment else data segment
        data:           bool, /// set for data segment. don't for tss
        privilege:      u2, /// dpl/ring level.
        present:        bool, /// should always be set (except: null descriptor)

        const CODE = Access{
            .accessed       = false,
            .read_write     = true,
            .mdpl_or_stack  = false,
            .executable     = true,
            .data           = true,
            .privilege      = 0,
            .present        = true,
        };

        const DATA = Access{
            .accessed       = false,
            .read_write     = true,
            .mdpl_or_stack  = false,
            .executable     = false,
            .data           = true,
            .privilege      = 0,
            .present        = true,
        };

        const TSS = Access{
            .accessed       = true,
            .read_write     = false,
            .mdpl_or_stack  = false,
            .executable     = true,
            .data           = false,
            .privilege      = 0,
            .present        = true,
        };
    };

    pub const Flags = packed struct {
        zero:           u1 = 0,
        x64:            bool,
        x32:            bool,
        granularity:    bool,

        pub const BITS32 = Flags{
            .x64            = false,
            .x32            = true,
            .granularity    = true,
        };
    };

    pub fn init(
        base:   u32,
        limit:  u20,
        access: Access,
        flags:  Flags
    ) Descriptor {
        return .{
            .base_low   = @truncate(u24, base),
            .base_high  = @truncate(u8, base >> 24),

            .limit_low  = @truncate(u16, limit),
            .limit_high = @truncate(u4, limit >> 16),

            .access     = access,
            .flags      = flags,
        };
    }

    pub const Table = packed struct {
        limit:  u16,
        base:   u32,
    };
};

var gdt = [_]Descriptor{
    std.mem.zeroes(Descriptor),
    Descriptor.init(0, 0, Descriptor.Access.CODE, Descriptor.Flags.BITS32),
    Descriptor.init(0, 0, Descriptor.Access.DATA, Descriptor.Flags.BITS32),
};

pub const CODE_OFFSET: usize = 0x08;
pub const DATA_OFFSET: usize = 0x10;

inline fn flushSegments(data: usize, code: usize) void {
    asm volatile (
        \\  mov %[segment], %%ds
        \\  mov %[segment], %%es
        \\  mov %[segment], %%fs
        \\  mov %[segment], %%gs
        \\  mov %[segment], %%ss
        : : [segment] "{ax}" (data)
    );

    asm volatile (
        \\      jmp $0x8, $.flush
        \\  .flush:
        //  : : [segment] "{ax}" (code)
    );
}

pub fn load(table: *const Descriptor.Table) void {
    asm volatile (
        \\  lgdt (%[table])
        : : [table] "{ax}" (table)
    );
    flushSegments(DATA_OFFSET, CODE_OFFSET);
}

pub fn init() void {
    log.log(.info, "initializing global descriptor table: start", .{});
    defer log.log(.info, "initializing global descriptor table: end", .{});

    load(&Descriptor.Table{
        .limit = gdt.len * @sizeOf(Descriptor) - 1,
        .base = @truncate(u32, @ptrToInt(&gdt)),
    });
}

test "Descriptor packing test" {
    testing.expect(@sizeOf(Descriptor) == 6);
    testing.expect(@sizeOf(Descriptor.Table) == 6);
}