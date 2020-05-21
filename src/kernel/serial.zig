const std  = @import("std");
const arch = @import("arch");

const io = arch.io;

const Error = error{
    Overrun,
    Parity,
    Framing,
    Break,
    Impending,
};

pub const Port = enum(u16) {
    COM1 = 0x3F8,
    COM2 = 0x2F8,
    COM3 = 0x3E8,
    COM4 = 0x2E8,

    const Register = enum {
        data,
        interruptEnable,

        fifoControl,
        lineControl,
        modemControl,

        lineStatus,
        modemStatus,

        scratch,
    };

    const RegisterDla = enum {
        lsb,
        msb,
    };

    pub fn register(self: Port, reg: Register) u16 {
        return @enumToInt(self) + @enumToInt(reg);
    }

    pub fn registerDla(self: Port, reg: RegisterDla) u16 {
        return @enumToInt(self) + @enumToInt(reg);
    }

    pub fn readLineStatus(self: Port) LineStatusData {
        return @bitCast(LineStatusData, io.read(u8)(self.register(.lineStatus)));
    }

    pub fn writeByte(port: Port, data: u8) Error!void {
        while (!port.readLineStatus().empty) {
            arch.halt();
        }
        io.write(u8)(port.register(.data), data);
    }

    pub fn write(port: Port, buf: []const u8) Error!usize {
        var i: usize = 0;
        while (i < buf.len) : (i += 1) {
            try writeByte(port, buf[i]);
        }
        return i;
    }

    pub fn Writer(port: Port) std.io.OutStream(Port, Error, write) {
        return .{
            .context = port,
        };
    }
};

const InterruptEnableData = packed struct {
    available:      bool,
    empty:          bool,
    break_error:    bool,
    status_change:  bool,
    unused:         u4,
};

const ParityMode = enum(u3) {
    none    = 0b000,
    odd     = 0b001,
    even    = 0b011,
    high    = 0b101,
    low     = 0b111,
};

const WordLength = enum(u2) {
    @"5",
    @"6",
    @"7",
    @"8",
};

const LineControlData = packed struct {
    word_length:            u2,
    // word_length:            WordLength,
    stop_bit_length:        u1,
    parity_mode:            u3,
    // parity_mode:            ParityMode,
    break_enable:           bool,
    divisor_latch_access:   bool,

//     fn init(
//         lcd: union(enum) {
//             data: struct {
//                 word_length:            u2,
//                 stop_bit_length:        u1,
//                 parity_mode:            u3,
//                 break_enable:           bool,
//             },
//             divisor_latch_access,
//         },
//     ) @This() {
//         switch (lcd) {
//             .data =>
//             .divisor_latch_access =>
//         }
//     }

    const DLA_ENABLE = LineControlData{
        .word_length            = @enumToInt(WordLength.@"5"),
        .stop_bit_length        = 0,
        .parity_mode            = @enumToInt(ParityMode.none),
        .break_enable           = false,
        .divisor_latch_access   = true,
    };

    const _8N1 = LineControlData{
        .word_length            = @enumToInt(WordLength.@"8"),
        .stop_bit_length        = 0,
        .parity_mode            = @enumToInt(ParityMode.none),
        .break_enable           = false,
        .divisor_latch_access   = false,
    };
};

const LineStatusData = packed struct {
    data_ready:         bool,
    overrun_error:      bool,
    parity_error:       bool,
    framing_error:      bool,
    break_indicator:    bool,
    empty:              bool,
    idle:               bool,
    impending_error:    bool,
};

const UART_CLOCK: u32 = 115200;

pub fn setBaudRate(port: Port, div: u16) void {
    io.write(u8)(port.register(.lineControl), @bitCast(u8, LineControlData.DLA_ENABLE));

    const baudSplits = @bitCast([2]u8, div);
    io.write(u8)(port.registerDla(.lsb), baudSplits[0]);
    io.write(u8)(port.registerDla(.msb), baudSplits[1]);

    io.write(u8)(port.register(.lineControl), @bitCast(u8, LineControlData._8N1));
}

pub fn init(port: Port, div: u16) void {
    setBaudRate(port, div);
    io.write(u8)(port.register(.interruptEnable), 0x00);
}

test "LCR bitcast" {
    const assert = std.debug.assert;
    assert(@bitCast(u8, LCR_DLA_ENABLE) == 0x80);
    assert(@bitCast(u8, LCR_8N1) == 0x03);
}