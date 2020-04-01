ENTRY(entry)
/* OUTPUT_FORMAT(elf64-x86-64) */
SECTIONS {
    .multiboot ALIGN(4K) : { *(.multiboot*) }

    . = 1M;

    .text   ALIGN(4K) : { *(.text*) }
    .rodata ALIGN(4K) : { *(.rodata*) }
    .data   ALIGN(4K) : { *(.data*) }
    .bss    ALIGN(4K) : { *(.bss*) }

    .bss.stack ALIGN(4K) : {
        *(.bss.stack)
        KSTACK_END = .;
    }
}