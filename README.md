DOCUMENTATION ON THE EXECUTION OF hexdump.c


USAGE:

./hexdump binary.out

COMPILE EXAMPLES:

gcc -O0 -S -o hexdump_O0.s hexdump.c   no optimisation

gcc -O1 -S -o hexdump_O1.s hexdump.c   light optimisation

gcc -O3 -S -o hexdump_O3.s hexdump.c   heavy optimisation

gcc -O0 -o hexdump hexdump.c           build runnable binary


















DOCUMENTATION ON THE EXECUTION OF double.s

1. as -o double.o double.s
2. ld -o double double.o
3. ./double

Test with any integer value positive or negative including 0.

ex. 

as -o double.o double.s

ld -o double double.o

./double

Enter a number: 7 (user input)

The double is: 14 (output)

