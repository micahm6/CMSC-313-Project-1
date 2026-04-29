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
