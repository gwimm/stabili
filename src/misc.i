    SEGMENT_CODE equ 0x08
    SEGMENT_DATA equ 0x10

%macro stmra 2-*
    %rep %0
            push %1
        %rotate 1
    %endrep
%endmacro

%macro stmrd 2-*
    %rep %0
        %rotate -1
            push %1
    %endrep
%endmacro

%macro ldmra 2-*
    %rep %0
            pop %1
        %rotate 1
    %endrep
%endmacro

%macro ldmrd 2-*
    %rep %0
        %rotate -1
            pop %1
    %endrep
%endmacro

%macro mvmr 2-*
    %rotate -1
        mov eax, %1
    %rep %0 - 1
        %rotate 1
            mov %1, eax
    %endrep
%endmacro