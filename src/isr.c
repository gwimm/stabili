# include "isr.h"

# include "intdef.h"
# include "misc.h"
# include "lib.h"

const char *except_msg[] = {
    "division by zero",
    "debug",
    "non maskable interrupt",
    "breakpoint",
    "into detected overflow",
    "out of bounds",
    "invalid opcode",
    "no coprocessor",

    "double fault",
    "coprocessor segment overrun",
    "bad tss",
    "segment not present",
    "stack fault",
    "general protection fault",
    "page fault",
    "unknown interrupt",

    "coprocessor fault",
    "alignment check",
    "machine check",
    "reserved",
    "reserved",
    "reserved",
    "reserved",
    "reserved",

    "reserved",
    "reserved",
    "reserved",
    "reserved",
    "reserved",
    "reserved",
    "reserved",
    "reserved",
};

void isr_handler(struct int_ctx ctx) {
    k_fmt(except_msg[ctx.int_num]);
    asm (
        "halt:;"
        "   cli;"
        "   hlt;"
        "   jmp halt;"
    );
}