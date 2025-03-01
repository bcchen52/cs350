#include "types.h"
#include "stat.h"
#include "user.h"
#include <stdio.h>


int main() {
    int num;
    printf("Enter a number: ");
    scanf("%d", &num);

    int result = square(num);
    printf("The square of %d is %d\n", num, result);
    exit();
}