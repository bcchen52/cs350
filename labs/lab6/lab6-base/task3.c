#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/wait.h>

int main(void) {
    pid_t cpid[3] = {0}; 
    int ret = 0;   
    int pipe1[2], pipe2[2];

    setbuf(stdout, NULL);

    pipe(pipe1);
    pipe(pipe2);

    cpid[0] = fork();
    if (cpid[0] < 0) {
        fprintf(stderr, "fork() 1 failed: %s\n", strerror(errno));
        return 0;
    }
    else if (0 == cpid[0]) { // CHILD-1
        char buf;
        close(pipe1[1]); // close write
        read(pipe1[0], &buf, 1); //open read, wait for pipe1
        printf("CHILD-1 (PID=%d) is running.\n", getpid());
        close(pipe1[0]);

        //C2 depends on this, so, send a signal through pipe2 to C2
        close(pipe2[0]);
        write(pipe2[1], "x", 1);
        close(pipe2[1]);
        exit(0);
    }

    cpid[1] = fork();
    if (cpid < 0) {
        fprintf(stderr, "fork() 2 failed: %s\n", strerror(errno));
        return 0;
    }
    else if (0 == cpid[1]) { // CHILD-2
        printf("CHILD-2 (PID=%d) is running.\n", getpid());
        exit(0);
    }
    
    cpid[2] = fork();
    if (cpid < 0) {
        fprintf(stderr, "fork() 3 failed: %s\n", strerror(errno));
        return 0;
    }
    else if (0 == cpid[2]) { // CHILD-3
        printf("CHILD-3 (PID=%d) is running.\n", getpid());

        //C1 dependson this, so, send a signal through pipe1 to C1
        close(pipe1[0]);
        write(pipe1[1], "x", 1);
        close(pipe1[1]);
        exit(0);   
    }

    while ((ret = wait(NULL)) > 0)
    {
        printf("In PARENT (PID=%d): successfully reaped child (PID=%d)\n", getpid(), ret);
    }

    return 0;
}
