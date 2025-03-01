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
        user_printf(1, "Include an int");
        exit();
    }
    
    char *str = argv[1];
    char *endptr;

    // Convert to integer and check validity
    int num = strtol(str, &endptr, 10);
    if (*endptr != '\0') {
        user_printf(1, "Invalid input\n");
        exit();
    }

    // Call system call
    int result = square(num);
    user_printf(1, "The square of %d is %d\n", num, result);
    //printf("The square of %d is %d\n", num, result);
    exit();
}