# double.s
# Description : Reads an integer from stdin, doubles it and prints the result
#
# How to build:
#   as -o double.o double.s
#   ld -o double double.o
#
# How to run:
#   echo 7 | ./double
#   ./double  type a number and enter

# Read-only data 
.section .rodata
prompt:     .ascii "Enter a number: "
prompt_len = . - prompt

label:      .ascii "The double is: "
label_len  = . - label

newline:    .byte  '\n'

# Uninitialized data
.section .bss
.lcomm input_buf,  32    # raw bytes read from stdin
.lcomm output_buf, 32    # ASCII digits of the result

# Program
.section .text
.globl _start

_start:
    
    # Print prompt to stdout
    
    mov     $1,          %rax    # syscall: write
    mov     $1,          %rdi    # fd = stdout
    lea     prompt(%rip),%rsi    # buffer address
    mov     $prompt_len, %rdx    # byte count
    syscall

    
    # Read a line of text from stdin into input_buf
    
    mov     $0,              %rax   # syscall: read
    mov     $0,              %rdi   # fd = stdin
    lea     input_buf(%rip), %rsi   # destination buffer
    mov     $31,             %rdx   # max bytes (leave room for NUL)
    syscall
    # rax now holds number of bytes actually read

   
    # 3. Convert ASCII string → integer  (atoi)
    #    Handles an optional leading - if the int is negative, then decimal digits
    #    Result lands in %rbx.
 
    lea     input_buf(%rip), %rsi   # pointer walks through the buffer
    xor     %rbx, %rbx             # accumulator = 0
    xor     %r8,  %r8              # r8 = sign flag (0 = positive)

check_sign:
    movzbq  (%rsi), %rax           # load first character
    cmp     $'-',   %al
    jne     atoi_loop
    mov     $1,     %r8            # negative flag set
    inc     %rsi                   # skip the -

atoi_loop:
    movzbq  (%rsi), %rax           # load next character
    cmp     $'0',   %al            # below 0 = not a digit
    jl      atoi_done
    cmp     $'9',   %al            # above 9 = not a digit
    jg      atoi_done
    sub     $'0',   %al            # ASCII → numeric value
    imul    $10,    %rbx           # accumulator *= 10
    add     %rax,   %rbx           # accumulator += digit
    inc     %rsi                   # advance pointer
    jmp     atoi_loop

atoi_done:
    test    %r8, %r8               # checks if the number is negative
    jz      do_double
    neg     %rbx                   # apply the proper sign


    # 4. Double the value

do_double:
    imul    $2, %rbx               # rbx = value * 2

  
    # 5. Print label: "The double is: "

    mov     $1,          %rax
    mov     $1,          %rdi
    lea     label(%rip), %rsi
    mov     $label_len,  %rdx
    syscall

   
    # 6. Convert integer → ASCII string  (itoa)
    # We write digits into output_buf from right to left, then shift the slice to the front so we can write() it easily

    lea     output_buf(%rip), %rdi  # base of output buffer
    mov     %rbx,  %rax             # value to convert
    xor     %rcx,  %rcx             # digit counter
    xor     %r9,   %r9             # r9 = was-negative flag

    test    %rax, %rax
    jns     itoa_positive
    mov     $1,   %r9              # remember it was negative
    neg     %rax                   # work with absolute value

itoa_positive:
    # Special case: value is 0
    test    %rax, %rax
    jnz     itoa_loop
    movb    $'0', (%rdi)
    inc     %rdi
    inc     %rcx
    jmp     itoa_write_sign

    # Extract digits (stored in reverse order in the buffer)
itoa_loop:
    test    %rax, %rax
    jz      itoa_reverse
    xor     %rdx, %rdx             # clear high half for div
    movq    $10,  %r10
    div     %r10                   # rax = quotient, rdx = remainder
    add     $'0', %dl              # remainder → ASCII
    mov     %dl,  (%rdi)           # store digit
    inc     %rdi
    inc     %rcx                   # count this digit
    jmp     itoa_loop

    # Reverse the digits in-place so they read left-to-right
itoa_reverse:
    lea     output_buf(%rip), %rsi  # left  pointer
    lea     -1(%rdi),         %rdi  # right pointer (last digit written)

reverse_loop:
    cmp     %rsi, %rdi
    jle     itoa_write_sign
    movb    (%rsi), %al
    movb    (%rdi), %bl
    movb    %bl,    (%rsi)
    movb    %al,    (%rdi)
    inc     %rsi
    dec     %rdi
    jmp     reverse_loop

itoa_write_sign:
    # If negative, add - first by shifting buffer right one byte
    test    %r9, %r9
    jz      print_number

    lea     output_buf(%rip), %rsi
    mov     %rcx, %r10             # save digit count
    add     %rcx, %rsi             # point one past last digit
    inc     %rcx                   # total length now includes -

shift_loop:
    test    %r10, %r10
    jz      place_minus
    movb    -1(%rsi), %al
    movb    %al,       (%rsi)
    dec     %rsi
    dec     %r10
    jmp     shift_loop

place_minus:
    movb    $'-', (%rsi)

  
    # 7. Write the number string to stdout

print_number:
    mov     $1,               %rax
    mov     $1,               %rdi
    lea     output_buf(%rip), %rsi
    mov     %rcx,             %rdx  # byte count = number of digits
    syscall


    # 8. Write newline

    mov     $1,              %rax
    mov     $1,              %rdi
    lea     newline(%rip),   %rsi
    mov     $1,              %rdx
    syscall


    # 9. Exit

    mov     $60, %rax    # syscall: exit
    xor     %rdi, %rdi   # exit code 0
    syscall
