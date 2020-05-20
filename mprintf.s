.intel_syntax noprefix

.section .text
.global mprintf

mprintf_pow2:
    # Get argument from stack
    mov rax, [r9]

    # Get mask for digit
    mov r10,  1
    shl r10, cl
    sub r10, 1

    # We can't use rcx as counter
    xor rbx, rbx
    .pow2_digits_loop:
        mov rdx, rax
        and rdx, r10

        push rdx
        inc rbx

        shr rax, cl
        cmp rax, 0
        je .pow2_print

        jmp .pow2_digits_loop

    .pow2_print:
        mov rcx, rbx
        jmp mprintf_stack

mprintf_stack:
    pop rbx

    push rdi
    push rcx

    mov rax, 1
    mov rsi, offset digits
    add rsi, rbx
    mov rdi, 1
    mov rdx, 1
    syscall

    pop rcx
    pop rdi

    loop mprintf_stack

    jmp .format_string_loop

mprintf_default:
    push rdi

    mov rax, 1 # Syscal num
    mov rsi, rdi # Buffer
    mov rdi, 1 # File descriptor
    mov rdx, 1 # Bytes count
    syscall

    pop rdi

    jmp .format_string_loop

mprintf_decimal:
    # Get argument from stack
    mov rax, [r9]

    xor rcx, rcx
    .decimal_digits_loop:
        xor rdx, rdx
        mov r11, 0xA
        divq r11

        push rdx
        inc rcx

        cmp rax, 0
        je mprintf_stack

        jmp .decimal_digits_loop

mprintf_binary:
    xor rcx, rcx
    mov rcx, 1

    jmp mprintf_pow2

mprintf_octal:
    xor rcx, rcx
    mov rcx, 3

    jmp mprintf_pow2

mprintf_hexadecimal:
    xor rcx, rcx
    mov rcx, 4

    jmp mprintf_pow2

mprintf_string:
    mov rsi, [r9]
    push rsi

    dec rsi
    xor rcx, rcx
    .string_get_length:
        inc rsi
        mov al, byte ptr [rsi]

        cmp al, 0
        je .string_print

        inc rcx

        jmp .string_get_length

    .string_print:
        pop rsi
        push rdi

        mov rax, 1 # Syscal num
        mov rsi, rsi # Buffer
        mov rdi, 1 # File descriptor
        mov rdx, rcx # Bytes count
        syscall

        pop rdi

        jmp .format_string_loop

mprintf_character:
    push rdi

    mov rax, 1 # Syscal num
    mov rsi, r9 # Buffer
    mov rdi, 1 # File descriptor
    mov rdx, 1 # Bytes count
    syscall

    pop rdi

    jmp .format_string_loop

mprintf:
    # Save lr
    pop r11

    # Put register args on stack
    push r9
    push r8
    push rcx
    push rdx
    push rsi

    # Return lr on stack
    push r11

    # Prologue
    push rbx
    push rbp
    mov rbp, rsp

    # r9 is a pointer to current argument on stack
    mov r9, rbp
    add r9, 16

    # Iterate through format string
    dec rdi
    .format_string_loop:
        inc rdi
        mov al, byte ptr [rdi]

        # Is the end of C-style string
        cmp al, 0
        je .mprintf_return

        # Is the % before modifier
        cmp al, '%
        jne mprintf_default

        inc rdi
        mov al, byte ptr [rdi]

        # %% -> %
        cmp al, '%
        je mprintf_default

        # Take next argument
        add r9, 8

        # %d -> decimal
        cmp al, 'd
        je mprintf_decimal

        # %b -> binary
        cmp al, 'b
        je mprintf_binary

        # %o -> octal
        cmp al, 'o
        je mprintf_octal

        # %x -> hexadecimal
        cmp al, 'x
        je mprintf_hexadecimal
        
        # %s -> string
        cmp al, 's
        je mprintf_string

        # %c -> character
        cmp al, 'c
        je mprintf_character

    .mprintf_return:
        pop rbp
        pop rbx
        pop r11 # lr

        add rsp, 40
        push r11 # lr

        xor rax, rax

        ret

.section .data
digits: .ascii "0123456789ABCDEF"
