// const boot      = @import("boot.zig");
// const multiboot = @import("multiboot.zig");

export fn main(mb_magic: u32) void {
    if (mb_magic != 3) {
        return;
    }
}