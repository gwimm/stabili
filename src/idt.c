# include "idt.h"
# include "isr.h"

struct idt_entry idt[IDT_ENTRIES] = {{0}};
struct idt_ptr idtd = {
    .limit = sizeof(idt) - 1,
    .base = (void*)&idt,
};

typedef void (*isr_t)(void);

union ptr_trunc {
    void* ptr;
    struct {
        u16 low_16, high_16;
    };
};

void idt_init(void) {
    const isr_t isrv[] = {
        isr_0,  isr_1,  isr_2,  isr_3,  isr_4,  isr_5,  isr_6,  isr_7,
        isr_8,  isr_9,  isr_10, isr_11, isr_12, isr_13, isr_14, isr_15,
        isr_16, isr_17, isr_18, isr_19, isr_20, isr_21, isr_22, isr_23,
        isr_24, isr_25, isr_26, isr_27, isr_28, isr_29, isr_30, isr_31,
    };

    for (usize i = 0; i < (sizeof(isrv)/sizeof(*isrv)); i++) {
        idt[i] = (struct idt_entry) {
            .base_0 = (union ptr_trunc){ .ptr = isrv[i] }.low_16,
            .base_1 = (union ptr_trunc){ .ptr = isrv[i] }.high_16,
            .sel = 0x08,

            // .flags = 0x8E,
            .type = IDT_GATE_INT,
            .desc_type = 0,
            .dpl = 0,
            .present = 1,
            .zero = 0,
        };
    }

    lidt(&idtd);
}