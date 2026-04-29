.section .data
message:    .ascii "Enter a number: "
messgae_len = . - message
label:     .ascii "The double is: "
label_len  = . - label
newline:   .byte '\n'

.section .bss
.lcomm input_buf,   32
.lcomm output_buf,  32
.lcomm digit_count, 4
.lcomm neg_flag,    4

.section .text
.globl _start

_start:
    movl  $4,          %eax
    movl  $1,          %ebx
    movl  $prompt,     %ecx
    movl  $prompt_len, %edx
    int   $0x80

    movl  $3,         %eax
    movl  $0,         %ebx
    movl  $input_buf, %ecx
    movl  $31,        %edx
    int   $0x80

    movl  $input_buf, %esi
    xorl  %ebx, %ebx
    xorl  %edi, %edi

check_sign:
    movzbl (%esi), %eax
    cmpb   $45,   %al
    jne    atoi_loop
    movl   $1,    %edi
    incl   %esi

atoi_loop:
    movzbl (%esi), %eax
    cmpb   $48,   %al
    jl     atoi_done
    cmpb   $57,   %al
    jg     atoi_done
    subb   $48,   %al
    imull  $10,   %ebx
    addl   %eax,  %ebx
    incl   %esi
    jmp    atoi_loop

atoi_done:
    testl  %edi, %edi
    jz     do_double
    negl   %ebx

do_double:
    imull  $2, %ebx

    pushl  %ebx
    movl   $4,         %eax
    movl   $1,         %ebx
    movl   $label,     %ecx
    movl   $label_len, %edx
    int    $0x80
    popl   %ebx

    movl   $output_buf, %edi
    movl   %ebx,        %eax
    xorl   %ecx, %ecx
    movl   $0,   neg_flag

    testl  %eax, %eax
    jns    itoa_pos
    movl   $1,   neg_flag
    negl   %eax

itoa_pos:
    testl  %eax, %eax
    jnz    itoa_loop
    movb   $48, (%edi)
    incl   %edi
    incl   %ecx
    jmp    save_count

itoa_loop:
    testl  %eax, %eax
    jz     itoa_rev
    xorl   %edx, %edx
    movl   $10,  %ebx
    divl   %ebx
    addb   $48,  %dl
    movb   %dl,  (%edi)
    incl   %edi
    incl   %ecx
    jmp    itoa_loop

itoa_rev:
    movl   $output_buf, %esi
    leal   -1(%edi),    %edi

rev_loop:
    cmpl   %esi, %edi
    jle    check_neg
    movb   (%esi), %al
    movb   (%edi), %bl
    movb   %bl,    (%esi)
    movb   %al,    (%edi)
    incl   %esi
    decl   %edi
    jmp    rev_loop

check_neg:
    cmpl   $0, neg_flag
    je     save_count
    movl   $output_buf, %esi
    movl   %ecx,        %ebx
    addl   %ecx,        %esi
    incl   %ecx

shift_loop:
    testl  %ebx, %ebx
    jz     place_minus
    movb   -1(%esi), %al
    movb   %al,      (%esi)
    decl   %esi
    decl   %ebx
    jmp    shift_loop

place_minus:
    movb   $45, (%esi)

save_count:
    movl   %ecx, digit_count

print_number:
    movl   $4,          %eax
    movl   $1,          %ebx
    movl   $output_buf, %ecx
    movl   digit_count, %edx
    int    $0x80

    movl   $4,       %eax
    movl   $1,       %ebx
    movl   $newline, %ecx
    movl   $1,       %edx
    int    $0x80

    movl   $1, %eax
    xorl   %ebx, %ebx
    int    $0x80