    extern isr_handler

%include "src/misc.i"

%macro isr_def 1-*
    %assign n 0
    %rep %1
            global isr_%[n]:function
        isr_%[n]:
            cli
        %if n != %2
            push 0  ; int_num
        %else
            %rotate 1
        %endif
            push n  ; err_num
            jmp isr_com_stub
        %assign n n + 1
    %endrep
%endmacro

    isr_def 32, 8, 10, 11, 12, 13, 14

isr_com_stub:
    ; pusha
    ; stmra ds, es, fs, gs
    ; mvmr ds, es, fs, gs, SEGMENT_DATA

    ; mov eax, esp
    ; push eax

    ; call isr_handler
    ; ldmrd ds, es, fs, gs, eax
    ; popa

    add esp, 8  ; clean up isr_[n]

    iret