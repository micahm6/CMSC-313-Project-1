        .file   "hexdump.c"
        .text
        .section        .rodata.str1.1,"aMS",@progbits,1
.LC0:
        .string "Usage: %s <filename>\n"
.LC1:
        .string "rb"
.LC2:
        .string "%08lx  "
.LC3:
        .string "%02x "
.LC4:
        .string "   "
.LC5:
        .string " |"
.LC6:
        .string "|"
.LC7:
        .string "%08lx\n"
        .section        .text.startup,"ax",@progbits
        .p2align 4
        .globl  main
        .type   main, @function
main:
.LFB25:
        .cfi_startproc
        pushq   %r15
        .cfi_def_cfa_offset 16
        .cfi_offset 15, -16
        pushq   %r14
        .cfi_def_cfa_offset 24
        .cfi_offset 14, -24
        pushq   %r13
        .cfi_def_cfa_offset 32
        .cfi_offset 13, -32
        pushq   %r12
        .cfi_def_cfa_offset 40
        .cfi_offset 12, -40
        pushq   %rbp
        .cfi_def_cfa_offset 48
        .cfi_offset 6, -48
        pushq   %rbx
        .cfi_def_cfa_offset 56
        .cfi_offset 3, -56
        movq    %rsi, %rbx
        subq    $24, %rsp
        .cfi_def_cfa_offset 80
        cmpl    $2, %edi
        je      .L2
        movq    (%rsi), %rdx
movq    stderr(%rip), %rdi
        movl    $.LC0, %esi
        xorl    %eax, %eax
        call    fprintf
        movl    $1, %eax
.L1:
        addq    $24, %rsp
        .cfi_remember_state
        .cfi_def_cfa_offset 56
        popq    %rbx
        .cfi_def_cfa_offset 48
        popq    %rbp
        .cfi_def_cfa_offset 40
        popq    %r12
        .cfi_def_cfa_offset 32
        popq    %r13
        .cfi_def_cfa_offset 24
        popq    %r14
        .cfi_def_cfa_offset 16
        popq    %r15
        .cfi_def_cfa_offset 8
        ret
.L2:
        .cfi_restore_state
        movq    8(%rsi), %rdi
        movl    $.LC1, %esi
        xorl    %r12d, %r12d
        call    fopen
        movq    %rax, %r13
        testq   %rax, %rax
        je      .L21
        .p2align 4,,10
        .p2align 3
.L4:
        movl    $1, %esi
        movq    %r13, %rcx
        movl    $16, %edx
        movq    %rsp, %rdi
        call    fread
        movq    %r12, %rsi
        movq    %rax, %rbp
        testq   %rax, %rax
        je      .L22
        movl    $.LC2, %edi
        xorl    %eax, %eax
        xorl    %ebx, %ebx
        call    printf
        jmp     .L10
.p2align 4,,10
        .p2align 3
.L24:
        movzbl  (%rsp,%rbx), %esi
        xorl    %eax, %eax
        movl    $.LC3, %edi
        call    printf
        cmpq    $7, %rbx
        je      .L23
.L7:
        cmpq    $15, %rbx
        je      .L9
.L8:
        addq    $1, %rbx
.L10:
        cmpq    %rbx, %rbp
        ja      .L24
        xorl    %eax, %eax
        movl    $.LC4, %edi
        call    printf
        cmpq    $7, %rbx
        jne     .L7
.L23:
        movl    $32, %edi
        call    putchar
        jmp     .L8
        .p2align 4,,10
        .p2align 3
.L9:
        xorl    %eax, %eax
        movl    $.LC5, %edi
        call    printf
        testl   %ebp, %ebp
        jle     .L14
        call    __ctype_b_loc
        leal    -1(%rbp), %r14d
        movq    %rsp, %rbx
        movq    %rax, %r15
        leaq    1(%rsp), %rax
        addq    %rax, %r14
        .p2align 4,,10
        .p2align 3
.L15:
        movzbl  (%rbx), %edx
        movq    (%r15), %rax
        movq    stdout(%rip), %rsi
        movq    %rdx, %rdi
        testb   $64, 1(%rax,%rdx,2)
        je      .L12
        call    putc
        addq    $1, %rbx
        cmpq    %r14, %rbx
        jne     .L15
.L14:
        movl    $.LC6, %edi
        addq    %rbp, %r12
        call    puts
        jmp     .L4
        .p2align 4,,10
        .p2align 3
.L12:
        movl    $46, %edi
        addq    $1, %rbx
        call    putc
        cmpq    %rbx, %r14
        jne     .L15
        movl    $.LC6, %edi
        addq    %rbp, %r12
        call    puts
        jmp     .L4
.L22:
        movl    $.LC7, %edi
        xorl    %eax, %eax
        call    printf
        movq    %r13, %rdi
        call    fclose
        xorl    %eax, %eax
        jmp     .L1
.L21:
        movq    8(%rbx), %rdi
        call    perror
        movl    $1, %eax
        jmp     .L1
        .cfi_endproc
.LFE25:
        .size   main, .-main
        .ident  "GCC: (GNU) 11.5.0 20240719 (Red Hat 11.5.0-5)"
        .section        .note.GNU-stack,"",@progbits
