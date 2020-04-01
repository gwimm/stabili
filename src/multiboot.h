# ifndef  __MULTIBOOT_H__
# define  __MULTIBOOT_H__

# include "intdef.h"

// how many bytes from the start of the file we search for the header
# define MULTIBOOT_SEARCH                        8192

# define MULTIBOOT_HEADER_ALIGN                  4
# define MULTIBOOT_INFO_ALIGN                    4
# define MULTIBOOT_MOD_ALIGN                     0x00001000

// this should be in %eax
# define MULTIBOOT_BOOTLOADER_MAGIC              0x2BADB002

struct multiboot_header {
    # define MULTIBOOT_HEADER_MAGIC 0x1BADB002
    u32 magic; // must be ^

    # define MULTIBOOT_PAGE_ALIGN   0x00000001
    # define MULTIBOOT_MEMORY_INFO  0x00000002
    # define MULTIBOOT_VIDEO_MODE   0x00000004
    # define MULTIBOOT_AOUT_KLUDGE  0x00010000
    u32 flags;
    u32 checksum; // checksum = -(flags + magic)

    // valid if MULTIBOOT_AOUT_KLUDGE set
    u32 header_addr;
    u32 load_addr;
    u32 load_end_addr;
    u32 bss_end_addr;
    u32 entry_addr;

    // valid if MULTIBOOT_VIDEO_MODE set
    u32 mode_type;
    u32 width;
    u32 height;
    u32 depth;
};

// a.out symbol table
struct multiboot_aout_symbol_table {
    u32 tabsize;
    u32 strsize;
    u32 addr;
    u32 reserved;
};

// ELF section header table
struct multiboot_elf_section_header_table {
    u32 num;
    u32 size;
    u32 addr;
    u32 shndx;
};

struct multiboot_info {
    # define MULTIBOOT_INFO_MEMORY              0x00000001
    # define MULTIBOOT_INFO_BOOTDEV             0x00000002
    # define MULTIBOOT_INFO_CMDLINE             0x00000004
    # define MULTIBOOT_INFO_MODS                0x00000008
    # define MULTIBOOT_INFO_AOUT_SYMS           0x00000010
    # define MULTIBOOT_INFO_ELF_SHDR            0X00000020
    # define MULTIBOOT_INFO_MEM_MAP             0x00000040
    # define MULTIBOOT_INFO_DRIVE_INFO          0x00000080
    # define MULTIBOOT_INFO_CONFIG_TABLE        0x00000100
    # define MULTIBOOT_INFO_BOOT_LOADER_NAME    0x00000200
    # define MULTIBOOT_INFO_APM_TABLE           0x00000400
    # define MULTIBOOT_INFO_VBE_INFO            0x00000800
    # define MULTIBOOT_INFO_FRAMEBUFFER_INFO    0x00001000
    u32 flags;

    // available memory from BIOS
    u32 mem_lower;
    u32 mem_upper;

    u32 boot_device; // "root" partition
    u32 cmdline; // Kernel command line

    // Boot-Module list
    u32 mods_count;
    u32 mods_addr;

    union {
        struct multiboot_aout_symbol_table aout_sym;
        struct multiboot_elf_section_header_table elf_sec;
    };

    // memory mapping buffer
    u32 mmap_length;
    u32 mmap_addr;

    // drive info buffer
    u32 drives_length;
    u32 drives_addr;

    u32 rom_config_table;
    u32 boot_loader_name;
    u32 apm_table;

    // Video
    u32 vbe_control_info;
    u32 vbe_mode_info;
    u16 vbe_mode;
    u16 vbe_interface_seg;
    u16 vbe_interface_off;
    u16 vbe_interface_len;

    u64 framebuffer_addr;
    u32 framebuffer_pitch;
    u32 framebuffer_width;
    u32 framebuffer_height;
    u8 framebuffer_bpp;

    # define MULTIBOOT_FRAMEBUFFER_TYPE_INDEXED     0
    # define MULTIBOOT_FRAMEBUFFER_TYPE_RGB         1
    # define MULTIBOOT_FRAMEBUFFER_TYPE_EGA_TEXT    2
    u8 framebuffer_type;
    union {
        struct {
            u32 palette_addr;
            u16 palette_num_colors;
        };
        struct {
            u8 red_field_position;
            u8 red_mask_size;
            u8 green_field_position;
            u8 green_mask_size;
            u8 blue_field_position;
            u8 blue_mask_size;
        };
    } framebuffer;
};

struct multiboot_color {
    u8 red;
    u8 green;
    u8 blue;
};

struct multiboot_mmap_entry {
    u32 size;
    u64 addr;
    u64 len;
    # define MULTIBOOT_MEMORY_AVAILABLE         1
    # define MULTIBOOT_MEMORY_RESERVED          2
    # define MULTIBOOT_MEMORY_ACPI_RECLAIMABLE  3
    # define MULTIBOOT_MEMORY_NVS               4
    # define MULTIBOOT_MEMORY_BADRAM            5
    u32 type;
};

struct multiboot_mod_list {
  // the memory used goes from bytes ’mod_start’ to ’mod_end-1’ inclusive
  u32 mod_start;
  u32 mod_end;

  u32 cmdline;  // Module command line
  u32 pad;      // must be 0
};
typedef struct multiboot_mod_list multiboot_module_t;

struct multiboot_apm_info {
  u16 version;
  u16 cseg;
  u32 offset;
  u16 cseg_16;
  u16 dseg;
  u16 flags;
  u16 cseg_len;
  u16 cseg_16_len;
  u16 dseg_len;
};

# endif // !__MULTIBOOT_H__