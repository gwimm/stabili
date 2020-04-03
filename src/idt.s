    global lidt:function
lidt:
    mov eax, dword [esp + 4]
    lidt [eax]
    ret