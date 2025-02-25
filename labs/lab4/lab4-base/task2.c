#include <stdio.h>
#include <stdlib.h>

#include <unistd.h>
#include <sys/wait.h>

int main(int argc, char * argv[]) {
    
    pid_t pid = fork();

    if (pid < 0){
        printf("did not work");
    } else if (pid == 0){
        printf("IN CHILD: pid=%ld\n", getpid());
        execvp(argv[1], &argv[1]);
        printf("Failed execution");
        exit(1);
    } else {
        int status;
        waitpid(pid, &status, 0);
        if(status != 0){
            printf("Command %c does not exist.\n", argv[1]);
        }
        printf("In PARENT: successfully awaited child (pid = %ld)\n", pid);
    }
    return 0;
}
