# ifndef    __ISR_H__
# define    __ISR_H__

struct int_ctx {
   u32 ds;                                      // isr_com_stub
   u32 edi, esi, ebp, esp, ebx, edx, ecx, eax;  // by pusha
   u32 int_num, err_code;                       // isr_n
   u32 eip, cs, eflags, useresp, ss;            // by cpu
};

extern void isr_0();
extern void isr_1();
extern void isr_2();
extern void isr_3();
extern void isr_4();
extern void isr_5();
extern void isr_6();
extern void isr_7();
extern void isr_8();
extern void isr_9();
extern void isr_10();
extern void isr_11();
extern void isr_12();
extern void isr_13();
extern void isr_14();
extern void isr_15();
extern void isr_16();
extern void isr_17();
extern void isr_18();
extern void isr_19();
extern void isr_20();
extern void isr_21();
extern void isr_22();
extern void isr_23();
extern void isr_24();
extern void isr_25();
extern void isr_26();
extern void isr_27();
extern void isr_28();
extern void isr_29();
extern void isr_30();
extern void isr_31();

# endif // !__ISR_H__