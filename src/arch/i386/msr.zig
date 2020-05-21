pub const Address = enum(u32) {
    extendedFeatureEnable = 0xC0000080,
};

pub fn Register(address: Address) type {
    return switch (address) {
        .extendedFeatureEnable => packed struct {
                system_call_extensions:         u1,
                reserved_0:                     u7,
                long_mode:                      bool,
                long_mode_active:               bool,
                no_execute:                     bool,
                secure_virtual_machine:         bool,
                long_mode_segment_limit:        bool,
                fast_fx_instructions:           bool,
                translation_cache_extension:    bool,
                reserved:                       u13
            },
    };
}

pub fn read(comptime address: Address) u32 {
    return asm volatile (
        \\  rdmsr
        : [_] "={ax}" (-> u32)
        : [_]  "{cx}" (@enumToInt(address))
    );
}

pub fn write(comptime address: Address, register: u32) void {
    asm volatile (
        \\  wrmsr
        : : [_] "{cx}" (@enumToInt(address)),
            [_] "{ax}" (register)
    );
}