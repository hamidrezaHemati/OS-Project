#include<stdio.h> 
#include<stdlib.h> 
#include<unistd.h> 
#include<sys/types.h> 
#include<string.h> 
#include<sys/wait.h> 
  
int main() 
{ 
    // We use two pipes 
    // First pipe to send input string from parent 
    // Second pipe to send concatenated string from child 
  
    int fd1[2];  // Used to store two ends of first pipe 
    int fd2[2];  // Used to store two ends of second pipe 
  
    char fixed_str[] = "The sum of even digits in the input number: "; 
    char input_str[100]; 
    pid_t p; 

    if (pipe(fd1)==-1) 
    { 
        fprintf(stderr, "Pipe Failed" ); 
        return 1; 
    } 
    if (pipe(fd2)==-1) 
    { 
        fprintf(stderr, "Pipe Failed" ); 
        return 1; 
    } 
  
    scanf("%s", input_str); 
    p = fork(); 
  
    if (p < 0) 
    { 
        fprintf(stderr, "fork Failed" ); 
        return 1; 
    } 
  
    // Parent process 
    else if (p > 0) 
    { 
        char result[100]; 
        close(fd1[0]);  // Close reading end of first pipe 
        // Write input string and close writing end of first 
        // pipe. 
        write(fd1[1], input_str, strlen(input_str)+1); 
        close(fd1[1]); 
        // Wait for child to send a string 
        wait(NULL); 
        close(fd2[1]); // Close writing end of second pipe 
        // Read string from child, print it and close 
        // reading end. 
        read(fd2[0], result, 100); 
        printf("%s\n", result); 
        close(fd2[0]); 
    } 
  
    // child process 
    else
    { 
        close(fd1[1]);  // Close writing end of first pipe 
        // Read a string using first pipe 
        char number[100]; 
        read(fd1[0], number, 100); 
	int i=0, num=0, sum=0;
	for(i=0; i<strlen(number); i++){
		 if(number[i]>='0' && number[i]<='9') //to confirm it's a digit
   		 {
    			num = number[i] - '0';
			if(num%2 == 0)     ///to check digit is an even number
		 		sum += num;
			}

	}
        // Concatenate a fixed string with it  
        i=0;

        for (i=0; i<strlen(fixed_str); i++) 
            number[i] = fixed_str[i]; 

        i = strlen(fixed_str);
	int temp_sum = sum;
	int counter=0; ///sum number of digits
	while(temp_sum > 0){
		temp_sum = temp_sum/10;
		counter++;
		
	}
	//printf("counter is : %d\n", counter);
	temp_sum = sum;
	char sums[counter];
	char reverse[counter];
	int length=0;
	int rev=0;
	while(temp_sum > 0){
		int a = temp_sum%10;
		reverse[length++] = a|'0';
		temp_sum /= 10;
		
	}
	int k=0;
	/*for(k=0; k<length; k++)
		printf("rev[i] is : %c\n", reverse[k]);*/
	k=0;
	length--;
	while(length >= 0){
		sums[rev++] = reverse[length--];
		//printf("sum[i] is : %c\n", sums[k]);
		k++;
	}
	
	int j=0;
	for(j=0; j<counter; j++){
		number[i] = sums[j];
		i++;

	}
	number[i]='\0';
        // Close both reading ends 
        close(fd1[0]); 
        close(fd2[0]); 
	//printf("sum of even number isssss : %d\n", sum);
        // Write concatenated string and close writing end 
        write(fd2[1], number, strlen(number)); 
        close(fd2[1]); 
        exit(0); 
    } 
} 
