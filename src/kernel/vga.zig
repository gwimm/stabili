const std = @import("std");
const io = @import("arch").io;

comptime { std.debug.assert(@bitSizeOf(Entry) == 16); }
pub const Entry = packed struct {
    data:  u8,
    color: packed struct {
        fg: Code,
        bg: Code,

        pub const Code = enum(u4) {
            black         = 0o00,
            blue          = 0o01,
            green         = 0o02,
            cyan          = 0o03,
            red           = 0o04,
            magenta       = 0o05,
            brown         = 0o06,
            gray_light    = 0o07,
            gray_dark     = 0o10,
            blue_light    = 0o11,
            green_light   = 0o12,
            cyan_light    = 0o13,
            red_light     = 0o14,
            magenta_light = 0o15,
            yellow        = 0o16,
            white         = 0o17,
        };
    },
};

pub const WIDTH: u16 = 80;
pub const HEIGHT: u16 = 25;

pub var CGA_MMIO = @intToPtr([*]volatile align(4)Entry, 0x000B8000)[0..WIDTH * HEIGHT];

pub fn write(
    mmio: []volatile Entry,
    str: []const u8,
    color: Entry.Color
) void {
    // std.mem.copy(volatile Entry, mmio, str);
    for (str) |c, i| {
        mmio[i] = .{
            .data = c,
            .color = color
        };
    }
}

pub const cursor = struct {
    pub fn enable(start: u8, end: u8) void {
        io.write(u8)(0x3D4, 0x0A);
        io.write(u8)(0x3D5, io.read(0x3D5) & 0xC0 | start);
        io.write(u8)(0x3D4, 0x0B);
        io.write(u8)(0x3D5, io.read(0x3D5) & 0xE0 | end);
    }

    pub fn disable() void {
        io.write(u8)(0x3D4, 0x0A);
        io.write(u8)(0x3D5, 0x20);
    }

    pub const pos = struct {
        pub fn get() u16 {
            var bytes: packed struct { lo: u8, hi: u8 } = undefined;
            io.write(u8)(0x3D4, 0x0F);
            bytes.lo = io.read(u8)(0x3D5);
            io.write(u8)(0x3D4, 0x0F);
            bytes.hi = io.read(u8)(0x3D5);
            return std.mem.readInt(u16, std.mem.asBytes(&bytes), .Little);
        }

        pub fn set(pos: u16) void {
            var bytes: packed struct { lo: u8, hi: u8 } = undefined;
            std.mem.writeInt(u16, std.mem.asBytes(&bytes), pos, .Little);
            io.write(u8)(0x3D4, 0x0F);
            io.write(u8)(0x3D5, bytes.lo);
            io.write(u8)(0x3D4, 0x0E);
            io.write(u8)(0x3D5, bytes.hi);
        }
    };
};