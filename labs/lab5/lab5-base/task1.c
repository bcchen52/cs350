#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/wait.h>

int main(void) {
    char * argv1[] = {"cat", "Makefile", 0};
    //char * argv2[] = {"head", "-4", 0};
    char * argv2[] = {"wc", "-l", 0};
    
    setbuf(stdout, NULL);
    
    int pipefd[2];

    if (pipe(pipefd) == -1) {
        perror("pipe failed");
        exit(EXIT_FAILURE);
    }

    pid_t pid_a = fork();

    if (pid_a < 0){
        printf("did not work");
    } else if (pid_a == 0){
        //in child
        printf("IN CHILD-1 (PID=%ld): executing command %s \n", getpid(), argv1[0]);
        close(pipefd[0]);               
        dup2(pipefd[1], STDOUT_FILENO); 
        close(pipefd[1]);    
        execvp(argv1[0], argv1);
        printf("Failed execution");
        exit(1);
    } else {

        int status;
        waitpid(pid_a, &status, 0);

        pid_t pid_b = fork();

        if (pid_b == 0) {
            printf("IN CHILD-2 (PID=%ld): executing command %s \n", getpid(), argv2[0]);
            close(pipefd[1]);               
            dup2(pipefd[0], STDIN_FILENO); 
            close(pipefd[0]); 
            execvp(argv2[0], argv2);
            printf("Failed execution");
            exit(1);
        } else {
            close(pipefd[0]);
            close(pipefd[1]);
            waitpid(pid_b, &status, 0);
            printf("In PARENT (PID=%ld): successfully reaped child (pid = %ld)\n", getpid(), pid_a);
            printf("In PARENT (PID=%ld): successfully reaped child (pid = %ld)\n", getpid(), pid_b);

        }
    }  
    return 0;
}
