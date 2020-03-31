%if 0
    global port_in
    global port_out

port_in:
    mov edx, edi
    out ax, dx
    ret

port_out:
    mov eax, esi
    mov edx, edi
    out dx, al
    ret
%endif