#include "types.h"
#include "stat.h"
#include "user.h"

int main(void){
    int ppid = getppid();
    int pid = getpid();
    int pid2 = getpid();
    printf(1, "parent PID: %d\n", ppid);
    printf(1, "process PID: %d    %d\n", pid, pid2);
    printf(1, "ppid syscall hit: %d\n", getcount(23));
    printf(1, "pid syscall hit: %d\n", getcount(11));
}