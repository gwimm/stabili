const InterfaceController = struct {
    address: struct {
        mac: [6]u8,
        ipv4: [4]u8,
        // ipv6
    },
    datalink: struct {
        size: usize,
        kind: u32,

    }
}

const MacAddress = [6]u8;
const Ipv4Address = [4]u8;

const Packet = struct {
    data: []u8
    nic: 
}

pub fn arp_process(packet: Packet) {
    (packet.data.len)
}

pub fn process(packet: Packet) {
    
}