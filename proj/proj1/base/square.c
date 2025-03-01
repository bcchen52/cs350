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
    
    if (argv[1] == '\0'){
        cprintf("Can't be empty");
        exit();
    }
    while (argv[1]) {
        if (!isdigit(argv[1])){
            cprintf("Invalid input");
            exit();
        }  
        argv[1]++;
    }
    square(argv[1]);
    //printf("The square of %d is %d\n", num, result);
    exit();
}