
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
8010002d:	b8 40 32 10 80       	mov    $0x80103240,%eax
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
8010004c:	68 80 75 10 80       	push   $0x80107580
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 55 46 00 00       	call   801046b0 <initlock>
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
80100092:	68 87 75 10 80       	push   $0x80107587
80100097:	50                   	push   %eax
80100098:	e8 03 45 00 00       	call   801045a0 <initsleeplock>
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
801000e4:	e8 b7 46 00 00       	call   801047a0 <acquire>
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
80100162:	e8 59 47 00 00       	call   801048c0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 6e 44 00 00       	call   801045e0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 3d 23 00 00       	call   801024c0 <iderw>
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
80100193:	68 8e 75 10 80       	push   $0x8010758e
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
801001ae:	e8 cd 44 00 00       	call   80104680 <holdingsleep>
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
801001c4:	e9 f7 22 00 00       	jmp    801024c0 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 9f 75 10 80       	push   $0x8010759f
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
801001ef:	e8 8c 44 00 00       	call   80104680 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 3c 44 00 00       	call   80104640 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 90 45 00 00       	call   801047a0 <acquire>
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
8010025c:	e9 5f 46 00 00       	jmp    801048c0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 a6 75 10 80       	push   $0x801075a6
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
80100280:	e8 eb 14 00 00       	call   80101770 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 0f 45 00 00       	call   801047a0 <acquire>
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
801002c5:	e8 56 3e 00 00       	call   80104120 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 0f 11 80    	cmp    0x80110fa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 a0 38 00 00       	call   80103b80 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 cc 45 00 00       	call   801048c0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 94 13 00 00       	call   80101690 <ilock>
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
8010034d:	e8 6e 45 00 00       	call   801048c0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 36 13 00 00       	call   80101690 <ilock>
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
801003a9:	e8 22 27 00 00       	call   80102ad0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ad 75 10 80       	push   $0x801075ad
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 a3 7f 10 80 	movl   $0x80107fa3,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 f3 42 00 00       	call   801046d0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 c1 75 10 80       	push   $0x801075c1
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
8010043a:	e8 d1 5b 00 00       	call   80106010 <uartputc>
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
801004ec:	e8 1f 5b 00 00       	call   80106010 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 13 5b 00 00       	call   80106010 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 07 5b 00 00       	call   80106010 <uartputc>
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
80100524:	e8 a7 44 00 00       	call   801049d0 <memmove>
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
80100541:	e8 da 43 00 00       	call   80104920 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 c5 75 10 80       	push   $0x801075c5
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
801005b1:	0f b6 92 f0 75 10 80 	movzbl -0x7fef8a10(%edx),%edx
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
8010060f:	e8 5c 11 00 00       	call   80101770 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 80 41 00 00       	call   801047a0 <acquire>
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
80100647:	e8 74 42 00 00       	call   801048c0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 3b 10 00 00       	call   80101690 <ilock>

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
8010071f:	e8 9c 41 00 00       	call   801048c0 <release>
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
801007d0:	ba d8 75 10 80       	mov    $0x801075d8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 ab 3f 00 00       	call   801047a0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 df 75 10 80       	push   $0x801075df
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
80100823:	e8 78 3f 00 00       	call   801047a0 <acquire>
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
80100888:	e8 33 40 00 00       	call   801048c0 <release>
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
80100916:	e8 c5 39 00 00       	call   801042e0 <wakeup>
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
80100997:	e9 24 3a 00 00       	jmp    801043c0 <procdump>
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
801009c6:	68 e8 75 10 80       	push   $0x801075e8
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 db 3c 00 00       	call   801046b0 <initlock>

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
801009f9:	e8 72 1c 00 00       	call   80102670 <ioapicenable>
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
80100a1c:	e8 5f 31 00 00       	call   80103b80 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 14 25 00 00       	call   80102f40 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 b9 14 00 00       	call   80101ef0 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 43 0c 00 00       	call   80101690 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 12 0f 00 00       	call   80101970 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 b1 0e 00 00       	call   80101920 <iunlockput>
    end_op();
80100a6f:	e8 3c 25 00 00       	call   80102fb0 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 c7 66 00 00       	call   80107160 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 85 64 00 00       	call   80106f80 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 93 63 00 00       	call   80106ec0 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 13 0e 00 00       	call   80101970 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 69 65 00 00       	call   801070e0 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 86 0d 00 00       	call   80101920 <iunlockput>
  end_op();
80100b9a:	e8 11 24 00 00       	call   80102fb0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 d1 63 00 00       	call   80106f80 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 1a 65 00 00       	call   801070e0 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 d8 23 00 00       	call   80102fb0 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 01 76 10 80       	push   $0x80107601
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 f5 65 00 00       	call   80107200 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 02 3f 00 00       	call   80104b40 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 ef 3e 00 00       	call   80104b40 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 ee 66 00 00       	call   80107350 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 84 66 00 00       	call   80107350 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 f1 3d 00 00       	call   80104b00 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 f7 5f 00 00       	call   80106d30 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 9f 63 00 00       	call   801070e0 <freevm>
  return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 0d 76 10 80       	push   $0x8010760d
80100d6b:	68 c0 0f 11 80       	push   $0x80110fc0
80100d70:	e8 3b 39 00 00       	call   801046b0 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 c0 0f 11 80       	push   $0x80110fc0
80100d91:	e8 0a 3a 00 00       	call   801047a0 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 c0 0f 11 80       	push   $0x80110fc0
80100dc1:	e8 fa 3a 00 00       	call   801048c0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 c0 0f 11 80       	push   $0x80110fc0
80100dda:	e8 e1 3a 00 00       	call   801048c0 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 c0 0f 11 80       	push   $0x80110fc0
80100dff:	e8 9c 39 00 00       	call   801047a0 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 c0 0f 11 80       	push   $0x80110fc0
80100e1c:	e8 9f 3a 00 00       	call   801048c0 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 14 76 10 80       	push   $0x80107614
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e51:	e8 4a 39 00 00       	call   801047a0 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 3f 3a 00 00       	jmp    801048c0 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 13 3a 00 00       	call   801048c0 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 1a 28 00 00       	call   801036f0 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 5b 20 00 00       	call   80102f40 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 d0 08 00 00       	call   801017c0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 b1 20 00 00       	jmp    80102fb0 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 1c 76 10 80       	push   $0x8010761c
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 66 07 00 00       	call   80101690 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 09 0a 00 00       	call   80101940 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 30 08 00 00       	call   80101770 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 01 07 00 00       	call   80101690 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 d4 09 00 00       	call   80101970 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 bd 07 00 00       	call   80101770 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 ce 28 00 00       	jmp    801038a0 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 26 76 10 80       	push   $0x80107626
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 27 07 00 00       	call   80101770 <iunlock>
      end_op();
80101049:	e8 62 1f 00 00       	call   80102fb0 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 c5 1e 00 00       	call   80102f40 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 0a 06 00 00       	call   80101690 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 d8 09 00 00       	call   80101a70 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 c3 06 00 00       	call   80101770 <iunlock>
      end_op();
801010ad:	e8 fe 1e 00 00       	call   80102fb0 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 9e 26 00 00       	jmp    80103790 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 2f 76 10 80       	push   $0x8010762f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 35 76 10 80       	push   $0x80107635
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101119:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
{
8010111f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101122:	85 c9                	test   %ecx,%ecx
80101124:	0f 84 87 00 00 00    	je     801011b1 <balloc+0xa1>
8010112a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101131:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101134:	83 ec 08             	sub    $0x8,%esp
80101137:	89 f0                	mov    %esi,%eax
80101139:	c1 f8 0c             	sar    $0xc,%eax
8010113c:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101142:	50                   	push   %eax
80101143:	ff 75 d8             	pushl  -0x28(%ebp)
80101146:	e8 85 ef ff ff       	call   801000d0 <bread>
8010114b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010114e:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101153:	83 c4 10             	add    $0x10,%esp
80101156:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101159:	31 c0                	xor    %eax,%eax
8010115b:	eb 2f                	jmp    8010118c <balloc+0x7c>
8010115d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101160:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101162:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101165:	bb 01 00 00 00       	mov    $0x1,%ebx
8010116a:	83 e1 07             	and    $0x7,%ecx
8010116d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010116f:	89 c1                	mov    %eax,%ecx
80101171:	c1 f9 03             	sar    $0x3,%ecx
80101174:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101179:	85 df                	test   %ebx,%edi
8010117b:	89 fa                	mov    %edi,%edx
8010117d:	74 41                	je     801011c0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010117f:	83 c0 01             	add    $0x1,%eax
80101182:	83 c6 01             	add    $0x1,%esi
80101185:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010118a:	74 05                	je     80101191 <balloc+0x81>
8010118c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010118f:	77 cf                	ja     80101160 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101191:	83 ec 0c             	sub    $0xc,%esp
80101194:	ff 75 e4             	pushl  -0x1c(%ebp)
80101197:	e8 44 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010119c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011a3:	83 c4 10             	add    $0x10,%esp
801011a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011a9:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
801011af:	77 80                	ja     80101131 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011b1:	83 ec 0c             	sub    $0xc,%esp
801011b4:	68 3f 76 10 80       	push   $0x8010763f
801011b9:	e8 d2 f1 ff ff       	call   80100390 <panic>
801011be:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801011c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011c3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801011c6:	09 da                	or     %ebx,%edx
801011c8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011cc:	57                   	push   %edi
801011cd:	e8 3e 1f 00 00       	call   80103110 <log_write>
        brelse(bp);
801011d2:	89 3c 24             	mov    %edi,(%esp)
801011d5:	e8 06 f0 ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011da:	58                   	pop    %eax
801011db:	5a                   	pop    %edx
801011dc:	56                   	push   %esi
801011dd:	ff 75 d8             	pushl  -0x28(%ebp)
801011e0:	e8 eb ee ff ff       	call   801000d0 <bread>
801011e5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011ea:	83 c4 0c             	add    $0xc,%esp
801011ed:	68 00 02 00 00       	push   $0x200
801011f2:	6a 00                	push   $0x0
801011f4:	50                   	push   %eax
801011f5:	e8 26 37 00 00       	call   80104920 <memset>
  log_write(bp);
801011fa:	89 1c 24             	mov    %ebx,(%esp)
801011fd:	e8 0e 1f 00 00       	call   80103110 <log_write>
  brelse(bp);
80101202:	89 1c 24             	mov    %ebx,(%esp)
80101205:	e8 d6 ef ff ff       	call   801001e0 <brelse>
}
8010120a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010120d:	89 f0                	mov    %esi,%eax
8010120f:	5b                   	pop    %ebx
80101210:	5e                   	pop    %esi
80101211:	5f                   	pop    %edi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
80101214:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010121a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101220 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	56                   	push   %esi
80101225:	53                   	push   %ebx
80101226:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101228:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
{
8010122f:	83 ec 28             	sub    $0x28,%esp
80101232:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101235:	68 e0 19 11 80       	push   $0x801119e0
8010123a:	e8 61 35 00 00       	call   801047a0 <acquire>
8010123f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101242:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101245:	eb 17                	jmp    8010125e <iget+0x3e>
80101247:	89 f6                	mov    %esi,%esi
80101249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101250:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101256:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
8010125c:	73 22                	jae    80101280 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010125e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101261:	85 c9                	test   %ecx,%ecx
80101263:	7e 04                	jle    80101269 <iget+0x49>
80101265:	39 3b                	cmp    %edi,(%ebx)
80101267:	74 4f                	je     801012b8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101269:	85 f6                	test   %esi,%esi
8010126b:	75 e3                	jne    80101250 <iget+0x30>
8010126d:	85 c9                	test   %ecx,%ecx
8010126f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101272:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101278:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
8010127e:	72 de                	jb     8010125e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101280:	85 f6                	test   %esi,%esi
80101282:	74 5b                	je     801012df <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101284:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101287:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101289:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010128c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101293:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010129a:	68 e0 19 11 80       	push   $0x801119e0
8010129f:	e8 1c 36 00 00       	call   801048c0 <release>

  return ip;
801012a4:	83 c4 10             	add    $0x10,%esp
}
801012a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012aa:	89 f0                	mov    %esi,%eax
801012ac:	5b                   	pop    %ebx
801012ad:	5e                   	pop    %esi
801012ae:	5f                   	pop    %edi
801012af:	5d                   	pop    %ebp
801012b0:	c3                   	ret    
801012b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012b8:	39 53 04             	cmp    %edx,0x4(%ebx)
801012bb:	75 ac                	jne    80101269 <iget+0x49>
      release(&icache.lock);
801012bd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801012c0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801012c3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012c5:	68 e0 19 11 80       	push   $0x801119e0
      ip->ref++;
801012ca:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012cd:	e8 ee 35 00 00       	call   801048c0 <release>
      return ip;
801012d2:	83 c4 10             	add    $0x10,%esp
}
801012d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012d8:	89 f0                	mov    %esi,%eax
801012da:	5b                   	pop    %ebx
801012db:	5e                   	pop    %esi
801012dc:	5f                   	pop    %edi
801012dd:	5d                   	pop    %ebp
801012de:	c3                   	ret    
    panic("iget: no inodes");
801012df:	83 ec 0c             	sub    $0xc,%esp
801012e2:	68 55 76 10 80       	push   $0x80107655
801012e7:	e8 a4 f0 ff ff       	call   80100390 <panic>
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
801012f4:	56                   	push   %esi
801012f5:	53                   	push   %ebx
801012f6:	89 c6                	mov    %eax,%esi
801012f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012fb:	83 fa 0b             	cmp    $0xb,%edx
801012fe:	77 18                	ja     80101318 <bmap+0x28>
80101300:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101303:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101306:	85 db                	test   %ebx,%ebx
80101308:	74 76                	je     80101380 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010130a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010130d:	89 d8                	mov    %ebx,%eax
8010130f:	5b                   	pop    %ebx
80101310:	5e                   	pop    %esi
80101311:	5f                   	pop    %edi
80101312:	5d                   	pop    %ebp
80101313:	c3                   	ret    
80101314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101318:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010131b:	83 fb 7f             	cmp    $0x7f,%ebx
8010131e:	0f 87 90 00 00 00    	ja     801013b4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101324:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010132a:	8b 00                	mov    (%eax),%eax
8010132c:	85 d2                	test   %edx,%edx
8010132e:	74 70                	je     801013a0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101330:	83 ec 08             	sub    $0x8,%esp
80101333:	52                   	push   %edx
80101334:	50                   	push   %eax
80101335:	e8 96 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010133a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010133e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101341:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101343:	8b 1a                	mov    (%edx),%ebx
80101345:	85 db                	test   %ebx,%ebx
80101347:	75 1d                	jne    80101366 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101349:	8b 06                	mov    (%esi),%eax
8010134b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010134e:	e8 bd fd ff ff       	call   80101110 <balloc>
80101353:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101356:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101359:	89 c3                	mov    %eax,%ebx
8010135b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010135d:	57                   	push   %edi
8010135e:	e8 ad 1d 00 00       	call   80103110 <log_write>
80101363:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101366:	83 ec 0c             	sub    $0xc,%esp
80101369:	57                   	push   %edi
8010136a:	e8 71 ee ff ff       	call   801001e0 <brelse>
8010136f:	83 c4 10             	add    $0x10,%esp
}
80101372:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101375:	89 d8                	mov    %ebx,%eax
80101377:	5b                   	pop    %ebx
80101378:	5e                   	pop    %esi
80101379:	5f                   	pop    %edi
8010137a:	5d                   	pop    %ebp
8010137b:	c3                   	ret    
8010137c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101380:	8b 00                	mov    (%eax),%eax
80101382:	e8 89 fd ff ff       	call   80101110 <balloc>
80101387:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010138a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010138d:	89 c3                	mov    %eax,%ebx
}
8010138f:	89 d8                	mov    %ebx,%eax
80101391:	5b                   	pop    %ebx
80101392:	5e                   	pop    %esi
80101393:	5f                   	pop    %edi
80101394:	5d                   	pop    %ebp
80101395:	c3                   	ret    
80101396:	8d 76 00             	lea    0x0(%esi),%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013a0:	e8 6b fd ff ff       	call   80101110 <balloc>
801013a5:	89 c2                	mov    %eax,%edx
801013a7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013ad:	8b 06                	mov    (%esi),%eax
801013af:	e9 7c ff ff ff       	jmp    80101330 <bmap+0x40>
  panic("bmap: out of range");
801013b4:	83 ec 0c             	sub    $0xc,%esp
801013b7:	68 65 76 10 80       	push   $0x80107665
801013bc:	e8 cf ef ff ff       	call   80100390 <panic>
801013c1:	eb 0d                	jmp    801013d0 <readsb>
801013c3:	90                   	nop
801013c4:	90                   	nop
801013c5:	90                   	nop
801013c6:	90                   	nop
801013c7:	90                   	nop
801013c8:	90                   	nop
801013c9:	90                   	nop
801013ca:	90                   	nop
801013cb:	90                   	nop
801013cc:	90                   	nop
801013cd:	90                   	nop
801013ce:	90                   	nop
801013cf:	90                   	nop

801013d0 <readsb>:
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	56                   	push   %esi
801013d4:	53                   	push   %ebx
801013d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013d8:	83 ec 08             	sub    $0x8,%esp
801013db:	6a 01                	push   $0x1
801013dd:	ff 75 08             	pushl  0x8(%ebp)
801013e0:	e8 eb ec ff ff       	call   801000d0 <bread>
801013e5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ea:	83 c4 0c             	add    $0xc,%esp
801013ed:	6a 1c                	push   $0x1c
801013ef:	50                   	push   %eax
801013f0:	56                   	push   %esi
801013f1:	e8 da 35 00 00       	call   801049d0 <memmove>
  brelse(bp);
801013f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013f9:	83 c4 10             	add    $0x10,%esp
}
801013fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013ff:	5b                   	pop    %ebx
80101400:	5e                   	pop    %esi
80101401:	5d                   	pop    %ebp
  brelse(bp);
80101402:	e9 d9 ed ff ff       	jmp    801001e0 <brelse>
80101407:	89 f6                	mov    %esi,%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101410 <bfree>:
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	56                   	push   %esi
80101414:	53                   	push   %ebx
80101415:	89 d3                	mov    %edx,%ebx
80101417:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101419:	83 ec 08             	sub    $0x8,%esp
8010141c:	68 c0 19 11 80       	push   $0x801119c0
80101421:	50                   	push   %eax
80101422:	e8 a9 ff ff ff       	call   801013d0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101427:	58                   	pop    %eax
80101428:	5a                   	pop    %edx
80101429:	89 da                	mov    %ebx,%edx
8010142b:	c1 ea 0c             	shr    $0xc,%edx
8010142e:	03 15 d8 19 11 80    	add    0x801119d8,%edx
80101434:	52                   	push   %edx
80101435:	56                   	push   %esi
80101436:	e8 95 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010143b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010143d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101440:	ba 01 00 00 00       	mov    $0x1,%edx
80101445:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101448:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010144e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101451:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101453:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101458:	85 d1                	test   %edx,%ecx
8010145a:	74 25                	je     80101481 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010145c:	f7 d2                	not    %edx
8010145e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101460:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101463:	21 ca                	and    %ecx,%edx
80101465:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101469:	56                   	push   %esi
8010146a:	e8 a1 1c 00 00       	call   80103110 <log_write>
  brelse(bp);
8010146f:	89 34 24             	mov    %esi,(%esp)
80101472:	e8 69 ed ff ff       	call   801001e0 <brelse>
}
80101477:	83 c4 10             	add    $0x10,%esp
8010147a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010147d:	5b                   	pop    %ebx
8010147e:	5e                   	pop    %esi
8010147f:	5d                   	pop    %ebp
80101480:	c3                   	ret    
    panic("freeing free block");
80101481:	83 ec 0c             	sub    $0xc,%esp
80101484:	68 78 76 10 80       	push   $0x80107678
80101489:	e8 02 ef ff ff       	call   80100390 <panic>
8010148e:	66 90                	xchg   %ax,%ax

80101490 <iinit>:
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	53                   	push   %ebx
80101494:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
80101499:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010149c:	68 8b 76 10 80       	push   $0x8010768b
801014a1:	68 e0 19 11 80       	push   $0x801119e0
801014a6:	e8 05 32 00 00       	call   801046b0 <initlock>
801014ab:	83 c4 10             	add    $0x10,%esp
801014ae:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014b0:	83 ec 08             	sub    $0x8,%esp
801014b3:	68 92 76 10 80       	push   $0x80107692
801014b8:	53                   	push   %ebx
801014b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014bf:	e8 dc 30 00 00       	call   801045a0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014c4:	83 c4 10             	add    $0x10,%esp
801014c7:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
801014cd:	75 e1                	jne    801014b0 <iinit+0x20>
  readsb(dev, &sb);
801014cf:	83 ec 08             	sub    $0x8,%esp
801014d2:	68 c0 19 11 80       	push   $0x801119c0
801014d7:	ff 75 08             	pushl  0x8(%ebp)
801014da:	e8 f1 fe ff ff       	call   801013d0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014df:	ff 35 d8 19 11 80    	pushl  0x801119d8
801014e5:	ff 35 d4 19 11 80    	pushl  0x801119d4
801014eb:	ff 35 d0 19 11 80    	pushl  0x801119d0
801014f1:	ff 35 cc 19 11 80    	pushl  0x801119cc
801014f7:	ff 35 c8 19 11 80    	pushl  0x801119c8
801014fd:	ff 35 c4 19 11 80    	pushl  0x801119c4
80101503:	ff 35 c0 19 11 80    	pushl  0x801119c0
80101509:	68 3c 77 10 80       	push   $0x8010773c
8010150e:	e8 4d f1 ff ff       	call   80100660 <cprintf>
}
80101513:	83 c4 30             	add    $0x30,%esp
80101516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101519:	c9                   	leave  
8010151a:	c3                   	ret    
8010151b:	90                   	nop
8010151c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101520 <ialloc>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
{
80101530:	8b 45 0c             	mov    0xc(%ebp),%eax
80101533:	8b 75 08             	mov    0x8(%ebp),%esi
80101536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	0f 86 91 00 00 00    	jbe    801015d0 <ialloc+0xb0>
8010153f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101544:	eb 21                	jmp    80101567 <ialloc+0x47>
80101546:	8d 76 00             	lea    0x0(%esi),%esi
80101549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101550:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101553:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101556:	57                   	push   %edi
80101557:	e8 84 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010155c:	83 c4 10             	add    $0x10,%esp
8010155f:	39 1d c8 19 11 80    	cmp    %ebx,0x801119c8
80101565:	76 69                	jbe    801015d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101567:	89 d8                	mov    %ebx,%eax
80101569:	83 ec 08             	sub    $0x8,%esp
8010156c:	c1 e8 03             	shr    $0x3,%eax
8010156f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101575:	50                   	push   %eax
80101576:	56                   	push   %esi
80101577:	e8 54 eb ff ff       	call   801000d0 <bread>
8010157c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010157e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101580:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101583:	83 e0 07             	and    $0x7,%eax
80101586:	c1 e0 06             	shl    $0x6,%eax
80101589:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010158d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101591:	75 bd                	jne    80101550 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101593:	83 ec 04             	sub    $0x4,%esp
80101596:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101599:	6a 40                	push   $0x40
8010159b:	6a 00                	push   $0x0
8010159d:	51                   	push   %ecx
8010159e:	e8 7d 33 00 00       	call   80104920 <memset>
      dip->type = type;
801015a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ad:	89 3c 24             	mov    %edi,(%esp)
801015b0:	e8 5b 1b 00 00       	call   80103110 <log_write>
      brelse(bp);
801015b5:	89 3c 24             	mov    %edi,(%esp)
801015b8:	e8 23 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015bd:	83 c4 10             	add    $0x10,%esp
}
801015c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015c3:	89 da                	mov    %ebx,%edx
801015c5:	89 f0                	mov    %esi,%eax
}
801015c7:	5b                   	pop    %ebx
801015c8:	5e                   	pop    %esi
801015c9:	5f                   	pop    %edi
801015ca:	5d                   	pop    %ebp
      return iget(dev, inum);
801015cb:	e9 50 fc ff ff       	jmp    80101220 <iget>
  panic("ialloc: no inodes");
801015d0:	83 ec 0c             	sub    $0xc,%esp
801015d3:	68 98 76 10 80       	push   $0x80107698
801015d8:	e8 b3 ed ff ff       	call   80100390 <panic>
801015dd:	8d 76 00             	lea    0x0(%esi),%esi

801015e0 <iupdate>:
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	56                   	push   %esi
801015e4:	53                   	push   %ebx
801015e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e8:	83 ec 08             	sub    $0x8,%esp
801015eb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ee:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015f1:	c1 e8 03             	shr    $0x3,%eax
801015f4:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801015fa:	50                   	push   %eax
801015fb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015fe:	e8 cd ea ff ff       	call   801000d0 <bread>
80101603:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101605:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101608:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010160f:	83 e0 07             	and    $0x7,%eax
80101612:	c1 e0 06             	shl    $0x6,%eax
80101615:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101619:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010161c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101620:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101623:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101627:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010162b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010162f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101633:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101637:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010163a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163d:	6a 34                	push   $0x34
8010163f:	53                   	push   %ebx
80101640:	50                   	push   %eax
80101641:	e8 8a 33 00 00       	call   801049d0 <memmove>
  log_write(bp);
80101646:	89 34 24             	mov    %esi,(%esp)
80101649:	e8 c2 1a 00 00       	call   80103110 <log_write>
  brelse(bp);
8010164e:	89 75 08             	mov    %esi,0x8(%ebp)
80101651:	83 c4 10             	add    $0x10,%esp
}
80101654:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101657:	5b                   	pop    %ebx
80101658:	5e                   	pop    %esi
80101659:	5d                   	pop    %ebp
  brelse(bp);
8010165a:	e9 81 eb ff ff       	jmp    801001e0 <brelse>
8010165f:	90                   	nop

80101660 <idup>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	53                   	push   %ebx
80101664:	83 ec 10             	sub    $0x10,%esp
80101667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010166a:	68 e0 19 11 80       	push   $0x801119e0
8010166f:	e8 2c 31 00 00       	call   801047a0 <acquire>
  ip->ref++;
80101674:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101678:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010167f:	e8 3c 32 00 00       	call   801048c0 <release>
}
80101684:	89 d8                	mov    %ebx,%eax
80101686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101689:	c9                   	leave  
8010168a:	c3                   	ret    
8010168b:	90                   	nop
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <ilock>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	56                   	push   %esi
80101694:	53                   	push   %ebx
80101695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101698:	85 db                	test   %ebx,%ebx
8010169a:	0f 84 b7 00 00 00    	je     80101757 <ilock+0xc7>
801016a0:	8b 53 08             	mov    0x8(%ebx),%edx
801016a3:	85 d2                	test   %edx,%edx
801016a5:	0f 8e ac 00 00 00    	jle    80101757 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016ab:	8d 43 0c             	lea    0xc(%ebx),%eax
801016ae:	83 ec 0c             	sub    $0xc,%esp
801016b1:	50                   	push   %eax
801016b2:	e8 29 2f 00 00       	call   801045e0 <acquiresleep>
  if(ip->valid == 0){
801016b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ba:	83 c4 10             	add    $0x10,%esp
801016bd:	85 c0                	test   %eax,%eax
801016bf:	74 0f                	je     801016d0 <ilock+0x40>
}
801016c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016c4:	5b                   	pop    %ebx
801016c5:	5e                   	pop    %esi
801016c6:	5d                   	pop    %ebp
801016c7:	c3                   	ret    
801016c8:	90                   	nop
801016c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d0:	8b 43 04             	mov    0x4(%ebx),%eax
801016d3:	83 ec 08             	sub    $0x8,%esp
801016d6:	c1 e8 03             	shr    $0x3,%eax
801016d9:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801016df:	50                   	push   %eax
801016e0:	ff 33                	pushl  (%ebx)
801016e2:	e8 e9 e9 ff ff       	call   801000d0 <bread>
801016e7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016ef:	83 e0 07             	and    $0x7,%eax
801016f2:	c1 e0 06             	shl    $0x6,%eax
801016f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016f9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016fc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101703:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101707:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010170b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010170f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101713:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101717:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010171b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010171e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101721:	6a 34                	push   $0x34
80101723:	50                   	push   %eax
80101724:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101727:	50                   	push   %eax
80101728:	e8 a3 32 00 00       	call   801049d0 <memmove>
    brelse(bp);
8010172d:	89 34 24             	mov    %esi,(%esp)
80101730:	e8 ab ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101735:	83 c4 10             	add    $0x10,%esp
80101738:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010173d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101744:	0f 85 77 ff ff ff    	jne    801016c1 <ilock+0x31>
      panic("ilock: no type");
8010174a:	83 ec 0c             	sub    $0xc,%esp
8010174d:	68 b0 76 10 80       	push   $0x801076b0
80101752:	e8 39 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101757:	83 ec 0c             	sub    $0xc,%esp
8010175a:	68 aa 76 10 80       	push   $0x801076aa
8010175f:	e8 2c ec ff ff       	call   80100390 <panic>
80101764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010176a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101770 <iunlock>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	56                   	push   %esi
80101774:	53                   	push   %ebx
80101775:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101778:	85 db                	test   %ebx,%ebx
8010177a:	74 28                	je     801017a4 <iunlock+0x34>
8010177c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	56                   	push   %esi
80101783:	e8 f8 2e 00 00       	call   80104680 <holdingsleep>
80101788:	83 c4 10             	add    $0x10,%esp
8010178b:	85 c0                	test   %eax,%eax
8010178d:	74 15                	je     801017a4 <iunlock+0x34>
8010178f:	8b 43 08             	mov    0x8(%ebx),%eax
80101792:	85 c0                	test   %eax,%eax
80101794:	7e 0e                	jle    801017a4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101796:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101799:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010179c:	5b                   	pop    %ebx
8010179d:	5e                   	pop    %esi
8010179e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010179f:	e9 9c 2e 00 00       	jmp    80104640 <releasesleep>
    panic("iunlock");
801017a4:	83 ec 0c             	sub    $0xc,%esp
801017a7:	68 bf 76 10 80       	push   $0x801076bf
801017ac:	e8 df eb ff ff       	call   80100390 <panic>
801017b1:	eb 0d                	jmp    801017c0 <iput>
801017b3:	90                   	nop
801017b4:	90                   	nop
801017b5:	90                   	nop
801017b6:	90                   	nop
801017b7:	90                   	nop
801017b8:	90                   	nop
801017b9:	90                   	nop
801017ba:	90                   	nop
801017bb:	90                   	nop
801017bc:	90                   	nop
801017bd:	90                   	nop
801017be:	90                   	nop
801017bf:	90                   	nop

801017c0 <iput>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	57                   	push   %edi
801017c4:	56                   	push   %esi
801017c5:	53                   	push   %ebx
801017c6:	83 ec 28             	sub    $0x28,%esp
801017c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017cc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017cf:	57                   	push   %edi
801017d0:	e8 0b 2e 00 00       	call   801045e0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017d5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017d8:	83 c4 10             	add    $0x10,%esp
801017db:	85 d2                	test   %edx,%edx
801017dd:	74 07                	je     801017e6 <iput+0x26>
801017df:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017e4:	74 32                	je     80101818 <iput+0x58>
  releasesleep(&ip->lock);
801017e6:	83 ec 0c             	sub    $0xc,%esp
801017e9:	57                   	push   %edi
801017ea:	e8 51 2e 00 00       	call   80104640 <releasesleep>
  acquire(&icache.lock);
801017ef:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801017f6:	e8 a5 2f 00 00       	call   801047a0 <acquire>
  ip->ref--;
801017fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ff:	83 c4 10             	add    $0x10,%esp
80101802:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
80101809:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010180c:	5b                   	pop    %ebx
8010180d:	5e                   	pop    %esi
8010180e:	5f                   	pop    %edi
8010180f:	5d                   	pop    %ebp
  release(&icache.lock);
80101810:	e9 ab 30 00 00       	jmp    801048c0 <release>
80101815:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101818:	83 ec 0c             	sub    $0xc,%esp
8010181b:	68 e0 19 11 80       	push   $0x801119e0
80101820:	e8 7b 2f 00 00       	call   801047a0 <acquire>
    int r = ip->ref;
80101825:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101828:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010182f:	e8 8c 30 00 00       	call   801048c0 <release>
    if(r == 1){
80101834:	83 c4 10             	add    $0x10,%esp
80101837:	83 fe 01             	cmp    $0x1,%esi
8010183a:	75 aa                	jne    801017e6 <iput+0x26>
8010183c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101842:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101845:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101848:	89 cf                	mov    %ecx,%edi
8010184a:	eb 0b                	jmp    80101857 <iput+0x97>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101850:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101853:	39 fe                	cmp    %edi,%esi
80101855:	74 19                	je     80101870 <iput+0xb0>
    if(ip->addrs[i]){
80101857:	8b 16                	mov    (%esi),%edx
80101859:	85 d2                	test   %edx,%edx
8010185b:	74 f3                	je     80101850 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010185d:	8b 03                	mov    (%ebx),%eax
8010185f:	e8 ac fb ff ff       	call   80101410 <bfree>
      ip->addrs[i] = 0;
80101864:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010186a:	eb e4                	jmp    80101850 <iput+0x90>
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101870:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101876:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101879:	85 c0                	test   %eax,%eax
8010187b:	75 33                	jne    801018b0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010187d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101880:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101887:	53                   	push   %ebx
80101888:	e8 53 fd ff ff       	call   801015e0 <iupdate>
      ip->type = 0;
8010188d:	31 c0                	xor    %eax,%eax
8010188f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101893:	89 1c 24             	mov    %ebx,(%esp)
80101896:	e8 45 fd ff ff       	call   801015e0 <iupdate>
      ip->valid = 0;
8010189b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018a2:	83 c4 10             	add    $0x10,%esp
801018a5:	e9 3c ff ff ff       	jmp    801017e6 <iput+0x26>
801018aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b0:	83 ec 08             	sub    $0x8,%esp
801018b3:	50                   	push   %eax
801018b4:	ff 33                	pushl  (%ebx)
801018b6:	e8 15 e8 ff ff       	call   801000d0 <bread>
801018bb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018c1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018c7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ca:	83 c4 10             	add    $0x10,%esp
801018cd:	89 cf                	mov    %ecx,%edi
801018cf:	eb 0e                	jmp    801018df <iput+0x11f>
801018d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018d8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018db:	39 fe                	cmp    %edi,%esi
801018dd:	74 0f                	je     801018ee <iput+0x12e>
      if(a[j])
801018df:	8b 16                	mov    (%esi),%edx
801018e1:	85 d2                	test   %edx,%edx
801018e3:	74 f3                	je     801018d8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018e5:	8b 03                	mov    (%ebx),%eax
801018e7:	e8 24 fb ff ff       	call   80101410 <bfree>
801018ec:	eb ea                	jmp    801018d8 <iput+0x118>
    brelse(bp);
801018ee:	83 ec 0c             	sub    $0xc,%esp
801018f1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018f7:	e8 e4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018fc:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101902:	8b 03                	mov    (%ebx),%eax
80101904:	e8 07 fb ff ff       	call   80101410 <bfree>
    ip->addrs[NDIRECT] = 0;
80101909:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101910:	00 00 00 
80101913:	83 c4 10             	add    $0x10,%esp
80101916:	e9 62 ff ff ff       	jmp    8010187d <iput+0xbd>
8010191b:	90                   	nop
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101920 <iunlockput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	53                   	push   %ebx
80101924:	83 ec 10             	sub    $0x10,%esp
80101927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010192a:	53                   	push   %ebx
8010192b:	e8 40 fe ff ff       	call   80101770 <iunlock>
  iput(ip);
80101930:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101933:	83 c4 10             	add    $0x10,%esp
}
80101936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101939:	c9                   	leave  
  iput(ip);
8010193a:	e9 81 fe ff ff       	jmp    801017c0 <iput>
8010193f:	90                   	nop

80101940 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	8b 55 08             	mov    0x8(%ebp),%edx
80101946:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101949:	8b 0a                	mov    (%edx),%ecx
8010194b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010194e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101951:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101954:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101958:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010195b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010195f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101963:	8b 52 58             	mov    0x58(%edx),%edx
80101966:	89 50 10             	mov    %edx,0x10(%eax)
}
80101969:	5d                   	pop    %ebp
8010196a:	c3                   	ret    
8010196b:	90                   	nop
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101970 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	57                   	push   %edi
80101974:	56                   	push   %esi
80101975:	53                   	push   %ebx
80101976:	83 ec 1c             	sub    $0x1c,%esp
80101979:	8b 45 08             	mov    0x8(%ebp),%eax
8010197c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010197f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101982:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101987:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010198a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010198d:	8b 75 10             	mov    0x10(%ebp),%esi
80101990:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101993:	0f 84 a7 00 00 00    	je     80101a40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101999:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010199c:	8b 40 58             	mov    0x58(%eax),%eax
8010199f:	39 c6                	cmp    %eax,%esi
801019a1:	0f 87 ba 00 00 00    	ja     80101a61 <readi+0xf1>
801019a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019aa:	89 f9                	mov    %edi,%ecx
801019ac:	01 f1                	add    %esi,%ecx
801019ae:	0f 82 ad 00 00 00    	jb     80101a61 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019b4:	89 c2                	mov    %eax,%edx
801019b6:	29 f2                	sub    %esi,%edx
801019b8:	39 c8                	cmp    %ecx,%eax
801019ba:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019bd:	31 ff                	xor    %edi,%edi
801019bf:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019c1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019c4:	74 6c                	je     80101a32 <readi+0xc2>
801019c6:	8d 76 00             	lea    0x0(%esi),%esi
801019c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019d0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019d3:	89 f2                	mov    %esi,%edx
801019d5:	c1 ea 09             	shr    $0x9,%edx
801019d8:	89 d8                	mov    %ebx,%eax
801019da:	e8 11 f9 ff ff       	call   801012f0 <bmap>
801019df:	83 ec 08             	sub    $0x8,%esp
801019e2:	50                   	push   %eax
801019e3:	ff 33                	pushl  (%ebx)
801019e5:	e8 e6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ed:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019ef:	89 f0                	mov    %esi,%eax
801019f1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019f6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019fb:	83 c4 0c             	add    $0xc,%esp
801019fe:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a00:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a04:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a07:	29 fb                	sub    %edi,%ebx
80101a09:	39 d9                	cmp    %ebx,%ecx
80101a0b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a0e:	53                   	push   %ebx
80101a0f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a10:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a12:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a15:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a17:	e8 b4 2f 00 00       	call   801049d0 <memmove>
    brelse(bp);
80101a1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a1f:	89 14 24             	mov    %edx,(%esp)
80101a22:	e8 b9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a27:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a2a:	83 c4 10             	add    $0x10,%esp
80101a2d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a30:	77 9e                	ja     801019d0 <readi+0x60>
  }
  return n;
80101a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a38:	5b                   	pop    %ebx
80101a39:	5e                   	pop    %esi
80101a3a:	5f                   	pop    %edi
80101a3b:	5d                   	pop    %ebp
80101a3c:	c3                   	ret    
80101a3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a44:	66 83 f8 09          	cmp    $0x9,%ax
80101a48:	77 17                	ja     80101a61 <readi+0xf1>
80101a4a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101a51:	85 c0                	test   %eax,%eax
80101a53:	74 0c                	je     80101a61 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a5b:	5b                   	pop    %ebx
80101a5c:	5e                   	pop    %esi
80101a5d:	5f                   	pop    %edi
80101a5e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a5f:	ff e0                	jmp    *%eax
      return -1;
80101a61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a66:	eb cd                	jmp    80101a35 <readi+0xc5>
80101a68:	90                   	nop
80101a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	57                   	push   %edi
80101a74:	56                   	push   %esi
80101a75:	53                   	push   %ebx
80101a76:	83 ec 1c             	sub    $0x1c,%esp
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a8d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a90:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a93:	0f 84 b7 00 00 00    	je     80101b50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a9c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a9f:	0f 82 eb 00 00 00    	jb     80101b90 <writei+0x120>
80101aa5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101aa8:	31 d2                	xor    %edx,%edx
80101aaa:	89 f8                	mov    %edi,%eax
80101aac:	01 f0                	add    %esi,%eax
80101aae:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ab1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ab6:	0f 87 d4 00 00 00    	ja     80101b90 <writei+0x120>
80101abc:	85 d2                	test   %edx,%edx
80101abe:	0f 85 cc 00 00 00    	jne    80101b90 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ac4:	85 ff                	test   %edi,%edi
80101ac6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101acd:	74 72                	je     80101b41 <writei+0xd1>
80101acf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ad3:	89 f2                	mov    %esi,%edx
80101ad5:	c1 ea 09             	shr    $0x9,%edx
80101ad8:	89 f8                	mov    %edi,%eax
80101ada:	e8 11 f8 ff ff       	call   801012f0 <bmap>
80101adf:	83 ec 08             	sub    $0x8,%esp
80101ae2:	50                   	push   %eax
80101ae3:	ff 37                	pushl  (%edi)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101aed:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101af2:	89 f0                	mov    %esi,%eax
80101af4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101af9:	83 c4 0c             	add    $0xc,%esp
80101afc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b01:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b07:	39 d9                	cmp    %ebx,%ecx
80101b09:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b0c:	53                   	push   %ebx
80101b0d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b10:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b12:	50                   	push   %eax
80101b13:	e8 b8 2e 00 00       	call   801049d0 <memmove>
    log_write(bp);
80101b18:	89 3c 24             	mov    %edi,(%esp)
80101b1b:	e8 f0 15 00 00       	call   80103110 <log_write>
    brelse(bp);
80101b20:	89 3c 24             	mov    %edi,(%esp)
80101b23:	e8 b8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b28:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b2b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b2e:	83 c4 10             	add    $0x10,%esp
80101b31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b34:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b37:	77 97                	ja     80101ad0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b3f:	77 37                	ja     80101b78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b41:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b47:	5b                   	pop    %ebx
80101b48:	5e                   	pop    %esi
80101b49:	5f                   	pop    %edi
80101b4a:	5d                   	pop    %ebp
80101b4b:	c3                   	ret    
80101b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b54:	66 83 f8 09          	cmp    $0x9,%ax
80101b58:	77 36                	ja     80101b90 <writei+0x120>
80101b5a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101b61:	85 c0                	test   %eax,%eax
80101b63:	74 2b                	je     80101b90 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b6b:	5b                   	pop    %ebx
80101b6c:	5e                   	pop    %esi
80101b6d:	5f                   	pop    %edi
80101b6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b6f:	ff e0                	jmp    *%eax
80101b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b7b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b81:	50                   	push   %eax
80101b82:	e8 59 fa ff ff       	call   801015e0 <iupdate>
80101b87:	83 c4 10             	add    $0x10,%esp
80101b8a:	eb b5                	jmp    80101b41 <writei+0xd1>
80101b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b95:	eb ad                	jmp    80101b44 <writei+0xd4>
80101b97:	89 f6                	mov    %esi,%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101ba6:	6a 0e                	push   $0xe
80101ba8:	ff 75 0c             	pushl  0xc(%ebp)
80101bab:	ff 75 08             	pushl  0x8(%ebp)
80101bae:	e8 8d 2e 00 00       	call   80104a40 <strncmp>
}
80101bb3:	c9                   	leave  
80101bb4:	c3                   	ret    
80101bb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 1c             	sub    $0x1c,%esp
80101bc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bcc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bd1:	0f 85 85 00 00 00    	jne    80101c5c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bd7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bda:	31 ff                	xor    %edi,%edi
80101bdc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bdf:	85 d2                	test   %edx,%edx
80101be1:	74 3e                	je     80101c21 <dirlookup+0x61>
80101be3:	90                   	nop
80101be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101be8:	6a 10                	push   $0x10
80101bea:	57                   	push   %edi
80101beb:	56                   	push   %esi
80101bec:	53                   	push   %ebx
80101bed:	e8 7e fd ff ff       	call   80101970 <readi>
80101bf2:	83 c4 10             	add    $0x10,%esp
80101bf5:	83 f8 10             	cmp    $0x10,%eax
80101bf8:	75 55                	jne    80101c4f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101bfa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bff:	74 18                	je     80101c19 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c01:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c04:	83 ec 04             	sub    $0x4,%esp
80101c07:	6a 0e                	push   $0xe
80101c09:	50                   	push   %eax
80101c0a:	ff 75 0c             	pushl  0xc(%ebp)
80101c0d:	e8 2e 2e 00 00       	call   80104a40 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c12:	83 c4 10             	add    $0x10,%esp
80101c15:	85 c0                	test   %eax,%eax
80101c17:	74 17                	je     80101c30 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c19:	83 c7 10             	add    $0x10,%edi
80101c1c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c1f:	72 c7                	jb     80101be8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c24:	31 c0                	xor    %eax,%eax
}
80101c26:	5b                   	pop    %ebx
80101c27:	5e                   	pop    %esi
80101c28:	5f                   	pop    %edi
80101c29:	5d                   	pop    %ebp
80101c2a:	c3                   	ret    
80101c2b:	90                   	nop
80101c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c30:	8b 45 10             	mov    0x10(%ebp),%eax
80101c33:	85 c0                	test   %eax,%eax
80101c35:	74 05                	je     80101c3c <dirlookup+0x7c>
        *poff = off;
80101c37:	8b 45 10             	mov    0x10(%ebp),%eax
80101c3a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c3c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c40:	8b 03                	mov    (%ebx),%eax
80101c42:	e8 d9 f5 ff ff       	call   80101220 <iget>
}
80101c47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c4a:	5b                   	pop    %ebx
80101c4b:	5e                   	pop    %esi
80101c4c:	5f                   	pop    %edi
80101c4d:	5d                   	pop    %ebp
80101c4e:	c3                   	ret    
      panic("dirlookup read");
80101c4f:	83 ec 0c             	sub    $0xc,%esp
80101c52:	68 d9 76 10 80       	push   $0x801076d9
80101c57:	e8 34 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c5c:	83 ec 0c             	sub    $0xc,%esp
80101c5f:	68 c7 76 10 80       	push   $0x801076c7
80101c64:	e8 27 e7 ff ff       	call   80100390 <panic>
80101c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	57                   	push   %edi
80101c74:	56                   	push   %esi
80101c75:	53                   	push   %ebx
80101c76:	89 cf                	mov    %ecx,%edi
80101c78:	89 c3                	mov    %eax,%ebx
80101c7a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c7d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c80:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c83:	0f 84 67 01 00 00    	je     80101df0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c89:	e8 f2 1e 00 00       	call   80103b80 <myproc>
  acquire(&icache.lock);
80101c8e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c91:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c94:	68 e0 19 11 80       	push   $0x801119e0
80101c99:	e8 02 2b 00 00       	call   801047a0 <acquire>
  ip->ref++;
80101c9e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ca2:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101ca9:	e8 12 2c 00 00       	call   801048c0 <release>
80101cae:	83 c4 10             	add    $0x10,%esp
80101cb1:	eb 08                	jmp    80101cbb <namex+0x4b>
80101cb3:	90                   	nop
80101cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101cb8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cbb:	0f b6 03             	movzbl (%ebx),%eax
80101cbe:	3c 2f                	cmp    $0x2f,%al
80101cc0:	74 f6                	je     80101cb8 <namex+0x48>
  if(*path == 0)
80101cc2:	84 c0                	test   %al,%al
80101cc4:	0f 84 ee 00 00 00    	je     80101db8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cca:	0f b6 03             	movzbl (%ebx),%eax
80101ccd:	3c 2f                	cmp    $0x2f,%al
80101ccf:	0f 84 b3 00 00 00    	je     80101d88 <namex+0x118>
80101cd5:	84 c0                	test   %al,%al
80101cd7:	89 da                	mov    %ebx,%edx
80101cd9:	75 09                	jne    80101ce4 <namex+0x74>
80101cdb:	e9 a8 00 00 00       	jmp    80101d88 <namex+0x118>
80101ce0:	84 c0                	test   %al,%al
80101ce2:	74 0a                	je     80101cee <namex+0x7e>
    path++;
80101ce4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101ce7:	0f b6 02             	movzbl (%edx),%eax
80101cea:	3c 2f                	cmp    $0x2f,%al
80101cec:	75 f2                	jne    80101ce0 <namex+0x70>
80101cee:	89 d1                	mov    %edx,%ecx
80101cf0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101cf2:	83 f9 0d             	cmp    $0xd,%ecx
80101cf5:	0f 8e 91 00 00 00    	jle    80101d8c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101cfb:	83 ec 04             	sub    $0x4,%esp
80101cfe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d01:	6a 0e                	push   $0xe
80101d03:	53                   	push   %ebx
80101d04:	57                   	push   %edi
80101d05:	e8 c6 2c 00 00       	call   801049d0 <memmove>
    path++;
80101d0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d0d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d10:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d12:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d15:	75 11                	jne    80101d28 <namex+0xb8>
80101d17:	89 f6                	mov    %esi,%esi
80101d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d20:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d23:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d26:	74 f8                	je     80101d20 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d28:	83 ec 0c             	sub    $0xc,%esp
80101d2b:	56                   	push   %esi
80101d2c:	e8 5f f9 ff ff       	call   80101690 <ilock>
    if(ip->type != T_DIR){
80101d31:	83 c4 10             	add    $0x10,%esp
80101d34:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d39:	0f 85 91 00 00 00    	jne    80101dd0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d42:	85 d2                	test   %edx,%edx
80101d44:	74 09                	je     80101d4f <namex+0xdf>
80101d46:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d49:	0f 84 b7 00 00 00    	je     80101e06 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d4f:	83 ec 04             	sub    $0x4,%esp
80101d52:	6a 00                	push   $0x0
80101d54:	57                   	push   %edi
80101d55:	56                   	push   %esi
80101d56:	e8 65 fe ff ff       	call   80101bc0 <dirlookup>
80101d5b:	83 c4 10             	add    $0x10,%esp
80101d5e:	85 c0                	test   %eax,%eax
80101d60:	74 6e                	je     80101dd0 <namex+0x160>
  iunlock(ip);
80101d62:	83 ec 0c             	sub    $0xc,%esp
80101d65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d68:	56                   	push   %esi
80101d69:	e8 02 fa ff ff       	call   80101770 <iunlock>
  iput(ip);
80101d6e:	89 34 24             	mov    %esi,(%esp)
80101d71:	e8 4a fa ff ff       	call   801017c0 <iput>
80101d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d79:	83 c4 10             	add    $0x10,%esp
80101d7c:	89 c6                	mov    %eax,%esi
80101d7e:	e9 38 ff ff ff       	jmp    80101cbb <namex+0x4b>
80101d83:	90                   	nop
80101d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d88:	89 da                	mov    %ebx,%edx
80101d8a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d8c:	83 ec 04             	sub    $0x4,%esp
80101d8f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d92:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d95:	51                   	push   %ecx
80101d96:	53                   	push   %ebx
80101d97:	57                   	push   %edi
80101d98:	e8 33 2c 00 00       	call   801049d0 <memmove>
    name[len] = 0;
80101d9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101da0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101da3:	83 c4 10             	add    $0x10,%esp
80101da6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101daa:	89 d3                	mov    %edx,%ebx
80101dac:	e9 61 ff ff ff       	jmp    80101d12 <namex+0xa2>
80101db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101db8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dbb:	85 c0                	test   %eax,%eax
80101dbd:	75 5d                	jne    80101e1c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101dbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dc2:	89 f0                	mov    %esi,%eax
80101dc4:	5b                   	pop    %ebx
80101dc5:	5e                   	pop    %esi
80101dc6:	5f                   	pop    %edi
80101dc7:	5d                   	pop    %ebp
80101dc8:	c3                   	ret    
80101dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101dd0:	83 ec 0c             	sub    $0xc,%esp
80101dd3:	56                   	push   %esi
80101dd4:	e8 97 f9 ff ff       	call   80101770 <iunlock>
  iput(ip);
80101dd9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ddc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dde:	e8 dd f9 ff ff       	call   801017c0 <iput>
      return 0;
80101de3:	83 c4 10             	add    $0x10,%esp
}
80101de6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101de9:	89 f0                	mov    %esi,%eax
80101deb:	5b                   	pop    %ebx
80101dec:	5e                   	pop    %esi
80101ded:	5f                   	pop    %edi
80101dee:	5d                   	pop    %ebp
80101def:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101df0:	ba 01 00 00 00       	mov    $0x1,%edx
80101df5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dfa:	e8 21 f4 ff ff       	call   80101220 <iget>
80101dff:	89 c6                	mov    %eax,%esi
80101e01:	e9 b5 fe ff ff       	jmp    80101cbb <namex+0x4b>
      iunlock(ip);
80101e06:	83 ec 0c             	sub    $0xc,%esp
80101e09:	56                   	push   %esi
80101e0a:	e8 61 f9 ff ff       	call   80101770 <iunlock>
      return ip;
80101e0f:	83 c4 10             	add    $0x10,%esp
}
80101e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e15:	89 f0                	mov    %esi,%eax
80101e17:	5b                   	pop    %ebx
80101e18:	5e                   	pop    %esi
80101e19:	5f                   	pop    %edi
80101e1a:	5d                   	pop    %ebp
80101e1b:	c3                   	ret    
    iput(ip);
80101e1c:	83 ec 0c             	sub    $0xc,%esp
80101e1f:	56                   	push   %esi
    return 0;
80101e20:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e22:	e8 99 f9 ff ff       	call   801017c0 <iput>
    return 0;
80101e27:	83 c4 10             	add    $0x10,%esp
80101e2a:	eb 93                	jmp    80101dbf <namex+0x14f>
80101e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e30 <dirlink>:
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	57                   	push   %edi
80101e34:	56                   	push   %esi
80101e35:	53                   	push   %ebx
80101e36:	83 ec 20             	sub    $0x20,%esp
80101e39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e3c:	6a 00                	push   $0x0
80101e3e:	ff 75 0c             	pushl  0xc(%ebp)
80101e41:	53                   	push   %ebx
80101e42:	e8 79 fd ff ff       	call   80101bc0 <dirlookup>
80101e47:	83 c4 10             	add    $0x10,%esp
80101e4a:	85 c0                	test   %eax,%eax
80101e4c:	75 67                	jne    80101eb5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e4e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e51:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e54:	85 ff                	test   %edi,%edi
80101e56:	74 29                	je     80101e81 <dirlink+0x51>
80101e58:	31 ff                	xor    %edi,%edi
80101e5a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e5d:	eb 09                	jmp    80101e68 <dirlink+0x38>
80101e5f:	90                   	nop
80101e60:	83 c7 10             	add    $0x10,%edi
80101e63:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e66:	73 19                	jae    80101e81 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e68:	6a 10                	push   $0x10
80101e6a:	57                   	push   %edi
80101e6b:	56                   	push   %esi
80101e6c:	53                   	push   %ebx
80101e6d:	e8 fe fa ff ff       	call   80101970 <readi>
80101e72:	83 c4 10             	add    $0x10,%esp
80101e75:	83 f8 10             	cmp    $0x10,%eax
80101e78:	75 4e                	jne    80101ec8 <dirlink+0x98>
    if(de.inum == 0)
80101e7a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e7f:	75 df                	jne    80101e60 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e81:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e84:	83 ec 04             	sub    $0x4,%esp
80101e87:	6a 0e                	push   $0xe
80101e89:	ff 75 0c             	pushl  0xc(%ebp)
80101e8c:	50                   	push   %eax
80101e8d:	e8 0e 2c 00 00       	call   80104aa0 <strncpy>
  de.inum = inum;
80101e92:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e95:	6a 10                	push   $0x10
80101e97:	57                   	push   %edi
80101e98:	56                   	push   %esi
80101e99:	53                   	push   %ebx
  de.inum = inum;
80101e9a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e9e:	e8 cd fb ff ff       	call   80101a70 <writei>
80101ea3:	83 c4 20             	add    $0x20,%esp
80101ea6:	83 f8 10             	cmp    $0x10,%eax
80101ea9:	75 2a                	jne    80101ed5 <dirlink+0xa5>
  return 0;
80101eab:	31 c0                	xor    %eax,%eax
}
80101ead:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eb0:	5b                   	pop    %ebx
80101eb1:	5e                   	pop    %esi
80101eb2:	5f                   	pop    %edi
80101eb3:	5d                   	pop    %ebp
80101eb4:	c3                   	ret    
    iput(ip);
80101eb5:	83 ec 0c             	sub    $0xc,%esp
80101eb8:	50                   	push   %eax
80101eb9:	e8 02 f9 ff ff       	call   801017c0 <iput>
    return -1;
80101ebe:	83 c4 10             	add    $0x10,%esp
80101ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ec6:	eb e5                	jmp    80101ead <dirlink+0x7d>
      panic("dirlink read");
80101ec8:	83 ec 0c             	sub    $0xc,%esp
80101ecb:	68 e8 76 10 80       	push   $0x801076e8
80101ed0:	e8 bb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ed5:	83 ec 0c             	sub    $0xc,%esp
80101ed8:	68 75 7d 10 80       	push   $0x80107d75
80101edd:	e8 ae e4 ff ff       	call   80100390 <panic>
80101ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ef0 <namei>:

struct inode*
namei(char *path)
{
80101ef0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ef1:	31 d2                	xor    %edx,%edx
{
80101ef3:	89 e5                	mov    %esp,%ebp
80101ef5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80101efb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101efe:	e8 6d fd ff ff       	call   80101c70 <namex>
}
80101f03:	c9                   	leave  
80101f04:	c3                   	ret    
80101f05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f10 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f10:	55                   	push   %ebp
  return namex(path, 1, name);
80101f11:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f16:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f1e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f1f:	e9 4c fd ff ff       	jmp    80101c70 <namex>
80101f24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101f30 <itoa>:


#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80101f30:	55                   	push   %ebp
    char const digit[] = "0123456789";
80101f31:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
80101f36:	89 e5                	mov    %esp,%ebp
80101f38:	57                   	push   %edi
80101f39:	56                   	push   %esi
80101f3a:	53                   	push   %ebx
80101f3b:	83 ec 10             	sub    $0x10,%esp
80101f3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80101f41:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
80101f48:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
80101f4f:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
80101f53:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
80101f57:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* p = b;
    if(i<0){
80101f5a:	85 c9                	test   %ecx,%ecx
80101f5c:	79 0a                	jns    80101f68 <itoa+0x38>
80101f5e:	89 f0                	mov    %esi,%eax
80101f60:	8d 76 01             	lea    0x1(%esi),%esi
        *p++ = '-';
        i *= -1;
80101f63:	f7 d9                	neg    %ecx
        *p++ = '-';
80101f65:	c6 00 2d             	movb   $0x2d,(%eax)
    }
    int shifter = i;
80101f68:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
80101f6a:	bf 67 66 66 66       	mov    $0x66666667,%edi
80101f6f:	90                   	nop
80101f70:	89 d8                	mov    %ebx,%eax
80101f72:	c1 fb 1f             	sar    $0x1f,%ebx
        ++p;
80101f75:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
80101f78:	f7 ef                	imul   %edi
80101f7a:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
80101f7d:	29 da                	sub    %ebx,%edx
80101f7f:	89 d3                	mov    %edx,%ebx
80101f81:	75 ed                	jne    80101f70 <itoa+0x40>
    *p = '\0';
80101f83:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80101f86:	bb 67 66 66 66       	mov    $0x66666667,%ebx
80101f8b:	90                   	nop
80101f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f90:	89 c8                	mov    %ecx,%eax
80101f92:	83 ee 01             	sub    $0x1,%esi
80101f95:	f7 eb                	imul   %ebx
80101f97:	89 c8                	mov    %ecx,%eax
80101f99:	c1 f8 1f             	sar    $0x1f,%eax
80101f9c:	c1 fa 02             	sar    $0x2,%edx
80101f9f:	29 c2                	sub    %eax,%edx
80101fa1:	8d 04 92             	lea    (%edx,%edx,4),%eax
80101fa4:	01 c0                	add    %eax,%eax
80101fa6:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
80101fa8:	85 d2                	test   %edx,%edx
        *--p = digit[i%10];
80101faa:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
80101faf:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
80101fb1:	88 06                	mov    %al,(%esi)
    }while(i);
80101fb3:	75 db                	jne    80101f90 <itoa+0x60>
    return b;
}
80101fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fb8:	83 c4 10             	add    $0x10,%esp
80101fbb:	5b                   	pop    %ebx
80101fbc:	5e                   	pop    %esi
80101fbd:	5f                   	pop    %edi
80101fbe:	5d                   	pop    %ebp
80101fbf:	c3                   	ret    

80101fc0 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	57                   	push   %edi
80101fc4:	56                   	push   %esi
80101fc5:	53                   	push   %ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80101fc6:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
80101fc9:	83 ec 40             	sub    $0x40,%esp
80101fcc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
80101fcf:	6a 06                	push   $0x6
80101fd1:	68 f5 76 10 80       	push   $0x801076f5
80101fd6:	56                   	push   %esi
80101fd7:	e8 f4 29 00 00       	call   801049d0 <memmove>
  itoa(p->pid, path+ 6);
80101fdc:	58                   	pop    %eax
80101fdd:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80101fe0:	5a                   	pop    %edx
80101fe1:	50                   	push   %eax
80101fe2:	ff 73 10             	pushl  0x10(%ebx)
80101fe5:	e8 46 ff ff ff       	call   80101f30 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
80101fea:	8b 43 7c             	mov    0x7c(%ebx),%eax
80101fed:	83 c4 10             	add    $0x10,%esp
80101ff0:	85 c0                	test   %eax,%eax
80101ff2:	0f 84 88 01 00 00    	je     80102180 <removeSwapFile+0x1c0>
  {
    return -1;
  }
  fileclose(p->swapFile);
80101ff8:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
80101ffb:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
80101ffe:	50                   	push   %eax
80101fff:	e8 3c ee ff ff       	call   80100e40 <fileclose>

  begin_op();
80102004:	e8 37 0f 00 00       	call   80102f40 <begin_op>
  return namex(path, 1, name);
80102009:	89 f0                	mov    %esi,%eax
8010200b:	89 d9                	mov    %ebx,%ecx
8010200d:	ba 01 00 00 00       	mov    $0x1,%edx
80102012:	e8 59 fc ff ff       	call   80101c70 <namex>
  if((dp = nameiparent(path, name)) == 0)
80102017:	83 c4 10             	add    $0x10,%esp
8010201a:	85 c0                	test   %eax,%eax
  return namex(path, 1, name);
8010201c:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
8010201e:	0f 84 66 01 00 00    	je     8010218a <removeSwapFile+0x1ca>
  {
    end_op();
    return -1;
  }

  ilock(dp);
80102024:	83 ec 0c             	sub    $0xc,%esp
80102027:	50                   	push   %eax
80102028:	e8 63 f6 ff ff       	call   80101690 <ilock>
  return strncmp(s, t, DIRSIZ);
8010202d:	83 c4 0c             	add    $0xc,%esp
80102030:	6a 0e                	push   $0xe
80102032:	68 fd 76 10 80       	push   $0x801076fd
80102037:	53                   	push   %ebx
80102038:	e8 03 2a 00 00       	call   80104a40 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010203d:	83 c4 10             	add    $0x10,%esp
80102040:	85 c0                	test   %eax,%eax
80102042:	0f 84 f8 00 00 00    	je     80102140 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
80102048:	83 ec 04             	sub    $0x4,%esp
8010204b:	6a 0e                	push   $0xe
8010204d:	68 fc 76 10 80       	push   $0x801076fc
80102052:	53                   	push   %ebx
80102053:	e8 e8 29 00 00       	call   80104a40 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102058:	83 c4 10             	add    $0x10,%esp
8010205b:	85 c0                	test   %eax,%eax
8010205d:	0f 84 dd 00 00 00    	je     80102140 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80102063:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102066:	83 ec 04             	sub    $0x4,%esp
80102069:	50                   	push   %eax
8010206a:	53                   	push   %ebx
8010206b:	56                   	push   %esi
8010206c:	e8 4f fb ff ff       	call   80101bc0 <dirlookup>
80102071:	83 c4 10             	add    $0x10,%esp
80102074:	85 c0                	test   %eax,%eax
80102076:	89 c3                	mov    %eax,%ebx
80102078:	0f 84 c2 00 00 00    	je     80102140 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
8010207e:	83 ec 0c             	sub    $0xc,%esp
80102081:	50                   	push   %eax
80102082:	e8 09 f6 ff ff       	call   80101690 <ilock>

  if(ip->nlink < 1)
80102087:	83 c4 10             	add    $0x10,%esp
8010208a:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010208f:	0f 8e 11 01 00 00    	jle    801021a6 <removeSwapFile+0x1e6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102095:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010209a:	74 74                	je     80102110 <removeSwapFile+0x150>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010209c:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010209f:	83 ec 04             	sub    $0x4,%esp
801020a2:	6a 10                	push   $0x10
801020a4:	6a 00                	push   $0x0
801020a6:	57                   	push   %edi
801020a7:	e8 74 28 00 00       	call   80104920 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020ac:	6a 10                	push   $0x10
801020ae:	ff 75 b8             	pushl  -0x48(%ebp)
801020b1:	57                   	push   %edi
801020b2:	56                   	push   %esi
801020b3:	e8 b8 f9 ff ff       	call   80101a70 <writei>
801020b8:	83 c4 20             	add    $0x20,%esp
801020bb:	83 f8 10             	cmp    $0x10,%eax
801020be:	0f 85 d5 00 00 00    	jne    80102199 <removeSwapFile+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801020c4:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801020c9:	0f 84 91 00 00 00    	je     80102160 <removeSwapFile+0x1a0>
  iunlock(ip);
801020cf:	83 ec 0c             	sub    $0xc,%esp
801020d2:	56                   	push   %esi
801020d3:	e8 98 f6 ff ff       	call   80101770 <iunlock>
  iput(ip);
801020d8:	89 34 24             	mov    %esi,(%esp)
801020db:	e8 e0 f6 ff ff       	call   801017c0 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
801020e0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801020e5:	89 1c 24             	mov    %ebx,(%esp)
801020e8:	e8 f3 f4 ff ff       	call   801015e0 <iupdate>
  iunlock(ip);
801020ed:	89 1c 24             	mov    %ebx,(%esp)
801020f0:	e8 7b f6 ff ff       	call   80101770 <iunlock>
  iput(ip);
801020f5:	89 1c 24             	mov    %ebx,(%esp)
801020f8:	e8 c3 f6 ff ff       	call   801017c0 <iput>
  iunlockput(ip);

  end_op();
801020fd:	e8 ae 0e 00 00       	call   80102fb0 <end_op>

  return 0;
80102102:	83 c4 10             	add    $0x10,%esp
80102105:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
80102107:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010210a:	5b                   	pop    %ebx
8010210b:	5e                   	pop    %esi
8010210c:	5f                   	pop    %edi
8010210d:	5d                   	pop    %ebp
8010210e:	c3                   	ret    
8010210f:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
80102110:	83 ec 0c             	sub    $0xc,%esp
80102113:	53                   	push   %ebx
80102114:	e8 e7 2f 00 00       	call   80105100 <isdirempty>
80102119:	83 c4 10             	add    $0x10,%esp
8010211c:	85 c0                	test   %eax,%eax
8010211e:	0f 85 78 ff ff ff    	jne    8010209c <removeSwapFile+0xdc>
  iunlock(ip);
80102124:	83 ec 0c             	sub    $0xc,%esp
80102127:	53                   	push   %ebx
80102128:	e8 43 f6 ff ff       	call   80101770 <iunlock>
  iput(ip);
8010212d:	89 1c 24             	mov    %ebx,(%esp)
80102130:	e8 8b f6 ff ff       	call   801017c0 <iput>
80102135:	83 c4 10             	add    $0x10,%esp
80102138:	90                   	nop
80102139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102140:	83 ec 0c             	sub    $0xc,%esp
80102143:	56                   	push   %esi
80102144:	e8 27 f6 ff ff       	call   80101770 <iunlock>
  iput(ip);
80102149:	89 34 24             	mov    %esi,(%esp)
8010214c:	e8 6f f6 ff ff       	call   801017c0 <iput>
    end_op();
80102151:	e8 5a 0e 00 00       	call   80102fb0 <end_op>
    return -1;
80102156:	83 c4 10             	add    $0x10,%esp
80102159:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010215e:	eb a7                	jmp    80102107 <removeSwapFile+0x147>
    dp->nlink--;
80102160:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80102165:	83 ec 0c             	sub    $0xc,%esp
80102168:	56                   	push   %esi
80102169:	e8 72 f4 ff ff       	call   801015e0 <iupdate>
8010216e:	83 c4 10             	add    $0x10,%esp
80102171:	e9 59 ff ff ff       	jmp    801020cf <removeSwapFile+0x10f>
80102176:	8d 76 00             	lea    0x0(%esi),%esi
80102179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102185:	e9 7d ff ff ff       	jmp    80102107 <removeSwapFile+0x147>
    end_op();
8010218a:	e8 21 0e 00 00       	call   80102fb0 <end_op>
    return -1;
8010218f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102194:	e9 6e ff ff ff       	jmp    80102107 <removeSwapFile+0x147>
    panic("unlink: writei");
80102199:	83 ec 0c             	sub    $0xc,%esp
8010219c:	68 11 77 10 80       	push   $0x80107711
801021a1:	e8 ea e1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801021a6:	83 ec 0c             	sub    $0xc,%esp
801021a9:	68 ff 76 10 80       	push   $0x801076ff
801021ae:	e8 dd e1 ff ff       	call   80100390 <panic>
801021b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021c0 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	56                   	push   %esi
801021c4:	53                   	push   %ebx

  char path[DIGITS];
  memmove(path,"/.swap", 6);
801021c5:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
801021c8:	83 ec 14             	sub    $0x14,%esp
801021cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
801021ce:	6a 06                	push   $0x6
801021d0:	68 f5 76 10 80       	push   $0x801076f5
801021d5:	56                   	push   %esi
801021d6:	e8 f5 27 00 00       	call   801049d0 <memmove>
  itoa(p->pid, path+ 6);
801021db:	58                   	pop    %eax
801021dc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801021df:	5a                   	pop    %edx
801021e0:	50                   	push   %eax
801021e1:	ff 73 10             	pushl  0x10(%ebx)
801021e4:	e8 47 fd ff ff       	call   80101f30 <itoa>

    begin_op();
801021e9:	e8 52 0d 00 00       	call   80102f40 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
801021ee:	6a 00                	push   $0x0
801021f0:	6a 00                	push   $0x0
801021f2:	6a 02                	push   $0x2
801021f4:	56                   	push   %esi
801021f5:	e8 16 31 00 00       	call   80105310 <create>
  iunlock(in);
801021fa:	83 c4 14             	add    $0x14,%esp
    struct inode * in = create(path, T_FILE, 0, 0);
801021fd:	89 c6                	mov    %eax,%esi
  iunlock(in);
801021ff:	50                   	push   %eax
80102200:	e8 6b f5 ff ff       	call   80101770 <iunlock>

  p->swapFile = filealloc();
80102205:	e8 76 eb ff ff       	call   80100d80 <filealloc>
  if (p->swapFile == 0)
8010220a:	83 c4 10             	add    $0x10,%esp
8010220d:	85 c0                	test   %eax,%eax
  p->swapFile = filealloc();
8010220f:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
80102212:	74 32                	je     80102246 <createSwapFile+0x86>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
80102214:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
80102217:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010221a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
80102220:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102223:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
8010222a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010222d:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
80102231:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102234:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
80102238:	e8 73 0d 00 00       	call   80102fb0 <end_op>

    return 0;
}
8010223d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102240:	31 c0                	xor    %eax,%eax
80102242:	5b                   	pop    %ebx
80102243:	5e                   	pop    %esi
80102244:	5d                   	pop    %ebp
80102245:	c3                   	ret    
    panic("no slot for files on /store");
80102246:	83 ec 0c             	sub    $0xc,%esp
80102249:	68 20 77 10 80       	push   $0x80107720
8010224e:	e8 3d e1 ff ff       	call   80100390 <panic>
80102253:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102260 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102260:	55                   	push   %ebp
80102261:	89 e5                	mov    %esp,%ebp
80102263:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102266:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102269:	8b 50 7c             	mov    0x7c(%eax),%edx
8010226c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
8010226f:	8b 55 14             	mov    0x14(%ebp),%edx
80102272:	89 55 10             	mov    %edx,0x10(%ebp)
80102275:	8b 40 7c             	mov    0x7c(%eax),%eax
80102278:	89 45 08             	mov    %eax,0x8(%ebp)

}
8010227b:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
8010227c:	e9 6f ed ff ff       	jmp    80100ff0 <filewrite>
80102281:	eb 0d                	jmp    80102290 <readFromSwapFile>
80102283:	90                   	nop
80102284:	90                   	nop
80102285:	90                   	nop
80102286:	90                   	nop
80102287:	90                   	nop
80102288:	90                   	nop
80102289:	90                   	nop
8010228a:	90                   	nop
8010228b:	90                   	nop
8010228c:	90                   	nop
8010228d:	90                   	nop
8010228e:	90                   	nop
8010228f:	90                   	nop

80102290 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102296:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102299:	8b 50 7c             	mov    0x7c(%eax),%edx
8010229c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
8010229f:	8b 55 14             	mov    0x14(%ebp),%edx
801022a2:	89 55 10             	mov    %edx,0x10(%ebp)
801022a5:	8b 40 7c             	mov    0x7c(%eax),%eax
801022a8:	89 45 08             	mov    %eax,0x8(%ebp)
}
801022ab:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
801022ac:	e9 af ec ff ff       	jmp    80100f60 <fileread>
801022b1:	66 90                	xchg   %ax,%ax
801022b3:	66 90                	xchg   %ax,%ax
801022b5:	66 90                	xchg   %ax,%ax
801022b7:	66 90                	xchg   %ax,%ax
801022b9:	66 90                	xchg   %ax,%ax
801022bb:	66 90                	xchg   %ax,%ax
801022bd:	66 90                	xchg   %ax,%ax
801022bf:	90                   	nop

801022c0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	57                   	push   %edi
801022c4:	56                   	push   %esi
801022c5:	53                   	push   %ebx
801022c6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801022c9:	85 c0                	test   %eax,%eax
801022cb:	0f 84 b4 00 00 00    	je     80102385 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801022d1:	8b 58 08             	mov    0x8(%eax),%ebx
801022d4:	89 c6                	mov    %eax,%esi
801022d6:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
801022dc:	0f 87 96 00 00 00    	ja     80102378 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022e2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801022e7:	89 f6                	mov    %esi,%esi
801022e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801022f0:	89 ca                	mov    %ecx,%edx
801022f2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022f3:	83 e0 c0             	and    $0xffffffc0,%eax
801022f6:	3c 40                	cmp    $0x40,%al
801022f8:	75 f6                	jne    801022f0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022fa:	31 ff                	xor    %edi,%edi
801022fc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102301:	89 f8                	mov    %edi,%eax
80102303:	ee                   	out    %al,(%dx)
80102304:	b8 01 00 00 00       	mov    $0x1,%eax
80102309:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010230e:	ee                   	out    %al,(%dx)
8010230f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102314:	89 d8                	mov    %ebx,%eax
80102316:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102317:	89 d8                	mov    %ebx,%eax
80102319:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010231e:	c1 f8 08             	sar    $0x8,%eax
80102321:	ee                   	out    %al,(%dx)
80102322:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102327:	89 f8                	mov    %edi,%eax
80102329:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010232a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010232e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102333:	c1 e0 04             	shl    $0x4,%eax
80102336:	83 e0 10             	and    $0x10,%eax
80102339:	83 c8 e0             	or     $0xffffffe0,%eax
8010233c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010233d:	f6 06 04             	testb  $0x4,(%esi)
80102340:	75 16                	jne    80102358 <idestart+0x98>
80102342:	b8 20 00 00 00       	mov    $0x20,%eax
80102347:	89 ca                	mov    %ecx,%edx
80102349:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010234a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010234d:	5b                   	pop    %ebx
8010234e:	5e                   	pop    %esi
8010234f:	5f                   	pop    %edi
80102350:	5d                   	pop    %ebp
80102351:	c3                   	ret    
80102352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102358:	b8 30 00 00 00       	mov    $0x30,%eax
8010235d:	89 ca                	mov    %ecx,%edx
8010235f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102360:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102365:	83 c6 5c             	add    $0x5c,%esi
80102368:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010236d:	fc                   	cld    
8010236e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102370:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102373:	5b                   	pop    %ebx
80102374:	5e                   	pop    %esi
80102375:	5f                   	pop    %edi
80102376:	5d                   	pop    %ebp
80102377:	c3                   	ret    
    panic("incorrect blockno");
80102378:	83 ec 0c             	sub    $0xc,%esp
8010237b:	68 98 77 10 80       	push   $0x80107798
80102380:	e8 0b e0 ff ff       	call   80100390 <panic>
    panic("idestart");
80102385:	83 ec 0c             	sub    $0xc,%esp
80102388:	68 8f 77 10 80       	push   $0x8010778f
8010238d:	e8 fe df ff ff       	call   80100390 <panic>
80102392:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023a0 <ideinit>:
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801023a6:	68 aa 77 10 80       	push   $0x801077aa
801023ab:	68 80 b5 10 80       	push   $0x8010b580
801023b0:	e8 fb 22 00 00       	call   801046b0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801023b5:	58                   	pop    %eax
801023b6:	a1 00 3d 11 80       	mov    0x80113d00,%eax
801023bb:	5a                   	pop    %edx
801023bc:	83 e8 01             	sub    $0x1,%eax
801023bf:	50                   	push   %eax
801023c0:	6a 0e                	push   $0xe
801023c2:	e8 a9 02 00 00       	call   80102670 <ioapicenable>
801023c7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023ca:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023cf:	90                   	nop
801023d0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023d1:	83 e0 c0             	and    $0xffffffc0,%eax
801023d4:	3c 40                	cmp    $0x40,%al
801023d6:	75 f8                	jne    801023d0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023d8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801023dd:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023e2:	ee                   	out    %al,(%dx)
801023e3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023e8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023ed:	eb 06                	jmp    801023f5 <ideinit+0x55>
801023ef:	90                   	nop
  for(i=0; i<1000; i++){
801023f0:	83 e9 01             	sub    $0x1,%ecx
801023f3:	74 0f                	je     80102404 <ideinit+0x64>
801023f5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801023f6:	84 c0                	test   %al,%al
801023f8:	74 f6                	je     801023f0 <ideinit+0x50>
      havedisk1 = 1;
801023fa:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102401:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102404:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102409:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010240e:	ee                   	out    %al,(%dx)
}
8010240f:	c9                   	leave  
80102410:	c3                   	ret    
80102411:	eb 0d                	jmp    80102420 <ideintr>
80102413:	90                   	nop
80102414:	90                   	nop
80102415:	90                   	nop
80102416:	90                   	nop
80102417:	90                   	nop
80102418:	90                   	nop
80102419:	90                   	nop
8010241a:	90                   	nop
8010241b:	90                   	nop
8010241c:	90                   	nop
8010241d:	90                   	nop
8010241e:	90                   	nop
8010241f:	90                   	nop

80102420 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102420:	55                   	push   %ebp
80102421:	89 e5                	mov    %esp,%ebp
80102423:	57                   	push   %edi
80102424:	56                   	push   %esi
80102425:	53                   	push   %ebx
80102426:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102429:	68 80 b5 10 80       	push   $0x8010b580
8010242e:	e8 6d 23 00 00       	call   801047a0 <acquire>

  if((b = idequeue) == 0){
80102433:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102439:	83 c4 10             	add    $0x10,%esp
8010243c:	85 db                	test   %ebx,%ebx
8010243e:	74 67                	je     801024a7 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102440:	8b 43 58             	mov    0x58(%ebx),%eax
80102443:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102448:	8b 3b                	mov    (%ebx),%edi
8010244a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102450:	75 31                	jne    80102483 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102452:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102457:	89 f6                	mov    %esi,%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102460:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102461:	89 c6                	mov    %eax,%esi
80102463:	83 e6 c0             	and    $0xffffffc0,%esi
80102466:	89 f1                	mov    %esi,%ecx
80102468:	80 f9 40             	cmp    $0x40,%cl
8010246b:	75 f3                	jne    80102460 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010246d:	a8 21                	test   $0x21,%al
8010246f:	75 12                	jne    80102483 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102471:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102474:	b9 80 00 00 00       	mov    $0x80,%ecx
80102479:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010247e:	fc                   	cld    
8010247f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102481:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102483:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102486:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102489:	89 f9                	mov    %edi,%ecx
8010248b:	83 c9 02             	or     $0x2,%ecx
8010248e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102490:	53                   	push   %ebx
80102491:	e8 4a 1e 00 00       	call   801042e0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102496:	a1 64 b5 10 80       	mov    0x8010b564,%eax
8010249b:	83 c4 10             	add    $0x10,%esp
8010249e:	85 c0                	test   %eax,%eax
801024a0:	74 05                	je     801024a7 <ideintr+0x87>
    idestart(idequeue);
801024a2:	e8 19 fe ff ff       	call   801022c0 <idestart>
    release(&idelock);
801024a7:	83 ec 0c             	sub    $0xc,%esp
801024aa:	68 80 b5 10 80       	push   $0x8010b580
801024af:	e8 0c 24 00 00       	call   801048c0 <release>

  release(&idelock);
}
801024b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024b7:	5b                   	pop    %ebx
801024b8:	5e                   	pop    %esi
801024b9:	5f                   	pop    %edi
801024ba:	5d                   	pop    %ebp
801024bb:	c3                   	ret    
801024bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801024c0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	53                   	push   %ebx
801024c4:	83 ec 10             	sub    $0x10,%esp
801024c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801024ca:	8d 43 0c             	lea    0xc(%ebx),%eax
801024cd:	50                   	push   %eax
801024ce:	e8 ad 21 00 00       	call   80104680 <holdingsleep>
801024d3:	83 c4 10             	add    $0x10,%esp
801024d6:	85 c0                	test   %eax,%eax
801024d8:	0f 84 c6 00 00 00    	je     801025a4 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801024de:	8b 03                	mov    (%ebx),%eax
801024e0:	83 e0 06             	and    $0x6,%eax
801024e3:	83 f8 02             	cmp    $0x2,%eax
801024e6:	0f 84 ab 00 00 00    	je     80102597 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801024ec:	8b 53 04             	mov    0x4(%ebx),%edx
801024ef:	85 d2                	test   %edx,%edx
801024f1:	74 0d                	je     80102500 <iderw+0x40>
801024f3:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801024f8:	85 c0                	test   %eax,%eax
801024fa:	0f 84 b1 00 00 00    	je     801025b1 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102500:	83 ec 0c             	sub    $0xc,%esp
80102503:	68 80 b5 10 80       	push   $0x8010b580
80102508:	e8 93 22 00 00       	call   801047a0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010250d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102513:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102516:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010251d:	85 d2                	test   %edx,%edx
8010251f:	75 09                	jne    8010252a <iderw+0x6a>
80102521:	eb 6d                	jmp    80102590 <iderw+0xd0>
80102523:	90                   	nop
80102524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102528:	89 c2                	mov    %eax,%edx
8010252a:	8b 42 58             	mov    0x58(%edx),%eax
8010252d:	85 c0                	test   %eax,%eax
8010252f:	75 f7                	jne    80102528 <iderw+0x68>
80102531:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102534:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102536:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010253c:	74 42                	je     80102580 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010253e:	8b 03                	mov    (%ebx),%eax
80102540:	83 e0 06             	and    $0x6,%eax
80102543:	83 f8 02             	cmp    $0x2,%eax
80102546:	74 23                	je     8010256b <iderw+0xab>
80102548:	90                   	nop
80102549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102550:	83 ec 08             	sub    $0x8,%esp
80102553:	68 80 b5 10 80       	push   $0x8010b580
80102558:	53                   	push   %ebx
80102559:	e8 c2 1b 00 00       	call   80104120 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010255e:	8b 03                	mov    (%ebx),%eax
80102560:	83 c4 10             	add    $0x10,%esp
80102563:	83 e0 06             	and    $0x6,%eax
80102566:	83 f8 02             	cmp    $0x2,%eax
80102569:	75 e5                	jne    80102550 <iderw+0x90>
  }


  release(&idelock);
8010256b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102572:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102575:	c9                   	leave  
  release(&idelock);
80102576:	e9 45 23 00 00       	jmp    801048c0 <release>
8010257b:	90                   	nop
8010257c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102580:	89 d8                	mov    %ebx,%eax
80102582:	e8 39 fd ff ff       	call   801022c0 <idestart>
80102587:	eb b5                	jmp    8010253e <iderw+0x7e>
80102589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102590:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102595:	eb 9d                	jmp    80102534 <iderw+0x74>
    panic("iderw: nothing to do");
80102597:	83 ec 0c             	sub    $0xc,%esp
8010259a:	68 c4 77 10 80       	push   $0x801077c4
8010259f:	e8 ec dd ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801025a4:	83 ec 0c             	sub    $0xc,%esp
801025a7:	68 ae 77 10 80       	push   $0x801077ae
801025ac:	e8 df dd ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
801025b1:	83 ec 0c             	sub    $0xc,%esp
801025b4:	68 d9 77 10 80       	push   $0x801077d9
801025b9:	e8 d2 dd ff ff       	call   80100390 <panic>
801025be:	66 90                	xchg   %ax,%ax

801025c0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801025c0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801025c1:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
801025c8:	00 c0 fe 
{
801025cb:	89 e5                	mov    %esp,%ebp
801025cd:	56                   	push   %esi
801025ce:	53                   	push   %ebx
  ioapic->reg = reg;
801025cf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801025d6:	00 00 00 
  return ioapic->data;
801025d9:	a1 34 36 11 80       	mov    0x80113634,%eax
801025de:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
801025e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
801025e7:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801025ed:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801025f4:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
801025f7:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801025fa:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
801025fd:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102600:	39 c2                	cmp    %eax,%edx
80102602:	74 16                	je     8010261a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102604:	83 ec 0c             	sub    $0xc,%esp
80102607:	68 f8 77 10 80       	push   $0x801077f8
8010260c:	e8 4f e0 ff ff       	call   80100660 <cprintf>
80102611:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102617:	83 c4 10             	add    $0x10,%esp
8010261a:	83 c3 21             	add    $0x21,%ebx
{
8010261d:	ba 10 00 00 00       	mov    $0x10,%edx
80102622:	b8 20 00 00 00       	mov    $0x20,%eax
80102627:	89 f6                	mov    %esi,%esi
80102629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102630:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102632:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102638:	89 c6                	mov    %eax,%esi
8010263a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102640:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102643:	89 71 10             	mov    %esi,0x10(%ecx)
80102646:	8d 72 01             	lea    0x1(%edx),%esi
80102649:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010264c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010264e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102650:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102656:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010265d:	75 d1                	jne    80102630 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010265f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102662:	5b                   	pop    %ebx
80102663:	5e                   	pop    %esi
80102664:	5d                   	pop    %ebp
80102665:	c3                   	ret    
80102666:	8d 76 00             	lea    0x0(%esi),%esi
80102669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102670 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102670:	55                   	push   %ebp
  ioapic->reg = reg;
80102671:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
{
80102677:	89 e5                	mov    %esp,%ebp
80102679:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010267c:	8d 50 20             	lea    0x20(%eax),%edx
8010267f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102683:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102685:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010268b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010268e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102691:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102694:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102696:	a1 34 36 11 80       	mov    0x80113634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010269b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010269e:	89 50 10             	mov    %edx,0x10(%eax)
}
801026a1:	5d                   	pop    %ebp
801026a2:	c3                   	ret    
801026a3:	66 90                	xchg   %ax,%ax
801026a5:	66 90                	xchg   %ax,%ax
801026a7:	66 90                	xchg   %ax,%ax
801026a9:	66 90                	xchg   %ax,%ax
801026ab:	66 90                	xchg   %ax,%ax
801026ad:	66 90                	xchg   %ax,%ax
801026af:	90                   	nop

801026b0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801026b0:	55                   	push   %ebp
801026b1:	89 e5                	mov    %esp,%ebp
801026b3:	53                   	push   %ebx
801026b4:	83 ec 04             	sub    $0x4,%esp
801026b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801026ba:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801026c0:	75 70                	jne    80102732 <kfree+0x82>
801026c2:	81 fb a8 68 11 80    	cmp    $0x801168a8,%ebx
801026c8:	72 68                	jb     80102732 <kfree+0x82>
801026ca:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801026d0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801026d5:	77 5b                	ja     80102732 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801026d7:	83 ec 04             	sub    $0x4,%esp
801026da:	68 00 10 00 00       	push   $0x1000
801026df:	6a 01                	push   $0x1
801026e1:	53                   	push   %ebx
801026e2:	e8 39 22 00 00       	call   80104920 <memset>

  if(kmem.use_lock)
801026e7:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801026ed:	83 c4 10             	add    $0x10,%esp
801026f0:	85 d2                	test   %edx,%edx
801026f2:	75 2c                	jne    80102720 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801026f4:	a1 78 36 11 80       	mov    0x80113678,%eax
801026f9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801026fb:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
80102700:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
80102706:	85 c0                	test   %eax,%eax
80102708:	75 06                	jne    80102710 <kfree+0x60>
    release(&kmem.lock);
}
8010270a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010270d:	c9                   	leave  
8010270e:	c3                   	ret    
8010270f:	90                   	nop
    release(&kmem.lock);
80102710:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
80102717:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010271a:	c9                   	leave  
    release(&kmem.lock);
8010271b:	e9 a0 21 00 00       	jmp    801048c0 <release>
    acquire(&kmem.lock);
80102720:	83 ec 0c             	sub    $0xc,%esp
80102723:	68 40 36 11 80       	push   $0x80113640
80102728:	e8 73 20 00 00       	call   801047a0 <acquire>
8010272d:	83 c4 10             	add    $0x10,%esp
80102730:	eb c2                	jmp    801026f4 <kfree+0x44>
    panic("kfree");
80102732:	83 ec 0c             	sub    $0xc,%esp
80102735:	68 2a 78 10 80       	push   $0x8010782a
8010273a:	e8 51 dc ff ff       	call   80100390 <panic>
8010273f:	90                   	nop

80102740 <freerange>:
{
80102740:	55                   	push   %ebp
80102741:	89 e5                	mov    %esp,%ebp
80102743:	56                   	push   %esi
80102744:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102745:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102748:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010274b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102751:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102757:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010275d:	39 de                	cmp    %ebx,%esi
8010275f:	72 23                	jb     80102784 <freerange+0x44>
80102761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102768:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010276e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102771:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102777:	50                   	push   %eax
80102778:	e8 33 ff ff ff       	call   801026b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010277d:	83 c4 10             	add    $0x10,%esp
80102780:	39 f3                	cmp    %esi,%ebx
80102782:	76 e4                	jbe    80102768 <freerange+0x28>
}
80102784:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102787:	5b                   	pop    %ebx
80102788:	5e                   	pop    %esi
80102789:	5d                   	pop    %ebp
8010278a:	c3                   	ret    
8010278b:	90                   	nop
8010278c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102790 <kinit1>:
{
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
80102793:	56                   	push   %esi
80102794:	53                   	push   %ebx
80102795:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102798:	83 ec 08             	sub    $0x8,%esp
8010279b:	68 30 78 10 80       	push   $0x80107830
801027a0:	68 40 36 11 80       	push   $0x80113640
801027a5:	e8 06 1f 00 00       	call   801046b0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801027aa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027ad:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801027b0:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
801027b7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801027ba:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027c0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027c6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027cc:	39 de                	cmp    %ebx,%esi
801027ce:	72 1c                	jb     801027ec <kinit1+0x5c>
    kfree(p);
801027d0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801027d6:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027d9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027df:	50                   	push   %eax
801027e0:	e8 cb fe ff ff       	call   801026b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027e5:	83 c4 10             	add    $0x10,%esp
801027e8:	39 de                	cmp    %ebx,%esi
801027ea:	73 e4                	jae    801027d0 <kinit1+0x40>
}
801027ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027ef:	5b                   	pop    %ebx
801027f0:	5e                   	pop    %esi
801027f1:	5d                   	pop    %ebp
801027f2:	c3                   	ret    
801027f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801027f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102800 <kinit2>:
{
80102800:	55                   	push   %ebp
80102801:	89 e5                	mov    %esp,%ebp
80102803:	56                   	push   %esi
80102804:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102805:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102808:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010280b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102811:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102817:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010281d:	39 de                	cmp    %ebx,%esi
8010281f:	72 23                	jb     80102844 <kinit2+0x44>
80102821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102828:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010282e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102831:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102837:	50                   	push   %eax
80102838:	e8 73 fe ff ff       	call   801026b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010283d:	83 c4 10             	add    $0x10,%esp
80102840:	39 de                	cmp    %ebx,%esi
80102842:	73 e4                	jae    80102828 <kinit2+0x28>
  kmem.use_lock = 1;
80102844:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010284b:	00 00 00 
}
8010284e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102851:	5b                   	pop    %ebx
80102852:	5e                   	pop    %esi
80102853:	5d                   	pop    %ebp
80102854:	c3                   	ret    
80102855:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102860 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102860:	a1 74 36 11 80       	mov    0x80113674,%eax
80102865:	85 c0                	test   %eax,%eax
80102867:	75 1f                	jne    80102888 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102869:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010286e:	85 c0                	test   %eax,%eax
80102870:	74 0e                	je     80102880 <kalloc+0x20>
    kmem.freelist = r->next;
80102872:	8b 10                	mov    (%eax),%edx
80102874:	89 15 78 36 11 80    	mov    %edx,0x80113678
8010287a:	c3                   	ret    
8010287b:	90                   	nop
8010287c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102880:	f3 c3                	repz ret 
80102882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102888:	55                   	push   %ebp
80102889:	89 e5                	mov    %esp,%ebp
8010288b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010288e:	68 40 36 11 80       	push   $0x80113640
80102893:	e8 08 1f 00 00       	call   801047a0 <acquire>
  r = kmem.freelist;
80102898:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010289d:	83 c4 10             	add    $0x10,%esp
801028a0:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801028a6:	85 c0                	test   %eax,%eax
801028a8:	74 08                	je     801028b2 <kalloc+0x52>
    kmem.freelist = r->next;
801028aa:	8b 08                	mov    (%eax),%ecx
801028ac:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
801028b2:	85 d2                	test   %edx,%edx
801028b4:	74 16                	je     801028cc <kalloc+0x6c>
    release(&kmem.lock);
801028b6:	83 ec 0c             	sub    $0xc,%esp
801028b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028bc:	68 40 36 11 80       	push   $0x80113640
801028c1:	e8 fa 1f 00 00       	call   801048c0 <release>
  return (char*)r;
801028c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801028c9:	83 c4 10             	add    $0x10,%esp
}
801028cc:	c9                   	leave  
801028cd:	c3                   	ret    
801028ce:	66 90                	xchg   %ax,%ax

801028d0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028d0:	ba 64 00 00 00       	mov    $0x64,%edx
801028d5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801028d6:	a8 01                	test   $0x1,%al
801028d8:	0f 84 c2 00 00 00    	je     801029a0 <kbdgetc+0xd0>
801028de:	ba 60 00 00 00       	mov    $0x60,%edx
801028e3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801028e4:	0f b6 d0             	movzbl %al,%edx
801028e7:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
801028ed:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801028f3:	0f 84 7f 00 00 00    	je     80102978 <kbdgetc+0xa8>
{
801028f9:	55                   	push   %ebp
801028fa:	89 e5                	mov    %esp,%ebp
801028fc:	53                   	push   %ebx
801028fd:	89 cb                	mov    %ecx,%ebx
801028ff:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102902:	84 c0                	test   %al,%al
80102904:	78 4a                	js     80102950 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102906:	85 db                	test   %ebx,%ebx
80102908:	74 09                	je     80102913 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010290a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010290d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102910:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102913:	0f b6 82 60 79 10 80 	movzbl -0x7fef86a0(%edx),%eax
8010291a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010291c:	0f b6 82 60 78 10 80 	movzbl -0x7fef87a0(%edx),%eax
80102923:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102925:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102927:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010292d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102930:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102933:	8b 04 85 40 78 10 80 	mov    -0x7fef87c0(,%eax,4),%eax
8010293a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010293e:	74 31                	je     80102971 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102940:	8d 50 9f             	lea    -0x61(%eax),%edx
80102943:	83 fa 19             	cmp    $0x19,%edx
80102946:	77 40                	ja     80102988 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102948:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010294b:	5b                   	pop    %ebx
8010294c:	5d                   	pop    %ebp
8010294d:	c3                   	ret    
8010294e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102950:	83 e0 7f             	and    $0x7f,%eax
80102953:	85 db                	test   %ebx,%ebx
80102955:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102958:	0f b6 82 60 79 10 80 	movzbl -0x7fef86a0(%edx),%eax
8010295f:	83 c8 40             	or     $0x40,%eax
80102962:	0f b6 c0             	movzbl %al,%eax
80102965:	f7 d0                	not    %eax
80102967:	21 c1                	and    %eax,%ecx
    return 0;
80102969:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010296b:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102971:	5b                   	pop    %ebx
80102972:	5d                   	pop    %ebp
80102973:	c3                   	ret    
80102974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102978:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010297b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010297d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
80102983:	c3                   	ret    
80102984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102988:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010298b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010298e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010298f:	83 f9 1a             	cmp    $0x1a,%ecx
80102992:	0f 42 c2             	cmovb  %edx,%eax
}
80102995:	5d                   	pop    %ebp
80102996:	c3                   	ret    
80102997:	89 f6                	mov    %esi,%esi
80102999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801029a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801029a5:	c3                   	ret    
801029a6:	8d 76 00             	lea    0x0(%esi),%esi
801029a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029b0 <kbdintr>:

void
kbdintr(void)
{
801029b0:	55                   	push   %ebp
801029b1:	89 e5                	mov    %esp,%ebp
801029b3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801029b6:	68 d0 28 10 80       	push   $0x801028d0
801029bb:	e8 50 de ff ff       	call   80100810 <consoleintr>
}
801029c0:	83 c4 10             	add    $0x10,%esp
801029c3:	c9                   	leave  
801029c4:	c3                   	ret    
801029c5:	66 90                	xchg   %ax,%ax
801029c7:	66 90                	xchg   %ax,%ax
801029c9:	66 90                	xchg   %ax,%ax
801029cb:	66 90                	xchg   %ax,%ax
801029cd:	66 90                	xchg   %ax,%ax
801029cf:	90                   	nop

801029d0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801029d0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
{
801029d5:	55                   	push   %ebp
801029d6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801029d8:	85 c0                	test   %eax,%eax
801029da:	0f 84 c8 00 00 00    	je     80102aa8 <lapicinit+0xd8>
  lapic[index] = value;
801029e0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801029e7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029ea:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ed:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801029f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029fa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102a01:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102a04:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a07:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102a0e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102a11:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a14:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102a1b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a1e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a21:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102a28:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a2b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a2e:	8b 50 30             	mov    0x30(%eax),%edx
80102a31:	c1 ea 10             	shr    $0x10,%edx
80102a34:	80 fa 03             	cmp    $0x3,%dl
80102a37:	77 77                	ja     80102ab0 <lapicinit+0xe0>
  lapic[index] = value;
80102a39:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a40:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a43:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a46:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a4d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a50:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a53:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a5a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a5d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a60:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a67:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a6a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a6d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a74:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a77:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a7a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a81:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a84:	8b 50 20             	mov    0x20(%eax),%edx
80102a87:	89 f6                	mov    %esi,%esi
80102a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a90:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a96:	80 e6 10             	and    $0x10,%dh
80102a99:	75 f5                	jne    80102a90 <lapicinit+0xc0>
  lapic[index] = value;
80102a9b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102aa2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102aa8:	5d                   	pop    %ebp
80102aa9:	c3                   	ret    
80102aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102ab0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102ab7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102aba:	8b 50 20             	mov    0x20(%eax),%edx
80102abd:	e9 77 ff ff ff       	jmp    80102a39 <lapicinit+0x69>
80102ac2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ad0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102ad0:	8b 15 7c 36 11 80    	mov    0x8011367c,%edx
{
80102ad6:	55                   	push   %ebp
80102ad7:	31 c0                	xor    %eax,%eax
80102ad9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102adb:	85 d2                	test   %edx,%edx
80102add:	74 06                	je     80102ae5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102adf:	8b 42 20             	mov    0x20(%edx),%eax
80102ae2:	c1 e8 18             	shr    $0x18,%eax
}
80102ae5:	5d                   	pop    %ebp
80102ae6:	c3                   	ret    
80102ae7:	89 f6                	mov    %esi,%esi
80102ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102af0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102af0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
{
80102af5:	55                   	push   %ebp
80102af6:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102af8:	85 c0                	test   %eax,%eax
80102afa:	74 0d                	je     80102b09 <lapiceoi+0x19>
  lapic[index] = value;
80102afc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b03:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b06:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102b09:	5d                   	pop    %ebp
80102b0a:	c3                   	ret    
80102b0b:	90                   	nop
80102b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b10 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102b10:	55                   	push   %ebp
80102b11:	89 e5                	mov    %esp,%ebp
}
80102b13:	5d                   	pop    %ebp
80102b14:	c3                   	ret    
80102b15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b20 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b20:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b21:	b8 0f 00 00 00       	mov    $0xf,%eax
80102b26:	ba 70 00 00 00       	mov    $0x70,%edx
80102b2b:	89 e5                	mov    %esp,%ebp
80102b2d:	53                   	push   %ebx
80102b2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b31:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b34:	ee                   	out    %al,(%dx)
80102b35:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b3a:	ba 71 00 00 00       	mov    $0x71,%edx
80102b3f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b40:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102b42:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102b45:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b4b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b4d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102b50:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102b53:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b55:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102b58:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102b5e:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102b63:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b69:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b6c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b73:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b76:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b79:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b80:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b83:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b86:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b8c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b8f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b95:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b98:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b9e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ba1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ba7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102baa:	5b                   	pop    %ebx
80102bab:	5d                   	pop    %ebp
80102bac:	c3                   	ret    
80102bad:	8d 76 00             	lea    0x0(%esi),%esi

80102bb0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102bb0:	55                   	push   %ebp
80102bb1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102bb6:	ba 70 00 00 00       	mov    $0x70,%edx
80102bbb:	89 e5                	mov    %esp,%ebp
80102bbd:	57                   	push   %edi
80102bbe:	56                   	push   %esi
80102bbf:	53                   	push   %ebx
80102bc0:	83 ec 4c             	sub    $0x4c,%esp
80102bc3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bc4:	ba 71 00 00 00       	mov    $0x71,%edx
80102bc9:	ec                   	in     (%dx),%al
80102bca:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bcd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102bd2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102bd5:	8d 76 00             	lea    0x0(%esi),%esi
80102bd8:	31 c0                	xor    %eax,%eax
80102bda:	89 da                	mov    %ebx,%edx
80102bdc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bdd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102be2:	89 ca                	mov    %ecx,%edx
80102be4:	ec                   	in     (%dx),%al
80102be5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be8:	89 da                	mov    %ebx,%edx
80102bea:	b8 02 00 00 00       	mov    $0x2,%eax
80102bef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bf0:	89 ca                	mov    %ecx,%edx
80102bf2:	ec                   	in     (%dx),%al
80102bf3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf6:	89 da                	mov    %ebx,%edx
80102bf8:	b8 04 00 00 00       	mov    $0x4,%eax
80102bfd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bfe:	89 ca                	mov    %ecx,%edx
80102c00:	ec                   	in     (%dx),%al
80102c01:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c04:	89 da                	mov    %ebx,%edx
80102c06:	b8 07 00 00 00       	mov    $0x7,%eax
80102c0b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c0c:	89 ca                	mov    %ecx,%edx
80102c0e:	ec                   	in     (%dx),%al
80102c0f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c12:	89 da                	mov    %ebx,%edx
80102c14:	b8 08 00 00 00       	mov    $0x8,%eax
80102c19:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c1a:	89 ca                	mov    %ecx,%edx
80102c1c:	ec                   	in     (%dx),%al
80102c1d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c1f:	89 da                	mov    %ebx,%edx
80102c21:	b8 09 00 00 00       	mov    $0x9,%eax
80102c26:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c27:	89 ca                	mov    %ecx,%edx
80102c29:	ec                   	in     (%dx),%al
80102c2a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c2c:	89 da                	mov    %ebx,%edx
80102c2e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c33:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c34:	89 ca                	mov    %ecx,%edx
80102c36:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c37:	84 c0                	test   %al,%al
80102c39:	78 9d                	js     80102bd8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102c3b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c3f:	89 fa                	mov    %edi,%edx
80102c41:	0f b6 fa             	movzbl %dl,%edi
80102c44:	89 f2                	mov    %esi,%edx
80102c46:	0f b6 f2             	movzbl %dl,%esi
80102c49:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c4c:	89 da                	mov    %ebx,%edx
80102c4e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102c51:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c54:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102c58:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c5b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102c5f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c62:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102c66:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c69:	31 c0                	xor    %eax,%eax
80102c6b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c6c:	89 ca                	mov    %ecx,%edx
80102c6e:	ec                   	in     (%dx),%al
80102c6f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c72:	89 da                	mov    %ebx,%edx
80102c74:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c77:	b8 02 00 00 00       	mov    $0x2,%eax
80102c7c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c7d:	89 ca                	mov    %ecx,%edx
80102c7f:	ec                   	in     (%dx),%al
80102c80:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c83:	89 da                	mov    %ebx,%edx
80102c85:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c88:	b8 04 00 00 00       	mov    $0x4,%eax
80102c8d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c8e:	89 ca                	mov    %ecx,%edx
80102c90:	ec                   	in     (%dx),%al
80102c91:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c94:	89 da                	mov    %ebx,%edx
80102c96:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c99:	b8 07 00 00 00       	mov    $0x7,%eax
80102c9e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c9f:	89 ca                	mov    %ecx,%edx
80102ca1:	ec                   	in     (%dx),%al
80102ca2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ca5:	89 da                	mov    %ebx,%edx
80102ca7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102caa:	b8 08 00 00 00       	mov    $0x8,%eax
80102caf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cb0:	89 ca                	mov    %ecx,%edx
80102cb2:	ec                   	in     (%dx),%al
80102cb3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cb6:	89 da                	mov    %ebx,%edx
80102cb8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102cbb:	b8 09 00 00 00       	mov    $0x9,%eax
80102cc0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cc1:	89 ca                	mov    %ecx,%edx
80102cc3:	ec                   	in     (%dx),%al
80102cc4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102cc7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102cca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ccd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102cd0:	6a 18                	push   $0x18
80102cd2:	50                   	push   %eax
80102cd3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102cd6:	50                   	push   %eax
80102cd7:	e8 94 1c 00 00       	call   80104970 <memcmp>
80102cdc:	83 c4 10             	add    $0x10,%esp
80102cdf:	85 c0                	test   %eax,%eax
80102ce1:	0f 85 f1 fe ff ff    	jne    80102bd8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102ce7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102ceb:	75 78                	jne    80102d65 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ced:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cf0:	89 c2                	mov    %eax,%edx
80102cf2:	83 e0 0f             	and    $0xf,%eax
80102cf5:	c1 ea 04             	shr    $0x4,%edx
80102cf8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cfb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cfe:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102d01:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d04:	89 c2                	mov    %eax,%edx
80102d06:	83 e0 0f             	and    $0xf,%eax
80102d09:	c1 ea 04             	shr    $0x4,%edx
80102d0c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d0f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d12:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102d15:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d18:	89 c2                	mov    %eax,%edx
80102d1a:	83 e0 0f             	and    $0xf,%eax
80102d1d:	c1 ea 04             	shr    $0x4,%edx
80102d20:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d23:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d26:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102d29:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d2c:	89 c2                	mov    %eax,%edx
80102d2e:	83 e0 0f             	and    $0xf,%eax
80102d31:	c1 ea 04             	shr    $0x4,%edx
80102d34:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d37:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d3a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d3d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d40:	89 c2                	mov    %eax,%edx
80102d42:	83 e0 0f             	and    $0xf,%eax
80102d45:	c1 ea 04             	shr    $0x4,%edx
80102d48:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d4b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d4e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d51:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d54:	89 c2                	mov    %eax,%edx
80102d56:	83 e0 0f             	and    $0xf,%eax
80102d59:	c1 ea 04             	shr    $0x4,%edx
80102d5c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d5f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d62:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d65:	8b 75 08             	mov    0x8(%ebp),%esi
80102d68:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d6b:	89 06                	mov    %eax,(%esi)
80102d6d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d70:	89 46 04             	mov    %eax,0x4(%esi)
80102d73:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d76:	89 46 08             	mov    %eax,0x8(%esi)
80102d79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d7c:	89 46 0c             	mov    %eax,0xc(%esi)
80102d7f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d82:	89 46 10             	mov    %eax,0x10(%esi)
80102d85:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d88:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102d8b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102d92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d95:	5b                   	pop    %ebx
80102d96:	5e                   	pop    %esi
80102d97:	5f                   	pop    %edi
80102d98:	5d                   	pop    %ebp
80102d99:	c3                   	ret    
80102d9a:	66 90                	xchg   %ax,%ax
80102d9c:	66 90                	xchg   %ax,%ax
80102d9e:	66 90                	xchg   %ax,%ax

80102da0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102da0:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102da6:	85 c9                	test   %ecx,%ecx
80102da8:	0f 8e 8a 00 00 00    	jle    80102e38 <install_trans+0x98>
{
80102dae:	55                   	push   %ebp
80102daf:	89 e5                	mov    %esp,%ebp
80102db1:	57                   	push   %edi
80102db2:	56                   	push   %esi
80102db3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102db4:	31 db                	xor    %ebx,%ebx
{
80102db6:	83 ec 0c             	sub    $0xc,%esp
80102db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102dc0:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102dc5:	83 ec 08             	sub    $0x8,%esp
80102dc8:	01 d8                	add    %ebx,%eax
80102dca:	83 c0 01             	add    $0x1,%eax
80102dcd:	50                   	push   %eax
80102dce:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102dd4:	e8 f7 d2 ff ff       	call   801000d0 <bread>
80102dd9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ddb:	58                   	pop    %eax
80102ddc:	5a                   	pop    %edx
80102ddd:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102de4:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102dea:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ded:	e8 de d2 ff ff       	call   801000d0 <bread>
80102df2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102df4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102df7:	83 c4 0c             	add    $0xc,%esp
80102dfa:	68 00 02 00 00       	push   $0x200
80102dff:	50                   	push   %eax
80102e00:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e03:	50                   	push   %eax
80102e04:	e8 c7 1b 00 00       	call   801049d0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102e09:	89 34 24             	mov    %esi,(%esp)
80102e0c:	e8 8f d3 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102e11:	89 3c 24             	mov    %edi,(%esp)
80102e14:	e8 c7 d3 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102e19:	89 34 24             	mov    %esi,(%esp)
80102e1c:	e8 bf d3 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e21:	83 c4 10             	add    $0x10,%esp
80102e24:	39 1d c8 36 11 80    	cmp    %ebx,0x801136c8
80102e2a:	7f 94                	jg     80102dc0 <install_trans+0x20>
  }
}
80102e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e2f:	5b                   	pop    %ebx
80102e30:	5e                   	pop    %esi
80102e31:	5f                   	pop    %edi
80102e32:	5d                   	pop    %ebp
80102e33:	c3                   	ret    
80102e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e38:	f3 c3                	repz ret 
80102e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102e40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	56                   	push   %esi
80102e44:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102e45:	83 ec 08             	sub    $0x8,%esp
80102e48:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102e4e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102e54:	e8 77 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102e59:	8b 1d c8 36 11 80    	mov    0x801136c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102e5f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e62:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102e64:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102e66:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102e69:	7e 16                	jle    80102e81 <write_head+0x41>
80102e6b:	c1 e3 02             	shl    $0x2,%ebx
80102e6e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102e70:	8b 8a cc 36 11 80    	mov    -0x7feec934(%edx),%ecx
80102e76:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102e7a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102e7d:	39 da                	cmp    %ebx,%edx
80102e7f:	75 ef                	jne    80102e70 <write_head+0x30>
  }
  bwrite(buf);
80102e81:	83 ec 0c             	sub    $0xc,%esp
80102e84:	56                   	push   %esi
80102e85:	e8 16 d3 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102e8a:	89 34 24             	mov    %esi,(%esp)
80102e8d:	e8 4e d3 ff ff       	call   801001e0 <brelse>
}
80102e92:	83 c4 10             	add    $0x10,%esp
80102e95:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e98:	5b                   	pop    %ebx
80102e99:	5e                   	pop    %esi
80102e9a:	5d                   	pop    %ebp
80102e9b:	c3                   	ret    
80102e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ea0 <initlog>:
{
80102ea0:	55                   	push   %ebp
80102ea1:	89 e5                	mov    %esp,%ebp
80102ea3:	53                   	push   %ebx
80102ea4:	83 ec 2c             	sub    $0x2c,%esp
80102ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102eaa:	68 60 7a 10 80       	push   $0x80107a60
80102eaf:	68 80 36 11 80       	push   $0x80113680
80102eb4:	e8 f7 17 00 00       	call   801046b0 <initlock>
  readsb(dev, &sb);
80102eb9:	58                   	pop    %eax
80102eba:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ebd:	5a                   	pop    %edx
80102ebe:	50                   	push   %eax
80102ebf:	53                   	push   %ebx
80102ec0:	e8 0b e5 ff ff       	call   801013d0 <readsb>
  log.size = sb.nlog;
80102ec5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102ec8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ecb:	59                   	pop    %ecx
  log.dev = dev;
80102ecc:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4
  log.size = sb.nlog;
80102ed2:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  log.start = sb.logstart;
80102ed8:	a3 b4 36 11 80       	mov    %eax,0x801136b4
  struct buf *buf = bread(log.dev, log.start);
80102edd:	5a                   	pop    %edx
80102ede:	50                   	push   %eax
80102edf:	53                   	push   %ebx
80102ee0:	e8 eb d1 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102ee5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102ee8:	83 c4 10             	add    $0x10,%esp
80102eeb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102eed:	89 1d c8 36 11 80    	mov    %ebx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102ef3:	7e 1c                	jle    80102f11 <initlog+0x71>
80102ef5:	c1 e3 02             	shl    $0x2,%ebx
80102ef8:	31 d2                	xor    %edx,%edx
80102efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102f00:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102f04:	83 c2 04             	add    $0x4,%edx
80102f07:	89 8a c8 36 11 80    	mov    %ecx,-0x7feec938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102f0d:	39 d3                	cmp    %edx,%ebx
80102f0f:	75 ef                	jne    80102f00 <initlog+0x60>
  brelse(buf);
80102f11:	83 ec 0c             	sub    $0xc,%esp
80102f14:	50                   	push   %eax
80102f15:	e8 c6 d2 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102f1a:	e8 81 fe ff ff       	call   80102da0 <install_trans>
  log.lh.n = 0;
80102f1f:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102f26:	00 00 00 
  write_head(); // clear the log
80102f29:	e8 12 ff ff ff       	call   80102e40 <write_head>
}
80102f2e:	83 c4 10             	add    $0x10,%esp
80102f31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f34:	c9                   	leave  
80102f35:	c3                   	ret    
80102f36:	8d 76 00             	lea    0x0(%esi),%esi
80102f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f46:	68 80 36 11 80       	push   $0x80113680
80102f4b:	e8 50 18 00 00       	call   801047a0 <acquire>
80102f50:	83 c4 10             	add    $0x10,%esp
80102f53:	eb 18                	jmp    80102f6d <begin_op+0x2d>
80102f55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f58:	83 ec 08             	sub    $0x8,%esp
80102f5b:	68 80 36 11 80       	push   $0x80113680
80102f60:	68 80 36 11 80       	push   $0x80113680
80102f65:	e8 b6 11 00 00       	call   80104120 <sleep>
80102f6a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f6d:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102f72:	85 c0                	test   %eax,%eax
80102f74:	75 e2                	jne    80102f58 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f76:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102f7b:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102f81:	83 c0 01             	add    $0x1,%eax
80102f84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f8a:	83 fa 1e             	cmp    $0x1e,%edx
80102f8d:	7f c9                	jg     80102f58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f8f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102f92:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102f97:	68 80 36 11 80       	push   $0x80113680
80102f9c:	e8 1f 19 00 00       	call   801048c0 <release>
      break;
    }
  }
}
80102fa1:	83 c4 10             	add    $0x10,%esp
80102fa4:	c9                   	leave  
80102fa5:	c3                   	ret    
80102fa6:	8d 76 00             	lea    0x0(%esi),%esi
80102fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fb0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	57                   	push   %edi
80102fb4:	56                   	push   %esi
80102fb5:	53                   	push   %ebx
80102fb6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102fb9:	68 80 36 11 80       	push   $0x80113680
80102fbe:	e8 dd 17 00 00       	call   801047a0 <acquire>
  log.outstanding -= 1;
80102fc3:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102fc8:	8b 35 c0 36 11 80    	mov    0x801136c0,%esi
80102fce:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102fd1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102fd4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102fd6:	89 1d bc 36 11 80    	mov    %ebx,0x801136bc
  if(log.committing)
80102fdc:	0f 85 1a 01 00 00    	jne    801030fc <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102fe2:	85 db                	test   %ebx,%ebx
80102fe4:	0f 85 ee 00 00 00    	jne    801030d8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102fea:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102fed:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102ff4:	00 00 00 
  release(&log.lock);
80102ff7:	68 80 36 11 80       	push   $0x80113680
80102ffc:	e8 bf 18 00 00       	call   801048c0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103001:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80103007:	83 c4 10             	add    $0x10,%esp
8010300a:	85 c9                	test   %ecx,%ecx
8010300c:	0f 8e 85 00 00 00    	jle    80103097 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103012:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80103017:	83 ec 08             	sub    $0x8,%esp
8010301a:	01 d8                	add    %ebx,%eax
8010301c:	83 c0 01             	add    $0x1,%eax
8010301f:	50                   	push   %eax
80103020:	ff 35 c4 36 11 80    	pushl  0x801136c4
80103026:	e8 a5 d0 ff ff       	call   801000d0 <bread>
8010302b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010302d:	58                   	pop    %eax
8010302e:	5a                   	pop    %edx
8010302f:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80103036:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
8010303c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010303f:	e8 8c d0 ff ff       	call   801000d0 <bread>
80103044:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103046:	8d 40 5c             	lea    0x5c(%eax),%eax
80103049:	83 c4 0c             	add    $0xc,%esp
8010304c:	68 00 02 00 00       	push   $0x200
80103051:	50                   	push   %eax
80103052:	8d 46 5c             	lea    0x5c(%esi),%eax
80103055:	50                   	push   %eax
80103056:	e8 75 19 00 00       	call   801049d0 <memmove>
    bwrite(to);  // write the log
8010305b:	89 34 24             	mov    %esi,(%esp)
8010305e:	e8 3d d1 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103063:	89 3c 24             	mov    %edi,(%esp)
80103066:	e8 75 d1 ff ff       	call   801001e0 <brelse>
    brelse(to);
8010306b:	89 34 24             	mov    %esi,(%esp)
8010306e:	e8 6d d1 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103073:	83 c4 10             	add    $0x10,%esp
80103076:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
8010307c:	7c 94                	jl     80103012 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010307e:	e8 bd fd ff ff       	call   80102e40 <write_head>
    install_trans(); // Now install writes to home locations
80103083:	e8 18 fd ff ff       	call   80102da0 <install_trans>
    log.lh.n = 0;
80103088:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
8010308f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103092:	e8 a9 fd ff ff       	call   80102e40 <write_head>
    acquire(&log.lock);
80103097:	83 ec 0c             	sub    $0xc,%esp
8010309a:	68 80 36 11 80       	push   $0x80113680
8010309f:	e8 fc 16 00 00       	call   801047a0 <acquire>
    wakeup(&log);
801030a4:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
801030ab:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
801030b2:	00 00 00 
    wakeup(&log);
801030b5:	e8 26 12 00 00       	call   801042e0 <wakeup>
    release(&log.lock);
801030ba:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
801030c1:	e8 fa 17 00 00       	call   801048c0 <release>
801030c6:	83 c4 10             	add    $0x10,%esp
}
801030c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030cc:	5b                   	pop    %ebx
801030cd:	5e                   	pop    %esi
801030ce:	5f                   	pop    %edi
801030cf:	5d                   	pop    %ebp
801030d0:	c3                   	ret    
801030d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
801030d8:	83 ec 0c             	sub    $0xc,%esp
801030db:	68 80 36 11 80       	push   $0x80113680
801030e0:	e8 fb 11 00 00       	call   801042e0 <wakeup>
  release(&log.lock);
801030e5:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
801030ec:	e8 cf 17 00 00       	call   801048c0 <release>
801030f1:	83 c4 10             	add    $0x10,%esp
}
801030f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030f7:	5b                   	pop    %ebx
801030f8:	5e                   	pop    %esi
801030f9:	5f                   	pop    %edi
801030fa:	5d                   	pop    %ebp
801030fb:	c3                   	ret    
    panic("log.committing");
801030fc:	83 ec 0c             	sub    $0xc,%esp
801030ff:	68 64 7a 10 80       	push   $0x80107a64
80103104:	e8 87 d2 ff ff       	call   80100390 <panic>
80103109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103110 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103110:	55                   	push   %ebp
80103111:	89 e5                	mov    %esp,%ebp
80103113:	53                   	push   %ebx
80103114:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103117:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
{
8010311d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103120:	83 fa 1d             	cmp    $0x1d,%edx
80103123:	0f 8f 9d 00 00 00    	jg     801031c6 <log_write+0xb6>
80103129:	a1 b8 36 11 80       	mov    0x801136b8,%eax
8010312e:	83 e8 01             	sub    $0x1,%eax
80103131:	39 c2                	cmp    %eax,%edx
80103133:	0f 8d 8d 00 00 00    	jge    801031c6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103139:	a1 bc 36 11 80       	mov    0x801136bc,%eax
8010313e:	85 c0                	test   %eax,%eax
80103140:	0f 8e 8d 00 00 00    	jle    801031d3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103146:	83 ec 0c             	sub    $0xc,%esp
80103149:	68 80 36 11 80       	push   $0x80113680
8010314e:	e8 4d 16 00 00       	call   801047a0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103153:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80103159:	83 c4 10             	add    $0x10,%esp
8010315c:	83 f9 00             	cmp    $0x0,%ecx
8010315f:	7e 57                	jle    801031b8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103161:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103164:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103166:	3b 15 cc 36 11 80    	cmp    0x801136cc,%edx
8010316c:	75 0b                	jne    80103179 <log_write+0x69>
8010316e:	eb 38                	jmp    801031a8 <log_write+0x98>
80103170:	39 14 85 cc 36 11 80 	cmp    %edx,-0x7feec934(,%eax,4)
80103177:	74 2f                	je     801031a8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103179:	83 c0 01             	add    $0x1,%eax
8010317c:	39 c1                	cmp    %eax,%ecx
8010317e:	75 f0                	jne    80103170 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103180:	89 14 85 cc 36 11 80 	mov    %edx,-0x7feec934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103187:	83 c0 01             	add    $0x1,%eax
8010318a:	a3 c8 36 11 80       	mov    %eax,0x801136c8
  b->flags |= B_DIRTY; // prevent eviction
8010318f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103192:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80103199:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010319c:	c9                   	leave  
  release(&log.lock);
8010319d:	e9 1e 17 00 00       	jmp    801048c0 <release>
801031a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801031a8:	89 14 85 cc 36 11 80 	mov    %edx,-0x7feec934(,%eax,4)
801031af:	eb de                	jmp    8010318f <log_write+0x7f>
801031b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031b8:	8b 43 08             	mov    0x8(%ebx),%eax
801031bb:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
801031c0:	75 cd                	jne    8010318f <log_write+0x7f>
801031c2:	31 c0                	xor    %eax,%eax
801031c4:	eb c1                	jmp    80103187 <log_write+0x77>
    panic("too big a transaction");
801031c6:	83 ec 0c             	sub    $0xc,%esp
801031c9:	68 73 7a 10 80       	push   $0x80107a73
801031ce:	e8 bd d1 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801031d3:	83 ec 0c             	sub    $0xc,%esp
801031d6:	68 89 7a 10 80       	push   $0x80107a89
801031db:	e8 b0 d1 ff ff       	call   80100390 <panic>

801031e0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	53                   	push   %ebx
801031e4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801031e7:	e8 74 09 00 00       	call   80103b60 <cpuid>
801031ec:	89 c3                	mov    %eax,%ebx
801031ee:	e8 6d 09 00 00       	call   80103b60 <cpuid>
801031f3:	83 ec 04             	sub    $0x4,%esp
801031f6:	53                   	push   %ebx
801031f7:	50                   	push   %eax
801031f8:	68 a4 7a 10 80       	push   $0x80107aa4
801031fd:	e8 5e d4 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103202:	e8 29 2a 00 00       	call   80105c30 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103207:	e8 d4 08 00 00       	call   80103ae0 <mycpu>
8010320c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010320e:	b8 01 00 00 00       	mov    $0x1,%eax
80103213:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010321a:	e8 21 0c 00 00       	call   80103e40 <scheduler>
8010321f:	90                   	nop

80103220 <mpenter>:
{
80103220:	55                   	push   %ebp
80103221:	89 e5                	mov    %esp,%ebp
80103223:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103226:	e8 e5 3a 00 00       	call   80106d10 <switchkvm>
  seginit();
8010322b:	e8 50 3a 00 00       	call   80106c80 <seginit>
  lapicinit();
80103230:	e8 9b f7 ff ff       	call   801029d0 <lapicinit>
  mpmain();
80103235:	e8 a6 ff ff ff       	call   801031e0 <mpmain>
8010323a:	66 90                	xchg   %ax,%ax
8010323c:	66 90                	xchg   %ax,%ax
8010323e:	66 90                	xchg   %ax,%ax

80103240 <main>:
{
80103240:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103244:	83 e4 f0             	and    $0xfffffff0,%esp
80103247:	ff 71 fc             	pushl  -0x4(%ecx)
8010324a:	55                   	push   %ebp
8010324b:	89 e5                	mov    %esp,%ebp
8010324d:	53                   	push   %ebx
8010324e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010324f:	83 ec 08             	sub    $0x8,%esp
80103252:	68 00 00 40 80       	push   $0x80400000
80103257:	68 a8 68 11 80       	push   $0x801168a8
8010325c:	e8 2f f5 ff ff       	call   80102790 <kinit1>
  kvmalloc();      // kernel page table
80103261:	e8 7a 3f 00 00       	call   801071e0 <kvmalloc>
  mpinit();        // detect other processors
80103266:	e8 75 01 00 00       	call   801033e0 <mpinit>
  lapicinit();     // interrupt controller
8010326b:	e8 60 f7 ff ff       	call   801029d0 <lapicinit>
  seginit();       // segment descriptors
80103270:	e8 0b 3a 00 00       	call   80106c80 <seginit>
  picinit();       // disable pic
80103275:	e8 46 03 00 00       	call   801035c0 <picinit>
  ioapicinit();    // another interrupt controller
8010327a:	e8 41 f3 ff ff       	call   801025c0 <ioapicinit>
  consoleinit();   // console hardware
8010327f:	e8 3c d7 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103284:	e8 c7 2c 00 00       	call   80105f50 <uartinit>
  pinit();         // process table
80103289:	e8 32 08 00 00       	call   80103ac0 <pinit>
  tvinit();        // trap vectors
8010328e:	e8 1d 29 00 00       	call   80105bb0 <tvinit>
  binit();         // buffer cache
80103293:	e8 a8 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103298:	e8 c3 da ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
8010329d:	e8 fe f0 ff ff       	call   801023a0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801032a2:	83 c4 0c             	add    $0xc,%esp
801032a5:	68 8a 00 00 00       	push   $0x8a
801032aa:	68 8c b4 10 80       	push   $0x8010b48c
801032af:	68 00 70 00 80       	push   $0x80007000
801032b4:	e8 17 17 00 00       	call   801049d0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801032b9:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801032c0:	00 00 00 
801032c3:	83 c4 10             	add    $0x10,%esp
801032c6:	05 80 37 11 80       	add    $0x80113780,%eax
801032cb:	3d 80 37 11 80       	cmp    $0x80113780,%eax
801032d0:	76 71                	jbe    80103343 <main+0x103>
801032d2:	bb 80 37 11 80       	mov    $0x80113780,%ebx
801032d7:	89 f6                	mov    %esi,%esi
801032d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
801032e0:	e8 fb 07 00 00       	call   80103ae0 <mycpu>
801032e5:	39 d8                	cmp    %ebx,%eax
801032e7:	74 41                	je     8010332a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801032e9:	e8 72 f5 ff ff       	call   80102860 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801032ee:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
801032f3:	c7 05 f8 6f 00 80 20 	movl   $0x80103220,0x80006ff8
801032fa:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801032fd:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103304:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103307:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010330c:	0f b6 03             	movzbl (%ebx),%eax
8010330f:	83 ec 08             	sub    $0x8,%esp
80103312:	68 00 70 00 00       	push   $0x7000
80103317:	50                   	push   %eax
80103318:	e8 03 f8 ff ff       	call   80102b20 <lapicstartap>
8010331d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103320:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103326:	85 c0                	test   %eax,%eax
80103328:	74 f6                	je     80103320 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010332a:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103331:	00 00 00 
80103334:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010333a:	05 80 37 11 80       	add    $0x80113780,%eax
8010333f:	39 c3                	cmp    %eax,%ebx
80103341:	72 9d                	jb     801032e0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103343:	83 ec 08             	sub    $0x8,%esp
80103346:	68 00 00 00 8e       	push   $0x8e000000
8010334b:	68 00 00 40 80       	push   $0x80400000
80103350:	e8 ab f4 ff ff       	call   80102800 <kinit2>
  userinit();      // first user process
80103355:	e8 56 08 00 00       	call   80103bb0 <userinit>
  mpmain();        // finish this processor's setup
8010335a:	e8 81 fe ff ff       	call   801031e0 <mpmain>
8010335f:	90                   	nop

80103360 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	57                   	push   %edi
80103364:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103365:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010336b:	53                   	push   %ebx
  e = addr+len;
8010336c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010336f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103372:	39 de                	cmp    %ebx,%esi
80103374:	72 10                	jb     80103386 <mpsearch1+0x26>
80103376:	eb 50                	jmp    801033c8 <mpsearch1+0x68>
80103378:	90                   	nop
80103379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103380:	39 fb                	cmp    %edi,%ebx
80103382:	89 fe                	mov    %edi,%esi
80103384:	76 42                	jbe    801033c8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103386:	83 ec 04             	sub    $0x4,%esp
80103389:	8d 7e 10             	lea    0x10(%esi),%edi
8010338c:	6a 04                	push   $0x4
8010338e:	68 b8 7a 10 80       	push   $0x80107ab8
80103393:	56                   	push   %esi
80103394:	e8 d7 15 00 00       	call   80104970 <memcmp>
80103399:	83 c4 10             	add    $0x10,%esp
8010339c:	85 c0                	test   %eax,%eax
8010339e:	75 e0                	jne    80103380 <mpsearch1+0x20>
801033a0:	89 f1                	mov    %esi,%ecx
801033a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801033a8:	0f b6 11             	movzbl (%ecx),%edx
801033ab:	83 c1 01             	add    $0x1,%ecx
801033ae:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801033b0:	39 f9                	cmp    %edi,%ecx
801033b2:	75 f4                	jne    801033a8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033b4:	84 c0                	test   %al,%al
801033b6:	75 c8                	jne    80103380 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801033b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033bb:	89 f0                	mov    %esi,%eax
801033bd:	5b                   	pop    %ebx
801033be:	5e                   	pop    %esi
801033bf:	5f                   	pop    %edi
801033c0:	5d                   	pop    %ebp
801033c1:	c3                   	ret    
801033c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801033c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033cb:	31 f6                	xor    %esi,%esi
}
801033cd:	89 f0                	mov    %esi,%eax
801033cf:	5b                   	pop    %ebx
801033d0:	5e                   	pop    %esi
801033d1:	5f                   	pop    %edi
801033d2:	5d                   	pop    %ebp
801033d3:	c3                   	ret    
801033d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801033da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801033e0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801033e0:	55                   	push   %ebp
801033e1:	89 e5                	mov    %esp,%ebp
801033e3:	57                   	push   %edi
801033e4:	56                   	push   %esi
801033e5:	53                   	push   %ebx
801033e6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801033e9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801033f0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801033f7:	c1 e0 08             	shl    $0x8,%eax
801033fa:	09 d0                	or     %edx,%eax
801033fc:	c1 e0 04             	shl    $0x4,%eax
801033ff:	85 c0                	test   %eax,%eax
80103401:	75 1b                	jne    8010341e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103403:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010340a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103411:	c1 e0 08             	shl    $0x8,%eax
80103414:	09 d0                	or     %edx,%eax
80103416:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103419:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010341e:	ba 00 04 00 00       	mov    $0x400,%edx
80103423:	e8 38 ff ff ff       	call   80103360 <mpsearch1>
80103428:	85 c0                	test   %eax,%eax
8010342a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010342d:	0f 84 3d 01 00 00    	je     80103570 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103433:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103436:	8b 58 04             	mov    0x4(%eax),%ebx
80103439:	85 db                	test   %ebx,%ebx
8010343b:	0f 84 4f 01 00 00    	je     80103590 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103441:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103447:	83 ec 04             	sub    $0x4,%esp
8010344a:	6a 04                	push   $0x4
8010344c:	68 d5 7a 10 80       	push   $0x80107ad5
80103451:	56                   	push   %esi
80103452:	e8 19 15 00 00       	call   80104970 <memcmp>
80103457:	83 c4 10             	add    $0x10,%esp
8010345a:	85 c0                	test   %eax,%eax
8010345c:	0f 85 2e 01 00 00    	jne    80103590 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103462:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103469:	3c 01                	cmp    $0x1,%al
8010346b:	0f 95 c2             	setne  %dl
8010346e:	3c 04                	cmp    $0x4,%al
80103470:	0f 95 c0             	setne  %al
80103473:	20 c2                	and    %al,%dl
80103475:	0f 85 15 01 00 00    	jne    80103590 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010347b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103482:	66 85 ff             	test   %di,%di
80103485:	74 1a                	je     801034a1 <mpinit+0xc1>
80103487:	89 f0                	mov    %esi,%eax
80103489:	01 f7                	add    %esi,%edi
  sum = 0;
8010348b:	31 d2                	xor    %edx,%edx
8010348d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103490:	0f b6 08             	movzbl (%eax),%ecx
80103493:	83 c0 01             	add    $0x1,%eax
80103496:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103498:	39 c7                	cmp    %eax,%edi
8010349a:	75 f4                	jne    80103490 <mpinit+0xb0>
8010349c:	84 d2                	test   %dl,%dl
8010349e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801034a1:	85 f6                	test   %esi,%esi
801034a3:	0f 84 e7 00 00 00    	je     80103590 <mpinit+0x1b0>
801034a9:	84 d2                	test   %dl,%dl
801034ab:	0f 85 df 00 00 00    	jne    80103590 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801034b1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801034b7:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034bc:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801034c3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801034c9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034ce:	01 d6                	add    %edx,%esi
801034d0:	39 c6                	cmp    %eax,%esi
801034d2:	76 23                	jbe    801034f7 <mpinit+0x117>
    switch(*p){
801034d4:	0f b6 10             	movzbl (%eax),%edx
801034d7:	80 fa 04             	cmp    $0x4,%dl
801034da:	0f 87 ca 00 00 00    	ja     801035aa <mpinit+0x1ca>
801034e0:	ff 24 95 fc 7a 10 80 	jmp    *-0x7fef8504(,%edx,4)
801034e7:	89 f6                	mov    %esi,%esi
801034e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801034f0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034f3:	39 c6                	cmp    %eax,%esi
801034f5:	77 dd                	ja     801034d4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801034f7:	85 db                	test   %ebx,%ebx
801034f9:	0f 84 9e 00 00 00    	je     8010359d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801034ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103502:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103506:	74 15                	je     8010351d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103508:	b8 70 00 00 00       	mov    $0x70,%eax
8010350d:	ba 22 00 00 00       	mov    $0x22,%edx
80103512:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103513:	ba 23 00 00 00       	mov    $0x23,%edx
80103518:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103519:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010351c:	ee                   	out    %al,(%dx)
  }
}
8010351d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103520:	5b                   	pop    %ebx
80103521:	5e                   	pop    %esi
80103522:	5f                   	pop    %edi
80103523:	5d                   	pop    %ebp
80103524:	c3                   	ret    
80103525:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103528:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
8010352e:	83 f9 07             	cmp    $0x7,%ecx
80103531:	7f 19                	jg     8010354c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103533:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103537:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010353d:	83 c1 01             	add    $0x1,%ecx
80103540:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103546:	88 97 80 37 11 80    	mov    %dl,-0x7feec880(%edi)
      p += sizeof(struct mpproc);
8010354c:	83 c0 14             	add    $0x14,%eax
      continue;
8010354f:	e9 7c ff ff ff       	jmp    801034d0 <mpinit+0xf0>
80103554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103558:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010355c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010355f:	88 15 60 37 11 80    	mov    %dl,0x80113760
      continue;
80103565:	e9 66 ff ff ff       	jmp    801034d0 <mpinit+0xf0>
8010356a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103570:	ba 00 00 01 00       	mov    $0x10000,%edx
80103575:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010357a:	e8 e1 fd ff ff       	call   80103360 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010357f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103581:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103584:	0f 85 a9 fe ff ff    	jne    80103433 <mpinit+0x53>
8010358a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	68 bd 7a 10 80       	push   $0x80107abd
80103598:	e8 f3 cd ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010359d:	83 ec 0c             	sub    $0xc,%esp
801035a0:	68 dc 7a 10 80       	push   $0x80107adc
801035a5:	e8 e6 cd ff ff       	call   80100390 <panic>
      ismp = 0;
801035aa:	31 db                	xor    %ebx,%ebx
801035ac:	e9 26 ff ff ff       	jmp    801034d7 <mpinit+0xf7>
801035b1:	66 90                	xchg   %ax,%ax
801035b3:	66 90                	xchg   %ax,%ax
801035b5:	66 90                	xchg   %ax,%ax
801035b7:	66 90                	xchg   %ax,%ax
801035b9:	66 90                	xchg   %ax,%ax
801035bb:	66 90                	xchg   %ax,%ax
801035bd:	66 90                	xchg   %ax,%ax
801035bf:	90                   	nop

801035c0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801035c0:	55                   	push   %ebp
801035c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035c6:	ba 21 00 00 00       	mov    $0x21,%edx
801035cb:	89 e5                	mov    %esp,%ebp
801035cd:	ee                   	out    %al,(%dx)
801035ce:	ba a1 00 00 00       	mov    $0xa1,%edx
801035d3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801035d4:	5d                   	pop    %ebp
801035d5:	c3                   	ret    
801035d6:	66 90                	xchg   %ax,%ax
801035d8:	66 90                	xchg   %ax,%ax
801035da:	66 90                	xchg   %ax,%ax
801035dc:	66 90                	xchg   %ax,%ax
801035de:	66 90                	xchg   %ax,%ax

801035e0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	57                   	push   %edi
801035e4:	56                   	push   %esi
801035e5:	53                   	push   %ebx
801035e6:	83 ec 0c             	sub    $0xc,%esp
801035e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801035ef:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801035f5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801035fb:	e8 80 d7 ff ff       	call   80100d80 <filealloc>
80103600:	85 c0                	test   %eax,%eax
80103602:	89 03                	mov    %eax,(%ebx)
80103604:	74 22                	je     80103628 <pipealloc+0x48>
80103606:	e8 75 d7 ff ff       	call   80100d80 <filealloc>
8010360b:	85 c0                	test   %eax,%eax
8010360d:	89 06                	mov    %eax,(%esi)
8010360f:	74 3f                	je     80103650 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103611:	e8 4a f2 ff ff       	call   80102860 <kalloc>
80103616:	85 c0                	test   %eax,%eax
80103618:	89 c7                	mov    %eax,%edi
8010361a:	75 54                	jne    80103670 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010361c:	8b 03                	mov    (%ebx),%eax
8010361e:	85 c0                	test   %eax,%eax
80103620:	75 34                	jne    80103656 <pipealloc+0x76>
80103622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103628:	8b 06                	mov    (%esi),%eax
8010362a:	85 c0                	test   %eax,%eax
8010362c:	74 0c                	je     8010363a <pipealloc+0x5a>
    fileclose(*f1);
8010362e:	83 ec 0c             	sub    $0xc,%esp
80103631:	50                   	push   %eax
80103632:	e8 09 d8 ff ff       	call   80100e40 <fileclose>
80103637:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010363a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010363d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103642:	5b                   	pop    %ebx
80103643:	5e                   	pop    %esi
80103644:	5f                   	pop    %edi
80103645:	5d                   	pop    %ebp
80103646:	c3                   	ret    
80103647:	89 f6                	mov    %esi,%esi
80103649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103650:	8b 03                	mov    (%ebx),%eax
80103652:	85 c0                	test   %eax,%eax
80103654:	74 e4                	je     8010363a <pipealloc+0x5a>
    fileclose(*f0);
80103656:	83 ec 0c             	sub    $0xc,%esp
80103659:	50                   	push   %eax
8010365a:	e8 e1 d7 ff ff       	call   80100e40 <fileclose>
  if(*f1)
8010365f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103661:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103664:	85 c0                	test   %eax,%eax
80103666:	75 c6                	jne    8010362e <pipealloc+0x4e>
80103668:	eb d0                	jmp    8010363a <pipealloc+0x5a>
8010366a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103670:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103673:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010367a:	00 00 00 
  p->writeopen = 1;
8010367d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103684:	00 00 00 
  p->nwrite = 0;
80103687:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010368e:	00 00 00 
  p->nread = 0;
80103691:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103698:	00 00 00 
  initlock(&p->lock, "pipe");
8010369b:	68 10 7b 10 80       	push   $0x80107b10
801036a0:	50                   	push   %eax
801036a1:	e8 0a 10 00 00       	call   801046b0 <initlock>
  (*f0)->type = FD_PIPE;
801036a6:	8b 03                	mov    (%ebx),%eax
  return 0;
801036a8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801036ab:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801036b1:	8b 03                	mov    (%ebx),%eax
801036b3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801036b7:	8b 03                	mov    (%ebx),%eax
801036b9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801036bd:	8b 03                	mov    (%ebx),%eax
801036bf:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801036c2:	8b 06                	mov    (%esi),%eax
801036c4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801036ca:	8b 06                	mov    (%esi),%eax
801036cc:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801036d0:	8b 06                	mov    (%esi),%eax
801036d2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801036d6:	8b 06                	mov    (%esi),%eax
801036d8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801036db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801036de:	31 c0                	xor    %eax,%eax
}
801036e0:	5b                   	pop    %ebx
801036e1:	5e                   	pop    %esi
801036e2:	5f                   	pop    %edi
801036e3:	5d                   	pop    %ebp
801036e4:	c3                   	ret    
801036e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036f0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	56                   	push   %esi
801036f4:	53                   	push   %ebx
801036f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801036fb:	83 ec 0c             	sub    $0xc,%esp
801036fe:	53                   	push   %ebx
801036ff:	e8 9c 10 00 00       	call   801047a0 <acquire>
  if(writable){
80103704:	83 c4 10             	add    $0x10,%esp
80103707:	85 f6                	test   %esi,%esi
80103709:	74 45                	je     80103750 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010370b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103711:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103714:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010371b:	00 00 00 
    wakeup(&p->nread);
8010371e:	50                   	push   %eax
8010371f:	e8 bc 0b 00 00       	call   801042e0 <wakeup>
80103724:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103727:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010372d:	85 d2                	test   %edx,%edx
8010372f:	75 0a                	jne    8010373b <pipeclose+0x4b>
80103731:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103737:	85 c0                	test   %eax,%eax
80103739:	74 35                	je     80103770 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010373b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010373e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103741:	5b                   	pop    %ebx
80103742:	5e                   	pop    %esi
80103743:	5d                   	pop    %ebp
    release(&p->lock);
80103744:	e9 77 11 00 00       	jmp    801048c0 <release>
80103749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103750:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103756:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103759:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103760:	00 00 00 
    wakeup(&p->nwrite);
80103763:	50                   	push   %eax
80103764:	e8 77 0b 00 00       	call   801042e0 <wakeup>
80103769:	83 c4 10             	add    $0x10,%esp
8010376c:	eb b9                	jmp    80103727 <pipeclose+0x37>
8010376e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103770:	83 ec 0c             	sub    $0xc,%esp
80103773:	53                   	push   %ebx
80103774:	e8 47 11 00 00       	call   801048c0 <release>
    kfree((char*)p);
80103779:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010377c:	83 c4 10             	add    $0x10,%esp
}
8010377f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103782:	5b                   	pop    %ebx
80103783:	5e                   	pop    %esi
80103784:	5d                   	pop    %ebp
    kfree((char*)p);
80103785:	e9 26 ef ff ff       	jmp    801026b0 <kfree>
8010378a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103790 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	57                   	push   %edi
80103794:	56                   	push   %esi
80103795:	53                   	push   %ebx
80103796:	83 ec 28             	sub    $0x28,%esp
80103799:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010379c:	53                   	push   %ebx
8010379d:	e8 fe 0f 00 00       	call   801047a0 <acquire>
  for(i = 0; i < n; i++){
801037a2:	8b 45 10             	mov    0x10(%ebp),%eax
801037a5:	83 c4 10             	add    $0x10,%esp
801037a8:	85 c0                	test   %eax,%eax
801037aa:	0f 8e c9 00 00 00    	jle    80103879 <pipewrite+0xe9>
801037b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801037b3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801037b9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801037bf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801037c2:	03 4d 10             	add    0x10(%ebp),%ecx
801037c5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037c8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801037ce:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801037d4:	39 d0                	cmp    %edx,%eax
801037d6:	75 71                	jne    80103849 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801037d8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801037de:	85 c0                	test   %eax,%eax
801037e0:	74 4e                	je     80103830 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037e2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801037e8:	eb 3a                	jmp    80103824 <pipewrite+0x94>
801037ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801037f0:	83 ec 0c             	sub    $0xc,%esp
801037f3:	57                   	push   %edi
801037f4:	e8 e7 0a 00 00       	call   801042e0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037f9:	5a                   	pop    %edx
801037fa:	59                   	pop    %ecx
801037fb:	53                   	push   %ebx
801037fc:	56                   	push   %esi
801037fd:	e8 1e 09 00 00       	call   80104120 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103802:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103808:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010380e:	83 c4 10             	add    $0x10,%esp
80103811:	05 00 02 00 00       	add    $0x200,%eax
80103816:	39 c2                	cmp    %eax,%edx
80103818:	75 36                	jne    80103850 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010381a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103820:	85 c0                	test   %eax,%eax
80103822:	74 0c                	je     80103830 <pipewrite+0xa0>
80103824:	e8 57 03 00 00       	call   80103b80 <myproc>
80103829:	8b 40 24             	mov    0x24(%eax),%eax
8010382c:	85 c0                	test   %eax,%eax
8010382e:	74 c0                	je     801037f0 <pipewrite+0x60>
        release(&p->lock);
80103830:	83 ec 0c             	sub    $0xc,%esp
80103833:	53                   	push   %ebx
80103834:	e8 87 10 00 00       	call   801048c0 <release>
        return -1;
80103839:	83 c4 10             	add    $0x10,%esp
8010383c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103841:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103844:	5b                   	pop    %ebx
80103845:	5e                   	pop    %esi
80103846:	5f                   	pop    %edi
80103847:	5d                   	pop    %ebp
80103848:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103849:	89 c2                	mov    %eax,%edx
8010384b:	90                   	nop
8010384c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103850:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103853:	8d 42 01             	lea    0x1(%edx),%eax
80103856:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010385c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103862:	83 c6 01             	add    $0x1,%esi
80103865:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103869:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010386c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010386f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103873:	0f 85 4f ff ff ff    	jne    801037c8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103879:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010387f:	83 ec 0c             	sub    $0xc,%esp
80103882:	50                   	push   %eax
80103883:	e8 58 0a 00 00       	call   801042e0 <wakeup>
  release(&p->lock);
80103888:	89 1c 24             	mov    %ebx,(%esp)
8010388b:	e8 30 10 00 00       	call   801048c0 <release>
  return n;
80103890:	83 c4 10             	add    $0x10,%esp
80103893:	8b 45 10             	mov    0x10(%ebp),%eax
80103896:	eb a9                	jmp    80103841 <pipewrite+0xb1>
80103898:	90                   	nop
80103899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038a0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	57                   	push   %edi
801038a4:	56                   	push   %esi
801038a5:	53                   	push   %ebx
801038a6:	83 ec 18             	sub    $0x18,%esp
801038a9:	8b 75 08             	mov    0x8(%ebp),%esi
801038ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801038af:	56                   	push   %esi
801038b0:	e8 eb 0e 00 00       	call   801047a0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038b5:	83 c4 10             	add    $0x10,%esp
801038b8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801038be:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801038c4:	75 6a                	jne    80103930 <piperead+0x90>
801038c6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801038cc:	85 db                	test   %ebx,%ebx
801038ce:	0f 84 c4 00 00 00    	je     80103998 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801038d4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801038da:	eb 2d                	jmp    80103909 <piperead+0x69>
801038dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038e0:	83 ec 08             	sub    $0x8,%esp
801038e3:	56                   	push   %esi
801038e4:	53                   	push   %ebx
801038e5:	e8 36 08 00 00       	call   80104120 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038ea:	83 c4 10             	add    $0x10,%esp
801038ed:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801038f3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801038f9:	75 35                	jne    80103930 <piperead+0x90>
801038fb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103901:	85 d2                	test   %edx,%edx
80103903:	0f 84 8f 00 00 00    	je     80103998 <piperead+0xf8>
    if(myproc()->killed){
80103909:	e8 72 02 00 00       	call   80103b80 <myproc>
8010390e:	8b 48 24             	mov    0x24(%eax),%ecx
80103911:	85 c9                	test   %ecx,%ecx
80103913:	74 cb                	je     801038e0 <piperead+0x40>
      release(&p->lock);
80103915:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103918:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010391d:	56                   	push   %esi
8010391e:	e8 9d 0f 00 00       	call   801048c0 <release>
      return -1;
80103923:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103926:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103929:	89 d8                	mov    %ebx,%eax
8010392b:	5b                   	pop    %ebx
8010392c:	5e                   	pop    %esi
8010392d:	5f                   	pop    %edi
8010392e:	5d                   	pop    %ebp
8010392f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103930:	8b 45 10             	mov    0x10(%ebp),%eax
80103933:	85 c0                	test   %eax,%eax
80103935:	7e 61                	jle    80103998 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103937:	31 db                	xor    %ebx,%ebx
80103939:	eb 13                	jmp    8010394e <piperead+0xae>
8010393b:	90                   	nop
8010393c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103940:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103946:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010394c:	74 1f                	je     8010396d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010394e:	8d 41 01             	lea    0x1(%ecx),%eax
80103951:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103957:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010395d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103962:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103965:	83 c3 01             	add    $0x1,%ebx
80103968:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010396b:	75 d3                	jne    80103940 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010396d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103973:	83 ec 0c             	sub    $0xc,%esp
80103976:	50                   	push   %eax
80103977:	e8 64 09 00 00       	call   801042e0 <wakeup>
  release(&p->lock);
8010397c:	89 34 24             	mov    %esi,(%esp)
8010397f:	e8 3c 0f 00 00       	call   801048c0 <release>
  return i;
80103984:	83 c4 10             	add    $0x10,%esp
}
80103987:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010398a:	89 d8                	mov    %ebx,%eax
8010398c:	5b                   	pop    %ebx
8010398d:	5e                   	pop    %esi
8010398e:	5f                   	pop    %edi
8010398f:	5d                   	pop    %ebp
80103990:	c3                   	ret    
80103991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103998:	31 db                	xor    %ebx,%ebx
8010399a:	eb d1                	jmp    8010396d <piperead+0xcd>
8010399c:	66 90                	xchg   %ax,%ax
8010399e:	66 90                	xchg   %ax,%ax

801039a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039a4:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
801039a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801039ac:	68 20 3d 11 80       	push   $0x80113d20
801039b1:	e8 ea 0d 00 00       	call   801047a0 <acquire>
801039b6:	83 c4 10             	add    $0x10,%esp
801039b9:	eb 13                	jmp    801039ce <allocproc+0x2e>
801039bb:	90                   	nop
801039bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039c0:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801039c6:	81 fb 54 60 11 80    	cmp    $0x80116054,%ebx
801039cc:	73 7a                	jae    80103a48 <allocproc+0xa8>
    if(p->state == UNUSED)
801039ce:	8b 43 0c             	mov    0xc(%ebx),%eax
801039d1:	85 c0                	test   %eax,%eax
801039d3:	75 eb                	jne    801039c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039d5:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801039da:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801039dd:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801039e4:	8d 50 01             	lea    0x1(%eax),%edx
801039e7:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801039ea:	68 20 3d 11 80       	push   $0x80113d20
  p->pid = nextpid++;
801039ef:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801039f5:	e8 c6 0e 00 00       	call   801048c0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801039fa:	e8 61 ee ff ff       	call   80102860 <kalloc>
801039ff:	83 c4 10             	add    $0x10,%esp
80103a02:	85 c0                	test   %eax,%eax
80103a04:	89 43 08             	mov    %eax,0x8(%ebx)
80103a07:	74 58                	je     80103a61 <allocproc+0xc1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103a09:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103a0f:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103a12:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103a17:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103a1a:	c7 40 14 9f 5b 10 80 	movl   $0x80105b9f,0x14(%eax)
  p->context = (struct context*)sp;
80103a21:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a24:	6a 14                	push   $0x14
80103a26:	6a 00                	push   $0x0
80103a28:	50                   	push   %eax
80103a29:	e8 f2 0e 00 00       	call   80104920 <memset>
  p->context->eip = (uint)forkret;
80103a2e:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103a31:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103a34:	c7 40 10 70 3a 10 80 	movl   $0x80103a70,0x10(%eax)
}
80103a3b:	89 d8                	mov    %ebx,%eax
80103a3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a40:	c9                   	leave  
80103a41:	c3                   	ret    
80103a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103a48:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a4b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a4d:	68 20 3d 11 80       	push   $0x80113d20
80103a52:	e8 69 0e 00 00       	call   801048c0 <release>
}
80103a57:	89 d8                	mov    %ebx,%eax
  return 0;
80103a59:	83 c4 10             	add    $0x10,%esp
}
80103a5c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a5f:	c9                   	leave  
80103a60:	c3                   	ret    
    p->state = UNUSED;
80103a61:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103a68:	31 db                	xor    %ebx,%ebx
80103a6a:	eb cf                	jmp    80103a3b <allocproc+0x9b>
80103a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a70 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a76:	68 20 3d 11 80       	push   $0x80113d20
80103a7b:	e8 40 0e 00 00       	call   801048c0 <release>

  if (first) {
80103a80:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103a85:	83 c4 10             	add    $0x10,%esp
80103a88:	85 c0                	test   %eax,%eax
80103a8a:	75 04                	jne    80103a90 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a8c:	c9                   	leave  
80103a8d:	c3                   	ret    
80103a8e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103a90:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103a93:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103a9a:	00 00 00 
    iinit(ROOTDEV);
80103a9d:	6a 01                	push   $0x1
80103a9f:	e8 ec d9 ff ff       	call   80101490 <iinit>
    initlog(ROOTDEV);
80103aa4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103aab:	e8 f0 f3 ff ff       	call   80102ea0 <initlog>
80103ab0:	83 c4 10             	add    $0x10,%esp
}
80103ab3:	c9                   	leave  
80103ab4:	c3                   	ret    
80103ab5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ac0 <pinit>:
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103ac6:	68 15 7b 10 80       	push   $0x80107b15
80103acb:	68 20 3d 11 80       	push   $0x80113d20
80103ad0:	e8 db 0b 00 00       	call   801046b0 <initlock>
}
80103ad5:	83 c4 10             	add    $0x10,%esp
80103ad8:	c9                   	leave  
80103ad9:	c3                   	ret    
80103ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ae0 <mycpu>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	56                   	push   %esi
80103ae4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ae5:	9c                   	pushf  
80103ae6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ae7:	f6 c4 02             	test   $0x2,%ah
80103aea:	75 5e                	jne    80103b4a <mycpu+0x6a>
  apicid = lapicid();
80103aec:	e8 df ef ff ff       	call   80102ad0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103af1:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
80103af7:	85 f6                	test   %esi,%esi
80103af9:	7e 42                	jle    80103b3d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103afb:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
80103b02:	39 d0                	cmp    %edx,%eax
80103b04:	74 30                	je     80103b36 <mycpu+0x56>
80103b06:	b9 30 38 11 80       	mov    $0x80113830,%ecx
  for (i = 0; i < ncpu; ++i) {
80103b0b:	31 d2                	xor    %edx,%edx
80103b0d:	8d 76 00             	lea    0x0(%esi),%esi
80103b10:	83 c2 01             	add    $0x1,%edx
80103b13:	39 f2                	cmp    %esi,%edx
80103b15:	74 26                	je     80103b3d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103b17:	0f b6 19             	movzbl (%ecx),%ebx
80103b1a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103b20:	39 c3                	cmp    %eax,%ebx
80103b22:	75 ec                	jne    80103b10 <mycpu+0x30>
80103b24:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103b2a:	05 80 37 11 80       	add    $0x80113780,%eax
}
80103b2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b32:	5b                   	pop    %ebx
80103b33:	5e                   	pop    %esi
80103b34:	5d                   	pop    %ebp
80103b35:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103b36:	b8 80 37 11 80       	mov    $0x80113780,%eax
      return &cpus[i];
80103b3b:	eb f2                	jmp    80103b2f <mycpu+0x4f>
  panic("unknown apicid\n");
80103b3d:	83 ec 0c             	sub    $0xc,%esp
80103b40:	68 1c 7b 10 80       	push   $0x80107b1c
80103b45:	e8 46 c8 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b4a:	83 ec 0c             	sub    $0xc,%esp
80103b4d:	68 34 7c 10 80       	push   $0x80107c34
80103b52:	e8 39 c8 ff ff       	call   80100390 <panic>
80103b57:	89 f6                	mov    %esi,%esi
80103b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b60 <cpuid>:
cpuid() {
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b66:	e8 75 ff ff ff       	call   80103ae0 <mycpu>
80103b6b:	2d 80 37 11 80       	sub    $0x80113780,%eax
}
80103b70:	c9                   	leave  
  return mycpu()-cpus;
80103b71:	c1 f8 04             	sar    $0x4,%eax
80103b74:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b7a:	c3                   	ret    
80103b7b:	90                   	nop
80103b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b80 <myproc>:
myproc(void) {
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	53                   	push   %ebx
80103b84:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b87:	e8 d4 0b 00 00       	call   80104760 <pushcli>
  c = mycpu();
80103b8c:	e8 4f ff ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80103b91:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b97:	e8 c4 0c 00 00       	call   80104860 <popcli>
}
80103b9c:	83 c4 04             	add    $0x4,%esp
80103b9f:	89 d8                	mov    %ebx,%eax
80103ba1:	5b                   	pop    %ebx
80103ba2:	5d                   	pop    %ebp
80103ba3:	c3                   	ret    
80103ba4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103baa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103bb0 <userinit>:
{
80103bb0:	55                   	push   %ebp
80103bb1:	89 e5                	mov    %esp,%ebp
80103bb3:	53                   	push   %ebx
80103bb4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103bb7:	e8 e4 fd ff ff       	call   801039a0 <allocproc>
80103bbc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103bbe:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103bc3:	e8 98 35 00 00       	call   80107160 <setupkvm>
80103bc8:	85 c0                	test   %eax,%eax
80103bca:	89 43 04             	mov    %eax,0x4(%ebx)
80103bcd:	0f 84 bd 00 00 00    	je     80103c90 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103bd3:	83 ec 04             	sub    $0x4,%esp
80103bd6:	68 2c 00 00 00       	push   $0x2c
80103bdb:	68 60 b4 10 80       	push   $0x8010b460
80103be0:	50                   	push   %eax
80103be1:	e8 5a 32 00 00       	call   80106e40 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103be6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103be9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103bef:	6a 4c                	push   $0x4c
80103bf1:	6a 00                	push   $0x0
80103bf3:	ff 73 18             	pushl  0x18(%ebx)
80103bf6:	e8 25 0d 00 00       	call   80104920 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bfb:	8b 43 18             	mov    0x18(%ebx),%eax
80103bfe:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c03:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c08:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c0b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c0f:	8b 43 18             	mov    0x18(%ebx),%eax
80103c12:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c16:	8b 43 18             	mov    0x18(%ebx),%eax
80103c19:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c1d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c21:	8b 43 18             	mov    0x18(%ebx),%eax
80103c24:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c28:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c2c:	8b 43 18             	mov    0x18(%ebx),%eax
80103c2f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c36:	8b 43 18             	mov    0x18(%ebx),%eax
80103c39:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c40:	8b 43 18             	mov    0x18(%ebx),%eax
80103c43:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c4a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c4d:	6a 10                	push   $0x10
80103c4f:	68 45 7b 10 80       	push   $0x80107b45
80103c54:	50                   	push   %eax
80103c55:	e8 a6 0e 00 00       	call   80104b00 <safestrcpy>
  p->cwd = namei("/");
80103c5a:	c7 04 24 4e 7b 10 80 	movl   $0x80107b4e,(%esp)
80103c61:	e8 8a e2 ff ff       	call   80101ef0 <namei>
80103c66:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103c69:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c70:	e8 2b 0b 00 00       	call   801047a0 <acquire>
  p->state = RUNNABLE;
80103c75:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103c7c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c83:	e8 38 0c 00 00       	call   801048c0 <release>
}
80103c88:	83 c4 10             	add    $0x10,%esp
80103c8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c8e:	c9                   	leave  
80103c8f:	c3                   	ret    
    panic("userinit: out of memory?");
80103c90:	83 ec 0c             	sub    $0xc,%esp
80103c93:	68 2c 7b 10 80       	push   $0x80107b2c
80103c98:	e8 f3 c6 ff ff       	call   80100390 <panic>
80103c9d:	8d 76 00             	lea    0x0(%esi),%esi

80103ca0 <growproc>:
{
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	56                   	push   %esi
80103ca4:	53                   	push   %ebx
80103ca5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ca8:	e8 b3 0a 00 00       	call   80104760 <pushcli>
  c = mycpu();
80103cad:	e8 2e fe ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80103cb2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cb8:	e8 a3 0b 00 00       	call   80104860 <popcli>
  if(n > 0){
80103cbd:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103cc0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103cc2:	7f 1c                	jg     80103ce0 <growproc+0x40>
  } else if(n < 0){
80103cc4:	75 3a                	jne    80103d00 <growproc+0x60>
  switchuvm(curproc);
80103cc6:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103cc9:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103ccb:	53                   	push   %ebx
80103ccc:	e8 5f 30 00 00       	call   80106d30 <switchuvm>
  return 0;
80103cd1:	83 c4 10             	add    $0x10,%esp
80103cd4:	31 c0                	xor    %eax,%eax
}
80103cd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cd9:	5b                   	pop    %ebx
80103cda:	5e                   	pop    %esi
80103cdb:	5d                   	pop    %ebp
80103cdc:	c3                   	ret    
80103cdd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ce0:	83 ec 04             	sub    $0x4,%esp
80103ce3:	01 c6                	add    %eax,%esi
80103ce5:	56                   	push   %esi
80103ce6:	50                   	push   %eax
80103ce7:	ff 73 04             	pushl  0x4(%ebx)
80103cea:	e8 91 32 00 00       	call   80106f80 <allocuvm>
80103cef:	83 c4 10             	add    $0x10,%esp
80103cf2:	85 c0                	test   %eax,%eax
80103cf4:	75 d0                	jne    80103cc6 <growproc+0x26>
      return -1;
80103cf6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cfb:	eb d9                	jmp    80103cd6 <growproc+0x36>
80103cfd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d00:	83 ec 04             	sub    $0x4,%esp
80103d03:	01 c6                	add    %eax,%esi
80103d05:	56                   	push   %esi
80103d06:	50                   	push   %eax
80103d07:	ff 73 04             	pushl  0x4(%ebx)
80103d0a:	e8 a1 33 00 00       	call   801070b0 <deallocuvm>
80103d0f:	83 c4 10             	add    $0x10,%esp
80103d12:	85 c0                	test   %eax,%eax
80103d14:	75 b0                	jne    80103cc6 <growproc+0x26>
80103d16:	eb de                	jmp    80103cf6 <growproc+0x56>
80103d18:	90                   	nop
80103d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d20 <fork>:
{
80103d20:	55                   	push   %ebp
80103d21:	89 e5                	mov    %esp,%ebp
80103d23:	57                   	push   %edi
80103d24:	56                   	push   %esi
80103d25:	53                   	push   %ebx
80103d26:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103d29:	e8 32 0a 00 00       	call   80104760 <pushcli>
  c = mycpu();
80103d2e:	e8 ad fd ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80103d33:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d39:	e8 22 0b 00 00       	call   80104860 <popcli>
  if((np = allocproc()) == 0){
80103d3e:	e8 5d fc ff ff       	call   801039a0 <allocproc>
80103d43:	85 c0                	test   %eax,%eax
80103d45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d48:	0f 84 b7 00 00 00    	je     80103e05 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d4e:	83 ec 08             	sub    $0x8,%esp
80103d51:	ff 33                	pushl  (%ebx)
80103d53:	ff 73 04             	pushl  0x4(%ebx)
80103d56:	89 c7                	mov    %eax,%edi
80103d58:	e8 d3 34 00 00       	call   80107230 <copyuvm>
80103d5d:	83 c4 10             	add    $0x10,%esp
80103d60:	85 c0                	test   %eax,%eax
80103d62:	89 47 04             	mov    %eax,0x4(%edi)
80103d65:	0f 84 a1 00 00 00    	je     80103e0c <fork+0xec>
  np->sz = curproc->sz;
80103d6b:	8b 03                	mov    (%ebx),%eax
80103d6d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d70:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103d72:	89 59 14             	mov    %ebx,0x14(%ecx)
80103d75:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103d77:	8b 79 18             	mov    0x18(%ecx),%edi
80103d7a:	8b 73 18             	mov    0x18(%ebx),%esi
80103d7d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d82:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103d84:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103d86:	8b 40 18             	mov    0x18(%eax),%eax
80103d89:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103d90:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103d94:	85 c0                	test   %eax,%eax
80103d96:	74 13                	je     80103dab <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d98:	83 ec 0c             	sub    $0xc,%esp
80103d9b:	50                   	push   %eax
80103d9c:	e8 4f d0 ff ff       	call   80100df0 <filedup>
80103da1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103da4:	83 c4 10             	add    $0x10,%esp
80103da7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103dab:	83 c6 01             	add    $0x1,%esi
80103dae:	83 fe 10             	cmp    $0x10,%esi
80103db1:	75 dd                	jne    80103d90 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103db3:	83 ec 0c             	sub    $0xc,%esp
80103db6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103db9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103dbc:	e8 9f d8 ff ff       	call   80101660 <idup>
80103dc1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dc4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103dc7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dca:	8d 47 6c             	lea    0x6c(%edi),%eax
80103dcd:	6a 10                	push   $0x10
80103dcf:	53                   	push   %ebx
80103dd0:	50                   	push   %eax
80103dd1:	e8 2a 0d 00 00       	call   80104b00 <safestrcpy>
  pid = np->pid;
80103dd6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103dd9:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103de0:	e8 bb 09 00 00       	call   801047a0 <acquire>
  np->state = RUNNABLE;
80103de5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103dec:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103df3:	e8 c8 0a 00 00       	call   801048c0 <release>
  return pid;
80103df8:	83 c4 10             	add    $0x10,%esp
}
80103dfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dfe:	89 d8                	mov    %ebx,%eax
80103e00:	5b                   	pop    %ebx
80103e01:	5e                   	pop    %esi
80103e02:	5f                   	pop    %edi
80103e03:	5d                   	pop    %ebp
80103e04:	c3                   	ret    
    return -1;
80103e05:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e0a:	eb ef                	jmp    80103dfb <fork+0xdb>
    kfree(np->kstack);
80103e0c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103e0f:	83 ec 0c             	sub    $0xc,%esp
80103e12:	ff 73 08             	pushl  0x8(%ebx)
80103e15:	e8 96 e8 ff ff       	call   801026b0 <kfree>
    np->kstack = 0;
80103e1a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103e21:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103e28:	83 c4 10             	add    $0x10,%esp
80103e2b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e30:	eb c9                	jmp    80103dfb <fork+0xdb>
80103e32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e40 <scheduler>:
{
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	57                   	push   %edi
80103e44:	56                   	push   %esi
80103e45:	53                   	push   %ebx
80103e46:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103e49:	e8 92 fc ff ff       	call   80103ae0 <mycpu>
80103e4e:	8d 78 04             	lea    0x4(%eax),%edi
80103e51:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e53:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e5a:	00 00 00 
80103e5d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103e60:	fb                   	sti    
    acquire(&ptable.lock);
80103e61:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e64:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
    acquire(&ptable.lock);
80103e69:	68 20 3d 11 80       	push   $0x80113d20
80103e6e:	e8 2d 09 00 00       	call   801047a0 <acquire>
80103e73:	83 c4 10             	add    $0x10,%esp
80103e76:	8d 76 00             	lea    0x0(%esi),%esi
80103e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103e80:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103e84:	75 33                	jne    80103eb9 <scheduler+0x79>
      switchuvm(p);
80103e86:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103e89:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103e8f:	53                   	push   %ebx
80103e90:	e8 9b 2e 00 00       	call   80106d30 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103e95:	58                   	pop    %eax
80103e96:	5a                   	pop    %edx
80103e97:	ff 73 1c             	pushl  0x1c(%ebx)
80103e9a:	57                   	push   %edi
      p->state = RUNNING;
80103e9b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103ea2:	e8 b4 0c 00 00       	call   80104b5b <swtch>
      switchkvm();
80103ea7:	e8 64 2e 00 00       	call   80106d10 <switchkvm>
      c->proc = 0;
80103eac:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103eb3:	00 00 00 
80103eb6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eb9:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103ebf:	81 fb 54 60 11 80    	cmp    $0x80116054,%ebx
80103ec5:	72 b9                	jb     80103e80 <scheduler+0x40>
    release(&ptable.lock);
80103ec7:	83 ec 0c             	sub    $0xc,%esp
80103eca:	68 20 3d 11 80       	push   $0x80113d20
80103ecf:	e8 ec 09 00 00       	call   801048c0 <release>
    sti();
80103ed4:	83 c4 10             	add    $0x10,%esp
80103ed7:	eb 87                	jmp    80103e60 <scheduler+0x20>
80103ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ee0 <sched>:
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	56                   	push   %esi
80103ee4:	53                   	push   %ebx
  pushcli();
80103ee5:	e8 76 08 00 00       	call   80104760 <pushcli>
  c = mycpu();
80103eea:	e8 f1 fb ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80103eef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ef5:	e8 66 09 00 00       	call   80104860 <popcli>
  if(!holding(&ptable.lock))
80103efa:	83 ec 0c             	sub    $0xc,%esp
80103efd:	68 20 3d 11 80       	push   $0x80113d20
80103f02:	e8 19 08 00 00       	call   80104720 <holding>
80103f07:	83 c4 10             	add    $0x10,%esp
80103f0a:	85 c0                	test   %eax,%eax
80103f0c:	74 4f                	je     80103f5d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103f0e:	e8 cd fb ff ff       	call   80103ae0 <mycpu>
80103f13:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f1a:	75 68                	jne    80103f84 <sched+0xa4>
  if(p->state == RUNNING)
80103f1c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103f20:	74 55                	je     80103f77 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f22:	9c                   	pushf  
80103f23:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f24:	f6 c4 02             	test   $0x2,%ah
80103f27:	75 41                	jne    80103f6a <sched+0x8a>
  intena = mycpu()->intena;
80103f29:	e8 b2 fb ff ff       	call   80103ae0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f2e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103f31:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f37:	e8 a4 fb ff ff       	call   80103ae0 <mycpu>
80103f3c:	83 ec 08             	sub    $0x8,%esp
80103f3f:	ff 70 04             	pushl  0x4(%eax)
80103f42:	53                   	push   %ebx
80103f43:	e8 13 0c 00 00       	call   80104b5b <swtch>
  mycpu()->intena = intena;
80103f48:	e8 93 fb ff ff       	call   80103ae0 <mycpu>
}
80103f4d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f50:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f56:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f59:	5b                   	pop    %ebx
80103f5a:	5e                   	pop    %esi
80103f5b:	5d                   	pop    %ebp
80103f5c:	c3                   	ret    
    panic("sched ptable.lock");
80103f5d:	83 ec 0c             	sub    $0xc,%esp
80103f60:	68 50 7b 10 80       	push   $0x80107b50
80103f65:	e8 26 c4 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103f6a:	83 ec 0c             	sub    $0xc,%esp
80103f6d:	68 7c 7b 10 80       	push   $0x80107b7c
80103f72:	e8 19 c4 ff ff       	call   80100390 <panic>
    panic("sched running");
80103f77:	83 ec 0c             	sub    $0xc,%esp
80103f7a:	68 6e 7b 10 80       	push   $0x80107b6e
80103f7f:	e8 0c c4 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103f84:	83 ec 0c             	sub    $0xc,%esp
80103f87:	68 62 7b 10 80       	push   $0x80107b62
80103f8c:	e8 ff c3 ff ff       	call   80100390 <panic>
80103f91:	eb 0d                	jmp    80103fa0 <exit>
80103f93:	90                   	nop
80103f94:	90                   	nop
80103f95:	90                   	nop
80103f96:	90                   	nop
80103f97:	90                   	nop
80103f98:	90                   	nop
80103f99:	90                   	nop
80103f9a:	90                   	nop
80103f9b:	90                   	nop
80103f9c:	90                   	nop
80103f9d:	90                   	nop
80103f9e:	90                   	nop
80103f9f:	90                   	nop

80103fa0 <exit>:
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	57                   	push   %edi
80103fa4:	56                   	push   %esi
80103fa5:	53                   	push   %ebx
80103fa6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103fa9:	e8 b2 07 00 00       	call   80104760 <pushcli>
  c = mycpu();
80103fae:	e8 2d fb ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80103fb3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103fb9:	e8 a2 08 00 00       	call   80104860 <popcli>
  if(curproc == initproc)
80103fbe:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80103fc4:	8d 5e 28             	lea    0x28(%esi),%ebx
80103fc7:	8d 7e 68             	lea    0x68(%esi),%edi
80103fca:	0f 84 f1 00 00 00    	je     801040c1 <exit+0x121>
    if(curproc->ofile[fd]){
80103fd0:	8b 03                	mov    (%ebx),%eax
80103fd2:	85 c0                	test   %eax,%eax
80103fd4:	74 12                	je     80103fe8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103fd6:	83 ec 0c             	sub    $0xc,%esp
80103fd9:	50                   	push   %eax
80103fda:	e8 61 ce ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
80103fdf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103fe5:	83 c4 10             	add    $0x10,%esp
80103fe8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103feb:	39 fb                	cmp    %edi,%ebx
80103fed:	75 e1                	jne    80103fd0 <exit+0x30>
  begin_op();
80103fef:	e8 4c ef ff ff       	call   80102f40 <begin_op>
  iput(curproc->cwd);
80103ff4:	83 ec 0c             	sub    $0xc,%esp
80103ff7:	ff 76 68             	pushl  0x68(%esi)
80103ffa:	e8 c1 d7 ff ff       	call   801017c0 <iput>
  end_op();
80103fff:	e8 ac ef ff ff       	call   80102fb0 <end_op>
  curproc->cwd = 0;
80104004:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
8010400b:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104012:	e8 89 07 00 00       	call   801047a0 <acquire>
  wakeup1(curproc->parent);
80104017:	8b 56 14             	mov    0x14(%esi),%edx
8010401a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010401d:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104022:	eb 10                	jmp    80104034 <exit+0x94>
80104024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104028:	05 8c 00 00 00       	add    $0x8c,%eax
8010402d:	3d 54 60 11 80       	cmp    $0x80116054,%eax
80104032:	73 1e                	jae    80104052 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80104034:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104038:	75 ee                	jne    80104028 <exit+0x88>
8010403a:	3b 50 20             	cmp    0x20(%eax),%edx
8010403d:	75 e9                	jne    80104028 <exit+0x88>
      p->state = RUNNABLE;
8010403f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104046:	05 8c 00 00 00       	add    $0x8c,%eax
8010404b:	3d 54 60 11 80       	cmp    $0x80116054,%eax
80104050:	72 e2                	jb     80104034 <exit+0x94>
      p->parent = initproc;
80104052:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104058:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
8010405d:	eb 0f                	jmp    8010406e <exit+0xce>
8010405f:	90                   	nop
80104060:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80104066:	81 fa 54 60 11 80    	cmp    $0x80116054,%edx
8010406c:	73 3a                	jae    801040a8 <exit+0x108>
    if(p->parent == curproc){
8010406e:	39 72 14             	cmp    %esi,0x14(%edx)
80104071:	75 ed                	jne    80104060 <exit+0xc0>
      if(p->state == ZOMBIE)
80104073:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104077:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010407a:	75 e4                	jne    80104060 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010407c:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104081:	eb 11                	jmp    80104094 <exit+0xf4>
80104083:	90                   	nop
80104084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104088:	05 8c 00 00 00       	add    $0x8c,%eax
8010408d:	3d 54 60 11 80       	cmp    $0x80116054,%eax
80104092:	73 cc                	jae    80104060 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80104094:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104098:	75 ee                	jne    80104088 <exit+0xe8>
8010409a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010409d:	75 e9                	jne    80104088 <exit+0xe8>
      p->state = RUNNABLE;
8010409f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801040a6:	eb e0                	jmp    80104088 <exit+0xe8>
  curproc->state = ZOMBIE;
801040a8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801040af:	e8 2c fe ff ff       	call   80103ee0 <sched>
  panic("zombie exit");
801040b4:	83 ec 0c             	sub    $0xc,%esp
801040b7:	68 9d 7b 10 80       	push   $0x80107b9d
801040bc:	e8 cf c2 ff ff       	call   80100390 <panic>
    panic("init exiting");
801040c1:	83 ec 0c             	sub    $0xc,%esp
801040c4:	68 90 7b 10 80       	push   $0x80107b90
801040c9:	e8 c2 c2 ff ff       	call   80100390 <panic>
801040ce:	66 90                	xchg   %ax,%ax

801040d0 <yield>:
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	53                   	push   %ebx
801040d4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801040d7:	68 20 3d 11 80       	push   $0x80113d20
801040dc:	e8 bf 06 00 00       	call   801047a0 <acquire>
  pushcli();
801040e1:	e8 7a 06 00 00       	call   80104760 <pushcli>
  c = mycpu();
801040e6:	e8 f5 f9 ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
801040eb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040f1:	e8 6a 07 00 00       	call   80104860 <popcli>
  myproc()->state = RUNNABLE;
801040f6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801040fd:	e8 de fd ff ff       	call   80103ee0 <sched>
  release(&ptable.lock);
80104102:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104109:	e8 b2 07 00 00       	call   801048c0 <release>
}
8010410e:	83 c4 10             	add    $0x10,%esp
80104111:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104114:	c9                   	leave  
80104115:	c3                   	ret    
80104116:	8d 76 00             	lea    0x0(%esi),%esi
80104119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104120 <sleep>:
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	57                   	push   %edi
80104124:	56                   	push   %esi
80104125:	53                   	push   %ebx
80104126:	83 ec 0c             	sub    $0xc,%esp
80104129:	8b 7d 08             	mov    0x8(%ebp),%edi
8010412c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010412f:	e8 2c 06 00 00       	call   80104760 <pushcli>
  c = mycpu();
80104134:	e8 a7 f9 ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80104139:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010413f:	e8 1c 07 00 00       	call   80104860 <popcli>
  if(p == 0)
80104144:	85 db                	test   %ebx,%ebx
80104146:	0f 84 87 00 00 00    	je     801041d3 <sleep+0xb3>
  if(lk == 0)
8010414c:	85 f6                	test   %esi,%esi
8010414e:	74 76                	je     801041c6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104150:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
80104156:	74 50                	je     801041a8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104158:	83 ec 0c             	sub    $0xc,%esp
8010415b:	68 20 3d 11 80       	push   $0x80113d20
80104160:	e8 3b 06 00 00       	call   801047a0 <acquire>
    release(lk);
80104165:	89 34 24             	mov    %esi,(%esp)
80104168:	e8 53 07 00 00       	call   801048c0 <release>
  p->chan = chan;
8010416d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104170:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104177:	e8 64 fd ff ff       	call   80103ee0 <sched>
  p->chan = 0;
8010417c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104183:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010418a:	e8 31 07 00 00       	call   801048c0 <release>
    acquire(lk);
8010418f:	89 75 08             	mov    %esi,0x8(%ebp)
80104192:	83 c4 10             	add    $0x10,%esp
}
80104195:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104198:	5b                   	pop    %ebx
80104199:	5e                   	pop    %esi
8010419a:	5f                   	pop    %edi
8010419b:	5d                   	pop    %ebp
    acquire(lk);
8010419c:	e9 ff 05 00 00       	jmp    801047a0 <acquire>
801041a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801041a8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041ab:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041b2:	e8 29 fd ff ff       	call   80103ee0 <sched>
  p->chan = 0;
801041b7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801041be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041c1:	5b                   	pop    %ebx
801041c2:	5e                   	pop    %esi
801041c3:	5f                   	pop    %edi
801041c4:	5d                   	pop    %ebp
801041c5:	c3                   	ret    
    panic("sleep without lk");
801041c6:	83 ec 0c             	sub    $0xc,%esp
801041c9:	68 af 7b 10 80       	push   $0x80107baf
801041ce:	e8 bd c1 ff ff       	call   80100390 <panic>
    panic("sleep");
801041d3:	83 ec 0c             	sub    $0xc,%esp
801041d6:	68 a9 7b 10 80       	push   $0x80107ba9
801041db:	e8 b0 c1 ff ff       	call   80100390 <panic>

801041e0 <wait>:
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	56                   	push   %esi
801041e4:	53                   	push   %ebx
  pushcli();
801041e5:	e8 76 05 00 00       	call   80104760 <pushcli>
  c = mycpu();
801041ea:	e8 f1 f8 ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
801041ef:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801041f5:	e8 66 06 00 00       	call   80104860 <popcli>
  acquire(&ptable.lock);
801041fa:	83 ec 0c             	sub    $0xc,%esp
801041fd:	68 20 3d 11 80       	push   $0x80113d20
80104202:	e8 99 05 00 00       	call   801047a0 <acquire>
80104207:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010420a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010420c:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80104211:	eb 13                	jmp    80104226 <wait+0x46>
80104213:	90                   	nop
80104214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104218:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
8010421e:	81 fb 54 60 11 80    	cmp    $0x80116054,%ebx
80104224:	73 1e                	jae    80104244 <wait+0x64>
      if(p->parent != curproc)
80104226:	39 73 14             	cmp    %esi,0x14(%ebx)
80104229:	75 ed                	jne    80104218 <wait+0x38>
      if(p->state == ZOMBIE){
8010422b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010422f:	74 37                	je     80104268 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104231:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
      havekids = 1;
80104237:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010423c:	81 fb 54 60 11 80    	cmp    $0x80116054,%ebx
80104242:	72 e2                	jb     80104226 <wait+0x46>
    if(!havekids || curproc->killed){
80104244:	85 c0                	test   %eax,%eax
80104246:	74 76                	je     801042be <wait+0xde>
80104248:	8b 46 24             	mov    0x24(%esi),%eax
8010424b:	85 c0                	test   %eax,%eax
8010424d:	75 6f                	jne    801042be <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010424f:	83 ec 08             	sub    $0x8,%esp
80104252:	68 20 3d 11 80       	push   $0x80113d20
80104257:	56                   	push   %esi
80104258:	e8 c3 fe ff ff       	call   80104120 <sleep>
    havekids = 0;
8010425d:	83 c4 10             	add    $0x10,%esp
80104260:	eb a8                	jmp    8010420a <wait+0x2a>
80104262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104268:	83 ec 0c             	sub    $0xc,%esp
8010426b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010426e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104271:	e8 3a e4 ff ff       	call   801026b0 <kfree>
        freevm(p->pgdir);
80104276:	5a                   	pop    %edx
80104277:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010427a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104281:	e8 5a 2e 00 00       	call   801070e0 <freevm>
        release(&ptable.lock);
80104286:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
        p->pid = 0;
8010428d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104294:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010429b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010429f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801042a6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801042ad:	e8 0e 06 00 00       	call   801048c0 <release>
        return pid;
801042b2:	83 c4 10             	add    $0x10,%esp
}
801042b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042b8:	89 f0                	mov    %esi,%eax
801042ba:	5b                   	pop    %ebx
801042bb:	5e                   	pop    %esi
801042bc:	5d                   	pop    %ebp
801042bd:	c3                   	ret    
      release(&ptable.lock);
801042be:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801042c1:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801042c6:	68 20 3d 11 80       	push   $0x80113d20
801042cb:	e8 f0 05 00 00       	call   801048c0 <release>
      return -1;
801042d0:	83 c4 10             	add    $0x10,%esp
801042d3:	eb e0                	jmp    801042b5 <wait+0xd5>
801042d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042e0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	53                   	push   %ebx
801042e4:	83 ec 10             	sub    $0x10,%esp
801042e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801042ea:	68 20 3d 11 80       	push   $0x80113d20
801042ef:	e8 ac 04 00 00       	call   801047a0 <acquire>
801042f4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042f7:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801042fc:	eb 0e                	jmp    8010430c <wakeup+0x2c>
801042fe:	66 90                	xchg   %ax,%ax
80104300:	05 8c 00 00 00       	add    $0x8c,%eax
80104305:	3d 54 60 11 80       	cmp    $0x80116054,%eax
8010430a:	73 1e                	jae    8010432a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010430c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104310:	75 ee                	jne    80104300 <wakeup+0x20>
80104312:	3b 58 20             	cmp    0x20(%eax),%ebx
80104315:	75 e9                	jne    80104300 <wakeup+0x20>
      p->state = RUNNABLE;
80104317:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010431e:	05 8c 00 00 00       	add    $0x8c,%eax
80104323:	3d 54 60 11 80       	cmp    $0x80116054,%eax
80104328:	72 e2                	jb     8010430c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010432a:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104331:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104334:	c9                   	leave  
  release(&ptable.lock);
80104335:	e9 86 05 00 00       	jmp    801048c0 <release>
8010433a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104340 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	53                   	push   %ebx
80104344:	83 ec 10             	sub    $0x10,%esp
80104347:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010434a:	68 20 3d 11 80       	push   $0x80113d20
8010434f:	e8 4c 04 00 00       	call   801047a0 <acquire>
80104354:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104357:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010435c:	eb 0e                	jmp    8010436c <kill+0x2c>
8010435e:	66 90                	xchg   %ax,%ax
80104360:	05 8c 00 00 00       	add    $0x8c,%eax
80104365:	3d 54 60 11 80       	cmp    $0x80116054,%eax
8010436a:	73 34                	jae    801043a0 <kill+0x60>
    if(p->pid == pid){
8010436c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010436f:	75 ef                	jne    80104360 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104371:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104375:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010437c:	75 07                	jne    80104385 <kill+0x45>
        p->state = RUNNABLE;
8010437e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104385:	83 ec 0c             	sub    $0xc,%esp
80104388:	68 20 3d 11 80       	push   $0x80113d20
8010438d:	e8 2e 05 00 00       	call   801048c0 <release>
      return 0;
80104392:	83 c4 10             	add    $0x10,%esp
80104395:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104397:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010439a:	c9                   	leave  
8010439b:	c3                   	ret    
8010439c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801043a0:	83 ec 0c             	sub    $0xc,%esp
801043a3:	68 20 3d 11 80       	push   $0x80113d20
801043a8:	e8 13 05 00 00       	call   801048c0 <release>
  return -1;
801043ad:	83 c4 10             	add    $0x10,%esp
801043b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801043b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043b8:	c9                   	leave  
801043b9:	c3                   	ret    
801043ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043c0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	57                   	push   %edi
801043c4:	56                   	push   %esi
801043c5:	53                   	push   %ebx
801043c6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043c9:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
801043ce:	83 ec 3c             	sub    $0x3c,%esp
801043d1:	eb 27                	jmp    801043fa <procdump+0x3a>
801043d3:	90                   	nop
801043d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801043d8:	83 ec 0c             	sub    $0xc,%esp
801043db:	68 a3 7f 10 80       	push   $0x80107fa3
801043e0:	e8 7b c2 ff ff       	call   80100660 <cprintf>
801043e5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043e8:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801043ee:	81 fb 54 60 11 80    	cmp    $0x80116054,%ebx
801043f4:	0f 83 86 00 00 00    	jae    80104480 <procdump+0xc0>
    if(p->state == UNUSED)
801043fa:	8b 43 0c             	mov    0xc(%ebx),%eax
801043fd:	85 c0                	test   %eax,%eax
801043ff:	74 e7                	je     801043e8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104401:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104404:	ba c0 7b 10 80       	mov    $0x80107bc0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104409:	77 11                	ja     8010441c <procdump+0x5c>
8010440b:	8b 14 85 5c 7c 10 80 	mov    -0x7fef83a4(,%eax,4),%edx
      state = "???";
80104412:	b8 c0 7b 10 80       	mov    $0x80107bc0,%eax
80104417:	85 d2                	test   %edx,%edx
80104419:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010441c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010441f:	50                   	push   %eax
80104420:	52                   	push   %edx
80104421:	ff 73 10             	pushl  0x10(%ebx)
80104424:	68 c4 7b 10 80       	push   $0x80107bc4
80104429:	e8 32 c2 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010442e:	83 c4 10             	add    $0x10,%esp
80104431:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104435:	75 a1                	jne    801043d8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104437:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010443a:	83 ec 08             	sub    $0x8,%esp
8010443d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104440:	50                   	push   %eax
80104441:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104444:	8b 40 0c             	mov    0xc(%eax),%eax
80104447:	83 c0 08             	add    $0x8,%eax
8010444a:	50                   	push   %eax
8010444b:	e8 80 02 00 00       	call   801046d0 <getcallerpcs>
80104450:	83 c4 10             	add    $0x10,%esp
80104453:	90                   	nop
80104454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104458:	8b 17                	mov    (%edi),%edx
8010445a:	85 d2                	test   %edx,%edx
8010445c:	0f 84 76 ff ff ff    	je     801043d8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104462:	83 ec 08             	sub    $0x8,%esp
80104465:	83 c7 04             	add    $0x4,%edi
80104468:	52                   	push   %edx
80104469:	68 c1 75 10 80       	push   $0x801075c1
8010446e:	e8 ed c1 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104473:	83 c4 10             	add    $0x10,%esp
80104476:	39 fe                	cmp    %edi,%esi
80104478:	75 de                	jne    80104458 <procdump+0x98>
8010447a:	e9 59 ff ff ff       	jmp    801043d8 <procdump+0x18>
8010447f:	90                   	nop
  }
}
80104480:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104483:	5b                   	pop    %ebx
80104484:	5e                   	pop    %esi
80104485:	5f                   	pop    %edi
80104486:	5d                   	pop    %ebp
80104487:	c3                   	ret    
80104488:	90                   	nop
80104489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104490 <printFlags>:

void printFlags(pte_t *pgtab){
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	83 ec 10             	sub    $0x10,%esp
  cprintf("PTE_P = %x\n", (*pgtab & PTE_P)&0x1);
80104496:	8b 45 08             	mov    0x8(%ebp),%eax
80104499:	8b 00                	mov    (%eax),%eax
8010449b:	83 e0 01             	and    $0x1,%eax
8010449e:	50                   	push   %eax
8010449f:	68 cd 7b 10 80       	push   $0x80107bcd
801044a4:	e8 b7 c1 ff ff       	call   80100660 <cprintf>
	cprintf("PTE_W = %d\n", (*pgtab & PTE_W)&0x1);
801044a9:	58                   	pop    %eax
801044aa:	5a                   	pop    %edx
801044ab:	6a 00                	push   $0x0
801044ad:	68 d9 7b 10 80       	push   $0x80107bd9
801044b2:	e8 a9 c1 ff ff       	call   80100660 <cprintf>
	cprintf("PTE_PG = %d\n", (*pgtab & PTE_PG)&0x1);
801044b7:	59                   	pop    %ecx
801044b8:	58                   	pop    %eax
801044b9:	6a 00                	push   $0x0
801044bb:	68 e5 7b 10 80       	push   $0x80107be5
801044c0:	e8 9b c1 ff ff       	call   80100660 <cprintf>
}
801044c5:	83 c4 10             	add    $0x10,%esp
801044c8:	c9                   	leave  
801044c9:	c3                   	ret    
801044ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044d0 <protectPage>:
int protectPage(void* va){
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	56                   	push   %esi
801044d4:	53                   	push   %ebx
  pushcli();
801044d5:	e8 86 02 00 00       	call   80104760 <pushcli>
  c = mycpu();
801044da:	e8 01 f6 ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
801044df:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044e5:	e8 76 03 00 00       	call   80104860 <popcli>
  pde = &pgdir[PDX(va)];
801044ea:	8b 45 08             	mov    0x8(%ebp),%eax
  if(*pde & PTE_P){
801044ed:	8b 53 04             	mov    0x4(%ebx),%edx
  pde = &pgdir[PDX(va)];
801044f0:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801044f3:	8b 04 82             	mov    (%edx,%eax,4),%eax
801044f6:	a8 01                	test   $0x1,%al
801044f8:	74 56                	je     80104550 <protectPage+0x80>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801044fa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  printFlags(pgtab);
801044ff:	83 ec 0c             	sub    $0xc,%esp
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80104502:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80104508:	89 c3                	mov    %eax,%ebx
  printFlags(pgtab);
8010450a:	56                   	push   %esi
8010450b:	e8 80 ff ff ff       	call   80104490 <printFlags>
  if(*pgtab & PTE_W){ // this page is writable
80104510:	83 c4 10             	add    $0x10,%esp
80104513:	f6 83 00 00 00 80 02 	testb  $0x2,-0x80000000(%ebx)
8010451a:	75 1c                	jne    80104538 <protectPage+0x68>
  printFlags(pgtab);
8010451c:	83 ec 0c             	sub    $0xc,%esp
8010451f:	56                   	push   %esi
80104520:	e8 6b ff ff ff       	call   80104490 <printFlags>
  return 1;
80104525:	83 c4 10             	add    $0x10,%esp
80104528:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010452d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104530:	5b                   	pop    %ebx
80104531:	5e                   	pop    %esi
80104532:	5d                   	pop    %ebp
80104533:	c3                   	ret    
80104534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("PTE_W = 1 - entered if\n");
80104538:	83 ec 0c             	sub    $0xc,%esp
8010453b:	68 f2 7b 10 80       	push   $0x80107bf2
80104540:	e8 1b c1 ff ff       	call   80100660 <cprintf>
    (*pgtab) &= ~PTE_W;
80104545:	83 26 fd             	andl   $0xfffffffd,(%esi)
80104548:	83 c4 10             	add    $0x10,%esp
8010454b:	eb cf                	jmp    8010451c <protectPage+0x4c>
8010454d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104550:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104555:	eb d6                	jmp    8010452d <protectPage+0x5d>
80104557:	89 f6                	mov    %esi,%esi
80104559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104560 <choosePageToSwapOut>:

void* choosePageToSwapOut(){
80104560:	55                   	push   %ebp
  // todo: choose which page to swap-out, update (add it to this array) the procSwappedFiles data structure and flush the TLB
  return 0;
}
80104561:	31 c0                	xor    %eax,%eax
void* choosePageToSwapOut(){
80104563:	89 e5                	mov    %esp,%ebp
}
80104565:	5d                   	pop    %ebp
80104566:	c3                   	ret    
80104567:	89 f6                	mov    %esi,%esi
80104569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104570 <swapOut>:

// Executes page-out from RAM to Disk.
// Updates the procSwappedFiles array and adds the meta-date of the page to the file   
int swapOut(){
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	83 ec 08             	sub    $0x8,%esp
  pushcli();
80104576:	e8 e5 01 00 00       	call   80104760 <pushcli>
  c = mycpu();
8010457b:	e8 60 f5 ff ff       	call   80103ae0 <mycpu>
  popcli();
80104580:	e8 db 02 00 00       	call   80104860 <popcli>
 struct proc *curProc = myproc();
 pte_t *pte = choosePageToSwapOut();
 char* pa = (char*)(PTE_ADDR(*pte));
80104585:	a1 00 00 00 00       	mov    0x0,%eax
8010458a:	0f 0b                	ud2    
8010458c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104590 <swap>:
 curProc->numOfPhysPages--;
 return offset;
}

// Gets the virtual address of the page which we need to bring from the disk.
int swap(uint *pte, uint faultAdd){
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	83 ec 08             	sub    $0x8,%esp
  if (swapOut() < 0) panic("problem with swapping out file");
80104596:	e8 d5 ff ff ff       	call   80104570 <swapOut>
8010459b:	66 90                	xchg   %ax,%ax
8010459d:	66 90                	xchg   %ax,%ax
8010459f:	90                   	nop

801045a0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	53                   	push   %ebx
801045a4:	83 ec 0c             	sub    $0xc,%esp
801045a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801045aa:	68 74 7c 10 80       	push   $0x80107c74
801045af:	8d 43 04             	lea    0x4(%ebx),%eax
801045b2:	50                   	push   %eax
801045b3:	e8 f8 00 00 00       	call   801046b0 <initlock>
  lk->name = name;
801045b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801045bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801045c1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801045c4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801045cb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801045ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045d1:	c9                   	leave  
801045d2:	c3                   	ret    
801045d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045e0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	56                   	push   %esi
801045e4:	53                   	push   %ebx
801045e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801045e8:	83 ec 0c             	sub    $0xc,%esp
801045eb:	8d 73 04             	lea    0x4(%ebx),%esi
801045ee:	56                   	push   %esi
801045ef:	e8 ac 01 00 00       	call   801047a0 <acquire>
  while (lk->locked) {
801045f4:	8b 13                	mov    (%ebx),%edx
801045f6:	83 c4 10             	add    $0x10,%esp
801045f9:	85 d2                	test   %edx,%edx
801045fb:	74 16                	je     80104613 <acquiresleep+0x33>
801045fd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104600:	83 ec 08             	sub    $0x8,%esp
80104603:	56                   	push   %esi
80104604:	53                   	push   %ebx
80104605:	e8 16 fb ff ff       	call   80104120 <sleep>
  while (lk->locked) {
8010460a:	8b 03                	mov    (%ebx),%eax
8010460c:	83 c4 10             	add    $0x10,%esp
8010460f:	85 c0                	test   %eax,%eax
80104611:	75 ed                	jne    80104600 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104613:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104619:	e8 62 f5 ff ff       	call   80103b80 <myproc>
8010461e:	8b 40 10             	mov    0x10(%eax),%eax
80104621:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104624:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104627:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010462a:	5b                   	pop    %ebx
8010462b:	5e                   	pop    %esi
8010462c:	5d                   	pop    %ebp
  release(&lk->lk);
8010462d:	e9 8e 02 00 00       	jmp    801048c0 <release>
80104632:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104640 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	56                   	push   %esi
80104644:	53                   	push   %ebx
80104645:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104648:	83 ec 0c             	sub    $0xc,%esp
8010464b:	8d 73 04             	lea    0x4(%ebx),%esi
8010464e:	56                   	push   %esi
8010464f:	e8 4c 01 00 00       	call   801047a0 <acquire>
  lk->locked = 0;
80104654:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010465a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104661:	89 1c 24             	mov    %ebx,(%esp)
80104664:	e8 77 fc ff ff       	call   801042e0 <wakeup>
  release(&lk->lk);
80104669:	89 75 08             	mov    %esi,0x8(%ebp)
8010466c:	83 c4 10             	add    $0x10,%esp
}
8010466f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104672:	5b                   	pop    %ebx
80104673:	5e                   	pop    %esi
80104674:	5d                   	pop    %ebp
  release(&lk->lk);
80104675:	e9 46 02 00 00       	jmp    801048c0 <release>
8010467a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104680 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	56                   	push   %esi
80104684:	53                   	push   %ebx
80104685:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104688:	83 ec 0c             	sub    $0xc,%esp
8010468b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010468e:	53                   	push   %ebx
8010468f:	e8 0c 01 00 00       	call   801047a0 <acquire>
  r = lk->locked;
80104694:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104696:	89 1c 24             	mov    %ebx,(%esp)
80104699:	e8 22 02 00 00       	call   801048c0 <release>
  return r;
}
8010469e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046a1:	89 f0                	mov    %esi,%eax
801046a3:	5b                   	pop    %ebx
801046a4:	5e                   	pop    %esi
801046a5:	5d                   	pop    %ebp
801046a6:	c3                   	ret    
801046a7:	66 90                	xchg   %ax,%ax
801046a9:	66 90                	xchg   %ax,%ax
801046ab:	66 90                	xchg   %ax,%ax
801046ad:	66 90                	xchg   %ax,%ax
801046af:	90                   	nop

801046b0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801046b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801046b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801046bf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801046c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801046c9:	5d                   	pop    %ebp
801046ca:	c3                   	ret    
801046cb:	90                   	nop
801046cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046d0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801046d0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801046d1:	31 d2                	xor    %edx,%edx
{
801046d3:	89 e5                	mov    %esp,%ebp
801046d5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801046d6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801046d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801046dc:	83 e8 08             	sub    $0x8,%eax
801046df:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046e0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801046e6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801046ec:	77 1a                	ja     80104708 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801046ee:	8b 58 04             	mov    0x4(%eax),%ebx
801046f1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801046f4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801046f7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801046f9:	83 fa 0a             	cmp    $0xa,%edx
801046fc:	75 e2                	jne    801046e0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801046fe:	5b                   	pop    %ebx
801046ff:	5d                   	pop    %ebp
80104700:	c3                   	ret    
80104701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104708:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010470b:	83 c1 28             	add    $0x28,%ecx
8010470e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104710:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104716:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104719:	39 c1                	cmp    %eax,%ecx
8010471b:	75 f3                	jne    80104710 <getcallerpcs+0x40>
}
8010471d:	5b                   	pop    %ebx
8010471e:	5d                   	pop    %ebp
8010471f:	c3                   	ret    

80104720 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	53                   	push   %ebx
80104724:	83 ec 04             	sub    $0x4,%esp
80104727:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010472a:	8b 02                	mov    (%edx),%eax
8010472c:	85 c0                	test   %eax,%eax
8010472e:	75 10                	jne    80104740 <holding+0x20>
}
80104730:	83 c4 04             	add    $0x4,%esp
80104733:	31 c0                	xor    %eax,%eax
80104735:	5b                   	pop    %ebx
80104736:	5d                   	pop    %ebp
80104737:	c3                   	ret    
80104738:	90                   	nop
80104739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104740:	8b 5a 08             	mov    0x8(%edx),%ebx
80104743:	e8 98 f3 ff ff       	call   80103ae0 <mycpu>
80104748:	39 c3                	cmp    %eax,%ebx
8010474a:	0f 94 c0             	sete   %al
}
8010474d:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104750:	0f b6 c0             	movzbl %al,%eax
}
80104753:	5b                   	pop    %ebx
80104754:	5d                   	pop    %ebp
80104755:	c3                   	ret    
80104756:	8d 76 00             	lea    0x0(%esi),%esi
80104759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104760 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	53                   	push   %ebx
80104764:	83 ec 04             	sub    $0x4,%esp
80104767:	9c                   	pushf  
80104768:	5b                   	pop    %ebx
  asm volatile("cli");
80104769:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010476a:	e8 71 f3 ff ff       	call   80103ae0 <mycpu>
8010476f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104775:	85 c0                	test   %eax,%eax
80104777:	75 11                	jne    8010478a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104779:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010477f:	e8 5c f3 ff ff       	call   80103ae0 <mycpu>
80104784:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010478a:	e8 51 f3 ff ff       	call   80103ae0 <mycpu>
8010478f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104796:	83 c4 04             	add    $0x4,%esp
80104799:	5b                   	pop    %ebx
8010479a:	5d                   	pop    %ebp
8010479b:	c3                   	ret    
8010479c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047a0 <acquire>:
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	56                   	push   %esi
801047a4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801047a5:	e8 b6 ff ff ff       	call   80104760 <pushcli>
  if(holding(lk))
801047aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801047ad:	8b 03                	mov    (%ebx),%eax
801047af:	85 c0                	test   %eax,%eax
801047b1:	0f 85 81 00 00 00    	jne    80104838 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
801047b7:	ba 01 00 00 00       	mov    $0x1,%edx
801047bc:	eb 05                	jmp    801047c3 <acquire+0x23>
801047be:	66 90                	xchg   %ax,%ax
801047c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047c3:	89 d0                	mov    %edx,%eax
801047c5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801047c8:	85 c0                	test   %eax,%eax
801047ca:	75 f4                	jne    801047c0 <acquire+0x20>
  __sync_synchronize();
801047cc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801047d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047d4:	e8 07 f3 ff ff       	call   80103ae0 <mycpu>
  for(i = 0; i < 10; i++){
801047d9:	31 d2                	xor    %edx,%edx
  getcallerpcs(&lk, lk->pcs);
801047db:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  lk->cpu = mycpu();
801047de:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801047e1:	89 e8                	mov    %ebp,%eax
801047e3:	90                   	nop
801047e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047e8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801047ee:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801047f4:	77 1a                	ja     80104810 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
801047f6:	8b 58 04             	mov    0x4(%eax),%ebx
801047f9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801047fc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801047ff:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104801:	83 fa 0a             	cmp    $0xa,%edx
80104804:	75 e2                	jne    801047e8 <acquire+0x48>
}
80104806:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104809:	5b                   	pop    %ebx
8010480a:	5e                   	pop    %esi
8010480b:	5d                   	pop    %ebp
8010480c:	c3                   	ret    
8010480d:	8d 76 00             	lea    0x0(%esi),%esi
80104810:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104813:	83 c1 28             	add    $0x28,%ecx
80104816:	8d 76 00             	lea    0x0(%esi),%esi
80104819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104820:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104826:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104829:	39 c8                	cmp    %ecx,%eax
8010482b:	75 f3                	jne    80104820 <acquire+0x80>
}
8010482d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104830:	5b                   	pop    %ebx
80104831:	5e                   	pop    %esi
80104832:	5d                   	pop    %ebp
80104833:	c3                   	ret    
80104834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104838:	8b 73 08             	mov    0x8(%ebx),%esi
8010483b:	e8 a0 f2 ff ff       	call   80103ae0 <mycpu>
80104840:	39 c6                	cmp    %eax,%esi
80104842:	0f 85 6f ff ff ff    	jne    801047b7 <acquire+0x17>
    panic("acquire");
80104848:	83 ec 0c             	sub    $0xc,%esp
8010484b:	68 7f 7c 10 80       	push   $0x80107c7f
80104850:	e8 3b bb ff ff       	call   80100390 <panic>
80104855:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104860 <popcli>:

void
popcli(void)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104866:	9c                   	pushf  
80104867:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104868:	f6 c4 02             	test   $0x2,%ah
8010486b:	75 35                	jne    801048a2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010486d:	e8 6e f2 ff ff       	call   80103ae0 <mycpu>
80104872:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104879:	78 34                	js     801048af <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010487b:	e8 60 f2 ff ff       	call   80103ae0 <mycpu>
80104880:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104886:	85 d2                	test   %edx,%edx
80104888:	74 06                	je     80104890 <popcli+0x30>
    sti();
}
8010488a:	c9                   	leave  
8010488b:	c3                   	ret    
8010488c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104890:	e8 4b f2 ff ff       	call   80103ae0 <mycpu>
80104895:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010489b:	85 c0                	test   %eax,%eax
8010489d:	74 eb                	je     8010488a <popcli+0x2a>
  asm volatile("sti");
8010489f:	fb                   	sti    
}
801048a0:	c9                   	leave  
801048a1:	c3                   	ret    
    panic("popcli - interruptible");
801048a2:	83 ec 0c             	sub    $0xc,%esp
801048a5:	68 87 7c 10 80       	push   $0x80107c87
801048aa:	e8 e1 ba ff ff       	call   80100390 <panic>
    panic("popcli");
801048af:	83 ec 0c             	sub    $0xc,%esp
801048b2:	68 9e 7c 10 80       	push   $0x80107c9e
801048b7:	e8 d4 ba ff ff       	call   80100390 <panic>
801048bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048c0 <release>:
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	56                   	push   %esi
801048c4:	53                   	push   %ebx
801048c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801048c8:	8b 03                	mov    (%ebx),%eax
801048ca:	85 c0                	test   %eax,%eax
801048cc:	74 0c                	je     801048da <release+0x1a>
801048ce:	8b 73 08             	mov    0x8(%ebx),%esi
801048d1:	e8 0a f2 ff ff       	call   80103ae0 <mycpu>
801048d6:	39 c6                	cmp    %eax,%esi
801048d8:	74 16                	je     801048f0 <release+0x30>
    panic("release");
801048da:	83 ec 0c             	sub    $0xc,%esp
801048dd:	68 a5 7c 10 80       	push   $0x80107ca5
801048e2:	e8 a9 ba ff ff       	call   80100390 <panic>
801048e7:	89 f6                	mov    %esi,%esi
801048e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lk->pcs[0] = 0;
801048f0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801048f7:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801048fe:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104903:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104909:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010490c:	5b                   	pop    %ebx
8010490d:	5e                   	pop    %esi
8010490e:	5d                   	pop    %ebp
  popcli();
8010490f:	e9 4c ff ff ff       	jmp    80104860 <popcli>
80104914:	66 90                	xchg   %ax,%ax
80104916:	66 90                	xchg   %ax,%ax
80104918:	66 90                	xchg   %ax,%ax
8010491a:	66 90                	xchg   %ax,%ax
8010491c:	66 90                	xchg   %ax,%ax
8010491e:	66 90                	xchg   %ax,%ax

80104920 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	57                   	push   %edi
80104924:	53                   	push   %ebx
80104925:	8b 55 08             	mov    0x8(%ebp),%edx
80104928:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010492b:	f6 c2 03             	test   $0x3,%dl
8010492e:	75 05                	jne    80104935 <memset+0x15>
80104930:	f6 c1 03             	test   $0x3,%cl
80104933:	74 13                	je     80104948 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104935:	89 d7                	mov    %edx,%edi
80104937:	8b 45 0c             	mov    0xc(%ebp),%eax
8010493a:	fc                   	cld    
8010493b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010493d:	5b                   	pop    %ebx
8010493e:	89 d0                	mov    %edx,%eax
80104940:	5f                   	pop    %edi
80104941:	5d                   	pop    %ebp
80104942:	c3                   	ret    
80104943:	90                   	nop
80104944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104948:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010494c:	c1 e9 02             	shr    $0x2,%ecx
8010494f:	89 f8                	mov    %edi,%eax
80104951:	89 fb                	mov    %edi,%ebx
80104953:	c1 e0 18             	shl    $0x18,%eax
80104956:	c1 e3 10             	shl    $0x10,%ebx
80104959:	09 d8                	or     %ebx,%eax
8010495b:	09 f8                	or     %edi,%eax
8010495d:	c1 e7 08             	shl    $0x8,%edi
80104960:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104962:	89 d7                	mov    %edx,%edi
80104964:	fc                   	cld    
80104965:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104967:	5b                   	pop    %ebx
80104968:	89 d0                	mov    %edx,%eax
8010496a:	5f                   	pop    %edi
8010496b:	5d                   	pop    %ebp
8010496c:	c3                   	ret    
8010496d:	8d 76 00             	lea    0x0(%esi),%esi

80104970 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	57                   	push   %edi
80104974:	56                   	push   %esi
80104975:	53                   	push   %ebx
80104976:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104979:	8b 75 08             	mov    0x8(%ebp),%esi
8010497c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010497f:	85 db                	test   %ebx,%ebx
80104981:	74 29                	je     801049ac <memcmp+0x3c>
    if(*s1 != *s2)
80104983:	0f b6 16             	movzbl (%esi),%edx
80104986:	0f b6 0f             	movzbl (%edi),%ecx
80104989:	38 d1                	cmp    %dl,%cl
8010498b:	75 2b                	jne    801049b8 <memcmp+0x48>
8010498d:	b8 01 00 00 00       	mov    $0x1,%eax
80104992:	eb 14                	jmp    801049a8 <memcmp+0x38>
80104994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104998:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010499c:	83 c0 01             	add    $0x1,%eax
8010499f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801049a4:	38 ca                	cmp    %cl,%dl
801049a6:	75 10                	jne    801049b8 <memcmp+0x48>
  while(n-- > 0){
801049a8:	39 d8                	cmp    %ebx,%eax
801049aa:	75 ec                	jne    80104998 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801049ac:	5b                   	pop    %ebx
  return 0;
801049ad:	31 c0                	xor    %eax,%eax
}
801049af:	5e                   	pop    %esi
801049b0:	5f                   	pop    %edi
801049b1:	5d                   	pop    %ebp
801049b2:	c3                   	ret    
801049b3:	90                   	nop
801049b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801049b8:	0f b6 c2             	movzbl %dl,%eax
}
801049bb:	5b                   	pop    %ebx
      return *s1 - *s2;
801049bc:	29 c8                	sub    %ecx,%eax
}
801049be:	5e                   	pop    %esi
801049bf:	5f                   	pop    %edi
801049c0:	5d                   	pop    %ebp
801049c1:	c3                   	ret    
801049c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049d0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	56                   	push   %esi
801049d4:	53                   	push   %ebx
801049d5:	8b 45 08             	mov    0x8(%ebp),%eax
801049d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801049db:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801049de:	39 c3                	cmp    %eax,%ebx
801049e0:	73 26                	jae    80104a08 <memmove+0x38>
801049e2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801049e5:	39 c8                	cmp    %ecx,%eax
801049e7:	73 1f                	jae    80104a08 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801049e9:	85 f6                	test   %esi,%esi
801049eb:	8d 56 ff             	lea    -0x1(%esi),%edx
801049ee:	74 0f                	je     801049ff <memmove+0x2f>
      *--d = *--s;
801049f0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801049f4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801049f7:	83 ea 01             	sub    $0x1,%edx
801049fa:	83 fa ff             	cmp    $0xffffffff,%edx
801049fd:	75 f1                	jne    801049f0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801049ff:	5b                   	pop    %ebx
80104a00:	5e                   	pop    %esi
80104a01:	5d                   	pop    %ebp
80104a02:	c3                   	ret    
80104a03:	90                   	nop
80104a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104a08:	31 d2                	xor    %edx,%edx
80104a0a:	85 f6                	test   %esi,%esi
80104a0c:	74 f1                	je     801049ff <memmove+0x2f>
80104a0e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104a10:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104a14:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104a17:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104a1a:	39 d6                	cmp    %edx,%esi
80104a1c:	75 f2                	jne    80104a10 <memmove+0x40>
}
80104a1e:	5b                   	pop    %ebx
80104a1f:	5e                   	pop    %esi
80104a20:	5d                   	pop    %ebp
80104a21:	c3                   	ret    
80104a22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a30 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104a33:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104a34:	eb 9a                	jmp    801049d0 <memmove>
80104a36:	8d 76 00             	lea    0x0(%esi),%esi
80104a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a40 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	57                   	push   %edi
80104a44:	56                   	push   %esi
80104a45:	8b 7d 10             	mov    0x10(%ebp),%edi
80104a48:	53                   	push   %ebx
80104a49:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104a4f:	85 ff                	test   %edi,%edi
80104a51:	74 2f                	je     80104a82 <strncmp+0x42>
80104a53:	0f b6 01             	movzbl (%ecx),%eax
80104a56:	0f b6 1e             	movzbl (%esi),%ebx
80104a59:	84 c0                	test   %al,%al
80104a5b:	74 37                	je     80104a94 <strncmp+0x54>
80104a5d:	38 c3                	cmp    %al,%bl
80104a5f:	75 33                	jne    80104a94 <strncmp+0x54>
80104a61:	01 f7                	add    %esi,%edi
80104a63:	eb 13                	jmp    80104a78 <strncmp+0x38>
80104a65:	8d 76 00             	lea    0x0(%esi),%esi
80104a68:	0f b6 01             	movzbl (%ecx),%eax
80104a6b:	84 c0                	test   %al,%al
80104a6d:	74 21                	je     80104a90 <strncmp+0x50>
80104a6f:	0f b6 1a             	movzbl (%edx),%ebx
80104a72:	89 d6                	mov    %edx,%esi
80104a74:	38 d8                	cmp    %bl,%al
80104a76:	75 1c                	jne    80104a94 <strncmp+0x54>
    n--, p++, q++;
80104a78:	8d 56 01             	lea    0x1(%esi),%edx
80104a7b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104a7e:	39 fa                	cmp    %edi,%edx
80104a80:	75 e6                	jne    80104a68 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104a82:	5b                   	pop    %ebx
    return 0;
80104a83:	31 c0                	xor    %eax,%eax
}
80104a85:	5e                   	pop    %esi
80104a86:	5f                   	pop    %edi
80104a87:	5d                   	pop    %ebp
80104a88:	c3                   	ret    
80104a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a90:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104a94:	29 d8                	sub    %ebx,%eax
}
80104a96:	5b                   	pop    %ebx
80104a97:	5e                   	pop    %esi
80104a98:	5f                   	pop    %edi
80104a99:	5d                   	pop    %ebp
80104a9a:	c3                   	ret    
80104a9b:	90                   	nop
80104a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104aa0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	56                   	push   %esi
80104aa4:	53                   	push   %ebx
80104aa5:	8b 45 08             	mov    0x8(%ebp),%eax
80104aa8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104aab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104aae:	89 c2                	mov    %eax,%edx
80104ab0:	eb 19                	jmp    80104acb <strncpy+0x2b>
80104ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ab8:	83 c3 01             	add    $0x1,%ebx
80104abb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104abf:	83 c2 01             	add    $0x1,%edx
80104ac2:	84 c9                	test   %cl,%cl
80104ac4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104ac7:	74 09                	je     80104ad2 <strncpy+0x32>
80104ac9:	89 f1                	mov    %esi,%ecx
80104acb:	85 c9                	test   %ecx,%ecx
80104acd:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104ad0:	7f e6                	jg     80104ab8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104ad2:	31 c9                	xor    %ecx,%ecx
80104ad4:	85 f6                	test   %esi,%esi
80104ad6:	7e 17                	jle    80104aef <strncpy+0x4f>
80104ad8:	90                   	nop
80104ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104ae0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104ae4:	89 f3                	mov    %esi,%ebx
80104ae6:	83 c1 01             	add    $0x1,%ecx
80104ae9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104aeb:	85 db                	test   %ebx,%ebx
80104aed:	7f f1                	jg     80104ae0 <strncpy+0x40>
  return os;
}
80104aef:	5b                   	pop    %ebx
80104af0:	5e                   	pop    %esi
80104af1:	5d                   	pop    %ebp
80104af2:	c3                   	ret    
80104af3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b00 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	56                   	push   %esi
80104b04:	53                   	push   %ebx
80104b05:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104b08:	8b 45 08             	mov    0x8(%ebp),%eax
80104b0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104b0e:	85 c9                	test   %ecx,%ecx
80104b10:	7e 26                	jle    80104b38 <safestrcpy+0x38>
80104b12:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104b16:	89 c1                	mov    %eax,%ecx
80104b18:	eb 17                	jmp    80104b31 <safestrcpy+0x31>
80104b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104b20:	83 c2 01             	add    $0x1,%edx
80104b23:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104b27:	83 c1 01             	add    $0x1,%ecx
80104b2a:	84 db                	test   %bl,%bl
80104b2c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104b2f:	74 04                	je     80104b35 <safestrcpy+0x35>
80104b31:	39 f2                	cmp    %esi,%edx
80104b33:	75 eb                	jne    80104b20 <safestrcpy+0x20>
    ;
  *s = 0;
80104b35:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104b38:	5b                   	pop    %ebx
80104b39:	5e                   	pop    %esi
80104b3a:	5d                   	pop    %ebp
80104b3b:	c3                   	ret    
80104b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b40 <strlen>:

int
strlen(const char *s)
{
80104b40:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104b41:	31 c0                	xor    %eax,%eax
{
80104b43:	89 e5                	mov    %esp,%ebp
80104b45:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104b48:	80 3a 00             	cmpb   $0x0,(%edx)
80104b4b:	74 0c                	je     80104b59 <strlen+0x19>
80104b4d:	8d 76 00             	lea    0x0(%esi),%esi
80104b50:	83 c0 01             	add    $0x1,%eax
80104b53:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104b57:	75 f7                	jne    80104b50 <strlen+0x10>
    ;
  return n;
}
80104b59:	5d                   	pop    %ebp
80104b5a:	c3                   	ret    

80104b5b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104b5b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104b5f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104b63:	55                   	push   %ebp
  pushl %ebx
80104b64:	53                   	push   %ebx
  pushl %esi
80104b65:	56                   	push   %esi
  pushl %edi
80104b66:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104b67:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104b69:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104b6b:	5f                   	pop    %edi
  popl %esi
80104b6c:	5e                   	pop    %esi
  popl %ebx
80104b6d:	5b                   	pop    %ebx
  popl %ebp
80104b6e:	5d                   	pop    %ebp
  ret
80104b6f:	c3                   	ret    

80104b70 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	53                   	push   %ebx
80104b74:	83 ec 04             	sub    $0x4,%esp
80104b77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104b7a:	e8 01 f0 ff ff       	call   80103b80 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b7f:	8b 00                	mov    (%eax),%eax
80104b81:	39 d8                	cmp    %ebx,%eax
80104b83:	76 1b                	jbe    80104ba0 <fetchint+0x30>
80104b85:	8d 53 04             	lea    0x4(%ebx),%edx
80104b88:	39 d0                	cmp    %edx,%eax
80104b8a:	72 14                	jb     80104ba0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b8f:	8b 13                	mov    (%ebx),%edx
80104b91:	89 10                	mov    %edx,(%eax)
  return 0;
80104b93:	31 c0                	xor    %eax,%eax
}
80104b95:	83 c4 04             	add    $0x4,%esp
80104b98:	5b                   	pop    %ebx
80104b99:	5d                   	pop    %ebp
80104b9a:	c3                   	ret    
80104b9b:	90                   	nop
80104b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ba5:	eb ee                	jmp    80104b95 <fetchint+0x25>
80104ba7:	89 f6                	mov    %esi,%esi
80104ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bb0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	53                   	push   %ebx
80104bb4:	83 ec 04             	sub    $0x4,%esp
80104bb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104bba:	e8 c1 ef ff ff       	call   80103b80 <myproc>

  if(addr >= curproc->sz)
80104bbf:	39 18                	cmp    %ebx,(%eax)
80104bc1:	76 29                	jbe    80104bec <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104bc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104bc6:	89 da                	mov    %ebx,%edx
80104bc8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104bca:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104bcc:	39 c3                	cmp    %eax,%ebx
80104bce:	73 1c                	jae    80104bec <fetchstr+0x3c>
    if(*s == 0)
80104bd0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104bd3:	75 10                	jne    80104be5 <fetchstr+0x35>
80104bd5:	eb 39                	jmp    80104c10 <fetchstr+0x60>
80104bd7:	89 f6                	mov    %esi,%esi
80104bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104be0:	80 3a 00             	cmpb   $0x0,(%edx)
80104be3:	74 1b                	je     80104c00 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104be5:	83 c2 01             	add    $0x1,%edx
80104be8:	39 d0                	cmp    %edx,%eax
80104bea:	77 f4                	ja     80104be0 <fetchstr+0x30>
    return -1;
80104bec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104bf1:	83 c4 04             	add    $0x4,%esp
80104bf4:	5b                   	pop    %ebx
80104bf5:	5d                   	pop    %ebp
80104bf6:	c3                   	ret    
80104bf7:	89 f6                	mov    %esi,%esi
80104bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104c00:	83 c4 04             	add    $0x4,%esp
80104c03:	89 d0                	mov    %edx,%eax
80104c05:	29 d8                	sub    %ebx,%eax
80104c07:	5b                   	pop    %ebx
80104c08:	5d                   	pop    %ebp
80104c09:	c3                   	ret    
80104c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104c10:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104c12:	eb dd                	jmp    80104bf1 <fetchstr+0x41>
80104c14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104c20 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	56                   	push   %esi
80104c24:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c25:	e8 56 ef ff ff       	call   80103b80 <myproc>
80104c2a:	8b 40 18             	mov    0x18(%eax),%eax
80104c2d:	8b 55 08             	mov    0x8(%ebp),%edx
80104c30:	8b 40 44             	mov    0x44(%eax),%eax
80104c33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c36:	e8 45 ef ff ff       	call   80103b80 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c3b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c3d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c40:	39 c6                	cmp    %eax,%esi
80104c42:	73 1c                	jae    80104c60 <argint+0x40>
80104c44:	8d 53 08             	lea    0x8(%ebx),%edx
80104c47:	39 d0                	cmp    %edx,%eax
80104c49:	72 15                	jb     80104c60 <argint+0x40>
  *ip = *(int*)(addr);
80104c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c4e:	8b 53 04             	mov    0x4(%ebx),%edx
80104c51:	89 10                	mov    %edx,(%eax)
  return 0;
80104c53:	31 c0                	xor    %eax,%eax
}
80104c55:	5b                   	pop    %ebx
80104c56:	5e                   	pop    %esi
80104c57:	5d                   	pop    %ebp
80104c58:	c3                   	ret    
80104c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c65:	eb ee                	jmp    80104c55 <argint+0x35>
80104c67:	89 f6                	mov    %esi,%esi
80104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c70 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	56                   	push   %esi
80104c74:	53                   	push   %ebx
80104c75:	83 ec 10             	sub    $0x10,%esp
80104c78:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104c7b:	e8 00 ef ff ff       	call   80103b80 <myproc>
80104c80:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104c82:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c85:	83 ec 08             	sub    $0x8,%esp
80104c88:	50                   	push   %eax
80104c89:	ff 75 08             	pushl  0x8(%ebp)
80104c8c:	e8 8f ff ff ff       	call   80104c20 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c91:	83 c4 10             	add    $0x10,%esp
80104c94:	85 c0                	test   %eax,%eax
80104c96:	78 28                	js     80104cc0 <argptr+0x50>
80104c98:	85 db                	test   %ebx,%ebx
80104c9a:	78 24                	js     80104cc0 <argptr+0x50>
80104c9c:	8b 16                	mov    (%esi),%edx
80104c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ca1:	39 c2                	cmp    %eax,%edx
80104ca3:	76 1b                	jbe    80104cc0 <argptr+0x50>
80104ca5:	01 c3                	add    %eax,%ebx
80104ca7:	39 da                	cmp    %ebx,%edx
80104ca9:	72 15                	jb     80104cc0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104cab:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cae:	89 02                	mov    %eax,(%edx)
  return 0;
80104cb0:	31 c0                	xor    %eax,%eax
}
80104cb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cb5:	5b                   	pop    %ebx
80104cb6:	5e                   	pop    %esi
80104cb7:	5d                   	pop    %ebp
80104cb8:	c3                   	ret    
80104cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cc5:	eb eb                	jmp    80104cb2 <argptr+0x42>
80104cc7:	89 f6                	mov    %esi,%esi
80104cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cd0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104cd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cd9:	50                   	push   %eax
80104cda:	ff 75 08             	pushl  0x8(%ebp)
80104cdd:	e8 3e ff ff ff       	call   80104c20 <argint>
80104ce2:	83 c4 10             	add    $0x10,%esp
80104ce5:	85 c0                	test   %eax,%eax
80104ce7:	78 17                	js     80104d00 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104ce9:	83 ec 08             	sub    $0x8,%esp
80104cec:	ff 75 0c             	pushl  0xc(%ebp)
80104cef:	ff 75 f4             	pushl  -0xc(%ebp)
80104cf2:	e8 b9 fe ff ff       	call   80104bb0 <fetchstr>
80104cf7:	83 c4 10             	add    $0x10,%esp
}
80104cfa:	c9                   	leave  
80104cfb:	c3                   	ret    
80104cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d05:	c9                   	leave  
80104d06:	c3                   	ret    
80104d07:	89 f6                	mov    %esi,%esi
80104d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d10 <syscall>:
[SYS_protectPage] sys_protectPage,
};

void
syscall(void)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	53                   	push   %ebx
80104d14:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104d17:	e8 64 ee ff ff       	call   80103b80 <myproc>
80104d1c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104d1e:	8b 40 18             	mov    0x18(%eax),%eax
80104d21:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d24:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d27:	83 fa 16             	cmp    $0x16,%edx
80104d2a:	77 1c                	ja     80104d48 <syscall+0x38>
80104d2c:	8b 14 85 e0 7c 10 80 	mov    -0x7fef8320(,%eax,4),%edx
80104d33:	85 d2                	test   %edx,%edx
80104d35:	74 11                	je     80104d48 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104d37:	ff d2                	call   *%edx
80104d39:	8b 53 18             	mov    0x18(%ebx),%edx
80104d3c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104d3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d42:	c9                   	leave  
80104d43:	c3                   	ret    
80104d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104d48:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104d49:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104d4c:	50                   	push   %eax
80104d4d:	ff 73 10             	pushl  0x10(%ebx)
80104d50:	68 ad 7c 10 80       	push   $0x80107cad
80104d55:	e8 06 b9 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104d5a:	8b 43 18             	mov    0x18(%ebx),%eax
80104d5d:	83 c4 10             	add    $0x10,%esp
80104d60:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104d67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d6a:	c9                   	leave  
80104d6b:	c3                   	ret    
80104d6c:	66 90                	xchg   %ax,%ax
80104d6e:	66 90                	xchg   %ax,%ax

80104d70 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	56                   	push   %esi
80104d74:	53                   	push   %ebx
80104d75:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104d77:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104d7a:	89 d6                	mov    %edx,%esi
80104d7c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d7f:	50                   	push   %eax
80104d80:	6a 00                	push   $0x0
80104d82:	e8 99 fe ff ff       	call   80104c20 <argint>
80104d87:	83 c4 10             	add    $0x10,%esp
80104d8a:	85 c0                	test   %eax,%eax
80104d8c:	78 2a                	js     80104db8 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d8e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d92:	77 24                	ja     80104db8 <argfd.constprop.0+0x48>
80104d94:	e8 e7 ed ff ff       	call   80103b80 <myproc>
80104d99:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d9c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104da0:	85 c0                	test   %eax,%eax
80104da2:	74 14                	je     80104db8 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80104da4:	85 db                	test   %ebx,%ebx
80104da6:	74 02                	je     80104daa <argfd.constprop.0+0x3a>
    *pfd = fd;
80104da8:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
80104daa:	89 06                	mov    %eax,(%esi)
  return 0;
80104dac:	31 c0                	xor    %eax,%eax
}
80104dae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104db1:	5b                   	pop    %ebx
80104db2:	5e                   	pop    %esi
80104db3:	5d                   	pop    %ebp
80104db4:	c3                   	ret    
80104db5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104db8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dbd:	eb ef                	jmp    80104dae <argfd.constprop.0+0x3e>
80104dbf:	90                   	nop

80104dc0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104dc0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104dc1:	31 c0                	xor    %eax,%eax
{
80104dc3:	89 e5                	mov    %esp,%ebp
80104dc5:	56                   	push   %esi
80104dc6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104dc7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104dca:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104dcd:	e8 9e ff ff ff       	call   80104d70 <argfd.constprop.0>
80104dd2:	85 c0                	test   %eax,%eax
80104dd4:	78 42                	js     80104e18 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104dd6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104dd9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104ddb:	e8 a0 ed ff ff       	call   80103b80 <myproc>
80104de0:	eb 0e                	jmp    80104df0 <sys_dup+0x30>
80104de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104de8:	83 c3 01             	add    $0x1,%ebx
80104deb:	83 fb 10             	cmp    $0x10,%ebx
80104dee:	74 28                	je     80104e18 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104df0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104df4:	85 d2                	test   %edx,%edx
80104df6:	75 f0                	jne    80104de8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104df8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
80104dfc:	83 ec 0c             	sub    $0xc,%esp
80104dff:	ff 75 f4             	pushl  -0xc(%ebp)
80104e02:	e8 e9 bf ff ff       	call   80100df0 <filedup>
  return fd;
80104e07:	83 c4 10             	add    $0x10,%esp
}
80104e0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e0d:	89 d8                	mov    %ebx,%eax
80104e0f:	5b                   	pop    %ebx
80104e10:	5e                   	pop    %esi
80104e11:	5d                   	pop    %ebp
80104e12:	c3                   	ret    
80104e13:	90                   	nop
80104e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e18:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104e1b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104e20:	89 d8                	mov    %ebx,%eax
80104e22:	5b                   	pop    %ebx
80104e23:	5e                   	pop    %esi
80104e24:	5d                   	pop    %ebp
80104e25:	c3                   	ret    
80104e26:	8d 76 00             	lea    0x0(%esi),%esi
80104e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e30 <sys_read>:

int
sys_read(void)
{
80104e30:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e31:	31 c0                	xor    %eax,%eax
{
80104e33:	89 e5                	mov    %esp,%ebp
80104e35:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e38:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e3b:	e8 30 ff ff ff       	call   80104d70 <argfd.constprop.0>
80104e40:	85 c0                	test   %eax,%eax
80104e42:	78 4c                	js     80104e90 <sys_read+0x60>
80104e44:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e47:	83 ec 08             	sub    $0x8,%esp
80104e4a:	50                   	push   %eax
80104e4b:	6a 02                	push   $0x2
80104e4d:	e8 ce fd ff ff       	call   80104c20 <argint>
80104e52:	83 c4 10             	add    $0x10,%esp
80104e55:	85 c0                	test   %eax,%eax
80104e57:	78 37                	js     80104e90 <sys_read+0x60>
80104e59:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e5c:	83 ec 04             	sub    $0x4,%esp
80104e5f:	ff 75 f0             	pushl  -0x10(%ebp)
80104e62:	50                   	push   %eax
80104e63:	6a 01                	push   $0x1
80104e65:	e8 06 fe ff ff       	call   80104c70 <argptr>
80104e6a:	83 c4 10             	add    $0x10,%esp
80104e6d:	85 c0                	test   %eax,%eax
80104e6f:	78 1f                	js     80104e90 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104e71:	83 ec 04             	sub    $0x4,%esp
80104e74:	ff 75 f0             	pushl  -0x10(%ebp)
80104e77:	ff 75 f4             	pushl  -0xc(%ebp)
80104e7a:	ff 75 ec             	pushl  -0x14(%ebp)
80104e7d:	e8 de c0 ff ff       	call   80100f60 <fileread>
80104e82:	83 c4 10             	add    $0x10,%esp
}
80104e85:	c9                   	leave  
80104e86:	c3                   	ret    
80104e87:	89 f6                	mov    %esi,%esi
80104e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104e90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e95:	c9                   	leave  
80104e96:	c3                   	ret    
80104e97:	89 f6                	mov    %esi,%esi
80104e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ea0 <sys_write>:

int
sys_write(void)
{
80104ea0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ea1:	31 c0                	xor    %eax,%eax
{
80104ea3:	89 e5                	mov    %esp,%ebp
80104ea5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ea8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104eab:	e8 c0 fe ff ff       	call   80104d70 <argfd.constprop.0>
80104eb0:	85 c0                	test   %eax,%eax
80104eb2:	78 4c                	js     80104f00 <sys_write+0x60>
80104eb4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104eb7:	83 ec 08             	sub    $0x8,%esp
80104eba:	50                   	push   %eax
80104ebb:	6a 02                	push   $0x2
80104ebd:	e8 5e fd ff ff       	call   80104c20 <argint>
80104ec2:	83 c4 10             	add    $0x10,%esp
80104ec5:	85 c0                	test   %eax,%eax
80104ec7:	78 37                	js     80104f00 <sys_write+0x60>
80104ec9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ecc:	83 ec 04             	sub    $0x4,%esp
80104ecf:	ff 75 f0             	pushl  -0x10(%ebp)
80104ed2:	50                   	push   %eax
80104ed3:	6a 01                	push   $0x1
80104ed5:	e8 96 fd ff ff       	call   80104c70 <argptr>
80104eda:	83 c4 10             	add    $0x10,%esp
80104edd:	85 c0                	test   %eax,%eax
80104edf:	78 1f                	js     80104f00 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104ee1:	83 ec 04             	sub    $0x4,%esp
80104ee4:	ff 75 f0             	pushl  -0x10(%ebp)
80104ee7:	ff 75 f4             	pushl  -0xc(%ebp)
80104eea:	ff 75 ec             	pushl  -0x14(%ebp)
80104eed:	e8 fe c0 ff ff       	call   80100ff0 <filewrite>
80104ef2:	83 c4 10             	add    $0x10,%esp
}
80104ef5:	c9                   	leave  
80104ef6:	c3                   	ret    
80104ef7:	89 f6                	mov    %esi,%esi
80104ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104f00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f05:	c9                   	leave  
80104f06:	c3                   	ret    
80104f07:	89 f6                	mov    %esi,%esi
80104f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f10 <sys_close>:

int
sys_close(void)
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104f16:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104f19:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f1c:	e8 4f fe ff ff       	call   80104d70 <argfd.constprop.0>
80104f21:	85 c0                	test   %eax,%eax
80104f23:	78 2b                	js     80104f50 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80104f25:	e8 56 ec ff ff       	call   80103b80 <myproc>
80104f2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104f2d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104f30:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104f37:	00 
  fileclose(f);
80104f38:	ff 75 f4             	pushl  -0xc(%ebp)
80104f3b:	e8 00 bf ff ff       	call   80100e40 <fileclose>
  return 0;
80104f40:	83 c4 10             	add    $0x10,%esp
80104f43:	31 c0                	xor    %eax,%eax
}
80104f45:	c9                   	leave  
80104f46:	c3                   	ret    
80104f47:	89 f6                	mov    %esi,%esi
80104f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f55:	c9                   	leave  
80104f56:	c3                   	ret    
80104f57:	89 f6                	mov    %esi,%esi
80104f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f60 <sys_fstat>:

int
sys_fstat(void)
{
80104f60:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f61:	31 c0                	xor    %eax,%eax
{
80104f63:	89 e5                	mov    %esp,%ebp
80104f65:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f68:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104f6b:	e8 00 fe ff ff       	call   80104d70 <argfd.constprop.0>
80104f70:	85 c0                	test   %eax,%eax
80104f72:	78 2c                	js     80104fa0 <sys_fstat+0x40>
80104f74:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f77:	83 ec 04             	sub    $0x4,%esp
80104f7a:	6a 14                	push   $0x14
80104f7c:	50                   	push   %eax
80104f7d:	6a 01                	push   $0x1
80104f7f:	e8 ec fc ff ff       	call   80104c70 <argptr>
80104f84:	83 c4 10             	add    $0x10,%esp
80104f87:	85 c0                	test   %eax,%eax
80104f89:	78 15                	js     80104fa0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80104f8b:	83 ec 08             	sub    $0x8,%esp
80104f8e:	ff 75 f4             	pushl  -0xc(%ebp)
80104f91:	ff 75 f0             	pushl  -0x10(%ebp)
80104f94:	e8 77 bf ff ff       	call   80100f10 <filestat>
80104f99:	83 c4 10             	add    $0x10,%esp
}
80104f9c:	c9                   	leave  
80104f9d:	c3                   	ret    
80104f9e:	66 90                	xchg   %ax,%ax
    return -1;
80104fa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fa5:	c9                   	leave  
80104fa6:	c3                   	ret    
80104fa7:	89 f6                	mov    %esi,%esi
80104fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fb0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	57                   	push   %edi
80104fb4:	56                   	push   %esi
80104fb5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104fb6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104fb9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104fbc:	50                   	push   %eax
80104fbd:	6a 00                	push   $0x0
80104fbf:	e8 0c fd ff ff       	call   80104cd0 <argstr>
80104fc4:	83 c4 10             	add    $0x10,%esp
80104fc7:	85 c0                	test   %eax,%eax
80104fc9:	0f 88 fb 00 00 00    	js     801050ca <sys_link+0x11a>
80104fcf:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104fd2:	83 ec 08             	sub    $0x8,%esp
80104fd5:	50                   	push   %eax
80104fd6:	6a 01                	push   $0x1
80104fd8:	e8 f3 fc ff ff       	call   80104cd0 <argstr>
80104fdd:	83 c4 10             	add    $0x10,%esp
80104fe0:	85 c0                	test   %eax,%eax
80104fe2:	0f 88 e2 00 00 00    	js     801050ca <sys_link+0x11a>
    return -1;

  begin_op();
80104fe8:	e8 53 df ff ff       	call   80102f40 <begin_op>
  if((ip = namei(old)) == 0){
80104fed:	83 ec 0c             	sub    $0xc,%esp
80104ff0:	ff 75 d4             	pushl  -0x2c(%ebp)
80104ff3:	e8 f8 ce ff ff       	call   80101ef0 <namei>
80104ff8:	83 c4 10             	add    $0x10,%esp
80104ffb:	85 c0                	test   %eax,%eax
80104ffd:	89 c3                	mov    %eax,%ebx
80104fff:	0f 84 ea 00 00 00    	je     801050ef <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
80105005:	83 ec 0c             	sub    $0xc,%esp
80105008:	50                   	push   %eax
80105009:	e8 82 c6 ff ff       	call   80101690 <ilock>
  if(ip->type == T_DIR){
8010500e:	83 c4 10             	add    $0x10,%esp
80105011:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105016:	0f 84 bb 00 00 00    	je     801050d7 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010501c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105021:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105024:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105027:	53                   	push   %ebx
80105028:	e8 b3 c5 ff ff       	call   801015e0 <iupdate>
  iunlock(ip);
8010502d:	89 1c 24             	mov    %ebx,(%esp)
80105030:	e8 3b c7 ff ff       	call   80101770 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105035:	58                   	pop    %eax
80105036:	5a                   	pop    %edx
80105037:	57                   	push   %edi
80105038:	ff 75 d0             	pushl  -0x30(%ebp)
8010503b:	e8 d0 ce ff ff       	call   80101f10 <nameiparent>
80105040:	83 c4 10             	add    $0x10,%esp
80105043:	85 c0                	test   %eax,%eax
80105045:	89 c6                	mov    %eax,%esi
80105047:	74 5b                	je     801050a4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105049:	83 ec 0c             	sub    $0xc,%esp
8010504c:	50                   	push   %eax
8010504d:	e8 3e c6 ff ff       	call   80101690 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105052:	83 c4 10             	add    $0x10,%esp
80105055:	8b 03                	mov    (%ebx),%eax
80105057:	39 06                	cmp    %eax,(%esi)
80105059:	75 3d                	jne    80105098 <sys_link+0xe8>
8010505b:	83 ec 04             	sub    $0x4,%esp
8010505e:	ff 73 04             	pushl  0x4(%ebx)
80105061:	57                   	push   %edi
80105062:	56                   	push   %esi
80105063:	e8 c8 cd ff ff       	call   80101e30 <dirlink>
80105068:	83 c4 10             	add    $0x10,%esp
8010506b:	85 c0                	test   %eax,%eax
8010506d:	78 29                	js     80105098 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010506f:	83 ec 0c             	sub    $0xc,%esp
80105072:	56                   	push   %esi
80105073:	e8 a8 c8 ff ff       	call   80101920 <iunlockput>
  iput(ip);
80105078:	89 1c 24             	mov    %ebx,(%esp)
8010507b:	e8 40 c7 ff ff       	call   801017c0 <iput>

  end_op();
80105080:	e8 2b df ff ff       	call   80102fb0 <end_op>

  return 0;
80105085:	83 c4 10             	add    $0x10,%esp
80105088:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010508a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010508d:	5b                   	pop    %ebx
8010508e:	5e                   	pop    %esi
8010508f:	5f                   	pop    %edi
80105090:	5d                   	pop    %ebp
80105091:	c3                   	ret    
80105092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105098:	83 ec 0c             	sub    $0xc,%esp
8010509b:	56                   	push   %esi
8010509c:	e8 7f c8 ff ff       	call   80101920 <iunlockput>
    goto bad;
801050a1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801050a4:	83 ec 0c             	sub    $0xc,%esp
801050a7:	53                   	push   %ebx
801050a8:	e8 e3 c5 ff ff       	call   80101690 <ilock>
  ip->nlink--;
801050ad:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801050b2:	89 1c 24             	mov    %ebx,(%esp)
801050b5:	e8 26 c5 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
801050ba:	89 1c 24             	mov    %ebx,(%esp)
801050bd:	e8 5e c8 ff ff       	call   80101920 <iunlockput>
  end_op();
801050c2:	e8 e9 de ff ff       	call   80102fb0 <end_op>
  return -1;
801050c7:	83 c4 10             	add    $0x10,%esp
}
801050ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801050cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050d2:	5b                   	pop    %ebx
801050d3:	5e                   	pop    %esi
801050d4:	5f                   	pop    %edi
801050d5:	5d                   	pop    %ebp
801050d6:	c3                   	ret    
    iunlockput(ip);
801050d7:	83 ec 0c             	sub    $0xc,%esp
801050da:	53                   	push   %ebx
801050db:	e8 40 c8 ff ff       	call   80101920 <iunlockput>
    end_op();
801050e0:	e8 cb de ff ff       	call   80102fb0 <end_op>
    return -1;
801050e5:	83 c4 10             	add    $0x10,%esp
801050e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050ed:	eb 9b                	jmp    8010508a <sys_link+0xda>
    end_op();
801050ef:	e8 bc de ff ff       	call   80102fb0 <end_op>
    return -1;
801050f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050f9:	eb 8f                	jmp    8010508a <sys_link+0xda>
801050fb:	90                   	nop
801050fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105100 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	57                   	push   %edi
80105104:	56                   	push   %esi
80105105:	53                   	push   %ebx
80105106:	83 ec 1c             	sub    $0x1c,%esp
80105109:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010510c:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105110:	76 3e                	jbe    80105150 <isdirempty+0x50>
80105112:	bb 20 00 00 00       	mov    $0x20,%ebx
80105117:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010511a:	eb 0c                	jmp    80105128 <isdirempty+0x28>
8010511c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105120:	83 c3 10             	add    $0x10,%ebx
80105123:	3b 5e 58             	cmp    0x58(%esi),%ebx
80105126:	73 28                	jae    80105150 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105128:	6a 10                	push   $0x10
8010512a:	53                   	push   %ebx
8010512b:	57                   	push   %edi
8010512c:	56                   	push   %esi
8010512d:	e8 3e c8 ff ff       	call   80101970 <readi>
80105132:	83 c4 10             	add    $0x10,%esp
80105135:	83 f8 10             	cmp    $0x10,%eax
80105138:	75 23                	jne    8010515d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010513a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010513f:	74 df                	je     80105120 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105141:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105144:	31 c0                	xor    %eax,%eax
}
80105146:	5b                   	pop    %ebx
80105147:	5e                   	pop    %esi
80105148:	5f                   	pop    %edi
80105149:	5d                   	pop    %ebp
8010514a:	c3                   	ret    
8010514b:	90                   	nop
8010514c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105150:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105153:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105158:	5b                   	pop    %ebx
80105159:	5e                   	pop    %esi
8010515a:	5f                   	pop    %edi
8010515b:	5d                   	pop    %ebp
8010515c:	c3                   	ret    
      panic("isdirempty: readi");
8010515d:	83 ec 0c             	sub    $0xc,%esp
80105160:	68 40 7d 10 80       	push   $0x80107d40
80105165:	e8 26 b2 ff ff       	call   80100390 <panic>
8010516a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105170 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	57                   	push   %edi
80105174:	56                   	push   %esi
80105175:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105176:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105179:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010517c:	50                   	push   %eax
8010517d:	6a 00                	push   $0x0
8010517f:	e8 4c fb ff ff       	call   80104cd0 <argstr>
80105184:	83 c4 10             	add    $0x10,%esp
80105187:	85 c0                	test   %eax,%eax
80105189:	0f 88 51 01 00 00    	js     801052e0 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010518f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105192:	e8 a9 dd ff ff       	call   80102f40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105197:	83 ec 08             	sub    $0x8,%esp
8010519a:	53                   	push   %ebx
8010519b:	ff 75 c0             	pushl  -0x40(%ebp)
8010519e:	e8 6d cd ff ff       	call   80101f10 <nameiparent>
801051a3:	83 c4 10             	add    $0x10,%esp
801051a6:	85 c0                	test   %eax,%eax
801051a8:	89 c6                	mov    %eax,%esi
801051aa:	0f 84 37 01 00 00    	je     801052e7 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
801051b0:	83 ec 0c             	sub    $0xc,%esp
801051b3:	50                   	push   %eax
801051b4:	e8 d7 c4 ff ff       	call   80101690 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801051b9:	58                   	pop    %eax
801051ba:	5a                   	pop    %edx
801051bb:	68 fd 76 10 80       	push   $0x801076fd
801051c0:	53                   	push   %ebx
801051c1:	e8 da c9 ff ff       	call   80101ba0 <namecmp>
801051c6:	83 c4 10             	add    $0x10,%esp
801051c9:	85 c0                	test   %eax,%eax
801051cb:	0f 84 d7 00 00 00    	je     801052a8 <sys_unlink+0x138>
801051d1:	83 ec 08             	sub    $0x8,%esp
801051d4:	68 fc 76 10 80       	push   $0x801076fc
801051d9:	53                   	push   %ebx
801051da:	e8 c1 c9 ff ff       	call   80101ba0 <namecmp>
801051df:	83 c4 10             	add    $0x10,%esp
801051e2:	85 c0                	test   %eax,%eax
801051e4:	0f 84 be 00 00 00    	je     801052a8 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801051ea:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801051ed:	83 ec 04             	sub    $0x4,%esp
801051f0:	50                   	push   %eax
801051f1:	53                   	push   %ebx
801051f2:	56                   	push   %esi
801051f3:	e8 c8 c9 ff ff       	call   80101bc0 <dirlookup>
801051f8:	83 c4 10             	add    $0x10,%esp
801051fb:	85 c0                	test   %eax,%eax
801051fd:	89 c3                	mov    %eax,%ebx
801051ff:	0f 84 a3 00 00 00    	je     801052a8 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
80105205:	83 ec 0c             	sub    $0xc,%esp
80105208:	50                   	push   %eax
80105209:	e8 82 c4 ff ff       	call   80101690 <ilock>

  if(ip->nlink < 1)
8010520e:	83 c4 10             	add    $0x10,%esp
80105211:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105216:	0f 8e e4 00 00 00    	jle    80105300 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
8010521c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105221:	74 65                	je     80105288 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105223:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105226:	83 ec 04             	sub    $0x4,%esp
80105229:	6a 10                	push   $0x10
8010522b:	6a 00                	push   $0x0
8010522d:	57                   	push   %edi
8010522e:	e8 ed f6 ff ff       	call   80104920 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105233:	6a 10                	push   $0x10
80105235:	ff 75 c4             	pushl  -0x3c(%ebp)
80105238:	57                   	push   %edi
80105239:	56                   	push   %esi
8010523a:	e8 31 c8 ff ff       	call   80101a70 <writei>
8010523f:	83 c4 20             	add    $0x20,%esp
80105242:	83 f8 10             	cmp    $0x10,%eax
80105245:	0f 85 a8 00 00 00    	jne    801052f3 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010524b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105250:	74 6e                	je     801052c0 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105252:	83 ec 0c             	sub    $0xc,%esp
80105255:	56                   	push   %esi
80105256:	e8 c5 c6 ff ff       	call   80101920 <iunlockput>

  ip->nlink--;
8010525b:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105260:	89 1c 24             	mov    %ebx,(%esp)
80105263:	e8 78 c3 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
80105268:	89 1c 24             	mov    %ebx,(%esp)
8010526b:	e8 b0 c6 ff ff       	call   80101920 <iunlockput>

  end_op();
80105270:	e8 3b dd ff ff       	call   80102fb0 <end_op>

  return 0;
80105275:	83 c4 10             	add    $0x10,%esp
80105278:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010527a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010527d:	5b                   	pop    %ebx
8010527e:	5e                   	pop    %esi
8010527f:	5f                   	pop    %edi
80105280:	5d                   	pop    %ebp
80105281:	c3                   	ret    
80105282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105288:	83 ec 0c             	sub    $0xc,%esp
8010528b:	53                   	push   %ebx
8010528c:	e8 6f fe ff ff       	call   80105100 <isdirempty>
80105291:	83 c4 10             	add    $0x10,%esp
80105294:	85 c0                	test   %eax,%eax
80105296:	75 8b                	jne    80105223 <sys_unlink+0xb3>
    iunlockput(ip);
80105298:	83 ec 0c             	sub    $0xc,%esp
8010529b:	53                   	push   %ebx
8010529c:	e8 7f c6 ff ff       	call   80101920 <iunlockput>
    goto bad;
801052a1:	83 c4 10             	add    $0x10,%esp
801052a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
801052a8:	83 ec 0c             	sub    $0xc,%esp
801052ab:	56                   	push   %esi
801052ac:	e8 6f c6 ff ff       	call   80101920 <iunlockput>
  end_op();
801052b1:	e8 fa dc ff ff       	call   80102fb0 <end_op>
  return -1;
801052b6:	83 c4 10             	add    $0x10,%esp
801052b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052be:	eb ba                	jmp    8010527a <sys_unlink+0x10a>
    dp->nlink--;
801052c0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801052c5:	83 ec 0c             	sub    $0xc,%esp
801052c8:	56                   	push   %esi
801052c9:	e8 12 c3 ff ff       	call   801015e0 <iupdate>
801052ce:	83 c4 10             	add    $0x10,%esp
801052d1:	e9 7c ff ff ff       	jmp    80105252 <sys_unlink+0xe2>
801052d6:	8d 76 00             	lea    0x0(%esi),%esi
801052d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801052e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052e5:	eb 93                	jmp    8010527a <sys_unlink+0x10a>
    end_op();
801052e7:	e8 c4 dc ff ff       	call   80102fb0 <end_op>
    return -1;
801052ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052f1:	eb 87                	jmp    8010527a <sys_unlink+0x10a>
    panic("unlink: writei");
801052f3:	83 ec 0c             	sub    $0xc,%esp
801052f6:	68 11 77 10 80       	push   $0x80107711
801052fb:	e8 90 b0 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105300:	83 ec 0c             	sub    $0xc,%esp
80105303:	68 ff 76 10 80       	push   $0x801076ff
80105308:	e8 83 b0 ff ff       	call   80100390 <panic>
8010530d:	8d 76 00             	lea    0x0(%esi),%esi

80105310 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	57                   	push   %edi
80105314:	56                   	push   %esi
80105315:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105316:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105319:	83 ec 44             	sub    $0x44,%esp
8010531c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010531f:	8b 55 10             	mov    0x10(%ebp),%edx
80105322:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105325:	56                   	push   %esi
80105326:	ff 75 08             	pushl  0x8(%ebp)
{
80105329:	89 45 c4             	mov    %eax,-0x3c(%ebp)
8010532c:	89 55 c0             	mov    %edx,-0x40(%ebp)
8010532f:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105332:	e8 d9 cb ff ff       	call   80101f10 <nameiparent>
80105337:	83 c4 10             	add    $0x10,%esp
8010533a:	85 c0                	test   %eax,%eax
8010533c:	0f 84 4e 01 00 00    	je     80105490 <create+0x180>
    return 0;
  ilock(dp);
80105342:	83 ec 0c             	sub    $0xc,%esp
80105345:	89 c3                	mov    %eax,%ebx
80105347:	50                   	push   %eax
80105348:	e8 43 c3 ff ff       	call   80101690 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
8010534d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105350:	83 c4 0c             	add    $0xc,%esp
80105353:	50                   	push   %eax
80105354:	56                   	push   %esi
80105355:	53                   	push   %ebx
80105356:	e8 65 c8 ff ff       	call   80101bc0 <dirlookup>
8010535b:	83 c4 10             	add    $0x10,%esp
8010535e:	85 c0                	test   %eax,%eax
80105360:	89 c7                	mov    %eax,%edi
80105362:	74 3c                	je     801053a0 <create+0x90>
    iunlockput(dp);
80105364:	83 ec 0c             	sub    $0xc,%esp
80105367:	53                   	push   %ebx
80105368:	e8 b3 c5 ff ff       	call   80101920 <iunlockput>
    ilock(ip);
8010536d:	89 3c 24             	mov    %edi,(%esp)
80105370:	e8 1b c3 ff ff       	call   80101690 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105375:	83 c4 10             	add    $0x10,%esp
80105378:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
8010537d:	0f 85 9d 00 00 00    	jne    80105420 <create+0x110>
80105383:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105388:	0f 85 92 00 00 00    	jne    80105420 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010538e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105391:	89 f8                	mov    %edi,%eax
80105393:	5b                   	pop    %ebx
80105394:	5e                   	pop    %esi
80105395:	5f                   	pop    %edi
80105396:	5d                   	pop    %ebp
80105397:	c3                   	ret    
80105398:	90                   	nop
80105399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
801053a0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801053a4:	83 ec 08             	sub    $0x8,%esp
801053a7:	50                   	push   %eax
801053a8:	ff 33                	pushl  (%ebx)
801053aa:	e8 71 c1 ff ff       	call   80101520 <ialloc>
801053af:	83 c4 10             	add    $0x10,%esp
801053b2:	85 c0                	test   %eax,%eax
801053b4:	89 c7                	mov    %eax,%edi
801053b6:	0f 84 e8 00 00 00    	je     801054a4 <create+0x194>
  ilock(ip);
801053bc:	83 ec 0c             	sub    $0xc,%esp
801053bf:	50                   	push   %eax
801053c0:	e8 cb c2 ff ff       	call   80101690 <ilock>
  ip->major = major;
801053c5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801053c9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
801053cd:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801053d1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
801053d5:	b8 01 00 00 00       	mov    $0x1,%eax
801053da:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
801053de:	89 3c 24             	mov    %edi,(%esp)
801053e1:	e8 fa c1 ff ff       	call   801015e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801053e6:	83 c4 10             	add    $0x10,%esp
801053e9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801053ee:	74 50                	je     80105440 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
801053f0:	83 ec 04             	sub    $0x4,%esp
801053f3:	ff 77 04             	pushl  0x4(%edi)
801053f6:	56                   	push   %esi
801053f7:	53                   	push   %ebx
801053f8:	e8 33 ca ff ff       	call   80101e30 <dirlink>
801053fd:	83 c4 10             	add    $0x10,%esp
80105400:	85 c0                	test   %eax,%eax
80105402:	0f 88 8f 00 00 00    	js     80105497 <create+0x187>
  iunlockput(dp);
80105408:	83 ec 0c             	sub    $0xc,%esp
8010540b:	53                   	push   %ebx
8010540c:	e8 0f c5 ff ff       	call   80101920 <iunlockput>
  return ip;
80105411:	83 c4 10             	add    $0x10,%esp
}
80105414:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105417:	89 f8                	mov    %edi,%eax
80105419:	5b                   	pop    %ebx
8010541a:	5e                   	pop    %esi
8010541b:	5f                   	pop    %edi
8010541c:	5d                   	pop    %ebp
8010541d:	c3                   	ret    
8010541e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105420:	83 ec 0c             	sub    $0xc,%esp
80105423:	57                   	push   %edi
    return 0;
80105424:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105426:	e8 f5 c4 ff ff       	call   80101920 <iunlockput>
    return 0;
8010542b:	83 c4 10             	add    $0x10,%esp
}
8010542e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105431:	89 f8                	mov    %edi,%eax
80105433:	5b                   	pop    %ebx
80105434:	5e                   	pop    %esi
80105435:	5f                   	pop    %edi
80105436:	5d                   	pop    %ebp
80105437:	c3                   	ret    
80105438:	90                   	nop
80105439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105440:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105445:	83 ec 0c             	sub    $0xc,%esp
80105448:	53                   	push   %ebx
80105449:	e8 92 c1 ff ff       	call   801015e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010544e:	83 c4 0c             	add    $0xc,%esp
80105451:	ff 77 04             	pushl  0x4(%edi)
80105454:	68 fd 76 10 80       	push   $0x801076fd
80105459:	57                   	push   %edi
8010545a:	e8 d1 c9 ff ff       	call   80101e30 <dirlink>
8010545f:	83 c4 10             	add    $0x10,%esp
80105462:	85 c0                	test   %eax,%eax
80105464:	78 1c                	js     80105482 <create+0x172>
80105466:	83 ec 04             	sub    $0x4,%esp
80105469:	ff 73 04             	pushl  0x4(%ebx)
8010546c:	68 fc 76 10 80       	push   $0x801076fc
80105471:	57                   	push   %edi
80105472:	e8 b9 c9 ff ff       	call   80101e30 <dirlink>
80105477:	83 c4 10             	add    $0x10,%esp
8010547a:	85 c0                	test   %eax,%eax
8010547c:	0f 89 6e ff ff ff    	jns    801053f0 <create+0xe0>
      panic("create dots");
80105482:	83 ec 0c             	sub    $0xc,%esp
80105485:	68 61 7d 10 80       	push   $0x80107d61
8010548a:	e8 01 af ff ff       	call   80100390 <panic>
8010548f:	90                   	nop
    return 0;
80105490:	31 ff                	xor    %edi,%edi
80105492:	e9 f7 fe ff ff       	jmp    8010538e <create+0x7e>
    panic("create: dirlink");
80105497:	83 ec 0c             	sub    $0xc,%esp
8010549a:	68 6d 7d 10 80       	push   $0x80107d6d
8010549f:	e8 ec ae ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801054a4:	83 ec 0c             	sub    $0xc,%esp
801054a7:	68 52 7d 10 80       	push   $0x80107d52
801054ac:	e8 df ae ff ff       	call   80100390 <panic>
801054b1:	eb 0d                	jmp    801054c0 <sys_open>
801054b3:	90                   	nop
801054b4:	90                   	nop
801054b5:	90                   	nop
801054b6:	90                   	nop
801054b7:	90                   	nop
801054b8:	90                   	nop
801054b9:	90                   	nop
801054ba:	90                   	nop
801054bb:	90                   	nop
801054bc:	90                   	nop
801054bd:	90                   	nop
801054be:	90                   	nop
801054bf:	90                   	nop

801054c0 <sys_open>:

int
sys_open(void)
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	57                   	push   %edi
801054c4:	56                   	push   %esi
801054c5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054c6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801054c9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054cc:	50                   	push   %eax
801054cd:	6a 00                	push   $0x0
801054cf:	e8 fc f7 ff ff       	call   80104cd0 <argstr>
801054d4:	83 c4 10             	add    $0x10,%esp
801054d7:	85 c0                	test   %eax,%eax
801054d9:	0f 88 1d 01 00 00    	js     801055fc <sys_open+0x13c>
801054df:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054e2:	83 ec 08             	sub    $0x8,%esp
801054e5:	50                   	push   %eax
801054e6:	6a 01                	push   $0x1
801054e8:	e8 33 f7 ff ff       	call   80104c20 <argint>
801054ed:	83 c4 10             	add    $0x10,%esp
801054f0:	85 c0                	test   %eax,%eax
801054f2:	0f 88 04 01 00 00    	js     801055fc <sys_open+0x13c>
    return -1;

  begin_op();
801054f8:	e8 43 da ff ff       	call   80102f40 <begin_op>

  if(omode & O_CREATE){
801054fd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105501:	0f 85 a9 00 00 00    	jne    801055b0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105507:	83 ec 0c             	sub    $0xc,%esp
8010550a:	ff 75 e0             	pushl  -0x20(%ebp)
8010550d:	e8 de c9 ff ff       	call   80101ef0 <namei>
80105512:	83 c4 10             	add    $0x10,%esp
80105515:	85 c0                	test   %eax,%eax
80105517:	89 c6                	mov    %eax,%esi
80105519:	0f 84 ac 00 00 00    	je     801055cb <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
8010551f:	83 ec 0c             	sub    $0xc,%esp
80105522:	50                   	push   %eax
80105523:	e8 68 c1 ff ff       	call   80101690 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105528:	83 c4 10             	add    $0x10,%esp
8010552b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105530:	0f 84 aa 00 00 00    	je     801055e0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105536:	e8 45 b8 ff ff       	call   80100d80 <filealloc>
8010553b:	85 c0                	test   %eax,%eax
8010553d:	89 c7                	mov    %eax,%edi
8010553f:	0f 84 a6 00 00 00    	je     801055eb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105545:	e8 36 e6 ff ff       	call   80103b80 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010554a:	31 db                	xor    %ebx,%ebx
8010554c:	eb 0e                	jmp    8010555c <sys_open+0x9c>
8010554e:	66 90                	xchg   %ax,%ax
80105550:	83 c3 01             	add    $0x1,%ebx
80105553:	83 fb 10             	cmp    $0x10,%ebx
80105556:	0f 84 ac 00 00 00    	je     80105608 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010555c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105560:	85 d2                	test   %edx,%edx
80105562:	75 ec                	jne    80105550 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105564:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105567:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010556b:	56                   	push   %esi
8010556c:	e8 ff c1 ff ff       	call   80101770 <iunlock>
  end_op();
80105571:	e8 3a da ff ff       	call   80102fb0 <end_op>

  f->type = FD_INODE;
80105576:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010557c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010557f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105582:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105585:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010558c:	89 d0                	mov    %edx,%eax
8010558e:	f7 d0                	not    %eax
80105590:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105593:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105596:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105599:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010559d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055a0:	89 d8                	mov    %ebx,%eax
801055a2:	5b                   	pop    %ebx
801055a3:	5e                   	pop    %esi
801055a4:	5f                   	pop    %edi
801055a5:	5d                   	pop    %ebp
801055a6:	c3                   	ret    
801055a7:	89 f6                	mov    %esi,%esi
801055a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
801055b0:	6a 00                	push   $0x0
801055b2:	6a 00                	push   $0x0
801055b4:	6a 02                	push   $0x2
801055b6:	ff 75 e0             	pushl  -0x20(%ebp)
801055b9:	e8 52 fd ff ff       	call   80105310 <create>
    if(ip == 0){
801055be:	83 c4 10             	add    $0x10,%esp
801055c1:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801055c3:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801055c5:	0f 85 6b ff ff ff    	jne    80105536 <sys_open+0x76>
      end_op();
801055cb:	e8 e0 d9 ff ff       	call   80102fb0 <end_op>
      return -1;
801055d0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055d5:	eb c6                	jmp    8010559d <sys_open+0xdd>
801055d7:	89 f6                	mov    %esi,%esi
801055d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
801055e0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801055e3:	85 c9                	test   %ecx,%ecx
801055e5:	0f 84 4b ff ff ff    	je     80105536 <sys_open+0x76>
    iunlockput(ip);
801055eb:	83 ec 0c             	sub    $0xc,%esp
801055ee:	56                   	push   %esi
801055ef:	e8 2c c3 ff ff       	call   80101920 <iunlockput>
    end_op();
801055f4:	e8 b7 d9 ff ff       	call   80102fb0 <end_op>
    return -1;
801055f9:	83 c4 10             	add    $0x10,%esp
801055fc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105601:	eb 9a                	jmp    8010559d <sys_open+0xdd>
80105603:	90                   	nop
80105604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105608:	83 ec 0c             	sub    $0xc,%esp
8010560b:	57                   	push   %edi
8010560c:	e8 2f b8 ff ff       	call   80100e40 <fileclose>
80105611:	83 c4 10             	add    $0x10,%esp
80105614:	eb d5                	jmp    801055eb <sys_open+0x12b>
80105616:	8d 76 00             	lea    0x0(%esi),%esi
80105619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105620 <sys_mkdir>:

int
sys_mkdir(void)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105626:	e8 15 d9 ff ff       	call   80102f40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010562b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010562e:	83 ec 08             	sub    $0x8,%esp
80105631:	50                   	push   %eax
80105632:	6a 00                	push   $0x0
80105634:	e8 97 f6 ff ff       	call   80104cd0 <argstr>
80105639:	83 c4 10             	add    $0x10,%esp
8010563c:	85 c0                	test   %eax,%eax
8010563e:	78 30                	js     80105670 <sys_mkdir+0x50>
80105640:	6a 00                	push   $0x0
80105642:	6a 00                	push   $0x0
80105644:	6a 01                	push   $0x1
80105646:	ff 75 f4             	pushl  -0xc(%ebp)
80105649:	e8 c2 fc ff ff       	call   80105310 <create>
8010564e:	83 c4 10             	add    $0x10,%esp
80105651:	85 c0                	test   %eax,%eax
80105653:	74 1b                	je     80105670 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105655:	83 ec 0c             	sub    $0xc,%esp
80105658:	50                   	push   %eax
80105659:	e8 c2 c2 ff ff       	call   80101920 <iunlockput>
  end_op();
8010565e:	e8 4d d9 ff ff       	call   80102fb0 <end_op>
  return 0;
80105663:	83 c4 10             	add    $0x10,%esp
80105666:	31 c0                	xor    %eax,%eax
}
80105668:	c9                   	leave  
80105669:	c3                   	ret    
8010566a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105670:	e8 3b d9 ff ff       	call   80102fb0 <end_op>
    return -1;
80105675:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010567a:	c9                   	leave  
8010567b:	c3                   	ret    
8010567c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105680 <sys_mknod>:

int
sys_mknod(void)
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105686:	e8 b5 d8 ff ff       	call   80102f40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010568b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010568e:	83 ec 08             	sub    $0x8,%esp
80105691:	50                   	push   %eax
80105692:	6a 00                	push   $0x0
80105694:	e8 37 f6 ff ff       	call   80104cd0 <argstr>
80105699:	83 c4 10             	add    $0x10,%esp
8010569c:	85 c0                	test   %eax,%eax
8010569e:	78 60                	js     80105700 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801056a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056a3:	83 ec 08             	sub    $0x8,%esp
801056a6:	50                   	push   %eax
801056a7:	6a 01                	push   $0x1
801056a9:	e8 72 f5 ff ff       	call   80104c20 <argint>
  if((argstr(0, &path)) < 0 ||
801056ae:	83 c4 10             	add    $0x10,%esp
801056b1:	85 c0                	test   %eax,%eax
801056b3:	78 4b                	js     80105700 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801056b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056b8:	83 ec 08             	sub    $0x8,%esp
801056bb:	50                   	push   %eax
801056bc:	6a 02                	push   $0x2
801056be:	e8 5d f5 ff ff       	call   80104c20 <argint>
     argint(1, &major) < 0 ||
801056c3:	83 c4 10             	add    $0x10,%esp
801056c6:	85 c0                	test   %eax,%eax
801056c8:	78 36                	js     80105700 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801056ca:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801056ce:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
801056cf:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
801056d3:	50                   	push   %eax
801056d4:	6a 03                	push   $0x3
801056d6:	ff 75 ec             	pushl  -0x14(%ebp)
801056d9:	e8 32 fc ff ff       	call   80105310 <create>
801056de:	83 c4 10             	add    $0x10,%esp
801056e1:	85 c0                	test   %eax,%eax
801056e3:	74 1b                	je     80105700 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056e5:	83 ec 0c             	sub    $0xc,%esp
801056e8:	50                   	push   %eax
801056e9:	e8 32 c2 ff ff       	call   80101920 <iunlockput>
  end_op();
801056ee:	e8 bd d8 ff ff       	call   80102fb0 <end_op>
  return 0;
801056f3:	83 c4 10             	add    $0x10,%esp
801056f6:	31 c0                	xor    %eax,%eax
}
801056f8:	c9                   	leave  
801056f9:	c3                   	ret    
801056fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105700:	e8 ab d8 ff ff       	call   80102fb0 <end_op>
    return -1;
80105705:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010570a:	c9                   	leave  
8010570b:	c3                   	ret    
8010570c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105710 <sys_chdir>:

int
sys_chdir(void)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	56                   	push   %esi
80105714:	53                   	push   %ebx
80105715:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105718:	e8 63 e4 ff ff       	call   80103b80 <myproc>
8010571d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010571f:	e8 1c d8 ff ff       	call   80102f40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105724:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105727:	83 ec 08             	sub    $0x8,%esp
8010572a:	50                   	push   %eax
8010572b:	6a 00                	push   $0x0
8010572d:	e8 9e f5 ff ff       	call   80104cd0 <argstr>
80105732:	83 c4 10             	add    $0x10,%esp
80105735:	85 c0                	test   %eax,%eax
80105737:	78 77                	js     801057b0 <sys_chdir+0xa0>
80105739:	83 ec 0c             	sub    $0xc,%esp
8010573c:	ff 75 f4             	pushl  -0xc(%ebp)
8010573f:	e8 ac c7 ff ff       	call   80101ef0 <namei>
80105744:	83 c4 10             	add    $0x10,%esp
80105747:	85 c0                	test   %eax,%eax
80105749:	89 c3                	mov    %eax,%ebx
8010574b:	74 63                	je     801057b0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010574d:	83 ec 0c             	sub    $0xc,%esp
80105750:	50                   	push   %eax
80105751:	e8 3a bf ff ff       	call   80101690 <ilock>
  if(ip->type != T_DIR){
80105756:	83 c4 10             	add    $0x10,%esp
80105759:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010575e:	75 30                	jne    80105790 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105760:	83 ec 0c             	sub    $0xc,%esp
80105763:	53                   	push   %ebx
80105764:	e8 07 c0 ff ff       	call   80101770 <iunlock>
  iput(curproc->cwd);
80105769:	58                   	pop    %eax
8010576a:	ff 76 68             	pushl  0x68(%esi)
8010576d:	e8 4e c0 ff ff       	call   801017c0 <iput>
  end_op();
80105772:	e8 39 d8 ff ff       	call   80102fb0 <end_op>
  curproc->cwd = ip;
80105777:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010577a:	83 c4 10             	add    $0x10,%esp
8010577d:	31 c0                	xor    %eax,%eax
}
8010577f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105782:	5b                   	pop    %ebx
80105783:	5e                   	pop    %esi
80105784:	5d                   	pop    %ebp
80105785:	c3                   	ret    
80105786:	8d 76 00             	lea    0x0(%esi),%esi
80105789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105790:	83 ec 0c             	sub    $0xc,%esp
80105793:	53                   	push   %ebx
80105794:	e8 87 c1 ff ff       	call   80101920 <iunlockput>
    end_op();
80105799:	e8 12 d8 ff ff       	call   80102fb0 <end_op>
    return -1;
8010579e:	83 c4 10             	add    $0x10,%esp
801057a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057a6:	eb d7                	jmp    8010577f <sys_chdir+0x6f>
801057a8:	90                   	nop
801057a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801057b0:	e8 fb d7 ff ff       	call   80102fb0 <end_op>
    return -1;
801057b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ba:	eb c3                	jmp    8010577f <sys_chdir+0x6f>
801057bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057c0 <sys_exec>:

int
sys_exec(void)
{
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	57                   	push   %edi
801057c4:	56                   	push   %esi
801057c5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057c6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801057cc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057d2:	50                   	push   %eax
801057d3:	6a 00                	push   $0x0
801057d5:	e8 f6 f4 ff ff       	call   80104cd0 <argstr>
801057da:	83 c4 10             	add    $0x10,%esp
801057dd:	85 c0                	test   %eax,%eax
801057df:	0f 88 87 00 00 00    	js     8010586c <sys_exec+0xac>
801057e5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801057eb:	83 ec 08             	sub    $0x8,%esp
801057ee:	50                   	push   %eax
801057ef:	6a 01                	push   $0x1
801057f1:	e8 2a f4 ff ff       	call   80104c20 <argint>
801057f6:	83 c4 10             	add    $0x10,%esp
801057f9:	85 c0                	test   %eax,%eax
801057fb:	78 6f                	js     8010586c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801057fd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105803:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105806:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105808:	68 80 00 00 00       	push   $0x80
8010580d:	6a 00                	push   $0x0
8010580f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105815:	50                   	push   %eax
80105816:	e8 05 f1 ff ff       	call   80104920 <memset>
8010581b:	83 c4 10             	add    $0x10,%esp
8010581e:	eb 2c                	jmp    8010584c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105820:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105826:	85 c0                	test   %eax,%eax
80105828:	74 56                	je     80105880 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010582a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105830:	83 ec 08             	sub    $0x8,%esp
80105833:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105836:	52                   	push   %edx
80105837:	50                   	push   %eax
80105838:	e8 73 f3 ff ff       	call   80104bb0 <fetchstr>
8010583d:	83 c4 10             	add    $0x10,%esp
80105840:	85 c0                	test   %eax,%eax
80105842:	78 28                	js     8010586c <sys_exec+0xac>
  for(i=0;; i++){
80105844:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105847:	83 fb 20             	cmp    $0x20,%ebx
8010584a:	74 20                	je     8010586c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010584c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105852:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105859:	83 ec 08             	sub    $0x8,%esp
8010585c:	57                   	push   %edi
8010585d:	01 f0                	add    %esi,%eax
8010585f:	50                   	push   %eax
80105860:	e8 0b f3 ff ff       	call   80104b70 <fetchint>
80105865:	83 c4 10             	add    $0x10,%esp
80105868:	85 c0                	test   %eax,%eax
8010586a:	79 b4                	jns    80105820 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010586c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010586f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105874:	5b                   	pop    %ebx
80105875:	5e                   	pop    %esi
80105876:	5f                   	pop    %edi
80105877:	5d                   	pop    %ebp
80105878:	c3                   	ret    
80105879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105880:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105886:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105889:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105890:	00 00 00 00 
  return exec(path, argv);
80105894:	50                   	push   %eax
80105895:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010589b:	e8 70 b1 ff ff       	call   80100a10 <exec>
801058a0:	83 c4 10             	add    $0x10,%esp
}
801058a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058a6:	5b                   	pop    %ebx
801058a7:	5e                   	pop    %esi
801058a8:	5f                   	pop    %edi
801058a9:	5d                   	pop    %ebp
801058aa:	c3                   	ret    
801058ab:	90                   	nop
801058ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058b0 <sys_pipe>:

int
sys_pipe(void)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	57                   	push   %edi
801058b4:	56                   	push   %esi
801058b5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058b6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801058b9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058bc:	6a 08                	push   $0x8
801058be:	50                   	push   %eax
801058bf:	6a 00                	push   $0x0
801058c1:	e8 aa f3 ff ff       	call   80104c70 <argptr>
801058c6:	83 c4 10             	add    $0x10,%esp
801058c9:	85 c0                	test   %eax,%eax
801058cb:	0f 88 ae 00 00 00    	js     8010597f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801058d1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058d4:	83 ec 08             	sub    $0x8,%esp
801058d7:	50                   	push   %eax
801058d8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801058db:	50                   	push   %eax
801058dc:	e8 ff dc ff ff       	call   801035e0 <pipealloc>
801058e1:	83 c4 10             	add    $0x10,%esp
801058e4:	85 c0                	test   %eax,%eax
801058e6:	0f 88 93 00 00 00    	js     8010597f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058ec:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801058ef:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801058f1:	e8 8a e2 ff ff       	call   80103b80 <myproc>
801058f6:	eb 10                	jmp    80105908 <sys_pipe+0x58>
801058f8:	90                   	nop
801058f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105900:	83 c3 01             	add    $0x1,%ebx
80105903:	83 fb 10             	cmp    $0x10,%ebx
80105906:	74 60                	je     80105968 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105908:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010590c:	85 f6                	test   %esi,%esi
8010590e:	75 f0                	jne    80105900 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105910:	8d 73 08             	lea    0x8(%ebx),%esi
80105913:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105917:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010591a:	e8 61 e2 ff ff       	call   80103b80 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010591f:	31 d2                	xor    %edx,%edx
80105921:	eb 0d                	jmp    80105930 <sys_pipe+0x80>
80105923:	90                   	nop
80105924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105928:	83 c2 01             	add    $0x1,%edx
8010592b:	83 fa 10             	cmp    $0x10,%edx
8010592e:	74 28                	je     80105958 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105930:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105934:	85 c9                	test   %ecx,%ecx
80105936:	75 f0                	jne    80105928 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105938:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010593c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010593f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105941:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105944:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105947:	31 c0                	xor    %eax,%eax
}
80105949:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010594c:	5b                   	pop    %ebx
8010594d:	5e                   	pop    %esi
8010594e:	5f                   	pop    %edi
8010594f:	5d                   	pop    %ebp
80105950:	c3                   	ret    
80105951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105958:	e8 23 e2 ff ff       	call   80103b80 <myproc>
8010595d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105964:	00 
80105965:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105968:	83 ec 0c             	sub    $0xc,%esp
8010596b:	ff 75 e0             	pushl  -0x20(%ebp)
8010596e:	e8 cd b4 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105973:	58                   	pop    %eax
80105974:	ff 75 e4             	pushl  -0x1c(%ebp)
80105977:	e8 c4 b4 ff ff       	call   80100e40 <fileclose>
    return -1;
8010597c:	83 c4 10             	add    $0x10,%esp
8010597f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105984:	eb c3                	jmp    80105949 <sys_pipe+0x99>
80105986:	66 90                	xchg   %ax,%ax
80105988:	66 90                	xchg   %ax,%ax
8010598a:	66 90                	xchg   %ax,%ax
8010598c:	66 90                	xchg   %ax,%ax
8010598e:	66 90                	xchg   %ax,%ax

80105990 <sys_yield>:
#include "mmu.h"
#include "proc.h"


int sys_yield(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	83 ec 08             	sub    $0x8,%esp
  yield(); 
80105996:	e8 35 e7 ff ff       	call   801040d0 <yield>
  return 0;
}
8010599b:	31 c0                	xor    %eax,%eax
8010599d:	c9                   	leave  
8010599e:	c3                   	ret    
8010599f:	90                   	nop

801059a0 <sys_fork>:

int
sys_fork(void)
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801059a3:	5d                   	pop    %ebp
  return fork();
801059a4:	e9 77 e3 ff ff       	jmp    80103d20 <fork>
801059a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059b0 <sys_exit>:

int
sys_exit(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	83 ec 08             	sub    $0x8,%esp
  exit();
801059b6:	e8 e5 e5 ff ff       	call   80103fa0 <exit>
  return 0;  // not reached
}
801059bb:	31 c0                	xor    %eax,%eax
801059bd:	c9                   	leave  
801059be:	c3                   	ret    
801059bf:	90                   	nop

801059c0 <sys_wait>:

int
sys_wait(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801059c3:	5d                   	pop    %ebp
  return wait();
801059c4:	e9 17 e8 ff ff       	jmp    801041e0 <wait>
801059c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059d0 <sys_kill>:

int
sys_kill(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801059d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059d9:	50                   	push   %eax
801059da:	6a 00                	push   $0x0
801059dc:	e8 3f f2 ff ff       	call   80104c20 <argint>
801059e1:	83 c4 10             	add    $0x10,%esp
801059e4:	85 c0                	test   %eax,%eax
801059e6:	78 18                	js     80105a00 <sys_kill+0x30>
    return -1;
  return kill(pid);
801059e8:	83 ec 0c             	sub    $0xc,%esp
801059eb:	ff 75 f4             	pushl  -0xc(%ebp)
801059ee:	e8 4d e9 ff ff       	call   80104340 <kill>
801059f3:	83 c4 10             	add    $0x10,%esp
}
801059f6:	c9                   	leave  
801059f7:	c3                   	ret    
801059f8:	90                   	nop
801059f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a05:	c9                   	leave  
80105a06:	c3                   	ret    
80105a07:	89 f6                	mov    %esi,%esi
80105a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a10 <sys_getpid>:

int
sys_getpid(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105a16:	e8 65 e1 ff ff       	call   80103b80 <myproc>
80105a1b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105a1e:	c9                   	leave  
80105a1f:	c3                   	ret    

80105a20 <sys_sbrk>:

int
sys_sbrk(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105a24:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a27:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a2a:	50                   	push   %eax
80105a2b:	6a 00                	push   $0x0
80105a2d:	e8 ee f1 ff ff       	call   80104c20 <argint>
80105a32:	83 c4 10             	add    $0x10,%esp
80105a35:	85 c0                	test   %eax,%eax
80105a37:	78 27                	js     80105a60 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105a39:	e8 42 e1 ff ff       	call   80103b80 <myproc>
  if(growproc(n) < 0)
80105a3e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105a41:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105a43:	ff 75 f4             	pushl  -0xc(%ebp)
80105a46:	e8 55 e2 ff ff       	call   80103ca0 <growproc>
80105a4b:	83 c4 10             	add    $0x10,%esp
80105a4e:	85 c0                	test   %eax,%eax
80105a50:	78 0e                	js     80105a60 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105a52:	89 d8                	mov    %ebx,%eax
80105a54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a57:	c9                   	leave  
80105a58:	c3                   	ret    
80105a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a60:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a65:	eb eb                	jmp    80105a52 <sys_sbrk+0x32>
80105a67:	89 f6                	mov    %esi,%esi
80105a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a70 <sys_sleep>:

int
sys_sleep(void)
{
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105a74:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a77:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a7a:	50                   	push   %eax
80105a7b:	6a 00                	push   $0x0
80105a7d:	e8 9e f1 ff ff       	call   80104c20 <argint>
80105a82:	83 c4 10             	add    $0x10,%esp
80105a85:	85 c0                	test   %eax,%eax
80105a87:	0f 88 8a 00 00 00    	js     80105b17 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105a8d:	83 ec 0c             	sub    $0xc,%esp
80105a90:	68 60 60 11 80       	push   $0x80116060
80105a95:	e8 06 ed ff ff       	call   801047a0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105a9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a9d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105aa0:	8b 1d a0 68 11 80    	mov    0x801168a0,%ebx
  while(ticks - ticks0 < n){
80105aa6:	85 d2                	test   %edx,%edx
80105aa8:	75 27                	jne    80105ad1 <sys_sleep+0x61>
80105aaa:	eb 54                	jmp    80105b00 <sys_sleep+0x90>
80105aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105ab0:	83 ec 08             	sub    $0x8,%esp
80105ab3:	68 60 60 11 80       	push   $0x80116060
80105ab8:	68 a0 68 11 80       	push   $0x801168a0
80105abd:	e8 5e e6 ff ff       	call   80104120 <sleep>
  while(ticks - ticks0 < n){
80105ac2:	a1 a0 68 11 80       	mov    0x801168a0,%eax
80105ac7:	83 c4 10             	add    $0x10,%esp
80105aca:	29 d8                	sub    %ebx,%eax
80105acc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105acf:	73 2f                	jae    80105b00 <sys_sleep+0x90>
    if(myproc()->killed){
80105ad1:	e8 aa e0 ff ff       	call   80103b80 <myproc>
80105ad6:	8b 40 24             	mov    0x24(%eax),%eax
80105ad9:	85 c0                	test   %eax,%eax
80105adb:	74 d3                	je     80105ab0 <sys_sleep+0x40>
      release(&tickslock);
80105add:	83 ec 0c             	sub    $0xc,%esp
80105ae0:	68 60 60 11 80       	push   $0x80116060
80105ae5:	e8 d6 ed ff ff       	call   801048c0 <release>
      return -1;
80105aea:	83 c4 10             	add    $0x10,%esp
80105aed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105af2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105af5:	c9                   	leave  
80105af6:	c3                   	ret    
80105af7:	89 f6                	mov    %esi,%esi
80105af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105b00:	83 ec 0c             	sub    $0xc,%esp
80105b03:	68 60 60 11 80       	push   $0x80116060
80105b08:	e8 b3 ed ff ff       	call   801048c0 <release>
  return 0;
80105b0d:	83 c4 10             	add    $0x10,%esp
80105b10:	31 c0                	xor    %eax,%eax
}
80105b12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b15:	c9                   	leave  
80105b16:	c3                   	ret    
    return -1;
80105b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b1c:	eb f4                	jmp    80105b12 <sys_sleep+0xa2>
80105b1e:	66 90                	xchg   %ax,%ax

80105b20 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	53                   	push   %ebx
80105b24:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105b27:	68 60 60 11 80       	push   $0x80116060
80105b2c:	e8 6f ec ff ff       	call   801047a0 <acquire>
  xticks = ticks;
80105b31:	8b 1d a0 68 11 80    	mov    0x801168a0,%ebx
  release(&tickslock);
80105b37:	c7 04 24 60 60 11 80 	movl   $0x80116060,(%esp)
80105b3e:	e8 7d ed ff ff       	call   801048c0 <release>
  return xticks;
}
80105b43:	89 d8                	mov    %ebx,%eax
80105b45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b48:	c9                   	leave  
80105b49:	c3                   	ret    
80105b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b50 <sys_protectPage>:

int
sys_protectPage(void){
80105b50:	55                   	push   %ebp
80105b51:	89 e5                	mov    %esp,%ebp
80105b53:	83 ec 1c             	sub    $0x1c,%esp
  void* va;

  if (argptr(0, (char**)(&va), sizeof(int)) < 0){
80105b56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b59:	6a 04                	push   $0x4
80105b5b:	50                   	push   %eax
80105b5c:	6a 00                	push   $0x0
80105b5e:	e8 0d f1 ff ff       	call   80104c70 <argptr>
80105b63:	83 c4 10             	add    $0x10,%esp
80105b66:	85 c0                	test   %eax,%eax
80105b68:	78 16                	js     80105b80 <sys_protectPage+0x30>
    return -1;
  }
  return protectPage(va);
80105b6a:	83 ec 0c             	sub    $0xc,%esp
80105b6d:	ff 75 f4             	pushl  -0xc(%ebp)
80105b70:	e8 5b e9 ff ff       	call   801044d0 <protectPage>
80105b75:	83 c4 10             	add    $0x10,%esp
80105b78:	c9                   	leave  
80105b79:	c3                   	ret    
80105b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b85:	c9                   	leave  
80105b86:	c3                   	ret    

80105b87 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b87:	1e                   	push   %ds
  pushl %es
80105b88:	06                   	push   %es
  pushl %fs
80105b89:	0f a0                	push   %fs
  pushl %gs
80105b8b:	0f a8                	push   %gs
  pushal
80105b8d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105b8e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105b92:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105b94:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105b96:	54                   	push   %esp
  call trap
80105b97:	e8 c4 00 00 00       	call   80105c60 <trap>
  addl $4, %esp
80105b9c:	83 c4 04             	add    $0x4,%esp

80105b9f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105b9f:	61                   	popa   
  popl %gs
80105ba0:	0f a9                	pop    %gs
  popl %fs
80105ba2:	0f a1                	pop    %fs
  popl %es
80105ba4:	07                   	pop    %es
  popl %ds
80105ba5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105ba6:	83 c4 08             	add    $0x8,%esp
  iret
80105ba9:	cf                   	iret   
80105baa:	66 90                	xchg   %ax,%ax
80105bac:	66 90                	xchg   %ax,%ax
80105bae:	66 90                	xchg   %ax,%ax

80105bb0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105bb0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105bb1:	31 c0                	xor    %eax,%eax
{
80105bb3:	89 e5                	mov    %esp,%ebp
80105bb5:	83 ec 08             	sub    $0x8,%esp
80105bb8:	90                   	nop
80105bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105bc0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105bc7:	c7 04 c5 a2 60 11 80 	movl   $0x8e000008,-0x7fee9f5e(,%eax,8)
80105bce:	08 00 00 8e 
80105bd2:	66 89 14 c5 a0 60 11 	mov    %dx,-0x7fee9f60(,%eax,8)
80105bd9:	80 
80105bda:	c1 ea 10             	shr    $0x10,%edx
80105bdd:	66 89 14 c5 a6 60 11 	mov    %dx,-0x7fee9f5a(,%eax,8)
80105be4:	80 
  for(i = 0; i < 256; i++)
80105be5:	83 c0 01             	add    $0x1,%eax
80105be8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105bed:	75 d1                	jne    80105bc0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bef:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105bf4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bf7:	c7 05 a2 62 11 80 08 	movl   $0xef000008,0x801162a2
80105bfe:	00 00 ef 
  initlock(&tickslock, "time");
80105c01:	68 7d 7d 10 80       	push   $0x80107d7d
80105c06:	68 60 60 11 80       	push   $0x80116060
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c0b:	66 a3 a0 62 11 80    	mov    %ax,0x801162a0
80105c11:	c1 e8 10             	shr    $0x10,%eax
80105c14:	66 a3 a6 62 11 80    	mov    %ax,0x801162a6
  initlock(&tickslock, "time");
80105c1a:	e8 91 ea ff ff       	call   801046b0 <initlock>
}
80105c1f:	83 c4 10             	add    $0x10,%esp
80105c22:	c9                   	leave  
80105c23:	c3                   	ret    
80105c24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105c30 <idtinit>:

void
idtinit(void)
{
80105c30:	55                   	push   %ebp
  pd[0] = size-1;
80105c31:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105c36:	89 e5                	mov    %esp,%ebp
80105c38:	83 ec 10             	sub    $0x10,%esp
80105c3b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105c3f:	b8 a0 60 11 80       	mov    $0x801160a0,%eax
80105c44:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105c48:	c1 e8 10             	shr    $0x10,%eax
80105c4b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105c4f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105c52:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105c55:	c9                   	leave  
80105c56:	c3                   	ret    
80105c57:	89 f6                	mov    %esi,%esi
80105c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c60 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	57                   	push   %edi
80105c64:	56                   	push   %esi
80105c65:	53                   	push   %ebx
80105c66:	83 ec 1c             	sub    $0x1c,%esp
80105c69:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105c6c:	8b 47 30             	mov    0x30(%edi),%eax
80105c6f:	83 f8 40             	cmp    $0x40,%eax
80105c72:	0f 84 f0 00 00 00    	je     80105d68 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105c78:	83 e8 0e             	sub    $0xe,%eax
80105c7b:	83 f8 31             	cmp    $0x31,%eax
80105c7e:	77 10                	ja     80105c90 <trap+0x30>
80105c80:	ff 24 85 24 7e 10 80 	jmp    *-0x7fef81dc(,%eax,4)
80105c87:	89 f6                	mov    %esi,%esi
80105c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105c90:	e8 eb de ff ff       	call   80103b80 <myproc>
80105c95:	85 c0                	test   %eax,%eax
80105c97:	8b 5f 38             	mov    0x38(%edi),%ebx
80105c9a:	0f 84 04 02 00 00    	je     80105ea4 <trap+0x244>
80105ca0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105ca4:	0f 84 fa 01 00 00    	je     80105ea4 <trap+0x244>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105caa:	0f 20 d1             	mov    %cr2,%ecx
80105cad:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cb0:	e8 ab de ff ff       	call   80103b60 <cpuid>
80105cb5:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105cb8:	8b 47 34             	mov    0x34(%edi),%eax
80105cbb:	8b 77 30             	mov    0x30(%edi),%esi
80105cbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105cc1:	e8 ba de ff ff       	call   80103b80 <myproc>
80105cc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105cc9:	e8 b2 de ff ff       	call   80103b80 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cce:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105cd1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105cd4:	51                   	push   %ecx
80105cd5:	53                   	push   %ebx
80105cd6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105cd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cda:	ff 75 e4             	pushl  -0x1c(%ebp)
80105cdd:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105cde:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ce1:	52                   	push   %edx
80105ce2:	ff 70 10             	pushl  0x10(%eax)
80105ce5:	68 e0 7d 10 80       	push   $0x80107de0
80105cea:	e8 71 a9 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105cef:	83 c4 20             	add    $0x20,%esp
80105cf2:	e8 89 de ff ff       	call   80103b80 <myproc>
80105cf7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105cfe:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d00:	e8 7b de ff ff       	call   80103b80 <myproc>
80105d05:	85 c0                	test   %eax,%eax
80105d07:	74 1d                	je     80105d26 <trap+0xc6>
80105d09:	e8 72 de ff ff       	call   80103b80 <myproc>
80105d0e:	8b 50 24             	mov    0x24(%eax),%edx
80105d11:	85 d2                	test   %edx,%edx
80105d13:	74 11                	je     80105d26 <trap+0xc6>
80105d15:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105d19:	83 e0 03             	and    $0x3,%eax
80105d1c:	66 83 f8 03          	cmp    $0x3,%ax
80105d20:	0f 84 3a 01 00 00    	je     80105e60 <trap+0x200>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105d26:	e8 55 de ff ff       	call   80103b80 <myproc>
80105d2b:	85 c0                	test   %eax,%eax
80105d2d:	74 0b                	je     80105d3a <trap+0xda>
80105d2f:	e8 4c de ff ff       	call   80103b80 <myproc>
80105d34:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105d38:	74 66                	je     80105da0 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d3a:	e8 41 de ff ff       	call   80103b80 <myproc>
80105d3f:	85 c0                	test   %eax,%eax
80105d41:	74 19                	je     80105d5c <trap+0xfc>
80105d43:	e8 38 de ff ff       	call   80103b80 <myproc>
80105d48:	8b 40 24             	mov    0x24(%eax),%eax
80105d4b:	85 c0                	test   %eax,%eax
80105d4d:	74 0d                	je     80105d5c <trap+0xfc>
80105d4f:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105d53:	83 e0 03             	and    $0x3,%eax
80105d56:	66 83 f8 03          	cmp    $0x3,%ax
80105d5a:	74 35                	je     80105d91 <trap+0x131>
    exit();
}
80105d5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d5f:	5b                   	pop    %ebx
80105d60:	5e                   	pop    %esi
80105d61:	5f                   	pop    %edi
80105d62:	5d                   	pop    %ebp
80105d63:	c3                   	ret    
80105d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105d68:	e8 13 de ff ff       	call   80103b80 <myproc>
80105d6d:	8b 58 24             	mov    0x24(%eax),%ebx
80105d70:	85 db                	test   %ebx,%ebx
80105d72:	0f 85 d8 00 00 00    	jne    80105e50 <trap+0x1f0>
    myproc()->tf = tf;
80105d78:	e8 03 de ff ff       	call   80103b80 <myproc>
80105d7d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105d80:	e8 8b ef ff ff       	call   80104d10 <syscall>
    if(myproc()->killed)
80105d85:	e8 f6 dd ff ff       	call   80103b80 <myproc>
80105d8a:	8b 48 24             	mov    0x24(%eax),%ecx
80105d8d:	85 c9                	test   %ecx,%ecx
80105d8f:	74 cb                	je     80105d5c <trap+0xfc>
}
80105d91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d94:	5b                   	pop    %ebx
80105d95:	5e                   	pop    %esi
80105d96:	5f                   	pop    %edi
80105d97:	5d                   	pop    %ebp
      exit();
80105d98:	e9 03 e2 ff ff       	jmp    80103fa0 <exit>
80105d9d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105da0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105da4:	75 94                	jne    80105d3a <trap+0xda>
    yield();
80105da6:	e8 25 e3 ff ff       	call   801040d0 <yield>
80105dab:	eb 8d                	jmp    80105d3a <trap+0xda>
80105dad:	8d 76 00             	lea    0x0(%esi),%esi
      checkIfNeedSwapping();
80105db0:	e8 1b 17 00 00       	call   801074d0 <checkIfNeedSwapping>
      break;
80105db5:	e9 46 ff ff ff       	jmp    80105d00 <trap+0xa0>
80105dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105dc0:	e8 9b dd ff ff       	call   80103b60 <cpuid>
80105dc5:	85 c0                	test   %eax,%eax
80105dc7:	0f 84 a3 00 00 00    	je     80105e70 <trap+0x210>
    lapiceoi();
80105dcd:	e8 1e cd ff ff       	call   80102af0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dd2:	e8 a9 dd ff ff       	call   80103b80 <myproc>
80105dd7:	85 c0                	test   %eax,%eax
80105dd9:	0f 85 2a ff ff ff    	jne    80105d09 <trap+0xa9>
80105ddf:	e9 42 ff ff ff       	jmp    80105d26 <trap+0xc6>
80105de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105de8:	e8 c3 cb ff ff       	call   801029b0 <kbdintr>
    lapiceoi();
80105ded:	e8 fe cc ff ff       	call   80102af0 <lapiceoi>
    break;
80105df2:	e9 09 ff ff ff       	jmp    80105d00 <trap+0xa0>
80105df7:	89 f6                	mov    %esi,%esi
80105df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    uartintr();
80105e00:	e8 3b 02 00 00       	call   80106040 <uartintr>
    lapiceoi();
80105e05:	e8 e6 cc ff ff       	call   80102af0 <lapiceoi>
    break;
80105e0a:	e9 f1 fe ff ff       	jmp    80105d00 <trap+0xa0>
80105e0f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105e10:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105e14:	8b 77 38             	mov    0x38(%edi),%esi
80105e17:	e8 44 dd ff ff       	call   80103b60 <cpuid>
80105e1c:	56                   	push   %esi
80105e1d:	53                   	push   %ebx
80105e1e:	50                   	push   %eax
80105e1f:	68 88 7d 10 80       	push   $0x80107d88
80105e24:	e8 37 a8 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105e29:	e8 c2 cc ff ff       	call   80102af0 <lapiceoi>
    break;
80105e2e:	83 c4 10             	add    $0x10,%esp
80105e31:	e9 ca fe ff ff       	jmp    80105d00 <trap+0xa0>
80105e36:	8d 76 00             	lea    0x0(%esi),%esi
80105e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80105e40:	e8 db c5 ff ff       	call   80102420 <ideintr>
80105e45:	eb 86                	jmp    80105dcd <trap+0x16d>
80105e47:	89 f6                	mov    %esi,%esi
80105e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
80105e50:	e8 4b e1 ff ff       	call   80103fa0 <exit>
80105e55:	e9 1e ff ff ff       	jmp    80105d78 <trap+0x118>
80105e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105e60:	e8 3b e1 ff ff       	call   80103fa0 <exit>
80105e65:	e9 bc fe ff ff       	jmp    80105d26 <trap+0xc6>
80105e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105e70:	83 ec 0c             	sub    $0xc,%esp
80105e73:	68 60 60 11 80       	push   $0x80116060
80105e78:	e8 23 e9 ff ff       	call   801047a0 <acquire>
      wakeup(&ticks);
80105e7d:	c7 04 24 a0 68 11 80 	movl   $0x801168a0,(%esp)
      ticks++;
80105e84:	83 05 a0 68 11 80 01 	addl   $0x1,0x801168a0
      wakeup(&ticks);
80105e8b:	e8 50 e4 ff ff       	call   801042e0 <wakeup>
      release(&tickslock);
80105e90:	c7 04 24 60 60 11 80 	movl   $0x80116060,(%esp)
80105e97:	e8 24 ea ff ff       	call   801048c0 <release>
80105e9c:	83 c4 10             	add    $0x10,%esp
80105e9f:	e9 29 ff ff ff       	jmp    80105dcd <trap+0x16d>
80105ea4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105ea7:	e8 b4 dc ff ff       	call   80103b60 <cpuid>
80105eac:	83 ec 0c             	sub    $0xc,%esp
80105eaf:	56                   	push   %esi
80105eb0:	53                   	push   %ebx
80105eb1:	50                   	push   %eax
80105eb2:	ff 77 30             	pushl  0x30(%edi)
80105eb5:	68 ac 7d 10 80       	push   $0x80107dac
80105eba:	e8 a1 a7 ff ff       	call   80100660 <cprintf>
      panic("trap");
80105ebf:	83 c4 14             	add    $0x14,%esp
80105ec2:	68 82 7d 10 80       	push   $0x80107d82
80105ec7:	e8 c4 a4 ff ff       	call   80100390 <panic>
80105ecc:	66 90                	xchg   %ax,%ax
80105ece:	66 90                	xchg   %ax,%ax

80105ed0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105ed0:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
80105ed5:	55                   	push   %ebp
80105ed6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105ed8:	85 c0                	test   %eax,%eax
80105eda:	74 1c                	je     80105ef8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105edc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ee1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105ee2:	a8 01                	test   $0x1,%al
80105ee4:	74 12                	je     80105ef8 <uartgetc+0x28>
80105ee6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105eeb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105eec:	0f b6 c0             	movzbl %al,%eax
}
80105eef:	5d                   	pop    %ebp
80105ef0:	c3                   	ret    
80105ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ef8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105efd:	5d                   	pop    %ebp
80105efe:	c3                   	ret    
80105eff:	90                   	nop

80105f00 <uartputc.part.0>:
uartputc(int c)
80105f00:	55                   	push   %ebp
80105f01:	89 e5                	mov    %esp,%ebp
80105f03:	57                   	push   %edi
80105f04:	56                   	push   %esi
80105f05:	53                   	push   %ebx
80105f06:	89 c7                	mov    %eax,%edi
80105f08:	bb 80 00 00 00       	mov    $0x80,%ebx
80105f0d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105f12:	83 ec 0c             	sub    $0xc,%esp
80105f15:	eb 1b                	jmp    80105f32 <uartputc.part.0+0x32>
80105f17:	89 f6                	mov    %esi,%esi
80105f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105f20:	83 ec 0c             	sub    $0xc,%esp
80105f23:	6a 0a                	push   $0xa
80105f25:	e8 e6 cb ff ff       	call   80102b10 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f2a:	83 c4 10             	add    $0x10,%esp
80105f2d:	83 eb 01             	sub    $0x1,%ebx
80105f30:	74 07                	je     80105f39 <uartputc.part.0+0x39>
80105f32:	89 f2                	mov    %esi,%edx
80105f34:	ec                   	in     (%dx),%al
80105f35:	a8 20                	test   $0x20,%al
80105f37:	74 e7                	je     80105f20 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f39:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f3e:	89 f8                	mov    %edi,%eax
80105f40:	ee                   	out    %al,(%dx)
}
80105f41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f44:	5b                   	pop    %ebx
80105f45:	5e                   	pop    %esi
80105f46:	5f                   	pop    %edi
80105f47:	5d                   	pop    %ebp
80105f48:	c3                   	ret    
80105f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f50 <uartinit>:
{
80105f50:	55                   	push   %ebp
80105f51:	31 c9                	xor    %ecx,%ecx
80105f53:	89 c8                	mov    %ecx,%eax
80105f55:	89 e5                	mov    %esp,%ebp
80105f57:	57                   	push   %edi
80105f58:	56                   	push   %esi
80105f59:	53                   	push   %ebx
80105f5a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105f5f:	89 da                	mov    %ebx,%edx
80105f61:	83 ec 0c             	sub    $0xc,%esp
80105f64:	ee                   	out    %al,(%dx)
80105f65:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105f6a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f6f:	89 fa                	mov    %edi,%edx
80105f71:	ee                   	out    %al,(%dx)
80105f72:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f77:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f7c:	ee                   	out    %al,(%dx)
80105f7d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105f82:	89 c8                	mov    %ecx,%eax
80105f84:	89 f2                	mov    %esi,%edx
80105f86:	ee                   	out    %al,(%dx)
80105f87:	b8 03 00 00 00       	mov    $0x3,%eax
80105f8c:	89 fa                	mov    %edi,%edx
80105f8e:	ee                   	out    %al,(%dx)
80105f8f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105f94:	89 c8                	mov    %ecx,%eax
80105f96:	ee                   	out    %al,(%dx)
80105f97:	b8 01 00 00 00       	mov    $0x1,%eax
80105f9c:	89 f2                	mov    %esi,%edx
80105f9e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f9f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105fa4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105fa5:	3c ff                	cmp    $0xff,%al
80105fa7:	74 5a                	je     80106003 <uartinit+0xb3>
  uart = 1;
80105fa9:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80105fb0:	00 00 00 
80105fb3:	89 da                	mov    %ebx,%edx
80105fb5:	ec                   	in     (%dx),%al
80105fb6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fbb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105fbc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105fbf:	bb ec 7e 10 80       	mov    $0x80107eec,%ebx
  ioapicenable(IRQ_COM1, 0);
80105fc4:	6a 00                	push   $0x0
80105fc6:	6a 04                	push   $0x4
80105fc8:	e8 a3 c6 ff ff       	call   80102670 <ioapicenable>
80105fcd:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105fd0:	b8 78 00 00 00       	mov    $0x78,%eax
80105fd5:	eb 13                	jmp    80105fea <uartinit+0x9a>
80105fd7:	89 f6                	mov    %esi,%esi
80105fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105fe0:	83 c3 01             	add    $0x1,%ebx
80105fe3:	0f be 03             	movsbl (%ebx),%eax
80105fe6:	84 c0                	test   %al,%al
80105fe8:	74 19                	je     80106003 <uartinit+0xb3>
  if(!uart)
80105fea:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80105ff0:	85 d2                	test   %edx,%edx
80105ff2:	74 ec                	je     80105fe0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80105ff4:	83 c3 01             	add    $0x1,%ebx
80105ff7:	e8 04 ff ff ff       	call   80105f00 <uartputc.part.0>
80105ffc:	0f be 03             	movsbl (%ebx),%eax
80105fff:	84 c0                	test   %al,%al
80106001:	75 e7                	jne    80105fea <uartinit+0x9a>
}
80106003:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106006:	5b                   	pop    %ebx
80106007:	5e                   	pop    %esi
80106008:	5f                   	pop    %edi
80106009:	5d                   	pop    %ebp
8010600a:	c3                   	ret    
8010600b:	90                   	nop
8010600c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106010 <uartputc>:
  if(!uart)
80106010:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
80106016:	55                   	push   %ebp
80106017:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106019:	85 d2                	test   %edx,%edx
{
8010601b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010601e:	74 10                	je     80106030 <uartputc+0x20>
}
80106020:	5d                   	pop    %ebp
80106021:	e9 da fe ff ff       	jmp    80105f00 <uartputc.part.0>
80106026:	8d 76 00             	lea    0x0(%esi),%esi
80106029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106030:	5d                   	pop    %ebp
80106031:	c3                   	ret    
80106032:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106040 <uartintr>:

void
uartintr(void)
{
80106040:	55                   	push   %ebp
80106041:	89 e5                	mov    %esp,%ebp
80106043:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106046:	68 d0 5e 10 80       	push   $0x80105ed0
8010604b:	e8 c0 a7 ff ff       	call   80100810 <consoleintr>
}
80106050:	83 c4 10             	add    $0x10,%esp
80106053:	c9                   	leave  
80106054:	c3                   	ret    

80106055 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106055:	6a 00                	push   $0x0
  pushl $0
80106057:	6a 00                	push   $0x0
  jmp alltraps
80106059:	e9 29 fb ff ff       	jmp    80105b87 <alltraps>

8010605e <vector1>:
.globl vector1
vector1:
  pushl $0
8010605e:	6a 00                	push   $0x0
  pushl $1
80106060:	6a 01                	push   $0x1
  jmp alltraps
80106062:	e9 20 fb ff ff       	jmp    80105b87 <alltraps>

80106067 <vector2>:
.globl vector2
vector2:
  pushl $0
80106067:	6a 00                	push   $0x0
  pushl $2
80106069:	6a 02                	push   $0x2
  jmp alltraps
8010606b:	e9 17 fb ff ff       	jmp    80105b87 <alltraps>

80106070 <vector3>:
.globl vector3
vector3:
  pushl $0
80106070:	6a 00                	push   $0x0
  pushl $3
80106072:	6a 03                	push   $0x3
  jmp alltraps
80106074:	e9 0e fb ff ff       	jmp    80105b87 <alltraps>

80106079 <vector4>:
.globl vector4
vector4:
  pushl $0
80106079:	6a 00                	push   $0x0
  pushl $4
8010607b:	6a 04                	push   $0x4
  jmp alltraps
8010607d:	e9 05 fb ff ff       	jmp    80105b87 <alltraps>

80106082 <vector5>:
.globl vector5
vector5:
  pushl $0
80106082:	6a 00                	push   $0x0
  pushl $5
80106084:	6a 05                	push   $0x5
  jmp alltraps
80106086:	e9 fc fa ff ff       	jmp    80105b87 <alltraps>

8010608b <vector6>:
.globl vector6
vector6:
  pushl $0
8010608b:	6a 00                	push   $0x0
  pushl $6
8010608d:	6a 06                	push   $0x6
  jmp alltraps
8010608f:	e9 f3 fa ff ff       	jmp    80105b87 <alltraps>

80106094 <vector7>:
.globl vector7
vector7:
  pushl $0
80106094:	6a 00                	push   $0x0
  pushl $7
80106096:	6a 07                	push   $0x7
  jmp alltraps
80106098:	e9 ea fa ff ff       	jmp    80105b87 <alltraps>

8010609d <vector8>:
.globl vector8
vector8:
  pushl $8
8010609d:	6a 08                	push   $0x8
  jmp alltraps
8010609f:	e9 e3 fa ff ff       	jmp    80105b87 <alltraps>

801060a4 <vector9>:
.globl vector9
vector9:
  pushl $0
801060a4:	6a 00                	push   $0x0
  pushl $9
801060a6:	6a 09                	push   $0x9
  jmp alltraps
801060a8:	e9 da fa ff ff       	jmp    80105b87 <alltraps>

801060ad <vector10>:
.globl vector10
vector10:
  pushl $10
801060ad:	6a 0a                	push   $0xa
  jmp alltraps
801060af:	e9 d3 fa ff ff       	jmp    80105b87 <alltraps>

801060b4 <vector11>:
.globl vector11
vector11:
  pushl $11
801060b4:	6a 0b                	push   $0xb
  jmp alltraps
801060b6:	e9 cc fa ff ff       	jmp    80105b87 <alltraps>

801060bb <vector12>:
.globl vector12
vector12:
  pushl $12
801060bb:	6a 0c                	push   $0xc
  jmp alltraps
801060bd:	e9 c5 fa ff ff       	jmp    80105b87 <alltraps>

801060c2 <vector13>:
.globl vector13
vector13:
  pushl $13
801060c2:	6a 0d                	push   $0xd
  jmp alltraps
801060c4:	e9 be fa ff ff       	jmp    80105b87 <alltraps>

801060c9 <vector14>:
.globl vector14
vector14:
  pushl $14
801060c9:	6a 0e                	push   $0xe
  jmp alltraps
801060cb:	e9 b7 fa ff ff       	jmp    80105b87 <alltraps>

801060d0 <vector15>:
.globl vector15
vector15:
  pushl $0
801060d0:	6a 00                	push   $0x0
  pushl $15
801060d2:	6a 0f                	push   $0xf
  jmp alltraps
801060d4:	e9 ae fa ff ff       	jmp    80105b87 <alltraps>

801060d9 <vector16>:
.globl vector16
vector16:
  pushl $0
801060d9:	6a 00                	push   $0x0
  pushl $16
801060db:	6a 10                	push   $0x10
  jmp alltraps
801060dd:	e9 a5 fa ff ff       	jmp    80105b87 <alltraps>

801060e2 <vector17>:
.globl vector17
vector17:
  pushl $17
801060e2:	6a 11                	push   $0x11
  jmp alltraps
801060e4:	e9 9e fa ff ff       	jmp    80105b87 <alltraps>

801060e9 <vector18>:
.globl vector18
vector18:
  pushl $0
801060e9:	6a 00                	push   $0x0
  pushl $18
801060eb:	6a 12                	push   $0x12
  jmp alltraps
801060ed:	e9 95 fa ff ff       	jmp    80105b87 <alltraps>

801060f2 <vector19>:
.globl vector19
vector19:
  pushl $0
801060f2:	6a 00                	push   $0x0
  pushl $19
801060f4:	6a 13                	push   $0x13
  jmp alltraps
801060f6:	e9 8c fa ff ff       	jmp    80105b87 <alltraps>

801060fb <vector20>:
.globl vector20
vector20:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $20
801060fd:	6a 14                	push   $0x14
  jmp alltraps
801060ff:	e9 83 fa ff ff       	jmp    80105b87 <alltraps>

80106104 <vector21>:
.globl vector21
vector21:
  pushl $0
80106104:	6a 00                	push   $0x0
  pushl $21
80106106:	6a 15                	push   $0x15
  jmp alltraps
80106108:	e9 7a fa ff ff       	jmp    80105b87 <alltraps>

8010610d <vector22>:
.globl vector22
vector22:
  pushl $0
8010610d:	6a 00                	push   $0x0
  pushl $22
8010610f:	6a 16                	push   $0x16
  jmp alltraps
80106111:	e9 71 fa ff ff       	jmp    80105b87 <alltraps>

80106116 <vector23>:
.globl vector23
vector23:
  pushl $0
80106116:	6a 00                	push   $0x0
  pushl $23
80106118:	6a 17                	push   $0x17
  jmp alltraps
8010611a:	e9 68 fa ff ff       	jmp    80105b87 <alltraps>

8010611f <vector24>:
.globl vector24
vector24:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $24
80106121:	6a 18                	push   $0x18
  jmp alltraps
80106123:	e9 5f fa ff ff       	jmp    80105b87 <alltraps>

80106128 <vector25>:
.globl vector25
vector25:
  pushl $0
80106128:	6a 00                	push   $0x0
  pushl $25
8010612a:	6a 19                	push   $0x19
  jmp alltraps
8010612c:	e9 56 fa ff ff       	jmp    80105b87 <alltraps>

80106131 <vector26>:
.globl vector26
vector26:
  pushl $0
80106131:	6a 00                	push   $0x0
  pushl $26
80106133:	6a 1a                	push   $0x1a
  jmp alltraps
80106135:	e9 4d fa ff ff       	jmp    80105b87 <alltraps>

8010613a <vector27>:
.globl vector27
vector27:
  pushl $0
8010613a:	6a 00                	push   $0x0
  pushl $27
8010613c:	6a 1b                	push   $0x1b
  jmp alltraps
8010613e:	e9 44 fa ff ff       	jmp    80105b87 <alltraps>

80106143 <vector28>:
.globl vector28
vector28:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $28
80106145:	6a 1c                	push   $0x1c
  jmp alltraps
80106147:	e9 3b fa ff ff       	jmp    80105b87 <alltraps>

8010614c <vector29>:
.globl vector29
vector29:
  pushl $0
8010614c:	6a 00                	push   $0x0
  pushl $29
8010614e:	6a 1d                	push   $0x1d
  jmp alltraps
80106150:	e9 32 fa ff ff       	jmp    80105b87 <alltraps>

80106155 <vector30>:
.globl vector30
vector30:
  pushl $0
80106155:	6a 00                	push   $0x0
  pushl $30
80106157:	6a 1e                	push   $0x1e
  jmp alltraps
80106159:	e9 29 fa ff ff       	jmp    80105b87 <alltraps>

8010615e <vector31>:
.globl vector31
vector31:
  pushl $0
8010615e:	6a 00                	push   $0x0
  pushl $31
80106160:	6a 1f                	push   $0x1f
  jmp alltraps
80106162:	e9 20 fa ff ff       	jmp    80105b87 <alltraps>

80106167 <vector32>:
.globl vector32
vector32:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $32
80106169:	6a 20                	push   $0x20
  jmp alltraps
8010616b:	e9 17 fa ff ff       	jmp    80105b87 <alltraps>

80106170 <vector33>:
.globl vector33
vector33:
  pushl $0
80106170:	6a 00                	push   $0x0
  pushl $33
80106172:	6a 21                	push   $0x21
  jmp alltraps
80106174:	e9 0e fa ff ff       	jmp    80105b87 <alltraps>

80106179 <vector34>:
.globl vector34
vector34:
  pushl $0
80106179:	6a 00                	push   $0x0
  pushl $34
8010617b:	6a 22                	push   $0x22
  jmp alltraps
8010617d:	e9 05 fa ff ff       	jmp    80105b87 <alltraps>

80106182 <vector35>:
.globl vector35
vector35:
  pushl $0
80106182:	6a 00                	push   $0x0
  pushl $35
80106184:	6a 23                	push   $0x23
  jmp alltraps
80106186:	e9 fc f9 ff ff       	jmp    80105b87 <alltraps>

8010618b <vector36>:
.globl vector36
vector36:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $36
8010618d:	6a 24                	push   $0x24
  jmp alltraps
8010618f:	e9 f3 f9 ff ff       	jmp    80105b87 <alltraps>

80106194 <vector37>:
.globl vector37
vector37:
  pushl $0
80106194:	6a 00                	push   $0x0
  pushl $37
80106196:	6a 25                	push   $0x25
  jmp alltraps
80106198:	e9 ea f9 ff ff       	jmp    80105b87 <alltraps>

8010619d <vector38>:
.globl vector38
vector38:
  pushl $0
8010619d:	6a 00                	push   $0x0
  pushl $38
8010619f:	6a 26                	push   $0x26
  jmp alltraps
801061a1:	e9 e1 f9 ff ff       	jmp    80105b87 <alltraps>

801061a6 <vector39>:
.globl vector39
vector39:
  pushl $0
801061a6:	6a 00                	push   $0x0
  pushl $39
801061a8:	6a 27                	push   $0x27
  jmp alltraps
801061aa:	e9 d8 f9 ff ff       	jmp    80105b87 <alltraps>

801061af <vector40>:
.globl vector40
vector40:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $40
801061b1:	6a 28                	push   $0x28
  jmp alltraps
801061b3:	e9 cf f9 ff ff       	jmp    80105b87 <alltraps>

801061b8 <vector41>:
.globl vector41
vector41:
  pushl $0
801061b8:	6a 00                	push   $0x0
  pushl $41
801061ba:	6a 29                	push   $0x29
  jmp alltraps
801061bc:	e9 c6 f9 ff ff       	jmp    80105b87 <alltraps>

801061c1 <vector42>:
.globl vector42
vector42:
  pushl $0
801061c1:	6a 00                	push   $0x0
  pushl $42
801061c3:	6a 2a                	push   $0x2a
  jmp alltraps
801061c5:	e9 bd f9 ff ff       	jmp    80105b87 <alltraps>

801061ca <vector43>:
.globl vector43
vector43:
  pushl $0
801061ca:	6a 00                	push   $0x0
  pushl $43
801061cc:	6a 2b                	push   $0x2b
  jmp alltraps
801061ce:	e9 b4 f9 ff ff       	jmp    80105b87 <alltraps>

801061d3 <vector44>:
.globl vector44
vector44:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $44
801061d5:	6a 2c                	push   $0x2c
  jmp alltraps
801061d7:	e9 ab f9 ff ff       	jmp    80105b87 <alltraps>

801061dc <vector45>:
.globl vector45
vector45:
  pushl $0
801061dc:	6a 00                	push   $0x0
  pushl $45
801061de:	6a 2d                	push   $0x2d
  jmp alltraps
801061e0:	e9 a2 f9 ff ff       	jmp    80105b87 <alltraps>

801061e5 <vector46>:
.globl vector46
vector46:
  pushl $0
801061e5:	6a 00                	push   $0x0
  pushl $46
801061e7:	6a 2e                	push   $0x2e
  jmp alltraps
801061e9:	e9 99 f9 ff ff       	jmp    80105b87 <alltraps>

801061ee <vector47>:
.globl vector47
vector47:
  pushl $0
801061ee:	6a 00                	push   $0x0
  pushl $47
801061f0:	6a 2f                	push   $0x2f
  jmp alltraps
801061f2:	e9 90 f9 ff ff       	jmp    80105b87 <alltraps>

801061f7 <vector48>:
.globl vector48
vector48:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $48
801061f9:	6a 30                	push   $0x30
  jmp alltraps
801061fb:	e9 87 f9 ff ff       	jmp    80105b87 <alltraps>

80106200 <vector49>:
.globl vector49
vector49:
  pushl $0
80106200:	6a 00                	push   $0x0
  pushl $49
80106202:	6a 31                	push   $0x31
  jmp alltraps
80106204:	e9 7e f9 ff ff       	jmp    80105b87 <alltraps>

80106209 <vector50>:
.globl vector50
vector50:
  pushl $0
80106209:	6a 00                	push   $0x0
  pushl $50
8010620b:	6a 32                	push   $0x32
  jmp alltraps
8010620d:	e9 75 f9 ff ff       	jmp    80105b87 <alltraps>

80106212 <vector51>:
.globl vector51
vector51:
  pushl $0
80106212:	6a 00                	push   $0x0
  pushl $51
80106214:	6a 33                	push   $0x33
  jmp alltraps
80106216:	e9 6c f9 ff ff       	jmp    80105b87 <alltraps>

8010621b <vector52>:
.globl vector52
vector52:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $52
8010621d:	6a 34                	push   $0x34
  jmp alltraps
8010621f:	e9 63 f9 ff ff       	jmp    80105b87 <alltraps>

80106224 <vector53>:
.globl vector53
vector53:
  pushl $0
80106224:	6a 00                	push   $0x0
  pushl $53
80106226:	6a 35                	push   $0x35
  jmp alltraps
80106228:	e9 5a f9 ff ff       	jmp    80105b87 <alltraps>

8010622d <vector54>:
.globl vector54
vector54:
  pushl $0
8010622d:	6a 00                	push   $0x0
  pushl $54
8010622f:	6a 36                	push   $0x36
  jmp alltraps
80106231:	e9 51 f9 ff ff       	jmp    80105b87 <alltraps>

80106236 <vector55>:
.globl vector55
vector55:
  pushl $0
80106236:	6a 00                	push   $0x0
  pushl $55
80106238:	6a 37                	push   $0x37
  jmp alltraps
8010623a:	e9 48 f9 ff ff       	jmp    80105b87 <alltraps>

8010623f <vector56>:
.globl vector56
vector56:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $56
80106241:	6a 38                	push   $0x38
  jmp alltraps
80106243:	e9 3f f9 ff ff       	jmp    80105b87 <alltraps>

80106248 <vector57>:
.globl vector57
vector57:
  pushl $0
80106248:	6a 00                	push   $0x0
  pushl $57
8010624a:	6a 39                	push   $0x39
  jmp alltraps
8010624c:	e9 36 f9 ff ff       	jmp    80105b87 <alltraps>

80106251 <vector58>:
.globl vector58
vector58:
  pushl $0
80106251:	6a 00                	push   $0x0
  pushl $58
80106253:	6a 3a                	push   $0x3a
  jmp alltraps
80106255:	e9 2d f9 ff ff       	jmp    80105b87 <alltraps>

8010625a <vector59>:
.globl vector59
vector59:
  pushl $0
8010625a:	6a 00                	push   $0x0
  pushl $59
8010625c:	6a 3b                	push   $0x3b
  jmp alltraps
8010625e:	e9 24 f9 ff ff       	jmp    80105b87 <alltraps>

80106263 <vector60>:
.globl vector60
vector60:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $60
80106265:	6a 3c                	push   $0x3c
  jmp alltraps
80106267:	e9 1b f9 ff ff       	jmp    80105b87 <alltraps>

8010626c <vector61>:
.globl vector61
vector61:
  pushl $0
8010626c:	6a 00                	push   $0x0
  pushl $61
8010626e:	6a 3d                	push   $0x3d
  jmp alltraps
80106270:	e9 12 f9 ff ff       	jmp    80105b87 <alltraps>

80106275 <vector62>:
.globl vector62
vector62:
  pushl $0
80106275:	6a 00                	push   $0x0
  pushl $62
80106277:	6a 3e                	push   $0x3e
  jmp alltraps
80106279:	e9 09 f9 ff ff       	jmp    80105b87 <alltraps>

8010627e <vector63>:
.globl vector63
vector63:
  pushl $0
8010627e:	6a 00                	push   $0x0
  pushl $63
80106280:	6a 3f                	push   $0x3f
  jmp alltraps
80106282:	e9 00 f9 ff ff       	jmp    80105b87 <alltraps>

80106287 <vector64>:
.globl vector64
vector64:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $64
80106289:	6a 40                	push   $0x40
  jmp alltraps
8010628b:	e9 f7 f8 ff ff       	jmp    80105b87 <alltraps>

80106290 <vector65>:
.globl vector65
vector65:
  pushl $0
80106290:	6a 00                	push   $0x0
  pushl $65
80106292:	6a 41                	push   $0x41
  jmp alltraps
80106294:	e9 ee f8 ff ff       	jmp    80105b87 <alltraps>

80106299 <vector66>:
.globl vector66
vector66:
  pushl $0
80106299:	6a 00                	push   $0x0
  pushl $66
8010629b:	6a 42                	push   $0x42
  jmp alltraps
8010629d:	e9 e5 f8 ff ff       	jmp    80105b87 <alltraps>

801062a2 <vector67>:
.globl vector67
vector67:
  pushl $0
801062a2:	6a 00                	push   $0x0
  pushl $67
801062a4:	6a 43                	push   $0x43
  jmp alltraps
801062a6:	e9 dc f8 ff ff       	jmp    80105b87 <alltraps>

801062ab <vector68>:
.globl vector68
vector68:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $68
801062ad:	6a 44                	push   $0x44
  jmp alltraps
801062af:	e9 d3 f8 ff ff       	jmp    80105b87 <alltraps>

801062b4 <vector69>:
.globl vector69
vector69:
  pushl $0
801062b4:	6a 00                	push   $0x0
  pushl $69
801062b6:	6a 45                	push   $0x45
  jmp alltraps
801062b8:	e9 ca f8 ff ff       	jmp    80105b87 <alltraps>

801062bd <vector70>:
.globl vector70
vector70:
  pushl $0
801062bd:	6a 00                	push   $0x0
  pushl $70
801062bf:	6a 46                	push   $0x46
  jmp alltraps
801062c1:	e9 c1 f8 ff ff       	jmp    80105b87 <alltraps>

801062c6 <vector71>:
.globl vector71
vector71:
  pushl $0
801062c6:	6a 00                	push   $0x0
  pushl $71
801062c8:	6a 47                	push   $0x47
  jmp alltraps
801062ca:	e9 b8 f8 ff ff       	jmp    80105b87 <alltraps>

801062cf <vector72>:
.globl vector72
vector72:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $72
801062d1:	6a 48                	push   $0x48
  jmp alltraps
801062d3:	e9 af f8 ff ff       	jmp    80105b87 <alltraps>

801062d8 <vector73>:
.globl vector73
vector73:
  pushl $0
801062d8:	6a 00                	push   $0x0
  pushl $73
801062da:	6a 49                	push   $0x49
  jmp alltraps
801062dc:	e9 a6 f8 ff ff       	jmp    80105b87 <alltraps>

801062e1 <vector74>:
.globl vector74
vector74:
  pushl $0
801062e1:	6a 00                	push   $0x0
  pushl $74
801062e3:	6a 4a                	push   $0x4a
  jmp alltraps
801062e5:	e9 9d f8 ff ff       	jmp    80105b87 <alltraps>

801062ea <vector75>:
.globl vector75
vector75:
  pushl $0
801062ea:	6a 00                	push   $0x0
  pushl $75
801062ec:	6a 4b                	push   $0x4b
  jmp alltraps
801062ee:	e9 94 f8 ff ff       	jmp    80105b87 <alltraps>

801062f3 <vector76>:
.globl vector76
vector76:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $76
801062f5:	6a 4c                	push   $0x4c
  jmp alltraps
801062f7:	e9 8b f8 ff ff       	jmp    80105b87 <alltraps>

801062fc <vector77>:
.globl vector77
vector77:
  pushl $0
801062fc:	6a 00                	push   $0x0
  pushl $77
801062fe:	6a 4d                	push   $0x4d
  jmp alltraps
80106300:	e9 82 f8 ff ff       	jmp    80105b87 <alltraps>

80106305 <vector78>:
.globl vector78
vector78:
  pushl $0
80106305:	6a 00                	push   $0x0
  pushl $78
80106307:	6a 4e                	push   $0x4e
  jmp alltraps
80106309:	e9 79 f8 ff ff       	jmp    80105b87 <alltraps>

8010630e <vector79>:
.globl vector79
vector79:
  pushl $0
8010630e:	6a 00                	push   $0x0
  pushl $79
80106310:	6a 4f                	push   $0x4f
  jmp alltraps
80106312:	e9 70 f8 ff ff       	jmp    80105b87 <alltraps>

80106317 <vector80>:
.globl vector80
vector80:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $80
80106319:	6a 50                	push   $0x50
  jmp alltraps
8010631b:	e9 67 f8 ff ff       	jmp    80105b87 <alltraps>

80106320 <vector81>:
.globl vector81
vector81:
  pushl $0
80106320:	6a 00                	push   $0x0
  pushl $81
80106322:	6a 51                	push   $0x51
  jmp alltraps
80106324:	e9 5e f8 ff ff       	jmp    80105b87 <alltraps>

80106329 <vector82>:
.globl vector82
vector82:
  pushl $0
80106329:	6a 00                	push   $0x0
  pushl $82
8010632b:	6a 52                	push   $0x52
  jmp alltraps
8010632d:	e9 55 f8 ff ff       	jmp    80105b87 <alltraps>

80106332 <vector83>:
.globl vector83
vector83:
  pushl $0
80106332:	6a 00                	push   $0x0
  pushl $83
80106334:	6a 53                	push   $0x53
  jmp alltraps
80106336:	e9 4c f8 ff ff       	jmp    80105b87 <alltraps>

8010633b <vector84>:
.globl vector84
vector84:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $84
8010633d:	6a 54                	push   $0x54
  jmp alltraps
8010633f:	e9 43 f8 ff ff       	jmp    80105b87 <alltraps>

80106344 <vector85>:
.globl vector85
vector85:
  pushl $0
80106344:	6a 00                	push   $0x0
  pushl $85
80106346:	6a 55                	push   $0x55
  jmp alltraps
80106348:	e9 3a f8 ff ff       	jmp    80105b87 <alltraps>

8010634d <vector86>:
.globl vector86
vector86:
  pushl $0
8010634d:	6a 00                	push   $0x0
  pushl $86
8010634f:	6a 56                	push   $0x56
  jmp alltraps
80106351:	e9 31 f8 ff ff       	jmp    80105b87 <alltraps>

80106356 <vector87>:
.globl vector87
vector87:
  pushl $0
80106356:	6a 00                	push   $0x0
  pushl $87
80106358:	6a 57                	push   $0x57
  jmp alltraps
8010635a:	e9 28 f8 ff ff       	jmp    80105b87 <alltraps>

8010635f <vector88>:
.globl vector88
vector88:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $88
80106361:	6a 58                	push   $0x58
  jmp alltraps
80106363:	e9 1f f8 ff ff       	jmp    80105b87 <alltraps>

80106368 <vector89>:
.globl vector89
vector89:
  pushl $0
80106368:	6a 00                	push   $0x0
  pushl $89
8010636a:	6a 59                	push   $0x59
  jmp alltraps
8010636c:	e9 16 f8 ff ff       	jmp    80105b87 <alltraps>

80106371 <vector90>:
.globl vector90
vector90:
  pushl $0
80106371:	6a 00                	push   $0x0
  pushl $90
80106373:	6a 5a                	push   $0x5a
  jmp alltraps
80106375:	e9 0d f8 ff ff       	jmp    80105b87 <alltraps>

8010637a <vector91>:
.globl vector91
vector91:
  pushl $0
8010637a:	6a 00                	push   $0x0
  pushl $91
8010637c:	6a 5b                	push   $0x5b
  jmp alltraps
8010637e:	e9 04 f8 ff ff       	jmp    80105b87 <alltraps>

80106383 <vector92>:
.globl vector92
vector92:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $92
80106385:	6a 5c                	push   $0x5c
  jmp alltraps
80106387:	e9 fb f7 ff ff       	jmp    80105b87 <alltraps>

8010638c <vector93>:
.globl vector93
vector93:
  pushl $0
8010638c:	6a 00                	push   $0x0
  pushl $93
8010638e:	6a 5d                	push   $0x5d
  jmp alltraps
80106390:	e9 f2 f7 ff ff       	jmp    80105b87 <alltraps>

80106395 <vector94>:
.globl vector94
vector94:
  pushl $0
80106395:	6a 00                	push   $0x0
  pushl $94
80106397:	6a 5e                	push   $0x5e
  jmp alltraps
80106399:	e9 e9 f7 ff ff       	jmp    80105b87 <alltraps>

8010639e <vector95>:
.globl vector95
vector95:
  pushl $0
8010639e:	6a 00                	push   $0x0
  pushl $95
801063a0:	6a 5f                	push   $0x5f
  jmp alltraps
801063a2:	e9 e0 f7 ff ff       	jmp    80105b87 <alltraps>

801063a7 <vector96>:
.globl vector96
vector96:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $96
801063a9:	6a 60                	push   $0x60
  jmp alltraps
801063ab:	e9 d7 f7 ff ff       	jmp    80105b87 <alltraps>

801063b0 <vector97>:
.globl vector97
vector97:
  pushl $0
801063b0:	6a 00                	push   $0x0
  pushl $97
801063b2:	6a 61                	push   $0x61
  jmp alltraps
801063b4:	e9 ce f7 ff ff       	jmp    80105b87 <alltraps>

801063b9 <vector98>:
.globl vector98
vector98:
  pushl $0
801063b9:	6a 00                	push   $0x0
  pushl $98
801063bb:	6a 62                	push   $0x62
  jmp alltraps
801063bd:	e9 c5 f7 ff ff       	jmp    80105b87 <alltraps>

801063c2 <vector99>:
.globl vector99
vector99:
  pushl $0
801063c2:	6a 00                	push   $0x0
  pushl $99
801063c4:	6a 63                	push   $0x63
  jmp alltraps
801063c6:	e9 bc f7 ff ff       	jmp    80105b87 <alltraps>

801063cb <vector100>:
.globl vector100
vector100:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $100
801063cd:	6a 64                	push   $0x64
  jmp alltraps
801063cf:	e9 b3 f7 ff ff       	jmp    80105b87 <alltraps>

801063d4 <vector101>:
.globl vector101
vector101:
  pushl $0
801063d4:	6a 00                	push   $0x0
  pushl $101
801063d6:	6a 65                	push   $0x65
  jmp alltraps
801063d8:	e9 aa f7 ff ff       	jmp    80105b87 <alltraps>

801063dd <vector102>:
.globl vector102
vector102:
  pushl $0
801063dd:	6a 00                	push   $0x0
  pushl $102
801063df:	6a 66                	push   $0x66
  jmp alltraps
801063e1:	e9 a1 f7 ff ff       	jmp    80105b87 <alltraps>

801063e6 <vector103>:
.globl vector103
vector103:
  pushl $0
801063e6:	6a 00                	push   $0x0
  pushl $103
801063e8:	6a 67                	push   $0x67
  jmp alltraps
801063ea:	e9 98 f7 ff ff       	jmp    80105b87 <alltraps>

801063ef <vector104>:
.globl vector104
vector104:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $104
801063f1:	6a 68                	push   $0x68
  jmp alltraps
801063f3:	e9 8f f7 ff ff       	jmp    80105b87 <alltraps>

801063f8 <vector105>:
.globl vector105
vector105:
  pushl $0
801063f8:	6a 00                	push   $0x0
  pushl $105
801063fa:	6a 69                	push   $0x69
  jmp alltraps
801063fc:	e9 86 f7 ff ff       	jmp    80105b87 <alltraps>

80106401 <vector106>:
.globl vector106
vector106:
  pushl $0
80106401:	6a 00                	push   $0x0
  pushl $106
80106403:	6a 6a                	push   $0x6a
  jmp alltraps
80106405:	e9 7d f7 ff ff       	jmp    80105b87 <alltraps>

8010640a <vector107>:
.globl vector107
vector107:
  pushl $0
8010640a:	6a 00                	push   $0x0
  pushl $107
8010640c:	6a 6b                	push   $0x6b
  jmp alltraps
8010640e:	e9 74 f7 ff ff       	jmp    80105b87 <alltraps>

80106413 <vector108>:
.globl vector108
vector108:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $108
80106415:	6a 6c                	push   $0x6c
  jmp alltraps
80106417:	e9 6b f7 ff ff       	jmp    80105b87 <alltraps>

8010641c <vector109>:
.globl vector109
vector109:
  pushl $0
8010641c:	6a 00                	push   $0x0
  pushl $109
8010641e:	6a 6d                	push   $0x6d
  jmp alltraps
80106420:	e9 62 f7 ff ff       	jmp    80105b87 <alltraps>

80106425 <vector110>:
.globl vector110
vector110:
  pushl $0
80106425:	6a 00                	push   $0x0
  pushl $110
80106427:	6a 6e                	push   $0x6e
  jmp alltraps
80106429:	e9 59 f7 ff ff       	jmp    80105b87 <alltraps>

8010642e <vector111>:
.globl vector111
vector111:
  pushl $0
8010642e:	6a 00                	push   $0x0
  pushl $111
80106430:	6a 6f                	push   $0x6f
  jmp alltraps
80106432:	e9 50 f7 ff ff       	jmp    80105b87 <alltraps>

80106437 <vector112>:
.globl vector112
vector112:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $112
80106439:	6a 70                	push   $0x70
  jmp alltraps
8010643b:	e9 47 f7 ff ff       	jmp    80105b87 <alltraps>

80106440 <vector113>:
.globl vector113
vector113:
  pushl $0
80106440:	6a 00                	push   $0x0
  pushl $113
80106442:	6a 71                	push   $0x71
  jmp alltraps
80106444:	e9 3e f7 ff ff       	jmp    80105b87 <alltraps>

80106449 <vector114>:
.globl vector114
vector114:
  pushl $0
80106449:	6a 00                	push   $0x0
  pushl $114
8010644b:	6a 72                	push   $0x72
  jmp alltraps
8010644d:	e9 35 f7 ff ff       	jmp    80105b87 <alltraps>

80106452 <vector115>:
.globl vector115
vector115:
  pushl $0
80106452:	6a 00                	push   $0x0
  pushl $115
80106454:	6a 73                	push   $0x73
  jmp alltraps
80106456:	e9 2c f7 ff ff       	jmp    80105b87 <alltraps>

8010645b <vector116>:
.globl vector116
vector116:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $116
8010645d:	6a 74                	push   $0x74
  jmp alltraps
8010645f:	e9 23 f7 ff ff       	jmp    80105b87 <alltraps>

80106464 <vector117>:
.globl vector117
vector117:
  pushl $0
80106464:	6a 00                	push   $0x0
  pushl $117
80106466:	6a 75                	push   $0x75
  jmp alltraps
80106468:	e9 1a f7 ff ff       	jmp    80105b87 <alltraps>

8010646d <vector118>:
.globl vector118
vector118:
  pushl $0
8010646d:	6a 00                	push   $0x0
  pushl $118
8010646f:	6a 76                	push   $0x76
  jmp alltraps
80106471:	e9 11 f7 ff ff       	jmp    80105b87 <alltraps>

80106476 <vector119>:
.globl vector119
vector119:
  pushl $0
80106476:	6a 00                	push   $0x0
  pushl $119
80106478:	6a 77                	push   $0x77
  jmp alltraps
8010647a:	e9 08 f7 ff ff       	jmp    80105b87 <alltraps>

8010647f <vector120>:
.globl vector120
vector120:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $120
80106481:	6a 78                	push   $0x78
  jmp alltraps
80106483:	e9 ff f6 ff ff       	jmp    80105b87 <alltraps>

80106488 <vector121>:
.globl vector121
vector121:
  pushl $0
80106488:	6a 00                	push   $0x0
  pushl $121
8010648a:	6a 79                	push   $0x79
  jmp alltraps
8010648c:	e9 f6 f6 ff ff       	jmp    80105b87 <alltraps>

80106491 <vector122>:
.globl vector122
vector122:
  pushl $0
80106491:	6a 00                	push   $0x0
  pushl $122
80106493:	6a 7a                	push   $0x7a
  jmp alltraps
80106495:	e9 ed f6 ff ff       	jmp    80105b87 <alltraps>

8010649a <vector123>:
.globl vector123
vector123:
  pushl $0
8010649a:	6a 00                	push   $0x0
  pushl $123
8010649c:	6a 7b                	push   $0x7b
  jmp alltraps
8010649e:	e9 e4 f6 ff ff       	jmp    80105b87 <alltraps>

801064a3 <vector124>:
.globl vector124
vector124:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $124
801064a5:	6a 7c                	push   $0x7c
  jmp alltraps
801064a7:	e9 db f6 ff ff       	jmp    80105b87 <alltraps>

801064ac <vector125>:
.globl vector125
vector125:
  pushl $0
801064ac:	6a 00                	push   $0x0
  pushl $125
801064ae:	6a 7d                	push   $0x7d
  jmp alltraps
801064b0:	e9 d2 f6 ff ff       	jmp    80105b87 <alltraps>

801064b5 <vector126>:
.globl vector126
vector126:
  pushl $0
801064b5:	6a 00                	push   $0x0
  pushl $126
801064b7:	6a 7e                	push   $0x7e
  jmp alltraps
801064b9:	e9 c9 f6 ff ff       	jmp    80105b87 <alltraps>

801064be <vector127>:
.globl vector127
vector127:
  pushl $0
801064be:	6a 00                	push   $0x0
  pushl $127
801064c0:	6a 7f                	push   $0x7f
  jmp alltraps
801064c2:	e9 c0 f6 ff ff       	jmp    80105b87 <alltraps>

801064c7 <vector128>:
.globl vector128
vector128:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $128
801064c9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801064ce:	e9 b4 f6 ff ff       	jmp    80105b87 <alltraps>

801064d3 <vector129>:
.globl vector129
vector129:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $129
801064d5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801064da:	e9 a8 f6 ff ff       	jmp    80105b87 <alltraps>

801064df <vector130>:
.globl vector130
vector130:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $130
801064e1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801064e6:	e9 9c f6 ff ff       	jmp    80105b87 <alltraps>

801064eb <vector131>:
.globl vector131
vector131:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $131
801064ed:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801064f2:	e9 90 f6 ff ff       	jmp    80105b87 <alltraps>

801064f7 <vector132>:
.globl vector132
vector132:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $132
801064f9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801064fe:	e9 84 f6 ff ff       	jmp    80105b87 <alltraps>

80106503 <vector133>:
.globl vector133
vector133:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $133
80106505:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010650a:	e9 78 f6 ff ff       	jmp    80105b87 <alltraps>

8010650f <vector134>:
.globl vector134
vector134:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $134
80106511:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106516:	e9 6c f6 ff ff       	jmp    80105b87 <alltraps>

8010651b <vector135>:
.globl vector135
vector135:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $135
8010651d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106522:	e9 60 f6 ff ff       	jmp    80105b87 <alltraps>

80106527 <vector136>:
.globl vector136
vector136:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $136
80106529:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010652e:	e9 54 f6 ff ff       	jmp    80105b87 <alltraps>

80106533 <vector137>:
.globl vector137
vector137:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $137
80106535:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010653a:	e9 48 f6 ff ff       	jmp    80105b87 <alltraps>

8010653f <vector138>:
.globl vector138
vector138:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $138
80106541:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106546:	e9 3c f6 ff ff       	jmp    80105b87 <alltraps>

8010654b <vector139>:
.globl vector139
vector139:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $139
8010654d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106552:	e9 30 f6 ff ff       	jmp    80105b87 <alltraps>

80106557 <vector140>:
.globl vector140
vector140:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $140
80106559:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010655e:	e9 24 f6 ff ff       	jmp    80105b87 <alltraps>

80106563 <vector141>:
.globl vector141
vector141:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $141
80106565:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010656a:	e9 18 f6 ff ff       	jmp    80105b87 <alltraps>

8010656f <vector142>:
.globl vector142
vector142:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $142
80106571:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106576:	e9 0c f6 ff ff       	jmp    80105b87 <alltraps>

8010657b <vector143>:
.globl vector143
vector143:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $143
8010657d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106582:	e9 00 f6 ff ff       	jmp    80105b87 <alltraps>

80106587 <vector144>:
.globl vector144
vector144:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $144
80106589:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010658e:	e9 f4 f5 ff ff       	jmp    80105b87 <alltraps>

80106593 <vector145>:
.globl vector145
vector145:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $145
80106595:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010659a:	e9 e8 f5 ff ff       	jmp    80105b87 <alltraps>

8010659f <vector146>:
.globl vector146
vector146:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $146
801065a1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801065a6:	e9 dc f5 ff ff       	jmp    80105b87 <alltraps>

801065ab <vector147>:
.globl vector147
vector147:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $147
801065ad:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801065b2:	e9 d0 f5 ff ff       	jmp    80105b87 <alltraps>

801065b7 <vector148>:
.globl vector148
vector148:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $148
801065b9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801065be:	e9 c4 f5 ff ff       	jmp    80105b87 <alltraps>

801065c3 <vector149>:
.globl vector149
vector149:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $149
801065c5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801065ca:	e9 b8 f5 ff ff       	jmp    80105b87 <alltraps>

801065cf <vector150>:
.globl vector150
vector150:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $150
801065d1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801065d6:	e9 ac f5 ff ff       	jmp    80105b87 <alltraps>

801065db <vector151>:
.globl vector151
vector151:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $151
801065dd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801065e2:	e9 a0 f5 ff ff       	jmp    80105b87 <alltraps>

801065e7 <vector152>:
.globl vector152
vector152:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $152
801065e9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801065ee:	e9 94 f5 ff ff       	jmp    80105b87 <alltraps>

801065f3 <vector153>:
.globl vector153
vector153:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $153
801065f5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801065fa:	e9 88 f5 ff ff       	jmp    80105b87 <alltraps>

801065ff <vector154>:
.globl vector154
vector154:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $154
80106601:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106606:	e9 7c f5 ff ff       	jmp    80105b87 <alltraps>

8010660b <vector155>:
.globl vector155
vector155:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $155
8010660d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106612:	e9 70 f5 ff ff       	jmp    80105b87 <alltraps>

80106617 <vector156>:
.globl vector156
vector156:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $156
80106619:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010661e:	e9 64 f5 ff ff       	jmp    80105b87 <alltraps>

80106623 <vector157>:
.globl vector157
vector157:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $157
80106625:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010662a:	e9 58 f5 ff ff       	jmp    80105b87 <alltraps>

8010662f <vector158>:
.globl vector158
vector158:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $158
80106631:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106636:	e9 4c f5 ff ff       	jmp    80105b87 <alltraps>

8010663b <vector159>:
.globl vector159
vector159:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $159
8010663d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106642:	e9 40 f5 ff ff       	jmp    80105b87 <alltraps>

80106647 <vector160>:
.globl vector160
vector160:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $160
80106649:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010664e:	e9 34 f5 ff ff       	jmp    80105b87 <alltraps>

80106653 <vector161>:
.globl vector161
vector161:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $161
80106655:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010665a:	e9 28 f5 ff ff       	jmp    80105b87 <alltraps>

8010665f <vector162>:
.globl vector162
vector162:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $162
80106661:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106666:	e9 1c f5 ff ff       	jmp    80105b87 <alltraps>

8010666b <vector163>:
.globl vector163
vector163:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $163
8010666d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106672:	e9 10 f5 ff ff       	jmp    80105b87 <alltraps>

80106677 <vector164>:
.globl vector164
vector164:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $164
80106679:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010667e:	e9 04 f5 ff ff       	jmp    80105b87 <alltraps>

80106683 <vector165>:
.globl vector165
vector165:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $165
80106685:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010668a:	e9 f8 f4 ff ff       	jmp    80105b87 <alltraps>

8010668f <vector166>:
.globl vector166
vector166:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $166
80106691:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106696:	e9 ec f4 ff ff       	jmp    80105b87 <alltraps>

8010669b <vector167>:
.globl vector167
vector167:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $167
8010669d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801066a2:	e9 e0 f4 ff ff       	jmp    80105b87 <alltraps>

801066a7 <vector168>:
.globl vector168
vector168:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $168
801066a9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801066ae:	e9 d4 f4 ff ff       	jmp    80105b87 <alltraps>

801066b3 <vector169>:
.globl vector169
vector169:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $169
801066b5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801066ba:	e9 c8 f4 ff ff       	jmp    80105b87 <alltraps>

801066bf <vector170>:
.globl vector170
vector170:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $170
801066c1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801066c6:	e9 bc f4 ff ff       	jmp    80105b87 <alltraps>

801066cb <vector171>:
.globl vector171
vector171:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $171
801066cd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801066d2:	e9 b0 f4 ff ff       	jmp    80105b87 <alltraps>

801066d7 <vector172>:
.globl vector172
vector172:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $172
801066d9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801066de:	e9 a4 f4 ff ff       	jmp    80105b87 <alltraps>

801066e3 <vector173>:
.globl vector173
vector173:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $173
801066e5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801066ea:	e9 98 f4 ff ff       	jmp    80105b87 <alltraps>

801066ef <vector174>:
.globl vector174
vector174:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $174
801066f1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801066f6:	e9 8c f4 ff ff       	jmp    80105b87 <alltraps>

801066fb <vector175>:
.globl vector175
vector175:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $175
801066fd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106702:	e9 80 f4 ff ff       	jmp    80105b87 <alltraps>

80106707 <vector176>:
.globl vector176
vector176:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $176
80106709:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010670e:	e9 74 f4 ff ff       	jmp    80105b87 <alltraps>

80106713 <vector177>:
.globl vector177
vector177:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $177
80106715:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010671a:	e9 68 f4 ff ff       	jmp    80105b87 <alltraps>

8010671f <vector178>:
.globl vector178
vector178:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $178
80106721:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106726:	e9 5c f4 ff ff       	jmp    80105b87 <alltraps>

8010672b <vector179>:
.globl vector179
vector179:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $179
8010672d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106732:	e9 50 f4 ff ff       	jmp    80105b87 <alltraps>

80106737 <vector180>:
.globl vector180
vector180:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $180
80106739:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010673e:	e9 44 f4 ff ff       	jmp    80105b87 <alltraps>

80106743 <vector181>:
.globl vector181
vector181:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $181
80106745:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010674a:	e9 38 f4 ff ff       	jmp    80105b87 <alltraps>

8010674f <vector182>:
.globl vector182
vector182:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $182
80106751:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106756:	e9 2c f4 ff ff       	jmp    80105b87 <alltraps>

8010675b <vector183>:
.globl vector183
vector183:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $183
8010675d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106762:	e9 20 f4 ff ff       	jmp    80105b87 <alltraps>

80106767 <vector184>:
.globl vector184
vector184:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $184
80106769:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010676e:	e9 14 f4 ff ff       	jmp    80105b87 <alltraps>

80106773 <vector185>:
.globl vector185
vector185:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $185
80106775:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010677a:	e9 08 f4 ff ff       	jmp    80105b87 <alltraps>

8010677f <vector186>:
.globl vector186
vector186:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $186
80106781:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106786:	e9 fc f3 ff ff       	jmp    80105b87 <alltraps>

8010678b <vector187>:
.globl vector187
vector187:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $187
8010678d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106792:	e9 f0 f3 ff ff       	jmp    80105b87 <alltraps>

80106797 <vector188>:
.globl vector188
vector188:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $188
80106799:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010679e:	e9 e4 f3 ff ff       	jmp    80105b87 <alltraps>

801067a3 <vector189>:
.globl vector189
vector189:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $189
801067a5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801067aa:	e9 d8 f3 ff ff       	jmp    80105b87 <alltraps>

801067af <vector190>:
.globl vector190
vector190:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $190
801067b1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801067b6:	e9 cc f3 ff ff       	jmp    80105b87 <alltraps>

801067bb <vector191>:
.globl vector191
vector191:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $191
801067bd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801067c2:	e9 c0 f3 ff ff       	jmp    80105b87 <alltraps>

801067c7 <vector192>:
.globl vector192
vector192:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $192
801067c9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801067ce:	e9 b4 f3 ff ff       	jmp    80105b87 <alltraps>

801067d3 <vector193>:
.globl vector193
vector193:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $193
801067d5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801067da:	e9 a8 f3 ff ff       	jmp    80105b87 <alltraps>

801067df <vector194>:
.globl vector194
vector194:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $194
801067e1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801067e6:	e9 9c f3 ff ff       	jmp    80105b87 <alltraps>

801067eb <vector195>:
.globl vector195
vector195:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $195
801067ed:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801067f2:	e9 90 f3 ff ff       	jmp    80105b87 <alltraps>

801067f7 <vector196>:
.globl vector196
vector196:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $196
801067f9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801067fe:	e9 84 f3 ff ff       	jmp    80105b87 <alltraps>

80106803 <vector197>:
.globl vector197
vector197:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $197
80106805:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010680a:	e9 78 f3 ff ff       	jmp    80105b87 <alltraps>

8010680f <vector198>:
.globl vector198
vector198:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $198
80106811:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106816:	e9 6c f3 ff ff       	jmp    80105b87 <alltraps>

8010681b <vector199>:
.globl vector199
vector199:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $199
8010681d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106822:	e9 60 f3 ff ff       	jmp    80105b87 <alltraps>

80106827 <vector200>:
.globl vector200
vector200:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $200
80106829:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010682e:	e9 54 f3 ff ff       	jmp    80105b87 <alltraps>

80106833 <vector201>:
.globl vector201
vector201:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $201
80106835:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010683a:	e9 48 f3 ff ff       	jmp    80105b87 <alltraps>

8010683f <vector202>:
.globl vector202
vector202:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $202
80106841:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106846:	e9 3c f3 ff ff       	jmp    80105b87 <alltraps>

8010684b <vector203>:
.globl vector203
vector203:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $203
8010684d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106852:	e9 30 f3 ff ff       	jmp    80105b87 <alltraps>

80106857 <vector204>:
.globl vector204
vector204:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $204
80106859:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010685e:	e9 24 f3 ff ff       	jmp    80105b87 <alltraps>

80106863 <vector205>:
.globl vector205
vector205:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $205
80106865:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010686a:	e9 18 f3 ff ff       	jmp    80105b87 <alltraps>

8010686f <vector206>:
.globl vector206
vector206:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $206
80106871:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106876:	e9 0c f3 ff ff       	jmp    80105b87 <alltraps>

8010687b <vector207>:
.globl vector207
vector207:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $207
8010687d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106882:	e9 00 f3 ff ff       	jmp    80105b87 <alltraps>

80106887 <vector208>:
.globl vector208
vector208:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $208
80106889:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010688e:	e9 f4 f2 ff ff       	jmp    80105b87 <alltraps>

80106893 <vector209>:
.globl vector209
vector209:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $209
80106895:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010689a:	e9 e8 f2 ff ff       	jmp    80105b87 <alltraps>

8010689f <vector210>:
.globl vector210
vector210:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $210
801068a1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801068a6:	e9 dc f2 ff ff       	jmp    80105b87 <alltraps>

801068ab <vector211>:
.globl vector211
vector211:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $211
801068ad:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801068b2:	e9 d0 f2 ff ff       	jmp    80105b87 <alltraps>

801068b7 <vector212>:
.globl vector212
vector212:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $212
801068b9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801068be:	e9 c4 f2 ff ff       	jmp    80105b87 <alltraps>

801068c3 <vector213>:
.globl vector213
vector213:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $213
801068c5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801068ca:	e9 b8 f2 ff ff       	jmp    80105b87 <alltraps>

801068cf <vector214>:
.globl vector214
vector214:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $214
801068d1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801068d6:	e9 ac f2 ff ff       	jmp    80105b87 <alltraps>

801068db <vector215>:
.globl vector215
vector215:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $215
801068dd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801068e2:	e9 a0 f2 ff ff       	jmp    80105b87 <alltraps>

801068e7 <vector216>:
.globl vector216
vector216:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $216
801068e9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801068ee:	e9 94 f2 ff ff       	jmp    80105b87 <alltraps>

801068f3 <vector217>:
.globl vector217
vector217:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $217
801068f5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801068fa:	e9 88 f2 ff ff       	jmp    80105b87 <alltraps>

801068ff <vector218>:
.globl vector218
vector218:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $218
80106901:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106906:	e9 7c f2 ff ff       	jmp    80105b87 <alltraps>

8010690b <vector219>:
.globl vector219
vector219:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $219
8010690d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106912:	e9 70 f2 ff ff       	jmp    80105b87 <alltraps>

80106917 <vector220>:
.globl vector220
vector220:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $220
80106919:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010691e:	e9 64 f2 ff ff       	jmp    80105b87 <alltraps>

80106923 <vector221>:
.globl vector221
vector221:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $221
80106925:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010692a:	e9 58 f2 ff ff       	jmp    80105b87 <alltraps>

8010692f <vector222>:
.globl vector222
vector222:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $222
80106931:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106936:	e9 4c f2 ff ff       	jmp    80105b87 <alltraps>

8010693b <vector223>:
.globl vector223
vector223:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $223
8010693d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106942:	e9 40 f2 ff ff       	jmp    80105b87 <alltraps>

80106947 <vector224>:
.globl vector224
vector224:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $224
80106949:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010694e:	e9 34 f2 ff ff       	jmp    80105b87 <alltraps>

80106953 <vector225>:
.globl vector225
vector225:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $225
80106955:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010695a:	e9 28 f2 ff ff       	jmp    80105b87 <alltraps>

8010695f <vector226>:
.globl vector226
vector226:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $226
80106961:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106966:	e9 1c f2 ff ff       	jmp    80105b87 <alltraps>

8010696b <vector227>:
.globl vector227
vector227:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $227
8010696d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106972:	e9 10 f2 ff ff       	jmp    80105b87 <alltraps>

80106977 <vector228>:
.globl vector228
vector228:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $228
80106979:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010697e:	e9 04 f2 ff ff       	jmp    80105b87 <alltraps>

80106983 <vector229>:
.globl vector229
vector229:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $229
80106985:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010698a:	e9 f8 f1 ff ff       	jmp    80105b87 <alltraps>

8010698f <vector230>:
.globl vector230
vector230:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $230
80106991:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106996:	e9 ec f1 ff ff       	jmp    80105b87 <alltraps>

8010699b <vector231>:
.globl vector231
vector231:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $231
8010699d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801069a2:	e9 e0 f1 ff ff       	jmp    80105b87 <alltraps>

801069a7 <vector232>:
.globl vector232
vector232:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $232
801069a9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801069ae:	e9 d4 f1 ff ff       	jmp    80105b87 <alltraps>

801069b3 <vector233>:
.globl vector233
vector233:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $233
801069b5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801069ba:	e9 c8 f1 ff ff       	jmp    80105b87 <alltraps>

801069bf <vector234>:
.globl vector234
vector234:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $234
801069c1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801069c6:	e9 bc f1 ff ff       	jmp    80105b87 <alltraps>

801069cb <vector235>:
.globl vector235
vector235:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $235
801069cd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801069d2:	e9 b0 f1 ff ff       	jmp    80105b87 <alltraps>

801069d7 <vector236>:
.globl vector236
vector236:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $236
801069d9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801069de:	e9 a4 f1 ff ff       	jmp    80105b87 <alltraps>

801069e3 <vector237>:
.globl vector237
vector237:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $237
801069e5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801069ea:	e9 98 f1 ff ff       	jmp    80105b87 <alltraps>

801069ef <vector238>:
.globl vector238
vector238:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $238
801069f1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801069f6:	e9 8c f1 ff ff       	jmp    80105b87 <alltraps>

801069fb <vector239>:
.globl vector239
vector239:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $239
801069fd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106a02:	e9 80 f1 ff ff       	jmp    80105b87 <alltraps>

80106a07 <vector240>:
.globl vector240
vector240:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $240
80106a09:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106a0e:	e9 74 f1 ff ff       	jmp    80105b87 <alltraps>

80106a13 <vector241>:
.globl vector241
vector241:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $241
80106a15:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106a1a:	e9 68 f1 ff ff       	jmp    80105b87 <alltraps>

80106a1f <vector242>:
.globl vector242
vector242:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $242
80106a21:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106a26:	e9 5c f1 ff ff       	jmp    80105b87 <alltraps>

80106a2b <vector243>:
.globl vector243
vector243:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $243
80106a2d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106a32:	e9 50 f1 ff ff       	jmp    80105b87 <alltraps>

80106a37 <vector244>:
.globl vector244
vector244:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $244
80106a39:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106a3e:	e9 44 f1 ff ff       	jmp    80105b87 <alltraps>

80106a43 <vector245>:
.globl vector245
vector245:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $245
80106a45:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106a4a:	e9 38 f1 ff ff       	jmp    80105b87 <alltraps>

80106a4f <vector246>:
.globl vector246
vector246:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $246
80106a51:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106a56:	e9 2c f1 ff ff       	jmp    80105b87 <alltraps>

80106a5b <vector247>:
.globl vector247
vector247:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $247
80106a5d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106a62:	e9 20 f1 ff ff       	jmp    80105b87 <alltraps>

80106a67 <vector248>:
.globl vector248
vector248:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $248
80106a69:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106a6e:	e9 14 f1 ff ff       	jmp    80105b87 <alltraps>

80106a73 <vector249>:
.globl vector249
vector249:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $249
80106a75:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106a7a:	e9 08 f1 ff ff       	jmp    80105b87 <alltraps>

80106a7f <vector250>:
.globl vector250
vector250:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $250
80106a81:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106a86:	e9 fc f0 ff ff       	jmp    80105b87 <alltraps>

80106a8b <vector251>:
.globl vector251
vector251:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $251
80106a8d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106a92:	e9 f0 f0 ff ff       	jmp    80105b87 <alltraps>

80106a97 <vector252>:
.globl vector252
vector252:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $252
80106a99:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106a9e:	e9 e4 f0 ff ff       	jmp    80105b87 <alltraps>

80106aa3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $253
80106aa5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106aaa:	e9 d8 f0 ff ff       	jmp    80105b87 <alltraps>

80106aaf <vector254>:
.globl vector254
vector254:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $254
80106ab1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106ab6:	e9 cc f0 ff ff       	jmp    80105b87 <alltraps>

80106abb <vector255>:
.globl vector255
vector255:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $255
80106abd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ac2:	e9 c0 f0 ff ff       	jmp    80105b87 <alltraps>
80106ac7:	66 90                	xchg   %ax,%ax
80106ac9:	66 90                	xchg   %ax,%ax
80106acb:	66 90                	xchg   %ax,%ax
80106acd:	66 90                	xchg   %ax,%ax
80106acf:	90                   	nop

80106ad0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106ad0:	55                   	push   %ebp
80106ad1:	89 e5                	mov    %esp,%ebp
80106ad3:	57                   	push   %edi
80106ad4:	56                   	push   %esi
80106ad5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106ad6:	89 d3                	mov    %edx,%ebx
{
80106ad8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106ada:	c1 eb 16             	shr    $0x16,%ebx
80106add:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106ae0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106ae3:	8b 06                	mov    (%esi),%eax
80106ae5:	a8 01                	test   $0x1,%al
80106ae7:	74 27                	je     80106b10 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ae9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106aee:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106af4:	c1 ef 0a             	shr    $0xa,%edi
}
80106af7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106afa:	89 fa                	mov    %edi,%edx
80106afc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106b02:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106b05:	5b                   	pop    %ebx
80106b06:	5e                   	pop    %esi
80106b07:	5f                   	pop    %edi
80106b08:	5d                   	pop    %ebp
80106b09:	c3                   	ret    
80106b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106b10:	85 c9                	test   %ecx,%ecx
80106b12:	74 2c                	je     80106b40 <walkpgdir+0x70>
80106b14:	e8 47 bd ff ff       	call   80102860 <kalloc>
80106b19:	85 c0                	test   %eax,%eax
80106b1b:	89 c3                	mov    %eax,%ebx
80106b1d:	74 21                	je     80106b40 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106b1f:	83 ec 04             	sub    $0x4,%esp
80106b22:	68 00 10 00 00       	push   $0x1000
80106b27:	6a 00                	push   $0x0
80106b29:	50                   	push   %eax
80106b2a:	e8 f1 dd ff ff       	call   80104920 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b2f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b35:	83 c4 10             	add    $0x10,%esp
80106b38:	83 c8 07             	or     $0x7,%eax
80106b3b:	89 06                	mov    %eax,(%esi)
80106b3d:	eb b5                	jmp    80106af4 <walkpgdir+0x24>
80106b3f:	90                   	nop
}
80106b40:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106b43:	31 c0                	xor    %eax,%eax
}
80106b45:	5b                   	pop    %ebx
80106b46:	5e                   	pop    %esi
80106b47:	5f                   	pop    %edi
80106b48:	5d                   	pop    %ebp
80106b49:	c3                   	ret    
80106b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b50 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106b50:	55                   	push   %ebp
80106b51:	89 e5                	mov    %esp,%ebp
80106b53:	57                   	push   %edi
80106b54:	56                   	push   %esi
80106b55:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106b56:	89 d3                	mov    %edx,%ebx
80106b58:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106b5e:	83 ec 1c             	sub    $0x1c,%esp
80106b61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b64:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106b68:	8b 7d 08             	mov    0x8(%ebp),%edi
80106b6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b70:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106b73:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b76:	29 df                	sub    %ebx,%edi
80106b78:	83 c8 01             	or     $0x1,%eax
80106b7b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106b7e:	eb 15                	jmp    80106b95 <mappages+0x45>
    if(*pte & PTE_P)
80106b80:	f6 00 01             	testb  $0x1,(%eax)
80106b83:	75 45                	jne    80106bca <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106b85:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106b88:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106b8b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106b8d:	74 31                	je     80106bc0 <mappages+0x70>
      break;
    a += PGSIZE;
80106b8f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b98:	b9 01 00 00 00       	mov    $0x1,%ecx
80106b9d:	89 da                	mov    %ebx,%edx
80106b9f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106ba2:	e8 29 ff ff ff       	call   80106ad0 <walkpgdir>
80106ba7:	85 c0                	test   %eax,%eax
80106ba9:	75 d5                	jne    80106b80 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106bab:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106bae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106bb3:	5b                   	pop    %ebx
80106bb4:	5e                   	pop    %esi
80106bb5:	5f                   	pop    %edi
80106bb6:	5d                   	pop    %ebp
80106bb7:	c3                   	ret    
80106bb8:	90                   	nop
80106bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106bc3:	31 c0                	xor    %eax,%eax
}
80106bc5:	5b                   	pop    %ebx
80106bc6:	5e                   	pop    %esi
80106bc7:	5f                   	pop    %edi
80106bc8:	5d                   	pop    %ebp
80106bc9:	c3                   	ret    
      panic("remap");
80106bca:	83 ec 0c             	sub    $0xc,%esp
80106bcd:	68 f4 7e 10 80       	push   $0x80107ef4
80106bd2:	e8 b9 97 ff ff       	call   80100390 <panic>
80106bd7:	89 f6                	mov    %esi,%esi
80106bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106be0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106be0:	55                   	push   %ebp
80106be1:	89 e5                	mov    %esp,%ebp
80106be3:	57                   	push   %edi
80106be4:	56                   	push   %esi
80106be5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106be6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106bec:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106bee:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106bf4:	83 ec 1c             	sub    $0x1c,%esp
80106bf7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106bfa:	39 d3                	cmp    %edx,%ebx
80106bfc:	73 66                	jae    80106c64 <deallocuvm.part.0+0x84>
80106bfe:	89 d6                	mov    %edx,%esi
80106c00:	eb 3d                	jmp    80106c3f <deallocuvm.part.0+0x5f>
80106c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106c08:	8b 10                	mov    (%eax),%edx
80106c0a:	f6 c2 01             	test   $0x1,%dl
80106c0d:	74 26                	je     80106c35 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106c0f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106c15:	74 58                	je     80106c6f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106c17:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106c1a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106c20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106c23:	52                   	push   %edx
80106c24:	e8 87 ba ff ff       	call   801026b0 <kfree>
      *pte = 0;
80106c29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c2c:	83 c4 10             	add    $0x10,%esp
80106c2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106c35:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c3b:	39 f3                	cmp    %esi,%ebx
80106c3d:	73 25                	jae    80106c64 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106c3f:	31 c9                	xor    %ecx,%ecx
80106c41:	89 da                	mov    %ebx,%edx
80106c43:	89 f8                	mov    %edi,%eax
80106c45:	e8 86 fe ff ff       	call   80106ad0 <walkpgdir>
    if(!pte)
80106c4a:	85 c0                	test   %eax,%eax
80106c4c:	75 ba                	jne    80106c08 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106c4e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106c54:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106c5a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c60:	39 f3                	cmp    %esi,%ebx
80106c62:	72 db                	jb     80106c3f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106c64:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c6a:	5b                   	pop    %ebx
80106c6b:	5e                   	pop    %esi
80106c6c:	5f                   	pop    %edi
80106c6d:	5d                   	pop    %ebp
80106c6e:	c3                   	ret    
        panic("kfree");
80106c6f:	83 ec 0c             	sub    $0xc,%esp
80106c72:	68 2a 78 10 80       	push   $0x8010782a
80106c77:	e8 14 97 ff ff       	call   80100390 <panic>
80106c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c80 <seginit>:
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106c86:	e8 d5 ce ff ff       	call   80103b60 <cpuid>
80106c8b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106c91:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106c96:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106c9a:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
80106ca1:	ff 00 00 
80106ca4:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
80106cab:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106cae:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
80106cb5:	ff 00 00 
80106cb8:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
80106cbf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106cc2:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
80106cc9:	ff 00 00 
80106ccc:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
80106cd3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106cd6:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
80106cdd:	ff 00 00 
80106ce0:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
80106ce7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106cea:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
80106cef:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106cf3:	c1 e8 10             	shr    $0x10,%eax
80106cf6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106cfa:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106cfd:	0f 01 10             	lgdtl  (%eax)
}
80106d00:	c9                   	leave  
80106d01:	c3                   	ret    
80106d02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d10 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d10:	a1 a4 68 11 80       	mov    0x801168a4,%eax
{
80106d15:	55                   	push   %ebp
80106d16:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d18:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d1d:	0f 22 d8             	mov    %eax,%cr3
}
80106d20:	5d                   	pop    %ebp
80106d21:	c3                   	ret    
80106d22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d30 <switchuvm>:
{
80106d30:	55                   	push   %ebp
80106d31:	89 e5                	mov    %esp,%ebp
80106d33:	57                   	push   %edi
80106d34:	56                   	push   %esi
80106d35:	53                   	push   %ebx
80106d36:	83 ec 1c             	sub    $0x1c,%esp
80106d39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106d3c:	85 db                	test   %ebx,%ebx
80106d3e:	0f 84 cb 00 00 00    	je     80106e0f <switchuvm+0xdf>
  if(p->kstack == 0)
80106d44:	8b 43 08             	mov    0x8(%ebx),%eax
80106d47:	85 c0                	test   %eax,%eax
80106d49:	0f 84 da 00 00 00    	je     80106e29 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106d4f:	8b 43 04             	mov    0x4(%ebx),%eax
80106d52:	85 c0                	test   %eax,%eax
80106d54:	0f 84 c2 00 00 00    	je     80106e1c <switchuvm+0xec>
  pushcli();
80106d5a:	e8 01 da ff ff       	call   80104760 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d5f:	e8 7c cd ff ff       	call   80103ae0 <mycpu>
80106d64:	89 c6                	mov    %eax,%esi
80106d66:	e8 75 cd ff ff       	call   80103ae0 <mycpu>
80106d6b:	89 c7                	mov    %eax,%edi
80106d6d:	e8 6e cd ff ff       	call   80103ae0 <mycpu>
80106d72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d75:	83 c7 08             	add    $0x8,%edi
80106d78:	e8 63 cd ff ff       	call   80103ae0 <mycpu>
80106d7d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d80:	83 c0 08             	add    $0x8,%eax
80106d83:	ba 67 00 00 00       	mov    $0x67,%edx
80106d88:	c1 e8 18             	shr    $0x18,%eax
80106d8b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106d92:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106d99:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d9f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106da4:	83 c1 08             	add    $0x8,%ecx
80106da7:	c1 e9 10             	shr    $0x10,%ecx
80106daa:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106db0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106db5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106dbc:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106dc1:	e8 1a cd ff ff       	call   80103ae0 <mycpu>
80106dc6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106dcd:	e8 0e cd ff ff       	call   80103ae0 <mycpu>
80106dd2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106dd6:	8b 73 08             	mov    0x8(%ebx),%esi
80106dd9:	e8 02 cd ff ff       	call   80103ae0 <mycpu>
80106dde:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106de4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106de7:	e8 f4 cc ff ff       	call   80103ae0 <mycpu>
80106dec:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106df0:	b8 28 00 00 00       	mov    $0x28,%eax
80106df5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106df8:	8b 43 04             	mov    0x4(%ebx),%eax
80106dfb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e00:	0f 22 d8             	mov    %eax,%cr3
}
80106e03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e06:	5b                   	pop    %ebx
80106e07:	5e                   	pop    %esi
80106e08:	5f                   	pop    %edi
80106e09:	5d                   	pop    %ebp
  popcli();
80106e0a:	e9 51 da ff ff       	jmp    80104860 <popcli>
    panic("switchuvm: no process");
80106e0f:	83 ec 0c             	sub    $0xc,%esp
80106e12:	68 fa 7e 10 80       	push   $0x80107efa
80106e17:	e8 74 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106e1c:	83 ec 0c             	sub    $0xc,%esp
80106e1f:	68 25 7f 10 80       	push   $0x80107f25
80106e24:	e8 67 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106e29:	83 ec 0c             	sub    $0xc,%esp
80106e2c:	68 10 7f 10 80       	push   $0x80107f10
80106e31:	e8 5a 95 ff ff       	call   80100390 <panic>
80106e36:	8d 76 00             	lea    0x0(%esi),%esi
80106e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e40 <inituvm>:
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	57                   	push   %edi
80106e44:	56                   	push   %esi
80106e45:	53                   	push   %ebx
80106e46:	83 ec 1c             	sub    $0x1c,%esp
80106e49:	8b 75 10             	mov    0x10(%ebp),%esi
80106e4c:	8b 45 08             	mov    0x8(%ebp),%eax
80106e4f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106e52:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106e58:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106e5b:	77 49                	ja     80106ea6 <inituvm+0x66>
  mem = kalloc();
80106e5d:	e8 fe b9 ff ff       	call   80102860 <kalloc>
  memset(mem, 0, PGSIZE);
80106e62:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106e65:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106e67:	68 00 10 00 00       	push   $0x1000
80106e6c:	6a 00                	push   $0x0
80106e6e:	50                   	push   %eax
80106e6f:	e8 ac da ff ff       	call   80104920 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106e74:	58                   	pop    %eax
80106e75:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e7b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e80:	5a                   	pop    %edx
80106e81:	6a 06                	push   $0x6
80106e83:	50                   	push   %eax
80106e84:	31 d2                	xor    %edx,%edx
80106e86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e89:	e8 c2 fc ff ff       	call   80106b50 <mappages>
  memmove(mem, init, sz);
80106e8e:	89 75 10             	mov    %esi,0x10(%ebp)
80106e91:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106e94:	83 c4 10             	add    $0x10,%esp
80106e97:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106e9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e9d:	5b                   	pop    %ebx
80106e9e:	5e                   	pop    %esi
80106e9f:	5f                   	pop    %edi
80106ea0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106ea1:	e9 2a db ff ff       	jmp    801049d0 <memmove>
    panic("inituvm: more than a page");
80106ea6:	83 ec 0c             	sub    $0xc,%esp
80106ea9:	68 39 7f 10 80       	push   $0x80107f39
80106eae:	e8 dd 94 ff ff       	call   80100390 <panic>
80106eb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ec0 <loaduvm>:
{
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	57                   	push   %edi
80106ec4:	56                   	push   %esi
80106ec5:	53                   	push   %ebx
80106ec6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106ec9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106ed0:	0f 85 91 00 00 00    	jne    80106f67 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106ed6:	8b 75 18             	mov    0x18(%ebp),%esi
80106ed9:	31 db                	xor    %ebx,%ebx
80106edb:	85 f6                	test   %esi,%esi
80106edd:	75 1a                	jne    80106ef9 <loaduvm+0x39>
80106edf:	eb 6f                	jmp    80106f50 <loaduvm+0x90>
80106ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ee8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106eee:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106ef4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106ef7:	76 57                	jbe    80106f50 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106ef9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106efc:	8b 45 08             	mov    0x8(%ebp),%eax
80106eff:	31 c9                	xor    %ecx,%ecx
80106f01:	01 da                	add    %ebx,%edx
80106f03:	e8 c8 fb ff ff       	call   80106ad0 <walkpgdir>
80106f08:	85 c0                	test   %eax,%eax
80106f0a:	74 4e                	je     80106f5a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106f0c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f0e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106f11:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106f16:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106f1b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106f21:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f24:	01 d9                	add    %ebx,%ecx
80106f26:	05 00 00 00 80       	add    $0x80000000,%eax
80106f2b:	57                   	push   %edi
80106f2c:	51                   	push   %ecx
80106f2d:	50                   	push   %eax
80106f2e:	ff 75 10             	pushl  0x10(%ebp)
80106f31:	e8 3a aa ff ff       	call   80101970 <readi>
80106f36:	83 c4 10             	add    $0x10,%esp
80106f39:	39 f8                	cmp    %edi,%eax
80106f3b:	74 ab                	je     80106ee8 <loaduvm+0x28>
}
80106f3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f45:	5b                   	pop    %ebx
80106f46:	5e                   	pop    %esi
80106f47:	5f                   	pop    %edi
80106f48:	5d                   	pop    %ebp
80106f49:	c3                   	ret    
80106f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f53:	31 c0                	xor    %eax,%eax
}
80106f55:	5b                   	pop    %ebx
80106f56:	5e                   	pop    %esi
80106f57:	5f                   	pop    %edi
80106f58:	5d                   	pop    %ebp
80106f59:	c3                   	ret    
      panic("loaduvm: address should exist");
80106f5a:	83 ec 0c             	sub    $0xc,%esp
80106f5d:	68 53 7f 10 80       	push   $0x80107f53
80106f62:	e8 29 94 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106f67:	83 ec 0c             	sub    $0xc,%esp
80106f6a:	68 08 80 10 80       	push   $0x80108008
80106f6f:	e8 1c 94 ff ff       	call   80100390 <panic>
80106f74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f80 <allocuvm>:
{
80106f80:	55                   	push   %ebp
80106f81:	89 e5                	mov    %esp,%ebp
80106f83:	57                   	push   %edi
80106f84:	56                   	push   %esi
80106f85:	53                   	push   %ebx
80106f86:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106f89:	8b 7d 10             	mov    0x10(%ebp),%edi
80106f8c:	85 ff                	test   %edi,%edi
80106f8e:	0f 88 8e 00 00 00    	js     80107022 <allocuvm+0xa2>
  if(newsz < oldsz)
80106f94:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106f97:	0f 82 93 00 00 00    	jb     80107030 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80106f9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fa0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106fa6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106fac:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106faf:	0f 86 7e 00 00 00    	jbe    80107033 <allocuvm+0xb3>
80106fb5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106fb8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106fbb:	eb 42                	jmp    80106fff <allocuvm+0x7f>
80106fbd:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106fc0:	83 ec 04             	sub    $0x4,%esp
80106fc3:	68 00 10 00 00       	push   $0x1000
80106fc8:	6a 00                	push   $0x0
80106fca:	50                   	push   %eax
80106fcb:	e8 50 d9 ff ff       	call   80104920 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106fd0:	58                   	pop    %eax
80106fd1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106fd7:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106fdc:	5a                   	pop    %edx
80106fdd:	6a 06                	push   $0x6
80106fdf:	50                   	push   %eax
80106fe0:	89 da                	mov    %ebx,%edx
80106fe2:	89 f8                	mov    %edi,%eax
80106fe4:	e8 67 fb ff ff       	call   80106b50 <mappages>
80106fe9:	83 c4 10             	add    $0x10,%esp
80106fec:	85 c0                	test   %eax,%eax
80106fee:	78 50                	js     80107040 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80106ff0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ff6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106ff9:	0f 86 81 00 00 00    	jbe    80107080 <allocuvm+0x100>
    mem = kalloc();
80106fff:	e8 5c b8 ff ff       	call   80102860 <kalloc>
    if(mem == 0){
80107004:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107006:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107008:	75 b6                	jne    80106fc0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010700a:	83 ec 0c             	sub    $0xc,%esp
8010700d:	68 71 7f 10 80       	push   $0x80107f71
80107012:	e8 49 96 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107017:	83 c4 10             	add    $0x10,%esp
8010701a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010701d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107020:	77 6e                	ja     80107090 <allocuvm+0x110>
}
80107022:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107025:	31 ff                	xor    %edi,%edi
}
80107027:	89 f8                	mov    %edi,%eax
80107029:	5b                   	pop    %ebx
8010702a:	5e                   	pop    %esi
8010702b:	5f                   	pop    %edi
8010702c:	5d                   	pop    %ebp
8010702d:	c3                   	ret    
8010702e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107030:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107033:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107036:	89 f8                	mov    %edi,%eax
80107038:	5b                   	pop    %ebx
80107039:	5e                   	pop    %esi
8010703a:	5f                   	pop    %edi
8010703b:	5d                   	pop    %ebp
8010703c:	c3                   	ret    
8010703d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107040:	83 ec 0c             	sub    $0xc,%esp
80107043:	68 89 7f 10 80       	push   $0x80107f89
80107048:	e8 13 96 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010704d:	83 c4 10             	add    $0x10,%esp
80107050:	8b 45 0c             	mov    0xc(%ebp),%eax
80107053:	39 45 10             	cmp    %eax,0x10(%ebp)
80107056:	76 0d                	jbe    80107065 <allocuvm+0xe5>
80107058:	89 c1                	mov    %eax,%ecx
8010705a:	8b 55 10             	mov    0x10(%ebp),%edx
8010705d:	8b 45 08             	mov    0x8(%ebp),%eax
80107060:	e8 7b fb ff ff       	call   80106be0 <deallocuvm.part.0>
      kfree(mem);
80107065:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107068:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010706a:	56                   	push   %esi
8010706b:	e8 40 b6 ff ff       	call   801026b0 <kfree>
      return 0;
80107070:	83 c4 10             	add    $0x10,%esp
}
80107073:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107076:	89 f8                	mov    %edi,%eax
80107078:	5b                   	pop    %ebx
80107079:	5e                   	pop    %esi
8010707a:	5f                   	pop    %edi
8010707b:	5d                   	pop    %ebp
8010707c:	c3                   	ret    
8010707d:	8d 76 00             	lea    0x0(%esi),%esi
80107080:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107083:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107086:	5b                   	pop    %ebx
80107087:	89 f8                	mov    %edi,%eax
80107089:	5e                   	pop    %esi
8010708a:	5f                   	pop    %edi
8010708b:	5d                   	pop    %ebp
8010708c:	c3                   	ret    
8010708d:	8d 76 00             	lea    0x0(%esi),%esi
80107090:	89 c1                	mov    %eax,%ecx
80107092:	8b 55 10             	mov    0x10(%ebp),%edx
80107095:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107098:	31 ff                	xor    %edi,%edi
8010709a:	e8 41 fb ff ff       	call   80106be0 <deallocuvm.part.0>
8010709f:	eb 92                	jmp    80107033 <allocuvm+0xb3>
801070a1:	eb 0d                	jmp    801070b0 <deallocuvm>
801070a3:	90                   	nop
801070a4:	90                   	nop
801070a5:	90                   	nop
801070a6:	90                   	nop
801070a7:	90                   	nop
801070a8:	90                   	nop
801070a9:	90                   	nop
801070aa:	90                   	nop
801070ab:	90                   	nop
801070ac:	90                   	nop
801070ad:	90                   	nop
801070ae:	90                   	nop
801070af:	90                   	nop

801070b0 <deallocuvm>:
{
801070b0:	55                   	push   %ebp
801070b1:	89 e5                	mov    %esp,%ebp
801070b3:	8b 55 0c             	mov    0xc(%ebp),%edx
801070b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801070b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801070bc:	39 d1                	cmp    %edx,%ecx
801070be:	73 10                	jae    801070d0 <deallocuvm+0x20>
}
801070c0:	5d                   	pop    %ebp
801070c1:	e9 1a fb ff ff       	jmp    80106be0 <deallocuvm.part.0>
801070c6:	8d 76 00             	lea    0x0(%esi),%esi
801070c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801070d0:	89 d0                	mov    %edx,%eax
801070d2:	5d                   	pop    %ebp
801070d3:	c3                   	ret    
801070d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801070e0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	57                   	push   %edi
801070e4:	56                   	push   %esi
801070e5:	53                   	push   %ebx
801070e6:	83 ec 0c             	sub    $0xc,%esp
801070e9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801070ec:	85 f6                	test   %esi,%esi
801070ee:	74 59                	je     80107149 <freevm+0x69>
801070f0:	31 c9                	xor    %ecx,%ecx
801070f2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801070f7:	89 f0                	mov    %esi,%eax
801070f9:	e8 e2 fa ff ff       	call   80106be0 <deallocuvm.part.0>
801070fe:	89 f3                	mov    %esi,%ebx
80107100:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107106:	eb 0f                	jmp    80107117 <freevm+0x37>
80107108:	90                   	nop
80107109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107110:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107113:	39 fb                	cmp    %edi,%ebx
80107115:	74 23                	je     8010713a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107117:	8b 03                	mov    (%ebx),%eax
80107119:	a8 01                	test   $0x1,%al
8010711b:	74 f3                	je     80107110 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010711d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107122:	83 ec 0c             	sub    $0xc,%esp
80107125:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107128:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010712d:	50                   	push   %eax
8010712e:	e8 7d b5 ff ff       	call   801026b0 <kfree>
80107133:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107136:	39 fb                	cmp    %edi,%ebx
80107138:	75 dd                	jne    80107117 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010713a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010713d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107140:	5b                   	pop    %ebx
80107141:	5e                   	pop    %esi
80107142:	5f                   	pop    %edi
80107143:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107144:	e9 67 b5 ff ff       	jmp    801026b0 <kfree>
    panic("freevm: no pgdir");
80107149:	83 ec 0c             	sub    $0xc,%esp
8010714c:	68 a5 7f 10 80       	push   $0x80107fa5
80107151:	e8 3a 92 ff ff       	call   80100390 <panic>
80107156:	8d 76 00             	lea    0x0(%esi),%esi
80107159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107160 <setupkvm>:
{
80107160:	55                   	push   %ebp
80107161:	89 e5                	mov    %esp,%ebp
80107163:	56                   	push   %esi
80107164:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107165:	e8 f6 b6 ff ff       	call   80102860 <kalloc>
8010716a:	85 c0                	test   %eax,%eax
8010716c:	89 c6                	mov    %eax,%esi
8010716e:	74 42                	je     801071b2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107170:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107173:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107178:	68 00 10 00 00       	push   $0x1000
8010717d:	6a 00                	push   $0x0
8010717f:	50                   	push   %eax
80107180:	e8 9b d7 ff ff       	call   80104920 <memset>
80107185:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107188:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010718b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010718e:	83 ec 08             	sub    $0x8,%esp
80107191:	8b 13                	mov    (%ebx),%edx
80107193:	ff 73 0c             	pushl  0xc(%ebx)
80107196:	50                   	push   %eax
80107197:	29 c1                	sub    %eax,%ecx
80107199:	89 f0                	mov    %esi,%eax
8010719b:	e8 b0 f9 ff ff       	call   80106b50 <mappages>
801071a0:	83 c4 10             	add    $0x10,%esp
801071a3:	85 c0                	test   %eax,%eax
801071a5:	78 19                	js     801071c0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801071a7:	83 c3 10             	add    $0x10,%ebx
801071aa:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801071b0:	75 d6                	jne    80107188 <setupkvm+0x28>
}
801071b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071b5:	89 f0                	mov    %esi,%eax
801071b7:	5b                   	pop    %ebx
801071b8:	5e                   	pop    %esi
801071b9:	5d                   	pop    %ebp
801071ba:	c3                   	ret    
801071bb:	90                   	nop
801071bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801071c0:	83 ec 0c             	sub    $0xc,%esp
801071c3:	56                   	push   %esi
      return 0;
801071c4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801071c6:	e8 15 ff ff ff       	call   801070e0 <freevm>
      return 0;
801071cb:	83 c4 10             	add    $0x10,%esp
}
801071ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071d1:	89 f0                	mov    %esi,%eax
801071d3:	5b                   	pop    %ebx
801071d4:	5e                   	pop    %esi
801071d5:	5d                   	pop    %ebp
801071d6:	c3                   	ret    
801071d7:	89 f6                	mov    %esi,%esi
801071d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071e0 <kvmalloc>:
{
801071e0:	55                   	push   %ebp
801071e1:	89 e5                	mov    %esp,%ebp
801071e3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801071e6:	e8 75 ff ff ff       	call   80107160 <setupkvm>
801071eb:	a3 a4 68 11 80       	mov    %eax,0x801168a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801071f0:	05 00 00 00 80       	add    $0x80000000,%eax
801071f5:	0f 22 d8             	mov    %eax,%cr3
}
801071f8:	c9                   	leave  
801071f9:	c3                   	ret    
801071fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107200 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107200:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107201:	31 c9                	xor    %ecx,%ecx
{
80107203:	89 e5                	mov    %esp,%ebp
80107205:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107208:	8b 55 0c             	mov    0xc(%ebp),%edx
8010720b:	8b 45 08             	mov    0x8(%ebp),%eax
8010720e:	e8 bd f8 ff ff       	call   80106ad0 <walkpgdir>
  if(pte == 0)
80107213:	85 c0                	test   %eax,%eax
80107215:	74 05                	je     8010721c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107217:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010721a:	c9                   	leave  
8010721b:	c3                   	ret    
    panic("clearpteu");
8010721c:	83 ec 0c             	sub    $0xc,%esp
8010721f:	68 b6 7f 10 80       	push   $0x80107fb6
80107224:	e8 67 91 ff ff       	call   80100390 <panic>
80107229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107230 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	57                   	push   %edi
80107234:	56                   	push   %esi
80107235:	53                   	push   %ebx
80107236:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107239:	e8 22 ff ff ff       	call   80107160 <setupkvm>
8010723e:	85 c0                	test   %eax,%eax
80107240:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107243:	0f 84 a0 00 00 00    	je     801072e9 <copyuvm+0xb9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107249:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010724c:	85 c9                	test   %ecx,%ecx
8010724e:	0f 84 95 00 00 00    	je     801072e9 <copyuvm+0xb9>
80107254:	31 f6                	xor    %esi,%esi
80107256:	eb 4e                	jmp    801072a6 <copyuvm+0x76>
80107258:	90                   	nop
80107259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107260:	83 ec 04             	sub    $0x4,%esp
80107263:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107269:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010726c:	68 00 10 00 00       	push   $0x1000
80107271:	57                   	push   %edi
80107272:	50                   	push   %eax
80107273:	e8 58 d7 ff ff       	call   801049d0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107278:	58                   	pop    %eax
80107279:	5a                   	pop    %edx
8010727a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010727d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107280:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107285:	53                   	push   %ebx
80107286:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010728c:	52                   	push   %edx
8010728d:	89 f2                	mov    %esi,%edx
8010728f:	e8 bc f8 ff ff       	call   80106b50 <mappages>
80107294:	83 c4 10             	add    $0x10,%esp
80107297:	85 c0                	test   %eax,%eax
80107299:	78 39                	js     801072d4 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
8010729b:	81 c6 00 10 00 00    	add    $0x1000,%esi
801072a1:	39 75 0c             	cmp    %esi,0xc(%ebp)
801072a4:	76 43                	jbe    801072e9 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801072a6:	8b 45 08             	mov    0x8(%ebp),%eax
801072a9:	31 c9                	xor    %ecx,%ecx
801072ab:	89 f2                	mov    %esi,%edx
801072ad:	e8 1e f8 ff ff       	call   80106ad0 <walkpgdir>
801072b2:	85 c0                	test   %eax,%eax
801072b4:	74 3e                	je     801072f4 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
801072b6:	8b 18                	mov    (%eax),%ebx
801072b8:	f6 c3 01             	test   $0x1,%bl
801072bb:	74 44                	je     80107301 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
801072bd:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
801072bf:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
801072c5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801072cb:	e8 90 b5 ff ff       	call   80102860 <kalloc>
801072d0:	85 c0                	test   %eax,%eax
801072d2:	75 8c                	jne    80107260 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
801072d4:	83 ec 0c             	sub    $0xc,%esp
801072d7:	ff 75 e0             	pushl  -0x20(%ebp)
801072da:	e8 01 fe ff ff       	call   801070e0 <freevm>
  return 0;
801072df:	83 c4 10             	add    $0x10,%esp
801072e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801072e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072ef:	5b                   	pop    %ebx
801072f0:	5e                   	pop    %esi
801072f1:	5f                   	pop    %edi
801072f2:	5d                   	pop    %ebp
801072f3:	c3                   	ret    
      panic("copyuvm: pte should exist");
801072f4:	83 ec 0c             	sub    $0xc,%esp
801072f7:	68 c0 7f 10 80       	push   $0x80107fc0
801072fc:	e8 8f 90 ff ff       	call   80100390 <panic>
      panic("copyuvm: page not present");
80107301:	83 ec 0c             	sub    $0xc,%esp
80107304:	68 da 7f 10 80       	push   $0x80107fda
80107309:	e8 82 90 ff ff       	call   80100390 <panic>
8010730e:	66 90                	xchg   %ax,%ax

80107310 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107310:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107311:	31 c9                	xor    %ecx,%ecx
{
80107313:	89 e5                	mov    %esp,%ebp
80107315:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107318:	8b 55 0c             	mov    0xc(%ebp),%edx
8010731b:	8b 45 08             	mov    0x8(%ebp),%eax
8010731e:	e8 ad f7 ff ff       	call   80106ad0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107323:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107325:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107326:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107328:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010732d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107330:	05 00 00 00 80       	add    $0x80000000,%eax
80107335:	83 fa 05             	cmp    $0x5,%edx
80107338:	ba 00 00 00 00       	mov    $0x0,%edx
8010733d:	0f 45 c2             	cmovne %edx,%eax
}
80107340:	c3                   	ret    
80107341:	eb 0d                	jmp    80107350 <copyout>
80107343:	90                   	nop
80107344:	90                   	nop
80107345:	90                   	nop
80107346:	90                   	nop
80107347:	90                   	nop
80107348:	90                   	nop
80107349:	90                   	nop
8010734a:	90                   	nop
8010734b:	90                   	nop
8010734c:	90                   	nop
8010734d:	90                   	nop
8010734e:	90                   	nop
8010734f:	90                   	nop

80107350 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107350:	55                   	push   %ebp
80107351:	89 e5                	mov    %esp,%ebp
80107353:	57                   	push   %edi
80107354:	56                   	push   %esi
80107355:	53                   	push   %ebx
80107356:	83 ec 1c             	sub    $0x1c,%esp
80107359:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010735c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010735f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107362:	85 db                	test   %ebx,%ebx
80107364:	75 40                	jne    801073a6 <copyout+0x56>
80107366:	eb 70                	jmp    801073d8 <copyout+0x88>
80107368:	90                   	nop
80107369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107370:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107373:	89 f1                	mov    %esi,%ecx
80107375:	29 d1                	sub    %edx,%ecx
80107377:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010737d:	39 d9                	cmp    %ebx,%ecx
8010737f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107382:	29 f2                	sub    %esi,%edx
80107384:	83 ec 04             	sub    $0x4,%esp
80107387:	01 d0                	add    %edx,%eax
80107389:	51                   	push   %ecx
8010738a:	57                   	push   %edi
8010738b:	50                   	push   %eax
8010738c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010738f:	e8 3c d6 ff ff       	call   801049d0 <memmove>
    len -= n;
    buf += n;
80107394:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107397:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010739a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
801073a0:	01 cf                	add    %ecx,%edi
  while(len > 0){
801073a2:	29 cb                	sub    %ecx,%ebx
801073a4:	74 32                	je     801073d8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801073a6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801073a8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801073ab:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801073ae:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801073b4:	56                   	push   %esi
801073b5:	ff 75 08             	pushl  0x8(%ebp)
801073b8:	e8 53 ff ff ff       	call   80107310 <uva2ka>
    if(pa0 == 0)
801073bd:	83 c4 10             	add    $0x10,%esp
801073c0:	85 c0                	test   %eax,%eax
801073c2:	75 ac                	jne    80107370 <copyout+0x20>
  }
  return 0;
}
801073c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801073c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073cc:	5b                   	pop    %ebx
801073cd:	5e                   	pop    %esi
801073ce:	5f                   	pop    %edi
801073cf:	5d                   	pop    %ebp
801073d0:	c3                   	ret    
801073d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801073db:	31 c0                	xor    %eax,%eax
}
801073dd:	5b                   	pop    %ebx
801073de:	5e                   	pop    %esi
801073df:	5f                   	pop    %edi
801073e0:	5d                   	pop    %ebp
801073e1:	c3                   	ret    
801073e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073f0 <swapIn>:
  }
  return 1;
}

// Executes page-in from Disk to RAM.
int swapIn(uint *pte, uint faultAdd){
801073f0:	55                   	push   %ebp
801073f1:	89 e5                	mov    %esp,%ebp
801073f3:	57                   	push   %edi
801073f4:	56                   	push   %esi
801073f5:	53                   	push   %ebx
801073f6:	83 ec 1c             	sub    $0x1c,%esp
  struct proc* curProc = myproc();
801073f9:	e8 82 c7 ff ff       	call   80103b80 <myproc>
801073fe:	89 c3                	mov    %eax,%ebx
  char* mem = kalloc(); // allocate physical memory (size of page)
80107400:	e8 5b b4 ff ff       	call   80102860 <kalloc>
  char* pageStart = (char*)PGROUNDDOWN(faultAdd); // gets the start point of the page (removes offset)
80107405:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int maped = mappages(curProc->pgdir,pageStart,PGSIZE,V2P(mem), PTE_U); // mapes the virtual memory of the page fault to the new allocated memory
80107408:	8b 73 04             	mov    0x4(%ebx),%esi
8010740b:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80107411:	83 ec 08             	sub    $0x8,%esp
80107414:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107419:	6a 04                	push   $0x4
8010741b:	52                   	push   %edx
  char* pageStart = (char*)PGROUNDDOWN(faultAdd); // gets the start point of the page (removes offset)
8010741c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  int maped = mappages(curProc->pgdir,pageStart,PGSIZE,V2P(mem), PTE_U); // mapes the virtual memory of the page fault to the new allocated memory
80107422:	89 f0                	mov    %esi,%eax
80107424:	89 fa                	mov    %edi,%edx
  char* pageStart = (char*)PGROUNDDOWN(faultAdd); // gets the start point of the page (removes offset)
80107426:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  int maped = mappages(curProc->pgdir,pageStart,PGSIZE,V2P(mem), PTE_U); // mapes the virtual memory of the page fault to the new allocated memory
80107429:	e8 22 f7 ff ff       	call   80106b50 <mappages>
  if(!maped)
8010742e:	83 c4 10             	add    $0x10,%esp
80107431:	85 c0                	test   %eax,%eax
80107433:	0f 84 83 00 00 00    	je     801074bc <swapIn+0xcc>
    return -1;
  int offset = -1;
  char* pa = (char*)(PTE_ADDR(*pte));
80107439:	8b 45 08             	mov    0x8(%ebp),%eax
8010743c:	8b 8b 80 00 00 00    	mov    0x80(%ebx),%ecx
80107442:	8b 10                	mov    (%eax),%edx
80107444:	8d b9 80 01 00 00    	lea    0x180(%ecx),%edi
  char* va = (char*)(P2V((uint)(pa)));
  for (int i=0; i<MAX_TOTAL_PAGES; i++){ // find the cell that contains the meta-data of this page
    if (curProc->procSwappedFiles[i].va == va){
8010744a:	89 c8                	mov    %ecx,%eax
  char* pa = (char*)(PTE_ADDR(*pte));
8010744c:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  char* va = (char*)(P2V((uint)(pa)));
80107452:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107458:	eb 0d                	jmp    80107467 <swapIn+0x77>
8010745a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107460:	83 c0 0c             	add    $0xc,%eax
  for (int i=0; i<MAX_TOTAL_PAGES; i++){ // find the cell that contains the meta-data of this page
80107463:	39 f8                	cmp    %edi,%eax
80107465:	74 51                	je     801074b8 <swapIn+0xc8>
80107467:	89 c6                	mov    %eax,%esi
80107469:	29 ce                	sub    %ecx,%esi
    if (curProc->procSwappedFiles[i].va == va){
8010746b:	39 10                	cmp    %edx,(%eax)
8010746d:	75 f1                	jne    80107460 <swapIn+0x70>
      curProc->procSwappedFiles[i].va = 0;
8010746f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      offset = curProc->procSwappedFiles[i].offsetInFile;
80107475:	03 b3 80 00 00 00    	add    0x80(%ebx),%esi
8010747b:	8b 46 04             	mov    0x4(%esi),%eax
      curProc->procSwappedFiles[i].isOccupied = 0; // cell is not needed anymore
8010747e:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
80107485:	83 c0 01             	add    $0x1,%eax
      break;
    }
  }
  readFromSwapFile(curProc, (char*)V2P(pageStart), offset+1, PGSIZE);
80107488:	68 00 10 00 00       	push   $0x1000
8010748d:	50                   	push   %eax
8010748e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107491:	05 00 00 00 80       	add    $0x80000000,%eax
80107496:	50                   	push   %eax
80107497:	53                   	push   %ebx
80107498:	e8 f3 ad ff ff       	call   80102290 <readFromSwapFile>
  curProc->numOfPhysPages++;
8010749d:	83 83 84 00 00 00 01 	addl   $0x1,0x84(%ebx)
  return 1;
801074a4:	83 c4 10             	add    $0x10,%esp
801074a7:	b8 01 00 00 00       	mov    $0x1,%eax
}
801074ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074af:	5b                   	pop    %ebx
801074b0:	5e                   	pop    %esi
801074b1:	5f                   	pop    %edi
801074b2:	5d                   	pop    %ebp
801074b3:	c3                   	ret    
801074b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074b8:	31 c0                	xor    %eax,%eax
801074ba:	eb cc                	jmp    80107488 <swapIn+0x98>
    return -1;
801074bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074c1:	eb e9                	jmp    801074ac <swapIn+0xbc>
801074c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801074c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801074d0 <checkIfNeedSwapping>:
int checkIfNeedSwapping(){
801074d0:	55                   	push   %ebp
801074d1:	89 e5                	mov    %esp,%ebp
801074d3:	53                   	push   %ebx
801074d4:	83 ec 24             	sub    $0x24,%esp
  struct proc *curProc = myproc();
801074d7:	e8 a4 c6 ff ff       	call   80103b80 <myproc>
  asm volatile("movl %%cr2,%0" : "=r" (val));
801074dc:	0f 20 d1             	mov    %cr2,%ecx
  pde = &curProc->pgdir[PDX(&faultingAddress)];
801074df:	8d 55 f4             	lea    -0xc(%ebp),%edx
  if (*pde & PTE_P){
801074e2:	8b 58 04             	mov    0x4(%eax),%ebx
  uint faultingAddress = rcr2(); // contains the address that register %cr2 holds
801074e5:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  pde = &curProc->pgdir[PDX(&faultingAddress)];
801074e8:	c1 ea 16             	shr    $0x16,%edx
  if (*pde & PTE_P){
801074eb:	8b 14 93             	mov    (%ebx,%edx,4),%edx
801074ee:	f6 c2 01             	test   $0x1,%dl
801074f1:	74 5d                	je     80107550 <checkIfNeedSwapping+0x80>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));; // Page is Present, swapping isn't needed
801074f3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if (*pgtab & PTE_PG) { // Page was paged-out to disk, paged-in is needed
801074f9:	f6 82 01 00 00 80 02 	testb  $0x2,-0x7fffffff(%edx)
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));; // Page is Present, swapping isn't needed
80107500:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
  if (*pgtab & PTE_PG) { // Page was paged-out to disk, paged-in is needed
80107506:	74 4f                	je     80107557 <checkIfNeedSwapping+0x87>
    if (curProc->numOfPhysPages >= MAX_PSYC_PAGES){ // Check if swapping is needed
80107508:	83 b8 84 00 00 00 0f 	cmpl   $0xf,0x84(%eax)
8010750f:	7f 1f                	jg     80107530 <checkIfNeedSwapping+0x60>
      swapIn(pgtab, faultingAddress);
80107511:	83 ec 08             	sub    $0x8,%esp
80107514:	51                   	push   %ecx
80107515:	53                   	push   %ebx
80107516:	e8 d5 fe ff ff       	call   801073f0 <swapIn>
8010751b:	83 c4 10             	add    $0x10,%esp
  return 1;
8010751e:	b8 01 00 00 00       	mov    $0x1,%eax
}
80107523:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107526:	c9                   	leave  
80107527:	c3                   	ret    
80107528:	90                   	nop
80107529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      swap(pgtab, faultingAddress);
80107530:	83 ec 08             	sub    $0x8,%esp
80107533:	51                   	push   %ecx
80107534:	53                   	push   %ebx
80107535:	e8 56 d0 ff ff       	call   80104590 <swap>
8010753a:	83 c4 10             	add    $0x10,%esp
  return 1;
8010753d:	b8 01 00 00 00       	mov    $0x1,%eax
}
80107542:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107545:	c9                   	leave  
80107546:	c3                   	ret    
80107547:	89 f6                	mov    %esi,%esi
80107549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80107550:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107555:	eb cc                	jmp    80107523 <checkIfNeedSwapping+0x53>
    cprintf("segmentation fault\n");
80107557:	83 ec 0c             	sub    $0xc,%esp
8010755a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010755d:	68 f4 7f 10 80       	push   $0x80107ff4
80107562:	e8 f9 90 ff ff       	call   80100660 <cprintf>
    curProc->killed = 1;
80107567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    return -1;
8010756a:	83 c4 10             	add    $0x10,%esp
    curProc->killed = 1;
8010756d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
    return -1;
80107574:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107579:	eb a8                	jmp    80107523 <checkIfNeedSwapping+0x53>
