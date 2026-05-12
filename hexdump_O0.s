       .file   "hexdump.c"
        .text
        .section        .rodata
.LC0:
        .string "%08lx  "
.LC1:
        .string "%02x "
.LC2:
        .string "   "
.LC3:
        .string " |"
.LC4:
        .string "|"
.LC5:
        .string "%08lx\n"
        .text
        .type   print_hex_dump, @function
print_hex_dump:
.LFB6:
        .cfi_startproc
        pushq   %rbp
        .cfi_def_cfa_offset 16
        .cfi_offset 6, -16
        movq    %rsp, %rbp
        .cfi_def_cfa_register 6
        subq    $64, %rsp
        movq    %rdi, -56(%rbp)
        movq    $0, -8(%rbp)
        jmp     .L2
.L12:
        movq    -8(%rbp), %rax
        movq    %rax, %rsi
        movl    $.LC0, %edi
        movl    $0, %eax
        call    printf
        movl    $0, -12(%rbp)
        jmp     .L3
.L7:
        movl    -12(%rbp), %eax
        cltq
        cmpq    %rax, -24(%rbp)
        jbe     .L4
        movl    -12(%rbp), %eax
        cltq
        movzbl  -48(%rbp,%rax), %eax
        movzbl  %al, %eax
        movl    %eax, %esi
        movl    $.LC1, %edi
        movl    $0, %eax
        call    printf
        jmp     .L5
.L4:
        movl    $.LC2, %edi
        movl    $0, %eax
        call    printf
.L5:
        cmpl    $7, -12(%rbp)
        jne     .L6
        movl    $32, %edi
        call    putchar
.L6:
        addl    $1, -12(%rbp)
.L3:
        cmpl    $15, -12(%rbp)
        jle     .L7
        movl    $.LC3, %edi
        movl    $0, %eax
        call    printf
        movl    $0, -12(%rbp)
        jmp     .L8
.L11:
        call    __ctype_b_loc
        movq    (%rax), %rdx
        movl    -12(%rbp), %eax
        cltq
        movzbl  -48(%rbp,%rax), %eax
        movzbl  %al, %eax
        addq    %rax, %rax
        addq    %rdx, %rax
        movzwl  (%rax), %eax
        movzwl  %ax, %eax
        andl    $16384, %eax
        testl   %eax, %eax
        je      .L9
        movl    -12(%rbp), %eax
        cltq
        movzbl  -48(%rbp,%rax), %eax
        movzbl  %al, %eax
        jmp     .L10
.L9:
        movl    $46, %eax
.L10:
        movl    %eax, %edi
        call    putchar
        addl    $1, -12(%rbp)
.L8:
        movq    -24(%rbp), %rax
        cmpl    %eax, -12(%rbp)
        jl      .L11
        movl    $.LC4, %edi
        call    puts
        movq    -24(%rbp), %rax
        addq    %rax, -8(%rbp)
.L2:
        movq    -56(%rbp), %rdx
        leaq    -48(%rbp), %rax
        movq    %rdx, %rcx
        movl    $16, %edx
        movl    $1, %esi
        movq    %rax, %rdi
        call    fread
        movq    %rax, -24(%rbp)
        cmpq    $0, -24(%rbp)
        jne     .L12
        movq    -8(%rbp), %rax
        movq    %rax, %rsi
        movl    $.LC5, %edi
        movl    $0, %eax
        call    printf
        nop
        leave
        .cfi_def_cfa 7, 8
        ret
.cfi_endproc
.LFE6:
        .size   print_hex_dump, .-print_hex_dump
        .section        .rodata
.LC6:
        .string "Usage: %s <filename>\n"
.LC7:
        .string "rb"
        .text
        .globl  main
        .type   main, @function
main:
.LFB7:
        .cfi_startproc
        pushq   %rbp
        .cfi_def_cfa_offset 16
        .cfi_offset 6, -16
        movq    %rsp, %rbp
        .cfi_def_cfa_register 6
        subq    $32, %rsp
        movl    %edi, -20(%rbp)
        movq    %rsi, -32(%rbp)
        cmpl    $2, -20(%rbp)
        je      .L14
        movq    -32(%rbp), %rax
        movq    (%rax), %rdx
        movq    stderr(%rip), %rax
        movl    $.LC6, %esi
        movq    %rax, %rdi
        movl    $0, %eax
        call    fprintf
        movl    $1, %eax
        jmp     .L15
.L14:
        movq    -32(%rbp), %rax
        addq    $8, %rax
        movq    (%rax), %rax
        movl    $.LC7, %esi
        movq    %rax, %rdi
        call    fopen
        movq    %rax, -8(%rbp)
        cmpq    $0, -8(%rbp)
        jne     .L16
        movq    -32(%rbp), %rax
        addq    $8, %rax
        movq    (%rax), %rax
        movq    %rax, %rdi
        call    perror
        movl    $1, %eax
        jmp     .L15
.L16:
        movq    -8(%rbp), %rax
        movq    %rax, %rdi
        call    print_hex_dump
        movq    -8(%rbp), %rax
        movq    %rax, %rdi
        call    fclose
        movl    $0, %eax
.L15:
        leave
        .cfi_def_cfa 7, 8
        ret
        .cfi_endproc
.LFE7:
        .size   main, .-main
        .ident  "GCC: (GNU) 11.5.0 20240719 (Red Hat 11.5.0-5)"
        .section        .note.GNU-stack,"",@progbits
