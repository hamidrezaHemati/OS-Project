#include "types.h"
#include "stat.h"
#include "user.h"


struct timeVariables{
  int creationTime;
  int terminationTime;
  int sleepingTime;
  int readyTime;
  int runningTime;
};


int main(void){
   int p=getpid();
   struct timeVariables tv = {0,0,0,0,0};
   struct timeVariables *tv1 = &tv;
   int i=0;
   for(i=0; i<10; i++){
       if(getpid() == p){
           fork();
       }
   }
   for(i=0; i<100; i++){
       printf(1, "%d : %d \n", getpid(), i);
   }
   int cbt=0;
   int cbtSum=0;
   int turnAroundTime=0;
   int turnAroundTimeSum=0;
   int watingTime=0;
   int watingTimeSum=0;
   if(p == getpid()){
       sleep(1000);
       for(i=0;i<10;i++){
           int id = waitForChild(tv1);
           turnAroundTime = tv1->terminationTime - tv1->creationTime;
           cbt = tv1->runningTime;
           watingTime = turnAroundTime - cbt;
           turnAroundTimeSum += turnAroundTime;
           watingTimeSum += watingTime;
           cbtSum += cbt;
           printf(1, "turn around time of %d th procces is : %d\n", id,turnAroundTime);
           printf(1, "cbt of %d th proccess is : %d\n", id, cbt);
           printf(1, "wating time of %d th proccess is %d\n",id, watingTime);
           
       }
       int turnAroundTimeAvg = turnAroundTimeSum/10;
        int watingTimeAvg = watingTimeSum/10;
        int cbtAvg = cbtSum/10;
        printf(1, " -------------avg starts--------------- ");
        printf(1, "turn around time avarage %d\n", turnAroundTimeAvg);
        printf(1, "cbt avarage %d\n", watingTimeAvg);
        printf(1, "wating time avarage %d\n", cbtAvg);
        exit();
   }
   exit();
   
}