const arch = @import("arch");

pub fn Port(port: u16) {
    return struct {
        pub fn read() u16 {
        }

        pub fn write() void {
        }
    };
}