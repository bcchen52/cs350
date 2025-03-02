#include "types.h"
#include "stat.h"
#include "user.h"
#include <ctype.h>

int main(int argc, char * argv[]) {
    
    //int num;
    //printf("Enter a number: ");
    //scanf("%d", &num);
    if (argc < 2){
        printf(1, "INCLUDE INTEGER\n");
        exit();
    }

    //convert *char into int, using stdlib has errors

    int status = atoi(argv[1]);

    // Call system call
    square(status);
    //user_printf(1, "The square of %d is %d\n", num, result);
    //printf("The square of %d is %d\n", num, result);
    exit();
}