
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
8010002d:	b8 b0 33 10 80       	mov    $0x801033b0,%eax
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
8010004c:	68 80 7e 10 80       	push   $0x80107e80
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 65 4c 00 00       	call   80104cc0 <initlock>
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
80100092:	68 87 7e 10 80       	push   $0x80107e87
80100097:	50                   	push   %eax
80100098:	e8 13 4b 00 00       	call   80104bb0 <initsleeplock>
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
801000e4:	e8 c7 4c 00 00       	call   80104db0 <acquire>
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
80100162:	e8 69 4d 00 00       	call   80104ed0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 7e 4a 00 00       	call   80104bf0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 ad 24 00 00       	call   80102630 <iderw>
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
80100193:	68 8e 7e 10 80       	push   $0x80107e8e
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
801001ae:	e8 dd 4a 00 00       	call   80104c90 <holdingsleep>
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
801001c4:	e9 67 24 00 00       	jmp    80102630 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 9f 7e 10 80       	push   $0x80107e9f
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
801001ef:	e8 9c 4a 00 00       	call   80104c90 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 4c 4a 00 00       	call   80104c50 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 a0 4b 00 00       	call   80104db0 <acquire>
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
8010025c:	e9 6f 4c 00 00       	jmp    80104ed0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 a6 7e 10 80       	push   $0x80107ea6
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
8010028c:	e8 1f 4b 00 00       	call   80104db0 <acquire>
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
801002c5:	e8 e6 40 00 00       	call   801043b0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 0f 11 80    	cmp    0x80110fa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 80 3a 00 00       	call   80103d60 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 dc 4b 00 00       	call   80104ed0 <release>
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
8010034d:	e8 7e 4b 00 00       	call   80104ed0 <release>
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
801003a9:	e8 92 28 00 00       	call   80102c40 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ad 7e 10 80       	push   $0x80107ead
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 43 85 10 80 	movl   $0x80108543,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 03 49 00 00       	call   80104ce0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 c1 7e 10 80       	push   $0x80107ec1
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
8010043a:	e8 e1 61 00 00       	call   80106620 <uartputc>
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
801004ec:	e8 2f 61 00 00       	call   80106620 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 23 61 00 00       	call   80106620 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 17 61 00 00       	call   80106620 <uartputc>
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
80100524:	e8 b7 4a 00 00       	call   80104fe0 <memmove>
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
80100541:	e8 ea 49 00 00       	call   80104f30 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 c5 7e 10 80       	push   $0x80107ec5
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
801005b1:	0f b6 92 f0 7e 10 80 	movzbl -0x7fef8110(%edx),%edx
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
8010061b:	e8 90 47 00 00       	call   80104db0 <acquire>
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
80100647:	e8 84 48 00 00       	call   80104ed0 <release>
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
8010071f:	e8 ac 47 00 00       	call   80104ed0 <release>
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
801007d0:	ba d8 7e 10 80       	mov    $0x80107ed8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 bb 45 00 00       	call   80104db0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 df 7e 10 80       	push   $0x80107edf
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
80100823:	e8 88 45 00 00       	call   80104db0 <acquire>
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
80100888:	e8 43 46 00 00       	call   80104ed0 <release>
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
80100916:	e8 55 3c 00 00       	call   80104570 <wakeup>
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
80100997:	e9 b4 3c 00 00       	jmp    80104650 <procdump>
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
801009c6:	68 e8 7e 10 80       	push   $0x80107ee8
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 eb 42 00 00       	call   80104cc0 <initlock>

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
801009f9:	e8 e2 1d 00 00       	call   801027e0 <ioapicenable>
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
80100a1c:	e8 3f 33 00 00       	call   80103d60 <myproc>
80100a21:	89 c7                	mov    %eax,%edi
  begin_op();
80100a23:	e8 88 26 00 00       	call   801030b0 <begin_op>
  if((ip = namei(path)) == 0){
80100a28:	83 ec 0c             	sub    $0xc,%esp
80100a2b:	ff 75 08             	pushl  0x8(%ebp)
80100a2e:	e8 3d 15 00 00       	call   80101f70 <namei>
80100a33:	83 c4 10             	add    $0x10,%esp
80100a36:	85 c0                	test   %eax,%eax
80100a38:	0f 84 a5 01 00 00    	je     80100be3 <exec+0x1d3>
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
80100a6b:	e8 b0 26 00 00       	call   80103120 <end_op>
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
80100a8c:	e8 8f 6f 00 00       	call   80107a20 <setupkvm>
80100a91:	85 c0                	test   %eax,%eax
80100a93:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a99:	74 c7                	je     80100a62 <exec+0x52>
  initPageMetaData(curproc);
80100a9b:	83 ec 0c             	sub    $0xc,%esp
80100a9e:	57                   	push   %edi
80100a9f:	e8 ec 32 00 00       	call   80103d90 <initPageMetaData>
  if(curproc->swapFile){
80100aa4:	8b 4f 7c             	mov    0x7c(%edi),%ecx
80100aa7:	83 c4 10             	add    $0x10,%esp
80100aaa:	85 c9                	test   %ecx,%ecx
80100aac:	74 0c                	je     80100aba <exec+0xaa>
    removeSwapFile(curproc);
80100aae:	83 ec 0c             	sub    $0xc,%esp
80100ab1:	57                   	push   %edi
80100ab2:	e8 89 15 00 00       	call   80102040 <removeSwapFile>
80100ab7:	83 c4 10             	add    $0x10,%esp
  if(strncmp(path,"sh",3)!=0){ignorePaging = 0;}
80100aba:	83 ec 04             	sub    $0x4,%esp
80100abd:	6a 03                	push   $0x3
80100abf:	68 0d 7f 10 80       	push   $0x80107f0d
80100ac4:	ff 75 08             	pushl  0x8(%ebp)
80100ac7:	e8 84 45 00 00       	call   80105050 <strncmp>
80100acc:	83 c4 10             	add    $0x10,%esp
80100acf:	85 c0                	test   %eax,%eax
80100ad1:	ba 01 00 00 00       	mov    $0x1,%edx
80100ad6:	0f 85 f4 00 00 00    	jne    80100bd0 <exec+0x1c0>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100adc:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100ae3:	00 
80100ae4:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  curproc->ignorePaging = ignorePaging;
80100aea:	89 97 98 03 00 00    	mov    %edx,0x398(%edi)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100af0:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100af6:	0f 84 c9 02 00 00    	je     80100dc5 <exec+0x3b5>
  sz = 0;
80100afc:	31 c0                	xor    %eax,%eax
80100afe:	89 bd ec fe ff ff    	mov    %edi,-0x114(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b04:	31 f6                	xor    %esi,%esi
80100b06:	89 c7                	mov    %eax,%edi
80100b08:	e9 7d 00 00 00       	jmp    80100b8a <exec+0x17a>
80100b0d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ph.type != ELF_PROG_LOAD)
80100b10:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b17:	75 63                	jne    80100b7c <exec+0x16c>
    if(ph.memsz < ph.filesz)
80100b19:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b1f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b25:	0f 82 86 00 00 00    	jb     80100bb1 <exec+0x1a1>
80100b2b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b31:	72 7e                	jb     80100bb1 <exec+0x1a1>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b33:	83 ec 04             	sub    $0x4,%esp
80100b36:	50                   	push   %eax
80100b37:	57                   	push   %edi
80100b38:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b3e:	e8 6d 6c 00 00       	call   801077b0 <allocuvm>
80100b43:	83 c4 10             	add    $0x10,%esp
80100b46:	85 c0                	test   %eax,%eax
80100b48:	89 c7                	mov    %eax,%edi
80100b4a:	74 65                	je     80100bb1 <exec+0x1a1>
    if(ph.vaddr % PGSIZE != 0)
80100b4c:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b52:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b57:	75 58                	jne    80100bb1 <exec+0x1a1>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b59:	83 ec 0c             	sub    $0xc,%esp
80100b5c:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b62:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b68:	53                   	push   %ebx
80100b69:	50                   	push   %eax
80100b6a:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b70:	e8 bb 68 00 00       	call   80107430 <loaduvm>
80100b75:	83 c4 20             	add    $0x20,%esp
80100b78:	85 c0                	test   %eax,%eax
80100b7a:	78 35                	js     80100bb1 <exec+0x1a1>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b7c:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b83:	83 c6 01             	add    $0x1,%esi
80100b86:	39 f0                	cmp    %esi,%eax
80100b88:	7e 78                	jle    80100c02 <exec+0x1f2>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b8a:	89 f0                	mov    %esi,%eax
80100b8c:	6a 20                	push   $0x20
80100b8e:	c1 e0 05             	shl    $0x5,%eax
80100b91:	03 85 f0 fe ff ff    	add    -0x110(%ebp),%eax
80100b97:	50                   	push   %eax
80100b98:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b9e:	50                   	push   %eax
80100b9f:	53                   	push   %ebx
80100ba0:	e8 4b 0e 00 00       	call   801019f0 <readi>
80100ba5:	83 c4 10             	add    $0x10,%esp
80100ba8:	83 f8 20             	cmp    $0x20,%eax
80100bab:	0f 84 5f ff ff ff    	je     80100b10 <exec+0x100>
    freevm(pgdir);
80100bb1:	83 ec 0c             	sub    $0xc,%esp
80100bb4:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bba:	e8 e1 6d 00 00       	call   801079a0 <freevm>
80100bbf:	83 c4 10             	add    $0x10,%esp
80100bc2:	e9 9b fe ff ff       	jmp    80100a62 <exec+0x52>
80100bc7:	89 f6                	mov    %esi,%esi
80100bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    createSwapFile(curproc);
80100bd0:	83 ec 0c             	sub    $0xc,%esp
80100bd3:	57                   	push   %edi
80100bd4:	e8 67 16 00 00       	call   80102240 <createSwapFile>
80100bd9:	83 c4 10             	add    $0x10,%esp
80100bdc:	31 d2                	xor    %edx,%edx
80100bde:	e9 f9 fe ff ff       	jmp    80100adc <exec+0xcc>
    end_op();
80100be3:	e8 38 25 00 00       	call   80103120 <end_op>
    cprintf("exec: fail\n");
80100be8:	83 ec 0c             	sub    $0xc,%esp
80100beb:	68 01 7f 10 80       	push   $0x80107f01
80100bf0:	e8 6b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100bf5:	83 c4 10             	add    $0x10,%esp
80100bf8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bfd:	e9 76 fe ff ff       	jmp    80100a78 <exec+0x68>
80100c02:	89 fe                	mov    %edi,%esi
80100c04:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
  iunlockput(ip);
80100c0a:	83 ec 0c             	sub    $0xc,%esp
80100c0d:	53                   	push   %ebx
80100c0e:	e8 8d 0d 00 00       	call   801019a0 <iunlockput>
  end_op();
80100c13:	e8 08 25 00 00       	call   80103120 <end_op>
  sz = PGROUNDUP(sz);
80100c18:	89 f0                	mov    %esi,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c1a:	83 c4 0c             	add    $0xc,%esp
  sz = PGROUNDUP(sz);
80100c1d:	05 ff 0f 00 00       	add    $0xfff,%eax
80100c22:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c27:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100c2d:	52                   	push   %edx
80100c2e:	50                   	push   %eax
80100c2f:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c35:	e8 76 6b 00 00       	call   801077b0 <allocuvm>
80100c3a:	83 c4 10             	add    $0x10,%esp
80100c3d:	85 c0                	test   %eax,%eax
80100c3f:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c45:	75 1b                	jne    80100c62 <exec+0x252>
    freevm(pgdir);
80100c47:	83 ec 0c             	sub    $0xc,%esp
80100c4a:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c50:	e8 4b 6d 00 00       	call   801079a0 <freevm>
80100c55:	83 c4 10             	add    $0x10,%esp
  return -1;
80100c58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c5d:	e9 16 fe ff ff       	jmp    80100a78 <exec+0x68>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c62:	89 c3                	mov    %eax,%ebx
80100c64:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100c6a:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c6f:	50                   	push   %eax
80100c70:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c76:	e8 45 6e 00 00       	call   80107ac0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c7e:	83 c4 10             	add    $0x10,%esp
80100c81:	8b 00                	mov    (%eax),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	0f 84 41 01 00 00    	je     80100dcc <exec+0x3bc>
80100c8b:	89 bd ec fe ff ff    	mov    %edi,-0x114(%ebp)
80100c91:	89 f7                	mov    %esi,%edi
80100c93:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c99:	eb 0a                	jmp    80100ca5 <exec+0x295>
80100c9b:	90                   	nop
80100c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100ca0:	83 ff 20             	cmp    $0x20,%edi
80100ca3:	74 a2                	je     80100c47 <exec+0x237>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ca5:	83 ec 0c             	sub    $0xc,%esp
80100ca8:	50                   	push   %eax
80100ca9:	e8 a2 44 00 00       	call   80105150 <strlen>
80100cae:	f7 d0                	not    %eax
80100cb0:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb2:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cb5:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb6:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb9:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cbc:	e8 8f 44 00 00       	call   80105150 <strlen>
80100cc1:	83 c0 01             	add    $0x1,%eax
80100cc4:	50                   	push   %eax
80100cc5:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc8:	ff 34 b8             	pushl  (%eax,%edi,4)
80100ccb:	53                   	push   %ebx
80100ccc:	56                   	push   %esi
80100ccd:	e8 3e 6f 00 00       	call   80107c10 <copyout>
80100cd2:	83 c4 20             	add    $0x20,%esp
80100cd5:	85 c0                	test   %eax,%eax
80100cd7:	0f 88 6a ff ff ff    	js     80100c47 <exec+0x237>
  for(argc = 0; argv[argc]; argc++) {
80100cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100ce0:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100ce7:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cea:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100cf0:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cf3:	85 c0                	test   %eax,%eax
80100cf5:	75 a9                	jne    80100ca0 <exec+0x290>
80100cf7:	89 fe                	mov    %edi,%esi
80100cf9:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cff:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100d06:	89 da                	mov    %ebx,%edx
  ustack[3+argc] = 0;
80100d08:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100d0f:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100d13:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d1a:	ff ff ff 
  ustack[1] = argc;
80100d1d:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d23:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
80100d25:	83 c0 0c             	add    $0xc,%eax
80100d28:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d2a:	50                   	push   %eax
80100d2b:	51                   	push   %ecx
80100d2c:	53                   	push   %ebx
80100d2d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d33:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d39:	e8 d2 6e 00 00       	call   80107c10 <copyout>
80100d3e:	83 c4 10             	add    $0x10,%esp
80100d41:	85 c0                	test   %eax,%eax
80100d43:	0f 88 fe fe ff ff    	js     80100c47 <exec+0x237>
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
80100d6b:	8d 47 6c             	lea    0x6c(%edi),%eax
80100d6e:	6a 10                	push   $0x10
80100d70:	ff 75 08             	pushl  0x8(%ebp)
80100d73:	50                   	push   %eax
80100d74:	e8 97 43 00 00       	call   80105110 <safestrcpy>
  oldpgdir = curproc->pgdir;
80100d79:	8b 47 04             	mov    0x4(%edi),%eax
  curproc->tf->eip = elf.entry;  // main
80100d7c:	8b 57 18             	mov    0x18(%edi),%edx
  oldpgdir = curproc->pgdir;
80100d7f:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  curproc->pgdir = pgdir;
80100d85:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100d8b:	89 47 04             	mov    %eax,0x4(%edi)
  curproc->sz = sz;
80100d8e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d94:	89 07                	mov    %eax,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100d96:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100d9c:	89 4a 38             	mov    %ecx,0x38(%edx)
  curproc->tf->esp = sp;
80100d9f:	8b 57 18             	mov    0x18(%edi),%edx
80100da2:	89 5a 44             	mov    %ebx,0x44(%edx)
  switchuvm(curproc);
80100da5:	89 3c 24             	mov    %edi,(%esp)
80100da8:	e8 f3 64 00 00       	call   801072a0 <switchuvm>
  freevm(oldpgdir);
80100dad:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100db3:	89 04 24             	mov    %eax,(%esp)
80100db6:	e8 e5 6b 00 00       	call   801079a0 <freevm>
  return 0;
80100dbb:	83 c4 10             	add    $0x10,%esp
80100dbe:	31 c0                	xor    %eax,%eax
80100dc0:	e9 b3 fc ff ff       	jmp    80100a78 <exec+0x68>
  sz = 0;
80100dc5:	31 f6                	xor    %esi,%esi
80100dc7:	e9 3e fe ff ff       	jmp    80100c0a <exec+0x1fa>
  for(argc = 0; argv[argc]; argc++) {
80100dcc:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100dd2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100dd8:	e9 22 ff ff ff       	jmp    80100cff <exec+0x2ef>
80100ddd:	66 90                	xchg   %ax,%ax
80100ddf:	90                   	nop

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
80100de6:	68 10 7f 10 80       	push   $0x80107f10
80100deb:	68 c0 0f 11 80       	push   $0x80110fc0
80100df0:	e8 cb 3e 00 00       	call   80104cc0 <initlock>
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
80100e11:	e8 9a 3f 00 00       	call   80104db0 <acquire>
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
80100e41:	e8 8a 40 00 00       	call   80104ed0 <release>
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
80100e5a:	e8 71 40 00 00       	call   80104ed0 <release>
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
80100e7f:	e8 2c 3f 00 00       	call   80104db0 <acquire>
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
80100e9c:	e8 2f 40 00 00       	call   80104ed0 <release>
  return f;
}
80100ea1:	89 d8                	mov    %ebx,%eax
80100ea3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ea6:	c9                   	leave  
80100ea7:	c3                   	ret    
    panic("filedup");
80100ea8:	83 ec 0c             	sub    $0xc,%esp
80100eab:	68 17 7f 10 80       	push   $0x80107f17
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
80100ed1:	e8 da 3e 00 00       	call   80104db0 <acquire>
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
80100efc:	e9 cf 3f 00 00       	jmp    80104ed0 <release>
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
80100f28:	e8 a3 3f 00 00       	call   80104ed0 <release>
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
80100f51:	e8 0a 29 00 00       	call   80103860 <pipeclose>
80100f56:	83 c4 10             	add    $0x10,%esp
80100f59:	eb df                	jmp    80100f3a <fileclose+0x7a>
80100f5b:	90                   	nop
80100f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f60:	e8 4b 21 00 00       	call   801030b0 <begin_op>
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
80100f7a:	e9 a1 21 00 00       	jmp    80103120 <end_op>
    panic("fileclose");
80100f7f:	83 ec 0c             	sub    $0xc,%esp
80100f82:	68 1f 7f 10 80       	push   $0x80107f1f
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
8010104d:	e9 be 29 00 00       	jmp    80103a10 <piperead>
80101052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101058:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010105d:	eb d7                	jmp    80101036 <fileread+0x56>
  panic("fileread");
8010105f:	83 ec 0c             	sub    $0xc,%esp
80101062:	68 29 7f 10 80       	push   $0x80107f29
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
801010c9:	e8 52 20 00 00       	call   80103120 <end_op>
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
801010f6:	e8 b5 1f 00 00       	call   801030b0 <begin_op>
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
8010112d:	e8 ee 1f 00 00       	call   80103120 <end_op>
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
8010116d:	e9 8e 27 00 00       	jmp    80103900 <pipewrite>
        panic("short filewrite");
80101172:	83 ec 0c             	sub    $0xc,%esp
80101175:	68 32 7f 10 80       	push   $0x80107f32
8010117a:	e8 11 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010117f:	83 ec 0c             	sub    $0xc,%esp
80101182:	68 38 7f 10 80       	push   $0x80107f38
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
80101234:	68 42 7f 10 80       	push   $0x80107f42
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
8010124d:	e8 2e 20 00 00       	call   80103280 <log_write>
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
80101275:	e8 b6 3c 00 00       	call   80104f30 <memset>
  log_write(bp);
8010127a:	89 1c 24             	mov    %ebx,(%esp)
8010127d:	e8 fe 1f 00 00       	call   80103280 <log_write>
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
801012ba:	e8 f1 3a 00 00       	call   80104db0 <acquire>
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
8010131f:	e8 ac 3b 00 00       	call   80104ed0 <release>

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
8010134d:	e8 7e 3b 00 00       	call   80104ed0 <release>
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
80101362:	68 58 7f 10 80       	push   $0x80107f58
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
801013de:	e8 9d 1e 00 00       	call   80103280 <log_write>
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
80101437:	68 68 7f 10 80       	push   $0x80107f68
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
80101471:	e8 6a 3b 00 00       	call   80104fe0 <memmove>
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
801014ea:	e8 91 1d 00 00       	call   80103280 <log_write>
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
80101504:	68 7b 7f 10 80       	push   $0x80107f7b
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
8010151c:	68 8e 7f 10 80       	push   $0x80107f8e
80101521:	68 e0 19 11 80       	push   $0x801119e0
80101526:	e8 95 37 00 00       	call   80104cc0 <initlock>
8010152b:	83 c4 10             	add    $0x10,%esp
8010152e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101530:	83 ec 08             	sub    $0x8,%esp
80101533:	68 95 7f 10 80       	push   $0x80107f95
80101538:	53                   	push   %ebx
80101539:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010153f:	e8 6c 36 00 00       	call   80104bb0 <initsleeplock>
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
80101589:	68 40 80 10 80       	push   $0x80108040
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
8010161e:	e8 0d 39 00 00       	call   80104f30 <memset>
      dip->type = type;
80101623:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101627:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010162a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010162d:	89 3c 24             	mov    %edi,(%esp)
80101630:	e8 4b 1c 00 00       	call   80103280 <log_write>
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
80101653:	68 9b 7f 10 80       	push   $0x80107f9b
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
801016c1:	e8 1a 39 00 00       	call   80104fe0 <memmove>
  log_write(bp);
801016c6:	89 34 24             	mov    %esi,(%esp)
801016c9:	e8 b2 1b 00 00       	call   80103280 <log_write>
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
801016ef:	e8 bc 36 00 00       	call   80104db0 <acquire>
  ip->ref++;
801016f4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016f8:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801016ff:	e8 cc 37 00 00       	call   80104ed0 <release>
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
80101732:	e8 b9 34 00 00       	call   80104bf0 <acquiresleep>
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
801017a8:	e8 33 38 00 00       	call   80104fe0 <memmove>
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
801017cd:	68 b3 7f 10 80       	push   $0x80107fb3
801017d2:	e8 b9 eb ff ff       	call   80100390 <panic>
    panic("ilock");
801017d7:	83 ec 0c             	sub    $0xc,%esp
801017da:	68 ad 7f 10 80       	push   $0x80107fad
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
80101803:	e8 88 34 00 00       	call   80104c90 <holdingsleep>
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
8010181f:	e9 2c 34 00 00       	jmp    80104c50 <releasesleep>
    panic("iunlock");
80101824:	83 ec 0c             	sub    $0xc,%esp
80101827:	68 c2 7f 10 80       	push   $0x80107fc2
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
80101850:	e8 9b 33 00 00       	call   80104bf0 <acquiresleep>
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
8010186a:	e8 e1 33 00 00       	call   80104c50 <releasesleep>
  acquire(&icache.lock);
8010186f:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101876:	e8 35 35 00 00       	call   80104db0 <acquire>
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
80101890:	e9 3b 36 00 00       	jmp    80104ed0 <release>
80101895:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101898:	83 ec 0c             	sub    $0xc,%esp
8010189b:	68 e0 19 11 80       	push   $0x801119e0
801018a0:	e8 0b 35 00 00       	call   80104db0 <acquire>
    int r = ip->ref;
801018a5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801018a8:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018af:	e8 1c 36 00 00       	call   80104ed0 <release>
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
80101a97:	e8 44 35 00 00       	call   80104fe0 <memmove>
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
80101b93:	e8 48 34 00 00       	call   80104fe0 <memmove>
    log_write(bp);
80101b98:	89 3c 24             	mov    %edi,(%esp)
80101b9b:	e8 e0 16 00 00       	call   80103280 <log_write>
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
80101c2e:	e8 1d 34 00 00       	call   80105050 <strncmp>
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
80101c8d:	e8 be 33 00 00       	call   80105050 <strncmp>
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
80101cd2:	68 dc 7f 10 80       	push   $0x80107fdc
80101cd7:	e8 b4 e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101cdc:	83 ec 0c             	sub    $0xc,%esp
80101cdf:	68 ca 7f 10 80       	push   $0x80107fca
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
80101d09:	e8 52 20 00 00       	call   80103d60 <myproc>
  acquire(&icache.lock);
80101d0e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101d11:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d14:	68 e0 19 11 80       	push   $0x801119e0
80101d19:	e8 92 30 00 00       	call   80104db0 <acquire>
  ip->ref++;
80101d1e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d22:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101d29:	e8 a2 31 00 00       	call   80104ed0 <release>
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
80101d85:	e8 56 32 00 00       	call   80104fe0 <memmove>
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
80101e18:	e8 c3 31 00 00       	call   80104fe0 <memmove>
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
80101f0d:	e8 9e 31 00 00       	call   801050b0 <strncpy>
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
80101f4b:	68 eb 7f 10 80       	push   $0x80107feb
80101f50:	e8 3b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101f55:	83 ec 0c             	sub    $0xc,%esp
80101f58:	68 f5 86 10 80       	push   $0x801086f5
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
80102051:	68 f8 7f 10 80       	push   $0x80107ff8
80102056:	56                   	push   %esi
80102057:	e8 84 2f 00 00       	call   80104fe0 <memmove>
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
80102084:	e8 27 10 00 00       	call   801030b0 <begin_op>
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
801020b2:	68 00 80 10 80       	push   $0x80108000
801020b7:	53                   	push   %ebx
801020b8:	e8 93 2f 00 00       	call   80105050 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801020bd:	83 c4 10             	add    $0x10,%esp
801020c0:	85 c0                	test   %eax,%eax
801020c2:	0f 84 f8 00 00 00    	je     801021c0 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
801020c8:	83 ec 04             	sub    $0x4,%esp
801020cb:	6a 0e                	push   $0xe
801020cd:	68 ff 7f 10 80       	push   $0x80107fff
801020d2:	53                   	push   %ebx
801020d3:	e8 78 2f 00 00       	call   80105050 <strncmp>
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
80102127:	e8 04 2e 00 00       	call   80104f30 <memset>
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
8010217d:	e8 9e 0f 00 00       	call   80103120 <end_op>

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
80102194:	e8 77 35 00 00       	call   80105710 <isdirempty>
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
801021d1:	e8 4a 0f 00 00       	call   80103120 <end_op>
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
8010220a:	e8 11 0f 00 00       	call   80103120 <end_op>
    return -1;
8010220f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102214:	e9 6e ff ff ff       	jmp    80102187 <removeSwapFile+0x147>
    panic("unlink: writei");
80102219:	83 ec 0c             	sub    $0xc,%esp
8010221c:	68 14 80 10 80       	push   $0x80108014
80102221:	e8 6a e1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102226:	83 ec 0c             	sub    $0xc,%esp
80102229:	68 02 80 10 80       	push   $0x80108002
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
80102250:	68 f8 7f 10 80       	push   $0x80107ff8
80102255:	56                   	push   %esi
80102256:	e8 85 2d 00 00       	call   80104fe0 <memmove>
  itoa(p->pid, path+ 6);
8010225b:	58                   	pop    %eax
8010225c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010225f:	5a                   	pop    %edx
80102260:	50                   	push   %eax
80102261:	ff 73 10             	pushl  0x10(%ebx)
80102264:	e8 47 fd ff ff       	call   80101fb0 <itoa>

    begin_op();
80102269:	e8 42 0e 00 00       	call   801030b0 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
8010226e:	6a 00                	push   $0x0
80102270:	6a 00                	push   $0x0
80102272:	6a 02                	push   $0x2
80102274:	56                   	push   %esi
80102275:	e8 a6 36 00 00       	call   80105920 <create>
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
801022b8:	e8 63 0e 00 00       	call   80103120 <end_op>

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
801022c9:	68 23 80 10 80       	push   $0x80108023
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
8010234c:	8b 75 08             	mov    0x8(%ebp),%esi
	void* buffer = kalloc();
8010234f:	e8 7c 06 00 00       	call   801029d0 <kalloc>
80102354:	89 c2                	mov    %eax,%edx
  return fileread(p->swapFile, buffer,  size);
80102356:	83 ec 04             	sub    $0x4,%esp
	int numFilePages = p->numOfDiskPages + p->numOfPhysPages;
80102359:	8b bb 80 03 00 00    	mov    0x380(%ebx),%edi
8010235f:	03 bb 84 03 00 00    	add    0x384(%ebx),%edi
  p->swapFile->off = placeOnFile;
80102365:	8b 43 7c             	mov    0x7c(%ebx),%eax
  return fileread(p->swapFile, buffer,  size);
80102368:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int fileSize = numFilePages*PGSIZE;
8010236b:	c1 e7 0c             	shl    $0xc,%edi
  p->swapFile->off = placeOnFile;
8010236e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  return fileread(p->swapFile, buffer,  size);
80102375:	57                   	push   %edi
80102376:	52                   	push   %edx
80102377:	ff 73 7c             	pushl  0x7c(%ebx)
8010237a:	e8 61 ec ff ff       	call   80100fe0 <fileread>
  p->swapFile->off = placeOnFile;
8010237f:	8b 46 7c             	mov    0x7c(%esi),%eax
  return filewrite(p->swapFile, buffer, size);
80102382:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102385:	83 c4 0c             	add    $0xc,%esp
  p->swapFile->off = placeOnFile;
80102388:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  return filewrite(p->swapFile, buffer, size);
8010238f:	57                   	push   %edi
80102390:	52                   	push   %edx
80102391:	ff 76 7c             	pushl  0x7c(%esi)
80102394:	e8 d7 ec ff ff       	call   80101070 <filewrite>
	readFromSwapFile(p, buffer, 0, fileSize);
	writeToSwapFile(np, buffer, 0, fileSize);
	kfree(buffer);
80102399:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010239c:	89 14 24             	mov    %edx,(%esp)
8010239f:	e8 7c 04 00 00       	call   80102820 <kfree>
  np->numOfPhysPages = p->numOfPhysPages;
801023a4:	8b 83 80 03 00 00    	mov    0x380(%ebx),%eax
801023aa:	8d 96 80 00 00 00    	lea    0x80(%esi),%edx
801023b0:	83 c4 10             	add    $0x10,%esp
801023b3:	89 86 80 03 00 00    	mov    %eax,0x380(%esi)
  np->numOfDiskPages = p->numOfDiskPages;
801023b9:	8b 83 84 03 00 00    	mov    0x384(%ebx),%eax
801023bf:	89 86 84 03 00 00    	mov    %eax,0x384(%esi)
  np->numOfProtectedPages = p->numOfProtectedPages;
801023c5:	8b 83 88 03 00 00    	mov    0x388(%ebx),%eax
  np->totalNumOfPagedOut = 0;
801023cb:	c7 86 90 03 00 00 00 	movl   $0x0,0x390(%esi)
801023d2:	00 00 00 
  np->numOfPageFaults = 0;
801023d5:	c7 86 8c 03 00 00 00 	movl   $0x0,0x38c(%esi)
801023dc:	00 00 00 
  np->numOfProtectedPages = p->numOfProtectedPages;
801023df:	89 86 88 03 00 00    	mov    %eax,0x388(%esi)
801023e5:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
801023eb:	81 c3 00 02 00 00    	add    $0x200,%ebx
801023f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  //cprintf("num of phys pages in fork %d \n", np->numOfPhysPages);
  for(int i=0; i< MAX_PSYC_PAGES; i++){
    np->procSwappedFiles[i].va = p->procSwappedFiles[i].va;
801023f8:	8b 08                	mov    (%eax),%ecx
801023fa:	83 c0 18             	add    $0x18,%eax
801023fd:	83 c2 18             	add    $0x18,%edx
80102400:	89 4a e8             	mov    %ecx,-0x18(%edx)
    np->procSwappedFiles[i].pte = p->procSwappedFiles[i].pte;
80102403:	8b 48 ec             	mov    -0x14(%eax),%ecx
80102406:	89 4a ec             	mov    %ecx,-0x14(%edx)
    np->procSwappedFiles[i].offsetInFile = p->procSwappedFiles[i].offsetInFile;
80102409:	8b 48 f0             	mov    -0x10(%eax),%ecx
8010240c:	89 4a f0             	mov    %ecx,-0x10(%edx)
    np->procSwappedFiles[i].isOccupied = p->procSwappedFiles[i].isOccupied;
8010240f:	8b 48 f4             	mov    -0xc(%eax),%ecx
80102412:	89 4a f4             	mov    %ecx,-0xc(%edx)
  for(int i=0; i< MAX_PSYC_PAGES; i++){
80102415:	39 d8                	cmp    %ebx,%eax
80102417:	75 df                	jne    801023f8 <copySwapFile+0xb8>
  }
  return 0;
}
80102419:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010241c:	31 c0                	xor    %eax,%eax
8010241e:	5b                   	pop    %ebx
8010241f:	5e                   	pop    %esi
80102420:	5f                   	pop    %edi
80102421:	5d                   	pop    %ebp
80102422:	c3                   	ret    
80102423:	66 90                	xchg   %ax,%ax
80102425:	66 90                	xchg   %ax,%ax
80102427:	66 90                	xchg   %ax,%ax
80102429:	66 90                	xchg   %ax,%ax
8010242b:	66 90                	xchg   %ax,%ax
8010242d:	66 90                	xchg   %ax,%ax
8010242f:	90                   	nop

80102430 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	57                   	push   %edi
80102434:	56                   	push   %esi
80102435:	53                   	push   %ebx
80102436:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102439:	85 c0                	test   %eax,%eax
8010243b:	0f 84 b4 00 00 00    	je     801024f5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102441:	8b 58 08             	mov    0x8(%eax),%ebx
80102444:	89 c6                	mov    %eax,%esi
80102446:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010244c:	0f 87 96 00 00 00    	ja     801024e8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102452:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102457:	89 f6                	mov    %esi,%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102460:	89 ca                	mov    %ecx,%edx
80102462:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102463:	83 e0 c0             	and    $0xffffffc0,%eax
80102466:	3c 40                	cmp    $0x40,%al
80102468:	75 f6                	jne    80102460 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010246a:	31 ff                	xor    %edi,%edi
8010246c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102471:	89 f8                	mov    %edi,%eax
80102473:	ee                   	out    %al,(%dx)
80102474:	b8 01 00 00 00       	mov    $0x1,%eax
80102479:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010247e:	ee                   	out    %al,(%dx)
8010247f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102484:	89 d8                	mov    %ebx,%eax
80102486:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102487:	89 d8                	mov    %ebx,%eax
80102489:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010248e:	c1 f8 08             	sar    $0x8,%eax
80102491:	ee                   	out    %al,(%dx)
80102492:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102497:	89 f8                	mov    %edi,%eax
80102499:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010249a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010249e:	ba f6 01 00 00       	mov    $0x1f6,%edx
801024a3:	c1 e0 04             	shl    $0x4,%eax
801024a6:	83 e0 10             	and    $0x10,%eax
801024a9:	83 c8 e0             	or     $0xffffffe0,%eax
801024ac:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801024ad:	f6 06 04             	testb  $0x4,(%esi)
801024b0:	75 16                	jne    801024c8 <idestart+0x98>
801024b2:	b8 20 00 00 00       	mov    $0x20,%eax
801024b7:	89 ca                	mov    %ecx,%edx
801024b9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801024ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024bd:	5b                   	pop    %ebx
801024be:	5e                   	pop    %esi
801024bf:	5f                   	pop    %edi
801024c0:	5d                   	pop    %ebp
801024c1:	c3                   	ret    
801024c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801024c8:	b8 30 00 00 00       	mov    $0x30,%eax
801024cd:	89 ca                	mov    %ecx,%edx
801024cf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801024d0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801024d5:	83 c6 5c             	add    $0x5c,%esi
801024d8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801024dd:	fc                   	cld    
801024de:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801024e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024e3:	5b                   	pop    %ebx
801024e4:	5e                   	pop    %esi
801024e5:	5f                   	pop    %edi
801024e6:	5d                   	pop    %ebp
801024e7:	c3                   	ret    
    panic("incorrect blockno");
801024e8:	83 ec 0c             	sub    $0xc,%esp
801024eb:	68 9c 80 10 80       	push   $0x8010809c
801024f0:	e8 9b de ff ff       	call   80100390 <panic>
    panic("idestart");
801024f5:	83 ec 0c             	sub    $0xc,%esp
801024f8:	68 93 80 10 80       	push   $0x80108093
801024fd:	e8 8e de ff ff       	call   80100390 <panic>
80102502:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102510 <ideinit>:
{
80102510:	55                   	push   %ebp
80102511:	89 e5                	mov    %esp,%ebp
80102513:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102516:	68 ae 80 10 80       	push   $0x801080ae
8010251b:	68 80 b5 10 80       	push   $0x8010b580
80102520:	e8 9b 27 00 00       	call   80104cc0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102525:	58                   	pop    %eax
80102526:	a1 00 3d 11 80       	mov    0x80113d00,%eax
8010252b:	5a                   	pop    %edx
8010252c:	83 e8 01             	sub    $0x1,%eax
8010252f:	50                   	push   %eax
80102530:	6a 0e                	push   $0xe
80102532:	e8 a9 02 00 00       	call   801027e0 <ioapicenable>
80102537:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010253a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010253f:	90                   	nop
80102540:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102541:	83 e0 c0             	and    $0xffffffc0,%eax
80102544:	3c 40                	cmp    $0x40,%al
80102546:	75 f8                	jne    80102540 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102548:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010254d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102552:	ee                   	out    %al,(%dx)
80102553:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102558:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010255d:	eb 06                	jmp    80102565 <ideinit+0x55>
8010255f:	90                   	nop
  for(i=0; i<1000; i++){
80102560:	83 e9 01             	sub    $0x1,%ecx
80102563:	74 0f                	je     80102574 <ideinit+0x64>
80102565:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102566:	84 c0                	test   %al,%al
80102568:	74 f6                	je     80102560 <ideinit+0x50>
      havedisk1 = 1;
8010256a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102571:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102574:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102579:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010257e:	ee                   	out    %al,(%dx)
}
8010257f:	c9                   	leave  
80102580:	c3                   	ret    
80102581:	eb 0d                	jmp    80102590 <ideintr>
80102583:	90                   	nop
80102584:	90                   	nop
80102585:	90                   	nop
80102586:	90                   	nop
80102587:	90                   	nop
80102588:	90                   	nop
80102589:	90                   	nop
8010258a:	90                   	nop
8010258b:	90                   	nop
8010258c:	90                   	nop
8010258d:	90                   	nop
8010258e:	90                   	nop
8010258f:	90                   	nop

80102590 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102590:	55                   	push   %ebp
80102591:	89 e5                	mov    %esp,%ebp
80102593:	57                   	push   %edi
80102594:	56                   	push   %esi
80102595:	53                   	push   %ebx
80102596:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102599:	68 80 b5 10 80       	push   $0x8010b580
8010259e:	e8 0d 28 00 00       	call   80104db0 <acquire>

  if((b = idequeue) == 0){
801025a3:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801025a9:	83 c4 10             	add    $0x10,%esp
801025ac:	85 db                	test   %ebx,%ebx
801025ae:	74 67                	je     80102617 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801025b0:	8b 43 58             	mov    0x58(%ebx),%eax
801025b3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801025b8:	8b 3b                	mov    (%ebx),%edi
801025ba:	f7 c7 04 00 00 00    	test   $0x4,%edi
801025c0:	75 31                	jne    801025f3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025c2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801025c7:	89 f6                	mov    %esi,%esi
801025c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801025d0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801025d1:	89 c6                	mov    %eax,%esi
801025d3:	83 e6 c0             	and    $0xffffffc0,%esi
801025d6:	89 f1                	mov    %esi,%ecx
801025d8:	80 f9 40             	cmp    $0x40,%cl
801025db:	75 f3                	jne    801025d0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801025dd:	a8 21                	test   $0x21,%al
801025df:	75 12                	jne    801025f3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801025e1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801025e4:	b9 80 00 00 00       	mov    $0x80,%ecx
801025e9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801025ee:	fc                   	cld    
801025ef:	f3 6d                	rep insl (%dx),%es:(%edi)
801025f1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801025f3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801025f6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801025f9:	89 f9                	mov    %edi,%ecx
801025fb:	83 c9 02             	or     $0x2,%ecx
801025fe:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102600:	53                   	push   %ebx
80102601:	e8 6a 1f 00 00       	call   80104570 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102606:	a1 64 b5 10 80       	mov    0x8010b564,%eax
8010260b:	83 c4 10             	add    $0x10,%esp
8010260e:	85 c0                	test   %eax,%eax
80102610:	74 05                	je     80102617 <ideintr+0x87>
    idestart(idequeue);
80102612:	e8 19 fe ff ff       	call   80102430 <idestart>
    release(&idelock);
80102617:	83 ec 0c             	sub    $0xc,%esp
8010261a:	68 80 b5 10 80       	push   $0x8010b580
8010261f:	e8 ac 28 00 00       	call   80104ed0 <release>

  release(&idelock);
}
80102624:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102627:	5b                   	pop    %ebx
80102628:	5e                   	pop    %esi
80102629:	5f                   	pop    %edi
8010262a:	5d                   	pop    %ebp
8010262b:	c3                   	ret    
8010262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102630 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	53                   	push   %ebx
80102634:	83 ec 10             	sub    $0x10,%esp
80102637:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010263a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010263d:	50                   	push   %eax
8010263e:	e8 4d 26 00 00       	call   80104c90 <holdingsleep>
80102643:	83 c4 10             	add    $0x10,%esp
80102646:	85 c0                	test   %eax,%eax
80102648:	0f 84 c6 00 00 00    	je     80102714 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010264e:	8b 03                	mov    (%ebx),%eax
80102650:	83 e0 06             	and    $0x6,%eax
80102653:	83 f8 02             	cmp    $0x2,%eax
80102656:	0f 84 ab 00 00 00    	je     80102707 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010265c:	8b 53 04             	mov    0x4(%ebx),%edx
8010265f:	85 d2                	test   %edx,%edx
80102661:	74 0d                	je     80102670 <iderw+0x40>
80102663:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102668:	85 c0                	test   %eax,%eax
8010266a:	0f 84 b1 00 00 00    	je     80102721 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102670:	83 ec 0c             	sub    $0xc,%esp
80102673:	68 80 b5 10 80       	push   $0x8010b580
80102678:	e8 33 27 00 00       	call   80104db0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010267d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102683:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102686:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010268d:	85 d2                	test   %edx,%edx
8010268f:	75 09                	jne    8010269a <iderw+0x6a>
80102691:	eb 6d                	jmp    80102700 <iderw+0xd0>
80102693:	90                   	nop
80102694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102698:	89 c2                	mov    %eax,%edx
8010269a:	8b 42 58             	mov    0x58(%edx),%eax
8010269d:	85 c0                	test   %eax,%eax
8010269f:	75 f7                	jne    80102698 <iderw+0x68>
801026a1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801026a4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801026a6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
801026ac:	74 42                	je     801026f0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801026ae:	8b 03                	mov    (%ebx),%eax
801026b0:	83 e0 06             	and    $0x6,%eax
801026b3:	83 f8 02             	cmp    $0x2,%eax
801026b6:	74 23                	je     801026db <iderw+0xab>
801026b8:	90                   	nop
801026b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801026c0:	83 ec 08             	sub    $0x8,%esp
801026c3:	68 80 b5 10 80       	push   $0x8010b580
801026c8:	53                   	push   %ebx
801026c9:	e8 e2 1c 00 00       	call   801043b0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801026ce:	8b 03                	mov    (%ebx),%eax
801026d0:	83 c4 10             	add    $0x10,%esp
801026d3:	83 e0 06             	and    $0x6,%eax
801026d6:	83 f8 02             	cmp    $0x2,%eax
801026d9:	75 e5                	jne    801026c0 <iderw+0x90>
  }


  release(&idelock);
801026db:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801026e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026e5:	c9                   	leave  
  release(&idelock);
801026e6:	e9 e5 27 00 00       	jmp    80104ed0 <release>
801026eb:	90                   	nop
801026ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801026f0:	89 d8                	mov    %ebx,%eax
801026f2:	e8 39 fd ff ff       	call   80102430 <idestart>
801026f7:	eb b5                	jmp    801026ae <iderw+0x7e>
801026f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102700:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102705:	eb 9d                	jmp    801026a4 <iderw+0x74>
    panic("iderw: nothing to do");
80102707:	83 ec 0c             	sub    $0xc,%esp
8010270a:	68 c8 80 10 80       	push   $0x801080c8
8010270f:	e8 7c dc ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102714:	83 ec 0c             	sub    $0xc,%esp
80102717:	68 b2 80 10 80       	push   $0x801080b2
8010271c:	e8 6f dc ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102721:	83 ec 0c             	sub    $0xc,%esp
80102724:	68 dd 80 10 80       	push   $0x801080dd
80102729:	e8 62 dc ff ff       	call   80100390 <panic>
8010272e:	66 90                	xchg   %ax,%ax

80102730 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102730:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102731:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
80102738:	00 c0 fe 
{
8010273b:	89 e5                	mov    %esp,%ebp
8010273d:	56                   	push   %esi
8010273e:	53                   	push   %ebx
  ioapic->reg = reg;
8010273f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102746:	00 00 00 
  return ioapic->data;
80102749:	a1 34 36 11 80       	mov    0x80113634,%eax
8010274e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102751:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102757:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010275d:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102764:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102767:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010276a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010276d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102770:	39 c2                	cmp    %eax,%edx
80102772:	74 16                	je     8010278a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102774:	83 ec 0c             	sub    $0xc,%esp
80102777:	68 fc 80 10 80       	push   $0x801080fc
8010277c:	e8 df de ff ff       	call   80100660 <cprintf>
80102781:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102787:	83 c4 10             	add    $0x10,%esp
8010278a:	83 c3 21             	add    $0x21,%ebx
{
8010278d:	ba 10 00 00 00       	mov    $0x10,%edx
80102792:	b8 20 00 00 00       	mov    $0x20,%eax
80102797:	89 f6                	mov    %esi,%esi
80102799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801027a0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801027a2:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801027a8:	89 c6                	mov    %eax,%esi
801027aa:	81 ce 00 00 01 00    	or     $0x10000,%esi
801027b0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801027b3:	89 71 10             	mov    %esi,0x10(%ecx)
801027b6:	8d 72 01             	lea    0x1(%edx),%esi
801027b9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801027bc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801027be:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801027c0:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801027c6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801027cd:	75 d1                	jne    801027a0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801027cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027d2:	5b                   	pop    %ebx
801027d3:	5e                   	pop    %esi
801027d4:	5d                   	pop    %ebp
801027d5:	c3                   	ret    
801027d6:	8d 76 00             	lea    0x0(%esi),%esi
801027d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027e0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801027e0:	55                   	push   %ebp
  ioapic->reg = reg;
801027e1:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
{
801027e7:	89 e5                	mov    %esp,%ebp
801027e9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801027ec:	8d 50 20             	lea    0x20(%eax),%edx
801027ef:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801027f3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801027f5:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801027fb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801027fe:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102801:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102804:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102806:	a1 34 36 11 80       	mov    0x80113634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010280b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010280e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102811:	5d                   	pop    %ebp
80102812:	c3                   	ret    
80102813:	66 90                	xchg   %ax,%ax
80102815:	66 90                	xchg   %ax,%ax
80102817:	66 90                	xchg   %ax,%ax
80102819:	66 90                	xchg   %ax,%ax
8010281b:	66 90                	xchg   %ax,%ax
8010281d:	66 90                	xchg   %ax,%ax
8010281f:	90                   	nop

80102820 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102820:	55                   	push   %ebp
80102821:	89 e5                	mov    %esp,%ebp
80102823:	53                   	push   %ebx
80102824:	83 ec 04             	sub    $0x4,%esp
80102827:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010282a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102830:	75 70                	jne    801028a2 <kfree+0x82>
80102832:	81 fb c8 2c 12 80    	cmp    $0x80122cc8,%ebx
80102838:	72 68                	jb     801028a2 <kfree+0x82>
8010283a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102840:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102845:	77 5b                	ja     801028a2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102847:	83 ec 04             	sub    $0x4,%esp
8010284a:	68 00 10 00 00       	push   $0x1000
8010284f:	6a 01                	push   $0x1
80102851:	53                   	push   %ebx
80102852:	e8 d9 26 00 00       	call   80104f30 <memset>

  if(kmem.use_lock)
80102857:	8b 15 74 36 11 80    	mov    0x80113674,%edx
8010285d:	83 c4 10             	add    $0x10,%esp
80102860:	85 d2                	test   %edx,%edx
80102862:	75 2c                	jne    80102890 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102864:	a1 78 36 11 80       	mov    0x80113678,%eax
80102869:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010286b:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
80102870:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
80102876:	85 c0                	test   %eax,%eax
80102878:	75 06                	jne    80102880 <kfree+0x60>
    release(&kmem.lock);
}
8010287a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010287d:	c9                   	leave  
8010287e:	c3                   	ret    
8010287f:	90                   	nop
    release(&kmem.lock);
80102880:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
80102887:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010288a:	c9                   	leave  
    release(&kmem.lock);
8010288b:	e9 40 26 00 00       	jmp    80104ed0 <release>
    acquire(&kmem.lock);
80102890:	83 ec 0c             	sub    $0xc,%esp
80102893:	68 40 36 11 80       	push   $0x80113640
80102898:	e8 13 25 00 00       	call   80104db0 <acquire>
8010289d:	83 c4 10             	add    $0x10,%esp
801028a0:	eb c2                	jmp    80102864 <kfree+0x44>
    panic("kfree");
801028a2:	83 ec 0c             	sub    $0xc,%esp
801028a5:	68 2e 81 10 80       	push   $0x8010812e
801028aa:	e8 e1 da ff ff       	call   80100390 <panic>
801028af:	90                   	nop

801028b0 <freerange>:
{
801028b0:	55                   	push   %ebp
801028b1:	89 e5                	mov    %esp,%ebp
801028b3:	56                   	push   %esi
801028b4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801028b5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801028b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801028bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801028c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801028cd:	39 de                	cmp    %ebx,%esi
801028cf:	72 23                	jb     801028f4 <freerange+0x44>
801028d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801028d8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801028de:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801028e7:	50                   	push   %eax
801028e8:	e8 33 ff ff ff       	call   80102820 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028ed:	83 c4 10             	add    $0x10,%esp
801028f0:	39 f3                	cmp    %esi,%ebx
801028f2:	76 e4                	jbe    801028d8 <freerange+0x28>
}
801028f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028f7:	5b                   	pop    %ebx
801028f8:	5e                   	pop    %esi
801028f9:	5d                   	pop    %ebp
801028fa:	c3                   	ret    
801028fb:	90                   	nop
801028fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102900 <kinit1>:
{
80102900:	55                   	push   %ebp
80102901:	89 e5                	mov    %esp,%ebp
80102903:	56                   	push   %esi
80102904:	53                   	push   %ebx
80102905:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102908:	83 ec 08             	sub    $0x8,%esp
8010290b:	68 34 81 10 80       	push   $0x80108134
80102910:	68 40 36 11 80       	push   $0x80113640
80102915:	e8 a6 23 00 00       	call   80104cc0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010291a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010291d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102920:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
80102927:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010292a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102930:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102936:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010293c:	39 de                	cmp    %ebx,%esi
8010293e:	72 1c                	jb     8010295c <kinit1+0x5c>
    kfree(p);
80102940:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102946:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102949:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010294f:	50                   	push   %eax
80102950:	e8 cb fe ff ff       	call   80102820 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102955:	83 c4 10             	add    $0x10,%esp
80102958:	39 de                	cmp    %ebx,%esi
8010295a:	73 e4                	jae    80102940 <kinit1+0x40>
}
8010295c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010295f:	5b                   	pop    %ebx
80102960:	5e                   	pop    %esi
80102961:	5d                   	pop    %ebp
80102962:	c3                   	ret    
80102963:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102970 <kinit2>:
{
80102970:	55                   	push   %ebp
80102971:	89 e5                	mov    %esp,%ebp
80102973:	56                   	push   %esi
80102974:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102975:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102978:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010297b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102981:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102987:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010298d:	39 de                	cmp    %ebx,%esi
8010298f:	72 23                	jb     801029b4 <kinit2+0x44>
80102991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102998:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010299e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801029a7:	50                   	push   %eax
801029a8:	e8 73 fe ff ff       	call   80102820 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029ad:	83 c4 10             	add    $0x10,%esp
801029b0:	39 de                	cmp    %ebx,%esi
801029b2:	73 e4                	jae    80102998 <kinit2+0x28>
  kmem.use_lock = 1;
801029b4:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
801029bb:	00 00 00 
}
801029be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801029c1:	5b                   	pop    %ebx
801029c2:	5e                   	pop    %esi
801029c3:	5d                   	pop    %ebp
801029c4:	c3                   	ret    
801029c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029d0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801029d0:	a1 74 36 11 80       	mov    0x80113674,%eax
801029d5:	85 c0                	test   %eax,%eax
801029d7:	75 1f                	jne    801029f8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801029d9:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
801029de:	85 c0                	test   %eax,%eax
801029e0:	74 0e                	je     801029f0 <kalloc+0x20>
    kmem.freelist = r->next;
801029e2:	8b 10                	mov    (%eax),%edx
801029e4:	89 15 78 36 11 80    	mov    %edx,0x80113678
801029ea:	c3                   	ret    
801029eb:	90                   	nop
801029ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801029f0:	f3 c3                	repz ret 
801029f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801029f8:	55                   	push   %ebp
801029f9:	89 e5                	mov    %esp,%ebp
801029fb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801029fe:	68 40 36 11 80       	push   $0x80113640
80102a03:	e8 a8 23 00 00       	call   80104db0 <acquire>
  r = kmem.freelist;
80102a08:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
80102a0d:	83 c4 10             	add    $0x10,%esp
80102a10:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102a16:	85 c0                	test   %eax,%eax
80102a18:	74 08                	je     80102a22 <kalloc+0x52>
    kmem.freelist = r->next;
80102a1a:	8b 08                	mov    (%eax),%ecx
80102a1c:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
80102a22:	85 d2                	test   %edx,%edx
80102a24:	74 16                	je     80102a3c <kalloc+0x6c>
    release(&kmem.lock);
80102a26:	83 ec 0c             	sub    $0xc,%esp
80102a29:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a2c:	68 40 36 11 80       	push   $0x80113640
80102a31:	e8 9a 24 00 00       	call   80104ed0 <release>
  return (char*)r;
80102a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102a39:	83 c4 10             	add    $0x10,%esp
}
80102a3c:	c9                   	leave  
80102a3d:	c3                   	ret    
80102a3e:	66 90                	xchg   %ax,%ax

80102a40 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a40:	ba 64 00 00 00       	mov    $0x64,%edx
80102a45:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102a46:	a8 01                	test   $0x1,%al
80102a48:	0f 84 c2 00 00 00    	je     80102b10 <kbdgetc+0xd0>
80102a4e:	ba 60 00 00 00       	mov    $0x60,%edx
80102a53:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102a54:	0f b6 d0             	movzbl %al,%edx
80102a57:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
80102a5d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102a63:	0f 84 7f 00 00 00    	je     80102ae8 <kbdgetc+0xa8>
{
80102a69:	55                   	push   %ebp
80102a6a:	89 e5                	mov    %esp,%ebp
80102a6c:	53                   	push   %ebx
80102a6d:	89 cb                	mov    %ecx,%ebx
80102a6f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102a72:	84 c0                	test   %al,%al
80102a74:	78 4a                	js     80102ac0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102a76:	85 db                	test   %ebx,%ebx
80102a78:	74 09                	je     80102a83 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102a7a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102a7d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102a80:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102a83:	0f b6 82 60 82 10 80 	movzbl -0x7fef7da0(%edx),%eax
80102a8a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102a8c:	0f b6 82 60 81 10 80 	movzbl -0x7fef7ea0(%edx),%eax
80102a93:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a95:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102a97:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102a9d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102aa0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102aa3:	8b 04 85 40 81 10 80 	mov    -0x7fef7ec0(,%eax,4),%eax
80102aaa:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102aae:	74 31                	je     80102ae1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102ab0:	8d 50 9f             	lea    -0x61(%eax),%edx
80102ab3:	83 fa 19             	cmp    $0x19,%edx
80102ab6:	77 40                	ja     80102af8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102ab8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102abb:	5b                   	pop    %ebx
80102abc:	5d                   	pop    %ebp
80102abd:	c3                   	ret    
80102abe:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102ac0:	83 e0 7f             	and    $0x7f,%eax
80102ac3:	85 db                	test   %ebx,%ebx
80102ac5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102ac8:	0f b6 82 60 82 10 80 	movzbl -0x7fef7da0(%edx),%eax
80102acf:	83 c8 40             	or     $0x40,%eax
80102ad2:	0f b6 c0             	movzbl %al,%eax
80102ad5:	f7 d0                	not    %eax
80102ad7:	21 c1                	and    %eax,%ecx
    return 0;
80102ad9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102adb:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102ae1:	5b                   	pop    %ebx
80102ae2:	5d                   	pop    %ebp
80102ae3:	c3                   	ret    
80102ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102ae8:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102aeb:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102aed:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
80102af3:	c3                   	ret    
80102af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102af8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102afb:	8d 50 20             	lea    0x20(%eax),%edx
}
80102afe:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102aff:	83 f9 1a             	cmp    $0x1a,%ecx
80102b02:	0f 42 c2             	cmovb  %edx,%eax
}
80102b05:	5d                   	pop    %ebp
80102b06:	c3                   	ret    
80102b07:	89 f6                	mov    %esi,%esi
80102b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102b15:	c3                   	ret    
80102b16:	8d 76 00             	lea    0x0(%esi),%esi
80102b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b20 <kbdintr>:

void
kbdintr(void)
{
80102b20:	55                   	push   %ebp
80102b21:	89 e5                	mov    %esp,%ebp
80102b23:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102b26:	68 40 2a 10 80       	push   $0x80102a40
80102b2b:	e8 e0 dc ff ff       	call   80100810 <consoleintr>
}
80102b30:	83 c4 10             	add    $0x10,%esp
80102b33:	c9                   	leave  
80102b34:	c3                   	ret    
80102b35:	66 90                	xchg   %ax,%ax
80102b37:	66 90                	xchg   %ax,%ax
80102b39:	66 90                	xchg   %ax,%ax
80102b3b:	66 90                	xchg   %ax,%ax
80102b3d:	66 90                	xchg   %ax,%ax
80102b3f:	90                   	nop

80102b40 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102b40:	a1 7c 36 11 80       	mov    0x8011367c,%eax
{
80102b45:	55                   	push   %ebp
80102b46:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102b48:	85 c0                	test   %eax,%eax
80102b4a:	0f 84 c8 00 00 00    	je     80102c18 <lapicinit+0xd8>
  lapic[index] = value;
80102b50:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102b57:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b5a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b5d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102b64:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b67:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b6a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102b71:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102b74:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b77:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102b7e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102b81:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b84:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102b8b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b8e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b91:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102b98:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b9b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102b9e:	8b 50 30             	mov    0x30(%eax),%edx
80102ba1:	c1 ea 10             	shr    $0x10,%edx
80102ba4:	80 fa 03             	cmp    $0x3,%dl
80102ba7:	77 77                	ja     80102c20 <lapicinit+0xe0>
  lapic[index] = value;
80102ba9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102bb0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bb3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bb6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102bbd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bc0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bc3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102bca:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bcd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bd0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102bd7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bda:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bdd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102be4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102be7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bea:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102bf1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102bf4:	8b 50 20             	mov    0x20(%eax),%edx
80102bf7:	89 f6                	mov    %esi,%esi
80102bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102c00:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102c06:	80 e6 10             	and    $0x10,%dh
80102c09:	75 f5                	jne    80102c00 <lapicinit+0xc0>
  lapic[index] = value;
80102c0b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102c12:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c15:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102c18:	5d                   	pop    %ebp
80102c19:	c3                   	ret    
80102c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102c20:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102c27:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102c2a:	8b 50 20             	mov    0x20(%eax),%edx
80102c2d:	e9 77 ff ff ff       	jmp    80102ba9 <lapicinit+0x69>
80102c32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c40 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102c40:	8b 15 7c 36 11 80    	mov    0x8011367c,%edx
{
80102c46:	55                   	push   %ebp
80102c47:	31 c0                	xor    %eax,%eax
80102c49:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102c4b:	85 d2                	test   %edx,%edx
80102c4d:	74 06                	je     80102c55 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102c4f:	8b 42 20             	mov    0x20(%edx),%eax
80102c52:	c1 e8 18             	shr    $0x18,%eax
}
80102c55:	5d                   	pop    %ebp
80102c56:	c3                   	ret    
80102c57:	89 f6                	mov    %esi,%esi
80102c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c60 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102c60:	a1 7c 36 11 80       	mov    0x8011367c,%eax
{
80102c65:	55                   	push   %ebp
80102c66:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102c68:	85 c0                	test   %eax,%eax
80102c6a:	74 0d                	je     80102c79 <lapiceoi+0x19>
  lapic[index] = value;
80102c6c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102c73:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c76:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102c79:	5d                   	pop    %ebp
80102c7a:	c3                   	ret    
80102c7b:	90                   	nop
80102c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c80 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102c80:	55                   	push   %ebp
80102c81:	89 e5                	mov    %esp,%ebp
}
80102c83:	5d                   	pop    %ebp
80102c84:	c3                   	ret    
80102c85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c90 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102c90:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c91:	b8 0f 00 00 00       	mov    $0xf,%eax
80102c96:	ba 70 00 00 00       	mov    $0x70,%edx
80102c9b:	89 e5                	mov    %esp,%ebp
80102c9d:	53                   	push   %ebx
80102c9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102ca1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102ca4:	ee                   	out    %al,(%dx)
80102ca5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102caa:	ba 71 00 00 00       	mov    $0x71,%edx
80102caf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102cb0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102cb2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102cb5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102cbb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102cbd:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102cc0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102cc3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102cc5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102cc8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102cce:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102cd3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cd9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cdc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102ce3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ce6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ce9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102cf0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cf3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cf6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cfc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cff:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d05:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102d08:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d0e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d11:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102d17:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102d1a:	5b                   	pop    %ebx
80102d1b:	5d                   	pop    %ebp
80102d1c:	c3                   	ret    
80102d1d:	8d 76 00             	lea    0x0(%esi),%esi

80102d20 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102d20:	55                   	push   %ebp
80102d21:	b8 0b 00 00 00       	mov    $0xb,%eax
80102d26:	ba 70 00 00 00       	mov    $0x70,%edx
80102d2b:	89 e5                	mov    %esp,%ebp
80102d2d:	57                   	push   %edi
80102d2e:	56                   	push   %esi
80102d2f:	53                   	push   %ebx
80102d30:	83 ec 4c             	sub    $0x4c,%esp
80102d33:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d34:	ba 71 00 00 00       	mov    $0x71,%edx
80102d39:	ec                   	in     (%dx),%al
80102d3a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d3d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102d42:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102d45:	8d 76 00             	lea    0x0(%esi),%esi
80102d48:	31 c0                	xor    %eax,%eax
80102d4a:	89 da                	mov    %ebx,%edx
80102d4c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d4d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102d52:	89 ca                	mov    %ecx,%edx
80102d54:	ec                   	in     (%dx),%al
80102d55:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d58:	89 da                	mov    %ebx,%edx
80102d5a:	b8 02 00 00 00       	mov    $0x2,%eax
80102d5f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d60:	89 ca                	mov    %ecx,%edx
80102d62:	ec                   	in     (%dx),%al
80102d63:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d66:	89 da                	mov    %ebx,%edx
80102d68:	b8 04 00 00 00       	mov    $0x4,%eax
80102d6d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d6e:	89 ca                	mov    %ecx,%edx
80102d70:	ec                   	in     (%dx),%al
80102d71:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d74:	89 da                	mov    %ebx,%edx
80102d76:	b8 07 00 00 00       	mov    $0x7,%eax
80102d7b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d7c:	89 ca                	mov    %ecx,%edx
80102d7e:	ec                   	in     (%dx),%al
80102d7f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d82:	89 da                	mov    %ebx,%edx
80102d84:	b8 08 00 00 00       	mov    $0x8,%eax
80102d89:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d8a:	89 ca                	mov    %ecx,%edx
80102d8c:	ec                   	in     (%dx),%al
80102d8d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d8f:	89 da                	mov    %ebx,%edx
80102d91:	b8 09 00 00 00       	mov    $0x9,%eax
80102d96:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d97:	89 ca                	mov    %ecx,%edx
80102d99:	ec                   	in     (%dx),%al
80102d9a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d9c:	89 da                	mov    %ebx,%edx
80102d9e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102da3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102da4:	89 ca                	mov    %ecx,%edx
80102da6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102da7:	84 c0                	test   %al,%al
80102da9:	78 9d                	js     80102d48 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102dab:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102daf:	89 fa                	mov    %edi,%edx
80102db1:	0f b6 fa             	movzbl %dl,%edi
80102db4:	89 f2                	mov    %esi,%edx
80102db6:	0f b6 f2             	movzbl %dl,%esi
80102db9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dbc:	89 da                	mov    %ebx,%edx
80102dbe:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102dc1:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102dc4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102dc8:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102dcb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102dcf:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102dd2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102dd6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102dd9:	31 c0                	xor    %eax,%eax
80102ddb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ddc:	89 ca                	mov    %ecx,%edx
80102dde:	ec                   	in     (%dx),%al
80102ddf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102de2:	89 da                	mov    %ebx,%edx
80102de4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102de7:	b8 02 00 00 00       	mov    $0x2,%eax
80102dec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ded:	89 ca                	mov    %ecx,%edx
80102def:	ec                   	in     (%dx),%al
80102df0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102df3:	89 da                	mov    %ebx,%edx
80102df5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102df8:	b8 04 00 00 00       	mov    $0x4,%eax
80102dfd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dfe:	89 ca                	mov    %ecx,%edx
80102e00:	ec                   	in     (%dx),%al
80102e01:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e04:	89 da                	mov    %ebx,%edx
80102e06:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102e09:	b8 07 00 00 00       	mov    $0x7,%eax
80102e0e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e0f:	89 ca                	mov    %ecx,%edx
80102e11:	ec                   	in     (%dx),%al
80102e12:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e15:	89 da                	mov    %ebx,%edx
80102e17:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102e1a:	b8 08 00 00 00       	mov    $0x8,%eax
80102e1f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e20:	89 ca                	mov    %ecx,%edx
80102e22:	ec                   	in     (%dx),%al
80102e23:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e26:	89 da                	mov    %ebx,%edx
80102e28:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102e2b:	b8 09 00 00 00       	mov    $0x9,%eax
80102e30:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e31:	89 ca                	mov    %ecx,%edx
80102e33:	ec                   	in     (%dx),%al
80102e34:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e37:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102e3a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102e3d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102e40:	6a 18                	push   $0x18
80102e42:	50                   	push   %eax
80102e43:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102e46:	50                   	push   %eax
80102e47:	e8 34 21 00 00       	call   80104f80 <memcmp>
80102e4c:	83 c4 10             	add    $0x10,%esp
80102e4f:	85 c0                	test   %eax,%eax
80102e51:	0f 85 f1 fe ff ff    	jne    80102d48 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102e57:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102e5b:	75 78                	jne    80102ed5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102e5d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102e60:	89 c2                	mov    %eax,%edx
80102e62:	83 e0 0f             	and    $0xf,%eax
80102e65:	c1 ea 04             	shr    $0x4,%edx
80102e68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e6e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102e71:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102e74:	89 c2                	mov    %eax,%edx
80102e76:	83 e0 0f             	and    $0xf,%eax
80102e79:	c1 ea 04             	shr    $0x4,%edx
80102e7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e82:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102e85:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102e88:	89 c2                	mov    %eax,%edx
80102e8a:	83 e0 0f             	and    $0xf,%eax
80102e8d:	c1 ea 04             	shr    $0x4,%edx
80102e90:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e93:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e96:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102e99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102e9c:	89 c2                	mov    %eax,%edx
80102e9e:	83 e0 0f             	and    $0xf,%eax
80102ea1:	c1 ea 04             	shr    $0x4,%edx
80102ea4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ea7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102eaa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102ead:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102eb0:	89 c2                	mov    %eax,%edx
80102eb2:	83 e0 0f             	and    $0xf,%eax
80102eb5:	c1 ea 04             	shr    $0x4,%edx
80102eb8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ebb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ebe:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102ec1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ec4:	89 c2                	mov    %eax,%edx
80102ec6:	83 e0 0f             	and    $0xf,%eax
80102ec9:	c1 ea 04             	shr    $0x4,%edx
80102ecc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ecf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ed2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102ed5:	8b 75 08             	mov    0x8(%ebp),%esi
80102ed8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102edb:	89 06                	mov    %eax,(%esi)
80102edd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ee0:	89 46 04             	mov    %eax,0x4(%esi)
80102ee3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ee6:	89 46 08             	mov    %eax,0x8(%esi)
80102ee9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102eec:	89 46 0c             	mov    %eax,0xc(%esi)
80102eef:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ef2:	89 46 10             	mov    %eax,0x10(%esi)
80102ef5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ef8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102efb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102f02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f05:	5b                   	pop    %ebx
80102f06:	5e                   	pop    %esi
80102f07:	5f                   	pop    %edi
80102f08:	5d                   	pop    %ebp
80102f09:	c3                   	ret    
80102f0a:	66 90                	xchg   %ax,%ax
80102f0c:	66 90                	xchg   %ax,%ax
80102f0e:	66 90                	xchg   %ax,%ax

80102f10 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102f10:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102f16:	85 c9                	test   %ecx,%ecx
80102f18:	0f 8e 8a 00 00 00    	jle    80102fa8 <install_trans+0x98>
{
80102f1e:	55                   	push   %ebp
80102f1f:	89 e5                	mov    %esp,%ebp
80102f21:	57                   	push   %edi
80102f22:	56                   	push   %esi
80102f23:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102f24:	31 db                	xor    %ebx,%ebx
{
80102f26:	83 ec 0c             	sub    $0xc,%esp
80102f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102f30:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102f35:	83 ec 08             	sub    $0x8,%esp
80102f38:	01 d8                	add    %ebx,%eax
80102f3a:	83 c0 01             	add    $0x1,%eax
80102f3d:	50                   	push   %eax
80102f3e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102f44:	e8 87 d1 ff ff       	call   801000d0 <bread>
80102f49:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f4b:	58                   	pop    %eax
80102f4c:	5a                   	pop    %edx
80102f4d:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102f54:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102f5a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f5d:	e8 6e d1 ff ff       	call   801000d0 <bread>
80102f62:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102f64:	8d 47 5c             	lea    0x5c(%edi),%eax
80102f67:	83 c4 0c             	add    $0xc,%esp
80102f6a:	68 00 02 00 00       	push   $0x200
80102f6f:	50                   	push   %eax
80102f70:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f73:	50                   	push   %eax
80102f74:	e8 67 20 00 00       	call   80104fe0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102f79:	89 34 24             	mov    %esi,(%esp)
80102f7c:	e8 1f d2 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102f81:	89 3c 24             	mov    %edi,(%esp)
80102f84:	e8 57 d2 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102f89:	89 34 24             	mov    %esi,(%esp)
80102f8c:	e8 4f d2 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f91:	83 c4 10             	add    $0x10,%esp
80102f94:	39 1d c8 36 11 80    	cmp    %ebx,0x801136c8
80102f9a:	7f 94                	jg     80102f30 <install_trans+0x20>
  }
}
80102f9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f9f:	5b                   	pop    %ebx
80102fa0:	5e                   	pop    %esi
80102fa1:	5f                   	pop    %edi
80102fa2:	5d                   	pop    %ebp
80102fa3:	c3                   	ret    
80102fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fa8:	f3 c3                	repz ret 
80102faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102fb0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	56                   	push   %esi
80102fb4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102fb5:	83 ec 08             	sub    $0x8,%esp
80102fb8:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102fbe:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102fc4:	e8 07 d1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102fc9:	8b 1d c8 36 11 80    	mov    0x801136c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102fcf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102fd2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102fd4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102fd6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102fd9:	7e 16                	jle    80102ff1 <write_head+0x41>
80102fdb:	c1 e3 02             	shl    $0x2,%ebx
80102fde:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102fe0:	8b 8a cc 36 11 80    	mov    -0x7feec934(%edx),%ecx
80102fe6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102fea:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102fed:	39 da                	cmp    %ebx,%edx
80102fef:	75 ef                	jne    80102fe0 <write_head+0x30>
  }
  bwrite(buf);
80102ff1:	83 ec 0c             	sub    $0xc,%esp
80102ff4:	56                   	push   %esi
80102ff5:	e8 a6 d1 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102ffa:	89 34 24             	mov    %esi,(%esp)
80102ffd:	e8 de d1 ff ff       	call   801001e0 <brelse>
}
80103002:	83 c4 10             	add    $0x10,%esp
80103005:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103008:	5b                   	pop    %ebx
80103009:	5e                   	pop    %esi
8010300a:	5d                   	pop    %ebp
8010300b:	c3                   	ret    
8010300c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103010 <initlog>:
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	53                   	push   %ebx
80103014:	83 ec 2c             	sub    $0x2c,%esp
80103017:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010301a:	68 60 83 10 80       	push   $0x80108360
8010301f:	68 80 36 11 80       	push   $0x80113680
80103024:	e8 97 1c 00 00       	call   80104cc0 <initlock>
  readsb(dev, &sb);
80103029:	58                   	pop    %eax
8010302a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010302d:	5a                   	pop    %edx
8010302e:	50                   	push   %eax
8010302f:	53                   	push   %ebx
80103030:	e8 1b e4 ff ff       	call   80101450 <readsb>
  log.size = sb.nlog;
80103035:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103038:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010303b:	59                   	pop    %ecx
  log.dev = dev;
8010303c:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4
  log.size = sb.nlog;
80103042:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  log.start = sb.logstart;
80103048:	a3 b4 36 11 80       	mov    %eax,0x801136b4
  struct buf *buf = bread(log.dev, log.start);
8010304d:	5a                   	pop    %edx
8010304e:	50                   	push   %eax
8010304f:	53                   	push   %ebx
80103050:	e8 7b d0 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80103055:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80103058:	83 c4 10             	add    $0x10,%esp
8010305b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
8010305d:	89 1d c8 36 11 80    	mov    %ebx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80103063:	7e 1c                	jle    80103081 <initlog+0x71>
80103065:	c1 e3 02             	shl    $0x2,%ebx
80103068:	31 d2                	xor    %edx,%edx
8010306a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80103070:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80103074:	83 c2 04             	add    $0x4,%edx
80103077:	89 8a c8 36 11 80    	mov    %ecx,-0x7feec938(%edx)
  for (i = 0; i < log.lh.n; i++) {
8010307d:	39 d3                	cmp    %edx,%ebx
8010307f:	75 ef                	jne    80103070 <initlog+0x60>
  brelse(buf);
80103081:	83 ec 0c             	sub    $0xc,%esp
80103084:	50                   	push   %eax
80103085:	e8 56 d1 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010308a:	e8 81 fe ff ff       	call   80102f10 <install_trans>
  log.lh.n = 0;
8010308f:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80103096:	00 00 00 
  write_head(); // clear the log
80103099:	e8 12 ff ff ff       	call   80102fb0 <write_head>
}
8010309e:	83 c4 10             	add    $0x10,%esp
801030a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801030a4:	c9                   	leave  
801030a5:	c3                   	ret    
801030a6:	8d 76 00             	lea    0x0(%esi),%esi
801030a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801030b0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801030b0:	55                   	push   %ebp
801030b1:	89 e5                	mov    %esp,%ebp
801030b3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801030b6:	68 80 36 11 80       	push   $0x80113680
801030bb:	e8 f0 1c 00 00       	call   80104db0 <acquire>
801030c0:	83 c4 10             	add    $0x10,%esp
801030c3:	eb 18                	jmp    801030dd <begin_op+0x2d>
801030c5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801030c8:	83 ec 08             	sub    $0x8,%esp
801030cb:	68 80 36 11 80       	push   $0x80113680
801030d0:	68 80 36 11 80       	push   $0x80113680
801030d5:	e8 d6 12 00 00       	call   801043b0 <sleep>
801030da:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801030dd:	a1 c0 36 11 80       	mov    0x801136c0,%eax
801030e2:	85 c0                	test   %eax,%eax
801030e4:	75 e2                	jne    801030c8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801030e6:	a1 bc 36 11 80       	mov    0x801136bc,%eax
801030eb:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
801030f1:	83 c0 01             	add    $0x1,%eax
801030f4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801030f7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801030fa:	83 fa 1e             	cmp    $0x1e,%edx
801030fd:	7f c9                	jg     801030c8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801030ff:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103102:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80103107:	68 80 36 11 80       	push   $0x80113680
8010310c:	e8 bf 1d 00 00       	call   80104ed0 <release>
      break;
    }
  }
}
80103111:	83 c4 10             	add    $0x10,%esp
80103114:	c9                   	leave  
80103115:	c3                   	ret    
80103116:	8d 76 00             	lea    0x0(%esi),%esi
80103119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103120 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103120:	55                   	push   %ebp
80103121:	89 e5                	mov    %esp,%ebp
80103123:	57                   	push   %edi
80103124:	56                   	push   %esi
80103125:	53                   	push   %ebx
80103126:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103129:	68 80 36 11 80       	push   $0x80113680
8010312e:	e8 7d 1c 00 00       	call   80104db0 <acquire>
  log.outstanding -= 1;
80103133:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80103138:	8b 35 c0 36 11 80    	mov    0x801136c0,%esi
8010313e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103141:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80103144:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80103146:	89 1d bc 36 11 80    	mov    %ebx,0x801136bc
  if(log.committing)
8010314c:	0f 85 1a 01 00 00    	jne    8010326c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80103152:	85 db                	test   %ebx,%ebx
80103154:	0f 85 ee 00 00 00    	jne    80103248 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010315a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
8010315d:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80103164:	00 00 00 
  release(&log.lock);
80103167:	68 80 36 11 80       	push   $0x80113680
8010316c:	e8 5f 1d 00 00       	call   80104ed0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103171:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80103177:	83 c4 10             	add    $0x10,%esp
8010317a:	85 c9                	test   %ecx,%ecx
8010317c:	0f 8e 85 00 00 00    	jle    80103207 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103182:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80103187:	83 ec 08             	sub    $0x8,%esp
8010318a:	01 d8                	add    %ebx,%eax
8010318c:	83 c0 01             	add    $0x1,%eax
8010318f:	50                   	push   %eax
80103190:	ff 35 c4 36 11 80    	pushl  0x801136c4
80103196:	e8 35 cf ff ff       	call   801000d0 <bread>
8010319b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010319d:	58                   	pop    %eax
8010319e:	5a                   	pop    %edx
8010319f:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
801031a6:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
801031ac:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801031af:	e8 1c cf ff ff       	call   801000d0 <bread>
801031b4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801031b6:	8d 40 5c             	lea    0x5c(%eax),%eax
801031b9:	83 c4 0c             	add    $0xc,%esp
801031bc:	68 00 02 00 00       	push   $0x200
801031c1:	50                   	push   %eax
801031c2:	8d 46 5c             	lea    0x5c(%esi),%eax
801031c5:	50                   	push   %eax
801031c6:	e8 15 1e 00 00       	call   80104fe0 <memmove>
    bwrite(to);  // write the log
801031cb:	89 34 24             	mov    %esi,(%esp)
801031ce:	e8 cd cf ff ff       	call   801001a0 <bwrite>
    brelse(from);
801031d3:	89 3c 24             	mov    %edi,(%esp)
801031d6:	e8 05 d0 ff ff       	call   801001e0 <brelse>
    brelse(to);
801031db:	89 34 24             	mov    %esi,(%esp)
801031de:	e8 fd cf ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801031e3:	83 c4 10             	add    $0x10,%esp
801031e6:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
801031ec:	7c 94                	jl     80103182 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801031ee:	e8 bd fd ff ff       	call   80102fb0 <write_head>
    install_trans(); // Now install writes to home locations
801031f3:	e8 18 fd ff ff       	call   80102f10 <install_trans>
    log.lh.n = 0;
801031f8:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
801031ff:	00 00 00 
    write_head();    // Erase the transaction from the log
80103202:	e8 a9 fd ff ff       	call   80102fb0 <write_head>
    acquire(&log.lock);
80103207:	83 ec 0c             	sub    $0xc,%esp
8010320a:	68 80 36 11 80       	push   $0x80113680
8010320f:	e8 9c 1b 00 00       	call   80104db0 <acquire>
    wakeup(&log);
80103214:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
8010321b:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80103222:	00 00 00 
    wakeup(&log);
80103225:	e8 46 13 00 00       	call   80104570 <wakeup>
    release(&log.lock);
8010322a:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80103231:	e8 9a 1c 00 00       	call   80104ed0 <release>
80103236:	83 c4 10             	add    $0x10,%esp
}
80103239:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010323c:	5b                   	pop    %ebx
8010323d:	5e                   	pop    %esi
8010323e:	5f                   	pop    %edi
8010323f:	5d                   	pop    %ebp
80103240:	c3                   	ret    
80103241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103248:	83 ec 0c             	sub    $0xc,%esp
8010324b:	68 80 36 11 80       	push   $0x80113680
80103250:	e8 1b 13 00 00       	call   80104570 <wakeup>
  release(&log.lock);
80103255:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
8010325c:	e8 6f 1c 00 00       	call   80104ed0 <release>
80103261:	83 c4 10             	add    $0x10,%esp
}
80103264:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103267:	5b                   	pop    %ebx
80103268:	5e                   	pop    %esi
80103269:	5f                   	pop    %edi
8010326a:	5d                   	pop    %ebp
8010326b:	c3                   	ret    
    panic("log.committing");
8010326c:	83 ec 0c             	sub    $0xc,%esp
8010326f:	68 64 83 10 80       	push   $0x80108364
80103274:	e8 17 d1 ff ff       	call   80100390 <panic>
80103279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103280 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103280:	55                   	push   %ebp
80103281:	89 e5                	mov    %esp,%ebp
80103283:	53                   	push   %ebx
80103284:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103287:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
{
8010328d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103290:	83 fa 1d             	cmp    $0x1d,%edx
80103293:	0f 8f 9d 00 00 00    	jg     80103336 <log_write+0xb6>
80103299:	a1 b8 36 11 80       	mov    0x801136b8,%eax
8010329e:	83 e8 01             	sub    $0x1,%eax
801032a1:	39 c2                	cmp    %eax,%edx
801032a3:	0f 8d 8d 00 00 00    	jge    80103336 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
801032a9:	a1 bc 36 11 80       	mov    0x801136bc,%eax
801032ae:	85 c0                	test   %eax,%eax
801032b0:	0f 8e 8d 00 00 00    	jle    80103343 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
801032b6:	83 ec 0c             	sub    $0xc,%esp
801032b9:	68 80 36 11 80       	push   $0x80113680
801032be:	e8 ed 1a 00 00       	call   80104db0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801032c3:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
801032c9:	83 c4 10             	add    $0x10,%esp
801032cc:	83 f9 00             	cmp    $0x0,%ecx
801032cf:	7e 57                	jle    80103328 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801032d1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
801032d4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801032d6:	3b 15 cc 36 11 80    	cmp    0x801136cc,%edx
801032dc:	75 0b                	jne    801032e9 <log_write+0x69>
801032de:	eb 38                	jmp    80103318 <log_write+0x98>
801032e0:	39 14 85 cc 36 11 80 	cmp    %edx,-0x7feec934(,%eax,4)
801032e7:	74 2f                	je     80103318 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
801032e9:	83 c0 01             	add    $0x1,%eax
801032ec:	39 c1                	cmp    %eax,%ecx
801032ee:	75 f0                	jne    801032e0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801032f0:	89 14 85 cc 36 11 80 	mov    %edx,-0x7feec934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
801032f7:	83 c0 01             	add    $0x1,%eax
801032fa:	a3 c8 36 11 80       	mov    %eax,0x801136c8
  b->flags |= B_DIRTY; // prevent eviction
801032ff:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103302:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80103309:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010330c:	c9                   	leave  
  release(&log.lock);
8010330d:	e9 be 1b 00 00       	jmp    80104ed0 <release>
80103312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103318:	89 14 85 cc 36 11 80 	mov    %edx,-0x7feec934(,%eax,4)
8010331f:	eb de                	jmp    801032ff <log_write+0x7f>
80103321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103328:	8b 43 08             	mov    0x8(%ebx),%eax
8010332b:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80103330:	75 cd                	jne    801032ff <log_write+0x7f>
80103332:	31 c0                	xor    %eax,%eax
80103334:	eb c1                	jmp    801032f7 <log_write+0x77>
    panic("too big a transaction");
80103336:	83 ec 0c             	sub    $0xc,%esp
80103339:	68 73 83 10 80       	push   $0x80108373
8010333e:	e8 4d d0 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103343:	83 ec 0c             	sub    $0xc,%esp
80103346:	68 89 83 10 80       	push   $0x80108389
8010334b:	e8 40 d0 ff ff       	call   80100390 <panic>

80103350 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	53                   	push   %ebx
80103354:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103357:	e8 e4 09 00 00       	call   80103d40 <cpuid>
8010335c:	89 c3                	mov    %eax,%ebx
8010335e:	e8 dd 09 00 00       	call   80103d40 <cpuid>
80103363:	83 ec 04             	sub    $0x4,%esp
80103366:	53                   	push   %ebx
80103367:	50                   	push   %eax
80103368:	68 a4 83 10 80       	push   $0x801083a4
8010336d:	e8 ee d2 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103372:	e8 c9 2e 00 00       	call   80106240 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103377:	e8 44 09 00 00       	call   80103cc0 <mycpu>
8010337c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010337e:	b8 01 00 00 00       	mov    $0x1,%eax
80103383:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010338a:	e8 31 0d 00 00       	call   801040c0 <scheduler>
8010338f:	90                   	nop

80103390 <mpenter>:
{
80103390:	55                   	push   %ebp
80103391:	89 e5                	mov    %esp,%ebp
80103393:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103396:	e8 e5 3e 00 00       	call   80107280 <switchkvm>
  seginit();
8010339b:	e8 50 3e 00 00       	call   801071f0 <seginit>
  lapicinit();
801033a0:	e8 9b f7 ff ff       	call   80102b40 <lapicinit>
  mpmain();
801033a5:	e8 a6 ff ff ff       	call   80103350 <mpmain>
801033aa:	66 90                	xchg   %ax,%ax
801033ac:	66 90                	xchg   %ax,%ax
801033ae:	66 90                	xchg   %ax,%ax

801033b0 <main>:
{
801033b0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801033b4:	83 e4 f0             	and    $0xfffffff0,%esp
801033b7:	ff 71 fc             	pushl  -0x4(%ecx)
801033ba:	55                   	push   %ebp
801033bb:	89 e5                	mov    %esp,%ebp
801033bd:	53                   	push   %ebx
801033be:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801033bf:	83 ec 08             	sub    $0x8,%esp
801033c2:	68 00 00 40 80       	push   $0x80400000
801033c7:	68 c8 2c 12 80       	push   $0x80122cc8
801033cc:	e8 2f f5 ff ff       	call   80102900 <kinit1>
  kvmalloc();      // kernel page table
801033d1:	e8 ca 46 00 00       	call   80107aa0 <kvmalloc>
  mpinit();        // detect other processors
801033d6:	e8 75 01 00 00       	call   80103550 <mpinit>
  lapicinit();     // interrupt controller
801033db:	e8 60 f7 ff ff       	call   80102b40 <lapicinit>
  seginit();       // segment descriptors
801033e0:	e8 0b 3e 00 00       	call   801071f0 <seginit>
  picinit();       // disable pic
801033e5:	e8 46 03 00 00       	call   80103730 <picinit>
  ioapicinit();    // another interrupt controller
801033ea:	e8 41 f3 ff ff       	call   80102730 <ioapicinit>
  consoleinit();   // console hardware
801033ef:	e8 cc d5 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
801033f4:	e8 67 31 00 00       	call   80106560 <uartinit>
  pinit();         // process table
801033f9:	e8 a2 08 00 00       	call   80103ca0 <pinit>
  tvinit();        // trap vectors
801033fe:	e8 bd 2d 00 00       	call   801061c0 <tvinit>
  binit();         // buffer cache
80103403:	e8 38 cc ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103408:	e8 d3 d9 ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
8010340d:	e8 fe f0 ff ff       	call   80102510 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103412:	83 c4 0c             	add    $0xc,%esp
80103415:	68 8a 00 00 00       	push   $0x8a
8010341a:	68 8c b4 10 80       	push   $0x8010b48c
8010341f:	68 00 70 00 80       	push   $0x80007000
80103424:	e8 b7 1b 00 00       	call   80104fe0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103429:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103430:	00 00 00 
80103433:	83 c4 10             	add    $0x10,%esp
80103436:	05 80 37 11 80       	add    $0x80113780,%eax
8010343b:	3d 80 37 11 80       	cmp    $0x80113780,%eax
80103440:	76 71                	jbe    801034b3 <main+0x103>
80103442:	bb 80 37 11 80       	mov    $0x80113780,%ebx
80103447:	89 f6                	mov    %esi,%esi
80103449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103450:	e8 6b 08 00 00       	call   80103cc0 <mycpu>
80103455:	39 d8                	cmp    %ebx,%eax
80103457:	74 41                	je     8010349a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103459:	e8 72 f5 ff ff       	call   801029d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010345e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80103463:	c7 05 f8 6f 00 80 90 	movl   $0x80103390,0x80006ff8
8010346a:	33 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010346d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103474:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103477:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010347c:	0f b6 03             	movzbl (%ebx),%eax
8010347f:	83 ec 08             	sub    $0x8,%esp
80103482:	68 00 70 00 00       	push   $0x7000
80103487:	50                   	push   %eax
80103488:	e8 03 f8 ff ff       	call   80102c90 <lapicstartap>
8010348d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103490:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103496:	85 c0                	test   %eax,%eax
80103498:	74 f6                	je     80103490 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010349a:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801034a1:	00 00 00 
801034a4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801034aa:	05 80 37 11 80       	add    $0x80113780,%eax
801034af:	39 c3                	cmp    %eax,%ebx
801034b1:	72 9d                	jb     80103450 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801034b3:	83 ec 08             	sub    $0x8,%esp
801034b6:	68 00 00 00 8e       	push   $0x8e000000
801034bb:	68 00 00 40 80       	push   $0x80400000
801034c0:	e8 ab f4 ff ff       	call   80102970 <kinit2>
  userinit();      // first user process
801034c5:	e8 26 09 00 00       	call   80103df0 <userinit>
  mpmain();        // finish this processor's setup
801034ca:	e8 81 fe ff ff       	call   80103350 <mpmain>
801034cf:	90                   	nop

801034d0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801034d0:	55                   	push   %ebp
801034d1:	89 e5                	mov    %esp,%ebp
801034d3:	57                   	push   %edi
801034d4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801034d5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801034db:	53                   	push   %ebx
  e = addr+len;
801034dc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801034df:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801034e2:	39 de                	cmp    %ebx,%esi
801034e4:	72 10                	jb     801034f6 <mpsearch1+0x26>
801034e6:	eb 50                	jmp    80103538 <mpsearch1+0x68>
801034e8:	90                   	nop
801034e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034f0:	39 fb                	cmp    %edi,%ebx
801034f2:	89 fe                	mov    %edi,%esi
801034f4:	76 42                	jbe    80103538 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034f6:	83 ec 04             	sub    $0x4,%esp
801034f9:	8d 7e 10             	lea    0x10(%esi),%edi
801034fc:	6a 04                	push   $0x4
801034fe:	68 b8 83 10 80       	push   $0x801083b8
80103503:	56                   	push   %esi
80103504:	e8 77 1a 00 00       	call   80104f80 <memcmp>
80103509:	83 c4 10             	add    $0x10,%esp
8010350c:	85 c0                	test   %eax,%eax
8010350e:	75 e0                	jne    801034f0 <mpsearch1+0x20>
80103510:	89 f1                	mov    %esi,%ecx
80103512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103518:	0f b6 11             	movzbl (%ecx),%edx
8010351b:	83 c1 01             	add    $0x1,%ecx
8010351e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103520:	39 f9                	cmp    %edi,%ecx
80103522:	75 f4                	jne    80103518 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103524:	84 c0                	test   %al,%al
80103526:	75 c8                	jne    801034f0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103528:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010352b:	89 f0                	mov    %esi,%eax
8010352d:	5b                   	pop    %ebx
8010352e:	5e                   	pop    %esi
8010352f:	5f                   	pop    %edi
80103530:	5d                   	pop    %ebp
80103531:	c3                   	ret    
80103532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103538:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010353b:	31 f6                	xor    %esi,%esi
}
8010353d:	89 f0                	mov    %esi,%eax
8010353f:	5b                   	pop    %ebx
80103540:	5e                   	pop    %esi
80103541:	5f                   	pop    %edi
80103542:	5d                   	pop    %ebp
80103543:	c3                   	ret    
80103544:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010354a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103550 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103550:	55                   	push   %ebp
80103551:	89 e5                	mov    %esp,%ebp
80103553:	57                   	push   %edi
80103554:	56                   	push   %esi
80103555:	53                   	push   %ebx
80103556:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103559:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103560:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103567:	c1 e0 08             	shl    $0x8,%eax
8010356a:	09 d0                	or     %edx,%eax
8010356c:	c1 e0 04             	shl    $0x4,%eax
8010356f:	85 c0                	test   %eax,%eax
80103571:	75 1b                	jne    8010358e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103573:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010357a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103581:	c1 e0 08             	shl    $0x8,%eax
80103584:	09 d0                	or     %edx,%eax
80103586:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103589:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010358e:	ba 00 04 00 00       	mov    $0x400,%edx
80103593:	e8 38 ff ff ff       	call   801034d0 <mpsearch1>
80103598:	85 c0                	test   %eax,%eax
8010359a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010359d:	0f 84 3d 01 00 00    	je     801036e0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801035a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801035a6:	8b 58 04             	mov    0x4(%eax),%ebx
801035a9:	85 db                	test   %ebx,%ebx
801035ab:	0f 84 4f 01 00 00    	je     80103700 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801035b1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801035b7:	83 ec 04             	sub    $0x4,%esp
801035ba:	6a 04                	push   $0x4
801035bc:	68 d5 83 10 80       	push   $0x801083d5
801035c1:	56                   	push   %esi
801035c2:	e8 b9 19 00 00       	call   80104f80 <memcmp>
801035c7:	83 c4 10             	add    $0x10,%esp
801035ca:	85 c0                	test   %eax,%eax
801035cc:	0f 85 2e 01 00 00    	jne    80103700 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801035d2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801035d9:	3c 01                	cmp    $0x1,%al
801035db:	0f 95 c2             	setne  %dl
801035de:	3c 04                	cmp    $0x4,%al
801035e0:	0f 95 c0             	setne  %al
801035e3:	20 c2                	and    %al,%dl
801035e5:	0f 85 15 01 00 00    	jne    80103700 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801035eb:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801035f2:	66 85 ff             	test   %di,%di
801035f5:	74 1a                	je     80103611 <mpinit+0xc1>
801035f7:	89 f0                	mov    %esi,%eax
801035f9:	01 f7                	add    %esi,%edi
  sum = 0;
801035fb:	31 d2                	xor    %edx,%edx
801035fd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103600:	0f b6 08             	movzbl (%eax),%ecx
80103603:	83 c0 01             	add    $0x1,%eax
80103606:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103608:	39 c7                	cmp    %eax,%edi
8010360a:	75 f4                	jne    80103600 <mpinit+0xb0>
8010360c:	84 d2                	test   %dl,%dl
8010360e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103611:	85 f6                	test   %esi,%esi
80103613:	0f 84 e7 00 00 00    	je     80103700 <mpinit+0x1b0>
80103619:	84 d2                	test   %dl,%dl
8010361b:	0f 85 df 00 00 00    	jne    80103700 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103621:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103627:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010362c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103633:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103639:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010363e:	01 d6                	add    %edx,%esi
80103640:	39 c6                	cmp    %eax,%esi
80103642:	76 23                	jbe    80103667 <mpinit+0x117>
    switch(*p){
80103644:	0f b6 10             	movzbl (%eax),%edx
80103647:	80 fa 04             	cmp    $0x4,%dl
8010364a:	0f 87 ca 00 00 00    	ja     8010371a <mpinit+0x1ca>
80103650:	ff 24 95 fc 83 10 80 	jmp    *-0x7fef7c04(,%edx,4)
80103657:	89 f6                	mov    %esi,%esi
80103659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103660:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103663:	39 c6                	cmp    %eax,%esi
80103665:	77 dd                	ja     80103644 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103667:	85 db                	test   %ebx,%ebx
80103669:	0f 84 9e 00 00 00    	je     8010370d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010366f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103672:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103676:	74 15                	je     8010368d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103678:	b8 70 00 00 00       	mov    $0x70,%eax
8010367d:	ba 22 00 00 00       	mov    $0x22,%edx
80103682:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103683:	ba 23 00 00 00       	mov    $0x23,%edx
80103688:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103689:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010368c:	ee                   	out    %al,(%dx)
  }
}
8010368d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103690:	5b                   	pop    %ebx
80103691:	5e                   	pop    %esi
80103692:	5f                   	pop    %edi
80103693:	5d                   	pop    %ebp
80103694:	c3                   	ret    
80103695:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103698:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
8010369e:	83 f9 07             	cmp    $0x7,%ecx
801036a1:	7f 19                	jg     801036bc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801036a3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801036a7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801036ad:	83 c1 01             	add    $0x1,%ecx
801036b0:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801036b6:	88 97 80 37 11 80    	mov    %dl,-0x7feec880(%edi)
      p += sizeof(struct mpproc);
801036bc:	83 c0 14             	add    $0x14,%eax
      continue;
801036bf:	e9 7c ff ff ff       	jmp    80103640 <mpinit+0xf0>
801036c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801036c8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801036cc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801036cf:	88 15 60 37 11 80    	mov    %dl,0x80113760
      continue;
801036d5:	e9 66 ff ff ff       	jmp    80103640 <mpinit+0xf0>
801036da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801036e0:	ba 00 00 01 00       	mov    $0x10000,%edx
801036e5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801036ea:	e8 e1 fd ff ff       	call   801034d0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801036ef:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801036f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801036f4:	0f 85 a9 fe ff ff    	jne    801035a3 <mpinit+0x53>
801036fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103700:	83 ec 0c             	sub    $0xc,%esp
80103703:	68 bd 83 10 80       	push   $0x801083bd
80103708:	e8 83 cc ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010370d:	83 ec 0c             	sub    $0xc,%esp
80103710:	68 dc 83 10 80       	push   $0x801083dc
80103715:	e8 76 cc ff ff       	call   80100390 <panic>
      ismp = 0;
8010371a:	31 db                	xor    %ebx,%ebx
8010371c:	e9 26 ff ff ff       	jmp    80103647 <mpinit+0xf7>
80103721:	66 90                	xchg   %ax,%ax
80103723:	66 90                	xchg   %ax,%ax
80103725:	66 90                	xchg   %ax,%ax
80103727:	66 90                	xchg   %ax,%ax
80103729:	66 90                	xchg   %ax,%ax
8010372b:	66 90                	xchg   %ax,%ax
8010372d:	66 90                	xchg   %ax,%ax
8010372f:	90                   	nop

80103730 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103730:	55                   	push   %ebp
80103731:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103736:	ba 21 00 00 00       	mov    $0x21,%edx
8010373b:	89 e5                	mov    %esp,%ebp
8010373d:	ee                   	out    %al,(%dx)
8010373e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103743:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103744:	5d                   	pop    %ebp
80103745:	c3                   	ret    
80103746:	66 90                	xchg   %ax,%ax
80103748:	66 90                	xchg   %ax,%ax
8010374a:	66 90                	xchg   %ax,%ax
8010374c:	66 90                	xchg   %ax,%ax
8010374e:	66 90                	xchg   %ax,%ax

80103750 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	57                   	push   %edi
80103754:	56                   	push   %esi
80103755:	53                   	push   %ebx
80103756:	83 ec 0c             	sub    $0xc,%esp
80103759:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010375c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010375f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103765:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010376b:	e8 90 d6 ff ff       	call   80100e00 <filealloc>
80103770:	85 c0                	test   %eax,%eax
80103772:	89 03                	mov    %eax,(%ebx)
80103774:	74 22                	je     80103798 <pipealloc+0x48>
80103776:	e8 85 d6 ff ff       	call   80100e00 <filealloc>
8010377b:	85 c0                	test   %eax,%eax
8010377d:	89 06                	mov    %eax,(%esi)
8010377f:	74 3f                	je     801037c0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103781:	e8 4a f2 ff ff       	call   801029d0 <kalloc>
80103786:	85 c0                	test   %eax,%eax
80103788:	89 c7                	mov    %eax,%edi
8010378a:	75 54                	jne    801037e0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010378c:	8b 03                	mov    (%ebx),%eax
8010378e:	85 c0                	test   %eax,%eax
80103790:	75 34                	jne    801037c6 <pipealloc+0x76>
80103792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103798:	8b 06                	mov    (%esi),%eax
8010379a:	85 c0                	test   %eax,%eax
8010379c:	74 0c                	je     801037aa <pipealloc+0x5a>
    fileclose(*f1);
8010379e:	83 ec 0c             	sub    $0xc,%esp
801037a1:	50                   	push   %eax
801037a2:	e8 19 d7 ff ff       	call   80100ec0 <fileclose>
801037a7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801037aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801037ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801037b2:	5b                   	pop    %ebx
801037b3:	5e                   	pop    %esi
801037b4:	5f                   	pop    %edi
801037b5:	5d                   	pop    %ebp
801037b6:	c3                   	ret    
801037b7:	89 f6                	mov    %esi,%esi
801037b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801037c0:	8b 03                	mov    (%ebx),%eax
801037c2:	85 c0                	test   %eax,%eax
801037c4:	74 e4                	je     801037aa <pipealloc+0x5a>
    fileclose(*f0);
801037c6:	83 ec 0c             	sub    $0xc,%esp
801037c9:	50                   	push   %eax
801037ca:	e8 f1 d6 ff ff       	call   80100ec0 <fileclose>
  if(*f1)
801037cf:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801037d1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801037d4:	85 c0                	test   %eax,%eax
801037d6:	75 c6                	jne    8010379e <pipealloc+0x4e>
801037d8:	eb d0                	jmp    801037aa <pipealloc+0x5a>
801037da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801037e0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801037e3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801037ea:	00 00 00 
  p->writeopen = 1;
801037ed:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801037f4:	00 00 00 
  p->nwrite = 0;
801037f7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801037fe:	00 00 00 
  p->nread = 0;
80103801:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103808:	00 00 00 
  initlock(&p->lock, "pipe");
8010380b:	68 10 84 10 80       	push   $0x80108410
80103810:	50                   	push   %eax
80103811:	e8 aa 14 00 00       	call   80104cc0 <initlock>
  (*f0)->type = FD_PIPE;
80103816:	8b 03                	mov    (%ebx),%eax
  return 0;
80103818:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010381b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103821:	8b 03                	mov    (%ebx),%eax
80103823:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103827:	8b 03                	mov    (%ebx),%eax
80103829:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010382d:	8b 03                	mov    (%ebx),%eax
8010382f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103832:	8b 06                	mov    (%esi),%eax
80103834:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010383a:	8b 06                	mov    (%esi),%eax
8010383c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103840:	8b 06                	mov    (%esi),%eax
80103842:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103846:	8b 06                	mov    (%esi),%eax
80103848:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010384b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010384e:	31 c0                	xor    %eax,%eax
}
80103850:	5b                   	pop    %ebx
80103851:	5e                   	pop    %esi
80103852:	5f                   	pop    %edi
80103853:	5d                   	pop    %ebp
80103854:	c3                   	ret    
80103855:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103860 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	56                   	push   %esi
80103864:	53                   	push   %ebx
80103865:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103868:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010386b:	83 ec 0c             	sub    $0xc,%esp
8010386e:	53                   	push   %ebx
8010386f:	e8 3c 15 00 00       	call   80104db0 <acquire>
  if(writable){
80103874:	83 c4 10             	add    $0x10,%esp
80103877:	85 f6                	test   %esi,%esi
80103879:	74 45                	je     801038c0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010387b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103881:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103884:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010388b:	00 00 00 
    wakeup(&p->nread);
8010388e:	50                   	push   %eax
8010388f:	e8 dc 0c 00 00       	call   80104570 <wakeup>
80103894:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103897:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010389d:	85 d2                	test   %edx,%edx
8010389f:	75 0a                	jne    801038ab <pipeclose+0x4b>
801038a1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801038a7:	85 c0                	test   %eax,%eax
801038a9:	74 35                	je     801038e0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801038ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801038ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038b1:	5b                   	pop    %ebx
801038b2:	5e                   	pop    %esi
801038b3:	5d                   	pop    %ebp
    release(&p->lock);
801038b4:	e9 17 16 00 00       	jmp    80104ed0 <release>
801038b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801038c0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801038c6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801038c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801038d0:	00 00 00 
    wakeup(&p->nwrite);
801038d3:	50                   	push   %eax
801038d4:	e8 97 0c 00 00       	call   80104570 <wakeup>
801038d9:	83 c4 10             	add    $0x10,%esp
801038dc:	eb b9                	jmp    80103897 <pipeclose+0x37>
801038de:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801038e0:	83 ec 0c             	sub    $0xc,%esp
801038e3:	53                   	push   %ebx
801038e4:	e8 e7 15 00 00       	call   80104ed0 <release>
    kfree((char*)p);
801038e9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801038ec:	83 c4 10             	add    $0x10,%esp
}
801038ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038f2:	5b                   	pop    %ebx
801038f3:	5e                   	pop    %esi
801038f4:	5d                   	pop    %ebp
    kfree((char*)p);
801038f5:	e9 26 ef ff ff       	jmp    80102820 <kfree>
801038fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103900 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	57                   	push   %edi
80103904:	56                   	push   %esi
80103905:	53                   	push   %ebx
80103906:	83 ec 28             	sub    $0x28,%esp
80103909:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010390c:	53                   	push   %ebx
8010390d:	e8 9e 14 00 00       	call   80104db0 <acquire>
  for(i = 0; i < n; i++){
80103912:	8b 45 10             	mov    0x10(%ebp),%eax
80103915:	83 c4 10             	add    $0x10,%esp
80103918:	85 c0                	test   %eax,%eax
8010391a:	0f 8e c9 00 00 00    	jle    801039e9 <pipewrite+0xe9>
80103920:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103923:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103929:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010392f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103932:	03 4d 10             	add    0x10(%ebp),%ecx
80103935:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103938:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010393e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103944:	39 d0                	cmp    %edx,%eax
80103946:	75 71                	jne    801039b9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103948:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010394e:	85 c0                	test   %eax,%eax
80103950:	74 4e                	je     801039a0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103952:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103958:	eb 3a                	jmp    80103994 <pipewrite+0x94>
8010395a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103960:	83 ec 0c             	sub    $0xc,%esp
80103963:	57                   	push   %edi
80103964:	e8 07 0c 00 00       	call   80104570 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103969:	5a                   	pop    %edx
8010396a:	59                   	pop    %ecx
8010396b:	53                   	push   %ebx
8010396c:	56                   	push   %esi
8010396d:	e8 3e 0a 00 00       	call   801043b0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103972:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103978:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010397e:	83 c4 10             	add    $0x10,%esp
80103981:	05 00 02 00 00       	add    $0x200,%eax
80103986:	39 c2                	cmp    %eax,%edx
80103988:	75 36                	jne    801039c0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010398a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103990:	85 c0                	test   %eax,%eax
80103992:	74 0c                	je     801039a0 <pipewrite+0xa0>
80103994:	e8 c7 03 00 00       	call   80103d60 <myproc>
80103999:	8b 40 24             	mov    0x24(%eax),%eax
8010399c:	85 c0                	test   %eax,%eax
8010399e:	74 c0                	je     80103960 <pipewrite+0x60>
        release(&p->lock);
801039a0:	83 ec 0c             	sub    $0xc,%esp
801039a3:	53                   	push   %ebx
801039a4:	e8 27 15 00 00       	call   80104ed0 <release>
        return -1;
801039a9:	83 c4 10             	add    $0x10,%esp
801039ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801039b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039b4:	5b                   	pop    %ebx
801039b5:	5e                   	pop    %esi
801039b6:	5f                   	pop    %edi
801039b7:	5d                   	pop    %ebp
801039b8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801039b9:	89 c2                	mov    %eax,%edx
801039bb:	90                   	nop
801039bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801039c0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801039c3:	8d 42 01             	lea    0x1(%edx),%eax
801039c6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801039cc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801039d2:	83 c6 01             	add    $0x1,%esi
801039d5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801039d9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801039dc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801039df:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801039e3:	0f 85 4f ff ff ff    	jne    80103938 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801039e9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801039ef:	83 ec 0c             	sub    $0xc,%esp
801039f2:	50                   	push   %eax
801039f3:	e8 78 0b 00 00       	call   80104570 <wakeup>
  release(&p->lock);
801039f8:	89 1c 24             	mov    %ebx,(%esp)
801039fb:	e8 d0 14 00 00       	call   80104ed0 <release>
  return n;
80103a00:	83 c4 10             	add    $0x10,%esp
80103a03:	8b 45 10             	mov    0x10(%ebp),%eax
80103a06:	eb a9                	jmp    801039b1 <pipewrite+0xb1>
80103a08:	90                   	nop
80103a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a10 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	57                   	push   %edi
80103a14:	56                   	push   %esi
80103a15:	53                   	push   %ebx
80103a16:	83 ec 18             	sub    $0x18,%esp
80103a19:	8b 75 08             	mov    0x8(%ebp),%esi
80103a1c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103a1f:	56                   	push   %esi
80103a20:	e8 8b 13 00 00       	call   80104db0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a25:	83 c4 10             	add    $0x10,%esp
80103a28:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103a2e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103a34:	75 6a                	jne    80103aa0 <piperead+0x90>
80103a36:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
80103a3c:	85 db                	test   %ebx,%ebx
80103a3e:	0f 84 c4 00 00 00    	je     80103b08 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103a44:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103a4a:	eb 2d                	jmp    80103a79 <piperead+0x69>
80103a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a50:	83 ec 08             	sub    $0x8,%esp
80103a53:	56                   	push   %esi
80103a54:	53                   	push   %ebx
80103a55:	e8 56 09 00 00       	call   801043b0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a5a:	83 c4 10             	add    $0x10,%esp
80103a5d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103a63:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103a69:	75 35                	jne    80103aa0 <piperead+0x90>
80103a6b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103a71:	85 d2                	test   %edx,%edx
80103a73:	0f 84 8f 00 00 00    	je     80103b08 <piperead+0xf8>
    if(myproc()->killed){
80103a79:	e8 e2 02 00 00       	call   80103d60 <myproc>
80103a7e:	8b 48 24             	mov    0x24(%eax),%ecx
80103a81:	85 c9                	test   %ecx,%ecx
80103a83:	74 cb                	je     80103a50 <piperead+0x40>
      release(&p->lock);
80103a85:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103a88:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103a8d:	56                   	push   %esi
80103a8e:	e8 3d 14 00 00       	call   80104ed0 <release>
      return -1;
80103a93:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103a96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a99:	89 d8                	mov    %ebx,%eax
80103a9b:	5b                   	pop    %ebx
80103a9c:	5e                   	pop    %esi
80103a9d:	5f                   	pop    %edi
80103a9e:	5d                   	pop    %ebp
80103a9f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103aa0:	8b 45 10             	mov    0x10(%ebp),%eax
80103aa3:	85 c0                	test   %eax,%eax
80103aa5:	7e 61                	jle    80103b08 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103aa7:	31 db                	xor    %ebx,%ebx
80103aa9:	eb 13                	jmp    80103abe <piperead+0xae>
80103aab:	90                   	nop
80103aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ab0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103ab6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103abc:	74 1f                	je     80103add <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103abe:	8d 41 01             	lea    0x1(%ecx),%eax
80103ac1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103ac7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103acd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103ad2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103ad5:	83 c3 01             	add    $0x1,%ebx
80103ad8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103adb:	75 d3                	jne    80103ab0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103add:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103ae3:	83 ec 0c             	sub    $0xc,%esp
80103ae6:	50                   	push   %eax
80103ae7:	e8 84 0a 00 00       	call   80104570 <wakeup>
  release(&p->lock);
80103aec:	89 34 24             	mov    %esi,(%esp)
80103aef:	e8 dc 13 00 00       	call   80104ed0 <release>
  return i;
80103af4:	83 c4 10             	add    $0x10,%esp
}
80103af7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103afa:	89 d8                	mov    %ebx,%eax
80103afc:	5b                   	pop    %ebx
80103afd:	5e                   	pop    %esi
80103afe:	5f                   	pop    %edi
80103aff:	5d                   	pop    %ebp
80103b00:	c3                   	ret    
80103b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b08:	31 db                	xor    %ebx,%ebx
80103b0a:	eb d1                	jmp    80103add <piperead+0xcd>
80103b0c:	66 90                	xchg   %ax,%ax
80103b0e:	66 90                	xchg   %ax,%ax

80103b10 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b14:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
{
80103b19:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103b1c:	68 40 3d 11 80       	push   $0x80113d40
80103b21:	e8 8a 12 00 00       	call   80104db0 <acquire>
80103b26:	83 c4 10             	add    $0x10,%esp
80103b29:	eb 17                	jmp    80103b42 <allocproc+0x32>
80103b2b:	90                   	nop
80103b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b30:	81 c3 9c 03 00 00    	add    $0x39c,%ebx
80103b36:	81 fb 74 24 12 80    	cmp    $0x80122474,%ebx
80103b3c:	0f 83 e6 00 00 00    	jae    80103c28 <allocproc+0x118>
    if(p->state == UNUSED)
80103b42:	8b 43 0c             	mov    0xc(%ebx),%eax
80103b45:	85 c0                	test   %eax,%eax
80103b47:	75 e7                	jne    80103b30 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103b49:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103b4e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103b51:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103b58:	8d 50 01             	lea    0x1(%eax),%edx
80103b5b:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103b5e:	68 40 3d 11 80       	push   $0x80113d40
  p->pid = nextpid++;
80103b63:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103b69:	e8 62 13 00 00       	call   80104ed0 <release>

  p->numOfPhysPages = 0;
80103b6e:	c7 83 80 03 00 00 00 	movl   $0x0,0x380(%ebx)
80103b75:	00 00 00 
  p->numOfTotalPages = 0;
80103b78:	c7 83 94 03 00 00 00 	movl   $0x0,0x394(%ebx)
80103b7f:	00 00 00 

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103b82:	e8 49 ee ff ff       	call   801029d0 <kalloc>
80103b87:	83 c4 10             	add    $0x10,%esp
80103b8a:	85 c0                	test   %eax,%eax
80103b8c:	89 43 08             	mov    %eax,0x8(%ebx)
80103b8f:	0f 84 ac 00 00 00    	je     80103c41 <allocproc+0x131>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103b95:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103b9b:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103b9e:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103ba3:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103ba6:	c7 40 14 af 61 10 80 	movl   $0x801061af,0x14(%eax)
  p->context = (struct context*)sp;
80103bad:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103bb0:	6a 14                	push   $0x14
80103bb2:	6a 00                	push   $0x0
80103bb4:	50                   	push   %eax
80103bb5:	e8 76 13 00 00       	call   80104f30 <memset>
  p->context->eip = (uint)forkret;
80103bba:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103bbd:	8d 8b 00 02 00 00    	lea    0x200(%ebx),%ecx
80103bc3:	83 c4 10             	add    $0x10,%esp
80103bc6:	31 d2                	xor    %edx,%edx
80103bc8:	c7 40 10 50 3c 10 80 	movl   $0x80103c50,0x10(%eax)
80103bcf:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80103bd5:	8d 76 00             	lea    0x0(%esi),%esi
  for(int i=0; i< MAX_PSYC_PAGES; i++){
    //cprintf("proc allocated in array of physpages,cell %d page address: %p \n", i, &p->procSwappedFiles[i]);
    //cprintf("proc allocated in array of swapped files,cell %d page address: %p\n", i, &p->procPhysPages[i]);
    p->procSwappedFiles[i].va = 0;
    p->procSwappedFiles[i].pte = 0;
    p->procSwappedFiles[i].offsetInFile = i*(PGSIZE);
80103bd8:	89 50 08             	mov    %edx,0x8(%eax)
    p->procSwappedFiles[i].va = 0;
80103bdb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103be1:	83 c0 18             	add    $0x18,%eax
    p->procSwappedFiles[i].pte = 0;
80103be4:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
    p->procSwappedFiles[i].isOccupied = 0;
80103beb:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
80103bf2:	81 c2 00 10 00 00    	add    $0x1000,%edx
    p->procPhysPages[i].va = 0;
80103bf8:	c7 80 68 01 00 00 00 	movl   $0x0,0x168(%eax)
80103bff:	00 00 00 
    p->procPhysPages[i].offsetInFile = 0;
80103c02:	c7 80 70 01 00 00 00 	movl   $0x0,0x170(%eax)
80103c09:	00 00 00 
    p->procPhysPages[i].isOccupied = 0;
80103c0c:	c7 80 74 01 00 00 00 	movl   $0x0,0x174(%eax)
80103c13:	00 00 00 
  for(int i=0; i< MAX_PSYC_PAGES; i++){
80103c16:	39 c8                	cmp    %ecx,%eax
80103c18:	75 be                	jne    80103bd8 <allocproc+0xc8>
}
80103c1a:	89 d8                	mov    %ebx,%eax
80103c1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c1f:	c9                   	leave  
80103c20:	c3                   	ret    
80103c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103c28:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103c2b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103c2d:	68 40 3d 11 80       	push   $0x80113d40
80103c32:	e8 99 12 00 00       	call   80104ed0 <release>
}
80103c37:	89 d8                	mov    %ebx,%eax
  return 0;
80103c39:	83 c4 10             	add    $0x10,%esp
}
80103c3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c3f:	c9                   	leave  
80103c40:	c3                   	ret    
    p->state = UNUSED;
80103c41:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103c48:	31 db                	xor    %ebx,%ebx
80103c4a:	eb ce                	jmp    80103c1a <allocproc+0x10a>
80103c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103c50 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103c56:	68 40 3d 11 80       	push   $0x80113d40
80103c5b:	e8 70 12 00 00       	call   80104ed0 <release>

  if (first) {
80103c60:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103c65:	83 c4 10             	add    $0x10,%esp
80103c68:	85 c0                	test   %eax,%eax
80103c6a:	75 04                	jne    80103c70 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103c6c:	c9                   	leave  
80103c6d:	c3                   	ret    
80103c6e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103c70:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103c73:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103c7a:	00 00 00 
    iinit(ROOTDEV);
80103c7d:	6a 01                	push   $0x1
80103c7f:	e8 8c d8 ff ff       	call   80101510 <iinit>
    initlog(ROOTDEV);
80103c84:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103c8b:	e8 80 f3 ff ff       	call   80103010 <initlog>
80103c90:	83 c4 10             	add    $0x10,%esp
}
80103c93:	c9                   	leave  
80103c94:	c3                   	ret    
80103c95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ca0 <pinit>:
{
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103ca6:	68 15 84 10 80       	push   $0x80108415
80103cab:	68 40 3d 11 80       	push   $0x80113d40
80103cb0:	e8 0b 10 00 00       	call   80104cc0 <initlock>
}
80103cb5:	83 c4 10             	add    $0x10,%esp
80103cb8:	c9                   	leave  
80103cb9:	c3                   	ret    
80103cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103cc0 <mycpu>:
{
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	56                   	push   %esi
80103cc4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103cc5:	9c                   	pushf  
80103cc6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103cc7:	f6 c4 02             	test   $0x2,%ah
80103cca:	75 5e                	jne    80103d2a <mycpu+0x6a>
  apicid = lapicid();
80103ccc:	e8 6f ef ff ff       	call   80102c40 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103cd1:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
80103cd7:	85 f6                	test   %esi,%esi
80103cd9:	7e 42                	jle    80103d1d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103cdb:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
80103ce2:	39 d0                	cmp    %edx,%eax
80103ce4:	74 30                	je     80103d16 <mycpu+0x56>
80103ce6:	b9 30 38 11 80       	mov    $0x80113830,%ecx
  for (i = 0; i < ncpu; ++i) {
80103ceb:	31 d2                	xor    %edx,%edx
80103ced:	8d 76 00             	lea    0x0(%esi),%esi
80103cf0:	83 c2 01             	add    $0x1,%edx
80103cf3:	39 f2                	cmp    %esi,%edx
80103cf5:	74 26                	je     80103d1d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103cf7:	0f b6 19             	movzbl (%ecx),%ebx
80103cfa:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103d00:	39 c3                	cmp    %eax,%ebx
80103d02:	75 ec                	jne    80103cf0 <mycpu+0x30>
80103d04:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103d0a:	05 80 37 11 80       	add    $0x80113780,%eax
}
80103d0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d12:	5b                   	pop    %ebx
80103d13:	5e                   	pop    %esi
80103d14:	5d                   	pop    %ebp
80103d15:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103d16:	b8 80 37 11 80       	mov    $0x80113780,%eax
      return &cpus[i];
80103d1b:	eb f2                	jmp    80103d0f <mycpu+0x4f>
  panic("unknown apicid\n");
80103d1d:	83 ec 0c             	sub    $0xc,%esp
80103d20:	68 1c 84 10 80       	push   $0x8010841c
80103d25:	e8 66 c6 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103d2a:	83 ec 0c             	sub    $0xc,%esp
80103d2d:	68 8c 85 10 80       	push   $0x8010858c
80103d32:	e8 59 c6 ff ff       	call   80100390 <panic>
80103d37:	89 f6                	mov    %esi,%esi
80103d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d40 <cpuid>:
cpuid() {
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103d46:	e8 75 ff ff ff       	call   80103cc0 <mycpu>
80103d4b:	2d 80 37 11 80       	sub    $0x80113780,%eax
}
80103d50:	c9                   	leave  
  return mycpu()-cpus;
80103d51:	c1 f8 04             	sar    $0x4,%eax
80103d54:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103d5a:	c3                   	ret    
80103d5b:	90                   	nop
80103d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103d60 <myproc>:
myproc(void) {
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	53                   	push   %ebx
80103d64:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103d67:	e8 04 10 00 00       	call   80104d70 <pushcli>
  c = mycpu();
80103d6c:	e8 4f ff ff ff       	call   80103cc0 <mycpu>
  p = c->proc;
80103d71:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d77:	e8 f4 10 00 00       	call   80104e70 <popcli>
}
80103d7c:	83 c4 04             	add    $0x4,%esp
80103d7f:	89 d8                	mov    %ebx,%eax
80103d81:	5b                   	pop    %ebx
80103d82:	5d                   	pop    %ebp
80103d83:	c3                   	ret    
80103d84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103d90 <initPageMetaData>:
int initPageMetaData(struct proc* p){
80103d90:	55                   	push   %ebp
80103d91:	31 d2                	xor    %edx,%edx
80103d93:	89 e5                	mov    %esp,%ebp
80103d95:	8b 45 08             	mov    0x8(%ebp),%eax
80103d98:	83 e8 80             	sub    $0xffffff80,%eax
80103d9b:	90                   	nop
80103d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->procSwappedFiles[i].offsetInFile = i*(PGSIZE);
80103da0:	89 50 08             	mov    %edx,0x8(%eax)
80103da3:	81 c2 00 10 00 00    	add    $0x1000,%edx
    p->procSwappedFiles[i].va = 0;
80103da9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    p->procSwappedFiles[i].pte = 0;
80103daf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    p->procSwappedFiles[i].isOccupied = 0;
80103db6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
80103dbd:	83 c0 18             	add    $0x18,%eax
    p->procPhysPages[i].va = 0;
80103dc0:	c7 80 68 01 00 00 00 	movl   $0x0,0x168(%eax)
80103dc7:	00 00 00 
    p->procPhysPages[i].offsetInFile = 0;
80103dca:	c7 80 70 01 00 00 00 	movl   $0x0,0x170(%eax)
80103dd1:	00 00 00 
    p->procPhysPages[i].isOccupied = 0;
80103dd4:	c7 80 74 01 00 00 00 	movl   $0x0,0x174(%eax)
80103ddb:	00 00 00 
  for(int i=0; i< MAX_PSYC_PAGES; i++){
80103dde:	81 fa 00 00 01 00    	cmp    $0x10000,%edx
80103de4:	75 ba                	jne    80103da0 <initPageMetaData+0x10>
}
80103de6:	b8 01 00 00 00       	mov    $0x1,%eax
80103deb:	5d                   	pop    %ebp
80103dec:	c3                   	ret    
80103ded:	8d 76 00             	lea    0x0(%esi),%esi

80103df0 <userinit>:
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	53                   	push   %ebx
80103df4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103df7:	e8 14 fd ff ff       	call   80103b10 <allocproc>
80103dfc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103dfe:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103e03:	e8 18 3c 00 00       	call   80107a20 <setupkvm>
80103e08:	85 c0                	test   %eax,%eax
80103e0a:	89 43 04             	mov    %eax,0x4(%ebx)
80103e0d:	0f 84 c7 00 00 00    	je     80103eda <userinit+0xea>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103e13:	83 ec 04             	sub    $0x4,%esp
80103e16:	68 2c 00 00 00       	push   $0x2c
80103e1b:	68 60 b4 10 80       	push   $0x8010b460
80103e20:	50                   	push   %eax
80103e21:	e8 8a 35 00 00       	call   801073b0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103e26:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103e29:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103e2f:	6a 4c                	push   $0x4c
80103e31:	6a 00                	push   $0x0
80103e33:	ff 73 18             	pushl  0x18(%ebx)
80103e36:	e8 f5 10 00 00       	call   80104f30 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103e3b:	8b 43 18             	mov    0x18(%ebx),%eax
80103e3e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103e43:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103e48:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103e4b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103e4f:	8b 43 18             	mov    0x18(%ebx),%eax
80103e52:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103e56:	8b 43 18             	mov    0x18(%ebx),%eax
80103e59:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103e5d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103e61:	8b 43 18             	mov    0x18(%ebx),%eax
80103e64:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103e68:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103e6c:	8b 43 18             	mov    0x18(%ebx),%eax
80103e6f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103e76:	8b 43 18             	mov    0x18(%ebx),%eax
80103e79:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103e80:	8b 43 18             	mov    0x18(%ebx),%eax
80103e83:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103e8a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103e8d:	6a 10                	push   $0x10
80103e8f:	68 45 84 10 80       	push   $0x80108445
80103e94:	50                   	push   %eax
80103e95:	e8 76 12 00 00       	call   80105110 <safestrcpy>
  p->cwd = namei("/");
80103e9a:	c7 04 24 4e 84 10 80 	movl   $0x8010844e,(%esp)
80103ea1:	e8 ca e0 ff ff       	call   80101f70 <namei>
  p->ignorePaging = 1;
80103ea6:	c7 83 98 03 00 00 01 	movl   $0x1,0x398(%ebx)
80103ead:	00 00 00 
  p->cwd = namei("/");
80103eb0:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103eb3:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103eba:	e8 f1 0e 00 00       	call   80104db0 <acquire>
  p->state = RUNNABLE;
80103ebf:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103ec6:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103ecd:	e8 fe 0f 00 00       	call   80104ed0 <release>
}
80103ed2:	83 c4 10             	add    $0x10,%esp
80103ed5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ed8:	c9                   	leave  
80103ed9:	c3                   	ret    
    panic("userinit: out of memory?");
80103eda:	83 ec 0c             	sub    $0xc,%esp
80103edd:	68 2c 84 10 80       	push   $0x8010842c
80103ee2:	e8 a9 c4 ff ff       	call   80100390 <panic>
80103ee7:	89 f6                	mov    %esi,%esi
80103ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ef0 <growproc>:
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	56                   	push   %esi
80103ef4:	53                   	push   %ebx
80103ef5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ef8:	e8 73 0e 00 00       	call   80104d70 <pushcli>
  c = mycpu();
80103efd:	e8 be fd ff ff       	call   80103cc0 <mycpu>
  p = c->proc;
80103f02:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f08:	e8 63 0f 00 00       	call   80104e70 <popcli>
  if(n > 0){
80103f0d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103f10:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103f12:	7f 1c                	jg     80103f30 <growproc+0x40>
  } else if(n < 0){
80103f14:	75 3a                	jne    80103f50 <growproc+0x60>
  switchuvm(curproc);
80103f16:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103f19:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103f1b:	53                   	push   %ebx
80103f1c:	e8 7f 33 00 00       	call   801072a0 <switchuvm>
  return 0;
80103f21:	83 c4 10             	add    $0x10,%esp
80103f24:	31 c0                	xor    %eax,%eax
}
80103f26:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f29:	5b                   	pop    %ebx
80103f2a:	5e                   	pop    %esi
80103f2b:	5d                   	pop    %ebp
80103f2c:	c3                   	ret    
80103f2d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103f30:	83 ec 04             	sub    $0x4,%esp
80103f33:	01 c6                	add    %eax,%esi
80103f35:	56                   	push   %esi
80103f36:	50                   	push   %eax
80103f37:	ff 73 04             	pushl  0x4(%ebx)
80103f3a:	e8 71 38 00 00       	call   801077b0 <allocuvm>
80103f3f:	83 c4 10             	add    $0x10,%esp
80103f42:	85 c0                	test   %eax,%eax
80103f44:	75 d0                	jne    80103f16 <growproc+0x26>
      return -1;
80103f46:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f4b:	eb d9                	jmp    80103f26 <growproc+0x36>
80103f4d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103f50:	83 ec 04             	sub    $0x4,%esp
80103f53:	01 c6                	add    %eax,%esi
80103f55:	56                   	push   %esi
80103f56:	50                   	push   %eax
80103f57:	ff 73 04             	pushl  0x4(%ebx)
80103f5a:	e8 51 37 00 00       	call   801076b0 <deallocuvm>
80103f5f:	83 c4 10             	add    $0x10,%esp
80103f62:	85 c0                	test   %eax,%eax
80103f64:	75 b0                	jne    80103f16 <growproc+0x26>
80103f66:	eb de                	jmp    80103f46 <growproc+0x56>
80103f68:	90                   	nop
80103f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f70 <fork>:
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	57                   	push   %edi
80103f74:	56                   	push   %esi
80103f75:	53                   	push   %ebx
80103f76:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103f79:	e8 f2 0d 00 00       	call   80104d70 <pushcli>
  c = mycpu();
80103f7e:	e8 3d fd ff ff       	call   80103cc0 <mycpu>
  p = c->proc;
80103f83:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f89:	e8 e2 0e 00 00       	call   80104e70 <popcli>
  if((np = allocproc()) == 0){
80103f8e:	e8 7d fb ff ff       	call   80103b10 <allocproc>
80103f93:	85 c0                	test   %eax,%eax
80103f95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103f98:	0f 84 ea 00 00 00    	je     80104088 <fork+0x118>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103f9e:	83 ec 08             	sub    $0x8,%esp
80103fa1:	ff 33                	pushl  (%ebx)
80103fa3:	ff 73 04             	pushl  0x4(%ebx)
80103fa6:	89 c7                	mov    %eax,%edi
80103fa8:	e8 43 3b 00 00       	call   80107af0 <copyuvm>
80103fad:	83 c4 10             	add    $0x10,%esp
80103fb0:	85 c0                	test   %eax,%eax
80103fb2:	89 47 04             	mov    %eax,0x4(%edi)
80103fb5:	0f 84 d4 00 00 00    	je     8010408f <fork+0x11f>
  np->sz = curproc->sz;
80103fbb:	8b 03                	mov    (%ebx),%eax
80103fbd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  *np->tf = *curproc->tf;
80103fc0:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103fc5:	89 02                	mov    %eax,(%edx)
  np->parent = curproc;
80103fc7:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103fca:	8b 7a 18             	mov    0x18(%edx),%edi
80103fcd:	8b 73 18             	mov    0x18(%ebx),%esi
80103fd0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103fd2:	31 f6                	xor    %esi,%esi
  np->ignorePaging = curproc->ignorePaging;
80103fd4:	8b 83 98 03 00 00    	mov    0x398(%ebx),%eax
80103fda:	89 82 98 03 00 00    	mov    %eax,0x398(%edx)
  np->tf->eax = 0;
80103fe0:	8b 42 18             	mov    0x18(%edx),%eax
80103fe3:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[i])
80103ff0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ff4:	85 c0                	test   %eax,%eax
80103ff6:	74 13                	je     8010400b <fork+0x9b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103ff8:	83 ec 0c             	sub    $0xc,%esp
80103ffb:	50                   	push   %eax
80103ffc:	e8 6f ce ff ff       	call   80100e70 <filedup>
80104001:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104004:	83 c4 10             	add    $0x10,%esp
80104007:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010400b:	83 c6 01             	add    $0x1,%esi
8010400e:	83 fe 10             	cmp    $0x10,%esi
80104011:	75 dd                	jne    80103ff0 <fork+0x80>
  np->cwd = idup(curproc->cwd);
80104013:	83 ec 0c             	sub    $0xc,%esp
80104016:	ff 73 68             	pushl  0x68(%ebx)
80104019:	e8 c2 d6 ff ff       	call   801016e0 <idup>
8010401e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104021:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104024:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104027:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010402a:	6a 10                	push   $0x10
8010402c:	50                   	push   %eax
8010402d:	8d 47 6c             	lea    0x6c(%edi),%eax
80104030:	50                   	push   %eax
80104031:	e8 da 10 00 00       	call   80105110 <safestrcpy>
  if(curproc->swapFile){
80104036:	8b 4b 7c             	mov    0x7c(%ebx),%ecx
80104039:	83 c4 10             	add    $0x10,%esp
  pid = np->pid;
8010403c:	8b 77 10             	mov    0x10(%edi),%esi
  if(curproc->swapFile){
8010403f:	85 c9                	test   %ecx,%ecx
80104041:	74 15                	je     80104058 <fork+0xe8>
    createSwapFile(np);
80104043:	83 ec 0c             	sub    $0xc,%esp
80104046:	57                   	push   %edi
80104047:	e8 f4 e1 ff ff       	call   80102240 <createSwapFile>
    copySwapFile(np,curproc);
8010404c:	58                   	pop    %eax
8010404d:	5a                   	pop    %edx
8010404e:	53                   	push   %ebx
8010404f:	57                   	push   %edi
80104050:	e8 eb e2 ff ff       	call   80102340 <copySwapFile>
80104055:	83 c4 10             	add    $0x10,%esp
  acquire(&ptable.lock);
80104058:	83 ec 0c             	sub    $0xc,%esp
8010405b:	68 40 3d 11 80       	push   $0x80113d40
80104060:	e8 4b 0d 00 00       	call   80104db0 <acquire>
  np->state = RUNNABLE;
80104065:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104068:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
8010406f:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80104076:	e8 55 0e 00 00       	call   80104ed0 <release>
  return pid;
8010407b:	83 c4 10             	add    $0x10,%esp
}
8010407e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104081:	89 f0                	mov    %esi,%eax
80104083:	5b                   	pop    %ebx
80104084:	5e                   	pop    %esi
80104085:	5f                   	pop    %edi
80104086:	5d                   	pop    %ebp
80104087:	c3                   	ret    
    return -1;
80104088:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010408d:	eb ef                	jmp    8010407e <fork+0x10e>
    kfree(np->kstack);
8010408f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80104092:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80104095:	be ff ff ff ff       	mov    $0xffffffff,%esi
    kfree(np->kstack);
8010409a:	ff 77 08             	pushl  0x8(%edi)
8010409d:	e8 7e e7 ff ff       	call   80102820 <kfree>
    np->kstack = 0;
801040a2:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
801040a9:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
801040b0:	83 c4 10             	add    $0x10,%esp
801040b3:	eb c9                	jmp    8010407e <fork+0x10e>
801040b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040c0 <scheduler>:
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	57                   	push   %edi
801040c4:	56                   	push   %esi
801040c5:	53                   	push   %ebx
801040c6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801040c9:	e8 f2 fb ff ff       	call   80103cc0 <mycpu>
801040ce:	8d 78 04             	lea    0x4(%eax),%edi
801040d1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801040d3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801040da:	00 00 00 
801040dd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801040e0:	fb                   	sti    
    acquire(&ptable.lock);
801040e1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040e4:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
    acquire(&ptable.lock);
801040e9:	68 40 3d 11 80       	push   $0x80113d40
801040ee:	e8 bd 0c 00 00       	call   80104db0 <acquire>
801040f3:	83 c4 10             	add    $0x10,%esp
801040f6:	8d 76 00             	lea    0x0(%esi),%esi
801040f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80104100:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104104:	75 33                	jne    80104139 <scheduler+0x79>
      switchuvm(p);
80104106:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104109:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010410f:	53                   	push   %ebx
80104110:	e8 8b 31 00 00       	call   801072a0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104115:	58                   	pop    %eax
80104116:	5a                   	pop    %edx
80104117:	ff 73 1c             	pushl  0x1c(%ebx)
8010411a:	57                   	push   %edi
      p->state = RUNNING;
8010411b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104122:	e8 44 10 00 00       	call   8010516b <swtch>
      switchkvm();
80104127:	e8 54 31 00 00       	call   80107280 <switchkvm>
      c->proc = 0;
8010412c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104133:	00 00 00 
80104136:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104139:	81 c3 9c 03 00 00    	add    $0x39c,%ebx
8010413f:	81 fb 74 24 12 80    	cmp    $0x80122474,%ebx
80104145:	72 b9                	jb     80104100 <scheduler+0x40>
    release(&ptable.lock);
80104147:	83 ec 0c             	sub    $0xc,%esp
8010414a:	68 40 3d 11 80       	push   $0x80113d40
8010414f:	e8 7c 0d 00 00       	call   80104ed0 <release>
    sti();
80104154:	83 c4 10             	add    $0x10,%esp
80104157:	eb 87                	jmp    801040e0 <scheduler+0x20>
80104159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104160 <sched>:
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	56                   	push   %esi
80104164:	53                   	push   %ebx
  pushcli();
80104165:	e8 06 0c 00 00       	call   80104d70 <pushcli>
  c = mycpu();
8010416a:	e8 51 fb ff ff       	call   80103cc0 <mycpu>
  p = c->proc;
8010416f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104175:	e8 f6 0c 00 00       	call   80104e70 <popcli>
  if(!holding(&ptable.lock))
8010417a:	83 ec 0c             	sub    $0xc,%esp
8010417d:	68 40 3d 11 80       	push   $0x80113d40
80104182:	e8 a9 0b 00 00       	call   80104d30 <holding>
80104187:	83 c4 10             	add    $0x10,%esp
8010418a:	85 c0                	test   %eax,%eax
8010418c:	74 4f                	je     801041dd <sched+0x7d>
  if(mycpu()->ncli != 1)
8010418e:	e8 2d fb ff ff       	call   80103cc0 <mycpu>
80104193:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010419a:	75 68                	jne    80104204 <sched+0xa4>
  if(p->state == RUNNING)
8010419c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801041a0:	74 55                	je     801041f7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041a2:	9c                   	pushf  
801041a3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801041a4:	f6 c4 02             	test   $0x2,%ah
801041a7:	75 41                	jne    801041ea <sched+0x8a>
  intena = mycpu()->intena;
801041a9:	e8 12 fb ff ff       	call   80103cc0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801041ae:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801041b1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801041b7:	e8 04 fb ff ff       	call   80103cc0 <mycpu>
801041bc:	83 ec 08             	sub    $0x8,%esp
801041bf:	ff 70 04             	pushl  0x4(%eax)
801041c2:	53                   	push   %ebx
801041c3:	e8 a3 0f 00 00       	call   8010516b <swtch>
  mycpu()->intena = intena;
801041c8:	e8 f3 fa ff ff       	call   80103cc0 <mycpu>
}
801041cd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801041d0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801041d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041d9:	5b                   	pop    %ebx
801041da:	5e                   	pop    %esi
801041db:	5d                   	pop    %ebp
801041dc:	c3                   	ret    
    panic("sched ptable.lock");
801041dd:	83 ec 0c             	sub    $0xc,%esp
801041e0:	68 50 84 10 80       	push   $0x80108450
801041e5:	e8 a6 c1 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801041ea:	83 ec 0c             	sub    $0xc,%esp
801041ed:	68 7c 84 10 80       	push   $0x8010847c
801041f2:	e8 99 c1 ff ff       	call   80100390 <panic>
    panic("sched running");
801041f7:	83 ec 0c             	sub    $0xc,%esp
801041fa:	68 6e 84 10 80       	push   $0x8010846e
801041ff:	e8 8c c1 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104204:	83 ec 0c             	sub    $0xc,%esp
80104207:	68 62 84 10 80       	push   $0x80108462
8010420c:	e8 7f c1 ff ff       	call   80100390 <panic>
80104211:	eb 0d                	jmp    80104220 <exit>
80104213:	90                   	nop
80104214:	90                   	nop
80104215:	90                   	nop
80104216:	90                   	nop
80104217:	90                   	nop
80104218:	90                   	nop
80104219:	90                   	nop
8010421a:	90                   	nop
8010421b:	90                   	nop
8010421c:	90                   	nop
8010421d:	90                   	nop
8010421e:	90                   	nop
8010421f:	90                   	nop

80104220 <exit>:
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	57                   	push   %edi
80104224:	56                   	push   %esi
80104225:	53                   	push   %ebx
80104226:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104229:	e8 42 0b 00 00       	call   80104d70 <pushcli>
  c = mycpu();
8010422e:	e8 8d fa ff ff       	call   80103cc0 <mycpu>
  p = c->proc;
80104233:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104239:	e8 32 0c 00 00       	call   80104e70 <popcli>
  if(curproc == initproc)
8010423e:	39 1d b8 b5 10 80    	cmp    %ebx,0x8010b5b8
80104244:	8d 73 28             	lea    0x28(%ebx),%esi
80104247:	8d 7b 68             	lea    0x68(%ebx),%edi
8010424a:	0f 84 01 01 00 00    	je     80104351 <exit+0x131>
    if(curproc->ofile[fd]){
80104250:	8b 06                	mov    (%esi),%eax
80104252:	85 c0                	test   %eax,%eax
80104254:	74 12                	je     80104268 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104256:	83 ec 0c             	sub    $0xc,%esp
80104259:	50                   	push   %eax
8010425a:	e8 61 cc ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
8010425f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104265:	83 c4 10             	add    $0x10,%esp
80104268:	83 c6 04             	add    $0x4,%esi
  for(fd = 0; fd < NOFILE; fd++){
8010426b:	39 fe                	cmp    %edi,%esi
8010426d:	75 e1                	jne    80104250 <exit+0x30>
  begin_op();
8010426f:	e8 3c ee ff ff       	call   801030b0 <begin_op>
  iput(curproc->cwd);
80104274:	83 ec 0c             	sub    $0xc,%esp
80104277:	ff 73 68             	pushl  0x68(%ebx)
8010427a:	e8 c1 d5 ff ff       	call   80101840 <iput>
  end_op();
8010427f:	e8 9c ee ff ff       	call   80103120 <end_op>
  curproc->cwd = 0;
80104284:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  removeSwapFile(curproc);
8010428b:	89 1c 24             	mov    %ebx,(%esp)
8010428e:	e8 ad dd ff ff       	call   80102040 <removeSwapFile>
  acquire(&ptable.lock);
80104293:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
8010429a:	e8 11 0b 00 00       	call   80104db0 <acquire>
  wakeup1(curproc->parent);
8010429f:	8b 53 14             	mov    0x14(%ebx),%edx
801042a2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042a5:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
801042aa:	eb 10                	jmp    801042bc <exit+0x9c>
801042ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042b0:	05 9c 03 00 00       	add    $0x39c,%eax
801042b5:	3d 74 24 12 80       	cmp    $0x80122474,%eax
801042ba:	73 1e                	jae    801042da <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
801042bc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801042c0:	75 ee                	jne    801042b0 <exit+0x90>
801042c2:	3b 50 20             	cmp    0x20(%eax),%edx
801042c5:	75 e9                	jne    801042b0 <exit+0x90>
      p->state = RUNNABLE;
801042c7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042ce:	05 9c 03 00 00       	add    $0x39c,%eax
801042d3:	3d 74 24 12 80       	cmp    $0x80122474,%eax
801042d8:	72 e2                	jb     801042bc <exit+0x9c>
      p->parent = initproc;
801042da:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042e0:	ba 74 3d 11 80       	mov    $0x80113d74,%edx
801042e5:	eb 17                	jmp    801042fe <exit+0xde>
801042e7:	89 f6                	mov    %esi,%esi
801042e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801042f0:	81 c2 9c 03 00 00    	add    $0x39c,%edx
801042f6:	81 fa 74 24 12 80    	cmp    $0x80122474,%edx
801042fc:	73 3a                	jae    80104338 <exit+0x118>
    if(p->parent == curproc){
801042fe:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104301:	75 ed                	jne    801042f0 <exit+0xd0>
      if(p->state == ZOMBIE)
80104303:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104307:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010430a:	75 e4                	jne    801042f0 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010430c:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
80104311:	eb 11                	jmp    80104324 <exit+0x104>
80104313:	90                   	nop
80104314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104318:	05 9c 03 00 00       	add    $0x39c,%eax
8010431d:	3d 74 24 12 80       	cmp    $0x80122474,%eax
80104322:	73 cc                	jae    801042f0 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80104324:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104328:	75 ee                	jne    80104318 <exit+0xf8>
8010432a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010432d:	75 e9                	jne    80104318 <exit+0xf8>
      p->state = RUNNABLE;
8010432f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104336:	eb e0                	jmp    80104318 <exit+0xf8>
  curproc->state = ZOMBIE;
80104338:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
8010433f:	e8 1c fe ff ff       	call   80104160 <sched>
  panic("zombie exit");
80104344:	83 ec 0c             	sub    $0xc,%esp
80104347:	68 9d 84 10 80       	push   $0x8010849d
8010434c:	e8 3f c0 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104351:	83 ec 0c             	sub    $0xc,%esp
80104354:	68 90 84 10 80       	push   $0x80108490
80104359:	e8 32 c0 ff ff       	call   80100390 <panic>
8010435e:	66 90                	xchg   %ax,%ax

80104360 <yield>:
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	53                   	push   %ebx
80104364:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104367:	68 40 3d 11 80       	push   $0x80113d40
8010436c:	e8 3f 0a 00 00       	call   80104db0 <acquire>
  pushcli();
80104371:	e8 fa 09 00 00       	call   80104d70 <pushcli>
  c = mycpu();
80104376:	e8 45 f9 ff ff       	call   80103cc0 <mycpu>
  p = c->proc;
8010437b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104381:	e8 ea 0a 00 00       	call   80104e70 <popcli>
  myproc()->state = RUNNABLE;
80104386:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010438d:	e8 ce fd ff ff       	call   80104160 <sched>
  release(&ptable.lock);
80104392:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80104399:	e8 32 0b 00 00       	call   80104ed0 <release>
}
8010439e:	83 c4 10             	add    $0x10,%esp
801043a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043a4:	c9                   	leave  
801043a5:	c3                   	ret    
801043a6:	8d 76 00             	lea    0x0(%esi),%esi
801043a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043b0 <sleep>:
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	57                   	push   %edi
801043b4:	56                   	push   %esi
801043b5:	53                   	push   %ebx
801043b6:	83 ec 0c             	sub    $0xc,%esp
801043b9:	8b 7d 08             	mov    0x8(%ebp),%edi
801043bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801043bf:	e8 ac 09 00 00       	call   80104d70 <pushcli>
  c = mycpu();
801043c4:	e8 f7 f8 ff ff       	call   80103cc0 <mycpu>
  p = c->proc;
801043c9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043cf:	e8 9c 0a 00 00       	call   80104e70 <popcli>
  if(p == 0)
801043d4:	85 db                	test   %ebx,%ebx
801043d6:	0f 84 87 00 00 00    	je     80104463 <sleep+0xb3>
  if(lk == 0)
801043dc:	85 f6                	test   %esi,%esi
801043de:	74 76                	je     80104456 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801043e0:	81 fe 40 3d 11 80    	cmp    $0x80113d40,%esi
801043e6:	74 50                	je     80104438 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801043e8:	83 ec 0c             	sub    $0xc,%esp
801043eb:	68 40 3d 11 80       	push   $0x80113d40
801043f0:	e8 bb 09 00 00       	call   80104db0 <acquire>
    release(lk);
801043f5:	89 34 24             	mov    %esi,(%esp)
801043f8:	e8 d3 0a 00 00       	call   80104ed0 <release>
  p->chan = chan;
801043fd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104400:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104407:	e8 54 fd ff ff       	call   80104160 <sched>
  p->chan = 0;
8010440c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104413:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
8010441a:	e8 b1 0a 00 00       	call   80104ed0 <release>
    acquire(lk);
8010441f:	89 75 08             	mov    %esi,0x8(%ebp)
80104422:	83 c4 10             	add    $0x10,%esp
}
80104425:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104428:	5b                   	pop    %ebx
80104429:	5e                   	pop    %esi
8010442a:	5f                   	pop    %edi
8010442b:	5d                   	pop    %ebp
    acquire(lk);
8010442c:	e9 7f 09 00 00       	jmp    80104db0 <acquire>
80104431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104438:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010443b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104442:	e8 19 fd ff ff       	call   80104160 <sched>
  p->chan = 0;
80104447:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010444e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104451:	5b                   	pop    %ebx
80104452:	5e                   	pop    %esi
80104453:	5f                   	pop    %edi
80104454:	5d                   	pop    %ebp
80104455:	c3                   	ret    
    panic("sleep without lk");
80104456:	83 ec 0c             	sub    $0xc,%esp
80104459:	68 af 84 10 80       	push   $0x801084af
8010445e:	e8 2d bf ff ff       	call   80100390 <panic>
    panic("sleep");
80104463:	83 ec 0c             	sub    $0xc,%esp
80104466:	68 a9 84 10 80       	push   $0x801084a9
8010446b:	e8 20 bf ff ff       	call   80100390 <panic>

80104470 <wait>:
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	56                   	push   %esi
80104474:	53                   	push   %ebx
  pushcli();
80104475:	e8 f6 08 00 00       	call   80104d70 <pushcli>
  c = mycpu();
8010447a:	e8 41 f8 ff ff       	call   80103cc0 <mycpu>
  p = c->proc;
8010447f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104485:	e8 e6 09 00 00       	call   80104e70 <popcli>
  acquire(&ptable.lock);
8010448a:	83 ec 0c             	sub    $0xc,%esp
8010448d:	68 40 3d 11 80       	push   $0x80113d40
80104492:	e8 19 09 00 00       	call   80104db0 <acquire>
80104497:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010449a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010449c:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
801044a1:	eb 13                	jmp    801044b6 <wait+0x46>
801044a3:	90                   	nop
801044a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044a8:	81 c3 9c 03 00 00    	add    $0x39c,%ebx
801044ae:	81 fb 74 24 12 80    	cmp    $0x80122474,%ebx
801044b4:	73 1e                	jae    801044d4 <wait+0x64>
      if(p->parent != curproc)
801044b6:	39 73 14             	cmp    %esi,0x14(%ebx)
801044b9:	75 ed                	jne    801044a8 <wait+0x38>
      if(p->state == ZOMBIE){
801044bb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801044bf:	74 37                	je     801044f8 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044c1:	81 c3 9c 03 00 00    	add    $0x39c,%ebx
      havekids = 1;
801044c7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044cc:	81 fb 74 24 12 80    	cmp    $0x80122474,%ebx
801044d2:	72 e2                	jb     801044b6 <wait+0x46>
    if(!havekids || curproc->killed){
801044d4:	85 c0                	test   %eax,%eax
801044d6:	74 76                	je     8010454e <wait+0xde>
801044d8:	8b 46 24             	mov    0x24(%esi),%eax
801044db:	85 c0                	test   %eax,%eax
801044dd:	75 6f                	jne    8010454e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801044df:	83 ec 08             	sub    $0x8,%esp
801044e2:	68 40 3d 11 80       	push   $0x80113d40
801044e7:	56                   	push   %esi
801044e8:	e8 c3 fe ff ff       	call   801043b0 <sleep>
    havekids = 0;
801044ed:	83 c4 10             	add    $0x10,%esp
801044f0:	eb a8                	jmp    8010449a <wait+0x2a>
801044f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801044f8:	83 ec 0c             	sub    $0xc,%esp
801044fb:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801044fe:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104501:	e8 1a e3 ff ff       	call   80102820 <kfree>
        freevm(p->pgdir);
80104506:	5a                   	pop    %edx
80104507:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010450a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104511:	e8 8a 34 00 00       	call   801079a0 <freevm>
        release(&ptable.lock);
80104516:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
        p->pid = 0;
8010451d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104524:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010452b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010452f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104536:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010453d:	e8 8e 09 00 00       	call   80104ed0 <release>
        return pid;
80104542:	83 c4 10             	add    $0x10,%esp
}
80104545:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104548:	89 f0                	mov    %esi,%eax
8010454a:	5b                   	pop    %ebx
8010454b:	5e                   	pop    %esi
8010454c:	5d                   	pop    %ebp
8010454d:	c3                   	ret    
      release(&ptable.lock);
8010454e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104551:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104556:	68 40 3d 11 80       	push   $0x80113d40
8010455b:	e8 70 09 00 00       	call   80104ed0 <release>
      return -1;
80104560:	83 c4 10             	add    $0x10,%esp
80104563:	eb e0                	jmp    80104545 <wait+0xd5>
80104565:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104570 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	53                   	push   %ebx
80104574:	83 ec 10             	sub    $0x10,%esp
80104577:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010457a:	68 40 3d 11 80       	push   $0x80113d40
8010457f:	e8 2c 08 00 00       	call   80104db0 <acquire>
80104584:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104587:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
8010458c:	eb 0e                	jmp    8010459c <wakeup+0x2c>
8010458e:	66 90                	xchg   %ax,%ax
80104590:	05 9c 03 00 00       	add    $0x39c,%eax
80104595:	3d 74 24 12 80       	cmp    $0x80122474,%eax
8010459a:	73 1e                	jae    801045ba <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010459c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801045a0:	75 ee                	jne    80104590 <wakeup+0x20>
801045a2:	3b 58 20             	cmp    0x20(%eax),%ebx
801045a5:	75 e9                	jne    80104590 <wakeup+0x20>
      p->state = RUNNABLE;
801045a7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045ae:	05 9c 03 00 00       	add    $0x39c,%eax
801045b3:	3d 74 24 12 80       	cmp    $0x80122474,%eax
801045b8:	72 e2                	jb     8010459c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
801045ba:	c7 45 08 40 3d 11 80 	movl   $0x80113d40,0x8(%ebp)
}
801045c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045c4:	c9                   	leave  
  release(&ptable.lock);
801045c5:	e9 06 09 00 00       	jmp    80104ed0 <release>
801045ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045d0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	53                   	push   %ebx
801045d4:	83 ec 10             	sub    $0x10,%esp
801045d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801045da:	68 40 3d 11 80       	push   $0x80113d40
801045df:	e8 cc 07 00 00       	call   80104db0 <acquire>
801045e4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045e7:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
801045ec:	eb 0e                	jmp    801045fc <kill+0x2c>
801045ee:	66 90                	xchg   %ax,%ax
801045f0:	05 9c 03 00 00       	add    $0x39c,%eax
801045f5:	3d 74 24 12 80       	cmp    $0x80122474,%eax
801045fa:	73 34                	jae    80104630 <kill+0x60>
    if(p->pid == pid){
801045fc:	39 58 10             	cmp    %ebx,0x10(%eax)
801045ff:	75 ef                	jne    801045f0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104601:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104605:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010460c:	75 07                	jne    80104615 <kill+0x45>
        p->state = RUNNABLE;
8010460e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104615:	83 ec 0c             	sub    $0xc,%esp
80104618:	68 40 3d 11 80       	push   $0x80113d40
8010461d:	e8 ae 08 00 00       	call   80104ed0 <release>
      return 0;
80104622:	83 c4 10             	add    $0x10,%esp
80104625:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104627:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010462a:	c9                   	leave  
8010462b:	c3                   	ret    
8010462c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104630:	83 ec 0c             	sub    $0xc,%esp
80104633:	68 40 3d 11 80       	push   $0x80113d40
80104638:	e8 93 08 00 00       	call   80104ed0 <release>
  return -1;
8010463d:	83 c4 10             	add    $0x10,%esp
80104640:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104645:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104648:	c9                   	leave  
80104649:	c3                   	ret    
8010464a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104650 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	57                   	push   %edi
80104654:	56                   	push   %esi
80104655:	53                   	push   %ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104656:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
{
8010465b:	83 ec 3c             	sub    $0x3c,%esp
8010465e:	eb 43                	jmp    801046a3 <procdump+0x53>
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    int curFreePages = MAX_TOTAL_PAGES - allocatedMemoryPages;
80104660:	b8 20 00 00 00       	mov    $0x20,%eax
    cprintf("%d\n", curFreePages/MAX_TOTAL_PAGES);
80104665:	83 ec 08             	sub    $0x8,%esp
    int curFreePages = MAX_TOTAL_PAGES - allocatedMemoryPages;
80104668:	29 f0                	sub    %esi,%eax
8010466a:	89 c2                	mov    %eax,%edx
    cprintf("%d\n", curFreePages/MAX_TOTAL_PAGES);
8010466c:	8d 40 1f             	lea    0x1f(%eax),%eax
8010466f:	85 d2                	test   %edx,%edx
80104671:	0f 49 c2             	cmovns %edx,%eax
80104674:	c1 f8 05             	sar    $0x5,%eax
80104677:	50                   	push   %eax
80104678:	68 04 85 10 80       	push   $0x80108504
8010467d:	e8 de bf ff ff       	call   80100660 <cprintf>
    cprintf("\n");
80104682:	c7 04 24 43 85 10 80 	movl   $0x80108543,(%esp)
80104689:	e8 d2 bf ff ff       	call   80100660 <cprintf>
8010468e:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104691:	81 c3 9c 03 00 00    	add    $0x39c,%ebx
80104697:	81 fb 74 24 12 80    	cmp    $0x80122474,%ebx
8010469d:	0f 83 cd 00 00 00    	jae    80104770 <procdump+0x120>
    if(p->state == UNUSED)
801046a3:	8b 43 0c             	mov    0xc(%ebx),%eax
801046a6:	85 c0                	test   %eax,%eax
801046a8:	74 e7                	je     80104691 <procdump+0x41>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801046aa:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801046ad:	bf c0 84 10 80       	mov    $0x801084c0,%edi
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801046b2:	77 11                	ja     801046c5 <procdump+0x75>
801046b4:	8b 3c 85 d4 85 10 80 	mov    -0x7fef7a2c(,%eax,4),%edi
      state = "???";
801046bb:	b8 c0 84 10 80       	mov    $0x801084c0,%eax
801046c0:	85 ff                	test   %edi,%edi
801046c2:	0f 44 f8             	cmove  %eax,%edi
    int allocatedMemoryPages= p->numOfPhysPages + p->numOfDiskPages;
801046c5:	8b 83 80 03 00 00    	mov    0x380(%ebx),%eax
801046cb:	8b 93 84 03 00 00    	mov    0x384(%ebx),%edx
    cprintf("%d %d\n", p->numOfPhysPages, p->numOfDiskPages);
801046d1:	83 ec 04             	sub    $0x4,%esp
801046d4:	52                   	push   %edx
801046d5:	50                   	push   %eax
    int allocatedMemoryPages= p->numOfPhysPages + p->numOfDiskPages;
801046d6:	8d 34 10             	lea    (%eax,%edx,1),%esi
    cprintf("%d %d\n", p->numOfPhysPages, p->numOfDiskPages);
801046d9:	68 c4 84 10 80       	push   $0x801084c4
801046de:	e8 7d bf ff ff       	call   80100660 <cprintf>
    cprintf("%d %s %d %d %d %d %d %s", p->pid, state, allocatedMemoryPages, p->numOfDiskPages,p->numOfProtectedPages,p->numOfPageFaults, p->totalNumOfPagedOut ,p->name);
801046e3:	8d 43 6c             	lea    0x6c(%ebx),%eax
801046e6:	89 04 24             	mov    %eax,(%esp)
801046e9:	ff b3 90 03 00 00    	pushl  0x390(%ebx)
801046ef:	ff b3 8c 03 00 00    	pushl  0x38c(%ebx)
801046f5:	ff b3 88 03 00 00    	pushl  0x388(%ebx)
801046fb:	ff b3 84 03 00 00    	pushl  0x384(%ebx)
80104701:	56                   	push   %esi
80104702:	57                   	push   %edi
80104703:	ff 73 10             	pushl  0x10(%ebx)
80104706:	68 cb 84 10 80       	push   $0x801084cb
8010470b:	e8 50 bf ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104710:	83 c4 30             	add    $0x30,%esp
80104713:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104717:	0f 85 43 ff ff ff    	jne    80104660 <procdump+0x10>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010471d:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104720:	83 ec 08             	sub    $0x8,%esp
80104723:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104726:	50                   	push   %eax
80104727:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010472a:	8b 40 0c             	mov    0xc(%eax),%eax
8010472d:	83 c0 08             	add    $0x8,%eax
80104730:	50                   	push   %eax
80104731:	e8 aa 05 00 00       	call   80104ce0 <getcallerpcs>
80104736:	83 c4 10             	add    $0x10,%esp
80104739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104740:	8b 07                	mov    (%edi),%eax
80104742:	85 c0                	test   %eax,%eax
80104744:	0f 84 16 ff ff ff    	je     80104660 <procdump+0x10>
        cprintf(" %p", pc[i]);
8010474a:	83 ec 08             	sub    $0x8,%esp
8010474d:	83 c7 04             	add    $0x4,%edi
80104750:	50                   	push   %eax
80104751:	68 c1 7e 10 80       	push   $0x80107ec1
80104756:	e8 05 bf ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010475b:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010475e:	83 c4 10             	add    $0x10,%esp
80104761:	39 f8                	cmp    %edi,%eax
80104763:	75 db                	jne    80104740 <procdump+0xf0>
80104765:	e9 f6 fe ff ff       	jmp    80104660 <procdump+0x10>
8010476a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
}
80104770:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104773:	5b                   	pop    %ebx
80104774:	5e                   	pop    %esi
80104775:	5f                   	pop    %edi
80104776:	5d                   	pop    %ebp
80104777:	c3                   	ret    
80104778:	90                   	nop
80104779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104780 <printFlags>:

void printFlags(pte_t *pgtab){
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	83 ec 10             	sub    $0x10,%esp
  cprintf("PTE_P = %x\n", (*pgtab & PTE_P)&0x1);
80104786:	8b 45 08             	mov    0x8(%ebp),%eax
80104789:	8b 00                	mov    (%eax),%eax
8010478b:	83 e0 01             	and    $0x1,%eax
8010478e:	50                   	push   %eax
8010478f:	68 e3 84 10 80       	push   $0x801084e3
80104794:	e8 c7 be ff ff       	call   80100660 <cprintf>
	cprintf("PTE_W = %d\n", (*pgtab & PTE_W)&0x1);
80104799:	58                   	pop    %eax
8010479a:	5a                   	pop    %edx
8010479b:	6a 00                	push   $0x0
8010479d:	68 ef 84 10 80       	push   $0x801084ef
801047a2:	e8 b9 be ff ff       	call   80100660 <cprintf>
	cprintf("PTE_PG = %d\n", (*pgtab & PTE_PG)&0x1);
801047a7:	59                   	pop    %ecx
801047a8:	58                   	pop    %eax
801047a9:	6a 00                	push   $0x0
801047ab:	68 fb 84 10 80       	push   $0x801084fb
801047b0:	e8 ab be ff ff       	call   80100660 <cprintf>
}
801047b5:	83 c4 10             	add    $0x10,%esp
801047b8:	c9                   	leave  
801047b9:	c3                   	ret    
801047ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047c0 <protectPage>:
int protectPage(void* va){
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	56                   	push   %esi
801047c4:	53                   	push   %ebx
  pushcli();
801047c5:	e8 a6 05 00 00       	call   80104d70 <pushcli>
  c = mycpu();
801047ca:	e8 f1 f4 ff ff       	call   80103cc0 <mycpu>
  p = c->proc;
801047cf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801047d5:	e8 96 06 00 00       	call   80104e70 <popcli>
  pde = &pgdir[PDX(va)];
801047da:	8b 45 08             	mov    0x8(%ebp),%eax
  if(*pde & PTE_P){
801047dd:	8b 53 04             	mov    0x4(%ebx),%edx
  pde = &pgdir[PDX(va)];
801047e0:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801047e3:	8b 1c 82             	mov    (%edx,%eax,4),%ebx
801047e6:	f6 c3 01             	test   $0x1,%bl
801047e9:	74 65                	je     80104850 <protectPage+0x90>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801047eb:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  printFlags(pgtab);
801047f1:	83 ec 0c             	sub    $0xc,%esp
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801047f4:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  printFlags(pgtab);
801047fa:	56                   	push   %esi
801047fb:	e8 80 ff ff ff       	call   80104780 <printFlags>
  if(*pgtab & PTE_W){ // this page is writable
80104800:	8b 83 00 00 00 80    	mov    -0x80000000(%ebx),%eax
80104806:	83 c4 10             	add    $0x10,%esp
80104809:	a8 02                	test   $0x2,%al
8010480b:	75 1b                	jne    80104828 <protectPage+0x68>
  printFlags(pgtab);
8010480d:	83 ec 0c             	sub    $0xc,%esp
80104810:	56                   	push   %esi
80104811:	e8 6a ff ff ff       	call   80104780 <printFlags>
  return 1;
80104816:	83 c4 10             	add    $0x10,%esp
80104819:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010481e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104821:	5b                   	pop    %ebx
80104822:	5e                   	pop    %esi
80104823:	5d                   	pop    %ebp
80104824:	c3                   	ret    
80104825:	8d 76 00             	lea    0x0(%esi),%esi
    (*pgtab) &= ~PTE_W;
80104828:	83 e0 fd             	and    $0xfffffffd,%eax
8010482b:	89 83 00 00 00 80    	mov    %eax,-0x80000000(%ebx)
  pushcli();
80104831:	e8 3a 05 00 00       	call   80104d70 <pushcli>
  c = mycpu();
80104836:	e8 85 f4 ff ff       	call   80103cc0 <mycpu>
  p = c->proc;
8010483b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104841:	e8 2a 06 00 00       	call   80104e70 <popcli>
    myproc()->numOfProtectedPages++;
80104846:	83 83 88 03 00 00 01 	addl   $0x1,0x388(%ebx)
8010484d:	eb be                	jmp    8010480d <protectPage+0x4d>
8010484f:	90                   	nop
    return -1;
80104850:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104855:	eb c7                	jmp    8010481e <protectPage+0x5e>
80104857:	89 f6                	mov    %esi,%esi
80104859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104860 <choosePageToSwapOut>:

struct page_meta_data *head;
struct page_meta_data *tail;

// choose which page to swap-out, update (add it to this array) the procSwappedFiles data structure and flush the TLB
void* choosePageToSwapOut(){
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	56                   	push   %esi
80104864:	53                   	push   %ebx
  head = chosen->next;  
  cprintf("head %p chosen %p \n", chosen, head );
#endif
#ifdef SCFIFO
  struct page_meta_data *last;
  for(int i=0; i < myproc()->numOfPhysPages; i++){
80104865:	31 db                	xor    %ebx,%ebx
  cprintf("choose page method\n");
80104867:	83 ec 0c             	sub    $0xc,%esp
8010486a:	68 08 85 10 80       	push   $0x80108508
8010486f:	e8 ec bd ff ff       	call   80100660 <cprintf>
  for(int i=0; i < myproc()->numOfPhysPages; i++){
80104874:	83 c4 10             	add    $0x10,%esp
80104877:	89 f6                	mov    %esi,%esi
80104879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  pushcli();
80104880:	e8 eb 04 00 00       	call   80104d70 <pushcli>
  c = mycpu();
80104885:	e8 36 f4 ff ff       	call   80103cc0 <mycpu>
  p = c->proc;
8010488a:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104890:	e8 db 05 00 00       	call   80104e70 <popcli>
  for(int i=0; i < myproc()->numOfPhysPages; i++){
80104895:	39 9e 80 03 00 00    	cmp    %ebx,0x380(%esi)
8010489b:	7e 73                	jle    80104910 <choosePageToSwapOut+0xb0>
    last = tail; //removeTail();
8010489d:	8b 0d 20 3d 11 80    	mov    0x80113d20,%ecx
  return chosen->pte; //chosen->pmd->pte;
}

// Delets tha last element (tail) from the list, and the prev node becomes the tail
struct page_meta_data* removeTail(){
  struct page_meta_data* tempNode = head;
801048a3:	8b 15 24 3d 11 80    	mov    0x80113d24,%edx
801048a9:	eb 07                	jmp    801048b2 <choosePageToSwapOut+0x52>
801048ab:	90                   	nop
801048ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct page_meta_data* curTail = tail;
  while (tempNode->next != curTail){
801048b0:	89 c2                	mov    %eax,%edx
801048b2:	8b 42 14             	mov    0x14(%edx),%eax
801048b5:	39 c1                	cmp    %eax,%ecx
801048b7:	75 f7                	jne    801048b0 <choosePageToSwapOut+0x50>
    tempNode = tempNode->next;
  }
  tempNode->next = 0; 
801048b9:	c7 42 14 00 00 00 00 	movl   $0x0,0x14(%edx)
    uint* pgtab = last->pte;//last->pmd->pte;
801048c0:	8b 41 04             	mov    0x4(%ecx),%eax
  tail = tempNode;
801048c3:	89 15 20 3d 11 80    	mov    %edx,0x80113d20
    if(*pgtab & PTE_A){ // page was accessed
801048c9:	8b 10                	mov    (%eax),%edx
801048cb:	f6 c2 20             	test   $0x20,%dl
801048ce:	74 38                	je     80104908 <choosePageToSwapOut+0xa8>
      (*pgtab) &= ~PTE_A; // clear bit and add to the list
801048d0:	83 e2 df             	and    $0xffffffdf,%edx
801048d3:	89 10                	mov    %edx,(%eax)
}

// Insert page to linked list in the first place
void insertNode(struct page_meta_data* pmd){
  //cprintf("insert node func\n");
  if(!head){ // empty list
801048d5:	a1 24 3d 11 80       	mov    0x80113d24,%eax
801048da:	85 c0                	test   %eax,%eax
801048dc:	74 12                	je     801048f0 <choosePageToSwapOut+0x90>
    tail = pmd;
    pmd->next = 0;
    //cprintf("first node");
  }else{ // insert node to the head of the list
    //cprintf("list of proc is NOT empty\n", myproc()->pid);
    pmd->next = head;
801048de:	89 41 14             	mov    %eax,0x14(%ecx)
    head = pmd;
801048e1:	89 0d 24 3d 11 80    	mov    %ecx,0x80113d24
  for(int i=0; i < myproc()->numOfPhysPages; i++){
801048e7:	83 c3 01             	add    $0x1,%ebx
801048ea:	eb 94                	jmp    80104880 <choosePageToSwapOut+0x20>
801048ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    head = pmd;
801048f0:	89 0d 24 3d 11 80    	mov    %ecx,0x80113d24
    tail = pmd;
801048f6:	89 0d 20 3d 11 80    	mov    %ecx,0x80113d20
    pmd->next = 0;
801048fc:	c7 41 14 00 00 00 00 	movl   $0x0,0x14(%ecx)
80104903:	eb e2                	jmp    801048e7 <choosePageToSwapOut+0x87>
80104905:	8d 76 00             	lea    0x0(%esi),%esi
}
80104908:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010490b:	5b                   	pop    %ebx
8010490c:	5e                   	pop    %esi
8010490d:	5d                   	pop    %ebp
8010490e:	c3                   	ret    
8010490f:	90                   	nop
  return chosen->pte; //chosen->pmd->pte;
80104910:	a1 04 00 00 00       	mov    0x4,%eax
80104915:	0f 0b                	ud2    
80104917:	89 f6                	mov    %esi,%esi
80104919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104920 <removeTail>:
struct page_meta_data* removeTail(){
80104920:	55                   	push   %ebp
  struct page_meta_data* tempNode = head;
80104921:	a1 24 3d 11 80       	mov    0x80113d24,%eax
  struct page_meta_data* curTail = tail;
80104926:	8b 0d 20 3d 11 80    	mov    0x80113d20,%ecx
struct page_meta_data* removeTail(){
8010492c:	89 e5                	mov    %esp,%ebp
  while (tempNode->next != curTail){
8010492e:	eb 02                	jmp    80104932 <removeTail+0x12>
80104930:	89 d0                	mov    %edx,%eax
80104932:	8b 50 14             	mov    0x14(%eax),%edx
80104935:	39 ca                	cmp    %ecx,%edx
80104937:	75 f7                	jne    80104930 <removeTail+0x10>
  tempNode->next = 0; 
80104939:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  tail = tempNode;
80104940:	a3 20 3d 11 80       	mov    %eax,0x80113d20
}
80104945:	5d                   	pop    %ebp
80104946:	c3                   	ret    
80104947:	89 f6                	mov    %esi,%esi
80104949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104950 <swapOut>:
int swapOut(){
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	57                   	push   %edi
80104954:	56                   	push   %esi
80104955:	53                   	push   %ebx
80104956:	83 ec 28             	sub    $0x28,%esp
  cprintf("swap out method\n");
80104959:	68 1c 85 10 80       	push   $0x8010851c
8010495e:	e8 fd bc ff ff       	call   80100660 <cprintf>
  pushcli();
80104963:	e8 08 04 00 00       	call   80104d70 <pushcli>
  c = mycpu();
80104968:	e8 53 f3 ff ff       	call   80103cc0 <mycpu>
  p = c->proc;
8010496d:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
80104973:	e8 f8 04 00 00       	call   80104e70 <popcli>
  uint* pte = choosePageToSwapOut();
80104978:	e8 e3 fe ff ff       	call   80104860 <choosePageToSwapOut>
8010497d:	8d 8f 04 02 00 00    	lea    0x204(%edi),%ecx
80104983:	89 c3                	mov    %eax,%ebx
80104985:	83 c4 10             	add    $0x10,%esp
  for (int i=0; i<MAX_PSYC_PAGES; i++){ 
80104988:	31 c0                	xor    %eax,%eax
8010498a:	eb 0f                	jmp    8010499b <swapOut+0x4b>
8010498c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104990:	83 c0 01             	add    $0x1,%eax
80104993:	83 c1 18             	add    $0x18,%ecx
80104996:	83 f8 10             	cmp    $0x10,%eax
80104999:	74 12                	je     801049ad <swapOut+0x5d>
    if (curProc->procPhysPages[i].pte == pte){
8010499b:	39 19                	cmp    %ebx,(%ecx)
8010499d:	75 f1                	jne    80104990 <swapOut+0x40>
      curProc->procPhysPages[i].isOccupied = 0;
8010499f:	8d 04 40             	lea    (%eax,%eax,2),%eax
801049a2:	c7 84 c7 0c 02 00 00 	movl   $0x0,0x20c(%edi,%eax,8)
801049a9:	00 00 00 00 
  cprintf("pte of chosen page %d \n", pte);
801049ad:	83 ec 08             	sub    $0x8,%esp
801049b0:	53                   	push   %ebx
801049b1:	68 2d 85 10 80       	push   $0x8010852d
801049b6:	e8 a5 bc ff ff       	call   80100660 <cprintf>
  char* pa = (char*)(PTE_ADDR(*pte));
801049bb:	8b 33                	mov    (%ebx),%esi
801049bd:	8d 8f 8c 00 00 00    	lea    0x8c(%edi),%ecx
801049c3:	83 c4 10             	add    $0x10,%esp
  for (int i=0; i<MAX_PSYC_PAGES; i++){ // find cell that isn't occupied in the array
801049c6:	31 c0                	xor    %eax,%eax
  char* pa = (char*)(PTE_ADDR(*pte));
801049c8:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  char* va = (char*)(P2V((uint)(pa)));
801049ce:	81 c6 00 00 00 80    	add    $0x80000000,%esi
801049d4:	eb 19                	jmp    801049ef <swapOut+0x9f>
801049d6:	8d 76 00             	lea    0x0(%esi),%esi
801049d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for (int i=0; i<MAX_PSYC_PAGES; i++){ // find cell that isn't occupied in the array
801049e0:	83 c0 01             	add    $0x1,%eax
801049e3:	83 c1 18             	add    $0x18,%ecx
801049e6:	83 f8 10             	cmp    $0x10,%eax
801049e9:	0f 84 91 00 00 00    	je     80104a80 <swapOut+0x130>
    if (curProc->procSwappedFiles[i].isOccupied == 0){
801049ef:	8b 11                	mov    (%ecx),%edx
801049f1:	85 d2                	test   %edx,%edx
801049f3:	75 eb                	jne    801049e0 <swapOut+0x90>
      curProc->procSwappedFiles[i].isOccupied = 1;
801049f5:	8d 04 40             	lea    (%eax,%eax,2),%eax
801049f8:	8d 04 c7             	lea    (%edi,%eax,8),%eax
801049fb:	c7 80 8c 00 00 00 01 	movl   $0x1,0x8c(%eax)
80104a02:	00 00 00 
      curProc->procSwappedFiles[i].pte = pte;
80104a05:	89 98 84 00 00 00    	mov    %ebx,0x84(%eax)
      offset = curProc->procSwappedFiles[i].offsetInFile;
80104a0b:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
  if (offset == -1)
80104a11:	83 f8 ff             	cmp    $0xffffffff,%eax
      offset = curProc->procSwappedFiles[i].offsetInFile;
80104a14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (offset == -1)
80104a17:	74 67                	je     80104a80 <swapOut+0x130>
  cprintf("before write\n");
80104a19:	83 ec 0c             	sub    $0xc,%esp
80104a1c:	68 45 85 10 80       	push   $0x80108545
80104a21:	e8 3a bc ff ff       	call   80100660 <cprintf>
  offset = writeToSwapFile(curProc, (char*)va, offset, PGSIZE);
80104a26:	68 00 10 00 00       	push   $0x1000
80104a2b:	ff 75 e4             	pushl  -0x1c(%ebp)
80104a2e:	56                   	push   %esi
80104a2f:	57                   	push   %edi
  kfree((char*)V2P(va)); // Free the page of physical memory pointed at by the virtualAdd
80104a30:	81 c6 00 00 00 80    	add    $0x80000000,%esi
  offset = writeToSwapFile(curProc, (char*)va, offset, PGSIZE);
80104a36:	e8 a5 d8 ff ff       	call   801022e0 <writeToSwapFile>
  cprintf("after write\n");
80104a3b:	83 c4 14             	add    $0x14,%esp
  offset = writeToSwapFile(curProc, (char*)va, offset, PGSIZE);
80104a3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  cprintf("after write\n");
80104a41:	68 53 85 10 80       	push   $0x80108553
80104a46:	e8 15 bc ff ff       	call   80100660 <cprintf>
  (*pte) &= ~PTE_P;
80104a4b:	8b 0b                	mov    (%ebx),%ecx
80104a4d:	83 e1 fe             	and    $0xfffffffe,%ecx
  (*pte) |= PTE_PG;
80104a50:	80 cd 02             	or     $0x2,%ch
80104a53:	89 0b                	mov    %ecx,(%ebx)
  kfree((char*)V2P(va)); // Free the page of physical memory pointed at by the virtualAdd
80104a55:	89 34 24             	mov    %esi,(%esp)
80104a58:	e8 c3 dd ff ff       	call   80102820 <kfree>
  curProc->numOfPhysPages--;
80104a5d:	83 af 80 03 00 00 01 	subl   $0x1,0x380(%edi)
  curProc->numOfDiskPages++;
80104a64:	83 87 84 03 00 00 01 	addl   $0x1,0x384(%edi)
  return offset;
80104a6b:	83 c4 10             	add    $0x10,%esp
80104a6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  curProc->totalNumOfPagedOut++;
80104a71:	83 87 90 03 00 00 01 	addl   $0x1,0x390(%edi)
}
80104a78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a7b:	5b                   	pop    %ebx
80104a7c:	5e                   	pop    %esi
80104a7d:	5f                   	pop    %edi
80104a7e:	5d                   	pop    %ebp
80104a7f:	c3                   	ret    
80104a80:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80104a83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a88:	5b                   	pop    %ebx
80104a89:	5e                   	pop    %esi
80104a8a:	5f                   	pop    %edi
80104a8b:	5d                   	pop    %ebp
80104a8c:	c3                   	ret    
80104a8d:	8d 76 00             	lea    0x0(%esi),%esi

80104a90 <swap>:
int swap(uint *pte, uint faultAdd){
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	53                   	push   %ebx
80104a94:	83 ec 04             	sub    $0x4,%esp
  if (swapOut() < 0) panic("problem with swapping out file");
80104a97:	e8 b4 fe ff ff       	call   80104950 <swapOut>
80104a9c:	85 c0                	test   %eax,%eax
80104a9e:	78 38                	js     80104ad8 <swap+0x48>
  pushcli();
80104aa0:	e8 cb 02 00 00       	call   80104d70 <pushcli>
  c = mycpu();
80104aa5:	e8 16 f2 ff ff       	call   80103cc0 <mycpu>
  p = c->proc;
80104aaa:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104ab0:	e8 bb 03 00 00       	call   80104e70 <popcli>
  lcr3(V2P(myproc()->pgdir)); // Refresh TLB after page-out
80104ab5:	8b 43 04             	mov    0x4(%ebx),%eax
80104ab8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80104abd:	0f 22 d8             	mov    %eax,%cr3
  swapIn(pte, faultAdd);
80104ac0:	83 ec 08             	sub    $0x8,%esp
80104ac3:	ff 75 0c             	pushl  0xc(%ebp)
80104ac6:	ff 75 08             	pushl  0x8(%ebp)
80104ac9:	e8 e2 31 00 00       	call   80107cb0 <swapIn>
}
80104ace:	b8 01 00 00 00       	mov    $0x1,%eax
80104ad3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ad6:	c9                   	leave  
80104ad7:	c3                   	ret    
  if (swapOut() < 0) panic("problem with swapping out file");
80104ad8:	83 ec 0c             	sub    $0xc,%esp
80104adb:	68 b4 85 10 80       	push   $0x801085b4
80104ae0:	e8 ab b8 ff ff       	call   80100390 <panic>
80104ae5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104af0 <insertNode>:
  if(!head){ // empty list
80104af0:	8b 15 24 3d 11 80    	mov    0x80113d24,%edx
void insertNode(struct page_meta_data* pmd){
80104af6:	55                   	push   %ebp
80104af7:	89 e5                	mov    %esp,%ebp
  if(!head){ // empty list
80104af9:	85 d2                	test   %edx,%edx
void insertNode(struct page_meta_data* pmd){
80104afb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!head){ // empty list
80104afe:	74 10                	je     80104b10 <insertNode+0x20>
    pmd->next = head;
80104b00:	89 50 14             	mov    %edx,0x14(%eax)
    head = pmd;
80104b03:	a3 24 3d 11 80       	mov    %eax,0x80113d24
    //   cprintf("address of node is %p", tempNodeForTestsing);
    //   tempNodeForTestsing = tempNodeForTestsing->next;
    // }
    
  }
}
80104b08:	5d                   	pop    %ebp
80104b09:	c3                   	ret    
80104b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pmd->next = 0;
80104b10:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    head = pmd;
80104b17:	a3 24 3d 11 80       	mov    %eax,0x80113d24
    tail = pmd;
80104b1c:	a3 20 3d 11 80       	mov    %eax,0x80113d20
}
80104b21:	5d                   	pop    %ebp
80104b22:	c3                   	ret    
80104b23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b30 <removeNode>:

int removeNode(struct page_meta_data* pmd){
  if(!head){ return -1; } // list is empty
80104b30:	8b 15 24 3d 11 80    	mov    0x80113d24,%edx
int removeNode(struct page_meta_data* pmd){
80104b36:	55                   	push   %ebp
80104b37:	89 e5                	mov    %esp,%ebp
80104b39:	53                   	push   %ebx
  if(!head){ return -1; } // list is empty
80104b3a:	85 d2                	test   %edx,%edx
int removeNode(struct page_meta_data* pmd){
80104b3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!head){ return -1; } // list is empty
80104b3f:	74 63                	je     80104ba4 <removeNode+0x74>
  struct page_meta_data *prev = head;
  if(!prev->next){
80104b41:	8b 4a 14             	mov    0x14(%edx),%ecx
80104b44:	85 c9                	test   %ecx,%ecx
80104b46:	74 28                	je     80104b70 <removeNode+0x40>
      return 0;
    }
  }
  struct page_meta_data *temp = head->next;
  while(temp){
    if(temp == pmd){ // found the link holding pmd
80104b48:	39 d9                	cmp    %ebx,%ecx
80104b4a:	8b 41 14             	mov    0x14(%ecx),%eax
80104b4d:	74 51                	je     80104ba0 <removeNode+0x70>
  while(temp){
80104b4f:	85 c0                	test   %eax,%eax
80104b51:	75 07                	jne    80104b5a <removeNode+0x2a>
80104b53:	eb 14                	jmp    80104b69 <removeNode+0x39>
80104b55:	8d 76 00             	lea    0x0(%esi),%esi
80104b58:	89 d0                	mov    %edx,%eax
    if(temp == pmd){ // found the link holding pmd
80104b5a:	39 d8                	cmp    %ebx,%eax
80104b5c:	74 32                	je     80104b90 <removeNode+0x60>
      prev->next = temp->next;
      return 0;
    }
    prev = temp;
    temp = temp->next;
80104b5e:	8b 50 14             	mov    0x14(%eax),%edx
80104b61:	89 c1                	mov    %eax,%ecx
  while(temp){
80104b63:	85 d2                	test   %edx,%edx
80104b65:	75 f1                	jne    80104b58 <removeNode+0x28>
      return 0;
80104b67:	31 c0                	xor    %eax,%eax
  }
  return 0;
80104b69:	5b                   	pop    %ebx
80104b6a:	5d                   	pop    %ebp
80104b6b:	c3                   	ret    
80104b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return 0;
80104b70:	31 c0                	xor    %eax,%eax
    if(prev == pmd){
80104b72:	39 da                	cmp    %ebx,%edx
80104b74:	75 f3                	jne    80104b69 <removeNode+0x39>
      head = 0;
80104b76:	c7 05 24 3d 11 80 00 	movl   $0x0,0x80113d24
80104b7d:	00 00 00 
      return 1;
80104b80:	b8 01 00 00 00       	mov    $0x1,%eax
80104b85:	eb e2                	jmp    80104b69 <removeNode+0x39>
80104b87:	89 f6                	mov    %esi,%esi
80104b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104b90:	8b 40 14             	mov    0x14(%eax),%eax
      prev->next = temp->next;
80104b93:	89 41 14             	mov    %eax,0x14(%ecx)
      return 0;
80104b96:	31 c0                	xor    %eax,%eax
80104b98:	5b                   	pop    %ebx
80104b99:	5d                   	pop    %ebp
80104b9a:	c3                   	ret    
80104b9b:	90                   	nop
80104b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(temp == pmd){ // found the link holding pmd
80104ba0:	89 d1                	mov    %edx,%ecx
80104ba2:	eb ef                	jmp    80104b93 <removeNode+0x63>
  if(!head){ return -1; } // list is empty
80104ba4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ba9:	eb be                	jmp    80104b69 <removeNode+0x39>
80104bab:	66 90                	xchg   %ax,%ax
80104bad:	66 90                	xchg   %ax,%ax
80104baf:	90                   	nop

80104bb0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	53                   	push   %ebx
80104bb4:	83 ec 0c             	sub    $0xc,%esp
80104bb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104bba:	68 ec 85 10 80       	push   $0x801085ec
80104bbf:	8d 43 04             	lea    0x4(%ebx),%eax
80104bc2:	50                   	push   %eax
80104bc3:	e8 f8 00 00 00       	call   80104cc0 <initlock>
  lk->name = name;
80104bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104bcb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104bd1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104bd4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104bdb:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104bde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104be1:	c9                   	leave  
80104be2:	c3                   	ret    
80104be3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bf0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	56                   	push   %esi
80104bf4:	53                   	push   %ebx
80104bf5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104bf8:	83 ec 0c             	sub    $0xc,%esp
80104bfb:	8d 73 04             	lea    0x4(%ebx),%esi
80104bfe:	56                   	push   %esi
80104bff:	e8 ac 01 00 00       	call   80104db0 <acquire>
  while (lk->locked) {
80104c04:	8b 13                	mov    (%ebx),%edx
80104c06:	83 c4 10             	add    $0x10,%esp
80104c09:	85 d2                	test   %edx,%edx
80104c0b:	74 16                	je     80104c23 <acquiresleep+0x33>
80104c0d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104c10:	83 ec 08             	sub    $0x8,%esp
80104c13:	56                   	push   %esi
80104c14:	53                   	push   %ebx
80104c15:	e8 96 f7 ff ff       	call   801043b0 <sleep>
  while (lk->locked) {
80104c1a:	8b 03                	mov    (%ebx),%eax
80104c1c:	83 c4 10             	add    $0x10,%esp
80104c1f:	85 c0                	test   %eax,%eax
80104c21:	75 ed                	jne    80104c10 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104c23:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104c29:	e8 32 f1 ff ff       	call   80103d60 <myproc>
80104c2e:	8b 40 10             	mov    0x10(%eax),%eax
80104c31:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104c34:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104c37:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c3a:	5b                   	pop    %ebx
80104c3b:	5e                   	pop    %esi
80104c3c:	5d                   	pop    %ebp
  release(&lk->lk);
80104c3d:	e9 8e 02 00 00       	jmp    80104ed0 <release>
80104c42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c50 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	56                   	push   %esi
80104c54:	53                   	push   %ebx
80104c55:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104c58:	83 ec 0c             	sub    $0xc,%esp
80104c5b:	8d 73 04             	lea    0x4(%ebx),%esi
80104c5e:	56                   	push   %esi
80104c5f:	e8 4c 01 00 00       	call   80104db0 <acquire>
  lk->locked = 0;
80104c64:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104c6a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104c71:	89 1c 24             	mov    %ebx,(%esp)
80104c74:	e8 f7 f8 ff ff       	call   80104570 <wakeup>
  release(&lk->lk);
80104c79:	89 75 08             	mov    %esi,0x8(%ebp)
80104c7c:	83 c4 10             	add    $0x10,%esp
}
80104c7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c82:	5b                   	pop    %ebx
80104c83:	5e                   	pop    %esi
80104c84:	5d                   	pop    %ebp
  release(&lk->lk);
80104c85:	e9 46 02 00 00       	jmp    80104ed0 <release>
80104c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c90 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	56                   	push   %esi
80104c94:	53                   	push   %ebx
80104c95:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104c98:	83 ec 0c             	sub    $0xc,%esp
80104c9b:	8d 5e 04             	lea    0x4(%esi),%ebx
80104c9e:	53                   	push   %ebx
80104c9f:	e8 0c 01 00 00       	call   80104db0 <acquire>
  r = lk->locked;
80104ca4:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104ca6:	89 1c 24             	mov    %ebx,(%esp)
80104ca9:	e8 22 02 00 00       	call   80104ed0 <release>
  return r;
}
80104cae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cb1:	89 f0                	mov    %esi,%eax
80104cb3:	5b                   	pop    %ebx
80104cb4:	5e                   	pop    %esi
80104cb5:	5d                   	pop    %ebp
80104cb6:	c3                   	ret    
80104cb7:	66 90                	xchg   %ax,%ax
80104cb9:	66 90                	xchg   %ax,%ax
80104cbb:	66 90                	xchg   %ax,%ax
80104cbd:	66 90                	xchg   %ax,%ax
80104cbf:	90                   	nop

80104cc0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104cc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104cc9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104ccf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104cd2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104cd9:	5d                   	pop    %ebp
80104cda:	c3                   	ret    
80104cdb:	90                   	nop
80104cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ce0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104ce0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104ce1:	31 d2                	xor    %edx,%edx
{
80104ce3:	89 e5                	mov    %esp,%ebp
80104ce5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104ce6:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104ce9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104cec:	83 e8 08             	sub    $0x8,%eax
80104cef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104cf0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104cf6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104cfc:	77 1a                	ja     80104d18 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104cfe:	8b 58 04             	mov    0x4(%eax),%ebx
80104d01:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104d04:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104d07:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104d09:	83 fa 0a             	cmp    $0xa,%edx
80104d0c:	75 e2                	jne    80104cf0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104d0e:	5b                   	pop    %ebx
80104d0f:	5d                   	pop    %ebp
80104d10:	c3                   	ret    
80104d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d18:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104d1b:	83 c1 28             	add    $0x28,%ecx
80104d1e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104d20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104d26:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104d29:	39 c1                	cmp    %eax,%ecx
80104d2b:	75 f3                	jne    80104d20 <getcallerpcs+0x40>
}
80104d2d:	5b                   	pop    %ebx
80104d2e:	5d                   	pop    %ebp
80104d2f:	c3                   	ret    

80104d30 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	53                   	push   %ebx
80104d34:	83 ec 04             	sub    $0x4,%esp
80104d37:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
80104d3a:	8b 02                	mov    (%edx),%eax
80104d3c:	85 c0                	test   %eax,%eax
80104d3e:	75 10                	jne    80104d50 <holding+0x20>
}
80104d40:	83 c4 04             	add    $0x4,%esp
80104d43:	31 c0                	xor    %eax,%eax
80104d45:	5b                   	pop    %ebx
80104d46:	5d                   	pop    %ebp
80104d47:	c3                   	ret    
80104d48:	90                   	nop
80104d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104d50:	8b 5a 08             	mov    0x8(%edx),%ebx
80104d53:	e8 68 ef ff ff       	call   80103cc0 <mycpu>
80104d58:	39 c3                	cmp    %eax,%ebx
80104d5a:	0f 94 c0             	sete   %al
}
80104d5d:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104d60:	0f b6 c0             	movzbl %al,%eax
}
80104d63:	5b                   	pop    %ebx
80104d64:	5d                   	pop    %ebp
80104d65:	c3                   	ret    
80104d66:	8d 76 00             	lea    0x0(%esi),%esi
80104d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d70 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	53                   	push   %ebx
80104d74:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104d77:	9c                   	pushf  
80104d78:	5b                   	pop    %ebx
  asm volatile("cli");
80104d79:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104d7a:	e8 41 ef ff ff       	call   80103cc0 <mycpu>
80104d7f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104d85:	85 c0                	test   %eax,%eax
80104d87:	75 11                	jne    80104d9a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104d89:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104d8f:	e8 2c ef ff ff       	call   80103cc0 <mycpu>
80104d94:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104d9a:	e8 21 ef ff ff       	call   80103cc0 <mycpu>
80104d9f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104da6:	83 c4 04             	add    $0x4,%esp
80104da9:	5b                   	pop    %ebx
80104daa:	5d                   	pop    %ebp
80104dab:	c3                   	ret    
80104dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104db0 <acquire>:
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	56                   	push   %esi
80104db4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104db5:	e8 b6 ff ff ff       	call   80104d70 <pushcli>
  if(holding(lk))
80104dba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104dbd:	8b 03                	mov    (%ebx),%eax
80104dbf:	85 c0                	test   %eax,%eax
80104dc1:	0f 85 81 00 00 00    	jne    80104e48 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
80104dc7:	ba 01 00 00 00       	mov    $0x1,%edx
80104dcc:	eb 05                	jmp    80104dd3 <acquire+0x23>
80104dce:	66 90                	xchg   %ax,%ax
80104dd0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104dd3:	89 d0                	mov    %edx,%eax
80104dd5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104dd8:	85 c0                	test   %eax,%eax
80104dda:	75 f4                	jne    80104dd0 <acquire+0x20>
  __sync_synchronize();
80104ddc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104de1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104de4:	e8 d7 ee ff ff       	call   80103cc0 <mycpu>
  for(i = 0; i < 10; i++){
80104de9:	31 d2                	xor    %edx,%edx
  getcallerpcs(&lk, lk->pcs);
80104deb:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  lk->cpu = mycpu();
80104dee:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104df1:	89 e8                	mov    %ebp,%eax
80104df3:	90                   	nop
80104df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104df8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104dfe:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104e04:	77 1a                	ja     80104e20 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
80104e06:	8b 58 04             	mov    0x4(%eax),%ebx
80104e09:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104e0c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104e0f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104e11:	83 fa 0a             	cmp    $0xa,%edx
80104e14:	75 e2                	jne    80104df8 <acquire+0x48>
}
80104e16:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e19:	5b                   	pop    %ebx
80104e1a:	5e                   	pop    %esi
80104e1b:	5d                   	pop    %ebp
80104e1c:	c3                   	ret    
80104e1d:	8d 76 00             	lea    0x0(%esi),%esi
80104e20:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104e23:	83 c1 28             	add    $0x28,%ecx
80104e26:	8d 76 00             	lea    0x0(%esi),%esi
80104e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104e30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104e36:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104e39:	39 c8                	cmp    %ecx,%eax
80104e3b:	75 f3                	jne    80104e30 <acquire+0x80>
}
80104e3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e40:	5b                   	pop    %ebx
80104e41:	5e                   	pop    %esi
80104e42:	5d                   	pop    %ebp
80104e43:	c3                   	ret    
80104e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104e48:	8b 73 08             	mov    0x8(%ebx),%esi
80104e4b:	e8 70 ee ff ff       	call   80103cc0 <mycpu>
80104e50:	39 c6                	cmp    %eax,%esi
80104e52:	0f 85 6f ff ff ff    	jne    80104dc7 <acquire+0x17>
    panic("acquire");
80104e58:	83 ec 0c             	sub    $0xc,%esp
80104e5b:	68 f7 85 10 80       	push   $0x801085f7
80104e60:	e8 2b b5 ff ff       	call   80100390 <panic>
80104e65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e70 <popcli>:

void
popcli(void)
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104e76:	9c                   	pushf  
80104e77:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104e78:	f6 c4 02             	test   $0x2,%ah
80104e7b:	75 35                	jne    80104eb2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104e7d:	e8 3e ee ff ff       	call   80103cc0 <mycpu>
80104e82:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104e89:	78 34                	js     80104ebf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104e8b:	e8 30 ee ff ff       	call   80103cc0 <mycpu>
80104e90:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104e96:	85 d2                	test   %edx,%edx
80104e98:	74 06                	je     80104ea0 <popcli+0x30>
    sti();
}
80104e9a:	c9                   	leave  
80104e9b:	c3                   	ret    
80104e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104ea0:	e8 1b ee ff ff       	call   80103cc0 <mycpu>
80104ea5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104eab:	85 c0                	test   %eax,%eax
80104ead:	74 eb                	je     80104e9a <popcli+0x2a>
  asm volatile("sti");
80104eaf:	fb                   	sti    
}
80104eb0:	c9                   	leave  
80104eb1:	c3                   	ret    
    panic("popcli - interruptible");
80104eb2:	83 ec 0c             	sub    $0xc,%esp
80104eb5:	68 ff 85 10 80       	push   $0x801085ff
80104eba:	e8 d1 b4 ff ff       	call   80100390 <panic>
    panic("popcli");
80104ebf:	83 ec 0c             	sub    $0xc,%esp
80104ec2:	68 16 86 10 80       	push   $0x80108616
80104ec7:	e8 c4 b4 ff ff       	call   80100390 <panic>
80104ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ed0 <release>:
{
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	56                   	push   %esi
80104ed4:	53                   	push   %ebx
80104ed5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104ed8:	8b 03                	mov    (%ebx),%eax
80104eda:	85 c0                	test   %eax,%eax
80104edc:	74 0c                	je     80104eea <release+0x1a>
80104ede:	8b 73 08             	mov    0x8(%ebx),%esi
80104ee1:	e8 da ed ff ff       	call   80103cc0 <mycpu>
80104ee6:	39 c6                	cmp    %eax,%esi
80104ee8:	74 16                	je     80104f00 <release+0x30>
    panic("release");
80104eea:	83 ec 0c             	sub    $0xc,%esp
80104eed:	68 1d 86 10 80       	push   $0x8010861d
80104ef2:	e8 99 b4 ff ff       	call   80100390 <panic>
80104ef7:	89 f6                	mov    %esi,%esi
80104ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lk->pcs[0] = 0;
80104f00:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104f07:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104f0e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104f13:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104f19:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f1c:	5b                   	pop    %ebx
80104f1d:	5e                   	pop    %esi
80104f1e:	5d                   	pop    %ebp
  popcli();
80104f1f:	e9 4c ff ff ff       	jmp    80104e70 <popcli>
80104f24:	66 90                	xchg   %ax,%ax
80104f26:	66 90                	xchg   %ax,%ax
80104f28:	66 90                	xchg   %ax,%ax
80104f2a:	66 90                	xchg   %ax,%ax
80104f2c:	66 90                	xchg   %ax,%ax
80104f2e:	66 90                	xchg   %ax,%ax

80104f30 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	57                   	push   %edi
80104f34:	53                   	push   %ebx
80104f35:	8b 55 08             	mov    0x8(%ebp),%edx
80104f38:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104f3b:	f6 c2 03             	test   $0x3,%dl
80104f3e:	75 05                	jne    80104f45 <memset+0x15>
80104f40:	f6 c1 03             	test   $0x3,%cl
80104f43:	74 13                	je     80104f58 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104f45:	89 d7                	mov    %edx,%edi
80104f47:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f4a:	fc                   	cld    
80104f4b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104f4d:	5b                   	pop    %ebx
80104f4e:	89 d0                	mov    %edx,%eax
80104f50:	5f                   	pop    %edi
80104f51:	5d                   	pop    %ebp
80104f52:	c3                   	ret    
80104f53:	90                   	nop
80104f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104f58:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104f5c:	c1 e9 02             	shr    $0x2,%ecx
80104f5f:	89 f8                	mov    %edi,%eax
80104f61:	89 fb                	mov    %edi,%ebx
80104f63:	c1 e0 18             	shl    $0x18,%eax
80104f66:	c1 e3 10             	shl    $0x10,%ebx
80104f69:	09 d8                	or     %ebx,%eax
80104f6b:	09 f8                	or     %edi,%eax
80104f6d:	c1 e7 08             	shl    $0x8,%edi
80104f70:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104f72:	89 d7                	mov    %edx,%edi
80104f74:	fc                   	cld    
80104f75:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104f77:	5b                   	pop    %ebx
80104f78:	89 d0                	mov    %edx,%eax
80104f7a:	5f                   	pop    %edi
80104f7b:	5d                   	pop    %ebp
80104f7c:	c3                   	ret    
80104f7d:	8d 76 00             	lea    0x0(%esi),%esi

80104f80 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	57                   	push   %edi
80104f84:	56                   	push   %esi
80104f85:	53                   	push   %ebx
80104f86:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104f89:	8b 75 08             	mov    0x8(%ebp),%esi
80104f8c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104f8f:	85 db                	test   %ebx,%ebx
80104f91:	74 29                	je     80104fbc <memcmp+0x3c>
    if(*s1 != *s2)
80104f93:	0f b6 16             	movzbl (%esi),%edx
80104f96:	0f b6 0f             	movzbl (%edi),%ecx
80104f99:	38 d1                	cmp    %dl,%cl
80104f9b:	75 2b                	jne    80104fc8 <memcmp+0x48>
80104f9d:	b8 01 00 00 00       	mov    $0x1,%eax
80104fa2:	eb 14                	jmp    80104fb8 <memcmp+0x38>
80104fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fa8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104fac:	83 c0 01             	add    $0x1,%eax
80104faf:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104fb4:	38 ca                	cmp    %cl,%dl
80104fb6:	75 10                	jne    80104fc8 <memcmp+0x48>
  while(n-- > 0){
80104fb8:	39 d8                	cmp    %ebx,%eax
80104fba:	75 ec                	jne    80104fa8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104fbc:	5b                   	pop    %ebx
  return 0;
80104fbd:	31 c0                	xor    %eax,%eax
}
80104fbf:	5e                   	pop    %esi
80104fc0:	5f                   	pop    %edi
80104fc1:	5d                   	pop    %ebp
80104fc2:	c3                   	ret    
80104fc3:	90                   	nop
80104fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104fc8:	0f b6 c2             	movzbl %dl,%eax
}
80104fcb:	5b                   	pop    %ebx
      return *s1 - *s2;
80104fcc:	29 c8                	sub    %ecx,%eax
}
80104fce:	5e                   	pop    %esi
80104fcf:	5f                   	pop    %edi
80104fd0:	5d                   	pop    %ebp
80104fd1:	c3                   	ret    
80104fd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fe0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	56                   	push   %esi
80104fe4:	53                   	push   %ebx
80104fe5:	8b 45 08             	mov    0x8(%ebp),%eax
80104fe8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104feb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104fee:	39 c3                	cmp    %eax,%ebx
80104ff0:	73 26                	jae    80105018 <memmove+0x38>
80104ff2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104ff5:	39 c8                	cmp    %ecx,%eax
80104ff7:	73 1f                	jae    80105018 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104ff9:	85 f6                	test   %esi,%esi
80104ffb:	8d 56 ff             	lea    -0x1(%esi),%edx
80104ffe:	74 0f                	je     8010500f <memmove+0x2f>
      *--d = *--s;
80105000:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105004:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80105007:	83 ea 01             	sub    $0x1,%edx
8010500a:	83 fa ff             	cmp    $0xffffffff,%edx
8010500d:	75 f1                	jne    80105000 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010500f:	5b                   	pop    %ebx
80105010:	5e                   	pop    %esi
80105011:	5d                   	pop    %ebp
80105012:	c3                   	ret    
80105013:	90                   	nop
80105014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80105018:	31 d2                	xor    %edx,%edx
8010501a:	85 f6                	test   %esi,%esi
8010501c:	74 f1                	je     8010500f <memmove+0x2f>
8010501e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105020:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105024:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105027:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010502a:	39 d6                	cmp    %edx,%esi
8010502c:	75 f2                	jne    80105020 <memmove+0x40>
}
8010502e:	5b                   	pop    %ebx
8010502f:	5e                   	pop    %esi
80105030:	5d                   	pop    %ebp
80105031:	c3                   	ret    
80105032:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105040 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105043:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105044:	eb 9a                	jmp    80104fe0 <memmove>
80105046:	8d 76 00             	lea    0x0(%esi),%esi
80105049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105050 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	57                   	push   %edi
80105054:	56                   	push   %esi
80105055:	8b 7d 10             	mov    0x10(%ebp),%edi
80105058:	53                   	push   %ebx
80105059:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010505c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010505f:	85 ff                	test   %edi,%edi
80105061:	74 2f                	je     80105092 <strncmp+0x42>
80105063:	0f b6 01             	movzbl (%ecx),%eax
80105066:	0f b6 1e             	movzbl (%esi),%ebx
80105069:	84 c0                	test   %al,%al
8010506b:	74 37                	je     801050a4 <strncmp+0x54>
8010506d:	38 c3                	cmp    %al,%bl
8010506f:	75 33                	jne    801050a4 <strncmp+0x54>
80105071:	01 f7                	add    %esi,%edi
80105073:	eb 13                	jmp    80105088 <strncmp+0x38>
80105075:	8d 76 00             	lea    0x0(%esi),%esi
80105078:	0f b6 01             	movzbl (%ecx),%eax
8010507b:	84 c0                	test   %al,%al
8010507d:	74 21                	je     801050a0 <strncmp+0x50>
8010507f:	0f b6 1a             	movzbl (%edx),%ebx
80105082:	89 d6                	mov    %edx,%esi
80105084:	38 d8                	cmp    %bl,%al
80105086:	75 1c                	jne    801050a4 <strncmp+0x54>
    n--, p++, q++;
80105088:	8d 56 01             	lea    0x1(%esi),%edx
8010508b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010508e:	39 fa                	cmp    %edi,%edx
80105090:	75 e6                	jne    80105078 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80105092:	5b                   	pop    %ebx
    return 0;
80105093:	31 c0                	xor    %eax,%eax
}
80105095:	5e                   	pop    %esi
80105096:	5f                   	pop    %edi
80105097:	5d                   	pop    %ebp
80105098:	c3                   	ret    
80105099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050a0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
801050a4:	29 d8                	sub    %ebx,%eax
}
801050a6:	5b                   	pop    %ebx
801050a7:	5e                   	pop    %esi
801050a8:	5f                   	pop    %edi
801050a9:	5d                   	pop    %ebp
801050aa:	c3                   	ret    
801050ab:	90                   	nop
801050ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050b0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	56                   	push   %esi
801050b4:	53                   	push   %ebx
801050b5:	8b 45 08             	mov    0x8(%ebp),%eax
801050b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801050bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801050be:	89 c2                	mov    %eax,%edx
801050c0:	eb 19                	jmp    801050db <strncpy+0x2b>
801050c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050c8:	83 c3 01             	add    $0x1,%ebx
801050cb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801050cf:	83 c2 01             	add    $0x1,%edx
801050d2:	84 c9                	test   %cl,%cl
801050d4:	88 4a ff             	mov    %cl,-0x1(%edx)
801050d7:	74 09                	je     801050e2 <strncpy+0x32>
801050d9:	89 f1                	mov    %esi,%ecx
801050db:	85 c9                	test   %ecx,%ecx
801050dd:	8d 71 ff             	lea    -0x1(%ecx),%esi
801050e0:	7f e6                	jg     801050c8 <strncpy+0x18>
    ;
  while(n-- > 0)
801050e2:	31 c9                	xor    %ecx,%ecx
801050e4:	85 f6                	test   %esi,%esi
801050e6:	7e 17                	jle    801050ff <strncpy+0x4f>
801050e8:	90                   	nop
801050e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801050f0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801050f4:	89 f3                	mov    %esi,%ebx
801050f6:	83 c1 01             	add    $0x1,%ecx
801050f9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801050fb:	85 db                	test   %ebx,%ebx
801050fd:	7f f1                	jg     801050f0 <strncpy+0x40>
  return os;
}
801050ff:	5b                   	pop    %ebx
80105100:	5e                   	pop    %esi
80105101:	5d                   	pop    %ebp
80105102:	c3                   	ret    
80105103:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105110 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	56                   	push   %esi
80105114:	53                   	push   %ebx
80105115:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105118:	8b 45 08             	mov    0x8(%ebp),%eax
8010511b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010511e:	85 c9                	test   %ecx,%ecx
80105120:	7e 26                	jle    80105148 <safestrcpy+0x38>
80105122:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105126:	89 c1                	mov    %eax,%ecx
80105128:	eb 17                	jmp    80105141 <safestrcpy+0x31>
8010512a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105130:	83 c2 01             	add    $0x1,%edx
80105133:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105137:	83 c1 01             	add    $0x1,%ecx
8010513a:	84 db                	test   %bl,%bl
8010513c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010513f:	74 04                	je     80105145 <safestrcpy+0x35>
80105141:	39 f2                	cmp    %esi,%edx
80105143:	75 eb                	jne    80105130 <safestrcpy+0x20>
    ;
  *s = 0;
80105145:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105148:	5b                   	pop    %ebx
80105149:	5e                   	pop    %esi
8010514a:	5d                   	pop    %ebp
8010514b:	c3                   	ret    
8010514c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105150 <strlen>:

int
strlen(const char *s)
{
80105150:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105151:	31 c0                	xor    %eax,%eax
{
80105153:	89 e5                	mov    %esp,%ebp
80105155:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105158:	80 3a 00             	cmpb   $0x0,(%edx)
8010515b:	74 0c                	je     80105169 <strlen+0x19>
8010515d:	8d 76 00             	lea    0x0(%esi),%esi
80105160:	83 c0 01             	add    $0x1,%eax
80105163:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105167:	75 f7                	jne    80105160 <strlen+0x10>
    ;
  return n;
}
80105169:	5d                   	pop    %ebp
8010516a:	c3                   	ret    

8010516b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010516b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010516f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105173:	55                   	push   %ebp
  pushl %ebx
80105174:	53                   	push   %ebx
  pushl %esi
80105175:	56                   	push   %esi
  pushl %edi
80105176:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105177:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105179:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010517b:	5f                   	pop    %edi
  popl %esi
8010517c:	5e                   	pop    %esi
  popl %ebx
8010517d:	5b                   	pop    %ebx
  popl %ebp
8010517e:	5d                   	pop    %ebp
  ret
8010517f:	c3                   	ret    

80105180 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	53                   	push   %ebx
80105184:	83 ec 04             	sub    $0x4,%esp
80105187:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010518a:	e8 d1 eb ff ff       	call   80103d60 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010518f:	8b 00                	mov    (%eax),%eax
80105191:	39 d8                	cmp    %ebx,%eax
80105193:	76 1b                	jbe    801051b0 <fetchint+0x30>
80105195:	8d 53 04             	lea    0x4(%ebx),%edx
80105198:	39 d0                	cmp    %edx,%eax
8010519a:	72 14                	jb     801051b0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010519c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010519f:	8b 13                	mov    (%ebx),%edx
801051a1:	89 10                	mov    %edx,(%eax)
  return 0;
801051a3:	31 c0                	xor    %eax,%eax
}
801051a5:	83 c4 04             	add    $0x4,%esp
801051a8:	5b                   	pop    %ebx
801051a9:	5d                   	pop    %ebp
801051aa:	c3                   	ret    
801051ab:	90                   	nop
801051ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801051b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051b5:	eb ee                	jmp    801051a5 <fetchint+0x25>
801051b7:	89 f6                	mov    %esi,%esi
801051b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051c0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	53                   	push   %ebx
801051c4:	83 ec 04             	sub    $0x4,%esp
801051c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801051ca:	e8 91 eb ff ff       	call   80103d60 <myproc>

  if(addr >= curproc->sz)
801051cf:	39 18                	cmp    %ebx,(%eax)
801051d1:	76 29                	jbe    801051fc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801051d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801051d6:	89 da                	mov    %ebx,%edx
801051d8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801051da:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801051dc:	39 c3                	cmp    %eax,%ebx
801051de:	73 1c                	jae    801051fc <fetchstr+0x3c>
    if(*s == 0)
801051e0:	80 3b 00             	cmpb   $0x0,(%ebx)
801051e3:	75 10                	jne    801051f5 <fetchstr+0x35>
801051e5:	eb 39                	jmp    80105220 <fetchstr+0x60>
801051e7:	89 f6                	mov    %esi,%esi
801051e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801051f0:	80 3a 00             	cmpb   $0x0,(%edx)
801051f3:	74 1b                	je     80105210 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
801051f5:	83 c2 01             	add    $0x1,%edx
801051f8:	39 d0                	cmp    %edx,%eax
801051fa:	77 f4                	ja     801051f0 <fetchstr+0x30>
    return -1;
801051fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80105201:	83 c4 04             	add    $0x4,%esp
80105204:	5b                   	pop    %ebx
80105205:	5d                   	pop    %ebp
80105206:	c3                   	ret    
80105207:	89 f6                	mov    %esi,%esi
80105209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105210:	83 c4 04             	add    $0x4,%esp
80105213:	89 d0                	mov    %edx,%eax
80105215:	29 d8                	sub    %ebx,%eax
80105217:	5b                   	pop    %ebx
80105218:	5d                   	pop    %ebp
80105219:	c3                   	ret    
8010521a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80105220:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105222:	eb dd                	jmp    80105201 <fetchstr+0x41>
80105224:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010522a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105230 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	56                   	push   %esi
80105234:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105235:	e8 26 eb ff ff       	call   80103d60 <myproc>
8010523a:	8b 40 18             	mov    0x18(%eax),%eax
8010523d:	8b 55 08             	mov    0x8(%ebp),%edx
80105240:	8b 40 44             	mov    0x44(%eax),%eax
80105243:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105246:	e8 15 eb ff ff       	call   80103d60 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010524b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010524d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105250:	39 c6                	cmp    %eax,%esi
80105252:	73 1c                	jae    80105270 <argint+0x40>
80105254:	8d 53 08             	lea    0x8(%ebx),%edx
80105257:	39 d0                	cmp    %edx,%eax
80105259:	72 15                	jb     80105270 <argint+0x40>
  *ip = *(int*)(addr);
8010525b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010525e:	8b 53 04             	mov    0x4(%ebx),%edx
80105261:	89 10                	mov    %edx,(%eax)
  return 0;
80105263:	31 c0                	xor    %eax,%eax
}
80105265:	5b                   	pop    %ebx
80105266:	5e                   	pop    %esi
80105267:	5d                   	pop    %ebp
80105268:	c3                   	ret    
80105269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105275:	eb ee                	jmp    80105265 <argint+0x35>
80105277:	89 f6                	mov    %esi,%esi
80105279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105280 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	56                   	push   %esi
80105284:	53                   	push   %ebx
80105285:	83 ec 10             	sub    $0x10,%esp
80105288:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010528b:	e8 d0 ea ff ff       	call   80103d60 <myproc>
80105290:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105292:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105295:	83 ec 08             	sub    $0x8,%esp
80105298:	50                   	push   %eax
80105299:	ff 75 08             	pushl  0x8(%ebp)
8010529c:	e8 8f ff ff ff       	call   80105230 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801052a1:	83 c4 10             	add    $0x10,%esp
801052a4:	85 c0                	test   %eax,%eax
801052a6:	78 28                	js     801052d0 <argptr+0x50>
801052a8:	85 db                	test   %ebx,%ebx
801052aa:	78 24                	js     801052d0 <argptr+0x50>
801052ac:	8b 16                	mov    (%esi),%edx
801052ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052b1:	39 c2                	cmp    %eax,%edx
801052b3:	76 1b                	jbe    801052d0 <argptr+0x50>
801052b5:	01 c3                	add    %eax,%ebx
801052b7:	39 da                	cmp    %ebx,%edx
801052b9:	72 15                	jb     801052d0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801052bb:	8b 55 0c             	mov    0xc(%ebp),%edx
801052be:	89 02                	mov    %eax,(%edx)
  return 0;
801052c0:	31 c0                	xor    %eax,%eax
}
801052c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052c5:	5b                   	pop    %ebx
801052c6:	5e                   	pop    %esi
801052c7:	5d                   	pop    %ebp
801052c8:	c3                   	ret    
801052c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801052d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052d5:	eb eb                	jmp    801052c2 <argptr+0x42>
801052d7:	89 f6                	mov    %esi,%esi
801052d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052e0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801052e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052e9:	50                   	push   %eax
801052ea:	ff 75 08             	pushl  0x8(%ebp)
801052ed:	e8 3e ff ff ff       	call   80105230 <argint>
801052f2:	83 c4 10             	add    $0x10,%esp
801052f5:	85 c0                	test   %eax,%eax
801052f7:	78 17                	js     80105310 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801052f9:	83 ec 08             	sub    $0x8,%esp
801052fc:	ff 75 0c             	pushl  0xc(%ebp)
801052ff:	ff 75 f4             	pushl  -0xc(%ebp)
80105302:	e8 b9 fe ff ff       	call   801051c0 <fetchstr>
80105307:	83 c4 10             	add    $0x10,%esp
}
8010530a:	c9                   	leave  
8010530b:	c3                   	ret    
8010530c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105310:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105315:	c9                   	leave  
80105316:	c3                   	ret    
80105317:	89 f6                	mov    %esi,%esi
80105319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105320 <syscall>:
[SYS_protectPage] sys_protectPage,
};

void
syscall(void)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	53                   	push   %ebx
80105324:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105327:	e8 34 ea ff ff       	call   80103d60 <myproc>
8010532c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010532e:	8b 40 18             	mov    0x18(%eax),%eax
80105331:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105334:	8d 50 ff             	lea    -0x1(%eax),%edx
80105337:	83 fa 16             	cmp    $0x16,%edx
8010533a:	77 1c                	ja     80105358 <syscall+0x38>
8010533c:	8b 14 85 60 86 10 80 	mov    -0x7fef79a0(,%eax,4),%edx
80105343:	85 d2                	test   %edx,%edx
80105345:	74 11                	je     80105358 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105347:	ff d2                	call   *%edx
80105349:	8b 53 18             	mov    0x18(%ebx),%edx
8010534c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010534f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105352:	c9                   	leave  
80105353:	c3                   	ret    
80105354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105358:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105359:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010535c:	50                   	push   %eax
8010535d:	ff 73 10             	pushl  0x10(%ebx)
80105360:	68 25 86 10 80       	push   $0x80108625
80105365:	e8 f6 b2 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010536a:	8b 43 18             	mov    0x18(%ebx),%eax
8010536d:	83 c4 10             	add    $0x10,%esp
80105370:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105377:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010537a:	c9                   	leave  
8010537b:	c3                   	ret    
8010537c:	66 90                	xchg   %ax,%ax
8010537e:	66 90                	xchg   %ax,%ax

80105380 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	56                   	push   %esi
80105384:	53                   	push   %ebx
80105385:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105387:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010538a:	89 d6                	mov    %edx,%esi
8010538c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010538f:	50                   	push   %eax
80105390:	6a 00                	push   $0x0
80105392:	e8 99 fe ff ff       	call   80105230 <argint>
80105397:	83 c4 10             	add    $0x10,%esp
8010539a:	85 c0                	test   %eax,%eax
8010539c:	78 2a                	js     801053c8 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010539e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801053a2:	77 24                	ja     801053c8 <argfd.constprop.0+0x48>
801053a4:	e8 b7 e9 ff ff       	call   80103d60 <myproc>
801053a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053ac:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801053b0:	85 c0                	test   %eax,%eax
801053b2:	74 14                	je     801053c8 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
801053b4:	85 db                	test   %ebx,%ebx
801053b6:	74 02                	je     801053ba <argfd.constprop.0+0x3a>
    *pfd = fd;
801053b8:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
801053ba:	89 06                	mov    %eax,(%esi)
  return 0;
801053bc:	31 c0                	xor    %eax,%eax
}
801053be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053c1:	5b                   	pop    %ebx
801053c2:	5e                   	pop    %esi
801053c3:	5d                   	pop    %ebp
801053c4:	c3                   	ret    
801053c5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801053c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053cd:	eb ef                	jmp    801053be <argfd.constprop.0+0x3e>
801053cf:	90                   	nop

801053d0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801053d0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801053d1:	31 c0                	xor    %eax,%eax
{
801053d3:	89 e5                	mov    %esp,%ebp
801053d5:	56                   	push   %esi
801053d6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801053d7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801053da:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801053dd:	e8 9e ff ff ff       	call   80105380 <argfd.constprop.0>
801053e2:	85 c0                	test   %eax,%eax
801053e4:	78 42                	js     80105428 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
801053e6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801053e9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801053eb:	e8 70 e9 ff ff       	call   80103d60 <myproc>
801053f0:	eb 0e                	jmp    80105400 <sys_dup+0x30>
801053f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801053f8:	83 c3 01             	add    $0x1,%ebx
801053fb:	83 fb 10             	cmp    $0x10,%ebx
801053fe:	74 28                	je     80105428 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105400:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105404:	85 d2                	test   %edx,%edx
80105406:	75 f0                	jne    801053f8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105408:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
8010540c:	83 ec 0c             	sub    $0xc,%esp
8010540f:	ff 75 f4             	pushl  -0xc(%ebp)
80105412:	e8 59 ba ff ff       	call   80100e70 <filedup>
  return fd;
80105417:	83 c4 10             	add    $0x10,%esp
}
8010541a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010541d:	89 d8                	mov    %ebx,%eax
8010541f:	5b                   	pop    %ebx
80105420:	5e                   	pop    %esi
80105421:	5d                   	pop    %ebp
80105422:	c3                   	ret    
80105423:	90                   	nop
80105424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105428:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010542b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105430:	89 d8                	mov    %ebx,%eax
80105432:	5b                   	pop    %ebx
80105433:	5e                   	pop    %esi
80105434:	5d                   	pop    %ebp
80105435:	c3                   	ret    
80105436:	8d 76 00             	lea    0x0(%esi),%esi
80105439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105440 <sys_read>:

int
sys_read(void)
{
80105440:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105441:	31 c0                	xor    %eax,%eax
{
80105443:	89 e5                	mov    %esp,%ebp
80105445:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105448:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010544b:	e8 30 ff ff ff       	call   80105380 <argfd.constprop.0>
80105450:	85 c0                	test   %eax,%eax
80105452:	78 4c                	js     801054a0 <sys_read+0x60>
80105454:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105457:	83 ec 08             	sub    $0x8,%esp
8010545a:	50                   	push   %eax
8010545b:	6a 02                	push   $0x2
8010545d:	e8 ce fd ff ff       	call   80105230 <argint>
80105462:	83 c4 10             	add    $0x10,%esp
80105465:	85 c0                	test   %eax,%eax
80105467:	78 37                	js     801054a0 <sys_read+0x60>
80105469:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010546c:	83 ec 04             	sub    $0x4,%esp
8010546f:	ff 75 f0             	pushl  -0x10(%ebp)
80105472:	50                   	push   %eax
80105473:	6a 01                	push   $0x1
80105475:	e8 06 fe ff ff       	call   80105280 <argptr>
8010547a:	83 c4 10             	add    $0x10,%esp
8010547d:	85 c0                	test   %eax,%eax
8010547f:	78 1f                	js     801054a0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105481:	83 ec 04             	sub    $0x4,%esp
80105484:	ff 75 f0             	pushl  -0x10(%ebp)
80105487:	ff 75 f4             	pushl  -0xc(%ebp)
8010548a:	ff 75 ec             	pushl  -0x14(%ebp)
8010548d:	e8 4e bb ff ff       	call   80100fe0 <fileread>
80105492:	83 c4 10             	add    $0x10,%esp
}
80105495:	c9                   	leave  
80105496:	c3                   	ret    
80105497:	89 f6                	mov    %esi,%esi
80105499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801054a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054a5:	c9                   	leave  
801054a6:	c3                   	ret    
801054a7:	89 f6                	mov    %esi,%esi
801054a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054b0 <sys_write>:

int
sys_write(void)
{
801054b0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054b1:	31 c0                	xor    %eax,%eax
{
801054b3:	89 e5                	mov    %esp,%ebp
801054b5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054b8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801054bb:	e8 c0 fe ff ff       	call   80105380 <argfd.constprop.0>
801054c0:	85 c0                	test   %eax,%eax
801054c2:	78 4c                	js     80105510 <sys_write+0x60>
801054c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054c7:	83 ec 08             	sub    $0x8,%esp
801054ca:	50                   	push   %eax
801054cb:	6a 02                	push   $0x2
801054cd:	e8 5e fd ff ff       	call   80105230 <argint>
801054d2:	83 c4 10             	add    $0x10,%esp
801054d5:	85 c0                	test   %eax,%eax
801054d7:	78 37                	js     80105510 <sys_write+0x60>
801054d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054dc:	83 ec 04             	sub    $0x4,%esp
801054df:	ff 75 f0             	pushl  -0x10(%ebp)
801054e2:	50                   	push   %eax
801054e3:	6a 01                	push   $0x1
801054e5:	e8 96 fd ff ff       	call   80105280 <argptr>
801054ea:	83 c4 10             	add    $0x10,%esp
801054ed:	85 c0                	test   %eax,%eax
801054ef:	78 1f                	js     80105510 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
801054f1:	83 ec 04             	sub    $0x4,%esp
801054f4:	ff 75 f0             	pushl  -0x10(%ebp)
801054f7:	ff 75 f4             	pushl  -0xc(%ebp)
801054fa:	ff 75 ec             	pushl  -0x14(%ebp)
801054fd:	e8 6e bb ff ff       	call   80101070 <filewrite>
80105502:	83 c4 10             	add    $0x10,%esp
}
80105505:	c9                   	leave  
80105506:	c3                   	ret    
80105507:	89 f6                	mov    %esi,%esi
80105509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105510:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105515:	c9                   	leave  
80105516:	c3                   	ret    
80105517:	89 f6                	mov    %esi,%esi
80105519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105520 <sys_close>:

int
sys_close(void)
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105526:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105529:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010552c:	e8 4f fe ff ff       	call   80105380 <argfd.constprop.0>
80105531:	85 c0                	test   %eax,%eax
80105533:	78 2b                	js     80105560 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105535:	e8 26 e8 ff ff       	call   80103d60 <myproc>
8010553a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010553d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105540:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105547:	00 
  fileclose(f);
80105548:	ff 75 f4             	pushl  -0xc(%ebp)
8010554b:	e8 70 b9 ff ff       	call   80100ec0 <fileclose>
  return 0;
80105550:	83 c4 10             	add    $0x10,%esp
80105553:	31 c0                	xor    %eax,%eax
}
80105555:	c9                   	leave  
80105556:	c3                   	ret    
80105557:	89 f6                	mov    %esi,%esi
80105559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105560:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105565:	c9                   	leave  
80105566:	c3                   	ret    
80105567:	89 f6                	mov    %esi,%esi
80105569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105570 <sys_fstat>:

int
sys_fstat(void)
{
80105570:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105571:	31 c0                	xor    %eax,%eax
{
80105573:	89 e5                	mov    %esp,%ebp
80105575:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105578:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010557b:	e8 00 fe ff ff       	call   80105380 <argfd.constprop.0>
80105580:	85 c0                	test   %eax,%eax
80105582:	78 2c                	js     801055b0 <sys_fstat+0x40>
80105584:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105587:	83 ec 04             	sub    $0x4,%esp
8010558a:	6a 14                	push   $0x14
8010558c:	50                   	push   %eax
8010558d:	6a 01                	push   $0x1
8010558f:	e8 ec fc ff ff       	call   80105280 <argptr>
80105594:	83 c4 10             	add    $0x10,%esp
80105597:	85 c0                	test   %eax,%eax
80105599:	78 15                	js     801055b0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010559b:	83 ec 08             	sub    $0x8,%esp
8010559e:	ff 75 f4             	pushl  -0xc(%ebp)
801055a1:	ff 75 f0             	pushl  -0x10(%ebp)
801055a4:	e8 e7 b9 ff ff       	call   80100f90 <filestat>
801055a9:	83 c4 10             	add    $0x10,%esp
}
801055ac:	c9                   	leave  
801055ad:	c3                   	ret    
801055ae:	66 90                	xchg   %ax,%ax
    return -1;
801055b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055b5:	c9                   	leave  
801055b6:	c3                   	ret    
801055b7:	89 f6                	mov    %esi,%esi
801055b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055c0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	57                   	push   %edi
801055c4:	56                   	push   %esi
801055c5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801055c6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801055c9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801055cc:	50                   	push   %eax
801055cd:	6a 00                	push   $0x0
801055cf:	e8 0c fd ff ff       	call   801052e0 <argstr>
801055d4:	83 c4 10             	add    $0x10,%esp
801055d7:	85 c0                	test   %eax,%eax
801055d9:	0f 88 fb 00 00 00    	js     801056da <sys_link+0x11a>
801055df:	8d 45 d0             	lea    -0x30(%ebp),%eax
801055e2:	83 ec 08             	sub    $0x8,%esp
801055e5:	50                   	push   %eax
801055e6:	6a 01                	push   $0x1
801055e8:	e8 f3 fc ff ff       	call   801052e0 <argstr>
801055ed:	83 c4 10             	add    $0x10,%esp
801055f0:	85 c0                	test   %eax,%eax
801055f2:	0f 88 e2 00 00 00    	js     801056da <sys_link+0x11a>
    return -1;

  begin_op();
801055f8:	e8 b3 da ff ff       	call   801030b0 <begin_op>
  if((ip = namei(old)) == 0){
801055fd:	83 ec 0c             	sub    $0xc,%esp
80105600:	ff 75 d4             	pushl  -0x2c(%ebp)
80105603:	e8 68 c9 ff ff       	call   80101f70 <namei>
80105608:	83 c4 10             	add    $0x10,%esp
8010560b:	85 c0                	test   %eax,%eax
8010560d:	89 c3                	mov    %eax,%ebx
8010560f:	0f 84 ea 00 00 00    	je     801056ff <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
80105615:	83 ec 0c             	sub    $0xc,%esp
80105618:	50                   	push   %eax
80105619:	e8 f2 c0 ff ff       	call   80101710 <ilock>
  if(ip->type == T_DIR){
8010561e:	83 c4 10             	add    $0x10,%esp
80105621:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105626:	0f 84 bb 00 00 00    	je     801056e7 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010562c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105631:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105634:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105637:	53                   	push   %ebx
80105638:	e8 23 c0 ff ff       	call   80101660 <iupdate>
  iunlock(ip);
8010563d:	89 1c 24             	mov    %ebx,(%esp)
80105640:	e8 ab c1 ff ff       	call   801017f0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105645:	58                   	pop    %eax
80105646:	5a                   	pop    %edx
80105647:	57                   	push   %edi
80105648:	ff 75 d0             	pushl  -0x30(%ebp)
8010564b:	e8 40 c9 ff ff       	call   80101f90 <nameiparent>
80105650:	83 c4 10             	add    $0x10,%esp
80105653:	85 c0                	test   %eax,%eax
80105655:	89 c6                	mov    %eax,%esi
80105657:	74 5b                	je     801056b4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105659:	83 ec 0c             	sub    $0xc,%esp
8010565c:	50                   	push   %eax
8010565d:	e8 ae c0 ff ff       	call   80101710 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105662:	83 c4 10             	add    $0x10,%esp
80105665:	8b 03                	mov    (%ebx),%eax
80105667:	39 06                	cmp    %eax,(%esi)
80105669:	75 3d                	jne    801056a8 <sys_link+0xe8>
8010566b:	83 ec 04             	sub    $0x4,%esp
8010566e:	ff 73 04             	pushl  0x4(%ebx)
80105671:	57                   	push   %edi
80105672:	56                   	push   %esi
80105673:	e8 38 c8 ff ff       	call   80101eb0 <dirlink>
80105678:	83 c4 10             	add    $0x10,%esp
8010567b:	85 c0                	test   %eax,%eax
8010567d:	78 29                	js     801056a8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010567f:	83 ec 0c             	sub    $0xc,%esp
80105682:	56                   	push   %esi
80105683:	e8 18 c3 ff ff       	call   801019a0 <iunlockput>
  iput(ip);
80105688:	89 1c 24             	mov    %ebx,(%esp)
8010568b:	e8 b0 c1 ff ff       	call   80101840 <iput>

  end_op();
80105690:	e8 8b da ff ff       	call   80103120 <end_op>

  return 0;
80105695:	83 c4 10             	add    $0x10,%esp
80105698:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010569a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010569d:	5b                   	pop    %ebx
8010569e:	5e                   	pop    %esi
8010569f:	5f                   	pop    %edi
801056a0:	5d                   	pop    %ebp
801056a1:	c3                   	ret    
801056a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801056a8:	83 ec 0c             	sub    $0xc,%esp
801056ab:	56                   	push   %esi
801056ac:	e8 ef c2 ff ff       	call   801019a0 <iunlockput>
    goto bad;
801056b1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801056b4:	83 ec 0c             	sub    $0xc,%esp
801056b7:	53                   	push   %ebx
801056b8:	e8 53 c0 ff ff       	call   80101710 <ilock>
  ip->nlink--;
801056bd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801056c2:	89 1c 24             	mov    %ebx,(%esp)
801056c5:	e8 96 bf ff ff       	call   80101660 <iupdate>
  iunlockput(ip);
801056ca:	89 1c 24             	mov    %ebx,(%esp)
801056cd:	e8 ce c2 ff ff       	call   801019a0 <iunlockput>
  end_op();
801056d2:	e8 49 da ff ff       	call   80103120 <end_op>
  return -1;
801056d7:	83 c4 10             	add    $0x10,%esp
}
801056da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801056dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056e2:	5b                   	pop    %ebx
801056e3:	5e                   	pop    %esi
801056e4:	5f                   	pop    %edi
801056e5:	5d                   	pop    %ebp
801056e6:	c3                   	ret    
    iunlockput(ip);
801056e7:	83 ec 0c             	sub    $0xc,%esp
801056ea:	53                   	push   %ebx
801056eb:	e8 b0 c2 ff ff       	call   801019a0 <iunlockput>
    end_op();
801056f0:	e8 2b da ff ff       	call   80103120 <end_op>
    return -1;
801056f5:	83 c4 10             	add    $0x10,%esp
801056f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056fd:	eb 9b                	jmp    8010569a <sys_link+0xda>
    end_op();
801056ff:	e8 1c da ff ff       	call   80103120 <end_op>
    return -1;
80105704:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105709:	eb 8f                	jmp    8010569a <sys_link+0xda>
8010570b:	90                   	nop
8010570c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105710 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	57                   	push   %edi
80105714:	56                   	push   %esi
80105715:	53                   	push   %ebx
80105716:	83 ec 1c             	sub    $0x1c,%esp
80105719:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010571c:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105720:	76 3e                	jbe    80105760 <isdirempty+0x50>
80105722:	bb 20 00 00 00       	mov    $0x20,%ebx
80105727:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010572a:	eb 0c                	jmp    80105738 <isdirempty+0x28>
8010572c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105730:	83 c3 10             	add    $0x10,%ebx
80105733:	3b 5e 58             	cmp    0x58(%esi),%ebx
80105736:	73 28                	jae    80105760 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105738:	6a 10                	push   $0x10
8010573a:	53                   	push   %ebx
8010573b:	57                   	push   %edi
8010573c:	56                   	push   %esi
8010573d:	e8 ae c2 ff ff       	call   801019f0 <readi>
80105742:	83 c4 10             	add    $0x10,%esp
80105745:	83 f8 10             	cmp    $0x10,%eax
80105748:	75 23                	jne    8010576d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010574a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010574f:	74 df                	je     80105730 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105751:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105754:	31 c0                	xor    %eax,%eax
}
80105756:	5b                   	pop    %ebx
80105757:	5e                   	pop    %esi
80105758:	5f                   	pop    %edi
80105759:	5d                   	pop    %ebp
8010575a:	c3                   	ret    
8010575b:	90                   	nop
8010575c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105760:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105763:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105768:	5b                   	pop    %ebx
80105769:	5e                   	pop    %esi
8010576a:	5f                   	pop    %edi
8010576b:	5d                   	pop    %ebp
8010576c:	c3                   	ret    
      panic("isdirempty: readi");
8010576d:	83 ec 0c             	sub    $0xc,%esp
80105770:	68 c0 86 10 80       	push   $0x801086c0
80105775:	e8 16 ac ff ff       	call   80100390 <panic>
8010577a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105780 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	57                   	push   %edi
80105784:	56                   	push   %esi
80105785:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105786:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105789:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010578c:	50                   	push   %eax
8010578d:	6a 00                	push   $0x0
8010578f:	e8 4c fb ff ff       	call   801052e0 <argstr>
80105794:	83 c4 10             	add    $0x10,%esp
80105797:	85 c0                	test   %eax,%eax
80105799:	0f 88 51 01 00 00    	js     801058f0 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010579f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801057a2:	e8 09 d9 ff ff       	call   801030b0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801057a7:	83 ec 08             	sub    $0x8,%esp
801057aa:	53                   	push   %ebx
801057ab:	ff 75 c0             	pushl  -0x40(%ebp)
801057ae:	e8 dd c7 ff ff       	call   80101f90 <nameiparent>
801057b3:	83 c4 10             	add    $0x10,%esp
801057b6:	85 c0                	test   %eax,%eax
801057b8:	89 c6                	mov    %eax,%esi
801057ba:	0f 84 37 01 00 00    	je     801058f7 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
801057c0:	83 ec 0c             	sub    $0xc,%esp
801057c3:	50                   	push   %eax
801057c4:	e8 47 bf ff ff       	call   80101710 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801057c9:	58                   	pop    %eax
801057ca:	5a                   	pop    %edx
801057cb:	68 00 80 10 80       	push   $0x80108000
801057d0:	53                   	push   %ebx
801057d1:	e8 4a c4 ff ff       	call   80101c20 <namecmp>
801057d6:	83 c4 10             	add    $0x10,%esp
801057d9:	85 c0                	test   %eax,%eax
801057db:	0f 84 d7 00 00 00    	je     801058b8 <sys_unlink+0x138>
801057e1:	83 ec 08             	sub    $0x8,%esp
801057e4:	68 ff 7f 10 80       	push   $0x80107fff
801057e9:	53                   	push   %ebx
801057ea:	e8 31 c4 ff ff       	call   80101c20 <namecmp>
801057ef:	83 c4 10             	add    $0x10,%esp
801057f2:	85 c0                	test   %eax,%eax
801057f4:	0f 84 be 00 00 00    	je     801058b8 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801057fa:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801057fd:	83 ec 04             	sub    $0x4,%esp
80105800:	50                   	push   %eax
80105801:	53                   	push   %ebx
80105802:	56                   	push   %esi
80105803:	e8 38 c4 ff ff       	call   80101c40 <dirlookup>
80105808:	83 c4 10             	add    $0x10,%esp
8010580b:	85 c0                	test   %eax,%eax
8010580d:	89 c3                	mov    %eax,%ebx
8010580f:	0f 84 a3 00 00 00    	je     801058b8 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
80105815:	83 ec 0c             	sub    $0xc,%esp
80105818:	50                   	push   %eax
80105819:	e8 f2 be ff ff       	call   80101710 <ilock>

  if(ip->nlink < 1)
8010581e:	83 c4 10             	add    $0x10,%esp
80105821:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105826:	0f 8e e4 00 00 00    	jle    80105910 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
8010582c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105831:	74 65                	je     80105898 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105833:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105836:	83 ec 04             	sub    $0x4,%esp
80105839:	6a 10                	push   $0x10
8010583b:	6a 00                	push   $0x0
8010583d:	57                   	push   %edi
8010583e:	e8 ed f6 ff ff       	call   80104f30 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105843:	6a 10                	push   $0x10
80105845:	ff 75 c4             	pushl  -0x3c(%ebp)
80105848:	57                   	push   %edi
80105849:	56                   	push   %esi
8010584a:	e8 a1 c2 ff ff       	call   80101af0 <writei>
8010584f:	83 c4 20             	add    $0x20,%esp
80105852:	83 f8 10             	cmp    $0x10,%eax
80105855:	0f 85 a8 00 00 00    	jne    80105903 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010585b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105860:	74 6e                	je     801058d0 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105862:	83 ec 0c             	sub    $0xc,%esp
80105865:	56                   	push   %esi
80105866:	e8 35 c1 ff ff       	call   801019a0 <iunlockput>

  ip->nlink--;
8010586b:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105870:	89 1c 24             	mov    %ebx,(%esp)
80105873:	e8 e8 bd ff ff       	call   80101660 <iupdate>
  iunlockput(ip);
80105878:	89 1c 24             	mov    %ebx,(%esp)
8010587b:	e8 20 c1 ff ff       	call   801019a0 <iunlockput>

  end_op();
80105880:	e8 9b d8 ff ff       	call   80103120 <end_op>

  return 0;
80105885:	83 c4 10             	add    $0x10,%esp
80105888:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010588a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010588d:	5b                   	pop    %ebx
8010588e:	5e                   	pop    %esi
8010588f:	5f                   	pop    %edi
80105890:	5d                   	pop    %ebp
80105891:	c3                   	ret    
80105892:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105898:	83 ec 0c             	sub    $0xc,%esp
8010589b:	53                   	push   %ebx
8010589c:	e8 6f fe ff ff       	call   80105710 <isdirempty>
801058a1:	83 c4 10             	add    $0x10,%esp
801058a4:	85 c0                	test   %eax,%eax
801058a6:	75 8b                	jne    80105833 <sys_unlink+0xb3>
    iunlockput(ip);
801058a8:	83 ec 0c             	sub    $0xc,%esp
801058ab:	53                   	push   %ebx
801058ac:	e8 ef c0 ff ff       	call   801019a0 <iunlockput>
    goto bad;
801058b1:	83 c4 10             	add    $0x10,%esp
801058b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
801058b8:	83 ec 0c             	sub    $0xc,%esp
801058bb:	56                   	push   %esi
801058bc:	e8 df c0 ff ff       	call   801019a0 <iunlockput>
  end_op();
801058c1:	e8 5a d8 ff ff       	call   80103120 <end_op>
  return -1;
801058c6:	83 c4 10             	add    $0x10,%esp
801058c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ce:	eb ba                	jmp    8010588a <sys_unlink+0x10a>
    dp->nlink--;
801058d0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801058d5:	83 ec 0c             	sub    $0xc,%esp
801058d8:	56                   	push   %esi
801058d9:	e8 82 bd ff ff       	call   80101660 <iupdate>
801058de:	83 c4 10             	add    $0x10,%esp
801058e1:	e9 7c ff ff ff       	jmp    80105862 <sys_unlink+0xe2>
801058e6:	8d 76 00             	lea    0x0(%esi),%esi
801058e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801058f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058f5:	eb 93                	jmp    8010588a <sys_unlink+0x10a>
    end_op();
801058f7:	e8 24 d8 ff ff       	call   80103120 <end_op>
    return -1;
801058fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105901:	eb 87                	jmp    8010588a <sys_unlink+0x10a>
    panic("unlink: writei");
80105903:	83 ec 0c             	sub    $0xc,%esp
80105906:	68 14 80 10 80       	push   $0x80108014
8010590b:	e8 80 aa ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105910:	83 ec 0c             	sub    $0xc,%esp
80105913:	68 02 80 10 80       	push   $0x80108002
80105918:	e8 73 aa ff ff       	call   80100390 <panic>
8010591d:	8d 76 00             	lea    0x0(%esi),%esi

80105920 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
80105923:	57                   	push   %edi
80105924:	56                   	push   %esi
80105925:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105926:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105929:	83 ec 44             	sub    $0x44,%esp
8010592c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010592f:	8b 55 10             	mov    0x10(%ebp),%edx
80105932:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105935:	56                   	push   %esi
80105936:	ff 75 08             	pushl  0x8(%ebp)
{
80105939:	89 45 c4             	mov    %eax,-0x3c(%ebp)
8010593c:	89 55 c0             	mov    %edx,-0x40(%ebp)
8010593f:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105942:	e8 49 c6 ff ff       	call   80101f90 <nameiparent>
80105947:	83 c4 10             	add    $0x10,%esp
8010594a:	85 c0                	test   %eax,%eax
8010594c:	0f 84 4e 01 00 00    	je     80105aa0 <create+0x180>
    return 0;
  ilock(dp);
80105952:	83 ec 0c             	sub    $0xc,%esp
80105955:	89 c3                	mov    %eax,%ebx
80105957:	50                   	push   %eax
80105958:	e8 b3 bd ff ff       	call   80101710 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
8010595d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105960:	83 c4 0c             	add    $0xc,%esp
80105963:	50                   	push   %eax
80105964:	56                   	push   %esi
80105965:	53                   	push   %ebx
80105966:	e8 d5 c2 ff ff       	call   80101c40 <dirlookup>
8010596b:	83 c4 10             	add    $0x10,%esp
8010596e:	85 c0                	test   %eax,%eax
80105970:	89 c7                	mov    %eax,%edi
80105972:	74 3c                	je     801059b0 <create+0x90>
    iunlockput(dp);
80105974:	83 ec 0c             	sub    $0xc,%esp
80105977:	53                   	push   %ebx
80105978:	e8 23 c0 ff ff       	call   801019a0 <iunlockput>
    ilock(ip);
8010597d:	89 3c 24             	mov    %edi,(%esp)
80105980:	e8 8b bd ff ff       	call   80101710 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105985:	83 c4 10             	add    $0x10,%esp
80105988:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
8010598d:	0f 85 9d 00 00 00    	jne    80105a30 <create+0x110>
80105993:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105998:	0f 85 92 00 00 00    	jne    80105a30 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010599e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059a1:	89 f8                	mov    %edi,%eax
801059a3:	5b                   	pop    %ebx
801059a4:	5e                   	pop    %esi
801059a5:	5f                   	pop    %edi
801059a6:	5d                   	pop    %ebp
801059a7:	c3                   	ret    
801059a8:	90                   	nop
801059a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
801059b0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801059b4:	83 ec 08             	sub    $0x8,%esp
801059b7:	50                   	push   %eax
801059b8:	ff 33                	pushl  (%ebx)
801059ba:	e8 e1 bb ff ff       	call   801015a0 <ialloc>
801059bf:	83 c4 10             	add    $0x10,%esp
801059c2:	85 c0                	test   %eax,%eax
801059c4:	89 c7                	mov    %eax,%edi
801059c6:	0f 84 e8 00 00 00    	je     80105ab4 <create+0x194>
  ilock(ip);
801059cc:	83 ec 0c             	sub    $0xc,%esp
801059cf:	50                   	push   %eax
801059d0:	e8 3b bd ff ff       	call   80101710 <ilock>
  ip->major = major;
801059d5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801059d9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
801059dd:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801059e1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
801059e5:	b8 01 00 00 00       	mov    $0x1,%eax
801059ea:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
801059ee:	89 3c 24             	mov    %edi,(%esp)
801059f1:	e8 6a bc ff ff       	call   80101660 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801059f6:	83 c4 10             	add    $0x10,%esp
801059f9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801059fe:	74 50                	je     80105a50 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80105a00:	83 ec 04             	sub    $0x4,%esp
80105a03:	ff 77 04             	pushl  0x4(%edi)
80105a06:	56                   	push   %esi
80105a07:	53                   	push   %ebx
80105a08:	e8 a3 c4 ff ff       	call   80101eb0 <dirlink>
80105a0d:	83 c4 10             	add    $0x10,%esp
80105a10:	85 c0                	test   %eax,%eax
80105a12:	0f 88 8f 00 00 00    	js     80105aa7 <create+0x187>
  iunlockput(dp);
80105a18:	83 ec 0c             	sub    $0xc,%esp
80105a1b:	53                   	push   %ebx
80105a1c:	e8 7f bf ff ff       	call   801019a0 <iunlockput>
  return ip;
80105a21:	83 c4 10             	add    $0x10,%esp
}
80105a24:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a27:	89 f8                	mov    %edi,%eax
80105a29:	5b                   	pop    %ebx
80105a2a:	5e                   	pop    %esi
80105a2b:	5f                   	pop    %edi
80105a2c:	5d                   	pop    %ebp
80105a2d:	c3                   	ret    
80105a2e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105a30:	83 ec 0c             	sub    $0xc,%esp
80105a33:	57                   	push   %edi
    return 0;
80105a34:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105a36:	e8 65 bf ff ff       	call   801019a0 <iunlockput>
    return 0;
80105a3b:	83 c4 10             	add    $0x10,%esp
}
80105a3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a41:	89 f8                	mov    %edi,%eax
80105a43:	5b                   	pop    %ebx
80105a44:	5e                   	pop    %esi
80105a45:	5f                   	pop    %edi
80105a46:	5d                   	pop    %ebp
80105a47:	c3                   	ret    
80105a48:	90                   	nop
80105a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105a50:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105a55:	83 ec 0c             	sub    $0xc,%esp
80105a58:	53                   	push   %ebx
80105a59:	e8 02 bc ff ff       	call   80101660 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105a5e:	83 c4 0c             	add    $0xc,%esp
80105a61:	ff 77 04             	pushl  0x4(%edi)
80105a64:	68 00 80 10 80       	push   $0x80108000
80105a69:	57                   	push   %edi
80105a6a:	e8 41 c4 ff ff       	call   80101eb0 <dirlink>
80105a6f:	83 c4 10             	add    $0x10,%esp
80105a72:	85 c0                	test   %eax,%eax
80105a74:	78 1c                	js     80105a92 <create+0x172>
80105a76:	83 ec 04             	sub    $0x4,%esp
80105a79:	ff 73 04             	pushl  0x4(%ebx)
80105a7c:	68 ff 7f 10 80       	push   $0x80107fff
80105a81:	57                   	push   %edi
80105a82:	e8 29 c4 ff ff       	call   80101eb0 <dirlink>
80105a87:	83 c4 10             	add    $0x10,%esp
80105a8a:	85 c0                	test   %eax,%eax
80105a8c:	0f 89 6e ff ff ff    	jns    80105a00 <create+0xe0>
      panic("create dots");
80105a92:	83 ec 0c             	sub    $0xc,%esp
80105a95:	68 e1 86 10 80       	push   $0x801086e1
80105a9a:	e8 f1 a8 ff ff       	call   80100390 <panic>
80105a9f:	90                   	nop
    return 0;
80105aa0:	31 ff                	xor    %edi,%edi
80105aa2:	e9 f7 fe ff ff       	jmp    8010599e <create+0x7e>
    panic("create: dirlink");
80105aa7:	83 ec 0c             	sub    $0xc,%esp
80105aaa:	68 ed 86 10 80       	push   $0x801086ed
80105aaf:	e8 dc a8 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105ab4:	83 ec 0c             	sub    $0xc,%esp
80105ab7:	68 d2 86 10 80       	push   $0x801086d2
80105abc:	e8 cf a8 ff ff       	call   80100390 <panic>
80105ac1:	eb 0d                	jmp    80105ad0 <sys_open>
80105ac3:	90                   	nop
80105ac4:	90                   	nop
80105ac5:	90                   	nop
80105ac6:	90                   	nop
80105ac7:	90                   	nop
80105ac8:	90                   	nop
80105ac9:	90                   	nop
80105aca:	90                   	nop
80105acb:	90                   	nop
80105acc:	90                   	nop
80105acd:	90                   	nop
80105ace:	90                   	nop
80105acf:	90                   	nop

80105ad0 <sys_open>:

int
sys_open(void)
{
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	57                   	push   %edi
80105ad4:	56                   	push   %esi
80105ad5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105ad6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105ad9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105adc:	50                   	push   %eax
80105add:	6a 00                	push   $0x0
80105adf:	e8 fc f7 ff ff       	call   801052e0 <argstr>
80105ae4:	83 c4 10             	add    $0x10,%esp
80105ae7:	85 c0                	test   %eax,%eax
80105ae9:	0f 88 1d 01 00 00    	js     80105c0c <sys_open+0x13c>
80105aef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105af2:	83 ec 08             	sub    $0x8,%esp
80105af5:	50                   	push   %eax
80105af6:	6a 01                	push   $0x1
80105af8:	e8 33 f7 ff ff       	call   80105230 <argint>
80105afd:	83 c4 10             	add    $0x10,%esp
80105b00:	85 c0                	test   %eax,%eax
80105b02:	0f 88 04 01 00 00    	js     80105c0c <sys_open+0x13c>
    return -1;

  begin_op();
80105b08:	e8 a3 d5 ff ff       	call   801030b0 <begin_op>

  if(omode & O_CREATE){
80105b0d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105b11:	0f 85 a9 00 00 00    	jne    80105bc0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105b17:	83 ec 0c             	sub    $0xc,%esp
80105b1a:	ff 75 e0             	pushl  -0x20(%ebp)
80105b1d:	e8 4e c4 ff ff       	call   80101f70 <namei>
80105b22:	83 c4 10             	add    $0x10,%esp
80105b25:	85 c0                	test   %eax,%eax
80105b27:	89 c6                	mov    %eax,%esi
80105b29:	0f 84 ac 00 00 00    	je     80105bdb <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
80105b2f:	83 ec 0c             	sub    $0xc,%esp
80105b32:	50                   	push   %eax
80105b33:	e8 d8 bb ff ff       	call   80101710 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b38:	83 c4 10             	add    $0x10,%esp
80105b3b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105b40:	0f 84 aa 00 00 00    	je     80105bf0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105b46:	e8 b5 b2 ff ff       	call   80100e00 <filealloc>
80105b4b:	85 c0                	test   %eax,%eax
80105b4d:	89 c7                	mov    %eax,%edi
80105b4f:	0f 84 a6 00 00 00    	je     80105bfb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105b55:	e8 06 e2 ff ff       	call   80103d60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b5a:	31 db                	xor    %ebx,%ebx
80105b5c:	eb 0e                	jmp    80105b6c <sys_open+0x9c>
80105b5e:	66 90                	xchg   %ax,%ax
80105b60:	83 c3 01             	add    $0x1,%ebx
80105b63:	83 fb 10             	cmp    $0x10,%ebx
80105b66:	0f 84 ac 00 00 00    	je     80105c18 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
80105b6c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105b70:	85 d2                	test   %edx,%edx
80105b72:	75 ec                	jne    80105b60 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b74:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105b77:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105b7b:	56                   	push   %esi
80105b7c:	e8 6f bc ff ff       	call   801017f0 <iunlock>
  end_op();
80105b81:	e8 9a d5 ff ff       	call   80103120 <end_op>

  f->type = FD_INODE;
80105b86:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105b8c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b8f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105b92:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105b95:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105b9c:	89 d0                	mov    %edx,%eax
80105b9e:	f7 d0                	not    %eax
80105ba0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ba3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105ba6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ba9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105bad:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bb0:	89 d8                	mov    %ebx,%eax
80105bb2:	5b                   	pop    %ebx
80105bb3:	5e                   	pop    %esi
80105bb4:	5f                   	pop    %edi
80105bb5:	5d                   	pop    %ebp
80105bb6:	c3                   	ret    
80105bb7:	89 f6                	mov    %esi,%esi
80105bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105bc0:	6a 00                	push   $0x0
80105bc2:	6a 00                	push   $0x0
80105bc4:	6a 02                	push   $0x2
80105bc6:	ff 75 e0             	pushl  -0x20(%ebp)
80105bc9:	e8 52 fd ff ff       	call   80105920 <create>
    if(ip == 0){
80105bce:	83 c4 10             	add    $0x10,%esp
80105bd1:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105bd3:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105bd5:	0f 85 6b ff ff ff    	jne    80105b46 <sys_open+0x76>
      end_op();
80105bdb:	e8 40 d5 ff ff       	call   80103120 <end_op>
      return -1;
80105be0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105be5:	eb c6                	jmp    80105bad <sys_open+0xdd>
80105be7:	89 f6                	mov    %esi,%esi
80105be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105bf0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105bf3:	85 c9                	test   %ecx,%ecx
80105bf5:	0f 84 4b ff ff ff    	je     80105b46 <sys_open+0x76>
    iunlockput(ip);
80105bfb:	83 ec 0c             	sub    $0xc,%esp
80105bfe:	56                   	push   %esi
80105bff:	e8 9c bd ff ff       	call   801019a0 <iunlockput>
    end_op();
80105c04:	e8 17 d5 ff ff       	call   80103120 <end_op>
    return -1;
80105c09:	83 c4 10             	add    $0x10,%esp
80105c0c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c11:	eb 9a                	jmp    80105bad <sys_open+0xdd>
80105c13:	90                   	nop
80105c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105c18:	83 ec 0c             	sub    $0xc,%esp
80105c1b:	57                   	push   %edi
80105c1c:	e8 9f b2 ff ff       	call   80100ec0 <fileclose>
80105c21:	83 c4 10             	add    $0x10,%esp
80105c24:	eb d5                	jmp    80105bfb <sys_open+0x12b>
80105c26:	8d 76 00             	lea    0x0(%esi),%esi
80105c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c30 <sys_mkdir>:

int
sys_mkdir(void)
{
80105c30:	55                   	push   %ebp
80105c31:	89 e5                	mov    %esp,%ebp
80105c33:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105c36:	e8 75 d4 ff ff       	call   801030b0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105c3b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c3e:	83 ec 08             	sub    $0x8,%esp
80105c41:	50                   	push   %eax
80105c42:	6a 00                	push   $0x0
80105c44:	e8 97 f6 ff ff       	call   801052e0 <argstr>
80105c49:	83 c4 10             	add    $0x10,%esp
80105c4c:	85 c0                	test   %eax,%eax
80105c4e:	78 30                	js     80105c80 <sys_mkdir+0x50>
80105c50:	6a 00                	push   $0x0
80105c52:	6a 00                	push   $0x0
80105c54:	6a 01                	push   $0x1
80105c56:	ff 75 f4             	pushl  -0xc(%ebp)
80105c59:	e8 c2 fc ff ff       	call   80105920 <create>
80105c5e:	83 c4 10             	add    $0x10,%esp
80105c61:	85 c0                	test   %eax,%eax
80105c63:	74 1b                	je     80105c80 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c65:	83 ec 0c             	sub    $0xc,%esp
80105c68:	50                   	push   %eax
80105c69:	e8 32 bd ff ff       	call   801019a0 <iunlockput>
  end_op();
80105c6e:	e8 ad d4 ff ff       	call   80103120 <end_op>
  return 0;
80105c73:	83 c4 10             	add    $0x10,%esp
80105c76:	31 c0                	xor    %eax,%eax
}
80105c78:	c9                   	leave  
80105c79:	c3                   	ret    
80105c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105c80:	e8 9b d4 ff ff       	call   80103120 <end_op>
    return -1;
80105c85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c8a:	c9                   	leave  
80105c8b:	c3                   	ret    
80105c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c90 <sys_mknod>:

int
sys_mknod(void)
{
80105c90:	55                   	push   %ebp
80105c91:	89 e5                	mov    %esp,%ebp
80105c93:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105c96:	e8 15 d4 ff ff       	call   801030b0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105c9b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c9e:	83 ec 08             	sub    $0x8,%esp
80105ca1:	50                   	push   %eax
80105ca2:	6a 00                	push   $0x0
80105ca4:	e8 37 f6 ff ff       	call   801052e0 <argstr>
80105ca9:	83 c4 10             	add    $0x10,%esp
80105cac:	85 c0                	test   %eax,%eax
80105cae:	78 60                	js     80105d10 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105cb0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105cb3:	83 ec 08             	sub    $0x8,%esp
80105cb6:	50                   	push   %eax
80105cb7:	6a 01                	push   $0x1
80105cb9:	e8 72 f5 ff ff       	call   80105230 <argint>
  if((argstr(0, &path)) < 0 ||
80105cbe:	83 c4 10             	add    $0x10,%esp
80105cc1:	85 c0                	test   %eax,%eax
80105cc3:	78 4b                	js     80105d10 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105cc5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cc8:	83 ec 08             	sub    $0x8,%esp
80105ccb:	50                   	push   %eax
80105ccc:	6a 02                	push   $0x2
80105cce:	e8 5d f5 ff ff       	call   80105230 <argint>
     argint(1, &major) < 0 ||
80105cd3:	83 c4 10             	add    $0x10,%esp
80105cd6:	85 c0                	test   %eax,%eax
80105cd8:	78 36                	js     80105d10 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105cda:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105cde:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
80105cdf:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
80105ce3:	50                   	push   %eax
80105ce4:	6a 03                	push   $0x3
80105ce6:	ff 75 ec             	pushl  -0x14(%ebp)
80105ce9:	e8 32 fc ff ff       	call   80105920 <create>
80105cee:	83 c4 10             	add    $0x10,%esp
80105cf1:	85 c0                	test   %eax,%eax
80105cf3:	74 1b                	je     80105d10 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105cf5:	83 ec 0c             	sub    $0xc,%esp
80105cf8:	50                   	push   %eax
80105cf9:	e8 a2 bc ff ff       	call   801019a0 <iunlockput>
  end_op();
80105cfe:	e8 1d d4 ff ff       	call   80103120 <end_op>
  return 0;
80105d03:	83 c4 10             	add    $0x10,%esp
80105d06:	31 c0                	xor    %eax,%eax
}
80105d08:	c9                   	leave  
80105d09:	c3                   	ret    
80105d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105d10:	e8 0b d4 ff ff       	call   80103120 <end_op>
    return -1;
80105d15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d1a:	c9                   	leave  
80105d1b:	c3                   	ret    
80105d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d20 <sys_chdir>:

int
sys_chdir(void)
{
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	56                   	push   %esi
80105d24:	53                   	push   %ebx
80105d25:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105d28:	e8 33 e0 ff ff       	call   80103d60 <myproc>
80105d2d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105d2f:	e8 7c d3 ff ff       	call   801030b0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105d34:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d37:	83 ec 08             	sub    $0x8,%esp
80105d3a:	50                   	push   %eax
80105d3b:	6a 00                	push   $0x0
80105d3d:	e8 9e f5 ff ff       	call   801052e0 <argstr>
80105d42:	83 c4 10             	add    $0x10,%esp
80105d45:	85 c0                	test   %eax,%eax
80105d47:	78 77                	js     80105dc0 <sys_chdir+0xa0>
80105d49:	83 ec 0c             	sub    $0xc,%esp
80105d4c:	ff 75 f4             	pushl  -0xc(%ebp)
80105d4f:	e8 1c c2 ff ff       	call   80101f70 <namei>
80105d54:	83 c4 10             	add    $0x10,%esp
80105d57:	85 c0                	test   %eax,%eax
80105d59:	89 c3                	mov    %eax,%ebx
80105d5b:	74 63                	je     80105dc0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105d5d:	83 ec 0c             	sub    $0xc,%esp
80105d60:	50                   	push   %eax
80105d61:	e8 aa b9 ff ff       	call   80101710 <ilock>
  if(ip->type != T_DIR){
80105d66:	83 c4 10             	add    $0x10,%esp
80105d69:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105d6e:	75 30                	jne    80105da0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105d70:	83 ec 0c             	sub    $0xc,%esp
80105d73:	53                   	push   %ebx
80105d74:	e8 77 ba ff ff       	call   801017f0 <iunlock>
  iput(curproc->cwd);
80105d79:	58                   	pop    %eax
80105d7a:	ff 76 68             	pushl  0x68(%esi)
80105d7d:	e8 be ba ff ff       	call   80101840 <iput>
  end_op();
80105d82:	e8 99 d3 ff ff       	call   80103120 <end_op>
  curproc->cwd = ip;
80105d87:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105d8a:	83 c4 10             	add    $0x10,%esp
80105d8d:	31 c0                	xor    %eax,%eax
}
80105d8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d92:	5b                   	pop    %ebx
80105d93:	5e                   	pop    %esi
80105d94:	5d                   	pop    %ebp
80105d95:	c3                   	ret    
80105d96:	8d 76 00             	lea    0x0(%esi),%esi
80105d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105da0:	83 ec 0c             	sub    $0xc,%esp
80105da3:	53                   	push   %ebx
80105da4:	e8 f7 bb ff ff       	call   801019a0 <iunlockput>
    end_op();
80105da9:	e8 72 d3 ff ff       	call   80103120 <end_op>
    return -1;
80105dae:	83 c4 10             	add    $0x10,%esp
80105db1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105db6:	eb d7                	jmp    80105d8f <sys_chdir+0x6f>
80105db8:	90                   	nop
80105db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105dc0:	e8 5b d3 ff ff       	call   80103120 <end_op>
    return -1;
80105dc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dca:	eb c3                	jmp    80105d8f <sys_chdir+0x6f>
80105dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105dd0 <sys_exec>:

int
sys_exec(void)
{
80105dd0:	55                   	push   %ebp
80105dd1:	89 e5                	mov    %esp,%ebp
80105dd3:	57                   	push   %edi
80105dd4:	56                   	push   %esi
80105dd5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105dd6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105ddc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105de2:	50                   	push   %eax
80105de3:	6a 00                	push   $0x0
80105de5:	e8 f6 f4 ff ff       	call   801052e0 <argstr>
80105dea:	83 c4 10             	add    $0x10,%esp
80105ded:	85 c0                	test   %eax,%eax
80105def:	0f 88 87 00 00 00    	js     80105e7c <sys_exec+0xac>
80105df5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105dfb:	83 ec 08             	sub    $0x8,%esp
80105dfe:	50                   	push   %eax
80105dff:	6a 01                	push   $0x1
80105e01:	e8 2a f4 ff ff       	call   80105230 <argint>
80105e06:	83 c4 10             	add    $0x10,%esp
80105e09:	85 c0                	test   %eax,%eax
80105e0b:	78 6f                	js     80105e7c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105e0d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105e13:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105e16:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105e18:	68 80 00 00 00       	push   $0x80
80105e1d:	6a 00                	push   $0x0
80105e1f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105e25:	50                   	push   %eax
80105e26:	e8 05 f1 ff ff       	call   80104f30 <memset>
80105e2b:	83 c4 10             	add    $0x10,%esp
80105e2e:	eb 2c                	jmp    80105e5c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105e30:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105e36:	85 c0                	test   %eax,%eax
80105e38:	74 56                	je     80105e90 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105e3a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105e40:	83 ec 08             	sub    $0x8,%esp
80105e43:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105e46:	52                   	push   %edx
80105e47:	50                   	push   %eax
80105e48:	e8 73 f3 ff ff       	call   801051c0 <fetchstr>
80105e4d:	83 c4 10             	add    $0x10,%esp
80105e50:	85 c0                	test   %eax,%eax
80105e52:	78 28                	js     80105e7c <sys_exec+0xac>
  for(i=0;; i++){
80105e54:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105e57:	83 fb 20             	cmp    $0x20,%ebx
80105e5a:	74 20                	je     80105e7c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105e5c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105e62:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105e69:	83 ec 08             	sub    $0x8,%esp
80105e6c:	57                   	push   %edi
80105e6d:	01 f0                	add    %esi,%eax
80105e6f:	50                   	push   %eax
80105e70:	e8 0b f3 ff ff       	call   80105180 <fetchint>
80105e75:	83 c4 10             	add    $0x10,%esp
80105e78:	85 c0                	test   %eax,%eax
80105e7a:	79 b4                	jns    80105e30 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105e7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105e7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e84:	5b                   	pop    %ebx
80105e85:	5e                   	pop    %esi
80105e86:	5f                   	pop    %edi
80105e87:	5d                   	pop    %ebp
80105e88:	c3                   	ret    
80105e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105e90:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105e96:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105e99:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105ea0:	00 00 00 00 
  return exec(path, argv);
80105ea4:	50                   	push   %eax
80105ea5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105eab:	e8 60 ab ff ff       	call   80100a10 <exec>
80105eb0:	83 c4 10             	add    $0x10,%esp
}
80105eb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105eb6:	5b                   	pop    %ebx
80105eb7:	5e                   	pop    %esi
80105eb8:	5f                   	pop    %edi
80105eb9:	5d                   	pop    %ebp
80105eba:	c3                   	ret    
80105ebb:	90                   	nop
80105ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ec0 <sys_pipe>:

int
sys_pipe(void)
{
80105ec0:	55                   	push   %ebp
80105ec1:	89 e5                	mov    %esp,%ebp
80105ec3:	57                   	push   %edi
80105ec4:	56                   	push   %esi
80105ec5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105ec6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105ec9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105ecc:	6a 08                	push   $0x8
80105ece:	50                   	push   %eax
80105ecf:	6a 00                	push   $0x0
80105ed1:	e8 aa f3 ff ff       	call   80105280 <argptr>
80105ed6:	83 c4 10             	add    $0x10,%esp
80105ed9:	85 c0                	test   %eax,%eax
80105edb:	0f 88 ae 00 00 00    	js     80105f8f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105ee1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ee4:	83 ec 08             	sub    $0x8,%esp
80105ee7:	50                   	push   %eax
80105ee8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105eeb:	50                   	push   %eax
80105eec:	e8 5f d8 ff ff       	call   80103750 <pipealloc>
80105ef1:	83 c4 10             	add    $0x10,%esp
80105ef4:	85 c0                	test   %eax,%eax
80105ef6:	0f 88 93 00 00 00    	js     80105f8f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105efc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105eff:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105f01:	e8 5a de ff ff       	call   80103d60 <myproc>
80105f06:	eb 10                	jmp    80105f18 <sys_pipe+0x58>
80105f08:	90                   	nop
80105f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105f10:	83 c3 01             	add    $0x1,%ebx
80105f13:	83 fb 10             	cmp    $0x10,%ebx
80105f16:	74 60                	je     80105f78 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105f18:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105f1c:	85 f6                	test   %esi,%esi
80105f1e:	75 f0                	jne    80105f10 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105f20:	8d 73 08             	lea    0x8(%ebx),%esi
80105f23:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105f27:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105f2a:	e8 31 de ff ff       	call   80103d60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105f2f:	31 d2                	xor    %edx,%edx
80105f31:	eb 0d                	jmp    80105f40 <sys_pipe+0x80>
80105f33:	90                   	nop
80105f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f38:	83 c2 01             	add    $0x1,%edx
80105f3b:	83 fa 10             	cmp    $0x10,%edx
80105f3e:	74 28                	je     80105f68 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105f40:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105f44:	85 c9                	test   %ecx,%ecx
80105f46:	75 f0                	jne    80105f38 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105f48:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105f4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f4f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105f51:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f54:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105f57:	31 c0                	xor    %eax,%eax
}
80105f59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f5c:	5b                   	pop    %ebx
80105f5d:	5e                   	pop    %esi
80105f5e:	5f                   	pop    %edi
80105f5f:	5d                   	pop    %ebp
80105f60:	c3                   	ret    
80105f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105f68:	e8 f3 dd ff ff       	call   80103d60 <myproc>
80105f6d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105f74:	00 
80105f75:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105f78:	83 ec 0c             	sub    $0xc,%esp
80105f7b:	ff 75 e0             	pushl  -0x20(%ebp)
80105f7e:	e8 3d af ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
80105f83:	58                   	pop    %eax
80105f84:	ff 75 e4             	pushl  -0x1c(%ebp)
80105f87:	e8 34 af ff ff       	call   80100ec0 <fileclose>
    return -1;
80105f8c:	83 c4 10             	add    $0x10,%esp
80105f8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f94:	eb c3                	jmp    80105f59 <sys_pipe+0x99>
80105f96:	66 90                	xchg   %ax,%ax
80105f98:	66 90                	xchg   %ax,%ax
80105f9a:	66 90                	xchg   %ax,%ax
80105f9c:	66 90                	xchg   %ax,%ax
80105f9e:	66 90                	xchg   %ax,%ax

80105fa0 <sys_yield>:
#include "mmu.h"
#include "proc.h"


int sys_yield(void)
{
80105fa0:	55                   	push   %ebp
80105fa1:	89 e5                	mov    %esp,%ebp
80105fa3:	83 ec 08             	sub    $0x8,%esp
  yield(); 
80105fa6:	e8 b5 e3 ff ff       	call   80104360 <yield>
  return 0;
}
80105fab:	31 c0                	xor    %eax,%eax
80105fad:	c9                   	leave  
80105fae:	c3                   	ret    
80105faf:	90                   	nop

80105fb0 <sys_fork>:

int
sys_fork(void)
{
80105fb0:	55                   	push   %ebp
80105fb1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105fb3:	5d                   	pop    %ebp
  return fork();
80105fb4:	e9 b7 df ff ff       	jmp    80103f70 <fork>
80105fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105fc0 <sys_exit>:

int
sys_exit(void)
{
80105fc0:	55                   	push   %ebp
80105fc1:	89 e5                	mov    %esp,%ebp
80105fc3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105fc6:	e8 55 e2 ff ff       	call   80104220 <exit>
  return 0;  // not reached
}
80105fcb:	31 c0                	xor    %eax,%eax
80105fcd:	c9                   	leave  
80105fce:	c3                   	ret    
80105fcf:	90                   	nop

80105fd0 <sys_wait>:

int
sys_wait(void)
{
80105fd0:	55                   	push   %ebp
80105fd1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105fd3:	5d                   	pop    %ebp
  return wait();
80105fd4:	e9 97 e4 ff ff       	jmp    80104470 <wait>
80105fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105fe0 <sys_kill>:

int
sys_kill(void)
{
80105fe0:	55                   	push   %ebp
80105fe1:	89 e5                	mov    %esp,%ebp
80105fe3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105fe6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fe9:	50                   	push   %eax
80105fea:	6a 00                	push   $0x0
80105fec:	e8 3f f2 ff ff       	call   80105230 <argint>
80105ff1:	83 c4 10             	add    $0x10,%esp
80105ff4:	85 c0                	test   %eax,%eax
80105ff6:	78 18                	js     80106010 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105ff8:	83 ec 0c             	sub    $0xc,%esp
80105ffb:	ff 75 f4             	pushl  -0xc(%ebp)
80105ffe:	e8 cd e5 ff ff       	call   801045d0 <kill>
80106003:	83 c4 10             	add    $0x10,%esp
}
80106006:	c9                   	leave  
80106007:	c3                   	ret    
80106008:	90                   	nop
80106009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106010:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106015:	c9                   	leave  
80106016:	c3                   	ret    
80106017:	89 f6                	mov    %esi,%esi
80106019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106020 <sys_getpid>:

int
sys_getpid(void)
{
80106020:	55                   	push   %ebp
80106021:	89 e5                	mov    %esp,%ebp
80106023:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106026:	e8 35 dd ff ff       	call   80103d60 <myproc>
8010602b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010602e:	c9                   	leave  
8010602f:	c3                   	ret    

80106030 <sys_sbrk>:

int
sys_sbrk(void)
{
80106030:	55                   	push   %ebp
80106031:	89 e5                	mov    %esp,%ebp
80106033:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106034:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106037:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010603a:	50                   	push   %eax
8010603b:	6a 00                	push   $0x0
8010603d:	e8 ee f1 ff ff       	call   80105230 <argint>
80106042:	83 c4 10             	add    $0x10,%esp
80106045:	85 c0                	test   %eax,%eax
80106047:	78 27                	js     80106070 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106049:	e8 12 dd ff ff       	call   80103d60 <myproc>
  if(growproc(n) < 0)
8010604e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106051:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106053:	ff 75 f4             	pushl  -0xc(%ebp)
80106056:	e8 95 de ff ff       	call   80103ef0 <growproc>
8010605b:	83 c4 10             	add    $0x10,%esp
8010605e:	85 c0                	test   %eax,%eax
80106060:	78 0e                	js     80106070 <sys_sbrk+0x40>
    return -1;
  //cprintf("sbrk - addr=%d\n", addr);
  return addr;
}
80106062:	89 d8                	mov    %ebx,%eax
80106064:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106067:	c9                   	leave  
80106068:	c3                   	ret    
80106069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106070:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106075:	eb eb                	jmp    80106062 <sys_sbrk+0x32>
80106077:	89 f6                	mov    %esi,%esi
80106079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106080 <sys_sleep>:

int
sys_sleep(void)
{
80106080:	55                   	push   %ebp
80106081:	89 e5                	mov    %esp,%ebp
80106083:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106084:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106087:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010608a:	50                   	push   %eax
8010608b:	6a 00                	push   $0x0
8010608d:	e8 9e f1 ff ff       	call   80105230 <argint>
80106092:	83 c4 10             	add    $0x10,%esp
80106095:	85 c0                	test   %eax,%eax
80106097:	0f 88 8a 00 00 00    	js     80106127 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010609d:	83 ec 0c             	sub    $0xc,%esp
801060a0:	68 80 24 12 80       	push   $0x80122480
801060a5:	e8 06 ed ff ff       	call   80104db0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801060aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801060ad:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801060b0:	8b 1d c0 2c 12 80    	mov    0x80122cc0,%ebx
  while(ticks - ticks0 < n){
801060b6:	85 d2                	test   %edx,%edx
801060b8:	75 27                	jne    801060e1 <sys_sleep+0x61>
801060ba:	eb 54                	jmp    80106110 <sys_sleep+0x90>
801060bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801060c0:	83 ec 08             	sub    $0x8,%esp
801060c3:	68 80 24 12 80       	push   $0x80122480
801060c8:	68 c0 2c 12 80       	push   $0x80122cc0
801060cd:	e8 de e2 ff ff       	call   801043b0 <sleep>
  while(ticks - ticks0 < n){
801060d2:	a1 c0 2c 12 80       	mov    0x80122cc0,%eax
801060d7:	83 c4 10             	add    $0x10,%esp
801060da:	29 d8                	sub    %ebx,%eax
801060dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801060df:	73 2f                	jae    80106110 <sys_sleep+0x90>
    if(myproc()->killed){
801060e1:	e8 7a dc ff ff       	call   80103d60 <myproc>
801060e6:	8b 40 24             	mov    0x24(%eax),%eax
801060e9:	85 c0                	test   %eax,%eax
801060eb:	74 d3                	je     801060c0 <sys_sleep+0x40>
      release(&tickslock);
801060ed:	83 ec 0c             	sub    $0xc,%esp
801060f0:	68 80 24 12 80       	push   $0x80122480
801060f5:	e8 d6 ed ff ff       	call   80104ed0 <release>
      return -1;
801060fa:	83 c4 10             	add    $0x10,%esp
801060fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80106102:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106105:	c9                   	leave  
80106106:	c3                   	ret    
80106107:	89 f6                	mov    %esi,%esi
80106109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80106110:	83 ec 0c             	sub    $0xc,%esp
80106113:	68 80 24 12 80       	push   $0x80122480
80106118:	e8 b3 ed ff ff       	call   80104ed0 <release>
  return 0;
8010611d:	83 c4 10             	add    $0x10,%esp
80106120:	31 c0                	xor    %eax,%eax
}
80106122:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106125:	c9                   	leave  
80106126:	c3                   	ret    
    return -1;
80106127:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010612c:	eb f4                	jmp    80106122 <sys_sleep+0xa2>
8010612e:	66 90                	xchg   %ax,%ax

80106130 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106130:	55                   	push   %ebp
80106131:	89 e5                	mov    %esp,%ebp
80106133:	53                   	push   %ebx
80106134:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106137:	68 80 24 12 80       	push   $0x80122480
8010613c:	e8 6f ec ff ff       	call   80104db0 <acquire>
  xticks = ticks;
80106141:	8b 1d c0 2c 12 80    	mov    0x80122cc0,%ebx
  release(&tickslock);
80106147:	c7 04 24 80 24 12 80 	movl   $0x80122480,(%esp)
8010614e:	e8 7d ed ff ff       	call   80104ed0 <release>
  return xticks;
}
80106153:	89 d8                	mov    %ebx,%eax
80106155:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106158:	c9                   	leave  
80106159:	c3                   	ret    
8010615a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106160 <sys_protectPage>:

int
sys_protectPage(void){
80106160:	55                   	push   %ebp
80106161:	89 e5                	mov    %esp,%ebp
80106163:	83 ec 1c             	sub    $0x1c,%esp
  void* va;

  if (argptr(0, (char**)(&va), sizeof(int)) < 0){
80106166:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106169:	6a 04                	push   $0x4
8010616b:	50                   	push   %eax
8010616c:	6a 00                	push   $0x0
8010616e:	e8 0d f1 ff ff       	call   80105280 <argptr>
80106173:	83 c4 10             	add    $0x10,%esp
80106176:	85 c0                	test   %eax,%eax
80106178:	78 16                	js     80106190 <sys_protectPage+0x30>
    return -1;
  }
  return protectPage(va);
8010617a:	83 ec 0c             	sub    $0xc,%esp
8010617d:	ff 75 f4             	pushl  -0xc(%ebp)
80106180:	e8 3b e6 ff ff       	call   801047c0 <protectPage>
80106185:	83 c4 10             	add    $0x10,%esp
80106188:	c9                   	leave  
80106189:	c3                   	ret    
8010618a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106190:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106195:	c9                   	leave  
80106196:	c3                   	ret    

80106197 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106197:	1e                   	push   %ds
  pushl %es
80106198:	06                   	push   %es
  pushl %fs
80106199:	0f a0                	push   %fs
  pushl %gs
8010619b:	0f a8                	push   %gs
  pushal
8010619d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010619e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801061a2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801061a4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801061a6:	54                   	push   %esp
  call trap
801061a7:	e8 c4 00 00 00       	call   80106270 <trap>
  addl $4, %esp
801061ac:	83 c4 04             	add    $0x4,%esp

801061af <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801061af:	61                   	popa   
  popl %gs
801061b0:	0f a9                	pop    %gs
  popl %fs
801061b2:	0f a1                	pop    %fs
  popl %es
801061b4:	07                   	pop    %es
  popl %ds
801061b5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801061b6:	83 c4 08             	add    $0x8,%esp
  iret
801061b9:	cf                   	iret   
801061ba:	66 90                	xchg   %ax,%ax
801061bc:	66 90                	xchg   %ax,%ax
801061be:	66 90                	xchg   %ax,%ax

801061c0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801061c0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801061c1:	31 c0                	xor    %eax,%eax
{
801061c3:	89 e5                	mov    %esp,%ebp
801061c5:	83 ec 08             	sub    $0x8,%esp
801061c8:	90                   	nop
801061c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801061d0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801061d7:	c7 04 c5 c2 24 12 80 	movl   $0x8e000008,-0x7feddb3e(,%eax,8)
801061de:	08 00 00 8e 
801061e2:	66 89 14 c5 c0 24 12 	mov    %dx,-0x7feddb40(,%eax,8)
801061e9:	80 
801061ea:	c1 ea 10             	shr    $0x10,%edx
801061ed:	66 89 14 c5 c6 24 12 	mov    %dx,-0x7feddb3a(,%eax,8)
801061f4:	80 
  for(i = 0; i < 256; i++)
801061f5:	83 c0 01             	add    $0x1,%eax
801061f8:	3d 00 01 00 00       	cmp    $0x100,%eax
801061fd:	75 d1                	jne    801061d0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061ff:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80106204:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106207:	c7 05 c2 26 12 80 08 	movl   $0xef000008,0x801226c2
8010620e:	00 00 ef 
  initlock(&tickslock, "time");
80106211:	68 fd 86 10 80       	push   $0x801086fd
80106216:	68 80 24 12 80       	push   $0x80122480
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010621b:	66 a3 c0 26 12 80    	mov    %ax,0x801226c0
80106221:	c1 e8 10             	shr    $0x10,%eax
80106224:	66 a3 c6 26 12 80    	mov    %ax,0x801226c6
  initlock(&tickslock, "time");
8010622a:	e8 91 ea ff ff       	call   80104cc0 <initlock>
}
8010622f:	83 c4 10             	add    $0x10,%esp
80106232:	c9                   	leave  
80106233:	c3                   	ret    
80106234:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010623a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106240 <idtinit>:

void
idtinit(void)
{
80106240:	55                   	push   %ebp
  pd[0] = size-1;
80106241:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106246:	89 e5                	mov    %esp,%ebp
80106248:	83 ec 10             	sub    $0x10,%esp
8010624b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010624f:	b8 c0 24 12 80       	mov    $0x801224c0,%eax
80106254:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106258:	c1 e8 10             	shr    $0x10,%eax
8010625b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010625f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106262:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106265:	c9                   	leave  
80106266:	c3                   	ret    
80106267:	89 f6                	mov    %esi,%esi
80106269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106270 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106270:	55                   	push   %ebp
80106271:	89 e5                	mov    %esp,%ebp
80106273:	57                   	push   %edi
80106274:	56                   	push   %esi
80106275:	53                   	push   %ebx
80106276:	83 ec 1c             	sub    $0x1c,%esp
80106279:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010627c:	8b 47 30             	mov    0x30(%edi),%eax
8010627f:	83 f8 40             	cmp    $0x40,%eax
80106282:	0f 84 f0 00 00 00    	je     80106378 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }
  
  switch(tf->trapno){
80106288:	83 e8 0e             	sub    $0xe,%eax
8010628b:	83 f8 31             	cmp    $0x31,%eax
8010628e:	77 10                	ja     801062a0 <trap+0x30>
80106290:	ff 24 85 a4 87 10 80 	jmp    *-0x7fef785c(,%eax,4)
80106297:	89 f6                	mov    %esi,%esi
80106299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801062a0:	e8 bb da ff ff       	call   80103d60 <myproc>
801062a5:	85 c0                	test   %eax,%eax
801062a7:	8b 5f 38             	mov    0x38(%edi),%ebx
801062aa:	0f 84 04 02 00 00    	je     801064b4 <trap+0x244>
801062b0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801062b4:	0f 84 fa 01 00 00    	je     801064b4 <trap+0x244>
  asm volatile("movl %%cr2,%0" : "=r" (val));
801062ba:	0f 20 d1             	mov    %cr2,%ecx
801062bd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801062c0:	e8 7b da ff ff       	call   80103d40 <cpuid>
801062c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
801062c8:	8b 47 34             	mov    0x34(%edi),%eax
801062cb:	8b 77 30             	mov    0x30(%edi),%esi
801062ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801062d1:	e8 8a da ff ff       	call   80103d60 <myproc>
801062d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801062d9:	e8 82 da ff ff       	call   80103d60 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801062de:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801062e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801062e4:	51                   	push   %ecx
801062e5:	53                   	push   %ebx
801062e6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
801062e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801062ea:	ff 75 e4             	pushl  -0x1c(%ebp)
801062ed:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801062ee:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801062f1:	52                   	push   %edx
801062f2:	ff 70 10             	pushl  0x10(%eax)
801062f5:	68 60 87 10 80       	push   $0x80108760
801062fa:	e8 61 a3 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801062ff:	83 c4 20             	add    $0x20,%esp
80106302:	e8 59 da ff ff       	call   80103d60 <myproc>
80106307:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010630e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106310:	e8 4b da ff ff       	call   80103d60 <myproc>
80106315:	85 c0                	test   %eax,%eax
80106317:	74 1d                	je     80106336 <trap+0xc6>
80106319:	e8 42 da ff ff       	call   80103d60 <myproc>
8010631e:	8b 50 24             	mov    0x24(%eax),%edx
80106321:	85 d2                	test   %edx,%edx
80106323:	74 11                	je     80106336 <trap+0xc6>
80106325:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106329:	83 e0 03             	and    $0x3,%eax
8010632c:	66 83 f8 03          	cmp    $0x3,%ax
80106330:	0f 84 3a 01 00 00    	je     80106470 <trap+0x200>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106336:	e8 25 da ff ff       	call   80103d60 <myproc>
8010633b:	85 c0                	test   %eax,%eax
8010633d:	74 0b                	je     8010634a <trap+0xda>
8010633f:	e8 1c da ff ff       	call   80103d60 <myproc>
80106344:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106348:	74 66                	je     801063b0 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010634a:	e8 11 da ff ff       	call   80103d60 <myproc>
8010634f:	85 c0                	test   %eax,%eax
80106351:	74 19                	je     8010636c <trap+0xfc>
80106353:	e8 08 da ff ff       	call   80103d60 <myproc>
80106358:	8b 40 24             	mov    0x24(%eax),%eax
8010635b:	85 c0                	test   %eax,%eax
8010635d:	74 0d                	je     8010636c <trap+0xfc>
8010635f:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106363:	83 e0 03             	and    $0x3,%eax
80106366:	66 83 f8 03          	cmp    $0x3,%ax
8010636a:	74 35                	je     801063a1 <trap+0x131>
    exit();
}
8010636c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010636f:	5b                   	pop    %ebx
80106370:	5e                   	pop    %esi
80106371:	5f                   	pop    %edi
80106372:	5d                   	pop    %ebp
80106373:	c3                   	ret    
80106374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106378:	e8 e3 d9 ff ff       	call   80103d60 <myproc>
8010637d:	8b 58 24             	mov    0x24(%eax),%ebx
80106380:	85 db                	test   %ebx,%ebx
80106382:	0f 85 d8 00 00 00    	jne    80106460 <trap+0x1f0>
    myproc()->tf = tf;
80106388:	e8 d3 d9 ff ff       	call   80103d60 <myproc>
8010638d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106390:	e8 8b ef ff ff       	call   80105320 <syscall>
    if(myproc()->killed)
80106395:	e8 c6 d9 ff ff       	call   80103d60 <myproc>
8010639a:	8b 48 24             	mov    0x24(%eax),%ecx
8010639d:	85 c9                	test   %ecx,%ecx
8010639f:	74 cb                	je     8010636c <trap+0xfc>
}
801063a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063a4:	5b                   	pop    %ebx
801063a5:	5e                   	pop    %esi
801063a6:	5f                   	pop    %edi
801063a7:	5d                   	pop    %ebp
      exit();
801063a8:	e9 73 de ff ff       	jmp    80104220 <exit>
801063ad:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
801063b0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801063b4:	75 94                	jne    8010634a <trap+0xda>
    yield();
801063b6:	e8 a5 df ff ff       	call   80104360 <yield>
801063bb:	eb 8d                	jmp    8010634a <trap+0xda>
801063bd:	8d 76 00             	lea    0x0(%esi),%esi
      checkIfNeedSwapping();
801063c0:	e8 0b 1a 00 00       	call   80107dd0 <checkIfNeedSwapping>
      break;
801063c5:	e9 46 ff ff ff       	jmp    80106310 <trap+0xa0>
801063ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(cpuid() == 0){
801063d0:	e8 6b d9 ff ff       	call   80103d40 <cpuid>
801063d5:	85 c0                	test   %eax,%eax
801063d7:	0f 84 a3 00 00 00    	je     80106480 <trap+0x210>
    lapiceoi();
801063dd:	e8 7e c8 ff ff       	call   80102c60 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063e2:	e8 79 d9 ff ff       	call   80103d60 <myproc>
801063e7:	85 c0                	test   %eax,%eax
801063e9:	0f 85 2a ff ff ff    	jne    80106319 <trap+0xa9>
801063ef:	e9 42 ff ff ff       	jmp    80106336 <trap+0xc6>
801063f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801063f8:	e8 23 c7 ff ff       	call   80102b20 <kbdintr>
    lapiceoi();
801063fd:	e8 5e c8 ff ff       	call   80102c60 <lapiceoi>
    break;
80106402:	e9 09 ff ff ff       	jmp    80106310 <trap+0xa0>
80106407:	89 f6                	mov    %esi,%esi
80106409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    uartintr();
80106410:	e8 3b 02 00 00       	call   80106650 <uartintr>
    lapiceoi();
80106415:	e8 46 c8 ff ff       	call   80102c60 <lapiceoi>
    break;
8010641a:	e9 f1 fe ff ff       	jmp    80106310 <trap+0xa0>
8010641f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106420:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106424:	8b 77 38             	mov    0x38(%edi),%esi
80106427:	e8 14 d9 ff ff       	call   80103d40 <cpuid>
8010642c:	56                   	push   %esi
8010642d:	53                   	push   %ebx
8010642e:	50                   	push   %eax
8010642f:	68 08 87 10 80       	push   $0x80108708
80106434:	e8 27 a2 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106439:	e8 22 c8 ff ff       	call   80102c60 <lapiceoi>
    break;
8010643e:	83 c4 10             	add    $0x10,%esp
80106441:	e9 ca fe ff ff       	jmp    80106310 <trap+0xa0>
80106446:	8d 76 00             	lea    0x0(%esi),%esi
80106449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80106450:	e8 3b c1 ff ff       	call   80102590 <ideintr>
80106455:	eb 86                	jmp    801063dd <trap+0x16d>
80106457:	89 f6                	mov    %esi,%esi
80106459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
80106460:	e8 bb dd ff ff       	call   80104220 <exit>
80106465:	e9 1e ff ff ff       	jmp    80106388 <trap+0x118>
8010646a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106470:	e8 ab dd ff ff       	call   80104220 <exit>
80106475:	e9 bc fe ff ff       	jmp    80106336 <trap+0xc6>
8010647a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106480:	83 ec 0c             	sub    $0xc,%esp
80106483:	68 80 24 12 80       	push   $0x80122480
80106488:	e8 23 e9 ff ff       	call   80104db0 <acquire>
      wakeup(&ticks);
8010648d:	c7 04 24 c0 2c 12 80 	movl   $0x80122cc0,(%esp)
      ticks++;
80106494:	83 05 c0 2c 12 80 01 	addl   $0x1,0x80122cc0
      wakeup(&ticks);
8010649b:	e8 d0 e0 ff ff       	call   80104570 <wakeup>
      release(&tickslock);
801064a0:	c7 04 24 80 24 12 80 	movl   $0x80122480,(%esp)
801064a7:	e8 24 ea ff ff       	call   80104ed0 <release>
801064ac:	83 c4 10             	add    $0x10,%esp
801064af:	e9 29 ff ff ff       	jmp    801063dd <trap+0x16d>
801064b4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801064b7:	e8 84 d8 ff ff       	call   80103d40 <cpuid>
801064bc:	83 ec 0c             	sub    $0xc,%esp
801064bf:	56                   	push   %esi
801064c0:	53                   	push   %ebx
801064c1:	50                   	push   %eax
801064c2:	ff 77 30             	pushl  0x30(%edi)
801064c5:	68 2c 87 10 80       	push   $0x8010872c
801064ca:	e8 91 a1 ff ff       	call   80100660 <cprintf>
      panic("trap");
801064cf:	83 c4 14             	add    $0x14,%esp
801064d2:	68 02 87 10 80       	push   $0x80108702
801064d7:	e8 b4 9e ff ff       	call   80100390 <panic>
801064dc:	66 90                	xchg   %ax,%ax
801064de:	66 90                	xchg   %ax,%ax

801064e0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801064e0:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
801064e5:	55                   	push   %ebp
801064e6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801064e8:	85 c0                	test   %eax,%eax
801064ea:	74 1c                	je     80106508 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801064ec:	ba fd 03 00 00       	mov    $0x3fd,%edx
801064f1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801064f2:	a8 01                	test   $0x1,%al
801064f4:	74 12                	je     80106508 <uartgetc+0x28>
801064f6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064fb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801064fc:	0f b6 c0             	movzbl %al,%eax
}
801064ff:	5d                   	pop    %ebp
80106500:	c3                   	ret    
80106501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106508:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010650d:	5d                   	pop    %ebp
8010650e:	c3                   	ret    
8010650f:	90                   	nop

80106510 <uartputc.part.0>:
uartputc(int c)
80106510:	55                   	push   %ebp
80106511:	89 e5                	mov    %esp,%ebp
80106513:	57                   	push   %edi
80106514:	56                   	push   %esi
80106515:	53                   	push   %ebx
80106516:	89 c7                	mov    %eax,%edi
80106518:	bb 80 00 00 00       	mov    $0x80,%ebx
8010651d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106522:	83 ec 0c             	sub    $0xc,%esp
80106525:	eb 1b                	jmp    80106542 <uartputc.part.0+0x32>
80106527:	89 f6                	mov    %esi,%esi
80106529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106530:	83 ec 0c             	sub    $0xc,%esp
80106533:	6a 0a                	push   $0xa
80106535:	e8 46 c7 ff ff       	call   80102c80 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010653a:	83 c4 10             	add    $0x10,%esp
8010653d:	83 eb 01             	sub    $0x1,%ebx
80106540:	74 07                	je     80106549 <uartputc.part.0+0x39>
80106542:	89 f2                	mov    %esi,%edx
80106544:	ec                   	in     (%dx),%al
80106545:	a8 20                	test   $0x20,%al
80106547:	74 e7                	je     80106530 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106549:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010654e:	89 f8                	mov    %edi,%eax
80106550:	ee                   	out    %al,(%dx)
}
80106551:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106554:	5b                   	pop    %ebx
80106555:	5e                   	pop    %esi
80106556:	5f                   	pop    %edi
80106557:	5d                   	pop    %ebp
80106558:	c3                   	ret    
80106559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106560 <uartinit>:
{
80106560:	55                   	push   %ebp
80106561:	31 c9                	xor    %ecx,%ecx
80106563:	89 c8                	mov    %ecx,%eax
80106565:	89 e5                	mov    %esp,%ebp
80106567:	57                   	push   %edi
80106568:	56                   	push   %esi
80106569:	53                   	push   %ebx
8010656a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010656f:	89 da                	mov    %ebx,%edx
80106571:	83 ec 0c             	sub    $0xc,%esp
80106574:	ee                   	out    %al,(%dx)
80106575:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010657a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010657f:	89 fa                	mov    %edi,%edx
80106581:	ee                   	out    %al,(%dx)
80106582:	b8 0c 00 00 00       	mov    $0xc,%eax
80106587:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010658c:	ee                   	out    %al,(%dx)
8010658d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106592:	89 c8                	mov    %ecx,%eax
80106594:	89 f2                	mov    %esi,%edx
80106596:	ee                   	out    %al,(%dx)
80106597:	b8 03 00 00 00       	mov    $0x3,%eax
8010659c:	89 fa                	mov    %edi,%edx
8010659e:	ee                   	out    %al,(%dx)
8010659f:	ba fc 03 00 00       	mov    $0x3fc,%edx
801065a4:	89 c8                	mov    %ecx,%eax
801065a6:	ee                   	out    %al,(%dx)
801065a7:	b8 01 00 00 00       	mov    $0x1,%eax
801065ac:	89 f2                	mov    %esi,%edx
801065ae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801065af:	ba fd 03 00 00       	mov    $0x3fd,%edx
801065b4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801065b5:	3c ff                	cmp    $0xff,%al
801065b7:	74 5a                	je     80106613 <uartinit+0xb3>
  uart = 1;
801065b9:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
801065c0:	00 00 00 
801065c3:	89 da                	mov    %ebx,%edx
801065c5:	ec                   	in     (%dx),%al
801065c6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065cb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801065cc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801065cf:	bb 6c 88 10 80       	mov    $0x8010886c,%ebx
  ioapicenable(IRQ_COM1, 0);
801065d4:	6a 00                	push   $0x0
801065d6:	6a 04                	push   $0x4
801065d8:	e8 03 c2 ff ff       	call   801027e0 <ioapicenable>
801065dd:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801065e0:	b8 78 00 00 00       	mov    $0x78,%eax
801065e5:	eb 13                	jmp    801065fa <uartinit+0x9a>
801065e7:	89 f6                	mov    %esi,%esi
801065e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801065f0:	83 c3 01             	add    $0x1,%ebx
801065f3:	0f be 03             	movsbl (%ebx),%eax
801065f6:	84 c0                	test   %al,%al
801065f8:	74 19                	je     80106613 <uartinit+0xb3>
  if(!uart)
801065fa:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106600:	85 d2                	test   %edx,%edx
80106602:	74 ec                	je     801065f0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106604:	83 c3 01             	add    $0x1,%ebx
80106607:	e8 04 ff ff ff       	call   80106510 <uartputc.part.0>
8010660c:	0f be 03             	movsbl (%ebx),%eax
8010660f:	84 c0                	test   %al,%al
80106611:	75 e7                	jne    801065fa <uartinit+0x9a>
}
80106613:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106616:	5b                   	pop    %ebx
80106617:	5e                   	pop    %esi
80106618:	5f                   	pop    %edi
80106619:	5d                   	pop    %ebp
8010661a:	c3                   	ret    
8010661b:	90                   	nop
8010661c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106620 <uartputc>:
  if(!uart)
80106620:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
80106626:	55                   	push   %ebp
80106627:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106629:	85 d2                	test   %edx,%edx
{
8010662b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010662e:	74 10                	je     80106640 <uartputc+0x20>
}
80106630:	5d                   	pop    %ebp
80106631:	e9 da fe ff ff       	jmp    80106510 <uartputc.part.0>
80106636:	8d 76 00             	lea    0x0(%esi),%esi
80106639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106640:	5d                   	pop    %ebp
80106641:	c3                   	ret    
80106642:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106650 <uartintr>:

void
uartintr(void)
{
80106650:	55                   	push   %ebp
80106651:	89 e5                	mov    %esp,%ebp
80106653:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106656:	68 e0 64 10 80       	push   $0x801064e0
8010665b:	e8 b0 a1 ff ff       	call   80100810 <consoleintr>
}
80106660:	83 c4 10             	add    $0x10,%esp
80106663:	c9                   	leave  
80106664:	c3                   	ret    

80106665 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106665:	6a 00                	push   $0x0
  pushl $0
80106667:	6a 00                	push   $0x0
  jmp alltraps
80106669:	e9 29 fb ff ff       	jmp    80106197 <alltraps>

8010666e <vector1>:
.globl vector1
vector1:
  pushl $0
8010666e:	6a 00                	push   $0x0
  pushl $1
80106670:	6a 01                	push   $0x1
  jmp alltraps
80106672:	e9 20 fb ff ff       	jmp    80106197 <alltraps>

80106677 <vector2>:
.globl vector2
vector2:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $2
80106679:	6a 02                	push   $0x2
  jmp alltraps
8010667b:	e9 17 fb ff ff       	jmp    80106197 <alltraps>

80106680 <vector3>:
.globl vector3
vector3:
  pushl $0
80106680:	6a 00                	push   $0x0
  pushl $3
80106682:	6a 03                	push   $0x3
  jmp alltraps
80106684:	e9 0e fb ff ff       	jmp    80106197 <alltraps>

80106689 <vector4>:
.globl vector4
vector4:
  pushl $0
80106689:	6a 00                	push   $0x0
  pushl $4
8010668b:	6a 04                	push   $0x4
  jmp alltraps
8010668d:	e9 05 fb ff ff       	jmp    80106197 <alltraps>

80106692 <vector5>:
.globl vector5
vector5:
  pushl $0
80106692:	6a 00                	push   $0x0
  pushl $5
80106694:	6a 05                	push   $0x5
  jmp alltraps
80106696:	e9 fc fa ff ff       	jmp    80106197 <alltraps>

8010669b <vector6>:
.globl vector6
vector6:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $6
8010669d:	6a 06                	push   $0x6
  jmp alltraps
8010669f:	e9 f3 fa ff ff       	jmp    80106197 <alltraps>

801066a4 <vector7>:
.globl vector7
vector7:
  pushl $0
801066a4:	6a 00                	push   $0x0
  pushl $7
801066a6:	6a 07                	push   $0x7
  jmp alltraps
801066a8:	e9 ea fa ff ff       	jmp    80106197 <alltraps>

801066ad <vector8>:
.globl vector8
vector8:
  pushl $8
801066ad:	6a 08                	push   $0x8
  jmp alltraps
801066af:	e9 e3 fa ff ff       	jmp    80106197 <alltraps>

801066b4 <vector9>:
.globl vector9
vector9:
  pushl $0
801066b4:	6a 00                	push   $0x0
  pushl $9
801066b6:	6a 09                	push   $0x9
  jmp alltraps
801066b8:	e9 da fa ff ff       	jmp    80106197 <alltraps>

801066bd <vector10>:
.globl vector10
vector10:
  pushl $10
801066bd:	6a 0a                	push   $0xa
  jmp alltraps
801066bf:	e9 d3 fa ff ff       	jmp    80106197 <alltraps>

801066c4 <vector11>:
.globl vector11
vector11:
  pushl $11
801066c4:	6a 0b                	push   $0xb
  jmp alltraps
801066c6:	e9 cc fa ff ff       	jmp    80106197 <alltraps>

801066cb <vector12>:
.globl vector12
vector12:
  pushl $12
801066cb:	6a 0c                	push   $0xc
  jmp alltraps
801066cd:	e9 c5 fa ff ff       	jmp    80106197 <alltraps>

801066d2 <vector13>:
.globl vector13
vector13:
  pushl $13
801066d2:	6a 0d                	push   $0xd
  jmp alltraps
801066d4:	e9 be fa ff ff       	jmp    80106197 <alltraps>

801066d9 <vector14>:
.globl vector14
vector14:
  pushl $14
801066d9:	6a 0e                	push   $0xe
  jmp alltraps
801066db:	e9 b7 fa ff ff       	jmp    80106197 <alltraps>

801066e0 <vector15>:
.globl vector15
vector15:
  pushl $0
801066e0:	6a 00                	push   $0x0
  pushl $15
801066e2:	6a 0f                	push   $0xf
  jmp alltraps
801066e4:	e9 ae fa ff ff       	jmp    80106197 <alltraps>

801066e9 <vector16>:
.globl vector16
vector16:
  pushl $0
801066e9:	6a 00                	push   $0x0
  pushl $16
801066eb:	6a 10                	push   $0x10
  jmp alltraps
801066ed:	e9 a5 fa ff ff       	jmp    80106197 <alltraps>

801066f2 <vector17>:
.globl vector17
vector17:
  pushl $17
801066f2:	6a 11                	push   $0x11
  jmp alltraps
801066f4:	e9 9e fa ff ff       	jmp    80106197 <alltraps>

801066f9 <vector18>:
.globl vector18
vector18:
  pushl $0
801066f9:	6a 00                	push   $0x0
  pushl $18
801066fb:	6a 12                	push   $0x12
  jmp alltraps
801066fd:	e9 95 fa ff ff       	jmp    80106197 <alltraps>

80106702 <vector19>:
.globl vector19
vector19:
  pushl $0
80106702:	6a 00                	push   $0x0
  pushl $19
80106704:	6a 13                	push   $0x13
  jmp alltraps
80106706:	e9 8c fa ff ff       	jmp    80106197 <alltraps>

8010670b <vector20>:
.globl vector20
vector20:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $20
8010670d:	6a 14                	push   $0x14
  jmp alltraps
8010670f:	e9 83 fa ff ff       	jmp    80106197 <alltraps>

80106714 <vector21>:
.globl vector21
vector21:
  pushl $0
80106714:	6a 00                	push   $0x0
  pushl $21
80106716:	6a 15                	push   $0x15
  jmp alltraps
80106718:	e9 7a fa ff ff       	jmp    80106197 <alltraps>

8010671d <vector22>:
.globl vector22
vector22:
  pushl $0
8010671d:	6a 00                	push   $0x0
  pushl $22
8010671f:	6a 16                	push   $0x16
  jmp alltraps
80106721:	e9 71 fa ff ff       	jmp    80106197 <alltraps>

80106726 <vector23>:
.globl vector23
vector23:
  pushl $0
80106726:	6a 00                	push   $0x0
  pushl $23
80106728:	6a 17                	push   $0x17
  jmp alltraps
8010672a:	e9 68 fa ff ff       	jmp    80106197 <alltraps>

8010672f <vector24>:
.globl vector24
vector24:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $24
80106731:	6a 18                	push   $0x18
  jmp alltraps
80106733:	e9 5f fa ff ff       	jmp    80106197 <alltraps>

80106738 <vector25>:
.globl vector25
vector25:
  pushl $0
80106738:	6a 00                	push   $0x0
  pushl $25
8010673a:	6a 19                	push   $0x19
  jmp alltraps
8010673c:	e9 56 fa ff ff       	jmp    80106197 <alltraps>

80106741 <vector26>:
.globl vector26
vector26:
  pushl $0
80106741:	6a 00                	push   $0x0
  pushl $26
80106743:	6a 1a                	push   $0x1a
  jmp alltraps
80106745:	e9 4d fa ff ff       	jmp    80106197 <alltraps>

8010674a <vector27>:
.globl vector27
vector27:
  pushl $0
8010674a:	6a 00                	push   $0x0
  pushl $27
8010674c:	6a 1b                	push   $0x1b
  jmp alltraps
8010674e:	e9 44 fa ff ff       	jmp    80106197 <alltraps>

80106753 <vector28>:
.globl vector28
vector28:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $28
80106755:	6a 1c                	push   $0x1c
  jmp alltraps
80106757:	e9 3b fa ff ff       	jmp    80106197 <alltraps>

8010675c <vector29>:
.globl vector29
vector29:
  pushl $0
8010675c:	6a 00                	push   $0x0
  pushl $29
8010675e:	6a 1d                	push   $0x1d
  jmp alltraps
80106760:	e9 32 fa ff ff       	jmp    80106197 <alltraps>

80106765 <vector30>:
.globl vector30
vector30:
  pushl $0
80106765:	6a 00                	push   $0x0
  pushl $30
80106767:	6a 1e                	push   $0x1e
  jmp alltraps
80106769:	e9 29 fa ff ff       	jmp    80106197 <alltraps>

8010676e <vector31>:
.globl vector31
vector31:
  pushl $0
8010676e:	6a 00                	push   $0x0
  pushl $31
80106770:	6a 1f                	push   $0x1f
  jmp alltraps
80106772:	e9 20 fa ff ff       	jmp    80106197 <alltraps>

80106777 <vector32>:
.globl vector32
vector32:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $32
80106779:	6a 20                	push   $0x20
  jmp alltraps
8010677b:	e9 17 fa ff ff       	jmp    80106197 <alltraps>

80106780 <vector33>:
.globl vector33
vector33:
  pushl $0
80106780:	6a 00                	push   $0x0
  pushl $33
80106782:	6a 21                	push   $0x21
  jmp alltraps
80106784:	e9 0e fa ff ff       	jmp    80106197 <alltraps>

80106789 <vector34>:
.globl vector34
vector34:
  pushl $0
80106789:	6a 00                	push   $0x0
  pushl $34
8010678b:	6a 22                	push   $0x22
  jmp alltraps
8010678d:	e9 05 fa ff ff       	jmp    80106197 <alltraps>

80106792 <vector35>:
.globl vector35
vector35:
  pushl $0
80106792:	6a 00                	push   $0x0
  pushl $35
80106794:	6a 23                	push   $0x23
  jmp alltraps
80106796:	e9 fc f9 ff ff       	jmp    80106197 <alltraps>

8010679b <vector36>:
.globl vector36
vector36:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $36
8010679d:	6a 24                	push   $0x24
  jmp alltraps
8010679f:	e9 f3 f9 ff ff       	jmp    80106197 <alltraps>

801067a4 <vector37>:
.globl vector37
vector37:
  pushl $0
801067a4:	6a 00                	push   $0x0
  pushl $37
801067a6:	6a 25                	push   $0x25
  jmp alltraps
801067a8:	e9 ea f9 ff ff       	jmp    80106197 <alltraps>

801067ad <vector38>:
.globl vector38
vector38:
  pushl $0
801067ad:	6a 00                	push   $0x0
  pushl $38
801067af:	6a 26                	push   $0x26
  jmp alltraps
801067b1:	e9 e1 f9 ff ff       	jmp    80106197 <alltraps>

801067b6 <vector39>:
.globl vector39
vector39:
  pushl $0
801067b6:	6a 00                	push   $0x0
  pushl $39
801067b8:	6a 27                	push   $0x27
  jmp alltraps
801067ba:	e9 d8 f9 ff ff       	jmp    80106197 <alltraps>

801067bf <vector40>:
.globl vector40
vector40:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $40
801067c1:	6a 28                	push   $0x28
  jmp alltraps
801067c3:	e9 cf f9 ff ff       	jmp    80106197 <alltraps>

801067c8 <vector41>:
.globl vector41
vector41:
  pushl $0
801067c8:	6a 00                	push   $0x0
  pushl $41
801067ca:	6a 29                	push   $0x29
  jmp alltraps
801067cc:	e9 c6 f9 ff ff       	jmp    80106197 <alltraps>

801067d1 <vector42>:
.globl vector42
vector42:
  pushl $0
801067d1:	6a 00                	push   $0x0
  pushl $42
801067d3:	6a 2a                	push   $0x2a
  jmp alltraps
801067d5:	e9 bd f9 ff ff       	jmp    80106197 <alltraps>

801067da <vector43>:
.globl vector43
vector43:
  pushl $0
801067da:	6a 00                	push   $0x0
  pushl $43
801067dc:	6a 2b                	push   $0x2b
  jmp alltraps
801067de:	e9 b4 f9 ff ff       	jmp    80106197 <alltraps>

801067e3 <vector44>:
.globl vector44
vector44:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $44
801067e5:	6a 2c                	push   $0x2c
  jmp alltraps
801067e7:	e9 ab f9 ff ff       	jmp    80106197 <alltraps>

801067ec <vector45>:
.globl vector45
vector45:
  pushl $0
801067ec:	6a 00                	push   $0x0
  pushl $45
801067ee:	6a 2d                	push   $0x2d
  jmp alltraps
801067f0:	e9 a2 f9 ff ff       	jmp    80106197 <alltraps>

801067f5 <vector46>:
.globl vector46
vector46:
  pushl $0
801067f5:	6a 00                	push   $0x0
  pushl $46
801067f7:	6a 2e                	push   $0x2e
  jmp alltraps
801067f9:	e9 99 f9 ff ff       	jmp    80106197 <alltraps>

801067fe <vector47>:
.globl vector47
vector47:
  pushl $0
801067fe:	6a 00                	push   $0x0
  pushl $47
80106800:	6a 2f                	push   $0x2f
  jmp alltraps
80106802:	e9 90 f9 ff ff       	jmp    80106197 <alltraps>

80106807 <vector48>:
.globl vector48
vector48:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $48
80106809:	6a 30                	push   $0x30
  jmp alltraps
8010680b:	e9 87 f9 ff ff       	jmp    80106197 <alltraps>

80106810 <vector49>:
.globl vector49
vector49:
  pushl $0
80106810:	6a 00                	push   $0x0
  pushl $49
80106812:	6a 31                	push   $0x31
  jmp alltraps
80106814:	e9 7e f9 ff ff       	jmp    80106197 <alltraps>

80106819 <vector50>:
.globl vector50
vector50:
  pushl $0
80106819:	6a 00                	push   $0x0
  pushl $50
8010681b:	6a 32                	push   $0x32
  jmp alltraps
8010681d:	e9 75 f9 ff ff       	jmp    80106197 <alltraps>

80106822 <vector51>:
.globl vector51
vector51:
  pushl $0
80106822:	6a 00                	push   $0x0
  pushl $51
80106824:	6a 33                	push   $0x33
  jmp alltraps
80106826:	e9 6c f9 ff ff       	jmp    80106197 <alltraps>

8010682b <vector52>:
.globl vector52
vector52:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $52
8010682d:	6a 34                	push   $0x34
  jmp alltraps
8010682f:	e9 63 f9 ff ff       	jmp    80106197 <alltraps>

80106834 <vector53>:
.globl vector53
vector53:
  pushl $0
80106834:	6a 00                	push   $0x0
  pushl $53
80106836:	6a 35                	push   $0x35
  jmp alltraps
80106838:	e9 5a f9 ff ff       	jmp    80106197 <alltraps>

8010683d <vector54>:
.globl vector54
vector54:
  pushl $0
8010683d:	6a 00                	push   $0x0
  pushl $54
8010683f:	6a 36                	push   $0x36
  jmp alltraps
80106841:	e9 51 f9 ff ff       	jmp    80106197 <alltraps>

80106846 <vector55>:
.globl vector55
vector55:
  pushl $0
80106846:	6a 00                	push   $0x0
  pushl $55
80106848:	6a 37                	push   $0x37
  jmp alltraps
8010684a:	e9 48 f9 ff ff       	jmp    80106197 <alltraps>

8010684f <vector56>:
.globl vector56
vector56:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $56
80106851:	6a 38                	push   $0x38
  jmp alltraps
80106853:	e9 3f f9 ff ff       	jmp    80106197 <alltraps>

80106858 <vector57>:
.globl vector57
vector57:
  pushl $0
80106858:	6a 00                	push   $0x0
  pushl $57
8010685a:	6a 39                	push   $0x39
  jmp alltraps
8010685c:	e9 36 f9 ff ff       	jmp    80106197 <alltraps>

80106861 <vector58>:
.globl vector58
vector58:
  pushl $0
80106861:	6a 00                	push   $0x0
  pushl $58
80106863:	6a 3a                	push   $0x3a
  jmp alltraps
80106865:	e9 2d f9 ff ff       	jmp    80106197 <alltraps>

8010686a <vector59>:
.globl vector59
vector59:
  pushl $0
8010686a:	6a 00                	push   $0x0
  pushl $59
8010686c:	6a 3b                	push   $0x3b
  jmp alltraps
8010686e:	e9 24 f9 ff ff       	jmp    80106197 <alltraps>

80106873 <vector60>:
.globl vector60
vector60:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $60
80106875:	6a 3c                	push   $0x3c
  jmp alltraps
80106877:	e9 1b f9 ff ff       	jmp    80106197 <alltraps>

8010687c <vector61>:
.globl vector61
vector61:
  pushl $0
8010687c:	6a 00                	push   $0x0
  pushl $61
8010687e:	6a 3d                	push   $0x3d
  jmp alltraps
80106880:	e9 12 f9 ff ff       	jmp    80106197 <alltraps>

80106885 <vector62>:
.globl vector62
vector62:
  pushl $0
80106885:	6a 00                	push   $0x0
  pushl $62
80106887:	6a 3e                	push   $0x3e
  jmp alltraps
80106889:	e9 09 f9 ff ff       	jmp    80106197 <alltraps>

8010688e <vector63>:
.globl vector63
vector63:
  pushl $0
8010688e:	6a 00                	push   $0x0
  pushl $63
80106890:	6a 3f                	push   $0x3f
  jmp alltraps
80106892:	e9 00 f9 ff ff       	jmp    80106197 <alltraps>

80106897 <vector64>:
.globl vector64
vector64:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $64
80106899:	6a 40                	push   $0x40
  jmp alltraps
8010689b:	e9 f7 f8 ff ff       	jmp    80106197 <alltraps>

801068a0 <vector65>:
.globl vector65
vector65:
  pushl $0
801068a0:	6a 00                	push   $0x0
  pushl $65
801068a2:	6a 41                	push   $0x41
  jmp alltraps
801068a4:	e9 ee f8 ff ff       	jmp    80106197 <alltraps>

801068a9 <vector66>:
.globl vector66
vector66:
  pushl $0
801068a9:	6a 00                	push   $0x0
  pushl $66
801068ab:	6a 42                	push   $0x42
  jmp alltraps
801068ad:	e9 e5 f8 ff ff       	jmp    80106197 <alltraps>

801068b2 <vector67>:
.globl vector67
vector67:
  pushl $0
801068b2:	6a 00                	push   $0x0
  pushl $67
801068b4:	6a 43                	push   $0x43
  jmp alltraps
801068b6:	e9 dc f8 ff ff       	jmp    80106197 <alltraps>

801068bb <vector68>:
.globl vector68
vector68:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $68
801068bd:	6a 44                	push   $0x44
  jmp alltraps
801068bf:	e9 d3 f8 ff ff       	jmp    80106197 <alltraps>

801068c4 <vector69>:
.globl vector69
vector69:
  pushl $0
801068c4:	6a 00                	push   $0x0
  pushl $69
801068c6:	6a 45                	push   $0x45
  jmp alltraps
801068c8:	e9 ca f8 ff ff       	jmp    80106197 <alltraps>

801068cd <vector70>:
.globl vector70
vector70:
  pushl $0
801068cd:	6a 00                	push   $0x0
  pushl $70
801068cf:	6a 46                	push   $0x46
  jmp alltraps
801068d1:	e9 c1 f8 ff ff       	jmp    80106197 <alltraps>

801068d6 <vector71>:
.globl vector71
vector71:
  pushl $0
801068d6:	6a 00                	push   $0x0
  pushl $71
801068d8:	6a 47                	push   $0x47
  jmp alltraps
801068da:	e9 b8 f8 ff ff       	jmp    80106197 <alltraps>

801068df <vector72>:
.globl vector72
vector72:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $72
801068e1:	6a 48                	push   $0x48
  jmp alltraps
801068e3:	e9 af f8 ff ff       	jmp    80106197 <alltraps>

801068e8 <vector73>:
.globl vector73
vector73:
  pushl $0
801068e8:	6a 00                	push   $0x0
  pushl $73
801068ea:	6a 49                	push   $0x49
  jmp alltraps
801068ec:	e9 a6 f8 ff ff       	jmp    80106197 <alltraps>

801068f1 <vector74>:
.globl vector74
vector74:
  pushl $0
801068f1:	6a 00                	push   $0x0
  pushl $74
801068f3:	6a 4a                	push   $0x4a
  jmp alltraps
801068f5:	e9 9d f8 ff ff       	jmp    80106197 <alltraps>

801068fa <vector75>:
.globl vector75
vector75:
  pushl $0
801068fa:	6a 00                	push   $0x0
  pushl $75
801068fc:	6a 4b                	push   $0x4b
  jmp alltraps
801068fe:	e9 94 f8 ff ff       	jmp    80106197 <alltraps>

80106903 <vector76>:
.globl vector76
vector76:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $76
80106905:	6a 4c                	push   $0x4c
  jmp alltraps
80106907:	e9 8b f8 ff ff       	jmp    80106197 <alltraps>

8010690c <vector77>:
.globl vector77
vector77:
  pushl $0
8010690c:	6a 00                	push   $0x0
  pushl $77
8010690e:	6a 4d                	push   $0x4d
  jmp alltraps
80106910:	e9 82 f8 ff ff       	jmp    80106197 <alltraps>

80106915 <vector78>:
.globl vector78
vector78:
  pushl $0
80106915:	6a 00                	push   $0x0
  pushl $78
80106917:	6a 4e                	push   $0x4e
  jmp alltraps
80106919:	e9 79 f8 ff ff       	jmp    80106197 <alltraps>

8010691e <vector79>:
.globl vector79
vector79:
  pushl $0
8010691e:	6a 00                	push   $0x0
  pushl $79
80106920:	6a 4f                	push   $0x4f
  jmp alltraps
80106922:	e9 70 f8 ff ff       	jmp    80106197 <alltraps>

80106927 <vector80>:
.globl vector80
vector80:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $80
80106929:	6a 50                	push   $0x50
  jmp alltraps
8010692b:	e9 67 f8 ff ff       	jmp    80106197 <alltraps>

80106930 <vector81>:
.globl vector81
vector81:
  pushl $0
80106930:	6a 00                	push   $0x0
  pushl $81
80106932:	6a 51                	push   $0x51
  jmp alltraps
80106934:	e9 5e f8 ff ff       	jmp    80106197 <alltraps>

80106939 <vector82>:
.globl vector82
vector82:
  pushl $0
80106939:	6a 00                	push   $0x0
  pushl $82
8010693b:	6a 52                	push   $0x52
  jmp alltraps
8010693d:	e9 55 f8 ff ff       	jmp    80106197 <alltraps>

80106942 <vector83>:
.globl vector83
vector83:
  pushl $0
80106942:	6a 00                	push   $0x0
  pushl $83
80106944:	6a 53                	push   $0x53
  jmp alltraps
80106946:	e9 4c f8 ff ff       	jmp    80106197 <alltraps>

8010694b <vector84>:
.globl vector84
vector84:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $84
8010694d:	6a 54                	push   $0x54
  jmp alltraps
8010694f:	e9 43 f8 ff ff       	jmp    80106197 <alltraps>

80106954 <vector85>:
.globl vector85
vector85:
  pushl $0
80106954:	6a 00                	push   $0x0
  pushl $85
80106956:	6a 55                	push   $0x55
  jmp alltraps
80106958:	e9 3a f8 ff ff       	jmp    80106197 <alltraps>

8010695d <vector86>:
.globl vector86
vector86:
  pushl $0
8010695d:	6a 00                	push   $0x0
  pushl $86
8010695f:	6a 56                	push   $0x56
  jmp alltraps
80106961:	e9 31 f8 ff ff       	jmp    80106197 <alltraps>

80106966 <vector87>:
.globl vector87
vector87:
  pushl $0
80106966:	6a 00                	push   $0x0
  pushl $87
80106968:	6a 57                	push   $0x57
  jmp alltraps
8010696a:	e9 28 f8 ff ff       	jmp    80106197 <alltraps>

8010696f <vector88>:
.globl vector88
vector88:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $88
80106971:	6a 58                	push   $0x58
  jmp alltraps
80106973:	e9 1f f8 ff ff       	jmp    80106197 <alltraps>

80106978 <vector89>:
.globl vector89
vector89:
  pushl $0
80106978:	6a 00                	push   $0x0
  pushl $89
8010697a:	6a 59                	push   $0x59
  jmp alltraps
8010697c:	e9 16 f8 ff ff       	jmp    80106197 <alltraps>

80106981 <vector90>:
.globl vector90
vector90:
  pushl $0
80106981:	6a 00                	push   $0x0
  pushl $90
80106983:	6a 5a                	push   $0x5a
  jmp alltraps
80106985:	e9 0d f8 ff ff       	jmp    80106197 <alltraps>

8010698a <vector91>:
.globl vector91
vector91:
  pushl $0
8010698a:	6a 00                	push   $0x0
  pushl $91
8010698c:	6a 5b                	push   $0x5b
  jmp alltraps
8010698e:	e9 04 f8 ff ff       	jmp    80106197 <alltraps>

80106993 <vector92>:
.globl vector92
vector92:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $92
80106995:	6a 5c                	push   $0x5c
  jmp alltraps
80106997:	e9 fb f7 ff ff       	jmp    80106197 <alltraps>

8010699c <vector93>:
.globl vector93
vector93:
  pushl $0
8010699c:	6a 00                	push   $0x0
  pushl $93
8010699e:	6a 5d                	push   $0x5d
  jmp alltraps
801069a0:	e9 f2 f7 ff ff       	jmp    80106197 <alltraps>

801069a5 <vector94>:
.globl vector94
vector94:
  pushl $0
801069a5:	6a 00                	push   $0x0
  pushl $94
801069a7:	6a 5e                	push   $0x5e
  jmp alltraps
801069a9:	e9 e9 f7 ff ff       	jmp    80106197 <alltraps>

801069ae <vector95>:
.globl vector95
vector95:
  pushl $0
801069ae:	6a 00                	push   $0x0
  pushl $95
801069b0:	6a 5f                	push   $0x5f
  jmp alltraps
801069b2:	e9 e0 f7 ff ff       	jmp    80106197 <alltraps>

801069b7 <vector96>:
.globl vector96
vector96:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $96
801069b9:	6a 60                	push   $0x60
  jmp alltraps
801069bb:	e9 d7 f7 ff ff       	jmp    80106197 <alltraps>

801069c0 <vector97>:
.globl vector97
vector97:
  pushl $0
801069c0:	6a 00                	push   $0x0
  pushl $97
801069c2:	6a 61                	push   $0x61
  jmp alltraps
801069c4:	e9 ce f7 ff ff       	jmp    80106197 <alltraps>

801069c9 <vector98>:
.globl vector98
vector98:
  pushl $0
801069c9:	6a 00                	push   $0x0
  pushl $98
801069cb:	6a 62                	push   $0x62
  jmp alltraps
801069cd:	e9 c5 f7 ff ff       	jmp    80106197 <alltraps>

801069d2 <vector99>:
.globl vector99
vector99:
  pushl $0
801069d2:	6a 00                	push   $0x0
  pushl $99
801069d4:	6a 63                	push   $0x63
  jmp alltraps
801069d6:	e9 bc f7 ff ff       	jmp    80106197 <alltraps>

801069db <vector100>:
.globl vector100
vector100:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $100
801069dd:	6a 64                	push   $0x64
  jmp alltraps
801069df:	e9 b3 f7 ff ff       	jmp    80106197 <alltraps>

801069e4 <vector101>:
.globl vector101
vector101:
  pushl $0
801069e4:	6a 00                	push   $0x0
  pushl $101
801069e6:	6a 65                	push   $0x65
  jmp alltraps
801069e8:	e9 aa f7 ff ff       	jmp    80106197 <alltraps>

801069ed <vector102>:
.globl vector102
vector102:
  pushl $0
801069ed:	6a 00                	push   $0x0
  pushl $102
801069ef:	6a 66                	push   $0x66
  jmp alltraps
801069f1:	e9 a1 f7 ff ff       	jmp    80106197 <alltraps>

801069f6 <vector103>:
.globl vector103
vector103:
  pushl $0
801069f6:	6a 00                	push   $0x0
  pushl $103
801069f8:	6a 67                	push   $0x67
  jmp alltraps
801069fa:	e9 98 f7 ff ff       	jmp    80106197 <alltraps>

801069ff <vector104>:
.globl vector104
vector104:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $104
80106a01:	6a 68                	push   $0x68
  jmp alltraps
80106a03:	e9 8f f7 ff ff       	jmp    80106197 <alltraps>

80106a08 <vector105>:
.globl vector105
vector105:
  pushl $0
80106a08:	6a 00                	push   $0x0
  pushl $105
80106a0a:	6a 69                	push   $0x69
  jmp alltraps
80106a0c:	e9 86 f7 ff ff       	jmp    80106197 <alltraps>

80106a11 <vector106>:
.globl vector106
vector106:
  pushl $0
80106a11:	6a 00                	push   $0x0
  pushl $106
80106a13:	6a 6a                	push   $0x6a
  jmp alltraps
80106a15:	e9 7d f7 ff ff       	jmp    80106197 <alltraps>

80106a1a <vector107>:
.globl vector107
vector107:
  pushl $0
80106a1a:	6a 00                	push   $0x0
  pushl $107
80106a1c:	6a 6b                	push   $0x6b
  jmp alltraps
80106a1e:	e9 74 f7 ff ff       	jmp    80106197 <alltraps>

80106a23 <vector108>:
.globl vector108
vector108:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $108
80106a25:	6a 6c                	push   $0x6c
  jmp alltraps
80106a27:	e9 6b f7 ff ff       	jmp    80106197 <alltraps>

80106a2c <vector109>:
.globl vector109
vector109:
  pushl $0
80106a2c:	6a 00                	push   $0x0
  pushl $109
80106a2e:	6a 6d                	push   $0x6d
  jmp alltraps
80106a30:	e9 62 f7 ff ff       	jmp    80106197 <alltraps>

80106a35 <vector110>:
.globl vector110
vector110:
  pushl $0
80106a35:	6a 00                	push   $0x0
  pushl $110
80106a37:	6a 6e                	push   $0x6e
  jmp alltraps
80106a39:	e9 59 f7 ff ff       	jmp    80106197 <alltraps>

80106a3e <vector111>:
.globl vector111
vector111:
  pushl $0
80106a3e:	6a 00                	push   $0x0
  pushl $111
80106a40:	6a 6f                	push   $0x6f
  jmp alltraps
80106a42:	e9 50 f7 ff ff       	jmp    80106197 <alltraps>

80106a47 <vector112>:
.globl vector112
vector112:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $112
80106a49:	6a 70                	push   $0x70
  jmp alltraps
80106a4b:	e9 47 f7 ff ff       	jmp    80106197 <alltraps>

80106a50 <vector113>:
.globl vector113
vector113:
  pushl $0
80106a50:	6a 00                	push   $0x0
  pushl $113
80106a52:	6a 71                	push   $0x71
  jmp alltraps
80106a54:	e9 3e f7 ff ff       	jmp    80106197 <alltraps>

80106a59 <vector114>:
.globl vector114
vector114:
  pushl $0
80106a59:	6a 00                	push   $0x0
  pushl $114
80106a5b:	6a 72                	push   $0x72
  jmp alltraps
80106a5d:	e9 35 f7 ff ff       	jmp    80106197 <alltraps>

80106a62 <vector115>:
.globl vector115
vector115:
  pushl $0
80106a62:	6a 00                	push   $0x0
  pushl $115
80106a64:	6a 73                	push   $0x73
  jmp alltraps
80106a66:	e9 2c f7 ff ff       	jmp    80106197 <alltraps>

80106a6b <vector116>:
.globl vector116
vector116:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $116
80106a6d:	6a 74                	push   $0x74
  jmp alltraps
80106a6f:	e9 23 f7 ff ff       	jmp    80106197 <alltraps>

80106a74 <vector117>:
.globl vector117
vector117:
  pushl $0
80106a74:	6a 00                	push   $0x0
  pushl $117
80106a76:	6a 75                	push   $0x75
  jmp alltraps
80106a78:	e9 1a f7 ff ff       	jmp    80106197 <alltraps>

80106a7d <vector118>:
.globl vector118
vector118:
  pushl $0
80106a7d:	6a 00                	push   $0x0
  pushl $118
80106a7f:	6a 76                	push   $0x76
  jmp alltraps
80106a81:	e9 11 f7 ff ff       	jmp    80106197 <alltraps>

80106a86 <vector119>:
.globl vector119
vector119:
  pushl $0
80106a86:	6a 00                	push   $0x0
  pushl $119
80106a88:	6a 77                	push   $0x77
  jmp alltraps
80106a8a:	e9 08 f7 ff ff       	jmp    80106197 <alltraps>

80106a8f <vector120>:
.globl vector120
vector120:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $120
80106a91:	6a 78                	push   $0x78
  jmp alltraps
80106a93:	e9 ff f6 ff ff       	jmp    80106197 <alltraps>

80106a98 <vector121>:
.globl vector121
vector121:
  pushl $0
80106a98:	6a 00                	push   $0x0
  pushl $121
80106a9a:	6a 79                	push   $0x79
  jmp alltraps
80106a9c:	e9 f6 f6 ff ff       	jmp    80106197 <alltraps>

80106aa1 <vector122>:
.globl vector122
vector122:
  pushl $0
80106aa1:	6a 00                	push   $0x0
  pushl $122
80106aa3:	6a 7a                	push   $0x7a
  jmp alltraps
80106aa5:	e9 ed f6 ff ff       	jmp    80106197 <alltraps>

80106aaa <vector123>:
.globl vector123
vector123:
  pushl $0
80106aaa:	6a 00                	push   $0x0
  pushl $123
80106aac:	6a 7b                	push   $0x7b
  jmp alltraps
80106aae:	e9 e4 f6 ff ff       	jmp    80106197 <alltraps>

80106ab3 <vector124>:
.globl vector124
vector124:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $124
80106ab5:	6a 7c                	push   $0x7c
  jmp alltraps
80106ab7:	e9 db f6 ff ff       	jmp    80106197 <alltraps>

80106abc <vector125>:
.globl vector125
vector125:
  pushl $0
80106abc:	6a 00                	push   $0x0
  pushl $125
80106abe:	6a 7d                	push   $0x7d
  jmp alltraps
80106ac0:	e9 d2 f6 ff ff       	jmp    80106197 <alltraps>

80106ac5 <vector126>:
.globl vector126
vector126:
  pushl $0
80106ac5:	6a 00                	push   $0x0
  pushl $126
80106ac7:	6a 7e                	push   $0x7e
  jmp alltraps
80106ac9:	e9 c9 f6 ff ff       	jmp    80106197 <alltraps>

80106ace <vector127>:
.globl vector127
vector127:
  pushl $0
80106ace:	6a 00                	push   $0x0
  pushl $127
80106ad0:	6a 7f                	push   $0x7f
  jmp alltraps
80106ad2:	e9 c0 f6 ff ff       	jmp    80106197 <alltraps>

80106ad7 <vector128>:
.globl vector128
vector128:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $128
80106ad9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106ade:	e9 b4 f6 ff ff       	jmp    80106197 <alltraps>

80106ae3 <vector129>:
.globl vector129
vector129:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $129
80106ae5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106aea:	e9 a8 f6 ff ff       	jmp    80106197 <alltraps>

80106aef <vector130>:
.globl vector130
vector130:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $130
80106af1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106af6:	e9 9c f6 ff ff       	jmp    80106197 <alltraps>

80106afb <vector131>:
.globl vector131
vector131:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $131
80106afd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106b02:	e9 90 f6 ff ff       	jmp    80106197 <alltraps>

80106b07 <vector132>:
.globl vector132
vector132:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $132
80106b09:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106b0e:	e9 84 f6 ff ff       	jmp    80106197 <alltraps>

80106b13 <vector133>:
.globl vector133
vector133:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $133
80106b15:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106b1a:	e9 78 f6 ff ff       	jmp    80106197 <alltraps>

80106b1f <vector134>:
.globl vector134
vector134:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $134
80106b21:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106b26:	e9 6c f6 ff ff       	jmp    80106197 <alltraps>

80106b2b <vector135>:
.globl vector135
vector135:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $135
80106b2d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106b32:	e9 60 f6 ff ff       	jmp    80106197 <alltraps>

80106b37 <vector136>:
.globl vector136
vector136:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $136
80106b39:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106b3e:	e9 54 f6 ff ff       	jmp    80106197 <alltraps>

80106b43 <vector137>:
.globl vector137
vector137:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $137
80106b45:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106b4a:	e9 48 f6 ff ff       	jmp    80106197 <alltraps>

80106b4f <vector138>:
.globl vector138
vector138:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $138
80106b51:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106b56:	e9 3c f6 ff ff       	jmp    80106197 <alltraps>

80106b5b <vector139>:
.globl vector139
vector139:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $139
80106b5d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106b62:	e9 30 f6 ff ff       	jmp    80106197 <alltraps>

80106b67 <vector140>:
.globl vector140
vector140:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $140
80106b69:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106b6e:	e9 24 f6 ff ff       	jmp    80106197 <alltraps>

80106b73 <vector141>:
.globl vector141
vector141:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $141
80106b75:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106b7a:	e9 18 f6 ff ff       	jmp    80106197 <alltraps>

80106b7f <vector142>:
.globl vector142
vector142:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $142
80106b81:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106b86:	e9 0c f6 ff ff       	jmp    80106197 <alltraps>

80106b8b <vector143>:
.globl vector143
vector143:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $143
80106b8d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106b92:	e9 00 f6 ff ff       	jmp    80106197 <alltraps>

80106b97 <vector144>:
.globl vector144
vector144:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $144
80106b99:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106b9e:	e9 f4 f5 ff ff       	jmp    80106197 <alltraps>

80106ba3 <vector145>:
.globl vector145
vector145:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $145
80106ba5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106baa:	e9 e8 f5 ff ff       	jmp    80106197 <alltraps>

80106baf <vector146>:
.globl vector146
vector146:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $146
80106bb1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106bb6:	e9 dc f5 ff ff       	jmp    80106197 <alltraps>

80106bbb <vector147>:
.globl vector147
vector147:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $147
80106bbd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106bc2:	e9 d0 f5 ff ff       	jmp    80106197 <alltraps>

80106bc7 <vector148>:
.globl vector148
vector148:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $148
80106bc9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106bce:	e9 c4 f5 ff ff       	jmp    80106197 <alltraps>

80106bd3 <vector149>:
.globl vector149
vector149:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $149
80106bd5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106bda:	e9 b8 f5 ff ff       	jmp    80106197 <alltraps>

80106bdf <vector150>:
.globl vector150
vector150:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $150
80106be1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106be6:	e9 ac f5 ff ff       	jmp    80106197 <alltraps>

80106beb <vector151>:
.globl vector151
vector151:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $151
80106bed:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106bf2:	e9 a0 f5 ff ff       	jmp    80106197 <alltraps>

80106bf7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $152
80106bf9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106bfe:	e9 94 f5 ff ff       	jmp    80106197 <alltraps>

80106c03 <vector153>:
.globl vector153
vector153:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $153
80106c05:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106c0a:	e9 88 f5 ff ff       	jmp    80106197 <alltraps>

80106c0f <vector154>:
.globl vector154
vector154:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $154
80106c11:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106c16:	e9 7c f5 ff ff       	jmp    80106197 <alltraps>

80106c1b <vector155>:
.globl vector155
vector155:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $155
80106c1d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106c22:	e9 70 f5 ff ff       	jmp    80106197 <alltraps>

80106c27 <vector156>:
.globl vector156
vector156:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $156
80106c29:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106c2e:	e9 64 f5 ff ff       	jmp    80106197 <alltraps>

80106c33 <vector157>:
.globl vector157
vector157:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $157
80106c35:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106c3a:	e9 58 f5 ff ff       	jmp    80106197 <alltraps>

80106c3f <vector158>:
.globl vector158
vector158:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $158
80106c41:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106c46:	e9 4c f5 ff ff       	jmp    80106197 <alltraps>

80106c4b <vector159>:
.globl vector159
vector159:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $159
80106c4d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106c52:	e9 40 f5 ff ff       	jmp    80106197 <alltraps>

80106c57 <vector160>:
.globl vector160
vector160:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $160
80106c59:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106c5e:	e9 34 f5 ff ff       	jmp    80106197 <alltraps>

80106c63 <vector161>:
.globl vector161
vector161:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $161
80106c65:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106c6a:	e9 28 f5 ff ff       	jmp    80106197 <alltraps>

80106c6f <vector162>:
.globl vector162
vector162:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $162
80106c71:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106c76:	e9 1c f5 ff ff       	jmp    80106197 <alltraps>

80106c7b <vector163>:
.globl vector163
vector163:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $163
80106c7d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106c82:	e9 10 f5 ff ff       	jmp    80106197 <alltraps>

80106c87 <vector164>:
.globl vector164
vector164:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $164
80106c89:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106c8e:	e9 04 f5 ff ff       	jmp    80106197 <alltraps>

80106c93 <vector165>:
.globl vector165
vector165:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $165
80106c95:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106c9a:	e9 f8 f4 ff ff       	jmp    80106197 <alltraps>

80106c9f <vector166>:
.globl vector166
vector166:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $166
80106ca1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106ca6:	e9 ec f4 ff ff       	jmp    80106197 <alltraps>

80106cab <vector167>:
.globl vector167
vector167:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $167
80106cad:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106cb2:	e9 e0 f4 ff ff       	jmp    80106197 <alltraps>

80106cb7 <vector168>:
.globl vector168
vector168:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $168
80106cb9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106cbe:	e9 d4 f4 ff ff       	jmp    80106197 <alltraps>

80106cc3 <vector169>:
.globl vector169
vector169:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $169
80106cc5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106cca:	e9 c8 f4 ff ff       	jmp    80106197 <alltraps>

80106ccf <vector170>:
.globl vector170
vector170:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $170
80106cd1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106cd6:	e9 bc f4 ff ff       	jmp    80106197 <alltraps>

80106cdb <vector171>:
.globl vector171
vector171:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $171
80106cdd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106ce2:	e9 b0 f4 ff ff       	jmp    80106197 <alltraps>

80106ce7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $172
80106ce9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106cee:	e9 a4 f4 ff ff       	jmp    80106197 <alltraps>

80106cf3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $173
80106cf5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106cfa:	e9 98 f4 ff ff       	jmp    80106197 <alltraps>

80106cff <vector174>:
.globl vector174
vector174:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $174
80106d01:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106d06:	e9 8c f4 ff ff       	jmp    80106197 <alltraps>

80106d0b <vector175>:
.globl vector175
vector175:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $175
80106d0d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106d12:	e9 80 f4 ff ff       	jmp    80106197 <alltraps>

80106d17 <vector176>:
.globl vector176
vector176:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $176
80106d19:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106d1e:	e9 74 f4 ff ff       	jmp    80106197 <alltraps>

80106d23 <vector177>:
.globl vector177
vector177:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $177
80106d25:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106d2a:	e9 68 f4 ff ff       	jmp    80106197 <alltraps>

80106d2f <vector178>:
.globl vector178
vector178:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $178
80106d31:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106d36:	e9 5c f4 ff ff       	jmp    80106197 <alltraps>

80106d3b <vector179>:
.globl vector179
vector179:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $179
80106d3d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106d42:	e9 50 f4 ff ff       	jmp    80106197 <alltraps>

80106d47 <vector180>:
.globl vector180
vector180:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $180
80106d49:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106d4e:	e9 44 f4 ff ff       	jmp    80106197 <alltraps>

80106d53 <vector181>:
.globl vector181
vector181:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $181
80106d55:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106d5a:	e9 38 f4 ff ff       	jmp    80106197 <alltraps>

80106d5f <vector182>:
.globl vector182
vector182:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $182
80106d61:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106d66:	e9 2c f4 ff ff       	jmp    80106197 <alltraps>

80106d6b <vector183>:
.globl vector183
vector183:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $183
80106d6d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106d72:	e9 20 f4 ff ff       	jmp    80106197 <alltraps>

80106d77 <vector184>:
.globl vector184
vector184:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $184
80106d79:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106d7e:	e9 14 f4 ff ff       	jmp    80106197 <alltraps>

80106d83 <vector185>:
.globl vector185
vector185:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $185
80106d85:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106d8a:	e9 08 f4 ff ff       	jmp    80106197 <alltraps>

80106d8f <vector186>:
.globl vector186
vector186:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $186
80106d91:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106d96:	e9 fc f3 ff ff       	jmp    80106197 <alltraps>

80106d9b <vector187>:
.globl vector187
vector187:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $187
80106d9d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106da2:	e9 f0 f3 ff ff       	jmp    80106197 <alltraps>

80106da7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $188
80106da9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106dae:	e9 e4 f3 ff ff       	jmp    80106197 <alltraps>

80106db3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $189
80106db5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106dba:	e9 d8 f3 ff ff       	jmp    80106197 <alltraps>

80106dbf <vector190>:
.globl vector190
vector190:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $190
80106dc1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106dc6:	e9 cc f3 ff ff       	jmp    80106197 <alltraps>

80106dcb <vector191>:
.globl vector191
vector191:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $191
80106dcd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106dd2:	e9 c0 f3 ff ff       	jmp    80106197 <alltraps>

80106dd7 <vector192>:
.globl vector192
vector192:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $192
80106dd9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106dde:	e9 b4 f3 ff ff       	jmp    80106197 <alltraps>

80106de3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $193
80106de5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106dea:	e9 a8 f3 ff ff       	jmp    80106197 <alltraps>

80106def <vector194>:
.globl vector194
vector194:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $194
80106df1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106df6:	e9 9c f3 ff ff       	jmp    80106197 <alltraps>

80106dfb <vector195>:
.globl vector195
vector195:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $195
80106dfd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106e02:	e9 90 f3 ff ff       	jmp    80106197 <alltraps>

80106e07 <vector196>:
.globl vector196
vector196:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $196
80106e09:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106e0e:	e9 84 f3 ff ff       	jmp    80106197 <alltraps>

80106e13 <vector197>:
.globl vector197
vector197:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $197
80106e15:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106e1a:	e9 78 f3 ff ff       	jmp    80106197 <alltraps>

80106e1f <vector198>:
.globl vector198
vector198:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $198
80106e21:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106e26:	e9 6c f3 ff ff       	jmp    80106197 <alltraps>

80106e2b <vector199>:
.globl vector199
vector199:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $199
80106e2d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106e32:	e9 60 f3 ff ff       	jmp    80106197 <alltraps>

80106e37 <vector200>:
.globl vector200
vector200:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $200
80106e39:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106e3e:	e9 54 f3 ff ff       	jmp    80106197 <alltraps>

80106e43 <vector201>:
.globl vector201
vector201:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $201
80106e45:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106e4a:	e9 48 f3 ff ff       	jmp    80106197 <alltraps>

80106e4f <vector202>:
.globl vector202
vector202:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $202
80106e51:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106e56:	e9 3c f3 ff ff       	jmp    80106197 <alltraps>

80106e5b <vector203>:
.globl vector203
vector203:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $203
80106e5d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106e62:	e9 30 f3 ff ff       	jmp    80106197 <alltraps>

80106e67 <vector204>:
.globl vector204
vector204:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $204
80106e69:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106e6e:	e9 24 f3 ff ff       	jmp    80106197 <alltraps>

80106e73 <vector205>:
.globl vector205
vector205:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $205
80106e75:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106e7a:	e9 18 f3 ff ff       	jmp    80106197 <alltraps>

80106e7f <vector206>:
.globl vector206
vector206:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $206
80106e81:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106e86:	e9 0c f3 ff ff       	jmp    80106197 <alltraps>

80106e8b <vector207>:
.globl vector207
vector207:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $207
80106e8d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106e92:	e9 00 f3 ff ff       	jmp    80106197 <alltraps>

80106e97 <vector208>:
.globl vector208
vector208:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $208
80106e99:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106e9e:	e9 f4 f2 ff ff       	jmp    80106197 <alltraps>

80106ea3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $209
80106ea5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106eaa:	e9 e8 f2 ff ff       	jmp    80106197 <alltraps>

80106eaf <vector210>:
.globl vector210
vector210:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $210
80106eb1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106eb6:	e9 dc f2 ff ff       	jmp    80106197 <alltraps>

80106ebb <vector211>:
.globl vector211
vector211:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $211
80106ebd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106ec2:	e9 d0 f2 ff ff       	jmp    80106197 <alltraps>

80106ec7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $212
80106ec9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106ece:	e9 c4 f2 ff ff       	jmp    80106197 <alltraps>

80106ed3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $213
80106ed5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106eda:	e9 b8 f2 ff ff       	jmp    80106197 <alltraps>

80106edf <vector214>:
.globl vector214
vector214:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $214
80106ee1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106ee6:	e9 ac f2 ff ff       	jmp    80106197 <alltraps>

80106eeb <vector215>:
.globl vector215
vector215:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $215
80106eed:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106ef2:	e9 a0 f2 ff ff       	jmp    80106197 <alltraps>

80106ef7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $216
80106ef9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106efe:	e9 94 f2 ff ff       	jmp    80106197 <alltraps>

80106f03 <vector217>:
.globl vector217
vector217:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $217
80106f05:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106f0a:	e9 88 f2 ff ff       	jmp    80106197 <alltraps>

80106f0f <vector218>:
.globl vector218
vector218:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $218
80106f11:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106f16:	e9 7c f2 ff ff       	jmp    80106197 <alltraps>

80106f1b <vector219>:
.globl vector219
vector219:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $219
80106f1d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106f22:	e9 70 f2 ff ff       	jmp    80106197 <alltraps>

80106f27 <vector220>:
.globl vector220
vector220:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $220
80106f29:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106f2e:	e9 64 f2 ff ff       	jmp    80106197 <alltraps>

80106f33 <vector221>:
.globl vector221
vector221:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $221
80106f35:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106f3a:	e9 58 f2 ff ff       	jmp    80106197 <alltraps>

80106f3f <vector222>:
.globl vector222
vector222:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $222
80106f41:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106f46:	e9 4c f2 ff ff       	jmp    80106197 <alltraps>

80106f4b <vector223>:
.globl vector223
vector223:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $223
80106f4d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106f52:	e9 40 f2 ff ff       	jmp    80106197 <alltraps>

80106f57 <vector224>:
.globl vector224
vector224:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $224
80106f59:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106f5e:	e9 34 f2 ff ff       	jmp    80106197 <alltraps>

80106f63 <vector225>:
.globl vector225
vector225:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $225
80106f65:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106f6a:	e9 28 f2 ff ff       	jmp    80106197 <alltraps>

80106f6f <vector226>:
.globl vector226
vector226:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $226
80106f71:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106f76:	e9 1c f2 ff ff       	jmp    80106197 <alltraps>

80106f7b <vector227>:
.globl vector227
vector227:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $227
80106f7d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106f82:	e9 10 f2 ff ff       	jmp    80106197 <alltraps>

80106f87 <vector228>:
.globl vector228
vector228:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $228
80106f89:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106f8e:	e9 04 f2 ff ff       	jmp    80106197 <alltraps>

80106f93 <vector229>:
.globl vector229
vector229:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $229
80106f95:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106f9a:	e9 f8 f1 ff ff       	jmp    80106197 <alltraps>

80106f9f <vector230>:
.globl vector230
vector230:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $230
80106fa1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106fa6:	e9 ec f1 ff ff       	jmp    80106197 <alltraps>

80106fab <vector231>:
.globl vector231
vector231:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $231
80106fad:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106fb2:	e9 e0 f1 ff ff       	jmp    80106197 <alltraps>

80106fb7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $232
80106fb9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106fbe:	e9 d4 f1 ff ff       	jmp    80106197 <alltraps>

80106fc3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $233
80106fc5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106fca:	e9 c8 f1 ff ff       	jmp    80106197 <alltraps>

80106fcf <vector234>:
.globl vector234
vector234:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $234
80106fd1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106fd6:	e9 bc f1 ff ff       	jmp    80106197 <alltraps>

80106fdb <vector235>:
.globl vector235
vector235:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $235
80106fdd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106fe2:	e9 b0 f1 ff ff       	jmp    80106197 <alltraps>

80106fe7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $236
80106fe9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106fee:	e9 a4 f1 ff ff       	jmp    80106197 <alltraps>

80106ff3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $237
80106ff5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106ffa:	e9 98 f1 ff ff       	jmp    80106197 <alltraps>

80106fff <vector238>:
.globl vector238
vector238:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $238
80107001:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107006:	e9 8c f1 ff ff       	jmp    80106197 <alltraps>

8010700b <vector239>:
.globl vector239
vector239:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $239
8010700d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107012:	e9 80 f1 ff ff       	jmp    80106197 <alltraps>

80107017 <vector240>:
.globl vector240
vector240:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $240
80107019:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010701e:	e9 74 f1 ff ff       	jmp    80106197 <alltraps>

80107023 <vector241>:
.globl vector241
vector241:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $241
80107025:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010702a:	e9 68 f1 ff ff       	jmp    80106197 <alltraps>

8010702f <vector242>:
.globl vector242
vector242:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $242
80107031:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107036:	e9 5c f1 ff ff       	jmp    80106197 <alltraps>

8010703b <vector243>:
.globl vector243
vector243:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $243
8010703d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107042:	e9 50 f1 ff ff       	jmp    80106197 <alltraps>

80107047 <vector244>:
.globl vector244
vector244:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $244
80107049:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010704e:	e9 44 f1 ff ff       	jmp    80106197 <alltraps>

80107053 <vector245>:
.globl vector245
vector245:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $245
80107055:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010705a:	e9 38 f1 ff ff       	jmp    80106197 <alltraps>

8010705f <vector246>:
.globl vector246
vector246:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $246
80107061:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107066:	e9 2c f1 ff ff       	jmp    80106197 <alltraps>

8010706b <vector247>:
.globl vector247
vector247:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $247
8010706d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107072:	e9 20 f1 ff ff       	jmp    80106197 <alltraps>

80107077 <vector248>:
.globl vector248
vector248:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $248
80107079:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010707e:	e9 14 f1 ff ff       	jmp    80106197 <alltraps>

80107083 <vector249>:
.globl vector249
vector249:
  pushl $0
80107083:	6a 00                	push   $0x0
  pushl $249
80107085:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010708a:	e9 08 f1 ff ff       	jmp    80106197 <alltraps>

8010708f <vector250>:
.globl vector250
vector250:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $250
80107091:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107096:	e9 fc f0 ff ff       	jmp    80106197 <alltraps>

8010709b <vector251>:
.globl vector251
vector251:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $251
8010709d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801070a2:	e9 f0 f0 ff ff       	jmp    80106197 <alltraps>

801070a7 <vector252>:
.globl vector252
vector252:
  pushl $0
801070a7:	6a 00                	push   $0x0
  pushl $252
801070a9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801070ae:	e9 e4 f0 ff ff       	jmp    80106197 <alltraps>

801070b3 <vector253>:
.globl vector253
vector253:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $253
801070b5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801070ba:	e9 d8 f0 ff ff       	jmp    80106197 <alltraps>

801070bf <vector254>:
.globl vector254
vector254:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $254
801070c1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801070c6:	e9 cc f0 ff ff       	jmp    80106197 <alltraps>

801070cb <vector255>:
.globl vector255
vector255:
  pushl $0
801070cb:	6a 00                	push   $0x0
  pushl $255
801070cd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801070d2:	e9 c0 f0 ff ff       	jmp    80106197 <alltraps>
801070d7:	66 90                	xchg   %ax,%ax
801070d9:	66 90                	xchg   %ax,%ax
801070db:	66 90                	xchg   %ax,%ax
801070dd:	66 90                	xchg   %ax,%ax
801070df:	90                   	nop

801070e0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	57                   	push   %edi
801070e4:	56                   	push   %esi
801070e5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801070e6:	89 d3                	mov    %edx,%ebx
{
801070e8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
801070ea:	c1 eb 16             	shr    $0x16,%ebx
801070ed:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
801070f0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801070f3:	8b 06                	mov    (%esi),%eax
801070f5:	a8 01                	test   $0x1,%al
801070f7:	74 27                	je     80107120 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070f9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801070fe:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107104:	c1 ef 0a             	shr    $0xa,%edi
}
80107107:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010710a:	89 fa                	mov    %edi,%edx
8010710c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107112:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107115:	5b                   	pop    %ebx
80107116:	5e                   	pop    %esi
80107117:	5f                   	pop    %edi
80107118:	5d                   	pop    %ebp
80107119:	c3                   	ret    
8010711a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107120:	85 c9                	test   %ecx,%ecx
80107122:	74 2c                	je     80107150 <walkpgdir+0x70>
80107124:	e8 a7 b8 ff ff       	call   801029d0 <kalloc>
80107129:	85 c0                	test   %eax,%eax
8010712b:	89 c3                	mov    %eax,%ebx
8010712d:	74 21                	je     80107150 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010712f:	83 ec 04             	sub    $0x4,%esp
80107132:	68 00 10 00 00       	push   $0x1000
80107137:	6a 00                	push   $0x0
80107139:	50                   	push   %eax
8010713a:	e8 f1 dd ff ff       	call   80104f30 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010713f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107145:	83 c4 10             	add    $0x10,%esp
80107148:	83 c8 07             	or     $0x7,%eax
8010714b:	89 06                	mov    %eax,(%esi)
8010714d:	eb b5                	jmp    80107104 <walkpgdir+0x24>
8010714f:	90                   	nop
}
80107150:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107153:	31 c0                	xor    %eax,%eax
}
80107155:	5b                   	pop    %ebx
80107156:	5e                   	pop    %esi
80107157:	5f                   	pop    %edi
80107158:	5d                   	pop    %ebp
80107159:	c3                   	ret    
8010715a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107160 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107160:	55                   	push   %ebp
80107161:	89 e5                	mov    %esp,%ebp
80107163:	57                   	push   %edi
80107164:	56                   	push   %esi
80107165:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107166:	89 d3                	mov    %edx,%ebx
80107168:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010716e:	83 ec 1c             	sub    $0x1c,%esp
80107171:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107174:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107178:	8b 7d 08             	mov    0x8(%ebp),%edi
8010717b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107180:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107183:	8b 45 0c             	mov    0xc(%ebp),%eax
80107186:	29 df                	sub    %ebx,%edi
80107188:	83 c8 01             	or     $0x1,%eax
8010718b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010718e:	eb 15                	jmp    801071a5 <mappages+0x45>
    if(*pte & PTE_P)
80107190:	f6 00 01             	testb  $0x1,(%eax)
80107193:	75 45                	jne    801071da <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107195:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107198:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010719b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010719d:	74 31                	je     801071d0 <mappages+0x70>
      break;
    a += PGSIZE;
8010719f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801071a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071a8:	b9 01 00 00 00       	mov    $0x1,%ecx
801071ad:	89 da                	mov    %ebx,%edx
801071af:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801071b2:	e8 29 ff ff ff       	call   801070e0 <walkpgdir>
801071b7:	85 c0                	test   %eax,%eax
801071b9:	75 d5                	jne    80107190 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801071bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801071be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071c3:	5b                   	pop    %ebx
801071c4:	5e                   	pop    %esi
801071c5:	5f                   	pop    %edi
801071c6:	5d                   	pop    %ebp
801071c7:	c3                   	ret    
801071c8:	90                   	nop
801071c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801071d3:	31 c0                	xor    %eax,%eax
}
801071d5:	5b                   	pop    %ebx
801071d6:	5e                   	pop    %esi
801071d7:	5f                   	pop    %edi
801071d8:	5d                   	pop    %ebp
801071d9:	c3                   	ret    
      panic("remap");
801071da:	83 ec 0c             	sub    $0xc,%esp
801071dd:	68 74 88 10 80       	push   $0x80108874
801071e2:	e8 a9 91 ff ff       	call   80100390 <panic>
801071e7:	89 f6                	mov    %esi,%esi
801071e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071f0 <seginit>:
{
801071f0:	55                   	push   %ebp
801071f1:	89 e5                	mov    %esp,%ebp
801071f3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801071f6:	e8 45 cb ff ff       	call   80103d40 <cpuid>
801071fb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107201:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107206:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010720a:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
80107211:	ff 00 00 
80107214:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
8010721b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010721e:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
80107225:	ff 00 00 
80107228:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
8010722f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107232:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
80107239:	ff 00 00 
8010723c:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
80107243:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107246:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
8010724d:	ff 00 00 
80107250:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
80107257:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010725a:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
8010725f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107263:	c1 e8 10             	shr    $0x10,%eax
80107266:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010726a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010726d:	0f 01 10             	lgdtl  (%eax)
}
80107270:	c9                   	leave  
80107271:	c3                   	ret    
80107272:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107280 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107280:	a1 c4 2c 12 80       	mov    0x80122cc4,%eax
{
80107285:	55                   	push   %ebp
80107286:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107288:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010728d:	0f 22 d8             	mov    %eax,%cr3
}
80107290:	5d                   	pop    %ebp
80107291:	c3                   	ret    
80107292:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801072a0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801072a0:	55                   	push   %ebp
801072a1:	89 e5                	mov    %esp,%ebp
801072a3:	57                   	push   %edi
801072a4:	56                   	push   %esi
801072a5:	53                   	push   %ebx
801072a6:	83 ec 1c             	sub    $0x1c,%esp
801072a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
801072ac:	85 db                	test   %ebx,%ebx
801072ae:	0f 84 cb 00 00 00    	je     8010737f <switchuvm+0xdf>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801072b4:	8b 43 08             	mov    0x8(%ebx),%eax
801072b7:	85 c0                	test   %eax,%eax
801072b9:	0f 84 da 00 00 00    	je     80107399 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801072bf:	8b 43 04             	mov    0x4(%ebx),%eax
801072c2:	85 c0                	test   %eax,%eax
801072c4:	0f 84 c2 00 00 00    	je     8010738c <switchuvm+0xec>
    panic("switchuvm: no pgdir");

  pushcli();
801072ca:	e8 a1 da ff ff       	call   80104d70 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801072cf:	e8 ec c9 ff ff       	call   80103cc0 <mycpu>
801072d4:	89 c6                	mov    %eax,%esi
801072d6:	e8 e5 c9 ff ff       	call   80103cc0 <mycpu>
801072db:	89 c7                	mov    %eax,%edi
801072dd:	e8 de c9 ff ff       	call   80103cc0 <mycpu>
801072e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801072e5:	83 c7 08             	add    $0x8,%edi
801072e8:	e8 d3 c9 ff ff       	call   80103cc0 <mycpu>
801072ed:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801072f0:	83 c0 08             	add    $0x8,%eax
801072f3:	ba 67 00 00 00       	mov    $0x67,%edx
801072f8:	c1 e8 18             	shr    $0x18,%eax
801072fb:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107302:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107309:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010730f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107314:	83 c1 08             	add    $0x8,%ecx
80107317:	c1 e9 10             	shr    $0x10,%ecx
8010731a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107320:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107325:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010732c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107331:	e8 8a c9 ff ff       	call   80103cc0 <mycpu>
80107336:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010733d:	e8 7e c9 ff ff       	call   80103cc0 <mycpu>
80107342:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107346:	8b 73 08             	mov    0x8(%ebx),%esi
80107349:	e8 72 c9 ff ff       	call   80103cc0 <mycpu>
8010734e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107354:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107357:	e8 64 c9 ff ff       	call   80103cc0 <mycpu>
8010735c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107360:	b8 28 00 00 00       	mov    $0x28,%eax
80107365:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107368:	8b 43 04             	mov    0x4(%ebx),%eax
8010736b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107370:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80107373:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107376:	5b                   	pop    %ebx
80107377:	5e                   	pop    %esi
80107378:	5f                   	pop    %edi
80107379:	5d                   	pop    %ebp
  popcli();
8010737a:	e9 f1 da ff ff       	jmp    80104e70 <popcli>
    panic("switchuvm: no process");
8010737f:	83 ec 0c             	sub    $0xc,%esp
80107382:	68 7a 88 10 80       	push   $0x8010887a
80107387:	e8 04 90 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
8010738c:	83 ec 0c             	sub    $0xc,%esp
8010738f:	68 a5 88 10 80       	push   $0x801088a5
80107394:	e8 f7 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107399:	83 ec 0c             	sub    $0xc,%esp
8010739c:	68 90 88 10 80       	push   $0x80108890
801073a1:	e8 ea 8f ff ff       	call   80100390 <panic>
801073a6:	8d 76 00             	lea    0x0(%esi),%esi
801073a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073b0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801073b0:	55                   	push   %ebp
801073b1:	89 e5                	mov    %esp,%ebp
801073b3:	57                   	push   %edi
801073b4:	56                   	push   %esi
801073b5:	53                   	push   %ebx
801073b6:	83 ec 1c             	sub    $0x1c,%esp
801073b9:	8b 75 10             	mov    0x10(%ebp),%esi
801073bc:	8b 45 08             	mov    0x8(%ebp),%eax
801073bf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801073c2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
801073c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801073cb:	77 49                	ja     80107416 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
801073cd:	e8 fe b5 ff ff       	call   801029d0 <kalloc>
  memset(mem, 0, PGSIZE);
801073d2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
801073d5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801073d7:	68 00 10 00 00       	push   $0x1000
801073dc:	6a 00                	push   $0x0
801073de:	50                   	push   %eax
801073df:	e8 4c db ff ff       	call   80104f30 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801073e4:	58                   	pop    %eax
801073e5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801073eb:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073f0:	5a                   	pop    %edx
801073f1:	6a 06                	push   $0x6
801073f3:	50                   	push   %eax
801073f4:	31 d2                	xor    %edx,%edx
801073f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073f9:	e8 62 fd ff ff       	call   80107160 <mappages>
  memmove(mem, init, sz);
801073fe:	89 75 10             	mov    %esi,0x10(%ebp)
80107401:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107404:	83 c4 10             	add    $0x10,%esp
80107407:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010740a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010740d:	5b                   	pop    %ebx
8010740e:	5e                   	pop    %esi
8010740f:	5f                   	pop    %edi
80107410:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107411:	e9 ca db ff ff       	jmp    80104fe0 <memmove>
    panic("inituvm: more than a page");
80107416:	83 ec 0c             	sub    $0xc,%esp
80107419:	68 b9 88 10 80       	push   $0x801088b9
8010741e:	e8 6d 8f ff ff       	call   80100390 <panic>
80107423:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107430 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107430:	55                   	push   %ebp
80107431:	89 e5                	mov    %esp,%ebp
80107433:	57                   	push   %edi
80107434:	56                   	push   %esi
80107435:	53                   	push   %ebx
80107436:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107439:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107440:	0f 85 91 00 00 00    	jne    801074d7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107446:	8b 75 18             	mov    0x18(%ebp),%esi
80107449:	31 db                	xor    %ebx,%ebx
8010744b:	85 f6                	test   %esi,%esi
8010744d:	75 1a                	jne    80107469 <loaduvm+0x39>
8010744f:	eb 6f                	jmp    801074c0 <loaduvm+0x90>
80107451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107458:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010745e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107464:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107467:	76 57                	jbe    801074c0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107469:	8b 55 0c             	mov    0xc(%ebp),%edx
8010746c:	8b 45 08             	mov    0x8(%ebp),%eax
8010746f:	31 c9                	xor    %ecx,%ecx
80107471:	01 da                	add    %ebx,%edx
80107473:	e8 68 fc ff ff       	call   801070e0 <walkpgdir>
80107478:	85 c0                	test   %eax,%eax
8010747a:	74 4e                	je     801074ca <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010747c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010747e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107481:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107486:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010748b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107491:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107494:	01 d9                	add    %ebx,%ecx
80107496:	05 00 00 00 80       	add    $0x80000000,%eax
8010749b:	57                   	push   %edi
8010749c:	51                   	push   %ecx
8010749d:	50                   	push   %eax
8010749e:	ff 75 10             	pushl  0x10(%ebp)
801074a1:	e8 4a a5 ff ff       	call   801019f0 <readi>
801074a6:	83 c4 10             	add    $0x10,%esp
801074a9:	39 f8                	cmp    %edi,%eax
801074ab:	74 ab                	je     80107458 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
801074ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801074b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074b5:	5b                   	pop    %ebx
801074b6:	5e                   	pop    %esi
801074b7:	5f                   	pop    %edi
801074b8:	5d                   	pop    %ebp
801074b9:	c3                   	ret    
801074ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801074c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801074c3:	31 c0                	xor    %eax,%eax
}
801074c5:	5b                   	pop    %ebx
801074c6:	5e                   	pop    %esi
801074c7:	5f                   	pop    %edi
801074c8:	5d                   	pop    %ebp
801074c9:	c3                   	ret    
      panic("loaduvm: address should exist");
801074ca:	83 ec 0c             	sub    $0xc,%esp
801074cd:	68 d3 88 10 80       	push   $0x801088d3
801074d2:	e8 b9 8e ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801074d7:	83 ec 0c             	sub    $0xc,%esp
801074da:	68 ac 89 10 80       	push   $0x801089ac
801074df:	e8 ac 8e ff ff       	call   80100390 <panic>
801074e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801074ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801074f0 <pageExist>:
#endif
  }
  return newsz;
}

int pageExist(struct proc* p,uint* page){
801074f0:	55                   	push   %ebp
801074f1:	89 e5                	mov    %esp,%ebp
801074f3:	8b 45 08             	mov    0x8(%ebp),%eax
801074f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801074f9:	8d 90 84 00 00 00    	lea    0x84(%eax),%edx
  for(int i=0;i<MAX_PSYC_PAGES;++i){
801074ff:	31 c0                	xor    %eax,%eax
80107501:	eb 14                	jmp    80107517 <pageExist+0x27>
80107503:	90                   	nop
80107504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->procPhysPages[i].pte == page && p->procPhysPages[i].isOccupied){
      return i;
    }
    if(p->procSwappedFiles[i].pte == page && p->procSwappedFiles[i].isOccupied){
80107508:	39 0a                	cmp    %ecx,(%edx)
8010750a:	74 24                	je     80107530 <pageExist+0x40>
  for(int i=0;i<MAX_PSYC_PAGES;++i){
8010750c:	83 c0 01             	add    $0x1,%eax
8010750f:	83 c2 18             	add    $0x18,%edx
80107512:	83 f8 10             	cmp    $0x10,%eax
80107515:	74 2a                	je     80107541 <pageExist+0x51>
    if(p->procPhysPages[i].pte == page && p->procPhysPages[i].isOccupied){
80107517:	39 8a 80 01 00 00    	cmp    %ecx,0x180(%edx)
8010751d:	75 e9                	jne    80107508 <pageExist+0x18>
8010751f:	83 ba 88 01 00 00 00 	cmpl   $0x0,0x188(%edx)
80107526:	74 e0                	je     80107508 <pageExist+0x18>
      return i;
    }
  }
  return -1;
}
80107528:	5d                   	pop    %ebp
80107529:	c3                   	ret    
8010752a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(p->procSwappedFiles[i].pte == page && p->procSwappedFiles[i].isOccupied){
80107530:	83 7a 08 00          	cmpl   $0x0,0x8(%edx)
80107534:	75 f2                	jne    80107528 <pageExist+0x38>
  for(int i=0;i<MAX_PSYC_PAGES;++i){
80107536:	83 c0 01             	add    $0x1,%eax
80107539:	83 c2 18             	add    $0x18,%edx
8010753c:	83 f8 10             	cmp    $0x10,%eax
8010753f:	75 d6                	jne    80107517 <pageExist+0x27>
  return -1;
80107541:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107546:	5d                   	pop    %ebp
80107547:	c3                   	ret    
80107548:	90                   	nop
80107549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107550 <addPage>:

int addPage(uint *pg_entry,char* a){
80107550:	55                   	push   %ebp
80107551:	89 e5                	mov    %esp,%ebp
80107553:	53                   	push   %ebx
80107554:	83 ec 04             	sub    $0x4,%esp
  //cprintf("add page func: %d \n", myproc()->numOfPhysPages); 
  struct proc* curProc = myproc();
80107557:	e8 04 c8 ff ff       	call   80103d60 <myproc>
8010755c:	89 c3                	mov    %eax,%ebx
  if(curProc->ignorePaging){ return 1; }
8010755e:	8b 80 98 03 00 00    	mov    0x398(%eax),%eax
80107564:	85 c0                	test   %eax,%eax
80107566:	75 70                	jne    801075d8 <addPage+0x88>
80107568:	8d 8b 0c 02 00 00    	lea    0x20c(%ebx),%ecx
  for(int i = 0; i < MAX_PSYC_PAGES; i++){
8010756e:	31 d2                	xor    %edx,%edx
80107570:	eb 11                	jmp    80107583 <addPage+0x33>
80107572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107578:	83 c2 01             	add    $0x1,%edx
8010757b:	83 c1 18             	add    $0x18,%ecx
8010757e:	83 fa 10             	cmp    $0x10,%edx
80107581:	74 49                	je     801075cc <addPage+0x7c>
  //cprintf(" cur page address %p, cur page address, is occupied = %d \n",&curProc->procSwappedFiles[i],curProc->procPhysPages[i].isOccupied); 
    if(!curProc->procPhysPages[i].isOccupied){
80107583:	83 39 00             	cmpl   $0x0,(%ecx)
80107586:	75 f0                	jne    80107578 <addPage+0x28>
      //cprintf("found cell in index: %d \n",i); 
      curProc->procPhysPages[i].isOccupied = 1; 
80107588:	8d 04 52             	lea    (%edx,%edx,2),%eax
      curProc->procPhysPages[i].va = a;
8010758b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
      curProc->procPhysPages[i].pte = pg_entry;
      insertNode(&curProc->procPhysPages[i]);
8010758e:	83 ec 0c             	sub    $0xc,%esp
      curProc->procPhysPages[i].isOccupied = 1; 
80107591:	c1 e0 03             	shl    $0x3,%eax
80107594:	8d 14 03             	lea    (%ebx,%eax,1),%edx
      insertNode(&curProc->procPhysPages[i]);
80107597:	8d 84 03 00 02 00 00 	lea    0x200(%ebx,%eax,1),%eax
      curProc->procPhysPages[i].va = a;
8010759e:	89 8a 00 02 00 00    	mov    %ecx,0x200(%edx)
      curProc->procPhysPages[i].pte = pg_entry;
801075a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
      curProc->procPhysPages[i].isOccupied = 1; 
801075a7:	c7 82 0c 02 00 00 01 	movl   $0x1,0x20c(%edx)
801075ae:	00 00 00 
      curProc->procPhysPages[i].pte = pg_entry;
801075b1:	89 8a 04 02 00 00    	mov    %ecx,0x204(%edx)
      insertNode(&curProc->procPhysPages[i]);
801075b7:	50                   	push   %eax
801075b8:	e8 33 d5 ff ff       	call   80104af0 <insertNode>
      curProc->numOfPhysPages++;
801075bd:	83 83 80 03 00 00 01 	addl   $0x1,0x380(%ebx)
     // cprintf(" cur page address %p, cur page address, is occupied = %d \n",&curProc->procSwappedFiles[i],curProc->procPhysPages[i].isOccupied); 
      return 1;
801075c4:	83 c4 10             	add    $0x10,%esp
801075c7:	b8 01 00 00 00       	mov    $0x1,%eax
    }
  }
  return 0;
}
801075cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801075cf:	c9                   	leave  
801075d0:	c3                   	ret    
801075d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(curProc->ignorePaging){ return 1; }
801075d8:	b8 01 00 00 00       	mov    $0x1,%eax
}
801075dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801075e0:	c9                   	leave  
801075e1:	c3                   	ret    
801075e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801075f0 <removePage>:
  }
  return newsz;
}

// Removes a page from the page meta data
int removePage(uint* page){
801075f0:	55                   	push   %ebp
801075f1:	89 e5                	mov    %esp,%ebp
801075f3:	57                   	push   %edi
801075f4:	56                   	push   %esi
801075f5:	53                   	push   %ebx
801075f6:	83 ec 0c             	sub    $0xc,%esp
801075f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc* curProc = myproc();
801075fc:	e8 5f c7 ff ff       	call   80103d60 <myproc>
  if(curProc->ignorePaging){ return 1; }
80107601:	8b b0 98 03 00 00    	mov    0x398(%eax),%esi
80107607:	85 f6                	test   %esi,%esi
80107609:	75 55                	jne    80107660 <removePage+0x70>
8010760b:	89 c7                	mov    %eax,%edi
8010760d:	8d 90 04 02 00 00    	lea    0x204(%eax),%edx
  for(int i = 0; i < MAX_PSYC_PAGES; i++){
80107613:	31 c0                	xor    %eax,%eax
80107615:	eb 14                	jmp    8010762b <removePage+0x3b>
80107617:	89 f6                	mov    %esi,%esi
80107619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107620:	83 c0 01             	add    $0x1,%eax
80107623:	83 c2 18             	add    $0x18,%edx
80107626:	83 f8 10             	cmp    $0x10,%eax
80107629:	74 21                	je     8010764c <removePage+0x5c>
    if(curProc->procPhysPages[i].pte == page){
8010762b:	39 1a                	cmp    %ebx,(%edx)
8010762d:	75 f1                	jne    80107620 <removePage+0x30>
      if(!removeNode(&curProc->procPhysPages[i])){ return 0; }
8010762f:	8d 1c 40             	lea    (%eax,%eax,2),%ebx
80107632:	83 ec 0c             	sub    $0xc,%esp
80107635:	c1 e3 03             	shl    $0x3,%ebx
80107638:	8d 84 1f 00 02 00 00 	lea    0x200(%edi,%ebx,1),%eax
8010763f:	50                   	push   %eax
80107640:	e8 eb d4 ff ff       	call   80104b30 <removeNode>
80107645:	83 c4 10             	add    $0x10,%esp
80107648:	85 c0                	test   %eax,%eax
8010764a:	75 24                	jne    80107670 <removePage+0x80>
      curProc->numOfPhysPages--;
      return 1;
    }
  }
  return 0;
}
8010764c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010764f:	89 f0                	mov    %esi,%eax
80107651:	5b                   	pop    %ebx
80107652:	5e                   	pop    %esi
80107653:	5f                   	pop    %edi
80107654:	5d                   	pop    %ebp
80107655:	c3                   	ret    
80107656:	8d 76 00             	lea    0x0(%esi),%esi
80107659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107660:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(curProc->ignorePaging){ return 1; }
80107663:	be 01 00 00 00       	mov    $0x1,%esi
}
80107668:	89 f0                	mov    %esi,%eax
8010766a:	5b                   	pop    %ebx
8010766b:	5e                   	pop    %esi
8010766c:	5f                   	pop    %edi
8010766d:	5d                   	pop    %ebp
8010766e:	c3                   	ret    
8010766f:	90                   	nop
      curProc->procPhysPages[i].isOccupied = 0; 
80107670:	01 fb                	add    %edi,%ebx
      return 1;
80107672:	be 01 00 00 00       	mov    $0x1,%esi
      curProc->procPhysPages[i].isOccupied = 0; 
80107677:	c7 83 0c 02 00 00 00 	movl   $0x0,0x20c(%ebx)
8010767e:	00 00 00 
      curProc->procPhysPages[i].va = 0;
80107681:	c7 83 00 02 00 00 00 	movl   $0x0,0x200(%ebx)
80107688:	00 00 00 
}
8010768b:	89 f0                	mov    %esi,%eax
      curProc->procPhysPages[i].pte = 0;
8010768d:	c7 83 04 02 00 00 00 	movl   $0x0,0x204(%ebx)
80107694:	00 00 00 
      curProc->numOfPhysPages--;
80107697:	83 af 80 03 00 00 01 	subl   $0x1,0x380(%edi)
}
8010769e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076a1:	5b                   	pop    %ebx
801076a2:	5e                   	pop    %esi
801076a3:	5f                   	pop    %edi
801076a4:	5d                   	pop    %ebp
801076a5:	c3                   	ret    
801076a6:	8d 76 00             	lea    0x0(%esi),%esi
801076a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801076b0 <deallocuvm>:
{
801076b0:	55                   	push   %ebp
801076b1:	89 e5                	mov    %esp,%ebp
801076b3:	57                   	push   %edi
801076b4:	56                   	push   %esi
801076b5:	53                   	push   %ebx
801076b6:	83 ec 1c             	sub    $0x1c,%esp
801076b9:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc* p = myproc();
801076bc:	e8 9f c6 ff ff       	call   80103d60 <myproc>
801076c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(newsz >= oldsz)
801076c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801076c7:	39 45 10             	cmp    %eax,0x10(%ebp)
801076ca:	0f 83 c3 00 00 00    	jae    80107793 <deallocuvm+0xe3>
  a = PGROUNDUP(newsz);
801076d0:	8b 45 10             	mov    0x10(%ebp),%eax
801076d3:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801076d9:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801076df:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
801076e2:	77 41                	ja     80107725 <deallocuvm+0x75>
801076e4:	e9 a7 00 00 00       	jmp    80107790 <deallocuvm+0xe0>
801076e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
801076f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801076f5:	0f 84 a0 00 00 00    	je     8010779b <deallocuvm+0xeb>
      kfree(v);
801076fb:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801076fe:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107703:	50                   	push   %eax
80107704:	e8 17 b1 ff ff       	call   80102820 <kfree>
      if(pgdir == p->pgdir){
80107709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010770c:	83 c4 10             	add    $0x10,%esp
8010770f:	39 70 04             	cmp    %esi,0x4(%eax)
80107712:	74 3c                	je     80107750 <deallocuvm+0xa0>
      *pte=0;
80107714:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  for(; a  < oldsz; a += PGSIZE){
8010771a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107720:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80107723:	76 6b                	jbe    80107790 <deallocuvm+0xe0>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107725:	31 c9                	xor    %ecx,%ecx
80107727:	89 da                	mov    %ebx,%edx
80107729:	89 f0                	mov    %esi,%eax
8010772b:	e8 b0 f9 ff ff       	call   801070e0 <walkpgdir>
    if(!pte){
80107730:	85 c0                	test   %eax,%eax
    pte = walkpgdir(pgdir, (char*)a, 0);
80107732:	89 c7                	mov    %eax,%edi
    if(!pte){
80107734:	74 3a                	je     80107770 <deallocuvm+0xc0>
    if((*pte & PTE_P) != 0){ //page not present
80107736:	8b 00                	mov    (%eax),%eax
80107738:	a8 01                	test   $0x1,%al
8010773a:	75 b4                	jne    801076f0 <deallocuvm+0x40>
    if(!(*pte & PTE_P) && (*pte & PTE_PG)){ //page on swap file
8010773c:	25 01 02 00 00       	and    $0x201,%eax
80107741:	3d 00 02 00 00       	cmp    $0x200,%eax
80107746:	75 d2                	jne    8010771a <deallocuvm+0x6a>
      if(pgdir == p->pgdir){
80107748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010774b:	39 70 04             	cmp    %esi,0x4(%eax)
8010774e:	75 c4                	jne    80107714 <deallocuvm+0x64>
        if(!removePage(pte)){
80107750:	83 ec 0c             	sub    $0xc,%esp
80107753:	57                   	push   %edi
80107754:	e8 97 fe ff ff       	call   801075f0 <removePage>
80107759:	83 c4 10             	add    $0x10,%esp
8010775c:	85 c0                	test   %eax,%eax
8010775e:	75 b4                	jne    80107714 <deallocuvm+0x64>
          panic("remove page");
80107760:	83 ec 0c             	sub    $0xc,%esp
80107763:	68 f1 88 10 80       	push   $0x801088f1
80107768:	e8 23 8c ff ff       	call   80100390 <panic>
8010776d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107770:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107776:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010777c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107782:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80107785:	77 9e                	ja     80107725 <deallocuvm+0x75>
80107787:	89 f6                	mov    %esi,%esi
80107789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  return newsz;
80107790:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107793:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107796:	5b                   	pop    %ebx
80107797:	5e                   	pop    %esi
80107798:	5f                   	pop    %edi
80107799:	5d                   	pop    %ebp
8010779a:	c3                   	ret    
        panic("kfree");
8010779b:	83 ec 0c             	sub    $0xc,%esp
8010779e:	68 2e 81 10 80       	push   $0x8010812e
801077a3:	e8 e8 8b ff ff       	call   80100390 <panic>
801077a8:	90                   	nop
801077a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801077b0 <allocuvm>:
{
801077b0:	55                   	push   %ebp
801077b1:	89 e5                	mov    %esp,%ebp
801077b3:	57                   	push   %edi
801077b4:	56                   	push   %esi
801077b5:	53                   	push   %ebx
801077b6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801077b9:	8b 45 10             	mov    0x10(%ebp),%eax
801077bc:	85 c0                	test   %eax,%eax
801077be:	89 45 e0             	mov    %eax,-0x20(%ebp)
801077c1:	0f 88 19 01 00 00    	js     801078e0 <allocuvm+0x130>
  if(newsz < oldsz)
801077c7:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801077ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801077cd:	73 11                	jae    801077e0 <allocuvm+0x30>
    return oldsz;
801077cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
}
801077d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801077d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077d8:	5b                   	pop    %ebx
801077d9:	5e                   	pop    %esi
801077da:	5f                   	pop    %edi
801077db:	5d                   	pop    %ebp
801077dc:	c3                   	ret    
801077dd:	8d 76 00             	lea    0x0(%esi),%esi
  a = PGROUNDUP(oldsz);
801077e0:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
  struct proc* p = myproc();
801077e6:	e8 75 c5 ff ff       	call   80103d60 <myproc>
  a = PGROUNDUP(oldsz);
801077eb:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801077f1:	39 75 10             	cmp    %esi,0x10(%ebp)
  struct proc* p = myproc();
801077f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a < newsz; a += PGSIZE){
801077f7:	76 d9                	jbe    801077d2 <allocuvm+0x22>
801077f9:	8d 98 04 02 00 00    	lea    0x204(%eax),%ebx
801077ff:	90                   	nop
    if(!p->ignorePaging && pgdir == p->pgdir){
80107800:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107803:	8b 88 98 03 00 00    	mov    0x398(%eax),%ecx
80107809:	85 c9                	test   %ecx,%ecx
8010780b:	75 0c                	jne    80107819 <allocuvm+0x69>
8010780d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107810:	39 48 04             	cmp    %ecx,0x4(%eax)
80107813:	0f 84 df 00 00 00    	je     801078f8 <allocuvm+0x148>
    mem = kalloc();
80107819:	e8 b2 b1 ff ff       	call   801029d0 <kalloc>
    if(mem == 0){
8010781e:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107820:	89 c7                	mov    %eax,%edi
    if(mem == 0){
80107822:	0f 84 e7 00 00 00    	je     8010790f <allocuvm+0x15f>
    memset(mem, 0, PGSIZE);
80107828:	83 ec 04             	sub    $0x4,%esp
8010782b:	68 00 10 00 00       	push   $0x1000
80107830:	6a 00                	push   $0x0
80107832:	50                   	push   %eax
80107833:	e8 f8 d6 ff ff       	call   80104f30 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107838:	58                   	pop    %eax
80107839:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
8010783f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107844:	5a                   	pop    %edx
80107845:	6a 06                	push   $0x6
80107847:	50                   	push   %eax
80107848:	89 f2                	mov    %esi,%edx
8010784a:	8b 45 08             	mov    0x8(%ebp),%eax
8010784d:	e8 0e f9 ff ff       	call   80107160 <mappages>
80107852:	83 c4 10             	add    $0x10,%esp
80107855:	85 c0                	test   %eax,%eax
80107857:	0f 88 df 00 00 00    	js     8010793c <allocuvm+0x18c>
    pte_t* pg_entry = walkpgdir(pgdir,(const char*)(a),0);
8010785d:	8b 45 08             	mov    0x8(%ebp),%eax
80107860:	31 c9                	xor    %ecx,%ecx
80107862:	89 f2                	mov    %esi,%edx
80107864:	e8 77 f8 ff ff       	call   801070e0 <walkpgdir>
80107869:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010786c:	8d 91 84 00 00 00    	lea    0x84(%ecx),%edx
80107872:	eb 0f                	jmp    80107883 <allocuvm+0xd3>
80107874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->procSwappedFiles[i].pte == page && p->procSwappedFiles[i].isOccupied){
80107878:	3b 02                	cmp    (%edx),%eax
8010787a:	74 2c                	je     801078a8 <allocuvm+0xf8>
8010787c:	83 c2 18             	add    $0x18,%edx
  for(int i=0;i<MAX_PSYC_PAGES;++i){
8010787f:	39 d3                	cmp    %edx,%ebx
80107881:	74 33                	je     801078b6 <allocuvm+0x106>
    if(p->procPhysPages[i].pte == page && p->procPhysPages[i].isOccupied){
80107883:	3b 82 80 01 00 00    	cmp    0x180(%edx),%eax
80107889:	75 ed                	jne    80107878 <allocuvm+0xc8>
8010788b:	8b ba 88 01 00 00    	mov    0x188(%edx),%edi
80107891:	85 ff                	test   %edi,%edi
80107893:	74 e3                	je     80107878 <allocuvm+0xc8>
      panic("page already exists");
80107895:	83 ec 0c             	sub    $0xc,%esp
80107898:	68 48 89 10 80       	push   $0x80108948
8010789d:	e8 ee 8a ff ff       	call   80100390 <panic>
801078a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(p->procSwappedFiles[i].pte == page && p->procSwappedFiles[i].isOccupied){
801078a8:	8b 4a 08             	mov    0x8(%edx),%ecx
801078ab:	85 c9                	test   %ecx,%ecx
801078ad:	75 e6                	jne    80107895 <allocuvm+0xe5>
801078af:	83 c2 18             	add    $0x18,%edx
  for(int i=0;i<MAX_PSYC_PAGES;++i){
801078b2:	39 d3                	cmp    %edx,%ebx
801078b4:	75 cd                	jne    80107883 <allocuvm+0xd3>
    if(!addPage(pg_entry,(char*)a)){ //tries to add page to page meta
801078b6:	83 ec 08             	sub    $0x8,%esp
801078b9:	56                   	push   %esi
801078ba:	50                   	push   %eax
801078bb:	e8 90 fc ff ff       	call   80107550 <addPage>
801078c0:	83 c4 10             	add    $0x10,%esp
801078c3:	85 c0                	test   %eax,%eax
801078c5:	0f 84 a6 00 00 00    	je     80107971 <allocuvm+0x1c1>
  for(; a < newsz; a += PGSIZE){
801078cb:	81 c6 00 10 00 00    	add    $0x1000,%esi
801078d1:	39 75 10             	cmp    %esi,0x10(%ebp)
801078d4:	0f 87 26 ff ff ff    	ja     80107800 <allocuvm+0x50>
801078da:	e9 f3 fe ff ff       	jmp    801077d2 <allocuvm+0x22>
801078df:	90                   	nop
    return 0;
801078e0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801078e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801078ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078ed:	5b                   	pop    %ebx
801078ee:	5e                   	pop    %esi
801078ef:	5f                   	pop    %edi
801078f0:	5d                   	pop    %ebp
801078f1:	c3                   	ret    
801078f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->numOfPhysPages >= MAX_PSYC_PAGES){ //frees a page if exceeded physical limit
801078f8:	83 b8 80 03 00 00 0f 	cmpl   $0xf,0x380(%eax)
801078ff:	0f 8e 14 ff ff ff    	jle    80107819 <allocuvm+0x69>
        swapOut();
80107905:	e8 46 d0 ff ff       	call   80104950 <swapOut>
8010790a:	e9 0a ff ff ff       	jmp    80107819 <allocuvm+0x69>
      cprintf("allocuvm out of memory\n");
8010790f:	83 ec 0c             	sub    $0xc,%esp
80107912:	68 fd 88 10 80       	push   $0x801088fd
80107917:	e8 44 8d ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010791c:	83 c4 0c             	add    $0xc,%esp
8010791f:	ff 75 0c             	pushl  0xc(%ebp)
80107922:	ff 75 10             	pushl  0x10(%ebp)
80107925:	ff 75 08             	pushl  0x8(%ebp)
80107928:	e8 83 fd ff ff       	call   801076b0 <deallocuvm>
      return 0;
8010792d:	83 c4 10             	add    $0x10,%esp
80107930:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107937:	e9 96 fe ff ff       	jmp    801077d2 <allocuvm+0x22>
      cprintf("allocuvm out of memory (2)\n");
8010793c:	83 ec 0c             	sub    $0xc,%esp
8010793f:	68 15 89 10 80       	push   $0x80108915
80107944:	e8 17 8d ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107949:	83 c4 0c             	add    $0xc,%esp
8010794c:	ff 75 0c             	pushl  0xc(%ebp)
8010794f:	ff 75 10             	pushl  0x10(%ebp)
80107952:	ff 75 08             	pushl  0x8(%ebp)
80107955:	e8 56 fd ff ff       	call   801076b0 <deallocuvm>
      kfree(mem);
8010795a:	89 3c 24             	mov    %edi,(%esp)
8010795d:	e8 be ae ff ff       	call   80102820 <kfree>
      return 0;
80107962:	83 c4 10             	add    $0x10,%esp
80107965:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
8010796c:	e9 61 fe ff ff       	jmp    801077d2 <allocuvm+0x22>
      cprintf("process out of memory\n");
80107971:	83 ec 0c             	sub    $0xc,%esp
80107974:	68 31 89 10 80       	push   $0x80108931
80107979:	e8 e2 8c ff ff       	call   80100660 <cprintf>
      p->killed=1;
8010797e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      return oldsz;
80107981:	83 c4 10             	add    $0x10,%esp
      p->killed=1;
80107984:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      return oldsz;
8010798b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010798e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107991:	e9 3c fe ff ff       	jmp    801077d2 <allocuvm+0x22>
80107996:	8d 76 00             	lea    0x0(%esi),%esi
80107999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801079a0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801079a0:	55                   	push   %ebp
801079a1:	89 e5                	mov    %esp,%ebp
801079a3:	57                   	push   %edi
801079a4:	56                   	push   %esi
801079a5:	53                   	push   %ebx
801079a6:	83 ec 0c             	sub    $0xc,%esp
801079a9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801079ac:	85 f6                	test   %esi,%esi
801079ae:	74 59                	je     80107a09 <freevm+0x69>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
801079b0:	83 ec 04             	sub    $0x4,%esp
801079b3:	89 f3                	mov    %esi,%ebx
801079b5:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801079bb:	6a 00                	push   $0x0
801079bd:	68 00 00 00 80       	push   $0x80000000
801079c2:	56                   	push   %esi
801079c3:	e8 e8 fc ff ff       	call   801076b0 <deallocuvm>
801079c8:	83 c4 10             	add    $0x10,%esp
801079cb:	eb 0a                	jmp    801079d7 <freevm+0x37>
801079cd:	8d 76 00             	lea    0x0(%esi),%esi
801079d0:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
801079d3:	39 fb                	cmp    %edi,%ebx
801079d5:	74 23                	je     801079fa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801079d7:	8b 03                	mov    (%ebx),%eax
801079d9:	a8 01                	test   $0x1,%al
801079db:	74 f3                	je     801079d0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801079dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801079e2:	83 ec 0c             	sub    $0xc,%esp
801079e5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801079e8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801079ed:	50                   	push   %eax
801079ee:	e8 2d ae ff ff       	call   80102820 <kfree>
801079f3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801079f6:	39 fb                	cmp    %edi,%ebx
801079f8:	75 dd                	jne    801079d7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801079fa:	89 75 08             	mov    %esi,0x8(%ebp)
}
801079fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a00:	5b                   	pop    %ebx
80107a01:	5e                   	pop    %esi
80107a02:	5f                   	pop    %edi
80107a03:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107a04:	e9 17 ae ff ff       	jmp    80102820 <kfree>
    panic("freevm: no pgdir");
80107a09:	83 ec 0c             	sub    $0xc,%esp
80107a0c:	68 5c 89 10 80       	push   $0x8010895c
80107a11:	e8 7a 89 ff ff       	call   80100390 <panic>
80107a16:	8d 76 00             	lea    0x0(%esi),%esi
80107a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107a20 <setupkvm>:
{
80107a20:	55                   	push   %ebp
80107a21:	89 e5                	mov    %esp,%ebp
80107a23:	56                   	push   %esi
80107a24:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107a25:	e8 a6 af ff ff       	call   801029d0 <kalloc>
80107a2a:	85 c0                	test   %eax,%eax
80107a2c:	89 c6                	mov    %eax,%esi
80107a2e:	74 42                	je     80107a72 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107a30:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107a33:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107a38:	68 00 10 00 00       	push   $0x1000
80107a3d:	6a 00                	push   $0x0
80107a3f:	50                   	push   %eax
80107a40:	e8 eb d4 ff ff       	call   80104f30 <memset>
80107a45:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107a48:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107a4b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107a4e:	83 ec 08             	sub    $0x8,%esp
80107a51:	8b 13                	mov    (%ebx),%edx
80107a53:	ff 73 0c             	pushl  0xc(%ebx)
80107a56:	50                   	push   %eax
80107a57:	29 c1                	sub    %eax,%ecx
80107a59:	89 f0                	mov    %esi,%eax
80107a5b:	e8 00 f7 ff ff       	call   80107160 <mappages>
80107a60:	83 c4 10             	add    $0x10,%esp
80107a63:	85 c0                	test   %eax,%eax
80107a65:	78 19                	js     80107a80 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107a67:	83 c3 10             	add    $0x10,%ebx
80107a6a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107a70:	75 d6                	jne    80107a48 <setupkvm+0x28>
}
80107a72:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107a75:	89 f0                	mov    %esi,%eax
80107a77:	5b                   	pop    %ebx
80107a78:	5e                   	pop    %esi
80107a79:	5d                   	pop    %ebp
80107a7a:	c3                   	ret    
80107a7b:	90                   	nop
80107a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107a80:	83 ec 0c             	sub    $0xc,%esp
80107a83:	56                   	push   %esi
      return 0;
80107a84:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107a86:	e8 15 ff ff ff       	call   801079a0 <freevm>
      return 0;
80107a8b:	83 c4 10             	add    $0x10,%esp
}
80107a8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107a91:	89 f0                	mov    %esi,%eax
80107a93:	5b                   	pop    %ebx
80107a94:	5e                   	pop    %esi
80107a95:	5d                   	pop    %ebp
80107a96:	c3                   	ret    
80107a97:	89 f6                	mov    %esi,%esi
80107a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107aa0 <kvmalloc>:
{
80107aa0:	55                   	push   %ebp
80107aa1:	89 e5                	mov    %esp,%ebp
80107aa3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107aa6:	e8 75 ff ff ff       	call   80107a20 <setupkvm>
80107aab:	a3 c4 2c 12 80       	mov    %eax,0x80122cc4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107ab0:	05 00 00 00 80       	add    $0x80000000,%eax
80107ab5:	0f 22 d8             	mov    %eax,%cr3
}
80107ab8:	c9                   	leave  
80107ab9:	c3                   	ret    
80107aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107ac0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107ac0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107ac1:	31 c9                	xor    %ecx,%ecx
{
80107ac3:	89 e5                	mov    %esp,%ebp
80107ac5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107ac8:	8b 55 0c             	mov    0xc(%ebp),%edx
80107acb:	8b 45 08             	mov    0x8(%ebp),%eax
80107ace:	e8 0d f6 ff ff       	call   801070e0 <walkpgdir>
  if(pte == 0)
80107ad3:	85 c0                	test   %eax,%eax
80107ad5:	74 05                	je     80107adc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107ad7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107ada:	c9                   	leave  
80107adb:	c3                   	ret    
    panic("clearpteu");
80107adc:	83 ec 0c             	sub    $0xc,%esp
80107adf:	68 6d 89 10 80       	push   $0x8010896d
80107ae4:	e8 a7 88 ff ff       	call   80100390 <panic>
80107ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107af0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107af0:	55                   	push   %ebp
80107af1:	89 e5                	mov    %esp,%ebp
80107af3:	57                   	push   %edi
80107af4:	56                   	push   %esi
80107af5:	53                   	push   %ebx
80107af6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107af9:	e8 22 ff ff ff       	call   80107a20 <setupkvm>
80107afe:	85 c0                	test   %eax,%eax
80107b00:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107b03:	0f 84 a0 00 00 00    	je     80107ba9 <copyuvm+0xb9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107b09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107b0c:	85 c9                	test   %ecx,%ecx
80107b0e:	0f 84 95 00 00 00    	je     80107ba9 <copyuvm+0xb9>
80107b14:	31 f6                	xor    %esi,%esi
80107b16:	eb 4e                	jmp    80107b66 <copyuvm+0x76>
80107b18:	90                   	nop
80107b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107b20:	83 ec 04             	sub    $0x4,%esp
80107b23:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107b29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107b2c:	68 00 10 00 00       	push   $0x1000
80107b31:	57                   	push   %edi
80107b32:	50                   	push   %eax
80107b33:	e8 a8 d4 ff ff       	call   80104fe0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107b38:	58                   	pop    %eax
80107b39:	5a                   	pop    %edx
80107b3a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107b3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107b40:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107b45:	53                   	push   %ebx
80107b46:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107b4c:	52                   	push   %edx
80107b4d:	89 f2                	mov    %esi,%edx
80107b4f:	e8 0c f6 ff ff       	call   80107160 <mappages>
80107b54:	83 c4 10             	add    $0x10,%esp
80107b57:	85 c0                	test   %eax,%eax
80107b59:	78 39                	js     80107b94 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
80107b5b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107b61:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107b64:	76 43                	jbe    80107ba9 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107b66:	8b 45 08             	mov    0x8(%ebp),%eax
80107b69:	31 c9                	xor    %ecx,%ecx
80107b6b:	89 f2                	mov    %esi,%edx
80107b6d:	e8 6e f5 ff ff       	call   801070e0 <walkpgdir>
80107b72:	85 c0                	test   %eax,%eax
80107b74:	74 3e                	je     80107bb4 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
80107b76:	8b 18                	mov    (%eax),%ebx
80107b78:	f6 c3 01             	test   $0x1,%bl
80107b7b:	74 44                	je     80107bc1 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
80107b7d:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80107b7f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80107b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107b8b:	e8 40 ae ff ff       	call   801029d0 <kalloc>
80107b90:	85 c0                	test   %eax,%eax
80107b92:	75 8c                	jne    80107b20 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80107b94:	83 ec 0c             	sub    $0xc,%esp
80107b97:	ff 75 e0             	pushl  -0x20(%ebp)
80107b9a:	e8 01 fe ff ff       	call   801079a0 <freevm>
  return 0;
80107b9f:	83 c4 10             	add    $0x10,%esp
80107ba2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107ba9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107bac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107baf:	5b                   	pop    %ebx
80107bb0:	5e                   	pop    %esi
80107bb1:	5f                   	pop    %edi
80107bb2:	5d                   	pop    %ebp
80107bb3:	c3                   	ret    
      panic("copyuvm: pte should exist");
80107bb4:	83 ec 0c             	sub    $0xc,%esp
80107bb7:	68 77 89 10 80       	push   $0x80108977
80107bbc:	e8 cf 87 ff ff       	call   80100390 <panic>
      panic("copyuvm: page not present");
80107bc1:	83 ec 0c             	sub    $0xc,%esp
80107bc4:	68 91 89 10 80       	push   $0x80108991
80107bc9:	e8 c2 87 ff ff       	call   80100390 <panic>
80107bce:	66 90                	xchg   %ax,%ax

80107bd0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107bd0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107bd1:	31 c9                	xor    %ecx,%ecx
{
80107bd3:	89 e5                	mov    %esp,%ebp
80107bd5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107bd8:	8b 55 0c             	mov    0xc(%ebp),%edx
80107bdb:	8b 45 08             	mov    0x8(%ebp),%eax
80107bde:	e8 fd f4 ff ff       	call   801070e0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107be3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107be5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107be6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107be8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107bed:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107bf0:	05 00 00 00 80       	add    $0x80000000,%eax
80107bf5:	83 fa 05             	cmp    $0x5,%edx
80107bf8:	ba 00 00 00 00       	mov    $0x0,%edx
80107bfd:	0f 45 c2             	cmovne %edx,%eax
}
80107c00:	c3                   	ret    
80107c01:	eb 0d                	jmp    80107c10 <copyout>
80107c03:	90                   	nop
80107c04:	90                   	nop
80107c05:	90                   	nop
80107c06:	90                   	nop
80107c07:	90                   	nop
80107c08:	90                   	nop
80107c09:	90                   	nop
80107c0a:	90                   	nop
80107c0b:	90                   	nop
80107c0c:	90                   	nop
80107c0d:	90                   	nop
80107c0e:	90                   	nop
80107c0f:	90                   	nop

80107c10 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107c10:	55                   	push   %ebp
80107c11:	89 e5                	mov    %esp,%ebp
80107c13:	57                   	push   %edi
80107c14:	56                   	push   %esi
80107c15:	53                   	push   %ebx
80107c16:	83 ec 1c             	sub    $0x1c,%esp
80107c19:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107c1c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c1f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107c22:	85 db                	test   %ebx,%ebx
80107c24:	75 40                	jne    80107c66 <copyout+0x56>
80107c26:	eb 70                	jmp    80107c98 <copyout+0x88>
80107c28:	90                   	nop
80107c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107c30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107c33:	89 f1                	mov    %esi,%ecx
80107c35:	29 d1                	sub    %edx,%ecx
80107c37:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107c3d:	39 d9                	cmp    %ebx,%ecx
80107c3f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107c42:	29 f2                	sub    %esi,%edx
80107c44:	83 ec 04             	sub    $0x4,%esp
80107c47:	01 d0                	add    %edx,%eax
80107c49:	51                   	push   %ecx
80107c4a:	57                   	push   %edi
80107c4b:	50                   	push   %eax
80107c4c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107c4f:	e8 8c d3 ff ff       	call   80104fe0 <memmove>
    len -= n;
    buf += n;
80107c54:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107c57:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80107c5a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107c60:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107c62:	29 cb                	sub    %ecx,%ebx
80107c64:	74 32                	je     80107c98 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107c66:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107c68:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107c6b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107c6e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107c74:	56                   	push   %esi
80107c75:	ff 75 08             	pushl  0x8(%ebp)
80107c78:	e8 53 ff ff ff       	call   80107bd0 <uva2ka>
    if(pa0 == 0)
80107c7d:	83 c4 10             	add    $0x10,%esp
80107c80:	85 c0                	test   %eax,%eax
80107c82:	75 ac                	jne    80107c30 <copyout+0x20>
  }
  return 0;
}
80107c84:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107c87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107c8c:	5b                   	pop    %ebx
80107c8d:	5e                   	pop    %esi
80107c8e:	5f                   	pop    %edi
80107c8f:	5d                   	pop    %ebp
80107c90:	c3                   	ret    
80107c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107c9b:	31 c0                	xor    %eax,%eax
}
80107c9d:	5b                   	pop    %ebx
80107c9e:	5e                   	pop    %esi
80107c9f:	5f                   	pop    %edi
80107ca0:	5d                   	pop    %ebp
80107ca1:	c3                   	ret    
80107ca2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107cb0 <swapIn>:
  }
  return 1;
}

// Executes page-in from Disk to RAM.
int swapIn(uint *pte, uint faultAdd){
80107cb0:	55                   	push   %ebp
80107cb1:	89 e5                	mov    %esp,%ebp
80107cb3:	57                   	push   %edi
80107cb4:	56                   	push   %esi
80107cb5:	53                   	push   %ebx
80107cb6:	83 ec 1c             	sub    $0x1c,%esp
  //cprintf("swap in method");
  struct proc* curProc = myproc();
80107cb9:	e8 a2 c0 ff ff       	call   80103d60 <myproc>
80107cbe:	89 c3                	mov    %eax,%ebx
  char* mem = kalloc(); // allocate physical memory (size of page)
80107cc0:	e8 0b ad ff ff       	call   801029d0 <kalloc>
  char* pageStart = (char*)PGROUNDDOWN(faultAdd); // gets the start point of the page (removes offset)
  int maped = mappages(curProc->pgdir,pageStart,PGSIZE,V2P(mem), PTE_U); // mapes the virtual memory of the page fault to the new allocated memory
80107cc5:	8b 73 04             	mov    0x4(%ebx),%esi
  char* pageStart = (char*)PGROUNDDOWN(faultAdd); // gets the start point of the page (removes offset)
80107cc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  int maped = mappages(curProc->pgdir,pageStart,PGSIZE,V2P(mem), PTE_U); // mapes the virtual memory of the page fault to the new allocated memory
80107ccb:	83 ec 08             	sub    $0x8,%esp
80107cce:	05 00 00 00 80       	add    $0x80000000,%eax
80107cd3:	6a 04                	push   $0x4
80107cd5:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107cda:	50                   	push   %eax
  char* pageStart = (char*)PGROUNDDOWN(faultAdd); // gets the start point of the page (removes offset)
80107cdb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  int maped = mappages(curProc->pgdir,pageStart,PGSIZE,V2P(mem), PTE_U); // mapes the virtual memory of the page fault to the new allocated memory
80107ce1:	89 f0                	mov    %esi,%eax
  char* pageStart = (char*)PGROUNDDOWN(faultAdd); // gets the start point of the page (removes offset)
80107ce3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  int maped = mappages(curProc->pgdir,pageStart,PGSIZE,V2P(mem), PTE_U); // mapes the virtual memory of the page fault to the new allocated memory
80107ce6:	e8 75 f4 ff ff       	call   80107160 <mappages>
  if(!maped)
80107ceb:	83 c4 10             	add    $0x10,%esp
80107cee:	85 c0                	test   %eax,%eax
80107cf0:	0f 84 d0 00 00 00    	je     80107dc6 <swapIn+0x116>
    return -1;
  int offset = -1;
  int foundCell = 0;
  char* pa = (char*)(PTE_ADDR(*pte));
80107cf6:	8b 45 08             	mov    0x8(%ebp),%eax
80107cf9:	8d bb 00 02 00 00    	lea    0x200(%ebx),%edi
  int offset = -1;
80107cff:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  int foundCell = 0;
80107d02:	31 c9                	xor    %ecx,%ecx
  int offset = -1;
80107d04:	be ff ff ff ff       	mov    $0xffffffff,%esi
  char* pa = (char*)(PTE_ADDR(*pte));
80107d09:	8b 00                	mov    (%eax),%eax
80107d0b:	89 c2                	mov    %eax,%edx
80107d0d:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  int offset = -1;
80107d13:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char* pa = (char*)(PTE_ADDR(*pte));
80107d16:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  char* va = (char*)(P2V((uint)(pa)));
80107d1c:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107d22:	eb 33                	jmp    80107d57 <swapIn+0xa7>
80107d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curProc->procSwappedFiles[i].isOccupied = 0; // cell in procSwappedFiles Array is not needed anymore
      // curProc->procPhysPages[i].va = va;
      // curProc->procPhysPages[i].pte = pte;
      // break;
      }
    if (!foundCell){
80107d28:	85 c9                	test   %ecx,%ecx
80107d2a:	75 24                	jne    80107d50 <swapIn+0xa0>
      if (curProc->procPhysPages[i].isOccupied == 0){ // look for a place in procPhysPages Array
80107d2c:	83 b8 8c 01 00 00 00 	cmpl   $0x0,0x18c(%eax)
80107d33:	75 1b                	jne    80107d50 <swapIn+0xa0>
          curProc->procPhysPages[i].isOccupied = 1;
80107d35:	c7 80 8c 01 00 00 01 	movl   $0x1,0x18c(%eax)
80107d3c:	00 00 00 
          curProc->procPhysPages[i].va = va;
80107d3f:	89 90 80 01 00 00    	mov    %edx,0x180(%eax)
          curProc->procPhysPages[i].pte = pte;
          foundCell = 1;
80107d45:	b9 01 00 00 00       	mov    $0x1,%ecx
          curProc->procPhysPages[i].pte = pte;
80107d4a:	89 98 84 01 00 00    	mov    %ebx,0x184(%eax)
80107d50:	83 c0 18             	add    $0x18,%eax
  for (int i=0; i<MAX_PSYC_PAGES; i++){ // find the cell that contains the meta-data of this page
80107d53:	39 f8                	cmp    %edi,%eax
80107d55:	74 19                	je     80107d70 <swapIn+0xc0>
    if (curProc->procSwappedFiles[i].va == va){
80107d57:	39 10                	cmp    %edx,(%eax)
80107d59:	75 cd                	jne    80107d28 <swapIn+0x78>
      offset = curProc->procSwappedFiles[i].offsetInFile;
80107d5b:	8b 70 08             	mov    0x8(%eax),%esi
      curProc->procSwappedFiles[i].isOccupied = 0; // cell in procSwappedFiles Array is not needed anymore
80107d5e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
80107d65:	eb c1                	jmp    80107d28 <swapIn+0x78>
80107d67:	89 f6                	mov    %esi,%esi
80107d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        }
    }  
  }
  readFromSwapFile(curProc, (char*)V2P(pageStart), offset, PGSIZE);
80107d70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d73:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80107d76:	68 00 10 00 00       	push   $0x1000
80107d7b:	56                   	push   %esi
80107d7c:	05 00 00 00 80       	add    $0x80000000,%eax
80107d81:	50                   	push   %eax
80107d82:	53                   	push   %ebx
80107d83:	e8 88 a5 ff ff       	call   80102310 <readFromSwapFile>
  curProc->numOfPhysPages++;
  curProc->numOfDiskPages--;
  #ifndef NONE
  insertNode(&curProc->procPhysPages[offset/PGSIZE]);
80107d88:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
  curProc->numOfPhysPages++;
80107d8e:	83 83 80 03 00 00 01 	addl   $0x1,0x380(%ebx)
  curProc->numOfDiskPages--;
80107d95:	83 ab 84 03 00 00 01 	subl   $0x1,0x384(%ebx)
  insertNode(&curProc->procPhysPages[offset/PGSIZE]);
80107d9c:	85 f6                	test   %esi,%esi
80107d9e:	0f 48 f0             	cmovs  %eax,%esi
80107da1:	c1 fe 0c             	sar    $0xc,%esi
80107da4:	8d 04 76             	lea    (%esi,%esi,2),%eax
80107da7:	8d 84 c3 00 02 00 00 	lea    0x200(%ebx,%eax,8),%eax
80107dae:	89 04 24             	mov    %eax,(%esp)
80107db1:	e8 3a cd ff ff       	call   80104af0 <insertNode>
  #endif
  return 1;
80107db6:	83 c4 10             	add    $0x10,%esp
80107db9:	b8 01 00 00 00       	mov    $0x1,%eax
}
80107dbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107dc1:	5b                   	pop    %ebx
80107dc2:	5e                   	pop    %esi
80107dc3:	5f                   	pop    %edi
80107dc4:	5d                   	pop    %ebp
80107dc5:	c3                   	ret    
    return -1;
80107dc6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107dcb:	eb f1                	jmp    80107dbe <swapIn+0x10e>
80107dcd:	8d 76 00             	lea    0x0(%esi),%esi

80107dd0 <checkIfNeedSwapping>:
int checkIfNeedSwapping(){
80107dd0:	55                   	push   %ebp
80107dd1:	89 e5                	mov    %esp,%ebp
80107dd3:	53                   	push   %ebx
80107dd4:	83 ec 14             	sub    $0x14,%esp
  struct proc *curProc = myproc();
80107dd7:	e8 84 bf ff ff       	call   80103d60 <myproc>
  curProc->numOfPageFaults++;
80107ddc:	83 80 8c 03 00 00 01 	addl   $0x1,0x38c(%eax)
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107de3:	0f 20 d1             	mov    %cr2,%ecx
  pde = &curProc->pgdir[PDX(&faultingAddress)];
80107de6:	8d 55 f4             	lea    -0xc(%ebp),%edx
  if (*pde & PTE_P){
80107de9:	8b 58 04             	mov    0x4(%eax),%ebx
  uint faultingAddress = rcr2(); // contains the address that register %cr2 holds
80107dec:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  pde = &curProc->pgdir[PDX(&faultingAddress)];
80107def:	c1 ea 16             	shr    $0x16,%edx
  if (*pde & PTE_P){
80107df2:	8b 14 93             	mov    (%ebx,%edx,4),%edx
80107df5:	f6 c2 01             	test   $0x1,%dl
80107df8:	74 56                	je     80107e50 <checkIfNeedSwapping+0x80>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));; // Page is Present, swapping isn't needed
80107dfa:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if (*pgtab & PTE_PG) { // Page was paged-out to disk, paged-in is needed
80107e00:	f6 82 01 00 00 80 02 	testb  $0x2,-0x7fffffff(%edx)
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));; // Page is Present, swapping isn't needed
80107e07:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
  if (*pgtab & PTE_PG) { // Page was paged-out to disk, paged-in is needed
80107e0d:	74 51                	je     80107e60 <checkIfNeedSwapping+0x90>
    if (curProc->numOfPhysPages >= MAX_PSYC_PAGES){ // Check if swapping is needed
80107e0f:	83 b8 80 03 00 00 0f 	cmpl   $0xf,0x380(%eax)
80107e16:	7f 18                	jg     80107e30 <checkIfNeedSwapping+0x60>
      swapIn(pgtab, faultingAddress);
80107e18:	83 ec 08             	sub    $0x8,%esp
80107e1b:	51                   	push   %ecx
80107e1c:	53                   	push   %ebx
80107e1d:	e8 8e fe ff ff       	call   80107cb0 <swapIn>
80107e22:	83 c4 10             	add    $0x10,%esp
  return 1;
80107e25:	b8 01 00 00 00       	mov    $0x1,%eax
}
80107e2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107e2d:	c9                   	leave  
80107e2e:	c3                   	ret    
80107e2f:	90                   	nop
      swap(pgtab, faultingAddress);
80107e30:	83 ec 08             	sub    $0x8,%esp
80107e33:	51                   	push   %ecx
80107e34:	53                   	push   %ebx
80107e35:	e8 56 cc ff ff       	call   80104a90 <swap>
80107e3a:	83 c4 10             	add    $0x10,%esp
  return 1;
80107e3d:	b8 01 00 00 00       	mov    $0x1,%eax
}
80107e42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107e45:	c9                   	leave  
80107e46:	c3                   	ret    
80107e47:	89 f6                	mov    %esi,%esi
80107e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80107e50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e55:	eb d3                	jmp    80107e2a <checkIfNeedSwapping+0x5a>
80107e57:	89 f6                	mov    %esi,%esi
80107e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    curProc->killed = 1;
80107e60:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
    return -1;
80107e67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e6c:	eb bc                	jmp    80107e2a <checkIfNeedSwapping+0x5a>
