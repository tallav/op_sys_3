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

void test_swapping(){
    int n = 20;
    int i = 0;
    void* pmalloc_add[n];
    int pid = fork();
    if(pid != 0){
        while(i < 5){
            pmalloc_add[i] = pmalloc();
            i++;
        }
    }
    wait();
    while(i < n){
        pfree(pmalloc_add[i]);
        i++;
    }
    exit();
}

void test_task4(){
    int pid = fork();
    if(pid == 0){
        char* argv[2] = {"/sh", "^p"};
        exec(argv[0], argv);
    }
    wait();
    exit();
}

#define CHILD_NUM 2
#define PGSIZE 4096
#define MEM_SIZE 10000
#define SZ 1200

#define PRINT_TEST_START(TEST_NAME)   printf(2,"\n----------------------\nstarting test - %s\n----------------------\n",TEST_NAME);
#define PRINT_TEST_END(TEST_NAME)   printf(2,"\nfinished test - %s\n----------------------\n",TEST_NAME);

void alloc_dealloc_test(){
    PRINT_TEST_START("alloc dealloc test");
    printf(2,"alloc dealloc test\n");
    if(!fork()){
        int* arr = (int*)(sbrk(PGSIZE*20));
        for(int i=0;i<PGSIZE*20/sizeof(int);++i){arr[i]=0;}
        sbrk(-PGSIZE*20);
        printf(2,"dealloc complete\n");
        arr = (int*)(sbrk(PGSIZE*20));
        for(int i=0;i<PGSIZE*20/sizeof(int);++i){arr[i]=2;}
        for(int i=0;i<PGSIZE*20/sizeof(int);++i){
            if(i%PGSIZE==0){
                printf(2,"arr[%d]=%d\n",i,arr[i]);
            }
        }
        sbrk(-PGSIZE*20);
        exit();
    }else{
        wait();
    }
    PRINT_TEST_END("alloc dealloc test");
}

int
main(int argc, char *argv[])
{
    //test_pmalloc();
    //test_swapping();
    //test_task4();
    alloc_dealloc_test();
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
