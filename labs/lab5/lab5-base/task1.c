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
        close(pipefd[0]);               
        dup2(pipefd[1], STDOUT_FILENO);  // Redirect stdout to pipe
        close(pipefd[1]);    
        printf("IN CHILD-1 (PID=%ld): executing command %s \n", getpid(), argv1[0]);
        execvp(argv1[0], argv1);
        printf("Failed execution");
        exit(1);
    } else {
        pid_t pid_b = fork();

        if (pid_b == 0){
            //in child
            close(pipefd[1]);               // Close unused write end
            dup2(pipefd[0], STDIN_FILENO);  // Redirect stdin to pipe
            close(pipefd[0]); 
            printf("IN CHILD-2 (PID=%ld): executing command %s \n", getpid(), argv2[0]);
            execvp(argv2[0], argv2);
            printf("Failed execution");
            exit(1);
        } else {
            close(pipefd[0]);
            close(pipefd[1]);
            wait(NULL);
            printf("In PARENT (PID=%ld): successfully reaped child (pid = %ld)\n", getpid(), pid_a);
            wait(NULL);
            printf("In PARENT (PID=%ld): successfully reaped child (pid = %ld)\n", getpid(), pid_a);
        }
    }  
    return 0;
}
