
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 90 33 10 80       	mov    $0x80103390,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 40 7a 10 80       	push   $0x80107a40
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 25 4a 00 00       	call   80104a80 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 0c 11 80       	mov    $0x80110cbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 7a 10 80       	push   $0x80107a47
80100097:	50                   	push   %eax
80100098:	e8 d3 48 00 00       	call   80104970 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e4:	e8 87 4a 00 00       	call   80104b70 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 29 4b 00 00       	call   80104c90 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 3e 48 00 00       	call   801049b0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 8d 24 00 00       	call   80102610 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 4e 7a 10 80       	push   $0x80107a4e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 9d 48 00 00       	call   80104a50 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 47 24 00 00       	jmp    80102610 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 5f 7a 10 80       	push   $0x80107a5f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 5c 48 00 00       	call   80104a50 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 0c 48 00 00       	call   80104a10 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 60 49 00 00       	call   80104b70 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 0d 11 80       	mov    0x80110d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 2f 4a 00 00       	jmp    80104c90 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 66 7a 10 80       	push   $0x80107a66
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 6b 15 00 00       	call   801017f0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 df 48 00 00       	call   80104b70 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002a7:	39 15 a4 0f 11 80    	cmp    %edx,0x80110fa4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 b5 10 80       	push   $0x8010b520
801002c0:	68 a0 0f 11 80       	push   $0x80110fa0
801002c5:	e8 46 40 00 00       	call   80104310 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 0f 11 80    	cmp    0x80110fa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 60 3a 00 00       	call   80103d40 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 9c 49 00 00       	call   80104c90 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 14 14 00 00       	call   80101710 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 0f 11 80 	movsbl -0x7feef0e0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 b5 10 80       	push   $0x8010b520
8010034d:	e8 3e 49 00 00       	call   80104c90 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 b6 13 00 00       	call   80101710 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 72 28 00 00       	call   80102c20 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 6d 7a 10 80       	push   $0x80107a6d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 b2 83 10 80 	movl   $0x801083b2,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 c3 46 00 00       	call   80104aa0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 81 7a 10 80       	push   $0x80107a81
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 a1 5f 00 00       	call   801063e0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 ef 5e 00 00       	call   801063e0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 e3 5e 00 00       	call   801063e0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 d7 5e 00 00       	call   801063e0 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 77 48 00 00       	call   80104da0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 aa 47 00 00       	call   80104cf0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 85 7a 10 80       	push   $0x80107a85
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 b0 7a 10 80 	movzbl -0x7fef8550(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 dc 11 00 00       	call   801017f0 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 50 45 00 00       	call   80104b70 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 44 46 00 00       	call   80104c90 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 bb 10 00 00       	call   80101710 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 b5 10 80       	push   $0x8010b520
8010071f:	e8 6c 45 00 00       	call   80104c90 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 98 7a 10 80       	mov    $0x80107a98,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 7b 43 00 00       	call   80104b70 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 9f 7a 10 80       	push   $0x80107a9f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 b5 10 80       	push   $0x8010b520
80100823:	e8 48 43 00 00       	call   80104b70 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100856:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 b5 10 80       	push   $0x8010b520
80100888:	e8 03 44 00 00       	call   80104c90 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
80100911:	68 a0 0f 11 80       	push   $0x80110fa0
80100916:	e8 b5 3b 00 00       	call   801044d0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010093d:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100964:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 14 3c 00 00       	jmp    801045b0 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 a8 7a 10 80       	push   $0x80107aa8
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 ab 40 00 00       	call   80104a80 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 19 11 80 00 	movl   $0x80100600,0x8011196c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 19 11 80 70 	movl   $0x80100270,0x80111968
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 c2 1d 00 00       	call   801027c0 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 1f 33 00 00       	call   80103d40 <myproc>
80100a21:	89 c7                	mov    %eax,%edi

  begin_op();
80100a23:	e8 68 26 00 00       	call   80103090 <begin_op>

  if((ip = namei(path)) == 0){
80100a28:	83 ec 0c             	sub    $0xc,%esp
80100a2b:	ff 75 08             	pushl  0x8(%ebp)
80100a2e:	e8 3d 15 00 00       	call   80101f70 <namei>
80100a33:	83 c4 10             	add    $0x10,%esp
80100a36:	85 c0                	test   %eax,%eax
80100a38:	0f 84 03 02 00 00    	je     80100c41 <exec+0x231>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a3e:	83 ec 0c             	sub    $0xc,%esp
80100a41:	89 c3                	mov    %eax,%ebx
80100a43:	50                   	push   %eax
80100a44:	e8 c7 0c 00 00       	call   80101710 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a49:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a4f:	6a 34                	push   $0x34
80100a51:	6a 00                	push   $0x0
80100a53:	50                   	push   %eax
80100a54:	53                   	push   %ebx
80100a55:	e8 96 0f 00 00       	call   801019f0 <readi>
80100a5a:	83 c4 20             	add    $0x20,%esp
80100a5d:	83 f8 34             	cmp    $0x34,%eax
80100a60:	74 1e                	je     80100a80 <exec+0x70>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a62:	83 ec 0c             	sub    $0xc,%esp
80100a65:	53                   	push   %ebx
80100a66:	e8 35 0f 00 00       	call   801019a0 <iunlockput>
    end_op();
80100a6b:	e8 90 26 00 00       	call   80103100 <end_op>
80100a70:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7b:	5b                   	pop    %ebx
80100a7c:	5e                   	pop    %esi
80100a7d:	5f                   	pop    %edi
80100a7e:	5d                   	pop    %ebp
80100a7f:	c3                   	ret    
  if(elf.magic != ELF_MAGIC)
80100a80:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a87:	45 4c 46 
80100a8a:	75 d6                	jne    80100a62 <exec+0x52>
  if((pgdir = setupkvm()) == 0)
80100a8c:	e8 6f 6b 00 00       	call   80107600 <setupkvm>
80100a91:	85 c0                	test   %eax,%eax
80100a93:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a99:	74 c7                	je     80100a62 <exec+0x52>
  if(curproc->swapFile){
80100a9b:	8b 4f 7c             	mov    0x7c(%edi),%ecx
80100a9e:	85 c9                	test   %ecx,%ecx
80100aa0:	74 0c                	je     80100aae <exec+0x9e>
    removeSwapFile(curproc);
80100aa2:	83 ec 0c             	sub    $0xc,%esp
80100aa5:	57                   	push   %edi
80100aa6:	e8 95 15 00 00       	call   80102040 <removeSwapFile>
80100aab:	83 c4 10             	add    $0x10,%esp
  if(strncmp(curproc->name,"init",4) != 0 || strncmp(curproc->name,"sh",2) != 0){ 
80100aae:	8d 47 6c             	lea    0x6c(%edi),%eax
80100ab1:	83 ec 04             	sub    $0x4,%esp
80100ab4:	6a 04                	push   $0x4
80100ab6:	68 cd 7a 10 80       	push   $0x80107acd
80100abb:	50                   	push   %eax
80100abc:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ac2:	e8 49 43 00 00       	call   80104e10 <strncmp>
80100ac7:	83 c4 10             	add    $0x10,%esp
80100aca:	85 c0                	test   %eax,%eax
80100acc:	75 1c                	jne    80100aea <exec+0xda>
80100ace:	83 ec 04             	sub    $0x4,%esp
80100ad1:	6a 02                	push   $0x2
80100ad3:	68 d2 7a 10 80       	push   $0x80107ad2
80100ad8:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100ade:	e8 2d 43 00 00       	call   80104e10 <strncmp>
80100ae3:	83 c4 10             	add    $0x10,%esp
80100ae6:	85 c0                	test   %eax,%eax
80100ae8:	74 0c                	je     80100af6 <exec+0xe6>
    createSwapFile(curproc);
80100aea:	83 ec 0c             	sub    $0xc,%esp
80100aed:	57                   	push   %edi
80100aee:	e8 4d 17 00 00       	call   80102240 <createSwapFile>
80100af3:	83 c4 10             	add    $0x10,%esp
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100af6:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100afc:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
  sz = 0;
80100b02:	31 c0                	xor    %eax,%eax
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b04:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b0b:	00 
80100b0c:	0f 84 a9 02 00 00    	je     80100dbb <exec+0x3ab>
80100b12:	89 bd e8 fe ff ff    	mov    %edi,-0x118(%ebp)
80100b18:	31 f6                	xor    %esi,%esi
80100b1a:	89 c7                	mov    %eax,%edi
80100b1c:	eb 7c                	jmp    80100b9a <exec+0x18a>
80100b1e:	66 90                	xchg   %ax,%ax
    if(ph.type != ELF_PROG_LOAD)
80100b20:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b27:	75 63                	jne    80100b8c <exec+0x17c>
    if(ph.memsz < ph.filesz)
80100b29:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b2f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b35:	0f 82 86 00 00 00    	jb     80100bc1 <exec+0x1b1>
80100b3b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b41:	72 7e                	jb     80100bc1 <exec+0x1b1>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b43:	83 ec 04             	sub    $0x4,%esp
80100b46:	50                   	push   %eax
80100b47:	57                   	push   %edi
80100b48:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b4e:	e8 8d 68 00 00       	call   801073e0 <allocuvm>
80100b53:	83 c4 10             	add    $0x10,%esp
80100b56:	85 c0                	test   %eax,%eax
80100b58:	89 c7                	mov    %eax,%edi
80100b5a:	74 65                	je     80100bc1 <exec+0x1b1>
    if(ph.vaddr % PGSIZE != 0)
80100b5c:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b62:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b67:	75 58                	jne    80100bc1 <exec+0x1b1>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b72:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b78:	53                   	push   %ebx
80100b79:	50                   	push   %eax
80100b7a:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b80:	e8 0b 67 00 00       	call   80107290 <loaduvm>
80100b85:	83 c4 20             	add    $0x20,%esp
80100b88:	85 c0                	test   %eax,%eax
80100b8a:	78 35                	js     80100bc1 <exec+0x1b1>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b8c:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b93:	83 c6 01             	add    $0x1,%esi
80100b96:	39 f0                	cmp    %esi,%eax
80100b98:	7e 3d                	jle    80100bd7 <exec+0x1c7>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b9a:	89 f0                	mov    %esi,%eax
80100b9c:	6a 20                	push   $0x20
80100b9e:	c1 e0 05             	shl    $0x5,%eax
80100ba1:	03 85 f0 fe ff ff    	add    -0x110(%ebp),%eax
80100ba7:	50                   	push   %eax
80100ba8:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bae:	50                   	push   %eax
80100baf:	53                   	push   %ebx
80100bb0:	e8 3b 0e 00 00       	call   801019f0 <readi>
80100bb5:	83 c4 10             	add    $0x10,%esp
80100bb8:	83 f8 20             	cmp    $0x20,%eax
80100bbb:	0f 84 5f ff ff ff    	je     80100b20 <exec+0x110>
    freevm(pgdir);
80100bc1:	83 ec 0c             	sub    $0xc,%esp
80100bc4:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bca:	e8 b1 69 00 00       	call   80107580 <freevm>
80100bcf:	83 c4 10             	add    $0x10,%esp
80100bd2:	e9 8b fe ff ff       	jmp    80100a62 <exec+0x52>
80100bd7:	89 f8                	mov    %edi,%eax
80100bd9:	8b bd e8 fe ff ff    	mov    -0x118(%ebp),%edi
80100bdf:	05 ff 0f 00 00       	add    $0xfff,%eax
80100be4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100be9:	8d b0 00 20 00 00    	lea    0x2000(%eax),%esi
  iunlockput(ip);
80100bef:	83 ec 0c             	sub    $0xc,%esp
80100bf2:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bf8:	53                   	push   %ebx
80100bf9:	e8 a2 0d 00 00       	call   801019a0 <iunlockput>
  end_op();
80100bfe:	e8 fd 24 00 00       	call   80103100 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c03:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c09:	83 c4 0c             	add    $0xc,%esp
80100c0c:	56                   	push   %esi
80100c0d:	50                   	push   %eax
80100c0e:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c14:	e8 c7 67 00 00       	call   801073e0 <allocuvm>
80100c19:	83 c4 10             	add    $0x10,%esp
80100c1c:	85 c0                	test   %eax,%eax
80100c1e:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c24:	75 3a                	jne    80100c60 <exec+0x250>
    freevm(pgdir);
80100c26:	83 ec 0c             	sub    $0xc,%esp
80100c29:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c2f:	e8 4c 69 00 00       	call   80107580 <freevm>
80100c34:	83 c4 10             	add    $0x10,%esp
  return -1;
80100c37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c3c:	e9 37 fe ff ff       	jmp    80100a78 <exec+0x68>
    end_op();
80100c41:	e8 ba 24 00 00       	call   80103100 <end_op>
    cprintf("exec: fail\n");
80100c46:	83 ec 0c             	sub    $0xc,%esp
80100c49:	68 c1 7a 10 80       	push   $0x80107ac1
80100c4e:	e8 0d fa ff ff       	call   80100660 <cprintf>
    return -1;
80100c53:	83 c4 10             	add    $0x10,%esp
80100c56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c5b:	e9 18 fe ff ff       	jmp    80100a78 <exec+0x68>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c60:	89 c3                	mov    %eax,%ebx
80100c62:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100c68:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100c6b:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c6d:	50                   	push   %eax
80100c6e:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c74:	e8 27 6a 00 00       	call   801076a0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c79:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c7c:	83 c4 10             	add    $0x10,%esp
80100c7f:	8b 00                	mov    (%eax),%eax
80100c81:	85 c0                	test   %eax,%eax
80100c83:	0f 84 3c 01 00 00    	je     80100dc5 <exec+0x3b5>
80100c89:	89 bd e8 fe ff ff    	mov    %edi,-0x118(%ebp)
80100c8f:	89 f7                	mov    %esi,%edi
80100c91:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c97:	eb 0c                	jmp    80100ca5 <exec+0x295>
80100c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100ca0:	83 ff 20             	cmp    $0x20,%edi
80100ca3:	74 81                	je     80100c26 <exec+0x216>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ca5:	83 ec 0c             	sub    $0xc,%esp
80100ca8:	50                   	push   %eax
80100ca9:	e8 62 42 00 00       	call   80104f10 <strlen>
80100cae:	f7 d0                	not    %eax
80100cb0:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb2:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cb5:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb6:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb9:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cbc:	e8 4f 42 00 00       	call   80104f10 <strlen>
80100cc1:	83 c0 01             	add    $0x1,%eax
80100cc4:	50                   	push   %eax
80100cc5:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc8:	ff 34 b8             	pushl  (%eax,%edi,4)
80100ccb:	53                   	push   %ebx
80100ccc:	56                   	push   %esi
80100ccd:	e8 1e 6b 00 00       	call   801077f0 <copyout>
80100cd2:	83 c4 20             	add    $0x20,%esp
80100cd5:	85 c0                	test   %eax,%eax
80100cd7:	0f 88 49 ff ff ff    	js     80100c26 <exec+0x216>
  for(argc = 0; argv[argc]; argc++) {
80100cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100ce0:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100ce7:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cea:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cf0:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cf3:	85 c0                	test   %eax,%eax
80100cf5:	75 a9                	jne    80100ca0 <exec+0x290>
80100cf7:	89 fe                	mov    %edi,%esi
80100cf9:	8b bd e8 fe ff ff    	mov    -0x118(%ebp),%edi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cff:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100d06:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d08:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100d0f:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100d13:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d1a:	ff ff ff 
  ustack[1] = argc;
80100d1d:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d23:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d25:	83 c0 0c             	add    $0xc,%eax
80100d28:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d2a:	50                   	push   %eax
80100d2b:	52                   	push   %edx
80100d2c:	53                   	push   %ebx
80100d2d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d33:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d39:	e8 b2 6a 00 00       	call   801077f0 <copyout>
80100d3e:	83 c4 10             	add    $0x10,%esp
80100d41:	85 c0                	test   %eax,%eax
80100d43:	0f 88 dd fe ff ff    	js     80100c26 <exec+0x216>
  for(last=s=path; *s; s++)
80100d49:	8b 45 08             	mov    0x8(%ebp),%eax
80100d4c:	0f b6 00             	movzbl (%eax),%eax
80100d4f:	84 c0                	test   %al,%al
80100d51:	74 17                	je     80100d6a <exec+0x35a>
80100d53:	8b 55 08             	mov    0x8(%ebp),%edx
80100d56:	89 d1                	mov    %edx,%ecx
80100d58:	83 c1 01             	add    $0x1,%ecx
80100d5b:	3c 2f                	cmp    $0x2f,%al
80100d5d:	0f b6 01             	movzbl (%ecx),%eax
80100d60:	0f 44 d1             	cmove  %ecx,%edx
80100d63:	84 c0                	test   %al,%al
80100d65:	75 f1                	jne    80100d58 <exec+0x348>
80100d67:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d6a:	50                   	push   %eax
80100d6b:	6a 10                	push   $0x10
80100d6d:	ff 75 08             	pushl  0x8(%ebp)
80100d70:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100d76:	e8 55 41 00 00       	call   80104ed0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d7b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  oldpgdir = curproc->pgdir;
80100d81:	8b 77 04             	mov    0x4(%edi),%esi
  curproc->pgdir = pgdir;
80100d84:	89 47 04             	mov    %eax,0x4(%edi)
  curproc->sz = sz;
80100d87:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d8d:	89 07                	mov    %eax,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100d8f:	8b 47 18             	mov    0x18(%edi),%eax
80100d92:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d98:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d9b:	8b 47 18             	mov    0x18(%edi),%eax
80100d9e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100da1:	89 3c 24             	mov    %edi,(%esp)
80100da4:	e8 57 63 00 00       	call   80107100 <switchuvm>
  freevm(oldpgdir);
80100da9:	89 34 24             	mov    %esi,(%esp)
80100dac:	e8 cf 67 00 00       	call   80107580 <freevm>
  return 0;
80100db1:	83 c4 10             	add    $0x10,%esp
80100db4:	31 c0                	xor    %eax,%eax
80100db6:	e9 bd fc ff ff       	jmp    80100a78 <exec+0x68>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dbb:	be 00 20 00 00       	mov    $0x2000,%esi
80100dc0:	e9 2a fe ff ff       	jmp    80100bef <exec+0x1df>
  for(argc = 0; argv[argc]; argc++) {
80100dc5:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100dcb:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100dd1:	e9 29 ff ff ff       	jmp    80100cff <exec+0x2ef>
80100dd6:	66 90                	xchg   %ax,%ax
80100dd8:	66 90                	xchg   %ax,%ax
80100dda:	66 90                	xchg   %ax,%ax
80100ddc:	66 90                	xchg   %ax,%ax
80100dde:	66 90                	xchg   %ax,%ax

80100de0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100de6:	68 d5 7a 10 80       	push   $0x80107ad5
80100deb:	68 c0 0f 11 80       	push   $0x80110fc0
80100df0:	e8 8b 3c 00 00       	call   80104a80 <initlock>
}
80100df5:	83 c4 10             	add    $0x10,%esp
80100df8:	c9                   	leave  
80100df9:	c3                   	ret    
80100dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e00:	55                   	push   %ebp
80100e01:	89 e5                	mov    %esp,%ebp
80100e03:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e04:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100e09:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e0c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e11:	e8 5a 3d 00 00       	call   80104b70 <acquire>
80100e16:	83 c4 10             	add    $0x10,%esp
80100e19:	eb 10                	jmp    80100e2b <filealloc+0x2b>
80100e1b:	90                   	nop
80100e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100e29:	73 25                	jae    80100e50 <filealloc+0x50>
    if(f->ref == 0){
80100e2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	75 ee                	jne    80100e20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e32:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e3c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e41:	e8 4a 3e 00 00       	call   80104c90 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e46:	89 d8                	mov    %ebx,%eax
      return f;
80100e48:	83 c4 10             	add    $0x10,%esp
}
80100e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4e:	c9                   	leave  
80100e4f:	c3                   	ret    
  release(&ftable.lock);
80100e50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e53:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e55:	68 c0 0f 11 80       	push   $0x80110fc0
80100e5a:	e8 31 3e 00 00       	call   80104c90 <release>
}
80100e5f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e61:	83 c4 10             	add    $0x10,%esp
}
80100e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e67:	c9                   	leave  
80100e68:	c3                   	ret    
80100e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e70:	55                   	push   %ebp
80100e71:	89 e5                	mov    %esp,%ebp
80100e73:	53                   	push   %ebx
80100e74:	83 ec 10             	sub    $0x10,%esp
80100e77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e7a:	68 c0 0f 11 80       	push   $0x80110fc0
80100e7f:	e8 ec 3c 00 00       	call   80104b70 <acquire>
  if(f->ref < 1)
80100e84:	8b 43 04             	mov    0x4(%ebx),%eax
80100e87:	83 c4 10             	add    $0x10,%esp
80100e8a:	85 c0                	test   %eax,%eax
80100e8c:	7e 1a                	jle    80100ea8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e8e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e91:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e94:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e97:	68 c0 0f 11 80       	push   $0x80110fc0
80100e9c:	e8 ef 3d 00 00       	call   80104c90 <release>
  return f;
}
80100ea1:	89 d8                	mov    %ebx,%eax
80100ea3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ea6:	c9                   	leave  
80100ea7:	c3                   	ret    
    panic("filedup");
80100ea8:	83 ec 0c             	sub    $0xc,%esp
80100eab:	68 dc 7a 10 80       	push   $0x80107adc
80100eb0:	e8 db f4 ff ff       	call   80100390 <panic>
80100eb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100ec0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	57                   	push   %edi
80100ec4:	56                   	push   %esi
80100ec5:	53                   	push   %ebx
80100ec6:	83 ec 28             	sub    $0x28,%esp
80100ec9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ecc:	68 c0 0f 11 80       	push   $0x80110fc0
80100ed1:	e8 9a 3c 00 00       	call   80104b70 <acquire>
  if(f->ref < 1)
80100ed6:	8b 43 04             	mov    0x4(%ebx),%eax
80100ed9:	83 c4 10             	add    $0x10,%esp
80100edc:	85 c0                	test   %eax,%eax
80100ede:	0f 8e 9b 00 00 00    	jle    80100f7f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100ee4:	83 e8 01             	sub    $0x1,%eax
80100ee7:	85 c0                	test   %eax,%eax
80100ee9:	89 43 04             	mov    %eax,0x4(%ebx)
80100eec:	74 1a                	je     80100f08 <fileclose+0x48>
    release(&ftable.lock);
80100eee:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100ef5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef8:	5b                   	pop    %ebx
80100ef9:	5e                   	pop    %esi
80100efa:	5f                   	pop    %edi
80100efb:	5d                   	pop    %ebp
    release(&ftable.lock);
80100efc:	e9 8f 3d 00 00       	jmp    80104c90 <release>
80100f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100f08:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100f0c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100f0e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f11:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100f14:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f1a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f1d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f20:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100f25:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f28:	e8 63 3d 00 00       	call   80104c90 <release>
  if(ff.type == FD_PIPE)
80100f2d:	83 c4 10             	add    $0x10,%esp
80100f30:	83 ff 01             	cmp    $0x1,%edi
80100f33:	74 13                	je     80100f48 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100f35:	83 ff 02             	cmp    $0x2,%edi
80100f38:	74 26                	je     80100f60 <fileclose+0xa0>
}
80100f3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3d:	5b                   	pop    %ebx
80100f3e:	5e                   	pop    %esi
80100f3f:	5f                   	pop    %edi
80100f40:	5d                   	pop    %ebp
80100f41:	c3                   	ret    
80100f42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100f48:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f4c:	83 ec 08             	sub    $0x8,%esp
80100f4f:	53                   	push   %ebx
80100f50:	56                   	push   %esi
80100f51:	e8 ea 28 00 00       	call   80103840 <pipeclose>
80100f56:	83 c4 10             	add    $0x10,%esp
80100f59:	eb df                	jmp    80100f3a <fileclose+0x7a>
80100f5b:	90                   	nop
80100f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f60:	e8 2b 21 00 00       	call   80103090 <begin_op>
    iput(ff.ip);
80100f65:	83 ec 0c             	sub    $0xc,%esp
80100f68:	ff 75 e0             	pushl  -0x20(%ebp)
80100f6b:	e8 d0 08 00 00       	call   80101840 <iput>
    end_op();
80100f70:	83 c4 10             	add    $0x10,%esp
}
80100f73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f76:	5b                   	pop    %ebx
80100f77:	5e                   	pop    %esi
80100f78:	5f                   	pop    %edi
80100f79:	5d                   	pop    %ebp
    end_op();
80100f7a:	e9 81 21 00 00       	jmp    80103100 <end_op>
    panic("fileclose");
80100f7f:	83 ec 0c             	sub    $0xc,%esp
80100f82:	68 e4 7a 10 80       	push   $0x80107ae4
80100f87:	e8 04 f4 ff ff       	call   80100390 <panic>
80100f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f90 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f90:	55                   	push   %ebp
80100f91:	89 e5                	mov    %esp,%ebp
80100f93:	53                   	push   %ebx
80100f94:	83 ec 04             	sub    $0x4,%esp
80100f97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f9a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f9d:	75 31                	jne    80100fd0 <filestat+0x40>
    ilock(f->ip);
80100f9f:	83 ec 0c             	sub    $0xc,%esp
80100fa2:	ff 73 10             	pushl  0x10(%ebx)
80100fa5:	e8 66 07 00 00       	call   80101710 <ilock>
    stati(f->ip, st);
80100faa:	58                   	pop    %eax
80100fab:	5a                   	pop    %edx
80100fac:	ff 75 0c             	pushl  0xc(%ebp)
80100faf:	ff 73 10             	pushl  0x10(%ebx)
80100fb2:	e8 09 0a 00 00       	call   801019c0 <stati>
    iunlock(f->ip);
80100fb7:	59                   	pop    %ecx
80100fb8:	ff 73 10             	pushl  0x10(%ebx)
80100fbb:	e8 30 08 00 00       	call   801017f0 <iunlock>
    return 0;
80100fc0:	83 c4 10             	add    $0x10,%esp
80100fc3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100fc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fc8:	c9                   	leave  
80100fc9:	c3                   	ret    
80100fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fd5:	eb ee                	jmp    80100fc5 <filestat+0x35>
80100fd7:	89 f6                	mov    %esi,%esi
80100fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fe0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 0c             	sub    $0xc,%esp
80100fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100fec:	8b 75 0c             	mov    0xc(%ebp),%esi
80100fef:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100ff2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100ff6:	74 60                	je     80101058 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100ff8:	8b 03                	mov    (%ebx),%eax
80100ffa:	83 f8 01             	cmp    $0x1,%eax
80100ffd:	74 41                	je     80101040 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fff:	83 f8 02             	cmp    $0x2,%eax
80101002:	75 5b                	jne    8010105f <fileread+0x7f>
    ilock(f->ip);
80101004:	83 ec 0c             	sub    $0xc,%esp
80101007:	ff 73 10             	pushl  0x10(%ebx)
8010100a:	e8 01 07 00 00       	call   80101710 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010100f:	57                   	push   %edi
80101010:	ff 73 14             	pushl  0x14(%ebx)
80101013:	56                   	push   %esi
80101014:	ff 73 10             	pushl  0x10(%ebx)
80101017:	e8 d4 09 00 00       	call   801019f0 <readi>
8010101c:	83 c4 20             	add    $0x20,%esp
8010101f:	85 c0                	test   %eax,%eax
80101021:	89 c6                	mov    %eax,%esi
80101023:	7e 03                	jle    80101028 <fileread+0x48>
      f->off += r;
80101025:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101028:	83 ec 0c             	sub    $0xc,%esp
8010102b:	ff 73 10             	pushl  0x10(%ebx)
8010102e:	e8 bd 07 00 00       	call   801017f0 <iunlock>
    return r;
80101033:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101036:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101039:	89 f0                	mov    %esi,%eax
8010103b:	5b                   	pop    %ebx
8010103c:	5e                   	pop    %esi
8010103d:	5f                   	pop    %edi
8010103e:	5d                   	pop    %ebp
8010103f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101040:	8b 43 0c             	mov    0xc(%ebx),%eax
80101043:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101046:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101049:	5b                   	pop    %ebx
8010104a:	5e                   	pop    %esi
8010104b:	5f                   	pop    %edi
8010104c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010104d:	e9 9e 29 00 00       	jmp    801039f0 <piperead>
80101052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101058:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010105d:	eb d7                	jmp    80101036 <fileread+0x56>
  panic("fileread");
8010105f:	83 ec 0c             	sub    $0xc,%esp
80101062:	68 ee 7a 10 80       	push   $0x80107aee
80101067:	e8 24 f3 ff ff       	call   80100390 <panic>
8010106c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101070 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101070:	55                   	push   %ebp
80101071:	89 e5                	mov    %esp,%ebp
80101073:	57                   	push   %edi
80101074:	56                   	push   %esi
80101075:	53                   	push   %ebx
80101076:	83 ec 1c             	sub    $0x1c,%esp
80101079:	8b 75 08             	mov    0x8(%ebp),%esi
8010107c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010107f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101083:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101086:	8b 45 10             	mov    0x10(%ebp),%eax
80101089:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010108c:	0f 84 aa 00 00 00    	je     8010113c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101092:	8b 06                	mov    (%esi),%eax
80101094:	83 f8 01             	cmp    $0x1,%eax
80101097:	0f 84 c3 00 00 00    	je     80101160 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010109d:	83 f8 02             	cmp    $0x2,%eax
801010a0:	0f 85 d9 00 00 00    	jne    8010117f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010a9:	31 ff                	xor    %edi,%edi
    while(i < n){
801010ab:	85 c0                	test   %eax,%eax
801010ad:	7f 34                	jg     801010e3 <filewrite+0x73>
801010af:	e9 9c 00 00 00       	jmp    80101150 <filewrite+0xe0>
801010b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010b8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010bb:	83 ec 0c             	sub    $0xc,%esp
801010be:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010c4:	e8 27 07 00 00       	call   801017f0 <iunlock>
      end_op();
801010c9:	e8 32 20 00 00       	call   80103100 <end_op>
801010ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010d1:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
801010d4:	39 c3                	cmp    %eax,%ebx
801010d6:	0f 85 96 00 00 00    	jne    80101172 <filewrite+0x102>
        panic("short filewrite");
      i += r;
801010dc:	01 df                	add    %ebx,%edi
    while(i < n){
801010de:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010e1:	7e 6d                	jle    80101150 <filewrite+0xe0>
      int n1 = n - i;
801010e3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801010e6:	b8 00 06 00 00       	mov    $0x600,%eax
801010eb:	29 fb                	sub    %edi,%ebx
801010ed:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801010f3:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801010f6:	e8 95 1f 00 00       	call   80103090 <begin_op>
      ilock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 76 10             	pushl  0x10(%esi)
80101101:	e8 0a 06 00 00       	call   80101710 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101106:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101109:	53                   	push   %ebx
8010110a:	ff 76 14             	pushl  0x14(%esi)
8010110d:	01 f8                	add    %edi,%eax
8010110f:	50                   	push   %eax
80101110:	ff 76 10             	pushl  0x10(%esi)
80101113:	e8 d8 09 00 00       	call   80101af0 <writei>
80101118:	83 c4 20             	add    $0x20,%esp
8010111b:	85 c0                	test   %eax,%eax
8010111d:	7f 99                	jg     801010b8 <filewrite+0x48>
      iunlock(f->ip);
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	ff 76 10             	pushl  0x10(%esi)
80101125:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101128:	e8 c3 06 00 00       	call   801017f0 <iunlock>
      end_op();
8010112d:	e8 ce 1f 00 00       	call   80103100 <end_op>
      if(r < 0)
80101132:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101135:	83 c4 10             	add    $0x10,%esp
80101138:	85 c0                	test   %eax,%eax
8010113a:	74 98                	je     801010d4 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010113c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010113f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101144:	89 f8                	mov    %edi,%eax
80101146:	5b                   	pop    %ebx
80101147:	5e                   	pop    %esi
80101148:	5f                   	pop    %edi
80101149:	5d                   	pop    %ebp
8010114a:	c3                   	ret    
8010114b:	90                   	nop
8010114c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101150:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101153:	75 e7                	jne    8010113c <filewrite+0xcc>
}
80101155:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101158:	89 f8                	mov    %edi,%eax
8010115a:	5b                   	pop    %ebx
8010115b:	5e                   	pop    %esi
8010115c:	5f                   	pop    %edi
8010115d:	5d                   	pop    %ebp
8010115e:	c3                   	ret    
8010115f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101160:	8b 46 0c             	mov    0xc(%esi),%eax
80101163:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101166:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101169:	5b                   	pop    %ebx
8010116a:	5e                   	pop    %esi
8010116b:	5f                   	pop    %edi
8010116c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010116d:	e9 6e 27 00 00       	jmp    801038e0 <pipewrite>
        panic("short filewrite");
80101172:	83 ec 0c             	sub    $0xc,%esp
80101175:	68 f7 7a 10 80       	push   $0x80107af7
8010117a:	e8 11 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010117f:	83 ec 0c             	sub    $0xc,%esp
80101182:	68 fd 7a 10 80       	push   $0x80107afd
80101187:	e8 04 f2 ff ff       	call   80100390 <panic>
8010118c:	66 90                	xchg   %ax,%ax
8010118e:	66 90                	xchg   %ax,%ax

80101190 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101190:	55                   	push   %ebp
80101191:	89 e5                	mov    %esp,%ebp
80101193:	57                   	push   %edi
80101194:	56                   	push   %esi
80101195:	53                   	push   %ebx
80101196:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101199:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
{
8010119f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011a2:	85 c9                	test   %ecx,%ecx
801011a4:	0f 84 87 00 00 00    	je     80101231 <balloc+0xa1>
801011aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011b1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011b4:	83 ec 08             	sub    $0x8,%esp
801011b7:	89 f0                	mov    %esi,%eax
801011b9:	c1 f8 0c             	sar    $0xc,%eax
801011bc:	03 05 d8 19 11 80    	add    0x801119d8,%eax
801011c2:	50                   	push   %eax
801011c3:	ff 75 d8             	pushl  -0x28(%ebp)
801011c6:	e8 05 ef ff ff       	call   801000d0 <bread>
801011cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ce:	a1 c0 19 11 80       	mov    0x801119c0,%eax
801011d3:	83 c4 10             	add    $0x10,%esp
801011d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011d9:	31 c0                	xor    %eax,%eax
801011db:	eb 2f                	jmp    8010120c <balloc+0x7c>
801011dd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011e0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011e5:	bb 01 00 00 00       	mov    $0x1,%ebx
801011ea:	83 e1 07             	and    $0x7,%ecx
801011ed:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011ef:	89 c1                	mov    %eax,%ecx
801011f1:	c1 f9 03             	sar    $0x3,%ecx
801011f4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011f9:	85 df                	test   %ebx,%edi
801011fb:	89 fa                	mov    %edi,%edx
801011fd:	74 41                	je     80101240 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ff:	83 c0 01             	add    $0x1,%eax
80101202:	83 c6 01             	add    $0x1,%esi
80101205:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010120a:	74 05                	je     80101211 <balloc+0x81>
8010120c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010120f:	77 cf                	ja     801011e0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101211:	83 ec 0c             	sub    $0xc,%esp
80101214:	ff 75 e4             	pushl  -0x1c(%ebp)
80101217:	e8 c4 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010121c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101223:	83 c4 10             	add    $0x10,%esp
80101226:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101229:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
8010122f:	77 80                	ja     801011b1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101231:	83 ec 0c             	sub    $0xc,%esp
80101234:	68 07 7b 10 80       	push   $0x80107b07
80101239:	e8 52 f1 ff ff       	call   80100390 <panic>
8010123e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101240:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101243:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101246:	09 da                	or     %ebx,%edx
80101248:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010124c:	57                   	push   %edi
8010124d:	e8 0e 20 00 00       	call   80103260 <log_write>
        brelse(bp);
80101252:	89 3c 24             	mov    %edi,(%esp)
80101255:	e8 86 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010125a:	58                   	pop    %eax
8010125b:	5a                   	pop    %edx
8010125c:	56                   	push   %esi
8010125d:	ff 75 d8             	pushl  -0x28(%ebp)
80101260:	e8 6b ee ff ff       	call   801000d0 <bread>
80101265:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101267:	8d 40 5c             	lea    0x5c(%eax),%eax
8010126a:	83 c4 0c             	add    $0xc,%esp
8010126d:	68 00 02 00 00       	push   $0x200
80101272:	6a 00                	push   $0x0
80101274:	50                   	push   %eax
80101275:	e8 76 3a 00 00       	call   80104cf0 <memset>
  log_write(bp);
8010127a:	89 1c 24             	mov    %ebx,(%esp)
8010127d:	e8 de 1f 00 00       	call   80103260 <log_write>
  brelse(bp);
80101282:	89 1c 24             	mov    %ebx,(%esp)
80101285:	e8 56 ef ff ff       	call   801001e0 <brelse>
}
8010128a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010128d:	89 f0                	mov    %esi,%eax
8010128f:	5b                   	pop    %ebx
80101290:	5e                   	pop    %esi
80101291:	5f                   	pop    %edi
80101292:	5d                   	pop    %ebp
80101293:	c3                   	ret    
80101294:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010129a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801012a0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012a0:	55                   	push   %ebp
801012a1:	89 e5                	mov    %esp,%ebp
801012a3:	57                   	push   %edi
801012a4:	56                   	push   %esi
801012a5:	53                   	push   %ebx
801012a6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012a8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012aa:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
{
801012af:	83 ec 28             	sub    $0x28,%esp
801012b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012b5:	68 e0 19 11 80       	push   $0x801119e0
801012ba:	e8 b1 38 00 00       	call   80104b70 <acquire>
801012bf:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012c5:	eb 17                	jmp    801012de <iget+0x3e>
801012c7:	89 f6                	mov    %esi,%esi
801012c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012d0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012d6:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801012dc:	73 22                	jae    80101300 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012de:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012e1:	85 c9                	test   %ecx,%ecx
801012e3:	7e 04                	jle    801012e9 <iget+0x49>
801012e5:	39 3b                	cmp    %edi,(%ebx)
801012e7:	74 4f                	je     80101338 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012e9:	85 f6                	test   %esi,%esi
801012eb:	75 e3                	jne    801012d0 <iget+0x30>
801012ed:	85 c9                	test   %ecx,%ecx
801012ef:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012f2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012f8:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801012fe:	72 de                	jb     801012de <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101300:	85 f6                	test   %esi,%esi
80101302:	74 5b                	je     8010135f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101304:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101307:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101309:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010130c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101313:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010131a:	68 e0 19 11 80       	push   $0x801119e0
8010131f:	e8 6c 39 00 00       	call   80104c90 <release>

  return ip;
80101324:	83 c4 10             	add    $0x10,%esp
}
80101327:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010132a:	89 f0                	mov    %esi,%eax
8010132c:	5b                   	pop    %ebx
8010132d:	5e                   	pop    %esi
8010132e:	5f                   	pop    %edi
8010132f:	5d                   	pop    %ebp
80101330:	c3                   	ret    
80101331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101338:	39 53 04             	cmp    %edx,0x4(%ebx)
8010133b:	75 ac                	jne    801012e9 <iget+0x49>
      release(&icache.lock);
8010133d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101340:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101343:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101345:	68 e0 19 11 80       	push   $0x801119e0
      ip->ref++;
8010134a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010134d:	e8 3e 39 00 00       	call   80104c90 <release>
      return ip;
80101352:	83 c4 10             	add    $0x10,%esp
}
80101355:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101358:	89 f0                	mov    %esi,%eax
8010135a:	5b                   	pop    %ebx
8010135b:	5e                   	pop    %esi
8010135c:	5f                   	pop    %edi
8010135d:	5d                   	pop    %ebp
8010135e:	c3                   	ret    
    panic("iget: no inodes");
8010135f:	83 ec 0c             	sub    $0xc,%esp
80101362:	68 1d 7b 10 80       	push   $0x80107b1d
80101367:	e8 24 f0 ff ff       	call   80100390 <panic>
8010136c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101370 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101370:	55                   	push   %ebp
80101371:	89 e5                	mov    %esp,%ebp
80101373:	57                   	push   %edi
80101374:	56                   	push   %esi
80101375:	53                   	push   %ebx
80101376:	89 c6                	mov    %eax,%esi
80101378:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010137b:	83 fa 0b             	cmp    $0xb,%edx
8010137e:	77 18                	ja     80101398 <bmap+0x28>
80101380:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101383:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101386:	85 db                	test   %ebx,%ebx
80101388:	74 76                	je     80101400 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010138a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010138d:	89 d8                	mov    %ebx,%eax
8010138f:	5b                   	pop    %ebx
80101390:	5e                   	pop    %esi
80101391:	5f                   	pop    %edi
80101392:	5d                   	pop    %ebp
80101393:	c3                   	ret    
80101394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101398:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010139b:	83 fb 7f             	cmp    $0x7f,%ebx
8010139e:	0f 87 90 00 00 00    	ja     80101434 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
801013a4:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801013aa:	8b 00                	mov    (%eax),%eax
801013ac:	85 d2                	test   %edx,%edx
801013ae:	74 70                	je     80101420 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801013b0:	83 ec 08             	sub    $0x8,%esp
801013b3:	52                   	push   %edx
801013b4:	50                   	push   %eax
801013b5:	e8 16 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013ba:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013be:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013c1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013c3:	8b 1a                	mov    (%edx),%ebx
801013c5:	85 db                	test   %ebx,%ebx
801013c7:	75 1d                	jne    801013e6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801013c9:	8b 06                	mov    (%esi),%eax
801013cb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013ce:	e8 bd fd ff ff       	call   80101190 <balloc>
801013d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013d6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801013d9:	89 c3                	mov    %eax,%ebx
801013db:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013dd:	57                   	push   %edi
801013de:	e8 7d 1e 00 00       	call   80103260 <log_write>
801013e3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801013e6:	83 ec 0c             	sub    $0xc,%esp
801013e9:	57                   	push   %edi
801013ea:	e8 f1 ed ff ff       	call   801001e0 <brelse>
801013ef:	83 c4 10             	add    $0x10,%esp
}
801013f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013f5:	89 d8                	mov    %ebx,%eax
801013f7:	5b                   	pop    %ebx
801013f8:	5e                   	pop    %esi
801013f9:	5f                   	pop    %edi
801013fa:	5d                   	pop    %ebp
801013fb:	c3                   	ret    
801013fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101400:	8b 00                	mov    (%eax),%eax
80101402:	e8 89 fd ff ff       	call   80101190 <balloc>
80101407:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010140a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010140d:	89 c3                	mov    %eax,%ebx
}
8010140f:	89 d8                	mov    %ebx,%eax
80101411:	5b                   	pop    %ebx
80101412:	5e                   	pop    %esi
80101413:	5f                   	pop    %edi
80101414:	5d                   	pop    %ebp
80101415:	c3                   	ret    
80101416:	8d 76 00             	lea    0x0(%esi),%esi
80101419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101420:	e8 6b fd ff ff       	call   80101190 <balloc>
80101425:	89 c2                	mov    %eax,%edx
80101427:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010142d:	8b 06                	mov    (%esi),%eax
8010142f:	e9 7c ff ff ff       	jmp    801013b0 <bmap+0x40>
  panic("bmap: out of range");
80101434:	83 ec 0c             	sub    $0xc,%esp
80101437:	68 2d 7b 10 80       	push   $0x80107b2d
8010143c:	e8 4f ef ff ff       	call   80100390 <panic>
80101441:	eb 0d                	jmp    80101450 <readsb>
80101443:	90                   	nop
80101444:	90                   	nop
80101445:	90                   	nop
80101446:	90                   	nop
80101447:	90                   	nop
80101448:	90                   	nop
80101449:	90                   	nop
8010144a:	90                   	nop
8010144b:	90                   	nop
8010144c:	90                   	nop
8010144d:	90                   	nop
8010144e:	90                   	nop
8010144f:	90                   	nop

80101450 <readsb>:
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	56                   	push   %esi
80101454:	53                   	push   %ebx
80101455:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101458:	83 ec 08             	sub    $0x8,%esp
8010145b:	6a 01                	push   $0x1
8010145d:	ff 75 08             	pushl  0x8(%ebp)
80101460:	e8 6b ec ff ff       	call   801000d0 <bread>
80101465:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101467:	8d 40 5c             	lea    0x5c(%eax),%eax
8010146a:	83 c4 0c             	add    $0xc,%esp
8010146d:	6a 1c                	push   $0x1c
8010146f:	50                   	push   %eax
80101470:	56                   	push   %esi
80101471:	e8 2a 39 00 00       	call   80104da0 <memmove>
  brelse(bp);
80101476:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101479:	83 c4 10             	add    $0x10,%esp
}
8010147c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010147f:	5b                   	pop    %ebx
80101480:	5e                   	pop    %esi
80101481:	5d                   	pop    %ebp
  brelse(bp);
80101482:	e9 59 ed ff ff       	jmp    801001e0 <brelse>
80101487:	89 f6                	mov    %esi,%esi
80101489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101490 <bfree>:
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	56                   	push   %esi
80101494:	53                   	push   %ebx
80101495:	89 d3                	mov    %edx,%ebx
80101497:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101499:	83 ec 08             	sub    $0x8,%esp
8010149c:	68 c0 19 11 80       	push   $0x801119c0
801014a1:	50                   	push   %eax
801014a2:	e8 a9 ff ff ff       	call   80101450 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801014a7:	58                   	pop    %eax
801014a8:	5a                   	pop    %edx
801014a9:	89 da                	mov    %ebx,%edx
801014ab:	c1 ea 0c             	shr    $0xc,%edx
801014ae:	03 15 d8 19 11 80    	add    0x801119d8,%edx
801014b4:	52                   	push   %edx
801014b5:	56                   	push   %esi
801014b6:	e8 15 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801014bb:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014bd:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801014c0:	ba 01 00 00 00       	mov    $0x1,%edx
801014c5:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014c8:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801014ce:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801014d1:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801014d3:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801014d8:	85 d1                	test   %edx,%ecx
801014da:	74 25                	je     80101501 <bfree+0x71>
  bp->data[bi/8] &= ~m;
801014dc:	f7 d2                	not    %edx
801014de:	89 c6                	mov    %eax,%esi
  log_write(bp);
801014e0:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801014e3:	21 ca                	and    %ecx,%edx
801014e5:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
801014e9:	56                   	push   %esi
801014ea:	e8 71 1d 00 00       	call   80103260 <log_write>
  brelse(bp);
801014ef:	89 34 24             	mov    %esi,(%esp)
801014f2:	e8 e9 ec ff ff       	call   801001e0 <brelse>
}
801014f7:	83 c4 10             	add    $0x10,%esp
801014fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014fd:	5b                   	pop    %ebx
801014fe:	5e                   	pop    %esi
801014ff:	5d                   	pop    %ebp
80101500:	c3                   	ret    
    panic("freeing free block");
80101501:	83 ec 0c             	sub    $0xc,%esp
80101504:	68 40 7b 10 80       	push   $0x80107b40
80101509:	e8 82 ee ff ff       	call   80100390 <panic>
8010150e:	66 90                	xchg   %ax,%ax

80101510 <iinit>:
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	53                   	push   %ebx
80101514:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
80101519:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010151c:	68 53 7b 10 80       	push   $0x80107b53
80101521:	68 e0 19 11 80       	push   $0x801119e0
80101526:	e8 55 35 00 00       	call   80104a80 <initlock>
8010152b:	83 c4 10             	add    $0x10,%esp
8010152e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101530:	83 ec 08             	sub    $0x8,%esp
80101533:	68 5a 7b 10 80       	push   $0x80107b5a
80101538:	53                   	push   %ebx
80101539:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010153f:	e8 2c 34 00 00       	call   80104970 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101544:	83 c4 10             	add    $0x10,%esp
80101547:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
8010154d:	75 e1                	jne    80101530 <iinit+0x20>
  readsb(dev, &sb);
8010154f:	83 ec 08             	sub    $0x8,%esp
80101552:	68 c0 19 11 80       	push   $0x801119c0
80101557:	ff 75 08             	pushl  0x8(%ebp)
8010155a:	e8 f1 fe ff ff       	call   80101450 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010155f:	ff 35 d8 19 11 80    	pushl  0x801119d8
80101565:	ff 35 d4 19 11 80    	pushl  0x801119d4
8010156b:	ff 35 d0 19 11 80    	pushl  0x801119d0
80101571:	ff 35 cc 19 11 80    	pushl  0x801119cc
80101577:	ff 35 c8 19 11 80    	pushl  0x801119c8
8010157d:	ff 35 c4 19 11 80    	pushl  0x801119c4
80101583:	ff 35 c0 19 11 80    	pushl  0x801119c0
80101589:	68 04 7c 10 80       	push   $0x80107c04
8010158e:	e8 cd f0 ff ff       	call   80100660 <cprintf>
}
80101593:	83 c4 30             	add    $0x30,%esp
80101596:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101599:	c9                   	leave  
8010159a:	c3                   	ret    
8010159b:	90                   	nop
8010159c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801015a0 <ialloc>:
{
801015a0:	55                   	push   %ebp
801015a1:	89 e5                	mov    %esp,%ebp
801015a3:	57                   	push   %edi
801015a4:	56                   	push   %esi
801015a5:	53                   	push   %ebx
801015a6:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801015a9:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
{
801015b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801015b3:	8b 75 08             	mov    0x8(%ebp),%esi
801015b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015b9:	0f 86 91 00 00 00    	jbe    80101650 <ialloc+0xb0>
801015bf:	bb 01 00 00 00       	mov    $0x1,%ebx
801015c4:	eb 21                	jmp    801015e7 <ialloc+0x47>
801015c6:	8d 76 00             	lea    0x0(%esi),%esi
801015c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
801015d0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801015d3:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
801015d6:	57                   	push   %edi
801015d7:	e8 04 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801015dc:	83 c4 10             	add    $0x10,%esp
801015df:	39 1d c8 19 11 80    	cmp    %ebx,0x801119c8
801015e5:	76 69                	jbe    80101650 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801015e7:	89 d8                	mov    %ebx,%eax
801015e9:	83 ec 08             	sub    $0x8,%esp
801015ec:	c1 e8 03             	shr    $0x3,%eax
801015ef:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801015f5:	50                   	push   %eax
801015f6:	56                   	push   %esi
801015f7:	e8 d4 ea ff ff       	call   801000d0 <bread>
801015fc:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801015fe:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101600:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101603:	83 e0 07             	and    $0x7,%eax
80101606:	c1 e0 06             	shl    $0x6,%eax
80101609:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010160d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101611:	75 bd                	jne    801015d0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101613:	83 ec 04             	sub    $0x4,%esp
80101616:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101619:	6a 40                	push   $0x40
8010161b:	6a 00                	push   $0x0
8010161d:	51                   	push   %ecx
8010161e:	e8 cd 36 00 00       	call   80104cf0 <memset>
      dip->type = type;
80101623:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101627:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010162a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010162d:	89 3c 24             	mov    %edi,(%esp)
80101630:	e8 2b 1c 00 00       	call   80103260 <log_write>
      brelse(bp);
80101635:	89 3c 24             	mov    %edi,(%esp)
80101638:	e8 a3 eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010163d:	83 c4 10             	add    $0x10,%esp
}
80101640:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101643:	89 da                	mov    %ebx,%edx
80101645:	89 f0                	mov    %esi,%eax
}
80101647:	5b                   	pop    %ebx
80101648:	5e                   	pop    %esi
80101649:	5f                   	pop    %edi
8010164a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010164b:	e9 50 fc ff ff       	jmp    801012a0 <iget>
  panic("ialloc: no inodes");
80101650:	83 ec 0c             	sub    $0xc,%esp
80101653:	68 60 7b 10 80       	push   $0x80107b60
80101658:	e8 33 ed ff ff       	call   80100390 <panic>
8010165d:	8d 76 00             	lea    0x0(%esi),%esi

80101660 <iupdate>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	56                   	push   %esi
80101664:	53                   	push   %ebx
80101665:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101668:	83 ec 08             	sub    $0x8,%esp
8010166b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010166e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101671:	c1 e8 03             	shr    $0x3,%eax
80101674:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010167a:	50                   	push   %eax
8010167b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010167e:	e8 4d ea ff ff       	call   801000d0 <bread>
80101683:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101685:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101688:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010168c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010168f:	83 e0 07             	and    $0x7,%eax
80101692:	c1 e0 06             	shl    $0x6,%eax
80101695:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101699:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010169c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016a0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016a3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016a7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ab:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016af:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016b3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016b7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016ba:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016bd:	6a 34                	push   $0x34
801016bf:	53                   	push   %ebx
801016c0:	50                   	push   %eax
801016c1:	e8 da 36 00 00       	call   80104da0 <memmove>
  log_write(bp);
801016c6:	89 34 24             	mov    %esi,(%esp)
801016c9:	e8 92 1b 00 00       	call   80103260 <log_write>
  brelse(bp);
801016ce:	89 75 08             	mov    %esi,0x8(%ebp)
801016d1:	83 c4 10             	add    $0x10,%esp
}
801016d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016d7:	5b                   	pop    %ebx
801016d8:	5e                   	pop    %esi
801016d9:	5d                   	pop    %ebp
  brelse(bp);
801016da:	e9 01 eb ff ff       	jmp    801001e0 <brelse>
801016df:	90                   	nop

801016e0 <idup>:
{
801016e0:	55                   	push   %ebp
801016e1:	89 e5                	mov    %esp,%ebp
801016e3:	53                   	push   %ebx
801016e4:	83 ec 10             	sub    $0x10,%esp
801016e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016ea:	68 e0 19 11 80       	push   $0x801119e0
801016ef:	e8 7c 34 00 00       	call   80104b70 <acquire>
  ip->ref++;
801016f4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016f8:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801016ff:	e8 8c 35 00 00       	call   80104c90 <release>
}
80101704:	89 d8                	mov    %ebx,%eax
80101706:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101709:	c9                   	leave  
8010170a:	c3                   	ret    
8010170b:	90                   	nop
8010170c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101710 <ilock>:
{
80101710:	55                   	push   %ebp
80101711:	89 e5                	mov    %esp,%ebp
80101713:	56                   	push   %esi
80101714:	53                   	push   %ebx
80101715:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101718:	85 db                	test   %ebx,%ebx
8010171a:	0f 84 b7 00 00 00    	je     801017d7 <ilock+0xc7>
80101720:	8b 53 08             	mov    0x8(%ebx),%edx
80101723:	85 d2                	test   %edx,%edx
80101725:	0f 8e ac 00 00 00    	jle    801017d7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010172b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010172e:	83 ec 0c             	sub    $0xc,%esp
80101731:	50                   	push   %eax
80101732:	e8 79 32 00 00       	call   801049b0 <acquiresleep>
  if(ip->valid == 0){
80101737:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010173a:	83 c4 10             	add    $0x10,%esp
8010173d:	85 c0                	test   %eax,%eax
8010173f:	74 0f                	je     80101750 <ilock+0x40>
}
80101741:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101744:	5b                   	pop    %ebx
80101745:	5e                   	pop    %esi
80101746:	5d                   	pop    %ebp
80101747:	c3                   	ret    
80101748:	90                   	nop
80101749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101750:	8b 43 04             	mov    0x4(%ebx),%eax
80101753:	83 ec 08             	sub    $0x8,%esp
80101756:	c1 e8 03             	shr    $0x3,%eax
80101759:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010175f:	50                   	push   %eax
80101760:	ff 33                	pushl  (%ebx)
80101762:	e8 69 e9 ff ff       	call   801000d0 <bread>
80101767:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101769:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010176c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010176f:	83 e0 07             	and    $0x7,%eax
80101772:	c1 e0 06             	shl    $0x6,%eax
80101775:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101779:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010177c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010177f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101783:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101787:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010178b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010178f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101793:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101797:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010179b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010179e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017a1:	6a 34                	push   $0x34
801017a3:	50                   	push   %eax
801017a4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017a7:	50                   	push   %eax
801017a8:	e8 f3 35 00 00       	call   80104da0 <memmove>
    brelse(bp);
801017ad:	89 34 24             	mov    %esi,(%esp)
801017b0:	e8 2b ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
801017b5:	83 c4 10             	add    $0x10,%esp
801017b8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801017bd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801017c4:	0f 85 77 ff ff ff    	jne    80101741 <ilock+0x31>
      panic("ilock: no type");
801017ca:	83 ec 0c             	sub    $0xc,%esp
801017cd:	68 78 7b 10 80       	push   $0x80107b78
801017d2:	e8 b9 eb ff ff       	call   80100390 <panic>
    panic("ilock");
801017d7:	83 ec 0c             	sub    $0xc,%esp
801017da:	68 72 7b 10 80       	push   $0x80107b72
801017df:	e8 ac eb ff ff       	call   80100390 <panic>
801017e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801017ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801017f0 <iunlock>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	56                   	push   %esi
801017f4:	53                   	push   %ebx
801017f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017f8:	85 db                	test   %ebx,%ebx
801017fa:	74 28                	je     80101824 <iunlock+0x34>
801017fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801017ff:	83 ec 0c             	sub    $0xc,%esp
80101802:	56                   	push   %esi
80101803:	e8 48 32 00 00       	call   80104a50 <holdingsleep>
80101808:	83 c4 10             	add    $0x10,%esp
8010180b:	85 c0                	test   %eax,%eax
8010180d:	74 15                	je     80101824 <iunlock+0x34>
8010180f:	8b 43 08             	mov    0x8(%ebx),%eax
80101812:	85 c0                	test   %eax,%eax
80101814:	7e 0e                	jle    80101824 <iunlock+0x34>
  releasesleep(&ip->lock);
80101816:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101819:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010181c:	5b                   	pop    %ebx
8010181d:	5e                   	pop    %esi
8010181e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010181f:	e9 ec 31 00 00       	jmp    80104a10 <releasesleep>
    panic("iunlock");
80101824:	83 ec 0c             	sub    $0xc,%esp
80101827:	68 87 7b 10 80       	push   $0x80107b87
8010182c:	e8 5f eb ff ff       	call   80100390 <panic>
80101831:	eb 0d                	jmp    80101840 <iput>
80101833:	90                   	nop
80101834:	90                   	nop
80101835:	90                   	nop
80101836:	90                   	nop
80101837:	90                   	nop
80101838:	90                   	nop
80101839:	90                   	nop
8010183a:	90                   	nop
8010183b:	90                   	nop
8010183c:	90                   	nop
8010183d:	90                   	nop
8010183e:	90                   	nop
8010183f:	90                   	nop

80101840 <iput>:
{
80101840:	55                   	push   %ebp
80101841:	89 e5                	mov    %esp,%ebp
80101843:	57                   	push   %edi
80101844:	56                   	push   %esi
80101845:	53                   	push   %ebx
80101846:	83 ec 28             	sub    $0x28,%esp
80101849:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010184c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010184f:	57                   	push   %edi
80101850:	e8 5b 31 00 00       	call   801049b0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101855:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101858:	83 c4 10             	add    $0x10,%esp
8010185b:	85 d2                	test   %edx,%edx
8010185d:	74 07                	je     80101866 <iput+0x26>
8010185f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101864:	74 32                	je     80101898 <iput+0x58>
  releasesleep(&ip->lock);
80101866:	83 ec 0c             	sub    $0xc,%esp
80101869:	57                   	push   %edi
8010186a:	e8 a1 31 00 00       	call   80104a10 <releasesleep>
  acquire(&icache.lock);
8010186f:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101876:	e8 f5 32 00 00       	call   80104b70 <acquire>
  ip->ref--;
8010187b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010187f:	83 c4 10             	add    $0x10,%esp
80101882:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
80101889:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5f                   	pop    %edi
8010188f:	5d                   	pop    %ebp
  release(&icache.lock);
80101890:	e9 fb 33 00 00       	jmp    80104c90 <release>
80101895:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101898:	83 ec 0c             	sub    $0xc,%esp
8010189b:	68 e0 19 11 80       	push   $0x801119e0
801018a0:	e8 cb 32 00 00       	call   80104b70 <acquire>
    int r = ip->ref;
801018a5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801018a8:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018af:	e8 dc 33 00 00       	call   80104c90 <release>
    if(r == 1){
801018b4:	83 c4 10             	add    $0x10,%esp
801018b7:	83 fe 01             	cmp    $0x1,%esi
801018ba:	75 aa                	jne    80101866 <iput+0x26>
801018bc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801018c2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801018c5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801018c8:	89 cf                	mov    %ecx,%edi
801018ca:	eb 0b                	jmp    801018d7 <iput+0x97>
801018cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018d0:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801018d3:	39 fe                	cmp    %edi,%esi
801018d5:	74 19                	je     801018f0 <iput+0xb0>
    if(ip->addrs[i]){
801018d7:	8b 16                	mov    (%esi),%edx
801018d9:	85 d2                	test   %edx,%edx
801018db:	74 f3                	je     801018d0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801018dd:	8b 03                	mov    (%ebx),%eax
801018df:	e8 ac fb ff ff       	call   80101490 <bfree>
      ip->addrs[i] = 0;
801018e4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801018ea:	eb e4                	jmp    801018d0 <iput+0x90>
801018ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801018f0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801018f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018f9:	85 c0                	test   %eax,%eax
801018fb:	75 33                	jne    80101930 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801018fd:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101900:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101907:	53                   	push   %ebx
80101908:	e8 53 fd ff ff       	call   80101660 <iupdate>
      ip->type = 0;
8010190d:	31 c0                	xor    %eax,%eax
8010190f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101913:	89 1c 24             	mov    %ebx,(%esp)
80101916:	e8 45 fd ff ff       	call   80101660 <iupdate>
      ip->valid = 0;
8010191b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101922:	83 c4 10             	add    $0x10,%esp
80101925:	e9 3c ff ff ff       	jmp    80101866 <iput+0x26>
8010192a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101930:	83 ec 08             	sub    $0x8,%esp
80101933:	50                   	push   %eax
80101934:	ff 33                	pushl  (%ebx)
80101936:	e8 95 e7 ff ff       	call   801000d0 <bread>
8010193b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101941:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101944:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101947:	8d 70 5c             	lea    0x5c(%eax),%esi
8010194a:	83 c4 10             	add    $0x10,%esp
8010194d:	89 cf                	mov    %ecx,%edi
8010194f:	eb 0e                	jmp    8010195f <iput+0x11f>
80101951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101958:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
8010195b:	39 fe                	cmp    %edi,%esi
8010195d:	74 0f                	je     8010196e <iput+0x12e>
      if(a[j])
8010195f:	8b 16                	mov    (%esi),%edx
80101961:	85 d2                	test   %edx,%edx
80101963:	74 f3                	je     80101958 <iput+0x118>
        bfree(ip->dev, a[j]);
80101965:	8b 03                	mov    (%ebx),%eax
80101967:	e8 24 fb ff ff       	call   80101490 <bfree>
8010196c:	eb ea                	jmp    80101958 <iput+0x118>
    brelse(bp);
8010196e:	83 ec 0c             	sub    $0xc,%esp
80101971:	ff 75 e4             	pushl  -0x1c(%ebp)
80101974:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101977:	e8 64 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010197c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101982:	8b 03                	mov    (%ebx),%eax
80101984:	e8 07 fb ff ff       	call   80101490 <bfree>
    ip->addrs[NDIRECT] = 0;
80101989:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101990:	00 00 00 
80101993:	83 c4 10             	add    $0x10,%esp
80101996:	e9 62 ff ff ff       	jmp    801018fd <iput+0xbd>
8010199b:	90                   	nop
8010199c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019a0 <iunlockput>:
{
801019a0:	55                   	push   %ebp
801019a1:	89 e5                	mov    %esp,%ebp
801019a3:	53                   	push   %ebx
801019a4:	83 ec 10             	sub    $0x10,%esp
801019a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801019aa:	53                   	push   %ebx
801019ab:	e8 40 fe ff ff       	call   801017f0 <iunlock>
  iput(ip);
801019b0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801019b3:	83 c4 10             	add    $0x10,%esp
}
801019b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019b9:	c9                   	leave  
  iput(ip);
801019ba:	e9 81 fe ff ff       	jmp    80101840 <iput>
801019bf:	90                   	nop

801019c0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801019c0:	55                   	push   %ebp
801019c1:	89 e5                	mov    %esp,%ebp
801019c3:	8b 55 08             	mov    0x8(%ebp),%edx
801019c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801019c9:	8b 0a                	mov    (%edx),%ecx
801019cb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801019ce:	8b 4a 04             	mov    0x4(%edx),%ecx
801019d1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801019d4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801019d8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801019db:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801019df:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801019e3:	8b 52 58             	mov    0x58(%edx),%edx
801019e6:	89 50 10             	mov    %edx,0x10(%eax)
}
801019e9:	5d                   	pop    %ebp
801019ea:	c3                   	ret    
801019eb:	90                   	nop
801019ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019f0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019f0:	55                   	push   %ebp
801019f1:	89 e5                	mov    %esp,%ebp
801019f3:	57                   	push   %edi
801019f4:	56                   	push   %esi
801019f5:	53                   	push   %ebx
801019f6:	83 ec 1c             	sub    $0x1c,%esp
801019f9:	8b 45 08             	mov    0x8(%ebp),%eax
801019fc:	8b 75 0c             	mov    0xc(%ebp),%esi
801019ff:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a02:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a07:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101a0a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a0d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a10:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a13:	0f 84 a7 00 00 00    	je     80101ac0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a19:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a1c:	8b 40 58             	mov    0x58(%eax),%eax
80101a1f:	39 c6                	cmp    %eax,%esi
80101a21:	0f 87 ba 00 00 00    	ja     80101ae1 <readi+0xf1>
80101a27:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a2a:	89 f9                	mov    %edi,%ecx
80101a2c:	01 f1                	add    %esi,%ecx
80101a2e:	0f 82 ad 00 00 00    	jb     80101ae1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a34:	89 c2                	mov    %eax,%edx
80101a36:	29 f2                	sub    %esi,%edx
80101a38:	39 c8                	cmp    %ecx,%eax
80101a3a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a3d:	31 ff                	xor    %edi,%edi
80101a3f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101a41:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a44:	74 6c                	je     80101ab2 <readi+0xc2>
80101a46:	8d 76 00             	lea    0x0(%esi),%esi
80101a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a50:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a53:	89 f2                	mov    %esi,%edx
80101a55:	c1 ea 09             	shr    $0x9,%edx
80101a58:	89 d8                	mov    %ebx,%eax
80101a5a:	e8 11 f9 ff ff       	call   80101370 <bmap>
80101a5f:	83 ec 08             	sub    $0x8,%esp
80101a62:	50                   	push   %eax
80101a63:	ff 33                	pushl  (%ebx)
80101a65:	e8 66 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a6a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a6d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a6f:	89 f0                	mov    %esi,%eax
80101a71:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a76:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a7b:	83 c4 0c             	add    $0xc,%esp
80101a7e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a80:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a84:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a87:	29 fb                	sub    %edi,%ebx
80101a89:	39 d9                	cmp    %ebx,%ecx
80101a8b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a8e:	53                   	push   %ebx
80101a8f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a90:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a92:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a95:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a97:	e8 04 33 00 00       	call   80104da0 <memmove>
    brelse(bp);
80101a9c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a9f:	89 14 24             	mov    %edx,(%esp)
80101aa2:	e8 39 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aa7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101aaa:	83 c4 10             	add    $0x10,%esp
80101aad:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ab0:	77 9e                	ja     80101a50 <readi+0x60>
  }
  return n;
80101ab2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ab5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ab8:	5b                   	pop    %ebx
80101ab9:	5e                   	pop    %esi
80101aba:	5f                   	pop    %edi
80101abb:	5d                   	pop    %ebp
80101abc:	c3                   	ret    
80101abd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ac0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ac4:	66 83 f8 09          	cmp    $0x9,%ax
80101ac8:	77 17                	ja     80101ae1 <readi+0xf1>
80101aca:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101ad1:	85 c0                	test   %eax,%eax
80101ad3:	74 0c                	je     80101ae1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101ad5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ad8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101adb:	5b                   	pop    %ebx
80101adc:	5e                   	pop    %esi
80101add:	5f                   	pop    %edi
80101ade:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101adf:	ff e0                	jmp    *%eax
      return -1;
80101ae1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ae6:	eb cd                	jmp    80101ab5 <readi+0xc5>
80101ae8:	90                   	nop
80101ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101af0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101af0:	55                   	push   %ebp
80101af1:	89 e5                	mov    %esp,%ebp
80101af3:	57                   	push   %edi
80101af4:	56                   	push   %esi
80101af5:	53                   	push   %ebx
80101af6:	83 ec 1c             	sub    $0x1c,%esp
80101af9:	8b 45 08             	mov    0x8(%ebp),%eax
80101afc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101aff:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b02:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b07:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b0a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b0d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b10:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b13:	0f 84 b7 00 00 00    	je     80101bd0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b19:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b1c:	39 70 58             	cmp    %esi,0x58(%eax)
80101b1f:	0f 82 eb 00 00 00    	jb     80101c10 <writei+0x120>
80101b25:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b28:	31 d2                	xor    %edx,%edx
80101b2a:	89 f8                	mov    %edi,%eax
80101b2c:	01 f0                	add    %esi,%eax
80101b2e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b31:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b36:	0f 87 d4 00 00 00    	ja     80101c10 <writei+0x120>
80101b3c:	85 d2                	test   %edx,%edx
80101b3e:	0f 85 cc 00 00 00    	jne    80101c10 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b44:	85 ff                	test   %edi,%edi
80101b46:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b4d:	74 72                	je     80101bc1 <writei+0xd1>
80101b4f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b50:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b53:	89 f2                	mov    %esi,%edx
80101b55:	c1 ea 09             	shr    $0x9,%edx
80101b58:	89 f8                	mov    %edi,%eax
80101b5a:	e8 11 f8 ff ff       	call   80101370 <bmap>
80101b5f:	83 ec 08             	sub    $0x8,%esp
80101b62:	50                   	push   %eax
80101b63:	ff 37                	pushl  (%edi)
80101b65:	e8 66 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b6a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b6d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b70:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b72:	89 f0                	mov    %esi,%eax
80101b74:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b79:	83 c4 0c             	add    $0xc,%esp
80101b7c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b81:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b83:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b87:	39 d9                	cmp    %ebx,%ecx
80101b89:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b8c:	53                   	push   %ebx
80101b8d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b90:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b92:	50                   	push   %eax
80101b93:	e8 08 32 00 00       	call   80104da0 <memmove>
    log_write(bp);
80101b98:	89 3c 24             	mov    %edi,(%esp)
80101b9b:	e8 c0 16 00 00       	call   80103260 <log_write>
    brelse(bp);
80101ba0:	89 3c 24             	mov    %edi,(%esp)
80101ba3:	e8 38 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ba8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101bab:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101bae:	83 c4 10             	add    $0x10,%esp
80101bb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101bb4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101bb7:	77 97                	ja     80101b50 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	77 37                	ja     80101bf8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101bc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101bc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bc7:	5b                   	pop    %ebx
80101bc8:	5e                   	pop    %esi
80101bc9:	5f                   	pop    %edi
80101bca:	5d                   	pop    %ebp
80101bcb:	c3                   	ret    
80101bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101bd0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101bd4:	66 83 f8 09          	cmp    $0x9,%ax
80101bd8:	77 36                	ja     80101c10 <writei+0x120>
80101bda:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101be1:	85 c0                	test   %eax,%eax
80101be3:	74 2b                	je     80101c10 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101be5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101be8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101beb:	5b                   	pop    %ebx
80101bec:	5e                   	pop    %esi
80101bed:	5f                   	pop    %edi
80101bee:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101bef:	ff e0                	jmp    *%eax
80101bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101bf8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101bfb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101bfe:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c01:	50                   	push   %eax
80101c02:	e8 59 fa ff ff       	call   80101660 <iupdate>
80101c07:	83 c4 10             	add    $0x10,%esp
80101c0a:	eb b5                	jmp    80101bc1 <writei+0xd1>
80101c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c15:	eb ad                	jmp    80101bc4 <writei+0xd4>
80101c17:	89 f6                	mov    %esi,%esi
80101c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c20 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c20:	55                   	push   %ebp
80101c21:	89 e5                	mov    %esp,%ebp
80101c23:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c26:	6a 0e                	push   $0xe
80101c28:	ff 75 0c             	pushl  0xc(%ebp)
80101c2b:	ff 75 08             	pushl  0x8(%ebp)
80101c2e:	e8 dd 31 00 00       	call   80104e10 <strncmp>
}
80101c33:	c9                   	leave  
80101c34:	c3                   	ret    
80101c35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c40 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c40:	55                   	push   %ebp
80101c41:	89 e5                	mov    %esp,%ebp
80101c43:	57                   	push   %edi
80101c44:	56                   	push   %esi
80101c45:	53                   	push   %ebx
80101c46:	83 ec 1c             	sub    $0x1c,%esp
80101c49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c4c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c51:	0f 85 85 00 00 00    	jne    80101cdc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c57:	8b 53 58             	mov    0x58(%ebx),%edx
80101c5a:	31 ff                	xor    %edi,%edi
80101c5c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c5f:	85 d2                	test   %edx,%edx
80101c61:	74 3e                	je     80101ca1 <dirlookup+0x61>
80101c63:	90                   	nop
80101c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c68:	6a 10                	push   $0x10
80101c6a:	57                   	push   %edi
80101c6b:	56                   	push   %esi
80101c6c:	53                   	push   %ebx
80101c6d:	e8 7e fd ff ff       	call   801019f0 <readi>
80101c72:	83 c4 10             	add    $0x10,%esp
80101c75:	83 f8 10             	cmp    $0x10,%eax
80101c78:	75 55                	jne    80101ccf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c7a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c7f:	74 18                	je     80101c99 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c81:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c84:	83 ec 04             	sub    $0x4,%esp
80101c87:	6a 0e                	push   $0xe
80101c89:	50                   	push   %eax
80101c8a:	ff 75 0c             	pushl  0xc(%ebp)
80101c8d:	e8 7e 31 00 00       	call   80104e10 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c92:	83 c4 10             	add    $0x10,%esp
80101c95:	85 c0                	test   %eax,%eax
80101c97:	74 17                	je     80101cb0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c99:	83 c7 10             	add    $0x10,%edi
80101c9c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c9f:	72 c7                	jb     80101c68 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101ca1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101ca4:	31 c0                	xor    %eax,%eax
}
80101ca6:	5b                   	pop    %ebx
80101ca7:	5e                   	pop    %esi
80101ca8:	5f                   	pop    %edi
80101ca9:	5d                   	pop    %ebp
80101caa:	c3                   	ret    
80101cab:	90                   	nop
80101cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101cb0:	8b 45 10             	mov    0x10(%ebp),%eax
80101cb3:	85 c0                	test   %eax,%eax
80101cb5:	74 05                	je     80101cbc <dirlookup+0x7c>
        *poff = off;
80101cb7:	8b 45 10             	mov    0x10(%ebp),%eax
80101cba:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101cbc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101cc0:	8b 03                	mov    (%ebx),%eax
80101cc2:	e8 d9 f5 ff ff       	call   801012a0 <iget>
}
80101cc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cca:	5b                   	pop    %ebx
80101ccb:	5e                   	pop    %esi
80101ccc:	5f                   	pop    %edi
80101ccd:	5d                   	pop    %ebp
80101cce:	c3                   	ret    
      panic("dirlookup read");
80101ccf:	83 ec 0c             	sub    $0xc,%esp
80101cd2:	68 a1 7b 10 80       	push   $0x80107ba1
80101cd7:	e8 b4 e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101cdc:	83 ec 0c             	sub    $0xc,%esp
80101cdf:	68 8f 7b 10 80       	push   $0x80107b8f
80101ce4:	e8 a7 e6 ff ff       	call   80100390 <panic>
80101ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cf0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 e5                	mov    %esp,%ebp
80101cf3:	57                   	push   %edi
80101cf4:	56                   	push   %esi
80101cf5:	53                   	push   %ebx
80101cf6:	89 cf                	mov    %ecx,%edi
80101cf8:	89 c3                	mov    %eax,%ebx
80101cfa:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101cfd:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d00:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101d03:	0f 84 67 01 00 00    	je     80101e70 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d09:	e8 32 20 00 00       	call   80103d40 <myproc>
  acquire(&icache.lock);
80101d0e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101d11:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d14:	68 e0 19 11 80       	push   $0x801119e0
80101d19:	e8 52 2e 00 00       	call   80104b70 <acquire>
  ip->ref++;
80101d1e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d22:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101d29:	e8 62 2f 00 00       	call   80104c90 <release>
80101d2e:	83 c4 10             	add    $0x10,%esp
80101d31:	eb 08                	jmp    80101d3b <namex+0x4b>
80101d33:	90                   	nop
80101d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101d38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d3b:	0f b6 03             	movzbl (%ebx),%eax
80101d3e:	3c 2f                	cmp    $0x2f,%al
80101d40:	74 f6                	je     80101d38 <namex+0x48>
  if(*path == 0)
80101d42:	84 c0                	test   %al,%al
80101d44:	0f 84 ee 00 00 00    	je     80101e38 <namex+0x148>
  while(*path != '/' && *path != 0)
80101d4a:	0f b6 03             	movzbl (%ebx),%eax
80101d4d:	3c 2f                	cmp    $0x2f,%al
80101d4f:	0f 84 b3 00 00 00    	je     80101e08 <namex+0x118>
80101d55:	84 c0                	test   %al,%al
80101d57:	89 da                	mov    %ebx,%edx
80101d59:	75 09                	jne    80101d64 <namex+0x74>
80101d5b:	e9 a8 00 00 00       	jmp    80101e08 <namex+0x118>
80101d60:	84 c0                	test   %al,%al
80101d62:	74 0a                	je     80101d6e <namex+0x7e>
    path++;
80101d64:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d67:	0f b6 02             	movzbl (%edx),%eax
80101d6a:	3c 2f                	cmp    $0x2f,%al
80101d6c:	75 f2                	jne    80101d60 <namex+0x70>
80101d6e:	89 d1                	mov    %edx,%ecx
80101d70:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d72:	83 f9 0d             	cmp    $0xd,%ecx
80101d75:	0f 8e 91 00 00 00    	jle    80101e0c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101d7b:	83 ec 04             	sub    $0x4,%esp
80101d7e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d81:	6a 0e                	push   $0xe
80101d83:	53                   	push   %ebx
80101d84:	57                   	push   %edi
80101d85:	e8 16 30 00 00       	call   80104da0 <memmove>
    path++;
80101d8a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d8d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d90:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d92:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d95:	75 11                	jne    80101da8 <namex+0xb8>
80101d97:	89 f6                	mov    %esi,%esi
80101d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101da0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101da3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101da6:	74 f8                	je     80101da0 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101da8:	83 ec 0c             	sub    $0xc,%esp
80101dab:	56                   	push   %esi
80101dac:	e8 5f f9 ff ff       	call   80101710 <ilock>
    if(ip->type != T_DIR){
80101db1:	83 c4 10             	add    $0x10,%esp
80101db4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101db9:	0f 85 91 00 00 00    	jne    80101e50 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101dbf:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101dc2:	85 d2                	test   %edx,%edx
80101dc4:	74 09                	je     80101dcf <namex+0xdf>
80101dc6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101dc9:	0f 84 b7 00 00 00    	je     80101e86 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101dcf:	83 ec 04             	sub    $0x4,%esp
80101dd2:	6a 00                	push   $0x0
80101dd4:	57                   	push   %edi
80101dd5:	56                   	push   %esi
80101dd6:	e8 65 fe ff ff       	call   80101c40 <dirlookup>
80101ddb:	83 c4 10             	add    $0x10,%esp
80101dde:	85 c0                	test   %eax,%eax
80101de0:	74 6e                	je     80101e50 <namex+0x160>
  iunlock(ip);
80101de2:	83 ec 0c             	sub    $0xc,%esp
80101de5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101de8:	56                   	push   %esi
80101de9:	e8 02 fa ff ff       	call   801017f0 <iunlock>
  iput(ip);
80101dee:	89 34 24             	mov    %esi,(%esp)
80101df1:	e8 4a fa ff ff       	call   80101840 <iput>
80101df6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101df9:	83 c4 10             	add    $0x10,%esp
80101dfc:	89 c6                	mov    %eax,%esi
80101dfe:	e9 38 ff ff ff       	jmp    80101d3b <namex+0x4b>
80101e03:	90                   	nop
80101e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101e08:	89 da                	mov    %ebx,%edx
80101e0a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101e0c:	83 ec 04             	sub    $0x4,%esp
80101e0f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e12:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101e15:	51                   	push   %ecx
80101e16:	53                   	push   %ebx
80101e17:	57                   	push   %edi
80101e18:	e8 83 2f 00 00       	call   80104da0 <memmove>
    name[len] = 0;
80101e1d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101e20:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e23:	83 c4 10             	add    $0x10,%esp
80101e26:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101e2a:	89 d3                	mov    %edx,%ebx
80101e2c:	e9 61 ff ff ff       	jmp    80101d92 <namex+0xa2>
80101e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e38:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e3b:	85 c0                	test   %eax,%eax
80101e3d:	75 5d                	jne    80101e9c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101e3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e42:	89 f0                	mov    %esi,%eax
80101e44:	5b                   	pop    %ebx
80101e45:	5e                   	pop    %esi
80101e46:	5f                   	pop    %edi
80101e47:	5d                   	pop    %ebp
80101e48:	c3                   	ret    
80101e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101e50:	83 ec 0c             	sub    $0xc,%esp
80101e53:	56                   	push   %esi
80101e54:	e8 97 f9 ff ff       	call   801017f0 <iunlock>
  iput(ip);
80101e59:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101e5c:	31 f6                	xor    %esi,%esi
  iput(ip);
80101e5e:	e8 dd f9 ff ff       	call   80101840 <iput>
      return 0;
80101e63:	83 c4 10             	add    $0x10,%esp
}
80101e66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e69:	89 f0                	mov    %esi,%eax
80101e6b:	5b                   	pop    %ebx
80101e6c:	5e                   	pop    %esi
80101e6d:	5f                   	pop    %edi
80101e6e:	5d                   	pop    %ebp
80101e6f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e70:	ba 01 00 00 00       	mov    $0x1,%edx
80101e75:	b8 01 00 00 00       	mov    $0x1,%eax
80101e7a:	e8 21 f4 ff ff       	call   801012a0 <iget>
80101e7f:	89 c6                	mov    %eax,%esi
80101e81:	e9 b5 fe ff ff       	jmp    80101d3b <namex+0x4b>
      iunlock(ip);
80101e86:	83 ec 0c             	sub    $0xc,%esp
80101e89:	56                   	push   %esi
80101e8a:	e8 61 f9 ff ff       	call   801017f0 <iunlock>
      return ip;
80101e8f:	83 c4 10             	add    $0x10,%esp
}
80101e92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e95:	89 f0                	mov    %esi,%eax
80101e97:	5b                   	pop    %ebx
80101e98:	5e                   	pop    %esi
80101e99:	5f                   	pop    %edi
80101e9a:	5d                   	pop    %ebp
80101e9b:	c3                   	ret    
    iput(ip);
80101e9c:	83 ec 0c             	sub    $0xc,%esp
80101e9f:	56                   	push   %esi
    return 0;
80101ea0:	31 f6                	xor    %esi,%esi
    iput(ip);
80101ea2:	e8 99 f9 ff ff       	call   80101840 <iput>
    return 0;
80101ea7:	83 c4 10             	add    $0x10,%esp
80101eaa:	eb 93                	jmp    80101e3f <namex+0x14f>
80101eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101eb0 <dirlink>:
{
80101eb0:	55                   	push   %ebp
80101eb1:	89 e5                	mov    %esp,%ebp
80101eb3:	57                   	push   %edi
80101eb4:	56                   	push   %esi
80101eb5:	53                   	push   %ebx
80101eb6:	83 ec 20             	sub    $0x20,%esp
80101eb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101ebc:	6a 00                	push   $0x0
80101ebe:	ff 75 0c             	pushl  0xc(%ebp)
80101ec1:	53                   	push   %ebx
80101ec2:	e8 79 fd ff ff       	call   80101c40 <dirlookup>
80101ec7:	83 c4 10             	add    $0x10,%esp
80101eca:	85 c0                	test   %eax,%eax
80101ecc:	75 67                	jne    80101f35 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ece:	8b 7b 58             	mov    0x58(%ebx),%edi
80101ed1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ed4:	85 ff                	test   %edi,%edi
80101ed6:	74 29                	je     80101f01 <dirlink+0x51>
80101ed8:	31 ff                	xor    %edi,%edi
80101eda:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101edd:	eb 09                	jmp    80101ee8 <dirlink+0x38>
80101edf:	90                   	nop
80101ee0:	83 c7 10             	add    $0x10,%edi
80101ee3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101ee6:	73 19                	jae    80101f01 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ee8:	6a 10                	push   $0x10
80101eea:	57                   	push   %edi
80101eeb:	56                   	push   %esi
80101eec:	53                   	push   %ebx
80101eed:	e8 fe fa ff ff       	call   801019f0 <readi>
80101ef2:	83 c4 10             	add    $0x10,%esp
80101ef5:	83 f8 10             	cmp    $0x10,%eax
80101ef8:	75 4e                	jne    80101f48 <dirlink+0x98>
    if(de.inum == 0)
80101efa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101eff:	75 df                	jne    80101ee0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101f01:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f04:	83 ec 04             	sub    $0x4,%esp
80101f07:	6a 0e                	push   $0xe
80101f09:	ff 75 0c             	pushl  0xc(%ebp)
80101f0c:	50                   	push   %eax
80101f0d:	e8 5e 2f 00 00       	call   80104e70 <strncpy>
  de.inum = inum;
80101f12:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f15:	6a 10                	push   $0x10
80101f17:	57                   	push   %edi
80101f18:	56                   	push   %esi
80101f19:	53                   	push   %ebx
  de.inum = inum;
80101f1a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f1e:	e8 cd fb ff ff       	call   80101af0 <writei>
80101f23:	83 c4 20             	add    $0x20,%esp
80101f26:	83 f8 10             	cmp    $0x10,%eax
80101f29:	75 2a                	jne    80101f55 <dirlink+0xa5>
  return 0;
80101f2b:	31 c0                	xor    %eax,%eax
}
80101f2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f30:	5b                   	pop    %ebx
80101f31:	5e                   	pop    %esi
80101f32:	5f                   	pop    %edi
80101f33:	5d                   	pop    %ebp
80101f34:	c3                   	ret    
    iput(ip);
80101f35:	83 ec 0c             	sub    $0xc,%esp
80101f38:	50                   	push   %eax
80101f39:	e8 02 f9 ff ff       	call   80101840 <iput>
    return -1;
80101f3e:	83 c4 10             	add    $0x10,%esp
80101f41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f46:	eb e5                	jmp    80101f2d <dirlink+0x7d>
      panic("dirlink read");
80101f48:	83 ec 0c             	sub    $0xc,%esp
80101f4b:	68 b0 7b 10 80       	push   $0x80107bb0
80101f50:	e8 3b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101f55:	83 ec 0c             	sub    $0xc,%esp
80101f58:	68 35 82 10 80       	push   $0x80108235
80101f5d:	e8 2e e4 ff ff       	call   80100390 <panic>
80101f62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f70 <namei>:

struct inode*
namei(char *path)
{
80101f70:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f71:	31 d2                	xor    %edx,%edx
{
80101f73:	89 e5                	mov    %esp,%ebp
80101f75:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f78:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f7e:	e8 6d fd ff ff       	call   80101cf0 <namex>
}
80101f83:	c9                   	leave  
80101f84:	c3                   	ret    
80101f85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f90 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f90:	55                   	push   %ebp
  return namex(path, 1, name);
80101f91:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f96:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f9b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f9e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f9f:	e9 4c fd ff ff       	jmp    80101cf0 <namex>
80101fa4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101faa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101fb0 <itoa>:


#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80101fb0:	55                   	push   %ebp
    char const digit[] = "0123456789";
80101fb1:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
80101fb6:	89 e5                	mov    %esp,%ebp
80101fb8:	57                   	push   %edi
80101fb9:	56                   	push   %esi
80101fba:	53                   	push   %ebx
80101fbb:	83 ec 10             	sub    $0x10,%esp
80101fbe:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80101fc1:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
80101fc8:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
80101fcf:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
80101fd3:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
80101fd7:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* p = b;
    if(i<0){
80101fda:	85 c9                	test   %ecx,%ecx
80101fdc:	79 0a                	jns    80101fe8 <itoa+0x38>
80101fde:	89 f0                	mov    %esi,%eax
80101fe0:	8d 76 01             	lea    0x1(%esi),%esi
        *p++ = '-';
        i *= -1;
80101fe3:	f7 d9                	neg    %ecx
        *p++ = '-';
80101fe5:	c6 00 2d             	movb   $0x2d,(%eax)
    }
    int shifter = i;
80101fe8:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
80101fea:	bf 67 66 66 66       	mov    $0x66666667,%edi
80101fef:	90                   	nop
80101ff0:	89 d8                	mov    %ebx,%eax
80101ff2:	c1 fb 1f             	sar    $0x1f,%ebx
        ++p;
80101ff5:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
80101ff8:	f7 ef                	imul   %edi
80101ffa:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
80101ffd:	29 da                	sub    %ebx,%edx
80101fff:	89 d3                	mov    %edx,%ebx
80102001:	75 ed                	jne    80101ff0 <itoa+0x40>
    *p = '\0';
80102003:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80102006:	bb 67 66 66 66       	mov    $0x66666667,%ebx
8010200b:	90                   	nop
8010200c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102010:	89 c8                	mov    %ecx,%eax
80102012:	83 ee 01             	sub    $0x1,%esi
80102015:	f7 eb                	imul   %ebx
80102017:	89 c8                	mov    %ecx,%eax
80102019:	c1 f8 1f             	sar    $0x1f,%eax
8010201c:	c1 fa 02             	sar    $0x2,%edx
8010201f:	29 c2                	sub    %eax,%edx
80102021:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102024:	01 c0                	add    %eax,%eax
80102026:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
80102028:	85 d2                	test   %edx,%edx
        *--p = digit[i%10];
8010202a:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
8010202f:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
80102031:	88 06                	mov    %al,(%esi)
    }while(i);
80102033:	75 db                	jne    80102010 <itoa+0x60>
    return b;
}
80102035:	8b 45 0c             	mov    0xc(%ebp),%eax
80102038:	83 c4 10             	add    $0x10,%esp
8010203b:	5b                   	pop    %ebx
8010203c:	5e                   	pop    %esi
8010203d:	5f                   	pop    %edi
8010203e:	5d                   	pop    %ebp
8010203f:	c3                   	ret    

80102040 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80102040:	55                   	push   %ebp
80102041:	89 e5                	mov    %esp,%ebp
80102043:	57                   	push   %edi
80102044:	56                   	push   %esi
80102045:	53                   	push   %ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102046:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
80102049:	83 ec 40             	sub    $0x40,%esp
8010204c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
8010204f:	6a 06                	push   $0x6
80102051:	68 bd 7b 10 80       	push   $0x80107bbd
80102056:	56                   	push   %esi
80102057:	e8 44 2d 00 00       	call   80104da0 <memmove>
  itoa(p->pid, path+ 6);
8010205c:	58                   	pop    %eax
8010205d:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80102060:	5a                   	pop    %edx
80102061:	50                   	push   %eax
80102062:	ff 73 10             	pushl  0x10(%ebx)
80102065:	e8 46 ff ff ff       	call   80101fb0 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
8010206a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010206d:	83 c4 10             	add    $0x10,%esp
80102070:	85 c0                	test   %eax,%eax
80102072:	0f 84 88 01 00 00    	je     80102200 <removeSwapFile+0x1c0>
  {
    return -1;
  }
  fileclose(p->swapFile);
80102078:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
8010207b:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
8010207e:	50                   	push   %eax
8010207f:	e8 3c ee ff ff       	call   80100ec0 <fileclose>

  begin_op();
80102084:	e8 07 10 00 00       	call   80103090 <begin_op>
  return namex(path, 1, name);
80102089:	89 f0                	mov    %esi,%eax
8010208b:	89 d9                	mov    %ebx,%ecx
8010208d:	ba 01 00 00 00       	mov    $0x1,%edx
80102092:	e8 59 fc ff ff       	call   80101cf0 <namex>
  if((dp = nameiparent(path, name)) == 0)
80102097:	83 c4 10             	add    $0x10,%esp
8010209a:	85 c0                	test   %eax,%eax
  return namex(path, 1, name);
8010209c:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
8010209e:	0f 84 66 01 00 00    	je     8010220a <removeSwapFile+0x1ca>
  {
    end_op();
    return -1;
  }

  ilock(dp);
801020a4:	83 ec 0c             	sub    $0xc,%esp
801020a7:	50                   	push   %eax
801020a8:	e8 63 f6 ff ff       	call   80101710 <ilock>
  return strncmp(s, t, DIRSIZ);
801020ad:	83 c4 0c             	add    $0xc,%esp
801020b0:	6a 0e                	push   $0xe
801020b2:	68 c5 7b 10 80       	push   $0x80107bc5
801020b7:	53                   	push   %ebx
801020b8:	e8 53 2d 00 00       	call   80104e10 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801020bd:	83 c4 10             	add    $0x10,%esp
801020c0:	85 c0                	test   %eax,%eax
801020c2:	0f 84 f8 00 00 00    	je     801021c0 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
801020c8:	83 ec 04             	sub    $0x4,%esp
801020cb:	6a 0e                	push   $0xe
801020cd:	68 c4 7b 10 80       	push   $0x80107bc4
801020d2:	53                   	push   %ebx
801020d3:	e8 38 2d 00 00       	call   80104e10 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801020d8:	83 c4 10             	add    $0x10,%esp
801020db:	85 c0                	test   %eax,%eax
801020dd:	0f 84 dd 00 00 00    	je     801021c0 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801020e3:	8d 45 b8             	lea    -0x48(%ebp),%eax
801020e6:	83 ec 04             	sub    $0x4,%esp
801020e9:	50                   	push   %eax
801020ea:	53                   	push   %ebx
801020eb:	56                   	push   %esi
801020ec:	e8 4f fb ff ff       	call   80101c40 <dirlookup>
801020f1:	83 c4 10             	add    $0x10,%esp
801020f4:	85 c0                	test   %eax,%eax
801020f6:	89 c3                	mov    %eax,%ebx
801020f8:	0f 84 c2 00 00 00    	je     801021c0 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
801020fe:	83 ec 0c             	sub    $0xc,%esp
80102101:	50                   	push   %eax
80102102:	e8 09 f6 ff ff       	call   80101710 <ilock>

  if(ip->nlink < 1)
80102107:	83 c4 10             	add    $0x10,%esp
8010210a:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010210f:	0f 8e 11 01 00 00    	jle    80102226 <removeSwapFile+0x1e6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102115:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010211a:	74 74                	je     80102190 <removeSwapFile+0x150>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010211c:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010211f:	83 ec 04             	sub    $0x4,%esp
80102122:	6a 10                	push   $0x10
80102124:	6a 00                	push   $0x0
80102126:	57                   	push   %edi
80102127:	e8 c4 2b 00 00       	call   80104cf0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010212c:	6a 10                	push   $0x10
8010212e:	ff 75 b8             	pushl  -0x48(%ebp)
80102131:	57                   	push   %edi
80102132:	56                   	push   %esi
80102133:	e8 b8 f9 ff ff       	call   80101af0 <writei>
80102138:	83 c4 20             	add    $0x20,%esp
8010213b:	83 f8 10             	cmp    $0x10,%eax
8010213e:	0f 85 d5 00 00 00    	jne    80102219 <removeSwapFile+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80102144:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102149:	0f 84 91 00 00 00    	je     801021e0 <removeSwapFile+0x1a0>
  iunlock(ip);
8010214f:	83 ec 0c             	sub    $0xc,%esp
80102152:	56                   	push   %esi
80102153:	e8 98 f6 ff ff       	call   801017f0 <iunlock>
  iput(ip);
80102158:	89 34 24             	mov    %esi,(%esp)
8010215b:	e8 e0 f6 ff ff       	call   80101840 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
80102160:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80102165:	89 1c 24             	mov    %ebx,(%esp)
80102168:	e8 f3 f4 ff ff       	call   80101660 <iupdate>
  iunlock(ip);
8010216d:	89 1c 24             	mov    %ebx,(%esp)
80102170:	e8 7b f6 ff ff       	call   801017f0 <iunlock>
  iput(ip);
80102175:	89 1c 24             	mov    %ebx,(%esp)
80102178:	e8 c3 f6 ff ff       	call   80101840 <iput>
  iunlockput(ip);

  end_op();
8010217d:	e8 7e 0f 00 00       	call   80103100 <end_op>

  return 0;
80102182:	83 c4 10             	add    $0x10,%esp
80102185:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
80102187:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010218a:	5b                   	pop    %ebx
8010218b:	5e                   	pop    %esi
8010218c:	5f                   	pop    %edi
8010218d:	5d                   	pop    %ebp
8010218e:	c3                   	ret    
8010218f:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
80102190:	83 ec 0c             	sub    $0xc,%esp
80102193:	53                   	push   %ebx
80102194:	e8 37 33 00 00       	call   801054d0 <isdirempty>
80102199:	83 c4 10             	add    $0x10,%esp
8010219c:	85 c0                	test   %eax,%eax
8010219e:	0f 85 78 ff ff ff    	jne    8010211c <removeSwapFile+0xdc>
  iunlock(ip);
801021a4:	83 ec 0c             	sub    $0xc,%esp
801021a7:	53                   	push   %ebx
801021a8:	e8 43 f6 ff ff       	call   801017f0 <iunlock>
  iput(ip);
801021ad:	89 1c 24             	mov    %ebx,(%esp)
801021b0:	e8 8b f6 ff ff       	call   80101840 <iput>
801021b5:	83 c4 10             	add    $0x10,%esp
801021b8:	90                   	nop
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801021c0:	83 ec 0c             	sub    $0xc,%esp
801021c3:	56                   	push   %esi
801021c4:	e8 27 f6 ff ff       	call   801017f0 <iunlock>
  iput(ip);
801021c9:	89 34 24             	mov    %esi,(%esp)
801021cc:	e8 6f f6 ff ff       	call   80101840 <iput>
    end_op();
801021d1:	e8 2a 0f 00 00       	call   80103100 <end_op>
    return -1;
801021d6:	83 c4 10             	add    $0x10,%esp
801021d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021de:	eb a7                	jmp    80102187 <removeSwapFile+0x147>
    dp->nlink--;
801021e0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801021e5:	83 ec 0c             	sub    $0xc,%esp
801021e8:	56                   	push   %esi
801021e9:	e8 72 f4 ff ff       	call   80101660 <iupdate>
801021ee:	83 c4 10             	add    $0x10,%esp
801021f1:	e9 59 ff ff ff       	jmp    8010214f <removeSwapFile+0x10f>
801021f6:	8d 76 00             	lea    0x0(%esi),%esi
801021f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102200:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102205:	e9 7d ff ff ff       	jmp    80102187 <removeSwapFile+0x147>
    end_op();
8010220a:	e8 f1 0e 00 00       	call   80103100 <end_op>
    return -1;
8010220f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102214:	e9 6e ff ff ff       	jmp    80102187 <removeSwapFile+0x147>
    panic("unlink: writei");
80102219:	83 ec 0c             	sub    $0xc,%esp
8010221c:	68 d9 7b 10 80       	push   $0x80107bd9
80102221:	e8 6a e1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102226:	83 ec 0c             	sub    $0xc,%esp
80102229:	68 c7 7b 10 80       	push   $0x80107bc7
8010222e:	e8 5d e1 ff ff       	call   80100390 <panic>
80102233:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102240 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	56                   	push   %esi
80102244:	53                   	push   %ebx

  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102245:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
80102248:	83 ec 14             	sub    $0x14,%esp
8010224b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
8010224e:	6a 06                	push   $0x6
80102250:	68 bd 7b 10 80       	push   $0x80107bbd
80102255:	56                   	push   %esi
80102256:	e8 45 2b 00 00       	call   80104da0 <memmove>
  itoa(p->pid, path+ 6);
8010225b:	58                   	pop    %eax
8010225c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010225f:	5a                   	pop    %edx
80102260:	50                   	push   %eax
80102261:	ff 73 10             	pushl  0x10(%ebx)
80102264:	e8 47 fd ff ff       	call   80101fb0 <itoa>

    begin_op();
80102269:	e8 22 0e 00 00       	call   80103090 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
8010226e:	6a 00                	push   $0x0
80102270:	6a 00                	push   $0x0
80102272:	6a 02                	push   $0x2
80102274:	56                   	push   %esi
80102275:	e8 66 34 00 00       	call   801056e0 <create>
  iunlock(in);
8010227a:	83 c4 14             	add    $0x14,%esp
    struct inode * in = create(path, T_FILE, 0, 0);
8010227d:	89 c6                	mov    %eax,%esi
  iunlock(in);
8010227f:	50                   	push   %eax
80102280:	e8 6b f5 ff ff       	call   801017f0 <iunlock>

  p->swapFile = filealloc();
80102285:	e8 76 eb ff ff       	call   80100e00 <filealloc>
  if (p->swapFile == 0)
8010228a:	83 c4 10             	add    $0x10,%esp
8010228d:	85 c0                	test   %eax,%eax
  p->swapFile = filealloc();
8010228f:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
80102292:	74 32                	je     801022c6 <createSwapFile+0x86>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
80102294:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
80102297:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010229a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
801022a0:	8b 43 7c             	mov    0x7c(%ebx),%eax
801022a3:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
801022aa:	8b 43 7c             	mov    0x7c(%ebx),%eax
801022ad:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
801022b1:	8b 43 7c             	mov    0x7c(%ebx),%eax
801022b4:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
801022b8:	e8 43 0e 00 00       	call   80103100 <end_op>

    return 0;
}
801022bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022c0:	31 c0                	xor    %eax,%eax
801022c2:	5b                   	pop    %ebx
801022c3:	5e                   	pop    %esi
801022c4:	5d                   	pop    %ebp
801022c5:	c3                   	ret    
    panic("no slot for files on /store");
801022c6:	83 ec 0c             	sub    $0xc,%esp
801022c9:	68 e8 7b 10 80       	push   $0x80107be8
801022ce:	e8 bd e0 ff ff       	call   80100390 <panic>
801022d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801022d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022e0 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
801022e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801022e9:	8b 50 7c             	mov    0x7c(%eax),%edx
801022ec:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
801022ef:	8b 55 14             	mov    0x14(%ebp),%edx
801022f2:	89 55 10             	mov    %edx,0x10(%ebp)
801022f5:	8b 40 7c             	mov    0x7c(%eax),%eax
801022f8:	89 45 08             	mov    %eax,0x8(%ebp)

}
801022fb:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
801022fc:	e9 6f ed ff ff       	jmp    80101070 <filewrite>
80102301:	eb 0d                	jmp    80102310 <readFromSwapFile>
80102303:	90                   	nop
80102304:	90                   	nop
80102305:	90                   	nop
80102306:	90                   	nop
80102307:	90                   	nop
80102308:	90                   	nop
80102309:	90                   	nop
8010230a:	90                   	nop
8010230b:	90                   	nop
8010230c:	90                   	nop
8010230d:	90                   	nop
8010230e:	90                   	nop
8010230f:	90                   	nop

80102310 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102316:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102319:	8b 50 7c             	mov    0x7c(%eax),%edx
8010231c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
8010231f:	8b 55 14             	mov    0x14(%ebp),%edx
80102322:	89 55 10             	mov    %edx,0x10(%ebp)
80102325:	8b 40 7c             	mov    0x7c(%eax),%eax
80102328:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010232b:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
8010232c:	e9 af ec ff ff       	jmp    80100fe0 <fileread>
80102331:	eb 0d                	jmp    80102340 <copySwapFile>
80102333:	90                   	nop
80102334:	90                   	nop
80102335:	90                   	nop
80102336:	90                   	nop
80102337:	90                   	nop
80102338:	90                   	nop
80102339:	90                   	nop
8010233a:	90                   	nop
8010233b:	90                   	nop
8010233c:	90                   	nop
8010233d:	90                   	nop
8010233e:	90                   	nop
8010233f:	90                   	nop

80102340 <copySwapFile>:

// copies the parent swapFile to the child on fork.
int copySwapFile(struct proc *np, struct proc *p){
80102340:	55                   	push   %ebp
80102341:	89 e5                	mov    %esp,%ebp
80102343:	57                   	push   %edi
80102344:	56                   	push   %esi
80102345:	53                   	push   %ebx
80102346:	83 ec 1c             	sub    $0x1c,%esp
80102349:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010234c:	8b 7d 08             	mov    0x8(%ebp),%edi
	void* buffer = kalloc();
8010234f:	e8 5c 06 00 00       	call   801029b0 <kalloc>
80102354:	89 c2                	mov    %eax,%edx
  return fileread(p->swapFile, buffer,  size);
80102356:	83 ec 04             	sub    $0x4,%esp
	int numFilePages = p->numOfTotalPages - p->numOfPhysPages;
80102359:	8b b3 88 03 00 00    	mov    0x388(%ebx),%esi
8010235f:	2b b3 80 03 00 00    	sub    0x380(%ebx),%esi
  p->swapFile->off = placeOnFile;
80102365:	8b 43 7c             	mov    0x7c(%ebx),%eax
  return fileread(p->swapFile, buffer,  size);
80102368:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int fileSize = numFilePages*PGSIZE;
8010236b:	c1 e6 0c             	shl    $0xc,%esi
  p->swapFile->off = placeOnFile;
8010236e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  return fileread(p->swapFile, buffer,  size);
80102375:	56                   	push   %esi
80102376:	52                   	push   %edx
80102377:	ff 73 7c             	pushl  0x7c(%ebx)
8010237a:	e8 61 ec ff ff       	call   80100fe0 <fileread>
  p->swapFile->off = placeOnFile;
8010237f:	8b 47 7c             	mov    0x7c(%edi),%eax
  return filewrite(p->swapFile, buffer, size);
80102382:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102385:	83 c4 0c             	add    $0xc,%esp
  p->swapFile->off = placeOnFile;
80102388:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  return filewrite(p->swapFile, buffer, size);
8010238f:	56                   	push   %esi
80102390:	52                   	push   %edx
80102391:	ff 77 7c             	pushl  0x7c(%edi)
80102394:	e8 d7 ec ff ff       	call   80101070 <filewrite>
	readFromSwapFile(p, buffer, 0, fileSize);
	writeToSwapFile(np, buffer, 0, fileSize);
	kfree(buffer);
80102399:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010239c:	89 14 24             	mov    %edx,(%esp)
8010239f:	e8 5c 04 00 00       	call   80102800 <kfree>
  np->numOfPhysPages = p->numOfPhysPages;
801023a4:	8b 83 80 03 00 00    	mov    0x380(%ebx),%eax
801023aa:	8d 97 80 00 00 00    	lea    0x80(%edi),%edx
801023b0:	83 c4 10             	add    $0x10,%esp
801023b3:	89 87 80 03 00 00    	mov    %eax,0x380(%edi)
  //cprintf("num of phys pages in fork %d \n", np->numOfPhysPages);
  np->numOfTotalPages = p->numOfTotalPages;
801023b9:	8b 83 88 03 00 00    	mov    0x388(%ebx),%eax
801023bf:	89 87 88 03 00 00    	mov    %eax,0x388(%edi)
801023c5:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
801023cb:	81 c3 00 02 00 00    	add    $0x200,%ebx
801023d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(int i=0; i< MAX_PSYC_PAGES; i++){
    np->procSwappedFiles[i].va = p->procSwappedFiles[i].va;
801023d8:	8b 08                	mov    (%eax),%ecx
801023da:	83 c0 18             	add    $0x18,%eax
801023dd:	83 c2 18             	add    $0x18,%edx
801023e0:	89 4a e8             	mov    %ecx,-0x18(%edx)
    np->procSwappedFiles[i].pte = p->procSwappedFiles[i].pte;
801023e3:	8b 48 ec             	mov    -0x14(%eax),%ecx
801023e6:	89 4a ec             	mov    %ecx,-0x14(%edx)
    np->procSwappedFiles[i].offsetInFile = p->procSwappedFiles[i].offsetInFile;
801023e9:	8b 48 f0             	mov    -0x10(%eax),%ecx
801023ec:	89 4a f0             	mov    %ecx,-0x10(%edx)
    np->procSwappedFiles[i].isOccupied = p->procSwappedFiles[i].isOccupied;
801023ef:	8b 48 f4             	mov    -0xc(%eax),%ecx
801023f2:	89 4a f4             	mov    %ecx,-0xc(%edx)
  for(int i=0; i< MAX_PSYC_PAGES; i++){
801023f5:	39 d8                	cmp    %ebx,%eax
801023f7:	75 df                	jne    801023d8 <copySwapFile+0x98>
  }
  return 0;
}
801023f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023fc:	31 c0                	xor    %eax,%eax
801023fe:	5b                   	pop    %ebx
801023ff:	5e                   	pop    %esi
80102400:	5f                   	pop    %edi
80102401:	5d                   	pop    %ebp
80102402:	c3                   	ret    
80102403:	66 90                	xchg   %ax,%ax
80102405:	66 90                	xchg   %ax,%ax
80102407:	66 90                	xchg   %ax,%ax
80102409:	66 90                	xchg   %ax,%ax
8010240b:	66 90                	xchg   %ax,%ax
8010240d:	66 90                	xchg   %ax,%ax
8010240f:	90                   	nop

80102410 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102410:	55                   	push   %ebp
80102411:	89 e5                	mov    %esp,%ebp
80102413:	57                   	push   %edi
80102414:	56                   	push   %esi
80102415:	53                   	push   %ebx
80102416:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102419:	85 c0                	test   %eax,%eax
8010241b:	0f 84 b4 00 00 00    	je     801024d5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102421:	8b 58 08             	mov    0x8(%eax),%ebx
80102424:	89 c6                	mov    %eax,%esi
80102426:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010242c:	0f 87 96 00 00 00    	ja     801024c8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102432:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102437:	89 f6                	mov    %esi,%esi
80102439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102440:	89 ca                	mov    %ecx,%edx
80102442:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102443:	83 e0 c0             	and    $0xffffffc0,%eax
80102446:	3c 40                	cmp    $0x40,%al
80102448:	75 f6                	jne    80102440 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010244a:	31 ff                	xor    %edi,%edi
8010244c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102451:	89 f8                	mov    %edi,%eax
80102453:	ee                   	out    %al,(%dx)
80102454:	b8 01 00 00 00       	mov    $0x1,%eax
80102459:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010245e:	ee                   	out    %al,(%dx)
8010245f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102464:	89 d8                	mov    %ebx,%eax
80102466:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102467:	89 d8                	mov    %ebx,%eax
80102469:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010246e:	c1 f8 08             	sar    $0x8,%eax
80102471:	ee                   	out    %al,(%dx)
80102472:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102477:	89 f8                	mov    %edi,%eax
80102479:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010247a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010247e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102483:	c1 e0 04             	shl    $0x4,%eax
80102486:	83 e0 10             	and    $0x10,%eax
80102489:	83 c8 e0             	or     $0xffffffe0,%eax
8010248c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010248d:	f6 06 04             	testb  $0x4,(%esi)
80102490:	75 16                	jne    801024a8 <idestart+0x98>
80102492:	b8 20 00 00 00       	mov    $0x20,%eax
80102497:	89 ca                	mov    %ecx,%edx
80102499:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010249a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010249d:	5b                   	pop    %ebx
8010249e:	5e                   	pop    %esi
8010249f:	5f                   	pop    %edi
801024a0:	5d                   	pop    %ebp
801024a1:	c3                   	ret    
801024a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801024a8:	b8 30 00 00 00       	mov    $0x30,%eax
801024ad:	89 ca                	mov    %ecx,%edx
801024af:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801024b0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801024b5:	83 c6 5c             	add    $0x5c,%esi
801024b8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801024bd:	fc                   	cld    
801024be:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801024c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024c3:	5b                   	pop    %ebx
801024c4:	5e                   	pop    %esi
801024c5:	5f                   	pop    %edi
801024c6:	5d                   	pop    %ebp
801024c7:	c3                   	ret    
    panic("incorrect blockno");
801024c8:	83 ec 0c             	sub    $0xc,%esp
801024cb:	68 60 7c 10 80       	push   $0x80107c60
801024d0:	e8 bb de ff ff       	call   80100390 <panic>
    panic("idestart");
801024d5:	83 ec 0c             	sub    $0xc,%esp
801024d8:	68 57 7c 10 80       	push   $0x80107c57
801024dd:	e8 ae de ff ff       	call   80100390 <panic>
801024e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024f0 <ideinit>:
{
801024f0:	55                   	push   %ebp
801024f1:	89 e5                	mov    %esp,%ebp
801024f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801024f6:	68 72 7c 10 80       	push   $0x80107c72
801024fb:	68 80 b5 10 80       	push   $0x8010b580
80102500:	e8 7b 25 00 00       	call   80104a80 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102505:	58                   	pop    %eax
80102506:	a1 00 3d 11 80       	mov    0x80113d00,%eax
8010250b:	5a                   	pop    %edx
8010250c:	83 e8 01             	sub    $0x1,%eax
8010250f:	50                   	push   %eax
80102510:	6a 0e                	push   $0xe
80102512:	e8 a9 02 00 00       	call   801027c0 <ioapicenable>
80102517:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010251a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010251f:	90                   	nop
80102520:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102521:	83 e0 c0             	and    $0xffffffc0,%eax
80102524:	3c 40                	cmp    $0x40,%al
80102526:	75 f8                	jne    80102520 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102528:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010252d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102532:	ee                   	out    %al,(%dx)
80102533:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102538:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010253d:	eb 06                	jmp    80102545 <ideinit+0x55>
8010253f:	90                   	nop
  for(i=0; i<1000; i++){
80102540:	83 e9 01             	sub    $0x1,%ecx
80102543:	74 0f                	je     80102554 <ideinit+0x64>
80102545:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102546:	84 c0                	test   %al,%al
80102548:	74 f6                	je     80102540 <ideinit+0x50>
      havedisk1 = 1;
8010254a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102551:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102554:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102559:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010255e:	ee                   	out    %al,(%dx)
}
8010255f:	c9                   	leave  
80102560:	c3                   	ret    
80102561:	eb 0d                	jmp    80102570 <ideintr>
80102563:	90                   	nop
80102564:	90                   	nop
80102565:	90                   	nop
80102566:	90                   	nop
80102567:	90                   	nop
80102568:	90                   	nop
80102569:	90                   	nop
8010256a:	90                   	nop
8010256b:	90                   	nop
8010256c:	90                   	nop
8010256d:	90                   	nop
8010256e:	90                   	nop
8010256f:	90                   	nop

80102570 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102570:	55                   	push   %ebp
80102571:	89 e5                	mov    %esp,%ebp
80102573:	57                   	push   %edi
80102574:	56                   	push   %esi
80102575:	53                   	push   %ebx
80102576:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102579:	68 80 b5 10 80       	push   $0x8010b580
8010257e:	e8 ed 25 00 00       	call   80104b70 <acquire>

  if((b = idequeue) == 0){
80102583:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102589:	83 c4 10             	add    $0x10,%esp
8010258c:	85 db                	test   %ebx,%ebx
8010258e:	74 67                	je     801025f7 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102590:	8b 43 58             	mov    0x58(%ebx),%eax
80102593:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102598:	8b 3b                	mov    (%ebx),%edi
8010259a:	f7 c7 04 00 00 00    	test   $0x4,%edi
801025a0:	75 31                	jne    801025d3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025a2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801025a7:	89 f6                	mov    %esi,%esi
801025a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801025b0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801025b1:	89 c6                	mov    %eax,%esi
801025b3:	83 e6 c0             	and    $0xffffffc0,%esi
801025b6:	89 f1                	mov    %esi,%ecx
801025b8:	80 f9 40             	cmp    $0x40,%cl
801025bb:	75 f3                	jne    801025b0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801025bd:	a8 21                	test   $0x21,%al
801025bf:	75 12                	jne    801025d3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801025c1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801025c4:	b9 80 00 00 00       	mov    $0x80,%ecx
801025c9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801025ce:	fc                   	cld    
801025cf:	f3 6d                	rep insl (%dx),%es:(%edi)
801025d1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801025d3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801025d6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801025d9:	89 f9                	mov    %edi,%ecx
801025db:	83 c9 02             	or     $0x2,%ecx
801025de:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801025e0:	53                   	push   %ebx
801025e1:	e8 ea 1e 00 00       	call   801044d0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801025e6:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801025eb:	83 c4 10             	add    $0x10,%esp
801025ee:	85 c0                	test   %eax,%eax
801025f0:	74 05                	je     801025f7 <ideintr+0x87>
    idestart(idequeue);
801025f2:	e8 19 fe ff ff       	call   80102410 <idestart>
    release(&idelock);
801025f7:	83 ec 0c             	sub    $0xc,%esp
801025fa:	68 80 b5 10 80       	push   $0x8010b580
801025ff:	e8 8c 26 00 00       	call   80104c90 <release>

  release(&idelock);
}
80102604:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102607:	5b                   	pop    %ebx
80102608:	5e                   	pop    %esi
80102609:	5f                   	pop    %edi
8010260a:	5d                   	pop    %ebp
8010260b:	c3                   	ret    
8010260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102610 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	53                   	push   %ebx
80102614:	83 ec 10             	sub    $0x10,%esp
80102617:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010261a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010261d:	50                   	push   %eax
8010261e:	e8 2d 24 00 00       	call   80104a50 <holdingsleep>
80102623:	83 c4 10             	add    $0x10,%esp
80102626:	85 c0                	test   %eax,%eax
80102628:	0f 84 c6 00 00 00    	je     801026f4 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010262e:	8b 03                	mov    (%ebx),%eax
80102630:	83 e0 06             	and    $0x6,%eax
80102633:	83 f8 02             	cmp    $0x2,%eax
80102636:	0f 84 ab 00 00 00    	je     801026e7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010263c:	8b 53 04             	mov    0x4(%ebx),%edx
8010263f:	85 d2                	test   %edx,%edx
80102641:	74 0d                	je     80102650 <iderw+0x40>
80102643:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102648:	85 c0                	test   %eax,%eax
8010264a:	0f 84 b1 00 00 00    	je     80102701 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102650:	83 ec 0c             	sub    $0xc,%esp
80102653:	68 80 b5 10 80       	push   $0x8010b580
80102658:	e8 13 25 00 00       	call   80104b70 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010265d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102663:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102666:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010266d:	85 d2                	test   %edx,%edx
8010266f:	75 09                	jne    8010267a <iderw+0x6a>
80102671:	eb 6d                	jmp    801026e0 <iderw+0xd0>
80102673:	90                   	nop
80102674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102678:	89 c2                	mov    %eax,%edx
8010267a:	8b 42 58             	mov    0x58(%edx),%eax
8010267d:	85 c0                	test   %eax,%eax
8010267f:	75 f7                	jne    80102678 <iderw+0x68>
80102681:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102684:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102686:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010268c:	74 42                	je     801026d0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010268e:	8b 03                	mov    (%ebx),%eax
80102690:	83 e0 06             	and    $0x6,%eax
80102693:	83 f8 02             	cmp    $0x2,%eax
80102696:	74 23                	je     801026bb <iderw+0xab>
80102698:	90                   	nop
80102699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801026a0:	83 ec 08             	sub    $0x8,%esp
801026a3:	68 80 b5 10 80       	push   $0x8010b580
801026a8:	53                   	push   %ebx
801026a9:	e8 62 1c 00 00       	call   80104310 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801026ae:	8b 03                	mov    (%ebx),%eax
801026b0:	83 c4 10             	add    $0x10,%esp
801026b3:	83 e0 06             	and    $0x6,%eax
801026b6:	83 f8 02             	cmp    $0x2,%eax
801026b9:	75 e5                	jne    801026a0 <iderw+0x90>
  }


  release(&idelock);
801026bb:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801026c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026c5:	c9                   	leave  
  release(&idelock);
801026c6:	e9 c5 25 00 00       	jmp    80104c90 <release>
801026cb:	90                   	nop
801026cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801026d0:	89 d8                	mov    %ebx,%eax
801026d2:	e8 39 fd ff ff       	call   80102410 <idestart>
801026d7:	eb b5                	jmp    8010268e <iderw+0x7e>
801026d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801026e0:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801026e5:	eb 9d                	jmp    80102684 <iderw+0x74>
    panic("iderw: nothing to do");
801026e7:	83 ec 0c             	sub    $0xc,%esp
801026ea:	68 8c 7c 10 80       	push   $0x80107c8c
801026ef:	e8 9c dc ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801026f4:	83 ec 0c             	sub    $0xc,%esp
801026f7:	68 76 7c 10 80       	push   $0x80107c76
801026fc:	e8 8f dc ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102701:	83 ec 0c             	sub    $0xc,%esp
80102704:	68 a1 7c 10 80       	push   $0x80107ca1
80102709:	e8 82 dc ff ff       	call   80100390 <panic>
8010270e:	66 90                	xchg   %ax,%ax

80102710 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102710:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102711:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
80102718:	00 c0 fe 
{
8010271b:	89 e5                	mov    %esp,%ebp
8010271d:	56                   	push   %esi
8010271e:	53                   	push   %ebx
  ioapic->reg = reg;
8010271f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102726:	00 00 00 
  return ioapic->data;
80102729:	a1 34 36 11 80       	mov    0x80113634,%eax
8010272e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102731:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102737:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010273d:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102744:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102747:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010274a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010274d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102750:	39 c2                	cmp    %eax,%edx
80102752:	74 16                	je     8010276a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102754:	83 ec 0c             	sub    $0xc,%esp
80102757:	68 c0 7c 10 80       	push   $0x80107cc0
8010275c:	e8 ff de ff ff       	call   80100660 <cprintf>
80102761:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102767:	83 c4 10             	add    $0x10,%esp
8010276a:	83 c3 21             	add    $0x21,%ebx
{
8010276d:	ba 10 00 00 00       	mov    $0x10,%edx
80102772:	b8 20 00 00 00       	mov    $0x20,%eax
80102777:	89 f6                	mov    %esi,%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102780:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102782:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102788:	89 c6                	mov    %eax,%esi
8010278a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102790:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102793:	89 71 10             	mov    %esi,0x10(%ecx)
80102796:	8d 72 01             	lea    0x1(%edx),%esi
80102799:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010279c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010279e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801027a0:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801027a6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801027ad:	75 d1                	jne    80102780 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801027af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027b2:	5b                   	pop    %ebx
801027b3:	5e                   	pop    %esi
801027b4:	5d                   	pop    %ebp
801027b5:	c3                   	ret    
801027b6:	8d 76 00             	lea    0x0(%esi),%esi
801027b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027c0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801027c0:	55                   	push   %ebp
  ioapic->reg = reg;
801027c1:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
{
801027c7:	89 e5                	mov    %esp,%ebp
801027c9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801027cc:	8d 50 20             	lea    0x20(%eax),%edx
801027cf:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801027d3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801027d5:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801027db:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801027de:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801027e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801027e4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801027e6:	a1 34 36 11 80       	mov    0x80113634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801027eb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801027ee:	89 50 10             	mov    %edx,0x10(%eax)
}
801027f1:	5d                   	pop    %ebp
801027f2:	c3                   	ret    
801027f3:	66 90                	xchg   %ax,%ax
801027f5:	66 90                	xchg   %ax,%ax
801027f7:	66 90                	xchg   %ax,%ax
801027f9:	66 90                	xchg   %ax,%ax
801027fb:	66 90                	xchg   %ax,%ax
801027fd:	66 90                	xchg   %ax,%ax
801027ff:	90                   	nop

80102800 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102800:	55                   	push   %ebp
80102801:	89 e5                	mov    %esp,%ebp
80102803:	53                   	push   %ebx
80102804:	83 ec 04             	sub    $0x4,%esp
80102807:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010280a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102810:	75 70                	jne    80102882 <kfree+0x82>
80102812:	81 fb c8 28 12 80    	cmp    $0x801228c8,%ebx
80102818:	72 68                	jb     80102882 <kfree+0x82>
8010281a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102820:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102825:	77 5b                	ja     80102882 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102827:	83 ec 04             	sub    $0x4,%esp
8010282a:	68 00 10 00 00       	push   $0x1000
8010282f:	6a 01                	push   $0x1
80102831:	53                   	push   %ebx
80102832:	e8 b9 24 00 00       	call   80104cf0 <memset>

  if(kmem.use_lock)
80102837:	8b 15 74 36 11 80    	mov    0x80113674,%edx
8010283d:	83 c4 10             	add    $0x10,%esp
80102840:	85 d2                	test   %edx,%edx
80102842:	75 2c                	jne    80102870 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102844:	a1 78 36 11 80       	mov    0x80113678,%eax
80102849:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010284b:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
80102850:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
80102856:	85 c0                	test   %eax,%eax
80102858:	75 06                	jne    80102860 <kfree+0x60>
    release(&kmem.lock);
}
8010285a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010285d:	c9                   	leave  
8010285e:	c3                   	ret    
8010285f:	90                   	nop
    release(&kmem.lock);
80102860:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
80102867:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010286a:	c9                   	leave  
    release(&kmem.lock);
8010286b:	e9 20 24 00 00       	jmp    80104c90 <release>
    acquire(&kmem.lock);
80102870:	83 ec 0c             	sub    $0xc,%esp
80102873:	68 40 36 11 80       	push   $0x80113640
80102878:	e8 f3 22 00 00       	call   80104b70 <acquire>
8010287d:	83 c4 10             	add    $0x10,%esp
80102880:	eb c2                	jmp    80102844 <kfree+0x44>
    panic("kfree");
80102882:	83 ec 0c             	sub    $0xc,%esp
80102885:	68 f2 7c 10 80       	push   $0x80107cf2
8010288a:	e8 01 db ff ff       	call   80100390 <panic>
8010288f:	90                   	nop

80102890 <freerange>:
{
80102890:	55                   	push   %ebp
80102891:	89 e5                	mov    %esp,%ebp
80102893:	56                   	push   %esi
80102894:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102895:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102898:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010289b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801028a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801028ad:	39 de                	cmp    %ebx,%esi
801028af:	72 23                	jb     801028d4 <freerange+0x44>
801028b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801028b8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801028be:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801028c7:	50                   	push   %eax
801028c8:	e8 33 ff ff ff       	call   80102800 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028cd:	83 c4 10             	add    $0x10,%esp
801028d0:	39 f3                	cmp    %esi,%ebx
801028d2:	76 e4                	jbe    801028b8 <freerange+0x28>
}
801028d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028d7:	5b                   	pop    %ebx
801028d8:	5e                   	pop    %esi
801028d9:	5d                   	pop    %ebp
801028da:	c3                   	ret    
801028db:	90                   	nop
801028dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028e0 <kinit1>:
{
801028e0:	55                   	push   %ebp
801028e1:	89 e5                	mov    %esp,%ebp
801028e3:	56                   	push   %esi
801028e4:	53                   	push   %ebx
801028e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801028e8:	83 ec 08             	sub    $0x8,%esp
801028eb:	68 f8 7c 10 80       	push   $0x80107cf8
801028f0:	68 40 36 11 80       	push   $0x80113640
801028f5:	e8 86 21 00 00       	call   80104a80 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801028fa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028fd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102900:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
80102907:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010290a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102910:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102916:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010291c:	39 de                	cmp    %ebx,%esi
8010291e:	72 1c                	jb     8010293c <kinit1+0x5c>
    kfree(p);
80102920:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102926:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102929:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010292f:	50                   	push   %eax
80102930:	e8 cb fe ff ff       	call   80102800 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102935:	83 c4 10             	add    $0x10,%esp
80102938:	39 de                	cmp    %ebx,%esi
8010293a:	73 e4                	jae    80102920 <kinit1+0x40>
}
8010293c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010293f:	5b                   	pop    %ebx
80102940:	5e                   	pop    %esi
80102941:	5d                   	pop    %ebp
80102942:	c3                   	ret    
80102943:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102950 <kinit2>:
{
80102950:	55                   	push   %ebp
80102951:	89 e5                	mov    %esp,%ebp
80102953:	56                   	push   %esi
80102954:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102955:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102958:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010295b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102961:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102967:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010296d:	39 de                	cmp    %ebx,%esi
8010296f:	72 23                	jb     80102994 <kinit2+0x44>
80102971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102978:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010297e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102981:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102987:	50                   	push   %eax
80102988:	e8 73 fe ff ff       	call   80102800 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010298d:	83 c4 10             	add    $0x10,%esp
80102990:	39 de                	cmp    %ebx,%esi
80102992:	73 e4                	jae    80102978 <kinit2+0x28>
  kmem.use_lock = 1;
80102994:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010299b:	00 00 00 
}
8010299e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801029a1:	5b                   	pop    %ebx
801029a2:	5e                   	pop    %esi
801029a3:	5d                   	pop    %ebp
801029a4:	c3                   	ret    
801029a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029b0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801029b0:	a1 74 36 11 80       	mov    0x80113674,%eax
801029b5:	85 c0                	test   %eax,%eax
801029b7:	75 1f                	jne    801029d8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801029b9:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
801029be:	85 c0                	test   %eax,%eax
801029c0:	74 0e                	je     801029d0 <kalloc+0x20>
    kmem.freelist = r->next;
801029c2:	8b 10                	mov    (%eax),%edx
801029c4:	89 15 78 36 11 80    	mov    %edx,0x80113678
801029ca:	c3                   	ret    
801029cb:	90                   	nop
801029cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801029d0:	f3 c3                	repz ret 
801029d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801029d8:	55                   	push   %ebp
801029d9:	89 e5                	mov    %esp,%ebp
801029db:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801029de:	68 40 36 11 80       	push   $0x80113640
801029e3:	e8 88 21 00 00       	call   80104b70 <acquire>
  r = kmem.freelist;
801029e8:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
801029ed:	83 c4 10             	add    $0x10,%esp
801029f0:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801029f6:	85 c0                	test   %eax,%eax
801029f8:	74 08                	je     80102a02 <kalloc+0x52>
    kmem.freelist = r->next;
801029fa:	8b 08                	mov    (%eax),%ecx
801029fc:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
80102a02:	85 d2                	test   %edx,%edx
80102a04:	74 16                	je     80102a1c <kalloc+0x6c>
    release(&kmem.lock);
80102a06:	83 ec 0c             	sub    $0xc,%esp
80102a09:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a0c:	68 40 36 11 80       	push   $0x80113640
80102a11:	e8 7a 22 00 00       	call   80104c90 <release>
  return (char*)r;
80102a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102a19:	83 c4 10             	add    $0x10,%esp
}
80102a1c:	c9                   	leave  
80102a1d:	c3                   	ret    
80102a1e:	66 90                	xchg   %ax,%ax

80102a20 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a20:	ba 64 00 00 00       	mov    $0x64,%edx
80102a25:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102a26:	a8 01                	test   $0x1,%al
80102a28:	0f 84 c2 00 00 00    	je     80102af0 <kbdgetc+0xd0>
80102a2e:	ba 60 00 00 00       	mov    $0x60,%edx
80102a33:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102a34:	0f b6 d0             	movzbl %al,%edx
80102a37:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
80102a3d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102a43:	0f 84 7f 00 00 00    	je     80102ac8 <kbdgetc+0xa8>
{
80102a49:	55                   	push   %ebp
80102a4a:	89 e5                	mov    %esp,%ebp
80102a4c:	53                   	push   %ebx
80102a4d:	89 cb                	mov    %ecx,%ebx
80102a4f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102a52:	84 c0                	test   %al,%al
80102a54:	78 4a                	js     80102aa0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102a56:	85 db                	test   %ebx,%ebx
80102a58:	74 09                	je     80102a63 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102a5a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102a5d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102a60:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102a63:	0f b6 82 20 7e 10 80 	movzbl -0x7fef81e0(%edx),%eax
80102a6a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102a6c:	0f b6 82 20 7d 10 80 	movzbl -0x7fef82e0(%edx),%eax
80102a73:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a75:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102a77:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102a7d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102a80:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a83:	8b 04 85 00 7d 10 80 	mov    -0x7fef8300(,%eax,4),%eax
80102a8a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102a8e:	74 31                	je     80102ac1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102a90:	8d 50 9f             	lea    -0x61(%eax),%edx
80102a93:	83 fa 19             	cmp    $0x19,%edx
80102a96:	77 40                	ja     80102ad8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102a98:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102a9b:	5b                   	pop    %ebx
80102a9c:	5d                   	pop    %ebp
80102a9d:	c3                   	ret    
80102a9e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102aa0:	83 e0 7f             	and    $0x7f,%eax
80102aa3:	85 db                	test   %ebx,%ebx
80102aa5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102aa8:	0f b6 82 20 7e 10 80 	movzbl -0x7fef81e0(%edx),%eax
80102aaf:	83 c8 40             	or     $0x40,%eax
80102ab2:	0f b6 c0             	movzbl %al,%eax
80102ab5:	f7 d0                	not    %eax
80102ab7:	21 c1                	and    %eax,%ecx
    return 0;
80102ab9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102abb:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102ac1:	5b                   	pop    %ebx
80102ac2:	5d                   	pop    %ebp
80102ac3:	c3                   	ret    
80102ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102ac8:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102acb:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102acd:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
80102ad3:	c3                   	ret    
80102ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102ad8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102adb:	8d 50 20             	lea    0x20(%eax),%edx
}
80102ade:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102adf:	83 f9 1a             	cmp    $0x1a,%ecx
80102ae2:	0f 42 c2             	cmovb  %edx,%eax
}
80102ae5:	5d                   	pop    %ebp
80102ae6:	c3                   	ret    
80102ae7:	89 f6                	mov    %esi,%esi
80102ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102af0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102af5:	c3                   	ret    
80102af6:	8d 76 00             	lea    0x0(%esi),%esi
80102af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b00 <kbdintr>:

void
kbdintr(void)
{
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
80102b03:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102b06:	68 20 2a 10 80       	push   $0x80102a20
80102b0b:	e8 00 dd ff ff       	call   80100810 <consoleintr>
}
80102b10:	83 c4 10             	add    $0x10,%esp
80102b13:	c9                   	leave  
80102b14:	c3                   	ret    
80102b15:	66 90                	xchg   %ax,%ax
80102b17:	66 90                	xchg   %ax,%ax
80102b19:	66 90                	xchg   %ax,%ax
80102b1b:	66 90                	xchg   %ax,%ax
80102b1d:	66 90                	xchg   %ax,%ax
80102b1f:	90                   	nop

80102b20 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102b20:	a1 7c 36 11 80       	mov    0x8011367c,%eax
{
80102b25:	55                   	push   %ebp
80102b26:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102b28:	85 c0                	test   %eax,%eax
80102b2a:	0f 84 c8 00 00 00    	je     80102bf8 <lapicinit+0xd8>
  lapic[index] = value;
80102b30:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102b37:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b3a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b3d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102b44:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b47:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b4a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102b51:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102b54:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b57:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102b5e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102b61:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b64:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102b6b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b6e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b71:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102b78:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b7b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102b7e:	8b 50 30             	mov    0x30(%eax),%edx
80102b81:	c1 ea 10             	shr    $0x10,%edx
80102b84:	80 fa 03             	cmp    $0x3,%dl
80102b87:	77 77                	ja     80102c00 <lapicinit+0xe0>
  lapic[index] = value;
80102b89:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102b90:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b93:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b96:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102b9d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ba0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ba3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102baa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bad:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bb0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102bb7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bba:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bbd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102bc4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bc7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bca:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102bd1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102bd4:	8b 50 20             	mov    0x20(%eax),%edx
80102bd7:	89 f6                	mov    %esi,%esi
80102bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102be0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102be6:	80 e6 10             	and    $0x10,%dh
80102be9:	75 f5                	jne    80102be0 <lapicinit+0xc0>
  lapic[index] = value;
80102beb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102bf2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bf5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102bf8:	5d                   	pop    %ebp
80102bf9:	c3                   	ret    
80102bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102c00:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102c07:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102c0a:	8b 50 20             	mov    0x20(%eax),%edx
80102c0d:	e9 77 ff ff ff       	jmp    80102b89 <lapicinit+0x69>
80102c12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c20 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102c20:	8b 15 7c 36 11 80    	mov    0x8011367c,%edx
{
80102c26:	55                   	push   %ebp
80102c27:	31 c0                	xor    %eax,%eax
80102c29:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102c2b:	85 d2                	test   %edx,%edx
80102c2d:	74 06                	je     80102c35 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102c2f:	8b 42 20             	mov    0x20(%edx),%eax
80102c32:	c1 e8 18             	shr    $0x18,%eax
}
80102c35:	5d                   	pop    %ebp
80102c36:	c3                   	ret    
80102c37:	89 f6                	mov    %esi,%esi
80102c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c40 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102c40:	a1 7c 36 11 80       	mov    0x8011367c,%eax
{
80102c45:	55                   	push   %ebp
80102c46:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102c48:	85 c0                	test   %eax,%eax
80102c4a:	74 0d                	je     80102c59 <lapiceoi+0x19>
  lapic[index] = value;
80102c4c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102c53:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c56:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102c59:	5d                   	pop    %ebp
80102c5a:	c3                   	ret    
80102c5b:	90                   	nop
80102c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c60 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102c60:	55                   	push   %ebp
80102c61:	89 e5                	mov    %esp,%ebp
}
80102c63:	5d                   	pop    %ebp
80102c64:	c3                   	ret    
80102c65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c70 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102c70:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c71:	b8 0f 00 00 00       	mov    $0xf,%eax
80102c76:	ba 70 00 00 00       	mov    $0x70,%edx
80102c7b:	89 e5                	mov    %esp,%ebp
80102c7d:	53                   	push   %ebx
80102c7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102c81:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102c84:	ee                   	out    %al,(%dx)
80102c85:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c8a:	ba 71 00 00 00       	mov    $0x71,%edx
80102c8f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102c90:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102c92:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102c95:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102c9b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c9d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102ca0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102ca3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102ca5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102ca8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102cae:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102cb3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cb9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cbc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102cc3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cc6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cc9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102cd0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cd3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cd6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cdc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cdf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ce5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ce8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cf1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cf7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102cfa:	5b                   	pop    %ebx
80102cfb:	5d                   	pop    %ebp
80102cfc:	c3                   	ret    
80102cfd:	8d 76 00             	lea    0x0(%esi),%esi

80102d00 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102d00:	55                   	push   %ebp
80102d01:	b8 0b 00 00 00       	mov    $0xb,%eax
80102d06:	ba 70 00 00 00       	mov    $0x70,%edx
80102d0b:	89 e5                	mov    %esp,%ebp
80102d0d:	57                   	push   %edi
80102d0e:	56                   	push   %esi
80102d0f:	53                   	push   %ebx
80102d10:	83 ec 4c             	sub    $0x4c,%esp
80102d13:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d14:	ba 71 00 00 00       	mov    $0x71,%edx
80102d19:	ec                   	in     (%dx),%al
80102d1a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d1d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102d22:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102d25:	8d 76 00             	lea    0x0(%esi),%esi
80102d28:	31 c0                	xor    %eax,%eax
80102d2a:	89 da                	mov    %ebx,%edx
80102d2c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d2d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102d32:	89 ca                	mov    %ecx,%edx
80102d34:	ec                   	in     (%dx),%al
80102d35:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d38:	89 da                	mov    %ebx,%edx
80102d3a:	b8 02 00 00 00       	mov    $0x2,%eax
80102d3f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d40:	89 ca                	mov    %ecx,%edx
80102d42:	ec                   	in     (%dx),%al
80102d43:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d46:	89 da                	mov    %ebx,%edx
80102d48:	b8 04 00 00 00       	mov    $0x4,%eax
80102d4d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d4e:	89 ca                	mov    %ecx,%edx
80102d50:	ec                   	in     (%dx),%al
80102d51:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d54:	89 da                	mov    %ebx,%edx
80102d56:	b8 07 00 00 00       	mov    $0x7,%eax
80102d5b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d5c:	89 ca                	mov    %ecx,%edx
80102d5e:	ec                   	in     (%dx),%al
80102d5f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d62:	89 da                	mov    %ebx,%edx
80102d64:	b8 08 00 00 00       	mov    $0x8,%eax
80102d69:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d6a:	89 ca                	mov    %ecx,%edx
80102d6c:	ec                   	in     (%dx),%al
80102d6d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d6f:	89 da                	mov    %ebx,%edx
80102d71:	b8 09 00 00 00       	mov    $0x9,%eax
80102d76:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d77:	89 ca                	mov    %ecx,%edx
80102d79:	ec                   	in     (%dx),%al
80102d7a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d7c:	89 da                	mov    %ebx,%edx
80102d7e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102d83:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d84:	89 ca                	mov    %ecx,%edx
80102d86:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102d87:	84 c0                	test   %al,%al
80102d89:	78 9d                	js     80102d28 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102d8b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102d8f:	89 fa                	mov    %edi,%edx
80102d91:	0f b6 fa             	movzbl %dl,%edi
80102d94:	89 f2                	mov    %esi,%edx
80102d96:	0f b6 f2             	movzbl %dl,%esi
80102d99:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d9c:	89 da                	mov    %ebx,%edx
80102d9e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102da1:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102da4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102da8:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102dab:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102daf:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102db2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102db6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102db9:	31 c0                	xor    %eax,%eax
80102dbb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dbc:	89 ca                	mov    %ecx,%edx
80102dbe:	ec                   	in     (%dx),%al
80102dbf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dc2:	89 da                	mov    %ebx,%edx
80102dc4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102dc7:	b8 02 00 00 00       	mov    $0x2,%eax
80102dcc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dcd:	89 ca                	mov    %ecx,%edx
80102dcf:	ec                   	in     (%dx),%al
80102dd0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dd3:	89 da                	mov    %ebx,%edx
80102dd5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102dd8:	b8 04 00 00 00       	mov    $0x4,%eax
80102ddd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dde:	89 ca                	mov    %ecx,%edx
80102de0:	ec                   	in     (%dx),%al
80102de1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102de4:	89 da                	mov    %ebx,%edx
80102de6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102de9:	b8 07 00 00 00       	mov    $0x7,%eax
80102dee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102def:	89 ca                	mov    %ecx,%edx
80102df1:	ec                   	in     (%dx),%al
80102df2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102df5:	89 da                	mov    %ebx,%edx
80102df7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102dfa:	b8 08 00 00 00       	mov    $0x8,%eax
80102dff:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e00:	89 ca                	mov    %ecx,%edx
80102e02:	ec                   	in     (%dx),%al
80102e03:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e06:	89 da                	mov    %ebx,%edx
80102e08:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102e0b:	b8 09 00 00 00       	mov    $0x9,%eax
80102e10:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e11:	89 ca                	mov    %ecx,%edx
80102e13:	ec                   	in     (%dx),%al
80102e14:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e17:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102e1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e1d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102e20:	6a 18                	push   $0x18
80102e22:	50                   	push   %eax
80102e23:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102e26:	50                   	push   %eax
80102e27:	e8 14 1f 00 00       	call   80104d40 <memcmp>
80102e2c:	83 c4 10             	add    $0x10,%esp
80102e2f:	85 c0                	test   %eax,%eax
80102e31:	0f 85 f1 fe ff ff    	jne    80102d28 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102e37:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102e3b:	75 78                	jne    80102eb5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102e3d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102e40:	89 c2                	mov    %eax,%edx
80102e42:	83 e0 0f             	and    $0xf,%eax
80102e45:	c1 ea 04             	shr    $0x4,%edx
80102e48:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e4b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e4e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102e51:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102e54:	89 c2                	mov    %eax,%edx
80102e56:	83 e0 0f             	and    $0xf,%eax
80102e59:	c1 ea 04             	shr    $0x4,%edx
80102e5c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e5f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e62:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102e65:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102e68:	89 c2                	mov    %eax,%edx
80102e6a:	83 e0 0f             	and    $0xf,%eax
80102e6d:	c1 ea 04             	shr    $0x4,%edx
80102e70:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e73:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e76:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102e79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102e7c:	89 c2                	mov    %eax,%edx
80102e7e:	83 e0 0f             	and    $0xf,%eax
80102e81:	c1 ea 04             	shr    $0x4,%edx
80102e84:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e87:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e8a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102e8d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102e90:	89 c2                	mov    %eax,%edx
80102e92:	83 e0 0f             	and    $0xf,%eax
80102e95:	c1 ea 04             	shr    $0x4,%edx
80102e98:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e9b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e9e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102ea1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ea4:	89 c2                	mov    %eax,%edx
80102ea6:	83 e0 0f             	and    $0xf,%eax
80102ea9:	c1 ea 04             	shr    $0x4,%edx
80102eac:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102eaf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102eb2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102eb5:	8b 75 08             	mov    0x8(%ebp),%esi
80102eb8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ebb:	89 06                	mov    %eax,(%esi)
80102ebd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ec0:	89 46 04             	mov    %eax,0x4(%esi)
80102ec3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ec6:	89 46 08             	mov    %eax,0x8(%esi)
80102ec9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102ecc:	89 46 0c             	mov    %eax,0xc(%esi)
80102ecf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ed2:	89 46 10             	mov    %eax,0x10(%esi)
80102ed5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ed8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102edb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102ee2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ee5:	5b                   	pop    %ebx
80102ee6:	5e                   	pop    %esi
80102ee7:	5f                   	pop    %edi
80102ee8:	5d                   	pop    %ebp
80102ee9:	c3                   	ret    
80102eea:	66 90                	xchg   %ax,%ax
80102eec:	66 90                	xchg   %ax,%ax
80102eee:	66 90                	xchg   %ax,%ax

80102ef0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ef0:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102ef6:	85 c9                	test   %ecx,%ecx
80102ef8:	0f 8e 8a 00 00 00    	jle    80102f88 <install_trans+0x98>
{
80102efe:	55                   	push   %ebp
80102eff:	89 e5                	mov    %esp,%ebp
80102f01:	57                   	push   %edi
80102f02:	56                   	push   %esi
80102f03:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102f04:	31 db                	xor    %ebx,%ebx
{
80102f06:	83 ec 0c             	sub    $0xc,%esp
80102f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102f10:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102f15:	83 ec 08             	sub    $0x8,%esp
80102f18:	01 d8                	add    %ebx,%eax
80102f1a:	83 c0 01             	add    $0x1,%eax
80102f1d:	50                   	push   %eax
80102f1e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102f24:	e8 a7 d1 ff ff       	call   801000d0 <bread>
80102f29:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f2b:	58                   	pop    %eax
80102f2c:	5a                   	pop    %edx
80102f2d:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102f34:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102f3a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f3d:	e8 8e d1 ff ff       	call   801000d0 <bread>
80102f42:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102f44:	8d 47 5c             	lea    0x5c(%edi),%eax
80102f47:	83 c4 0c             	add    $0xc,%esp
80102f4a:	68 00 02 00 00       	push   $0x200
80102f4f:	50                   	push   %eax
80102f50:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f53:	50                   	push   %eax
80102f54:	e8 47 1e 00 00       	call   80104da0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102f59:	89 34 24             	mov    %esi,(%esp)
80102f5c:	e8 3f d2 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102f61:	89 3c 24             	mov    %edi,(%esp)
80102f64:	e8 77 d2 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102f69:	89 34 24             	mov    %esi,(%esp)
80102f6c:	e8 6f d2 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f71:	83 c4 10             	add    $0x10,%esp
80102f74:	39 1d c8 36 11 80    	cmp    %ebx,0x801136c8
80102f7a:	7f 94                	jg     80102f10 <install_trans+0x20>
  }
}
80102f7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f7f:	5b                   	pop    %ebx
80102f80:	5e                   	pop    %esi
80102f81:	5f                   	pop    %edi
80102f82:	5d                   	pop    %ebp
80102f83:	c3                   	ret    
80102f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f88:	f3 c3                	repz ret 
80102f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102f90 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102f90:	55                   	push   %ebp
80102f91:	89 e5                	mov    %esp,%ebp
80102f93:	56                   	push   %esi
80102f94:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102f95:	83 ec 08             	sub    $0x8,%esp
80102f98:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102f9e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102fa4:	e8 27 d1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102fa9:	8b 1d c8 36 11 80    	mov    0x801136c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102faf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102fb2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102fb4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102fb6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102fb9:	7e 16                	jle    80102fd1 <write_head+0x41>
80102fbb:	c1 e3 02             	shl    $0x2,%ebx
80102fbe:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102fc0:	8b 8a cc 36 11 80    	mov    -0x7feec934(%edx),%ecx
80102fc6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102fca:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102fcd:	39 da                	cmp    %ebx,%edx
80102fcf:	75 ef                	jne    80102fc0 <write_head+0x30>
  }
  bwrite(buf);
80102fd1:	83 ec 0c             	sub    $0xc,%esp
80102fd4:	56                   	push   %esi
80102fd5:	e8 c6 d1 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102fda:	89 34 24             	mov    %esi,(%esp)
80102fdd:	e8 fe d1 ff ff       	call   801001e0 <brelse>
}
80102fe2:	83 c4 10             	add    $0x10,%esp
80102fe5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102fe8:	5b                   	pop    %ebx
80102fe9:	5e                   	pop    %esi
80102fea:	5d                   	pop    %ebp
80102feb:	c3                   	ret    
80102fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ff0 <initlog>:
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	53                   	push   %ebx
80102ff4:	83 ec 2c             	sub    $0x2c,%esp
80102ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102ffa:	68 20 7f 10 80       	push   $0x80107f20
80102fff:	68 80 36 11 80       	push   $0x80113680
80103004:	e8 77 1a 00 00       	call   80104a80 <initlock>
  readsb(dev, &sb);
80103009:	58                   	pop    %eax
8010300a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010300d:	5a                   	pop    %edx
8010300e:	50                   	push   %eax
8010300f:	53                   	push   %ebx
80103010:	e8 3b e4 ff ff       	call   80101450 <readsb>
  log.size = sb.nlog;
80103015:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103018:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010301b:	59                   	pop    %ecx
  log.dev = dev;
8010301c:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4
  log.size = sb.nlog;
80103022:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  log.start = sb.logstart;
80103028:	a3 b4 36 11 80       	mov    %eax,0x801136b4
  struct buf *buf = bread(log.dev, log.start);
8010302d:	5a                   	pop    %edx
8010302e:	50                   	push   %eax
8010302f:	53                   	push   %ebx
80103030:	e8 9b d0 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80103035:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80103038:	83 c4 10             	add    $0x10,%esp
8010303b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
8010303d:	89 1d c8 36 11 80    	mov    %ebx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80103043:	7e 1c                	jle    80103061 <initlog+0x71>
80103045:	c1 e3 02             	shl    $0x2,%ebx
80103048:	31 d2                	xor    %edx,%edx
8010304a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80103050:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80103054:	83 c2 04             	add    $0x4,%edx
80103057:	89 8a c8 36 11 80    	mov    %ecx,-0x7feec938(%edx)
  for (i = 0; i < log.lh.n; i++) {
8010305d:	39 d3                	cmp    %edx,%ebx
8010305f:	75 ef                	jne    80103050 <initlog+0x60>
  brelse(buf);
80103061:	83 ec 0c             	sub    $0xc,%esp
80103064:	50                   	push   %eax
80103065:	e8 76 d1 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010306a:	e8 81 fe ff ff       	call   80102ef0 <install_trans>
  log.lh.n = 0;
8010306f:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80103076:	00 00 00 
  write_head(); // clear the log
80103079:	e8 12 ff ff ff       	call   80102f90 <write_head>
}
8010307e:	83 c4 10             	add    $0x10,%esp
80103081:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103084:	c9                   	leave  
80103085:	c3                   	ret    
80103086:	8d 76 00             	lea    0x0(%esi),%esi
80103089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103090 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103090:	55                   	push   %ebp
80103091:	89 e5                	mov    %esp,%ebp
80103093:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103096:	68 80 36 11 80       	push   $0x80113680
8010309b:	e8 d0 1a 00 00       	call   80104b70 <acquire>
801030a0:	83 c4 10             	add    $0x10,%esp
801030a3:	eb 18                	jmp    801030bd <begin_op+0x2d>
801030a5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801030a8:	83 ec 08             	sub    $0x8,%esp
801030ab:	68 80 36 11 80       	push   $0x80113680
801030b0:	68 80 36 11 80       	push   $0x80113680
801030b5:	e8 56 12 00 00       	call   80104310 <sleep>
801030ba:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801030bd:	a1 c0 36 11 80       	mov    0x801136c0,%eax
801030c2:	85 c0                	test   %eax,%eax
801030c4:	75 e2                	jne    801030a8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801030c6:	a1 bc 36 11 80       	mov    0x801136bc,%eax
801030cb:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
801030d1:	83 c0 01             	add    $0x1,%eax
801030d4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801030d7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801030da:	83 fa 1e             	cmp    $0x1e,%edx
801030dd:	7f c9                	jg     801030a8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801030df:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801030e2:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
801030e7:	68 80 36 11 80       	push   $0x80113680
801030ec:	e8 9f 1b 00 00       	call   80104c90 <release>
      break;
    }
  }
}
801030f1:	83 c4 10             	add    $0x10,%esp
801030f4:	c9                   	leave  
801030f5:	c3                   	ret    
801030f6:	8d 76 00             	lea    0x0(%esi),%esi
801030f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103100 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103100:	55                   	push   %ebp
80103101:	89 e5                	mov    %esp,%ebp
80103103:	57                   	push   %edi
80103104:	56                   	push   %esi
80103105:	53                   	push   %ebx
80103106:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103109:	68 80 36 11 80       	push   $0x80113680
8010310e:	e8 5d 1a 00 00       	call   80104b70 <acquire>
  log.outstanding -= 1;
80103113:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80103118:	8b 35 c0 36 11 80    	mov    0x801136c0,%esi
8010311e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103121:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80103124:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80103126:	89 1d bc 36 11 80    	mov    %ebx,0x801136bc
  if(log.committing)
8010312c:	0f 85 1a 01 00 00    	jne    8010324c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80103132:	85 db                	test   %ebx,%ebx
80103134:	0f 85 ee 00 00 00    	jne    80103228 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010313a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
8010313d:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80103144:	00 00 00 
  release(&log.lock);
80103147:	68 80 36 11 80       	push   $0x80113680
8010314c:	e8 3f 1b 00 00       	call   80104c90 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103151:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80103157:	83 c4 10             	add    $0x10,%esp
8010315a:	85 c9                	test   %ecx,%ecx
8010315c:	0f 8e 85 00 00 00    	jle    801031e7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103162:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80103167:	83 ec 08             	sub    $0x8,%esp
8010316a:	01 d8                	add    %ebx,%eax
8010316c:	83 c0 01             	add    $0x1,%eax
8010316f:	50                   	push   %eax
80103170:	ff 35 c4 36 11 80    	pushl  0x801136c4
80103176:	e8 55 cf ff ff       	call   801000d0 <bread>
8010317b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010317d:	58                   	pop    %eax
8010317e:	5a                   	pop    %edx
8010317f:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80103186:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
8010318c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010318f:	e8 3c cf ff ff       	call   801000d0 <bread>
80103194:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103196:	8d 40 5c             	lea    0x5c(%eax),%eax
80103199:	83 c4 0c             	add    $0xc,%esp
8010319c:	68 00 02 00 00       	push   $0x200
801031a1:	50                   	push   %eax
801031a2:	8d 46 5c             	lea    0x5c(%esi),%eax
801031a5:	50                   	push   %eax
801031a6:	e8 f5 1b 00 00       	call   80104da0 <memmove>
    bwrite(to);  // write the log
801031ab:	89 34 24             	mov    %esi,(%esp)
801031ae:	e8 ed cf ff ff       	call   801001a0 <bwrite>
    brelse(from);
801031b3:	89 3c 24             	mov    %edi,(%esp)
801031b6:	e8 25 d0 ff ff       	call   801001e0 <brelse>
    brelse(to);
801031bb:	89 34 24             	mov    %esi,(%esp)
801031be:	e8 1d d0 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801031c3:	83 c4 10             	add    $0x10,%esp
801031c6:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
801031cc:	7c 94                	jl     80103162 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801031ce:	e8 bd fd ff ff       	call   80102f90 <write_head>
    install_trans(); // Now install writes to home locations
801031d3:	e8 18 fd ff ff       	call   80102ef0 <install_trans>
    log.lh.n = 0;
801031d8:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
801031df:	00 00 00 
    write_head();    // Erase the transaction from the log
801031e2:	e8 a9 fd ff ff       	call   80102f90 <write_head>
    acquire(&log.lock);
801031e7:	83 ec 0c             	sub    $0xc,%esp
801031ea:	68 80 36 11 80       	push   $0x80113680
801031ef:	e8 7c 19 00 00       	call   80104b70 <acquire>
    wakeup(&log);
801031f4:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
801031fb:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80103202:	00 00 00 
    wakeup(&log);
80103205:	e8 c6 12 00 00       	call   801044d0 <wakeup>
    release(&log.lock);
8010320a:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80103211:	e8 7a 1a 00 00       	call   80104c90 <release>
80103216:	83 c4 10             	add    $0x10,%esp
}
80103219:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010321c:	5b                   	pop    %ebx
8010321d:	5e                   	pop    %esi
8010321e:	5f                   	pop    %edi
8010321f:	5d                   	pop    %ebp
80103220:	c3                   	ret    
80103221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103228:	83 ec 0c             	sub    $0xc,%esp
8010322b:	68 80 36 11 80       	push   $0x80113680
80103230:	e8 9b 12 00 00       	call   801044d0 <wakeup>
  release(&log.lock);
80103235:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
8010323c:	e8 4f 1a 00 00       	call   80104c90 <release>
80103241:	83 c4 10             	add    $0x10,%esp
}
80103244:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103247:	5b                   	pop    %ebx
80103248:	5e                   	pop    %esi
80103249:	5f                   	pop    %edi
8010324a:	5d                   	pop    %ebp
8010324b:	c3                   	ret    
    panic("log.committing");
8010324c:	83 ec 0c             	sub    $0xc,%esp
8010324f:	68 24 7f 10 80       	push   $0x80107f24
80103254:	e8 37 d1 ff ff       	call   80100390 <panic>
80103259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103260 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103260:	55                   	push   %ebp
80103261:	89 e5                	mov    %esp,%ebp
80103263:	53                   	push   %ebx
80103264:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103267:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
{
8010326d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103270:	83 fa 1d             	cmp    $0x1d,%edx
80103273:	0f 8f 9d 00 00 00    	jg     80103316 <log_write+0xb6>
80103279:	a1 b8 36 11 80       	mov    0x801136b8,%eax
8010327e:	83 e8 01             	sub    $0x1,%eax
80103281:	39 c2                	cmp    %eax,%edx
80103283:	0f 8d 8d 00 00 00    	jge    80103316 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103289:	a1 bc 36 11 80       	mov    0x801136bc,%eax
8010328e:	85 c0                	test   %eax,%eax
80103290:	0f 8e 8d 00 00 00    	jle    80103323 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103296:	83 ec 0c             	sub    $0xc,%esp
80103299:	68 80 36 11 80       	push   $0x80113680
8010329e:	e8 cd 18 00 00       	call   80104b70 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801032a3:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
801032a9:	83 c4 10             	add    $0x10,%esp
801032ac:	83 f9 00             	cmp    $0x0,%ecx
801032af:	7e 57                	jle    80103308 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801032b1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
801032b4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801032b6:	3b 15 cc 36 11 80    	cmp    0x801136cc,%edx
801032bc:	75 0b                	jne    801032c9 <log_write+0x69>
801032be:	eb 38                	jmp    801032f8 <log_write+0x98>
801032c0:	39 14 85 cc 36 11 80 	cmp    %edx,-0x7feec934(,%eax,4)
801032c7:	74 2f                	je     801032f8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
801032c9:	83 c0 01             	add    $0x1,%eax
801032cc:	39 c1                	cmp    %eax,%ecx
801032ce:	75 f0                	jne    801032c0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801032d0:	89 14 85 cc 36 11 80 	mov    %edx,-0x7feec934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
801032d7:	83 c0 01             	add    $0x1,%eax
801032da:	a3 c8 36 11 80       	mov    %eax,0x801136c8
  b->flags |= B_DIRTY; // prevent eviction
801032df:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
801032e2:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
801032e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801032ec:	c9                   	leave  
  release(&log.lock);
801032ed:	e9 9e 19 00 00       	jmp    80104c90 <release>
801032f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801032f8:	89 14 85 cc 36 11 80 	mov    %edx,-0x7feec934(,%eax,4)
801032ff:	eb de                	jmp    801032df <log_write+0x7f>
80103301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103308:	8b 43 08             	mov    0x8(%ebx),%eax
8010330b:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80103310:	75 cd                	jne    801032df <log_write+0x7f>
80103312:	31 c0                	xor    %eax,%eax
80103314:	eb c1                	jmp    801032d7 <log_write+0x77>
    panic("too big a transaction");
80103316:	83 ec 0c             	sub    $0xc,%esp
80103319:	68 33 7f 10 80       	push   $0x80107f33
8010331e:	e8 6d d0 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103323:	83 ec 0c             	sub    $0xc,%esp
80103326:	68 49 7f 10 80       	push   $0x80107f49
8010332b:	e8 60 d0 ff ff       	call   80100390 <panic>

80103330 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103330:	55                   	push   %ebp
80103331:	89 e5                	mov    %esp,%ebp
80103333:	53                   	push   %ebx
80103334:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103337:	e8 e4 09 00 00       	call   80103d20 <cpuid>
8010333c:	89 c3                	mov    %eax,%ebx
8010333e:	e8 dd 09 00 00       	call   80103d20 <cpuid>
80103343:	83 ec 04             	sub    $0x4,%esp
80103346:	53                   	push   %ebx
80103347:	50                   	push   %eax
80103348:	68 64 7f 10 80       	push   $0x80107f64
8010334d:	e8 0e d3 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103352:	e8 a9 2c 00 00       	call   80106000 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103357:	e8 44 09 00 00       	call   80103ca0 <mycpu>
8010335c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010335e:	b8 01 00 00 00       	mov    $0x1,%eax
80103363:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010336a:	e8 b1 0c 00 00       	call   80104020 <scheduler>
8010336f:	90                   	nop

80103370 <mpenter>:
{
80103370:	55                   	push   %ebp
80103371:	89 e5                	mov    %esp,%ebp
80103373:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103376:	e8 65 3d 00 00       	call   801070e0 <switchkvm>
  seginit();
8010337b:	e8 d0 3c 00 00       	call   80107050 <seginit>
  lapicinit();
80103380:	e8 9b f7 ff ff       	call   80102b20 <lapicinit>
  mpmain();
80103385:	e8 a6 ff ff ff       	call   80103330 <mpmain>
8010338a:	66 90                	xchg   %ax,%ax
8010338c:	66 90                	xchg   %ax,%ax
8010338e:	66 90                	xchg   %ax,%ax

80103390 <main>:
{
80103390:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103394:	83 e4 f0             	and    $0xfffffff0,%esp
80103397:	ff 71 fc             	pushl  -0x4(%ecx)
8010339a:	55                   	push   %ebp
8010339b:	89 e5                	mov    %esp,%ebp
8010339d:	53                   	push   %ebx
8010339e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010339f:	83 ec 08             	sub    $0x8,%esp
801033a2:	68 00 00 40 80       	push   $0x80400000
801033a7:	68 c8 28 12 80       	push   $0x801228c8
801033ac:	e8 2f f5 ff ff       	call   801028e0 <kinit1>
  kvmalloc();      // kernel page table
801033b1:	e8 ca 42 00 00       	call   80107680 <kvmalloc>
  mpinit();        // detect other processors
801033b6:	e8 75 01 00 00       	call   80103530 <mpinit>
  lapicinit();     // interrupt controller
801033bb:	e8 60 f7 ff ff       	call   80102b20 <lapicinit>
  seginit();       // segment descriptors
801033c0:	e8 8b 3c 00 00       	call   80107050 <seginit>
  picinit();       // disable pic
801033c5:	e8 46 03 00 00       	call   80103710 <picinit>
  ioapicinit();    // another interrupt controller
801033ca:	e8 41 f3 ff ff       	call   80102710 <ioapicinit>
  consoleinit();   // console hardware
801033cf:	e8 ec d5 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
801033d4:	e8 47 2f 00 00       	call   80106320 <uartinit>
  pinit();         // process table
801033d9:	e8 a2 08 00 00       	call   80103c80 <pinit>
  tvinit();        // trap vectors
801033de:	e8 9d 2b 00 00       	call   80105f80 <tvinit>
  binit();         // buffer cache
801033e3:	e8 58 cc ff ff       	call   80100040 <binit>
  fileinit();      // file table
801033e8:	e8 f3 d9 ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
801033ed:	e8 fe f0 ff ff       	call   801024f0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801033f2:	83 c4 0c             	add    $0xc,%esp
801033f5:	68 8a 00 00 00       	push   $0x8a
801033fa:	68 8c b4 10 80       	push   $0x8010b48c
801033ff:	68 00 70 00 80       	push   $0x80007000
80103404:	e8 97 19 00 00       	call   80104da0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103409:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103410:	00 00 00 
80103413:	83 c4 10             	add    $0x10,%esp
80103416:	05 80 37 11 80       	add    $0x80113780,%eax
8010341b:	3d 80 37 11 80       	cmp    $0x80113780,%eax
80103420:	76 71                	jbe    80103493 <main+0x103>
80103422:	bb 80 37 11 80       	mov    $0x80113780,%ebx
80103427:	89 f6                	mov    %esi,%esi
80103429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103430:	e8 6b 08 00 00       	call   80103ca0 <mycpu>
80103435:	39 d8                	cmp    %ebx,%eax
80103437:	74 41                	je     8010347a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103439:	e8 72 f5 ff ff       	call   801029b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010343e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80103443:	c7 05 f8 6f 00 80 70 	movl   $0x80103370,0x80006ff8
8010344a:	33 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010344d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103454:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103457:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010345c:	0f b6 03             	movzbl (%ebx),%eax
8010345f:	83 ec 08             	sub    $0x8,%esp
80103462:	68 00 70 00 00       	push   $0x7000
80103467:	50                   	push   %eax
80103468:	e8 03 f8 ff ff       	call   80102c70 <lapicstartap>
8010346d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103470:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103476:	85 c0                	test   %eax,%eax
80103478:	74 f6                	je     80103470 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010347a:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103481:	00 00 00 
80103484:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010348a:	05 80 37 11 80       	add    $0x80113780,%eax
8010348f:	39 c3                	cmp    %eax,%ebx
80103491:	72 9d                	jb     80103430 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103493:	83 ec 08             	sub    $0x8,%esp
80103496:	68 00 00 00 8e       	push   $0x8e000000
8010349b:	68 00 00 40 80       	push   $0x80400000
801034a0:	e8 ab f4 ff ff       	call   80102950 <kinit2>
  userinit();      // first user process
801034a5:	e8 c6 08 00 00       	call   80103d70 <userinit>
  mpmain();        // finish this processor's setup
801034aa:	e8 81 fe ff ff       	call   80103330 <mpmain>
801034af:	90                   	nop

801034b0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801034b0:	55                   	push   %ebp
801034b1:	89 e5                	mov    %esp,%ebp
801034b3:	57                   	push   %edi
801034b4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801034b5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801034bb:	53                   	push   %ebx
  e = addr+len;
801034bc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801034bf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801034c2:	39 de                	cmp    %ebx,%esi
801034c4:	72 10                	jb     801034d6 <mpsearch1+0x26>
801034c6:	eb 50                	jmp    80103518 <mpsearch1+0x68>
801034c8:	90                   	nop
801034c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034d0:	39 fb                	cmp    %edi,%ebx
801034d2:	89 fe                	mov    %edi,%esi
801034d4:	76 42                	jbe    80103518 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034d6:	83 ec 04             	sub    $0x4,%esp
801034d9:	8d 7e 10             	lea    0x10(%esi),%edi
801034dc:	6a 04                	push   $0x4
801034de:	68 78 7f 10 80       	push   $0x80107f78
801034e3:	56                   	push   %esi
801034e4:	e8 57 18 00 00       	call   80104d40 <memcmp>
801034e9:	83 c4 10             	add    $0x10,%esp
801034ec:	85 c0                	test   %eax,%eax
801034ee:	75 e0                	jne    801034d0 <mpsearch1+0x20>
801034f0:	89 f1                	mov    %esi,%ecx
801034f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801034f8:	0f b6 11             	movzbl (%ecx),%edx
801034fb:	83 c1 01             	add    $0x1,%ecx
801034fe:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103500:	39 f9                	cmp    %edi,%ecx
80103502:	75 f4                	jne    801034f8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103504:	84 c0                	test   %al,%al
80103506:	75 c8                	jne    801034d0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010350b:	89 f0                	mov    %esi,%eax
8010350d:	5b                   	pop    %ebx
8010350e:	5e                   	pop    %esi
8010350f:	5f                   	pop    %edi
80103510:	5d                   	pop    %ebp
80103511:	c3                   	ret    
80103512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103518:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010351b:	31 f6                	xor    %esi,%esi
}
8010351d:	89 f0                	mov    %esi,%eax
8010351f:	5b                   	pop    %ebx
80103520:	5e                   	pop    %esi
80103521:	5f                   	pop    %edi
80103522:	5d                   	pop    %ebp
80103523:	c3                   	ret    
80103524:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010352a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103530 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	57                   	push   %edi
80103534:	56                   	push   %esi
80103535:	53                   	push   %ebx
80103536:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103539:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103540:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103547:	c1 e0 08             	shl    $0x8,%eax
8010354a:	09 d0                	or     %edx,%eax
8010354c:	c1 e0 04             	shl    $0x4,%eax
8010354f:	85 c0                	test   %eax,%eax
80103551:	75 1b                	jne    8010356e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103553:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010355a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103561:	c1 e0 08             	shl    $0x8,%eax
80103564:	09 d0                	or     %edx,%eax
80103566:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103569:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010356e:	ba 00 04 00 00       	mov    $0x400,%edx
80103573:	e8 38 ff ff ff       	call   801034b0 <mpsearch1>
80103578:	85 c0                	test   %eax,%eax
8010357a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010357d:	0f 84 3d 01 00 00    	je     801036c0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103586:	8b 58 04             	mov    0x4(%eax),%ebx
80103589:	85 db                	test   %ebx,%ebx
8010358b:	0f 84 4f 01 00 00    	je     801036e0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103591:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103597:	83 ec 04             	sub    $0x4,%esp
8010359a:	6a 04                	push   $0x4
8010359c:	68 95 7f 10 80       	push   $0x80107f95
801035a1:	56                   	push   %esi
801035a2:	e8 99 17 00 00       	call   80104d40 <memcmp>
801035a7:	83 c4 10             	add    $0x10,%esp
801035aa:	85 c0                	test   %eax,%eax
801035ac:	0f 85 2e 01 00 00    	jne    801036e0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801035b2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801035b9:	3c 01                	cmp    $0x1,%al
801035bb:	0f 95 c2             	setne  %dl
801035be:	3c 04                	cmp    $0x4,%al
801035c0:	0f 95 c0             	setne  %al
801035c3:	20 c2                	and    %al,%dl
801035c5:	0f 85 15 01 00 00    	jne    801036e0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801035cb:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801035d2:	66 85 ff             	test   %di,%di
801035d5:	74 1a                	je     801035f1 <mpinit+0xc1>
801035d7:	89 f0                	mov    %esi,%eax
801035d9:	01 f7                	add    %esi,%edi
  sum = 0;
801035db:	31 d2                	xor    %edx,%edx
801035dd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801035e0:	0f b6 08             	movzbl (%eax),%ecx
801035e3:	83 c0 01             	add    $0x1,%eax
801035e6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801035e8:	39 c7                	cmp    %eax,%edi
801035ea:	75 f4                	jne    801035e0 <mpinit+0xb0>
801035ec:	84 d2                	test   %dl,%dl
801035ee:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801035f1:	85 f6                	test   %esi,%esi
801035f3:	0f 84 e7 00 00 00    	je     801036e0 <mpinit+0x1b0>
801035f9:	84 d2                	test   %dl,%dl
801035fb:	0f 85 df 00 00 00    	jne    801036e0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103601:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103607:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010360c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103613:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103619:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010361e:	01 d6                	add    %edx,%esi
80103620:	39 c6                	cmp    %eax,%esi
80103622:	76 23                	jbe    80103647 <mpinit+0x117>
    switch(*p){
80103624:	0f b6 10             	movzbl (%eax),%edx
80103627:	80 fa 04             	cmp    $0x4,%dl
8010362a:	0f 87 ca 00 00 00    	ja     801036fa <mpinit+0x1ca>
80103630:	ff 24 95 bc 7f 10 80 	jmp    *-0x7fef8044(,%edx,4)
80103637:	89 f6                	mov    %esi,%esi
80103639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103640:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103643:	39 c6                	cmp    %eax,%esi
80103645:	77 dd                	ja     80103624 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103647:	85 db                	test   %ebx,%ebx
80103649:	0f 84 9e 00 00 00    	je     801036ed <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010364f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103652:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103656:	74 15                	je     8010366d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103658:	b8 70 00 00 00       	mov    $0x70,%eax
8010365d:	ba 22 00 00 00       	mov    $0x22,%edx
80103662:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103663:	ba 23 00 00 00       	mov    $0x23,%edx
80103668:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103669:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010366c:	ee                   	out    %al,(%dx)
  }
}
8010366d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103670:	5b                   	pop    %ebx
80103671:	5e                   	pop    %esi
80103672:	5f                   	pop    %edi
80103673:	5d                   	pop    %ebp
80103674:	c3                   	ret    
80103675:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103678:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
8010367e:	83 f9 07             	cmp    $0x7,%ecx
80103681:	7f 19                	jg     8010369c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103683:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103687:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010368d:	83 c1 01             	add    $0x1,%ecx
80103690:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103696:	88 97 80 37 11 80    	mov    %dl,-0x7feec880(%edi)
      p += sizeof(struct mpproc);
8010369c:	83 c0 14             	add    $0x14,%eax
      continue;
8010369f:	e9 7c ff ff ff       	jmp    80103620 <mpinit+0xf0>
801036a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801036a8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801036ac:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801036af:	88 15 60 37 11 80    	mov    %dl,0x80113760
      continue;
801036b5:	e9 66 ff ff ff       	jmp    80103620 <mpinit+0xf0>
801036ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801036c0:	ba 00 00 01 00       	mov    $0x10000,%edx
801036c5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801036ca:	e8 e1 fd ff ff       	call   801034b0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801036cf:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801036d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801036d4:	0f 85 a9 fe ff ff    	jne    80103583 <mpinit+0x53>
801036da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801036e0:	83 ec 0c             	sub    $0xc,%esp
801036e3:	68 7d 7f 10 80       	push   $0x80107f7d
801036e8:	e8 a3 cc ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801036ed:	83 ec 0c             	sub    $0xc,%esp
801036f0:	68 9c 7f 10 80       	push   $0x80107f9c
801036f5:	e8 96 cc ff ff       	call   80100390 <panic>
      ismp = 0;
801036fa:	31 db                	xor    %ebx,%ebx
801036fc:	e9 26 ff ff ff       	jmp    80103627 <mpinit+0xf7>
80103701:	66 90                	xchg   %ax,%ax
80103703:	66 90                	xchg   %ax,%ax
80103705:	66 90                	xchg   %ax,%ax
80103707:	66 90                	xchg   %ax,%ax
80103709:	66 90                	xchg   %ax,%ax
8010370b:	66 90                	xchg   %ax,%ax
8010370d:	66 90                	xchg   %ax,%ax
8010370f:	90                   	nop

80103710 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103710:	55                   	push   %ebp
80103711:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103716:	ba 21 00 00 00       	mov    $0x21,%edx
8010371b:	89 e5                	mov    %esp,%ebp
8010371d:	ee                   	out    %al,(%dx)
8010371e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103723:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103724:	5d                   	pop    %ebp
80103725:	c3                   	ret    
80103726:	66 90                	xchg   %ax,%ax
80103728:	66 90                	xchg   %ax,%ax
8010372a:	66 90                	xchg   %ax,%ax
8010372c:	66 90                	xchg   %ax,%ax
8010372e:	66 90                	xchg   %ax,%ax

80103730 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	57                   	push   %edi
80103734:	56                   	push   %esi
80103735:	53                   	push   %ebx
80103736:	83 ec 0c             	sub    $0xc,%esp
80103739:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010373c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010373f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103745:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010374b:	e8 b0 d6 ff ff       	call   80100e00 <filealloc>
80103750:	85 c0                	test   %eax,%eax
80103752:	89 03                	mov    %eax,(%ebx)
80103754:	74 22                	je     80103778 <pipealloc+0x48>
80103756:	e8 a5 d6 ff ff       	call   80100e00 <filealloc>
8010375b:	85 c0                	test   %eax,%eax
8010375d:	89 06                	mov    %eax,(%esi)
8010375f:	74 3f                	je     801037a0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103761:	e8 4a f2 ff ff       	call   801029b0 <kalloc>
80103766:	85 c0                	test   %eax,%eax
80103768:	89 c7                	mov    %eax,%edi
8010376a:	75 54                	jne    801037c0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010376c:	8b 03                	mov    (%ebx),%eax
8010376e:	85 c0                	test   %eax,%eax
80103770:	75 34                	jne    801037a6 <pipealloc+0x76>
80103772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103778:	8b 06                	mov    (%esi),%eax
8010377a:	85 c0                	test   %eax,%eax
8010377c:	74 0c                	je     8010378a <pipealloc+0x5a>
    fileclose(*f1);
8010377e:	83 ec 0c             	sub    $0xc,%esp
80103781:	50                   	push   %eax
80103782:	e8 39 d7 ff ff       	call   80100ec0 <fileclose>
80103787:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010378a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010378d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103792:	5b                   	pop    %ebx
80103793:	5e                   	pop    %esi
80103794:	5f                   	pop    %edi
80103795:	5d                   	pop    %ebp
80103796:	c3                   	ret    
80103797:	89 f6                	mov    %esi,%esi
80103799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801037a0:	8b 03                	mov    (%ebx),%eax
801037a2:	85 c0                	test   %eax,%eax
801037a4:	74 e4                	je     8010378a <pipealloc+0x5a>
    fileclose(*f0);
801037a6:	83 ec 0c             	sub    $0xc,%esp
801037a9:	50                   	push   %eax
801037aa:	e8 11 d7 ff ff       	call   80100ec0 <fileclose>
  if(*f1)
801037af:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801037b1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801037b4:	85 c0                	test   %eax,%eax
801037b6:	75 c6                	jne    8010377e <pipealloc+0x4e>
801037b8:	eb d0                	jmp    8010378a <pipealloc+0x5a>
801037ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801037c0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801037c3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801037ca:	00 00 00 
  p->writeopen = 1;
801037cd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801037d4:	00 00 00 
  p->nwrite = 0;
801037d7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801037de:	00 00 00 
  p->nread = 0;
801037e1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801037e8:	00 00 00 
  initlock(&p->lock, "pipe");
801037eb:	68 d0 7f 10 80       	push   $0x80107fd0
801037f0:	50                   	push   %eax
801037f1:	e8 8a 12 00 00       	call   80104a80 <initlock>
  (*f0)->type = FD_PIPE;
801037f6:	8b 03                	mov    (%ebx),%eax
  return 0;
801037f8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801037fb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103801:	8b 03                	mov    (%ebx),%eax
80103803:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103807:	8b 03                	mov    (%ebx),%eax
80103809:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010380d:	8b 03                	mov    (%ebx),%eax
8010380f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103812:	8b 06                	mov    (%esi),%eax
80103814:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010381a:	8b 06                	mov    (%esi),%eax
8010381c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103820:	8b 06                	mov    (%esi),%eax
80103822:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103826:	8b 06                	mov    (%esi),%eax
80103828:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010382b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010382e:	31 c0                	xor    %eax,%eax
}
80103830:	5b                   	pop    %ebx
80103831:	5e                   	pop    %esi
80103832:	5f                   	pop    %edi
80103833:	5d                   	pop    %ebp
80103834:	c3                   	ret    
80103835:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103840 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	56                   	push   %esi
80103844:	53                   	push   %ebx
80103845:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103848:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010384b:	83 ec 0c             	sub    $0xc,%esp
8010384e:	53                   	push   %ebx
8010384f:	e8 1c 13 00 00       	call   80104b70 <acquire>
  if(writable){
80103854:	83 c4 10             	add    $0x10,%esp
80103857:	85 f6                	test   %esi,%esi
80103859:	74 45                	je     801038a0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010385b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103861:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103864:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010386b:	00 00 00 
    wakeup(&p->nread);
8010386e:	50                   	push   %eax
8010386f:	e8 5c 0c 00 00       	call   801044d0 <wakeup>
80103874:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103877:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010387d:	85 d2                	test   %edx,%edx
8010387f:	75 0a                	jne    8010388b <pipeclose+0x4b>
80103881:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103887:	85 c0                	test   %eax,%eax
80103889:	74 35                	je     801038c0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010388b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010388e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103891:	5b                   	pop    %ebx
80103892:	5e                   	pop    %esi
80103893:	5d                   	pop    %ebp
    release(&p->lock);
80103894:	e9 f7 13 00 00       	jmp    80104c90 <release>
80103899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801038a0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801038a6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801038a9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801038b0:	00 00 00 
    wakeup(&p->nwrite);
801038b3:	50                   	push   %eax
801038b4:	e8 17 0c 00 00       	call   801044d0 <wakeup>
801038b9:	83 c4 10             	add    $0x10,%esp
801038bc:	eb b9                	jmp    80103877 <pipeclose+0x37>
801038be:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801038c0:	83 ec 0c             	sub    $0xc,%esp
801038c3:	53                   	push   %ebx
801038c4:	e8 c7 13 00 00       	call   80104c90 <release>
    kfree((char*)p);
801038c9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801038cc:	83 c4 10             	add    $0x10,%esp
}
801038cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038d2:	5b                   	pop    %ebx
801038d3:	5e                   	pop    %esi
801038d4:	5d                   	pop    %ebp
    kfree((char*)p);
801038d5:	e9 26 ef ff ff       	jmp    80102800 <kfree>
801038da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801038e0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	57                   	push   %edi
801038e4:	56                   	push   %esi
801038e5:	53                   	push   %ebx
801038e6:	83 ec 28             	sub    $0x28,%esp
801038e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801038ec:	53                   	push   %ebx
801038ed:	e8 7e 12 00 00       	call   80104b70 <acquire>
  for(i = 0; i < n; i++){
801038f2:	8b 45 10             	mov    0x10(%ebp),%eax
801038f5:	83 c4 10             	add    $0x10,%esp
801038f8:	85 c0                	test   %eax,%eax
801038fa:	0f 8e c9 00 00 00    	jle    801039c9 <pipewrite+0xe9>
80103900:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103903:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103909:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010390f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103912:	03 4d 10             	add    0x10(%ebp),%ecx
80103915:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103918:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010391e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103924:	39 d0                	cmp    %edx,%eax
80103926:	75 71                	jne    80103999 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103928:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010392e:	85 c0                	test   %eax,%eax
80103930:	74 4e                	je     80103980 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103932:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103938:	eb 3a                	jmp    80103974 <pipewrite+0x94>
8010393a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103940:	83 ec 0c             	sub    $0xc,%esp
80103943:	57                   	push   %edi
80103944:	e8 87 0b 00 00       	call   801044d0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103949:	5a                   	pop    %edx
8010394a:	59                   	pop    %ecx
8010394b:	53                   	push   %ebx
8010394c:	56                   	push   %esi
8010394d:	e8 be 09 00 00       	call   80104310 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103952:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103958:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010395e:	83 c4 10             	add    $0x10,%esp
80103961:	05 00 02 00 00       	add    $0x200,%eax
80103966:	39 c2                	cmp    %eax,%edx
80103968:	75 36                	jne    801039a0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010396a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103970:	85 c0                	test   %eax,%eax
80103972:	74 0c                	je     80103980 <pipewrite+0xa0>
80103974:	e8 c7 03 00 00       	call   80103d40 <myproc>
80103979:	8b 40 24             	mov    0x24(%eax),%eax
8010397c:	85 c0                	test   %eax,%eax
8010397e:	74 c0                	je     80103940 <pipewrite+0x60>
        release(&p->lock);
80103980:	83 ec 0c             	sub    $0xc,%esp
80103983:	53                   	push   %ebx
80103984:	e8 07 13 00 00       	call   80104c90 <release>
        return -1;
80103989:	83 c4 10             	add    $0x10,%esp
8010398c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103991:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103994:	5b                   	pop    %ebx
80103995:	5e                   	pop    %esi
80103996:	5f                   	pop    %edi
80103997:	5d                   	pop    %ebp
80103998:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103999:	89 c2                	mov    %eax,%edx
8010399b:	90                   	nop
8010399c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801039a0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801039a3:	8d 42 01             	lea    0x1(%edx),%eax
801039a6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801039ac:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801039b2:	83 c6 01             	add    $0x1,%esi
801039b5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801039b9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801039bc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801039bf:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801039c3:	0f 85 4f ff ff ff    	jne    80103918 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801039c9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801039cf:	83 ec 0c             	sub    $0xc,%esp
801039d2:	50                   	push   %eax
801039d3:	e8 f8 0a 00 00       	call   801044d0 <wakeup>
  release(&p->lock);
801039d8:	89 1c 24             	mov    %ebx,(%esp)
801039db:	e8 b0 12 00 00       	call   80104c90 <release>
  return n;
801039e0:	83 c4 10             	add    $0x10,%esp
801039e3:	8b 45 10             	mov    0x10(%ebp),%eax
801039e6:	eb a9                	jmp    80103991 <pipewrite+0xb1>
801039e8:	90                   	nop
801039e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039f0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	57                   	push   %edi
801039f4:	56                   	push   %esi
801039f5:	53                   	push   %ebx
801039f6:	83 ec 18             	sub    $0x18,%esp
801039f9:	8b 75 08             	mov    0x8(%ebp),%esi
801039fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801039ff:	56                   	push   %esi
80103a00:	e8 6b 11 00 00       	call   80104b70 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a05:	83 c4 10             	add    $0x10,%esp
80103a08:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103a0e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103a14:	75 6a                	jne    80103a80 <piperead+0x90>
80103a16:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
80103a1c:	85 db                	test   %ebx,%ebx
80103a1e:	0f 84 c4 00 00 00    	je     80103ae8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103a24:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103a2a:	eb 2d                	jmp    80103a59 <piperead+0x69>
80103a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a30:	83 ec 08             	sub    $0x8,%esp
80103a33:	56                   	push   %esi
80103a34:	53                   	push   %ebx
80103a35:	e8 d6 08 00 00       	call   80104310 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a3a:	83 c4 10             	add    $0x10,%esp
80103a3d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103a43:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103a49:	75 35                	jne    80103a80 <piperead+0x90>
80103a4b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103a51:	85 d2                	test   %edx,%edx
80103a53:	0f 84 8f 00 00 00    	je     80103ae8 <piperead+0xf8>
    if(myproc()->killed){
80103a59:	e8 e2 02 00 00       	call   80103d40 <myproc>
80103a5e:	8b 48 24             	mov    0x24(%eax),%ecx
80103a61:	85 c9                	test   %ecx,%ecx
80103a63:	74 cb                	je     80103a30 <piperead+0x40>
      release(&p->lock);
80103a65:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103a68:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103a6d:	56                   	push   %esi
80103a6e:	e8 1d 12 00 00       	call   80104c90 <release>
      return -1;
80103a73:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103a76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a79:	89 d8                	mov    %ebx,%eax
80103a7b:	5b                   	pop    %ebx
80103a7c:	5e                   	pop    %esi
80103a7d:	5f                   	pop    %edi
80103a7e:	5d                   	pop    %ebp
80103a7f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a80:	8b 45 10             	mov    0x10(%ebp),%eax
80103a83:	85 c0                	test   %eax,%eax
80103a85:	7e 61                	jle    80103ae8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103a87:	31 db                	xor    %ebx,%ebx
80103a89:	eb 13                	jmp    80103a9e <piperead+0xae>
80103a8b:	90                   	nop
80103a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a90:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103a96:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103a9c:	74 1f                	je     80103abd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103a9e:	8d 41 01             	lea    0x1(%ecx),%eax
80103aa1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103aa7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103aad:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103ab2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103ab5:	83 c3 01             	add    $0x1,%ebx
80103ab8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103abb:	75 d3                	jne    80103a90 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103abd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103ac3:	83 ec 0c             	sub    $0xc,%esp
80103ac6:	50                   	push   %eax
80103ac7:	e8 04 0a 00 00       	call   801044d0 <wakeup>
  release(&p->lock);
80103acc:	89 34 24             	mov    %esi,(%esp)
80103acf:	e8 bc 11 00 00       	call   80104c90 <release>
  return i;
80103ad4:	83 c4 10             	add    $0x10,%esp
}
80103ad7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ada:	89 d8                	mov    %ebx,%eax
80103adc:	5b                   	pop    %ebx
80103add:	5e                   	pop    %esi
80103ade:	5f                   	pop    %edi
80103adf:	5d                   	pop    %ebp
80103ae0:	c3                   	ret    
80103ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ae8:	31 db                	xor    %ebx,%ebx
80103aea:	eb d1                	jmp    80103abd <piperead+0xcd>
80103aec:	66 90                	xchg   %ax,%ax
80103aee:	66 90                	xchg   %ax,%ax

80103af0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103af4:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
{
80103af9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103afc:	68 40 3d 11 80       	push   $0x80113d40
80103b01:	e8 6a 10 00 00       	call   80104b70 <acquire>
80103b06:	83 c4 10             	add    $0x10,%esp
80103b09:	eb 17                	jmp    80103b22 <allocproc+0x32>
80103b0b:	90                   	nop
80103b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b10:	81 c3 8c 03 00 00    	add    $0x38c,%ebx
80103b16:	81 fb 74 20 12 80    	cmp    $0x80122074,%ebx
80103b1c:	0f 83 e6 00 00 00    	jae    80103c08 <allocproc+0x118>
    if(p->state == UNUSED)
80103b22:	8b 43 0c             	mov    0xc(%ebx),%eax
80103b25:	85 c0                	test   %eax,%eax
80103b27:	75 e7                	jne    80103b10 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103b29:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103b2e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103b31:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103b38:	8d 50 01             	lea    0x1(%eax),%edx
80103b3b:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103b3e:	68 40 3d 11 80       	push   $0x80113d40
  p->pid = nextpid++;
80103b43:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103b49:	e8 42 11 00 00       	call   80104c90 <release>

  p->numOfPhysPages = 0;
80103b4e:	c7 83 80 03 00 00 00 	movl   $0x0,0x380(%ebx)
80103b55:	00 00 00 
  p->numOfTotalPages = 0;
80103b58:	c7 83 88 03 00 00 00 	movl   $0x0,0x388(%ebx)
80103b5f:	00 00 00 

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103b62:	e8 49 ee ff ff       	call   801029b0 <kalloc>
80103b67:	83 c4 10             	add    $0x10,%esp
80103b6a:	85 c0                	test   %eax,%eax
80103b6c:	89 43 08             	mov    %eax,0x8(%ebx)
80103b6f:	0f 84 ac 00 00 00    	je     80103c21 <allocproc+0x131>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103b75:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103b7b:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103b7e:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103b83:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103b86:	c7 40 14 6f 5f 10 80 	movl   $0x80105f6f,0x14(%eax)
  p->context = (struct context*)sp;
80103b8d:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103b90:	6a 14                	push   $0x14
80103b92:	6a 00                	push   $0x0
80103b94:	50                   	push   %eax
80103b95:	e8 56 11 00 00       	call   80104cf0 <memset>
  p->context->eip = (uint)forkret;
80103b9a:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103b9d:	8d 8b 00 02 00 00    	lea    0x200(%ebx),%ecx
80103ba3:	83 c4 10             	add    $0x10,%esp
80103ba6:	31 d2                	xor    %edx,%edx
80103ba8:	c7 40 10 30 3c 10 80 	movl   $0x80103c30,0x10(%eax)
80103baf:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80103bb5:	8d 76 00             	lea    0x0(%esi),%esi
  for(int i=0; i< MAX_PSYC_PAGES; i++){
    //cprintf("proc allocated in array of physpages,cell %d page address: %p \n", i, &p->procSwappedFiles[i]);
    //cprintf("proc allocated in array of swapped files,cell %d page address: %p\n", i, &p->procPhysPages[i]);
    p->procSwappedFiles[i].va = 0;
    p->procSwappedFiles[i].pte = 0;
    p->procSwappedFiles[i].offsetInFile = i*(PGSIZE);
80103bb8:	89 50 08             	mov    %edx,0x8(%eax)
    p->procSwappedFiles[i].va = 0;
80103bbb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103bc1:	83 c0 18             	add    $0x18,%eax
    p->procSwappedFiles[i].pte = 0;
80103bc4:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
    p->procSwappedFiles[i].isOccupied = 0;
80103bcb:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
80103bd2:	81 c2 00 10 00 00    	add    $0x1000,%edx
    p->procPhysPages[i].va = 0;
80103bd8:	c7 80 68 01 00 00 00 	movl   $0x0,0x168(%eax)
80103bdf:	00 00 00 
    p->procPhysPages[i].offsetInFile = 0;
80103be2:	c7 80 70 01 00 00 00 	movl   $0x0,0x170(%eax)
80103be9:	00 00 00 
    p->procPhysPages[i].isOccupied = 0;
80103bec:	c7 80 74 01 00 00 00 	movl   $0x0,0x174(%eax)
80103bf3:	00 00 00 
  for(int i=0; i< MAX_PSYC_PAGES; i++){
80103bf6:	39 c8                	cmp    %ecx,%eax
80103bf8:	75 be                	jne    80103bb8 <allocproc+0xc8>
  }

  return p;
}
80103bfa:	89 d8                	mov    %ebx,%eax
80103bfc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bff:	c9                   	leave  
80103c00:	c3                   	ret    
80103c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103c08:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103c0b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103c0d:	68 40 3d 11 80       	push   $0x80113d40
80103c12:	e8 79 10 00 00       	call   80104c90 <release>
}
80103c17:	89 d8                	mov    %ebx,%eax
  return 0;
80103c19:	83 c4 10             	add    $0x10,%esp
}
80103c1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c1f:	c9                   	leave  
80103c20:	c3                   	ret    
    p->state = UNUSED;
80103c21:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103c28:	31 db                	xor    %ebx,%ebx
80103c2a:	eb ce                	jmp    80103bfa <allocproc+0x10a>
80103c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103c30 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103c36:	68 40 3d 11 80       	push   $0x80113d40
80103c3b:	e8 50 10 00 00       	call   80104c90 <release>

  if (first) {
80103c40:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103c45:	83 c4 10             	add    $0x10,%esp
80103c48:	85 c0                	test   %eax,%eax
80103c4a:	75 04                	jne    80103c50 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103c4c:	c9                   	leave  
80103c4d:	c3                   	ret    
80103c4e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103c50:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103c53:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103c5a:	00 00 00 
    iinit(ROOTDEV);
80103c5d:	6a 01                	push   $0x1
80103c5f:	e8 ac d8 ff ff       	call   80101510 <iinit>
    initlog(ROOTDEV);
80103c64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103c6b:	e8 80 f3 ff ff       	call   80102ff0 <initlog>
80103c70:	83 c4 10             	add    $0x10,%esp
}
80103c73:	c9                   	leave  
80103c74:	c3                   	ret    
80103c75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c80 <pinit>:
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103c86:	68 d5 7f 10 80       	push   $0x80107fd5
80103c8b:	68 40 3d 11 80       	push   $0x80113d40
80103c90:	e8 eb 0d 00 00       	call   80104a80 <initlock>
}
80103c95:	83 c4 10             	add    $0x10,%esp
80103c98:	c9                   	leave  
80103c99:	c3                   	ret    
80103c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ca0 <mycpu>:
{
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	56                   	push   %esi
80103ca4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ca5:	9c                   	pushf  
80103ca6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ca7:	f6 c4 02             	test   $0x2,%ah
80103caa:	75 5e                	jne    80103d0a <mycpu+0x6a>
  apicid = lapicid();
80103cac:	e8 6f ef ff ff       	call   80102c20 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103cb1:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
80103cb7:	85 f6                	test   %esi,%esi
80103cb9:	7e 42                	jle    80103cfd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103cbb:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
80103cc2:	39 d0                	cmp    %edx,%eax
80103cc4:	74 30                	je     80103cf6 <mycpu+0x56>
80103cc6:	b9 30 38 11 80       	mov    $0x80113830,%ecx
  for (i = 0; i < ncpu; ++i) {
80103ccb:	31 d2                	xor    %edx,%edx
80103ccd:	8d 76 00             	lea    0x0(%esi),%esi
80103cd0:	83 c2 01             	add    $0x1,%edx
80103cd3:	39 f2                	cmp    %esi,%edx
80103cd5:	74 26                	je     80103cfd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103cd7:	0f b6 19             	movzbl (%ecx),%ebx
80103cda:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103ce0:	39 c3                	cmp    %eax,%ebx
80103ce2:	75 ec                	jne    80103cd0 <mycpu+0x30>
80103ce4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103cea:	05 80 37 11 80       	add    $0x80113780,%eax
}
80103cef:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cf2:	5b                   	pop    %ebx
80103cf3:	5e                   	pop    %esi
80103cf4:	5d                   	pop    %ebp
80103cf5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103cf6:	b8 80 37 11 80       	mov    $0x80113780,%eax
      return &cpus[i];
80103cfb:	eb f2                	jmp    80103cef <mycpu+0x4f>
  panic("unknown apicid\n");
80103cfd:	83 ec 0c             	sub    $0xc,%esp
80103d00:	68 dc 7f 10 80       	push   $0x80107fdc
80103d05:	e8 86 c6 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103d0a:	83 ec 0c             	sub    $0xc,%esp
80103d0d:	68 dc 80 10 80       	push   $0x801080dc
80103d12:	e8 79 c6 ff ff       	call   80100390 <panic>
80103d17:	89 f6                	mov    %esi,%esi
80103d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d20 <cpuid>:
cpuid() {
80103d20:	55                   	push   %ebp
80103d21:	89 e5                	mov    %esp,%ebp
80103d23:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103d26:	e8 75 ff ff ff       	call   80103ca0 <mycpu>
80103d2b:	2d 80 37 11 80       	sub    $0x80113780,%eax
}
80103d30:	c9                   	leave  
  return mycpu()-cpus;
80103d31:	c1 f8 04             	sar    $0x4,%eax
80103d34:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103d3a:	c3                   	ret    
80103d3b:	90                   	nop
80103d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103d40 <myproc>:
myproc(void) {
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	53                   	push   %ebx
80103d44:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103d47:	e8 e4 0d 00 00       	call   80104b30 <pushcli>
  c = mycpu();
80103d4c:	e8 4f ff ff ff       	call   80103ca0 <mycpu>
  p = c->proc;
80103d51:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d57:	e8 d4 0e 00 00       	call   80104c30 <popcli>
}
80103d5c:	83 c4 04             	add    $0x4,%esp
80103d5f:	89 d8                	mov    %ebx,%eax
80103d61:	5b                   	pop    %ebx
80103d62:	5d                   	pop    %ebp
80103d63:	c3                   	ret    
80103d64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103d70 <userinit>:
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	53                   	push   %ebx
80103d74:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103d77:	e8 74 fd ff ff       	call   80103af0 <allocproc>
80103d7c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103d7e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103d83:	e8 78 38 00 00       	call   80107600 <setupkvm>
80103d88:	85 c0                	test   %eax,%eax
80103d8a:	89 43 04             	mov    %eax,0x4(%ebx)
80103d8d:	0f 84 bd 00 00 00    	je     80103e50 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103d93:	83 ec 04             	sub    $0x4,%esp
80103d96:	68 2c 00 00 00       	push   $0x2c
80103d9b:	68 60 b4 10 80       	push   $0x8010b460
80103da0:	50                   	push   %eax
80103da1:	e8 6a 34 00 00       	call   80107210 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103da6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103da9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103daf:	6a 4c                	push   $0x4c
80103db1:	6a 00                	push   $0x0
80103db3:	ff 73 18             	pushl  0x18(%ebx)
80103db6:	e8 35 0f 00 00       	call   80104cf0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103dbb:	8b 43 18             	mov    0x18(%ebx),%eax
80103dbe:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103dc3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103dc8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103dcb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103dcf:	8b 43 18             	mov    0x18(%ebx),%eax
80103dd2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103dd6:	8b 43 18             	mov    0x18(%ebx),%eax
80103dd9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ddd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103de1:	8b 43 18             	mov    0x18(%ebx),%eax
80103de4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103de8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103dec:	8b 43 18             	mov    0x18(%ebx),%eax
80103def:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103df6:	8b 43 18             	mov    0x18(%ebx),%eax
80103df9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103e00:	8b 43 18             	mov    0x18(%ebx),%eax
80103e03:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103e0a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103e0d:	6a 10                	push   $0x10
80103e0f:	68 05 80 10 80       	push   $0x80108005
80103e14:	50                   	push   %eax
80103e15:	e8 b6 10 00 00       	call   80104ed0 <safestrcpy>
  p->cwd = namei("/");
80103e1a:	c7 04 24 0e 80 10 80 	movl   $0x8010800e,(%esp)
80103e21:	e8 4a e1 ff ff       	call   80101f70 <namei>
80103e26:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103e29:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103e30:	e8 3b 0d 00 00       	call   80104b70 <acquire>
  p->state = RUNNABLE;
80103e35:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103e3c:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103e43:	e8 48 0e 00 00       	call   80104c90 <release>
}
80103e48:	83 c4 10             	add    $0x10,%esp
80103e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e4e:	c9                   	leave  
80103e4f:	c3                   	ret    
    panic("userinit: out of memory?");
80103e50:	83 ec 0c             	sub    $0xc,%esp
80103e53:	68 ec 7f 10 80       	push   $0x80107fec
80103e58:	e8 33 c5 ff ff       	call   80100390 <panic>
80103e5d:	8d 76 00             	lea    0x0(%esi),%esi

80103e60 <growproc>:
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	56                   	push   %esi
80103e64:	53                   	push   %ebx
80103e65:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103e68:	e8 c3 0c 00 00       	call   80104b30 <pushcli>
  c = mycpu();
80103e6d:	e8 2e fe ff ff       	call   80103ca0 <mycpu>
  p = c->proc;
80103e72:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e78:	e8 b3 0d 00 00       	call   80104c30 <popcli>
  if(n > 0){
80103e7d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103e80:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103e82:	7f 1c                	jg     80103ea0 <growproc+0x40>
  } else if(n < 0){
80103e84:	75 3a                	jne    80103ec0 <growproc+0x60>
  switchuvm(curproc);
80103e86:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103e89:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103e8b:	53                   	push   %ebx
80103e8c:	e8 6f 32 00 00       	call   80107100 <switchuvm>
  return 0;
80103e91:	83 c4 10             	add    $0x10,%esp
80103e94:	31 c0                	xor    %eax,%eax
}
80103e96:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e99:	5b                   	pop    %ebx
80103e9a:	5e                   	pop    %esi
80103e9b:	5d                   	pop    %ebp
80103e9c:	c3                   	ret    
80103e9d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ea0:	83 ec 04             	sub    $0x4,%esp
80103ea3:	01 c6                	add    %eax,%esi
80103ea5:	56                   	push   %esi
80103ea6:	50                   	push   %eax
80103ea7:	ff 73 04             	pushl  0x4(%ebx)
80103eaa:	e8 31 35 00 00       	call   801073e0 <allocuvm>
80103eaf:	83 c4 10             	add    $0x10,%esp
80103eb2:	85 c0                	test   %eax,%eax
80103eb4:	75 d0                	jne    80103e86 <growproc+0x26>
      return -1;
80103eb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ebb:	eb d9                	jmp    80103e96 <growproc+0x36>
80103ebd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ec0:	83 ec 04             	sub    $0x4,%esp
80103ec3:	01 c6                	add    %eax,%esi
80103ec5:	56                   	push   %esi
80103ec6:	50                   	push   %eax
80103ec7:	ff 73 04             	pushl  0x4(%ebx)
80103eca:	e8 81 36 00 00       	call   80107550 <deallocuvm>
80103ecf:	83 c4 10             	add    $0x10,%esp
80103ed2:	85 c0                	test   %eax,%eax
80103ed4:	75 b0                	jne    80103e86 <growproc+0x26>
80103ed6:	eb de                	jmp    80103eb6 <growproc+0x56>
80103ed8:	90                   	nop
80103ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ee0 <fork>:
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	57                   	push   %edi
80103ee4:	56                   	push   %esi
80103ee5:	53                   	push   %ebx
80103ee6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103ee9:	e8 42 0c 00 00       	call   80104b30 <pushcli>
  c = mycpu();
80103eee:	e8 ad fd ff ff       	call   80103ca0 <mycpu>
  p = c->proc;
80103ef3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ef9:	e8 32 0d 00 00       	call   80104c30 <popcli>
  if((np = allocproc()) == 0){
80103efe:	e8 ed fb ff ff       	call   80103af0 <allocproc>
80103f03:	85 c0                	test   %eax,%eax
80103f05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103f08:	0f 84 da 00 00 00    	je     80103fe8 <fork+0x108>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103f0e:	83 ec 08             	sub    $0x8,%esp
80103f11:	ff 33                	pushl  (%ebx)
80103f13:	ff 73 04             	pushl  0x4(%ebx)
80103f16:	89 c7                	mov    %eax,%edi
80103f18:	e8 b3 37 00 00       	call   801076d0 <copyuvm>
80103f1d:	83 c4 10             	add    $0x10,%esp
80103f20:	85 c0                	test   %eax,%eax
80103f22:	89 47 04             	mov    %eax,0x4(%edi)
80103f25:	0f 84 c4 00 00 00    	je     80103fef <fork+0x10f>
  np->sz = curproc->sz;
80103f2b:	8b 03                	mov    (%ebx),%eax
80103f2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103f30:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103f32:	89 59 14             	mov    %ebx,0x14(%ecx)
80103f35:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103f37:	8b 79 18             	mov    0x18(%ecx),%edi
80103f3a:	8b 73 18             	mov    0x18(%ebx),%esi
80103f3d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103f42:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103f44:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103f46:	8b 40 18             	mov    0x18(%eax),%eax
80103f49:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103f50:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103f54:	85 c0                	test   %eax,%eax
80103f56:	74 13                	je     80103f6b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103f58:	83 ec 0c             	sub    $0xc,%esp
80103f5b:	50                   	push   %eax
80103f5c:	e8 0f cf ff ff       	call   80100e70 <filedup>
80103f61:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f64:	83 c4 10             	add    $0x10,%esp
80103f67:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103f6b:	83 c6 01             	add    $0x1,%esi
80103f6e:	83 fe 10             	cmp    $0x10,%esi
80103f71:	75 dd                	jne    80103f50 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103f73:	83 ec 0c             	sub    $0xc,%esp
80103f76:	ff 73 68             	pushl  0x68(%ebx)
80103f79:	e8 62 d7 ff ff       	call   801016e0 <idup>
80103f7e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f81:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103f84:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f87:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103f8a:	6a 10                	push   $0x10
80103f8c:	50                   	push   %eax
80103f8d:	8d 47 6c             	lea    0x6c(%edi),%eax
80103f90:	50                   	push   %eax
80103f91:	e8 3a 0f 00 00       	call   80104ed0 <safestrcpy>
  if(curproc->swapFile){
80103f96:	8b 4b 7c             	mov    0x7c(%ebx),%ecx
80103f99:	83 c4 10             	add    $0x10,%esp
  pid = np->pid;
80103f9c:	8b 77 10             	mov    0x10(%edi),%esi
  if(curproc->swapFile){
80103f9f:	85 c9                	test   %ecx,%ecx
80103fa1:	74 15                	je     80103fb8 <fork+0xd8>
    createSwapFile(np);
80103fa3:	83 ec 0c             	sub    $0xc,%esp
80103fa6:	57                   	push   %edi
80103fa7:	e8 94 e2 ff ff       	call   80102240 <createSwapFile>
    copySwapFile(np,curproc);
80103fac:	58                   	pop    %eax
80103fad:	5a                   	pop    %edx
80103fae:	53                   	push   %ebx
80103faf:	57                   	push   %edi
80103fb0:	e8 8b e3 ff ff       	call   80102340 <copySwapFile>
80103fb5:	83 c4 10             	add    $0x10,%esp
  acquire(&ptable.lock);
80103fb8:	83 ec 0c             	sub    $0xc,%esp
80103fbb:	68 40 3d 11 80       	push   $0x80113d40
80103fc0:	e8 ab 0b 00 00       	call   80104b70 <acquire>
  np->state = RUNNABLE;
80103fc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103fc8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80103fcf:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103fd6:	e8 b5 0c 00 00       	call   80104c90 <release>
  return pid;
80103fdb:	83 c4 10             	add    $0x10,%esp
}
80103fde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fe1:	89 f0                	mov    %esi,%eax
80103fe3:	5b                   	pop    %ebx
80103fe4:	5e                   	pop    %esi
80103fe5:	5f                   	pop    %edi
80103fe6:	5d                   	pop    %ebp
80103fe7:	c3                   	ret    
    return -1;
80103fe8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103fed:	eb ef                	jmp    80103fde <fork+0xfe>
    kfree(np->kstack);
80103fef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103ff2:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80103ff5:	be ff ff ff ff       	mov    $0xffffffff,%esi
    kfree(np->kstack);
80103ffa:	ff 77 08             	pushl  0x8(%edi)
80103ffd:	e8 fe e7 ff ff       	call   80102800 <kfree>
    np->kstack = 0;
80104002:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80104009:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80104010:	83 c4 10             	add    $0x10,%esp
80104013:	eb c9                	jmp    80103fde <fork+0xfe>
80104015:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104020 <scheduler>:
{
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	57                   	push   %edi
80104024:	56                   	push   %esi
80104025:	53                   	push   %ebx
80104026:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104029:	e8 72 fc ff ff       	call   80103ca0 <mycpu>
8010402e:	8d 78 04             	lea    0x4(%eax),%edi
80104031:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80104033:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010403a:	00 00 00 
8010403d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104040:	fb                   	sti    
    acquire(&ptable.lock);
80104041:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104044:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
    acquire(&ptable.lock);
80104049:	68 40 3d 11 80       	push   $0x80113d40
8010404e:	e8 1d 0b 00 00       	call   80104b70 <acquire>
80104053:	83 c4 10             	add    $0x10,%esp
80104056:	8d 76 00             	lea    0x0(%esi),%esi
80104059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80104060:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104064:	75 33                	jne    80104099 <scheduler+0x79>
      switchuvm(p);
80104066:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104069:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010406f:	53                   	push   %ebx
80104070:	e8 8b 30 00 00       	call   80107100 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104075:	58                   	pop    %eax
80104076:	5a                   	pop    %edx
80104077:	ff 73 1c             	pushl  0x1c(%ebx)
8010407a:	57                   	push   %edi
      p->state = RUNNING;
8010407b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104082:	e8 a4 0e 00 00       	call   80104f2b <swtch>
      switchkvm();
80104087:	e8 54 30 00 00       	call   801070e0 <switchkvm>
      c->proc = 0;
8010408c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104093:	00 00 00 
80104096:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104099:	81 c3 8c 03 00 00    	add    $0x38c,%ebx
8010409f:	81 fb 74 20 12 80    	cmp    $0x80122074,%ebx
801040a5:	72 b9                	jb     80104060 <scheduler+0x40>
    release(&ptable.lock);
801040a7:	83 ec 0c             	sub    $0xc,%esp
801040aa:	68 40 3d 11 80       	push   $0x80113d40
801040af:	e8 dc 0b 00 00       	call   80104c90 <release>
    sti();
801040b4:	83 c4 10             	add    $0x10,%esp
801040b7:	eb 87                	jmp    80104040 <scheduler+0x20>
801040b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040c0 <sched>:
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	56                   	push   %esi
801040c4:	53                   	push   %ebx
  pushcli();
801040c5:	e8 66 0a 00 00       	call   80104b30 <pushcli>
  c = mycpu();
801040ca:	e8 d1 fb ff ff       	call   80103ca0 <mycpu>
  p = c->proc;
801040cf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040d5:	e8 56 0b 00 00       	call   80104c30 <popcli>
  if(!holding(&ptable.lock))
801040da:	83 ec 0c             	sub    $0xc,%esp
801040dd:	68 40 3d 11 80       	push   $0x80113d40
801040e2:	e8 09 0a 00 00       	call   80104af0 <holding>
801040e7:	83 c4 10             	add    $0x10,%esp
801040ea:	85 c0                	test   %eax,%eax
801040ec:	74 4f                	je     8010413d <sched+0x7d>
  if(mycpu()->ncli != 1)
801040ee:	e8 ad fb ff ff       	call   80103ca0 <mycpu>
801040f3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801040fa:	75 68                	jne    80104164 <sched+0xa4>
  if(p->state == RUNNING)
801040fc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104100:	74 55                	je     80104157 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104102:	9c                   	pushf  
80104103:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104104:	f6 c4 02             	test   $0x2,%ah
80104107:	75 41                	jne    8010414a <sched+0x8a>
  intena = mycpu()->intena;
80104109:	e8 92 fb ff ff       	call   80103ca0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010410e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104111:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104117:	e8 84 fb ff ff       	call   80103ca0 <mycpu>
8010411c:	83 ec 08             	sub    $0x8,%esp
8010411f:	ff 70 04             	pushl  0x4(%eax)
80104122:	53                   	push   %ebx
80104123:	e8 03 0e 00 00       	call   80104f2b <swtch>
  mycpu()->intena = intena;
80104128:	e8 73 fb ff ff       	call   80103ca0 <mycpu>
}
8010412d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104130:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104136:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104139:	5b                   	pop    %ebx
8010413a:	5e                   	pop    %esi
8010413b:	5d                   	pop    %ebp
8010413c:	c3                   	ret    
    panic("sched ptable.lock");
8010413d:	83 ec 0c             	sub    $0xc,%esp
80104140:	68 10 80 10 80       	push   $0x80108010
80104145:	e8 46 c2 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010414a:	83 ec 0c             	sub    $0xc,%esp
8010414d:	68 3c 80 10 80       	push   $0x8010803c
80104152:	e8 39 c2 ff ff       	call   80100390 <panic>
    panic("sched running");
80104157:	83 ec 0c             	sub    $0xc,%esp
8010415a:	68 2e 80 10 80       	push   $0x8010802e
8010415f:	e8 2c c2 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104164:	83 ec 0c             	sub    $0xc,%esp
80104167:	68 22 80 10 80       	push   $0x80108022
8010416c:	e8 1f c2 ff ff       	call   80100390 <panic>
80104171:	eb 0d                	jmp    80104180 <exit>
80104173:	90                   	nop
80104174:	90                   	nop
80104175:	90                   	nop
80104176:	90                   	nop
80104177:	90                   	nop
80104178:	90                   	nop
80104179:	90                   	nop
8010417a:	90                   	nop
8010417b:	90                   	nop
8010417c:	90                   	nop
8010417d:	90                   	nop
8010417e:	90                   	nop
8010417f:	90                   	nop

80104180 <exit>:
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	57                   	push   %edi
80104184:	56                   	push   %esi
80104185:	53                   	push   %ebx
80104186:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104189:	e8 a2 09 00 00       	call   80104b30 <pushcli>
  c = mycpu();
8010418e:	e8 0d fb ff ff       	call   80103ca0 <mycpu>
  p = c->proc;
80104193:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104199:	e8 92 0a 00 00       	call   80104c30 <popcli>
  if(curproc == initproc)
8010419e:	39 1d b8 b5 10 80    	cmp    %ebx,0x8010b5b8
801041a4:	8d 73 28             	lea    0x28(%ebx),%esi
801041a7:	8d 7b 68             	lea    0x68(%ebx),%edi
801041aa:	0f 84 01 01 00 00    	je     801042b1 <exit+0x131>
    if(curproc->ofile[fd]){
801041b0:	8b 06                	mov    (%esi),%eax
801041b2:	85 c0                	test   %eax,%eax
801041b4:	74 12                	je     801041c8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
801041b6:	83 ec 0c             	sub    $0xc,%esp
801041b9:	50                   	push   %eax
801041ba:	e8 01 cd ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
801041bf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801041c5:	83 c4 10             	add    $0x10,%esp
801041c8:	83 c6 04             	add    $0x4,%esi
  for(fd = 0; fd < NOFILE; fd++){
801041cb:	39 fe                	cmp    %edi,%esi
801041cd:	75 e1                	jne    801041b0 <exit+0x30>
  begin_op();
801041cf:	e8 bc ee ff ff       	call   80103090 <begin_op>
  iput(curproc->cwd);
801041d4:	83 ec 0c             	sub    $0xc,%esp
801041d7:	ff 73 68             	pushl  0x68(%ebx)
801041da:	e8 61 d6 ff ff       	call   80101840 <iput>
  end_op();
801041df:	e8 1c ef ff ff       	call   80103100 <end_op>
  curproc->cwd = 0;
801041e4:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  removeSwapFile(curproc);
801041eb:	89 1c 24             	mov    %ebx,(%esp)
801041ee:	e8 4d de ff ff       	call   80102040 <removeSwapFile>
  acquire(&ptable.lock);
801041f3:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
801041fa:	e8 71 09 00 00       	call   80104b70 <acquire>
  wakeup1(curproc->parent);
801041ff:	8b 53 14             	mov    0x14(%ebx),%edx
80104202:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104205:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
8010420a:	eb 10                	jmp    8010421c <exit+0x9c>
8010420c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104210:	05 8c 03 00 00       	add    $0x38c,%eax
80104215:	3d 74 20 12 80       	cmp    $0x80122074,%eax
8010421a:	73 1e                	jae    8010423a <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
8010421c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104220:	75 ee                	jne    80104210 <exit+0x90>
80104222:	3b 50 20             	cmp    0x20(%eax),%edx
80104225:	75 e9                	jne    80104210 <exit+0x90>
      p->state = RUNNABLE;
80104227:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010422e:	05 8c 03 00 00       	add    $0x38c,%eax
80104233:	3d 74 20 12 80       	cmp    $0x80122074,%eax
80104238:	72 e2                	jb     8010421c <exit+0x9c>
      p->parent = initproc;
8010423a:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104240:	ba 74 3d 11 80       	mov    $0x80113d74,%edx
80104245:	eb 17                	jmp    8010425e <exit+0xde>
80104247:	89 f6                	mov    %esi,%esi
80104249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104250:	81 c2 8c 03 00 00    	add    $0x38c,%edx
80104256:	81 fa 74 20 12 80    	cmp    $0x80122074,%edx
8010425c:	73 3a                	jae    80104298 <exit+0x118>
    if(p->parent == curproc){
8010425e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104261:	75 ed                	jne    80104250 <exit+0xd0>
      if(p->state == ZOMBIE)
80104263:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104267:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010426a:	75 e4                	jne    80104250 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010426c:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
80104271:	eb 11                	jmp    80104284 <exit+0x104>
80104273:	90                   	nop
80104274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104278:	05 8c 03 00 00       	add    $0x38c,%eax
8010427d:	3d 74 20 12 80       	cmp    $0x80122074,%eax
80104282:	73 cc                	jae    80104250 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80104284:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104288:	75 ee                	jne    80104278 <exit+0xf8>
8010428a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010428d:	75 e9                	jne    80104278 <exit+0xf8>
      p->state = RUNNABLE;
8010428f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104296:	eb e0                	jmp    80104278 <exit+0xf8>
  curproc->state = ZOMBIE;
80104298:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
8010429f:	e8 1c fe ff ff       	call   801040c0 <sched>
  panic("zombie exit");
801042a4:	83 ec 0c             	sub    $0xc,%esp
801042a7:	68 5d 80 10 80       	push   $0x8010805d
801042ac:	e8 df c0 ff ff       	call   80100390 <panic>
    panic("init exiting");
801042b1:	83 ec 0c             	sub    $0xc,%esp
801042b4:	68 50 80 10 80       	push   $0x80108050
801042b9:	e8 d2 c0 ff ff       	call   80100390 <panic>
801042be:	66 90                	xchg   %ax,%ax

801042c0 <yield>:
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	53                   	push   %ebx
801042c4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801042c7:	68 40 3d 11 80       	push   $0x80113d40
801042cc:	e8 9f 08 00 00       	call   80104b70 <acquire>
  pushcli();
801042d1:	e8 5a 08 00 00       	call   80104b30 <pushcli>
  c = mycpu();
801042d6:	e8 c5 f9 ff ff       	call   80103ca0 <mycpu>
  p = c->proc;
801042db:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042e1:	e8 4a 09 00 00       	call   80104c30 <popcli>
  myproc()->state = RUNNABLE;
801042e6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801042ed:	e8 ce fd ff ff       	call   801040c0 <sched>
  release(&ptable.lock);
801042f2:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
801042f9:	e8 92 09 00 00       	call   80104c90 <release>
}
801042fe:	83 c4 10             	add    $0x10,%esp
80104301:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104304:	c9                   	leave  
80104305:	c3                   	ret    
80104306:	8d 76 00             	lea    0x0(%esi),%esi
80104309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104310 <sleep>:
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	57                   	push   %edi
80104314:	56                   	push   %esi
80104315:	53                   	push   %ebx
80104316:	83 ec 0c             	sub    $0xc,%esp
80104319:	8b 7d 08             	mov    0x8(%ebp),%edi
8010431c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010431f:	e8 0c 08 00 00       	call   80104b30 <pushcli>
  c = mycpu();
80104324:	e8 77 f9 ff ff       	call   80103ca0 <mycpu>
  p = c->proc;
80104329:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010432f:	e8 fc 08 00 00       	call   80104c30 <popcli>
  if(p == 0)
80104334:	85 db                	test   %ebx,%ebx
80104336:	0f 84 87 00 00 00    	je     801043c3 <sleep+0xb3>
  if(lk == 0)
8010433c:	85 f6                	test   %esi,%esi
8010433e:	74 76                	je     801043b6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104340:	81 fe 40 3d 11 80    	cmp    $0x80113d40,%esi
80104346:	74 50                	je     80104398 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104348:	83 ec 0c             	sub    $0xc,%esp
8010434b:	68 40 3d 11 80       	push   $0x80113d40
80104350:	e8 1b 08 00 00       	call   80104b70 <acquire>
    release(lk);
80104355:	89 34 24             	mov    %esi,(%esp)
80104358:	e8 33 09 00 00       	call   80104c90 <release>
  p->chan = chan;
8010435d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104360:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104367:	e8 54 fd ff ff       	call   801040c0 <sched>
  p->chan = 0;
8010436c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104373:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
8010437a:	e8 11 09 00 00       	call   80104c90 <release>
    acquire(lk);
8010437f:	89 75 08             	mov    %esi,0x8(%ebp)
80104382:	83 c4 10             	add    $0x10,%esp
}
80104385:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104388:	5b                   	pop    %ebx
80104389:	5e                   	pop    %esi
8010438a:	5f                   	pop    %edi
8010438b:	5d                   	pop    %ebp
    acquire(lk);
8010438c:	e9 df 07 00 00       	jmp    80104b70 <acquire>
80104391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104398:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010439b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801043a2:	e8 19 fd ff ff       	call   801040c0 <sched>
  p->chan = 0;
801043a7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801043ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043b1:	5b                   	pop    %ebx
801043b2:	5e                   	pop    %esi
801043b3:	5f                   	pop    %edi
801043b4:	5d                   	pop    %ebp
801043b5:	c3                   	ret    
    panic("sleep without lk");
801043b6:	83 ec 0c             	sub    $0xc,%esp
801043b9:	68 6f 80 10 80       	push   $0x8010806f
801043be:	e8 cd bf ff ff       	call   80100390 <panic>
    panic("sleep");
801043c3:	83 ec 0c             	sub    $0xc,%esp
801043c6:	68 69 80 10 80       	push   $0x80108069
801043cb:	e8 c0 bf ff ff       	call   80100390 <panic>

801043d0 <wait>:
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	56                   	push   %esi
801043d4:	53                   	push   %ebx
  pushcli();
801043d5:	e8 56 07 00 00       	call   80104b30 <pushcli>
  c = mycpu();
801043da:	e8 c1 f8 ff ff       	call   80103ca0 <mycpu>
  p = c->proc;
801043df:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801043e5:	e8 46 08 00 00       	call   80104c30 <popcli>
  acquire(&ptable.lock);
801043ea:	83 ec 0c             	sub    $0xc,%esp
801043ed:	68 40 3d 11 80       	push   $0x80113d40
801043f2:	e8 79 07 00 00       	call   80104b70 <acquire>
801043f7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801043fa:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043fc:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
80104401:	eb 13                	jmp    80104416 <wait+0x46>
80104403:	90                   	nop
80104404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104408:	81 c3 8c 03 00 00    	add    $0x38c,%ebx
8010440e:	81 fb 74 20 12 80    	cmp    $0x80122074,%ebx
80104414:	73 1e                	jae    80104434 <wait+0x64>
      if(p->parent != curproc)
80104416:	39 73 14             	cmp    %esi,0x14(%ebx)
80104419:	75 ed                	jne    80104408 <wait+0x38>
      if(p->state == ZOMBIE){
8010441b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010441f:	74 37                	je     80104458 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104421:	81 c3 8c 03 00 00    	add    $0x38c,%ebx
      havekids = 1;
80104427:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010442c:	81 fb 74 20 12 80    	cmp    $0x80122074,%ebx
80104432:	72 e2                	jb     80104416 <wait+0x46>
    if(!havekids || curproc->killed){
80104434:	85 c0                	test   %eax,%eax
80104436:	74 76                	je     801044ae <wait+0xde>
80104438:	8b 46 24             	mov    0x24(%esi),%eax
8010443b:	85 c0                	test   %eax,%eax
8010443d:	75 6f                	jne    801044ae <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010443f:	83 ec 08             	sub    $0x8,%esp
80104442:	68 40 3d 11 80       	push   $0x80113d40
80104447:	56                   	push   %esi
80104448:	e8 c3 fe ff ff       	call   80104310 <sleep>
    havekids = 0;
8010444d:	83 c4 10             	add    $0x10,%esp
80104450:	eb a8                	jmp    801043fa <wait+0x2a>
80104452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104458:	83 ec 0c             	sub    $0xc,%esp
8010445b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010445e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104461:	e8 9a e3 ff ff       	call   80102800 <kfree>
        freevm(p->pgdir);
80104466:	5a                   	pop    %edx
80104467:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010446a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104471:	e8 0a 31 00 00       	call   80107580 <freevm>
        release(&ptable.lock);
80104476:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
        p->pid = 0;
8010447d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104484:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010448b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010448f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104496:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010449d:	e8 ee 07 00 00       	call   80104c90 <release>
        return pid;
801044a2:	83 c4 10             	add    $0x10,%esp
}
801044a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044a8:	89 f0                	mov    %esi,%eax
801044aa:	5b                   	pop    %ebx
801044ab:	5e                   	pop    %esi
801044ac:	5d                   	pop    %ebp
801044ad:	c3                   	ret    
      release(&ptable.lock);
801044ae:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801044b1:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801044b6:	68 40 3d 11 80       	push   $0x80113d40
801044bb:	e8 d0 07 00 00       	call   80104c90 <release>
      return -1;
801044c0:	83 c4 10             	add    $0x10,%esp
801044c3:	eb e0                	jmp    801044a5 <wait+0xd5>
801044c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044d0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	53                   	push   %ebx
801044d4:	83 ec 10             	sub    $0x10,%esp
801044d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801044da:	68 40 3d 11 80       	push   $0x80113d40
801044df:	e8 8c 06 00 00       	call   80104b70 <acquire>
801044e4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044e7:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
801044ec:	eb 0e                	jmp    801044fc <wakeup+0x2c>
801044ee:	66 90                	xchg   %ax,%ax
801044f0:	05 8c 03 00 00       	add    $0x38c,%eax
801044f5:	3d 74 20 12 80       	cmp    $0x80122074,%eax
801044fa:	73 1e                	jae    8010451a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801044fc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104500:	75 ee                	jne    801044f0 <wakeup+0x20>
80104502:	3b 58 20             	cmp    0x20(%eax),%ebx
80104505:	75 e9                	jne    801044f0 <wakeup+0x20>
      p->state = RUNNABLE;
80104507:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010450e:	05 8c 03 00 00       	add    $0x38c,%eax
80104513:	3d 74 20 12 80       	cmp    $0x80122074,%eax
80104518:	72 e2                	jb     801044fc <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010451a:	c7 45 08 40 3d 11 80 	movl   $0x80113d40,0x8(%ebp)
}
80104521:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104524:	c9                   	leave  
  release(&ptable.lock);
80104525:	e9 66 07 00 00       	jmp    80104c90 <release>
8010452a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104530 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	53                   	push   %ebx
80104534:	83 ec 10             	sub    $0x10,%esp
80104537:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010453a:	68 40 3d 11 80       	push   $0x80113d40
8010453f:	e8 2c 06 00 00       	call   80104b70 <acquire>
80104544:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104547:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
8010454c:	eb 0e                	jmp    8010455c <kill+0x2c>
8010454e:	66 90                	xchg   %ax,%ax
80104550:	05 8c 03 00 00       	add    $0x38c,%eax
80104555:	3d 74 20 12 80       	cmp    $0x80122074,%eax
8010455a:	73 34                	jae    80104590 <kill+0x60>
    if(p->pid == pid){
8010455c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010455f:	75 ef                	jne    80104550 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104561:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104565:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010456c:	75 07                	jne    80104575 <kill+0x45>
        p->state = RUNNABLE;
8010456e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104575:	83 ec 0c             	sub    $0xc,%esp
80104578:	68 40 3d 11 80       	push   $0x80113d40
8010457d:	e8 0e 07 00 00       	call   80104c90 <release>
      return 0;
80104582:	83 c4 10             	add    $0x10,%esp
80104585:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104587:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010458a:	c9                   	leave  
8010458b:	c3                   	ret    
8010458c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104590:	83 ec 0c             	sub    $0xc,%esp
80104593:	68 40 3d 11 80       	push   $0x80113d40
80104598:	e8 f3 06 00 00       	call   80104c90 <release>
  return -1;
8010459d:	83 c4 10             	add    $0x10,%esp
801045a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045a8:	c9                   	leave  
801045a9:	c3                   	ret    
801045aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045b0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	57                   	push   %edi
801045b4:	56                   	push   %esi
801045b5:	53                   	push   %ebx
801045b6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045b9:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
{
801045be:	83 ec 3c             	sub    $0x3c,%esp
801045c1:	eb 27                	jmp    801045ea <procdump+0x3a>
801045c3:	90                   	nop
801045c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801045c8:	83 ec 0c             	sub    $0xc,%esp
801045cb:	68 b2 83 10 80       	push   $0x801083b2
801045d0:	e8 8b c0 ff ff       	call   80100660 <cprintf>
801045d5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045d8:	81 c3 8c 03 00 00    	add    $0x38c,%ebx
801045de:	81 fb 74 20 12 80    	cmp    $0x80122074,%ebx
801045e4:	0f 83 86 00 00 00    	jae    80104670 <procdump+0xc0>
    if(p->state == UNUSED)
801045ea:	8b 43 0c             	mov    0xc(%ebx),%eax
801045ed:	85 c0                	test   %eax,%eax
801045ef:	74 e7                	je     801045d8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801045f1:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801045f4:	ba 80 80 10 80       	mov    $0x80108080,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801045f9:	77 11                	ja     8010460c <procdump+0x5c>
801045fb:	8b 14 85 24 81 10 80 	mov    -0x7fef7edc(,%eax,4),%edx
      state = "???";
80104602:	b8 80 80 10 80       	mov    $0x80108080,%eax
80104607:	85 d2                	test   %edx,%edx
80104609:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010460c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010460f:	50                   	push   %eax
80104610:	52                   	push   %edx
80104611:	ff 73 10             	pushl  0x10(%ebx)
80104614:	68 84 80 10 80       	push   $0x80108084
80104619:	e8 42 c0 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010461e:	83 c4 10             	add    $0x10,%esp
80104621:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104625:	75 a1                	jne    801045c8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104627:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010462a:	83 ec 08             	sub    $0x8,%esp
8010462d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104630:	50                   	push   %eax
80104631:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104634:	8b 40 0c             	mov    0xc(%eax),%eax
80104637:	83 c0 08             	add    $0x8,%eax
8010463a:	50                   	push   %eax
8010463b:	e8 60 04 00 00       	call   80104aa0 <getcallerpcs>
80104640:	83 c4 10             	add    $0x10,%esp
80104643:	90                   	nop
80104644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104648:	8b 17                	mov    (%edi),%edx
8010464a:	85 d2                	test   %edx,%edx
8010464c:	0f 84 76 ff ff ff    	je     801045c8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104652:	83 ec 08             	sub    $0x8,%esp
80104655:	83 c7 04             	add    $0x4,%edi
80104658:	52                   	push   %edx
80104659:	68 81 7a 10 80       	push   $0x80107a81
8010465e:	e8 fd bf ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104663:	83 c4 10             	add    $0x10,%esp
80104666:	39 fe                	cmp    %edi,%esi
80104668:	75 de                	jne    80104648 <procdump+0x98>
8010466a:	e9 59 ff ff ff       	jmp    801045c8 <procdump+0x18>
8010466f:	90                   	nop
  }
}
80104670:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104673:	5b                   	pop    %ebx
80104674:	5e                   	pop    %esi
80104675:	5f                   	pop    %edi
80104676:	5d                   	pop    %ebp
80104677:	c3                   	ret    
80104678:	90                   	nop
80104679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104680 <printFlags>:

void printFlags(pte_t *pgtab){
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	83 ec 10             	sub    $0x10,%esp
  cprintf("PTE_P = %x\n", (*pgtab & PTE_P)&0x1);
80104686:	8b 45 08             	mov    0x8(%ebp),%eax
80104689:	8b 00                	mov    (%eax),%eax
8010468b:	83 e0 01             	and    $0x1,%eax
8010468e:	50                   	push   %eax
8010468f:	68 8d 80 10 80       	push   $0x8010808d
80104694:	e8 c7 bf ff ff       	call   80100660 <cprintf>
	cprintf("PTE_W = %d\n", (*pgtab & PTE_W)&0x1);
80104699:	58                   	pop    %eax
8010469a:	5a                   	pop    %edx
8010469b:	6a 00                	push   $0x0
8010469d:	68 99 80 10 80       	push   $0x80108099
801046a2:	e8 b9 bf ff ff       	call   80100660 <cprintf>
	cprintf("PTE_PG = %d\n", (*pgtab & PTE_PG)&0x1);
801046a7:	59                   	pop    %ecx
801046a8:	58                   	pop    %eax
801046a9:	6a 00                	push   $0x0
801046ab:	68 a5 80 10 80       	push   $0x801080a5
801046b0:	e8 ab bf ff ff       	call   80100660 <cprintf>
}
801046b5:	83 c4 10             	add    $0x10,%esp
801046b8:	c9                   	leave  
801046b9:	c3                   	ret    
801046ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046c0 <protectPage>:
int protectPage(void* va){
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	56                   	push   %esi
801046c4:	53                   	push   %ebx
  pushcli();
801046c5:	e8 66 04 00 00       	call   80104b30 <pushcli>
  c = mycpu();
801046ca:	e8 d1 f5 ff ff       	call   80103ca0 <mycpu>
  p = c->proc;
801046cf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046d5:	e8 56 05 00 00       	call   80104c30 <popcli>
  pde = &pgdir[PDX(va)];
801046da:	8b 45 08             	mov    0x8(%ebp),%eax
  if(*pde & PTE_P){
801046dd:	8b 53 04             	mov    0x4(%ebx),%edx
  pde = &pgdir[PDX(va)];
801046e0:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801046e3:	8b 1c 82             	mov    (%edx,%eax,4),%ebx
801046e6:	f6 c3 01             	test   $0x1,%bl
801046e9:	74 4d                	je     80104738 <protectPage+0x78>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801046eb:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  printFlags(pgtab);
801046f1:	83 ec 0c             	sub    $0xc,%esp
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801046f4:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  printFlags(pgtab);
801046fa:	56                   	push   %esi
801046fb:	e8 80 ff ff ff       	call   80104680 <printFlags>
  if(*pgtab & PTE_W){ // this page is writable
80104700:	8b 83 00 00 00 80    	mov    -0x80000000(%ebx),%eax
80104706:	83 c4 10             	add    $0x10,%esp
80104709:	a8 02                	test   $0x2,%al
8010470b:	75 1b                	jne    80104728 <protectPage+0x68>
  printFlags(pgtab);
8010470d:	83 ec 0c             	sub    $0xc,%esp
80104710:	56                   	push   %esi
80104711:	e8 6a ff ff ff       	call   80104680 <printFlags>
  return 1;
80104716:	83 c4 10             	add    $0x10,%esp
80104719:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010471e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104721:	5b                   	pop    %ebx
80104722:	5e                   	pop    %esi
80104723:	5d                   	pop    %ebp
80104724:	c3                   	ret    
80104725:	8d 76 00             	lea    0x0(%esi),%esi
    (*pgtab) &= ~PTE_W;
80104728:	83 e0 fd             	and    $0xfffffffd,%eax
8010472b:	89 83 00 00 00 80    	mov    %eax,-0x80000000(%ebx)
80104731:	eb da                	jmp    8010470d <protectPage+0x4d>
80104733:	90                   	nop
80104734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104738:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010473d:	eb df                	jmp    8010471e <protectPage+0x5e>
8010473f:	90                   	nop

80104740 <choosePageToSwapOut>:

struct page_meta_data *head;
struct page_meta_data *tail;

// choose which page to swap-out, update (add it to this array) the procSwappedFiles data structure and flush the TLB
void* choosePageToSwapOut(){
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	56                   	push   %esi
80104744:	53                   	push   %ebx
  chosen = head;
  head = chosen->next;  
  #endif
  #ifdef SCFIFO
  struct page_meta_data *last;
  for(int i=0; i < myproc()->numOfPhysPages; i++){
80104745:	31 db                	xor    %ebx,%ebx
80104747:	89 f6                	mov    %esi,%esi
80104749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  pushcli();
80104750:	e8 db 03 00 00       	call   80104b30 <pushcli>
  c = mycpu();
80104755:	e8 46 f5 ff ff       	call   80103ca0 <mycpu>
  p = c->proc;
8010475a:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104760:	e8 cb 04 00 00       	call   80104c30 <popcli>
  for(int i=0; i < myproc()->numOfPhysPages; i++){
80104765:	39 9e 80 03 00 00    	cmp    %ebx,0x380(%esi)
8010476b:	7e 73                	jle    801047e0 <choosePageToSwapOut+0xa0>
    last = tail; //removeTail();
8010476d:	8b 0d 20 3d 11 80    	mov    0x80113d20,%ecx
  return chosen->pte; //chosen->pmd->pte;
}

// Delets tha last element (tail) from the list, and the prev node becomes the tail
struct page_meta_data* removeTail(){
  struct page_meta_data* tempNode = head;
80104773:	8b 15 24 3d 11 80    	mov    0x80113d24,%edx
80104779:	eb 07                	jmp    80104782 <choosePageToSwapOut+0x42>
8010477b:	90                   	nop
8010477c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct page_meta_data* curTail = tail;
  while (tempNode->next != curTail){
80104780:	89 c2                	mov    %eax,%edx
80104782:	8b 42 14             	mov    0x14(%edx),%eax
80104785:	39 c1                	cmp    %eax,%ecx
80104787:	75 f7                	jne    80104780 <choosePageToSwapOut+0x40>
    tempNode = tempNode->next;
  }
  tempNode->next = 0; 
80104789:	c7 42 14 00 00 00 00 	movl   $0x0,0x14(%edx)
    uint* pgtab = last->pte;//last->pmd->pte;
80104790:	8b 41 04             	mov    0x4(%ecx),%eax
  tail = tempNode;
80104793:	89 15 20 3d 11 80    	mov    %edx,0x80113d20
    if(*pgtab & PTE_A){ // page was accessed
80104799:	8b 10                	mov    (%eax),%edx
8010479b:	f6 c2 20             	test   $0x20,%dl
8010479e:	74 38                	je     801047d8 <choosePageToSwapOut+0x98>
      (*pgtab) &= ~PTE_A; // clear bit and add to the list
801047a0:	83 e2 df             	and    $0xffffffdf,%edx
801047a3:	89 10                	mov    %edx,(%eax)


// Insert page to linked list in the first place
void insertNode(struct page_meta_data* pmd){
  //cprintf("insert node func\n");
  if(!head){ // empty list
801047a5:	a1 24 3d 11 80       	mov    0x80113d24,%eax
801047aa:	85 c0                	test   %eax,%eax
801047ac:	74 12                	je     801047c0 <choosePageToSwapOut+0x80>
    tail = pmd;
    pmd->next = 0;
    //cprintf("first node");
  }else{ // insert node to the head of the list
    //cprintf("list of proc is NOT empty\n", myproc()->pid);
    pmd->next = head;
801047ae:	89 41 14             	mov    %eax,0x14(%ecx)
    head = pmd;
801047b1:	89 0d 24 3d 11 80    	mov    %ecx,0x80113d24
  for(int i=0; i < myproc()->numOfPhysPages; i++){
801047b7:	83 c3 01             	add    $0x1,%ebx
801047ba:	eb 94                	jmp    80104750 <choosePageToSwapOut+0x10>
801047bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    head = pmd;
801047c0:	89 0d 24 3d 11 80    	mov    %ecx,0x80113d24
    tail = pmd;
801047c6:	89 0d 20 3d 11 80    	mov    %ecx,0x80113d20
    pmd->next = 0;
801047cc:	c7 41 14 00 00 00 00 	movl   $0x0,0x14(%ecx)
801047d3:	eb e2                	jmp    801047b7 <choosePageToSwapOut+0x77>
801047d5:	8d 76 00             	lea    0x0(%esi),%esi
}
801047d8:	5b                   	pop    %ebx
801047d9:	5e                   	pop    %esi
801047da:	5d                   	pop    %ebp
801047db:	c3                   	ret    
801047dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return chosen->pte; //chosen->pmd->pte;
801047e0:	a1 04 00 00 00       	mov    0x4,%eax
801047e5:	0f 0b                	ud2    
801047e7:	89 f6                	mov    %esi,%esi
801047e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047f0 <removeTail>:
struct page_meta_data* removeTail(){
801047f0:	55                   	push   %ebp
  struct page_meta_data* tempNode = head;
801047f1:	a1 24 3d 11 80       	mov    0x80113d24,%eax
  struct page_meta_data* curTail = tail;
801047f6:	8b 0d 20 3d 11 80    	mov    0x80113d20,%ecx
struct page_meta_data* removeTail(){
801047fc:	89 e5                	mov    %esp,%ebp
  while (tempNode->next != curTail){
801047fe:	eb 02                	jmp    80104802 <removeTail+0x12>
80104800:	89 d0                	mov    %edx,%eax
80104802:	8b 50 14             	mov    0x14(%eax),%edx
80104805:	39 ca                	cmp    %ecx,%edx
80104807:	75 f7                	jne    80104800 <removeTail+0x10>
  tempNode->next = 0; 
80104809:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  tail = tempNode;
80104810:	a3 20 3d 11 80       	mov    %eax,0x80113d20
}
80104815:	5d                   	pop    %ebp
80104816:	c3                   	ret    
80104817:	89 f6                	mov    %esi,%esi
80104819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104820 <swapOut>:
int swapOut(){
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	57                   	push   %edi
80104824:	56                   	push   %esi
80104825:	53                   	push   %ebx
80104826:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104829:	e8 02 03 00 00       	call   80104b30 <pushcli>
  c = mycpu();
8010482e:	e8 6d f4 ff ff       	call   80103ca0 <mycpu>
  p = c->proc;
80104833:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104839:	e8 f2 03 00 00       	call   80104c30 <popcli>
  uint* pte = choosePageToSwapOut();
8010483e:	e8 fd fe ff ff       	call   80104740 <choosePageToSwapOut>
  char* pa = (char*)(PTE_ADDR(*pte));
80104843:	8b 38                	mov    (%eax),%edi
80104845:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
  for (int i=0; i<MAX_PSYC_PAGES; i++){ // find cell that isn't occupied in the array
8010484b:	31 d2                	xor    %edx,%edx
  char* pa = (char*)(PTE_ADDR(*pte));
8010484d:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  char* va = (char*)(P2V((uint)(pa)));
80104853:	8d 9f 00 00 00 80    	lea    -0x80000000(%edi),%ebx
80104859:	eb 10                	jmp    8010486b <swapOut+0x4b>
8010485b:	90                   	nop
8010485c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (int i=0; i<MAX_PSYC_PAGES; i++){ // find cell that isn't occupied in the array
80104860:	83 c2 01             	add    $0x1,%edx
80104863:	83 c1 18             	add    $0x18,%ecx
80104866:	83 fa 10             	cmp    $0x10,%edx
80104869:	74 55                	je     801048c0 <swapOut+0xa0>
    if (curProc->procSwappedFiles[i].isOccupied == 0){
8010486b:	83 39 00             	cmpl   $0x0,(%ecx)
8010486e:	75 f0                	jne    80104860 <swapOut+0x40>
      curProc->procSwappedFiles[i].pte = pte;
80104870:	8d 14 52             	lea    (%edx,%edx,2),%edx
80104873:	8d 14 d6             	lea    (%esi,%edx,8),%edx
80104876:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
      offset = curProc->procSwappedFiles[i].offsetInFile;
8010487c:	8b 82 88 00 00 00    	mov    0x88(%edx),%eax
  if (offset == -1)
80104882:	83 f8 ff             	cmp    $0xffffffff,%eax
80104885:	74 39                	je     801048c0 <swapOut+0xa0>
  offset = writeToSwapFile(curProc, (char*)pa, offset, PGSIZE);
80104887:	68 00 10 00 00       	push   $0x1000
8010488c:	50                   	push   %eax
  kfree((char*)V2P(va)); // Free the page of physical memory pointed at by the virtualAdd
8010488d:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
  offset = writeToSwapFile(curProc, (char*)pa, offset, PGSIZE);
80104893:	57                   	push   %edi
80104894:	56                   	push   %esi
80104895:	e8 46 da ff ff       	call   801022e0 <writeToSwapFile>
  kfree((char*)V2P(va)); // Free the page of physical memory pointed at by the virtualAdd
8010489a:	89 1c 24             	mov    %ebx,(%esp)
  offset = writeToSwapFile(curProc, (char*)pa, offset, PGSIZE);
8010489d:	89 c7                	mov    %eax,%edi
  kfree((char*)V2P(va)); // Free the page of physical memory pointed at by the virtualAdd
8010489f:	e8 5c df ff ff       	call   80102800 <kfree>
  curProc->numOfPhysPages--;
801048a4:	83 ae 80 03 00 00 01 	subl   $0x1,0x380(%esi)
  curProc->numOfDiskPages++;
801048ab:	83 86 84 03 00 00 01 	addl   $0x1,0x384(%esi)
  return offset;
801048b2:	83 c4 10             	add    $0x10,%esp
}
801048b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048b8:	89 f8                	mov    %edi,%eax
801048ba:	5b                   	pop    %ebx
801048bb:	5e                   	pop    %esi
801048bc:	5f                   	pop    %edi
801048bd:	5d                   	pop    %ebp
801048be:	c3                   	ret    
801048bf:	90                   	nop
801048c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801048c3:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801048c8:	89 f8                	mov    %edi,%eax
801048ca:	5b                   	pop    %ebx
801048cb:	5e                   	pop    %esi
801048cc:	5f                   	pop    %edi
801048cd:	5d                   	pop    %ebp
801048ce:	c3                   	ret    
801048cf:	90                   	nop

801048d0 <swap>:
int swap(uint *pte, uint faultAdd){
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	53                   	push   %ebx
801048d4:	83 ec 04             	sub    $0x4,%esp
  if (swapOut() < 0) panic("problem with swapping out file");
801048d7:	e8 44 ff ff ff       	call   80104820 <swapOut>
801048dc:	85 c0                	test   %eax,%eax
801048de:	78 38                	js     80104918 <swap+0x48>
  pushcli();
801048e0:	e8 4b 02 00 00       	call   80104b30 <pushcli>
  c = mycpu();
801048e5:	e8 b6 f3 ff ff       	call   80103ca0 <mycpu>
  p = c->proc;
801048ea:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801048f0:	e8 3b 03 00 00       	call   80104c30 <popcli>
  lcr3(V2P(myproc()->pgdir)); // Refresh TLB after page-out
801048f5:	8b 43 04             	mov    0x4(%ebx),%eax
801048f8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801048fd:	0f 22 d8             	mov    %eax,%cr3
  swapIn(pte, faultAdd);
80104900:	83 ec 08             	sub    $0x8,%esp
80104903:	ff 75 0c             	pushl  0xc(%ebp)
80104906:	ff 75 08             	pushl  0x8(%ebp)
80104909:	e8 82 2f 00 00       	call   80107890 <swapIn>
}
8010490e:	b8 01 00 00 00       	mov    $0x1,%eax
80104913:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104916:	c9                   	leave  
80104917:	c3                   	ret    
  if (swapOut() < 0) panic("problem with swapping out file");
80104918:	83 ec 0c             	sub    $0xc,%esp
8010491b:	68 04 81 10 80       	push   $0x80108104
80104920:	e8 6b ba ff ff       	call   80100390 <panic>
80104925:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104930 <insertNode>:
  if(!head){ // empty list
80104930:	8b 15 24 3d 11 80    	mov    0x80113d24,%edx
void insertNode(struct page_meta_data* pmd){
80104936:	55                   	push   %ebp
80104937:	89 e5                	mov    %esp,%ebp
  if(!head){ // empty list
80104939:	85 d2                	test   %edx,%edx
void insertNode(struct page_meta_data* pmd){
8010493b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!head){ // empty list
8010493e:	74 10                	je     80104950 <insertNode+0x20>
    pmd->next = head;
80104940:	89 50 14             	mov    %edx,0x14(%eax)
    head = pmd;
80104943:	a3 24 3d 11 80       	mov    %eax,0x80113d24
    //   cprintf("address of node is %p", tempNodeForTestsing);
    //   tempNodeForTestsing = tempNodeForTestsing->next;
    // }
    
  }
}
80104948:	5d                   	pop    %ebp
80104949:	c3                   	ret    
8010494a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pmd->next = 0;
80104950:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    head = pmd;
80104957:	a3 24 3d 11 80       	mov    %eax,0x80113d24
    tail = pmd;
8010495c:	a3 20 3d 11 80       	mov    %eax,0x80113d20
}
80104961:	5d                   	pop    %ebp
80104962:	c3                   	ret    
80104963:	66 90                	xchg   %ax,%ax
80104965:	66 90                	xchg   %ax,%ax
80104967:	66 90                	xchg   %ax,%ax
80104969:	66 90                	xchg   %ax,%ax
8010496b:	66 90                	xchg   %ax,%ax
8010496d:	66 90                	xchg   %ax,%ax
8010496f:	90                   	nop

80104970 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	53                   	push   %ebx
80104974:	83 ec 0c             	sub    $0xc,%esp
80104977:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010497a:	68 3c 81 10 80       	push   $0x8010813c
8010497f:	8d 43 04             	lea    0x4(%ebx),%eax
80104982:	50                   	push   %eax
80104983:	e8 f8 00 00 00       	call   80104a80 <initlock>
  lk->name = name;
80104988:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010498b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104991:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104994:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010499b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010499e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049a1:	c9                   	leave  
801049a2:	c3                   	ret    
801049a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049b0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	56                   	push   %esi
801049b4:	53                   	push   %ebx
801049b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801049b8:	83 ec 0c             	sub    $0xc,%esp
801049bb:	8d 73 04             	lea    0x4(%ebx),%esi
801049be:	56                   	push   %esi
801049bf:	e8 ac 01 00 00       	call   80104b70 <acquire>
  while (lk->locked) {
801049c4:	8b 13                	mov    (%ebx),%edx
801049c6:	83 c4 10             	add    $0x10,%esp
801049c9:	85 d2                	test   %edx,%edx
801049cb:	74 16                	je     801049e3 <acquiresleep+0x33>
801049cd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801049d0:	83 ec 08             	sub    $0x8,%esp
801049d3:	56                   	push   %esi
801049d4:	53                   	push   %ebx
801049d5:	e8 36 f9 ff ff       	call   80104310 <sleep>
  while (lk->locked) {
801049da:	8b 03                	mov    (%ebx),%eax
801049dc:	83 c4 10             	add    $0x10,%esp
801049df:	85 c0                	test   %eax,%eax
801049e1:	75 ed                	jne    801049d0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801049e3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801049e9:	e8 52 f3 ff ff       	call   80103d40 <myproc>
801049ee:	8b 40 10             	mov    0x10(%eax),%eax
801049f1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801049f4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801049f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049fa:	5b                   	pop    %ebx
801049fb:	5e                   	pop    %esi
801049fc:	5d                   	pop    %ebp
  release(&lk->lk);
801049fd:	e9 8e 02 00 00       	jmp    80104c90 <release>
80104a02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a10 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	56                   	push   %esi
80104a14:	53                   	push   %ebx
80104a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a18:	83 ec 0c             	sub    $0xc,%esp
80104a1b:	8d 73 04             	lea    0x4(%ebx),%esi
80104a1e:	56                   	push   %esi
80104a1f:	e8 4c 01 00 00       	call   80104b70 <acquire>
  lk->locked = 0;
80104a24:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104a2a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104a31:	89 1c 24             	mov    %ebx,(%esp)
80104a34:	e8 97 fa ff ff       	call   801044d0 <wakeup>
  release(&lk->lk);
80104a39:	89 75 08             	mov    %esi,0x8(%ebp)
80104a3c:	83 c4 10             	add    $0x10,%esp
}
80104a3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a42:	5b                   	pop    %ebx
80104a43:	5e                   	pop    %esi
80104a44:	5d                   	pop    %ebp
  release(&lk->lk);
80104a45:	e9 46 02 00 00       	jmp    80104c90 <release>
80104a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a50 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	56                   	push   %esi
80104a54:	53                   	push   %ebx
80104a55:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104a58:	83 ec 0c             	sub    $0xc,%esp
80104a5b:	8d 5e 04             	lea    0x4(%esi),%ebx
80104a5e:	53                   	push   %ebx
80104a5f:	e8 0c 01 00 00       	call   80104b70 <acquire>
  r = lk->locked;
80104a64:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104a66:	89 1c 24             	mov    %ebx,(%esp)
80104a69:	e8 22 02 00 00       	call   80104c90 <release>
  return r;
}
80104a6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a71:	89 f0                	mov    %esi,%eax
80104a73:	5b                   	pop    %ebx
80104a74:	5e                   	pop    %esi
80104a75:	5d                   	pop    %ebp
80104a76:	c3                   	ret    
80104a77:	66 90                	xchg   %ax,%ax
80104a79:	66 90                	xchg   %ax,%ax
80104a7b:	66 90                	xchg   %ax,%ax
80104a7d:	66 90                	xchg   %ax,%ax
80104a7f:	90                   	nop

80104a80 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104a86:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104a89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104a8f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104a92:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104a99:	5d                   	pop    %ebp
80104a9a:	c3                   	ret    
80104a9b:	90                   	nop
80104a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104aa0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104aa0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104aa1:	31 d2                	xor    %edx,%edx
{
80104aa3:	89 e5                	mov    %esp,%ebp
80104aa5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104aa6:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104aa9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104aac:	83 e8 08             	sub    $0x8,%eax
80104aaf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ab0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104ab6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104abc:	77 1a                	ja     80104ad8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104abe:	8b 58 04             	mov    0x4(%eax),%ebx
80104ac1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104ac4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104ac7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104ac9:	83 fa 0a             	cmp    $0xa,%edx
80104acc:	75 e2                	jne    80104ab0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104ace:	5b                   	pop    %ebx
80104acf:	5d                   	pop    %ebp
80104ad0:	c3                   	ret    
80104ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ad8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104adb:	83 c1 28             	add    $0x28,%ecx
80104ade:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104ae0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104ae6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104ae9:	39 c1                	cmp    %eax,%ecx
80104aeb:	75 f3                	jne    80104ae0 <getcallerpcs+0x40>
}
80104aed:	5b                   	pop    %ebx
80104aee:	5d                   	pop    %ebp
80104aef:	c3                   	ret    

80104af0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	53                   	push   %ebx
80104af4:	83 ec 04             	sub    $0x4,%esp
80104af7:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
80104afa:	8b 02                	mov    (%edx),%eax
80104afc:	85 c0                	test   %eax,%eax
80104afe:	75 10                	jne    80104b10 <holding+0x20>
}
80104b00:	83 c4 04             	add    $0x4,%esp
80104b03:	31 c0                	xor    %eax,%eax
80104b05:	5b                   	pop    %ebx
80104b06:	5d                   	pop    %ebp
80104b07:	c3                   	ret    
80104b08:	90                   	nop
80104b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104b10:	8b 5a 08             	mov    0x8(%edx),%ebx
80104b13:	e8 88 f1 ff ff       	call   80103ca0 <mycpu>
80104b18:	39 c3                	cmp    %eax,%ebx
80104b1a:	0f 94 c0             	sete   %al
}
80104b1d:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104b20:	0f b6 c0             	movzbl %al,%eax
}
80104b23:	5b                   	pop    %ebx
80104b24:	5d                   	pop    %ebp
80104b25:	c3                   	ret    
80104b26:	8d 76 00             	lea    0x0(%esi),%esi
80104b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b30 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	53                   	push   %ebx
80104b34:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b37:	9c                   	pushf  
80104b38:	5b                   	pop    %ebx
  asm volatile("cli");
80104b39:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104b3a:	e8 61 f1 ff ff       	call   80103ca0 <mycpu>
80104b3f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b45:	85 c0                	test   %eax,%eax
80104b47:	75 11                	jne    80104b5a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104b49:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104b4f:	e8 4c f1 ff ff       	call   80103ca0 <mycpu>
80104b54:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104b5a:	e8 41 f1 ff ff       	call   80103ca0 <mycpu>
80104b5f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104b66:	83 c4 04             	add    $0x4,%esp
80104b69:	5b                   	pop    %ebx
80104b6a:	5d                   	pop    %ebp
80104b6b:	c3                   	ret    
80104b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b70 <acquire>:
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	56                   	push   %esi
80104b74:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104b75:	e8 b6 ff ff ff       	call   80104b30 <pushcli>
  if(holding(lk))
80104b7a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104b7d:	8b 03                	mov    (%ebx),%eax
80104b7f:	85 c0                	test   %eax,%eax
80104b81:	0f 85 81 00 00 00    	jne    80104c08 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
80104b87:	ba 01 00 00 00       	mov    $0x1,%edx
80104b8c:	eb 05                	jmp    80104b93 <acquire+0x23>
80104b8e:	66 90                	xchg   %ax,%ax
80104b90:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b93:	89 d0                	mov    %edx,%eax
80104b95:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104b98:	85 c0                	test   %eax,%eax
80104b9a:	75 f4                	jne    80104b90 <acquire+0x20>
  __sync_synchronize();
80104b9c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104ba1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ba4:	e8 f7 f0 ff ff       	call   80103ca0 <mycpu>
  for(i = 0; i < 10; i++){
80104ba9:	31 d2                	xor    %edx,%edx
  getcallerpcs(&lk, lk->pcs);
80104bab:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  lk->cpu = mycpu();
80104bae:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104bb1:	89 e8                	mov    %ebp,%eax
80104bb3:	90                   	nop
80104bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104bb8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104bbe:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104bc4:	77 1a                	ja     80104be0 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
80104bc6:	8b 58 04             	mov    0x4(%eax),%ebx
80104bc9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104bcc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104bcf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104bd1:	83 fa 0a             	cmp    $0xa,%edx
80104bd4:	75 e2                	jne    80104bb8 <acquire+0x48>
}
80104bd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bd9:	5b                   	pop    %ebx
80104bda:	5e                   	pop    %esi
80104bdb:	5d                   	pop    %ebp
80104bdc:	c3                   	ret    
80104bdd:	8d 76 00             	lea    0x0(%esi),%esi
80104be0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104be3:	83 c1 28             	add    $0x28,%ecx
80104be6:	8d 76 00             	lea    0x0(%esi),%esi
80104be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104bf0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104bf6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104bf9:	39 c8                	cmp    %ecx,%eax
80104bfb:	75 f3                	jne    80104bf0 <acquire+0x80>
}
80104bfd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c00:	5b                   	pop    %ebx
80104c01:	5e                   	pop    %esi
80104c02:	5d                   	pop    %ebp
80104c03:	c3                   	ret    
80104c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104c08:	8b 73 08             	mov    0x8(%ebx),%esi
80104c0b:	e8 90 f0 ff ff       	call   80103ca0 <mycpu>
80104c10:	39 c6                	cmp    %eax,%esi
80104c12:	0f 85 6f ff ff ff    	jne    80104b87 <acquire+0x17>
    panic("acquire");
80104c18:	83 ec 0c             	sub    $0xc,%esp
80104c1b:	68 47 81 10 80       	push   $0x80108147
80104c20:	e8 6b b7 ff ff       	call   80100390 <panic>
80104c25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c30 <popcli>:

void
popcli(void)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104c36:	9c                   	pushf  
80104c37:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104c38:	f6 c4 02             	test   $0x2,%ah
80104c3b:	75 35                	jne    80104c72 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104c3d:	e8 5e f0 ff ff       	call   80103ca0 <mycpu>
80104c42:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104c49:	78 34                	js     80104c7f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c4b:	e8 50 f0 ff ff       	call   80103ca0 <mycpu>
80104c50:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104c56:	85 d2                	test   %edx,%edx
80104c58:	74 06                	je     80104c60 <popcli+0x30>
    sti();
}
80104c5a:	c9                   	leave  
80104c5b:	c3                   	ret    
80104c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c60:	e8 3b f0 ff ff       	call   80103ca0 <mycpu>
80104c65:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104c6b:	85 c0                	test   %eax,%eax
80104c6d:	74 eb                	je     80104c5a <popcli+0x2a>
  asm volatile("sti");
80104c6f:	fb                   	sti    
}
80104c70:	c9                   	leave  
80104c71:	c3                   	ret    
    panic("popcli - interruptible");
80104c72:	83 ec 0c             	sub    $0xc,%esp
80104c75:	68 4f 81 10 80       	push   $0x8010814f
80104c7a:	e8 11 b7 ff ff       	call   80100390 <panic>
    panic("popcli");
80104c7f:	83 ec 0c             	sub    $0xc,%esp
80104c82:	68 66 81 10 80       	push   $0x80108166
80104c87:	e8 04 b7 ff ff       	call   80100390 <panic>
80104c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c90 <release>:
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	56                   	push   %esi
80104c94:	53                   	push   %ebx
80104c95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104c98:	8b 03                	mov    (%ebx),%eax
80104c9a:	85 c0                	test   %eax,%eax
80104c9c:	74 0c                	je     80104caa <release+0x1a>
80104c9e:	8b 73 08             	mov    0x8(%ebx),%esi
80104ca1:	e8 fa ef ff ff       	call   80103ca0 <mycpu>
80104ca6:	39 c6                	cmp    %eax,%esi
80104ca8:	74 16                	je     80104cc0 <release+0x30>
    panic("release");
80104caa:	83 ec 0c             	sub    $0xc,%esp
80104cad:	68 6d 81 10 80       	push   $0x8010816d
80104cb2:	e8 d9 b6 ff ff       	call   80100390 <panic>
80104cb7:	89 f6                	mov    %esi,%esi
80104cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lk->pcs[0] = 0;
80104cc0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104cc7:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104cce:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104cd3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104cd9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cdc:	5b                   	pop    %ebx
80104cdd:	5e                   	pop    %esi
80104cde:	5d                   	pop    %ebp
  popcli();
80104cdf:	e9 4c ff ff ff       	jmp    80104c30 <popcli>
80104ce4:	66 90                	xchg   %ax,%ax
80104ce6:	66 90                	xchg   %ax,%ax
80104ce8:	66 90                	xchg   %ax,%ax
80104cea:	66 90                	xchg   %ax,%ax
80104cec:	66 90                	xchg   %ax,%ax
80104cee:	66 90                	xchg   %ax,%ax

80104cf0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	57                   	push   %edi
80104cf4:	53                   	push   %ebx
80104cf5:	8b 55 08             	mov    0x8(%ebp),%edx
80104cf8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104cfb:	f6 c2 03             	test   $0x3,%dl
80104cfe:	75 05                	jne    80104d05 <memset+0x15>
80104d00:	f6 c1 03             	test   $0x3,%cl
80104d03:	74 13                	je     80104d18 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104d05:	89 d7                	mov    %edx,%edi
80104d07:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d0a:	fc                   	cld    
80104d0b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104d0d:	5b                   	pop    %ebx
80104d0e:	89 d0                	mov    %edx,%eax
80104d10:	5f                   	pop    %edi
80104d11:	5d                   	pop    %ebp
80104d12:	c3                   	ret    
80104d13:	90                   	nop
80104d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104d18:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104d1c:	c1 e9 02             	shr    $0x2,%ecx
80104d1f:	89 f8                	mov    %edi,%eax
80104d21:	89 fb                	mov    %edi,%ebx
80104d23:	c1 e0 18             	shl    $0x18,%eax
80104d26:	c1 e3 10             	shl    $0x10,%ebx
80104d29:	09 d8                	or     %ebx,%eax
80104d2b:	09 f8                	or     %edi,%eax
80104d2d:	c1 e7 08             	shl    $0x8,%edi
80104d30:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104d32:	89 d7                	mov    %edx,%edi
80104d34:	fc                   	cld    
80104d35:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104d37:	5b                   	pop    %ebx
80104d38:	89 d0                	mov    %edx,%eax
80104d3a:	5f                   	pop    %edi
80104d3b:	5d                   	pop    %ebp
80104d3c:	c3                   	ret    
80104d3d:	8d 76 00             	lea    0x0(%esi),%esi

80104d40 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	57                   	push   %edi
80104d44:	56                   	push   %esi
80104d45:	53                   	push   %ebx
80104d46:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104d49:	8b 75 08             	mov    0x8(%ebp),%esi
80104d4c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d4f:	85 db                	test   %ebx,%ebx
80104d51:	74 29                	je     80104d7c <memcmp+0x3c>
    if(*s1 != *s2)
80104d53:	0f b6 16             	movzbl (%esi),%edx
80104d56:	0f b6 0f             	movzbl (%edi),%ecx
80104d59:	38 d1                	cmp    %dl,%cl
80104d5b:	75 2b                	jne    80104d88 <memcmp+0x48>
80104d5d:	b8 01 00 00 00       	mov    $0x1,%eax
80104d62:	eb 14                	jmp    80104d78 <memcmp+0x38>
80104d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d68:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104d6c:	83 c0 01             	add    $0x1,%eax
80104d6f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104d74:	38 ca                	cmp    %cl,%dl
80104d76:	75 10                	jne    80104d88 <memcmp+0x48>
  while(n-- > 0){
80104d78:	39 d8                	cmp    %ebx,%eax
80104d7a:	75 ec                	jne    80104d68 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104d7c:	5b                   	pop    %ebx
  return 0;
80104d7d:	31 c0                	xor    %eax,%eax
}
80104d7f:	5e                   	pop    %esi
80104d80:	5f                   	pop    %edi
80104d81:	5d                   	pop    %ebp
80104d82:	c3                   	ret    
80104d83:	90                   	nop
80104d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104d88:	0f b6 c2             	movzbl %dl,%eax
}
80104d8b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104d8c:	29 c8                	sub    %ecx,%eax
}
80104d8e:	5e                   	pop    %esi
80104d8f:	5f                   	pop    %edi
80104d90:	5d                   	pop    %ebp
80104d91:	c3                   	ret    
80104d92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104da0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	56                   	push   %esi
80104da4:	53                   	push   %ebx
80104da5:	8b 45 08             	mov    0x8(%ebp),%eax
80104da8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104dab:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104dae:	39 c3                	cmp    %eax,%ebx
80104db0:	73 26                	jae    80104dd8 <memmove+0x38>
80104db2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104db5:	39 c8                	cmp    %ecx,%eax
80104db7:	73 1f                	jae    80104dd8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104db9:	85 f6                	test   %esi,%esi
80104dbb:	8d 56 ff             	lea    -0x1(%esi),%edx
80104dbe:	74 0f                	je     80104dcf <memmove+0x2f>
      *--d = *--s;
80104dc0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104dc4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104dc7:	83 ea 01             	sub    $0x1,%edx
80104dca:	83 fa ff             	cmp    $0xffffffff,%edx
80104dcd:	75 f1                	jne    80104dc0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104dcf:	5b                   	pop    %ebx
80104dd0:	5e                   	pop    %esi
80104dd1:	5d                   	pop    %ebp
80104dd2:	c3                   	ret    
80104dd3:	90                   	nop
80104dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104dd8:	31 d2                	xor    %edx,%edx
80104dda:	85 f6                	test   %esi,%esi
80104ddc:	74 f1                	je     80104dcf <memmove+0x2f>
80104dde:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104de0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104de4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104de7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104dea:	39 d6                	cmp    %edx,%esi
80104dec:	75 f2                	jne    80104de0 <memmove+0x40>
}
80104dee:	5b                   	pop    %ebx
80104def:	5e                   	pop    %esi
80104df0:	5d                   	pop    %ebp
80104df1:	c3                   	ret    
80104df2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e00 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104e03:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104e04:	eb 9a                	jmp    80104da0 <memmove>
80104e06:	8d 76 00             	lea    0x0(%esi),%esi
80104e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e10 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	57                   	push   %edi
80104e14:	56                   	push   %esi
80104e15:	8b 7d 10             	mov    0x10(%ebp),%edi
80104e18:	53                   	push   %ebx
80104e19:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104e1f:	85 ff                	test   %edi,%edi
80104e21:	74 2f                	je     80104e52 <strncmp+0x42>
80104e23:	0f b6 01             	movzbl (%ecx),%eax
80104e26:	0f b6 1e             	movzbl (%esi),%ebx
80104e29:	84 c0                	test   %al,%al
80104e2b:	74 37                	je     80104e64 <strncmp+0x54>
80104e2d:	38 c3                	cmp    %al,%bl
80104e2f:	75 33                	jne    80104e64 <strncmp+0x54>
80104e31:	01 f7                	add    %esi,%edi
80104e33:	eb 13                	jmp    80104e48 <strncmp+0x38>
80104e35:	8d 76 00             	lea    0x0(%esi),%esi
80104e38:	0f b6 01             	movzbl (%ecx),%eax
80104e3b:	84 c0                	test   %al,%al
80104e3d:	74 21                	je     80104e60 <strncmp+0x50>
80104e3f:	0f b6 1a             	movzbl (%edx),%ebx
80104e42:	89 d6                	mov    %edx,%esi
80104e44:	38 d8                	cmp    %bl,%al
80104e46:	75 1c                	jne    80104e64 <strncmp+0x54>
    n--, p++, q++;
80104e48:	8d 56 01             	lea    0x1(%esi),%edx
80104e4b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104e4e:	39 fa                	cmp    %edi,%edx
80104e50:	75 e6                	jne    80104e38 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104e52:	5b                   	pop    %ebx
    return 0;
80104e53:	31 c0                	xor    %eax,%eax
}
80104e55:	5e                   	pop    %esi
80104e56:	5f                   	pop    %edi
80104e57:	5d                   	pop    %ebp
80104e58:	c3                   	ret    
80104e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e60:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104e64:	29 d8                	sub    %ebx,%eax
}
80104e66:	5b                   	pop    %ebx
80104e67:	5e                   	pop    %esi
80104e68:	5f                   	pop    %edi
80104e69:	5d                   	pop    %ebp
80104e6a:	c3                   	ret    
80104e6b:	90                   	nop
80104e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e70 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	56                   	push   %esi
80104e74:	53                   	push   %ebx
80104e75:	8b 45 08             	mov    0x8(%ebp),%eax
80104e78:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104e7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104e7e:	89 c2                	mov    %eax,%edx
80104e80:	eb 19                	jmp    80104e9b <strncpy+0x2b>
80104e82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e88:	83 c3 01             	add    $0x1,%ebx
80104e8b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104e8f:	83 c2 01             	add    $0x1,%edx
80104e92:	84 c9                	test   %cl,%cl
80104e94:	88 4a ff             	mov    %cl,-0x1(%edx)
80104e97:	74 09                	je     80104ea2 <strncpy+0x32>
80104e99:	89 f1                	mov    %esi,%ecx
80104e9b:	85 c9                	test   %ecx,%ecx
80104e9d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104ea0:	7f e6                	jg     80104e88 <strncpy+0x18>
    ;
  while(n-- > 0)
80104ea2:	31 c9                	xor    %ecx,%ecx
80104ea4:	85 f6                	test   %esi,%esi
80104ea6:	7e 17                	jle    80104ebf <strncpy+0x4f>
80104ea8:	90                   	nop
80104ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104eb0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104eb4:	89 f3                	mov    %esi,%ebx
80104eb6:	83 c1 01             	add    $0x1,%ecx
80104eb9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104ebb:	85 db                	test   %ebx,%ebx
80104ebd:	7f f1                	jg     80104eb0 <strncpy+0x40>
  return os;
}
80104ebf:	5b                   	pop    %ebx
80104ec0:	5e                   	pop    %esi
80104ec1:	5d                   	pop    %ebp
80104ec2:	c3                   	ret    
80104ec3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ed0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	56                   	push   %esi
80104ed4:	53                   	push   %ebx
80104ed5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104ed8:	8b 45 08             	mov    0x8(%ebp),%eax
80104edb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104ede:	85 c9                	test   %ecx,%ecx
80104ee0:	7e 26                	jle    80104f08 <safestrcpy+0x38>
80104ee2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104ee6:	89 c1                	mov    %eax,%ecx
80104ee8:	eb 17                	jmp    80104f01 <safestrcpy+0x31>
80104eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ef0:	83 c2 01             	add    $0x1,%edx
80104ef3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104ef7:	83 c1 01             	add    $0x1,%ecx
80104efa:	84 db                	test   %bl,%bl
80104efc:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104eff:	74 04                	je     80104f05 <safestrcpy+0x35>
80104f01:	39 f2                	cmp    %esi,%edx
80104f03:	75 eb                	jne    80104ef0 <safestrcpy+0x20>
    ;
  *s = 0;
80104f05:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104f08:	5b                   	pop    %ebx
80104f09:	5e                   	pop    %esi
80104f0a:	5d                   	pop    %ebp
80104f0b:	c3                   	ret    
80104f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f10 <strlen>:

int
strlen(const char *s)
{
80104f10:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104f11:	31 c0                	xor    %eax,%eax
{
80104f13:	89 e5                	mov    %esp,%ebp
80104f15:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104f18:	80 3a 00             	cmpb   $0x0,(%edx)
80104f1b:	74 0c                	je     80104f29 <strlen+0x19>
80104f1d:	8d 76 00             	lea    0x0(%esi),%esi
80104f20:	83 c0 01             	add    $0x1,%eax
80104f23:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104f27:	75 f7                	jne    80104f20 <strlen+0x10>
    ;
  return n;
}
80104f29:	5d                   	pop    %ebp
80104f2a:	c3                   	ret    

80104f2b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104f2b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104f2f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104f33:	55                   	push   %ebp
  pushl %ebx
80104f34:	53                   	push   %ebx
  pushl %esi
80104f35:	56                   	push   %esi
  pushl %edi
80104f36:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104f37:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104f39:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104f3b:	5f                   	pop    %edi
  popl %esi
80104f3c:	5e                   	pop    %esi
  popl %ebx
80104f3d:	5b                   	pop    %ebx
  popl %ebp
80104f3e:	5d                   	pop    %ebp
  ret
80104f3f:	c3                   	ret    

80104f40 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	53                   	push   %ebx
80104f44:	83 ec 04             	sub    $0x4,%esp
80104f47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104f4a:	e8 f1 ed ff ff       	call   80103d40 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f4f:	8b 00                	mov    (%eax),%eax
80104f51:	39 d8                	cmp    %ebx,%eax
80104f53:	76 1b                	jbe    80104f70 <fetchint+0x30>
80104f55:	8d 53 04             	lea    0x4(%ebx),%edx
80104f58:	39 d0                	cmp    %edx,%eax
80104f5a:	72 14                	jb     80104f70 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f5f:	8b 13                	mov    (%ebx),%edx
80104f61:	89 10                	mov    %edx,(%eax)
  return 0;
80104f63:	31 c0                	xor    %eax,%eax
}
80104f65:	83 c4 04             	add    $0x4,%esp
80104f68:	5b                   	pop    %ebx
80104f69:	5d                   	pop    %ebp
80104f6a:	c3                   	ret    
80104f6b:	90                   	nop
80104f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104f70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f75:	eb ee                	jmp    80104f65 <fetchint+0x25>
80104f77:	89 f6                	mov    %esi,%esi
80104f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f80 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	53                   	push   %ebx
80104f84:	83 ec 04             	sub    $0x4,%esp
80104f87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104f8a:	e8 b1 ed ff ff       	call   80103d40 <myproc>

  if(addr >= curproc->sz)
80104f8f:	39 18                	cmp    %ebx,(%eax)
80104f91:	76 29                	jbe    80104fbc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104f93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104f96:	89 da                	mov    %ebx,%edx
80104f98:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104f9a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104f9c:	39 c3                	cmp    %eax,%ebx
80104f9e:	73 1c                	jae    80104fbc <fetchstr+0x3c>
    if(*s == 0)
80104fa0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104fa3:	75 10                	jne    80104fb5 <fetchstr+0x35>
80104fa5:	eb 39                	jmp    80104fe0 <fetchstr+0x60>
80104fa7:	89 f6                	mov    %esi,%esi
80104fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104fb0:	80 3a 00             	cmpb   $0x0,(%edx)
80104fb3:	74 1b                	je     80104fd0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104fb5:	83 c2 01             	add    $0x1,%edx
80104fb8:	39 d0                	cmp    %edx,%eax
80104fba:	77 f4                	ja     80104fb0 <fetchstr+0x30>
    return -1;
80104fbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104fc1:	83 c4 04             	add    $0x4,%esp
80104fc4:	5b                   	pop    %ebx
80104fc5:	5d                   	pop    %ebp
80104fc6:	c3                   	ret    
80104fc7:	89 f6                	mov    %esi,%esi
80104fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104fd0:	83 c4 04             	add    $0x4,%esp
80104fd3:	89 d0                	mov    %edx,%eax
80104fd5:	29 d8                	sub    %ebx,%eax
80104fd7:	5b                   	pop    %ebx
80104fd8:	5d                   	pop    %ebp
80104fd9:	c3                   	ret    
80104fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104fe0:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104fe2:	eb dd                	jmp    80104fc1 <fetchstr+0x41>
80104fe4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104ff0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	56                   	push   %esi
80104ff4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ff5:	e8 46 ed ff ff       	call   80103d40 <myproc>
80104ffa:	8b 40 18             	mov    0x18(%eax),%eax
80104ffd:	8b 55 08             	mov    0x8(%ebp),%edx
80105000:	8b 40 44             	mov    0x44(%eax),%eax
80105003:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105006:	e8 35 ed ff ff       	call   80103d40 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010500b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010500d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105010:	39 c6                	cmp    %eax,%esi
80105012:	73 1c                	jae    80105030 <argint+0x40>
80105014:	8d 53 08             	lea    0x8(%ebx),%edx
80105017:	39 d0                	cmp    %edx,%eax
80105019:	72 15                	jb     80105030 <argint+0x40>
  *ip = *(int*)(addr);
8010501b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010501e:	8b 53 04             	mov    0x4(%ebx),%edx
80105021:	89 10                	mov    %edx,(%eax)
  return 0;
80105023:	31 c0                	xor    %eax,%eax
}
80105025:	5b                   	pop    %ebx
80105026:	5e                   	pop    %esi
80105027:	5d                   	pop    %ebp
80105028:	c3                   	ret    
80105029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105035:	eb ee                	jmp    80105025 <argint+0x35>
80105037:	89 f6                	mov    %esi,%esi
80105039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105040 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	56                   	push   %esi
80105044:	53                   	push   %ebx
80105045:	83 ec 10             	sub    $0x10,%esp
80105048:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010504b:	e8 f0 ec ff ff       	call   80103d40 <myproc>
80105050:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105052:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105055:	83 ec 08             	sub    $0x8,%esp
80105058:	50                   	push   %eax
80105059:	ff 75 08             	pushl  0x8(%ebp)
8010505c:	e8 8f ff ff ff       	call   80104ff0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105061:	83 c4 10             	add    $0x10,%esp
80105064:	85 c0                	test   %eax,%eax
80105066:	78 28                	js     80105090 <argptr+0x50>
80105068:	85 db                	test   %ebx,%ebx
8010506a:	78 24                	js     80105090 <argptr+0x50>
8010506c:	8b 16                	mov    (%esi),%edx
8010506e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105071:	39 c2                	cmp    %eax,%edx
80105073:	76 1b                	jbe    80105090 <argptr+0x50>
80105075:	01 c3                	add    %eax,%ebx
80105077:	39 da                	cmp    %ebx,%edx
80105079:	72 15                	jb     80105090 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010507b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010507e:	89 02                	mov    %eax,(%edx)
  return 0;
80105080:	31 c0                	xor    %eax,%eax
}
80105082:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105085:	5b                   	pop    %ebx
80105086:	5e                   	pop    %esi
80105087:	5d                   	pop    %ebp
80105088:	c3                   	ret    
80105089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105090:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105095:	eb eb                	jmp    80105082 <argptr+0x42>
80105097:	89 f6                	mov    %esi,%esi
80105099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050a0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801050a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050a9:	50                   	push   %eax
801050aa:	ff 75 08             	pushl  0x8(%ebp)
801050ad:	e8 3e ff ff ff       	call   80104ff0 <argint>
801050b2:	83 c4 10             	add    $0x10,%esp
801050b5:	85 c0                	test   %eax,%eax
801050b7:	78 17                	js     801050d0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801050b9:	83 ec 08             	sub    $0x8,%esp
801050bc:	ff 75 0c             	pushl  0xc(%ebp)
801050bf:	ff 75 f4             	pushl  -0xc(%ebp)
801050c2:	e8 b9 fe ff ff       	call   80104f80 <fetchstr>
801050c7:	83 c4 10             	add    $0x10,%esp
}
801050ca:	c9                   	leave  
801050cb:	c3                   	ret    
801050cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801050d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050d5:	c9                   	leave  
801050d6:	c3                   	ret    
801050d7:	89 f6                	mov    %esi,%esi
801050d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050e0 <syscall>:
[SYS_protectPage] sys_protectPage,
};

void
syscall(void)
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	53                   	push   %ebx
801050e4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801050e7:	e8 54 ec ff ff       	call   80103d40 <myproc>
801050ec:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801050ee:	8b 40 18             	mov    0x18(%eax),%eax
801050f1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801050f4:	8d 50 ff             	lea    -0x1(%eax),%edx
801050f7:	83 fa 16             	cmp    $0x16,%edx
801050fa:	77 1c                	ja     80105118 <syscall+0x38>
801050fc:	8b 14 85 a0 81 10 80 	mov    -0x7fef7e60(,%eax,4),%edx
80105103:	85 d2                	test   %edx,%edx
80105105:	74 11                	je     80105118 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105107:	ff d2                	call   *%edx
80105109:	8b 53 18             	mov    0x18(%ebx),%edx
8010510c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010510f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105112:	c9                   	leave  
80105113:	c3                   	ret    
80105114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105118:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105119:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010511c:	50                   	push   %eax
8010511d:	ff 73 10             	pushl  0x10(%ebx)
80105120:	68 75 81 10 80       	push   $0x80108175
80105125:	e8 36 b5 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010512a:	8b 43 18             	mov    0x18(%ebx),%eax
8010512d:	83 c4 10             	add    $0x10,%esp
80105130:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105137:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010513a:	c9                   	leave  
8010513b:	c3                   	ret    
8010513c:	66 90                	xchg   %ax,%ax
8010513e:	66 90                	xchg   %ax,%ax

80105140 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	56                   	push   %esi
80105144:	53                   	push   %ebx
80105145:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105147:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010514a:	89 d6                	mov    %edx,%esi
8010514c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010514f:	50                   	push   %eax
80105150:	6a 00                	push   $0x0
80105152:	e8 99 fe ff ff       	call   80104ff0 <argint>
80105157:	83 c4 10             	add    $0x10,%esp
8010515a:	85 c0                	test   %eax,%eax
8010515c:	78 2a                	js     80105188 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010515e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105162:	77 24                	ja     80105188 <argfd.constprop.0+0x48>
80105164:	e8 d7 eb ff ff       	call   80103d40 <myproc>
80105169:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010516c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105170:	85 c0                	test   %eax,%eax
80105172:	74 14                	je     80105188 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80105174:	85 db                	test   %ebx,%ebx
80105176:	74 02                	je     8010517a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105178:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
8010517a:	89 06                	mov    %eax,(%esi)
  return 0;
8010517c:	31 c0                	xor    %eax,%eax
}
8010517e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105181:	5b                   	pop    %ebx
80105182:	5e                   	pop    %esi
80105183:	5d                   	pop    %ebp
80105184:	c3                   	ret    
80105185:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105188:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010518d:	eb ef                	jmp    8010517e <argfd.constprop.0+0x3e>
8010518f:	90                   	nop

80105190 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105190:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105191:	31 c0                	xor    %eax,%eax
{
80105193:	89 e5                	mov    %esp,%ebp
80105195:	56                   	push   %esi
80105196:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105197:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010519a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010519d:	e8 9e ff ff ff       	call   80105140 <argfd.constprop.0>
801051a2:	85 c0                	test   %eax,%eax
801051a4:	78 42                	js     801051e8 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
801051a6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801051a9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801051ab:	e8 90 eb ff ff       	call   80103d40 <myproc>
801051b0:	eb 0e                	jmp    801051c0 <sys_dup+0x30>
801051b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801051b8:	83 c3 01             	add    $0x1,%ebx
801051bb:	83 fb 10             	cmp    $0x10,%ebx
801051be:	74 28                	je     801051e8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
801051c0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801051c4:	85 d2                	test   %edx,%edx
801051c6:	75 f0                	jne    801051b8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
801051c8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
801051cc:	83 ec 0c             	sub    $0xc,%esp
801051cf:	ff 75 f4             	pushl  -0xc(%ebp)
801051d2:	e8 99 bc ff ff       	call   80100e70 <filedup>
  return fd;
801051d7:	83 c4 10             	add    $0x10,%esp
}
801051da:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051dd:	89 d8                	mov    %ebx,%eax
801051df:	5b                   	pop    %ebx
801051e0:	5e                   	pop    %esi
801051e1:	5d                   	pop    %ebp
801051e2:	c3                   	ret    
801051e3:	90                   	nop
801051e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801051eb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801051f0:	89 d8                	mov    %ebx,%eax
801051f2:	5b                   	pop    %ebx
801051f3:	5e                   	pop    %esi
801051f4:	5d                   	pop    %ebp
801051f5:	c3                   	ret    
801051f6:	8d 76 00             	lea    0x0(%esi),%esi
801051f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105200 <sys_read>:

int
sys_read(void)
{
80105200:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105201:	31 c0                	xor    %eax,%eax
{
80105203:	89 e5                	mov    %esp,%ebp
80105205:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105208:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010520b:	e8 30 ff ff ff       	call   80105140 <argfd.constprop.0>
80105210:	85 c0                	test   %eax,%eax
80105212:	78 4c                	js     80105260 <sys_read+0x60>
80105214:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105217:	83 ec 08             	sub    $0x8,%esp
8010521a:	50                   	push   %eax
8010521b:	6a 02                	push   $0x2
8010521d:	e8 ce fd ff ff       	call   80104ff0 <argint>
80105222:	83 c4 10             	add    $0x10,%esp
80105225:	85 c0                	test   %eax,%eax
80105227:	78 37                	js     80105260 <sys_read+0x60>
80105229:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010522c:	83 ec 04             	sub    $0x4,%esp
8010522f:	ff 75 f0             	pushl  -0x10(%ebp)
80105232:	50                   	push   %eax
80105233:	6a 01                	push   $0x1
80105235:	e8 06 fe ff ff       	call   80105040 <argptr>
8010523a:	83 c4 10             	add    $0x10,%esp
8010523d:	85 c0                	test   %eax,%eax
8010523f:	78 1f                	js     80105260 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105241:	83 ec 04             	sub    $0x4,%esp
80105244:	ff 75 f0             	pushl  -0x10(%ebp)
80105247:	ff 75 f4             	pushl  -0xc(%ebp)
8010524a:	ff 75 ec             	pushl  -0x14(%ebp)
8010524d:	e8 8e bd ff ff       	call   80100fe0 <fileread>
80105252:	83 c4 10             	add    $0x10,%esp
}
80105255:	c9                   	leave  
80105256:	c3                   	ret    
80105257:	89 f6                	mov    %esi,%esi
80105259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105260:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105265:	c9                   	leave  
80105266:	c3                   	ret    
80105267:	89 f6                	mov    %esi,%esi
80105269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105270 <sys_write>:

int
sys_write(void)
{
80105270:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105271:	31 c0                	xor    %eax,%eax
{
80105273:	89 e5                	mov    %esp,%ebp
80105275:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105278:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010527b:	e8 c0 fe ff ff       	call   80105140 <argfd.constprop.0>
80105280:	85 c0                	test   %eax,%eax
80105282:	78 4c                	js     801052d0 <sys_write+0x60>
80105284:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105287:	83 ec 08             	sub    $0x8,%esp
8010528a:	50                   	push   %eax
8010528b:	6a 02                	push   $0x2
8010528d:	e8 5e fd ff ff       	call   80104ff0 <argint>
80105292:	83 c4 10             	add    $0x10,%esp
80105295:	85 c0                	test   %eax,%eax
80105297:	78 37                	js     801052d0 <sys_write+0x60>
80105299:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010529c:	83 ec 04             	sub    $0x4,%esp
8010529f:	ff 75 f0             	pushl  -0x10(%ebp)
801052a2:	50                   	push   %eax
801052a3:	6a 01                	push   $0x1
801052a5:	e8 96 fd ff ff       	call   80105040 <argptr>
801052aa:	83 c4 10             	add    $0x10,%esp
801052ad:	85 c0                	test   %eax,%eax
801052af:	78 1f                	js     801052d0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
801052b1:	83 ec 04             	sub    $0x4,%esp
801052b4:	ff 75 f0             	pushl  -0x10(%ebp)
801052b7:	ff 75 f4             	pushl  -0xc(%ebp)
801052ba:	ff 75 ec             	pushl  -0x14(%ebp)
801052bd:	e8 ae bd ff ff       	call   80101070 <filewrite>
801052c2:	83 c4 10             	add    $0x10,%esp
}
801052c5:	c9                   	leave  
801052c6:	c3                   	ret    
801052c7:	89 f6                	mov    %esi,%esi
801052c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801052d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052d5:	c9                   	leave  
801052d6:	c3                   	ret    
801052d7:	89 f6                	mov    %esi,%esi
801052d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052e0 <sys_close>:

int
sys_close(void)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801052e6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801052e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052ec:	e8 4f fe ff ff       	call   80105140 <argfd.constprop.0>
801052f1:	85 c0                	test   %eax,%eax
801052f3:	78 2b                	js     80105320 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
801052f5:	e8 46 ea ff ff       	call   80103d40 <myproc>
801052fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801052fd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105300:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105307:	00 
  fileclose(f);
80105308:	ff 75 f4             	pushl  -0xc(%ebp)
8010530b:	e8 b0 bb ff ff       	call   80100ec0 <fileclose>
  return 0;
80105310:	83 c4 10             	add    $0x10,%esp
80105313:	31 c0                	xor    %eax,%eax
}
80105315:	c9                   	leave  
80105316:	c3                   	ret    
80105317:	89 f6                	mov    %esi,%esi
80105319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105325:	c9                   	leave  
80105326:	c3                   	ret    
80105327:	89 f6                	mov    %esi,%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105330 <sys_fstat>:

int
sys_fstat(void)
{
80105330:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105331:	31 c0                	xor    %eax,%eax
{
80105333:	89 e5                	mov    %esp,%ebp
80105335:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105338:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010533b:	e8 00 fe ff ff       	call   80105140 <argfd.constprop.0>
80105340:	85 c0                	test   %eax,%eax
80105342:	78 2c                	js     80105370 <sys_fstat+0x40>
80105344:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105347:	83 ec 04             	sub    $0x4,%esp
8010534a:	6a 14                	push   $0x14
8010534c:	50                   	push   %eax
8010534d:	6a 01                	push   $0x1
8010534f:	e8 ec fc ff ff       	call   80105040 <argptr>
80105354:	83 c4 10             	add    $0x10,%esp
80105357:	85 c0                	test   %eax,%eax
80105359:	78 15                	js     80105370 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010535b:	83 ec 08             	sub    $0x8,%esp
8010535e:	ff 75 f4             	pushl  -0xc(%ebp)
80105361:	ff 75 f0             	pushl  -0x10(%ebp)
80105364:	e8 27 bc ff ff       	call   80100f90 <filestat>
80105369:	83 c4 10             	add    $0x10,%esp
}
8010536c:	c9                   	leave  
8010536d:	c3                   	ret    
8010536e:	66 90                	xchg   %ax,%ax
    return -1;
80105370:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105375:	c9                   	leave  
80105376:	c3                   	ret    
80105377:	89 f6                	mov    %esi,%esi
80105379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105380 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	57                   	push   %edi
80105384:	56                   	push   %esi
80105385:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105386:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105389:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010538c:	50                   	push   %eax
8010538d:	6a 00                	push   $0x0
8010538f:	e8 0c fd ff ff       	call   801050a0 <argstr>
80105394:	83 c4 10             	add    $0x10,%esp
80105397:	85 c0                	test   %eax,%eax
80105399:	0f 88 fb 00 00 00    	js     8010549a <sys_link+0x11a>
8010539f:	8d 45 d0             	lea    -0x30(%ebp),%eax
801053a2:	83 ec 08             	sub    $0x8,%esp
801053a5:	50                   	push   %eax
801053a6:	6a 01                	push   $0x1
801053a8:	e8 f3 fc ff ff       	call   801050a0 <argstr>
801053ad:	83 c4 10             	add    $0x10,%esp
801053b0:	85 c0                	test   %eax,%eax
801053b2:	0f 88 e2 00 00 00    	js     8010549a <sys_link+0x11a>
    return -1;

  begin_op();
801053b8:	e8 d3 dc ff ff       	call   80103090 <begin_op>
  if((ip = namei(old)) == 0){
801053bd:	83 ec 0c             	sub    $0xc,%esp
801053c0:	ff 75 d4             	pushl  -0x2c(%ebp)
801053c3:	e8 a8 cb ff ff       	call   80101f70 <namei>
801053c8:	83 c4 10             	add    $0x10,%esp
801053cb:	85 c0                	test   %eax,%eax
801053cd:	89 c3                	mov    %eax,%ebx
801053cf:	0f 84 ea 00 00 00    	je     801054bf <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
801053d5:	83 ec 0c             	sub    $0xc,%esp
801053d8:	50                   	push   %eax
801053d9:	e8 32 c3 ff ff       	call   80101710 <ilock>
  if(ip->type == T_DIR){
801053de:	83 c4 10             	add    $0x10,%esp
801053e1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053e6:	0f 84 bb 00 00 00    	je     801054a7 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
801053ec:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801053f1:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
801053f4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801053f7:	53                   	push   %ebx
801053f8:	e8 63 c2 ff ff       	call   80101660 <iupdate>
  iunlock(ip);
801053fd:	89 1c 24             	mov    %ebx,(%esp)
80105400:	e8 eb c3 ff ff       	call   801017f0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105405:	58                   	pop    %eax
80105406:	5a                   	pop    %edx
80105407:	57                   	push   %edi
80105408:	ff 75 d0             	pushl  -0x30(%ebp)
8010540b:	e8 80 cb ff ff       	call   80101f90 <nameiparent>
80105410:	83 c4 10             	add    $0x10,%esp
80105413:	85 c0                	test   %eax,%eax
80105415:	89 c6                	mov    %eax,%esi
80105417:	74 5b                	je     80105474 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105419:	83 ec 0c             	sub    $0xc,%esp
8010541c:	50                   	push   %eax
8010541d:	e8 ee c2 ff ff       	call   80101710 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105422:	83 c4 10             	add    $0x10,%esp
80105425:	8b 03                	mov    (%ebx),%eax
80105427:	39 06                	cmp    %eax,(%esi)
80105429:	75 3d                	jne    80105468 <sys_link+0xe8>
8010542b:	83 ec 04             	sub    $0x4,%esp
8010542e:	ff 73 04             	pushl  0x4(%ebx)
80105431:	57                   	push   %edi
80105432:	56                   	push   %esi
80105433:	e8 78 ca ff ff       	call   80101eb0 <dirlink>
80105438:	83 c4 10             	add    $0x10,%esp
8010543b:	85 c0                	test   %eax,%eax
8010543d:	78 29                	js     80105468 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010543f:	83 ec 0c             	sub    $0xc,%esp
80105442:	56                   	push   %esi
80105443:	e8 58 c5 ff ff       	call   801019a0 <iunlockput>
  iput(ip);
80105448:	89 1c 24             	mov    %ebx,(%esp)
8010544b:	e8 f0 c3 ff ff       	call   80101840 <iput>

  end_op();
80105450:	e8 ab dc ff ff       	call   80103100 <end_op>

  return 0;
80105455:	83 c4 10             	add    $0x10,%esp
80105458:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010545a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010545d:	5b                   	pop    %ebx
8010545e:	5e                   	pop    %esi
8010545f:	5f                   	pop    %edi
80105460:	5d                   	pop    %ebp
80105461:	c3                   	ret    
80105462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105468:	83 ec 0c             	sub    $0xc,%esp
8010546b:	56                   	push   %esi
8010546c:	e8 2f c5 ff ff       	call   801019a0 <iunlockput>
    goto bad;
80105471:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105474:	83 ec 0c             	sub    $0xc,%esp
80105477:	53                   	push   %ebx
80105478:	e8 93 c2 ff ff       	call   80101710 <ilock>
  ip->nlink--;
8010547d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105482:	89 1c 24             	mov    %ebx,(%esp)
80105485:	e8 d6 c1 ff ff       	call   80101660 <iupdate>
  iunlockput(ip);
8010548a:	89 1c 24             	mov    %ebx,(%esp)
8010548d:	e8 0e c5 ff ff       	call   801019a0 <iunlockput>
  end_op();
80105492:	e8 69 dc ff ff       	call   80103100 <end_op>
  return -1;
80105497:	83 c4 10             	add    $0x10,%esp
}
8010549a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010549d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054a2:	5b                   	pop    %ebx
801054a3:	5e                   	pop    %esi
801054a4:	5f                   	pop    %edi
801054a5:	5d                   	pop    %ebp
801054a6:	c3                   	ret    
    iunlockput(ip);
801054a7:	83 ec 0c             	sub    $0xc,%esp
801054aa:	53                   	push   %ebx
801054ab:	e8 f0 c4 ff ff       	call   801019a0 <iunlockput>
    end_op();
801054b0:	e8 4b dc ff ff       	call   80103100 <end_op>
    return -1;
801054b5:	83 c4 10             	add    $0x10,%esp
801054b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054bd:	eb 9b                	jmp    8010545a <sys_link+0xda>
    end_op();
801054bf:	e8 3c dc ff ff       	call   80103100 <end_op>
    return -1;
801054c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054c9:	eb 8f                	jmp    8010545a <sys_link+0xda>
801054cb:	90                   	nop
801054cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054d0 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	57                   	push   %edi
801054d4:	56                   	push   %esi
801054d5:	53                   	push   %ebx
801054d6:	83 ec 1c             	sub    $0x1c,%esp
801054d9:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801054dc:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
801054e0:	76 3e                	jbe    80105520 <isdirempty+0x50>
801054e2:	bb 20 00 00 00       	mov    $0x20,%ebx
801054e7:	8d 7d d8             	lea    -0x28(%ebp),%edi
801054ea:	eb 0c                	jmp    801054f8 <isdirempty+0x28>
801054ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054f0:	83 c3 10             	add    $0x10,%ebx
801054f3:	3b 5e 58             	cmp    0x58(%esi),%ebx
801054f6:	73 28                	jae    80105520 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054f8:	6a 10                	push   $0x10
801054fa:	53                   	push   %ebx
801054fb:	57                   	push   %edi
801054fc:	56                   	push   %esi
801054fd:	e8 ee c4 ff ff       	call   801019f0 <readi>
80105502:	83 c4 10             	add    $0x10,%esp
80105505:	83 f8 10             	cmp    $0x10,%eax
80105508:	75 23                	jne    8010552d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010550a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010550f:	74 df                	je     801054f0 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105511:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105514:	31 c0                	xor    %eax,%eax
}
80105516:	5b                   	pop    %ebx
80105517:	5e                   	pop    %esi
80105518:	5f                   	pop    %edi
80105519:	5d                   	pop    %ebp
8010551a:	c3                   	ret    
8010551b:	90                   	nop
8010551c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105520:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105523:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105528:	5b                   	pop    %ebx
80105529:	5e                   	pop    %esi
8010552a:	5f                   	pop    %edi
8010552b:	5d                   	pop    %ebp
8010552c:	c3                   	ret    
      panic("isdirempty: readi");
8010552d:	83 ec 0c             	sub    $0xc,%esp
80105530:	68 00 82 10 80       	push   $0x80108200
80105535:	e8 56 ae ff ff       	call   80100390 <panic>
8010553a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105540 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	57                   	push   %edi
80105544:	56                   	push   %esi
80105545:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105546:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105549:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010554c:	50                   	push   %eax
8010554d:	6a 00                	push   $0x0
8010554f:	e8 4c fb ff ff       	call   801050a0 <argstr>
80105554:	83 c4 10             	add    $0x10,%esp
80105557:	85 c0                	test   %eax,%eax
80105559:	0f 88 51 01 00 00    	js     801056b0 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010555f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105562:	e8 29 db ff ff       	call   80103090 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105567:	83 ec 08             	sub    $0x8,%esp
8010556a:	53                   	push   %ebx
8010556b:	ff 75 c0             	pushl  -0x40(%ebp)
8010556e:	e8 1d ca ff ff       	call   80101f90 <nameiparent>
80105573:	83 c4 10             	add    $0x10,%esp
80105576:	85 c0                	test   %eax,%eax
80105578:	89 c6                	mov    %eax,%esi
8010557a:	0f 84 37 01 00 00    	je     801056b7 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
80105580:	83 ec 0c             	sub    $0xc,%esp
80105583:	50                   	push   %eax
80105584:	e8 87 c1 ff ff       	call   80101710 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105589:	58                   	pop    %eax
8010558a:	5a                   	pop    %edx
8010558b:	68 c5 7b 10 80       	push   $0x80107bc5
80105590:	53                   	push   %ebx
80105591:	e8 8a c6 ff ff       	call   80101c20 <namecmp>
80105596:	83 c4 10             	add    $0x10,%esp
80105599:	85 c0                	test   %eax,%eax
8010559b:	0f 84 d7 00 00 00    	je     80105678 <sys_unlink+0x138>
801055a1:	83 ec 08             	sub    $0x8,%esp
801055a4:	68 c4 7b 10 80       	push   $0x80107bc4
801055a9:	53                   	push   %ebx
801055aa:	e8 71 c6 ff ff       	call   80101c20 <namecmp>
801055af:	83 c4 10             	add    $0x10,%esp
801055b2:	85 c0                	test   %eax,%eax
801055b4:	0f 84 be 00 00 00    	je     80105678 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801055ba:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801055bd:	83 ec 04             	sub    $0x4,%esp
801055c0:	50                   	push   %eax
801055c1:	53                   	push   %ebx
801055c2:	56                   	push   %esi
801055c3:	e8 78 c6 ff ff       	call   80101c40 <dirlookup>
801055c8:	83 c4 10             	add    $0x10,%esp
801055cb:	85 c0                	test   %eax,%eax
801055cd:	89 c3                	mov    %eax,%ebx
801055cf:	0f 84 a3 00 00 00    	je     80105678 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
801055d5:	83 ec 0c             	sub    $0xc,%esp
801055d8:	50                   	push   %eax
801055d9:	e8 32 c1 ff ff       	call   80101710 <ilock>

  if(ip->nlink < 1)
801055de:	83 c4 10             	add    $0x10,%esp
801055e1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801055e6:	0f 8e e4 00 00 00    	jle    801056d0 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801055ec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055f1:	74 65                	je     80105658 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801055f3:	8d 7d d8             	lea    -0x28(%ebp),%edi
801055f6:	83 ec 04             	sub    $0x4,%esp
801055f9:	6a 10                	push   $0x10
801055fb:	6a 00                	push   $0x0
801055fd:	57                   	push   %edi
801055fe:	e8 ed f6 ff ff       	call   80104cf0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105603:	6a 10                	push   $0x10
80105605:	ff 75 c4             	pushl  -0x3c(%ebp)
80105608:	57                   	push   %edi
80105609:	56                   	push   %esi
8010560a:	e8 e1 c4 ff ff       	call   80101af0 <writei>
8010560f:	83 c4 20             	add    $0x20,%esp
80105612:	83 f8 10             	cmp    $0x10,%eax
80105615:	0f 85 a8 00 00 00    	jne    801056c3 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010561b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105620:	74 6e                	je     80105690 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105622:	83 ec 0c             	sub    $0xc,%esp
80105625:	56                   	push   %esi
80105626:	e8 75 c3 ff ff       	call   801019a0 <iunlockput>

  ip->nlink--;
8010562b:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105630:	89 1c 24             	mov    %ebx,(%esp)
80105633:	e8 28 c0 ff ff       	call   80101660 <iupdate>
  iunlockput(ip);
80105638:	89 1c 24             	mov    %ebx,(%esp)
8010563b:	e8 60 c3 ff ff       	call   801019a0 <iunlockput>

  end_op();
80105640:	e8 bb da ff ff       	call   80103100 <end_op>

  return 0;
80105645:	83 c4 10             	add    $0x10,%esp
80105648:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010564a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010564d:	5b                   	pop    %ebx
8010564e:	5e                   	pop    %esi
8010564f:	5f                   	pop    %edi
80105650:	5d                   	pop    %ebp
80105651:	c3                   	ret    
80105652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105658:	83 ec 0c             	sub    $0xc,%esp
8010565b:	53                   	push   %ebx
8010565c:	e8 6f fe ff ff       	call   801054d0 <isdirempty>
80105661:	83 c4 10             	add    $0x10,%esp
80105664:	85 c0                	test   %eax,%eax
80105666:	75 8b                	jne    801055f3 <sys_unlink+0xb3>
    iunlockput(ip);
80105668:	83 ec 0c             	sub    $0xc,%esp
8010566b:	53                   	push   %ebx
8010566c:	e8 2f c3 ff ff       	call   801019a0 <iunlockput>
    goto bad;
80105671:	83 c4 10             	add    $0x10,%esp
80105674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105678:	83 ec 0c             	sub    $0xc,%esp
8010567b:	56                   	push   %esi
8010567c:	e8 1f c3 ff ff       	call   801019a0 <iunlockput>
  end_op();
80105681:	e8 7a da ff ff       	call   80103100 <end_op>
  return -1;
80105686:	83 c4 10             	add    $0x10,%esp
80105689:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010568e:	eb ba                	jmp    8010564a <sys_unlink+0x10a>
    dp->nlink--;
80105690:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105695:	83 ec 0c             	sub    $0xc,%esp
80105698:	56                   	push   %esi
80105699:	e8 c2 bf ff ff       	call   80101660 <iupdate>
8010569e:	83 c4 10             	add    $0x10,%esp
801056a1:	e9 7c ff ff ff       	jmp    80105622 <sys_unlink+0xe2>
801056a6:	8d 76 00             	lea    0x0(%esi),%esi
801056a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801056b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056b5:	eb 93                	jmp    8010564a <sys_unlink+0x10a>
    end_op();
801056b7:	e8 44 da ff ff       	call   80103100 <end_op>
    return -1;
801056bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056c1:	eb 87                	jmp    8010564a <sys_unlink+0x10a>
    panic("unlink: writei");
801056c3:	83 ec 0c             	sub    $0xc,%esp
801056c6:	68 d9 7b 10 80       	push   $0x80107bd9
801056cb:	e8 c0 ac ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801056d0:	83 ec 0c             	sub    $0xc,%esp
801056d3:	68 c7 7b 10 80       	push   $0x80107bc7
801056d8:	e8 b3 ac ff ff       	call   80100390 <panic>
801056dd:	8d 76 00             	lea    0x0(%esi),%esi

801056e0 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	57                   	push   %edi
801056e4:	56                   	push   %esi
801056e5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801056e6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
801056e9:	83 ec 44             	sub    $0x44,%esp
801056ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801056ef:	8b 55 10             	mov    0x10(%ebp),%edx
801056f2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801056f5:	56                   	push   %esi
801056f6:	ff 75 08             	pushl  0x8(%ebp)
{
801056f9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801056fc:	89 55 c0             	mov    %edx,-0x40(%ebp)
801056ff:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105702:	e8 89 c8 ff ff       	call   80101f90 <nameiparent>
80105707:	83 c4 10             	add    $0x10,%esp
8010570a:	85 c0                	test   %eax,%eax
8010570c:	0f 84 4e 01 00 00    	je     80105860 <create+0x180>
    return 0;
  ilock(dp);
80105712:	83 ec 0c             	sub    $0xc,%esp
80105715:	89 c3                	mov    %eax,%ebx
80105717:	50                   	push   %eax
80105718:	e8 f3 bf ff ff       	call   80101710 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
8010571d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105720:	83 c4 0c             	add    $0xc,%esp
80105723:	50                   	push   %eax
80105724:	56                   	push   %esi
80105725:	53                   	push   %ebx
80105726:	e8 15 c5 ff ff       	call   80101c40 <dirlookup>
8010572b:	83 c4 10             	add    $0x10,%esp
8010572e:	85 c0                	test   %eax,%eax
80105730:	89 c7                	mov    %eax,%edi
80105732:	74 3c                	je     80105770 <create+0x90>
    iunlockput(dp);
80105734:	83 ec 0c             	sub    $0xc,%esp
80105737:	53                   	push   %ebx
80105738:	e8 63 c2 ff ff       	call   801019a0 <iunlockput>
    ilock(ip);
8010573d:	89 3c 24             	mov    %edi,(%esp)
80105740:	e8 cb bf ff ff       	call   80101710 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105745:	83 c4 10             	add    $0x10,%esp
80105748:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
8010574d:	0f 85 9d 00 00 00    	jne    801057f0 <create+0x110>
80105753:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105758:	0f 85 92 00 00 00    	jne    801057f0 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010575e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105761:	89 f8                	mov    %edi,%eax
80105763:	5b                   	pop    %ebx
80105764:	5e                   	pop    %esi
80105765:	5f                   	pop    %edi
80105766:	5d                   	pop    %ebp
80105767:	c3                   	ret    
80105768:	90                   	nop
80105769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
80105770:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80105774:	83 ec 08             	sub    $0x8,%esp
80105777:	50                   	push   %eax
80105778:	ff 33                	pushl  (%ebx)
8010577a:	e8 21 be ff ff       	call   801015a0 <ialloc>
8010577f:	83 c4 10             	add    $0x10,%esp
80105782:	85 c0                	test   %eax,%eax
80105784:	89 c7                	mov    %eax,%edi
80105786:	0f 84 e8 00 00 00    	je     80105874 <create+0x194>
  ilock(ip);
8010578c:	83 ec 0c             	sub    $0xc,%esp
8010578f:	50                   	push   %eax
80105790:	e8 7b bf ff ff       	call   80101710 <ilock>
  ip->major = major;
80105795:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105799:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010579d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801057a1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
801057a5:	b8 01 00 00 00       	mov    $0x1,%eax
801057aa:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
801057ae:	89 3c 24             	mov    %edi,(%esp)
801057b1:	e8 aa be ff ff       	call   80101660 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801057b6:	83 c4 10             	add    $0x10,%esp
801057b9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801057be:	74 50                	je     80105810 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
801057c0:	83 ec 04             	sub    $0x4,%esp
801057c3:	ff 77 04             	pushl  0x4(%edi)
801057c6:	56                   	push   %esi
801057c7:	53                   	push   %ebx
801057c8:	e8 e3 c6 ff ff       	call   80101eb0 <dirlink>
801057cd:	83 c4 10             	add    $0x10,%esp
801057d0:	85 c0                	test   %eax,%eax
801057d2:	0f 88 8f 00 00 00    	js     80105867 <create+0x187>
  iunlockput(dp);
801057d8:	83 ec 0c             	sub    $0xc,%esp
801057db:	53                   	push   %ebx
801057dc:	e8 bf c1 ff ff       	call   801019a0 <iunlockput>
  return ip;
801057e1:	83 c4 10             	add    $0x10,%esp
}
801057e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057e7:	89 f8                	mov    %edi,%eax
801057e9:	5b                   	pop    %ebx
801057ea:	5e                   	pop    %esi
801057eb:	5f                   	pop    %edi
801057ec:	5d                   	pop    %ebp
801057ed:	c3                   	ret    
801057ee:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801057f0:	83 ec 0c             	sub    $0xc,%esp
801057f3:	57                   	push   %edi
    return 0;
801057f4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
801057f6:	e8 a5 c1 ff ff       	call   801019a0 <iunlockput>
    return 0;
801057fb:	83 c4 10             	add    $0x10,%esp
}
801057fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105801:	89 f8                	mov    %edi,%eax
80105803:	5b                   	pop    %ebx
80105804:	5e                   	pop    %esi
80105805:	5f                   	pop    %edi
80105806:	5d                   	pop    %ebp
80105807:	c3                   	ret    
80105808:	90                   	nop
80105809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105810:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105815:	83 ec 0c             	sub    $0xc,%esp
80105818:	53                   	push   %ebx
80105819:	e8 42 be ff ff       	call   80101660 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010581e:	83 c4 0c             	add    $0xc,%esp
80105821:	ff 77 04             	pushl  0x4(%edi)
80105824:	68 c5 7b 10 80       	push   $0x80107bc5
80105829:	57                   	push   %edi
8010582a:	e8 81 c6 ff ff       	call   80101eb0 <dirlink>
8010582f:	83 c4 10             	add    $0x10,%esp
80105832:	85 c0                	test   %eax,%eax
80105834:	78 1c                	js     80105852 <create+0x172>
80105836:	83 ec 04             	sub    $0x4,%esp
80105839:	ff 73 04             	pushl  0x4(%ebx)
8010583c:	68 c4 7b 10 80       	push   $0x80107bc4
80105841:	57                   	push   %edi
80105842:	e8 69 c6 ff ff       	call   80101eb0 <dirlink>
80105847:	83 c4 10             	add    $0x10,%esp
8010584a:	85 c0                	test   %eax,%eax
8010584c:	0f 89 6e ff ff ff    	jns    801057c0 <create+0xe0>
      panic("create dots");
80105852:	83 ec 0c             	sub    $0xc,%esp
80105855:	68 21 82 10 80       	push   $0x80108221
8010585a:	e8 31 ab ff ff       	call   80100390 <panic>
8010585f:	90                   	nop
    return 0;
80105860:	31 ff                	xor    %edi,%edi
80105862:	e9 f7 fe ff ff       	jmp    8010575e <create+0x7e>
    panic("create: dirlink");
80105867:	83 ec 0c             	sub    $0xc,%esp
8010586a:	68 2d 82 10 80       	push   $0x8010822d
8010586f:	e8 1c ab ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105874:	83 ec 0c             	sub    $0xc,%esp
80105877:	68 12 82 10 80       	push   $0x80108212
8010587c:	e8 0f ab ff ff       	call   80100390 <panic>
80105881:	eb 0d                	jmp    80105890 <sys_open>
80105883:	90                   	nop
80105884:	90                   	nop
80105885:	90                   	nop
80105886:	90                   	nop
80105887:	90                   	nop
80105888:	90                   	nop
80105889:	90                   	nop
8010588a:	90                   	nop
8010588b:	90                   	nop
8010588c:	90                   	nop
8010588d:	90                   	nop
8010588e:	90                   	nop
8010588f:	90                   	nop

80105890 <sys_open>:

int
sys_open(void)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	57                   	push   %edi
80105894:	56                   	push   %esi
80105895:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105896:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105899:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010589c:	50                   	push   %eax
8010589d:	6a 00                	push   $0x0
8010589f:	e8 fc f7 ff ff       	call   801050a0 <argstr>
801058a4:	83 c4 10             	add    $0x10,%esp
801058a7:	85 c0                	test   %eax,%eax
801058a9:	0f 88 1d 01 00 00    	js     801059cc <sys_open+0x13c>
801058af:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058b2:	83 ec 08             	sub    $0x8,%esp
801058b5:	50                   	push   %eax
801058b6:	6a 01                	push   $0x1
801058b8:	e8 33 f7 ff ff       	call   80104ff0 <argint>
801058bd:	83 c4 10             	add    $0x10,%esp
801058c0:	85 c0                	test   %eax,%eax
801058c2:	0f 88 04 01 00 00    	js     801059cc <sys_open+0x13c>
    return -1;

  begin_op();
801058c8:	e8 c3 d7 ff ff       	call   80103090 <begin_op>

  if(omode & O_CREATE){
801058cd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801058d1:	0f 85 a9 00 00 00    	jne    80105980 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801058d7:	83 ec 0c             	sub    $0xc,%esp
801058da:	ff 75 e0             	pushl  -0x20(%ebp)
801058dd:	e8 8e c6 ff ff       	call   80101f70 <namei>
801058e2:	83 c4 10             	add    $0x10,%esp
801058e5:	85 c0                	test   %eax,%eax
801058e7:	89 c6                	mov    %eax,%esi
801058e9:	0f 84 ac 00 00 00    	je     8010599b <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
801058ef:	83 ec 0c             	sub    $0xc,%esp
801058f2:	50                   	push   %eax
801058f3:	e8 18 be ff ff       	call   80101710 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801058f8:	83 c4 10             	add    $0x10,%esp
801058fb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105900:	0f 84 aa 00 00 00    	je     801059b0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105906:	e8 f5 b4 ff ff       	call   80100e00 <filealloc>
8010590b:	85 c0                	test   %eax,%eax
8010590d:	89 c7                	mov    %eax,%edi
8010590f:	0f 84 a6 00 00 00    	je     801059bb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105915:	e8 26 e4 ff ff       	call   80103d40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010591a:	31 db                	xor    %ebx,%ebx
8010591c:	eb 0e                	jmp    8010592c <sys_open+0x9c>
8010591e:	66 90                	xchg   %ax,%ax
80105920:	83 c3 01             	add    $0x1,%ebx
80105923:	83 fb 10             	cmp    $0x10,%ebx
80105926:	0f 84 ac 00 00 00    	je     801059d8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010592c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105930:	85 d2                	test   %edx,%edx
80105932:	75 ec                	jne    80105920 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105934:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105937:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010593b:	56                   	push   %esi
8010593c:	e8 af be ff ff       	call   801017f0 <iunlock>
  end_op();
80105941:	e8 ba d7 ff ff       	call   80103100 <end_op>

  f->type = FD_INODE;
80105946:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010594c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010594f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105952:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105955:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010595c:	89 d0                	mov    %edx,%eax
8010595e:	f7 d0                	not    %eax
80105960:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105963:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105966:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105969:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010596d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105970:	89 d8                	mov    %ebx,%eax
80105972:	5b                   	pop    %ebx
80105973:	5e                   	pop    %esi
80105974:	5f                   	pop    %edi
80105975:	5d                   	pop    %ebp
80105976:	c3                   	ret    
80105977:	89 f6                	mov    %esi,%esi
80105979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105980:	6a 00                	push   $0x0
80105982:	6a 00                	push   $0x0
80105984:	6a 02                	push   $0x2
80105986:	ff 75 e0             	pushl  -0x20(%ebp)
80105989:	e8 52 fd ff ff       	call   801056e0 <create>
    if(ip == 0){
8010598e:	83 c4 10             	add    $0x10,%esp
80105991:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105993:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105995:	0f 85 6b ff ff ff    	jne    80105906 <sys_open+0x76>
      end_op();
8010599b:	e8 60 d7 ff ff       	call   80103100 <end_op>
      return -1;
801059a0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059a5:	eb c6                	jmp    8010596d <sys_open+0xdd>
801059a7:	89 f6                	mov    %esi,%esi
801059a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
801059b0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801059b3:	85 c9                	test   %ecx,%ecx
801059b5:	0f 84 4b ff ff ff    	je     80105906 <sys_open+0x76>
    iunlockput(ip);
801059bb:	83 ec 0c             	sub    $0xc,%esp
801059be:	56                   	push   %esi
801059bf:	e8 dc bf ff ff       	call   801019a0 <iunlockput>
    end_op();
801059c4:	e8 37 d7 ff ff       	call   80103100 <end_op>
    return -1;
801059c9:	83 c4 10             	add    $0x10,%esp
801059cc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059d1:	eb 9a                	jmp    8010596d <sys_open+0xdd>
801059d3:	90                   	nop
801059d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801059d8:	83 ec 0c             	sub    $0xc,%esp
801059db:	57                   	push   %edi
801059dc:	e8 df b4 ff ff       	call   80100ec0 <fileclose>
801059e1:	83 c4 10             	add    $0x10,%esp
801059e4:	eb d5                	jmp    801059bb <sys_open+0x12b>
801059e6:	8d 76 00             	lea    0x0(%esi),%esi
801059e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059f0 <sys_mkdir>:

int
sys_mkdir(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801059f6:	e8 95 d6 ff ff       	call   80103090 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801059fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059fe:	83 ec 08             	sub    $0x8,%esp
80105a01:	50                   	push   %eax
80105a02:	6a 00                	push   $0x0
80105a04:	e8 97 f6 ff ff       	call   801050a0 <argstr>
80105a09:	83 c4 10             	add    $0x10,%esp
80105a0c:	85 c0                	test   %eax,%eax
80105a0e:	78 30                	js     80105a40 <sys_mkdir+0x50>
80105a10:	6a 00                	push   $0x0
80105a12:	6a 00                	push   $0x0
80105a14:	6a 01                	push   $0x1
80105a16:	ff 75 f4             	pushl  -0xc(%ebp)
80105a19:	e8 c2 fc ff ff       	call   801056e0 <create>
80105a1e:	83 c4 10             	add    $0x10,%esp
80105a21:	85 c0                	test   %eax,%eax
80105a23:	74 1b                	je     80105a40 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a25:	83 ec 0c             	sub    $0xc,%esp
80105a28:	50                   	push   %eax
80105a29:	e8 72 bf ff ff       	call   801019a0 <iunlockput>
  end_op();
80105a2e:	e8 cd d6 ff ff       	call   80103100 <end_op>
  return 0;
80105a33:	83 c4 10             	add    $0x10,%esp
80105a36:	31 c0                	xor    %eax,%eax
}
80105a38:	c9                   	leave  
80105a39:	c3                   	ret    
80105a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105a40:	e8 bb d6 ff ff       	call   80103100 <end_op>
    return -1;
80105a45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a4a:	c9                   	leave  
80105a4b:	c3                   	ret    
80105a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a50 <sys_mknod>:

int
sys_mknod(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105a56:	e8 35 d6 ff ff       	call   80103090 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105a5b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a5e:	83 ec 08             	sub    $0x8,%esp
80105a61:	50                   	push   %eax
80105a62:	6a 00                	push   $0x0
80105a64:	e8 37 f6 ff ff       	call   801050a0 <argstr>
80105a69:	83 c4 10             	add    $0x10,%esp
80105a6c:	85 c0                	test   %eax,%eax
80105a6e:	78 60                	js     80105ad0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105a70:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a73:	83 ec 08             	sub    $0x8,%esp
80105a76:	50                   	push   %eax
80105a77:	6a 01                	push   $0x1
80105a79:	e8 72 f5 ff ff       	call   80104ff0 <argint>
  if((argstr(0, &path)) < 0 ||
80105a7e:	83 c4 10             	add    $0x10,%esp
80105a81:	85 c0                	test   %eax,%eax
80105a83:	78 4b                	js     80105ad0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105a85:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a88:	83 ec 08             	sub    $0x8,%esp
80105a8b:	50                   	push   %eax
80105a8c:	6a 02                	push   $0x2
80105a8e:	e8 5d f5 ff ff       	call   80104ff0 <argint>
     argint(1, &major) < 0 ||
80105a93:	83 c4 10             	add    $0x10,%esp
80105a96:	85 c0                	test   %eax,%eax
80105a98:	78 36                	js     80105ad0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a9a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105a9e:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a9f:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
80105aa3:	50                   	push   %eax
80105aa4:	6a 03                	push   $0x3
80105aa6:	ff 75 ec             	pushl  -0x14(%ebp)
80105aa9:	e8 32 fc ff ff       	call   801056e0 <create>
80105aae:	83 c4 10             	add    $0x10,%esp
80105ab1:	85 c0                	test   %eax,%eax
80105ab3:	74 1b                	je     80105ad0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105ab5:	83 ec 0c             	sub    $0xc,%esp
80105ab8:	50                   	push   %eax
80105ab9:	e8 e2 be ff ff       	call   801019a0 <iunlockput>
  end_op();
80105abe:	e8 3d d6 ff ff       	call   80103100 <end_op>
  return 0;
80105ac3:	83 c4 10             	add    $0x10,%esp
80105ac6:	31 c0                	xor    %eax,%eax
}
80105ac8:	c9                   	leave  
80105ac9:	c3                   	ret    
80105aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105ad0:	e8 2b d6 ff ff       	call   80103100 <end_op>
    return -1;
80105ad5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ada:	c9                   	leave  
80105adb:	c3                   	ret    
80105adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ae0 <sys_chdir>:

int
sys_chdir(void)
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	56                   	push   %esi
80105ae4:	53                   	push   %ebx
80105ae5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105ae8:	e8 53 e2 ff ff       	call   80103d40 <myproc>
80105aed:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105aef:	e8 9c d5 ff ff       	call   80103090 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105af4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105af7:	83 ec 08             	sub    $0x8,%esp
80105afa:	50                   	push   %eax
80105afb:	6a 00                	push   $0x0
80105afd:	e8 9e f5 ff ff       	call   801050a0 <argstr>
80105b02:	83 c4 10             	add    $0x10,%esp
80105b05:	85 c0                	test   %eax,%eax
80105b07:	78 77                	js     80105b80 <sys_chdir+0xa0>
80105b09:	83 ec 0c             	sub    $0xc,%esp
80105b0c:	ff 75 f4             	pushl  -0xc(%ebp)
80105b0f:	e8 5c c4 ff ff       	call   80101f70 <namei>
80105b14:	83 c4 10             	add    $0x10,%esp
80105b17:	85 c0                	test   %eax,%eax
80105b19:	89 c3                	mov    %eax,%ebx
80105b1b:	74 63                	je     80105b80 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105b1d:	83 ec 0c             	sub    $0xc,%esp
80105b20:	50                   	push   %eax
80105b21:	e8 ea bb ff ff       	call   80101710 <ilock>
  if(ip->type != T_DIR){
80105b26:	83 c4 10             	add    $0x10,%esp
80105b29:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b2e:	75 30                	jne    80105b60 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b30:	83 ec 0c             	sub    $0xc,%esp
80105b33:	53                   	push   %ebx
80105b34:	e8 b7 bc ff ff       	call   801017f0 <iunlock>
  iput(curproc->cwd);
80105b39:	58                   	pop    %eax
80105b3a:	ff 76 68             	pushl  0x68(%esi)
80105b3d:	e8 fe bc ff ff       	call   80101840 <iput>
  end_op();
80105b42:	e8 b9 d5 ff ff       	call   80103100 <end_op>
  curproc->cwd = ip;
80105b47:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105b4a:	83 c4 10             	add    $0x10,%esp
80105b4d:	31 c0                	xor    %eax,%eax
}
80105b4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b52:	5b                   	pop    %ebx
80105b53:	5e                   	pop    %esi
80105b54:	5d                   	pop    %ebp
80105b55:	c3                   	ret    
80105b56:	8d 76 00             	lea    0x0(%esi),%esi
80105b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105b60:	83 ec 0c             	sub    $0xc,%esp
80105b63:	53                   	push   %ebx
80105b64:	e8 37 be ff ff       	call   801019a0 <iunlockput>
    end_op();
80105b69:	e8 92 d5 ff ff       	call   80103100 <end_op>
    return -1;
80105b6e:	83 c4 10             	add    $0x10,%esp
80105b71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b76:	eb d7                	jmp    80105b4f <sys_chdir+0x6f>
80105b78:	90                   	nop
80105b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105b80:	e8 7b d5 ff ff       	call   80103100 <end_op>
    return -1;
80105b85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b8a:	eb c3                	jmp    80105b4f <sys_chdir+0x6f>
80105b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b90 <sys_exec>:

int
sys_exec(void)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	57                   	push   %edi
80105b94:	56                   	push   %esi
80105b95:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b96:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105b9c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ba2:	50                   	push   %eax
80105ba3:	6a 00                	push   $0x0
80105ba5:	e8 f6 f4 ff ff       	call   801050a0 <argstr>
80105baa:	83 c4 10             	add    $0x10,%esp
80105bad:	85 c0                	test   %eax,%eax
80105baf:	0f 88 87 00 00 00    	js     80105c3c <sys_exec+0xac>
80105bb5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105bbb:	83 ec 08             	sub    $0x8,%esp
80105bbe:	50                   	push   %eax
80105bbf:	6a 01                	push   $0x1
80105bc1:	e8 2a f4 ff ff       	call   80104ff0 <argint>
80105bc6:	83 c4 10             	add    $0x10,%esp
80105bc9:	85 c0                	test   %eax,%eax
80105bcb:	78 6f                	js     80105c3c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105bcd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105bd3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105bd6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105bd8:	68 80 00 00 00       	push   $0x80
80105bdd:	6a 00                	push   $0x0
80105bdf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105be5:	50                   	push   %eax
80105be6:	e8 05 f1 ff ff       	call   80104cf0 <memset>
80105beb:	83 c4 10             	add    $0x10,%esp
80105bee:	eb 2c                	jmp    80105c1c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105bf0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105bf6:	85 c0                	test   %eax,%eax
80105bf8:	74 56                	je     80105c50 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105bfa:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105c00:	83 ec 08             	sub    $0x8,%esp
80105c03:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105c06:	52                   	push   %edx
80105c07:	50                   	push   %eax
80105c08:	e8 73 f3 ff ff       	call   80104f80 <fetchstr>
80105c0d:	83 c4 10             	add    $0x10,%esp
80105c10:	85 c0                	test   %eax,%eax
80105c12:	78 28                	js     80105c3c <sys_exec+0xac>
  for(i=0;; i++){
80105c14:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105c17:	83 fb 20             	cmp    $0x20,%ebx
80105c1a:	74 20                	je     80105c3c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105c1c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105c22:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105c29:	83 ec 08             	sub    $0x8,%esp
80105c2c:	57                   	push   %edi
80105c2d:	01 f0                	add    %esi,%eax
80105c2f:	50                   	push   %eax
80105c30:	e8 0b f3 ff ff       	call   80104f40 <fetchint>
80105c35:	83 c4 10             	add    $0x10,%esp
80105c38:	85 c0                	test   %eax,%eax
80105c3a:	79 b4                	jns    80105bf0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105c3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105c3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c44:	5b                   	pop    %ebx
80105c45:	5e                   	pop    %esi
80105c46:	5f                   	pop    %edi
80105c47:	5d                   	pop    %ebp
80105c48:	c3                   	ret    
80105c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105c50:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105c56:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105c59:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105c60:	00 00 00 00 
  return exec(path, argv);
80105c64:	50                   	push   %eax
80105c65:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105c6b:	e8 a0 ad ff ff       	call   80100a10 <exec>
80105c70:	83 c4 10             	add    $0x10,%esp
}
80105c73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c76:	5b                   	pop    %ebx
80105c77:	5e                   	pop    %esi
80105c78:	5f                   	pop    %edi
80105c79:	5d                   	pop    %ebp
80105c7a:	c3                   	ret    
80105c7b:	90                   	nop
80105c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c80 <sys_pipe>:

int
sys_pipe(void)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	57                   	push   %edi
80105c84:	56                   	push   %esi
80105c85:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c86:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105c89:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c8c:	6a 08                	push   $0x8
80105c8e:	50                   	push   %eax
80105c8f:	6a 00                	push   $0x0
80105c91:	e8 aa f3 ff ff       	call   80105040 <argptr>
80105c96:	83 c4 10             	add    $0x10,%esp
80105c99:	85 c0                	test   %eax,%eax
80105c9b:	0f 88 ae 00 00 00    	js     80105d4f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105ca1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ca4:	83 ec 08             	sub    $0x8,%esp
80105ca7:	50                   	push   %eax
80105ca8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105cab:	50                   	push   %eax
80105cac:	e8 7f da ff ff       	call   80103730 <pipealloc>
80105cb1:	83 c4 10             	add    $0x10,%esp
80105cb4:	85 c0                	test   %eax,%eax
80105cb6:	0f 88 93 00 00 00    	js     80105d4f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105cbc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105cbf:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105cc1:	e8 7a e0 ff ff       	call   80103d40 <myproc>
80105cc6:	eb 10                	jmp    80105cd8 <sys_pipe+0x58>
80105cc8:	90                   	nop
80105cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105cd0:	83 c3 01             	add    $0x1,%ebx
80105cd3:	83 fb 10             	cmp    $0x10,%ebx
80105cd6:	74 60                	je     80105d38 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105cd8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105cdc:	85 f6                	test   %esi,%esi
80105cde:	75 f0                	jne    80105cd0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105ce0:	8d 73 08             	lea    0x8(%ebx),%esi
80105ce3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ce7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105cea:	e8 51 e0 ff ff       	call   80103d40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105cef:	31 d2                	xor    %edx,%edx
80105cf1:	eb 0d                	jmp    80105d00 <sys_pipe+0x80>
80105cf3:	90                   	nop
80105cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cf8:	83 c2 01             	add    $0x1,%edx
80105cfb:	83 fa 10             	cmp    $0x10,%edx
80105cfe:	74 28                	je     80105d28 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105d00:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105d04:	85 c9                	test   %ecx,%ecx
80105d06:	75 f0                	jne    80105cf8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105d08:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105d0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d0f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105d11:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d14:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105d17:	31 c0                	xor    %eax,%eax
}
80105d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d1c:	5b                   	pop    %ebx
80105d1d:	5e                   	pop    %esi
80105d1e:	5f                   	pop    %edi
80105d1f:	5d                   	pop    %ebp
80105d20:	c3                   	ret    
80105d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105d28:	e8 13 e0 ff ff       	call   80103d40 <myproc>
80105d2d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105d34:	00 
80105d35:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105d38:	83 ec 0c             	sub    $0xc,%esp
80105d3b:	ff 75 e0             	pushl  -0x20(%ebp)
80105d3e:	e8 7d b1 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
80105d43:	58                   	pop    %eax
80105d44:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d47:	e8 74 b1 ff ff       	call   80100ec0 <fileclose>
    return -1;
80105d4c:	83 c4 10             	add    $0x10,%esp
80105d4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d54:	eb c3                	jmp    80105d19 <sys_pipe+0x99>
80105d56:	66 90                	xchg   %ax,%ax
80105d58:	66 90                	xchg   %ax,%ax
80105d5a:	66 90                	xchg   %ax,%ax
80105d5c:	66 90                	xchg   %ax,%ax
80105d5e:	66 90                	xchg   %ax,%ax

80105d60 <sys_yield>:
#include "mmu.h"
#include "proc.h"


int sys_yield(void)
{
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
80105d63:	83 ec 08             	sub    $0x8,%esp
  yield(); 
80105d66:	e8 55 e5 ff ff       	call   801042c0 <yield>
  return 0;
}
80105d6b:	31 c0                	xor    %eax,%eax
80105d6d:	c9                   	leave  
80105d6e:	c3                   	ret    
80105d6f:	90                   	nop

80105d70 <sys_fork>:

int
sys_fork(void)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105d73:	5d                   	pop    %ebp
  return fork();
80105d74:	e9 67 e1 ff ff       	jmp    80103ee0 <fork>
80105d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d80 <sys_exit>:

int
sys_exit(void)
{
80105d80:	55                   	push   %ebp
80105d81:	89 e5                	mov    %esp,%ebp
80105d83:	83 ec 08             	sub    $0x8,%esp
  exit();
80105d86:	e8 f5 e3 ff ff       	call   80104180 <exit>
  return 0;  // not reached
}
80105d8b:	31 c0                	xor    %eax,%eax
80105d8d:	c9                   	leave  
80105d8e:	c3                   	ret    
80105d8f:	90                   	nop

80105d90 <sys_wait>:

int
sys_wait(void)
{
80105d90:	55                   	push   %ebp
80105d91:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105d93:	5d                   	pop    %ebp
  return wait();
80105d94:	e9 37 e6 ff ff       	jmp    801043d0 <wait>
80105d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105da0 <sys_kill>:

int
sys_kill(void)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105da6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105da9:	50                   	push   %eax
80105daa:	6a 00                	push   $0x0
80105dac:	e8 3f f2 ff ff       	call   80104ff0 <argint>
80105db1:	83 c4 10             	add    $0x10,%esp
80105db4:	85 c0                	test   %eax,%eax
80105db6:	78 18                	js     80105dd0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105db8:	83 ec 0c             	sub    $0xc,%esp
80105dbb:	ff 75 f4             	pushl  -0xc(%ebp)
80105dbe:	e8 6d e7 ff ff       	call   80104530 <kill>
80105dc3:	83 c4 10             	add    $0x10,%esp
}
80105dc6:	c9                   	leave  
80105dc7:	c3                   	ret    
80105dc8:	90                   	nop
80105dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105dd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dd5:	c9                   	leave  
80105dd6:	c3                   	ret    
80105dd7:	89 f6                	mov    %esi,%esi
80105dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105de0 <sys_getpid>:

int
sys_getpid(void)
{
80105de0:	55                   	push   %ebp
80105de1:	89 e5                	mov    %esp,%ebp
80105de3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105de6:	e8 55 df ff ff       	call   80103d40 <myproc>
80105deb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105dee:	c9                   	leave  
80105def:	c3                   	ret    

80105df0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105df0:	55                   	push   %ebp
80105df1:	89 e5                	mov    %esp,%ebp
80105df3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105df4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105df7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105dfa:	50                   	push   %eax
80105dfb:	6a 00                	push   $0x0
80105dfd:	e8 ee f1 ff ff       	call   80104ff0 <argint>
80105e02:	83 c4 10             	add    $0x10,%esp
80105e05:	85 c0                	test   %eax,%eax
80105e07:	78 27                	js     80105e30 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105e09:	e8 32 df ff ff       	call   80103d40 <myproc>
  if(growproc(n) < 0)
80105e0e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105e11:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105e13:	ff 75 f4             	pushl  -0xc(%ebp)
80105e16:	e8 45 e0 ff ff       	call   80103e60 <growproc>
80105e1b:	83 c4 10             	add    $0x10,%esp
80105e1e:	85 c0                	test   %eax,%eax
80105e20:	78 0e                	js     80105e30 <sys_sbrk+0x40>
    return -1;
  //cprintf("sbrk - addr=%d\n", addr);
  return addr;
}
80105e22:	89 d8                	mov    %ebx,%eax
80105e24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e27:	c9                   	leave  
80105e28:	c3                   	ret    
80105e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105e30:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105e35:	eb eb                	jmp    80105e22 <sys_sbrk+0x32>
80105e37:	89 f6                	mov    %esi,%esi
80105e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e40 <sys_sleep>:

int
sys_sleep(void)
{
80105e40:	55                   	push   %ebp
80105e41:	89 e5                	mov    %esp,%ebp
80105e43:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105e44:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e47:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105e4a:	50                   	push   %eax
80105e4b:	6a 00                	push   $0x0
80105e4d:	e8 9e f1 ff ff       	call   80104ff0 <argint>
80105e52:	83 c4 10             	add    $0x10,%esp
80105e55:	85 c0                	test   %eax,%eax
80105e57:	0f 88 8a 00 00 00    	js     80105ee7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105e5d:	83 ec 0c             	sub    $0xc,%esp
80105e60:	68 80 20 12 80       	push   $0x80122080
80105e65:	e8 06 ed ff ff       	call   80104b70 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105e6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e6d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105e70:	8b 1d c0 28 12 80    	mov    0x801228c0,%ebx
  while(ticks - ticks0 < n){
80105e76:	85 d2                	test   %edx,%edx
80105e78:	75 27                	jne    80105ea1 <sys_sleep+0x61>
80105e7a:	eb 54                	jmp    80105ed0 <sys_sleep+0x90>
80105e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105e80:	83 ec 08             	sub    $0x8,%esp
80105e83:	68 80 20 12 80       	push   $0x80122080
80105e88:	68 c0 28 12 80       	push   $0x801228c0
80105e8d:	e8 7e e4 ff ff       	call   80104310 <sleep>
  while(ticks - ticks0 < n){
80105e92:	a1 c0 28 12 80       	mov    0x801228c0,%eax
80105e97:	83 c4 10             	add    $0x10,%esp
80105e9a:	29 d8                	sub    %ebx,%eax
80105e9c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105e9f:	73 2f                	jae    80105ed0 <sys_sleep+0x90>
    if(myproc()->killed){
80105ea1:	e8 9a de ff ff       	call   80103d40 <myproc>
80105ea6:	8b 40 24             	mov    0x24(%eax),%eax
80105ea9:	85 c0                	test   %eax,%eax
80105eab:	74 d3                	je     80105e80 <sys_sleep+0x40>
      release(&tickslock);
80105ead:	83 ec 0c             	sub    $0xc,%esp
80105eb0:	68 80 20 12 80       	push   $0x80122080
80105eb5:	e8 d6 ed ff ff       	call   80104c90 <release>
      return -1;
80105eba:	83 c4 10             	add    $0x10,%esp
80105ebd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105ec2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ec5:	c9                   	leave  
80105ec6:	c3                   	ret    
80105ec7:	89 f6                	mov    %esi,%esi
80105ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105ed0:	83 ec 0c             	sub    $0xc,%esp
80105ed3:	68 80 20 12 80       	push   $0x80122080
80105ed8:	e8 b3 ed ff ff       	call   80104c90 <release>
  return 0;
80105edd:	83 c4 10             	add    $0x10,%esp
80105ee0:	31 c0                	xor    %eax,%eax
}
80105ee2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ee5:	c9                   	leave  
80105ee6:	c3                   	ret    
    return -1;
80105ee7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eec:	eb f4                	jmp    80105ee2 <sys_sleep+0xa2>
80105eee:	66 90                	xchg   %ax,%ax

80105ef0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
80105ef3:	53                   	push   %ebx
80105ef4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ef7:	68 80 20 12 80       	push   $0x80122080
80105efc:	e8 6f ec ff ff       	call   80104b70 <acquire>
  xticks = ticks;
80105f01:	8b 1d c0 28 12 80    	mov    0x801228c0,%ebx
  release(&tickslock);
80105f07:	c7 04 24 80 20 12 80 	movl   $0x80122080,(%esp)
80105f0e:	e8 7d ed ff ff       	call   80104c90 <release>
  return xticks;
}
80105f13:	89 d8                	mov    %ebx,%eax
80105f15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f18:	c9                   	leave  
80105f19:	c3                   	ret    
80105f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f20 <sys_protectPage>:

int
sys_protectPage(void){
80105f20:	55                   	push   %ebp
80105f21:	89 e5                	mov    %esp,%ebp
80105f23:	83 ec 1c             	sub    $0x1c,%esp
  void* va;

  if (argptr(0, (char**)(&va), sizeof(int)) < 0){
80105f26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f29:	6a 04                	push   $0x4
80105f2b:	50                   	push   %eax
80105f2c:	6a 00                	push   $0x0
80105f2e:	e8 0d f1 ff ff       	call   80105040 <argptr>
80105f33:	83 c4 10             	add    $0x10,%esp
80105f36:	85 c0                	test   %eax,%eax
80105f38:	78 16                	js     80105f50 <sys_protectPage+0x30>
    return -1;
  }
  return protectPage(va);
80105f3a:	83 ec 0c             	sub    $0xc,%esp
80105f3d:	ff 75 f4             	pushl  -0xc(%ebp)
80105f40:	e8 7b e7 ff ff       	call   801046c0 <protectPage>
80105f45:	83 c4 10             	add    $0x10,%esp
80105f48:	c9                   	leave  
80105f49:	c3                   	ret    
80105f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f55:	c9                   	leave  
80105f56:	c3                   	ret    

80105f57 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105f57:	1e                   	push   %ds
  pushl %es
80105f58:	06                   	push   %es
  pushl %fs
80105f59:	0f a0                	push   %fs
  pushl %gs
80105f5b:	0f a8                	push   %gs
  pushal
80105f5d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105f5e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105f62:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105f64:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105f66:	54                   	push   %esp
  call trap
80105f67:	e8 c4 00 00 00       	call   80106030 <trap>
  addl $4, %esp
80105f6c:	83 c4 04             	add    $0x4,%esp

80105f6f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105f6f:	61                   	popa   
  popl %gs
80105f70:	0f a9                	pop    %gs
  popl %fs
80105f72:	0f a1                	pop    %fs
  popl %es
80105f74:	07                   	pop    %es
  popl %ds
80105f75:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105f76:	83 c4 08             	add    $0x8,%esp
  iret
80105f79:	cf                   	iret   
80105f7a:	66 90                	xchg   %ax,%ax
80105f7c:	66 90                	xchg   %ax,%ax
80105f7e:	66 90                	xchg   %ax,%ax

80105f80 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105f80:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105f81:	31 c0                	xor    %eax,%eax
{
80105f83:	89 e5                	mov    %esp,%ebp
80105f85:	83 ec 08             	sub    $0x8,%esp
80105f88:	90                   	nop
80105f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105f90:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105f97:	c7 04 c5 c2 20 12 80 	movl   $0x8e000008,-0x7feddf3e(,%eax,8)
80105f9e:	08 00 00 8e 
80105fa2:	66 89 14 c5 c0 20 12 	mov    %dx,-0x7feddf40(,%eax,8)
80105fa9:	80 
80105faa:	c1 ea 10             	shr    $0x10,%edx
80105fad:	66 89 14 c5 c6 20 12 	mov    %dx,-0x7feddf3a(,%eax,8)
80105fb4:	80 
  for(i = 0; i < 256; i++)
80105fb5:	83 c0 01             	add    $0x1,%eax
80105fb8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105fbd:	75 d1                	jne    80105f90 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105fbf:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105fc4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105fc7:	c7 05 c2 22 12 80 08 	movl   $0xef000008,0x801222c2
80105fce:	00 00 ef 
  initlock(&tickslock, "time");
80105fd1:	68 3d 82 10 80       	push   $0x8010823d
80105fd6:	68 80 20 12 80       	push   $0x80122080
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105fdb:	66 a3 c0 22 12 80    	mov    %ax,0x801222c0
80105fe1:	c1 e8 10             	shr    $0x10,%eax
80105fe4:	66 a3 c6 22 12 80    	mov    %ax,0x801222c6
  initlock(&tickslock, "time");
80105fea:	e8 91 ea ff ff       	call   80104a80 <initlock>
}
80105fef:	83 c4 10             	add    $0x10,%esp
80105ff2:	c9                   	leave  
80105ff3:	c3                   	ret    
80105ff4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105ffa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106000 <idtinit>:

void
idtinit(void)
{
80106000:	55                   	push   %ebp
  pd[0] = size-1;
80106001:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106006:	89 e5                	mov    %esp,%ebp
80106008:	83 ec 10             	sub    $0x10,%esp
8010600b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010600f:	b8 c0 20 12 80       	mov    $0x801220c0,%eax
80106014:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106018:	c1 e8 10             	shr    $0x10,%eax
8010601b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010601f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106022:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106025:	c9                   	leave  
80106026:	c3                   	ret    
80106027:	89 f6                	mov    %esi,%esi
80106029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106030 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106030:	55                   	push   %ebp
80106031:	89 e5                	mov    %esp,%ebp
80106033:	57                   	push   %edi
80106034:	56                   	push   %esi
80106035:	53                   	push   %ebx
80106036:	83 ec 1c             	sub    $0x1c,%esp
80106039:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010603c:	8b 47 30             	mov    0x30(%edi),%eax
8010603f:	83 f8 40             	cmp    $0x40,%eax
80106042:	0f 84 f0 00 00 00    	je     80106138 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106048:	83 e8 0e             	sub    $0xe,%eax
8010604b:	83 f8 31             	cmp    $0x31,%eax
8010604e:	77 10                	ja     80106060 <trap+0x30>
80106050:	ff 24 85 e4 82 10 80 	jmp    *-0x7fef7d1c(,%eax,4)
80106057:	89 f6                	mov    %esi,%esi
80106059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106060:	e8 db dc ff ff       	call   80103d40 <myproc>
80106065:	85 c0                	test   %eax,%eax
80106067:	8b 5f 38             	mov    0x38(%edi),%ebx
8010606a:	0f 84 04 02 00 00    	je     80106274 <trap+0x244>
80106070:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106074:	0f 84 fa 01 00 00    	je     80106274 <trap+0x244>
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010607a:	0f 20 d1             	mov    %cr2,%ecx
8010607d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106080:	e8 9b dc ff ff       	call   80103d20 <cpuid>
80106085:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106088:	8b 47 34             	mov    0x34(%edi),%eax
8010608b:	8b 77 30             	mov    0x30(%edi),%esi
8010608e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106091:	e8 aa dc ff ff       	call   80103d40 <myproc>
80106096:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106099:	e8 a2 dc ff ff       	call   80103d40 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010609e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801060a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801060a4:	51                   	push   %ecx
801060a5:	53                   	push   %ebx
801060a6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
801060a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060aa:	ff 75 e4             	pushl  -0x1c(%ebp)
801060ad:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801060ae:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060b1:	52                   	push   %edx
801060b2:	ff 70 10             	pushl  0x10(%eax)
801060b5:	68 a0 82 10 80       	push   $0x801082a0
801060ba:	e8 a1 a5 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801060bf:	83 c4 20             	add    $0x20,%esp
801060c2:	e8 79 dc ff ff       	call   80103d40 <myproc>
801060c7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801060ce:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060d0:	e8 6b dc ff ff       	call   80103d40 <myproc>
801060d5:	85 c0                	test   %eax,%eax
801060d7:	74 1d                	je     801060f6 <trap+0xc6>
801060d9:	e8 62 dc ff ff       	call   80103d40 <myproc>
801060de:	8b 50 24             	mov    0x24(%eax),%edx
801060e1:	85 d2                	test   %edx,%edx
801060e3:	74 11                	je     801060f6 <trap+0xc6>
801060e5:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801060e9:	83 e0 03             	and    $0x3,%eax
801060ec:	66 83 f8 03          	cmp    $0x3,%ax
801060f0:	0f 84 3a 01 00 00    	je     80106230 <trap+0x200>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801060f6:	e8 45 dc ff ff       	call   80103d40 <myproc>
801060fb:	85 c0                	test   %eax,%eax
801060fd:	74 0b                	je     8010610a <trap+0xda>
801060ff:	e8 3c dc ff ff       	call   80103d40 <myproc>
80106104:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106108:	74 66                	je     80106170 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010610a:	e8 31 dc ff ff       	call   80103d40 <myproc>
8010610f:	85 c0                	test   %eax,%eax
80106111:	74 19                	je     8010612c <trap+0xfc>
80106113:	e8 28 dc ff ff       	call   80103d40 <myproc>
80106118:	8b 40 24             	mov    0x24(%eax),%eax
8010611b:	85 c0                	test   %eax,%eax
8010611d:	74 0d                	je     8010612c <trap+0xfc>
8010611f:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106123:	83 e0 03             	and    $0x3,%eax
80106126:	66 83 f8 03          	cmp    $0x3,%ax
8010612a:	74 35                	je     80106161 <trap+0x131>
    exit();
}
8010612c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010612f:	5b                   	pop    %ebx
80106130:	5e                   	pop    %esi
80106131:	5f                   	pop    %edi
80106132:	5d                   	pop    %ebp
80106133:	c3                   	ret    
80106134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106138:	e8 03 dc ff ff       	call   80103d40 <myproc>
8010613d:	8b 58 24             	mov    0x24(%eax),%ebx
80106140:	85 db                	test   %ebx,%ebx
80106142:	0f 85 d8 00 00 00    	jne    80106220 <trap+0x1f0>
    myproc()->tf = tf;
80106148:	e8 f3 db ff ff       	call   80103d40 <myproc>
8010614d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106150:	e8 8b ef ff ff       	call   801050e0 <syscall>
    if(myproc()->killed)
80106155:	e8 e6 db ff ff       	call   80103d40 <myproc>
8010615a:	8b 48 24             	mov    0x24(%eax),%ecx
8010615d:	85 c9                	test   %ecx,%ecx
8010615f:	74 cb                	je     8010612c <trap+0xfc>
}
80106161:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106164:	5b                   	pop    %ebx
80106165:	5e                   	pop    %esi
80106166:	5f                   	pop    %edi
80106167:	5d                   	pop    %ebp
      exit();
80106168:	e9 13 e0 ff ff       	jmp    80104180 <exit>
8010616d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106170:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106174:	75 94                	jne    8010610a <trap+0xda>
    yield();
80106176:	e8 45 e1 ff ff       	call   801042c0 <yield>
8010617b:	eb 8d                	jmp    8010610a <trap+0xda>
8010617d:	8d 76 00             	lea    0x0(%esi),%esi
      checkIfNeedSwapping();
80106180:	e8 1b 18 00 00       	call   801079a0 <checkIfNeedSwapping>
      break;
80106185:	e9 46 ff ff ff       	jmp    801060d0 <trap+0xa0>
8010618a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80106190:	e8 8b db ff ff       	call   80103d20 <cpuid>
80106195:	85 c0                	test   %eax,%eax
80106197:	0f 84 a3 00 00 00    	je     80106240 <trap+0x210>
    lapiceoi();
8010619d:	e8 9e ca ff ff       	call   80102c40 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061a2:	e8 99 db ff ff       	call   80103d40 <myproc>
801061a7:	85 c0                	test   %eax,%eax
801061a9:	0f 85 2a ff ff ff    	jne    801060d9 <trap+0xa9>
801061af:	e9 42 ff ff ff       	jmp    801060f6 <trap+0xc6>
801061b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801061b8:	e8 43 c9 ff ff       	call   80102b00 <kbdintr>
    lapiceoi();
801061bd:	e8 7e ca ff ff       	call   80102c40 <lapiceoi>
    break;
801061c2:	e9 09 ff ff ff       	jmp    801060d0 <trap+0xa0>
801061c7:	89 f6                	mov    %esi,%esi
801061c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    uartintr();
801061d0:	e8 3b 02 00 00       	call   80106410 <uartintr>
    lapiceoi();
801061d5:	e8 66 ca ff ff       	call   80102c40 <lapiceoi>
    break;
801061da:	e9 f1 fe ff ff       	jmp    801060d0 <trap+0xa0>
801061df:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801061e0:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801061e4:	8b 77 38             	mov    0x38(%edi),%esi
801061e7:	e8 34 db ff ff       	call   80103d20 <cpuid>
801061ec:	56                   	push   %esi
801061ed:	53                   	push   %ebx
801061ee:	50                   	push   %eax
801061ef:	68 48 82 10 80       	push   $0x80108248
801061f4:	e8 67 a4 ff ff       	call   80100660 <cprintf>
    lapiceoi();
801061f9:	e8 42 ca ff ff       	call   80102c40 <lapiceoi>
    break;
801061fe:	83 c4 10             	add    $0x10,%esp
80106201:	e9 ca fe ff ff       	jmp    801060d0 <trap+0xa0>
80106206:	8d 76 00             	lea    0x0(%esi),%esi
80106209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80106210:	e8 5b c3 ff ff       	call   80102570 <ideintr>
80106215:	eb 86                	jmp    8010619d <trap+0x16d>
80106217:	89 f6                	mov    %esi,%esi
80106219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
80106220:	e8 5b df ff ff       	call   80104180 <exit>
80106225:	e9 1e ff ff ff       	jmp    80106148 <trap+0x118>
8010622a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106230:	e8 4b df ff ff       	call   80104180 <exit>
80106235:	e9 bc fe ff ff       	jmp    801060f6 <trap+0xc6>
8010623a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106240:	83 ec 0c             	sub    $0xc,%esp
80106243:	68 80 20 12 80       	push   $0x80122080
80106248:	e8 23 e9 ff ff       	call   80104b70 <acquire>
      wakeup(&ticks);
8010624d:	c7 04 24 c0 28 12 80 	movl   $0x801228c0,(%esp)
      ticks++;
80106254:	83 05 c0 28 12 80 01 	addl   $0x1,0x801228c0
      wakeup(&ticks);
8010625b:	e8 70 e2 ff ff       	call   801044d0 <wakeup>
      release(&tickslock);
80106260:	c7 04 24 80 20 12 80 	movl   $0x80122080,(%esp)
80106267:	e8 24 ea ff ff       	call   80104c90 <release>
8010626c:	83 c4 10             	add    $0x10,%esp
8010626f:	e9 29 ff ff ff       	jmp    8010619d <trap+0x16d>
80106274:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106277:	e8 a4 da ff ff       	call   80103d20 <cpuid>
8010627c:	83 ec 0c             	sub    $0xc,%esp
8010627f:	56                   	push   %esi
80106280:	53                   	push   %ebx
80106281:	50                   	push   %eax
80106282:	ff 77 30             	pushl  0x30(%edi)
80106285:	68 6c 82 10 80       	push   $0x8010826c
8010628a:	e8 d1 a3 ff ff       	call   80100660 <cprintf>
      panic("trap");
8010628f:	83 c4 14             	add    $0x14,%esp
80106292:	68 42 82 10 80       	push   $0x80108242
80106297:	e8 f4 a0 ff ff       	call   80100390 <panic>
8010629c:	66 90                	xchg   %ax,%ax
8010629e:	66 90                	xchg   %ax,%ax

801062a0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801062a0:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
801062a5:	55                   	push   %ebp
801062a6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801062a8:	85 c0                	test   %eax,%eax
801062aa:	74 1c                	je     801062c8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801062ac:	ba fd 03 00 00       	mov    $0x3fd,%edx
801062b1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801062b2:	a8 01                	test   $0x1,%al
801062b4:	74 12                	je     801062c8 <uartgetc+0x28>
801062b6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062bb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801062bc:	0f b6 c0             	movzbl %al,%eax
}
801062bf:	5d                   	pop    %ebp
801062c0:	c3                   	ret    
801062c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801062c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062cd:	5d                   	pop    %ebp
801062ce:	c3                   	ret    
801062cf:	90                   	nop

801062d0 <uartputc.part.0>:
uartputc(int c)
801062d0:	55                   	push   %ebp
801062d1:	89 e5                	mov    %esp,%ebp
801062d3:	57                   	push   %edi
801062d4:	56                   	push   %esi
801062d5:	53                   	push   %ebx
801062d6:	89 c7                	mov    %eax,%edi
801062d8:	bb 80 00 00 00       	mov    $0x80,%ebx
801062dd:	be fd 03 00 00       	mov    $0x3fd,%esi
801062e2:	83 ec 0c             	sub    $0xc,%esp
801062e5:	eb 1b                	jmp    80106302 <uartputc.part.0+0x32>
801062e7:	89 f6                	mov    %esi,%esi
801062e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801062f0:	83 ec 0c             	sub    $0xc,%esp
801062f3:	6a 0a                	push   $0xa
801062f5:	e8 66 c9 ff ff       	call   80102c60 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801062fa:	83 c4 10             	add    $0x10,%esp
801062fd:	83 eb 01             	sub    $0x1,%ebx
80106300:	74 07                	je     80106309 <uartputc.part.0+0x39>
80106302:	89 f2                	mov    %esi,%edx
80106304:	ec                   	in     (%dx),%al
80106305:	a8 20                	test   $0x20,%al
80106307:	74 e7                	je     801062f0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106309:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010630e:	89 f8                	mov    %edi,%eax
80106310:	ee                   	out    %al,(%dx)
}
80106311:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106314:	5b                   	pop    %ebx
80106315:	5e                   	pop    %esi
80106316:	5f                   	pop    %edi
80106317:	5d                   	pop    %ebp
80106318:	c3                   	ret    
80106319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106320 <uartinit>:
{
80106320:	55                   	push   %ebp
80106321:	31 c9                	xor    %ecx,%ecx
80106323:	89 c8                	mov    %ecx,%eax
80106325:	89 e5                	mov    %esp,%ebp
80106327:	57                   	push   %edi
80106328:	56                   	push   %esi
80106329:	53                   	push   %ebx
8010632a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010632f:	89 da                	mov    %ebx,%edx
80106331:	83 ec 0c             	sub    $0xc,%esp
80106334:	ee                   	out    %al,(%dx)
80106335:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010633a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010633f:	89 fa                	mov    %edi,%edx
80106341:	ee                   	out    %al,(%dx)
80106342:	b8 0c 00 00 00       	mov    $0xc,%eax
80106347:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010634c:	ee                   	out    %al,(%dx)
8010634d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106352:	89 c8                	mov    %ecx,%eax
80106354:	89 f2                	mov    %esi,%edx
80106356:	ee                   	out    %al,(%dx)
80106357:	b8 03 00 00 00       	mov    $0x3,%eax
8010635c:	89 fa                	mov    %edi,%edx
8010635e:	ee                   	out    %al,(%dx)
8010635f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106364:	89 c8                	mov    %ecx,%eax
80106366:	ee                   	out    %al,(%dx)
80106367:	b8 01 00 00 00       	mov    $0x1,%eax
8010636c:	89 f2                	mov    %esi,%edx
8010636e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010636f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106374:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106375:	3c ff                	cmp    $0xff,%al
80106377:	74 5a                	je     801063d3 <uartinit+0xb3>
  uart = 1;
80106379:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106380:	00 00 00 
80106383:	89 da                	mov    %ebx,%edx
80106385:	ec                   	in     (%dx),%al
80106386:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010638b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010638c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010638f:	bb ac 83 10 80       	mov    $0x801083ac,%ebx
  ioapicenable(IRQ_COM1, 0);
80106394:	6a 00                	push   $0x0
80106396:	6a 04                	push   $0x4
80106398:	e8 23 c4 ff ff       	call   801027c0 <ioapicenable>
8010639d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801063a0:	b8 78 00 00 00       	mov    $0x78,%eax
801063a5:	eb 13                	jmp    801063ba <uartinit+0x9a>
801063a7:	89 f6                	mov    %esi,%esi
801063a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801063b0:	83 c3 01             	add    $0x1,%ebx
801063b3:	0f be 03             	movsbl (%ebx),%eax
801063b6:	84 c0                	test   %al,%al
801063b8:	74 19                	je     801063d3 <uartinit+0xb3>
  if(!uart)
801063ba:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
801063c0:	85 d2                	test   %edx,%edx
801063c2:	74 ec                	je     801063b0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801063c4:	83 c3 01             	add    $0x1,%ebx
801063c7:	e8 04 ff ff ff       	call   801062d0 <uartputc.part.0>
801063cc:	0f be 03             	movsbl (%ebx),%eax
801063cf:	84 c0                	test   %al,%al
801063d1:	75 e7                	jne    801063ba <uartinit+0x9a>
}
801063d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063d6:	5b                   	pop    %ebx
801063d7:	5e                   	pop    %esi
801063d8:	5f                   	pop    %edi
801063d9:	5d                   	pop    %ebp
801063da:	c3                   	ret    
801063db:	90                   	nop
801063dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801063e0 <uartputc>:
  if(!uart)
801063e0:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
801063e6:	55                   	push   %ebp
801063e7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801063e9:	85 d2                	test   %edx,%edx
{
801063eb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801063ee:	74 10                	je     80106400 <uartputc+0x20>
}
801063f0:	5d                   	pop    %ebp
801063f1:	e9 da fe ff ff       	jmp    801062d0 <uartputc.part.0>
801063f6:	8d 76 00             	lea    0x0(%esi),%esi
801063f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106400:	5d                   	pop    %ebp
80106401:	c3                   	ret    
80106402:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106410 <uartintr>:

void
uartintr(void)
{
80106410:	55                   	push   %ebp
80106411:	89 e5                	mov    %esp,%ebp
80106413:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106416:	68 a0 62 10 80       	push   $0x801062a0
8010641b:	e8 f0 a3 ff ff       	call   80100810 <consoleintr>
}
80106420:	83 c4 10             	add    $0x10,%esp
80106423:	c9                   	leave  
80106424:	c3                   	ret    

80106425 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106425:	6a 00                	push   $0x0
  pushl $0
80106427:	6a 00                	push   $0x0
  jmp alltraps
80106429:	e9 29 fb ff ff       	jmp    80105f57 <alltraps>

8010642e <vector1>:
.globl vector1
vector1:
  pushl $0
8010642e:	6a 00                	push   $0x0
  pushl $1
80106430:	6a 01                	push   $0x1
  jmp alltraps
80106432:	e9 20 fb ff ff       	jmp    80105f57 <alltraps>

80106437 <vector2>:
.globl vector2
vector2:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $2
80106439:	6a 02                	push   $0x2
  jmp alltraps
8010643b:	e9 17 fb ff ff       	jmp    80105f57 <alltraps>

80106440 <vector3>:
.globl vector3
vector3:
  pushl $0
80106440:	6a 00                	push   $0x0
  pushl $3
80106442:	6a 03                	push   $0x3
  jmp alltraps
80106444:	e9 0e fb ff ff       	jmp    80105f57 <alltraps>

80106449 <vector4>:
.globl vector4
vector4:
  pushl $0
80106449:	6a 00                	push   $0x0
  pushl $4
8010644b:	6a 04                	push   $0x4
  jmp alltraps
8010644d:	e9 05 fb ff ff       	jmp    80105f57 <alltraps>

80106452 <vector5>:
.globl vector5
vector5:
  pushl $0
80106452:	6a 00                	push   $0x0
  pushl $5
80106454:	6a 05                	push   $0x5
  jmp alltraps
80106456:	e9 fc fa ff ff       	jmp    80105f57 <alltraps>

8010645b <vector6>:
.globl vector6
vector6:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $6
8010645d:	6a 06                	push   $0x6
  jmp alltraps
8010645f:	e9 f3 fa ff ff       	jmp    80105f57 <alltraps>

80106464 <vector7>:
.globl vector7
vector7:
  pushl $0
80106464:	6a 00                	push   $0x0
  pushl $7
80106466:	6a 07                	push   $0x7
  jmp alltraps
80106468:	e9 ea fa ff ff       	jmp    80105f57 <alltraps>

8010646d <vector8>:
.globl vector8
vector8:
  pushl $8
8010646d:	6a 08                	push   $0x8
  jmp alltraps
8010646f:	e9 e3 fa ff ff       	jmp    80105f57 <alltraps>

80106474 <vector9>:
.globl vector9
vector9:
  pushl $0
80106474:	6a 00                	push   $0x0
  pushl $9
80106476:	6a 09                	push   $0x9
  jmp alltraps
80106478:	e9 da fa ff ff       	jmp    80105f57 <alltraps>

8010647d <vector10>:
.globl vector10
vector10:
  pushl $10
8010647d:	6a 0a                	push   $0xa
  jmp alltraps
8010647f:	e9 d3 fa ff ff       	jmp    80105f57 <alltraps>

80106484 <vector11>:
.globl vector11
vector11:
  pushl $11
80106484:	6a 0b                	push   $0xb
  jmp alltraps
80106486:	e9 cc fa ff ff       	jmp    80105f57 <alltraps>

8010648b <vector12>:
.globl vector12
vector12:
  pushl $12
8010648b:	6a 0c                	push   $0xc
  jmp alltraps
8010648d:	e9 c5 fa ff ff       	jmp    80105f57 <alltraps>

80106492 <vector13>:
.globl vector13
vector13:
  pushl $13
80106492:	6a 0d                	push   $0xd
  jmp alltraps
80106494:	e9 be fa ff ff       	jmp    80105f57 <alltraps>

80106499 <vector14>:
.globl vector14
vector14:
  pushl $14
80106499:	6a 0e                	push   $0xe
  jmp alltraps
8010649b:	e9 b7 fa ff ff       	jmp    80105f57 <alltraps>

801064a0 <vector15>:
.globl vector15
vector15:
  pushl $0
801064a0:	6a 00                	push   $0x0
  pushl $15
801064a2:	6a 0f                	push   $0xf
  jmp alltraps
801064a4:	e9 ae fa ff ff       	jmp    80105f57 <alltraps>

801064a9 <vector16>:
.globl vector16
vector16:
  pushl $0
801064a9:	6a 00                	push   $0x0
  pushl $16
801064ab:	6a 10                	push   $0x10
  jmp alltraps
801064ad:	e9 a5 fa ff ff       	jmp    80105f57 <alltraps>

801064b2 <vector17>:
.globl vector17
vector17:
  pushl $17
801064b2:	6a 11                	push   $0x11
  jmp alltraps
801064b4:	e9 9e fa ff ff       	jmp    80105f57 <alltraps>

801064b9 <vector18>:
.globl vector18
vector18:
  pushl $0
801064b9:	6a 00                	push   $0x0
  pushl $18
801064bb:	6a 12                	push   $0x12
  jmp alltraps
801064bd:	e9 95 fa ff ff       	jmp    80105f57 <alltraps>

801064c2 <vector19>:
.globl vector19
vector19:
  pushl $0
801064c2:	6a 00                	push   $0x0
  pushl $19
801064c4:	6a 13                	push   $0x13
  jmp alltraps
801064c6:	e9 8c fa ff ff       	jmp    80105f57 <alltraps>

801064cb <vector20>:
.globl vector20
vector20:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $20
801064cd:	6a 14                	push   $0x14
  jmp alltraps
801064cf:	e9 83 fa ff ff       	jmp    80105f57 <alltraps>

801064d4 <vector21>:
.globl vector21
vector21:
  pushl $0
801064d4:	6a 00                	push   $0x0
  pushl $21
801064d6:	6a 15                	push   $0x15
  jmp alltraps
801064d8:	e9 7a fa ff ff       	jmp    80105f57 <alltraps>

801064dd <vector22>:
.globl vector22
vector22:
  pushl $0
801064dd:	6a 00                	push   $0x0
  pushl $22
801064df:	6a 16                	push   $0x16
  jmp alltraps
801064e1:	e9 71 fa ff ff       	jmp    80105f57 <alltraps>

801064e6 <vector23>:
.globl vector23
vector23:
  pushl $0
801064e6:	6a 00                	push   $0x0
  pushl $23
801064e8:	6a 17                	push   $0x17
  jmp alltraps
801064ea:	e9 68 fa ff ff       	jmp    80105f57 <alltraps>

801064ef <vector24>:
.globl vector24
vector24:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $24
801064f1:	6a 18                	push   $0x18
  jmp alltraps
801064f3:	e9 5f fa ff ff       	jmp    80105f57 <alltraps>

801064f8 <vector25>:
.globl vector25
vector25:
  pushl $0
801064f8:	6a 00                	push   $0x0
  pushl $25
801064fa:	6a 19                	push   $0x19
  jmp alltraps
801064fc:	e9 56 fa ff ff       	jmp    80105f57 <alltraps>

80106501 <vector26>:
.globl vector26
vector26:
  pushl $0
80106501:	6a 00                	push   $0x0
  pushl $26
80106503:	6a 1a                	push   $0x1a
  jmp alltraps
80106505:	e9 4d fa ff ff       	jmp    80105f57 <alltraps>

8010650a <vector27>:
.globl vector27
vector27:
  pushl $0
8010650a:	6a 00                	push   $0x0
  pushl $27
8010650c:	6a 1b                	push   $0x1b
  jmp alltraps
8010650e:	e9 44 fa ff ff       	jmp    80105f57 <alltraps>

80106513 <vector28>:
.globl vector28
vector28:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $28
80106515:	6a 1c                	push   $0x1c
  jmp alltraps
80106517:	e9 3b fa ff ff       	jmp    80105f57 <alltraps>

8010651c <vector29>:
.globl vector29
vector29:
  pushl $0
8010651c:	6a 00                	push   $0x0
  pushl $29
8010651e:	6a 1d                	push   $0x1d
  jmp alltraps
80106520:	e9 32 fa ff ff       	jmp    80105f57 <alltraps>

80106525 <vector30>:
.globl vector30
vector30:
  pushl $0
80106525:	6a 00                	push   $0x0
  pushl $30
80106527:	6a 1e                	push   $0x1e
  jmp alltraps
80106529:	e9 29 fa ff ff       	jmp    80105f57 <alltraps>

8010652e <vector31>:
.globl vector31
vector31:
  pushl $0
8010652e:	6a 00                	push   $0x0
  pushl $31
80106530:	6a 1f                	push   $0x1f
  jmp alltraps
80106532:	e9 20 fa ff ff       	jmp    80105f57 <alltraps>

80106537 <vector32>:
.globl vector32
vector32:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $32
80106539:	6a 20                	push   $0x20
  jmp alltraps
8010653b:	e9 17 fa ff ff       	jmp    80105f57 <alltraps>

80106540 <vector33>:
.globl vector33
vector33:
  pushl $0
80106540:	6a 00                	push   $0x0
  pushl $33
80106542:	6a 21                	push   $0x21
  jmp alltraps
80106544:	e9 0e fa ff ff       	jmp    80105f57 <alltraps>

80106549 <vector34>:
.globl vector34
vector34:
  pushl $0
80106549:	6a 00                	push   $0x0
  pushl $34
8010654b:	6a 22                	push   $0x22
  jmp alltraps
8010654d:	e9 05 fa ff ff       	jmp    80105f57 <alltraps>

80106552 <vector35>:
.globl vector35
vector35:
  pushl $0
80106552:	6a 00                	push   $0x0
  pushl $35
80106554:	6a 23                	push   $0x23
  jmp alltraps
80106556:	e9 fc f9 ff ff       	jmp    80105f57 <alltraps>

8010655b <vector36>:
.globl vector36
vector36:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $36
8010655d:	6a 24                	push   $0x24
  jmp alltraps
8010655f:	e9 f3 f9 ff ff       	jmp    80105f57 <alltraps>

80106564 <vector37>:
.globl vector37
vector37:
  pushl $0
80106564:	6a 00                	push   $0x0
  pushl $37
80106566:	6a 25                	push   $0x25
  jmp alltraps
80106568:	e9 ea f9 ff ff       	jmp    80105f57 <alltraps>

8010656d <vector38>:
.globl vector38
vector38:
  pushl $0
8010656d:	6a 00                	push   $0x0
  pushl $38
8010656f:	6a 26                	push   $0x26
  jmp alltraps
80106571:	e9 e1 f9 ff ff       	jmp    80105f57 <alltraps>

80106576 <vector39>:
.globl vector39
vector39:
  pushl $0
80106576:	6a 00                	push   $0x0
  pushl $39
80106578:	6a 27                	push   $0x27
  jmp alltraps
8010657a:	e9 d8 f9 ff ff       	jmp    80105f57 <alltraps>

8010657f <vector40>:
.globl vector40
vector40:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $40
80106581:	6a 28                	push   $0x28
  jmp alltraps
80106583:	e9 cf f9 ff ff       	jmp    80105f57 <alltraps>

80106588 <vector41>:
.globl vector41
vector41:
  pushl $0
80106588:	6a 00                	push   $0x0
  pushl $41
8010658a:	6a 29                	push   $0x29
  jmp alltraps
8010658c:	e9 c6 f9 ff ff       	jmp    80105f57 <alltraps>

80106591 <vector42>:
.globl vector42
vector42:
  pushl $0
80106591:	6a 00                	push   $0x0
  pushl $42
80106593:	6a 2a                	push   $0x2a
  jmp alltraps
80106595:	e9 bd f9 ff ff       	jmp    80105f57 <alltraps>

8010659a <vector43>:
.globl vector43
vector43:
  pushl $0
8010659a:	6a 00                	push   $0x0
  pushl $43
8010659c:	6a 2b                	push   $0x2b
  jmp alltraps
8010659e:	e9 b4 f9 ff ff       	jmp    80105f57 <alltraps>

801065a3 <vector44>:
.globl vector44
vector44:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $44
801065a5:	6a 2c                	push   $0x2c
  jmp alltraps
801065a7:	e9 ab f9 ff ff       	jmp    80105f57 <alltraps>

801065ac <vector45>:
.globl vector45
vector45:
  pushl $0
801065ac:	6a 00                	push   $0x0
  pushl $45
801065ae:	6a 2d                	push   $0x2d
  jmp alltraps
801065b0:	e9 a2 f9 ff ff       	jmp    80105f57 <alltraps>

801065b5 <vector46>:
.globl vector46
vector46:
  pushl $0
801065b5:	6a 00                	push   $0x0
  pushl $46
801065b7:	6a 2e                	push   $0x2e
  jmp alltraps
801065b9:	e9 99 f9 ff ff       	jmp    80105f57 <alltraps>

801065be <vector47>:
.globl vector47
vector47:
  pushl $0
801065be:	6a 00                	push   $0x0
  pushl $47
801065c0:	6a 2f                	push   $0x2f
  jmp alltraps
801065c2:	e9 90 f9 ff ff       	jmp    80105f57 <alltraps>

801065c7 <vector48>:
.globl vector48
vector48:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $48
801065c9:	6a 30                	push   $0x30
  jmp alltraps
801065cb:	e9 87 f9 ff ff       	jmp    80105f57 <alltraps>

801065d0 <vector49>:
.globl vector49
vector49:
  pushl $0
801065d0:	6a 00                	push   $0x0
  pushl $49
801065d2:	6a 31                	push   $0x31
  jmp alltraps
801065d4:	e9 7e f9 ff ff       	jmp    80105f57 <alltraps>

801065d9 <vector50>:
.globl vector50
vector50:
  pushl $0
801065d9:	6a 00                	push   $0x0
  pushl $50
801065db:	6a 32                	push   $0x32
  jmp alltraps
801065dd:	e9 75 f9 ff ff       	jmp    80105f57 <alltraps>

801065e2 <vector51>:
.globl vector51
vector51:
  pushl $0
801065e2:	6a 00                	push   $0x0
  pushl $51
801065e4:	6a 33                	push   $0x33
  jmp alltraps
801065e6:	e9 6c f9 ff ff       	jmp    80105f57 <alltraps>

801065eb <vector52>:
.globl vector52
vector52:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $52
801065ed:	6a 34                	push   $0x34
  jmp alltraps
801065ef:	e9 63 f9 ff ff       	jmp    80105f57 <alltraps>

801065f4 <vector53>:
.globl vector53
vector53:
  pushl $0
801065f4:	6a 00                	push   $0x0
  pushl $53
801065f6:	6a 35                	push   $0x35
  jmp alltraps
801065f8:	e9 5a f9 ff ff       	jmp    80105f57 <alltraps>

801065fd <vector54>:
.globl vector54
vector54:
  pushl $0
801065fd:	6a 00                	push   $0x0
  pushl $54
801065ff:	6a 36                	push   $0x36
  jmp alltraps
80106601:	e9 51 f9 ff ff       	jmp    80105f57 <alltraps>

80106606 <vector55>:
.globl vector55
vector55:
  pushl $0
80106606:	6a 00                	push   $0x0
  pushl $55
80106608:	6a 37                	push   $0x37
  jmp alltraps
8010660a:	e9 48 f9 ff ff       	jmp    80105f57 <alltraps>

8010660f <vector56>:
.globl vector56
vector56:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $56
80106611:	6a 38                	push   $0x38
  jmp alltraps
80106613:	e9 3f f9 ff ff       	jmp    80105f57 <alltraps>

80106618 <vector57>:
.globl vector57
vector57:
  pushl $0
80106618:	6a 00                	push   $0x0
  pushl $57
8010661a:	6a 39                	push   $0x39
  jmp alltraps
8010661c:	e9 36 f9 ff ff       	jmp    80105f57 <alltraps>

80106621 <vector58>:
.globl vector58
vector58:
  pushl $0
80106621:	6a 00                	push   $0x0
  pushl $58
80106623:	6a 3a                	push   $0x3a
  jmp alltraps
80106625:	e9 2d f9 ff ff       	jmp    80105f57 <alltraps>

8010662a <vector59>:
.globl vector59
vector59:
  pushl $0
8010662a:	6a 00                	push   $0x0
  pushl $59
8010662c:	6a 3b                	push   $0x3b
  jmp alltraps
8010662e:	e9 24 f9 ff ff       	jmp    80105f57 <alltraps>

80106633 <vector60>:
.globl vector60
vector60:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $60
80106635:	6a 3c                	push   $0x3c
  jmp alltraps
80106637:	e9 1b f9 ff ff       	jmp    80105f57 <alltraps>

8010663c <vector61>:
.globl vector61
vector61:
  pushl $0
8010663c:	6a 00                	push   $0x0
  pushl $61
8010663e:	6a 3d                	push   $0x3d
  jmp alltraps
80106640:	e9 12 f9 ff ff       	jmp    80105f57 <alltraps>

80106645 <vector62>:
.globl vector62
vector62:
  pushl $0
80106645:	6a 00                	push   $0x0
  pushl $62
80106647:	6a 3e                	push   $0x3e
  jmp alltraps
80106649:	e9 09 f9 ff ff       	jmp    80105f57 <alltraps>

8010664e <vector63>:
.globl vector63
vector63:
  pushl $0
8010664e:	6a 00                	push   $0x0
  pushl $63
80106650:	6a 3f                	push   $0x3f
  jmp alltraps
80106652:	e9 00 f9 ff ff       	jmp    80105f57 <alltraps>

80106657 <vector64>:
.globl vector64
vector64:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $64
80106659:	6a 40                	push   $0x40
  jmp alltraps
8010665b:	e9 f7 f8 ff ff       	jmp    80105f57 <alltraps>

80106660 <vector65>:
.globl vector65
vector65:
  pushl $0
80106660:	6a 00                	push   $0x0
  pushl $65
80106662:	6a 41                	push   $0x41
  jmp alltraps
80106664:	e9 ee f8 ff ff       	jmp    80105f57 <alltraps>

80106669 <vector66>:
.globl vector66
vector66:
  pushl $0
80106669:	6a 00                	push   $0x0
  pushl $66
8010666b:	6a 42                	push   $0x42
  jmp alltraps
8010666d:	e9 e5 f8 ff ff       	jmp    80105f57 <alltraps>

80106672 <vector67>:
.globl vector67
vector67:
  pushl $0
80106672:	6a 00                	push   $0x0
  pushl $67
80106674:	6a 43                	push   $0x43
  jmp alltraps
80106676:	e9 dc f8 ff ff       	jmp    80105f57 <alltraps>

8010667b <vector68>:
.globl vector68
vector68:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $68
8010667d:	6a 44                	push   $0x44
  jmp alltraps
8010667f:	e9 d3 f8 ff ff       	jmp    80105f57 <alltraps>

80106684 <vector69>:
.globl vector69
vector69:
  pushl $0
80106684:	6a 00                	push   $0x0
  pushl $69
80106686:	6a 45                	push   $0x45
  jmp alltraps
80106688:	e9 ca f8 ff ff       	jmp    80105f57 <alltraps>

8010668d <vector70>:
.globl vector70
vector70:
  pushl $0
8010668d:	6a 00                	push   $0x0
  pushl $70
8010668f:	6a 46                	push   $0x46
  jmp alltraps
80106691:	e9 c1 f8 ff ff       	jmp    80105f57 <alltraps>

80106696 <vector71>:
.globl vector71
vector71:
  pushl $0
80106696:	6a 00                	push   $0x0
  pushl $71
80106698:	6a 47                	push   $0x47
  jmp alltraps
8010669a:	e9 b8 f8 ff ff       	jmp    80105f57 <alltraps>

8010669f <vector72>:
.globl vector72
vector72:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $72
801066a1:	6a 48                	push   $0x48
  jmp alltraps
801066a3:	e9 af f8 ff ff       	jmp    80105f57 <alltraps>

801066a8 <vector73>:
.globl vector73
vector73:
  pushl $0
801066a8:	6a 00                	push   $0x0
  pushl $73
801066aa:	6a 49                	push   $0x49
  jmp alltraps
801066ac:	e9 a6 f8 ff ff       	jmp    80105f57 <alltraps>

801066b1 <vector74>:
.globl vector74
vector74:
  pushl $0
801066b1:	6a 00                	push   $0x0
  pushl $74
801066b3:	6a 4a                	push   $0x4a
  jmp alltraps
801066b5:	e9 9d f8 ff ff       	jmp    80105f57 <alltraps>

801066ba <vector75>:
.globl vector75
vector75:
  pushl $0
801066ba:	6a 00                	push   $0x0
  pushl $75
801066bc:	6a 4b                	push   $0x4b
  jmp alltraps
801066be:	e9 94 f8 ff ff       	jmp    80105f57 <alltraps>

801066c3 <vector76>:
.globl vector76
vector76:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $76
801066c5:	6a 4c                	push   $0x4c
  jmp alltraps
801066c7:	e9 8b f8 ff ff       	jmp    80105f57 <alltraps>

801066cc <vector77>:
.globl vector77
vector77:
  pushl $0
801066cc:	6a 00                	push   $0x0
  pushl $77
801066ce:	6a 4d                	push   $0x4d
  jmp alltraps
801066d0:	e9 82 f8 ff ff       	jmp    80105f57 <alltraps>

801066d5 <vector78>:
.globl vector78
vector78:
  pushl $0
801066d5:	6a 00                	push   $0x0
  pushl $78
801066d7:	6a 4e                	push   $0x4e
  jmp alltraps
801066d9:	e9 79 f8 ff ff       	jmp    80105f57 <alltraps>

801066de <vector79>:
.globl vector79
vector79:
  pushl $0
801066de:	6a 00                	push   $0x0
  pushl $79
801066e0:	6a 4f                	push   $0x4f
  jmp alltraps
801066e2:	e9 70 f8 ff ff       	jmp    80105f57 <alltraps>

801066e7 <vector80>:
.globl vector80
vector80:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $80
801066e9:	6a 50                	push   $0x50
  jmp alltraps
801066eb:	e9 67 f8 ff ff       	jmp    80105f57 <alltraps>

801066f0 <vector81>:
.globl vector81
vector81:
  pushl $0
801066f0:	6a 00                	push   $0x0
  pushl $81
801066f2:	6a 51                	push   $0x51
  jmp alltraps
801066f4:	e9 5e f8 ff ff       	jmp    80105f57 <alltraps>

801066f9 <vector82>:
.globl vector82
vector82:
  pushl $0
801066f9:	6a 00                	push   $0x0
  pushl $82
801066fb:	6a 52                	push   $0x52
  jmp alltraps
801066fd:	e9 55 f8 ff ff       	jmp    80105f57 <alltraps>

80106702 <vector83>:
.globl vector83
vector83:
  pushl $0
80106702:	6a 00                	push   $0x0
  pushl $83
80106704:	6a 53                	push   $0x53
  jmp alltraps
80106706:	e9 4c f8 ff ff       	jmp    80105f57 <alltraps>

8010670b <vector84>:
.globl vector84
vector84:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $84
8010670d:	6a 54                	push   $0x54
  jmp alltraps
8010670f:	e9 43 f8 ff ff       	jmp    80105f57 <alltraps>

80106714 <vector85>:
.globl vector85
vector85:
  pushl $0
80106714:	6a 00                	push   $0x0
  pushl $85
80106716:	6a 55                	push   $0x55
  jmp alltraps
80106718:	e9 3a f8 ff ff       	jmp    80105f57 <alltraps>

8010671d <vector86>:
.globl vector86
vector86:
  pushl $0
8010671d:	6a 00                	push   $0x0
  pushl $86
8010671f:	6a 56                	push   $0x56
  jmp alltraps
80106721:	e9 31 f8 ff ff       	jmp    80105f57 <alltraps>

80106726 <vector87>:
.globl vector87
vector87:
  pushl $0
80106726:	6a 00                	push   $0x0
  pushl $87
80106728:	6a 57                	push   $0x57
  jmp alltraps
8010672a:	e9 28 f8 ff ff       	jmp    80105f57 <alltraps>

8010672f <vector88>:
.globl vector88
vector88:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $88
80106731:	6a 58                	push   $0x58
  jmp alltraps
80106733:	e9 1f f8 ff ff       	jmp    80105f57 <alltraps>

80106738 <vector89>:
.globl vector89
vector89:
  pushl $0
80106738:	6a 00                	push   $0x0
  pushl $89
8010673a:	6a 59                	push   $0x59
  jmp alltraps
8010673c:	e9 16 f8 ff ff       	jmp    80105f57 <alltraps>

80106741 <vector90>:
.globl vector90
vector90:
  pushl $0
80106741:	6a 00                	push   $0x0
  pushl $90
80106743:	6a 5a                	push   $0x5a
  jmp alltraps
80106745:	e9 0d f8 ff ff       	jmp    80105f57 <alltraps>

8010674a <vector91>:
.globl vector91
vector91:
  pushl $0
8010674a:	6a 00                	push   $0x0
  pushl $91
8010674c:	6a 5b                	push   $0x5b
  jmp alltraps
8010674e:	e9 04 f8 ff ff       	jmp    80105f57 <alltraps>

80106753 <vector92>:
.globl vector92
vector92:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $92
80106755:	6a 5c                	push   $0x5c
  jmp alltraps
80106757:	e9 fb f7 ff ff       	jmp    80105f57 <alltraps>

8010675c <vector93>:
.globl vector93
vector93:
  pushl $0
8010675c:	6a 00                	push   $0x0
  pushl $93
8010675e:	6a 5d                	push   $0x5d
  jmp alltraps
80106760:	e9 f2 f7 ff ff       	jmp    80105f57 <alltraps>

80106765 <vector94>:
.globl vector94
vector94:
  pushl $0
80106765:	6a 00                	push   $0x0
  pushl $94
80106767:	6a 5e                	push   $0x5e
  jmp alltraps
80106769:	e9 e9 f7 ff ff       	jmp    80105f57 <alltraps>

8010676e <vector95>:
.globl vector95
vector95:
  pushl $0
8010676e:	6a 00                	push   $0x0
  pushl $95
80106770:	6a 5f                	push   $0x5f
  jmp alltraps
80106772:	e9 e0 f7 ff ff       	jmp    80105f57 <alltraps>

80106777 <vector96>:
.globl vector96
vector96:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $96
80106779:	6a 60                	push   $0x60
  jmp alltraps
8010677b:	e9 d7 f7 ff ff       	jmp    80105f57 <alltraps>

80106780 <vector97>:
.globl vector97
vector97:
  pushl $0
80106780:	6a 00                	push   $0x0
  pushl $97
80106782:	6a 61                	push   $0x61
  jmp alltraps
80106784:	e9 ce f7 ff ff       	jmp    80105f57 <alltraps>

80106789 <vector98>:
.globl vector98
vector98:
  pushl $0
80106789:	6a 00                	push   $0x0
  pushl $98
8010678b:	6a 62                	push   $0x62
  jmp alltraps
8010678d:	e9 c5 f7 ff ff       	jmp    80105f57 <alltraps>

80106792 <vector99>:
.globl vector99
vector99:
  pushl $0
80106792:	6a 00                	push   $0x0
  pushl $99
80106794:	6a 63                	push   $0x63
  jmp alltraps
80106796:	e9 bc f7 ff ff       	jmp    80105f57 <alltraps>

8010679b <vector100>:
.globl vector100
vector100:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $100
8010679d:	6a 64                	push   $0x64
  jmp alltraps
8010679f:	e9 b3 f7 ff ff       	jmp    80105f57 <alltraps>

801067a4 <vector101>:
.globl vector101
vector101:
  pushl $0
801067a4:	6a 00                	push   $0x0
  pushl $101
801067a6:	6a 65                	push   $0x65
  jmp alltraps
801067a8:	e9 aa f7 ff ff       	jmp    80105f57 <alltraps>

801067ad <vector102>:
.globl vector102
vector102:
  pushl $0
801067ad:	6a 00                	push   $0x0
  pushl $102
801067af:	6a 66                	push   $0x66
  jmp alltraps
801067b1:	e9 a1 f7 ff ff       	jmp    80105f57 <alltraps>

801067b6 <vector103>:
.globl vector103
vector103:
  pushl $0
801067b6:	6a 00                	push   $0x0
  pushl $103
801067b8:	6a 67                	push   $0x67
  jmp alltraps
801067ba:	e9 98 f7 ff ff       	jmp    80105f57 <alltraps>

801067bf <vector104>:
.globl vector104
vector104:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $104
801067c1:	6a 68                	push   $0x68
  jmp alltraps
801067c3:	e9 8f f7 ff ff       	jmp    80105f57 <alltraps>

801067c8 <vector105>:
.globl vector105
vector105:
  pushl $0
801067c8:	6a 00                	push   $0x0
  pushl $105
801067ca:	6a 69                	push   $0x69
  jmp alltraps
801067cc:	e9 86 f7 ff ff       	jmp    80105f57 <alltraps>

801067d1 <vector106>:
.globl vector106
vector106:
  pushl $0
801067d1:	6a 00                	push   $0x0
  pushl $106
801067d3:	6a 6a                	push   $0x6a
  jmp alltraps
801067d5:	e9 7d f7 ff ff       	jmp    80105f57 <alltraps>

801067da <vector107>:
.globl vector107
vector107:
  pushl $0
801067da:	6a 00                	push   $0x0
  pushl $107
801067dc:	6a 6b                	push   $0x6b
  jmp alltraps
801067de:	e9 74 f7 ff ff       	jmp    80105f57 <alltraps>

801067e3 <vector108>:
.globl vector108
vector108:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $108
801067e5:	6a 6c                	push   $0x6c
  jmp alltraps
801067e7:	e9 6b f7 ff ff       	jmp    80105f57 <alltraps>

801067ec <vector109>:
.globl vector109
vector109:
  pushl $0
801067ec:	6a 00                	push   $0x0
  pushl $109
801067ee:	6a 6d                	push   $0x6d
  jmp alltraps
801067f0:	e9 62 f7 ff ff       	jmp    80105f57 <alltraps>

801067f5 <vector110>:
.globl vector110
vector110:
  pushl $0
801067f5:	6a 00                	push   $0x0
  pushl $110
801067f7:	6a 6e                	push   $0x6e
  jmp alltraps
801067f9:	e9 59 f7 ff ff       	jmp    80105f57 <alltraps>

801067fe <vector111>:
.globl vector111
vector111:
  pushl $0
801067fe:	6a 00                	push   $0x0
  pushl $111
80106800:	6a 6f                	push   $0x6f
  jmp alltraps
80106802:	e9 50 f7 ff ff       	jmp    80105f57 <alltraps>

80106807 <vector112>:
.globl vector112
vector112:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $112
80106809:	6a 70                	push   $0x70
  jmp alltraps
8010680b:	e9 47 f7 ff ff       	jmp    80105f57 <alltraps>

80106810 <vector113>:
.globl vector113
vector113:
  pushl $0
80106810:	6a 00                	push   $0x0
  pushl $113
80106812:	6a 71                	push   $0x71
  jmp alltraps
80106814:	e9 3e f7 ff ff       	jmp    80105f57 <alltraps>

80106819 <vector114>:
.globl vector114
vector114:
  pushl $0
80106819:	6a 00                	push   $0x0
  pushl $114
8010681b:	6a 72                	push   $0x72
  jmp alltraps
8010681d:	e9 35 f7 ff ff       	jmp    80105f57 <alltraps>

80106822 <vector115>:
.globl vector115
vector115:
  pushl $0
80106822:	6a 00                	push   $0x0
  pushl $115
80106824:	6a 73                	push   $0x73
  jmp alltraps
80106826:	e9 2c f7 ff ff       	jmp    80105f57 <alltraps>

8010682b <vector116>:
.globl vector116
vector116:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $116
8010682d:	6a 74                	push   $0x74
  jmp alltraps
8010682f:	e9 23 f7 ff ff       	jmp    80105f57 <alltraps>

80106834 <vector117>:
.globl vector117
vector117:
  pushl $0
80106834:	6a 00                	push   $0x0
  pushl $117
80106836:	6a 75                	push   $0x75
  jmp alltraps
80106838:	e9 1a f7 ff ff       	jmp    80105f57 <alltraps>

8010683d <vector118>:
.globl vector118
vector118:
  pushl $0
8010683d:	6a 00                	push   $0x0
  pushl $118
8010683f:	6a 76                	push   $0x76
  jmp alltraps
80106841:	e9 11 f7 ff ff       	jmp    80105f57 <alltraps>

80106846 <vector119>:
.globl vector119
vector119:
  pushl $0
80106846:	6a 00                	push   $0x0
  pushl $119
80106848:	6a 77                	push   $0x77
  jmp alltraps
8010684a:	e9 08 f7 ff ff       	jmp    80105f57 <alltraps>

8010684f <vector120>:
.globl vector120
vector120:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $120
80106851:	6a 78                	push   $0x78
  jmp alltraps
80106853:	e9 ff f6 ff ff       	jmp    80105f57 <alltraps>

80106858 <vector121>:
.globl vector121
vector121:
  pushl $0
80106858:	6a 00                	push   $0x0
  pushl $121
8010685a:	6a 79                	push   $0x79
  jmp alltraps
8010685c:	e9 f6 f6 ff ff       	jmp    80105f57 <alltraps>

80106861 <vector122>:
.globl vector122
vector122:
  pushl $0
80106861:	6a 00                	push   $0x0
  pushl $122
80106863:	6a 7a                	push   $0x7a
  jmp alltraps
80106865:	e9 ed f6 ff ff       	jmp    80105f57 <alltraps>

8010686a <vector123>:
.globl vector123
vector123:
  pushl $0
8010686a:	6a 00                	push   $0x0
  pushl $123
8010686c:	6a 7b                	push   $0x7b
  jmp alltraps
8010686e:	e9 e4 f6 ff ff       	jmp    80105f57 <alltraps>

80106873 <vector124>:
.globl vector124
vector124:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $124
80106875:	6a 7c                	push   $0x7c
  jmp alltraps
80106877:	e9 db f6 ff ff       	jmp    80105f57 <alltraps>

8010687c <vector125>:
.globl vector125
vector125:
  pushl $0
8010687c:	6a 00                	push   $0x0
  pushl $125
8010687e:	6a 7d                	push   $0x7d
  jmp alltraps
80106880:	e9 d2 f6 ff ff       	jmp    80105f57 <alltraps>

80106885 <vector126>:
.globl vector126
vector126:
  pushl $0
80106885:	6a 00                	push   $0x0
  pushl $126
80106887:	6a 7e                	push   $0x7e
  jmp alltraps
80106889:	e9 c9 f6 ff ff       	jmp    80105f57 <alltraps>

8010688e <vector127>:
.globl vector127
vector127:
  pushl $0
8010688e:	6a 00                	push   $0x0
  pushl $127
80106890:	6a 7f                	push   $0x7f
  jmp alltraps
80106892:	e9 c0 f6 ff ff       	jmp    80105f57 <alltraps>

80106897 <vector128>:
.globl vector128
vector128:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $128
80106899:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010689e:	e9 b4 f6 ff ff       	jmp    80105f57 <alltraps>

801068a3 <vector129>:
.globl vector129
vector129:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $129
801068a5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801068aa:	e9 a8 f6 ff ff       	jmp    80105f57 <alltraps>

801068af <vector130>:
.globl vector130
vector130:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $130
801068b1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801068b6:	e9 9c f6 ff ff       	jmp    80105f57 <alltraps>

801068bb <vector131>:
.globl vector131
vector131:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $131
801068bd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801068c2:	e9 90 f6 ff ff       	jmp    80105f57 <alltraps>

801068c7 <vector132>:
.globl vector132
vector132:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $132
801068c9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801068ce:	e9 84 f6 ff ff       	jmp    80105f57 <alltraps>

801068d3 <vector133>:
.globl vector133
vector133:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $133
801068d5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801068da:	e9 78 f6 ff ff       	jmp    80105f57 <alltraps>

801068df <vector134>:
.globl vector134
vector134:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $134
801068e1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801068e6:	e9 6c f6 ff ff       	jmp    80105f57 <alltraps>

801068eb <vector135>:
.globl vector135
vector135:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $135
801068ed:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801068f2:	e9 60 f6 ff ff       	jmp    80105f57 <alltraps>

801068f7 <vector136>:
.globl vector136
vector136:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $136
801068f9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801068fe:	e9 54 f6 ff ff       	jmp    80105f57 <alltraps>

80106903 <vector137>:
.globl vector137
vector137:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $137
80106905:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010690a:	e9 48 f6 ff ff       	jmp    80105f57 <alltraps>

8010690f <vector138>:
.globl vector138
vector138:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $138
80106911:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106916:	e9 3c f6 ff ff       	jmp    80105f57 <alltraps>

8010691b <vector139>:
.globl vector139
vector139:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $139
8010691d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106922:	e9 30 f6 ff ff       	jmp    80105f57 <alltraps>

80106927 <vector140>:
.globl vector140
vector140:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $140
80106929:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010692e:	e9 24 f6 ff ff       	jmp    80105f57 <alltraps>

80106933 <vector141>:
.globl vector141
vector141:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $141
80106935:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010693a:	e9 18 f6 ff ff       	jmp    80105f57 <alltraps>

8010693f <vector142>:
.globl vector142
vector142:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $142
80106941:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106946:	e9 0c f6 ff ff       	jmp    80105f57 <alltraps>

8010694b <vector143>:
.globl vector143
vector143:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $143
8010694d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106952:	e9 00 f6 ff ff       	jmp    80105f57 <alltraps>

80106957 <vector144>:
.globl vector144
vector144:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $144
80106959:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010695e:	e9 f4 f5 ff ff       	jmp    80105f57 <alltraps>

80106963 <vector145>:
.globl vector145
vector145:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $145
80106965:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010696a:	e9 e8 f5 ff ff       	jmp    80105f57 <alltraps>

8010696f <vector146>:
.globl vector146
vector146:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $146
80106971:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106976:	e9 dc f5 ff ff       	jmp    80105f57 <alltraps>

8010697b <vector147>:
.globl vector147
vector147:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $147
8010697d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106982:	e9 d0 f5 ff ff       	jmp    80105f57 <alltraps>

80106987 <vector148>:
.globl vector148
vector148:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $148
80106989:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010698e:	e9 c4 f5 ff ff       	jmp    80105f57 <alltraps>

80106993 <vector149>:
.globl vector149
vector149:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $149
80106995:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010699a:	e9 b8 f5 ff ff       	jmp    80105f57 <alltraps>

8010699f <vector150>:
.globl vector150
vector150:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $150
801069a1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801069a6:	e9 ac f5 ff ff       	jmp    80105f57 <alltraps>

801069ab <vector151>:
.globl vector151
vector151:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $151
801069ad:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801069b2:	e9 a0 f5 ff ff       	jmp    80105f57 <alltraps>

801069b7 <vector152>:
.globl vector152
vector152:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $152
801069b9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801069be:	e9 94 f5 ff ff       	jmp    80105f57 <alltraps>

801069c3 <vector153>:
.globl vector153
vector153:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $153
801069c5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801069ca:	e9 88 f5 ff ff       	jmp    80105f57 <alltraps>

801069cf <vector154>:
.globl vector154
vector154:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $154
801069d1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801069d6:	e9 7c f5 ff ff       	jmp    80105f57 <alltraps>

801069db <vector155>:
.globl vector155
vector155:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $155
801069dd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801069e2:	e9 70 f5 ff ff       	jmp    80105f57 <alltraps>

801069e7 <vector156>:
.globl vector156
vector156:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $156
801069e9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801069ee:	e9 64 f5 ff ff       	jmp    80105f57 <alltraps>

801069f3 <vector157>:
.globl vector157
vector157:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $157
801069f5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801069fa:	e9 58 f5 ff ff       	jmp    80105f57 <alltraps>

801069ff <vector158>:
.globl vector158
vector158:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $158
80106a01:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106a06:	e9 4c f5 ff ff       	jmp    80105f57 <alltraps>

80106a0b <vector159>:
.globl vector159
vector159:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $159
80106a0d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106a12:	e9 40 f5 ff ff       	jmp    80105f57 <alltraps>

80106a17 <vector160>:
.globl vector160
vector160:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $160
80106a19:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106a1e:	e9 34 f5 ff ff       	jmp    80105f57 <alltraps>

80106a23 <vector161>:
.globl vector161
vector161:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $161
80106a25:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106a2a:	e9 28 f5 ff ff       	jmp    80105f57 <alltraps>

80106a2f <vector162>:
.globl vector162
vector162:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $162
80106a31:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106a36:	e9 1c f5 ff ff       	jmp    80105f57 <alltraps>

80106a3b <vector163>:
.globl vector163
vector163:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $163
80106a3d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106a42:	e9 10 f5 ff ff       	jmp    80105f57 <alltraps>

80106a47 <vector164>:
.globl vector164
vector164:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $164
80106a49:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106a4e:	e9 04 f5 ff ff       	jmp    80105f57 <alltraps>

80106a53 <vector165>:
.globl vector165
vector165:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $165
80106a55:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106a5a:	e9 f8 f4 ff ff       	jmp    80105f57 <alltraps>

80106a5f <vector166>:
.globl vector166
vector166:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $166
80106a61:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106a66:	e9 ec f4 ff ff       	jmp    80105f57 <alltraps>

80106a6b <vector167>:
.globl vector167
vector167:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $167
80106a6d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106a72:	e9 e0 f4 ff ff       	jmp    80105f57 <alltraps>

80106a77 <vector168>:
.globl vector168
vector168:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $168
80106a79:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106a7e:	e9 d4 f4 ff ff       	jmp    80105f57 <alltraps>

80106a83 <vector169>:
.globl vector169
vector169:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $169
80106a85:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106a8a:	e9 c8 f4 ff ff       	jmp    80105f57 <alltraps>

80106a8f <vector170>:
.globl vector170
vector170:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $170
80106a91:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106a96:	e9 bc f4 ff ff       	jmp    80105f57 <alltraps>

80106a9b <vector171>:
.globl vector171
vector171:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $171
80106a9d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106aa2:	e9 b0 f4 ff ff       	jmp    80105f57 <alltraps>

80106aa7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $172
80106aa9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106aae:	e9 a4 f4 ff ff       	jmp    80105f57 <alltraps>

80106ab3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $173
80106ab5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106aba:	e9 98 f4 ff ff       	jmp    80105f57 <alltraps>

80106abf <vector174>:
.globl vector174
vector174:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $174
80106ac1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106ac6:	e9 8c f4 ff ff       	jmp    80105f57 <alltraps>

80106acb <vector175>:
.globl vector175
vector175:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $175
80106acd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106ad2:	e9 80 f4 ff ff       	jmp    80105f57 <alltraps>

80106ad7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $176
80106ad9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106ade:	e9 74 f4 ff ff       	jmp    80105f57 <alltraps>

80106ae3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $177
80106ae5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106aea:	e9 68 f4 ff ff       	jmp    80105f57 <alltraps>

80106aef <vector178>:
.globl vector178
vector178:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $178
80106af1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106af6:	e9 5c f4 ff ff       	jmp    80105f57 <alltraps>

80106afb <vector179>:
.globl vector179
vector179:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $179
80106afd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106b02:	e9 50 f4 ff ff       	jmp    80105f57 <alltraps>

80106b07 <vector180>:
.globl vector180
vector180:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $180
80106b09:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106b0e:	e9 44 f4 ff ff       	jmp    80105f57 <alltraps>

80106b13 <vector181>:
.globl vector181
vector181:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $181
80106b15:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106b1a:	e9 38 f4 ff ff       	jmp    80105f57 <alltraps>

80106b1f <vector182>:
.globl vector182
vector182:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $182
80106b21:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106b26:	e9 2c f4 ff ff       	jmp    80105f57 <alltraps>

80106b2b <vector183>:
.globl vector183
vector183:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $183
80106b2d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106b32:	e9 20 f4 ff ff       	jmp    80105f57 <alltraps>

80106b37 <vector184>:
.globl vector184
vector184:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $184
80106b39:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106b3e:	e9 14 f4 ff ff       	jmp    80105f57 <alltraps>

80106b43 <vector185>:
.globl vector185
vector185:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $185
80106b45:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106b4a:	e9 08 f4 ff ff       	jmp    80105f57 <alltraps>

80106b4f <vector186>:
.globl vector186
vector186:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $186
80106b51:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106b56:	e9 fc f3 ff ff       	jmp    80105f57 <alltraps>

80106b5b <vector187>:
.globl vector187
vector187:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $187
80106b5d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106b62:	e9 f0 f3 ff ff       	jmp    80105f57 <alltraps>

80106b67 <vector188>:
.globl vector188
vector188:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $188
80106b69:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106b6e:	e9 e4 f3 ff ff       	jmp    80105f57 <alltraps>

80106b73 <vector189>:
.globl vector189
vector189:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $189
80106b75:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106b7a:	e9 d8 f3 ff ff       	jmp    80105f57 <alltraps>

80106b7f <vector190>:
.globl vector190
vector190:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $190
80106b81:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106b86:	e9 cc f3 ff ff       	jmp    80105f57 <alltraps>

80106b8b <vector191>:
.globl vector191
vector191:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $191
80106b8d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106b92:	e9 c0 f3 ff ff       	jmp    80105f57 <alltraps>

80106b97 <vector192>:
.globl vector192
vector192:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $192
80106b99:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106b9e:	e9 b4 f3 ff ff       	jmp    80105f57 <alltraps>

80106ba3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $193
80106ba5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106baa:	e9 a8 f3 ff ff       	jmp    80105f57 <alltraps>

80106baf <vector194>:
.globl vector194
vector194:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $194
80106bb1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106bb6:	e9 9c f3 ff ff       	jmp    80105f57 <alltraps>

80106bbb <vector195>:
.globl vector195
vector195:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $195
80106bbd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106bc2:	e9 90 f3 ff ff       	jmp    80105f57 <alltraps>

80106bc7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $196
80106bc9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106bce:	e9 84 f3 ff ff       	jmp    80105f57 <alltraps>

80106bd3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $197
80106bd5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106bda:	e9 78 f3 ff ff       	jmp    80105f57 <alltraps>

80106bdf <vector198>:
.globl vector198
vector198:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $198
80106be1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106be6:	e9 6c f3 ff ff       	jmp    80105f57 <alltraps>

80106beb <vector199>:
.globl vector199
vector199:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $199
80106bed:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106bf2:	e9 60 f3 ff ff       	jmp    80105f57 <alltraps>

80106bf7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $200
80106bf9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106bfe:	e9 54 f3 ff ff       	jmp    80105f57 <alltraps>

80106c03 <vector201>:
.globl vector201
vector201:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $201
80106c05:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106c0a:	e9 48 f3 ff ff       	jmp    80105f57 <alltraps>

80106c0f <vector202>:
.globl vector202
vector202:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $202
80106c11:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106c16:	e9 3c f3 ff ff       	jmp    80105f57 <alltraps>

80106c1b <vector203>:
.globl vector203
vector203:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $203
80106c1d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106c22:	e9 30 f3 ff ff       	jmp    80105f57 <alltraps>

80106c27 <vector204>:
.globl vector204
vector204:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $204
80106c29:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106c2e:	e9 24 f3 ff ff       	jmp    80105f57 <alltraps>

80106c33 <vector205>:
.globl vector205
vector205:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $205
80106c35:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106c3a:	e9 18 f3 ff ff       	jmp    80105f57 <alltraps>

80106c3f <vector206>:
.globl vector206
vector206:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $206
80106c41:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106c46:	e9 0c f3 ff ff       	jmp    80105f57 <alltraps>

80106c4b <vector207>:
.globl vector207
vector207:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $207
80106c4d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106c52:	e9 00 f3 ff ff       	jmp    80105f57 <alltraps>

80106c57 <vector208>:
.globl vector208
vector208:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $208
80106c59:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106c5e:	e9 f4 f2 ff ff       	jmp    80105f57 <alltraps>

80106c63 <vector209>:
.globl vector209
vector209:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $209
80106c65:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106c6a:	e9 e8 f2 ff ff       	jmp    80105f57 <alltraps>

80106c6f <vector210>:
.globl vector210
vector210:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $210
80106c71:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106c76:	e9 dc f2 ff ff       	jmp    80105f57 <alltraps>

80106c7b <vector211>:
.globl vector211
vector211:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $211
80106c7d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106c82:	e9 d0 f2 ff ff       	jmp    80105f57 <alltraps>

80106c87 <vector212>:
.globl vector212
vector212:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $212
80106c89:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106c8e:	e9 c4 f2 ff ff       	jmp    80105f57 <alltraps>

80106c93 <vector213>:
.globl vector213
vector213:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $213
80106c95:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106c9a:	e9 b8 f2 ff ff       	jmp    80105f57 <alltraps>

80106c9f <vector214>:
.globl vector214
vector214:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $214
80106ca1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106ca6:	e9 ac f2 ff ff       	jmp    80105f57 <alltraps>

80106cab <vector215>:
.globl vector215
vector215:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $215
80106cad:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106cb2:	e9 a0 f2 ff ff       	jmp    80105f57 <alltraps>

80106cb7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $216
80106cb9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106cbe:	e9 94 f2 ff ff       	jmp    80105f57 <alltraps>

80106cc3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $217
80106cc5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106cca:	e9 88 f2 ff ff       	jmp    80105f57 <alltraps>

80106ccf <vector218>:
.globl vector218
vector218:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $218
80106cd1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106cd6:	e9 7c f2 ff ff       	jmp    80105f57 <alltraps>

80106cdb <vector219>:
.globl vector219
vector219:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $219
80106cdd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ce2:	e9 70 f2 ff ff       	jmp    80105f57 <alltraps>

80106ce7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $220
80106ce9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106cee:	e9 64 f2 ff ff       	jmp    80105f57 <alltraps>

80106cf3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $221
80106cf5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106cfa:	e9 58 f2 ff ff       	jmp    80105f57 <alltraps>

80106cff <vector222>:
.globl vector222
vector222:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $222
80106d01:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106d06:	e9 4c f2 ff ff       	jmp    80105f57 <alltraps>

80106d0b <vector223>:
.globl vector223
vector223:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $223
80106d0d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106d12:	e9 40 f2 ff ff       	jmp    80105f57 <alltraps>

80106d17 <vector224>:
.globl vector224
vector224:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $224
80106d19:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106d1e:	e9 34 f2 ff ff       	jmp    80105f57 <alltraps>

80106d23 <vector225>:
.globl vector225
vector225:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $225
80106d25:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106d2a:	e9 28 f2 ff ff       	jmp    80105f57 <alltraps>

80106d2f <vector226>:
.globl vector226
vector226:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $226
80106d31:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106d36:	e9 1c f2 ff ff       	jmp    80105f57 <alltraps>

80106d3b <vector227>:
.globl vector227
vector227:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $227
80106d3d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106d42:	e9 10 f2 ff ff       	jmp    80105f57 <alltraps>

80106d47 <vector228>:
.globl vector228
vector228:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $228
80106d49:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106d4e:	e9 04 f2 ff ff       	jmp    80105f57 <alltraps>

80106d53 <vector229>:
.globl vector229
vector229:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $229
80106d55:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106d5a:	e9 f8 f1 ff ff       	jmp    80105f57 <alltraps>

80106d5f <vector230>:
.globl vector230
vector230:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $230
80106d61:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106d66:	e9 ec f1 ff ff       	jmp    80105f57 <alltraps>

80106d6b <vector231>:
.globl vector231
vector231:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $231
80106d6d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106d72:	e9 e0 f1 ff ff       	jmp    80105f57 <alltraps>

80106d77 <vector232>:
.globl vector232
vector232:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $232
80106d79:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106d7e:	e9 d4 f1 ff ff       	jmp    80105f57 <alltraps>

80106d83 <vector233>:
.globl vector233
vector233:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $233
80106d85:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106d8a:	e9 c8 f1 ff ff       	jmp    80105f57 <alltraps>

80106d8f <vector234>:
.globl vector234
vector234:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $234
80106d91:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106d96:	e9 bc f1 ff ff       	jmp    80105f57 <alltraps>

80106d9b <vector235>:
.globl vector235
vector235:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $235
80106d9d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106da2:	e9 b0 f1 ff ff       	jmp    80105f57 <alltraps>

80106da7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $236
80106da9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106dae:	e9 a4 f1 ff ff       	jmp    80105f57 <alltraps>

80106db3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $237
80106db5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106dba:	e9 98 f1 ff ff       	jmp    80105f57 <alltraps>

80106dbf <vector238>:
.globl vector238
vector238:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $238
80106dc1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106dc6:	e9 8c f1 ff ff       	jmp    80105f57 <alltraps>

80106dcb <vector239>:
.globl vector239
vector239:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $239
80106dcd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106dd2:	e9 80 f1 ff ff       	jmp    80105f57 <alltraps>

80106dd7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $240
80106dd9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106dde:	e9 74 f1 ff ff       	jmp    80105f57 <alltraps>

80106de3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $241
80106de5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106dea:	e9 68 f1 ff ff       	jmp    80105f57 <alltraps>

80106def <vector242>:
.globl vector242
vector242:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $242
80106df1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106df6:	e9 5c f1 ff ff       	jmp    80105f57 <alltraps>

80106dfb <vector243>:
.globl vector243
vector243:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $243
80106dfd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106e02:	e9 50 f1 ff ff       	jmp    80105f57 <alltraps>

80106e07 <vector244>:
.globl vector244
vector244:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $244
80106e09:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106e0e:	e9 44 f1 ff ff       	jmp    80105f57 <alltraps>

80106e13 <vector245>:
.globl vector245
vector245:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $245
80106e15:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106e1a:	e9 38 f1 ff ff       	jmp    80105f57 <alltraps>

80106e1f <vector246>:
.globl vector246
vector246:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $246
80106e21:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106e26:	e9 2c f1 ff ff       	jmp    80105f57 <alltraps>

80106e2b <vector247>:
.globl vector247
vector247:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $247
80106e2d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106e32:	e9 20 f1 ff ff       	jmp    80105f57 <alltraps>

80106e37 <vector248>:
.globl vector248
vector248:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $248
80106e39:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106e3e:	e9 14 f1 ff ff       	jmp    80105f57 <alltraps>

80106e43 <vector249>:
.globl vector249
vector249:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $249
80106e45:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106e4a:	e9 08 f1 ff ff       	jmp    80105f57 <alltraps>

80106e4f <vector250>:
.globl vector250
vector250:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $250
80106e51:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106e56:	e9 fc f0 ff ff       	jmp    80105f57 <alltraps>

80106e5b <vector251>:
.globl vector251
vector251:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $251
80106e5d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106e62:	e9 f0 f0 ff ff       	jmp    80105f57 <alltraps>

80106e67 <vector252>:
.globl vector252
vector252:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $252
80106e69:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106e6e:	e9 e4 f0 ff ff       	jmp    80105f57 <alltraps>

80106e73 <vector253>:
.globl vector253
vector253:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $253
80106e75:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106e7a:	e9 d8 f0 ff ff       	jmp    80105f57 <alltraps>

80106e7f <vector254>:
.globl vector254
vector254:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $254
80106e81:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106e86:	e9 cc f0 ff ff       	jmp    80105f57 <alltraps>

80106e8b <vector255>:
.globl vector255
vector255:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $255
80106e8d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106e92:	e9 c0 f0 ff ff       	jmp    80105f57 <alltraps>
80106e97:	66 90                	xchg   %ax,%ax
80106e99:	66 90                	xchg   %ax,%ax
80106e9b:	66 90                	xchg   %ax,%ax
80106e9d:	66 90                	xchg   %ax,%ax
80106e9f:	90                   	nop

80106ea0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	57                   	push   %edi
80106ea4:	56                   	push   %esi
80106ea5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106ea6:	89 d3                	mov    %edx,%ebx
{
80106ea8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106eaa:	c1 eb 16             	shr    $0x16,%ebx
80106ead:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106eb0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106eb3:	8b 06                	mov    (%esi),%eax
80106eb5:	a8 01                	test   $0x1,%al
80106eb7:	74 27                	je     80106ee0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106eb9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ebe:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106ec4:	c1 ef 0a             	shr    $0xa,%edi
}
80106ec7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106eca:	89 fa                	mov    %edi,%edx
80106ecc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106ed2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106ed5:	5b                   	pop    %ebx
80106ed6:	5e                   	pop    %esi
80106ed7:	5f                   	pop    %edi
80106ed8:	5d                   	pop    %ebp
80106ed9:	c3                   	ret    
80106eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106ee0:	85 c9                	test   %ecx,%ecx
80106ee2:	74 2c                	je     80106f10 <walkpgdir+0x70>
80106ee4:	e8 c7 ba ff ff       	call   801029b0 <kalloc>
80106ee9:	85 c0                	test   %eax,%eax
80106eeb:	89 c3                	mov    %eax,%ebx
80106eed:	74 21                	je     80106f10 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106eef:	83 ec 04             	sub    $0x4,%esp
80106ef2:	68 00 10 00 00       	push   $0x1000
80106ef7:	6a 00                	push   $0x0
80106ef9:	50                   	push   %eax
80106efa:	e8 f1 dd ff ff       	call   80104cf0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106eff:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f05:	83 c4 10             	add    $0x10,%esp
80106f08:	83 c8 07             	or     $0x7,%eax
80106f0b:	89 06                	mov    %eax,(%esi)
80106f0d:	eb b5                	jmp    80106ec4 <walkpgdir+0x24>
80106f0f:	90                   	nop
}
80106f10:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106f13:	31 c0                	xor    %eax,%eax
}
80106f15:	5b                   	pop    %ebx
80106f16:	5e                   	pop    %esi
80106f17:	5f                   	pop    %edi
80106f18:	5d                   	pop    %ebp
80106f19:	c3                   	ret    
80106f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f20 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	57                   	push   %edi
80106f24:	56                   	push   %esi
80106f25:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106f26:	89 d3                	mov    %edx,%ebx
80106f28:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106f2e:	83 ec 1c             	sub    $0x1c,%esp
80106f31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f34:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106f38:	8b 7d 08             	mov    0x8(%ebp),%edi
80106f3b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f40:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106f43:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f46:	29 df                	sub    %ebx,%edi
80106f48:	83 c8 01             	or     $0x1,%eax
80106f4b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106f4e:	eb 15                	jmp    80106f65 <mappages+0x45>
    if(*pte & PTE_P)
80106f50:	f6 00 01             	testb  $0x1,(%eax)
80106f53:	75 45                	jne    80106f9a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106f55:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106f58:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106f5b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106f5d:	74 31                	je     80106f90 <mappages+0x70>
      break;
    a += PGSIZE;
80106f5f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106f65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f68:	b9 01 00 00 00       	mov    $0x1,%ecx
80106f6d:	89 da                	mov    %ebx,%edx
80106f6f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106f72:	e8 29 ff ff ff       	call   80106ea0 <walkpgdir>
80106f77:	85 c0                	test   %eax,%eax
80106f79:	75 d5                	jne    80106f50 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106f7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f83:	5b                   	pop    %ebx
80106f84:	5e                   	pop    %esi
80106f85:	5f                   	pop    %edi
80106f86:	5d                   	pop    %ebp
80106f87:	c3                   	ret    
80106f88:	90                   	nop
80106f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f93:	31 c0                	xor    %eax,%eax
}
80106f95:	5b                   	pop    %ebx
80106f96:	5e                   	pop    %esi
80106f97:	5f                   	pop    %edi
80106f98:	5d                   	pop    %ebp
80106f99:	c3                   	ret    
      panic("remap");
80106f9a:	83 ec 0c             	sub    $0xc,%esp
80106f9d:	68 b4 83 10 80       	push   $0x801083b4
80106fa2:	e8 e9 93 ff ff       	call   80100390 <panic>
80106fa7:	89 f6                	mov    %esi,%esi
80106fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fb0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106fb0:	55                   	push   %ebp
80106fb1:	89 e5                	mov    %esp,%ebp
80106fb3:	57                   	push   %edi
80106fb4:	56                   	push   %esi
80106fb5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106fb6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106fbc:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106fbe:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106fc4:	83 ec 1c             	sub    $0x1c,%esp
80106fc7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106fca:	39 d3                	cmp    %edx,%ebx
80106fcc:	73 66                	jae    80107034 <deallocuvm.part.0+0x84>
80106fce:	89 d6                	mov    %edx,%esi
80106fd0:	eb 3d                	jmp    8010700f <deallocuvm.part.0+0x5f>
80106fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106fd8:	8b 10                	mov    (%eax),%edx
80106fda:	f6 c2 01             	test   $0x1,%dl
80106fdd:	74 26                	je     80107005 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106fdf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106fe5:	74 58                	je     8010703f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106fe7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106fea:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106ff0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106ff3:	52                   	push   %edx
80106ff4:	e8 07 b8 ff ff       	call   80102800 <kfree>
      *pte = 0;
80106ff9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ffc:	83 c4 10             	add    $0x10,%esp
80106fff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107005:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010700b:	39 f3                	cmp    %esi,%ebx
8010700d:	73 25                	jae    80107034 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010700f:	31 c9                	xor    %ecx,%ecx
80107011:	89 da                	mov    %ebx,%edx
80107013:	89 f8                	mov    %edi,%eax
80107015:	e8 86 fe ff ff       	call   80106ea0 <walkpgdir>
    if(!pte)
8010701a:	85 c0                	test   %eax,%eax
8010701c:	75 ba                	jne    80106fd8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010701e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107024:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010702a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107030:	39 f3                	cmp    %esi,%ebx
80107032:	72 db                	jb     8010700f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80107034:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107037:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010703a:	5b                   	pop    %ebx
8010703b:	5e                   	pop    %esi
8010703c:	5f                   	pop    %edi
8010703d:	5d                   	pop    %ebp
8010703e:	c3                   	ret    
        panic("kfree");
8010703f:	83 ec 0c             	sub    $0xc,%esp
80107042:	68 f2 7c 10 80       	push   $0x80107cf2
80107047:	e8 44 93 ff ff       	call   80100390 <panic>
8010704c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107050 <seginit>:
{
80107050:	55                   	push   %ebp
80107051:	89 e5                	mov    %esp,%ebp
80107053:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107056:	e8 c5 cc ff ff       	call   80103d20 <cpuid>
8010705b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107061:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107066:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010706a:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
80107071:	ff 00 00 
80107074:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
8010707b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010707e:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
80107085:	ff 00 00 
80107088:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
8010708f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107092:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
80107099:	ff 00 00 
8010709c:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
801070a3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801070a6:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
801070ad:	ff 00 00 
801070b0:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
801070b7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801070ba:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
801070bf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801070c3:	c1 e8 10             	shr    $0x10,%eax
801070c6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801070ca:	8d 45 f2             	lea    -0xe(%ebp),%eax
801070cd:	0f 01 10             	lgdtl  (%eax)
}
801070d0:	c9                   	leave  
801070d1:	c3                   	ret    
801070d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070e0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801070e0:	a1 c4 28 12 80       	mov    0x801228c4,%eax
{
801070e5:	55                   	push   %ebp
801070e6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801070e8:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801070ed:	0f 22 d8             	mov    %eax,%cr3
}
801070f0:	5d                   	pop    %ebp
801070f1:	c3                   	ret    
801070f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107100 <switchuvm>:
{
80107100:	55                   	push   %ebp
80107101:	89 e5                	mov    %esp,%ebp
80107103:	57                   	push   %edi
80107104:	56                   	push   %esi
80107105:	53                   	push   %ebx
80107106:	83 ec 1c             	sub    $0x1c,%esp
80107109:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010710c:	85 db                	test   %ebx,%ebx
8010710e:	0f 84 cb 00 00 00    	je     801071df <switchuvm+0xdf>
  if(p->kstack == 0)
80107114:	8b 43 08             	mov    0x8(%ebx),%eax
80107117:	85 c0                	test   %eax,%eax
80107119:	0f 84 da 00 00 00    	je     801071f9 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010711f:	8b 43 04             	mov    0x4(%ebx),%eax
80107122:	85 c0                	test   %eax,%eax
80107124:	0f 84 c2 00 00 00    	je     801071ec <switchuvm+0xec>
  pushcli();
8010712a:	e8 01 da ff ff       	call   80104b30 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010712f:	e8 6c cb ff ff       	call   80103ca0 <mycpu>
80107134:	89 c6                	mov    %eax,%esi
80107136:	e8 65 cb ff ff       	call   80103ca0 <mycpu>
8010713b:	89 c7                	mov    %eax,%edi
8010713d:	e8 5e cb ff ff       	call   80103ca0 <mycpu>
80107142:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107145:	83 c7 08             	add    $0x8,%edi
80107148:	e8 53 cb ff ff       	call   80103ca0 <mycpu>
8010714d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107150:	83 c0 08             	add    $0x8,%eax
80107153:	ba 67 00 00 00       	mov    $0x67,%edx
80107158:	c1 e8 18             	shr    $0x18,%eax
8010715b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107162:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107169:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010716f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107174:	83 c1 08             	add    $0x8,%ecx
80107177:	c1 e9 10             	shr    $0x10,%ecx
8010717a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107180:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107185:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010718c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107191:	e8 0a cb ff ff       	call   80103ca0 <mycpu>
80107196:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010719d:	e8 fe ca ff ff       	call   80103ca0 <mycpu>
801071a2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801071a6:	8b 73 08             	mov    0x8(%ebx),%esi
801071a9:	e8 f2 ca ff ff       	call   80103ca0 <mycpu>
801071ae:	81 c6 00 10 00 00    	add    $0x1000,%esi
801071b4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801071b7:	e8 e4 ca ff ff       	call   80103ca0 <mycpu>
801071bc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801071c0:	b8 28 00 00 00       	mov    $0x28,%eax
801071c5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801071c8:	8b 43 04             	mov    0x4(%ebx),%eax
801071cb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801071d0:	0f 22 d8             	mov    %eax,%cr3
}
801071d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071d6:	5b                   	pop    %ebx
801071d7:	5e                   	pop    %esi
801071d8:	5f                   	pop    %edi
801071d9:	5d                   	pop    %ebp
  popcli();
801071da:	e9 51 da ff ff       	jmp    80104c30 <popcli>
    panic("switchuvm: no process");
801071df:	83 ec 0c             	sub    $0xc,%esp
801071e2:	68 ba 83 10 80       	push   $0x801083ba
801071e7:	e8 a4 91 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801071ec:	83 ec 0c             	sub    $0xc,%esp
801071ef:	68 e5 83 10 80       	push   $0x801083e5
801071f4:	e8 97 91 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801071f9:	83 ec 0c             	sub    $0xc,%esp
801071fc:	68 d0 83 10 80       	push   $0x801083d0
80107201:	e8 8a 91 ff ff       	call   80100390 <panic>
80107206:	8d 76 00             	lea    0x0(%esi),%esi
80107209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107210 <inituvm>:
{
80107210:	55                   	push   %ebp
80107211:	89 e5                	mov    %esp,%ebp
80107213:	57                   	push   %edi
80107214:	56                   	push   %esi
80107215:	53                   	push   %ebx
80107216:	83 ec 1c             	sub    $0x1c,%esp
80107219:	8b 75 10             	mov    0x10(%ebp),%esi
8010721c:	8b 45 08             	mov    0x8(%ebp),%eax
8010721f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107222:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107228:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010722b:	77 49                	ja     80107276 <inituvm+0x66>
  mem = kalloc();
8010722d:	e8 7e b7 ff ff       	call   801029b0 <kalloc>
  memset(mem, 0, PGSIZE);
80107232:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107235:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107237:	68 00 10 00 00       	push   $0x1000
8010723c:	6a 00                	push   $0x0
8010723e:	50                   	push   %eax
8010723f:	e8 ac da ff ff       	call   80104cf0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107244:	58                   	pop    %eax
80107245:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010724b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107250:	5a                   	pop    %edx
80107251:	6a 06                	push   $0x6
80107253:	50                   	push   %eax
80107254:	31 d2                	xor    %edx,%edx
80107256:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107259:	e8 c2 fc ff ff       	call   80106f20 <mappages>
  memmove(mem, init, sz);
8010725e:	89 75 10             	mov    %esi,0x10(%ebp)
80107261:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107264:	83 c4 10             	add    $0x10,%esp
80107267:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010726a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010726d:	5b                   	pop    %ebx
8010726e:	5e                   	pop    %esi
8010726f:	5f                   	pop    %edi
80107270:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107271:	e9 2a db ff ff       	jmp    80104da0 <memmove>
    panic("inituvm: more than a page");
80107276:	83 ec 0c             	sub    $0xc,%esp
80107279:	68 f9 83 10 80       	push   $0x801083f9
8010727e:	e8 0d 91 ff ff       	call   80100390 <panic>
80107283:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107290 <loaduvm>:
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	57                   	push   %edi
80107294:	56                   	push   %esi
80107295:	53                   	push   %ebx
80107296:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107299:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801072a0:	0f 85 91 00 00 00    	jne    80107337 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
801072a6:	8b 75 18             	mov    0x18(%ebp),%esi
801072a9:	31 db                	xor    %ebx,%ebx
801072ab:	85 f6                	test   %esi,%esi
801072ad:	75 1a                	jne    801072c9 <loaduvm+0x39>
801072af:	eb 6f                	jmp    80107320 <loaduvm+0x90>
801072b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072b8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801072be:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801072c4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801072c7:	76 57                	jbe    80107320 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801072c9:	8b 55 0c             	mov    0xc(%ebp),%edx
801072cc:	8b 45 08             	mov    0x8(%ebp),%eax
801072cf:	31 c9                	xor    %ecx,%ecx
801072d1:	01 da                	add    %ebx,%edx
801072d3:	e8 c8 fb ff ff       	call   80106ea0 <walkpgdir>
801072d8:	85 c0                	test   %eax,%eax
801072da:	74 4e                	je     8010732a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
801072dc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801072de:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
801072e1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801072e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801072eb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801072f1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801072f4:	01 d9                	add    %ebx,%ecx
801072f6:	05 00 00 00 80       	add    $0x80000000,%eax
801072fb:	57                   	push   %edi
801072fc:	51                   	push   %ecx
801072fd:	50                   	push   %eax
801072fe:	ff 75 10             	pushl  0x10(%ebp)
80107301:	e8 ea a6 ff ff       	call   801019f0 <readi>
80107306:	83 c4 10             	add    $0x10,%esp
80107309:	39 f8                	cmp    %edi,%eax
8010730b:	74 ab                	je     801072b8 <loaduvm+0x28>
}
8010730d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107310:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107315:	5b                   	pop    %ebx
80107316:	5e                   	pop    %esi
80107317:	5f                   	pop    %edi
80107318:	5d                   	pop    %ebp
80107319:	c3                   	ret    
8010731a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107320:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107323:	31 c0                	xor    %eax,%eax
}
80107325:	5b                   	pop    %ebx
80107326:	5e                   	pop    %esi
80107327:	5f                   	pop    %edi
80107328:	5d                   	pop    %ebp
80107329:	c3                   	ret    
      panic("loaduvm: address should exist");
8010732a:	83 ec 0c             	sub    $0xc,%esp
8010732d:	68 13 84 10 80       	push   $0x80108413
80107332:	e8 59 90 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107337:	83 ec 0c             	sub    $0xc,%esp
8010733a:	68 80 84 10 80       	push   $0x80108480
8010733f:	e8 4c 90 ff ff       	call   80100390 <panic>
80107344:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010734a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107350 <addPage>:
int addPage(uint *pg_entry,char* a){
80107350:	55                   	push   %ebp
80107351:	89 e5                	mov    %esp,%ebp
80107353:	53                   	push   %ebx
80107354:	83 ec 04             	sub    $0x4,%esp
  struct proc* curProc = myproc();
80107357:	e8 e4 c9 ff ff       	call   80103d40 <myproc>
  for(int i = 0; i < MAX_PSYC_PAGES; i++){
8010735c:	31 d2                	xor    %edx,%edx
  struct proc* curProc = myproc();
8010735e:	89 c3                	mov    %eax,%ebx
80107360:	8d 88 0c 02 00 00    	lea    0x20c(%eax),%ecx
80107366:	eb 13                	jmp    8010737b <addPage+0x2b>
80107368:	90                   	nop
80107369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(int i = 0; i < MAX_PSYC_PAGES; i++){
80107370:	83 c2 01             	add    $0x1,%edx
80107373:	83 c1 18             	add    $0x18,%ecx
80107376:	83 fa 10             	cmp    $0x10,%edx
80107379:	74 55                	je     801073d0 <addPage+0x80>
    if(!curProc->procPhysPages[i].isOccupied){
8010737b:	8b 01                	mov    (%ecx),%eax
8010737d:	85 c0                	test   %eax,%eax
8010737f:	75 ef                	jne    80107370 <addPage+0x20>
      curProc->procPhysPages[i].isOccupied = 1; 
80107381:	8d 04 52             	lea    (%edx,%edx,2),%eax
      curProc->procPhysPages[i].va = a;
80107384:	8b 4d 0c             	mov    0xc(%ebp),%ecx
      insertNode(&curProc->procPhysPages[i]);
80107387:	83 ec 0c             	sub    $0xc,%esp
      curProc->procPhysPages[i].isOccupied = 1; 
8010738a:	c1 e0 03             	shl    $0x3,%eax
8010738d:	8d 14 03             	lea    (%ebx,%eax,1),%edx
      insertNode(&curProc->procPhysPages[i]);
80107390:	8d 84 03 00 02 00 00 	lea    0x200(%ebx,%eax,1),%eax
      curProc->procPhysPages[i].va = a;
80107397:	89 8a 00 02 00 00    	mov    %ecx,0x200(%edx)
      curProc->procPhysPages[i].pte = pg_entry;
8010739d:	8b 4d 08             	mov    0x8(%ebp),%ecx
      curProc->procPhysPages[i].isOccupied = 1; 
801073a0:	c7 82 0c 02 00 00 01 	movl   $0x1,0x20c(%edx)
801073a7:	00 00 00 
      curProc->procPhysPages[i].pte = pg_entry;
801073aa:	89 8a 04 02 00 00    	mov    %ecx,0x204(%edx)
      insertNode(&curProc->procPhysPages[i]);
801073b0:	50                   	push   %eax
801073b1:	e8 7a d5 ff ff       	call   80104930 <insertNode>
      curProc->numOfPhysPages++;
801073b6:	83 83 80 03 00 00 01 	addl   $0x1,0x380(%ebx)
      return 1;
801073bd:	83 c4 10             	add    $0x10,%esp
801073c0:	b8 01 00 00 00       	mov    $0x1,%eax
}
801073c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801073c8:	c9                   	leave  
801073c9:	c3                   	ret    
801073ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return 0;
801073d0:	31 c0                	xor    %eax,%eax
}
801073d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801073d5:	c9                   	leave  
801073d6:	c3                   	ret    
801073d7:	89 f6                	mov    %esi,%esi
801073d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073e0 <allocuvm>:
{
801073e0:	55                   	push   %ebp
801073e1:	89 e5                	mov    %esp,%ebp
801073e3:	57                   	push   %edi
801073e4:	56                   	push   %esi
801073e5:	53                   	push   %ebx
801073e6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801073e9:	8b 7d 10             	mov    0x10(%ebp),%edi
801073ec:	85 ff                	test   %edi,%edi
801073ee:	0f 88 fc 00 00 00    	js     801074f0 <allocuvm+0x110>
  if(newsz < oldsz)
801073f4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801073f7:	0f 82 d7 00 00 00    	jb     801074d4 <allocuvm+0xf4>
  a = PGROUNDUP(oldsz);
801073fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80107400:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107406:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010740c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010740f:	0f 86 c2 00 00 00    	jbe    801074d7 <allocuvm+0xf7>
80107415:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107418:	eb 15                	jmp    8010742f <allocuvm+0x4f>
8010741a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107420:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107426:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107429:	0f 86 f9 00 00 00    	jbe    80107528 <allocuvm+0x148>
    mem = kalloc();
8010742f:	e8 7c b5 ff ff       	call   801029b0 <kalloc>
    if(mem == 0){
80107434:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107436:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107438:	0f 84 aa 00 00 00    	je     801074e8 <allocuvm+0x108>
    memset(mem, 0, PGSIZE);
8010743e:	83 ec 04             	sub    $0x4,%esp
80107441:	68 00 10 00 00       	push   $0x1000
80107446:	6a 00                	push   $0x0
80107448:	50                   	push   %eax
80107449:	e8 a2 d8 ff ff       	call   80104cf0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010744e:	58                   	pop    %eax
8010744f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107455:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010745a:	5a                   	pop    %edx
8010745b:	6a 06                	push   $0x6
8010745d:	50                   	push   %eax
8010745e:	89 da                	mov    %ebx,%edx
80107460:	8b 45 08             	mov    0x8(%ebp),%eax
80107463:	e8 b8 fa ff ff       	call   80106f20 <mappages>
80107468:	83 c4 10             	add    $0x10,%esp
8010746b:	85 c0                	test   %eax,%eax
8010746d:	0f 88 8d 00 00 00    	js     80107500 <allocuvm+0x120>
    pte_t* pg_entry = walkpgdir(pgdir,(const char*)(a),0);
80107473:	8b 45 08             	mov    0x8(%ebp),%eax
80107476:	31 c9                	xor    %ecx,%ecx
80107478:	89 da                	mov    %ebx,%edx
8010747a:	e8 21 fa ff ff       	call   80106ea0 <walkpgdir>
8010747f:	89 c6                	mov    %eax,%esi
    if (myproc()->numOfPhysPages + myproc()->numOfDiskPages  < 32){
80107481:	e8 ba c8 ff ff       	call   80103d40 <myproc>
80107486:	8b b8 80 03 00 00    	mov    0x380(%eax),%edi
8010748c:	e8 af c8 ff ff       	call   80103d40 <myproc>
80107491:	8b 90 84 03 00 00    	mov    0x384(%eax),%edx
80107497:	01 fa                	add    %edi,%edx
80107499:	83 fa 1f             	cmp    $0x1f,%edx
8010749c:	7f 2a                	jg     801074c8 <allocuvm+0xe8>
        if(myproc()->numOfPhysPages < 16)
8010749e:	e8 9d c8 ff ff       	call   80103d40 <myproc>
801074a3:	83 b8 80 03 00 00 0f 	cmpl   $0xf,0x380(%eax)
801074aa:	0f 8f 70 ff ff ff    	jg     80107420 <allocuvm+0x40>
          addPage(pg_entry, (char*)a);
801074b0:	83 ec 08             	sub    $0x8,%esp
801074b3:	53                   	push   %ebx
801074b4:	56                   	push   %esi
801074b5:	e8 96 fe ff ff       	call   80107350 <addPage>
801074ba:	83 c4 10             	add    $0x10,%esp
801074bd:	e9 5e ff ff ff       	jmp    80107420 <allocuvm+0x40>
801074c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      myproc()->killed=1;
801074c8:	e8 73 c8 ff ff       	call   80103d40 <myproc>
801074cd:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      return oldsz;
801074d4:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801074d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074da:	89 f8                	mov    %edi,%eax
801074dc:	5b                   	pop    %ebx
801074dd:	5e                   	pop    %esi
801074de:	5f                   	pop    %edi
801074df:	5d                   	pop    %ebp
801074e0:	c3                   	ret    
801074e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(newsz >= oldsz)
801074e8:	8b 45 0c             	mov    0xc(%ebp),%eax
801074eb:	39 45 10             	cmp    %eax,0x10(%ebp)
801074ee:	77 40                	ja     80107530 <allocuvm+0x150>
}
801074f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801074f3:	31 ff                	xor    %edi,%edi
}
801074f5:	89 f8                	mov    %edi,%eax
801074f7:	5b                   	pop    %ebx
801074f8:	5e                   	pop    %esi
801074f9:	5f                   	pop    %edi
801074fa:	5d                   	pop    %ebp
801074fb:	c3                   	ret    
801074fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(newsz >= oldsz)
80107500:	8b 45 0c             	mov    0xc(%ebp),%eax
80107503:	39 45 10             	cmp    %eax,0x10(%ebp)
80107506:	76 0d                	jbe    80107515 <allocuvm+0x135>
80107508:	89 c1                	mov    %eax,%ecx
8010750a:	8b 55 10             	mov    0x10(%ebp),%edx
8010750d:	8b 45 08             	mov    0x8(%ebp),%eax
80107510:	e8 9b fa ff ff       	call   80106fb0 <deallocuvm.part.0>
      kfree(mem);
80107515:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107518:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010751a:	56                   	push   %esi
8010751b:	e8 e0 b2 ff ff       	call   80102800 <kfree>
      return 0;
80107520:	83 c4 10             	add    $0x10,%esp
80107523:	eb b2                	jmp    801074d7 <allocuvm+0xf7>
80107525:	8d 76 00             	lea    0x0(%esi),%esi
80107528:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010752b:	eb aa                	jmp    801074d7 <allocuvm+0xf7>
8010752d:	8d 76 00             	lea    0x0(%esi),%esi
80107530:	89 c1                	mov    %eax,%ecx
80107532:	8b 55 10             	mov    0x10(%ebp),%edx
80107535:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107538:	31 ff                	xor    %edi,%edi
8010753a:	e8 71 fa ff ff       	call   80106fb0 <deallocuvm.part.0>
8010753f:	eb 96                	jmp    801074d7 <allocuvm+0xf7>
80107541:	eb 0d                	jmp    80107550 <deallocuvm>
80107543:	90                   	nop
80107544:	90                   	nop
80107545:	90                   	nop
80107546:	90                   	nop
80107547:	90                   	nop
80107548:	90                   	nop
80107549:	90                   	nop
8010754a:	90                   	nop
8010754b:	90                   	nop
8010754c:	90                   	nop
8010754d:	90                   	nop
8010754e:	90                   	nop
8010754f:	90                   	nop

80107550 <deallocuvm>:
{
80107550:	55                   	push   %ebp
80107551:	89 e5                	mov    %esp,%ebp
80107553:	8b 55 0c             	mov    0xc(%ebp),%edx
80107556:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107559:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010755c:	39 d1                	cmp    %edx,%ecx
8010755e:	73 10                	jae    80107570 <deallocuvm+0x20>
}
80107560:	5d                   	pop    %ebp
80107561:	e9 4a fa ff ff       	jmp    80106fb0 <deallocuvm.part.0>
80107566:	8d 76 00             	lea    0x0(%esi),%esi
80107569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107570:	89 d0                	mov    %edx,%eax
80107572:	5d                   	pop    %ebp
80107573:	c3                   	ret    
80107574:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010757a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107580 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107580:	55                   	push   %ebp
80107581:	89 e5                	mov    %esp,%ebp
80107583:	57                   	push   %edi
80107584:	56                   	push   %esi
80107585:	53                   	push   %ebx
80107586:	83 ec 0c             	sub    $0xc,%esp
80107589:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010758c:	85 f6                	test   %esi,%esi
8010758e:	74 59                	je     801075e9 <freevm+0x69>
80107590:	31 c9                	xor    %ecx,%ecx
80107592:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107597:	89 f0                	mov    %esi,%eax
80107599:	e8 12 fa ff ff       	call   80106fb0 <deallocuvm.part.0>
8010759e:	89 f3                	mov    %esi,%ebx
801075a0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801075a6:	eb 0f                	jmp    801075b7 <freevm+0x37>
801075a8:	90                   	nop
801075a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075b0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801075b3:	39 fb                	cmp    %edi,%ebx
801075b5:	74 23                	je     801075da <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801075b7:	8b 03                	mov    (%ebx),%eax
801075b9:	a8 01                	test   $0x1,%al
801075bb:	74 f3                	je     801075b0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801075bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801075c2:	83 ec 0c             	sub    $0xc,%esp
801075c5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801075c8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801075cd:	50                   	push   %eax
801075ce:	e8 2d b2 ff ff       	call   80102800 <kfree>
801075d3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801075d6:	39 fb                	cmp    %edi,%ebx
801075d8:	75 dd                	jne    801075b7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801075da:	89 75 08             	mov    %esi,0x8(%ebp)
}
801075dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075e0:	5b                   	pop    %ebx
801075e1:	5e                   	pop    %esi
801075e2:	5f                   	pop    %edi
801075e3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801075e4:	e9 17 b2 ff ff       	jmp    80102800 <kfree>
    panic("freevm: no pgdir");
801075e9:	83 ec 0c             	sub    $0xc,%esp
801075ec:	68 31 84 10 80       	push   $0x80108431
801075f1:	e8 9a 8d ff ff       	call   80100390 <panic>
801075f6:	8d 76 00             	lea    0x0(%esi),%esi
801075f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107600 <setupkvm>:
{
80107600:	55                   	push   %ebp
80107601:	89 e5                	mov    %esp,%ebp
80107603:	56                   	push   %esi
80107604:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107605:	e8 a6 b3 ff ff       	call   801029b0 <kalloc>
8010760a:	85 c0                	test   %eax,%eax
8010760c:	89 c6                	mov    %eax,%esi
8010760e:	74 42                	je     80107652 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107610:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107613:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107618:	68 00 10 00 00       	push   $0x1000
8010761d:	6a 00                	push   $0x0
8010761f:	50                   	push   %eax
80107620:	e8 cb d6 ff ff       	call   80104cf0 <memset>
80107625:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107628:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010762b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010762e:	83 ec 08             	sub    $0x8,%esp
80107631:	8b 13                	mov    (%ebx),%edx
80107633:	ff 73 0c             	pushl  0xc(%ebx)
80107636:	50                   	push   %eax
80107637:	29 c1                	sub    %eax,%ecx
80107639:	89 f0                	mov    %esi,%eax
8010763b:	e8 e0 f8 ff ff       	call   80106f20 <mappages>
80107640:	83 c4 10             	add    $0x10,%esp
80107643:	85 c0                	test   %eax,%eax
80107645:	78 19                	js     80107660 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107647:	83 c3 10             	add    $0x10,%ebx
8010764a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107650:	75 d6                	jne    80107628 <setupkvm+0x28>
}
80107652:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107655:	89 f0                	mov    %esi,%eax
80107657:	5b                   	pop    %ebx
80107658:	5e                   	pop    %esi
80107659:	5d                   	pop    %ebp
8010765a:	c3                   	ret    
8010765b:	90                   	nop
8010765c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107660:	83 ec 0c             	sub    $0xc,%esp
80107663:	56                   	push   %esi
      return 0;
80107664:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107666:	e8 15 ff ff ff       	call   80107580 <freevm>
      return 0;
8010766b:	83 c4 10             	add    $0x10,%esp
}
8010766e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107671:	89 f0                	mov    %esi,%eax
80107673:	5b                   	pop    %ebx
80107674:	5e                   	pop    %esi
80107675:	5d                   	pop    %ebp
80107676:	c3                   	ret    
80107677:	89 f6                	mov    %esi,%esi
80107679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107680 <kvmalloc>:
{
80107680:	55                   	push   %ebp
80107681:	89 e5                	mov    %esp,%ebp
80107683:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107686:	e8 75 ff ff ff       	call   80107600 <setupkvm>
8010768b:	a3 c4 28 12 80       	mov    %eax,0x801228c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107690:	05 00 00 00 80       	add    $0x80000000,%eax
80107695:	0f 22 d8             	mov    %eax,%cr3
}
80107698:	c9                   	leave  
80107699:	c3                   	ret    
8010769a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801076a0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801076a0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801076a1:	31 c9                	xor    %ecx,%ecx
{
801076a3:	89 e5                	mov    %esp,%ebp
801076a5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801076a8:	8b 55 0c             	mov    0xc(%ebp),%edx
801076ab:	8b 45 08             	mov    0x8(%ebp),%eax
801076ae:	e8 ed f7 ff ff       	call   80106ea0 <walkpgdir>
  if(pte == 0)
801076b3:	85 c0                	test   %eax,%eax
801076b5:	74 05                	je     801076bc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801076b7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801076ba:	c9                   	leave  
801076bb:	c3                   	ret    
    panic("clearpteu");
801076bc:	83 ec 0c             	sub    $0xc,%esp
801076bf:	68 42 84 10 80       	push   $0x80108442
801076c4:	e8 c7 8c ff ff       	call   80100390 <panic>
801076c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801076d0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801076d0:	55                   	push   %ebp
801076d1:	89 e5                	mov    %esp,%ebp
801076d3:	57                   	push   %edi
801076d4:	56                   	push   %esi
801076d5:	53                   	push   %ebx
801076d6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801076d9:	e8 22 ff ff ff       	call   80107600 <setupkvm>
801076de:	85 c0                	test   %eax,%eax
801076e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801076e3:	0f 84 a0 00 00 00    	je     80107789 <copyuvm+0xb9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801076e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801076ec:	85 c9                	test   %ecx,%ecx
801076ee:	0f 84 95 00 00 00    	je     80107789 <copyuvm+0xb9>
801076f4:	31 f6                	xor    %esi,%esi
801076f6:	eb 4e                	jmp    80107746 <copyuvm+0x76>
801076f8:	90                   	nop
801076f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107700:	83 ec 04             	sub    $0x4,%esp
80107703:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107709:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010770c:	68 00 10 00 00       	push   $0x1000
80107711:	57                   	push   %edi
80107712:	50                   	push   %eax
80107713:	e8 88 d6 ff ff       	call   80104da0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107718:	58                   	pop    %eax
80107719:	5a                   	pop    %edx
8010771a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010771d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107720:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107725:	53                   	push   %ebx
80107726:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010772c:	52                   	push   %edx
8010772d:	89 f2                	mov    %esi,%edx
8010772f:	e8 ec f7 ff ff       	call   80106f20 <mappages>
80107734:	83 c4 10             	add    $0x10,%esp
80107737:	85 c0                	test   %eax,%eax
80107739:	78 39                	js     80107774 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
8010773b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107741:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107744:	76 43                	jbe    80107789 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107746:	8b 45 08             	mov    0x8(%ebp),%eax
80107749:	31 c9                	xor    %ecx,%ecx
8010774b:	89 f2                	mov    %esi,%edx
8010774d:	e8 4e f7 ff ff       	call   80106ea0 <walkpgdir>
80107752:	85 c0                	test   %eax,%eax
80107754:	74 3e                	je     80107794 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
80107756:	8b 18                	mov    (%eax),%ebx
80107758:	f6 c3 01             	test   $0x1,%bl
8010775b:	74 44                	je     801077a1 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
8010775d:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
8010775f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80107765:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
8010776b:	e8 40 b2 ff ff       	call   801029b0 <kalloc>
80107770:	85 c0                	test   %eax,%eax
80107772:	75 8c                	jne    80107700 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80107774:	83 ec 0c             	sub    $0xc,%esp
80107777:	ff 75 e0             	pushl  -0x20(%ebp)
8010777a:	e8 01 fe ff ff       	call   80107580 <freevm>
  return 0;
8010777f:	83 c4 10             	add    $0x10,%esp
80107782:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107789:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010778c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010778f:	5b                   	pop    %ebx
80107790:	5e                   	pop    %esi
80107791:	5f                   	pop    %edi
80107792:	5d                   	pop    %ebp
80107793:	c3                   	ret    
      panic("copyuvm: pte should exist");
80107794:	83 ec 0c             	sub    $0xc,%esp
80107797:	68 4c 84 10 80       	push   $0x8010844c
8010779c:	e8 ef 8b ff ff       	call   80100390 <panic>
      panic("copyuvm: page not present");
801077a1:	83 ec 0c             	sub    $0xc,%esp
801077a4:	68 66 84 10 80       	push   $0x80108466
801077a9:	e8 e2 8b ff ff       	call   80100390 <panic>
801077ae:	66 90                	xchg   %ax,%ax

801077b0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801077b0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801077b1:	31 c9                	xor    %ecx,%ecx
{
801077b3:	89 e5                	mov    %esp,%ebp
801077b5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801077b8:	8b 55 0c             	mov    0xc(%ebp),%edx
801077bb:	8b 45 08             	mov    0x8(%ebp),%eax
801077be:	e8 dd f6 ff ff       	call   80106ea0 <walkpgdir>
  if((*pte & PTE_P) == 0)
801077c3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801077c5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801077c6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801077c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801077cd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801077d0:	05 00 00 00 80       	add    $0x80000000,%eax
801077d5:	83 fa 05             	cmp    $0x5,%edx
801077d8:	ba 00 00 00 00       	mov    $0x0,%edx
801077dd:	0f 45 c2             	cmovne %edx,%eax
}
801077e0:	c3                   	ret    
801077e1:	eb 0d                	jmp    801077f0 <copyout>
801077e3:	90                   	nop
801077e4:	90                   	nop
801077e5:	90                   	nop
801077e6:	90                   	nop
801077e7:	90                   	nop
801077e8:	90                   	nop
801077e9:	90                   	nop
801077ea:	90                   	nop
801077eb:	90                   	nop
801077ec:	90                   	nop
801077ed:	90                   	nop
801077ee:	90                   	nop
801077ef:	90                   	nop

801077f0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801077f0:	55                   	push   %ebp
801077f1:	89 e5                	mov    %esp,%ebp
801077f3:	57                   	push   %edi
801077f4:	56                   	push   %esi
801077f5:	53                   	push   %ebx
801077f6:	83 ec 1c             	sub    $0x1c,%esp
801077f9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801077fc:	8b 55 0c             	mov    0xc(%ebp),%edx
801077ff:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107802:	85 db                	test   %ebx,%ebx
80107804:	75 40                	jne    80107846 <copyout+0x56>
80107806:	eb 70                	jmp    80107878 <copyout+0x88>
80107808:	90                   	nop
80107809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107810:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107813:	89 f1                	mov    %esi,%ecx
80107815:	29 d1                	sub    %edx,%ecx
80107817:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010781d:	39 d9                	cmp    %ebx,%ecx
8010781f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107822:	29 f2                	sub    %esi,%edx
80107824:	83 ec 04             	sub    $0x4,%esp
80107827:	01 d0                	add    %edx,%eax
80107829:	51                   	push   %ecx
8010782a:	57                   	push   %edi
8010782b:	50                   	push   %eax
8010782c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010782f:	e8 6c d5 ff ff       	call   80104da0 <memmove>
    len -= n;
    buf += n;
80107834:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107837:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010783a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107840:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107842:	29 cb                	sub    %ecx,%ebx
80107844:	74 32                	je     80107878 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107846:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107848:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010784b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010784e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107854:	56                   	push   %esi
80107855:	ff 75 08             	pushl  0x8(%ebp)
80107858:	e8 53 ff ff ff       	call   801077b0 <uva2ka>
    if(pa0 == 0)
8010785d:	83 c4 10             	add    $0x10,%esp
80107860:	85 c0                	test   %eax,%eax
80107862:	75 ac                	jne    80107810 <copyout+0x20>
  }
  return 0;
}
80107864:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107867:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010786c:	5b                   	pop    %ebx
8010786d:	5e                   	pop    %esi
8010786e:	5f                   	pop    %edi
8010786f:	5d                   	pop    %ebp
80107870:	c3                   	ret    
80107871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107878:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010787b:	31 c0                	xor    %eax,%eax
}
8010787d:	5b                   	pop    %ebx
8010787e:	5e                   	pop    %esi
8010787f:	5f                   	pop    %edi
80107880:	5d                   	pop    %ebp
80107881:	c3                   	ret    
80107882:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107890 <swapIn>:
  }
  return 1;
}

// Executes page-in from Disk to RAM.
int swapIn(uint *pte, uint faultAdd){
80107890:	55                   	push   %ebp
80107891:	89 e5                	mov    %esp,%ebp
80107893:	57                   	push   %edi
80107894:	56                   	push   %esi
80107895:	53                   	push   %ebx
80107896:	83 ec 1c             	sub    $0x1c,%esp
  //cprintf("swap in method");
  struct proc* curProc = myproc();
80107899:	e8 a2 c4 ff ff       	call   80103d40 <myproc>
8010789e:	89 c3                	mov    %eax,%ebx
  char* mem = kalloc(); // allocate physical memory (size of page)
801078a0:	e8 0b b1 ff ff       	call   801029b0 <kalloc>
  char* pageStart = (char*)PGROUNDDOWN(faultAdd); // gets the start point of the page (removes offset)
  int maped = mappages(curProc->pgdir,pageStart,PGSIZE,V2P(mem), PTE_U); // mapes the virtual memory of the page fault to the new allocated memory
801078a5:	8b 73 04             	mov    0x4(%ebx),%esi
  char* pageStart = (char*)PGROUNDDOWN(faultAdd); // gets the start point of the page (removes offset)
801078a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  int maped = mappages(curProc->pgdir,pageStart,PGSIZE,V2P(mem), PTE_U); // mapes the virtual memory of the page fault to the new allocated memory
801078ab:	83 ec 08             	sub    $0x8,%esp
801078ae:	05 00 00 00 80       	add    $0x80000000,%eax
801078b3:	6a 04                	push   $0x4
801078b5:	b9 00 10 00 00       	mov    $0x1000,%ecx
801078ba:	50                   	push   %eax
  char* pageStart = (char*)PGROUNDDOWN(faultAdd); // gets the start point of the page (removes offset)
801078bb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  int maped = mappages(curProc->pgdir,pageStart,PGSIZE,V2P(mem), PTE_U); // mapes the virtual memory of the page fault to the new allocated memory
801078c1:	89 f0                	mov    %esi,%eax
  char* pageStart = (char*)PGROUNDDOWN(faultAdd); // gets the start point of the page (removes offset)
801078c3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  int maped = mappages(curProc->pgdir,pageStart,PGSIZE,V2P(mem), PTE_U); // mapes the virtual memory of the page fault to the new allocated memory
801078c6:	e8 55 f6 ff ff       	call   80106f20 <mappages>
  if(!maped)
801078cb:	83 c4 10             	add    $0x10,%esp
801078ce:	85 c0                	test   %eax,%eax
801078d0:	0f 84 c0 00 00 00    	je     80107996 <swapIn+0x106>
    return -1;
  int offset = -1;
  int foundCell = 0;
  char* pa = (char*)(PTE_ADDR(*pte));
801078d6:	8b 45 08             	mov    0x8(%ebp),%eax
801078d9:	8d bb 00 02 00 00    	lea    0x200(%ebx),%edi
  int offset = -1;
801078df:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  int foundCell = 0;
801078e2:	31 c9                	xor    %ecx,%ecx
  int offset = -1;
801078e4:	be ff ff ff ff       	mov    $0xffffffff,%esi
  char* pa = (char*)(PTE_ADDR(*pte));
801078e9:	8b 00                	mov    (%eax),%eax
801078eb:	89 c2                	mov    %eax,%edx
801078ed:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  int offset = -1;
801078f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char* pa = (char*)(PTE_ADDR(*pte));
801078f6:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  char* va = (char*)(P2V((uint)(pa)));
801078fc:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107902:	eb 29                	jmp    8010792d <swapIn+0x9d>
80107904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curProc->procSwappedFiles[i].isOccupied = 0; // cell in procSwappedFiles Array is not needed anymore
      // curProc->procPhysPages[i].va = va;
      // curProc->procPhysPages[i].pte = pte;
      // break;
      }
    if (!foundCell){
80107908:	85 c9                	test   %ecx,%ecx
8010790a:	75 1a                	jne    80107926 <swapIn+0x96>
      if (curProc->procPhysPages[i].isOccupied == 0){ // look for a place in procPhysPages Array
8010790c:	83 b8 8c 01 00 00 00 	cmpl   $0x0,0x18c(%eax)
80107913:	75 11                	jne    80107926 <swapIn+0x96>
          curProc->procPhysPages[i].va = va;
80107915:	89 90 80 01 00 00    	mov    %edx,0x180(%eax)
          curProc->procPhysPages[i].pte = pte;
8010791b:	89 98 84 01 00 00    	mov    %ebx,0x184(%eax)
          foundCell = 1;
80107921:	b9 01 00 00 00       	mov    $0x1,%ecx
80107926:	83 c0 18             	add    $0x18,%eax
  for (int i=0; i<MAX_PSYC_PAGES; i++){ // find the cell that contains the meta-data of this page
80107929:	39 c7                	cmp    %eax,%edi
8010792b:	74 13                	je     80107940 <swapIn+0xb0>
    if (curProc->procSwappedFiles[i].va == va){
8010792d:	39 10                	cmp    %edx,(%eax)
8010792f:	75 d7                	jne    80107908 <swapIn+0x78>
      offset = curProc->procSwappedFiles[i].offsetInFile;
80107931:	8b 70 08             	mov    0x8(%eax),%esi
      curProc->procSwappedFiles[i].isOccupied = 0; // cell in procSwappedFiles Array is not needed anymore
80107934:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
8010793b:	eb cb                	jmp    80107908 <swapIn+0x78>
8010793d:	8d 76 00             	lea    0x0(%esi),%esi
        }
    }  
  }
  readFromSwapFile(curProc, (char*)V2P(pageStart), offset, PGSIZE);
80107940:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107943:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80107946:	68 00 10 00 00       	push   $0x1000
8010794b:	56                   	push   %esi
8010794c:	05 00 00 00 80       	add    $0x80000000,%eax
80107951:	50                   	push   %eax
80107952:	53                   	push   %ebx
80107953:	e8 b8 a9 ff ff       	call   80102310 <readFromSwapFile>
  curProc->numOfPhysPages++;
  curProc->numOfDiskPages--;
  #ifndef NONE
  insertNode(&curProc->procPhysPages[offset/PGSIZE]);
80107958:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
  curProc->numOfPhysPages++;
8010795e:	83 83 80 03 00 00 01 	addl   $0x1,0x380(%ebx)
  curProc->numOfDiskPages--;
80107965:	83 ab 84 03 00 00 01 	subl   $0x1,0x384(%ebx)
  insertNode(&curProc->procPhysPages[offset/PGSIZE]);
8010796c:	85 f6                	test   %esi,%esi
8010796e:	0f 48 f0             	cmovs  %eax,%esi
80107971:	c1 fe 0c             	sar    $0xc,%esi
80107974:	8d 04 76             	lea    (%esi,%esi,2),%eax
80107977:	8d 84 c3 00 02 00 00 	lea    0x200(%ebx,%eax,8),%eax
8010797e:	89 04 24             	mov    %eax,(%esp)
80107981:	e8 aa cf ff ff       	call   80104930 <insertNode>
  #endif
  return 1;
80107986:	83 c4 10             	add    $0x10,%esp
80107989:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010798e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107991:	5b                   	pop    %ebx
80107992:	5e                   	pop    %esi
80107993:	5f                   	pop    %edi
80107994:	5d                   	pop    %ebp
80107995:	c3                   	ret    
    return -1;
80107996:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010799b:	eb f1                	jmp    8010798e <swapIn+0xfe>
8010799d:	8d 76 00             	lea    0x0(%esi),%esi

801079a0 <checkIfNeedSwapping>:
int checkIfNeedSwapping(){
801079a0:	55                   	push   %ebp
801079a1:	89 e5                	mov    %esp,%ebp
801079a3:	53                   	push   %ebx
801079a4:	83 ec 14             	sub    $0x14,%esp
  struct proc *curProc = myproc();
801079a7:	e8 94 c3 ff ff       	call   80103d40 <myproc>
  asm volatile("movl %%cr2,%0" : "=r" (val));
801079ac:	0f 20 d1             	mov    %cr2,%ecx
  pde = &curProc->pgdir[PDX(&faultingAddress)];
801079af:	8d 55 f4             	lea    -0xc(%ebp),%edx
  if (*pde & PTE_P){
801079b2:	8b 58 04             	mov    0x4(%eax),%ebx
  uint faultingAddress = rcr2(); // contains the address that register %cr2 holds
801079b5:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  pde = &curProc->pgdir[PDX(&faultingAddress)];
801079b8:	c1 ea 16             	shr    $0x16,%edx
  if (*pde & PTE_P){
801079bb:	8b 14 93             	mov    (%ebx,%edx,4),%edx
801079be:	f6 c2 01             	test   $0x1,%dl
801079c1:	74 5d                	je     80107a20 <checkIfNeedSwapping+0x80>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));; // Page is Present, swapping isn't needed
801079c3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if (*pgtab & PTE_PG) { // Page was paged-out to disk, paged-in is needed
801079c9:	f6 82 01 00 00 80 02 	testb  $0x2,-0x7fffffff(%edx)
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));; // Page is Present, swapping isn't needed
801079d0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
  if (*pgtab & PTE_PG) { // Page was paged-out to disk, paged-in is needed
801079d6:	74 58                	je     80107a30 <checkIfNeedSwapping+0x90>
    if (curProc->numOfPhysPages >= MAX_PSYC_PAGES){ // Check if swapping is needed
801079d8:	83 b8 80 03 00 00 0f 	cmpl   $0xf,0x380(%eax)
801079df:	7f 1f                	jg     80107a00 <checkIfNeedSwapping+0x60>
      swapIn(pgtab, faultingAddress);
801079e1:	83 ec 08             	sub    $0x8,%esp
801079e4:	51                   	push   %ecx
801079e5:	53                   	push   %ebx
801079e6:	e8 a5 fe ff ff       	call   80107890 <swapIn>
801079eb:	83 c4 10             	add    $0x10,%esp
  return 1;
801079ee:	b8 01 00 00 00       	mov    $0x1,%eax
}
801079f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801079f6:	c9                   	leave  
801079f7:	c3                   	ret    
801079f8:	90                   	nop
801079f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      swap(pgtab, faultingAddress);
80107a00:	83 ec 08             	sub    $0x8,%esp
80107a03:	51                   	push   %ecx
80107a04:	53                   	push   %ebx
80107a05:	e8 c6 ce ff ff       	call   801048d0 <swap>
80107a0a:	83 c4 10             	add    $0x10,%esp
  return 1;
80107a0d:	b8 01 00 00 00       	mov    $0x1,%eax
}
80107a12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107a15:	c9                   	leave  
80107a16:	c3                   	ret    
80107a17:	89 f6                	mov    %esi,%esi
80107a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80107a20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a25:	eb cc                	jmp    801079f3 <checkIfNeedSwapping+0x53>
80107a27:	89 f6                	mov    %esi,%esi
80107a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    curProc->killed = 1;
80107a30:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
    return -1;
80107a37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a3c:	eb b5                	jmp    801079f3 <checkIfNeedSwapping+0x53>
