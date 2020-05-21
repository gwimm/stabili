extern var KERNEL_VADDR_END:      *u32;
extern var KERNEL_VADDR_START:    *u32;
extern var KERNEL_PHYSADDR_END:   *u32;
extern var KERNEL_PHYSADDR_START: *u32;
extern var KERNEL_ADDR_OFFSET:    *u32;

const Profile = struct {
    virt = []u8,
    phy  = []u8,
}

pub fn init() Profile {
    log.log(.Info, "init mem:\n", .{});
    return .{
        .virtual    = @ptrCast([KERNEL_VADDR_END - KERNEL_VADDR_START]u8, KERNEL_VADDR_START),
        .physical   = @ptrCast([KERNEL_PHYSADDR_END - KERNEL_PHYSADDR_START]u8, KERNEL_PHYSADDR_START),
    };
}