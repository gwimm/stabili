pub const BOOTLOADER_MAGIC = 0x2BADB002;
pub const HEADER_MAGIC = 0x1BADB002;

pub const Header = extern struct {
    magic:          u32,
    flags:          u32,
    checksum:       u32,
    header_addr:    u32,
    load_addr:      u32,
    load_end_addr:  u32,
    bss_end_addr:   u32,
    entry_addr:     u32,
    mode_type:      u32,
    width:          u32,
    height:         u32,
    depth:          u32,
};

pub const SymbolTable = extern struct {
    tabsize:    u32,
    strsize:    u32,
    addr:       u32,
    reserved:   u32,
};

pub const SectionTable = extern struct {
    num:    u32,
    size:   u32,
    addr:   u32,
    shndx:  u32,
};

pub const Info = extern struct {
    flags:          u32,
    mem_lower:      u32,
    mem_upper:      u32,
    boot_device:    u32,
    cmd_line:       u32,

    module_count:   u32,
    module_addr:    u32,

    u: extern union {
        aout_symbols: SymbolTable,
        elf_sections: SectionTable,
    },

    mmap_length:        u32,
    mmap_addr:          u32,

    drives_length:      u32,
    drives_addr:        u32,

    config_table:       u32,
    boot_loader_name:   u32,
    apm_table:          u32,

    vbe_control_info:   u32,
    vbe_mode_info:      u32,
    vbe_mode:           u16,
    vbe_interface_seg:  u16,
    vbe_interface_off:  u16,
    vbe_interface_len:  u16,

    framebuffer_addr:   u64,
    framebuffer_pitch:  u32,
    framebuffer_width:  u32,
    framebuffer_height: u32,
    framebuffer_bpp:    u8,
    framebuffer_type:   u8,
    framebuffer: extern union {
        palette: extern struct {
            addr:       u32,
            num_colors: u16,
        },
        colours: extern struct {
            red_field_position:     u8,
            red_mask_size:          u8,
            green_field_position:   u8,
            green_mask_size:        u8,
            blue_field_position:    u8,
            blue_mask_size:         u8,
        },
    },
};

pub const ModuleList = extern struct {
    start:      u32,
    end:        u32,
    cmd_line:   u32,
    padding:    u32,
};

pub const MemoryMapEntry = extern struct {
    size:   u32,
    addr:   u32,
    length: u32,
    type:   u32,
};