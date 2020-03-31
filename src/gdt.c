# include "gdt.h"

# include "intdef.h"
# include "misc.h"

struct gdt_entry gdt[3] = {
    {0},
    (struct gdt_entry) {
        .base_0 = 0,
        .base_1 = 0,
        .base_2 = 0,

        .len_0 = 0xFFFF,
        .len_1 = 0xF,

        .type = GDT_TYPE_CODE,
        .desc_type = 1,
        .dpl = GDT_RING_0,
        .present = true,

        .zero = 0,
        .available = false,
        .granularity = GDT_GRANULARITY_1B,
        .op_size = GDT_OP_SIZE_32,
    },
    (struct gdt_entry) {
        .base_0 = 0,
        .base_1 = 0,
        .base_2 = 0,

        .len_0 = 0xFFFF,
        .len_1 = 0xF,

        .type = GDT_TYPE_DATA,
        .desc_type = 1,
        .dpl = GDT_RING_0,
        .present = true,

        .zero = 0,
        .available = false,
        .granularity = GDT_GRANULARITY_1B,
        .op_size = GDT_OP_SIZE_32,
    },
};

struct gdt_ptr gdtd = (struct gdt_ptr) {
    .limit = sizeof(gdt) - 1,
    .base = (void*)&gdt,
};