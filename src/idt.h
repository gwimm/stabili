# ifndef    __IDT_H__
# define    __IDT_H__

# include "intdef.h"
# include "misc.h"

# define IDT_ENTRIES 256

struct idt_entry {
    u16 base_0;
    u16 sel;
    u8  zero;
    union {
        u8 flags;
        struct {
            # define IDT_GATE_TASK  0x5
            # define IDT_GATE_INT   0xE
            # define IDT_GATE_TRAP  0xF
            u8 type : 4;
            u8 desc_type : 1;
            # define IDT_RING_0 0
            # define IDT_RING_1 1
            # define IDT_RING_2 2
            # define IDT_RING_3 3
            u8 dpl : 2;
            u8 present : 1;
        } packed;
    };
    u16 base_1;
} packed;

struct idt_ptr {
    u16 limit;
    struct idt_entry* base;
} packed;

extern void idt_load(struct idt_ptr*);

void idt_init(void);

# endif // !__IDT_H__