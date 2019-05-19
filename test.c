#include "types.h"
#include "stat.h"
#include "user.h"
#include "param.h"
 
 int
 main(int argc, char *argv[])
 {
    int pid = fork();
    if(pid == 0){
        void* page = malloc(sizeof(int)); 
        protectPage(page);
        free(page);
    }
    wait();
    exit();
 }
