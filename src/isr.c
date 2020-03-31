# include "intdef.h"
# include "lib.h"

struct registers {
   u32 ds;                                      // isr_com_stub
   u32 edi, esi, ebp, esp, ebx, edx, ecx, eax;  // by pusha
   u32 int_num, err_code;                       // isr_n
   u32 eip, cs, eflags, useresp, ss;            // by cpu
};

char *except_msg[] = {
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

void isr_handler(struct registers reg) {
    k_fmt("int received '%x', %s\n",
        reg.int_num,
        except_msg[reg.int_num]);
}