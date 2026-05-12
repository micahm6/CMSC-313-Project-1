DOCUMENTATION ON THE EXECUTION OF hexdump.c


RUN:

./hexdump binary.out

COMPILE:

gcc -O0 -S -o hexdump_O0.s hexdump.c   no optimisation

gcc -O1 -S -o hexdump_O1.s hexdump.c   light optimisation

gcc -O3 -S -o hexdump_O3.s hexdump.c   heavy optimisation

gcc -O0 -o hexdump hexdump.c           build runnable binary

O0 generated 190 lines of code and unlike O3 and O1 this does not have print_hex_dump inlined into main 

O1 generated 165 lines of code this is a noticable improvement to the O1 and will actually run much more efficiently

O3 generated 186 lines of code but the difference from O1 to O3 is significantly smaller than the difference between O0 to O1 but 03 is still slightly faster than O1














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

