ENTRY(entry)

SECTIONS {
    . = 1M;

    .multiboot ALIGN(4K) : { KEEP(*(.multiboot*)) }

    .text   ALIGN(4K) : { *(.text*) }
    .rodata ALIGN(4K) : { *(.rodata*) }
    .data   ALIGN(4K) : { *(.data*) }
    .bss    ALIGN(4K) : {
        *(COMMON)
        *(.bss*)
    }

    .bss.stack ALIGN(4K) : {
        *(.bss.stack*)
        KERNEL_STACK_END = .;
    }
}