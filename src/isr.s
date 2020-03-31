    extern isr_handler

%include "src/misc.i"

%macro isr_def 1-*
    %assign i 0
    %rep %1
            global isr_%[i]
        isr_%[i]:
        %if i != %2
            push 0  ; int_num
        %else
            %rotate 1
        %endif
            push i  ; err_num
            call isr_com_stub
        %assign i i+1
    %endrep
%endmacro

    isr_def 32, 8, 10, 11, 12, 13, 14

isr_com_stub:
    pusha

    push ds
    push es
    push fs
    push gs
    push eax

    mov ax, SEGMENT_DATA
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    call isr_handler

    pop eax 
    pop gs
    pop fs
    pop es
    pop ds

    popa

    add esp, 8  ; clean err_num, int_num
    iret        ; pop cs, eip, eflags, ss, esp; ret