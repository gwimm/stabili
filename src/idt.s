    global idt_load:function
idt_load:
    mov eax, dword [esp + 4]
    lidt [eax]
    ret