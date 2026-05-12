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
        .text
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
        subq    $40, %rsp
        .cfi_def_cfa_offset 96
        movq    %rsi, %rbx
        cmpl    $2, %edi
        je      .L2
        movq    (%rsi), %rdx
        movl    $.LC0, %esi
movq    stderr(%rip), %rdi
        movl    $0, %eax
        call    fprintf
        movl    $1, %eax
.L1:
        addq    $40, %rsp
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
        call    fopen
        movq    %rax, 8(%rsp)
        movl    $0, %r15d
        testq   %rax, %rax
        jne     .L4
        movq    8(%rbx), %rdi
        call    perror
        movl    $1, %eax
        jmp     .L1
.L5:
        movl    $.LC4, %edi
        movl    $0, %eax
        call    printf
.L6:
        cmpl    $7, %ebx
        je      .L20
        leal    1(%rbx), %eax
        cmpl    $15, %eax
        jg      .L9
.L8:
        addq    $1, %rbx
.L10:
        cmpq    %rbx, %rbp
        jbe     .L5
        movzbl  16(%rsp,%rbx), %esi
        movl    $.LC3, %edi
        movl    $0, %eax
        call    printf
        jmp     .L6
.L20:
        movl    $32, %edi
        call    putchar
        jmp     .L8
.L9:
        movl    $.LC5, %edi
        movl    $0, %eax
        call    printf
        testl   %ebp, %ebp
        jle     .L11
        call    __ctype_b_loc
        movq    %rax, %r12
        leaq    16(%rsp), %rbx
        leal    -1(%rbp), %eax
        leaq    17(%rsp,%rax), %r14
        movl    $46, %r13d
.L13:
        movzbl  (%rbx), %edi
        movzbl  %dil, %edx
        movq    (%r12), %rax
        testb   $64, 1(%rax,%rdx,2)
        cmove   %r13d, %edi
        movzbl  %dil, %edi
        movq    stdout(%rip), %rsi
        call    putc
        addq    $1, %rbx
        cmpq    %r14, %rbx
        jne     .L13
.L11:
        movl    $.LC6, %edi
        call    puts
        addq    %rbp, %r15
.L4:
        movq    8(%rsp), %rcx
        movl    $16, %edx
        movl    $1, %esi
        leaq    16(%rsp), %rdi
        call    fread
        movq    %rax, %rbp
        testq   %rax, %rax
        je      .L21
        movq    %r15, %rsi
        movl    $.LC2, %edi
        movl    $0, %eax
        call    printf
        movl    $0, %ebx
        jmp     .L10
.L21:
        movq    %r15, %rsi
        movl    $.LC7, %edi
        movl    $0, %eax
        call    printf
        movq    8(%rsp), %rdi
        call    fclose
        movl    $0, %eax
        jmp     .L1
        .cfi_endproc
.LFE25:
        .size   main, .-main
        .ident  "GCC: (GNU) 11.5.0 20240719 (Red Hat 11.5.0-5)"
        .section        .note.GNU-stack,"",@progbits
