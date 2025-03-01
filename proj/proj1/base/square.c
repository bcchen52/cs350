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


    // Call system call
    square(argv[1]);
    //user_printf(1, "The square of %d is %d\n", num, result);
    //printf("The square of %d is %d\n", num, result);
    exit();
}