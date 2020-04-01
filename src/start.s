    extern kmain
    extern KSTACK_END

    section .text

    global entry:function
    global halt:function

entry:
    mov esp, KSTACK_END
    call kmain

halt:
    cli
    hlt
    jmp halt