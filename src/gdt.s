%include "src/misc.i"

    extern gdtd

struc struct_gdt_entry

	limit_low:   resb 2
	base_low:    resb 2
	base_middle: resb 1
	access:      resb 1
	granularity: resb 1
	base_high:   resb 1
endstruc

    global gdt_load

gdt_load:
    lgdt [gdtd]
    jmp SEGMENT_CODE:.init_pm
    .init_pm:

    mov ax, SEGMENT_DATA
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ret