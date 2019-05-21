#include "types.h"
#include "stat.h"
#include "user.h"
#include "param.h"
 
void test_pmalloc(){
    int pid = fork();
    int n = 5;
    if(pid == 0){
        void* pmalloc_add[n];
        void* malloc_add[n];
        for(int i=0; i < n; i++){
            void* addr1 = pmalloc();
            void* addr2 = malloc(10);
            pmalloc_add[i] = addr1;
            malloc_add[i] = addr2;
            printf(1, "pmalloc adress = %d\n", pmalloc_add[i]);
            printf(1, "malloc adress = %d\n", malloc_add[i]);
        }
        for(int i=0; i < 16; i++){
            printf(1, "pfree adress = %d\n", pmalloc_add[i]);
            printf(1, "free adress = %d\n", malloc_add[i]);
            pfree(pmalloc_add[i]);
            free(malloc_add[i]);
        }
    }
    wait();
    exit();
}

int
main(int argc, char *argv[])
{
    test_pmalloc();
    /*
    int pid = fork();
    if(pid == 0){
        void* page = malloc(sizeof(int)); 
        protectPage(page);
        free(page);
    }
    wait();
    exit();
    */
}
