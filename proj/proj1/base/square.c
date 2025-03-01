#include "types.h"
#include "stat.h"
#include "user.h"
#include <ctype.h>
#include <stdio.h>

int main(int argc, char * argv[]) {
    
    //int num;
    //printf("Enter a number: ");
    //scanf("%d", &num);
    if (argc < 2){
        exit();
    }

    int num = 0;
    int sign = 1;

    // Handle negative numbers
    if (*argv[1] == '-') {
        sign = -1;
        *argv[1]++;
    }

    // Convert characters to numbers
    while (*argv[1]) {
        if (*argv[1] < '0' || *argv[1] > '9') {
            return 0;  // Invalid character → return 0 or handle error
        }
        num = num * 10 + (*argv[1] - '0');  // Convert character to integer
        *argv[1]++;
    }

    num= sign * num;

    // Call system call
    square(num);
    //user_printf(1, "The square of %d is %d\n", num, result);
    //printf("The square of %d is %d\n", num, result);
    exit();
}