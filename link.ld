ENTRY(_start)

SECTIONS {
    .boot.rodata ALIGN(4K) : { *(.boot.rodata*) }

    . = 1M;

    .text   ALIGN(4K) : { *(.text*) }
    .rodata ALIGN(4K) : { *(.rodata*) }
    .data   ALIGN(4K) : { *(.data*) }
    .bss    ALIGN(4K) : {
        *(COMMON)
        *(.bss*)
    }

    .bss.stack ALIGN(4K) : {
        *(.bss.stack*)
        KSTACK_END = .;
    }
}