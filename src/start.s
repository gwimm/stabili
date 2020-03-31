    global _start

    extern kmain
    extern gdt_load

    KERNEL_STACK_SIZE equ 4096

    section .bss
    align 4
kernel_stack:
    resb KERNEL_STACK_SIZE

    section .text
_start:
    mov esp, kernel_stack + KERNEL_STACK_SIZE
    call gdt_load

    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    call kmain
    .halt:
        cli
        hlt
        jmp .halt