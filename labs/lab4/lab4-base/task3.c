#include <stdio.h>
#include <stdlib.h>

#include <unistd.h>
#include <sys/wait.h>

#define INPUT_FILE "./input/if1"

int main(int argc, char * argv[]) {
    
    pid_t pid = fork();

    if (pid < 0){
        printf("did not work");
    } else if (pid == 0){
        //in child
        printf("IN CHILD: pid=%ld\n", getpid());
        execl("ls", "-l", "-a");
        printf("failed");
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
