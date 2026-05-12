/*
File: hexdump.c
Author: Micah Mathew
Due: May 11, 2026
Desc:
Produces a formatted hex dump of a binary file with aach output line containing the following:
A left column:address of the first byte on that line printed as an 8 digit hex num

A middle section: 16 raw bytes printed as two digit hex vals separated by spaces

If the final line has fewer than 16 bytes the remaining positions are padded with spaces so the ASCII column is always aligned to the right

A right column: the ASCII representation of those same bytes, enclosed in |'s and any byte that is not a printable ASCII
character is shown as .

USAGE:
./hexdump binary.out

COMPILE EXAMPLES:
gcc -O0 -S -o hexdump_O0.s hexdump.c   (no optimisation, for analysis)
gcc -O1 -S -o hexdump_O1.s hexdump.c   (light optimisation)
gcc -O3 -S -o hexdump_O3.s hexdump.c   (aggressive optimisation)
gcc -O0 -o hexdump hexdump.c            (build runnable binary)


*/

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

// Number of bytes displayed per line 
#define BYTES_PER_LINE 16

/*
print_hex_dump

reads the open file pointer in BYTES_PER_LINE and write one line to stdout for each chunk

Param:
fp open, readable FILE* positioned at the start of the data to dump

Returns: void
*/
static void print_hex_dump(FILE *fp)
{
    unsigned char buf[BYTES_PER_LINE]; //raw bytes for the curr line      
    size_t        n_read;              // bytes read into buf         
    unsigned long offset = 0;         // running byte offset from file start  
    int           i;                  // general purpose loop counter         

    
    //read up to BYTES_PER_LINE bytes per iteration
    
    while ((n_read = fread(buf, 1, BYTES_PER_LINE, fp)) > 0) {

        /* ----left column: 8-digit hex offset followed by two spaces ---- */
        printf("%08lx  ", offset);

        /* ---- middle section: hex bytes, space-separated ---- */
        for (i = 0; i < BYTES_PER_LINE; i++) {
            if ((size_t)i < n_read) {
                /* Print the byte value as two uppercase hex digits */
                printf("%02x ", buf[i]);
            } else {
                /* Pad with spaces so the ASCII column stays aligned */
                printf("   ");
            }

            /*
             * Insert an extra space after the 8th byte (index 7) to visually
             * split the 16 bytes into two groups of 8, matching the canonical
             * xxd / hexdump -C layout.
             */
            if (i == 7) {
                printf(" ");
            }
        }

        /* ---- right column: ASCII representation enclosed in '|' ---- */
        printf(" |");
        for (i = 0; i < (int)n_read; i++) {
            /*
             * isprint() returns non-zero for printable characters (0x20–0x7E).
             * Any non-printable byte is replaced by '.' for readability.
             */
            putchar(isprint(buf[i]) ? buf[i] : '.');
        }
        printf("|\n");

        /* Advance the offset by the number of bytes just printed */
        offset += n_read;
    }

    /* Print the final offset so the reader knows the total file size */
    printf("%08lx\n", offset);
}

/*
 * main
 *
 * Entry point.  Expects exactly one command-line argument: the path to the
 * file to hex-dump.  Opens the file in binary mode, delegates to
 * print_hex_dump(), then closes the file.
 *
 * Returns: EXIT_SUCCESS (0) on success, EXIT_FAILURE (1) on error.
 */
int main(int argc, char *argv[])
{
    FILE *fp;

    /* Validate command-line usage */
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        return EXIT_FAILURE;
    }

    /* Open the target file in binary mode ("rb") to avoid newline translation
     * on platforms such as Windows that distinguish text vs. binary streams. */
    fp = fopen(argv[1], "rb");
    if (fp == NULL) {
        perror(argv[1]);   /* prints system error message (e.g. "No such file") */
        return EXIT_FAILURE;
    }

    /* Perform the actual hex dump */
    print_hex_dump(fp);

    /* Always close the file, even on success, to flush OS buffers */
    fclose(fp);

    return EXIT_SUCCESS;
}