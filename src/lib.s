    global port_in:function
    global port_out:function

port_in:
    movzx edx, word [esp + 4]
    ret

port_out:
    mov al, byte [esp + 8]
    movzx edx, word [esp + 4]
    out dx, al
    ret