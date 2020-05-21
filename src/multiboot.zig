pub const BOOTLOADER_MAGIC: u32 = 0x2BADB002;
pub const HEADER_MAGIC:     u32 = 0x1BADB002;

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

    vbe: extern struct {
        control_info:   u32,
        mode_info:      u32,
        mode:           u16,
        interface_seg:  u16,
        interface_off:  u16,
        interface_len:  u16,
    },
    framebuffer: extern struct {
        addr:   u64,
        pitch:  u32,
        width:  u32,
        height: u32,
        bpp:    u8,
        _type:   u8,
        u: extern union {
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
    },

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