%include "src/misc.i"

    global gdt_load:function
gdt_load:
    mov eax, dword [esp + 4]
    lgdt [eax]
    mvmr ds, es, fs, gs, ss, SEGMENT_DATA
    jmp SEGMENT_CODE:.init_pm
    .init_pm:
    ret