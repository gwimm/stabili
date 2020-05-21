nic: net.Interface,

base: usize, // pointer to mmio

irq_line: u32,
poll_reg: u32,

ipf: u32,
udpf: u32,
tcpf: u32,

reader: std.io.InStream(),
writer: std.io.OutStream(),

const This = @This();
const net = @import("net");
const 

const SUPPORTED = [_]u16{
    0x8139,
    0x8168,
    0x8169,
};

pub fn init() !@This() {

}