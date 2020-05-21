const std = @import("std");

comptime std.debug.assert(@bitSizeOf(Header) % 32 == 0);
const Header = packed struct {
    port_src: u16,
    port_dst: u16,
    num_seq: u16,
    num_ack: u16,
    data_offset: u4,
    reserved: u6,
    control: packed struct {
        urg: bool,
        ack: bool,
        psh: bool,
        rst: bool,
        syn: bool,
        fin: bool,
    },
    window: u16,
    checksum: u16,
    urgent_pointer: u16,
    options: [2]u8

    const This = @This();
    const Kind = enum {
        urg = 0b000001,
        ack = 0b000010,
        psh = 0b000100,
        rst = 0b001000,
        syn = 0b010000,
        fin = 0b100000,
    };

    pub fn kind(*this: This) Kind {
        return @bitCast(Kind, this.control);
    }
};

pub fn deserializer(
    in_stream: var,
) std.io.Deserializer(.Big, .Byte, @TypeOf(in_stream)) {
    return std.io.Deserializer(.Big, .Byte, @TypeOf(in_stream))
        .init(in_stream);
}

const Connection = struct {
    state: State,
    send: SendSequenceSpace,
    revieve: RecieveSequenceSpace
    closed: bool,

    const This = @This();
    const State = enum {
        closed,
        listening,
        sync_sent,
        sync_rcvd,
        established,
        finish_wait_0,
        finish_wait_1,
        closing,
        closing_wait,
        time_wait,
        last_acknoledgment,
    };

    /// State of the Send Sequence Space (RFC 793 S3.2 F4)
    ///
    /// ```
    ///            1         2          3          4
    ///       ----------|----------|----------|----------
    ///              SND.UNA    SND.NXT    SND.UNA
    ///                                   +SND.WND
    ///
    /// 1 - old sequence numbers which have been acknowledged
    /// 2 - sequence numbers of unacknowledged data
    /// 3 - sequence numbers allowed for new data transmission
    /// 4 - future sequence numbers which are not yet allowed
    /// ```
    const SendSequenceSpace = struct {
        /// oldest unacknowledged sequence number
        una: u32,
        /// next sequence number to be sent
        nxt: u32,
        /// acknowledgment from the recieving tcp (next sequence number
        /// expected by the reveiving TCP)
        wnd: u16,
        up: bool,
        wl1: usize,
        wl2: usize,
        iss: u32,
    };

    /// State of the Receive Sequence Space (RFC 793 S3.2 F5)
    ///
    /// ```
    ///                1          2          3
    ///            ----------|----------|----------
    ///                   RCV.NXT    RCV.NXT
    ///                             +RCV.WND
    ///
    /// 1 - old sequence numbers which have been acknowledged
    /// 2 - sequence numbers allowed for new reception
    /// 3 - future sequence numbers which are not yet allowed
    /// ```
    struct RecieveSequenceSpace {
        nxt: u32,
        wnd: u16,
        up: bool,
        irs: u32,
    };

    pub fn accept(tcp: Header, data: []u8) ?This {
        return if (tcp.kind() == .syn) .{
            .state = .sync_recieved,
            .send = .{
            },
        } else null;
    }

    pub write(this: *This, seq: u32) !usize {
        var buf = std.mem.zeroes([1500]u8);
    }
}