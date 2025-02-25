#include <stdio.h>
#include <stdlib.h>

#include <unistd.h>
#include <sys/wait.h>
#include <fcntl.h> 

#define INPUT_FILE "./input/if1"

int main(int argc, char * argv[]) {

    int read = open(INPUT_FILE, O_RDONLY);

    dup2(read, 0);

    close(read);

    int write = open("result", O_WRONLY | O_CREAT | O_TRUNC);

    pid_t pid = fork();

    if (pid < 0){
        printf("did not work");
    } else if (pid == 0){
        printf("IN CHILD: pid=%ld\n", getpid());
        int write = open("result", O_WRONLY | O_CREAT | O_TRUNC);
        dup2(write, 1);
        execvp(argv[1], &argv[1]);
        printf("Failed execution");
        exit(1);
    } else {
        int status;
        waitpid(pid, &status, 0);
        dup2(1, write);
        close(write);
        if(status != 0){
            printf("Command %c does not exist.\n", argv[1]);
        }
        printf("In PARENT: successfully awaited child (pid = %ld)\n", pid);
    }

    return 0;
}
