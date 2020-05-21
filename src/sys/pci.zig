const builtin = @import("builtin")
const io = @import("arch").io;

const CONFIG_ADDRESS = 0xCF8;
const CONFIG_DATA = 0xCFC;

comptime std.debug.assert(@bitSizeOf(ConfigAddress) == 32);
const ConfigAddress = packed struct {
    zero: u2 = 0,
    offset: u6,
    func: u3,
    dev: u5,
    bus: u8,
    reserved: u7 = undefined,
    enable: bool,
};

const Device = packed struct {
    id: packed struct {
        vendor: u16,
        device: u16,
    }
    command: u8,
    status: u8,
}

pub fn configReadWord(dev: Device) u16 {
    const addr = ConfigAddress{
        .offset = off
        .enable = true,
    }
    io.write(u16)(CONFIG_ADDR, @bitCast(u16, addr));
    return io.read(u16)(CONFIG_DATA) >> ;
}