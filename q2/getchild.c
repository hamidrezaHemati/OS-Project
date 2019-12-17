#include "types.h"
#include "stat.h"
#include "user.h"

int main(void){
int parent = getpid();
printf(1, "orginal parent id = %d \n", parent);
int pid1 = fork();
//printf(1, "pid number check pid1 %d \n\n\n", pid1);
int pid2 = fork();
//printf(1, "pid number check pid2 %d \n\n\n", pid2);
if(pid1 < 0)
    printf(1, "first fork didnt work \n");
if(pid2 < 0)
    printf(1, "second fork didnt work \n");
printf(1, "%d \t %d\n", getpid(), getppid());
if(getpid() == parent){
    printf(1, "checking orginal parent id is %d\n", parent);
    printf(1, "children = %d\n", getchildren());
}
exit();
}
