

extern var KERNEL_VADDR_END: *u32;

extern var KERNEL_VADDR_START: *u32;

extern var KERNEL_PHYSADDR_END: *u32;

extern var KERNEL_PHYSADDR_START: *u32;

extern var KERNEL_ADDR_OFFSET: *u32;

pub fn init(info: *multiboot.Info) MemProfile {
    log.log(.Info, "init mem:\n", .{});
    return MemProfile{
        .vaddr_end   = @ptrCast([*]u8, &KERNEL_VADDR_END),
        .vaddr_start = @ptrCast([*]u8, &KERNEL_VADDR_START),
        .phyaddr_end   = @ptrCast([*]u8, &KERNEL_PHYADDR_END),
        .phyaddr_start = @ptrCast([*]u8, &KERNEL_PHYADDR_START),

        .mem_kb = info.mem_upper + info.mem_lower,
        .boot_modules = 
    };
}