
_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    PRINT_TEST_END("alloc dealloc test");
}

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
    //test_pmalloc();
    //test_swapping();
    //test_task4();
    alloc_dealloc_test();
  11:	e8 7a 01 00 00       	call   190 <alloc_dealloc_test>
        free(page);
    }
    wait();
    exit();
    */
}
  16:	83 c4 04             	add    $0x4,%esp
  19:	31 c0                	xor    %eax,%eax
  1b:	59                   	pop    %ecx
  1c:	5d                   	pop    %ebp
  1d:	8d 61 fc             	lea    -0x4(%ecx),%esp
  20:	c3                   	ret    
  21:	66 90                	xchg   %ax,%ax
  23:	66 90                	xchg   %ax,%ax
  25:	66 90                	xchg   %ax,%ax
  27:	66 90                	xchg   %ax,%ax
  29:	66 90                	xchg   %ax,%ax
  2b:	66 90                	xchg   %ax,%ax
  2d:	66 90                	xchg   %ax,%ax
  2f:	90                   	nop

00000030 <test_pmalloc>:
void test_pmalloc(){
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	57                   	push   %edi
  34:	56                   	push   %esi
  35:	53                   	push   %ebx
  36:	83 ec 4c             	sub    $0x4c,%esp
    int pid = fork();
  39:	e8 9c 04 00 00       	call   4da <fork>
    if(pid == 0){
  3e:	85 c0                	test   %eax,%eax
  40:	0f 85 a0 00 00 00    	jne    e6 <test_pmalloc+0xb6>
  46:	89 c3                	mov    %eax,%ebx
  48:	89 65 b0             	mov    %esp,-0x50(%ebp)
        for(int i=0; i < n; i++){
  4b:	31 f6                	xor    %esi,%esi
            void* addr1 = pmalloc();
  4d:	e8 3e 09 00 00       	call   990 <pmalloc>
            void* addr2 = malloc(10);
  52:	83 ec 0c             	sub    $0xc,%esp
            void* addr1 = pmalloc();
  55:	89 45 b4             	mov    %eax,-0x4c(%ebp)
            void* addr2 = malloc(10);
  58:	6a 0a                	push   $0xa
  5a:	e8 31 08 00 00       	call   890 <malloc>
            pmalloc_add[i] = addr1;
  5f:	8b 55 b4             	mov    -0x4c(%ebp),%edx
            printf(1, "pmalloc adress = %d\n", pmalloc_add[i]);
  62:	83 c4 0c             	add    $0xc,%esp
            malloc_add[i] = addr2;
  65:	89 44 b5 d4          	mov    %eax,-0x2c(%ebp,%esi,4)
            void* addr2 = malloc(10);
  69:	89 c7                	mov    %eax,%edi
            pmalloc_add[i] = addr1;
  6b:	89 54 b5 c0          	mov    %edx,-0x40(%ebp,%esi,4)
            printf(1, "pmalloc adress = %d\n", pmalloc_add[i]);
  6f:	52                   	push   %edx
        for(int i=0; i < n; i++){
  70:	83 c6 01             	add    $0x1,%esi
            printf(1, "pmalloc adress = %d\n", pmalloc_add[i]);
  73:	68 c0 0a 00 00       	push   $0xac0
  78:	6a 01                	push   $0x1
  7a:	e8 b1 05 00 00       	call   630 <printf>
            printf(1, "malloc adress = %d\n", malloc_add[i]);
  7f:	83 c4 0c             	add    $0xc,%esp
  82:	57                   	push   %edi
  83:	68 c1 0a 00 00       	push   $0xac1
  88:	6a 01                	push   $0x1
  8a:	e8 a1 05 00 00       	call   630 <printf>
        for(int i=0; i < n; i++){
  8f:	83 c4 10             	add    $0x10,%esp
  92:	83 fe 05             	cmp    $0x5,%esi
  95:	75 b6                	jne    4d <test_pmalloc+0x1d>
  97:	89 f6                	mov    %esi,%esi
  99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            printf(1, "pfree adress = %d\n", pmalloc_add[i]);
  a0:	8b 7c 9d c0          	mov    -0x40(%ebp,%ebx,4),%edi
  a4:	83 ec 04             	sub    $0x4,%esp
  a7:	57                   	push   %edi
  a8:	68 d5 0a 00 00       	push   $0xad5
  ad:	6a 01                	push   $0x1
  af:	e8 7c 05 00 00       	call   630 <printf>
            printf(1, "free adress = %d\n", malloc_add[i]);
  b4:	8b 74 9d d4          	mov    -0x2c(%ebp,%ebx,4),%esi
  b8:	83 c4 0c             	add    $0xc,%esp
        for(int i=0; i < 16; i++){
  bb:	83 c3 01             	add    $0x1,%ebx
            printf(1, "free adress = %d\n", malloc_add[i]);
  be:	56                   	push   %esi
  bf:	68 d6 0a 00 00       	push   $0xad6
  c4:	6a 01                	push   $0x1
  c6:	e8 65 05 00 00       	call   630 <printf>
            pfree(pmalloc_add[i]);
  cb:	89 3c 24             	mov    %edi,(%esp)
  ce:	e8 ad 09 00 00       	call   a80 <pfree>
            free(malloc_add[i]);
  d3:	89 34 24             	mov    %esi,(%esp)
  d6:	e8 25 07 00 00       	call   800 <free>
        for(int i=0; i < 16; i++){
  db:	83 c4 10             	add    $0x10,%esp
  de:	83 fb 10             	cmp    $0x10,%ebx
  e1:	75 bd                	jne    a0 <test_pmalloc+0x70>
  e3:	8b 65 b0             	mov    -0x50(%ebp),%esp
    wait();
  e6:	e8 ff 03 00 00       	call   4ea <wait>
    exit();
  eb:	e8 f2 03 00 00       	call   4e2 <exit>

000000f0 <test_swapping>:
void test_swapping(){
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	56                   	push   %esi
  f4:	53                   	push   %ebx
  f5:	83 ec 50             	sub    $0x50,%esp
    int pid = fork();
  f8:	e8 dd 03 00 00       	call   4da <fork>
    if(pid != 0){
  fd:	85 c0                	test   %eax,%eax
  ff:	89 c3                	mov    %eax,%ebx
 101:	74 13                	je     116 <test_swapping+0x26>
    int i = 0;
 103:	31 db                	xor    %ebx,%ebx
            pmalloc_add[i] = pmalloc();
 105:	e8 86 08 00 00       	call   990 <pmalloc>
 10a:	89 44 9d a8          	mov    %eax,-0x58(%ebp,%ebx,4)
            i++;
 10e:	83 c3 01             	add    $0x1,%ebx
        while(i < 5){
 111:	83 fb 05             	cmp    $0x5,%ebx
 114:	75 ef                	jne    105 <test_swapping+0x15>
 116:	8d 5c 9d a8          	lea    -0x58(%ebp,%ebx,4),%ebx
 11a:	8d 75 f8             	lea    -0x8(%ebp),%esi
    wait();
 11d:	e8 c8 03 00 00       	call   4ea <wait>
 122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        pfree(pmalloc_add[i]);
 128:	83 ec 0c             	sub    $0xc,%esp
 12b:	ff 33                	pushl  (%ebx)
 12d:	83 c3 04             	add    $0x4,%ebx
 130:	e8 4b 09 00 00       	call   a80 <pfree>
    while(i < n){
 135:	83 c4 10             	add    $0x10,%esp
 138:	39 f3                	cmp    %esi,%ebx
 13a:	75 ec                	jne    128 <test_swapping+0x38>
    exit();
 13c:	e8 a1 03 00 00       	call   4e2 <exit>
 141:	eb 0d                	jmp    150 <test_task4>
 143:	90                   	nop
 144:	90                   	nop
 145:	90                   	nop
 146:	90                   	nop
 147:	90                   	nop
 148:	90                   	nop
 149:	90                   	nop
 14a:	90                   	nop
 14b:	90                   	nop
 14c:	90                   	nop
 14d:	90                   	nop
 14e:	90                   	nop
 14f:	90                   	nop

00000150 <test_task4>:
void test_task4(){
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	83 ec 18             	sub    $0x18,%esp
    int pid = fork();
 156:	e8 7f 03 00 00       	call   4da <fork>
    if(pid == 0){
 15b:	85 c0                	test   %eax,%eax
 15d:	74 0a                	je     169 <test_task4+0x19>
    wait();
 15f:	e8 86 03 00 00       	call   4ea <wait>
    exit();
 164:	e8 79 03 00 00       	call   4e2 <exit>
        exec(argv[0], argv);
 169:	50                   	push   %eax
 16a:	50                   	push   %eax
 16b:	8d 45 f0             	lea    -0x10(%ebp),%eax
        char* argv[2] = {"/sh", "^p"};
 16e:	c7 45 f0 e8 0a 00 00 	movl   $0xae8,-0x10(%ebp)
 175:	c7 45 f4 ec 0a 00 00 	movl   $0xaec,-0xc(%ebp)
        exec(argv[0], argv);
 17c:	50                   	push   %eax
 17d:	68 e8 0a 00 00       	push   $0xae8
 182:	e8 93 03 00 00       	call   51a <exec>
 187:	83 c4 10             	add    $0x10,%esp
 18a:	eb d3                	jmp    15f <test_task4+0xf>
 18c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000190 <alloc_dealloc_test>:
void alloc_dealloc_test(){
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	56                   	push   %esi
 194:	53                   	push   %ebx
    PRINT_TEST_START("alloc dealloc test");
 195:	83 ec 04             	sub    $0x4,%esp
 198:	68 ef 0a 00 00       	push   $0xaef
 19d:	68 34 0b 00 00       	push   $0xb34
 1a2:	6a 02                	push   $0x2
 1a4:	e8 87 04 00 00       	call   630 <printf>
    printf(2,"alloc dealloc test\n");
 1a9:	59                   	pop    %ecx
 1aa:	5b                   	pop    %ebx
 1ab:	68 02 0b 00 00       	push   $0xb02
 1b0:	6a 02                	push   $0x2
 1b2:	e8 79 04 00 00       	call   630 <printf>
    if(!fork()){
 1b7:	e8 1e 03 00 00       	call   4da <fork>
 1bc:	83 c4 10             	add    $0x10,%esp
 1bf:	85 c0                	test   %eax,%eax
 1c1:	74 23                	je     1e6 <alloc_dealloc_test+0x56>
        wait();
 1c3:	e8 22 03 00 00       	call   4ea <wait>
    PRINT_TEST_END("alloc dealloc test");
 1c8:	83 ec 04             	sub    $0x4,%esp
 1cb:	68 ef 0a 00 00       	push   $0xaef
 1d0:	68 78 0b 00 00       	push   $0xb78
 1d5:	6a 02                	push   $0x2
 1d7:	e8 54 04 00 00       	call   630 <printf>
}
 1dc:	83 c4 10             	add    $0x10,%esp
 1df:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1e2:	5b                   	pop    %ebx
 1e3:	5e                   	pop    %esi
 1e4:	5d                   	pop    %ebp
 1e5:	c3                   	ret    
        int* arr = (int*)(sbrk(PGSIZE*20));
 1e6:	83 ec 0c             	sub    $0xc,%esp
 1e9:	89 c3                	mov    %eax,%ebx
 1eb:	68 00 40 01 00       	push   $0x14000
 1f0:	e8 75 03 00 00       	call   56a <sbrk>
 1f5:	8d 90 00 40 01 00    	lea    0x14000(%eax),%edx
 1fb:	83 c4 10             	add    $0x10,%esp
 1fe:	66 90                	xchg   %ax,%ax
        for(int i=0;i<PGSIZE*20/sizeof(int);++i){arr[i]=0;}
 200:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
 206:	83 c0 04             	add    $0x4,%eax
 209:	39 d0                	cmp    %edx,%eax
 20b:	75 f3                	jne    200 <alloc_dealloc_test+0x70>
        sbrk(-PGSIZE*20);
 20d:	83 ec 0c             	sub    $0xc,%esp
 210:	68 00 c0 fe ff       	push   $0xfffec000
 215:	e8 50 03 00 00       	call   56a <sbrk>
        printf(2,"dealloc complete\n");
 21a:	58                   	pop    %eax
 21b:	5a                   	pop    %edx
 21c:	68 16 0b 00 00       	push   $0xb16
 221:	6a 02                	push   $0x2
 223:	e8 08 04 00 00       	call   630 <printf>
        arr = (int*)(sbrk(PGSIZE*20));
 228:	c7 04 24 00 40 01 00 	movl   $0x14000,(%esp)
 22f:	e8 36 03 00 00       	call   56a <sbrk>
 234:	8d 90 00 40 01 00    	lea    0x14000(%eax),%edx
 23a:	89 c6                	mov    %eax,%esi
 23c:	83 c4 10             	add    $0x10,%esp
 23f:	90                   	nop
        for(int i=0;i<PGSIZE*20/sizeof(int);++i){arr[i]=2;}
 240:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
 246:	83 c0 04             	add    $0x4,%eax
 249:	39 d0                	cmp    %edx,%eax
 24b:	75 f3                	jne    240 <alloc_dealloc_test+0xb0>
 24d:	eb 1f                	jmp    26e <alloc_dealloc_test+0xde>
 24f:	90                   	nop
                printf(2,"arr[%d]=%d\n",i,arr[i]);
 250:	ff 34 9e             	pushl  (%esi,%ebx,4)
 253:	53                   	push   %ebx
 254:	68 28 0b 00 00       	push   $0xb28
 259:	6a 02                	push   $0x2
 25b:	e8 d0 03 00 00       	call   630 <printf>
 260:	83 c4 10             	add    $0x10,%esp
        for(int i=0;i<PGSIZE*20/sizeof(int);++i){
 263:	83 c3 01             	add    $0x1,%ebx
 266:	81 fb 00 50 00 00    	cmp    $0x5000,%ebx
 26c:	74 0a                	je     278 <alloc_dealloc_test+0xe8>
            if(i%PGSIZE==0){
 26e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
 274:	75 ed                	jne    263 <alloc_dealloc_test+0xd3>
 276:	eb d8                	jmp    250 <alloc_dealloc_test+0xc0>
        sbrk(-PGSIZE*20);
 278:	83 ec 0c             	sub    $0xc,%esp
 27b:	68 00 c0 fe ff       	push   $0xfffec000
 280:	e8 e5 02 00 00       	call   56a <sbrk>
        exit();
 285:	e8 58 02 00 00       	call   4e2 <exit>
 28a:	66 90                	xchg   %ax,%ax
 28c:	66 90                	xchg   %ax,%ax
 28e:	66 90                	xchg   %ax,%ax

00000290 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	53                   	push   %ebx
 294:	8b 45 08             	mov    0x8(%ebp),%eax
 297:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 29a:	89 c2                	mov    %eax,%edx
 29c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2a0:	83 c1 01             	add    $0x1,%ecx
 2a3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 2a7:	83 c2 01             	add    $0x1,%edx
 2aa:	84 db                	test   %bl,%bl
 2ac:	88 5a ff             	mov    %bl,-0x1(%edx)
 2af:	75 ef                	jne    2a0 <strcpy+0x10>
    ;
  return os;
}
 2b1:	5b                   	pop    %ebx
 2b2:	5d                   	pop    %ebp
 2b3:	c3                   	ret    
 2b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000002c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	53                   	push   %ebx
 2c4:	8b 55 08             	mov    0x8(%ebp),%edx
 2c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 2ca:	0f b6 02             	movzbl (%edx),%eax
 2cd:	0f b6 19             	movzbl (%ecx),%ebx
 2d0:	84 c0                	test   %al,%al
 2d2:	75 1c                	jne    2f0 <strcmp+0x30>
 2d4:	eb 2a                	jmp    300 <strcmp+0x40>
 2d6:	8d 76 00             	lea    0x0(%esi),%esi
 2d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 2e0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 2e3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 2e6:	83 c1 01             	add    $0x1,%ecx
 2e9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 2ec:	84 c0                	test   %al,%al
 2ee:	74 10                	je     300 <strcmp+0x40>
 2f0:	38 d8                	cmp    %bl,%al
 2f2:	74 ec                	je     2e0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 2f4:	29 d8                	sub    %ebx,%eax
}
 2f6:	5b                   	pop    %ebx
 2f7:	5d                   	pop    %ebp
 2f8:	c3                   	ret    
 2f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 300:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 302:	29 d8                	sub    %ebx,%eax
}
 304:	5b                   	pop    %ebx
 305:	5d                   	pop    %ebp
 306:	c3                   	ret    
 307:	89 f6                	mov    %esi,%esi
 309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000310 <strlen>:

uint
strlen(char *s)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 316:	80 39 00             	cmpb   $0x0,(%ecx)
 319:	74 15                	je     330 <strlen+0x20>
 31b:	31 d2                	xor    %edx,%edx
 31d:	8d 76 00             	lea    0x0(%esi),%esi
 320:	83 c2 01             	add    $0x1,%edx
 323:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 327:	89 d0                	mov    %edx,%eax
 329:	75 f5                	jne    320 <strlen+0x10>
    ;
  return n;
}
 32b:	5d                   	pop    %ebp
 32c:	c3                   	ret    
 32d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 330:	31 c0                	xor    %eax,%eax
}
 332:	5d                   	pop    %ebp
 333:	c3                   	ret    
 334:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 33a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000340 <memset>:

void*
memset(void *dst, int c, uint n)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	57                   	push   %edi
 344:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 347:	8b 4d 10             	mov    0x10(%ebp),%ecx
 34a:	8b 45 0c             	mov    0xc(%ebp),%eax
 34d:	89 d7                	mov    %edx,%edi
 34f:	fc                   	cld    
 350:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 352:	89 d0                	mov    %edx,%eax
 354:	5f                   	pop    %edi
 355:	5d                   	pop    %ebp
 356:	c3                   	ret    
 357:	89 f6                	mov    %esi,%esi
 359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000360 <strchr>:

char*
strchr(const char *s, char c)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	53                   	push   %ebx
 364:	8b 45 08             	mov    0x8(%ebp),%eax
 367:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 36a:	0f b6 10             	movzbl (%eax),%edx
 36d:	84 d2                	test   %dl,%dl
 36f:	74 1d                	je     38e <strchr+0x2e>
    if(*s == c)
 371:	38 d3                	cmp    %dl,%bl
 373:	89 d9                	mov    %ebx,%ecx
 375:	75 0d                	jne    384 <strchr+0x24>
 377:	eb 17                	jmp    390 <strchr+0x30>
 379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 380:	38 ca                	cmp    %cl,%dl
 382:	74 0c                	je     390 <strchr+0x30>
  for(; *s; s++)
 384:	83 c0 01             	add    $0x1,%eax
 387:	0f b6 10             	movzbl (%eax),%edx
 38a:	84 d2                	test   %dl,%dl
 38c:	75 f2                	jne    380 <strchr+0x20>
      return (char*)s;
  return 0;
 38e:	31 c0                	xor    %eax,%eax
}
 390:	5b                   	pop    %ebx
 391:	5d                   	pop    %ebp
 392:	c3                   	ret    
 393:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003a0 <gets>:

char*
gets(char *buf, int max)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	57                   	push   %edi
 3a4:	56                   	push   %esi
 3a5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3a6:	31 f6                	xor    %esi,%esi
 3a8:	89 f3                	mov    %esi,%ebx
{
 3aa:	83 ec 1c             	sub    $0x1c,%esp
 3ad:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 3b0:	eb 2f                	jmp    3e1 <gets+0x41>
 3b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 3b8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3bb:	83 ec 04             	sub    $0x4,%esp
 3be:	6a 01                	push   $0x1
 3c0:	50                   	push   %eax
 3c1:	6a 00                	push   $0x0
 3c3:	e8 32 01 00 00       	call   4fa <read>
    if(cc < 1)
 3c8:	83 c4 10             	add    $0x10,%esp
 3cb:	85 c0                	test   %eax,%eax
 3cd:	7e 1c                	jle    3eb <gets+0x4b>
      break;
    buf[i++] = c;
 3cf:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3d3:	83 c7 01             	add    $0x1,%edi
 3d6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 3d9:	3c 0a                	cmp    $0xa,%al
 3db:	74 23                	je     400 <gets+0x60>
 3dd:	3c 0d                	cmp    $0xd,%al
 3df:	74 1f                	je     400 <gets+0x60>
  for(i=0; i+1 < max; ){
 3e1:	83 c3 01             	add    $0x1,%ebx
 3e4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3e7:	89 fe                	mov    %edi,%esi
 3e9:	7c cd                	jl     3b8 <gets+0x18>
 3eb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 3ed:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 3f0:	c6 03 00             	movb   $0x0,(%ebx)
}
 3f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3f6:	5b                   	pop    %ebx
 3f7:	5e                   	pop    %esi
 3f8:	5f                   	pop    %edi
 3f9:	5d                   	pop    %ebp
 3fa:	c3                   	ret    
 3fb:	90                   	nop
 3fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 400:	8b 75 08             	mov    0x8(%ebp),%esi
 403:	8b 45 08             	mov    0x8(%ebp),%eax
 406:	01 de                	add    %ebx,%esi
 408:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 40a:	c6 03 00             	movb   $0x0,(%ebx)
}
 40d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 410:	5b                   	pop    %ebx
 411:	5e                   	pop    %esi
 412:	5f                   	pop    %edi
 413:	5d                   	pop    %ebp
 414:	c3                   	ret    
 415:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000420 <stat>:

int
stat(char *n, struct stat *st)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	56                   	push   %esi
 424:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 425:	83 ec 08             	sub    $0x8,%esp
 428:	6a 00                	push   $0x0
 42a:	ff 75 08             	pushl  0x8(%ebp)
 42d:	e8 f0 00 00 00       	call   522 <open>
  if(fd < 0)
 432:	83 c4 10             	add    $0x10,%esp
 435:	85 c0                	test   %eax,%eax
 437:	78 27                	js     460 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 439:	83 ec 08             	sub    $0x8,%esp
 43c:	ff 75 0c             	pushl  0xc(%ebp)
 43f:	89 c3                	mov    %eax,%ebx
 441:	50                   	push   %eax
 442:	e8 f3 00 00 00       	call   53a <fstat>
  close(fd);
 447:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 44a:	89 c6                	mov    %eax,%esi
  close(fd);
 44c:	e8 b9 00 00 00       	call   50a <close>
  return r;
 451:	83 c4 10             	add    $0x10,%esp
}
 454:	8d 65 f8             	lea    -0x8(%ebp),%esp
 457:	89 f0                	mov    %esi,%eax
 459:	5b                   	pop    %ebx
 45a:	5e                   	pop    %esi
 45b:	5d                   	pop    %ebp
 45c:	c3                   	ret    
 45d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 460:	be ff ff ff ff       	mov    $0xffffffff,%esi
 465:	eb ed                	jmp    454 <stat+0x34>
 467:	89 f6                	mov    %esi,%esi
 469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000470 <atoi>:

int
atoi(const char *s)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	53                   	push   %ebx
 474:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 477:	0f be 11             	movsbl (%ecx),%edx
 47a:	8d 42 d0             	lea    -0x30(%edx),%eax
 47d:	3c 09                	cmp    $0x9,%al
  n = 0;
 47f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 484:	77 1f                	ja     4a5 <atoi+0x35>
 486:	8d 76 00             	lea    0x0(%esi),%esi
 489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 490:	8d 04 80             	lea    (%eax,%eax,4),%eax
 493:	83 c1 01             	add    $0x1,%ecx
 496:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 49a:	0f be 11             	movsbl (%ecx),%edx
 49d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 4a0:	80 fb 09             	cmp    $0x9,%bl
 4a3:	76 eb                	jbe    490 <atoi+0x20>
  return n;
}
 4a5:	5b                   	pop    %ebx
 4a6:	5d                   	pop    %ebp
 4a7:	c3                   	ret    
 4a8:	90                   	nop
 4a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000004b0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	56                   	push   %esi
 4b4:	53                   	push   %ebx
 4b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4b8:	8b 45 08             	mov    0x8(%ebp),%eax
 4bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4be:	85 db                	test   %ebx,%ebx
 4c0:	7e 14                	jle    4d6 <memmove+0x26>
 4c2:	31 d2                	xor    %edx,%edx
 4c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 4c8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 4cc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 4cf:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 4d2:	39 d3                	cmp    %edx,%ebx
 4d4:	75 f2                	jne    4c8 <memmove+0x18>
  return vdst;
}
 4d6:	5b                   	pop    %ebx
 4d7:	5e                   	pop    %esi
 4d8:	5d                   	pop    %ebp
 4d9:	c3                   	ret    

000004da <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4da:	b8 01 00 00 00       	mov    $0x1,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <exit>:
SYSCALL(exit)
 4e2:	b8 02 00 00 00       	mov    $0x2,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <wait>:
SYSCALL(wait)
 4ea:	b8 03 00 00 00       	mov    $0x3,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <pipe>:
SYSCALL(pipe)
 4f2:	b8 04 00 00 00       	mov    $0x4,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <read>:
SYSCALL(read)
 4fa:	b8 05 00 00 00       	mov    $0x5,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <write>:
SYSCALL(write)
 502:	b8 10 00 00 00       	mov    $0x10,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <close>:
SYSCALL(close)
 50a:	b8 15 00 00 00       	mov    $0x15,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <kill>:
SYSCALL(kill)
 512:	b8 06 00 00 00       	mov    $0x6,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <exec>:
SYSCALL(exec)
 51a:	b8 07 00 00 00       	mov    $0x7,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <open>:
SYSCALL(open)
 522:	b8 0f 00 00 00       	mov    $0xf,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <mknod>:
SYSCALL(mknod)
 52a:	b8 11 00 00 00       	mov    $0x11,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <unlink>:
SYSCALL(unlink)
 532:	b8 12 00 00 00       	mov    $0x12,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <fstat>:
SYSCALL(fstat)
 53a:	b8 08 00 00 00       	mov    $0x8,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <link>:
SYSCALL(link)
 542:	b8 13 00 00 00       	mov    $0x13,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <mkdir>:
SYSCALL(mkdir)
 54a:	b8 14 00 00 00       	mov    $0x14,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <chdir>:
SYSCALL(chdir)
 552:	b8 09 00 00 00       	mov    $0x9,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <dup>:
SYSCALL(dup)
 55a:	b8 0a 00 00 00       	mov    $0xa,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <getpid>:
SYSCALL(getpid)
 562:	b8 0b 00 00 00       	mov    $0xb,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <sbrk>:
SYSCALL(sbrk)
 56a:	b8 0c 00 00 00       	mov    $0xc,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <sleep>:
SYSCALL(sleep)
 572:	b8 0d 00 00 00       	mov    $0xd,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <uptime>:
SYSCALL(uptime)
 57a:	b8 0e 00 00 00       	mov    $0xe,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <protectPage>:
SYSCALL(protectPage)
 582:	b8 17 00 00 00       	mov    $0x17,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    
 58a:	66 90                	xchg   %ax,%ax
 58c:	66 90                	xchg   %ax,%ax
 58e:	66 90                	xchg   %ax,%ax

00000590 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	57                   	push   %edi
 594:	56                   	push   %esi
 595:	53                   	push   %ebx
 596:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 599:	85 d2                	test   %edx,%edx
{
 59b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 59e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 5a0:	79 76                	jns    618 <printint+0x88>
 5a2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5a6:	74 70                	je     618 <printint+0x88>
    x = -xx;
 5a8:	f7 d8                	neg    %eax
    neg = 1;
 5aa:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 5b1:	31 f6                	xor    %esi,%esi
 5b3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 5b6:	eb 0a                	jmp    5c2 <printint+0x32>
 5b8:	90                   	nop
 5b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 5c0:	89 fe                	mov    %edi,%esi
 5c2:	31 d2                	xor    %edx,%edx
 5c4:	8d 7e 01             	lea    0x1(%esi),%edi
 5c7:	f7 f1                	div    %ecx
 5c9:	0f b6 92 ac 0b 00 00 	movzbl 0xbac(%edx),%edx
  }while((x /= base) != 0);
 5d0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 5d2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 5d5:	75 e9                	jne    5c0 <printint+0x30>
  if(neg)
 5d7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 5da:	85 c0                	test   %eax,%eax
 5dc:	74 08                	je     5e6 <printint+0x56>
    buf[i++] = '-';
 5de:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 5e3:	8d 7e 02             	lea    0x2(%esi),%edi
 5e6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 5ea:	8b 7d c0             	mov    -0x40(%ebp),%edi
 5ed:	8d 76 00             	lea    0x0(%esi),%esi
 5f0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 5f3:	83 ec 04             	sub    $0x4,%esp
 5f6:	83 ee 01             	sub    $0x1,%esi
 5f9:	6a 01                	push   $0x1
 5fb:	53                   	push   %ebx
 5fc:	57                   	push   %edi
 5fd:	88 45 d7             	mov    %al,-0x29(%ebp)
 600:	e8 fd fe ff ff       	call   502 <write>

  while(--i >= 0)
 605:	83 c4 10             	add    $0x10,%esp
 608:	39 de                	cmp    %ebx,%esi
 60a:	75 e4                	jne    5f0 <printint+0x60>
    putc(fd, buf[i]);
}
 60c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 60f:	5b                   	pop    %ebx
 610:	5e                   	pop    %esi
 611:	5f                   	pop    %edi
 612:	5d                   	pop    %ebp
 613:	c3                   	ret    
 614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 618:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 61f:	eb 90                	jmp    5b1 <printint+0x21>
 621:	eb 0d                	jmp    630 <printf>
 623:	90                   	nop
 624:	90                   	nop
 625:	90                   	nop
 626:	90                   	nop
 627:	90                   	nop
 628:	90                   	nop
 629:	90                   	nop
 62a:	90                   	nop
 62b:	90                   	nop
 62c:	90                   	nop
 62d:	90                   	nop
 62e:	90                   	nop
 62f:	90                   	nop

00000630 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 630:	55                   	push   %ebp
 631:	89 e5                	mov    %esp,%ebp
 633:	57                   	push   %edi
 634:	56                   	push   %esi
 635:	53                   	push   %ebx
 636:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 639:	8b 75 0c             	mov    0xc(%ebp),%esi
 63c:	0f b6 1e             	movzbl (%esi),%ebx
 63f:	84 db                	test   %bl,%bl
 641:	0f 84 b3 00 00 00    	je     6fa <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 647:	8d 45 10             	lea    0x10(%ebp),%eax
 64a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 64d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 64f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 652:	eb 2f                	jmp    683 <printf+0x53>
 654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 658:	83 f8 25             	cmp    $0x25,%eax
 65b:	0f 84 a7 00 00 00    	je     708 <printf+0xd8>
  write(fd, &c, 1);
 661:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 664:	83 ec 04             	sub    $0x4,%esp
 667:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 66a:	6a 01                	push   $0x1
 66c:	50                   	push   %eax
 66d:	ff 75 08             	pushl  0x8(%ebp)
 670:	e8 8d fe ff ff       	call   502 <write>
 675:	83 c4 10             	add    $0x10,%esp
 678:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 67b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 67f:	84 db                	test   %bl,%bl
 681:	74 77                	je     6fa <printf+0xca>
    if(state == 0){
 683:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 685:	0f be cb             	movsbl %bl,%ecx
 688:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 68b:	74 cb                	je     658 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 68d:	83 ff 25             	cmp    $0x25,%edi
 690:	75 e6                	jne    678 <printf+0x48>
      if(c == 'd'){
 692:	83 f8 64             	cmp    $0x64,%eax
 695:	0f 84 05 01 00 00    	je     7a0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 69b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 6a1:	83 f9 70             	cmp    $0x70,%ecx
 6a4:	74 72                	je     718 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 6a6:	83 f8 73             	cmp    $0x73,%eax
 6a9:	0f 84 99 00 00 00    	je     748 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6af:	83 f8 63             	cmp    $0x63,%eax
 6b2:	0f 84 08 01 00 00    	je     7c0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 6b8:	83 f8 25             	cmp    $0x25,%eax
 6bb:	0f 84 ef 00 00 00    	je     7b0 <printf+0x180>
  write(fd, &c, 1);
 6c1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6c4:	83 ec 04             	sub    $0x4,%esp
 6c7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6cb:	6a 01                	push   $0x1
 6cd:	50                   	push   %eax
 6ce:	ff 75 08             	pushl  0x8(%ebp)
 6d1:	e8 2c fe ff ff       	call   502 <write>
 6d6:	83 c4 0c             	add    $0xc,%esp
 6d9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 6dc:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 6df:	6a 01                	push   $0x1
 6e1:	50                   	push   %eax
 6e2:	ff 75 08             	pushl  0x8(%ebp)
 6e5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6e8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 6ea:	e8 13 fe ff ff       	call   502 <write>
  for(i = 0; fmt[i]; i++){
 6ef:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 6f3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 6f6:	84 db                	test   %bl,%bl
 6f8:	75 89                	jne    683 <printf+0x53>
    }
  }
}
 6fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6fd:	5b                   	pop    %ebx
 6fe:	5e                   	pop    %esi
 6ff:	5f                   	pop    %edi
 700:	5d                   	pop    %ebp
 701:	c3                   	ret    
 702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 708:	bf 25 00 00 00       	mov    $0x25,%edi
 70d:	e9 66 ff ff ff       	jmp    678 <printf+0x48>
 712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 718:	83 ec 0c             	sub    $0xc,%esp
 71b:	b9 10 00 00 00       	mov    $0x10,%ecx
 720:	6a 00                	push   $0x0
 722:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 725:	8b 45 08             	mov    0x8(%ebp),%eax
 728:	8b 17                	mov    (%edi),%edx
 72a:	e8 61 fe ff ff       	call   590 <printint>
        ap++;
 72f:	89 f8                	mov    %edi,%eax
 731:	83 c4 10             	add    $0x10,%esp
      state = 0;
 734:	31 ff                	xor    %edi,%edi
        ap++;
 736:	83 c0 04             	add    $0x4,%eax
 739:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 73c:	e9 37 ff ff ff       	jmp    678 <printf+0x48>
 741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 748:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 74b:	8b 08                	mov    (%eax),%ecx
        ap++;
 74d:	83 c0 04             	add    $0x4,%eax
 750:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 753:	85 c9                	test   %ecx,%ecx
 755:	0f 84 8e 00 00 00    	je     7e9 <printf+0x1b9>
        while(*s != 0){
 75b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 75e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 760:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 762:	84 c0                	test   %al,%al
 764:	0f 84 0e ff ff ff    	je     678 <printf+0x48>
 76a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 76d:	89 de                	mov    %ebx,%esi
 76f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 772:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 775:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 778:	83 ec 04             	sub    $0x4,%esp
          s++;
 77b:	83 c6 01             	add    $0x1,%esi
 77e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 781:	6a 01                	push   $0x1
 783:	57                   	push   %edi
 784:	53                   	push   %ebx
 785:	e8 78 fd ff ff       	call   502 <write>
        while(*s != 0){
 78a:	0f b6 06             	movzbl (%esi),%eax
 78d:	83 c4 10             	add    $0x10,%esp
 790:	84 c0                	test   %al,%al
 792:	75 e4                	jne    778 <printf+0x148>
 794:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 797:	31 ff                	xor    %edi,%edi
 799:	e9 da fe ff ff       	jmp    678 <printf+0x48>
 79e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 7a0:	83 ec 0c             	sub    $0xc,%esp
 7a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 7a8:	6a 01                	push   $0x1
 7aa:	e9 73 ff ff ff       	jmp    722 <printf+0xf2>
 7af:	90                   	nop
  write(fd, &c, 1);
 7b0:	83 ec 04             	sub    $0x4,%esp
 7b3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 7b6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 7b9:	6a 01                	push   $0x1
 7bb:	e9 21 ff ff ff       	jmp    6e1 <printf+0xb1>
        putc(fd, *ap);
 7c0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 7c3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 7c6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 7c8:	6a 01                	push   $0x1
        ap++;
 7ca:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 7cd:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 7d0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 7d3:	50                   	push   %eax
 7d4:	ff 75 08             	pushl  0x8(%ebp)
 7d7:	e8 26 fd ff ff       	call   502 <write>
        ap++;
 7dc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 7df:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7e2:	31 ff                	xor    %edi,%edi
 7e4:	e9 8f fe ff ff       	jmp    678 <printf+0x48>
          s = "(null)";
 7e9:	bb a4 0b 00 00       	mov    $0xba4,%ebx
        while(*s != 0){
 7ee:	b8 28 00 00 00       	mov    $0x28,%eax
 7f3:	e9 72 ff ff ff       	jmp    76a <printf+0x13a>
 7f8:	66 90                	xchg   %ax,%ax
 7fa:	66 90                	xchg   %ax,%ax
 7fc:	66 90                	xchg   %ax,%ax
 7fe:	66 90                	xchg   %ax,%ax

00000800 <free>:
static Header *freep; // start of free list

// put block ap in free list
void
free(void *ap)
{
 800:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1; // point to block header
  // It scans the free list, starting at freep, looking for the place to insert the free block.
  // This is either between two existing blocks or at one end of the list.
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 801:	a1 6c 0f 00 00       	mov    0xf6c,%eax
{
 806:	89 e5                	mov    %esp,%ebp
 808:	57                   	push   %edi
 809:	56                   	push   %esi
 80a:	53                   	push   %ebx
 80b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1; // point to block header
 80e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 818:	39 c8                	cmp    %ecx,%eax
 81a:	8b 10                	mov    (%eax),%edx
 81c:	73 32                	jae    850 <free+0x50>
 81e:	39 d1                	cmp    %edx,%ecx
 820:	72 04                	jb     826 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 822:	39 d0                	cmp    %edx,%eax
 824:	72 32                	jb     858 <free+0x58>
      break; // freed block at start or end of arena
  // In any case, if the block being freed is adjacent to either neighbor, the adjacent blocks are combined.
  if(bp + bp->s.size == p->s.ptr){ // join to upper neighbor
 826:	8b 73 fc             	mov    -0x4(%ebx),%esi
 829:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 82c:	39 fa                	cmp    %edi,%edx
 82e:	74 30                	je     860 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 830:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){ // join to lower neighbor
 833:	8b 50 04             	mov    0x4(%eax),%edx
 836:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 839:	39 f1                	cmp    %esi,%ecx
 83b:	74 3a                	je     877 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 83d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 83f:	a3 6c 0f 00 00       	mov    %eax,0xf6c
}
 844:	5b                   	pop    %ebx
 845:	5e                   	pop    %esi
 846:	5f                   	pop    %edi
 847:	5d                   	pop    %ebp
 848:	c3                   	ret    
 849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 850:	39 d0                	cmp    %edx,%eax
 852:	72 04                	jb     858 <free+0x58>
 854:	39 d1                	cmp    %edx,%ecx
 856:	72 ce                	jb     826 <free+0x26>
{
 858:	89 d0                	mov    %edx,%eax
 85a:	eb bc                	jmp    818 <free+0x18>
 85c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 860:	03 72 04             	add    0x4(%edx),%esi
 863:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 866:	8b 10                	mov    (%eax),%edx
 868:	8b 12                	mov    (%edx),%edx
 86a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){ // join to lower neighbor
 86d:	8b 50 04             	mov    0x4(%eax),%edx
 870:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 873:	39 f1                	cmp    %esi,%ecx
 875:	75 c6                	jne    83d <free+0x3d>
    p->s.size += bp->s.size;
 877:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 87a:	a3 6c 0f 00 00       	mov    %eax,0xf6c
    p->s.size += bp->s.size;
 87f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 882:	8b 53 f8             	mov    -0x8(%ebx),%edx
 885:	89 10                	mov    %edx,(%eax)
}
 887:	5b                   	pop    %ebx
 888:	5e                   	pop    %esi
 889:	5f                   	pop    %edi
 88a:	5d                   	pop    %ebp
 88b:	c3                   	ret    
 88c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000890 <malloc>:
}

// general-purpose storage allocator
void*
malloc(uint nbytes)
{
 890:	55                   	push   %ebp
 891:	89 e5                	mov    %esp,%ebp
 893:	57                   	push   %edi
 894:	56                   	push   %esi
 895:	53                   	push   %ebx
 896:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 899:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){ // no free list yet
 89c:	8b 15 6c 0f 00 00    	mov    0xf6c,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a2:	8d 78 07             	lea    0x7(%eax),%edi
 8a5:	c1 ef 03             	shr    $0x3,%edi
 8a8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){ // no free list yet
 8ab:	85 d2                	test   %edx,%edx
 8ad:	0f 84 9d 00 00 00    	je     950 <malloc+0xc0>
 8b3:	8b 02                	mov    (%edx),%eax
 8b5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  // the free list is scanned until a big-enough block is found
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 8b8:	39 cf                	cmp    %ecx,%edi
 8ba:	76 6c                	jbe    928 <malloc+0x98>
 8bc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 8c2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8c7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 8ca:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 8d1:	eb 0e                	jmp    8e1 <malloc+0x51>
 8d3:	90                   	nop
 8d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8da:	8b 48 04             	mov    0x4(%eax),%ecx
 8dd:	39 f9                	cmp    %edi,%ecx
 8df:	73 47                	jae    928 <malloc+0x98>
	  // The pointer returned by malloc points at the free space (not at the header itself)
	  // which begins one unit beyond the header.
      return (void*)(p + 1);
    }
	// If no big-enough block is found, another large chunk is obtained from the OS and linked into the free list.
    if(p == freep)
 8e1:	39 05 6c 0f 00 00    	cmp    %eax,0xf6c
 8e7:	89 c2                	mov    %eax,%edx
 8e9:	75 ed                	jne    8d8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 8eb:	83 ec 0c             	sub    $0xc,%esp
 8ee:	56                   	push   %esi
 8ef:	e8 76 fc ff ff       	call   56a <sbrk>
  if(p == (char*)-1) // sbrk returns -1 if there was no space.
 8f4:	83 c4 10             	add    $0x10,%esp
 8f7:	83 f8 ff             	cmp    $0xffffffff,%eax
 8fa:	74 1c                	je     918 <malloc+0x88>
  hp->s.size = nu;
 8fc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8ff:	83 ec 0c             	sub    $0xc,%esp
 902:	83 c0 08             	add    $0x8,%eax
 905:	50                   	push   %eax
 906:	e8 f5 fe ff ff       	call   800 <free>
  return freep;
 90b:	8b 15 6c 0f 00 00    	mov    0xf6c,%edx
      if((p = morecore(nunits)) == 0)
 911:	83 c4 10             	add    $0x10,%esp
 914:	85 d2                	test   %edx,%edx
 916:	75 c0                	jne    8d8 <malloc+0x48>
        return 0;
  }
}
 918:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 91b:	31 c0                	xor    %eax,%eax
}
 91d:	5b                   	pop    %ebx
 91e:	5e                   	pop    %esi
 91f:	5f                   	pop    %edi
 920:	5d                   	pop    %ebp
 921:	c3                   	ret    
 922:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 928:	39 cf                	cmp    %ecx,%edi
 92a:	74 54                	je     980 <malloc+0xf0>
        p->s.size -= nunits;
 92c:	29 f9                	sub    %edi,%ecx
 92e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 931:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 934:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 937:	89 15 6c 0f 00 00    	mov    %edx,0xf6c
}
 93d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 940:	83 c0 08             	add    $0x8,%eax
}
 943:	5b                   	pop    %ebx
 944:	5e                   	pop    %esi
 945:	5f                   	pop    %edi
 946:	5d                   	pop    %ebp
 947:	c3                   	ret    
 948:	90                   	nop
 949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 950:	c7 05 6c 0f 00 00 70 	movl   $0xf70,0xf6c
 957:	0f 00 00 
 95a:	c7 05 70 0f 00 00 70 	movl   $0xf70,0xf70
 961:	0f 00 00 
    base.s.size = 0;
 964:	b8 70 0f 00 00       	mov    $0xf70,%eax
 969:	c7 05 74 0f 00 00 00 	movl   $0x0,0xf74
 970:	00 00 00 
 973:	e9 44 ff ff ff       	jmp    8bc <malloc+0x2c>
 978:	90                   	nop
 979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 980:	8b 08                	mov    (%eax),%ecx
 982:	89 0a                	mov    %ecx,(%edx)
 984:	eb b1                	jmp    937 <malloc+0xa7>
 986:	8d 76 00             	lea    0x0(%esi),%esi
 989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000990 <pmalloc>:
int pageSize = 4096;
int towpageSize = 8192;

// like malloc but also always allocate exactly 1 page, it will be page-aligned,
// if there is any free memory in the previously allocated page it will skip it.
void* pmalloc(){
 990:	55                   	push   %ebp
 991:	89 e5                	mov    %esp,%ebp
 993:	53                   	push   %ebx
 994:	83 ec 04             	sub    $0x4,%esp
  struct plink *pl;
  if(!plink_freep){ // empty list
 997:	8b 1d 78 0f 00 00    	mov    0xf78,%ebx
 99d:	85 db                	test   %ebx,%ebx
 99f:	75 0d                	jne    9ae <pmalloc+0x1e>
 9a1:	eb 5d                	jmp    a00 <pmalloc+0x70>
 9a3:	90                   	nop
 9a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    plink_freep->isFree = 0;
    return plink_freep;
  }
  pl = plink_freep;
  while(pl->next){
    if(pl->isFree){
 9a8:	85 d2                	test   %edx,%edx
 9aa:	75 0f                	jne    9bb <pmalloc+0x2b>
 9ac:	89 c3                	mov    %eax,%ebx
  while(pl->next){
 9ae:	8b 03                	mov    (%ebx),%eax
 9b0:	8b 53 04             	mov    0x4(%ebx),%edx
 9b3:	85 c0                	test   %eax,%eax
 9b5:	75 f1                	jne    9a8 <pmalloc+0x18>
      pl->isFree = 0;
      return pl;
    }
    pl = pl->next;
  }
  if(pl->isFree){ // reached last link
 9b7:	85 d2                	test   %edx,%edx
 9b9:	74 15                	je     9d0 <pmalloc+0x40>
    pl->isFree = 0;
 9bb:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    //printf(1, "plink=%d\n", pl->next);
    pl->next->next = 0;
    pl->next->isFree = 0;
    return pl->next;
  }
}
 9c2:	89 d8                	mov    %ebx,%eax
 9c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 9c7:	c9                   	leave  
 9c8:	c3                   	ret    
 9c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pl->next = (struct plink*)sbrk(pageSize);
 9d0:	83 ec 0c             	sub    $0xc,%esp
 9d3:	ff 35 68 0f 00 00    	pushl  0xf68
 9d9:	e8 8c fb ff ff       	call   56a <sbrk>
 9de:	89 03                	mov    %eax,(%ebx)
    pl->next->next = 0;
 9e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    return pl->next;
 9e6:	83 c4 10             	add    $0x10,%esp
    pl->next->isFree = 0;
 9e9:	8b 03                	mov    (%ebx),%eax
 9eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    return pl->next;
 9f2:	8b 1b                	mov    (%ebx),%ebx
}
 9f4:	89 d8                	mov    %ebx,%eax
 9f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 9f9:	c9                   	leave  
 9fa:	c3                   	ret    
 9fb:	90                   	nop
 9fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    plink_freep = (struct plink*)sbrk(pageSize);
 a00:	83 ec 0c             	sub    $0xc,%esp
 a03:	ff 35 68 0f 00 00    	pushl  0xf68
 a09:	e8 5c fb ff ff       	call   56a <sbrk>
 a0e:	a3 78 0f 00 00       	mov    %eax,0xf78
    plink_freep->next = 0;
 a13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    return plink_freep;
 a19:	83 c4 10             	add    $0x10,%esp
    plink_freep->isFree = 0;
 a1c:	8b 1d 78 0f 00 00    	mov    0xf78,%ebx
 a22:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
 a29:	89 d8                	mov    %ebx,%eax
 a2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 a2e:	c9                   	leave  
 a2f:	c3                   	ret    

00000a30 <protect_page>:

// this function will verify that the address of the pointer has been allocated using pmalloc.
// then it will protect the page, and return 1. return –1 on failure.
int protect_page(void* ap){
 a30:	55                   	push   %ebp
 a31:	89 e5                	mov    %esp,%ebp
 a33:	83 ec 08             	sub    $0x8,%esp
  struct plink *pl = plink_freep;
 a36:	a1 78 0f 00 00       	mov    0xf78,%eax
int protect_page(void* ap){
 a3b:	8b 55 08             	mov    0x8(%ebp),%edx
  while(pl){
 a3e:	85 c0                	test   %eax,%eax
 a40:	74 18                	je     a5a <protect_page+0x2a>
    if(pl == ap){
 a42:	39 d0                	cmp    %edx,%eax
 a44:	75 0e                	jne    a54 <protect_page+0x24>
 a46:	eb 20                	jmp    a68 <protect_page+0x38>
 a48:	90                   	nop
 a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a50:	39 c2                	cmp    %eax,%edx
 a52:	74 14                	je     a68 <protect_page+0x38>
      protectPage(pl);
      return 1;
    }
    pl = pl->next;
 a54:	8b 00                	mov    (%eax),%eax
  while(pl){
 a56:	85 c0                	test   %eax,%eax
 a58:	75 f6                	jne    a50 <protect_page+0x20>
  }
	return -1;
 a5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 a5f:	c9                   	leave  
 a60:	c3                   	ret    
 a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      protectPage(pl);
 a68:	83 ec 0c             	sub    $0xc,%esp
 a6b:	52                   	push   %edx
 a6c:	e8 11 fb ff ff       	call   582 <protectPage>
      return 1;
 a71:	83 c4 10             	add    $0x10,%esp
 a74:	b8 01 00 00 00       	mov    $0x1,%eax
}
 a79:	c9                   	leave  
 a7a:	c3                   	ret    
 a7b:	90                   	nop
 a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000a80 <pfree>:

// this function will attempt to release a protected page that pointed at the argument.
// return –1 on failure, 1 on success.
int pfree(void* ap){
  struct plink *pl = plink_freep;
 a80:	a1 78 0f 00 00       	mov    0xf78,%eax
int pfree(void* ap){
 a85:	55                   	push   %ebp
 a86:	89 e5                	mov    %esp,%ebp
  while(pl){
 a88:	85 c0                	test   %eax,%eax
int pfree(void* ap){
 a8a:	8b 55 08             	mov    0x8(%ebp),%edx
  while(pl){
 a8d:	74 13                	je     aa2 <pfree+0x22>
    if(pl == ap){
 a8f:	39 d0                	cmp    %edx,%eax
 a91:	75 09                	jne    a9c <pfree+0x1c>
 a93:	eb 1b                	jmp    ab0 <pfree+0x30>
 a95:	8d 76 00             	lea    0x0(%esi),%esi
 a98:	39 c2                	cmp    %eax,%edx
 a9a:	74 14                	je     ab0 <pfree+0x30>
      pl->isFree = 1;
      return 1;
    }
    pl = pl->next;
 a9c:	8b 00                	mov    (%eax),%eax
  while(pl){
 a9e:	85 c0                	test   %eax,%eax
 aa0:	75 f6                	jne    a98 <pfree+0x18>
  }
	return -1;
 aa2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 aa7:	5d                   	pop    %ebp
 aa8:	c3                   	ret    
 aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      pl->isFree = 1;
 ab0:	c7 42 04 01 00 00 00 	movl   $0x1,0x4(%edx)
      return 1;
 ab7:	b8 01 00 00 00       	mov    $0x1,%eax
}
 abc:	5d                   	pop    %ebp
 abd:	c3                   	ret    
