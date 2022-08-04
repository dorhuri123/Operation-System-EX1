//Dor Huri 209409218
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>
#define MAX_SIZE 100
#define SPACE " "
#define COLON ":"
#define ONE 1
#define ZERO 0
#define ERROR -1

char shellHistory[MAX_SIZE][MAX_SIZE];
pid_t commandPid[MAX_SIZE];
/*
 function to handle the child process
 depend on the result he get from fork function
 */
int child_proc(int num,char* arguments[]){
    //checking if fork failed
    if(num < ZERO){
        perror("fork failed");
    }
    //for the child process using execvp
    else if(num == ZERO){
        //checking if execvp failed
        if(execvp(arguments[ZERO],arguments) == ERROR){
            perror("execvp failed");
            return 1;
        }
    }
    //for father process
    else if(num > ZERO) {
        //waiting for all child process to finish
        if(wait(NULL) == ERROR){
            perror("wait failed");
        }
    }
    return 0;
}
int main(int argc,char *argv[]) {
    int i;
    //adding all command argument to environment PATH variable
    for(i=ONE; i < argc; i++){
        char* temp;
        if((temp = getenv("PATH"))== NULL){
            perror("getenv failed");
        }
        //adding variable in path variable format
        temp = strcat(temp, COLON);
        temp = strcat(temp,argv[i]);
        //updating the path variable and checking if there is an error
        if(setenv("PATH",temp,ONE) == ERROR){
            perror("setenv failed");
        }
    }
    //input for the current command
    char currentInput[MAX_SIZE];
    //arguments that we get after split
    char* arguments[MAX_SIZE];
    //index for number of commands
    int countHistory;
    for (countHistory = ZERO; countHistory < MAX_SIZE; ++countHistory) {
        //index for argument of current command
        int countArgument = ZERO;
        //the argument we get from command
        char* arg;
        //printing the prompt
        printf("$ ");
        fflush(stdout);
        //getting command input until \n
        scanf(" %[^\n]", currentInput);
        //copying command to shellHistory
        strcpy( shellHistory[countHistory], currentInput);
        //first argument
        arg = strtok(currentInput,SPACE);
        while(arg!=NULL){
            //taking all argument from current command
            arguments[countArgument]=arg;
            arg = strtok(NULL,SPACE);
            countArgument++;
        }
        //putting null in last element for execvp
        arguments[countArgument]=NULL;
        //in case the command is history
        if(strcmp("history",arguments[ZERO])==ZERO){
            //updating the command pid
            commandPid[countHistory] = getpid();
            //printing all the shell history until now
            int j;
            for(j=ZERO; j<=countHistory; j++){
                printf("%d %s\n",commandPid[j],shellHistory[j]);
            }
        }
            //in case the command is cd
        else if(strcmp("cd",arguments[ZERO])==ZERO){
            //updating the command pid
            commandPid[countHistory] = getpid();
            //using and checking if chdir failed
            if(chdir(arguments[ONE]) == ERROR){
                perror("chdir failed");
            }
        }
            //in case the command is exit
        else if(strcmp("exit",arguments[ZERO])== ZERO){
            //exiting shell
           return 0;
        }
            //in case the command is not built in
        else{

            //calling fork to create new process
            commandPid[countHistory] = fork();
            int num = commandPid[countHistory];
            //calling function for child processes
            int flag = child_proc(num,arguments);
            //for solving a bug when execvp send perror
            if(flag){
                return 0;
            }
        }
    }
}
