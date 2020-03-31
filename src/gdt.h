# ifndef   __GDT_H__
# define   __GDT_H__

# include "misc.h"

struct gdt_entry {
    u16 len_0;
    u16 base_0;
    u8  base_1;
    union {
        u8 access;
        struct {
            # define GDT_TYPE_CODE 0xA
            # define GDT_TYPE_DATA 0x2
            u8  type : 4;
            u8  desc_type : 1;
            # define GDT_RING_0 0
            # define GDT_RING_1 1
            # define GDT_RING_2 2
            # define GDT_RING_3 3
            u8  dpl : 2;
            u8  present : 1;
        };
    } packed;
    union {
        struct {
            u8  len_1 : 4;
            u8  zero : 1;           // always 0
            u8  available : 1;      // always 0
            # define GDT_GRANULARITY_4K 0
            # define GDT_GRANULARITY_1B 1
            u8  granularity : 1;
            # define GDT_OP_SIZE_16 0
            # define GDT_OP_SIZE_32 1
            u8  op_size : 1;
        } packed;
    };        
    u8  base_2;
} packed;

struct gdt_ptr {
    u16 limit;
    struct gdt_entry* base;
} packed;

extern void gdt_load(void);

# endif // __GDT_H__