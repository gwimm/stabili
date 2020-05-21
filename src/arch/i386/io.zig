fn getGasSuffix(comptime T: type) []const u8 {
    return switch (T) {
        u8          => "b",
        u16         => "w",
        f32         => "s",
        u32, f64    => "l",
        u64         => "q",
        else => @compileError(@tagName(@import("builtin").arch) ++
                " doesn't allow for this suffix"),
    };
}

pub fn write(comptime T: type) fn (u16, T) void {
    return struct {
        fn func(port: u16, data: T) void {
            asm volatile (
                   "out" ++ getGasSuffix(T) ++ " %[data], %[port]"
                : : [port] "{dx}" (port),
                    [data] "{al}" (data)
            );
        }
    }.func;
}

pub fn read(comptime T: type) fn (u16) T {
    return struct {
        fn func(port: u16) T {
            return asm volatile (
                  "in" ++ getGasSuffix(T) ++ "  %[port], %[ret]"
                : [ret] "={ax}" (-> T)
                : [port] "{dx}" (port)
            );
        }
    }.func;
}

pub fn wait() void { out(u8)(0x80, 0x00); }