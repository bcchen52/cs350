#include <stdio.h>
#include <stdlib.h>

#include <unistd.h>
#include <sys/wait.h>

int main(void) {
    
    pid_t pid = fork();

    if (pid < 0){
        printf("did not work");
    } else if (pid == 0){
        //in child
        printf("IN CHILD: pid=%ld\n", getpid());
        execl("/bin/ls", "ls", "-l -a", (char*)0);
        printf("Failed execution");
        exit(1);
    } else {
        int status;
        waitpid(pid, &status, 0);
        printf("In PARENT: successfully awaited child (pid = %ld)\n", pid);
    }  
    return 0;
}
