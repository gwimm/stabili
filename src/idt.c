# include "misc.h"
# include "intdef.h"

struct idt_entry {
    u16 base_0;
    u16 sel;
    u8  zero;
    union {
        u8 flags;
        struct {
            u8 present : 1;
            u8 dpl : 2;
            u8 desc_type : 1;
            u8 type : 4;
        } packed;
    };
    u16 base_1;
} packed;

struct idt_ptr {
    u16 limit;
    struct idt_entry* base;
} packed;

#define IDT_ENTRIES 256

struct idt_entry idt[IDT_ENTRIES];
struct idt_ptr idtd = {
    .limit = sizeof(idt) - 1,
    .base = idt,
};