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
        cprintf("Include an int");
        exit();
    }
    
    char *str = argv[1];
    char *endptr;

    // Convert to integer and check validity
    int num = strtol(str, &endptr, 10);
    if (*endptr != '\0') {
        printf("Invalid input\n");
        exit();
    }

    // Call system call
    int result = square(num);
    printf("The square of %d is %d\n", num, result);
    //printf("The square of %d is %d\n", num, result);
    exit();
}