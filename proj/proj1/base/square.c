#include "types.h"
#include "stat.h"
#include "user.h"
#include <ctype.h>

int main(int argc, char * argv[]) {
    
    //int num;
    //printf("Enter a number: ");
    //scanf("%d", &num);
    if (argc < 2){
        user_printf(1, "Error");
        exit();
    }

    //convert *char into int, using stdlib has errors
    int num = 0;
    int sign = 1;
    char *ptr = argv[1];

    // Handle negative numbers
    if (*ptr == '-') {
        sign = -1;
        ptr++;
    }

    // Convert characters to numbers
    while (*ptr) {
        if (*ptr < '0' || *ptr > '9') {
            return 0;  
        }
        num = num * 10 + (*ptr - '0');  // Convert character to integer
        ptr++;
    }

    num= sign * num;

    // Call system call
    square(num);
    //user_printf(1, "The square of %d is %d\n", num, result);
    //printf("The square of %d is %d\n", num, result);
    exit();
}