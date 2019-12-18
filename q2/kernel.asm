
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 b0 2e 10 80       	mov    $0x80102eb0,%eax
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
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 71 10 80       	push   $0x80107100
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 35 43 00 00       	call   80104390 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
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
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 71 10 80       	push   $0x80107107
80100097:	50                   	push   %eax
80100098:	e8 c3 41 00 00       	call   80104260 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
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
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 e7 43 00 00       	call   801044d0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
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
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
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
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 29 44 00 00       	call   80104590 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 2e 41 00 00       	call   801042a0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 ad 1f 00 00       	call   80102130 <iderw>
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
80100193:	68 0e 71 10 80       	push   $0x8010710e
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
801001ae:	e8 8d 41 00 00       	call   80104340 <holdingsleep>
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
801001c4:	e9 67 1f 00 00       	jmp    80102130 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 1f 71 10 80       	push   $0x8010711f
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
801001ef:	e8 4c 41 00 00       	call   80104340 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 fc 40 00 00       	call   80104300 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 c0 42 00 00       	call   801044d0 <acquire>
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
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 2f 43 00 00       	jmp    80104590 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 26 71 10 80       	push   $0x80107126
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
80100280:	e8 db 14 00 00       	call   80101760 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 3f 42 00 00       	call   801044d0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002a7:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
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
801002bb:	68 20 a5 10 80       	push   $0x8010a520
801002c0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002c5:	e8 46 3b 00 00       	call   80103e10 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 40 35 00 00       	call   80103820 <myproc>
801002e0:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
801002e6:	85 c0                	test   %eax,%eax
801002e8:	74 ce                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002ea:	83 ec 0c             	sub    $0xc,%esp
801002ed:	68 20 a5 10 80       	push   $0x8010a520
801002f2:	e8 99 42 00 00       	call   80104590 <release>
        ilock(ip);
801002f7:	89 3c 24             	mov    %edi,(%esp)
801002fa:	e8 81 13 00 00       	call   80101680 <ilock>
        return -1;
801002ff:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100302:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100305:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030a:	5b                   	pop    %ebx
8010030b:	5e                   	pop    %esi
8010030c:	5f                   	pop    %edi
8010030d:	5d                   	pop    %ebp
8010030e:	c3                   	ret    
8010030f:	90                   	nop
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
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
80100348:	68 20 a5 10 80       	push   $0x8010a520
8010034d:	e8 3e 42 00 00       	call   80104590 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 26 13 00 00       	call   80101680 <ilock>
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
80100372:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
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
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 92 23 00 00       	call   80102740 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 2d 71 10 80       	push   $0x8010712d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 87 7a 10 80 	movl   $0x80107a87,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 d3 3f 00 00       	call   801043b0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 41 71 10 80       	push   $0x80107141
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
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
8010043a:	e8 c1 58 00 00       	call   80105d00 <uartputc>
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
801004ec:	e8 0f 58 00 00       	call   80105d00 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 03 58 00 00       	call   80105d00 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 f7 57 00 00       	call   80105d00 <uartputc>
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
80100524:	e8 67 41 00 00       	call   80104690 <memmove>
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
80100541:	e8 9a 40 00 00       	call   801045e0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 45 71 10 80       	push   $0x80107145
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
801005b1:	0f b6 92 70 71 10 80 	movzbl -0x7fef8e90(%edx),%edx
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
8010060f:	e8 4c 11 00 00       	call   80101760 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 b0 3e 00 00       	call   801044d0 <acquire>
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
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 44 3f 00 00       	call   80104590 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 2b 10 00 00       	call   80101680 <ilock>

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
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
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
8010071a:	68 20 a5 10 80       	push   $0x8010a520
8010071f:	e8 6c 3e 00 00       	call   80104590 <release>
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
801007d0:	ba 58 71 10 80       	mov    $0x80107158,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 a5 10 80       	push   $0x8010a520
801007f0:	e8 db 3c 00 00       	call   801044d0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 5f 71 10 80       	push   $0x8010715f
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
8010081e:	68 20 a5 10 80       	push   $0x8010a520
80100823:	e8 a8 3c 00 00       	call   801044d0 <acquire>
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
80100851:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100856:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
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
80100883:	68 20 a5 10 80       	push   $0x8010a520
80100888:	e8 03 3d 00 00       	call   80104590 <release>
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
801008a9:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100911:	68 a0 ff 10 80       	push   $0x8010ffa0
80100916:	e8 c5 36 00 00       	call   80103fe0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010093d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100964:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
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
80100997:	e9 24 37 00 00       	jmp    801040c0 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
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
801009c6:	68 68 71 10 80       	push   $0x80107168
801009cb:	68 20 a5 10 80       	push   $0x8010a520
801009d0:	e8 bb 39 00 00       	call   80104390 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 e2 18 00 00       	call   801022e0 <ioapicenable>
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
80100a1c:	e8 ff 2d 00 00       	call   80103820 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 84 21 00 00       	call   80102bb0 <begin_op>

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
80100a48:	e8 33 0c 00 00       	call   80101680 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 02 0f 00 00       	call   80101960 <readi>
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
80100a6a:	e8 a1 0e 00 00       	call   80101910 <iunlockput>
    end_op();
80100a6f:	e8 ac 21 00 00       	call   80102c20 <end_op>
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
80100a94:	e8 b7 63 00 00       	call   80106e50 <setupkvm>
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
80100ab9:	0f 84 8f 02 00 00    	je     80100d4e <exec+0x33e>
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
80100af6:	e8 75 61 00 00       	call   80106c70 <allocuvm>
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
80100b28:	e8 83 60 00 00       	call   80106bb0 <loaduvm>
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
80100b58:	e8 03 0e 00 00       	call   80101960 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 59 62 00 00       	call   80106dd0 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 76 0d 00 00       	call   80101910 <iunlockput>
  end_op();
80100b9a:	e8 81 20 00 00       	call   80102c20 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 c1 60 00 00       	call   80106c70 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 0a 62 00 00       	call   80106dd0 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 48 20 00 00       	call   80102c20 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 81 71 10 80       	push   $0x80107181
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
80100c06:	e8 e5 62 00 00       	call   80106ef0 <clearpteu>
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
80100c39:	e8 c2 3b 00 00       	call   80104800 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 af 3b 00 00       	call   80104800 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 ee 63 00 00       	call   80107050 <copyout>
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
80100cc7:	e8 84 63 00 00       	call   80107050 <copyout>
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
80100d06:	05 d0 00 00 00       	add    $0xd0,%eax
80100d0b:	50                   	push   %eax
80100d0c:	e8 af 3a 00 00       	call   801047c0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d11:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d17:	89 f9                	mov    %edi,%ecx
80100d19:	8b 7f 68             	mov    0x68(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1c:	8b 41 7c             	mov    0x7c(%ecx),%eax
  curproc->sz = sz;
80100d1f:	89 71 64             	mov    %esi,0x64(%ecx)
  curproc->pgdir = pgdir;
80100d22:	89 51 68             	mov    %edx,0x68(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d25:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d2b:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2e:	8b 41 7c             	mov    0x7c(%ecx),%eax
80100d31:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d34:	89 0c 24             	mov    %ecx,(%esp)
80100d37:	e8 e4 5c 00 00       	call   80106a20 <switchuvm>
  freevm(oldpgdir);
80100d3c:	89 3c 24             	mov    %edi,(%esp)
80100d3f:	e8 8c 60 00 00       	call   80106dd0 <freevm>
  return 0;
80100d44:	83 c4 10             	add    $0x10,%esp
80100d47:	31 c0                	xor    %eax,%eax
80100d49:	e9 2e fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4e:	be 00 20 00 00       	mov    $0x2000,%esi
80100d53:	e9 39 fe ff ff       	jmp    80100b91 <exec+0x181>
80100d58:	66 90                	xchg   %ax,%ax
80100d5a:	66 90                	xchg   %ax,%ax
80100d5c:	66 90                	xchg   %ax,%ax
80100d5e:	66 90                	xchg   %ax,%ax

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
80100d66:	68 8d 71 10 80       	push   $0x8010718d
80100d6b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d70:	e8 1b 36 00 00       	call   80104390 <initlock>
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
80100d84:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d91:	e8 3a 37 00 00       	call   801044d0 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
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
80100dbc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dc1:	e8 ca 37 00 00       	call   80104590 <release>
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
80100dd5:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dda:	e8 b1 37 00 00       	call   80104590 <release>
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
80100dfa:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dff:	e8 cc 36 00 00       	call   801044d0 <acquire>
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
80100e17:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e1c:	e8 6f 37 00 00       	call   80104590 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 94 71 10 80       	push   $0x80107194
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
80100e4c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e51:	e8 7a 36 00 00       	call   801044d0 <acquire>
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
80100e6e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
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
80100e7c:	e9 0f 37 00 00       	jmp    80104590 <release>
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
80100ea0:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 e3 36 00 00       	call   80104590 <release>
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
80100ed1:	e8 8a 24 00 00       	call   80103360 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 cb 1c 00 00       	call   80102bb0 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 c0 08 00 00       	call   801017b0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 21 1d 00 00       	jmp    80102c20 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 9c 71 10 80       	push   $0x8010719c
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
80100f25:	e8 56 07 00 00       	call   80101680 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 f9 09 00 00       	call   80101930 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 20 08 00 00       	call   80101760 <iunlock>
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
80100f8a:	e8 f1 06 00 00       	call   80101680 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 c4 09 00 00       	call   80101960 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 ad 07 00 00       	call   80101760 <iunlock>
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
80100fcd:	e9 3e 25 00 00       	jmp    80103510 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 a6 71 10 80       	push   $0x801071a6
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
80101044:	e8 17 07 00 00       	call   80101760 <iunlock>
      end_op();
80101049:	e8 d2 1b 00 00       	call   80102c20 <end_op>
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
80101076:	e8 35 1b 00 00       	call   80102bb0 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 fa 05 00 00       	call   80101680 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 c8 09 00 00       	call   80101a60 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 b3 06 00 00       	call   80101760 <iunlock>
      end_op();
801010ad:	e8 6e 1b 00 00       	call   80102c20 <end_op>
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
801010ed:	e9 0e 23 00 00       	jmp    80103400 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 af 71 10 80       	push   $0x801071af
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 b5 71 10 80       	push   $0x801071b5
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	56                   	push   %esi
80101114:	53                   	push   %ebx
80101115:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101117:	c1 ea 0c             	shr    $0xc,%edx
8010111a:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101120:	83 ec 08             	sub    $0x8,%esp
80101123:	52                   	push   %edx
80101124:	50                   	push   %eax
80101125:	e8 a6 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010112a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010112c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010112f:	ba 01 00 00 00       	mov    $0x1,%edx
80101134:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101137:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010113d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101140:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101142:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101147:	85 d1                	test   %edx,%ecx
80101149:	74 25                	je     80101170 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010114b:	f7 d2                	not    %edx
8010114d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010114f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101152:	21 ca                	and    %ecx,%edx
80101154:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101158:	56                   	push   %esi
80101159:	e8 22 1c 00 00       	call   80102d80 <log_write>
  brelse(bp);
8010115e:	89 34 24             	mov    %esi,(%esp)
80101161:	e8 7a f0 ff ff       	call   801001e0 <brelse>
}
80101166:	83 c4 10             	add    $0x10,%esp
80101169:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010116c:	5b                   	pop    %ebx
8010116d:	5e                   	pop    %esi
8010116e:	5d                   	pop    %ebp
8010116f:	c3                   	ret    
    panic("freeing free block");
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 bf 71 10 80       	push   $0x801071bf
80101178:	e8 13 f2 ff ff       	call   80100390 <panic>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi

80101180 <balloc>:
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101189:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010118f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101192:	85 c9                	test   %ecx,%ecx
80101194:	0f 84 87 00 00 00    	je     80101221 <balloc+0xa1>
8010119a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011a1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011a4:	83 ec 08             	sub    $0x8,%esp
801011a7:	89 f0                	mov    %esi,%eax
801011a9:	c1 f8 0c             	sar    $0xc,%eax
801011ac:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011b2:	50                   	push   %eax
801011b3:	ff 75 d8             	pushl  -0x28(%ebp)
801011b6:	e8 15 ef ff ff       	call   801000d0 <bread>
801011bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011be:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011c3:	83 c4 10             	add    $0x10,%esp
801011c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011c9:	31 c0                	xor    %eax,%eax
801011cb:	eb 2f                	jmp    801011fc <balloc+0x7c>
801011cd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011d0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011d5:	bb 01 00 00 00       	mov    $0x1,%ebx
801011da:	83 e1 07             	and    $0x7,%ecx
801011dd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011df:	89 c1                	mov    %eax,%ecx
801011e1:	c1 f9 03             	sar    $0x3,%ecx
801011e4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011e9:	85 df                	test   %ebx,%edi
801011eb:	89 fa                	mov    %edi,%edx
801011ed:	74 41                	je     80101230 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ef:	83 c0 01             	add    $0x1,%eax
801011f2:	83 c6 01             	add    $0x1,%esi
801011f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011fa:	74 05                	je     80101201 <balloc+0x81>
801011fc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801011ff:	77 cf                	ja     801011d0 <balloc+0x50>
    brelse(bp);
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	ff 75 e4             	pushl  -0x1c(%ebp)
80101207:	e8 d4 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010120c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101213:	83 c4 10             	add    $0x10,%esp
80101216:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101219:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010121f:	77 80                	ja     801011a1 <balloc+0x21>
  panic("balloc: out of blocks");
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	68 d2 71 10 80       	push   $0x801071d2
80101229:	e8 62 f1 ff ff       	call   80100390 <panic>
8010122e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101230:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101233:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101236:	09 da                	or     %ebx,%edx
80101238:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010123c:	57                   	push   %edi
8010123d:	e8 3e 1b 00 00       	call   80102d80 <log_write>
        brelse(bp);
80101242:	89 3c 24             	mov    %edi,(%esp)
80101245:	e8 96 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010124a:	58                   	pop    %eax
8010124b:	5a                   	pop    %edx
8010124c:	56                   	push   %esi
8010124d:	ff 75 d8             	pushl  -0x28(%ebp)
80101250:	e8 7b ee ff ff       	call   801000d0 <bread>
80101255:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101257:	8d 40 5c             	lea    0x5c(%eax),%eax
8010125a:	83 c4 0c             	add    $0xc,%esp
8010125d:	68 00 02 00 00       	push   $0x200
80101262:	6a 00                	push   $0x0
80101264:	50                   	push   %eax
80101265:	e8 76 33 00 00       	call   801045e0 <memset>
  log_write(bp);
8010126a:	89 1c 24             	mov    %ebx,(%esp)
8010126d:	e8 0e 1b 00 00       	call   80102d80 <log_write>
  brelse(bp);
80101272:	89 1c 24             	mov    %ebx,(%esp)
80101275:	e8 66 ef ff ff       	call   801001e0 <brelse>
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010128a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101290 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101298:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010129a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010129f:	83 ec 28             	sub    $0x28,%esp
801012a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012a5:	68 e0 09 11 80       	push   $0x801109e0
801012aa:	e8 21 32 00 00       	call   801044d0 <acquire>
801012af:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012b5:	eb 17                	jmp    801012ce <iget+0x3e>
801012b7:	89 f6                	mov    %esi,%esi
801012b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012c0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012c6:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012cc:	73 22                	jae    801012f0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012ce:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012d1:	85 c9                	test   %ecx,%ecx
801012d3:	7e 04                	jle    801012d9 <iget+0x49>
801012d5:	39 3b                	cmp    %edi,(%ebx)
801012d7:	74 4f                	je     80101328 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012d9:	85 f6                	test   %esi,%esi
801012db:	75 e3                	jne    801012c0 <iget+0x30>
801012dd:	85 c9                	test   %ecx,%ecx
801012df:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012e2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012e8:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012ee:	72 de                	jb     801012ce <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012f0:	85 f6                	test   %esi,%esi
801012f2:	74 5b                	je     8010134f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012f4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801012f7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012f9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012fc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101303:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010130a:	68 e0 09 11 80       	push   $0x801109e0
8010130f:	e8 7c 32 00 00       	call   80104590 <release>

  return ip;
80101314:	83 c4 10             	add    $0x10,%esp
}
80101317:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131a:	89 f0                	mov    %esi,%eax
8010131c:	5b                   	pop    %ebx
8010131d:	5e                   	pop    %esi
8010131e:	5f                   	pop    %edi
8010131f:	5d                   	pop    %ebp
80101320:	c3                   	ret    
80101321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101328:	39 53 04             	cmp    %edx,0x4(%ebx)
8010132b:	75 ac                	jne    801012d9 <iget+0x49>
      release(&icache.lock);
8010132d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101330:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101333:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101335:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
8010133a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010133d:	e8 4e 32 00 00       	call   80104590 <release>
      return ip;
80101342:	83 c4 10             	add    $0x10,%esp
}
80101345:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101348:	89 f0                	mov    %esi,%eax
8010134a:	5b                   	pop    %ebx
8010134b:	5e                   	pop    %esi
8010134c:	5f                   	pop    %edi
8010134d:	5d                   	pop    %ebp
8010134e:	c3                   	ret    
    panic("iget: no inodes");
8010134f:	83 ec 0c             	sub    $0xc,%esp
80101352:	68 e8 71 10 80       	push   $0x801071e8
80101357:	e8 34 f0 ff ff       	call   80100390 <panic>
8010135c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101360 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	89 c6                	mov    %eax,%esi
80101368:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010136b:	83 fa 0b             	cmp    $0xb,%edx
8010136e:	77 18                	ja     80101388 <bmap+0x28>
80101370:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101373:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101376:	85 db                	test   %ebx,%ebx
80101378:	74 76                	je     801013f0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137d:	89 d8                	mov    %ebx,%eax
8010137f:	5b                   	pop    %ebx
80101380:	5e                   	pop    %esi
80101381:	5f                   	pop    %edi
80101382:	5d                   	pop    %ebp
80101383:	c3                   	ret    
80101384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101388:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010138b:	83 fb 7f             	cmp    $0x7f,%ebx
8010138e:	0f 87 90 00 00 00    	ja     80101424 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101394:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010139a:	8b 00                	mov    (%eax),%eax
8010139c:	85 d2                	test   %edx,%edx
8010139e:	74 70                	je     80101410 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801013a0:	83 ec 08             	sub    $0x8,%esp
801013a3:	52                   	push   %edx
801013a4:	50                   	push   %eax
801013a5:	e8 26 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013aa:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013ae:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013b1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013b3:	8b 1a                	mov    (%edx),%ebx
801013b5:	85 db                	test   %ebx,%ebx
801013b7:	75 1d                	jne    801013d6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801013b9:	8b 06                	mov    (%esi),%eax
801013bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013be:	e8 bd fd ff ff       	call   80101180 <balloc>
801013c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013c6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801013c9:	89 c3                	mov    %eax,%ebx
801013cb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013cd:	57                   	push   %edi
801013ce:	e8 ad 19 00 00       	call   80102d80 <log_write>
801013d3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801013d6:	83 ec 0c             	sub    $0xc,%esp
801013d9:	57                   	push   %edi
801013da:	e8 01 ee ff ff       	call   801001e0 <brelse>
801013df:	83 c4 10             	add    $0x10,%esp
}
801013e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e5:	89 d8                	mov    %ebx,%eax
801013e7:	5b                   	pop    %ebx
801013e8:	5e                   	pop    %esi
801013e9:	5f                   	pop    %edi
801013ea:	5d                   	pop    %ebp
801013eb:	c3                   	ret    
801013ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801013f0:	8b 00                	mov    (%eax),%eax
801013f2:	e8 89 fd ff ff       	call   80101180 <balloc>
801013f7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801013fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801013fd:	89 c3                	mov    %eax,%ebx
}
801013ff:	89 d8                	mov    %ebx,%eax
80101401:	5b                   	pop    %ebx
80101402:	5e                   	pop    %esi
80101403:	5f                   	pop    %edi
80101404:	5d                   	pop    %ebp
80101405:	c3                   	ret    
80101406:	8d 76 00             	lea    0x0(%esi),%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101410:	e8 6b fd ff ff       	call   80101180 <balloc>
80101415:	89 c2                	mov    %eax,%edx
80101417:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010141d:	8b 06                	mov    (%esi),%eax
8010141f:	e9 7c ff ff ff       	jmp    801013a0 <bmap+0x40>
  panic("bmap: out of range");
80101424:	83 ec 0c             	sub    $0xc,%esp
80101427:	68 f8 71 10 80       	push   $0x801071f8
8010142c:	e8 5f ef ff ff       	call   80100390 <panic>
80101431:	eb 0d                	jmp    80101440 <readsb>
80101433:	90                   	nop
80101434:	90                   	nop
80101435:	90                   	nop
80101436:	90                   	nop
80101437:	90                   	nop
80101438:	90                   	nop
80101439:	90                   	nop
8010143a:	90                   	nop
8010143b:	90                   	nop
8010143c:	90                   	nop
8010143d:	90                   	nop
8010143e:	90                   	nop
8010143f:	90                   	nop

80101440 <readsb>:
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	56                   	push   %esi
80101444:	53                   	push   %ebx
80101445:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101448:	83 ec 08             	sub    $0x8,%esp
8010144b:	6a 01                	push   $0x1
8010144d:	ff 75 08             	pushl  0x8(%ebp)
80101450:	e8 7b ec ff ff       	call   801000d0 <bread>
80101455:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101457:	8d 40 5c             	lea    0x5c(%eax),%eax
8010145a:	83 c4 0c             	add    $0xc,%esp
8010145d:	6a 1c                	push   $0x1c
8010145f:	50                   	push   %eax
80101460:	56                   	push   %esi
80101461:	e8 2a 32 00 00       	call   80104690 <memmove>
  brelse(bp);
80101466:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101469:	83 c4 10             	add    $0x10,%esp
}
8010146c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010146f:	5b                   	pop    %ebx
80101470:	5e                   	pop    %esi
80101471:	5d                   	pop    %ebp
  brelse(bp);
80101472:	e9 69 ed ff ff       	jmp    801001e0 <brelse>
80101477:	89 f6                	mov    %esi,%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <iinit>:
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101489:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010148c:	68 0b 72 10 80       	push   $0x8010720b
80101491:	68 e0 09 11 80       	push   $0x801109e0
80101496:	e8 f5 2e 00 00       	call   80104390 <initlock>
8010149b:	83 c4 10             	add    $0x10,%esp
8010149e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	83 ec 08             	sub    $0x8,%esp
801014a3:	68 12 72 10 80       	push   $0x80107212
801014a8:	53                   	push   %ebx
801014a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014af:	e8 ac 2d 00 00       	call   80104260 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014b4:	83 c4 10             	add    $0x10,%esp
801014b7:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014bd:	75 e1                	jne    801014a0 <iinit+0x20>
  readsb(dev, &sb);
801014bf:	83 ec 08             	sub    $0x8,%esp
801014c2:	68 c0 09 11 80       	push   $0x801109c0
801014c7:	ff 75 08             	pushl  0x8(%ebp)
801014ca:	e8 71 ff ff ff       	call   80101440 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014cf:	ff 35 d8 09 11 80    	pushl  0x801109d8
801014d5:	ff 35 d4 09 11 80    	pushl  0x801109d4
801014db:	ff 35 d0 09 11 80    	pushl  0x801109d0
801014e1:	ff 35 cc 09 11 80    	pushl  0x801109cc
801014e7:	ff 35 c8 09 11 80    	pushl  0x801109c8
801014ed:	ff 35 c4 09 11 80    	pushl  0x801109c4
801014f3:	ff 35 c0 09 11 80    	pushl  0x801109c0
801014f9:	68 78 72 10 80       	push   $0x80107278
801014fe:	e8 5d f1 ff ff       	call   80100660 <cprintf>
}
80101503:	83 c4 30             	add    $0x30,%esp
80101506:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101509:	c9                   	leave  
8010150a:	c3                   	ret    
8010150b:	90                   	nop
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <ialloc>:
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	57                   	push   %edi
80101514:	56                   	push   %esi
80101515:	53                   	push   %ebx
80101516:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101520:	8b 45 0c             	mov    0xc(%ebp),%eax
80101523:	8b 75 08             	mov    0x8(%ebp),%esi
80101526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	0f 86 91 00 00 00    	jbe    801015c0 <ialloc+0xb0>
8010152f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101534:	eb 21                	jmp    80101557 <ialloc+0x47>
80101536:	8d 76 00             	lea    0x0(%esi),%esi
80101539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101540:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101543:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101546:	57                   	push   %edi
80101547:	e8 94 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010154c:	83 c4 10             	add    $0x10,%esp
8010154f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101555:	76 69                	jbe    801015c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101557:	89 d8                	mov    %ebx,%eax
80101559:	83 ec 08             	sub    $0x8,%esp
8010155c:	c1 e8 03             	shr    $0x3,%eax
8010155f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101565:	50                   	push   %eax
80101566:	56                   	push   %esi
80101567:	e8 64 eb ff ff       	call   801000d0 <bread>
8010156c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010156e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101570:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101573:	83 e0 07             	and    $0x7,%eax
80101576:	c1 e0 06             	shl    $0x6,%eax
80101579:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010157d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101581:	75 bd                	jne    80101540 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101583:	83 ec 04             	sub    $0x4,%esp
80101586:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101589:	6a 40                	push   $0x40
8010158b:	6a 00                	push   $0x0
8010158d:	51                   	push   %ecx
8010158e:	e8 4d 30 00 00       	call   801045e0 <memset>
      dip->type = type;
80101593:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101597:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010159a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010159d:	89 3c 24             	mov    %edi,(%esp)
801015a0:	e8 db 17 00 00       	call   80102d80 <log_write>
      brelse(bp);
801015a5:	89 3c 24             	mov    %edi,(%esp)
801015a8:	e8 33 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015ad:	83 c4 10             	add    $0x10,%esp
}
801015b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015b3:	89 da                	mov    %ebx,%edx
801015b5:	89 f0                	mov    %esi,%eax
}
801015b7:	5b                   	pop    %ebx
801015b8:	5e                   	pop    %esi
801015b9:	5f                   	pop    %edi
801015ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801015bb:	e9 d0 fc ff ff       	jmp    80101290 <iget>
  panic("ialloc: no inodes");
801015c0:	83 ec 0c             	sub    $0xc,%esp
801015c3:	68 18 72 10 80       	push   $0x80107218
801015c8:	e8 c3 ed ff ff       	call   80100390 <panic>
801015cd:	8d 76 00             	lea    0x0(%esi),%esi

801015d0 <iupdate>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	56                   	push   %esi
801015d4:	53                   	push   %ebx
801015d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d8:	83 ec 08             	sub    $0x8,%esp
801015db:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015de:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e1:	c1 e8 03             	shr    $0x3,%eax
801015e4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015ea:	50                   	push   %eax
801015eb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015ee:	e8 dd ea ff ff       	call   801000d0 <bread>
801015f3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015f5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015f8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fc:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ff:	83 e0 07             	and    $0x7,%eax
80101602:	c1 e0 06             	shl    $0x6,%eax
80101605:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101609:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010160c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101610:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101613:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101617:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010161b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010161f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101623:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101627:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010162a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162d:	6a 34                	push   $0x34
8010162f:	53                   	push   %ebx
80101630:	50                   	push   %eax
80101631:	e8 5a 30 00 00       	call   80104690 <memmove>
  log_write(bp);
80101636:	89 34 24             	mov    %esi,(%esp)
80101639:	e8 42 17 00 00       	call   80102d80 <log_write>
  brelse(bp);
8010163e:	89 75 08             	mov    %esi,0x8(%ebp)
80101641:	83 c4 10             	add    $0x10,%esp
}
80101644:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101647:	5b                   	pop    %ebx
80101648:	5e                   	pop    %esi
80101649:	5d                   	pop    %ebp
  brelse(bp);
8010164a:	e9 91 eb ff ff       	jmp    801001e0 <brelse>
8010164f:	90                   	nop

80101650 <idup>:
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	53                   	push   %ebx
80101654:	83 ec 10             	sub    $0x10,%esp
80101657:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010165a:	68 e0 09 11 80       	push   $0x801109e0
8010165f:	e8 6c 2e 00 00       	call   801044d0 <acquire>
  ip->ref++;
80101664:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101668:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010166f:	e8 1c 2f 00 00       	call   80104590 <release>
}
80101674:	89 d8                	mov    %ebx,%eax
80101676:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101679:	c9                   	leave  
8010167a:	c3                   	ret    
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <ilock>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	56                   	push   %esi
80101684:	53                   	push   %ebx
80101685:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101688:	85 db                	test   %ebx,%ebx
8010168a:	0f 84 b7 00 00 00    	je     80101747 <ilock+0xc7>
80101690:	8b 53 08             	mov    0x8(%ebx),%edx
80101693:	85 d2                	test   %edx,%edx
80101695:	0f 8e ac 00 00 00    	jle    80101747 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010169b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010169e:	83 ec 0c             	sub    $0xc,%esp
801016a1:	50                   	push   %eax
801016a2:	e8 f9 2b 00 00       	call   801042a0 <acquiresleep>
  if(ip->valid == 0){
801016a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016aa:	83 c4 10             	add    $0x10,%esp
801016ad:	85 c0                	test   %eax,%eax
801016af:	74 0f                	je     801016c0 <ilock+0x40>
}
801016b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016b4:	5b                   	pop    %ebx
801016b5:	5e                   	pop    %esi
801016b6:	5d                   	pop    %ebp
801016b7:	c3                   	ret    
801016b8:	90                   	nop
801016b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c0:	8b 43 04             	mov    0x4(%ebx),%eax
801016c3:	83 ec 08             	sub    $0x8,%esp
801016c6:	c1 e8 03             	shr    $0x3,%eax
801016c9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016cf:	50                   	push   %eax
801016d0:	ff 33                	pushl  (%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
801016d7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016dc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016df:	83 e0 07             	and    $0x7,%eax
801016e2:	c1 e0 06             	shl    $0x6,%eax
801016e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101703:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101707:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010170b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010170e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101711:	6a 34                	push   $0x34
80101713:	50                   	push   %eax
80101714:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101717:	50                   	push   %eax
80101718:	e8 73 2f 00 00       	call   80104690 <memmove>
    brelse(bp);
8010171d:	89 34 24             	mov    %esi,(%esp)
80101720:	e8 bb ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101725:	83 c4 10             	add    $0x10,%esp
80101728:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010172d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101734:	0f 85 77 ff ff ff    	jne    801016b1 <ilock+0x31>
      panic("ilock: no type");
8010173a:	83 ec 0c             	sub    $0xc,%esp
8010173d:	68 30 72 10 80       	push   $0x80107230
80101742:	e8 49 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101747:	83 ec 0c             	sub    $0xc,%esp
8010174a:	68 2a 72 10 80       	push   $0x8010722a
8010174f:	e8 3c ec ff ff       	call   80100390 <panic>
80101754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010175a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101760 <iunlock>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	56                   	push   %esi
80101764:	53                   	push   %ebx
80101765:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101768:	85 db                	test   %ebx,%ebx
8010176a:	74 28                	je     80101794 <iunlock+0x34>
8010176c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010176f:	83 ec 0c             	sub    $0xc,%esp
80101772:	56                   	push   %esi
80101773:	e8 c8 2b 00 00       	call   80104340 <holdingsleep>
80101778:	83 c4 10             	add    $0x10,%esp
8010177b:	85 c0                	test   %eax,%eax
8010177d:	74 15                	je     80101794 <iunlock+0x34>
8010177f:	8b 43 08             	mov    0x8(%ebx),%eax
80101782:	85 c0                	test   %eax,%eax
80101784:	7e 0e                	jle    80101794 <iunlock+0x34>
  releasesleep(&ip->lock);
80101786:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101789:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010178c:	5b                   	pop    %ebx
8010178d:	5e                   	pop    %esi
8010178e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010178f:	e9 6c 2b 00 00       	jmp    80104300 <releasesleep>
    panic("iunlock");
80101794:	83 ec 0c             	sub    $0xc,%esp
80101797:	68 3f 72 10 80       	push   $0x8010723f
8010179c:	e8 ef eb ff ff       	call   80100390 <panic>
801017a1:	eb 0d                	jmp    801017b0 <iput>
801017a3:	90                   	nop
801017a4:	90                   	nop
801017a5:	90                   	nop
801017a6:	90                   	nop
801017a7:	90                   	nop
801017a8:	90                   	nop
801017a9:	90                   	nop
801017aa:	90                   	nop
801017ab:	90                   	nop
801017ac:	90                   	nop
801017ad:	90                   	nop
801017ae:	90                   	nop
801017af:	90                   	nop

801017b0 <iput>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	57                   	push   %edi
801017b4:	56                   	push   %esi
801017b5:	53                   	push   %ebx
801017b6:	83 ec 28             	sub    $0x28,%esp
801017b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017bf:	57                   	push   %edi
801017c0:	e8 db 2a 00 00       	call   801042a0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	85 d2                	test   %edx,%edx
801017cd:	74 07                	je     801017d6 <iput+0x26>
801017cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017d4:	74 32                	je     80101808 <iput+0x58>
  releasesleep(&ip->lock);
801017d6:	83 ec 0c             	sub    $0xc,%esp
801017d9:	57                   	push   %edi
801017da:	e8 21 2b 00 00       	call   80104300 <releasesleep>
  acquire(&icache.lock);
801017df:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017e6:	e8 e5 2c 00 00       	call   801044d0 <acquire>
  ip->ref--;
801017eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ef:	83 c4 10             	add    $0x10,%esp
801017f2:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801017f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017fc:	5b                   	pop    %ebx
801017fd:	5e                   	pop    %esi
801017fe:	5f                   	pop    %edi
801017ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101800:	e9 8b 2d 00 00       	jmp    80104590 <release>
80101805:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101808:	83 ec 0c             	sub    $0xc,%esp
8010180b:	68 e0 09 11 80       	push   $0x801109e0
80101810:	e8 bb 2c 00 00       	call   801044d0 <acquire>
    int r = ip->ref;
80101815:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101818:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010181f:	e8 6c 2d 00 00       	call   80104590 <release>
    if(r == 1){
80101824:	83 c4 10             	add    $0x10,%esp
80101827:	83 fe 01             	cmp    $0x1,%esi
8010182a:	75 aa                	jne    801017d6 <iput+0x26>
8010182c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101832:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101835:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101838:	89 cf                	mov    %ecx,%edi
8010183a:	eb 0b                	jmp    80101847 <iput+0x97>
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101840:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101843:	39 fe                	cmp    %edi,%esi
80101845:	74 19                	je     80101860 <iput+0xb0>
    if(ip->addrs[i]){
80101847:	8b 16                	mov    (%esi),%edx
80101849:	85 d2                	test   %edx,%edx
8010184b:	74 f3                	je     80101840 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010184d:	8b 03                	mov    (%ebx),%eax
8010184f:	e8 bc f8 ff ff       	call   80101110 <bfree>
      ip->addrs[i] = 0;
80101854:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010185a:	eb e4                	jmp    80101840 <iput+0x90>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101860:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101866:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101869:	85 c0                	test   %eax,%eax
8010186b:	75 33                	jne    801018a0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010186d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101870:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101877:	53                   	push   %ebx
80101878:	e8 53 fd ff ff       	call   801015d0 <iupdate>
      ip->type = 0;
8010187d:	31 c0                	xor    %eax,%eax
8010187f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101883:	89 1c 24             	mov    %ebx,(%esp)
80101886:	e8 45 fd ff ff       	call   801015d0 <iupdate>
      ip->valid = 0;
8010188b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101892:	83 c4 10             	add    $0x10,%esp
80101895:	e9 3c ff ff ff       	jmp    801017d6 <iput+0x26>
8010189a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018a0:	83 ec 08             	sub    $0x8,%esp
801018a3:	50                   	push   %eax
801018a4:	ff 33                	pushl  (%ebx)
801018a6:	e8 25 e8 ff ff       	call   801000d0 <bread>
801018ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018b1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018b7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ba:	83 c4 10             	add    $0x10,%esp
801018bd:	89 cf                	mov    %ecx,%edi
801018bf:	eb 0e                	jmp    801018cf <iput+0x11f>
801018c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018c8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018cb:	39 fe                	cmp    %edi,%esi
801018cd:	74 0f                	je     801018de <iput+0x12e>
      if(a[j])
801018cf:	8b 16                	mov    (%esi),%edx
801018d1:	85 d2                	test   %edx,%edx
801018d3:	74 f3                	je     801018c8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018d5:	8b 03                	mov    (%ebx),%eax
801018d7:	e8 34 f8 ff ff       	call   80101110 <bfree>
801018dc:	eb ea                	jmp    801018c8 <iput+0x118>
    brelse(bp);
801018de:	83 ec 0c             	sub    $0xc,%esp
801018e1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018e7:	e8 f4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018ec:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801018f2:	8b 03                	mov    (%ebx),%eax
801018f4:	e8 17 f8 ff ff       	call   80101110 <bfree>
    ip->addrs[NDIRECT] = 0;
801018f9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101900:	00 00 00 
80101903:	83 c4 10             	add    $0x10,%esp
80101906:	e9 62 ff ff ff       	jmp    8010186d <iput+0xbd>
8010190b:	90                   	nop
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101910 <iunlockput>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	53                   	push   %ebx
80101914:	83 ec 10             	sub    $0x10,%esp
80101917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010191a:	53                   	push   %ebx
8010191b:	e8 40 fe ff ff       	call   80101760 <iunlock>
  iput(ip);
80101920:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101923:	83 c4 10             	add    $0x10,%esp
}
80101926:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101929:	c9                   	leave  
  iput(ip);
8010192a:	e9 81 fe ff ff       	jmp    801017b0 <iput>
8010192f:	90                   	nop

80101930 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	8b 55 08             	mov    0x8(%ebp),%edx
80101936:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101939:	8b 0a                	mov    (%edx),%ecx
8010193b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010193e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101941:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101944:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101948:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010194b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010194f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101953:	8b 52 58             	mov    0x58(%edx),%edx
80101956:	89 50 10             	mov    %edx,0x10(%eax)
}
80101959:	5d                   	pop    %ebp
8010195a:	c3                   	ret    
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 1c             	sub    $0x1c,%esp
80101969:	8b 45 08             	mov    0x8(%ebp),%eax
8010196c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010196f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101972:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101977:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010197a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010197d:	8b 75 10             	mov    0x10(%ebp),%esi
80101980:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101983:	0f 84 a7 00 00 00    	je     80101a30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101989:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010198c:	8b 40 58             	mov    0x58(%eax),%eax
8010198f:	39 c6                	cmp    %eax,%esi
80101991:	0f 87 ba 00 00 00    	ja     80101a51 <readi+0xf1>
80101997:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010199a:	89 f9                	mov    %edi,%ecx
8010199c:	01 f1                	add    %esi,%ecx
8010199e:	0f 82 ad 00 00 00    	jb     80101a51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019a4:	89 c2                	mov    %eax,%edx
801019a6:	29 f2                	sub    %esi,%edx
801019a8:	39 c8                	cmp    %ecx,%eax
801019aa:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ad:	31 ff                	xor    %edi,%edi
801019af:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019b1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019b4:	74 6c                	je     80101a22 <readi+0xc2>
801019b6:	8d 76 00             	lea    0x0(%esi),%esi
801019b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019c0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019c3:	89 f2                	mov    %esi,%edx
801019c5:	c1 ea 09             	shr    $0x9,%edx
801019c8:	89 d8                	mov    %ebx,%eax
801019ca:	e8 91 f9 ff ff       	call   80101360 <bmap>
801019cf:	83 ec 08             	sub    $0x8,%esp
801019d2:	50                   	push   %eax
801019d3:	ff 33                	pushl  (%ebx)
801019d5:	e8 f6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019da:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019dd:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019df:	89 f0                	mov    %esi,%eax
801019e1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019e6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019eb:	83 c4 0c             	add    $0xc,%esp
801019ee:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
801019f0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
801019f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801019f7:	29 fb                	sub    %edi,%ebx
801019f9:	39 d9                	cmp    %ebx,%ecx
801019fb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019fe:	53                   	push   %ebx
801019ff:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a00:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a02:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a05:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a07:	e8 84 2c 00 00       	call   80104690 <memmove>
    brelse(bp);
80101a0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a0f:	89 14 24             	mov    %edx,(%esp)
80101a12:	e8 c9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a1a:	83 c4 10             	add    $0x10,%esp
80101a1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a20:	77 9e                	ja     801019c0 <readi+0x60>
  }
  return n;
80101a22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a28:	5b                   	pop    %ebx
80101a29:	5e                   	pop    %esi
80101a2a:	5f                   	pop    %edi
80101a2b:	5d                   	pop    %ebp
80101a2c:	c3                   	ret    
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a34:	66 83 f8 09          	cmp    $0x9,%ax
80101a38:	77 17                	ja     80101a51 <readi+0xf1>
80101a3a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a41:	85 c0                	test   %eax,%eax
80101a43:	74 0c                	je     80101a51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a4b:	5b                   	pop    %ebx
80101a4c:	5e                   	pop    %esi
80101a4d:	5f                   	pop    %edi
80101a4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a4f:	ff e0                	jmp    *%eax
      return -1;
80101a51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a56:	eb cd                	jmp    80101a25 <readi+0xc5>
80101a58:	90                   	nop
80101a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	57                   	push   %edi
80101a64:	56                   	push   %esi
80101a65:	53                   	push   %ebx
80101a66:	83 ec 1c             	sub    $0x1c,%esp
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a6f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a72:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a77:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a7d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a80:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a83:	0f 84 b7 00 00 00    	je     80101b40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a8c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a8f:	0f 82 eb 00 00 00    	jb     80101b80 <writei+0x120>
80101a95:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a98:	31 d2                	xor    %edx,%edx
80101a9a:	89 f8                	mov    %edi,%eax
80101a9c:	01 f0                	add    %esi,%eax
80101a9e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101aa1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101aa6:	0f 87 d4 00 00 00    	ja     80101b80 <writei+0x120>
80101aac:	85 d2                	test   %edx,%edx
80101aae:	0f 85 cc 00 00 00    	jne    80101b80 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ab4:	85 ff                	test   %edi,%edi
80101ab6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101abd:	74 72                	je     80101b31 <writei+0xd1>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 f8                	mov    %edi,%eax
80101aca:	e8 91 f8 ff ff       	call   80101360 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 37                	pushl  (%edi)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101add:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae2:	89 f0                	mov    %esi,%eax
80101ae4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae9:	83 c4 0c             	add    $0xc,%esp
80101aec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101af1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101af3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af7:	39 d9                	cmp    %ebx,%ecx
80101af9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101afc:	53                   	push   %ebx
80101afd:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b00:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b02:	50                   	push   %eax
80101b03:	e8 88 2b 00 00       	call   80104690 <memmove>
    log_write(bp);
80101b08:	89 3c 24             	mov    %edi,(%esp)
80101b0b:	e8 70 12 00 00       	call   80102d80 <log_write>
    brelse(bp);
80101b10:	89 3c 24             	mov    %edi,(%esp)
80101b13:	e8 c8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b1b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b1e:	83 c4 10             	add    $0x10,%esp
80101b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b27:	77 97                	ja     80101ac0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b2f:	77 37                	ja     80101b68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b37:	5b                   	pop    %ebx
80101b38:	5e                   	pop    %esi
80101b39:	5f                   	pop    %edi
80101b3a:	5d                   	pop    %ebp
80101b3b:	c3                   	ret    
80101b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 36                	ja     80101b80 <writei+0x120>
80101b4a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 2b                	je     80101b80 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b5f:	ff e0                	jmp    *%eax
80101b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b71:	50                   	push   %eax
80101b72:	e8 59 fa ff ff       	call   801015d0 <iupdate>
80101b77:	83 c4 10             	add    $0x10,%esp
80101b7a:	eb b5                	jmp    80101b31 <writei+0xd1>
80101b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b85:	eb ad                	jmp    80101b34 <writei+0xd4>
80101b87:	89 f6                	mov    %esi,%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b96:	6a 0e                	push   $0xe
80101b98:	ff 75 0c             	pushl  0xc(%ebp)
80101b9b:	ff 75 08             	pushl  0x8(%ebp)
80101b9e:	e8 5d 2b 00 00       	call   80104700 <strncmp>
}
80101ba3:	c9                   	leave  
80101ba4:	c3                   	ret    
80101ba5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bc1:	0f 85 85 00 00 00    	jne    80101c4c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bc7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bca:	31 ff                	xor    %edi,%edi
80101bcc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bcf:	85 d2                	test   %edx,%edx
80101bd1:	74 3e                	je     80101c11 <dirlookup+0x61>
80101bd3:	90                   	nop
80101bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd8:	6a 10                	push   $0x10
80101bda:	57                   	push   %edi
80101bdb:	56                   	push   %esi
80101bdc:	53                   	push   %ebx
80101bdd:	e8 7e fd ff ff       	call   80101960 <readi>
80101be2:	83 c4 10             	add    $0x10,%esp
80101be5:	83 f8 10             	cmp    $0x10,%eax
80101be8:	75 55                	jne    80101c3f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101bea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bef:	74 18                	je     80101c09 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101bf1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bf4:	83 ec 04             	sub    $0x4,%esp
80101bf7:	6a 0e                	push   $0xe
80101bf9:	50                   	push   %eax
80101bfa:	ff 75 0c             	pushl  0xc(%ebp)
80101bfd:	e8 fe 2a 00 00       	call   80104700 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c02:	83 c4 10             	add    $0x10,%esp
80101c05:	85 c0                	test   %eax,%eax
80101c07:	74 17                	je     80101c20 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c09:	83 c7 10             	add    $0x10,%edi
80101c0c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c0f:	72 c7                	jb     80101bd8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c14:	31 c0                	xor    %eax,%eax
}
80101c16:	5b                   	pop    %ebx
80101c17:	5e                   	pop    %esi
80101c18:	5f                   	pop    %edi
80101c19:	5d                   	pop    %ebp
80101c1a:	c3                   	ret    
80101c1b:	90                   	nop
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c20:	8b 45 10             	mov    0x10(%ebp),%eax
80101c23:	85 c0                	test   %eax,%eax
80101c25:	74 05                	je     80101c2c <dirlookup+0x7c>
        *poff = off;
80101c27:	8b 45 10             	mov    0x10(%ebp),%eax
80101c2a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c2c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c30:	8b 03                	mov    (%ebx),%eax
80101c32:	e8 59 f6 ff ff       	call   80101290 <iget>
}
80101c37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c3a:	5b                   	pop    %ebx
80101c3b:	5e                   	pop    %esi
80101c3c:	5f                   	pop    %edi
80101c3d:	5d                   	pop    %ebp
80101c3e:	c3                   	ret    
      panic("dirlookup read");
80101c3f:	83 ec 0c             	sub    $0xc,%esp
80101c42:	68 59 72 10 80       	push   $0x80107259
80101c47:	e8 44 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c4c:	83 ec 0c             	sub    $0xc,%esp
80101c4f:	68 47 72 10 80       	push   $0x80107247
80101c54:	e8 37 e7 ff ff       	call   80100390 <panic>
80101c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c60 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	56                   	push   %esi
80101c65:	53                   	push   %ebx
80101c66:	89 cf                	mov    %ecx,%edi
80101c68:	89 c3                	mov    %eax,%ebx
80101c6a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c6d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c70:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c73:	0f 84 77 01 00 00    	je     80101df0 <namex+0x190>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c79:	e8 a2 1b 00 00       	call   80103820 <myproc>
  acquire(&icache.lock);
80101c7e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c81:	8b b0 cc 00 00 00    	mov    0xcc(%eax),%esi
  acquire(&icache.lock);
80101c87:	68 e0 09 11 80       	push   $0x801109e0
80101c8c:	e8 3f 28 00 00       	call   801044d0 <acquire>
  ip->ref++;
80101c91:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c95:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101c9c:	e8 ef 28 00 00       	call   80104590 <release>
80101ca1:	83 c4 10             	add    $0x10,%esp
80101ca4:	eb 0d                	jmp    80101cb3 <namex+0x53>
80101ca6:	8d 76 00             	lea    0x0(%esi),%esi
80101ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101cb0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cb3:	0f b6 03             	movzbl (%ebx),%eax
80101cb6:	3c 2f                	cmp    $0x2f,%al
80101cb8:	74 f6                	je     80101cb0 <namex+0x50>
  if(*path == 0)
80101cba:	84 c0                	test   %al,%al
80101cbc:	0f 84 f6 00 00 00    	je     80101db8 <namex+0x158>
  while(*path != '/' && *path != 0)
80101cc2:	0f b6 03             	movzbl (%ebx),%eax
80101cc5:	3c 2f                	cmp    $0x2f,%al
80101cc7:	0f 84 bb 00 00 00    	je     80101d88 <namex+0x128>
80101ccd:	84 c0                	test   %al,%al
80101ccf:	89 da                	mov    %ebx,%edx
80101cd1:	75 11                	jne    80101ce4 <namex+0x84>
80101cd3:	e9 b0 00 00 00       	jmp    80101d88 <namex+0x128>
80101cd8:	90                   	nop
80101cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ce0:	84 c0                	test   %al,%al
80101ce2:	74 0a                	je     80101cee <namex+0x8e>
    path++;
80101ce4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101ce7:	0f b6 02             	movzbl (%edx),%eax
80101cea:	3c 2f                	cmp    $0x2f,%al
80101cec:	75 f2                	jne    80101ce0 <namex+0x80>
80101cee:	89 d1                	mov    %edx,%ecx
80101cf0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101cf2:	83 f9 0d             	cmp    $0xd,%ecx
80101cf5:	0f 8e 91 00 00 00    	jle    80101d8c <namex+0x12c>
    memmove(name, s, DIRSIZ);
80101cfb:	83 ec 04             	sub    $0x4,%esp
80101cfe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d01:	6a 0e                	push   $0xe
80101d03:	53                   	push   %ebx
80101d04:	57                   	push   %edi
80101d05:	e8 86 29 00 00       	call   80104690 <memmove>
    path++;
80101d0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d0d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d10:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d12:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d15:	75 11                	jne    80101d28 <namex+0xc8>
80101d17:	89 f6                	mov    %esi,%esi
80101d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d20:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d23:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d26:	74 f8                	je     80101d20 <namex+0xc0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d28:	83 ec 0c             	sub    $0xc,%esp
80101d2b:	56                   	push   %esi
80101d2c:	e8 4f f9 ff ff       	call   80101680 <ilock>
    if(ip->type != T_DIR){
80101d31:	83 c4 10             	add    $0x10,%esp
80101d34:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d39:	0f 85 91 00 00 00    	jne    80101dd0 <namex+0x170>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d42:	85 d2                	test   %edx,%edx
80101d44:	74 09                	je     80101d4f <namex+0xef>
80101d46:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d49:	0f 84 b7 00 00 00    	je     80101e06 <namex+0x1a6>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d4f:	83 ec 04             	sub    $0x4,%esp
80101d52:	6a 00                	push   $0x0
80101d54:	57                   	push   %edi
80101d55:	56                   	push   %esi
80101d56:	e8 55 fe ff ff       	call   80101bb0 <dirlookup>
80101d5b:	83 c4 10             	add    $0x10,%esp
80101d5e:	85 c0                	test   %eax,%eax
80101d60:	74 6e                	je     80101dd0 <namex+0x170>
  iunlock(ip);
80101d62:	83 ec 0c             	sub    $0xc,%esp
80101d65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d68:	56                   	push   %esi
80101d69:	e8 f2 f9 ff ff       	call   80101760 <iunlock>
  iput(ip);
80101d6e:	89 34 24             	mov    %esi,(%esp)
80101d71:	e8 3a fa ff ff       	call   801017b0 <iput>
80101d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d79:	83 c4 10             	add    $0x10,%esp
80101d7c:	89 c6                	mov    %eax,%esi
80101d7e:	e9 30 ff ff ff       	jmp    80101cb3 <namex+0x53>
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
80101d98:	e8 f3 28 00 00       	call   80104690 <memmove>
    name[len] = 0;
80101d9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101da0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101da3:	83 c4 10             	add    $0x10,%esp
80101da6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101daa:	89 d3                	mov    %edx,%ebx
80101dac:	e9 61 ff ff ff       	jmp    80101d12 <namex+0xb2>
80101db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101db8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dbb:	85 c0                	test   %eax,%eax
80101dbd:	75 5d                	jne    80101e1c <namex+0x1bc>
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
80101dd4:	e8 87 f9 ff ff       	call   80101760 <iunlock>
  iput(ip);
80101dd9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ddc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dde:	e8 cd f9 ff ff       	call   801017b0 <iput>
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
80101dfa:	e8 91 f4 ff ff       	call   80101290 <iget>
80101dff:	89 c6                	mov    %eax,%esi
80101e01:	e9 ad fe ff ff       	jmp    80101cb3 <namex+0x53>
      iunlock(ip);
80101e06:	83 ec 0c             	sub    $0xc,%esp
80101e09:	56                   	push   %esi
80101e0a:	e8 51 f9 ff ff       	call   80101760 <iunlock>
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
80101e22:	e8 89 f9 ff ff       	call   801017b0 <iput>
    return 0;
80101e27:	83 c4 10             	add    $0x10,%esp
80101e2a:	eb 93                	jmp    80101dbf <namex+0x15f>
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
80101e42:	e8 69 fd ff ff       	call   80101bb0 <dirlookup>
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
80101e6d:	e8 ee fa ff ff       	call   80101960 <readi>
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
80101e8d:	e8 ce 28 00 00       	call   80104760 <strncpy>
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
80101e9e:	e8 bd fb ff ff       	call   80101a60 <writei>
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
80101eb9:	e8 f2 f8 ff ff       	call   801017b0 <iput>
    return -1;
80101ebe:	83 c4 10             	add    $0x10,%esp
80101ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ec6:	eb e5                	jmp    80101ead <dirlink+0x7d>
      panic("dirlink read");
80101ec8:	83 ec 0c             	sub    $0xc,%esp
80101ecb:	68 68 72 10 80       	push   $0x80107268
80101ed0:	e8 bb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ed5:	83 ec 0c             	sub    $0xc,%esp
80101ed8:	68 6e 78 10 80       	push   $0x8010786e
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
80101efe:	e8 5d fd ff ff       	call   80101c60 <namex>
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
80101f1f:	e9 3c fd ff ff       	jmp    80101c60 <namex>
80101f24:	66 90                	xchg   %ax,%ax
80101f26:	66 90                	xchg   %ax,%ax
80101f28:	66 90                	xchg   %ax,%ax
80101f2a:	66 90                	xchg   %ax,%ax
80101f2c:	66 90                	xchg   %ax,%ax
80101f2e:	66 90                	xchg   %ax,%ax

80101f30 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	57                   	push   %edi
80101f34:	56                   	push   %esi
80101f35:	53                   	push   %ebx
80101f36:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f39:	85 c0                	test   %eax,%eax
80101f3b:	0f 84 b4 00 00 00    	je     80101ff5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f41:	8b 58 08             	mov    0x8(%eax),%ebx
80101f44:	89 c6                	mov    %eax,%esi
80101f46:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f4c:	0f 87 96 00 00 00    	ja     80101fe8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f52:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f57:	89 f6                	mov    %esi,%esi
80101f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f60:	89 ca                	mov    %ecx,%edx
80101f62:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f63:	83 e0 c0             	and    $0xffffffc0,%eax
80101f66:	3c 40                	cmp    $0x40,%al
80101f68:	75 f6                	jne    80101f60 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f6a:	31 ff                	xor    %edi,%edi
80101f6c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f71:	89 f8                	mov    %edi,%eax
80101f73:	ee                   	out    %al,(%dx)
80101f74:	b8 01 00 00 00       	mov    $0x1,%eax
80101f79:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f7e:	ee                   	out    %al,(%dx)
80101f7f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f84:	89 d8                	mov    %ebx,%eax
80101f86:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f87:	89 d8                	mov    %ebx,%eax
80101f89:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f8e:	c1 f8 08             	sar    $0x8,%eax
80101f91:	ee                   	out    %al,(%dx)
80101f92:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f97:	89 f8                	mov    %edi,%eax
80101f99:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f9a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f9e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fa3:	c1 e0 04             	shl    $0x4,%eax
80101fa6:	83 e0 10             	and    $0x10,%eax
80101fa9:	83 c8 e0             	or     $0xffffffe0,%eax
80101fac:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fad:	f6 06 04             	testb  $0x4,(%esi)
80101fb0:	75 16                	jne    80101fc8 <idestart+0x98>
80101fb2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fb7:	89 ca                	mov    %ecx,%edx
80101fb9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fbd:	5b                   	pop    %ebx
80101fbe:	5e                   	pop    %esi
80101fbf:	5f                   	pop    %edi
80101fc0:	5d                   	pop    %ebp
80101fc1:	c3                   	ret    
80101fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fc8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fcd:	89 ca                	mov    %ecx,%edx
80101fcf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fd0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fd5:	83 c6 5c             	add    $0x5c,%esi
80101fd8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fdd:	fc                   	cld    
80101fde:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fe0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fe3:	5b                   	pop    %ebx
80101fe4:	5e                   	pop    %esi
80101fe5:	5f                   	pop    %edi
80101fe6:	5d                   	pop    %ebp
80101fe7:	c3                   	ret    
    panic("incorrect blockno");
80101fe8:	83 ec 0c             	sub    $0xc,%esp
80101feb:	68 d4 72 10 80       	push   $0x801072d4
80101ff0:	e8 9b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80101ff5:	83 ec 0c             	sub    $0xc,%esp
80101ff8:	68 cb 72 10 80       	push   $0x801072cb
80101ffd:	e8 8e e3 ff ff       	call   80100390 <panic>
80102002:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102010 <ideinit>:
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102016:	68 e6 72 10 80       	push   $0x801072e6
8010201b:	68 80 a5 10 80       	push   $0x8010a580
80102020:	e8 6b 23 00 00       	call   80104390 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102025:	58                   	pop    %eax
80102026:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010202b:	5a                   	pop    %edx
8010202c:	83 e8 01             	sub    $0x1,%eax
8010202f:	50                   	push   %eax
80102030:	6a 0e                	push   $0xe
80102032:	e8 a9 02 00 00       	call   801022e0 <ioapicenable>
80102037:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010203a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010203f:	90                   	nop
80102040:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102041:	83 e0 c0             	and    $0xffffffc0,%eax
80102044:	3c 40                	cmp    $0x40,%al
80102046:	75 f8                	jne    80102040 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102048:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010204d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102052:	ee                   	out    %al,(%dx)
80102053:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102058:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010205d:	eb 06                	jmp    80102065 <ideinit+0x55>
8010205f:	90                   	nop
  for(i=0; i<1000; i++){
80102060:	83 e9 01             	sub    $0x1,%ecx
80102063:	74 0f                	je     80102074 <ideinit+0x64>
80102065:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102066:	84 c0                	test   %al,%al
80102068:	74 f6                	je     80102060 <ideinit+0x50>
      havedisk1 = 1;
8010206a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102071:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102074:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102079:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010207e:	ee                   	out    %al,(%dx)
}
8010207f:	c9                   	leave  
80102080:	c3                   	ret    
80102081:	eb 0d                	jmp    80102090 <ideintr>
80102083:	90                   	nop
80102084:	90                   	nop
80102085:	90                   	nop
80102086:	90                   	nop
80102087:	90                   	nop
80102088:	90                   	nop
80102089:	90                   	nop
8010208a:	90                   	nop
8010208b:	90                   	nop
8010208c:	90                   	nop
8010208d:	90                   	nop
8010208e:	90                   	nop
8010208f:	90                   	nop

80102090 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	57                   	push   %edi
80102094:	56                   	push   %esi
80102095:	53                   	push   %ebx
80102096:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102099:	68 80 a5 10 80       	push   $0x8010a580
8010209e:	e8 2d 24 00 00       	call   801044d0 <acquire>

  if((b = idequeue) == 0){
801020a3:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020a9:	83 c4 10             	add    $0x10,%esp
801020ac:	85 db                	test   %ebx,%ebx
801020ae:	74 67                	je     80102117 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020b0:	8b 43 58             	mov    0x58(%ebx),%eax
801020b3:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020b8:	8b 3b                	mov    (%ebx),%edi
801020ba:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020c0:	75 31                	jne    801020f3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020c2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020c7:	89 f6                	mov    %esi,%esi
801020c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020d0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020d1:	89 c6                	mov    %eax,%esi
801020d3:	83 e6 c0             	and    $0xffffffc0,%esi
801020d6:	89 f1                	mov    %esi,%ecx
801020d8:	80 f9 40             	cmp    $0x40,%cl
801020db:	75 f3                	jne    801020d0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020dd:	a8 21                	test   $0x21,%al
801020df:	75 12                	jne    801020f3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801020e1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020e4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020e9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020ee:	fc                   	cld    
801020ef:	f3 6d                	rep insl (%dx),%es:(%edi)
801020f1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020f3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801020f6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801020f9:	89 f9                	mov    %edi,%ecx
801020fb:	83 c9 02             	or     $0x2,%ecx
801020fe:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102100:	53                   	push   %ebx
80102101:	e8 da 1e 00 00       	call   80103fe0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102106:	a1 64 a5 10 80       	mov    0x8010a564,%eax
8010210b:	83 c4 10             	add    $0x10,%esp
8010210e:	85 c0                	test   %eax,%eax
80102110:	74 05                	je     80102117 <ideintr+0x87>
    idestart(idequeue);
80102112:	e8 19 fe ff ff       	call   80101f30 <idestart>
    release(&idelock);
80102117:	83 ec 0c             	sub    $0xc,%esp
8010211a:	68 80 a5 10 80       	push   $0x8010a580
8010211f:	e8 6c 24 00 00       	call   80104590 <release>

  release(&idelock);
}
80102124:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102127:	5b                   	pop    %ebx
80102128:	5e                   	pop    %esi
80102129:	5f                   	pop    %edi
8010212a:	5d                   	pop    %ebp
8010212b:	c3                   	ret    
8010212c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102130 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102130:	55                   	push   %ebp
80102131:	89 e5                	mov    %esp,%ebp
80102133:	53                   	push   %ebx
80102134:	83 ec 10             	sub    $0x10,%esp
80102137:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010213a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010213d:	50                   	push   %eax
8010213e:	e8 fd 21 00 00       	call   80104340 <holdingsleep>
80102143:	83 c4 10             	add    $0x10,%esp
80102146:	85 c0                	test   %eax,%eax
80102148:	0f 84 c6 00 00 00    	je     80102214 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010214e:	8b 03                	mov    (%ebx),%eax
80102150:	83 e0 06             	and    $0x6,%eax
80102153:	83 f8 02             	cmp    $0x2,%eax
80102156:	0f 84 ab 00 00 00    	je     80102207 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010215c:	8b 53 04             	mov    0x4(%ebx),%edx
8010215f:	85 d2                	test   %edx,%edx
80102161:	74 0d                	je     80102170 <iderw+0x40>
80102163:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102168:	85 c0                	test   %eax,%eax
8010216a:	0f 84 b1 00 00 00    	je     80102221 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102170:	83 ec 0c             	sub    $0xc,%esp
80102173:	68 80 a5 10 80       	push   $0x8010a580
80102178:	e8 53 23 00 00       	call   801044d0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102183:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102186:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010218d:	85 d2                	test   %edx,%edx
8010218f:	75 09                	jne    8010219a <iderw+0x6a>
80102191:	eb 6d                	jmp    80102200 <iderw+0xd0>
80102193:	90                   	nop
80102194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102198:	89 c2                	mov    %eax,%edx
8010219a:	8b 42 58             	mov    0x58(%edx),%eax
8010219d:	85 c0                	test   %eax,%eax
8010219f:	75 f7                	jne    80102198 <iderw+0x68>
801021a1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801021a4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801021a6:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021ac:	74 42                	je     801021f0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ae:	8b 03                	mov    (%ebx),%eax
801021b0:	83 e0 06             	and    $0x6,%eax
801021b3:	83 f8 02             	cmp    $0x2,%eax
801021b6:	74 23                	je     801021db <iderw+0xab>
801021b8:	90                   	nop
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021c0:	83 ec 08             	sub    $0x8,%esp
801021c3:	68 80 a5 10 80       	push   $0x8010a580
801021c8:	53                   	push   %ebx
801021c9:	e8 42 1c 00 00       	call   80103e10 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ce:	8b 03                	mov    (%ebx),%eax
801021d0:	83 c4 10             	add    $0x10,%esp
801021d3:	83 e0 06             	and    $0x6,%eax
801021d6:	83 f8 02             	cmp    $0x2,%eax
801021d9:	75 e5                	jne    801021c0 <iderw+0x90>
  }


  release(&idelock);
801021db:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021e5:	c9                   	leave  
  release(&idelock);
801021e6:	e9 a5 23 00 00       	jmp    80104590 <release>
801021eb:	90                   	nop
801021ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801021f0:	89 d8                	mov    %ebx,%eax
801021f2:	e8 39 fd ff ff       	call   80101f30 <idestart>
801021f7:	eb b5                	jmp    801021ae <iderw+0x7e>
801021f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102200:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102205:	eb 9d                	jmp    801021a4 <iderw+0x74>
    panic("iderw: nothing to do");
80102207:	83 ec 0c             	sub    $0xc,%esp
8010220a:	68 00 73 10 80       	push   $0x80107300
8010220f:	e8 7c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102214:	83 ec 0c             	sub    $0xc,%esp
80102217:	68 ea 72 10 80       	push   $0x801072ea
8010221c:	e8 6f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102221:	83 ec 0c             	sub    $0xc,%esp
80102224:	68 15 73 10 80       	push   $0x80107315
80102229:	e8 62 e1 ff ff       	call   80100390 <panic>
8010222e:	66 90                	xchg   %ax,%ax

80102230 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102230:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102231:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102238:	00 c0 fe 
{
8010223b:	89 e5                	mov    %esp,%ebp
8010223d:	56                   	push   %esi
8010223e:	53                   	push   %ebx
  ioapic->reg = reg;
8010223f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102246:	00 00 00 
  return ioapic->data;
80102249:	a1 34 26 11 80       	mov    0x80112634,%eax
8010224e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102251:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102257:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010225d:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102264:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102267:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010226a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010226d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102270:	39 c2                	cmp    %eax,%edx
80102272:	74 16                	je     8010228a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102274:	83 ec 0c             	sub    $0xc,%esp
80102277:	68 34 73 10 80       	push   $0x80107334
8010227c:	e8 df e3 ff ff       	call   80100660 <cprintf>
80102281:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102287:	83 c4 10             	add    $0x10,%esp
8010228a:	83 c3 21             	add    $0x21,%ebx
{
8010228d:	ba 10 00 00 00       	mov    $0x10,%edx
80102292:	b8 20 00 00 00       	mov    $0x20,%eax
80102297:	89 f6                	mov    %esi,%esi
80102299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801022a0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801022a2:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022a8:	89 c6                	mov    %eax,%esi
801022aa:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022b0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022b3:	89 71 10             	mov    %esi,0x10(%ecx)
801022b6:	8d 72 01             	lea    0x1(%edx),%esi
801022b9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022bc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022be:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022c0:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801022c6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022cd:	75 d1                	jne    801022a0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022d2:	5b                   	pop    %ebx
801022d3:	5e                   	pop    %esi
801022d4:	5d                   	pop    %ebp
801022d5:	c3                   	ret    
801022d6:	8d 76 00             	lea    0x0(%esi),%esi
801022d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022e0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022e0:	55                   	push   %ebp
  ioapic->reg = reg;
801022e1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
801022e7:	89 e5                	mov    %esp,%ebp
801022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022ec:	8d 50 20             	lea    0x20(%eax),%edx
801022ef:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801022f3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022f5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022fb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022fe:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102301:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102304:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102306:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010230b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010230e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102311:	5d                   	pop    %ebp
80102312:	c3                   	ret    
80102313:	66 90                	xchg   %ax,%ax
80102315:	66 90                	xchg   %ax,%ax
80102317:	66 90                	xchg   %ax,%ax
80102319:	66 90                	xchg   %ax,%ax
8010231b:	66 90                	xchg   %ax,%ax
8010231d:	66 90                	xchg   %ax,%ax
8010231f:	90                   	nop

80102320 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	53                   	push   %ebx
80102324:	83 ec 04             	sub    $0x4,%esp
80102327:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010232a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102330:	75 70                	jne    801023a2 <kfree+0x82>
80102332:	81 fb a8 6d 11 80    	cmp    $0x80116da8,%ebx
80102338:	72 68                	jb     801023a2 <kfree+0x82>
8010233a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102340:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102345:	77 5b                	ja     801023a2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102347:	83 ec 04             	sub    $0x4,%esp
8010234a:	68 00 10 00 00       	push   $0x1000
8010234f:	6a 01                	push   $0x1
80102351:	53                   	push   %ebx
80102352:	e8 89 22 00 00       	call   801045e0 <memset>

  if(kmem.use_lock)
80102357:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010235d:	83 c4 10             	add    $0x10,%esp
80102360:	85 d2                	test   %edx,%edx
80102362:	75 2c                	jne    80102390 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102364:	a1 78 26 11 80       	mov    0x80112678,%eax
80102369:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010236b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102370:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102376:	85 c0                	test   %eax,%eax
80102378:	75 06                	jne    80102380 <kfree+0x60>
    release(&kmem.lock);
}
8010237a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010237d:	c9                   	leave  
8010237e:	c3                   	ret    
8010237f:	90                   	nop
    release(&kmem.lock);
80102380:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102387:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010238a:	c9                   	leave  
    release(&kmem.lock);
8010238b:	e9 00 22 00 00       	jmp    80104590 <release>
    acquire(&kmem.lock);
80102390:	83 ec 0c             	sub    $0xc,%esp
80102393:	68 40 26 11 80       	push   $0x80112640
80102398:	e8 33 21 00 00       	call   801044d0 <acquire>
8010239d:	83 c4 10             	add    $0x10,%esp
801023a0:	eb c2                	jmp    80102364 <kfree+0x44>
    panic("kfree");
801023a2:	83 ec 0c             	sub    $0xc,%esp
801023a5:	68 66 73 10 80       	push   $0x80107366
801023aa:	e8 e1 df ff ff       	call   80100390 <panic>
801023af:	90                   	nop

801023b0 <freerange>:
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	56                   	push   %esi
801023b4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023b5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023cd:	39 de                	cmp    %ebx,%esi
801023cf:	72 23                	jb     801023f4 <freerange+0x44>
801023d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023d8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023de:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023e7:	50                   	push   %eax
801023e8:	e8 33 ff ff ff       	call   80102320 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023ed:	83 c4 10             	add    $0x10,%esp
801023f0:	39 f3                	cmp    %esi,%ebx
801023f2:	76 e4                	jbe    801023d8 <freerange+0x28>
}
801023f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023f7:	5b                   	pop    %ebx
801023f8:	5e                   	pop    %esi
801023f9:	5d                   	pop    %ebp
801023fa:	c3                   	ret    
801023fb:	90                   	nop
801023fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102400 <kinit1>:
{
80102400:	55                   	push   %ebp
80102401:	89 e5                	mov    %esp,%ebp
80102403:	56                   	push   %esi
80102404:	53                   	push   %ebx
80102405:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102408:	83 ec 08             	sub    $0x8,%esp
8010240b:	68 6c 73 10 80       	push   $0x8010736c
80102410:	68 40 26 11 80       	push   $0x80112640
80102415:	e8 76 1f 00 00       	call   80104390 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010241a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010241d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102420:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102427:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010242a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102430:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102436:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010243c:	39 de                	cmp    %ebx,%esi
8010243e:	72 1c                	jb     8010245c <kinit1+0x5c>
    kfree(p);
80102440:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102446:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102449:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010244f:	50                   	push   %eax
80102450:	e8 cb fe ff ff       	call   80102320 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102455:	83 c4 10             	add    $0x10,%esp
80102458:	39 de                	cmp    %ebx,%esi
8010245a:	73 e4                	jae    80102440 <kinit1+0x40>
}
8010245c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010245f:	5b                   	pop    %ebx
80102460:	5e                   	pop    %esi
80102461:	5d                   	pop    %ebp
80102462:	c3                   	ret    
80102463:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102470 <kinit2>:
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	56                   	push   %esi
80102474:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102475:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102478:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010247b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102481:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102487:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010248d:	39 de                	cmp    %ebx,%esi
8010248f:	72 23                	jb     801024b4 <kinit2+0x44>
80102491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102498:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010249e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024a7:	50                   	push   %eax
801024a8:	e8 73 fe ff ff       	call   80102320 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024ad:	83 c4 10             	add    $0x10,%esp
801024b0:	39 de                	cmp    %ebx,%esi
801024b2:	73 e4                	jae    80102498 <kinit2+0x28>
  kmem.use_lock = 1;
801024b4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801024bb:	00 00 00 
}
801024be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024c1:	5b                   	pop    %ebx
801024c2:	5e                   	pop    %esi
801024c3:	5d                   	pop    %ebp
801024c4:	c3                   	ret    
801024c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024d0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801024d0:	a1 74 26 11 80       	mov    0x80112674,%eax
801024d5:	85 c0                	test   %eax,%eax
801024d7:	75 1f                	jne    801024f8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024d9:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
801024de:	85 c0                	test   %eax,%eax
801024e0:	74 0e                	je     801024f0 <kalloc+0x20>
    kmem.freelist = r->next;
801024e2:	8b 10                	mov    (%eax),%edx
801024e4:	89 15 78 26 11 80    	mov    %edx,0x80112678
801024ea:	c3                   	ret    
801024eb:	90                   	nop
801024ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801024f0:	f3 c3                	repz ret 
801024f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801024f8:	55                   	push   %ebp
801024f9:	89 e5                	mov    %esp,%ebp
801024fb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801024fe:	68 40 26 11 80       	push   $0x80112640
80102503:	e8 c8 1f 00 00       	call   801044d0 <acquire>
  r = kmem.freelist;
80102508:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102516:	85 c0                	test   %eax,%eax
80102518:	74 08                	je     80102522 <kalloc+0x52>
    kmem.freelist = r->next;
8010251a:	8b 08                	mov    (%eax),%ecx
8010251c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
80102522:	85 d2                	test   %edx,%edx
80102524:	74 16                	je     8010253c <kalloc+0x6c>
    release(&kmem.lock);
80102526:	83 ec 0c             	sub    $0xc,%esp
80102529:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010252c:	68 40 26 11 80       	push   $0x80112640
80102531:	e8 5a 20 00 00       	call   80104590 <release>
  return (char*)r;
80102536:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102539:	83 c4 10             	add    $0x10,%esp
}
8010253c:	c9                   	leave  
8010253d:	c3                   	ret    
8010253e:	66 90                	xchg   %ax,%ax

80102540 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102540:	ba 64 00 00 00       	mov    $0x64,%edx
80102545:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102546:	a8 01                	test   $0x1,%al
80102548:	0f 84 c2 00 00 00    	je     80102610 <kbdgetc+0xd0>
8010254e:	ba 60 00 00 00       	mov    $0x60,%edx
80102553:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102554:	0f b6 d0             	movzbl %al,%edx
80102557:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx

  if(data == 0xE0){
8010255d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102563:	0f 84 7f 00 00 00    	je     801025e8 <kbdgetc+0xa8>
{
80102569:	55                   	push   %ebp
8010256a:	89 e5                	mov    %esp,%ebp
8010256c:	53                   	push   %ebx
8010256d:	89 cb                	mov    %ecx,%ebx
8010256f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102572:	84 c0                	test   %al,%al
80102574:	78 4a                	js     801025c0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102576:	85 db                	test   %ebx,%ebx
80102578:	74 09                	je     80102583 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010257a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010257d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102580:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102583:	0f b6 82 a0 74 10 80 	movzbl -0x7fef8b60(%edx),%eax
8010258a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010258c:	0f b6 82 a0 73 10 80 	movzbl -0x7fef8c60(%edx),%eax
80102593:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102595:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102597:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010259d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801025a0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025a3:	8b 04 85 80 73 10 80 	mov    -0x7fef8c80(,%eax,4),%eax
801025aa:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801025ae:	74 31                	je     801025e1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025b0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025b3:	83 fa 19             	cmp    $0x19,%edx
801025b6:	77 40                	ja     801025f8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025b8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025bb:	5b                   	pop    %ebx
801025bc:	5d                   	pop    %ebp
801025bd:	c3                   	ret    
801025be:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025c0:	83 e0 7f             	and    $0x7f,%eax
801025c3:	85 db                	test   %ebx,%ebx
801025c5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025c8:	0f b6 82 a0 74 10 80 	movzbl -0x7fef8b60(%edx),%eax
801025cf:	83 c8 40             	or     $0x40,%eax
801025d2:	0f b6 c0             	movzbl %al,%eax
801025d5:	f7 d0                	not    %eax
801025d7:	21 c1                	and    %eax,%ecx
    return 0;
801025d9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801025db:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
801025e1:	5b                   	pop    %ebx
801025e2:	5d                   	pop    %ebp
801025e3:	c3                   	ret    
801025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025e8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801025eb:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801025ed:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
    return 0;
801025f3:	c3                   	ret    
801025f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801025f8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025fb:	8d 50 20             	lea    0x20(%eax),%edx
}
801025fe:	5b                   	pop    %ebx
      c += 'a' - 'A';
801025ff:	83 f9 1a             	cmp    $0x1a,%ecx
80102602:	0f 42 c2             	cmovb  %edx,%eax
}
80102605:	5d                   	pop    %ebp
80102606:	c3                   	ret    
80102607:	89 f6                	mov    %esi,%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102610:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102615:	c3                   	ret    
80102616:	8d 76 00             	lea    0x0(%esi),%esi
80102619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102620 <kbdintr>:

void
kbdintr(void)
{
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102626:	68 40 25 10 80       	push   $0x80102540
8010262b:	e8 e0 e1 ff ff       	call   80100810 <consoleintr>
}
80102630:	83 c4 10             	add    $0x10,%esp
80102633:	c9                   	leave  
80102634:	c3                   	ret    
80102635:	66 90                	xchg   %ax,%ax
80102637:	66 90                	xchg   %ax,%ax
80102639:	66 90                	xchg   %ax,%ax
8010263b:	66 90                	xchg   %ax,%ax
8010263d:	66 90                	xchg   %ax,%ax
8010263f:	90                   	nop

80102640 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102640:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102645:	55                   	push   %ebp
80102646:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102648:	85 c0                	test   %eax,%eax
8010264a:	0f 84 c8 00 00 00    	je     80102718 <lapicinit+0xd8>
  lapic[index] = value;
80102650:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102657:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010265a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010265d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102664:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102667:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010266a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102671:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102674:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102677:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010267e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102681:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102684:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010268b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010268e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102691:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102698:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010269b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010269e:	8b 50 30             	mov    0x30(%eax),%edx
801026a1:	c1 ea 10             	shr    $0x10,%edx
801026a4:	80 fa 03             	cmp    $0x3,%dl
801026a7:	77 77                	ja     80102720 <lapicinit+0xe0>
  lapic[index] = value;
801026a9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026b0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026bd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026c0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ca:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026cd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026d0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026d7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026da:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026dd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026ea:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026f1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026f4:	8b 50 20             	mov    0x20(%eax),%edx
801026f7:	89 f6                	mov    %esi,%esi
801026f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102700:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102706:	80 e6 10             	and    $0x10,%dh
80102709:	75 f5                	jne    80102700 <lapicinit+0xc0>
  lapic[index] = value;
8010270b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102712:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102715:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102718:	5d                   	pop    %ebp
80102719:	c3                   	ret    
8010271a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102720:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102727:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010272a:	8b 50 20             	mov    0x20(%eax),%edx
8010272d:	e9 77 ff ff ff       	jmp    801026a9 <lapicinit+0x69>
80102732:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102740 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102740:	8b 15 7c 26 11 80    	mov    0x8011267c,%edx
{
80102746:	55                   	push   %ebp
80102747:	31 c0                	xor    %eax,%eax
80102749:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010274b:	85 d2                	test   %edx,%edx
8010274d:	74 06                	je     80102755 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010274f:	8b 42 20             	mov    0x20(%edx),%eax
80102752:	c1 e8 18             	shr    $0x18,%eax
}
80102755:	5d                   	pop    %ebp
80102756:	c3                   	ret    
80102757:	89 f6                	mov    %esi,%esi
80102759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102760 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102760:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102765:	55                   	push   %ebp
80102766:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102768:	85 c0                	test   %eax,%eax
8010276a:	74 0d                	je     80102779 <lapiceoi+0x19>
  lapic[index] = value;
8010276c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102773:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102776:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102779:	5d                   	pop    %ebp
8010277a:	c3                   	ret    
8010277b:	90                   	nop
8010277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102780 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102780:	55                   	push   %ebp
80102781:	89 e5                	mov    %esp,%ebp
}
80102783:	5d                   	pop    %ebp
80102784:	c3                   	ret    
80102785:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102790 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102790:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102791:	b8 0f 00 00 00       	mov    $0xf,%eax
80102796:	ba 70 00 00 00       	mov    $0x70,%edx
8010279b:	89 e5                	mov    %esp,%ebp
8010279d:	53                   	push   %ebx
8010279e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027a4:	ee                   	out    %al,(%dx)
801027a5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027aa:	ba 71 00 00 00       	mov    $0x71,%edx
801027af:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027b0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027b2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027b5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027bb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027bd:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027c0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027c3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027c5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027c8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027ce:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801027d3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027d9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027dc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027e3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027e9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027f0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027f6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027fc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027ff:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102805:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102808:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010280e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102811:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102817:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010281a:	5b                   	pop    %ebx
8010281b:	5d                   	pop    %ebp
8010281c:	c3                   	ret    
8010281d:	8d 76 00             	lea    0x0(%esi),%esi

80102820 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102820:	55                   	push   %ebp
80102821:	b8 0b 00 00 00       	mov    $0xb,%eax
80102826:	ba 70 00 00 00       	mov    $0x70,%edx
8010282b:	89 e5                	mov    %esp,%ebp
8010282d:	57                   	push   %edi
8010282e:	56                   	push   %esi
8010282f:	53                   	push   %ebx
80102830:	83 ec 4c             	sub    $0x4c,%esp
80102833:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102834:	ba 71 00 00 00       	mov    $0x71,%edx
80102839:	ec                   	in     (%dx),%al
8010283a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010283d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102842:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102845:	8d 76 00             	lea    0x0(%esi),%esi
80102848:	31 c0                	xor    %eax,%eax
8010284a:	89 da                	mov    %ebx,%edx
8010284c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010284d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102852:	89 ca                	mov    %ecx,%edx
80102854:	ec                   	in     (%dx),%al
80102855:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102858:	89 da                	mov    %ebx,%edx
8010285a:	b8 02 00 00 00       	mov    $0x2,%eax
8010285f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102860:	89 ca                	mov    %ecx,%edx
80102862:	ec                   	in     (%dx),%al
80102863:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102866:	89 da                	mov    %ebx,%edx
80102868:	b8 04 00 00 00       	mov    $0x4,%eax
8010286d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286e:	89 ca                	mov    %ecx,%edx
80102870:	ec                   	in     (%dx),%al
80102871:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102874:	89 da                	mov    %ebx,%edx
80102876:	b8 07 00 00 00       	mov    $0x7,%eax
8010287b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287c:	89 ca                	mov    %ecx,%edx
8010287e:	ec                   	in     (%dx),%al
8010287f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102882:	89 da                	mov    %ebx,%edx
80102884:	b8 08 00 00 00       	mov    $0x8,%eax
80102889:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288a:	89 ca                	mov    %ecx,%edx
8010288c:	ec                   	in     (%dx),%al
8010288d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010288f:	89 da                	mov    %ebx,%edx
80102891:	b8 09 00 00 00       	mov    $0x9,%eax
80102896:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102897:	89 ca                	mov    %ecx,%edx
80102899:	ec                   	in     (%dx),%al
8010289a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010289c:	89 da                	mov    %ebx,%edx
8010289e:	b8 0a 00 00 00       	mov    $0xa,%eax
801028a3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028a4:	89 ca                	mov    %ecx,%edx
801028a6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028a7:	84 c0                	test   %al,%al
801028a9:	78 9d                	js     80102848 <cmostime+0x28>
  return inb(CMOS_RETURN);
801028ab:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801028af:	89 fa                	mov    %edi,%edx
801028b1:	0f b6 fa             	movzbl %dl,%edi
801028b4:	89 f2                	mov    %esi,%edx
801028b6:	0f b6 f2             	movzbl %dl,%esi
801028b9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028bc:	89 da                	mov    %ebx,%edx
801028be:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028c1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028c4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028c8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028cb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028cf:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028d2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801028d6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028d9:	31 c0                	xor    %eax,%eax
801028db:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028dc:	89 ca                	mov    %ecx,%edx
801028de:	ec                   	in     (%dx),%al
801028df:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e2:	89 da                	mov    %ebx,%edx
801028e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028e7:	b8 02 00 00 00       	mov    $0x2,%eax
801028ec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ed:	89 ca                	mov    %ecx,%edx
801028ef:	ec                   	in     (%dx),%al
801028f0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f3:	89 da                	mov    %ebx,%edx
801028f5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028f8:	b8 04 00 00 00       	mov    $0x4,%eax
801028fd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028fe:	89 ca                	mov    %ecx,%edx
80102900:	ec                   	in     (%dx),%al
80102901:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102904:	89 da                	mov    %ebx,%edx
80102906:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102909:	b8 07 00 00 00       	mov    $0x7,%eax
8010290e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290f:	89 ca                	mov    %ecx,%edx
80102911:	ec                   	in     (%dx),%al
80102912:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102915:	89 da                	mov    %ebx,%edx
80102917:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010291a:	b8 08 00 00 00       	mov    $0x8,%eax
8010291f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102920:	89 ca                	mov    %ecx,%edx
80102922:	ec                   	in     (%dx),%al
80102923:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102926:	89 da                	mov    %ebx,%edx
80102928:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010292b:	b8 09 00 00 00       	mov    $0x9,%eax
80102930:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102931:	89 ca                	mov    %ecx,%edx
80102933:	ec                   	in     (%dx),%al
80102934:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102937:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010293a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010293d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102940:	6a 18                	push   $0x18
80102942:	50                   	push   %eax
80102943:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102946:	50                   	push   %eax
80102947:	e8 e4 1c 00 00       	call   80104630 <memcmp>
8010294c:	83 c4 10             	add    $0x10,%esp
8010294f:	85 c0                	test   %eax,%eax
80102951:	0f 85 f1 fe ff ff    	jne    80102848 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102957:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010295b:	75 78                	jne    801029d5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010295d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102960:	89 c2                	mov    %eax,%edx
80102962:	83 e0 0f             	and    $0xf,%eax
80102965:	c1 ea 04             	shr    $0x4,%edx
80102968:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010296b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010296e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102971:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102974:	89 c2                	mov    %eax,%edx
80102976:	83 e0 0f             	and    $0xf,%eax
80102979:	c1 ea 04             	shr    $0x4,%edx
8010297c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010297f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102982:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102985:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102988:	89 c2                	mov    %eax,%edx
8010298a:	83 e0 0f             	and    $0xf,%eax
8010298d:	c1 ea 04             	shr    $0x4,%edx
80102990:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102993:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102996:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102999:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010299c:	89 c2                	mov    %eax,%edx
8010299e:	83 e0 0f             	and    $0xf,%eax
801029a1:	c1 ea 04             	shr    $0x4,%edx
801029a4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029a7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029aa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029b0:	89 c2                	mov    %eax,%edx
801029b2:	83 e0 0f             	and    $0xf,%eax
801029b5:	c1 ea 04             	shr    $0x4,%edx
801029b8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029bb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029be:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029c4:	89 c2                	mov    %eax,%edx
801029c6:	83 e0 0f             	and    $0xf,%eax
801029c9:	c1 ea 04             	shr    $0x4,%edx
801029cc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029cf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029d2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029d5:	8b 75 08             	mov    0x8(%ebp),%esi
801029d8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029db:	89 06                	mov    %eax,(%esi)
801029dd:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029e0:	89 46 04             	mov    %eax,0x4(%esi)
801029e3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029e6:	89 46 08             	mov    %eax,0x8(%esi)
801029e9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029ec:	89 46 0c             	mov    %eax,0xc(%esi)
801029ef:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029f2:	89 46 10             	mov    %eax,0x10(%esi)
801029f5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029f8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801029fb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a05:	5b                   	pop    %ebx
80102a06:	5e                   	pop    %esi
80102a07:	5f                   	pop    %edi
80102a08:	5d                   	pop    %ebp
80102a09:	c3                   	ret    
80102a0a:	66 90                	xchg   %ax,%ax
80102a0c:	66 90                	xchg   %ax,%ax
80102a0e:	66 90                	xchg   %ax,%ax

80102a10 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a10:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102a16:	85 c9                	test   %ecx,%ecx
80102a18:	0f 8e 8a 00 00 00    	jle    80102aa8 <install_trans+0x98>
{
80102a1e:	55                   	push   %ebp
80102a1f:	89 e5                	mov    %esp,%ebp
80102a21:	57                   	push   %edi
80102a22:	56                   	push   %esi
80102a23:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a24:	31 db                	xor    %ebx,%ebx
{
80102a26:	83 ec 0c             	sub    $0xc,%esp
80102a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a30:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a35:	83 ec 08             	sub    $0x8,%esp
80102a38:	01 d8                	add    %ebx,%eax
80102a3a:	83 c0 01             	add    $0x1,%eax
80102a3d:	50                   	push   %eax
80102a3e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102a44:	e8 87 d6 ff ff       	call   801000d0 <bread>
80102a49:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a4b:	58                   	pop    %eax
80102a4c:	5a                   	pop    %edx
80102a4d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102a54:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102a5a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a5d:	e8 6e d6 ff ff       	call   801000d0 <bread>
80102a62:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a64:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a67:	83 c4 0c             	add    $0xc,%esp
80102a6a:	68 00 02 00 00       	push   $0x200
80102a6f:	50                   	push   %eax
80102a70:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a73:	50                   	push   %eax
80102a74:	e8 17 1c 00 00       	call   80104690 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a79:	89 34 24             	mov    %esi,(%esp)
80102a7c:	e8 1f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a81:	89 3c 24             	mov    %edi,(%esp)
80102a84:	e8 57 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a89:	89 34 24             	mov    %esi,(%esp)
80102a8c:	e8 4f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102a91:	83 c4 10             	add    $0x10,%esp
80102a94:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102a9a:	7f 94                	jg     80102a30 <install_trans+0x20>
  }
}
80102a9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a9f:	5b                   	pop    %ebx
80102aa0:	5e                   	pop    %esi
80102aa1:	5f                   	pop    %edi
80102aa2:	5d                   	pop    %ebp
80102aa3:	c3                   	ret    
80102aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102aa8:	f3 c3                	repz ret 
80102aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ab0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ab0:	55                   	push   %ebp
80102ab1:	89 e5                	mov    %esp,%ebp
80102ab3:	56                   	push   %esi
80102ab4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102ab5:	83 ec 08             	sub    $0x8,%esp
80102ab8:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102abe:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102ac4:	e8 07 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ac9:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102acf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ad2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102ad4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102ad6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ad9:	7e 16                	jle    80102af1 <write_head+0x41>
80102adb:	c1 e3 02             	shl    $0x2,%ebx
80102ade:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102ae0:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102ae6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102aea:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102aed:	39 da                	cmp    %ebx,%edx
80102aef:	75 ef                	jne    80102ae0 <write_head+0x30>
  }
  bwrite(buf);
80102af1:	83 ec 0c             	sub    $0xc,%esp
80102af4:	56                   	push   %esi
80102af5:	e8 a6 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102afa:	89 34 24             	mov    %esi,(%esp)
80102afd:	e8 de d6 ff ff       	call   801001e0 <brelse>
}
80102b02:	83 c4 10             	add    $0x10,%esp
80102b05:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b08:	5b                   	pop    %ebx
80102b09:	5e                   	pop    %esi
80102b0a:	5d                   	pop    %ebp
80102b0b:	c3                   	ret    
80102b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b10 <initlog>:
{
80102b10:	55                   	push   %ebp
80102b11:	89 e5                	mov    %esp,%ebp
80102b13:	53                   	push   %ebx
80102b14:	83 ec 2c             	sub    $0x2c,%esp
80102b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b1a:	68 a0 75 10 80       	push   $0x801075a0
80102b1f:	68 80 26 11 80       	push   $0x80112680
80102b24:	e8 67 18 00 00       	call   80104390 <initlock>
  readsb(dev, &sb);
80102b29:	58                   	pop    %eax
80102b2a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b2d:	5a                   	pop    %edx
80102b2e:	50                   	push   %eax
80102b2f:	53                   	push   %ebx
80102b30:	e8 0b e9 ff ff       	call   80101440 <readsb>
  log.size = sb.nlog;
80102b35:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b3b:	59                   	pop    %ecx
  log.dev = dev;
80102b3c:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102b42:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102b48:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102b4d:	5a                   	pop    %edx
80102b4e:	50                   	push   %eax
80102b4f:	53                   	push   %ebx
80102b50:	e8 7b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b55:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b58:	83 c4 10             	add    $0x10,%esp
80102b5b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b5d:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102b63:	7e 1c                	jle    80102b81 <initlog+0x71>
80102b65:	c1 e3 02             	shl    $0x2,%ebx
80102b68:	31 d2                	xor    %edx,%edx
80102b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102b70:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b74:	83 c2 04             	add    $0x4,%edx
80102b77:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102b7d:	39 d3                	cmp    %edx,%ebx
80102b7f:	75 ef                	jne    80102b70 <initlog+0x60>
  brelse(buf);
80102b81:	83 ec 0c             	sub    $0xc,%esp
80102b84:	50                   	push   %eax
80102b85:	e8 56 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b8a:	e8 81 fe ff ff       	call   80102a10 <install_trans>
  log.lh.n = 0;
80102b8f:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102b96:	00 00 00 
  write_head(); // clear the log
80102b99:	e8 12 ff ff ff       	call   80102ab0 <write_head>
}
80102b9e:	83 c4 10             	add    $0x10,%esp
80102ba1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ba4:	c9                   	leave  
80102ba5:	c3                   	ret    
80102ba6:	8d 76 00             	lea    0x0(%esi),%esi
80102ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bb0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102bb0:	55                   	push   %ebp
80102bb1:	89 e5                	mov    %esp,%ebp
80102bb3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102bb6:	68 80 26 11 80       	push   $0x80112680
80102bbb:	e8 10 19 00 00       	call   801044d0 <acquire>
80102bc0:	83 c4 10             	add    $0x10,%esp
80102bc3:	eb 18                	jmp    80102bdd <begin_op+0x2d>
80102bc5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bc8:	83 ec 08             	sub    $0x8,%esp
80102bcb:	68 80 26 11 80       	push   $0x80112680
80102bd0:	68 80 26 11 80       	push   $0x80112680
80102bd5:	e8 36 12 00 00       	call   80103e10 <sleep>
80102bda:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102bdd:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102be2:	85 c0                	test   %eax,%eax
80102be4:	75 e2                	jne    80102bc8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102be6:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102beb:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102bf1:	83 c0 01             	add    $0x1,%eax
80102bf4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102bf7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bfa:	83 fa 1e             	cmp    $0x1e,%edx
80102bfd:	7f c9                	jg     80102bc8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bff:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102c02:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102c07:	68 80 26 11 80       	push   $0x80112680
80102c0c:	e8 7f 19 00 00       	call   80104590 <release>
      break;
    }
  }
}
80102c11:	83 c4 10             	add    $0x10,%esp
80102c14:	c9                   	leave  
80102c15:	c3                   	ret    
80102c16:	8d 76 00             	lea    0x0(%esi),%esi
80102c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c20 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	57                   	push   %edi
80102c24:	56                   	push   %esi
80102c25:	53                   	push   %ebx
80102c26:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c29:	68 80 26 11 80       	push   $0x80112680
80102c2e:	e8 9d 18 00 00       	call   801044d0 <acquire>
  log.outstanding -= 1;
80102c33:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102c38:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102c3e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c41:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c44:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c46:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102c4c:	0f 85 1a 01 00 00    	jne    80102d6c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c52:	85 db                	test   %ebx,%ebx
80102c54:	0f 85 ee 00 00 00    	jne    80102d48 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c5a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c5d:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102c64:	00 00 00 
  release(&log.lock);
80102c67:	68 80 26 11 80       	push   $0x80112680
80102c6c:	e8 1f 19 00 00       	call   80104590 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c71:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102c77:	83 c4 10             	add    $0x10,%esp
80102c7a:	85 c9                	test   %ecx,%ecx
80102c7c:	0f 8e 85 00 00 00    	jle    80102d07 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c82:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102c87:	83 ec 08             	sub    $0x8,%esp
80102c8a:	01 d8                	add    %ebx,%eax
80102c8c:	83 c0 01             	add    $0x1,%eax
80102c8f:	50                   	push   %eax
80102c90:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102c96:	e8 35 d4 ff ff       	call   801000d0 <bread>
80102c9b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c9d:	58                   	pop    %eax
80102c9e:	5a                   	pop    %edx
80102c9f:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102ca6:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102cac:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102caf:	e8 1c d4 ff ff       	call   801000d0 <bread>
80102cb4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102cb6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102cb9:	83 c4 0c             	add    $0xc,%esp
80102cbc:	68 00 02 00 00       	push   $0x200
80102cc1:	50                   	push   %eax
80102cc2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cc5:	50                   	push   %eax
80102cc6:	e8 c5 19 00 00       	call   80104690 <memmove>
    bwrite(to);  // write the log
80102ccb:	89 34 24             	mov    %esi,(%esp)
80102cce:	e8 cd d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cd3:	89 3c 24             	mov    %edi,(%esp)
80102cd6:	e8 05 d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102cdb:	89 34 24             	mov    %esi,(%esp)
80102cde:	e8 fd d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ce3:	83 c4 10             	add    $0x10,%esp
80102ce6:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102cec:	7c 94                	jl     80102c82 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cee:	e8 bd fd ff ff       	call   80102ab0 <write_head>
    install_trans(); // Now install writes to home locations
80102cf3:	e8 18 fd ff ff       	call   80102a10 <install_trans>
    log.lh.n = 0;
80102cf8:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102cff:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d02:	e8 a9 fd ff ff       	call   80102ab0 <write_head>
    acquire(&log.lock);
80102d07:	83 ec 0c             	sub    $0xc,%esp
80102d0a:	68 80 26 11 80       	push   $0x80112680
80102d0f:	e8 bc 17 00 00       	call   801044d0 <acquire>
    wakeup(&log);
80102d14:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102d1b:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102d22:	00 00 00 
    wakeup(&log);
80102d25:	e8 b6 12 00 00       	call   80103fe0 <wakeup>
    release(&log.lock);
80102d2a:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d31:	e8 5a 18 00 00       	call   80104590 <release>
80102d36:	83 c4 10             	add    $0x10,%esp
}
80102d39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d3c:	5b                   	pop    %ebx
80102d3d:	5e                   	pop    %esi
80102d3e:	5f                   	pop    %edi
80102d3f:	5d                   	pop    %ebp
80102d40:	c3                   	ret    
80102d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d48:	83 ec 0c             	sub    $0xc,%esp
80102d4b:	68 80 26 11 80       	push   $0x80112680
80102d50:	e8 8b 12 00 00       	call   80103fe0 <wakeup>
  release(&log.lock);
80102d55:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d5c:	e8 2f 18 00 00       	call   80104590 <release>
80102d61:	83 c4 10             	add    $0x10,%esp
}
80102d64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d67:	5b                   	pop    %ebx
80102d68:	5e                   	pop    %esi
80102d69:	5f                   	pop    %edi
80102d6a:	5d                   	pop    %ebp
80102d6b:	c3                   	ret    
    panic("log.committing");
80102d6c:	83 ec 0c             	sub    $0xc,%esp
80102d6f:	68 a4 75 10 80       	push   $0x801075a4
80102d74:	e8 17 d6 ff ff       	call   80100390 <panic>
80102d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d80 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d80:	55                   	push   %ebp
80102d81:	89 e5                	mov    %esp,%ebp
80102d83:	53                   	push   %ebx
80102d84:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d87:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102d8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d90:	83 fa 1d             	cmp    $0x1d,%edx
80102d93:	0f 8f 9d 00 00 00    	jg     80102e36 <log_write+0xb6>
80102d99:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102d9e:	83 e8 01             	sub    $0x1,%eax
80102da1:	39 c2                	cmp    %eax,%edx
80102da3:	0f 8d 8d 00 00 00    	jge    80102e36 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102da9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102dae:	85 c0                	test   %eax,%eax
80102db0:	0f 8e 8d 00 00 00    	jle    80102e43 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102db6:	83 ec 0c             	sub    $0xc,%esp
80102db9:	68 80 26 11 80       	push   $0x80112680
80102dbe:	e8 0d 17 00 00       	call   801044d0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102dc3:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102dc9:	83 c4 10             	add    $0x10,%esp
80102dcc:	83 f9 00             	cmp    $0x0,%ecx
80102dcf:	7e 57                	jle    80102e28 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dd1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102dd4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dd6:	3b 15 cc 26 11 80    	cmp    0x801126cc,%edx
80102ddc:	75 0b                	jne    80102de9 <log_write+0x69>
80102dde:	eb 38                	jmp    80102e18 <log_write+0x98>
80102de0:	39 14 85 cc 26 11 80 	cmp    %edx,-0x7feed934(,%eax,4)
80102de7:	74 2f                	je     80102e18 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102de9:	83 c0 01             	add    $0x1,%eax
80102dec:	39 c1                	cmp    %eax,%ecx
80102dee:	75 f0                	jne    80102de0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102df0:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102df7:	83 c0 01             	add    $0x1,%eax
80102dfa:	a3 c8 26 11 80       	mov    %eax,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102dff:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e02:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102e09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e0c:	c9                   	leave  
  release(&log.lock);
80102e0d:	e9 7e 17 00 00       	jmp    80104590 <release>
80102e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e18:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
80102e1f:	eb de                	jmp    80102dff <log_write+0x7f>
80102e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e28:	8b 43 08             	mov    0x8(%ebx),%eax
80102e2b:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102e30:	75 cd                	jne    80102dff <log_write+0x7f>
80102e32:	31 c0                	xor    %eax,%eax
80102e34:	eb c1                	jmp    80102df7 <log_write+0x77>
    panic("too big a transaction");
80102e36:	83 ec 0c             	sub    $0xc,%esp
80102e39:	68 b3 75 10 80       	push   $0x801075b3
80102e3e:	e8 4d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e43:	83 ec 0c             	sub    $0xc,%esp
80102e46:	68 c9 75 10 80       	push   $0x801075c9
80102e4b:	e8 40 d5 ff ff       	call   80100390 <panic>

80102e50 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e50:	55                   	push   %ebp
80102e51:	89 e5                	mov    %esp,%ebp
80102e53:	53                   	push   %ebx
80102e54:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e57:	e8 a4 09 00 00       	call   80103800 <cpuid>
80102e5c:	89 c3                	mov    %eax,%ebx
80102e5e:	e8 9d 09 00 00       	call   80103800 <cpuid>
80102e63:	83 ec 04             	sub    $0x4,%esp
80102e66:	53                   	push   %ebx
80102e67:	50                   	push   %eax
80102e68:	68 e4 75 10 80       	push   $0x801075e4
80102e6d:	e8 ee d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e72:	e8 69 2a 00 00       	call   801058e0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e77:	e8 04 09 00 00       	call   80103780 <mycpu>
80102e7c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e7e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e83:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e8a:	e8 71 0c 00 00       	call   80103b00 <scheduler>
80102e8f:	90                   	nop

80102e90 <mpenter>:
{
80102e90:	55                   	push   %ebp
80102e91:	89 e5                	mov    %esp,%ebp
80102e93:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e96:	e8 65 3b 00 00       	call   80106a00 <switchkvm>
  seginit();
80102e9b:	e8 d0 3a 00 00       	call   80106970 <seginit>
  lapicinit();
80102ea0:	e8 9b f7 ff ff       	call   80102640 <lapicinit>
  mpmain();
80102ea5:	e8 a6 ff ff ff       	call   80102e50 <mpmain>
80102eaa:	66 90                	xchg   %ax,%ax
80102eac:	66 90                	xchg   %ax,%ax
80102eae:	66 90                	xchg   %ax,%ax

80102eb0 <main>:
{
80102eb0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102eb4:	83 e4 f0             	and    $0xfffffff0,%esp
80102eb7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eba:	55                   	push   %ebp
80102ebb:	89 e5                	mov    %esp,%ebp
80102ebd:	53                   	push   %ebx
80102ebe:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102ebf:	83 ec 08             	sub    $0x8,%esp
80102ec2:	68 00 00 40 80       	push   $0x80400000
80102ec7:	68 a8 6d 11 80       	push   $0x80116da8
80102ecc:	e8 2f f5 ff ff       	call   80102400 <kinit1>
  kvmalloc();      // kernel page table
80102ed1:	e8 fa 3f 00 00       	call   80106ed0 <kvmalloc>
  mpinit();        // detect other processors
80102ed6:	e8 75 01 00 00       	call   80103050 <mpinit>
  lapicinit();     // interrupt controller
80102edb:	e8 60 f7 ff ff       	call   80102640 <lapicinit>
  seginit();       // segment descriptors
80102ee0:	e8 8b 3a 00 00       	call   80106970 <seginit>
  picinit();       // disable pic
80102ee5:	e8 46 03 00 00       	call   80103230 <picinit>
  ioapicinit();    // another interrupt controller
80102eea:	e8 41 f3 ff ff       	call   80102230 <ioapicinit>
  consoleinit();   // console hardware
80102eef:	e8 cc da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102ef4:	e8 47 2d 00 00       	call   80105c40 <uartinit>
  pinit();         // process table
80102ef9:	e8 62 08 00 00       	call   80103760 <pinit>
  tvinit();        // trap vectors
80102efe:	e8 5d 29 00 00       	call   80105860 <tvinit>
  binit();         // buffer cache
80102f03:	e8 38 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f08:	e8 53 de ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
80102f0d:	e8 fe f0 ff ff       	call   80102010 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f12:	83 c4 0c             	add    $0xc,%esp
80102f15:	68 8a 00 00 00       	push   $0x8a
80102f1a:	68 8c a4 10 80       	push   $0x8010a48c
80102f1f:	68 00 70 00 80       	push   $0x80007000
80102f24:	e8 67 17 00 00       	call   80104690 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f29:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f30:	00 00 00 
80102f33:	83 c4 10             	add    $0x10,%esp
80102f36:	05 80 27 11 80       	add    $0x80112780,%eax
80102f3b:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80102f40:	76 71                	jbe    80102fb3 <main+0x103>
80102f42:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80102f47:	89 f6                	mov    %esi,%esi
80102f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f50:	e8 2b 08 00 00       	call   80103780 <mycpu>
80102f55:	39 d8                	cmp    %ebx,%eax
80102f57:	74 41                	je     80102f9a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f59:	e8 72 f5 ff ff       	call   801024d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f5e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f63:	c7 05 f8 6f 00 80 90 	movl   $0x80102e90,0x80006ff8
80102f6a:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f6d:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f74:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f77:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102f7c:	0f b6 03             	movzbl (%ebx),%eax
80102f7f:	83 ec 08             	sub    $0x8,%esp
80102f82:	68 00 70 00 00       	push   $0x7000
80102f87:	50                   	push   %eax
80102f88:	e8 03 f8 ff ff       	call   80102790 <lapicstartap>
80102f8d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f90:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f96:	85 c0                	test   %eax,%eax
80102f98:	74 f6                	je     80102f90 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102f9a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102fa1:	00 00 00 
80102fa4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102faa:	05 80 27 11 80       	add    $0x80112780,%eax
80102faf:	39 c3                	cmp    %eax,%ebx
80102fb1:	72 9d                	jb     80102f50 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fb3:	83 ec 08             	sub    $0x8,%esp
80102fb6:	68 00 00 00 8e       	push   $0x8e000000
80102fbb:	68 00 00 40 80       	push   $0x80400000
80102fc0:	e8 ab f4 ff ff       	call   80102470 <kinit2>
  userinit();      // first user process
80102fc5:	e8 86 08 00 00       	call   80103850 <userinit>
  mpmain();        // finish this processor's setup
80102fca:	e8 81 fe ff ff       	call   80102e50 <mpmain>
80102fcf:	90                   	nop

80102fd0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
80102fd3:	57                   	push   %edi
80102fd4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fd5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102fdb:	53                   	push   %ebx
  e = addr+len;
80102fdc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102fdf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102fe2:	39 de                	cmp    %ebx,%esi
80102fe4:	72 10                	jb     80102ff6 <mpsearch1+0x26>
80102fe6:	eb 50                	jmp    80103038 <mpsearch1+0x68>
80102fe8:	90                   	nop
80102fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ff0:	39 fb                	cmp    %edi,%ebx
80102ff2:	89 fe                	mov    %edi,%esi
80102ff4:	76 42                	jbe    80103038 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102ff6:	83 ec 04             	sub    $0x4,%esp
80102ff9:	8d 7e 10             	lea    0x10(%esi),%edi
80102ffc:	6a 04                	push   $0x4
80102ffe:	68 f8 75 10 80       	push   $0x801075f8
80103003:	56                   	push   %esi
80103004:	e8 27 16 00 00       	call   80104630 <memcmp>
80103009:	83 c4 10             	add    $0x10,%esp
8010300c:	85 c0                	test   %eax,%eax
8010300e:	75 e0                	jne    80102ff0 <mpsearch1+0x20>
80103010:	89 f1                	mov    %esi,%ecx
80103012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103018:	0f b6 11             	movzbl (%ecx),%edx
8010301b:	83 c1 01             	add    $0x1,%ecx
8010301e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103020:	39 f9                	cmp    %edi,%ecx
80103022:	75 f4                	jne    80103018 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103024:	84 c0                	test   %al,%al
80103026:	75 c8                	jne    80102ff0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103028:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010302b:	89 f0                	mov    %esi,%eax
8010302d:	5b                   	pop    %ebx
8010302e:	5e                   	pop    %esi
8010302f:	5f                   	pop    %edi
80103030:	5d                   	pop    %ebp
80103031:	c3                   	ret    
80103032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103038:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010303b:	31 f6                	xor    %esi,%esi
}
8010303d:	89 f0                	mov    %esi,%eax
8010303f:	5b                   	pop    %ebx
80103040:	5e                   	pop    %esi
80103041:	5f                   	pop    %edi
80103042:	5d                   	pop    %ebp
80103043:	c3                   	ret    
80103044:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010304a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103050 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	57                   	push   %edi
80103054:	56                   	push   %esi
80103055:	53                   	push   %ebx
80103056:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103059:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103060:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103067:	c1 e0 08             	shl    $0x8,%eax
8010306a:	09 d0                	or     %edx,%eax
8010306c:	c1 e0 04             	shl    $0x4,%eax
8010306f:	85 c0                	test   %eax,%eax
80103071:	75 1b                	jne    8010308e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103073:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010307a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103081:	c1 e0 08             	shl    $0x8,%eax
80103084:	09 d0                	or     %edx,%eax
80103086:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103089:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010308e:	ba 00 04 00 00       	mov    $0x400,%edx
80103093:	e8 38 ff ff ff       	call   80102fd0 <mpsearch1>
80103098:	85 c0                	test   %eax,%eax
8010309a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010309d:	0f 84 3d 01 00 00    	je     801031e0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030a6:	8b 58 04             	mov    0x4(%eax),%ebx
801030a9:	85 db                	test   %ebx,%ebx
801030ab:	0f 84 4f 01 00 00    	je     80103200 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030b1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030b7:	83 ec 04             	sub    $0x4,%esp
801030ba:	6a 04                	push   $0x4
801030bc:	68 15 76 10 80       	push   $0x80107615
801030c1:	56                   	push   %esi
801030c2:	e8 69 15 00 00       	call   80104630 <memcmp>
801030c7:	83 c4 10             	add    $0x10,%esp
801030ca:	85 c0                	test   %eax,%eax
801030cc:	0f 85 2e 01 00 00    	jne    80103200 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801030d2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801030d9:	3c 01                	cmp    $0x1,%al
801030db:	0f 95 c2             	setne  %dl
801030de:	3c 04                	cmp    $0x4,%al
801030e0:	0f 95 c0             	setne  %al
801030e3:	20 c2                	and    %al,%dl
801030e5:	0f 85 15 01 00 00    	jne    80103200 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801030eb:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801030f2:	66 85 ff             	test   %di,%di
801030f5:	74 1a                	je     80103111 <mpinit+0xc1>
801030f7:	89 f0                	mov    %esi,%eax
801030f9:	01 f7                	add    %esi,%edi
  sum = 0;
801030fb:	31 d2                	xor    %edx,%edx
801030fd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103100:	0f b6 08             	movzbl (%eax),%ecx
80103103:	83 c0 01             	add    $0x1,%eax
80103106:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103108:	39 c7                	cmp    %eax,%edi
8010310a:	75 f4                	jne    80103100 <mpinit+0xb0>
8010310c:	84 d2                	test   %dl,%dl
8010310e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103111:	85 f6                	test   %esi,%esi
80103113:	0f 84 e7 00 00 00    	je     80103200 <mpinit+0x1b0>
80103119:	84 d2                	test   %dl,%dl
8010311b:	0f 85 df 00 00 00    	jne    80103200 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103121:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103127:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010312c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103133:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103139:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010313e:	01 d6                	add    %edx,%esi
80103140:	39 c6                	cmp    %eax,%esi
80103142:	76 23                	jbe    80103167 <mpinit+0x117>
    switch(*p){
80103144:	0f b6 10             	movzbl (%eax),%edx
80103147:	80 fa 04             	cmp    $0x4,%dl
8010314a:	0f 87 ca 00 00 00    	ja     8010321a <mpinit+0x1ca>
80103150:	ff 24 95 3c 76 10 80 	jmp    *-0x7fef89c4(,%edx,4)
80103157:	89 f6                	mov    %esi,%esi
80103159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103160:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103163:	39 c6                	cmp    %eax,%esi
80103165:	77 dd                	ja     80103144 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103167:	85 db                	test   %ebx,%ebx
80103169:	0f 84 9e 00 00 00    	je     8010320d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010316f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103172:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103176:	74 15                	je     8010318d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103178:	b8 70 00 00 00       	mov    $0x70,%eax
8010317d:	ba 22 00 00 00       	mov    $0x22,%edx
80103182:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103183:	ba 23 00 00 00       	mov    $0x23,%edx
80103188:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103189:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010318c:	ee                   	out    %al,(%dx)
  }
}
8010318d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103190:	5b                   	pop    %ebx
80103191:	5e                   	pop    %esi
80103192:	5f                   	pop    %edi
80103193:	5d                   	pop    %ebp
80103194:	c3                   	ret    
80103195:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103198:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
8010319e:	83 f9 07             	cmp    $0x7,%ecx
801031a1:	7f 19                	jg     801031bc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031a3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031a7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801031ad:	83 c1 01             	add    $0x1,%ecx
801031b0:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031b6:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
801031bc:	83 c0 14             	add    $0x14,%eax
      continue;
801031bf:	e9 7c ff ff ff       	jmp    80103140 <mpinit+0xf0>
801031c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801031c8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031cc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031cf:	88 15 60 27 11 80    	mov    %dl,0x80112760
      continue;
801031d5:	e9 66 ff ff ff       	jmp    80103140 <mpinit+0xf0>
801031da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801031e0:	ba 00 00 01 00       	mov    $0x10000,%edx
801031e5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031ea:	e8 e1 fd ff ff       	call   80102fd0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031ef:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801031f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031f4:	0f 85 a9 fe ff ff    	jne    801030a3 <mpinit+0x53>
801031fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103200:	83 ec 0c             	sub    $0xc,%esp
80103203:	68 fd 75 10 80       	push   $0x801075fd
80103208:	e8 83 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010320d:	83 ec 0c             	sub    $0xc,%esp
80103210:	68 1c 76 10 80       	push   $0x8010761c
80103215:	e8 76 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010321a:	31 db                	xor    %ebx,%ebx
8010321c:	e9 26 ff ff ff       	jmp    80103147 <mpinit+0xf7>
80103221:	66 90                	xchg   %ax,%ax
80103223:	66 90                	xchg   %ax,%ax
80103225:	66 90                	xchg   %ax,%ax
80103227:	66 90                	xchg   %ax,%ax
80103229:	66 90                	xchg   %ax,%ax
8010322b:	66 90                	xchg   %ax,%ax
8010322d:	66 90                	xchg   %ax,%ax
8010322f:	90                   	nop

80103230 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103230:	55                   	push   %ebp
80103231:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103236:	ba 21 00 00 00       	mov    $0x21,%edx
8010323b:	89 e5                	mov    %esp,%ebp
8010323d:	ee                   	out    %al,(%dx)
8010323e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103243:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103244:	5d                   	pop    %ebp
80103245:	c3                   	ret    
80103246:	66 90                	xchg   %ax,%ax
80103248:	66 90                	xchg   %ax,%ax
8010324a:	66 90                	xchg   %ax,%ax
8010324c:	66 90                	xchg   %ax,%ax
8010324e:	66 90                	xchg   %ax,%ax

80103250 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	57                   	push   %edi
80103254:	56                   	push   %esi
80103255:	53                   	push   %ebx
80103256:	83 ec 0c             	sub    $0xc,%esp
80103259:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010325c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010325f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103265:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010326b:	e8 10 db ff ff       	call   80100d80 <filealloc>
80103270:	85 c0                	test   %eax,%eax
80103272:	89 03                	mov    %eax,(%ebx)
80103274:	74 22                	je     80103298 <pipealloc+0x48>
80103276:	e8 05 db ff ff       	call   80100d80 <filealloc>
8010327b:	85 c0                	test   %eax,%eax
8010327d:	89 06                	mov    %eax,(%esi)
8010327f:	74 3f                	je     801032c0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103281:	e8 4a f2 ff ff       	call   801024d0 <kalloc>
80103286:	85 c0                	test   %eax,%eax
80103288:	89 c7                	mov    %eax,%edi
8010328a:	75 54                	jne    801032e0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010328c:	8b 03                	mov    (%ebx),%eax
8010328e:	85 c0                	test   %eax,%eax
80103290:	75 34                	jne    801032c6 <pipealloc+0x76>
80103292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103298:	8b 06                	mov    (%esi),%eax
8010329a:	85 c0                	test   %eax,%eax
8010329c:	74 0c                	je     801032aa <pipealloc+0x5a>
    fileclose(*f1);
8010329e:	83 ec 0c             	sub    $0xc,%esp
801032a1:	50                   	push   %eax
801032a2:	e8 99 db ff ff       	call   80100e40 <fileclose>
801032a7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801032ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032b2:	5b                   	pop    %ebx
801032b3:	5e                   	pop    %esi
801032b4:	5f                   	pop    %edi
801032b5:	5d                   	pop    %ebp
801032b6:	c3                   	ret    
801032b7:	89 f6                	mov    %esi,%esi
801032b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032c0:	8b 03                	mov    (%ebx),%eax
801032c2:	85 c0                	test   %eax,%eax
801032c4:	74 e4                	je     801032aa <pipealloc+0x5a>
    fileclose(*f0);
801032c6:	83 ec 0c             	sub    $0xc,%esp
801032c9:	50                   	push   %eax
801032ca:	e8 71 db ff ff       	call   80100e40 <fileclose>
  if(*f1)
801032cf:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801032d1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032d4:	85 c0                	test   %eax,%eax
801032d6:	75 c6                	jne    8010329e <pipealloc+0x4e>
801032d8:	eb d0                	jmp    801032aa <pipealloc+0x5a>
801032da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801032e0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801032e3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801032ea:	00 00 00 
  p->writeopen = 1;
801032ed:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801032f4:	00 00 00 
  p->nwrite = 0;
801032f7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801032fe:	00 00 00 
  p->nread = 0;
80103301:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103308:	00 00 00 
  initlock(&p->lock, "pipe");
8010330b:	68 50 76 10 80       	push   $0x80107650
80103310:	50                   	push   %eax
80103311:	e8 7a 10 00 00       	call   80104390 <initlock>
  (*f0)->type = FD_PIPE;
80103316:	8b 03                	mov    (%ebx),%eax
  return 0;
80103318:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010331b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103321:	8b 03                	mov    (%ebx),%eax
80103323:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103327:	8b 03                	mov    (%ebx),%eax
80103329:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010332d:	8b 03                	mov    (%ebx),%eax
8010332f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103332:	8b 06                	mov    (%esi),%eax
80103334:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010333a:	8b 06                	mov    (%esi),%eax
8010333c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103340:	8b 06                	mov    (%esi),%eax
80103342:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103346:	8b 06                	mov    (%esi),%eax
80103348:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010334b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010334e:	31 c0                	xor    %eax,%eax
}
80103350:	5b                   	pop    %ebx
80103351:	5e                   	pop    %esi
80103352:	5f                   	pop    %edi
80103353:	5d                   	pop    %ebp
80103354:	c3                   	ret    
80103355:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103360 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	56                   	push   %esi
80103364:	53                   	push   %ebx
80103365:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103368:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010336b:	83 ec 0c             	sub    $0xc,%esp
8010336e:	53                   	push   %ebx
8010336f:	e8 5c 11 00 00       	call   801044d0 <acquire>
  if(writable){
80103374:	83 c4 10             	add    $0x10,%esp
80103377:	85 f6                	test   %esi,%esi
80103379:	74 45                	je     801033c0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010337b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103381:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103384:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010338b:	00 00 00 
    wakeup(&p->nread);
8010338e:	50                   	push   %eax
8010338f:	e8 4c 0c 00 00       	call   80103fe0 <wakeup>
80103394:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103397:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010339d:	85 d2                	test   %edx,%edx
8010339f:	75 0a                	jne    801033ab <pipeclose+0x4b>
801033a1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033a7:	85 c0                	test   %eax,%eax
801033a9:	74 35                	je     801033e0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033b1:	5b                   	pop    %ebx
801033b2:	5e                   	pop    %esi
801033b3:	5d                   	pop    %ebp
    release(&p->lock);
801033b4:	e9 d7 11 00 00       	jmp    80104590 <release>
801033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033c0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033c6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033d0:	00 00 00 
    wakeup(&p->nwrite);
801033d3:	50                   	push   %eax
801033d4:	e8 07 0c 00 00       	call   80103fe0 <wakeup>
801033d9:	83 c4 10             	add    $0x10,%esp
801033dc:	eb b9                	jmp    80103397 <pipeclose+0x37>
801033de:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801033e0:	83 ec 0c             	sub    $0xc,%esp
801033e3:	53                   	push   %ebx
801033e4:	e8 a7 11 00 00       	call   80104590 <release>
    kfree((char*)p);
801033e9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801033ec:	83 c4 10             	add    $0x10,%esp
}
801033ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033f2:	5b                   	pop    %ebx
801033f3:	5e                   	pop    %esi
801033f4:	5d                   	pop    %ebp
    kfree((char*)p);
801033f5:	e9 26 ef ff ff       	jmp    80102320 <kfree>
801033fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103400 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103400:	55                   	push   %ebp
80103401:	89 e5                	mov    %esp,%ebp
80103403:	57                   	push   %edi
80103404:	56                   	push   %esi
80103405:	53                   	push   %ebx
80103406:	83 ec 28             	sub    $0x28,%esp
80103409:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010340c:	53                   	push   %ebx
8010340d:	e8 be 10 00 00       	call   801044d0 <acquire>
  for(i = 0; i < n; i++){
80103412:	8b 45 10             	mov    0x10(%ebp),%eax
80103415:	83 c4 10             	add    $0x10,%esp
80103418:	85 c0                	test   %eax,%eax
8010341a:	0f 8e c9 00 00 00    	jle    801034e9 <pipewrite+0xe9>
80103420:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103423:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103429:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010342f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103432:	03 4d 10             	add    0x10(%ebp),%ecx
80103435:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103438:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010343e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103444:	39 d0                	cmp    %edx,%eax
80103446:	75 74                	jne    801034bc <pipewrite+0xbc>
      if(p->readopen == 0 || myproc()->killed){
80103448:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010344e:	85 c0                	test   %eax,%eax
80103450:	74 51                	je     801034a3 <pipewrite+0xa3>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103452:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103458:	eb 3a                	jmp    80103494 <pipewrite+0x94>
8010345a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103460:	83 ec 0c             	sub    $0xc,%esp
80103463:	57                   	push   %edi
80103464:	e8 77 0b 00 00       	call   80103fe0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103469:	5a                   	pop    %edx
8010346a:	59                   	pop    %ecx
8010346b:	53                   	push   %ebx
8010346c:	56                   	push   %esi
8010346d:	e8 9e 09 00 00       	call   80103e10 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103472:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103478:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010347e:	83 c4 10             	add    $0x10,%esp
80103481:	05 00 02 00 00       	add    $0x200,%eax
80103486:	39 c2                	cmp    %eax,%edx
80103488:	75 36                	jne    801034c0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010348a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103490:	85 c0                	test   %eax,%eax
80103492:	74 0f                	je     801034a3 <pipewrite+0xa3>
80103494:	e8 87 03 00 00       	call   80103820 <myproc>
80103499:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
8010349f:	85 c0                	test   %eax,%eax
801034a1:	74 bd                	je     80103460 <pipewrite+0x60>
        release(&p->lock);
801034a3:	83 ec 0c             	sub    $0xc,%esp
801034a6:	53                   	push   %ebx
801034a7:	e8 e4 10 00 00       	call   80104590 <release>
        return -1;
801034ac:	83 c4 10             	add    $0x10,%esp
801034af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034b7:	5b                   	pop    %ebx
801034b8:	5e                   	pop    %esi
801034b9:	5f                   	pop    %edi
801034ba:	5d                   	pop    %ebp
801034bb:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034bc:	89 c2                	mov    %eax,%edx
801034be:	66 90                	xchg   %ax,%ax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034c0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034c3:	8d 42 01             	lea    0x1(%edx),%eax
801034c6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034cc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034d2:	83 c6 01             	add    $0x1,%esi
801034d5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801034d9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801034dc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034df:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801034e3:	0f 85 4f ff ff ff    	jne    80103438 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801034e9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034ef:	83 ec 0c             	sub    $0xc,%esp
801034f2:	50                   	push   %eax
801034f3:	e8 e8 0a 00 00       	call   80103fe0 <wakeup>
  release(&p->lock);
801034f8:	89 1c 24             	mov    %ebx,(%esp)
801034fb:	e8 90 10 00 00       	call   80104590 <release>
  return n;
80103500:	83 c4 10             	add    $0x10,%esp
80103503:	8b 45 10             	mov    0x10(%ebp),%eax
80103506:	eb ac                	jmp    801034b4 <pipewrite+0xb4>
80103508:	90                   	nop
80103509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103510 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103510:	55                   	push   %ebp
80103511:	89 e5                	mov    %esp,%ebp
80103513:	57                   	push   %edi
80103514:	56                   	push   %esi
80103515:	53                   	push   %ebx
80103516:	83 ec 18             	sub    $0x18,%esp
80103519:	8b 75 08             	mov    0x8(%ebp),%esi
8010351c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010351f:	56                   	push   %esi
80103520:	e8 ab 0f 00 00       	call   801044d0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103525:	83 c4 10             	add    $0x10,%esp
80103528:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010352e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103534:	75 72                	jne    801035a8 <piperead+0x98>
80103536:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010353c:	85 db                	test   %ebx,%ebx
8010353e:	0f 84 cc 00 00 00    	je     80103610 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103544:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010354a:	eb 2d                	jmp    80103579 <piperead+0x69>
8010354c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103550:	83 ec 08             	sub    $0x8,%esp
80103553:	56                   	push   %esi
80103554:	53                   	push   %ebx
80103555:	e8 b6 08 00 00       	call   80103e10 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010355a:	83 c4 10             	add    $0x10,%esp
8010355d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103563:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103569:	75 3d                	jne    801035a8 <piperead+0x98>
8010356b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103571:	85 d2                	test   %edx,%edx
80103573:	0f 84 97 00 00 00    	je     80103610 <piperead+0x100>
    if(myproc()->killed){
80103579:	e8 a2 02 00 00       	call   80103820 <myproc>
8010357e:	8b 88 88 00 00 00    	mov    0x88(%eax),%ecx
80103584:	85 c9                	test   %ecx,%ecx
80103586:	74 c8                	je     80103550 <piperead+0x40>
      release(&p->lock);
80103588:	83 ec 0c             	sub    $0xc,%esp
      return -1;
8010358b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103590:	56                   	push   %esi
80103591:	e8 fa 0f 00 00       	call   80104590 <release>
      return -1;
80103596:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103599:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010359c:	89 d8                	mov    %ebx,%eax
8010359e:	5b                   	pop    %ebx
8010359f:	5e                   	pop    %esi
801035a0:	5f                   	pop    %edi
801035a1:	5d                   	pop    %ebp
801035a2:	c3                   	ret    
801035a3:	90                   	nop
801035a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035a8:	8b 45 10             	mov    0x10(%ebp),%eax
801035ab:	85 c0                	test   %eax,%eax
801035ad:	7e 61                	jle    80103610 <piperead+0x100>
    if(p->nread == p->nwrite)
801035af:	31 db                	xor    %ebx,%ebx
801035b1:	eb 13                	jmp    801035c6 <piperead+0xb6>
801035b3:	90                   	nop
801035b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035b8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035be:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035c4:	74 1f                	je     801035e5 <piperead+0xd5>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035c6:	8d 41 01             	lea    0x1(%ecx),%eax
801035c9:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035cf:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035d5:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801035da:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035dd:	83 c3 01             	add    $0x1,%ebx
801035e0:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801035e3:	75 d3                	jne    801035b8 <piperead+0xa8>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801035e5:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801035eb:	83 ec 0c             	sub    $0xc,%esp
801035ee:	50                   	push   %eax
801035ef:	e8 ec 09 00 00       	call   80103fe0 <wakeup>
  release(&p->lock);
801035f4:	89 34 24             	mov    %esi,(%esp)
801035f7:	e8 94 0f 00 00       	call   80104590 <release>
  return i;
801035fc:	83 c4 10             	add    $0x10,%esp
}
801035ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103602:	89 d8                	mov    %ebx,%eax
80103604:	5b                   	pop    %ebx
80103605:	5e                   	pop    %esi
80103606:	5f                   	pop    %edi
80103607:	5d                   	pop    %ebp
80103608:	c3                   	ret    
80103609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103610:	31 db                	xor    %ebx,%ebx
80103612:	eb d1                	jmp    801035e5 <piperead+0xd5>
80103614:	66 90                	xchg   %ax,%ax
80103616:	66 90                	xchg   %ax,%ax
80103618:	66 90                	xchg   %ax,%ax
8010361a:	66 90                	xchg   %ax,%ax
8010361c:	66 90                	xchg   %ax,%ax
8010361e:	66 90                	xchg   %ax,%ax

80103620 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103620:	55                   	push   %ebp
80103621:	89 e5                	mov    %esp,%ebp
80103623:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103624:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103629:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010362c:	68 20 2d 11 80       	push   $0x80112d20
80103631:	e8 9a 0e 00 00       	call   801044d0 <acquire>
80103636:	83 c4 10             	add    $0x10,%esp
80103639:	eb 17                	jmp    80103652 <allocproc+0x32>
8010363b:	90                   	nop
8010363c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103640:	81 c3 e0 00 00 00    	add    $0xe0,%ebx
80103646:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
8010364c:	0f 83 8e 00 00 00    	jae    801036e0 <allocproc+0xc0>
    if(p->state == UNUSED)
80103652:	8b 43 70             	mov    0x70(%ebx),%eax
80103655:	85 c0                	test   %eax,%eax
80103657:	75 e7                	jne    80103640 <allocproc+0x20>
80103659:	8d 53 64             	lea    0x64(%ebx),%edx
8010365c:	89 d8                	mov    %ebx,%eax
8010365e:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
  return 0;

found:
  for(int i=0; i<25; i++){ 
      p->hit[i] = 0;
80103660:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103666:	83 c0 04             	add    $0x4,%eax
  for(int i=0; i<25; i++){ 
80103669:	39 c2                	cmp    %eax,%edx
8010366b:	75 f3                	jne    80103660 <allocproc+0x40>
  }
  p->state = EMBRYO;
  p->pid = nextpid++;
8010366d:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103672:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103675:	c7 43 70 01 00 00 00 	movl   $0x1,0x70(%ebx)
  p->pid = nextpid++;
8010367c:	8d 50 01             	lea    0x1(%eax),%edx
8010367f:	89 43 74             	mov    %eax,0x74(%ebx)
  release(&ptable.lock);
80103682:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
80103687:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
8010368d:	e8 fe 0e 00 00       	call   80104590 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103692:	e8 39 ee ff ff       	call   801024d0 <kalloc>
80103697:	83 c4 10             	add    $0x10,%esp
8010369a:	85 c0                	test   %eax,%eax
8010369c:	89 43 6c             	mov    %eax,0x6c(%ebx)
8010369f:	74 58                	je     801036f9 <allocproc+0xd9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801036a1:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801036a7:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801036aa:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801036af:	89 53 7c             	mov    %edx,0x7c(%ebx)
  *(uint*)sp = (uint)trapret;
801036b2:	c7 40 14 52 58 10 80 	movl   $0x80105852,0x14(%eax)
  p->context = (struct context*)sp;
801036b9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
  memset(p->context, 0, sizeof *p->context);
801036bf:	6a 14                	push   $0x14
801036c1:	6a 00                	push   $0x0
801036c3:	50                   	push   %eax
801036c4:	e8 17 0f 00 00       	call   801045e0 <memset>
  p->context->eip = (uint)forkret;
801036c9:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax

  return p;
801036cf:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801036d2:	c7 40 10 10 37 10 80 	movl   $0x80103710,0x10(%eax)
}
801036d9:	89 d8                	mov    %ebx,%eax
801036db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036de:	c9                   	leave  
801036df:	c3                   	ret    
  release(&ptable.lock);
801036e0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801036e3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801036e5:	68 20 2d 11 80       	push   $0x80112d20
801036ea:	e8 a1 0e 00 00       	call   80104590 <release>
}
801036ef:	89 d8                	mov    %ebx,%eax
  return 0;
801036f1:	83 c4 10             	add    $0x10,%esp
}
801036f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036f7:	c9                   	leave  
801036f8:	c3                   	ret    
    p->state = UNUSED;
801036f9:	c7 43 70 00 00 00 00 	movl   $0x0,0x70(%ebx)
    return 0;
80103700:	31 db                	xor    %ebx,%ebx
80103702:	eb d5                	jmp    801036d9 <allocproc+0xb9>
80103704:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010370a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103710 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103710:	55                   	push   %ebp
80103711:	89 e5                	mov    %esp,%ebp
80103713:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103716:	68 20 2d 11 80       	push   $0x80112d20
8010371b:	e8 70 0e 00 00       	call   80104590 <release>

  if (first) {
80103720:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103725:	83 c4 10             	add    $0x10,%esp
80103728:	85 c0                	test   %eax,%eax
8010372a:	75 04                	jne    80103730 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010372c:	c9                   	leave  
8010372d:	c3                   	ret    
8010372e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103730:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103733:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010373a:	00 00 00 
    iinit(ROOTDEV);
8010373d:	6a 01                	push   $0x1
8010373f:	e8 3c dd ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
80103744:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010374b:	e8 c0 f3 ff ff       	call   80102b10 <initlog>
80103750:	83 c4 10             	add    $0x10,%esp
}
80103753:	c9                   	leave  
80103754:	c3                   	ret    
80103755:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103760 <pinit>:
{
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103766:	68 55 76 10 80       	push   $0x80107655
8010376b:	68 20 2d 11 80       	push   $0x80112d20
80103770:	e8 1b 0c 00 00       	call   80104390 <initlock>
}
80103775:	83 c4 10             	add    $0x10,%esp
80103778:	c9                   	leave  
80103779:	c3                   	ret    
8010377a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103780 <mycpu>:
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	56                   	push   %esi
80103784:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103785:	9c                   	pushf  
80103786:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103787:	f6 c4 02             	test   $0x2,%ah
8010378a:	75 5e                	jne    801037ea <mycpu+0x6a>
  apicid = lapicid();
8010378c:	e8 af ef ff ff       	call   80102740 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103791:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80103797:	85 f6                	test   %esi,%esi
80103799:	7e 42                	jle    801037dd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010379b:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
801037a2:	39 d0                	cmp    %edx,%eax
801037a4:	74 30                	je     801037d6 <mycpu+0x56>
801037a6:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
801037ab:	31 d2                	xor    %edx,%edx
801037ad:	8d 76 00             	lea    0x0(%esi),%esi
801037b0:	83 c2 01             	add    $0x1,%edx
801037b3:	39 f2                	cmp    %esi,%edx
801037b5:	74 26                	je     801037dd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801037b7:	0f b6 19             	movzbl (%ecx),%ebx
801037ba:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801037c0:	39 c3                	cmp    %eax,%ebx
801037c2:	75 ec                	jne    801037b0 <mycpu+0x30>
801037c4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801037ca:	05 80 27 11 80       	add    $0x80112780,%eax
}
801037cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037d2:	5b                   	pop    %ebx
801037d3:	5e                   	pop    %esi
801037d4:	5d                   	pop    %ebp
801037d5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
801037d6:	b8 80 27 11 80       	mov    $0x80112780,%eax
      return &cpus[i];
801037db:	eb f2                	jmp    801037cf <mycpu+0x4f>
  panic("unknown apicid\n");
801037dd:	83 ec 0c             	sub    $0xc,%esp
801037e0:	68 5c 76 10 80       	push   $0x8010765c
801037e5:	e8 a6 cb ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801037ea:	83 ec 0c             	sub    $0xc,%esp
801037ed:	68 38 77 10 80       	push   $0x80107738
801037f2:	e8 99 cb ff ff       	call   80100390 <panic>
801037f7:	89 f6                	mov    %esi,%esi
801037f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103800 <cpuid>:
cpuid() {
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103806:	e8 75 ff ff ff       	call   80103780 <mycpu>
8010380b:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
80103810:	c9                   	leave  
  return mycpu()-cpus;
80103811:	c1 f8 04             	sar    $0x4,%eax
80103814:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010381a:	c3                   	ret    
8010381b:	90                   	nop
8010381c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103820 <myproc>:
myproc(void) {
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	53                   	push   %ebx
80103824:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103827:	e8 d4 0b 00 00       	call   80104400 <pushcli>
  c = mycpu();
8010382c:	e8 4f ff ff ff       	call   80103780 <mycpu>
  p = c->proc;
80103831:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103837:	e8 04 0c 00 00       	call   80104440 <popcli>
}
8010383c:	83 c4 04             	add    $0x4,%esp
8010383f:	89 d8                	mov    %ebx,%eax
80103841:	5b                   	pop    %ebx
80103842:	5d                   	pop    %ebp
80103843:	c3                   	ret    
80103844:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010384a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103850 <userinit>:
{
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	53                   	push   %ebx
80103854:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103857:	e8 c4 fd ff ff       	call   80103620 <allocproc>
8010385c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010385e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103863:	e8 e8 35 00 00       	call   80106e50 <setupkvm>
80103868:	85 c0                	test   %eax,%eax
8010386a:	89 43 68             	mov    %eax,0x68(%ebx)
8010386d:	0f 84 c4 00 00 00    	je     80103937 <userinit+0xe7>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103873:	83 ec 04             	sub    $0x4,%esp
80103876:	68 2c 00 00 00       	push   $0x2c
8010387b:	68 60 a4 10 80       	push   $0x8010a460
80103880:	50                   	push   %eax
80103881:	e8 aa 32 00 00       	call   80106b30 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103886:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103889:	c7 43 64 00 10 00 00 	movl   $0x1000,0x64(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103890:	6a 4c                	push   $0x4c
80103892:	6a 00                	push   $0x0
80103894:	ff 73 7c             	pushl  0x7c(%ebx)
80103897:	e8 44 0d 00 00       	call   801045e0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010389c:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010389f:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801038a4:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801038a9:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801038ac:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801038b0:	8b 43 7c             	mov    0x7c(%ebx),%eax
801038b3:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801038b7:	8b 43 7c             	mov    0x7c(%ebx),%eax
801038ba:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038be:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801038c2:	8b 43 7c             	mov    0x7c(%ebx),%eax
801038c5:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038c9:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801038cd:	8b 43 7c             	mov    0x7c(%ebx),%eax
801038d0:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801038d7:	8b 43 7c             	mov    0x7c(%ebx),%eax
801038da:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801038e1:	8b 43 7c             	mov    0x7c(%ebx),%eax
801038e4:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801038eb:	8d 83 d0 00 00 00    	lea    0xd0(%ebx),%eax
801038f1:	6a 10                	push   $0x10
801038f3:	68 85 76 10 80       	push   $0x80107685
801038f8:	50                   	push   %eax
801038f9:	e8 c2 0e 00 00       	call   801047c0 <safestrcpy>
  p->cwd = namei("/");
801038fe:	c7 04 24 8e 76 10 80 	movl   $0x8010768e,(%esp)
80103905:	e8 e6 e5 ff ff       	call   80101ef0 <namei>
8010390a:	89 83 cc 00 00 00    	mov    %eax,0xcc(%ebx)
  acquire(&ptable.lock);
80103910:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103917:	e8 b4 0b 00 00       	call   801044d0 <acquire>
  p->state = RUNNABLE;
8010391c:	c7 43 70 03 00 00 00 	movl   $0x3,0x70(%ebx)
  release(&ptable.lock);
80103923:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010392a:	e8 61 0c 00 00       	call   80104590 <release>
}
8010392f:	83 c4 10             	add    $0x10,%esp
80103932:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103935:	c9                   	leave  
80103936:	c3                   	ret    
    panic("userinit: out of memory?");
80103937:	83 ec 0c             	sub    $0xc,%esp
8010393a:	68 6c 76 10 80       	push   $0x8010766c
8010393f:	e8 4c ca ff ff       	call   80100390 <panic>
80103944:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010394a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103950 <growproc>:
{
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	56                   	push   %esi
80103954:	53                   	push   %ebx
80103955:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103958:	e8 a3 0a 00 00       	call   80104400 <pushcli>
  c = mycpu();
8010395d:	e8 1e fe ff ff       	call   80103780 <mycpu>
  p = c->proc;
80103962:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103968:	e8 d3 0a 00 00       	call   80104440 <popcli>
  if(n > 0){
8010396d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103970:	8b 43 64             	mov    0x64(%ebx),%eax
  if(n > 0){
80103973:	7f 1b                	jg     80103990 <growproc+0x40>
  } else if(n < 0){
80103975:	75 39                	jne    801039b0 <growproc+0x60>
  switchuvm(curproc);
80103977:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
8010397a:	89 43 64             	mov    %eax,0x64(%ebx)
  switchuvm(curproc);
8010397d:	53                   	push   %ebx
8010397e:	e8 9d 30 00 00       	call   80106a20 <switchuvm>
  return 0;
80103983:	83 c4 10             	add    $0x10,%esp
80103986:	31 c0                	xor    %eax,%eax
}
80103988:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010398b:	5b                   	pop    %ebx
8010398c:	5e                   	pop    %esi
8010398d:	5d                   	pop    %ebp
8010398e:	c3                   	ret    
8010398f:	90                   	nop
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103990:	83 ec 04             	sub    $0x4,%esp
80103993:	01 c6                	add    %eax,%esi
80103995:	56                   	push   %esi
80103996:	50                   	push   %eax
80103997:	ff 73 68             	pushl  0x68(%ebx)
8010399a:	e8 d1 32 00 00       	call   80106c70 <allocuvm>
8010399f:	83 c4 10             	add    $0x10,%esp
801039a2:	85 c0                	test   %eax,%eax
801039a4:	75 d1                	jne    80103977 <growproc+0x27>
      return -1;
801039a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039ab:	eb db                	jmp    80103988 <growproc+0x38>
801039ad:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801039b0:	83 ec 04             	sub    $0x4,%esp
801039b3:	01 c6                	add    %eax,%esi
801039b5:	56                   	push   %esi
801039b6:	50                   	push   %eax
801039b7:	ff 73 68             	pushl  0x68(%ebx)
801039ba:	e8 e1 33 00 00       	call   80106da0 <deallocuvm>
801039bf:	83 c4 10             	add    $0x10,%esp
801039c2:	85 c0                	test   %eax,%eax
801039c4:	75 b1                	jne    80103977 <growproc+0x27>
801039c6:	eb de                	jmp    801039a6 <growproc+0x56>
801039c8:	90                   	nop
801039c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039d0 <fork>:
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	57                   	push   %edi
801039d4:	56                   	push   %esi
801039d5:	53                   	push   %ebx
801039d6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801039d9:	e8 22 0a 00 00       	call   80104400 <pushcli>
  c = mycpu();
801039de:	e8 9d fd ff ff       	call   80103780 <mycpu>
  p = c->proc;
801039e3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039e9:	e8 52 0a 00 00       	call   80104440 <popcli>
  if((np = allocproc()) == 0){
801039ee:	e8 2d fc ff ff       	call   80103620 <allocproc>
801039f3:	85 c0                	test   %eax,%eax
801039f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801039f8:	0f 84 d1 00 00 00    	je     80103acf <fork+0xff>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801039fe:	83 ec 08             	sub    $0x8,%esp
80103a01:	ff 73 64             	pushl  0x64(%ebx)
80103a04:	ff 73 68             	pushl  0x68(%ebx)
80103a07:	89 c7                	mov    %eax,%edi
80103a09:	e8 12 35 00 00       	call   80106f20 <copyuvm>
80103a0e:	83 c4 10             	add    $0x10,%esp
80103a11:	85 c0                	test   %eax,%eax
80103a13:	89 47 68             	mov    %eax,0x68(%edi)
80103a16:	0f 84 ba 00 00 00    	je     80103ad6 <fork+0x106>
  np->sz = curproc->sz;
80103a1c:	8b 43 64             	mov    0x64(%ebx),%eax
80103a1f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103a22:	89 41 64             	mov    %eax,0x64(%ecx)
  np->parent = curproc;
80103a25:	89 59 78             	mov    %ebx,0x78(%ecx)
80103a28:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103a2a:	8b 79 7c             	mov    0x7c(%ecx),%edi
80103a2d:	8b 73 7c             	mov    0x7c(%ebx),%esi
80103a30:	b9 13 00 00 00       	mov    $0x13,%ecx
80103a35:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103a37:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103a39:	8b 40 7c             	mov    0x7c(%eax),%eax
80103a3c:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103a43:	90                   	nop
80103a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103a48:	8b 84 b3 8c 00 00 00 	mov    0x8c(%ebx,%esi,4),%eax
80103a4f:	85 c0                	test   %eax,%eax
80103a51:	74 16                	je     80103a69 <fork+0x99>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103a53:	83 ec 0c             	sub    $0xc,%esp
80103a56:	50                   	push   %eax
80103a57:	e8 94 d3 ff ff       	call   80100df0 <filedup>
80103a5c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a5f:	83 c4 10             	add    $0x10,%esp
80103a62:	89 84 b2 8c 00 00 00 	mov    %eax,0x8c(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103a69:	83 c6 01             	add    $0x1,%esi
80103a6c:	83 fe 10             	cmp    $0x10,%esi
80103a6f:	75 d7                	jne    80103a48 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103a71:	83 ec 0c             	sub    $0xc,%esp
80103a74:	ff b3 cc 00 00 00    	pushl  0xcc(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a7a:	81 c3 d0 00 00 00    	add    $0xd0,%ebx
  np->cwd = idup(curproc->cwd);
80103a80:	e8 cb db ff ff       	call   80101650 <idup>
80103a85:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a88:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103a8b:	89 87 cc 00 00 00    	mov    %eax,0xcc(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a91:	8d 87 d0 00 00 00    	lea    0xd0(%edi),%eax
80103a97:	6a 10                	push   $0x10
80103a99:	53                   	push   %ebx
80103a9a:	50                   	push   %eax
80103a9b:	e8 20 0d 00 00       	call   801047c0 <safestrcpy>
  pid = np->pid;
80103aa0:	8b 5f 74             	mov    0x74(%edi),%ebx
  acquire(&ptable.lock);
80103aa3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103aaa:	e8 21 0a 00 00       	call   801044d0 <acquire>
  np->state = RUNNABLE;
80103aaf:	c7 47 70 03 00 00 00 	movl   $0x3,0x70(%edi)
  release(&ptable.lock);
80103ab6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103abd:	e8 ce 0a 00 00       	call   80104590 <release>
  return pid;
80103ac2:	83 c4 10             	add    $0x10,%esp
}
80103ac5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ac8:	89 d8                	mov    %ebx,%eax
80103aca:	5b                   	pop    %ebx
80103acb:	5e                   	pop    %esi
80103acc:	5f                   	pop    %edi
80103acd:	5d                   	pop    %ebp
80103ace:	c3                   	ret    
    return -1;
80103acf:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ad4:	eb ef                	jmp    80103ac5 <fork+0xf5>
    kfree(np->kstack);
80103ad6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103ad9:	83 ec 0c             	sub    $0xc,%esp
80103adc:	ff 73 6c             	pushl  0x6c(%ebx)
80103adf:	e8 3c e8 ff ff       	call   80102320 <kfree>
    np->kstack = 0;
80103ae4:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
    np->state = UNUSED;
80103aeb:	c7 43 70 00 00 00 00 	movl   $0x0,0x70(%ebx)
    return -1;
80103af2:	83 c4 10             	add    $0x10,%esp
80103af5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103afa:	eb c9                	jmp    80103ac5 <fork+0xf5>
80103afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b00 <scheduler>:
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	57                   	push   %edi
80103b04:	56                   	push   %esi
80103b05:	53                   	push   %ebx
80103b06:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103b09:	e8 72 fc ff ff       	call   80103780 <mycpu>
80103b0e:	8d 78 04             	lea    0x4(%eax),%edi
80103b11:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103b13:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103b1a:	00 00 00 
80103b1d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103b20:	fb                   	sti    
    acquire(&ptable.lock);
80103b21:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b24:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103b29:	68 20 2d 11 80       	push   $0x80112d20
80103b2e:	e8 9d 09 00 00       	call   801044d0 <acquire>
80103b33:	83 c4 10             	add    $0x10,%esp
80103b36:	8d 76 00             	lea    0x0(%esi),%esi
80103b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103b40:	83 7b 70 03          	cmpl   $0x3,0x70(%ebx)
80103b44:	75 36                	jne    80103b7c <scheduler+0x7c>
      switchuvm(p);
80103b46:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103b49:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103b4f:	53                   	push   %ebx
80103b50:	e8 cb 2e 00 00       	call   80106a20 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103b55:	58                   	pop    %eax
80103b56:	5a                   	pop    %edx
80103b57:	ff b3 80 00 00 00    	pushl  0x80(%ebx)
80103b5d:	57                   	push   %edi
      p->state = RUNNING;
80103b5e:	c7 43 70 04 00 00 00 	movl   $0x4,0x70(%ebx)
      swtch(&(c->scheduler), p->context);
80103b65:	e8 b1 0c 00 00       	call   8010481b <swtch>
      switchkvm();
80103b6a:	e8 91 2e 00 00       	call   80106a00 <switchkvm>
      c->proc = 0;
80103b6f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103b76:	00 00 00 
80103b79:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b7c:	81 c3 e0 00 00 00    	add    $0xe0,%ebx
80103b82:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
80103b88:	72 b6                	jb     80103b40 <scheduler+0x40>
    release(&ptable.lock);
80103b8a:	83 ec 0c             	sub    $0xc,%esp
80103b8d:	68 20 2d 11 80       	push   $0x80112d20
80103b92:	e8 f9 09 00 00       	call   80104590 <release>
    sti();
80103b97:	83 c4 10             	add    $0x10,%esp
80103b9a:	eb 84                	jmp    80103b20 <scheduler+0x20>
80103b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ba0 <sched>:
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	56                   	push   %esi
80103ba4:	53                   	push   %ebx
  pushcli();
80103ba5:	e8 56 08 00 00       	call   80104400 <pushcli>
  c = mycpu();
80103baa:	e8 d1 fb ff ff       	call   80103780 <mycpu>
  p = c->proc;
80103baf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bb5:	e8 86 08 00 00       	call   80104440 <popcli>
  if(!holding(&ptable.lock))
80103bba:	83 ec 0c             	sub    $0xc,%esp
80103bbd:	68 20 2d 11 80       	push   $0x80112d20
80103bc2:	e8 d9 08 00 00       	call   801044a0 <holding>
80103bc7:	83 c4 10             	add    $0x10,%esp
80103bca:	85 c0                	test   %eax,%eax
80103bcc:	74 4f                	je     80103c1d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103bce:	e8 ad fb ff ff       	call   80103780 <mycpu>
80103bd3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103bda:	75 68                	jne    80103c44 <sched+0xa4>
  if(p->state == RUNNING)
80103bdc:	83 7b 70 04          	cmpl   $0x4,0x70(%ebx)
80103be0:	74 55                	je     80103c37 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103be2:	9c                   	pushf  
80103be3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103be4:	f6 c4 02             	test   $0x2,%ah
80103be7:	75 41                	jne    80103c2a <sched+0x8a>
  intena = mycpu()->intena;
80103be9:	e8 92 fb ff ff       	call   80103780 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103bee:	83 eb 80             	sub    $0xffffff80,%ebx
  intena = mycpu()->intena;
80103bf1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103bf7:	e8 84 fb ff ff       	call   80103780 <mycpu>
80103bfc:	83 ec 08             	sub    $0x8,%esp
80103bff:	ff 70 04             	pushl  0x4(%eax)
80103c02:	53                   	push   %ebx
80103c03:	e8 13 0c 00 00       	call   8010481b <swtch>
  mycpu()->intena = intena;
80103c08:	e8 73 fb ff ff       	call   80103780 <mycpu>
}
80103c0d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103c10:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103c16:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c19:	5b                   	pop    %ebx
80103c1a:	5e                   	pop    %esi
80103c1b:	5d                   	pop    %ebp
80103c1c:	c3                   	ret    
    panic("sched ptable.lock");
80103c1d:	83 ec 0c             	sub    $0xc,%esp
80103c20:	68 90 76 10 80       	push   $0x80107690
80103c25:	e8 66 c7 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103c2a:	83 ec 0c             	sub    $0xc,%esp
80103c2d:	68 bc 76 10 80       	push   $0x801076bc
80103c32:	e8 59 c7 ff ff       	call   80100390 <panic>
    panic("sched running");
80103c37:	83 ec 0c             	sub    $0xc,%esp
80103c3a:	68 ae 76 10 80       	push   $0x801076ae
80103c3f:	e8 4c c7 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103c44:	83 ec 0c             	sub    $0xc,%esp
80103c47:	68 a2 76 10 80       	push   $0x801076a2
80103c4c:	e8 3f c7 ff ff       	call   80100390 <panic>
80103c51:	eb 0d                	jmp    80103c60 <exit>
80103c53:	90                   	nop
80103c54:	90                   	nop
80103c55:	90                   	nop
80103c56:	90                   	nop
80103c57:	90                   	nop
80103c58:	90                   	nop
80103c59:	90                   	nop
80103c5a:	90                   	nop
80103c5b:	90                   	nop
80103c5c:	90                   	nop
80103c5d:	90                   	nop
80103c5e:	90                   	nop
80103c5f:	90                   	nop

80103c60 <exit>:
{
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	57                   	push   %edi
80103c64:	56                   	push   %esi
80103c65:	53                   	push   %ebx
80103c66:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103c69:	e8 92 07 00 00       	call   80104400 <pushcli>
  c = mycpu();
80103c6e:	e8 0d fb ff ff       	call   80103780 <mycpu>
  p = c->proc;
80103c73:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103c79:	e8 c2 07 00 00       	call   80104440 <popcli>
  if(curproc == initproc)
80103c7e:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103c84:	8d 9e 8c 00 00 00    	lea    0x8c(%esi),%ebx
80103c8a:	8d be cc 00 00 00    	lea    0xcc(%esi),%edi
80103c90:	0f 84 0e 01 00 00    	je     80103da4 <exit+0x144>
80103c96:	8d 76 00             	lea    0x0(%esi),%esi
80103c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(curproc->ofile[fd]){
80103ca0:	8b 03                	mov    (%ebx),%eax
80103ca2:	85 c0                	test   %eax,%eax
80103ca4:	74 12                	je     80103cb8 <exit+0x58>
      fileclose(curproc->ofile[fd]);
80103ca6:	83 ec 0c             	sub    $0xc,%esp
80103ca9:	50                   	push   %eax
80103caa:	e8 91 d1 ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
80103caf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103cb5:	83 c4 10             	add    $0x10,%esp
80103cb8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103cbb:	39 fb                	cmp    %edi,%ebx
80103cbd:	75 e1                	jne    80103ca0 <exit+0x40>
  begin_op();
80103cbf:	e8 ec ee ff ff       	call   80102bb0 <begin_op>
  iput(curproc->cwd);
80103cc4:	83 ec 0c             	sub    $0xc,%esp
80103cc7:	ff b6 cc 00 00 00    	pushl  0xcc(%esi)
80103ccd:	e8 de da ff ff       	call   801017b0 <iput>
  end_op();
80103cd2:	e8 49 ef ff ff       	call   80102c20 <end_op>
  curproc->cwd = 0;
80103cd7:	c7 86 cc 00 00 00 00 	movl   $0x0,0xcc(%esi)
80103cde:	00 00 00 
  acquire(&ptable.lock);
80103ce1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ce8:	e8 e3 07 00 00       	call   801044d0 <acquire>
  wakeup1(curproc->parent);
80103ced:	8b 56 78             	mov    0x78(%esi),%edx
80103cf0:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cf3:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103cf8:	eb 12                	jmp    80103d0c <exit+0xac>
80103cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d00:	05 e0 00 00 00       	add    $0xe0,%eax
80103d05:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80103d0a:	73 21                	jae    80103d2d <exit+0xcd>
    if(p->state == SLEEPING && p->chan == chan)
80103d0c:	83 78 70 02          	cmpl   $0x2,0x70(%eax)
80103d10:	75 ee                	jne    80103d00 <exit+0xa0>
80103d12:	3b 90 84 00 00 00    	cmp    0x84(%eax),%edx
80103d18:	75 e6                	jne    80103d00 <exit+0xa0>
      p->state = RUNNABLE;
80103d1a:	c7 40 70 03 00 00 00 	movl   $0x3,0x70(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d21:	05 e0 00 00 00       	add    $0xe0,%eax
80103d26:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80103d2b:	72 df                	jb     80103d0c <exit+0xac>
      p->parent = initproc;
80103d2d:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d33:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103d38:	eb 14                	jmp    80103d4e <exit+0xee>
80103d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d40:	81 c2 e0 00 00 00    	add    $0xe0,%edx
80103d46:	81 fa 54 65 11 80    	cmp    $0x80116554,%edx
80103d4c:	73 3d                	jae    80103d8b <exit+0x12b>
    if(p->parent == curproc){
80103d4e:	39 72 78             	cmp    %esi,0x78(%edx)
80103d51:	75 ed                	jne    80103d40 <exit+0xe0>
      if(p->state == ZOMBIE)
80103d53:	83 7a 70 05          	cmpl   $0x5,0x70(%edx)
      p->parent = initproc;
80103d57:	89 4a 78             	mov    %ecx,0x78(%edx)
      if(p->state == ZOMBIE)
80103d5a:	75 e4                	jne    80103d40 <exit+0xe0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d5c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103d61:	eb 11                	jmp    80103d74 <exit+0x114>
80103d63:	90                   	nop
80103d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d68:	05 e0 00 00 00       	add    $0xe0,%eax
80103d6d:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80103d72:	73 cc                	jae    80103d40 <exit+0xe0>
    if(p->state == SLEEPING && p->chan == chan)
80103d74:	83 78 70 02          	cmpl   $0x2,0x70(%eax)
80103d78:	75 ee                	jne    80103d68 <exit+0x108>
80103d7a:	3b 88 84 00 00 00    	cmp    0x84(%eax),%ecx
80103d80:	75 e6                	jne    80103d68 <exit+0x108>
      p->state = RUNNABLE;
80103d82:	c7 40 70 03 00 00 00 	movl   $0x3,0x70(%eax)
80103d89:	eb dd                	jmp    80103d68 <exit+0x108>
  curproc->state = ZOMBIE;
80103d8b:	c7 46 70 05 00 00 00 	movl   $0x5,0x70(%esi)
  sched();
80103d92:	e8 09 fe ff ff       	call   80103ba0 <sched>
  panic("zombie exit");
80103d97:	83 ec 0c             	sub    $0xc,%esp
80103d9a:	68 dd 76 10 80       	push   $0x801076dd
80103d9f:	e8 ec c5 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103da4:	83 ec 0c             	sub    $0xc,%esp
80103da7:	68 d0 76 10 80       	push   $0x801076d0
80103dac:	e8 df c5 ff ff       	call   80100390 <panic>
80103db1:	eb 0d                	jmp    80103dc0 <yield>
80103db3:	90                   	nop
80103db4:	90                   	nop
80103db5:	90                   	nop
80103db6:	90                   	nop
80103db7:	90                   	nop
80103db8:	90                   	nop
80103db9:	90                   	nop
80103dba:	90                   	nop
80103dbb:	90                   	nop
80103dbc:	90                   	nop
80103dbd:	90                   	nop
80103dbe:	90                   	nop
80103dbf:	90                   	nop

80103dc0 <yield>:
{
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	53                   	push   %ebx
80103dc4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103dc7:	68 20 2d 11 80       	push   $0x80112d20
80103dcc:	e8 ff 06 00 00       	call   801044d0 <acquire>
  pushcli();
80103dd1:	e8 2a 06 00 00       	call   80104400 <pushcli>
  c = mycpu();
80103dd6:	e8 a5 f9 ff ff       	call   80103780 <mycpu>
  p = c->proc;
80103ddb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103de1:	e8 5a 06 00 00       	call   80104440 <popcli>
  myproc()->state = RUNNABLE;
80103de6:	c7 43 70 03 00 00 00 	movl   $0x3,0x70(%ebx)
  sched();
80103ded:	e8 ae fd ff ff       	call   80103ba0 <sched>
  release(&ptable.lock);
80103df2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103df9:	e8 92 07 00 00       	call   80104590 <release>
}
80103dfe:	83 c4 10             	add    $0x10,%esp
80103e01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e04:	c9                   	leave  
80103e05:	c3                   	ret    
80103e06:	8d 76 00             	lea    0x0(%esi),%esi
80103e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e10 <sleep>:
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	57                   	push   %edi
80103e14:	56                   	push   %esi
80103e15:	53                   	push   %ebx
80103e16:	83 ec 0c             	sub    $0xc,%esp
80103e19:	8b 7d 08             	mov    0x8(%ebp),%edi
80103e1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103e1f:	e8 dc 05 00 00       	call   80104400 <pushcli>
  c = mycpu();
80103e24:	e8 57 f9 ff ff       	call   80103780 <mycpu>
  p = c->proc;
80103e29:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e2f:	e8 0c 06 00 00       	call   80104440 <popcli>
  if(p == 0)
80103e34:	85 db                	test   %ebx,%ebx
80103e36:	0f 84 95 00 00 00    	je     80103ed1 <sleep+0xc1>
  if(lk == 0)
80103e3c:	85 f6                	test   %esi,%esi
80103e3e:	0f 84 80 00 00 00    	je     80103ec4 <sleep+0xb4>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103e44:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103e4a:	74 54                	je     80103ea0 <sleep+0x90>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103e4c:	83 ec 0c             	sub    $0xc,%esp
80103e4f:	68 20 2d 11 80       	push   $0x80112d20
80103e54:	e8 77 06 00 00       	call   801044d0 <acquire>
    release(lk);
80103e59:	89 34 24             	mov    %esi,(%esp)
80103e5c:	e8 2f 07 00 00       	call   80104590 <release>
  p->chan = chan;
80103e61:	89 bb 84 00 00 00    	mov    %edi,0x84(%ebx)
  p->state = SLEEPING;
80103e67:	c7 43 70 02 00 00 00 	movl   $0x2,0x70(%ebx)
  sched();
80103e6e:	e8 2d fd ff ff       	call   80103ba0 <sched>
  p->chan = 0;
80103e73:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103e7a:	00 00 00 
    release(&ptable.lock);
80103e7d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e84:	e8 07 07 00 00       	call   80104590 <release>
    acquire(lk);
80103e89:	89 75 08             	mov    %esi,0x8(%ebp)
80103e8c:	83 c4 10             	add    $0x10,%esp
}
80103e8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e92:	5b                   	pop    %ebx
80103e93:	5e                   	pop    %esi
80103e94:	5f                   	pop    %edi
80103e95:	5d                   	pop    %ebp
    acquire(lk);
80103e96:	e9 35 06 00 00       	jmp    801044d0 <acquire>
80103e9b:	90                   	nop
80103e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103ea0:	89 bb 84 00 00 00    	mov    %edi,0x84(%ebx)
  p->state = SLEEPING;
80103ea6:	c7 43 70 02 00 00 00 	movl   $0x2,0x70(%ebx)
  sched();
80103ead:	e8 ee fc ff ff       	call   80103ba0 <sched>
  p->chan = 0;
80103eb2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103eb9:	00 00 00 
}
80103ebc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ebf:	5b                   	pop    %ebx
80103ec0:	5e                   	pop    %esi
80103ec1:	5f                   	pop    %edi
80103ec2:	5d                   	pop    %ebp
80103ec3:	c3                   	ret    
    panic("sleep without lk");
80103ec4:	83 ec 0c             	sub    $0xc,%esp
80103ec7:	68 ef 76 10 80       	push   $0x801076ef
80103ecc:	e8 bf c4 ff ff       	call   80100390 <panic>
    panic("sleep");
80103ed1:	83 ec 0c             	sub    $0xc,%esp
80103ed4:	68 e9 76 10 80       	push   $0x801076e9
80103ed9:	e8 b2 c4 ff ff       	call   80100390 <panic>
80103ede:	66 90                	xchg   %ax,%ax

80103ee0 <wait>:
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	56                   	push   %esi
80103ee4:	53                   	push   %ebx
  pushcli();
80103ee5:	e8 16 05 00 00       	call   80104400 <pushcli>
  c = mycpu();
80103eea:	e8 91 f8 ff ff       	call   80103780 <mycpu>
  p = c->proc;
80103eef:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ef5:	e8 46 05 00 00       	call   80104440 <popcli>
  acquire(&ptable.lock);
80103efa:	83 ec 0c             	sub    $0xc,%esp
80103efd:	68 20 2d 11 80       	push   $0x80112d20
80103f02:	e8 c9 05 00 00       	call   801044d0 <acquire>
80103f07:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f0a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f0c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103f11:	eb 13                	jmp    80103f26 <wait+0x46>
80103f13:	90                   	nop
80103f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f18:	81 c3 e0 00 00 00    	add    $0xe0,%ebx
80103f1e:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
80103f24:	73 1e                	jae    80103f44 <wait+0x64>
      if(p->parent != curproc)
80103f26:	39 73 78             	cmp    %esi,0x78(%ebx)
80103f29:	75 ed                	jne    80103f18 <wait+0x38>
      if(p->state == ZOMBIE){
80103f2b:	83 7b 70 05          	cmpl   $0x5,0x70(%ebx)
80103f2f:	74 37                	je     80103f68 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f31:	81 c3 e0 00 00 00    	add    $0xe0,%ebx
      havekids = 1;
80103f37:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f3c:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
80103f42:	72 e2                	jb     80103f26 <wait+0x46>
    if(!havekids || curproc->killed){
80103f44:	85 c0                	test   %eax,%eax
80103f46:	74 7c                	je     80103fc4 <wait+0xe4>
80103f48:	8b 86 88 00 00 00    	mov    0x88(%esi),%eax
80103f4e:	85 c0                	test   %eax,%eax
80103f50:	75 72                	jne    80103fc4 <wait+0xe4>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103f52:	83 ec 08             	sub    $0x8,%esp
80103f55:	68 20 2d 11 80       	push   $0x80112d20
80103f5a:	56                   	push   %esi
80103f5b:	e8 b0 fe ff ff       	call   80103e10 <sleep>
    havekids = 0;
80103f60:	83 c4 10             	add    $0x10,%esp
80103f63:	eb a5                	jmp    80103f0a <wait+0x2a>
80103f65:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80103f68:	83 ec 0c             	sub    $0xc,%esp
80103f6b:	ff 73 6c             	pushl  0x6c(%ebx)
        pid = p->pid;
80103f6e:	8b 73 74             	mov    0x74(%ebx),%esi
        kfree(p->kstack);
80103f71:	e8 aa e3 ff ff       	call   80102320 <kfree>
        freevm(p->pgdir);
80103f76:	5a                   	pop    %edx
80103f77:	ff 73 68             	pushl  0x68(%ebx)
        p->kstack = 0;
80103f7a:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
        freevm(p->pgdir);
80103f81:	e8 4a 2e 00 00       	call   80106dd0 <freevm>
        release(&ptable.lock);
80103f86:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80103f8d:	c7 43 74 00 00 00 00 	movl   $0x0,0x74(%ebx)
        p->parent = 0;
80103f94:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
        p->name[0] = 0;
80103f9b:	c6 83 d0 00 00 00 00 	movb   $0x0,0xd0(%ebx)
        p->killed = 0;
80103fa2:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103fa9:	00 00 00 
        p->state = UNUSED;
80103fac:	c7 43 70 00 00 00 00 	movl   $0x0,0x70(%ebx)
        release(&ptable.lock);
80103fb3:	e8 d8 05 00 00       	call   80104590 <release>
        return pid;
80103fb8:	83 c4 10             	add    $0x10,%esp
}
80103fbb:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fbe:	89 f0                	mov    %esi,%eax
80103fc0:	5b                   	pop    %ebx
80103fc1:	5e                   	pop    %esi
80103fc2:	5d                   	pop    %ebp
80103fc3:	c3                   	ret    
      release(&ptable.lock);
80103fc4:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103fc7:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103fcc:	68 20 2d 11 80       	push   $0x80112d20
80103fd1:	e8 ba 05 00 00       	call   80104590 <release>
      return -1;
80103fd6:	83 c4 10             	add    $0x10,%esp
80103fd9:	eb e0                	jmp    80103fbb <wait+0xdb>
80103fdb:	90                   	nop
80103fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103fe0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	53                   	push   %ebx
80103fe4:	83 ec 10             	sub    $0x10,%esp
80103fe7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103fea:	68 20 2d 11 80       	push   $0x80112d20
80103fef:	e8 dc 04 00 00       	call   801044d0 <acquire>
80103ff4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ff7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103ffc:	eb 0e                	jmp    8010400c <wakeup+0x2c>
80103ffe:	66 90                	xchg   %ax,%ax
80104000:	05 e0 00 00 00       	add    $0xe0,%eax
80104005:	3d 54 65 11 80       	cmp    $0x80116554,%eax
8010400a:	73 21                	jae    8010402d <wakeup+0x4d>
    if(p->state == SLEEPING && p->chan == chan)
8010400c:	83 78 70 02          	cmpl   $0x2,0x70(%eax)
80104010:	75 ee                	jne    80104000 <wakeup+0x20>
80104012:	3b 98 84 00 00 00    	cmp    0x84(%eax),%ebx
80104018:	75 e6                	jne    80104000 <wakeup+0x20>
      p->state = RUNNABLE;
8010401a:	c7 40 70 03 00 00 00 	movl   $0x3,0x70(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104021:	05 e0 00 00 00       	add    $0xe0,%eax
80104026:	3d 54 65 11 80       	cmp    $0x80116554,%eax
8010402b:	72 df                	jb     8010400c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010402d:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104034:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104037:	c9                   	leave  
  release(&ptable.lock);
80104038:	e9 53 05 00 00       	jmp    80104590 <release>
8010403d:	8d 76 00             	lea    0x0(%esi),%esi

80104040 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	53                   	push   %ebx
80104044:	83 ec 10             	sub    $0x10,%esp
80104047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010404a:	68 20 2d 11 80       	push   $0x80112d20
8010404f:	e8 7c 04 00 00       	call   801044d0 <acquire>
80104054:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104057:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010405c:	eb 0e                	jmp    8010406c <kill+0x2c>
8010405e:	66 90                	xchg   %ax,%ax
80104060:	05 e0 00 00 00       	add    $0xe0,%eax
80104065:	3d 54 65 11 80       	cmp    $0x80116554,%eax
8010406a:	73 34                	jae    801040a0 <kill+0x60>
    if(p->pid == pid){
8010406c:	39 58 74             	cmp    %ebx,0x74(%eax)
8010406f:	75 ef                	jne    80104060 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104071:	83 78 70 02          	cmpl   $0x2,0x70(%eax)
      p->killed = 1;
80104075:	c7 80 88 00 00 00 01 	movl   $0x1,0x88(%eax)
8010407c:	00 00 00 
      if(p->state == SLEEPING)
8010407f:	75 07                	jne    80104088 <kill+0x48>
        p->state = RUNNABLE;
80104081:	c7 40 70 03 00 00 00 	movl   $0x3,0x70(%eax)
      release(&ptable.lock);
80104088:	83 ec 0c             	sub    $0xc,%esp
8010408b:	68 20 2d 11 80       	push   $0x80112d20
80104090:	e8 fb 04 00 00       	call   80104590 <release>
      return 0;
80104095:	83 c4 10             	add    $0x10,%esp
80104098:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
8010409a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010409d:	c9                   	leave  
8010409e:	c3                   	ret    
8010409f:	90                   	nop
  release(&ptable.lock);
801040a0:	83 ec 0c             	sub    $0xc,%esp
801040a3:	68 20 2d 11 80       	push   $0x80112d20
801040a8:	e8 e3 04 00 00       	call   80104590 <release>
  return -1;
801040ad:	83 c4 10             	add    $0x10,%esp
801040b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801040b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040b8:	c9                   	leave  
801040b9:	c3                   	ret    
801040ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040c0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	57                   	push   %edi
801040c4:	56                   	push   %esi
801040c5:	53                   	push   %ebx
801040c6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040c9:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801040ce:	83 ec 3c             	sub    $0x3c,%esp
801040d1:	eb 27                	jmp    801040fa <procdump+0x3a>
801040d3:	90                   	nop
801040d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801040d8:	83 ec 0c             	sub    $0xc,%esp
801040db:	68 87 7a 10 80       	push   $0x80107a87
801040e0:	e8 7b c5 ff ff       	call   80100660 <cprintf>
801040e5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040e8:	81 c3 e0 00 00 00    	add    $0xe0,%ebx
801040ee:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
801040f4:	0f 83 96 00 00 00    	jae    80104190 <procdump+0xd0>
    if(p->state == UNUSED)
801040fa:	8b 43 70             	mov    0x70(%ebx),%eax
801040fd:	85 c0                	test   %eax,%eax
801040ff:	74 e7                	je     801040e8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104101:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104104:	ba 00 77 10 80       	mov    $0x80107700,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104109:	77 11                	ja     8010411c <procdump+0x5c>
8010410b:	8b 14 85 60 77 10 80 	mov    -0x7fef88a0(,%eax,4),%edx
      state = "???";
80104112:	b8 00 77 10 80       	mov    $0x80107700,%eax
80104117:	85 d2                	test   %edx,%edx
80104119:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010411c:	8d 83 d0 00 00 00    	lea    0xd0(%ebx),%eax
80104122:	50                   	push   %eax
80104123:	52                   	push   %edx
80104124:	ff 73 74             	pushl  0x74(%ebx)
80104127:	68 04 77 10 80       	push   $0x80107704
8010412c:	e8 2f c5 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104131:	83 c4 10             	add    $0x10,%esp
80104134:	83 7b 70 02          	cmpl   $0x2,0x70(%ebx)
80104138:	75 9e                	jne    801040d8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010413a:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010413d:	83 ec 08             	sub    $0x8,%esp
80104140:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104143:	50                   	push   %eax
80104144:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
8010414a:	8b 40 0c             	mov    0xc(%eax),%eax
8010414d:	83 c0 08             	add    $0x8,%eax
80104150:	50                   	push   %eax
80104151:	e8 5a 02 00 00       	call   801043b0 <getcallerpcs>
80104156:	83 c4 10             	add    $0x10,%esp
80104159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104160:	8b 17                	mov    (%edi),%edx
80104162:	85 d2                	test   %edx,%edx
80104164:	0f 84 6e ff ff ff    	je     801040d8 <procdump+0x18>
        cprintf(" %p", pc[i]);
8010416a:	83 ec 08             	sub    $0x8,%esp
8010416d:	83 c7 04             	add    $0x4,%edi
80104170:	52                   	push   %edx
80104171:	68 41 71 10 80       	push   $0x80107141
80104176:	e8 e5 c4 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010417b:	83 c4 10             	add    $0x10,%esp
8010417e:	39 fe                	cmp    %edi,%esi
80104180:	75 de                	jne    80104160 <procdump+0xa0>
80104182:	e9 51 ff ff ff       	jmp    801040d8 <procdump+0x18>
80104187:	89 f6                	mov    %esi,%esi
80104189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }
}
80104190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104193:	5b                   	pop    %ebx
80104194:	5e                   	pop    %esi
80104195:	5f                   	pop    %edi
80104196:	5d                   	pop    %ebp
80104197:	c3                   	ret    
80104198:	90                   	nop
80104199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041a0 <getppid>:

int getppid(void){
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	53                   	push   %ebx
801041a4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801041a7:	e8 54 02 00 00       	call   80104400 <pushcli>
  c = mycpu();
801041ac:	e8 cf f5 ff ff       	call   80103780 <mycpu>
  p = c->proc;
801041b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041b7:	e8 84 02 00 00       	call   80104440 <popcli>
	return myproc() -> parent ->pid;
801041bc:	8b 43 78             	mov    0x78(%ebx),%eax
801041bf:	8b 40 74             	mov    0x74(%eax),%eax
}
801041c2:	83 c4 04             	add    $0x4,%esp
801041c5:	5b                   	pop    %ebx
801041c6:	5d                   	pop    %ebp
801041c7:	c3                   	ret    
801041c8:	90                   	nop
801041c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041d0 <getchildren>:
int getchildren(void){
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	57                   	push   %edi
801041d4:	56                   	push   %esi
801041d5:	53                   	push   %ebx
    struct proc *p;
    int result=0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041d6:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
int getchildren(void){
801041db:	83 ec 1c             	sub    $0x1c,%esp
    int result=0;
801041de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801041e5:	8d 76 00             	lea    0x0(%esi),%esi
        if(p->parent->pid == myproc()->pid){
801041e8:	8b 43 78             	mov    0x78(%ebx),%eax
801041eb:	8b 78 74             	mov    0x74(%eax),%edi
  pushcli();
801041ee:	e8 0d 02 00 00       	call   80104400 <pushcli>
  c = mycpu();
801041f3:	e8 88 f5 ff ff       	call   80103780 <mycpu>
  p = c->proc;
801041f8:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801041fe:	e8 3d 02 00 00       	call   80104440 <popcli>
        if(p->parent->pid == myproc()->pid){
80104203:	3b 7e 74             	cmp    0x74(%esi),%edi
80104206:	75 0a                	jne    80104212 <getchildren+0x42>
            result *= 100;
80104208:	6b 7d e4 64          	imul   $0x64,-0x1c(%ebp),%edi
            result += p->pid;
8010420c:	03 7b 74             	add    0x74(%ebx),%edi
8010420f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104212:	81 c3 e0 00 00 00    	add    $0xe0,%ebx
80104218:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
8010421e:	72 c8                	jb     801041e8 <getchildren+0x18>
        }
    }
    return result;
}
80104220:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104223:	83 c4 1c             	add    $0x1c,%esp
80104226:	5b                   	pop    %ebx
80104227:	5e                   	pop    %esi
80104228:	5f                   	pop    %edi
80104229:	5d                   	pop    %ebp
8010422a:	c3                   	ret    
8010422b:	90                   	nop
8010422c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104230 <getcount>:
int getcount(int input){
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	53                   	push   %ebx
80104234:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104237:	e8 c4 01 00 00       	call   80104400 <pushcli>
  c = mycpu();
8010423c:	e8 3f f5 ff ff       	call   80103780 <mycpu>
  p = c->proc;
80104241:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104247:	e8 f4 01 00 00       	call   80104440 <popcli>
   return myproc()->hit[input];
8010424c:	8b 45 08             	mov    0x8(%ebp),%eax
8010424f:	8b 04 83             	mov    (%ebx,%eax,4),%eax
}
80104252:	83 c4 04             	add    $0x4,%esp
80104255:	5b                   	pop    %ebx
80104256:	5d                   	pop    %ebp
80104257:	c3                   	ret    
80104258:	66 90                	xchg   %ax,%ax
8010425a:	66 90                	xchg   %ax,%ax
8010425c:	66 90                	xchg   %ax,%ax
8010425e:	66 90                	xchg   %ax,%ax

80104260 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	53                   	push   %ebx
80104264:	83 ec 0c             	sub    $0xc,%esp
80104267:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010426a:	68 78 77 10 80       	push   $0x80107778
8010426f:	8d 43 04             	lea    0x4(%ebx),%eax
80104272:	50                   	push   %eax
80104273:	e8 18 01 00 00       	call   80104390 <initlock>
  lk->name = name;
80104278:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010427b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104281:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104284:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010428b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010428e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104291:	c9                   	leave  
80104292:	c3                   	ret    
80104293:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042a0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	56                   	push   %esi
801042a4:	53                   	push   %ebx
801042a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801042a8:	83 ec 0c             	sub    $0xc,%esp
801042ab:	8d 73 04             	lea    0x4(%ebx),%esi
801042ae:	56                   	push   %esi
801042af:	e8 1c 02 00 00       	call   801044d0 <acquire>
  while (lk->locked) {
801042b4:	8b 13                	mov    (%ebx),%edx
801042b6:	83 c4 10             	add    $0x10,%esp
801042b9:	85 d2                	test   %edx,%edx
801042bb:	74 16                	je     801042d3 <acquiresleep+0x33>
801042bd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801042c0:	83 ec 08             	sub    $0x8,%esp
801042c3:	56                   	push   %esi
801042c4:	53                   	push   %ebx
801042c5:	e8 46 fb ff ff       	call   80103e10 <sleep>
  while (lk->locked) {
801042ca:	8b 03                	mov    (%ebx),%eax
801042cc:	83 c4 10             	add    $0x10,%esp
801042cf:	85 c0                	test   %eax,%eax
801042d1:	75 ed                	jne    801042c0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801042d3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801042d9:	e8 42 f5 ff ff       	call   80103820 <myproc>
801042de:	8b 40 74             	mov    0x74(%eax),%eax
801042e1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801042e4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801042e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042ea:	5b                   	pop    %ebx
801042eb:	5e                   	pop    %esi
801042ec:	5d                   	pop    %ebp
  release(&lk->lk);
801042ed:	e9 9e 02 00 00       	jmp    80104590 <release>
801042f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104300 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	56                   	push   %esi
80104304:	53                   	push   %ebx
80104305:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104308:	83 ec 0c             	sub    $0xc,%esp
8010430b:	8d 73 04             	lea    0x4(%ebx),%esi
8010430e:	56                   	push   %esi
8010430f:	e8 bc 01 00 00       	call   801044d0 <acquire>
  lk->locked = 0;
80104314:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010431a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104321:	89 1c 24             	mov    %ebx,(%esp)
80104324:	e8 b7 fc ff ff       	call   80103fe0 <wakeup>
  release(&lk->lk);
80104329:	89 75 08             	mov    %esi,0x8(%ebp)
8010432c:	83 c4 10             	add    $0x10,%esp
}
8010432f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104332:	5b                   	pop    %ebx
80104333:	5e                   	pop    %esi
80104334:	5d                   	pop    %ebp
  release(&lk->lk);
80104335:	e9 56 02 00 00       	jmp    80104590 <release>
8010433a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104340 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	57                   	push   %edi
80104344:	56                   	push   %esi
80104345:	53                   	push   %ebx
80104346:	31 ff                	xor    %edi,%edi
80104348:	83 ec 18             	sub    $0x18,%esp
8010434b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010434e:	8d 73 04             	lea    0x4(%ebx),%esi
80104351:	56                   	push   %esi
80104352:	e8 79 01 00 00       	call   801044d0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104357:	8b 03                	mov    (%ebx),%eax
80104359:	83 c4 10             	add    $0x10,%esp
8010435c:	85 c0                	test   %eax,%eax
8010435e:	74 13                	je     80104373 <holdingsleep+0x33>
80104360:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104363:	e8 b8 f4 ff ff       	call   80103820 <myproc>
80104368:	39 58 74             	cmp    %ebx,0x74(%eax)
8010436b:	0f 94 c0             	sete   %al
8010436e:	0f b6 c0             	movzbl %al,%eax
80104371:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104373:	83 ec 0c             	sub    $0xc,%esp
80104376:	56                   	push   %esi
80104377:	e8 14 02 00 00       	call   80104590 <release>
  return r;
}
8010437c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010437f:	89 f8                	mov    %edi,%eax
80104381:	5b                   	pop    %ebx
80104382:	5e                   	pop    %esi
80104383:	5f                   	pop    %edi
80104384:	5d                   	pop    %ebp
80104385:	c3                   	ret    
80104386:	66 90                	xchg   %ax,%ax
80104388:	66 90                	xchg   %ax,%ax
8010438a:	66 90                	xchg   %ax,%ax
8010438c:	66 90                	xchg   %ax,%ax
8010438e:	66 90                	xchg   %ax,%ax

80104390 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104396:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104399:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010439f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801043a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801043a9:	5d                   	pop    %ebp
801043aa:	c3                   	ret    
801043ab:	90                   	nop
801043ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801043b0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801043b0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043b1:	31 d2                	xor    %edx,%edx
{
801043b3:	89 e5                	mov    %esp,%ebp
801043b5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801043b6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801043b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801043bc:	83 e8 08             	sub    $0x8,%eax
801043bf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801043c0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801043c6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801043cc:	77 1a                	ja     801043e8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801043ce:	8b 58 04             	mov    0x4(%eax),%ebx
801043d1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801043d4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801043d7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801043d9:	83 fa 0a             	cmp    $0xa,%edx
801043dc:	75 e2                	jne    801043c0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801043de:	5b                   	pop    %ebx
801043df:	5d                   	pop    %ebp
801043e0:	c3                   	ret    
801043e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043e8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801043eb:	83 c1 28             	add    $0x28,%ecx
801043ee:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801043f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801043f6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801043f9:	39 c1                	cmp    %eax,%ecx
801043fb:	75 f3                	jne    801043f0 <getcallerpcs+0x40>
}
801043fd:	5b                   	pop    %ebx
801043fe:	5d                   	pop    %ebp
801043ff:	c3                   	ret    

80104400 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	53                   	push   %ebx
80104404:	83 ec 04             	sub    $0x4,%esp
80104407:	9c                   	pushf  
80104408:	5b                   	pop    %ebx
  asm volatile("cli");
80104409:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010440a:	e8 71 f3 ff ff       	call   80103780 <mycpu>
8010440f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104415:	85 c0                	test   %eax,%eax
80104417:	75 11                	jne    8010442a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104419:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010441f:	e8 5c f3 ff ff       	call   80103780 <mycpu>
80104424:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010442a:	e8 51 f3 ff ff       	call   80103780 <mycpu>
8010442f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104436:	83 c4 04             	add    $0x4,%esp
80104439:	5b                   	pop    %ebx
8010443a:	5d                   	pop    %ebp
8010443b:	c3                   	ret    
8010443c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104440 <popcli>:

void
popcli(void)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104446:	9c                   	pushf  
80104447:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104448:	f6 c4 02             	test   $0x2,%ah
8010444b:	75 35                	jne    80104482 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010444d:	e8 2e f3 ff ff       	call   80103780 <mycpu>
80104452:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104459:	78 34                	js     8010448f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010445b:	e8 20 f3 ff ff       	call   80103780 <mycpu>
80104460:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104466:	85 d2                	test   %edx,%edx
80104468:	74 06                	je     80104470 <popcli+0x30>
    sti();
}
8010446a:	c9                   	leave  
8010446b:	c3                   	ret    
8010446c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104470:	e8 0b f3 ff ff       	call   80103780 <mycpu>
80104475:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010447b:	85 c0                	test   %eax,%eax
8010447d:	74 eb                	je     8010446a <popcli+0x2a>
  asm volatile("sti");
8010447f:	fb                   	sti    
}
80104480:	c9                   	leave  
80104481:	c3                   	ret    
    panic("popcli - interruptible");
80104482:	83 ec 0c             	sub    $0xc,%esp
80104485:	68 83 77 10 80       	push   $0x80107783
8010448a:	e8 01 bf ff ff       	call   80100390 <panic>
    panic("popcli");
8010448f:	83 ec 0c             	sub    $0xc,%esp
80104492:	68 9a 77 10 80       	push   $0x8010779a
80104497:	e8 f4 be ff ff       	call   80100390 <panic>
8010449c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044a0 <holding>:
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	56                   	push   %esi
801044a4:	53                   	push   %ebx
801044a5:	8b 75 08             	mov    0x8(%ebp),%esi
801044a8:	31 db                	xor    %ebx,%ebx
  pushcli();
801044aa:	e8 51 ff ff ff       	call   80104400 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801044af:	8b 06                	mov    (%esi),%eax
801044b1:	85 c0                	test   %eax,%eax
801044b3:	74 10                	je     801044c5 <holding+0x25>
801044b5:	8b 5e 08             	mov    0x8(%esi),%ebx
801044b8:	e8 c3 f2 ff ff       	call   80103780 <mycpu>
801044bd:	39 c3                	cmp    %eax,%ebx
801044bf:	0f 94 c3             	sete   %bl
801044c2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
801044c5:	e8 76 ff ff ff       	call   80104440 <popcli>
}
801044ca:	89 d8                	mov    %ebx,%eax
801044cc:	5b                   	pop    %ebx
801044cd:	5e                   	pop    %esi
801044ce:	5d                   	pop    %ebp
801044cf:	c3                   	ret    

801044d0 <acquire>:
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	56                   	push   %esi
801044d4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801044d5:	e8 26 ff ff ff       	call   80104400 <pushcli>
  if(holding(lk))
801044da:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044dd:	83 ec 0c             	sub    $0xc,%esp
801044e0:	53                   	push   %ebx
801044e1:	e8 ba ff ff ff       	call   801044a0 <holding>
801044e6:	83 c4 10             	add    $0x10,%esp
801044e9:	85 c0                	test   %eax,%eax
801044eb:	0f 85 83 00 00 00    	jne    80104574 <acquire+0xa4>
801044f1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801044f3:	ba 01 00 00 00       	mov    $0x1,%edx
801044f8:	eb 09                	jmp    80104503 <acquire+0x33>
801044fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104500:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104503:	89 d0                	mov    %edx,%eax
80104505:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104508:	85 c0                	test   %eax,%eax
8010450a:	75 f4                	jne    80104500 <acquire+0x30>
  __sync_synchronize();
8010450c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104511:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104514:	e8 67 f2 ff ff       	call   80103780 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104519:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010451c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010451f:	89 e8                	mov    %ebp,%eax
80104521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104528:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010452e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104534:	77 1a                	ja     80104550 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104536:	8b 48 04             	mov    0x4(%eax),%ecx
80104539:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010453c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010453f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104541:	83 fe 0a             	cmp    $0xa,%esi
80104544:	75 e2                	jne    80104528 <acquire+0x58>
}
80104546:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104549:	5b                   	pop    %ebx
8010454a:	5e                   	pop    %esi
8010454b:	5d                   	pop    %ebp
8010454c:	c3                   	ret    
8010454d:	8d 76 00             	lea    0x0(%esi),%esi
80104550:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104553:	83 c2 28             	add    $0x28,%edx
80104556:	8d 76 00             	lea    0x0(%esi),%esi
80104559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104560:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104566:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104569:	39 d0                	cmp    %edx,%eax
8010456b:	75 f3                	jne    80104560 <acquire+0x90>
}
8010456d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104570:	5b                   	pop    %ebx
80104571:	5e                   	pop    %esi
80104572:	5d                   	pop    %ebp
80104573:	c3                   	ret    
    panic("acquire");
80104574:	83 ec 0c             	sub    $0xc,%esp
80104577:	68 a1 77 10 80       	push   $0x801077a1
8010457c:	e8 0f be ff ff       	call   80100390 <panic>
80104581:	eb 0d                	jmp    80104590 <release>
80104583:	90                   	nop
80104584:	90                   	nop
80104585:	90                   	nop
80104586:	90                   	nop
80104587:	90                   	nop
80104588:	90                   	nop
80104589:	90                   	nop
8010458a:	90                   	nop
8010458b:	90                   	nop
8010458c:	90                   	nop
8010458d:	90                   	nop
8010458e:	90                   	nop
8010458f:	90                   	nop

80104590 <release>:
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	53                   	push   %ebx
80104594:	83 ec 10             	sub    $0x10,%esp
80104597:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010459a:	53                   	push   %ebx
8010459b:	e8 00 ff ff ff       	call   801044a0 <holding>
801045a0:	83 c4 10             	add    $0x10,%esp
801045a3:	85 c0                	test   %eax,%eax
801045a5:	74 22                	je     801045c9 <release+0x39>
  lk->pcs[0] = 0;
801045a7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801045ae:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801045b5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801045ba:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801045c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045c3:	c9                   	leave  
  popcli();
801045c4:	e9 77 fe ff ff       	jmp    80104440 <popcli>
    panic("release");
801045c9:	83 ec 0c             	sub    $0xc,%esp
801045cc:	68 a9 77 10 80       	push   $0x801077a9
801045d1:	e8 ba bd ff ff       	call   80100390 <panic>
801045d6:	66 90                	xchg   %ax,%ax
801045d8:	66 90                	xchg   %ax,%ax
801045da:	66 90                	xchg   %ax,%ax
801045dc:	66 90                	xchg   %ax,%ax
801045de:	66 90                	xchg   %ax,%ax

801045e0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	57                   	push   %edi
801045e4:	53                   	push   %ebx
801045e5:	8b 55 08             	mov    0x8(%ebp),%edx
801045e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801045eb:	f6 c2 03             	test   $0x3,%dl
801045ee:	75 05                	jne    801045f5 <memset+0x15>
801045f0:	f6 c1 03             	test   $0x3,%cl
801045f3:	74 13                	je     80104608 <memset+0x28>
  asm volatile("cld; rep stosb" :
801045f5:	89 d7                	mov    %edx,%edi
801045f7:	8b 45 0c             	mov    0xc(%ebp),%eax
801045fa:	fc                   	cld    
801045fb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801045fd:	5b                   	pop    %ebx
801045fe:	89 d0                	mov    %edx,%eax
80104600:	5f                   	pop    %edi
80104601:	5d                   	pop    %ebp
80104602:	c3                   	ret    
80104603:	90                   	nop
80104604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104608:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010460c:	c1 e9 02             	shr    $0x2,%ecx
8010460f:	89 f8                	mov    %edi,%eax
80104611:	89 fb                	mov    %edi,%ebx
80104613:	c1 e0 18             	shl    $0x18,%eax
80104616:	c1 e3 10             	shl    $0x10,%ebx
80104619:	09 d8                	or     %ebx,%eax
8010461b:	09 f8                	or     %edi,%eax
8010461d:	c1 e7 08             	shl    $0x8,%edi
80104620:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104622:	89 d7                	mov    %edx,%edi
80104624:	fc                   	cld    
80104625:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104627:	5b                   	pop    %ebx
80104628:	89 d0                	mov    %edx,%eax
8010462a:	5f                   	pop    %edi
8010462b:	5d                   	pop    %ebp
8010462c:	c3                   	ret    
8010462d:	8d 76 00             	lea    0x0(%esi),%esi

80104630 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	57                   	push   %edi
80104634:	56                   	push   %esi
80104635:	53                   	push   %ebx
80104636:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104639:	8b 75 08             	mov    0x8(%ebp),%esi
8010463c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010463f:	85 db                	test   %ebx,%ebx
80104641:	74 29                	je     8010466c <memcmp+0x3c>
    if(*s1 != *s2)
80104643:	0f b6 16             	movzbl (%esi),%edx
80104646:	0f b6 0f             	movzbl (%edi),%ecx
80104649:	38 d1                	cmp    %dl,%cl
8010464b:	75 2b                	jne    80104678 <memcmp+0x48>
8010464d:	b8 01 00 00 00       	mov    $0x1,%eax
80104652:	eb 14                	jmp    80104668 <memcmp+0x38>
80104654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104658:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010465c:	83 c0 01             	add    $0x1,%eax
8010465f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104664:	38 ca                	cmp    %cl,%dl
80104666:	75 10                	jne    80104678 <memcmp+0x48>
  while(n-- > 0){
80104668:	39 d8                	cmp    %ebx,%eax
8010466a:	75 ec                	jne    80104658 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010466c:	5b                   	pop    %ebx
  return 0;
8010466d:	31 c0                	xor    %eax,%eax
}
8010466f:	5e                   	pop    %esi
80104670:	5f                   	pop    %edi
80104671:	5d                   	pop    %ebp
80104672:	c3                   	ret    
80104673:	90                   	nop
80104674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104678:	0f b6 c2             	movzbl %dl,%eax
}
8010467b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010467c:	29 c8                	sub    %ecx,%eax
}
8010467e:	5e                   	pop    %esi
8010467f:	5f                   	pop    %edi
80104680:	5d                   	pop    %ebp
80104681:	c3                   	ret    
80104682:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104690 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	56                   	push   %esi
80104694:	53                   	push   %ebx
80104695:	8b 45 08             	mov    0x8(%ebp),%eax
80104698:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010469b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010469e:	39 c3                	cmp    %eax,%ebx
801046a0:	73 26                	jae    801046c8 <memmove+0x38>
801046a2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801046a5:	39 c8                	cmp    %ecx,%eax
801046a7:	73 1f                	jae    801046c8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801046a9:	85 f6                	test   %esi,%esi
801046ab:	8d 56 ff             	lea    -0x1(%esi),%edx
801046ae:	74 0f                	je     801046bf <memmove+0x2f>
      *--d = *--s;
801046b0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801046b4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801046b7:	83 ea 01             	sub    $0x1,%edx
801046ba:	83 fa ff             	cmp    $0xffffffff,%edx
801046bd:	75 f1                	jne    801046b0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801046bf:	5b                   	pop    %ebx
801046c0:	5e                   	pop    %esi
801046c1:	5d                   	pop    %ebp
801046c2:	c3                   	ret    
801046c3:	90                   	nop
801046c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801046c8:	31 d2                	xor    %edx,%edx
801046ca:	85 f6                	test   %esi,%esi
801046cc:	74 f1                	je     801046bf <memmove+0x2f>
801046ce:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801046d0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801046d4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801046d7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801046da:	39 d6                	cmp    %edx,%esi
801046dc:	75 f2                	jne    801046d0 <memmove+0x40>
}
801046de:	5b                   	pop    %ebx
801046df:	5e                   	pop    %esi
801046e0:	5d                   	pop    %ebp
801046e1:	c3                   	ret    
801046e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046f0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801046f3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801046f4:	eb 9a                	jmp    80104690 <memmove>
801046f6:	8d 76 00             	lea    0x0(%esi),%esi
801046f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104700 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	57                   	push   %edi
80104704:	56                   	push   %esi
80104705:	8b 7d 10             	mov    0x10(%ebp),%edi
80104708:	53                   	push   %ebx
80104709:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010470c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010470f:	85 ff                	test   %edi,%edi
80104711:	74 2f                	je     80104742 <strncmp+0x42>
80104713:	0f b6 01             	movzbl (%ecx),%eax
80104716:	0f b6 1e             	movzbl (%esi),%ebx
80104719:	84 c0                	test   %al,%al
8010471b:	74 37                	je     80104754 <strncmp+0x54>
8010471d:	38 c3                	cmp    %al,%bl
8010471f:	75 33                	jne    80104754 <strncmp+0x54>
80104721:	01 f7                	add    %esi,%edi
80104723:	eb 13                	jmp    80104738 <strncmp+0x38>
80104725:	8d 76 00             	lea    0x0(%esi),%esi
80104728:	0f b6 01             	movzbl (%ecx),%eax
8010472b:	84 c0                	test   %al,%al
8010472d:	74 21                	je     80104750 <strncmp+0x50>
8010472f:	0f b6 1a             	movzbl (%edx),%ebx
80104732:	89 d6                	mov    %edx,%esi
80104734:	38 d8                	cmp    %bl,%al
80104736:	75 1c                	jne    80104754 <strncmp+0x54>
    n--, p++, q++;
80104738:	8d 56 01             	lea    0x1(%esi),%edx
8010473b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010473e:	39 fa                	cmp    %edi,%edx
80104740:	75 e6                	jne    80104728 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104742:	5b                   	pop    %ebx
    return 0;
80104743:	31 c0                	xor    %eax,%eax
}
80104745:	5e                   	pop    %esi
80104746:	5f                   	pop    %edi
80104747:	5d                   	pop    %ebp
80104748:	c3                   	ret    
80104749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104750:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104754:	29 d8                	sub    %ebx,%eax
}
80104756:	5b                   	pop    %ebx
80104757:	5e                   	pop    %esi
80104758:	5f                   	pop    %edi
80104759:	5d                   	pop    %ebp
8010475a:	c3                   	ret    
8010475b:	90                   	nop
8010475c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104760 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	56                   	push   %esi
80104764:	53                   	push   %ebx
80104765:	8b 45 08             	mov    0x8(%ebp),%eax
80104768:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010476b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010476e:	89 c2                	mov    %eax,%edx
80104770:	eb 19                	jmp    8010478b <strncpy+0x2b>
80104772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104778:	83 c3 01             	add    $0x1,%ebx
8010477b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010477f:	83 c2 01             	add    $0x1,%edx
80104782:	84 c9                	test   %cl,%cl
80104784:	88 4a ff             	mov    %cl,-0x1(%edx)
80104787:	74 09                	je     80104792 <strncpy+0x32>
80104789:	89 f1                	mov    %esi,%ecx
8010478b:	85 c9                	test   %ecx,%ecx
8010478d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104790:	7f e6                	jg     80104778 <strncpy+0x18>
    ;
  while(n-- > 0)
80104792:	31 c9                	xor    %ecx,%ecx
80104794:	85 f6                	test   %esi,%esi
80104796:	7e 17                	jle    801047af <strncpy+0x4f>
80104798:	90                   	nop
80104799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801047a0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801047a4:	89 f3                	mov    %esi,%ebx
801047a6:	83 c1 01             	add    $0x1,%ecx
801047a9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801047ab:	85 db                	test   %ebx,%ebx
801047ad:	7f f1                	jg     801047a0 <strncpy+0x40>
  return os;
}
801047af:	5b                   	pop    %ebx
801047b0:	5e                   	pop    %esi
801047b1:	5d                   	pop    %ebp
801047b2:	c3                   	ret    
801047b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047c0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	56                   	push   %esi
801047c4:	53                   	push   %ebx
801047c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801047c8:	8b 45 08             	mov    0x8(%ebp),%eax
801047cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801047ce:	85 c9                	test   %ecx,%ecx
801047d0:	7e 26                	jle    801047f8 <safestrcpy+0x38>
801047d2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801047d6:	89 c1                	mov    %eax,%ecx
801047d8:	eb 17                	jmp    801047f1 <safestrcpy+0x31>
801047da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801047e0:	83 c2 01             	add    $0x1,%edx
801047e3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801047e7:	83 c1 01             	add    $0x1,%ecx
801047ea:	84 db                	test   %bl,%bl
801047ec:	88 59 ff             	mov    %bl,-0x1(%ecx)
801047ef:	74 04                	je     801047f5 <safestrcpy+0x35>
801047f1:	39 f2                	cmp    %esi,%edx
801047f3:	75 eb                	jne    801047e0 <safestrcpy+0x20>
    ;
  *s = 0;
801047f5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801047f8:	5b                   	pop    %ebx
801047f9:	5e                   	pop    %esi
801047fa:	5d                   	pop    %ebp
801047fb:	c3                   	ret    
801047fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104800 <strlen>:

int
strlen(const char *s)
{
80104800:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104801:	31 c0                	xor    %eax,%eax
{
80104803:	89 e5                	mov    %esp,%ebp
80104805:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104808:	80 3a 00             	cmpb   $0x0,(%edx)
8010480b:	74 0c                	je     80104819 <strlen+0x19>
8010480d:	8d 76 00             	lea    0x0(%esi),%esi
80104810:	83 c0 01             	add    $0x1,%eax
80104813:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104817:	75 f7                	jne    80104810 <strlen+0x10>
    ;
  return n;
}
80104819:	5d                   	pop    %ebp
8010481a:	c3                   	ret    

8010481b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010481b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010481f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104823:	55                   	push   %ebp
  pushl %ebx
80104824:	53                   	push   %ebx
  pushl %esi
80104825:	56                   	push   %esi
  pushl %edi
80104826:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104827:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104829:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010482b:	5f                   	pop    %edi
  popl %esi
8010482c:	5e                   	pop    %esi
  popl %ebx
8010482d:	5b                   	pop    %ebx
  popl %ebp
8010482e:	5d                   	pop    %ebp
  ret
8010482f:	c3                   	ret    

80104830 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	53                   	push   %ebx
80104834:	83 ec 04             	sub    $0x4,%esp
80104837:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010483a:	e8 e1 ef ff ff       	call   80103820 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010483f:	8b 40 64             	mov    0x64(%eax),%eax
80104842:	39 d8                	cmp    %ebx,%eax
80104844:	76 1a                	jbe    80104860 <fetchint+0x30>
80104846:	8d 53 04             	lea    0x4(%ebx),%edx
80104849:	39 d0                	cmp    %edx,%eax
8010484b:	72 13                	jb     80104860 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010484d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104850:	8b 13                	mov    (%ebx),%edx
80104852:	89 10                	mov    %edx,(%eax)
  return 0;
80104854:	31 c0                	xor    %eax,%eax
}
80104856:	83 c4 04             	add    $0x4,%esp
80104859:	5b                   	pop    %ebx
8010485a:	5d                   	pop    %ebp
8010485b:	c3                   	ret    
8010485c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104860:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104865:	eb ef                	jmp    80104856 <fetchint+0x26>
80104867:	89 f6                	mov    %esi,%esi
80104869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104870 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	53                   	push   %ebx
80104874:	83 ec 04             	sub    $0x4,%esp
80104877:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010487a:	e8 a1 ef ff ff       	call   80103820 <myproc>

  if(addr >= curproc->sz)
8010487f:	39 58 64             	cmp    %ebx,0x64(%eax)
80104882:	76 28                	jbe    801048ac <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104884:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104887:	89 da                	mov    %ebx,%edx
80104889:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010488b:	8b 40 64             	mov    0x64(%eax),%eax
  for(s = *pp; s < ep; s++){
8010488e:	39 c3                	cmp    %eax,%ebx
80104890:	73 1a                	jae    801048ac <fetchstr+0x3c>
    if(*s == 0)
80104892:	80 3b 00             	cmpb   $0x0,(%ebx)
80104895:	75 0e                	jne    801048a5 <fetchstr+0x35>
80104897:	eb 37                	jmp    801048d0 <fetchstr+0x60>
80104899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048a0:	80 3a 00             	cmpb   $0x0,(%edx)
801048a3:	74 1b                	je     801048c0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
801048a5:	83 c2 01             	add    $0x1,%edx
801048a8:	39 d0                	cmp    %edx,%eax
801048aa:	77 f4                	ja     801048a0 <fetchstr+0x30>
    return -1;
801048ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
801048b1:	83 c4 04             	add    $0x4,%esp
801048b4:	5b                   	pop    %ebx
801048b5:	5d                   	pop    %ebp
801048b6:	c3                   	ret    
801048b7:	89 f6                	mov    %esi,%esi
801048b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801048c0:	83 c4 04             	add    $0x4,%esp
801048c3:	89 d0                	mov    %edx,%eax
801048c5:	29 d8                	sub    %ebx,%eax
801048c7:	5b                   	pop    %ebx
801048c8:	5d                   	pop    %ebp
801048c9:	c3                   	ret    
801048ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
801048d0:	31 c0                	xor    %eax,%eax
      return s - *pp;
801048d2:	eb dd                	jmp    801048b1 <fetchstr+0x41>
801048d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801048e0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	56                   	push   %esi
801048e4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801048e5:	e8 36 ef ff ff       	call   80103820 <myproc>
801048ea:	8b 40 7c             	mov    0x7c(%eax),%eax
801048ed:	8b 55 08             	mov    0x8(%ebp),%edx
801048f0:	8b 40 44             	mov    0x44(%eax),%eax
801048f3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801048f6:	e8 25 ef ff ff       	call   80103820 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048fb:	8b 40 64             	mov    0x64(%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801048fe:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104901:	39 c6                	cmp    %eax,%esi
80104903:	73 1b                	jae    80104920 <argint+0x40>
80104905:	8d 53 08             	lea    0x8(%ebx),%edx
80104908:	39 d0                	cmp    %edx,%eax
8010490a:	72 14                	jb     80104920 <argint+0x40>
  *ip = *(int*)(addr);
8010490c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010490f:	8b 53 04             	mov    0x4(%ebx),%edx
80104912:	89 10                	mov    %edx,(%eax)
  return 0;
80104914:	31 c0                	xor    %eax,%eax
}
80104916:	5b                   	pop    %ebx
80104917:	5e                   	pop    %esi
80104918:	5d                   	pop    %ebp
80104919:	c3                   	ret    
8010491a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104920:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104925:	eb ef                	jmp    80104916 <argint+0x36>
80104927:	89 f6                	mov    %esi,%esi
80104929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104930 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	56                   	push   %esi
80104934:	53                   	push   %ebx
80104935:	83 ec 10             	sub    $0x10,%esp
80104938:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010493b:	e8 e0 ee ff ff       	call   80103820 <myproc>
80104940:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104942:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104945:	83 ec 08             	sub    $0x8,%esp
80104948:	50                   	push   %eax
80104949:	ff 75 08             	pushl  0x8(%ebp)
8010494c:	e8 8f ff ff ff       	call   801048e0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104951:	83 c4 10             	add    $0x10,%esp
80104954:	85 c0                	test   %eax,%eax
80104956:	78 28                	js     80104980 <argptr+0x50>
80104958:	85 db                	test   %ebx,%ebx
8010495a:	78 24                	js     80104980 <argptr+0x50>
8010495c:	8b 56 64             	mov    0x64(%esi),%edx
8010495f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104962:	39 c2                	cmp    %eax,%edx
80104964:	76 1a                	jbe    80104980 <argptr+0x50>
80104966:	01 c3                	add    %eax,%ebx
80104968:	39 da                	cmp    %ebx,%edx
8010496a:	72 14                	jb     80104980 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010496c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010496f:	89 02                	mov    %eax,(%edx)
  return 0;
80104971:	31 c0                	xor    %eax,%eax
}
80104973:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104976:	5b                   	pop    %ebx
80104977:	5e                   	pop    %esi
80104978:	5d                   	pop    %ebp
80104979:	c3                   	ret    
8010497a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104980:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104985:	eb ec                	jmp    80104973 <argptr+0x43>
80104987:	89 f6                	mov    %esi,%esi
80104989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104990 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104996:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104999:	50                   	push   %eax
8010499a:	ff 75 08             	pushl  0x8(%ebp)
8010499d:	e8 3e ff ff ff       	call   801048e0 <argint>
801049a2:	83 c4 10             	add    $0x10,%esp
801049a5:	85 c0                	test   %eax,%eax
801049a7:	78 17                	js     801049c0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801049a9:	83 ec 08             	sub    $0x8,%esp
801049ac:	ff 75 0c             	pushl  0xc(%ebp)
801049af:	ff 75 f4             	pushl  -0xc(%ebp)
801049b2:	e8 b9 fe ff ff       	call   80104870 <fetchstr>
801049b7:	83 c4 10             	add    $0x10,%esp
}
801049ba:	c9                   	leave  
801049bb:	c3                   	ret    
801049bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049c5:	c9                   	leave  
801049c6:	c3                   	ret    
801049c7:	89 f6                	mov    %esi,%esi
801049c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049d0 <syscall>:
};


void
syscall(void)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	56                   	push   %esi
801049d4:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
801049d5:	e8 46 ee ff ff       	call   80103820 <myproc>
801049da:	89 c6                	mov    %eax,%esi

  num = curproc->tf->eax;
801049dc:	8b 40 7c             	mov    0x7c(%eax),%eax
801049df:	8b 58 1c             	mov    0x1c(%eax),%ebx
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801049e2:	8d 43 ff             	lea    -0x1(%ebx),%eax
801049e5:	83 f8 18             	cmp    $0x18,%eax
801049e8:	77 26                	ja     80104a10 <syscall+0x40>
801049ea:	8b 04 9d e0 77 10 80 	mov    -0x7fef8820(,%ebx,4),%eax
801049f1:	85 c0                	test   %eax,%eax
801049f3:	74 1b                	je     80104a10 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801049f5:	ff d0                	call   *%eax
801049f7:	8b 56 7c             	mov    0x7c(%esi),%edx
801049fa:	89 42 1c             	mov    %eax,0x1c(%edx)
    myproc()->hit[num]++;
801049fd:	e8 1e ee ff ff       	call   80103820 <myproc>
80104a02:	83 04 98 01          	addl   $0x1,(%eax,%ebx,4)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104a06:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a09:	5b                   	pop    %ebx
80104a0a:	5e                   	pop    %esi
80104a0b:	5d                   	pop    %ebp
80104a0c:	c3                   	ret    
80104a0d:	8d 76 00             	lea    0x0(%esi),%esi
            curproc->pid, curproc->name, num);
80104a10:	8d 86 d0 00 00 00    	lea    0xd0(%esi),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104a16:	53                   	push   %ebx
80104a17:	50                   	push   %eax
80104a18:	ff 76 74             	pushl  0x74(%esi)
80104a1b:	68 b1 77 10 80       	push   $0x801077b1
80104a20:	e8 3b bc ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104a25:	8b 46 7c             	mov    0x7c(%esi),%eax
80104a28:	83 c4 10             	add    $0x10,%esp
80104a2b:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104a32:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a35:	5b                   	pop    %ebx
80104a36:	5e                   	pop    %esi
80104a37:	5d                   	pop    %ebp
80104a38:	c3                   	ret    
80104a39:	66 90                	xchg   %ax,%ax
80104a3b:	66 90                	xchg   %ax,%ax
80104a3d:	66 90                	xchg   %ax,%ax
80104a3f:	90                   	nop

80104a40 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	57                   	push   %edi
80104a44:	56                   	push   %esi
80104a45:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104a46:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104a49:	83 ec 34             	sub    $0x34,%esp
80104a4c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104a4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104a52:	56                   	push   %esi
80104a53:	50                   	push   %eax
{
80104a54:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104a57:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104a5a:	e8 b1 d4 ff ff       	call   80101f10 <nameiparent>
80104a5f:	83 c4 10             	add    $0x10,%esp
80104a62:	85 c0                	test   %eax,%eax
80104a64:	0f 84 46 01 00 00    	je     80104bb0 <create+0x170>
    return 0;
  ilock(dp);
80104a6a:	83 ec 0c             	sub    $0xc,%esp
80104a6d:	89 c3                	mov    %eax,%ebx
80104a6f:	50                   	push   %eax
80104a70:	e8 0b cc ff ff       	call   80101680 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104a75:	83 c4 0c             	add    $0xc,%esp
80104a78:	6a 00                	push   $0x0
80104a7a:	56                   	push   %esi
80104a7b:	53                   	push   %ebx
80104a7c:	e8 2f d1 ff ff       	call   80101bb0 <dirlookup>
80104a81:	83 c4 10             	add    $0x10,%esp
80104a84:	85 c0                	test   %eax,%eax
80104a86:	89 c7                	mov    %eax,%edi
80104a88:	74 36                	je     80104ac0 <create+0x80>
    iunlockput(dp);
80104a8a:	83 ec 0c             	sub    $0xc,%esp
80104a8d:	53                   	push   %ebx
80104a8e:	e8 7d ce ff ff       	call   80101910 <iunlockput>
    ilock(ip);
80104a93:	89 3c 24             	mov    %edi,(%esp)
80104a96:	e8 e5 cb ff ff       	call   80101680 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104a9b:	83 c4 10             	add    $0x10,%esp
80104a9e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104aa3:	0f 85 97 00 00 00    	jne    80104b40 <create+0x100>
80104aa9:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104aae:	0f 85 8c 00 00 00    	jne    80104b40 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104ab4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ab7:	89 f8                	mov    %edi,%eax
80104ab9:	5b                   	pop    %ebx
80104aba:	5e                   	pop    %esi
80104abb:	5f                   	pop    %edi
80104abc:	5d                   	pop    %ebp
80104abd:	c3                   	ret    
80104abe:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80104ac0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104ac4:	83 ec 08             	sub    $0x8,%esp
80104ac7:	50                   	push   %eax
80104ac8:	ff 33                	pushl  (%ebx)
80104aca:	e8 41 ca ff ff       	call   80101510 <ialloc>
80104acf:	83 c4 10             	add    $0x10,%esp
80104ad2:	85 c0                	test   %eax,%eax
80104ad4:	89 c7                	mov    %eax,%edi
80104ad6:	0f 84 e8 00 00 00    	je     80104bc4 <create+0x184>
  ilock(ip);
80104adc:	83 ec 0c             	sub    $0xc,%esp
80104adf:	50                   	push   %eax
80104ae0:	e8 9b cb ff ff       	call   80101680 <ilock>
  ip->major = major;
80104ae5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104ae9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104aed:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104af1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104af5:	b8 01 00 00 00       	mov    $0x1,%eax
80104afa:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104afe:	89 3c 24             	mov    %edi,(%esp)
80104b01:	e8 ca ca ff ff       	call   801015d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104b06:	83 c4 10             	add    $0x10,%esp
80104b09:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104b0e:	74 50                	je     80104b60 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104b10:	83 ec 04             	sub    $0x4,%esp
80104b13:	ff 77 04             	pushl  0x4(%edi)
80104b16:	56                   	push   %esi
80104b17:	53                   	push   %ebx
80104b18:	e8 13 d3 ff ff       	call   80101e30 <dirlink>
80104b1d:	83 c4 10             	add    $0x10,%esp
80104b20:	85 c0                	test   %eax,%eax
80104b22:	0f 88 8f 00 00 00    	js     80104bb7 <create+0x177>
  iunlockput(dp);
80104b28:	83 ec 0c             	sub    $0xc,%esp
80104b2b:	53                   	push   %ebx
80104b2c:	e8 df cd ff ff       	call   80101910 <iunlockput>
  return ip;
80104b31:	83 c4 10             	add    $0x10,%esp
}
80104b34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b37:	89 f8                	mov    %edi,%eax
80104b39:	5b                   	pop    %ebx
80104b3a:	5e                   	pop    %esi
80104b3b:	5f                   	pop    %edi
80104b3c:	5d                   	pop    %ebp
80104b3d:	c3                   	ret    
80104b3e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104b40:	83 ec 0c             	sub    $0xc,%esp
80104b43:	57                   	push   %edi
    return 0;
80104b44:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104b46:	e8 c5 cd ff ff       	call   80101910 <iunlockput>
    return 0;
80104b4b:	83 c4 10             	add    $0x10,%esp
}
80104b4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b51:	89 f8                	mov    %edi,%eax
80104b53:	5b                   	pop    %ebx
80104b54:	5e                   	pop    %esi
80104b55:	5f                   	pop    %edi
80104b56:	5d                   	pop    %ebp
80104b57:	c3                   	ret    
80104b58:	90                   	nop
80104b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104b60:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104b65:	83 ec 0c             	sub    $0xc,%esp
80104b68:	53                   	push   %ebx
80104b69:	e8 62 ca ff ff       	call   801015d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104b6e:	83 c4 0c             	add    $0xc,%esp
80104b71:	ff 77 04             	pushl  0x4(%edi)
80104b74:	68 64 78 10 80       	push   $0x80107864
80104b79:	57                   	push   %edi
80104b7a:	e8 b1 d2 ff ff       	call   80101e30 <dirlink>
80104b7f:	83 c4 10             	add    $0x10,%esp
80104b82:	85 c0                	test   %eax,%eax
80104b84:	78 1c                	js     80104ba2 <create+0x162>
80104b86:	83 ec 04             	sub    $0x4,%esp
80104b89:	ff 73 04             	pushl  0x4(%ebx)
80104b8c:	68 63 78 10 80       	push   $0x80107863
80104b91:	57                   	push   %edi
80104b92:	e8 99 d2 ff ff       	call   80101e30 <dirlink>
80104b97:	83 c4 10             	add    $0x10,%esp
80104b9a:	85 c0                	test   %eax,%eax
80104b9c:	0f 89 6e ff ff ff    	jns    80104b10 <create+0xd0>
      panic("create dots");
80104ba2:	83 ec 0c             	sub    $0xc,%esp
80104ba5:	68 57 78 10 80       	push   $0x80107857
80104baa:	e8 e1 b7 ff ff       	call   80100390 <panic>
80104baf:	90                   	nop
    return 0;
80104bb0:	31 ff                	xor    %edi,%edi
80104bb2:	e9 fd fe ff ff       	jmp    80104ab4 <create+0x74>
    panic("create: dirlink");
80104bb7:	83 ec 0c             	sub    $0xc,%esp
80104bba:	68 66 78 10 80       	push   $0x80107866
80104bbf:	e8 cc b7 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104bc4:	83 ec 0c             	sub    $0xc,%esp
80104bc7:	68 48 78 10 80       	push   $0x80107848
80104bcc:	e8 bf b7 ff ff       	call   80100390 <panic>
80104bd1:	eb 0d                	jmp    80104be0 <argfd.constprop.0>
80104bd3:	90                   	nop
80104bd4:	90                   	nop
80104bd5:	90                   	nop
80104bd6:	90                   	nop
80104bd7:	90                   	nop
80104bd8:	90                   	nop
80104bd9:	90                   	nop
80104bda:	90                   	nop
80104bdb:	90                   	nop
80104bdc:	90                   	nop
80104bdd:	90                   	nop
80104bde:	90                   	nop
80104bdf:	90                   	nop

80104be0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	56                   	push   %esi
80104be4:	53                   	push   %ebx
80104be5:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104be7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104bea:	89 d6                	mov    %edx,%esi
80104bec:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104bef:	50                   	push   %eax
80104bf0:	6a 00                	push   $0x0
80104bf2:	e8 e9 fc ff ff       	call   801048e0 <argint>
80104bf7:	83 c4 10             	add    $0x10,%esp
80104bfa:	85 c0                	test   %eax,%eax
80104bfc:	78 32                	js     80104c30 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104bfe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104c02:	77 2c                	ja     80104c30 <argfd.constprop.0+0x50>
80104c04:	e8 17 ec ff ff       	call   80103820 <myproc>
80104c09:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c0c:	8b 84 90 8c 00 00 00 	mov    0x8c(%eax,%edx,4),%eax
80104c13:	85 c0                	test   %eax,%eax
80104c15:	74 19                	je     80104c30 <argfd.constprop.0+0x50>
  if(pfd)
80104c17:	85 db                	test   %ebx,%ebx
80104c19:	74 02                	je     80104c1d <argfd.constprop.0+0x3d>
    *pfd = fd;
80104c1b:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104c1d:	89 06                	mov    %eax,(%esi)
  return 0;
80104c1f:	31 c0                	xor    %eax,%eax
}
80104c21:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c24:	5b                   	pop    %ebx
80104c25:	5e                   	pop    %esi
80104c26:	5d                   	pop    %ebp
80104c27:	c3                   	ret    
80104c28:	90                   	nop
80104c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c35:	eb ea                	jmp    80104c21 <argfd.constprop.0+0x41>
80104c37:	89 f6                	mov    %esi,%esi
80104c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c40 <sys_dup>:
{
80104c40:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104c41:	31 c0                	xor    %eax,%eax
{
80104c43:	89 e5                	mov    %esp,%ebp
80104c45:	56                   	push   %esi
80104c46:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104c47:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104c4a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104c4d:	e8 8e ff ff ff       	call   80104be0 <argfd.constprop.0>
80104c52:	85 c0                	test   %eax,%eax
80104c54:	78 4a                	js     80104ca0 <sys_dup+0x60>
  if((fd=fdalloc(f)) < 0)
80104c56:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104c59:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104c5b:	e8 c0 eb ff ff       	call   80103820 <myproc>
80104c60:	eb 0e                	jmp    80104c70 <sys_dup+0x30>
80104c62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104c68:	83 c3 01             	add    $0x1,%ebx
80104c6b:	83 fb 10             	cmp    $0x10,%ebx
80104c6e:	74 30                	je     80104ca0 <sys_dup+0x60>
    if(curproc->ofile[fd] == 0){
80104c70:	8b 94 98 8c 00 00 00 	mov    0x8c(%eax,%ebx,4),%edx
80104c77:	85 d2                	test   %edx,%edx
80104c79:	75 ed                	jne    80104c68 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104c7b:	89 b4 98 8c 00 00 00 	mov    %esi,0x8c(%eax,%ebx,4)
  filedup(f);
80104c82:	83 ec 0c             	sub    $0xc,%esp
80104c85:	ff 75 f4             	pushl  -0xc(%ebp)
80104c88:	e8 63 c1 ff ff       	call   80100df0 <filedup>
  return fd;
80104c8d:	83 c4 10             	add    $0x10,%esp
}
80104c90:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c93:	89 d8                	mov    %ebx,%eax
80104c95:	5b                   	pop    %ebx
80104c96:	5e                   	pop    %esi
80104c97:	5d                   	pop    %ebp
80104c98:	c3                   	ret    
80104c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ca0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104ca3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104ca8:	89 d8                	mov    %ebx,%eax
80104caa:	5b                   	pop    %ebx
80104cab:	5e                   	pop    %esi
80104cac:	5d                   	pop    %ebp
80104cad:	c3                   	ret    
80104cae:	66 90                	xchg   %ax,%ax

80104cb0 <sys_read>:
{
80104cb0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104cb1:	31 c0                	xor    %eax,%eax
{
80104cb3:	89 e5                	mov    %esp,%ebp
80104cb5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104cb8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104cbb:	e8 20 ff ff ff       	call   80104be0 <argfd.constprop.0>
80104cc0:	85 c0                	test   %eax,%eax
80104cc2:	78 4c                	js     80104d10 <sys_read+0x60>
80104cc4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104cc7:	83 ec 08             	sub    $0x8,%esp
80104cca:	50                   	push   %eax
80104ccb:	6a 02                	push   $0x2
80104ccd:	e8 0e fc ff ff       	call   801048e0 <argint>
80104cd2:	83 c4 10             	add    $0x10,%esp
80104cd5:	85 c0                	test   %eax,%eax
80104cd7:	78 37                	js     80104d10 <sys_read+0x60>
80104cd9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cdc:	83 ec 04             	sub    $0x4,%esp
80104cdf:	ff 75 f0             	pushl  -0x10(%ebp)
80104ce2:	50                   	push   %eax
80104ce3:	6a 01                	push   $0x1
80104ce5:	e8 46 fc ff ff       	call   80104930 <argptr>
80104cea:	83 c4 10             	add    $0x10,%esp
80104ced:	85 c0                	test   %eax,%eax
80104cef:	78 1f                	js     80104d10 <sys_read+0x60>
  return fileread(f, p, n);
80104cf1:	83 ec 04             	sub    $0x4,%esp
80104cf4:	ff 75 f0             	pushl  -0x10(%ebp)
80104cf7:	ff 75 f4             	pushl  -0xc(%ebp)
80104cfa:	ff 75 ec             	pushl  -0x14(%ebp)
80104cfd:	e8 5e c2 ff ff       	call   80100f60 <fileread>
80104d02:	83 c4 10             	add    $0x10,%esp
}
80104d05:	c9                   	leave  
80104d06:	c3                   	ret    
80104d07:	89 f6                	mov    %esi,%esi
80104d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104d10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d15:	c9                   	leave  
80104d16:	c3                   	ret    
80104d17:	89 f6                	mov    %esi,%esi
80104d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d20 <sys_write>:
{
80104d20:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d21:	31 c0                	xor    %eax,%eax
{
80104d23:	89 e5                	mov    %esp,%ebp
80104d25:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d28:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d2b:	e8 b0 fe ff ff       	call   80104be0 <argfd.constprop.0>
80104d30:	85 c0                	test   %eax,%eax
80104d32:	78 4c                	js     80104d80 <sys_write+0x60>
80104d34:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d37:	83 ec 08             	sub    $0x8,%esp
80104d3a:	50                   	push   %eax
80104d3b:	6a 02                	push   $0x2
80104d3d:	e8 9e fb ff ff       	call   801048e0 <argint>
80104d42:	83 c4 10             	add    $0x10,%esp
80104d45:	85 c0                	test   %eax,%eax
80104d47:	78 37                	js     80104d80 <sys_write+0x60>
80104d49:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d4c:	83 ec 04             	sub    $0x4,%esp
80104d4f:	ff 75 f0             	pushl  -0x10(%ebp)
80104d52:	50                   	push   %eax
80104d53:	6a 01                	push   $0x1
80104d55:	e8 d6 fb ff ff       	call   80104930 <argptr>
80104d5a:	83 c4 10             	add    $0x10,%esp
80104d5d:	85 c0                	test   %eax,%eax
80104d5f:	78 1f                	js     80104d80 <sys_write+0x60>
  return filewrite(f, p, n);
80104d61:	83 ec 04             	sub    $0x4,%esp
80104d64:	ff 75 f0             	pushl  -0x10(%ebp)
80104d67:	ff 75 f4             	pushl  -0xc(%ebp)
80104d6a:	ff 75 ec             	pushl  -0x14(%ebp)
80104d6d:	e8 7e c2 ff ff       	call   80100ff0 <filewrite>
80104d72:	83 c4 10             	add    $0x10,%esp
}
80104d75:	c9                   	leave  
80104d76:	c3                   	ret    
80104d77:	89 f6                	mov    %esi,%esi
80104d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104d80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d85:	c9                   	leave  
80104d86:	c3                   	ret    
80104d87:	89 f6                	mov    %esi,%esi
80104d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d90 <sys_close>:
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104d96:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104d99:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d9c:	e8 3f fe ff ff       	call   80104be0 <argfd.constprop.0>
80104da1:	85 c0                	test   %eax,%eax
80104da3:	78 2b                	js     80104dd0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104da5:	e8 76 ea ff ff       	call   80103820 <myproc>
80104daa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104dad:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104db0:	c7 84 90 8c 00 00 00 	movl   $0x0,0x8c(%eax,%edx,4)
80104db7:	00 00 00 00 
  fileclose(f);
80104dbb:	ff 75 f4             	pushl  -0xc(%ebp)
80104dbe:	e8 7d c0 ff ff       	call   80100e40 <fileclose>
  return 0;
80104dc3:	83 c4 10             	add    $0x10,%esp
80104dc6:	31 c0                	xor    %eax,%eax
}
80104dc8:	c9                   	leave  
80104dc9:	c3                   	ret    
80104dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104dd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104dd5:	c9                   	leave  
80104dd6:	c3                   	ret    
80104dd7:	89 f6                	mov    %esi,%esi
80104dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104de0 <sys_fstat>:
{
80104de0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104de1:	31 c0                	xor    %eax,%eax
{
80104de3:	89 e5                	mov    %esp,%ebp
80104de5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104de8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104deb:	e8 f0 fd ff ff       	call   80104be0 <argfd.constprop.0>
80104df0:	85 c0                	test   %eax,%eax
80104df2:	78 2c                	js     80104e20 <sys_fstat+0x40>
80104df4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104df7:	83 ec 04             	sub    $0x4,%esp
80104dfa:	6a 14                	push   $0x14
80104dfc:	50                   	push   %eax
80104dfd:	6a 01                	push   $0x1
80104dff:	e8 2c fb ff ff       	call   80104930 <argptr>
80104e04:	83 c4 10             	add    $0x10,%esp
80104e07:	85 c0                	test   %eax,%eax
80104e09:	78 15                	js     80104e20 <sys_fstat+0x40>
  return filestat(f, st);
80104e0b:	83 ec 08             	sub    $0x8,%esp
80104e0e:	ff 75 f4             	pushl  -0xc(%ebp)
80104e11:	ff 75 f0             	pushl  -0x10(%ebp)
80104e14:	e8 f7 c0 ff ff       	call   80100f10 <filestat>
80104e19:	83 c4 10             	add    $0x10,%esp
}
80104e1c:	c9                   	leave  
80104e1d:	c3                   	ret    
80104e1e:	66 90                	xchg   %ax,%ax
    return -1;
80104e20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e25:	c9                   	leave  
80104e26:	c3                   	ret    
80104e27:	89 f6                	mov    %esi,%esi
80104e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e30 <sys_link>:
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	57                   	push   %edi
80104e34:	56                   	push   %esi
80104e35:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104e36:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104e39:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104e3c:	50                   	push   %eax
80104e3d:	6a 00                	push   $0x0
80104e3f:	e8 4c fb ff ff       	call   80104990 <argstr>
80104e44:	83 c4 10             	add    $0x10,%esp
80104e47:	85 c0                	test   %eax,%eax
80104e49:	0f 88 fb 00 00 00    	js     80104f4a <sys_link+0x11a>
80104e4f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104e52:	83 ec 08             	sub    $0x8,%esp
80104e55:	50                   	push   %eax
80104e56:	6a 01                	push   $0x1
80104e58:	e8 33 fb ff ff       	call   80104990 <argstr>
80104e5d:	83 c4 10             	add    $0x10,%esp
80104e60:	85 c0                	test   %eax,%eax
80104e62:	0f 88 e2 00 00 00    	js     80104f4a <sys_link+0x11a>
  begin_op();
80104e68:	e8 43 dd ff ff       	call   80102bb0 <begin_op>
  if((ip = namei(old)) == 0){
80104e6d:	83 ec 0c             	sub    $0xc,%esp
80104e70:	ff 75 d4             	pushl  -0x2c(%ebp)
80104e73:	e8 78 d0 ff ff       	call   80101ef0 <namei>
80104e78:	83 c4 10             	add    $0x10,%esp
80104e7b:	85 c0                	test   %eax,%eax
80104e7d:	89 c3                	mov    %eax,%ebx
80104e7f:	0f 84 ea 00 00 00    	je     80104f6f <sys_link+0x13f>
  ilock(ip);
80104e85:	83 ec 0c             	sub    $0xc,%esp
80104e88:	50                   	push   %eax
80104e89:	e8 f2 c7 ff ff       	call   80101680 <ilock>
  if(ip->type == T_DIR){
80104e8e:	83 c4 10             	add    $0x10,%esp
80104e91:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e96:	0f 84 bb 00 00 00    	je     80104f57 <sys_link+0x127>
  ip->nlink++;
80104e9c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104ea1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80104ea4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104ea7:	53                   	push   %ebx
80104ea8:	e8 23 c7 ff ff       	call   801015d0 <iupdate>
  iunlock(ip);
80104ead:	89 1c 24             	mov    %ebx,(%esp)
80104eb0:	e8 ab c8 ff ff       	call   80101760 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104eb5:	58                   	pop    %eax
80104eb6:	5a                   	pop    %edx
80104eb7:	57                   	push   %edi
80104eb8:	ff 75 d0             	pushl  -0x30(%ebp)
80104ebb:	e8 50 d0 ff ff       	call   80101f10 <nameiparent>
80104ec0:	83 c4 10             	add    $0x10,%esp
80104ec3:	85 c0                	test   %eax,%eax
80104ec5:	89 c6                	mov    %eax,%esi
80104ec7:	74 5b                	je     80104f24 <sys_link+0xf4>
  ilock(dp);
80104ec9:	83 ec 0c             	sub    $0xc,%esp
80104ecc:	50                   	push   %eax
80104ecd:	e8 ae c7 ff ff       	call   80101680 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104ed2:	83 c4 10             	add    $0x10,%esp
80104ed5:	8b 03                	mov    (%ebx),%eax
80104ed7:	39 06                	cmp    %eax,(%esi)
80104ed9:	75 3d                	jne    80104f18 <sys_link+0xe8>
80104edb:	83 ec 04             	sub    $0x4,%esp
80104ede:	ff 73 04             	pushl  0x4(%ebx)
80104ee1:	57                   	push   %edi
80104ee2:	56                   	push   %esi
80104ee3:	e8 48 cf ff ff       	call   80101e30 <dirlink>
80104ee8:	83 c4 10             	add    $0x10,%esp
80104eeb:	85 c0                	test   %eax,%eax
80104eed:	78 29                	js     80104f18 <sys_link+0xe8>
  iunlockput(dp);
80104eef:	83 ec 0c             	sub    $0xc,%esp
80104ef2:	56                   	push   %esi
80104ef3:	e8 18 ca ff ff       	call   80101910 <iunlockput>
  iput(ip);
80104ef8:	89 1c 24             	mov    %ebx,(%esp)
80104efb:	e8 b0 c8 ff ff       	call   801017b0 <iput>
  end_op();
80104f00:	e8 1b dd ff ff       	call   80102c20 <end_op>
  return 0;
80104f05:	83 c4 10             	add    $0x10,%esp
80104f08:	31 c0                	xor    %eax,%eax
}
80104f0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f0d:	5b                   	pop    %ebx
80104f0e:	5e                   	pop    %esi
80104f0f:	5f                   	pop    %edi
80104f10:	5d                   	pop    %ebp
80104f11:	c3                   	ret    
80104f12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104f18:	83 ec 0c             	sub    $0xc,%esp
80104f1b:	56                   	push   %esi
80104f1c:	e8 ef c9 ff ff       	call   80101910 <iunlockput>
    goto bad;
80104f21:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104f24:	83 ec 0c             	sub    $0xc,%esp
80104f27:	53                   	push   %ebx
80104f28:	e8 53 c7 ff ff       	call   80101680 <ilock>
  ip->nlink--;
80104f2d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f32:	89 1c 24             	mov    %ebx,(%esp)
80104f35:	e8 96 c6 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
80104f3a:	89 1c 24             	mov    %ebx,(%esp)
80104f3d:	e8 ce c9 ff ff       	call   80101910 <iunlockput>
  end_op();
80104f42:	e8 d9 dc ff ff       	call   80102c20 <end_op>
  return -1;
80104f47:	83 c4 10             	add    $0x10,%esp
}
80104f4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80104f4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f52:	5b                   	pop    %ebx
80104f53:	5e                   	pop    %esi
80104f54:	5f                   	pop    %edi
80104f55:	5d                   	pop    %ebp
80104f56:	c3                   	ret    
    iunlockput(ip);
80104f57:	83 ec 0c             	sub    $0xc,%esp
80104f5a:	53                   	push   %ebx
80104f5b:	e8 b0 c9 ff ff       	call   80101910 <iunlockput>
    end_op();
80104f60:	e8 bb dc ff ff       	call   80102c20 <end_op>
    return -1;
80104f65:	83 c4 10             	add    $0x10,%esp
80104f68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f6d:	eb 9b                	jmp    80104f0a <sys_link+0xda>
    end_op();
80104f6f:	e8 ac dc ff ff       	call   80102c20 <end_op>
    return -1;
80104f74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f79:	eb 8f                	jmp    80104f0a <sys_link+0xda>
80104f7b:	90                   	nop
80104f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f80 <sys_unlink>:
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	57                   	push   %edi
80104f84:	56                   	push   %esi
80104f85:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80104f86:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80104f89:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80104f8c:	50                   	push   %eax
80104f8d:	6a 00                	push   $0x0
80104f8f:	e8 fc f9 ff ff       	call   80104990 <argstr>
80104f94:	83 c4 10             	add    $0x10,%esp
80104f97:	85 c0                	test   %eax,%eax
80104f99:	0f 88 77 01 00 00    	js     80105116 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
80104f9f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80104fa2:	e8 09 dc ff ff       	call   80102bb0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104fa7:	83 ec 08             	sub    $0x8,%esp
80104faa:	53                   	push   %ebx
80104fab:	ff 75 c0             	pushl  -0x40(%ebp)
80104fae:	e8 5d cf ff ff       	call   80101f10 <nameiparent>
80104fb3:	83 c4 10             	add    $0x10,%esp
80104fb6:	85 c0                	test   %eax,%eax
80104fb8:	89 c6                	mov    %eax,%esi
80104fba:	0f 84 60 01 00 00    	je     80105120 <sys_unlink+0x1a0>
  ilock(dp);
80104fc0:	83 ec 0c             	sub    $0xc,%esp
80104fc3:	50                   	push   %eax
80104fc4:	e8 b7 c6 ff ff       	call   80101680 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104fc9:	58                   	pop    %eax
80104fca:	5a                   	pop    %edx
80104fcb:	68 64 78 10 80       	push   $0x80107864
80104fd0:	53                   	push   %ebx
80104fd1:	e8 ba cb ff ff       	call   80101b90 <namecmp>
80104fd6:	83 c4 10             	add    $0x10,%esp
80104fd9:	85 c0                	test   %eax,%eax
80104fdb:	0f 84 03 01 00 00    	je     801050e4 <sys_unlink+0x164>
80104fe1:	83 ec 08             	sub    $0x8,%esp
80104fe4:	68 63 78 10 80       	push   $0x80107863
80104fe9:	53                   	push   %ebx
80104fea:	e8 a1 cb ff ff       	call   80101b90 <namecmp>
80104fef:	83 c4 10             	add    $0x10,%esp
80104ff2:	85 c0                	test   %eax,%eax
80104ff4:	0f 84 ea 00 00 00    	je     801050e4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104ffa:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104ffd:	83 ec 04             	sub    $0x4,%esp
80105000:	50                   	push   %eax
80105001:	53                   	push   %ebx
80105002:	56                   	push   %esi
80105003:	e8 a8 cb ff ff       	call   80101bb0 <dirlookup>
80105008:	83 c4 10             	add    $0x10,%esp
8010500b:	85 c0                	test   %eax,%eax
8010500d:	89 c3                	mov    %eax,%ebx
8010500f:	0f 84 cf 00 00 00    	je     801050e4 <sys_unlink+0x164>
  ilock(ip);
80105015:	83 ec 0c             	sub    $0xc,%esp
80105018:	50                   	push   %eax
80105019:	e8 62 c6 ff ff       	call   80101680 <ilock>
  if(ip->nlink < 1)
8010501e:	83 c4 10             	add    $0x10,%esp
80105021:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105026:	0f 8e 10 01 00 00    	jle    8010513c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010502c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105031:	74 6d                	je     801050a0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105033:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105036:	83 ec 04             	sub    $0x4,%esp
80105039:	6a 10                	push   $0x10
8010503b:	6a 00                	push   $0x0
8010503d:	50                   	push   %eax
8010503e:	e8 9d f5 ff ff       	call   801045e0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105043:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105046:	6a 10                	push   $0x10
80105048:	ff 75 c4             	pushl  -0x3c(%ebp)
8010504b:	50                   	push   %eax
8010504c:	56                   	push   %esi
8010504d:	e8 0e ca ff ff       	call   80101a60 <writei>
80105052:	83 c4 20             	add    $0x20,%esp
80105055:	83 f8 10             	cmp    $0x10,%eax
80105058:	0f 85 eb 00 00 00    	jne    80105149 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010505e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105063:	0f 84 97 00 00 00    	je     80105100 <sys_unlink+0x180>
  iunlockput(dp);
80105069:	83 ec 0c             	sub    $0xc,%esp
8010506c:	56                   	push   %esi
8010506d:	e8 9e c8 ff ff       	call   80101910 <iunlockput>
  ip->nlink--;
80105072:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105077:	89 1c 24             	mov    %ebx,(%esp)
8010507a:	e8 51 c5 ff ff       	call   801015d0 <iupdate>
  iunlockput(ip);
8010507f:	89 1c 24             	mov    %ebx,(%esp)
80105082:	e8 89 c8 ff ff       	call   80101910 <iunlockput>
  end_op();
80105087:	e8 94 db ff ff       	call   80102c20 <end_op>
  return 0;
8010508c:	83 c4 10             	add    $0x10,%esp
8010508f:	31 c0                	xor    %eax,%eax
}
80105091:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105094:	5b                   	pop    %ebx
80105095:	5e                   	pop    %esi
80105096:	5f                   	pop    %edi
80105097:	5d                   	pop    %ebp
80105098:	c3                   	ret    
80105099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801050a0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801050a4:	76 8d                	jbe    80105033 <sys_unlink+0xb3>
801050a6:	bf 20 00 00 00       	mov    $0x20,%edi
801050ab:	eb 0f                	jmp    801050bc <sys_unlink+0x13c>
801050ad:	8d 76 00             	lea    0x0(%esi),%esi
801050b0:	83 c7 10             	add    $0x10,%edi
801050b3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801050b6:	0f 83 77 ff ff ff    	jae    80105033 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801050bc:	8d 45 d8             	lea    -0x28(%ebp),%eax
801050bf:	6a 10                	push   $0x10
801050c1:	57                   	push   %edi
801050c2:	50                   	push   %eax
801050c3:	53                   	push   %ebx
801050c4:	e8 97 c8 ff ff       	call   80101960 <readi>
801050c9:	83 c4 10             	add    $0x10,%esp
801050cc:	83 f8 10             	cmp    $0x10,%eax
801050cf:	75 5e                	jne    8010512f <sys_unlink+0x1af>
    if(de.inum != 0)
801050d1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801050d6:	74 d8                	je     801050b0 <sys_unlink+0x130>
    iunlockput(ip);
801050d8:	83 ec 0c             	sub    $0xc,%esp
801050db:	53                   	push   %ebx
801050dc:	e8 2f c8 ff ff       	call   80101910 <iunlockput>
    goto bad;
801050e1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801050e4:	83 ec 0c             	sub    $0xc,%esp
801050e7:	56                   	push   %esi
801050e8:	e8 23 c8 ff ff       	call   80101910 <iunlockput>
  end_op();
801050ed:	e8 2e db ff ff       	call   80102c20 <end_op>
  return -1;
801050f2:	83 c4 10             	add    $0x10,%esp
801050f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050fa:	eb 95                	jmp    80105091 <sys_unlink+0x111>
801050fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105100:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105105:	83 ec 0c             	sub    $0xc,%esp
80105108:	56                   	push   %esi
80105109:	e8 c2 c4 ff ff       	call   801015d0 <iupdate>
8010510e:	83 c4 10             	add    $0x10,%esp
80105111:	e9 53 ff ff ff       	jmp    80105069 <sys_unlink+0xe9>
    return -1;
80105116:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010511b:	e9 71 ff ff ff       	jmp    80105091 <sys_unlink+0x111>
    end_op();
80105120:	e8 fb da ff ff       	call   80102c20 <end_op>
    return -1;
80105125:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010512a:	e9 62 ff ff ff       	jmp    80105091 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010512f:	83 ec 0c             	sub    $0xc,%esp
80105132:	68 88 78 10 80       	push   $0x80107888
80105137:	e8 54 b2 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010513c:	83 ec 0c             	sub    $0xc,%esp
8010513f:	68 76 78 10 80       	push   $0x80107876
80105144:	e8 47 b2 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105149:	83 ec 0c             	sub    $0xc,%esp
8010514c:	68 9a 78 10 80       	push   $0x8010789a
80105151:	e8 3a b2 ff ff       	call   80100390 <panic>
80105156:	8d 76 00             	lea    0x0(%esi),%esi
80105159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105160 <sys_open>:

int
sys_open(void)
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	57                   	push   %edi
80105164:	56                   	push   %esi
80105165:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105166:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105169:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010516c:	50                   	push   %eax
8010516d:	6a 00                	push   $0x0
8010516f:	e8 1c f8 ff ff       	call   80104990 <argstr>
80105174:	83 c4 10             	add    $0x10,%esp
80105177:	85 c0                	test   %eax,%eax
80105179:	0f 88 1d 01 00 00    	js     8010529c <sys_open+0x13c>
8010517f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105182:	83 ec 08             	sub    $0x8,%esp
80105185:	50                   	push   %eax
80105186:	6a 01                	push   $0x1
80105188:	e8 53 f7 ff ff       	call   801048e0 <argint>
8010518d:	83 c4 10             	add    $0x10,%esp
80105190:	85 c0                	test   %eax,%eax
80105192:	0f 88 04 01 00 00    	js     8010529c <sys_open+0x13c>
    return -1;

  begin_op();
80105198:	e8 13 da ff ff       	call   80102bb0 <begin_op>

  if(omode & O_CREATE){
8010519d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801051a1:	0f 85 a9 00 00 00    	jne    80105250 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801051a7:	83 ec 0c             	sub    $0xc,%esp
801051aa:	ff 75 e0             	pushl  -0x20(%ebp)
801051ad:	e8 3e cd ff ff       	call   80101ef0 <namei>
801051b2:	83 c4 10             	add    $0x10,%esp
801051b5:	85 c0                	test   %eax,%eax
801051b7:	89 c6                	mov    %eax,%esi
801051b9:	0f 84 b2 00 00 00    	je     80105271 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801051bf:	83 ec 0c             	sub    $0xc,%esp
801051c2:	50                   	push   %eax
801051c3:	e8 b8 c4 ff ff       	call   80101680 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801051c8:	83 c4 10             	add    $0x10,%esp
801051cb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801051d0:	0f 84 aa 00 00 00    	je     80105280 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801051d6:	e8 a5 bb ff ff       	call   80100d80 <filealloc>
801051db:	85 c0                	test   %eax,%eax
801051dd:	89 c7                	mov    %eax,%edi
801051df:	0f 84 a6 00 00 00    	je     8010528b <sys_open+0x12b>
  struct proc *curproc = myproc();
801051e5:	e8 36 e6 ff ff       	call   80103820 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801051ea:	31 db                	xor    %ebx,%ebx
801051ec:	eb 0e                	jmp    801051fc <sys_open+0x9c>
801051ee:	66 90                	xchg   %ax,%ax
801051f0:	83 c3 01             	add    $0x1,%ebx
801051f3:	83 fb 10             	cmp    $0x10,%ebx
801051f6:	0f 84 ac 00 00 00    	je     801052a8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801051fc:	8b 94 98 8c 00 00 00 	mov    0x8c(%eax,%ebx,4),%edx
80105203:	85 d2                	test   %edx,%edx
80105205:	75 e9                	jne    801051f0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105207:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010520a:	89 bc 98 8c 00 00 00 	mov    %edi,0x8c(%eax,%ebx,4)
  iunlock(ip);
80105211:	56                   	push   %esi
80105212:	e8 49 c5 ff ff       	call   80101760 <iunlock>
  end_op();
80105217:	e8 04 da ff ff       	call   80102c20 <end_op>

  f->type = FD_INODE;
8010521c:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105222:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105225:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105228:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
8010522b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105232:	89 d0                	mov    %edx,%eax
80105234:	f7 d0                	not    %eax
80105236:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105239:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010523c:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010523f:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105243:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105246:	89 d8                	mov    %ebx,%eax
80105248:	5b                   	pop    %ebx
80105249:	5e                   	pop    %esi
8010524a:	5f                   	pop    %edi
8010524b:	5d                   	pop    %ebp
8010524c:	c3                   	ret    
8010524d:	8d 76 00             	lea    0x0(%esi),%esi
    ip = create(path, T_FILE, 0, 0);
80105250:	83 ec 0c             	sub    $0xc,%esp
80105253:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105256:	31 c9                	xor    %ecx,%ecx
80105258:	6a 00                	push   $0x0
8010525a:	ba 02 00 00 00       	mov    $0x2,%edx
8010525f:	e8 dc f7 ff ff       	call   80104a40 <create>
    if(ip == 0){
80105264:	83 c4 10             	add    $0x10,%esp
80105267:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105269:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010526b:	0f 85 65 ff ff ff    	jne    801051d6 <sys_open+0x76>
      end_op();
80105271:	e8 aa d9 ff ff       	call   80102c20 <end_op>
      return -1;
80105276:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010527b:	eb c6                	jmp    80105243 <sys_open+0xe3>
8010527d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105280:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105283:	85 c9                	test   %ecx,%ecx
80105285:	0f 84 4b ff ff ff    	je     801051d6 <sys_open+0x76>
    iunlockput(ip);
8010528b:	83 ec 0c             	sub    $0xc,%esp
8010528e:	56                   	push   %esi
8010528f:	e8 7c c6 ff ff       	call   80101910 <iunlockput>
    end_op();
80105294:	e8 87 d9 ff ff       	call   80102c20 <end_op>
    return -1;
80105299:	83 c4 10             	add    $0x10,%esp
8010529c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801052a1:	eb a0                	jmp    80105243 <sys_open+0xe3>
801052a3:	90                   	nop
801052a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801052a8:	83 ec 0c             	sub    $0xc,%esp
801052ab:	57                   	push   %edi
801052ac:	e8 8f bb ff ff       	call   80100e40 <fileclose>
801052b1:	83 c4 10             	add    $0x10,%esp
801052b4:	eb d5                	jmp    8010528b <sys_open+0x12b>
801052b6:	8d 76 00             	lea    0x0(%esi),%esi
801052b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052c0 <sys_mkdir>:

int
sys_mkdir(void)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801052c6:	e8 e5 d8 ff ff       	call   80102bb0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801052cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052ce:	83 ec 08             	sub    $0x8,%esp
801052d1:	50                   	push   %eax
801052d2:	6a 00                	push   $0x0
801052d4:	e8 b7 f6 ff ff       	call   80104990 <argstr>
801052d9:	83 c4 10             	add    $0x10,%esp
801052dc:	85 c0                	test   %eax,%eax
801052de:	78 30                	js     80105310 <sys_mkdir+0x50>
801052e0:	83 ec 0c             	sub    $0xc,%esp
801052e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052e6:	31 c9                	xor    %ecx,%ecx
801052e8:	6a 00                	push   $0x0
801052ea:	ba 01 00 00 00       	mov    $0x1,%edx
801052ef:	e8 4c f7 ff ff       	call   80104a40 <create>
801052f4:	83 c4 10             	add    $0x10,%esp
801052f7:	85 c0                	test   %eax,%eax
801052f9:	74 15                	je     80105310 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801052fb:	83 ec 0c             	sub    $0xc,%esp
801052fe:	50                   	push   %eax
801052ff:	e8 0c c6 ff ff       	call   80101910 <iunlockput>
  end_op();
80105304:	e8 17 d9 ff ff       	call   80102c20 <end_op>
  return 0;
80105309:	83 c4 10             	add    $0x10,%esp
8010530c:	31 c0                	xor    %eax,%eax
}
8010530e:	c9                   	leave  
8010530f:	c3                   	ret    
    end_op();
80105310:	e8 0b d9 ff ff       	call   80102c20 <end_op>
    return -1;
80105315:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010531a:	c9                   	leave  
8010531b:	c3                   	ret    
8010531c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105320 <sys_mknod>:

int
sys_mknod(void)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105326:	e8 85 d8 ff ff       	call   80102bb0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010532b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010532e:	83 ec 08             	sub    $0x8,%esp
80105331:	50                   	push   %eax
80105332:	6a 00                	push   $0x0
80105334:	e8 57 f6 ff ff       	call   80104990 <argstr>
80105339:	83 c4 10             	add    $0x10,%esp
8010533c:	85 c0                	test   %eax,%eax
8010533e:	78 60                	js     801053a0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105340:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105343:	83 ec 08             	sub    $0x8,%esp
80105346:	50                   	push   %eax
80105347:	6a 01                	push   $0x1
80105349:	e8 92 f5 ff ff       	call   801048e0 <argint>
  if((argstr(0, &path)) < 0 ||
8010534e:	83 c4 10             	add    $0x10,%esp
80105351:	85 c0                	test   %eax,%eax
80105353:	78 4b                	js     801053a0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105355:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105358:	83 ec 08             	sub    $0x8,%esp
8010535b:	50                   	push   %eax
8010535c:	6a 02                	push   $0x2
8010535e:	e8 7d f5 ff ff       	call   801048e0 <argint>
     argint(1, &major) < 0 ||
80105363:	83 c4 10             	add    $0x10,%esp
80105366:	85 c0                	test   %eax,%eax
80105368:	78 36                	js     801053a0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010536a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010536e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105371:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105375:	ba 03 00 00 00       	mov    $0x3,%edx
8010537a:	50                   	push   %eax
8010537b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010537e:	e8 bd f6 ff ff       	call   80104a40 <create>
80105383:	83 c4 10             	add    $0x10,%esp
80105386:	85 c0                	test   %eax,%eax
80105388:	74 16                	je     801053a0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010538a:	83 ec 0c             	sub    $0xc,%esp
8010538d:	50                   	push   %eax
8010538e:	e8 7d c5 ff ff       	call   80101910 <iunlockput>
  end_op();
80105393:	e8 88 d8 ff ff       	call   80102c20 <end_op>
  return 0;
80105398:	83 c4 10             	add    $0x10,%esp
8010539b:	31 c0                	xor    %eax,%eax
}
8010539d:	c9                   	leave  
8010539e:	c3                   	ret    
8010539f:	90                   	nop
    end_op();
801053a0:	e8 7b d8 ff ff       	call   80102c20 <end_op>
    return -1;
801053a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053aa:	c9                   	leave  
801053ab:	c3                   	ret    
801053ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053b0 <sys_chdir>:

int
sys_chdir(void)
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
801053b3:	56                   	push   %esi
801053b4:	53                   	push   %ebx
801053b5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801053b8:	e8 63 e4 ff ff       	call   80103820 <myproc>
801053bd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801053bf:	e8 ec d7 ff ff       	call   80102bb0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801053c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053c7:	83 ec 08             	sub    $0x8,%esp
801053ca:	50                   	push   %eax
801053cb:	6a 00                	push   $0x0
801053cd:	e8 be f5 ff ff       	call   80104990 <argstr>
801053d2:	83 c4 10             	add    $0x10,%esp
801053d5:	85 c0                	test   %eax,%eax
801053d7:	78 77                	js     80105450 <sys_chdir+0xa0>
801053d9:	83 ec 0c             	sub    $0xc,%esp
801053dc:	ff 75 f4             	pushl  -0xc(%ebp)
801053df:	e8 0c cb ff ff       	call   80101ef0 <namei>
801053e4:	83 c4 10             	add    $0x10,%esp
801053e7:	85 c0                	test   %eax,%eax
801053e9:	89 c3                	mov    %eax,%ebx
801053eb:	74 63                	je     80105450 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801053ed:	83 ec 0c             	sub    $0xc,%esp
801053f0:	50                   	push   %eax
801053f1:	e8 8a c2 ff ff       	call   80101680 <ilock>
  if(ip->type != T_DIR){
801053f6:	83 c4 10             	add    $0x10,%esp
801053f9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053fe:	75 30                	jne    80105430 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105400:	83 ec 0c             	sub    $0xc,%esp
80105403:	53                   	push   %ebx
80105404:	e8 57 c3 ff ff       	call   80101760 <iunlock>
  iput(curproc->cwd);
80105409:	58                   	pop    %eax
8010540a:	ff b6 cc 00 00 00    	pushl  0xcc(%esi)
80105410:	e8 9b c3 ff ff       	call   801017b0 <iput>
  end_op();
80105415:	e8 06 d8 ff ff       	call   80102c20 <end_op>
  curproc->cwd = ip;
8010541a:	89 9e cc 00 00 00    	mov    %ebx,0xcc(%esi)
  return 0;
80105420:	83 c4 10             	add    $0x10,%esp
80105423:	31 c0                	xor    %eax,%eax
}
80105425:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105428:	5b                   	pop    %ebx
80105429:	5e                   	pop    %esi
8010542a:	5d                   	pop    %ebp
8010542b:	c3                   	ret    
8010542c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80105430:	83 ec 0c             	sub    $0xc,%esp
80105433:	53                   	push   %ebx
80105434:	e8 d7 c4 ff ff       	call   80101910 <iunlockput>
    end_op();
80105439:	e8 e2 d7 ff ff       	call   80102c20 <end_op>
    return -1;
8010543e:	83 c4 10             	add    $0x10,%esp
80105441:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105446:	eb dd                	jmp    80105425 <sys_chdir+0x75>
80105448:	90                   	nop
80105449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105450:	e8 cb d7 ff ff       	call   80102c20 <end_op>
    return -1;
80105455:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010545a:	eb c9                	jmp    80105425 <sys_chdir+0x75>
8010545c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105460 <sys_exec>:

int
sys_exec(void)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	57                   	push   %edi
80105464:	56                   	push   %esi
80105465:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105466:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010546c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105472:	50                   	push   %eax
80105473:	6a 00                	push   $0x0
80105475:	e8 16 f5 ff ff       	call   80104990 <argstr>
8010547a:	83 c4 10             	add    $0x10,%esp
8010547d:	85 c0                	test   %eax,%eax
8010547f:	0f 88 87 00 00 00    	js     8010550c <sys_exec+0xac>
80105485:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010548b:	83 ec 08             	sub    $0x8,%esp
8010548e:	50                   	push   %eax
8010548f:	6a 01                	push   $0x1
80105491:	e8 4a f4 ff ff       	call   801048e0 <argint>
80105496:	83 c4 10             	add    $0x10,%esp
80105499:	85 c0                	test   %eax,%eax
8010549b:	78 6f                	js     8010550c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010549d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801054a3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801054a6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801054a8:	68 80 00 00 00       	push   $0x80
801054ad:	6a 00                	push   $0x0
801054af:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801054b5:	50                   	push   %eax
801054b6:	e8 25 f1 ff ff       	call   801045e0 <memset>
801054bb:	83 c4 10             	add    $0x10,%esp
801054be:	eb 2c                	jmp    801054ec <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801054c0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801054c6:	85 c0                	test   %eax,%eax
801054c8:	74 56                	je     80105520 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801054ca:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801054d0:	83 ec 08             	sub    $0x8,%esp
801054d3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801054d6:	52                   	push   %edx
801054d7:	50                   	push   %eax
801054d8:	e8 93 f3 ff ff       	call   80104870 <fetchstr>
801054dd:	83 c4 10             	add    $0x10,%esp
801054e0:	85 c0                	test   %eax,%eax
801054e2:	78 28                	js     8010550c <sys_exec+0xac>
  for(i=0;; i++){
801054e4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801054e7:	83 fb 20             	cmp    $0x20,%ebx
801054ea:	74 20                	je     8010550c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801054ec:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801054f2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801054f9:	83 ec 08             	sub    $0x8,%esp
801054fc:	57                   	push   %edi
801054fd:	01 f0                	add    %esi,%eax
801054ff:	50                   	push   %eax
80105500:	e8 2b f3 ff ff       	call   80104830 <fetchint>
80105505:	83 c4 10             	add    $0x10,%esp
80105508:	85 c0                	test   %eax,%eax
8010550a:	79 b4                	jns    801054c0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010550c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010550f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105514:	5b                   	pop    %ebx
80105515:	5e                   	pop    %esi
80105516:	5f                   	pop    %edi
80105517:	5d                   	pop    %ebp
80105518:	c3                   	ret    
80105519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105520:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105526:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105529:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105530:	00 00 00 00 
  return exec(path, argv);
80105534:	50                   	push   %eax
80105535:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010553b:	e8 d0 b4 ff ff       	call   80100a10 <exec>
80105540:	83 c4 10             	add    $0x10,%esp
}
80105543:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105546:	5b                   	pop    %ebx
80105547:	5e                   	pop    %esi
80105548:	5f                   	pop    %edi
80105549:	5d                   	pop    %ebp
8010554a:	c3                   	ret    
8010554b:	90                   	nop
8010554c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105550 <sys_pipe>:

int
sys_pipe(void)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	57                   	push   %edi
80105554:	56                   	push   %esi
80105555:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105556:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105559:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010555c:	6a 08                	push   $0x8
8010555e:	50                   	push   %eax
8010555f:	6a 00                	push   $0x0
80105561:	e8 ca f3 ff ff       	call   80104930 <argptr>
80105566:	83 c4 10             	add    $0x10,%esp
80105569:	85 c0                	test   %eax,%eax
8010556b:	0f 88 b6 00 00 00    	js     80105627 <sys_pipe+0xd7>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105571:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105574:	83 ec 08             	sub    $0x8,%esp
80105577:	50                   	push   %eax
80105578:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010557b:	50                   	push   %eax
8010557c:	e8 cf dc ff ff       	call   80103250 <pipealloc>
80105581:	83 c4 10             	add    $0x10,%esp
80105584:	85 c0                	test   %eax,%eax
80105586:	0f 88 9b 00 00 00    	js     80105627 <sys_pipe+0xd7>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010558c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010558f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105591:	e8 8a e2 ff ff       	call   80103820 <myproc>
80105596:	eb 10                	jmp    801055a8 <sys_pipe+0x58>
80105598:	90                   	nop
80105599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801055a0:	83 c3 01             	add    $0x1,%ebx
801055a3:	83 fb 10             	cmp    $0x10,%ebx
801055a6:	74 68                	je     80105610 <sys_pipe+0xc0>
    if(curproc->ofile[fd] == 0){
801055a8:	8b b4 98 8c 00 00 00 	mov    0x8c(%eax,%ebx,4),%esi
801055af:	85 f6                	test   %esi,%esi
801055b1:	75 ed                	jne    801055a0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801055b3:	8d 73 20             	lea    0x20(%ebx),%esi
801055b6:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801055ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801055bd:	e8 5e e2 ff ff       	call   80103820 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801055c2:	31 d2                	xor    %edx,%edx
801055c4:	eb 12                	jmp    801055d8 <sys_pipe+0x88>
801055c6:	8d 76 00             	lea    0x0(%esi),%esi
801055c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801055d0:	83 c2 01             	add    $0x1,%edx
801055d3:	83 fa 10             	cmp    $0x10,%edx
801055d6:	74 28                	je     80105600 <sys_pipe+0xb0>
    if(curproc->ofile[fd] == 0){
801055d8:	8b 8c 90 8c 00 00 00 	mov    0x8c(%eax,%edx,4),%ecx
801055df:	85 c9                	test   %ecx,%ecx
801055e1:	75 ed                	jne    801055d0 <sys_pipe+0x80>
      curproc->ofile[fd] = f;
801055e3:	89 bc 90 8c 00 00 00 	mov    %edi,0x8c(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801055ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
801055ed:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801055ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
801055f2:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801055f5:	31 c0                	xor    %eax,%eax
}
801055f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055fa:	5b                   	pop    %ebx
801055fb:	5e                   	pop    %esi
801055fc:	5f                   	pop    %edi
801055fd:	5d                   	pop    %ebp
801055fe:	c3                   	ret    
801055ff:	90                   	nop
      myproc()->ofile[fd0] = 0;
80105600:	e8 1b e2 ff ff       	call   80103820 <myproc>
80105605:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
8010560c:	00 
8010560d:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105610:	83 ec 0c             	sub    $0xc,%esp
80105613:	ff 75 e0             	pushl  -0x20(%ebp)
80105616:	e8 25 b8 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
8010561b:	58                   	pop    %eax
8010561c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010561f:	e8 1c b8 ff ff       	call   80100e40 <fileclose>
    return -1;
80105624:	83 c4 10             	add    $0x10,%esp
80105627:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010562c:	eb c9                	jmp    801055f7 <sys_pipe+0xa7>
8010562e:	66 90                	xchg   %ax,%ax

80105630 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105633:	5d                   	pop    %ebp
  return fork();
80105634:	e9 97 e3 ff ff       	jmp    801039d0 <fork>
80105639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105640 <sys_exit>:

int
sys_exit(void)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	83 ec 08             	sub    $0x8,%esp
  exit();
80105646:	e8 15 e6 ff ff       	call   80103c60 <exit>
  return 0;  // not reached
}
8010564b:	31 c0                	xor    %eax,%eax
8010564d:	c9                   	leave  
8010564e:	c3                   	ret    
8010564f:	90                   	nop

80105650 <sys_wait>:

int
sys_wait(void)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105653:	5d                   	pop    %ebp
  return wait();
80105654:	e9 87 e8 ff ff       	jmp    80103ee0 <wait>
80105659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105660 <sys_kill>:

int
sys_kill(void)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105666:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105669:	50                   	push   %eax
8010566a:	6a 00                	push   $0x0
8010566c:	e8 6f f2 ff ff       	call   801048e0 <argint>
80105671:	83 c4 10             	add    $0x10,%esp
80105674:	85 c0                	test   %eax,%eax
80105676:	78 18                	js     80105690 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105678:	83 ec 0c             	sub    $0xc,%esp
8010567b:	ff 75 f4             	pushl  -0xc(%ebp)
8010567e:	e8 bd e9 ff ff       	call   80104040 <kill>
80105683:	83 c4 10             	add    $0x10,%esp
}
80105686:	c9                   	leave  
80105687:	c3                   	ret    
80105688:	90                   	nop
80105689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105690:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105695:	c9                   	leave  
80105696:	c3                   	ret    
80105697:	89 f6                	mov    %esi,%esi
80105699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056a0 <sys_getpid>:

int
sys_getpid(void)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801056a6:	e8 75 e1 ff ff       	call   80103820 <myproc>
801056ab:	8b 40 74             	mov    0x74(%eax),%eax
}
801056ae:	c9                   	leave  
801056af:	c3                   	ret    

801056b0 <sys_sbrk>:

int
sys_sbrk(void)
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801056b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801056b7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801056ba:	50                   	push   %eax
801056bb:	6a 00                	push   $0x0
801056bd:	e8 1e f2 ff ff       	call   801048e0 <argint>
801056c2:	83 c4 10             	add    $0x10,%esp
801056c5:	85 c0                	test   %eax,%eax
801056c7:	78 27                	js     801056f0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801056c9:	e8 52 e1 ff ff       	call   80103820 <myproc>
  if(growproc(n) < 0)
801056ce:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801056d1:	8b 58 64             	mov    0x64(%eax),%ebx
  if(growproc(n) < 0)
801056d4:	ff 75 f4             	pushl  -0xc(%ebp)
801056d7:	e8 74 e2 ff ff       	call   80103950 <growproc>
801056dc:	83 c4 10             	add    $0x10,%esp
801056df:	85 c0                	test   %eax,%eax
801056e1:	78 0d                	js     801056f0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801056e3:	89 d8                	mov    %ebx,%eax
801056e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056e8:	c9                   	leave  
801056e9:	c3                   	ret    
801056ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801056f0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801056f5:	eb ec                	jmp    801056e3 <sys_sbrk+0x33>
801056f7:	89 f6                	mov    %esi,%esi
801056f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105700 <sys_sleep>:

int
sys_sleep(void)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105704:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105707:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010570a:	50                   	push   %eax
8010570b:	6a 00                	push   $0x0
8010570d:	e8 ce f1 ff ff       	call   801048e0 <argint>
80105712:	83 c4 10             	add    $0x10,%esp
80105715:	85 c0                	test   %eax,%eax
80105717:	0f 88 8a 00 00 00    	js     801057a7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010571d:	83 ec 0c             	sub    $0xc,%esp
80105720:	68 60 65 11 80       	push   $0x80116560
80105725:	e8 a6 ed ff ff       	call   801044d0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010572a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010572d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105730:	8b 1d a0 6d 11 80    	mov    0x80116da0,%ebx
  while(ticks - ticks0 < n){
80105736:	85 d2                	test   %edx,%edx
80105738:	75 27                	jne    80105761 <sys_sleep+0x61>
8010573a:	eb 54                	jmp    80105790 <sys_sleep+0x90>
8010573c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105740:	83 ec 08             	sub    $0x8,%esp
80105743:	68 60 65 11 80       	push   $0x80116560
80105748:	68 a0 6d 11 80       	push   $0x80116da0
8010574d:	e8 be e6 ff ff       	call   80103e10 <sleep>
  while(ticks - ticks0 < n){
80105752:	a1 a0 6d 11 80       	mov    0x80116da0,%eax
80105757:	83 c4 10             	add    $0x10,%esp
8010575a:	29 d8                	sub    %ebx,%eax
8010575c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010575f:	73 2f                	jae    80105790 <sys_sleep+0x90>
    if(myproc()->killed){
80105761:	e8 ba e0 ff ff       	call   80103820 <myproc>
80105766:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
8010576c:	85 c0                	test   %eax,%eax
8010576e:	74 d0                	je     80105740 <sys_sleep+0x40>
      release(&tickslock);
80105770:	83 ec 0c             	sub    $0xc,%esp
80105773:	68 60 65 11 80       	push   $0x80116560
80105778:	e8 13 ee ff ff       	call   80104590 <release>
      return -1;
8010577d:	83 c4 10             	add    $0x10,%esp
80105780:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105785:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105788:	c9                   	leave  
80105789:	c3                   	ret    
8010578a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&tickslock);
80105790:	83 ec 0c             	sub    $0xc,%esp
80105793:	68 60 65 11 80       	push   $0x80116560
80105798:	e8 f3 ed ff ff       	call   80104590 <release>
  return 0;
8010579d:	83 c4 10             	add    $0x10,%esp
801057a0:	31 c0                	xor    %eax,%eax
}
801057a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057a5:	c9                   	leave  
801057a6:	c3                   	ret    
    return -1;
801057a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ac:	eb f4                	jmp    801057a2 <sys_sleep+0xa2>
801057ae:	66 90                	xchg   %ax,%ax

801057b0 <sys_getyear>:
int 
sys_getyear(void)
{
801057b0:	55                   	push   %ebp
    return 2010;
}
801057b1:	b8 da 07 00 00       	mov    $0x7da,%eax
{
801057b6:	89 e5                	mov    %esp,%ebp
}
801057b8:	5d                   	pop    %ebp
801057b9:	c3                   	ret    
801057ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801057c0 <sys_getppid>:
int sys_getppid(void){
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	83 ec 08             	sub    $0x8,%esp
  	return myproc() -> parent ->pid;
801057c6:	e8 55 e0 ff ff       	call   80103820 <myproc>
801057cb:	8b 40 78             	mov    0x78(%eax),%eax
801057ce:	8b 40 74             	mov    0x74(%eax),%eax
}
801057d1:	c9                   	leave  
801057d2:	c3                   	ret    
801057d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801057d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057e0 <sys_getchildren>:
int sys_getchildren(void){
801057e0:	55                   	push   %ebp
801057e1:	89 e5                	mov    %esp,%ebp
   return getchildren();
}
801057e3:	5d                   	pop    %ebp
   return getchildren();
801057e4:	e9 e7 e9 ff ff       	jmp    801041d0 <getchildren>
801057e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801057f0 <sys_getcount>:
int sys_getcount(void){
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	83 ec 20             	sub    $0x20,%esp
    int pid;
    argint(0, &pid);
801057f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057f9:	50                   	push   %eax
801057fa:	6a 00                	push   $0x0
801057fc:	e8 df f0 ff ff       	call   801048e0 <argint>
    return getcount(pid);
80105801:	58                   	pop    %eax
80105802:	ff 75 f4             	pushl  -0xc(%ebp)
80105805:	e8 26 ea ff ff       	call   80104230 <getcount>
}
8010580a:	c9                   	leave  
8010580b:	c3                   	ret    
8010580c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105810 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	53                   	push   %ebx
80105814:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105817:	68 60 65 11 80       	push   $0x80116560
8010581c:	e8 af ec ff ff       	call   801044d0 <acquire>
  xticks = ticks;
80105821:	8b 1d a0 6d 11 80    	mov    0x80116da0,%ebx
  release(&tickslock);
80105827:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
8010582e:	e8 5d ed ff ff       	call   80104590 <release>
  return xticks;
}
80105833:	89 d8                	mov    %ebx,%eax
80105835:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105838:	c9                   	leave  
80105839:	c3                   	ret    

8010583a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010583a:	1e                   	push   %ds
  pushl %es
8010583b:	06                   	push   %es
  pushl %fs
8010583c:	0f a0                	push   %fs
  pushl %gs
8010583e:	0f a8                	push   %gs
  pushal
80105840:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105841:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105845:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105847:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105849:	54                   	push   %esp
  call trap
8010584a:	e8 c1 00 00 00       	call   80105910 <trap>
  addl $4, %esp
8010584f:	83 c4 04             	add    $0x4,%esp

80105852 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105852:	61                   	popa   
  popl %gs
80105853:	0f a9                	pop    %gs
  popl %fs
80105855:	0f a1                	pop    %fs
  popl %es
80105857:	07                   	pop    %es
  popl %ds
80105858:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105859:	83 c4 08             	add    $0x8,%esp
  iret
8010585c:	cf                   	iret   
8010585d:	66 90                	xchg   %ax,%ax
8010585f:	90                   	nop

80105860 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105860:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105861:	31 c0                	xor    %eax,%eax
{
80105863:	89 e5                	mov    %esp,%ebp
80105865:	83 ec 08             	sub    $0x8,%esp
80105868:	90                   	nop
80105869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105870:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105877:	c7 04 c5 a2 65 11 80 	movl   $0x8e000008,-0x7fee9a5e(,%eax,8)
8010587e:	08 00 00 8e 
80105882:	66 89 14 c5 a0 65 11 	mov    %dx,-0x7fee9a60(,%eax,8)
80105889:	80 
8010588a:	c1 ea 10             	shr    $0x10,%edx
8010588d:	66 89 14 c5 a6 65 11 	mov    %dx,-0x7fee9a5a(,%eax,8)
80105894:	80 
  for(i = 0; i < 256; i++)
80105895:	83 c0 01             	add    $0x1,%eax
80105898:	3d 00 01 00 00       	cmp    $0x100,%eax
8010589d:	75 d1                	jne    80105870 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010589f:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
801058a4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801058a7:	c7 05 a2 67 11 80 08 	movl   $0xef000008,0x801167a2
801058ae:	00 00 ef 
  initlock(&tickslock, "time");
801058b1:	68 a9 78 10 80       	push   $0x801078a9
801058b6:	68 60 65 11 80       	push   $0x80116560
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801058bb:	66 a3 a0 67 11 80    	mov    %ax,0x801167a0
801058c1:	c1 e8 10             	shr    $0x10,%eax
801058c4:	66 a3 a6 67 11 80    	mov    %ax,0x801167a6
  initlock(&tickslock, "time");
801058ca:	e8 c1 ea ff ff       	call   80104390 <initlock>
}
801058cf:	83 c4 10             	add    $0x10,%esp
801058d2:	c9                   	leave  
801058d3:	c3                   	ret    
801058d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801058da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801058e0 <idtinit>:

void
idtinit(void)
{
801058e0:	55                   	push   %ebp
  pd[0] = size-1;
801058e1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801058e6:	89 e5                	mov    %esp,%ebp
801058e8:	83 ec 10             	sub    $0x10,%esp
801058eb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801058ef:	b8 a0 65 11 80       	mov    $0x801165a0,%eax
801058f4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801058f8:	c1 e8 10             	shr    $0x10,%eax
801058fb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801058ff:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105902:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105905:	c9                   	leave  
80105906:	c3                   	ret    
80105907:	89 f6                	mov    %esi,%esi
80105909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105910 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	57                   	push   %edi
80105914:	56                   	push   %esi
80105915:	53                   	push   %ebx
80105916:	83 ec 1c             	sub    $0x1c,%esp
80105919:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010591c:	8b 47 30             	mov    0x30(%edi),%eax
8010591f:	83 f8 40             	cmp    $0x40,%eax
80105922:	0f 84 f8 00 00 00    	je     80105a20 <trap+0x110>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105928:	83 e8 20             	sub    $0x20,%eax
8010592b:	83 f8 1f             	cmp    $0x1f,%eax
8010592e:	77 10                	ja     80105940 <trap+0x30>
80105930:	ff 24 85 50 79 10 80 	jmp    *-0x7fef86b0(,%eax,4)
80105937:	89 f6                	mov    %esi,%esi
80105939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105940:	e8 db de ff ff       	call   80103820 <myproc>
80105945:	85 c0                	test   %eax,%eax
80105947:	8b 5f 38             	mov    0x38(%edi),%ebx
8010594a:	0f 84 44 02 00 00    	je     80105b94 <trap+0x284>
80105950:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105954:	0f 84 3a 02 00 00    	je     80105b94 <trap+0x284>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010595a:	0f 20 d1             	mov    %cr2,%ecx
8010595d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105960:	e8 9b de ff ff       	call   80103800 <cpuid>
80105965:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105968:	8b 47 34             	mov    0x34(%edi),%eax
8010596b:	8b 77 30             	mov    0x30(%edi),%esi
8010596e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105971:	e8 aa de ff ff       	call   80103820 <myproc>
80105976:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105979:	e8 a2 de ff ff       	call   80103820 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010597e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105981:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105984:	51                   	push   %ecx
80105985:	53                   	push   %ebx
80105986:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105987:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010598a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010598d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010598e:	81 c2 d0 00 00 00    	add    $0xd0,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105994:	52                   	push   %edx
80105995:	ff 70 74             	pushl  0x74(%eax)
80105998:	68 0c 79 10 80       	push   $0x8010790c
8010599d:	e8 be ac ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801059a2:	83 c4 20             	add    $0x20,%esp
801059a5:	e8 76 de ff ff       	call   80103820 <myproc>
801059aa:	c7 80 88 00 00 00 01 	movl   $0x1,0x88(%eax)
801059b1:	00 00 00 
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059b4:	e8 67 de ff ff       	call   80103820 <myproc>
801059b9:	85 c0                	test   %eax,%eax
801059bb:	74 20                	je     801059dd <trap+0xcd>
801059bd:	e8 5e de ff ff       	call   80103820 <myproc>
801059c2:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
801059c8:	85 d2                	test   %edx,%edx
801059ca:	74 11                	je     801059dd <trap+0xcd>
801059cc:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801059d0:	83 e0 03             	and    $0x3,%eax
801059d3:	66 83 f8 03          	cmp    $0x3,%ax
801059d7:	0f 84 73 01 00 00    	je     80105b50 <trap+0x240>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801059dd:	e8 3e de ff ff       	call   80103820 <myproc>
801059e2:	85 c0                	test   %eax,%eax
801059e4:	74 0b                	je     801059f1 <trap+0xe1>
801059e6:	e8 35 de ff ff       	call   80103820 <myproc>
801059eb:	83 78 70 04          	cmpl   $0x4,0x70(%eax)
801059ef:	74 6f                	je     80105a60 <trap+0x150>
        yield();
     }
    

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059f1:	e8 2a de ff ff       	call   80103820 <myproc>
801059f6:	85 c0                	test   %eax,%eax
801059f8:	74 1c                	je     80105a16 <trap+0x106>
801059fa:	e8 21 de ff ff       	call   80103820 <myproc>
801059ff:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105a05:	85 c0                	test   %eax,%eax
80105a07:	74 0d                	je     80105a16 <trap+0x106>
80105a09:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105a0d:	83 e0 03             	and    $0x3,%eax
80105a10:	66 83 f8 03          	cmp    $0x3,%ax
80105a14:	74 39                	je     80105a4f <trap+0x13f>
    exit();
}
80105a16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a19:	5b                   	pop    %ebx
80105a1a:	5e                   	pop    %esi
80105a1b:	5f                   	pop    %edi
80105a1c:	5d                   	pop    %ebp
80105a1d:	c3                   	ret    
80105a1e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed)
80105a20:	e8 fb dd ff ff       	call   80103820 <myproc>
80105a25:	8b 98 88 00 00 00    	mov    0x88(%eax),%ebx
80105a2b:	85 db                	test   %ebx,%ebx
80105a2d:	0f 85 0d 01 00 00    	jne    80105b40 <trap+0x230>
    myproc()->tf = tf;
80105a33:	e8 e8 dd ff ff       	call   80103820 <myproc>
80105a38:	89 78 7c             	mov    %edi,0x7c(%eax)
    syscall();
80105a3b:	e8 90 ef ff ff       	call   801049d0 <syscall>
    if(myproc()->killed)
80105a40:	e8 db dd ff ff       	call   80103820 <myproc>
80105a45:	8b 88 88 00 00 00    	mov    0x88(%eax),%ecx
80105a4b:	85 c9                	test   %ecx,%ecx
80105a4d:	74 c7                	je     80105a16 <trap+0x106>
}
80105a4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a52:	5b                   	pop    %ebx
80105a53:	5e                   	pop    %esi
80105a54:	5f                   	pop    %edi
80105a55:	5d                   	pop    %ebp
      exit();
80105a56:	e9 05 e2 ff ff       	jmp    80103c60 <exit>
80105a5b:	90                   	nop
80105a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105a60:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105a64:	75 8b                	jne    801059f1 <trap+0xe1>
     if(ticks % QUANTUM == 0){
80105a66:	8b 0d a0 6d 11 80    	mov    0x80116da0,%ecx
80105a6c:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80105a71:	89 c8                	mov    %ecx,%eax
80105a73:	f7 e2                	mul    %edx
80105a75:	c1 ea 03             	shr    $0x3,%edx
80105a78:	8d 04 92             	lea    (%edx,%edx,4),%eax
80105a7b:	01 c0                	add    %eax,%eax
80105a7d:	39 c1                	cmp    %eax,%ecx
80105a7f:	0f 85 6c ff ff ff    	jne    801059f1 <trap+0xe1>
        yield();
80105a85:	e8 36 e3 ff ff       	call   80103dc0 <yield>
80105a8a:	e9 62 ff ff ff       	jmp    801059f1 <trap+0xe1>
80105a8f:	90                   	nop
    if(cpuid() == 0){
80105a90:	e8 6b dd ff ff       	call   80103800 <cpuid>
80105a95:	85 c0                	test   %eax,%eax
80105a97:	0f 84 c3 00 00 00    	je     80105b60 <trap+0x250>
    lapiceoi();
80105a9d:	e8 be cc ff ff       	call   80102760 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105aa2:	e8 79 dd ff ff       	call   80103820 <myproc>
80105aa7:	85 c0                	test   %eax,%eax
80105aa9:	0f 85 0e ff ff ff    	jne    801059bd <trap+0xad>
80105aaf:	e9 29 ff ff ff       	jmp    801059dd <trap+0xcd>
80105ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105ab8:	e8 63 cb ff ff       	call   80102620 <kbdintr>
    lapiceoi();
80105abd:	e8 9e cc ff ff       	call   80102760 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ac2:	e8 59 dd ff ff       	call   80103820 <myproc>
80105ac7:	85 c0                	test   %eax,%eax
80105ac9:	0f 85 ee fe ff ff    	jne    801059bd <trap+0xad>
80105acf:	e9 09 ff ff ff       	jmp    801059dd <trap+0xcd>
80105ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105ad8:	e8 53 02 00 00       	call   80105d30 <uartintr>
    lapiceoi();
80105add:	e8 7e cc ff ff       	call   80102760 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ae2:	e8 39 dd ff ff       	call   80103820 <myproc>
80105ae7:	85 c0                	test   %eax,%eax
80105ae9:	0f 85 ce fe ff ff    	jne    801059bd <trap+0xad>
80105aef:	e9 e9 fe ff ff       	jmp    801059dd <trap+0xcd>
80105af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105af8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105afc:	8b 77 38             	mov    0x38(%edi),%esi
80105aff:	e8 fc dc ff ff       	call   80103800 <cpuid>
80105b04:	56                   	push   %esi
80105b05:	53                   	push   %ebx
80105b06:	50                   	push   %eax
80105b07:	68 b4 78 10 80       	push   $0x801078b4
80105b0c:	e8 4f ab ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105b11:	e8 4a cc ff ff       	call   80102760 <lapiceoi>
    break;
80105b16:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b19:	e8 02 dd ff ff       	call   80103820 <myproc>
80105b1e:	85 c0                	test   %eax,%eax
80105b20:	0f 85 97 fe ff ff    	jne    801059bd <trap+0xad>
80105b26:	e9 b2 fe ff ff       	jmp    801059dd <trap+0xcd>
80105b2b:	90                   	nop
80105b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105b30:	e8 5b c5 ff ff       	call   80102090 <ideintr>
80105b35:	e9 63 ff ff ff       	jmp    80105a9d <trap+0x18d>
80105b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105b40:	e8 1b e1 ff ff       	call   80103c60 <exit>
80105b45:	e9 e9 fe ff ff       	jmp    80105a33 <trap+0x123>
80105b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105b50:	e8 0b e1 ff ff       	call   80103c60 <exit>
80105b55:	e9 83 fe ff ff       	jmp    801059dd <trap+0xcd>
80105b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105b60:	83 ec 0c             	sub    $0xc,%esp
80105b63:	68 60 65 11 80       	push   $0x80116560
80105b68:	e8 63 e9 ff ff       	call   801044d0 <acquire>
      wakeup(&ticks);
80105b6d:	c7 04 24 a0 6d 11 80 	movl   $0x80116da0,(%esp)
      ticks++;
80105b74:	83 05 a0 6d 11 80 01 	addl   $0x1,0x80116da0
      wakeup(&ticks);
80105b7b:	e8 60 e4 ff ff       	call   80103fe0 <wakeup>
      release(&tickslock);
80105b80:	c7 04 24 60 65 11 80 	movl   $0x80116560,(%esp)
80105b87:	e8 04 ea ff ff       	call   80104590 <release>
80105b8c:	83 c4 10             	add    $0x10,%esp
80105b8f:	e9 09 ff ff ff       	jmp    80105a9d <trap+0x18d>
80105b94:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105b97:	e8 64 dc ff ff       	call   80103800 <cpuid>
80105b9c:	83 ec 0c             	sub    $0xc,%esp
80105b9f:	56                   	push   %esi
80105ba0:	53                   	push   %ebx
80105ba1:	50                   	push   %eax
80105ba2:	ff 77 30             	pushl  0x30(%edi)
80105ba5:	68 d8 78 10 80       	push   $0x801078d8
80105baa:	e8 b1 aa ff ff       	call   80100660 <cprintf>
      panic("trap");
80105baf:	83 c4 14             	add    $0x14,%esp
80105bb2:	68 ae 78 10 80       	push   $0x801078ae
80105bb7:	e8 d4 a7 ff ff       	call   80100390 <panic>
80105bbc:	66 90                	xchg   %ax,%ax
80105bbe:	66 90                	xchg   %ax,%ax

80105bc0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105bc0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105bc5:	55                   	push   %ebp
80105bc6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105bc8:	85 c0                	test   %eax,%eax
80105bca:	74 1c                	je     80105be8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105bcc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105bd1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105bd2:	a8 01                	test   $0x1,%al
80105bd4:	74 12                	je     80105be8 <uartgetc+0x28>
80105bd6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105bdb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105bdc:	0f b6 c0             	movzbl %al,%eax
}
80105bdf:	5d                   	pop    %ebp
80105be0:	c3                   	ret    
80105be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bed:	5d                   	pop    %ebp
80105bee:	c3                   	ret    
80105bef:	90                   	nop

80105bf0 <uartputc.part.0>:
uartputc(int c)
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	57                   	push   %edi
80105bf4:	56                   	push   %esi
80105bf5:	53                   	push   %ebx
80105bf6:	89 c7                	mov    %eax,%edi
80105bf8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105bfd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105c02:	83 ec 0c             	sub    $0xc,%esp
80105c05:	eb 1b                	jmp    80105c22 <uartputc.part.0+0x32>
80105c07:	89 f6                	mov    %esi,%esi
80105c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105c10:	83 ec 0c             	sub    $0xc,%esp
80105c13:	6a 0a                	push   $0xa
80105c15:	e8 66 cb ff ff       	call   80102780 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105c1a:	83 c4 10             	add    $0x10,%esp
80105c1d:	83 eb 01             	sub    $0x1,%ebx
80105c20:	74 07                	je     80105c29 <uartputc.part.0+0x39>
80105c22:	89 f2                	mov    %esi,%edx
80105c24:	ec                   	in     (%dx),%al
80105c25:	a8 20                	test   $0x20,%al
80105c27:	74 e7                	je     80105c10 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105c29:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c2e:	89 f8                	mov    %edi,%eax
80105c30:	ee                   	out    %al,(%dx)
}
80105c31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c34:	5b                   	pop    %ebx
80105c35:	5e                   	pop    %esi
80105c36:	5f                   	pop    %edi
80105c37:	5d                   	pop    %ebp
80105c38:	c3                   	ret    
80105c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c40 <uartinit>:
{
80105c40:	55                   	push   %ebp
80105c41:	31 c9                	xor    %ecx,%ecx
80105c43:	89 c8                	mov    %ecx,%eax
80105c45:	89 e5                	mov    %esp,%ebp
80105c47:	57                   	push   %edi
80105c48:	56                   	push   %esi
80105c49:	53                   	push   %ebx
80105c4a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105c4f:	89 da                	mov    %ebx,%edx
80105c51:	83 ec 0c             	sub    $0xc,%esp
80105c54:	ee                   	out    %al,(%dx)
80105c55:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105c5a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105c5f:	89 fa                	mov    %edi,%edx
80105c61:	ee                   	out    %al,(%dx)
80105c62:	b8 0c 00 00 00       	mov    $0xc,%eax
80105c67:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c6c:	ee                   	out    %al,(%dx)
80105c6d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105c72:	89 c8                	mov    %ecx,%eax
80105c74:	89 f2                	mov    %esi,%edx
80105c76:	ee                   	out    %al,(%dx)
80105c77:	b8 03 00 00 00       	mov    $0x3,%eax
80105c7c:	89 fa                	mov    %edi,%edx
80105c7e:	ee                   	out    %al,(%dx)
80105c7f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105c84:	89 c8                	mov    %ecx,%eax
80105c86:	ee                   	out    %al,(%dx)
80105c87:	b8 01 00 00 00       	mov    $0x1,%eax
80105c8c:	89 f2                	mov    %esi,%edx
80105c8e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c8f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c94:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105c95:	3c ff                	cmp    $0xff,%al
80105c97:	74 5a                	je     80105cf3 <uartinit+0xb3>
  uart = 1;
80105c99:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105ca0:	00 00 00 
80105ca3:	89 da                	mov    %ebx,%edx
80105ca5:	ec                   	in     (%dx),%al
80105ca6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cab:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105cac:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105caf:	bb d0 79 10 80       	mov    $0x801079d0,%ebx
  ioapicenable(IRQ_COM1, 0);
80105cb4:	6a 00                	push   $0x0
80105cb6:	6a 04                	push   $0x4
80105cb8:	e8 23 c6 ff ff       	call   801022e0 <ioapicenable>
80105cbd:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105cc0:	b8 78 00 00 00       	mov    $0x78,%eax
80105cc5:	eb 13                	jmp    80105cda <uartinit+0x9a>
80105cc7:	89 f6                	mov    %esi,%esi
80105cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105cd0:	83 c3 01             	add    $0x1,%ebx
80105cd3:	0f be 03             	movsbl (%ebx),%eax
80105cd6:	84 c0                	test   %al,%al
80105cd8:	74 19                	je     80105cf3 <uartinit+0xb3>
  if(!uart)
80105cda:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105ce0:	85 d2                	test   %edx,%edx
80105ce2:	74 ec                	je     80105cd0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80105ce4:	83 c3 01             	add    $0x1,%ebx
80105ce7:	e8 04 ff ff ff       	call   80105bf0 <uartputc.part.0>
80105cec:	0f be 03             	movsbl (%ebx),%eax
80105cef:	84 c0                	test   %al,%al
80105cf1:	75 e7                	jne    80105cda <uartinit+0x9a>
}
80105cf3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cf6:	5b                   	pop    %ebx
80105cf7:	5e                   	pop    %esi
80105cf8:	5f                   	pop    %edi
80105cf9:	5d                   	pop    %ebp
80105cfa:	c3                   	ret    
80105cfb:	90                   	nop
80105cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d00 <uartputc>:
  if(!uart)
80105d00:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105d06:	55                   	push   %ebp
80105d07:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105d09:	85 d2                	test   %edx,%edx
{
80105d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105d0e:	74 10                	je     80105d20 <uartputc+0x20>
}
80105d10:	5d                   	pop    %ebp
80105d11:	e9 da fe ff ff       	jmp    80105bf0 <uartputc.part.0>
80105d16:	8d 76 00             	lea    0x0(%esi),%esi
80105d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105d20:	5d                   	pop    %ebp
80105d21:	c3                   	ret    
80105d22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d30 <uartintr>:

void
uartintr(void)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105d36:	68 c0 5b 10 80       	push   $0x80105bc0
80105d3b:	e8 d0 aa ff ff       	call   80100810 <consoleintr>
}
80105d40:	83 c4 10             	add    $0x10,%esp
80105d43:	c9                   	leave  
80105d44:	c3                   	ret    

80105d45 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105d45:	6a 00                	push   $0x0
  pushl $0
80105d47:	6a 00                	push   $0x0
  jmp alltraps
80105d49:	e9 ec fa ff ff       	jmp    8010583a <alltraps>

80105d4e <vector1>:
.globl vector1
vector1:
  pushl $0
80105d4e:	6a 00                	push   $0x0
  pushl $1
80105d50:	6a 01                	push   $0x1
  jmp alltraps
80105d52:	e9 e3 fa ff ff       	jmp    8010583a <alltraps>

80105d57 <vector2>:
.globl vector2
vector2:
  pushl $0
80105d57:	6a 00                	push   $0x0
  pushl $2
80105d59:	6a 02                	push   $0x2
  jmp alltraps
80105d5b:	e9 da fa ff ff       	jmp    8010583a <alltraps>

80105d60 <vector3>:
.globl vector3
vector3:
  pushl $0
80105d60:	6a 00                	push   $0x0
  pushl $3
80105d62:	6a 03                	push   $0x3
  jmp alltraps
80105d64:	e9 d1 fa ff ff       	jmp    8010583a <alltraps>

80105d69 <vector4>:
.globl vector4
vector4:
  pushl $0
80105d69:	6a 00                	push   $0x0
  pushl $4
80105d6b:	6a 04                	push   $0x4
  jmp alltraps
80105d6d:	e9 c8 fa ff ff       	jmp    8010583a <alltraps>

80105d72 <vector5>:
.globl vector5
vector5:
  pushl $0
80105d72:	6a 00                	push   $0x0
  pushl $5
80105d74:	6a 05                	push   $0x5
  jmp alltraps
80105d76:	e9 bf fa ff ff       	jmp    8010583a <alltraps>

80105d7b <vector6>:
.globl vector6
vector6:
  pushl $0
80105d7b:	6a 00                	push   $0x0
  pushl $6
80105d7d:	6a 06                	push   $0x6
  jmp alltraps
80105d7f:	e9 b6 fa ff ff       	jmp    8010583a <alltraps>

80105d84 <vector7>:
.globl vector7
vector7:
  pushl $0
80105d84:	6a 00                	push   $0x0
  pushl $7
80105d86:	6a 07                	push   $0x7
  jmp alltraps
80105d88:	e9 ad fa ff ff       	jmp    8010583a <alltraps>

80105d8d <vector8>:
.globl vector8
vector8:
  pushl $8
80105d8d:	6a 08                	push   $0x8
  jmp alltraps
80105d8f:	e9 a6 fa ff ff       	jmp    8010583a <alltraps>

80105d94 <vector9>:
.globl vector9
vector9:
  pushl $0
80105d94:	6a 00                	push   $0x0
  pushl $9
80105d96:	6a 09                	push   $0x9
  jmp alltraps
80105d98:	e9 9d fa ff ff       	jmp    8010583a <alltraps>

80105d9d <vector10>:
.globl vector10
vector10:
  pushl $10
80105d9d:	6a 0a                	push   $0xa
  jmp alltraps
80105d9f:	e9 96 fa ff ff       	jmp    8010583a <alltraps>

80105da4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105da4:	6a 0b                	push   $0xb
  jmp alltraps
80105da6:	e9 8f fa ff ff       	jmp    8010583a <alltraps>

80105dab <vector12>:
.globl vector12
vector12:
  pushl $12
80105dab:	6a 0c                	push   $0xc
  jmp alltraps
80105dad:	e9 88 fa ff ff       	jmp    8010583a <alltraps>

80105db2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105db2:	6a 0d                	push   $0xd
  jmp alltraps
80105db4:	e9 81 fa ff ff       	jmp    8010583a <alltraps>

80105db9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105db9:	6a 0e                	push   $0xe
  jmp alltraps
80105dbb:	e9 7a fa ff ff       	jmp    8010583a <alltraps>

80105dc0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105dc0:	6a 00                	push   $0x0
  pushl $15
80105dc2:	6a 0f                	push   $0xf
  jmp alltraps
80105dc4:	e9 71 fa ff ff       	jmp    8010583a <alltraps>

80105dc9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105dc9:	6a 00                	push   $0x0
  pushl $16
80105dcb:	6a 10                	push   $0x10
  jmp alltraps
80105dcd:	e9 68 fa ff ff       	jmp    8010583a <alltraps>

80105dd2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105dd2:	6a 11                	push   $0x11
  jmp alltraps
80105dd4:	e9 61 fa ff ff       	jmp    8010583a <alltraps>

80105dd9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105dd9:	6a 00                	push   $0x0
  pushl $18
80105ddb:	6a 12                	push   $0x12
  jmp alltraps
80105ddd:	e9 58 fa ff ff       	jmp    8010583a <alltraps>

80105de2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105de2:	6a 00                	push   $0x0
  pushl $19
80105de4:	6a 13                	push   $0x13
  jmp alltraps
80105de6:	e9 4f fa ff ff       	jmp    8010583a <alltraps>

80105deb <vector20>:
.globl vector20
vector20:
  pushl $0
80105deb:	6a 00                	push   $0x0
  pushl $20
80105ded:	6a 14                	push   $0x14
  jmp alltraps
80105def:	e9 46 fa ff ff       	jmp    8010583a <alltraps>

80105df4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105df4:	6a 00                	push   $0x0
  pushl $21
80105df6:	6a 15                	push   $0x15
  jmp alltraps
80105df8:	e9 3d fa ff ff       	jmp    8010583a <alltraps>

80105dfd <vector22>:
.globl vector22
vector22:
  pushl $0
80105dfd:	6a 00                	push   $0x0
  pushl $22
80105dff:	6a 16                	push   $0x16
  jmp alltraps
80105e01:	e9 34 fa ff ff       	jmp    8010583a <alltraps>

80105e06 <vector23>:
.globl vector23
vector23:
  pushl $0
80105e06:	6a 00                	push   $0x0
  pushl $23
80105e08:	6a 17                	push   $0x17
  jmp alltraps
80105e0a:	e9 2b fa ff ff       	jmp    8010583a <alltraps>

80105e0f <vector24>:
.globl vector24
vector24:
  pushl $0
80105e0f:	6a 00                	push   $0x0
  pushl $24
80105e11:	6a 18                	push   $0x18
  jmp alltraps
80105e13:	e9 22 fa ff ff       	jmp    8010583a <alltraps>

80105e18 <vector25>:
.globl vector25
vector25:
  pushl $0
80105e18:	6a 00                	push   $0x0
  pushl $25
80105e1a:	6a 19                	push   $0x19
  jmp alltraps
80105e1c:	e9 19 fa ff ff       	jmp    8010583a <alltraps>

80105e21 <vector26>:
.globl vector26
vector26:
  pushl $0
80105e21:	6a 00                	push   $0x0
  pushl $26
80105e23:	6a 1a                	push   $0x1a
  jmp alltraps
80105e25:	e9 10 fa ff ff       	jmp    8010583a <alltraps>

80105e2a <vector27>:
.globl vector27
vector27:
  pushl $0
80105e2a:	6a 00                	push   $0x0
  pushl $27
80105e2c:	6a 1b                	push   $0x1b
  jmp alltraps
80105e2e:	e9 07 fa ff ff       	jmp    8010583a <alltraps>

80105e33 <vector28>:
.globl vector28
vector28:
  pushl $0
80105e33:	6a 00                	push   $0x0
  pushl $28
80105e35:	6a 1c                	push   $0x1c
  jmp alltraps
80105e37:	e9 fe f9 ff ff       	jmp    8010583a <alltraps>

80105e3c <vector29>:
.globl vector29
vector29:
  pushl $0
80105e3c:	6a 00                	push   $0x0
  pushl $29
80105e3e:	6a 1d                	push   $0x1d
  jmp alltraps
80105e40:	e9 f5 f9 ff ff       	jmp    8010583a <alltraps>

80105e45 <vector30>:
.globl vector30
vector30:
  pushl $0
80105e45:	6a 00                	push   $0x0
  pushl $30
80105e47:	6a 1e                	push   $0x1e
  jmp alltraps
80105e49:	e9 ec f9 ff ff       	jmp    8010583a <alltraps>

80105e4e <vector31>:
.globl vector31
vector31:
  pushl $0
80105e4e:	6a 00                	push   $0x0
  pushl $31
80105e50:	6a 1f                	push   $0x1f
  jmp alltraps
80105e52:	e9 e3 f9 ff ff       	jmp    8010583a <alltraps>

80105e57 <vector32>:
.globl vector32
vector32:
  pushl $0
80105e57:	6a 00                	push   $0x0
  pushl $32
80105e59:	6a 20                	push   $0x20
  jmp alltraps
80105e5b:	e9 da f9 ff ff       	jmp    8010583a <alltraps>

80105e60 <vector33>:
.globl vector33
vector33:
  pushl $0
80105e60:	6a 00                	push   $0x0
  pushl $33
80105e62:	6a 21                	push   $0x21
  jmp alltraps
80105e64:	e9 d1 f9 ff ff       	jmp    8010583a <alltraps>

80105e69 <vector34>:
.globl vector34
vector34:
  pushl $0
80105e69:	6a 00                	push   $0x0
  pushl $34
80105e6b:	6a 22                	push   $0x22
  jmp alltraps
80105e6d:	e9 c8 f9 ff ff       	jmp    8010583a <alltraps>

80105e72 <vector35>:
.globl vector35
vector35:
  pushl $0
80105e72:	6a 00                	push   $0x0
  pushl $35
80105e74:	6a 23                	push   $0x23
  jmp alltraps
80105e76:	e9 bf f9 ff ff       	jmp    8010583a <alltraps>

80105e7b <vector36>:
.globl vector36
vector36:
  pushl $0
80105e7b:	6a 00                	push   $0x0
  pushl $36
80105e7d:	6a 24                	push   $0x24
  jmp alltraps
80105e7f:	e9 b6 f9 ff ff       	jmp    8010583a <alltraps>

80105e84 <vector37>:
.globl vector37
vector37:
  pushl $0
80105e84:	6a 00                	push   $0x0
  pushl $37
80105e86:	6a 25                	push   $0x25
  jmp alltraps
80105e88:	e9 ad f9 ff ff       	jmp    8010583a <alltraps>

80105e8d <vector38>:
.globl vector38
vector38:
  pushl $0
80105e8d:	6a 00                	push   $0x0
  pushl $38
80105e8f:	6a 26                	push   $0x26
  jmp alltraps
80105e91:	e9 a4 f9 ff ff       	jmp    8010583a <alltraps>

80105e96 <vector39>:
.globl vector39
vector39:
  pushl $0
80105e96:	6a 00                	push   $0x0
  pushl $39
80105e98:	6a 27                	push   $0x27
  jmp alltraps
80105e9a:	e9 9b f9 ff ff       	jmp    8010583a <alltraps>

80105e9f <vector40>:
.globl vector40
vector40:
  pushl $0
80105e9f:	6a 00                	push   $0x0
  pushl $40
80105ea1:	6a 28                	push   $0x28
  jmp alltraps
80105ea3:	e9 92 f9 ff ff       	jmp    8010583a <alltraps>

80105ea8 <vector41>:
.globl vector41
vector41:
  pushl $0
80105ea8:	6a 00                	push   $0x0
  pushl $41
80105eaa:	6a 29                	push   $0x29
  jmp alltraps
80105eac:	e9 89 f9 ff ff       	jmp    8010583a <alltraps>

80105eb1 <vector42>:
.globl vector42
vector42:
  pushl $0
80105eb1:	6a 00                	push   $0x0
  pushl $42
80105eb3:	6a 2a                	push   $0x2a
  jmp alltraps
80105eb5:	e9 80 f9 ff ff       	jmp    8010583a <alltraps>

80105eba <vector43>:
.globl vector43
vector43:
  pushl $0
80105eba:	6a 00                	push   $0x0
  pushl $43
80105ebc:	6a 2b                	push   $0x2b
  jmp alltraps
80105ebe:	e9 77 f9 ff ff       	jmp    8010583a <alltraps>

80105ec3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105ec3:	6a 00                	push   $0x0
  pushl $44
80105ec5:	6a 2c                	push   $0x2c
  jmp alltraps
80105ec7:	e9 6e f9 ff ff       	jmp    8010583a <alltraps>

80105ecc <vector45>:
.globl vector45
vector45:
  pushl $0
80105ecc:	6a 00                	push   $0x0
  pushl $45
80105ece:	6a 2d                	push   $0x2d
  jmp alltraps
80105ed0:	e9 65 f9 ff ff       	jmp    8010583a <alltraps>

80105ed5 <vector46>:
.globl vector46
vector46:
  pushl $0
80105ed5:	6a 00                	push   $0x0
  pushl $46
80105ed7:	6a 2e                	push   $0x2e
  jmp alltraps
80105ed9:	e9 5c f9 ff ff       	jmp    8010583a <alltraps>

80105ede <vector47>:
.globl vector47
vector47:
  pushl $0
80105ede:	6a 00                	push   $0x0
  pushl $47
80105ee0:	6a 2f                	push   $0x2f
  jmp alltraps
80105ee2:	e9 53 f9 ff ff       	jmp    8010583a <alltraps>

80105ee7 <vector48>:
.globl vector48
vector48:
  pushl $0
80105ee7:	6a 00                	push   $0x0
  pushl $48
80105ee9:	6a 30                	push   $0x30
  jmp alltraps
80105eeb:	e9 4a f9 ff ff       	jmp    8010583a <alltraps>

80105ef0 <vector49>:
.globl vector49
vector49:
  pushl $0
80105ef0:	6a 00                	push   $0x0
  pushl $49
80105ef2:	6a 31                	push   $0x31
  jmp alltraps
80105ef4:	e9 41 f9 ff ff       	jmp    8010583a <alltraps>

80105ef9 <vector50>:
.globl vector50
vector50:
  pushl $0
80105ef9:	6a 00                	push   $0x0
  pushl $50
80105efb:	6a 32                	push   $0x32
  jmp alltraps
80105efd:	e9 38 f9 ff ff       	jmp    8010583a <alltraps>

80105f02 <vector51>:
.globl vector51
vector51:
  pushl $0
80105f02:	6a 00                	push   $0x0
  pushl $51
80105f04:	6a 33                	push   $0x33
  jmp alltraps
80105f06:	e9 2f f9 ff ff       	jmp    8010583a <alltraps>

80105f0b <vector52>:
.globl vector52
vector52:
  pushl $0
80105f0b:	6a 00                	push   $0x0
  pushl $52
80105f0d:	6a 34                	push   $0x34
  jmp alltraps
80105f0f:	e9 26 f9 ff ff       	jmp    8010583a <alltraps>

80105f14 <vector53>:
.globl vector53
vector53:
  pushl $0
80105f14:	6a 00                	push   $0x0
  pushl $53
80105f16:	6a 35                	push   $0x35
  jmp alltraps
80105f18:	e9 1d f9 ff ff       	jmp    8010583a <alltraps>

80105f1d <vector54>:
.globl vector54
vector54:
  pushl $0
80105f1d:	6a 00                	push   $0x0
  pushl $54
80105f1f:	6a 36                	push   $0x36
  jmp alltraps
80105f21:	e9 14 f9 ff ff       	jmp    8010583a <alltraps>

80105f26 <vector55>:
.globl vector55
vector55:
  pushl $0
80105f26:	6a 00                	push   $0x0
  pushl $55
80105f28:	6a 37                	push   $0x37
  jmp alltraps
80105f2a:	e9 0b f9 ff ff       	jmp    8010583a <alltraps>

80105f2f <vector56>:
.globl vector56
vector56:
  pushl $0
80105f2f:	6a 00                	push   $0x0
  pushl $56
80105f31:	6a 38                	push   $0x38
  jmp alltraps
80105f33:	e9 02 f9 ff ff       	jmp    8010583a <alltraps>

80105f38 <vector57>:
.globl vector57
vector57:
  pushl $0
80105f38:	6a 00                	push   $0x0
  pushl $57
80105f3a:	6a 39                	push   $0x39
  jmp alltraps
80105f3c:	e9 f9 f8 ff ff       	jmp    8010583a <alltraps>

80105f41 <vector58>:
.globl vector58
vector58:
  pushl $0
80105f41:	6a 00                	push   $0x0
  pushl $58
80105f43:	6a 3a                	push   $0x3a
  jmp alltraps
80105f45:	e9 f0 f8 ff ff       	jmp    8010583a <alltraps>

80105f4a <vector59>:
.globl vector59
vector59:
  pushl $0
80105f4a:	6a 00                	push   $0x0
  pushl $59
80105f4c:	6a 3b                	push   $0x3b
  jmp alltraps
80105f4e:	e9 e7 f8 ff ff       	jmp    8010583a <alltraps>

80105f53 <vector60>:
.globl vector60
vector60:
  pushl $0
80105f53:	6a 00                	push   $0x0
  pushl $60
80105f55:	6a 3c                	push   $0x3c
  jmp alltraps
80105f57:	e9 de f8 ff ff       	jmp    8010583a <alltraps>

80105f5c <vector61>:
.globl vector61
vector61:
  pushl $0
80105f5c:	6a 00                	push   $0x0
  pushl $61
80105f5e:	6a 3d                	push   $0x3d
  jmp alltraps
80105f60:	e9 d5 f8 ff ff       	jmp    8010583a <alltraps>

80105f65 <vector62>:
.globl vector62
vector62:
  pushl $0
80105f65:	6a 00                	push   $0x0
  pushl $62
80105f67:	6a 3e                	push   $0x3e
  jmp alltraps
80105f69:	e9 cc f8 ff ff       	jmp    8010583a <alltraps>

80105f6e <vector63>:
.globl vector63
vector63:
  pushl $0
80105f6e:	6a 00                	push   $0x0
  pushl $63
80105f70:	6a 3f                	push   $0x3f
  jmp alltraps
80105f72:	e9 c3 f8 ff ff       	jmp    8010583a <alltraps>

80105f77 <vector64>:
.globl vector64
vector64:
  pushl $0
80105f77:	6a 00                	push   $0x0
  pushl $64
80105f79:	6a 40                	push   $0x40
  jmp alltraps
80105f7b:	e9 ba f8 ff ff       	jmp    8010583a <alltraps>

80105f80 <vector65>:
.globl vector65
vector65:
  pushl $0
80105f80:	6a 00                	push   $0x0
  pushl $65
80105f82:	6a 41                	push   $0x41
  jmp alltraps
80105f84:	e9 b1 f8 ff ff       	jmp    8010583a <alltraps>

80105f89 <vector66>:
.globl vector66
vector66:
  pushl $0
80105f89:	6a 00                	push   $0x0
  pushl $66
80105f8b:	6a 42                	push   $0x42
  jmp alltraps
80105f8d:	e9 a8 f8 ff ff       	jmp    8010583a <alltraps>

80105f92 <vector67>:
.globl vector67
vector67:
  pushl $0
80105f92:	6a 00                	push   $0x0
  pushl $67
80105f94:	6a 43                	push   $0x43
  jmp alltraps
80105f96:	e9 9f f8 ff ff       	jmp    8010583a <alltraps>

80105f9b <vector68>:
.globl vector68
vector68:
  pushl $0
80105f9b:	6a 00                	push   $0x0
  pushl $68
80105f9d:	6a 44                	push   $0x44
  jmp alltraps
80105f9f:	e9 96 f8 ff ff       	jmp    8010583a <alltraps>

80105fa4 <vector69>:
.globl vector69
vector69:
  pushl $0
80105fa4:	6a 00                	push   $0x0
  pushl $69
80105fa6:	6a 45                	push   $0x45
  jmp alltraps
80105fa8:	e9 8d f8 ff ff       	jmp    8010583a <alltraps>

80105fad <vector70>:
.globl vector70
vector70:
  pushl $0
80105fad:	6a 00                	push   $0x0
  pushl $70
80105faf:	6a 46                	push   $0x46
  jmp alltraps
80105fb1:	e9 84 f8 ff ff       	jmp    8010583a <alltraps>

80105fb6 <vector71>:
.globl vector71
vector71:
  pushl $0
80105fb6:	6a 00                	push   $0x0
  pushl $71
80105fb8:	6a 47                	push   $0x47
  jmp alltraps
80105fba:	e9 7b f8 ff ff       	jmp    8010583a <alltraps>

80105fbf <vector72>:
.globl vector72
vector72:
  pushl $0
80105fbf:	6a 00                	push   $0x0
  pushl $72
80105fc1:	6a 48                	push   $0x48
  jmp alltraps
80105fc3:	e9 72 f8 ff ff       	jmp    8010583a <alltraps>

80105fc8 <vector73>:
.globl vector73
vector73:
  pushl $0
80105fc8:	6a 00                	push   $0x0
  pushl $73
80105fca:	6a 49                	push   $0x49
  jmp alltraps
80105fcc:	e9 69 f8 ff ff       	jmp    8010583a <alltraps>

80105fd1 <vector74>:
.globl vector74
vector74:
  pushl $0
80105fd1:	6a 00                	push   $0x0
  pushl $74
80105fd3:	6a 4a                	push   $0x4a
  jmp alltraps
80105fd5:	e9 60 f8 ff ff       	jmp    8010583a <alltraps>

80105fda <vector75>:
.globl vector75
vector75:
  pushl $0
80105fda:	6a 00                	push   $0x0
  pushl $75
80105fdc:	6a 4b                	push   $0x4b
  jmp alltraps
80105fde:	e9 57 f8 ff ff       	jmp    8010583a <alltraps>

80105fe3 <vector76>:
.globl vector76
vector76:
  pushl $0
80105fe3:	6a 00                	push   $0x0
  pushl $76
80105fe5:	6a 4c                	push   $0x4c
  jmp alltraps
80105fe7:	e9 4e f8 ff ff       	jmp    8010583a <alltraps>

80105fec <vector77>:
.globl vector77
vector77:
  pushl $0
80105fec:	6a 00                	push   $0x0
  pushl $77
80105fee:	6a 4d                	push   $0x4d
  jmp alltraps
80105ff0:	e9 45 f8 ff ff       	jmp    8010583a <alltraps>

80105ff5 <vector78>:
.globl vector78
vector78:
  pushl $0
80105ff5:	6a 00                	push   $0x0
  pushl $78
80105ff7:	6a 4e                	push   $0x4e
  jmp alltraps
80105ff9:	e9 3c f8 ff ff       	jmp    8010583a <alltraps>

80105ffe <vector79>:
.globl vector79
vector79:
  pushl $0
80105ffe:	6a 00                	push   $0x0
  pushl $79
80106000:	6a 4f                	push   $0x4f
  jmp alltraps
80106002:	e9 33 f8 ff ff       	jmp    8010583a <alltraps>

80106007 <vector80>:
.globl vector80
vector80:
  pushl $0
80106007:	6a 00                	push   $0x0
  pushl $80
80106009:	6a 50                	push   $0x50
  jmp alltraps
8010600b:	e9 2a f8 ff ff       	jmp    8010583a <alltraps>

80106010 <vector81>:
.globl vector81
vector81:
  pushl $0
80106010:	6a 00                	push   $0x0
  pushl $81
80106012:	6a 51                	push   $0x51
  jmp alltraps
80106014:	e9 21 f8 ff ff       	jmp    8010583a <alltraps>

80106019 <vector82>:
.globl vector82
vector82:
  pushl $0
80106019:	6a 00                	push   $0x0
  pushl $82
8010601b:	6a 52                	push   $0x52
  jmp alltraps
8010601d:	e9 18 f8 ff ff       	jmp    8010583a <alltraps>

80106022 <vector83>:
.globl vector83
vector83:
  pushl $0
80106022:	6a 00                	push   $0x0
  pushl $83
80106024:	6a 53                	push   $0x53
  jmp alltraps
80106026:	e9 0f f8 ff ff       	jmp    8010583a <alltraps>

8010602b <vector84>:
.globl vector84
vector84:
  pushl $0
8010602b:	6a 00                	push   $0x0
  pushl $84
8010602d:	6a 54                	push   $0x54
  jmp alltraps
8010602f:	e9 06 f8 ff ff       	jmp    8010583a <alltraps>

80106034 <vector85>:
.globl vector85
vector85:
  pushl $0
80106034:	6a 00                	push   $0x0
  pushl $85
80106036:	6a 55                	push   $0x55
  jmp alltraps
80106038:	e9 fd f7 ff ff       	jmp    8010583a <alltraps>

8010603d <vector86>:
.globl vector86
vector86:
  pushl $0
8010603d:	6a 00                	push   $0x0
  pushl $86
8010603f:	6a 56                	push   $0x56
  jmp alltraps
80106041:	e9 f4 f7 ff ff       	jmp    8010583a <alltraps>

80106046 <vector87>:
.globl vector87
vector87:
  pushl $0
80106046:	6a 00                	push   $0x0
  pushl $87
80106048:	6a 57                	push   $0x57
  jmp alltraps
8010604a:	e9 eb f7 ff ff       	jmp    8010583a <alltraps>

8010604f <vector88>:
.globl vector88
vector88:
  pushl $0
8010604f:	6a 00                	push   $0x0
  pushl $88
80106051:	6a 58                	push   $0x58
  jmp alltraps
80106053:	e9 e2 f7 ff ff       	jmp    8010583a <alltraps>

80106058 <vector89>:
.globl vector89
vector89:
  pushl $0
80106058:	6a 00                	push   $0x0
  pushl $89
8010605a:	6a 59                	push   $0x59
  jmp alltraps
8010605c:	e9 d9 f7 ff ff       	jmp    8010583a <alltraps>

80106061 <vector90>:
.globl vector90
vector90:
  pushl $0
80106061:	6a 00                	push   $0x0
  pushl $90
80106063:	6a 5a                	push   $0x5a
  jmp alltraps
80106065:	e9 d0 f7 ff ff       	jmp    8010583a <alltraps>

8010606a <vector91>:
.globl vector91
vector91:
  pushl $0
8010606a:	6a 00                	push   $0x0
  pushl $91
8010606c:	6a 5b                	push   $0x5b
  jmp alltraps
8010606e:	e9 c7 f7 ff ff       	jmp    8010583a <alltraps>

80106073 <vector92>:
.globl vector92
vector92:
  pushl $0
80106073:	6a 00                	push   $0x0
  pushl $92
80106075:	6a 5c                	push   $0x5c
  jmp alltraps
80106077:	e9 be f7 ff ff       	jmp    8010583a <alltraps>

8010607c <vector93>:
.globl vector93
vector93:
  pushl $0
8010607c:	6a 00                	push   $0x0
  pushl $93
8010607e:	6a 5d                	push   $0x5d
  jmp alltraps
80106080:	e9 b5 f7 ff ff       	jmp    8010583a <alltraps>

80106085 <vector94>:
.globl vector94
vector94:
  pushl $0
80106085:	6a 00                	push   $0x0
  pushl $94
80106087:	6a 5e                	push   $0x5e
  jmp alltraps
80106089:	e9 ac f7 ff ff       	jmp    8010583a <alltraps>

8010608e <vector95>:
.globl vector95
vector95:
  pushl $0
8010608e:	6a 00                	push   $0x0
  pushl $95
80106090:	6a 5f                	push   $0x5f
  jmp alltraps
80106092:	e9 a3 f7 ff ff       	jmp    8010583a <alltraps>

80106097 <vector96>:
.globl vector96
vector96:
  pushl $0
80106097:	6a 00                	push   $0x0
  pushl $96
80106099:	6a 60                	push   $0x60
  jmp alltraps
8010609b:	e9 9a f7 ff ff       	jmp    8010583a <alltraps>

801060a0 <vector97>:
.globl vector97
vector97:
  pushl $0
801060a0:	6a 00                	push   $0x0
  pushl $97
801060a2:	6a 61                	push   $0x61
  jmp alltraps
801060a4:	e9 91 f7 ff ff       	jmp    8010583a <alltraps>

801060a9 <vector98>:
.globl vector98
vector98:
  pushl $0
801060a9:	6a 00                	push   $0x0
  pushl $98
801060ab:	6a 62                	push   $0x62
  jmp alltraps
801060ad:	e9 88 f7 ff ff       	jmp    8010583a <alltraps>

801060b2 <vector99>:
.globl vector99
vector99:
  pushl $0
801060b2:	6a 00                	push   $0x0
  pushl $99
801060b4:	6a 63                	push   $0x63
  jmp alltraps
801060b6:	e9 7f f7 ff ff       	jmp    8010583a <alltraps>

801060bb <vector100>:
.globl vector100
vector100:
  pushl $0
801060bb:	6a 00                	push   $0x0
  pushl $100
801060bd:	6a 64                	push   $0x64
  jmp alltraps
801060bf:	e9 76 f7 ff ff       	jmp    8010583a <alltraps>

801060c4 <vector101>:
.globl vector101
vector101:
  pushl $0
801060c4:	6a 00                	push   $0x0
  pushl $101
801060c6:	6a 65                	push   $0x65
  jmp alltraps
801060c8:	e9 6d f7 ff ff       	jmp    8010583a <alltraps>

801060cd <vector102>:
.globl vector102
vector102:
  pushl $0
801060cd:	6a 00                	push   $0x0
  pushl $102
801060cf:	6a 66                	push   $0x66
  jmp alltraps
801060d1:	e9 64 f7 ff ff       	jmp    8010583a <alltraps>

801060d6 <vector103>:
.globl vector103
vector103:
  pushl $0
801060d6:	6a 00                	push   $0x0
  pushl $103
801060d8:	6a 67                	push   $0x67
  jmp alltraps
801060da:	e9 5b f7 ff ff       	jmp    8010583a <alltraps>

801060df <vector104>:
.globl vector104
vector104:
  pushl $0
801060df:	6a 00                	push   $0x0
  pushl $104
801060e1:	6a 68                	push   $0x68
  jmp alltraps
801060e3:	e9 52 f7 ff ff       	jmp    8010583a <alltraps>

801060e8 <vector105>:
.globl vector105
vector105:
  pushl $0
801060e8:	6a 00                	push   $0x0
  pushl $105
801060ea:	6a 69                	push   $0x69
  jmp alltraps
801060ec:	e9 49 f7 ff ff       	jmp    8010583a <alltraps>

801060f1 <vector106>:
.globl vector106
vector106:
  pushl $0
801060f1:	6a 00                	push   $0x0
  pushl $106
801060f3:	6a 6a                	push   $0x6a
  jmp alltraps
801060f5:	e9 40 f7 ff ff       	jmp    8010583a <alltraps>

801060fa <vector107>:
.globl vector107
vector107:
  pushl $0
801060fa:	6a 00                	push   $0x0
  pushl $107
801060fc:	6a 6b                	push   $0x6b
  jmp alltraps
801060fe:	e9 37 f7 ff ff       	jmp    8010583a <alltraps>

80106103 <vector108>:
.globl vector108
vector108:
  pushl $0
80106103:	6a 00                	push   $0x0
  pushl $108
80106105:	6a 6c                	push   $0x6c
  jmp alltraps
80106107:	e9 2e f7 ff ff       	jmp    8010583a <alltraps>

8010610c <vector109>:
.globl vector109
vector109:
  pushl $0
8010610c:	6a 00                	push   $0x0
  pushl $109
8010610e:	6a 6d                	push   $0x6d
  jmp alltraps
80106110:	e9 25 f7 ff ff       	jmp    8010583a <alltraps>

80106115 <vector110>:
.globl vector110
vector110:
  pushl $0
80106115:	6a 00                	push   $0x0
  pushl $110
80106117:	6a 6e                	push   $0x6e
  jmp alltraps
80106119:	e9 1c f7 ff ff       	jmp    8010583a <alltraps>

8010611e <vector111>:
.globl vector111
vector111:
  pushl $0
8010611e:	6a 00                	push   $0x0
  pushl $111
80106120:	6a 6f                	push   $0x6f
  jmp alltraps
80106122:	e9 13 f7 ff ff       	jmp    8010583a <alltraps>

80106127 <vector112>:
.globl vector112
vector112:
  pushl $0
80106127:	6a 00                	push   $0x0
  pushl $112
80106129:	6a 70                	push   $0x70
  jmp alltraps
8010612b:	e9 0a f7 ff ff       	jmp    8010583a <alltraps>

80106130 <vector113>:
.globl vector113
vector113:
  pushl $0
80106130:	6a 00                	push   $0x0
  pushl $113
80106132:	6a 71                	push   $0x71
  jmp alltraps
80106134:	e9 01 f7 ff ff       	jmp    8010583a <alltraps>

80106139 <vector114>:
.globl vector114
vector114:
  pushl $0
80106139:	6a 00                	push   $0x0
  pushl $114
8010613b:	6a 72                	push   $0x72
  jmp alltraps
8010613d:	e9 f8 f6 ff ff       	jmp    8010583a <alltraps>

80106142 <vector115>:
.globl vector115
vector115:
  pushl $0
80106142:	6a 00                	push   $0x0
  pushl $115
80106144:	6a 73                	push   $0x73
  jmp alltraps
80106146:	e9 ef f6 ff ff       	jmp    8010583a <alltraps>

8010614b <vector116>:
.globl vector116
vector116:
  pushl $0
8010614b:	6a 00                	push   $0x0
  pushl $116
8010614d:	6a 74                	push   $0x74
  jmp alltraps
8010614f:	e9 e6 f6 ff ff       	jmp    8010583a <alltraps>

80106154 <vector117>:
.globl vector117
vector117:
  pushl $0
80106154:	6a 00                	push   $0x0
  pushl $117
80106156:	6a 75                	push   $0x75
  jmp alltraps
80106158:	e9 dd f6 ff ff       	jmp    8010583a <alltraps>

8010615d <vector118>:
.globl vector118
vector118:
  pushl $0
8010615d:	6a 00                	push   $0x0
  pushl $118
8010615f:	6a 76                	push   $0x76
  jmp alltraps
80106161:	e9 d4 f6 ff ff       	jmp    8010583a <alltraps>

80106166 <vector119>:
.globl vector119
vector119:
  pushl $0
80106166:	6a 00                	push   $0x0
  pushl $119
80106168:	6a 77                	push   $0x77
  jmp alltraps
8010616a:	e9 cb f6 ff ff       	jmp    8010583a <alltraps>

8010616f <vector120>:
.globl vector120
vector120:
  pushl $0
8010616f:	6a 00                	push   $0x0
  pushl $120
80106171:	6a 78                	push   $0x78
  jmp alltraps
80106173:	e9 c2 f6 ff ff       	jmp    8010583a <alltraps>

80106178 <vector121>:
.globl vector121
vector121:
  pushl $0
80106178:	6a 00                	push   $0x0
  pushl $121
8010617a:	6a 79                	push   $0x79
  jmp alltraps
8010617c:	e9 b9 f6 ff ff       	jmp    8010583a <alltraps>

80106181 <vector122>:
.globl vector122
vector122:
  pushl $0
80106181:	6a 00                	push   $0x0
  pushl $122
80106183:	6a 7a                	push   $0x7a
  jmp alltraps
80106185:	e9 b0 f6 ff ff       	jmp    8010583a <alltraps>

8010618a <vector123>:
.globl vector123
vector123:
  pushl $0
8010618a:	6a 00                	push   $0x0
  pushl $123
8010618c:	6a 7b                	push   $0x7b
  jmp alltraps
8010618e:	e9 a7 f6 ff ff       	jmp    8010583a <alltraps>

80106193 <vector124>:
.globl vector124
vector124:
  pushl $0
80106193:	6a 00                	push   $0x0
  pushl $124
80106195:	6a 7c                	push   $0x7c
  jmp alltraps
80106197:	e9 9e f6 ff ff       	jmp    8010583a <alltraps>

8010619c <vector125>:
.globl vector125
vector125:
  pushl $0
8010619c:	6a 00                	push   $0x0
  pushl $125
8010619e:	6a 7d                	push   $0x7d
  jmp alltraps
801061a0:	e9 95 f6 ff ff       	jmp    8010583a <alltraps>

801061a5 <vector126>:
.globl vector126
vector126:
  pushl $0
801061a5:	6a 00                	push   $0x0
  pushl $126
801061a7:	6a 7e                	push   $0x7e
  jmp alltraps
801061a9:	e9 8c f6 ff ff       	jmp    8010583a <alltraps>

801061ae <vector127>:
.globl vector127
vector127:
  pushl $0
801061ae:	6a 00                	push   $0x0
  pushl $127
801061b0:	6a 7f                	push   $0x7f
  jmp alltraps
801061b2:	e9 83 f6 ff ff       	jmp    8010583a <alltraps>

801061b7 <vector128>:
.globl vector128
vector128:
  pushl $0
801061b7:	6a 00                	push   $0x0
  pushl $128
801061b9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801061be:	e9 77 f6 ff ff       	jmp    8010583a <alltraps>

801061c3 <vector129>:
.globl vector129
vector129:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $129
801061c5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801061ca:	e9 6b f6 ff ff       	jmp    8010583a <alltraps>

801061cf <vector130>:
.globl vector130
vector130:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $130
801061d1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801061d6:	e9 5f f6 ff ff       	jmp    8010583a <alltraps>

801061db <vector131>:
.globl vector131
vector131:
  pushl $0
801061db:	6a 00                	push   $0x0
  pushl $131
801061dd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801061e2:	e9 53 f6 ff ff       	jmp    8010583a <alltraps>

801061e7 <vector132>:
.globl vector132
vector132:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $132
801061e9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801061ee:	e9 47 f6 ff ff       	jmp    8010583a <alltraps>

801061f3 <vector133>:
.globl vector133
vector133:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $133
801061f5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801061fa:	e9 3b f6 ff ff       	jmp    8010583a <alltraps>

801061ff <vector134>:
.globl vector134
vector134:
  pushl $0
801061ff:	6a 00                	push   $0x0
  pushl $134
80106201:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106206:	e9 2f f6 ff ff       	jmp    8010583a <alltraps>

8010620b <vector135>:
.globl vector135
vector135:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $135
8010620d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106212:	e9 23 f6 ff ff       	jmp    8010583a <alltraps>

80106217 <vector136>:
.globl vector136
vector136:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $136
80106219:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010621e:	e9 17 f6 ff ff       	jmp    8010583a <alltraps>

80106223 <vector137>:
.globl vector137
vector137:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $137
80106225:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010622a:	e9 0b f6 ff ff       	jmp    8010583a <alltraps>

8010622f <vector138>:
.globl vector138
vector138:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $138
80106231:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106236:	e9 ff f5 ff ff       	jmp    8010583a <alltraps>

8010623b <vector139>:
.globl vector139
vector139:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $139
8010623d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106242:	e9 f3 f5 ff ff       	jmp    8010583a <alltraps>

80106247 <vector140>:
.globl vector140
vector140:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $140
80106249:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010624e:	e9 e7 f5 ff ff       	jmp    8010583a <alltraps>

80106253 <vector141>:
.globl vector141
vector141:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $141
80106255:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010625a:	e9 db f5 ff ff       	jmp    8010583a <alltraps>

8010625f <vector142>:
.globl vector142
vector142:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $142
80106261:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106266:	e9 cf f5 ff ff       	jmp    8010583a <alltraps>

8010626b <vector143>:
.globl vector143
vector143:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $143
8010626d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106272:	e9 c3 f5 ff ff       	jmp    8010583a <alltraps>

80106277 <vector144>:
.globl vector144
vector144:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $144
80106279:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010627e:	e9 b7 f5 ff ff       	jmp    8010583a <alltraps>

80106283 <vector145>:
.globl vector145
vector145:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $145
80106285:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010628a:	e9 ab f5 ff ff       	jmp    8010583a <alltraps>

8010628f <vector146>:
.globl vector146
vector146:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $146
80106291:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106296:	e9 9f f5 ff ff       	jmp    8010583a <alltraps>

8010629b <vector147>:
.globl vector147
vector147:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $147
8010629d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801062a2:	e9 93 f5 ff ff       	jmp    8010583a <alltraps>

801062a7 <vector148>:
.globl vector148
vector148:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $148
801062a9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801062ae:	e9 87 f5 ff ff       	jmp    8010583a <alltraps>

801062b3 <vector149>:
.globl vector149
vector149:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $149
801062b5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801062ba:	e9 7b f5 ff ff       	jmp    8010583a <alltraps>

801062bf <vector150>:
.globl vector150
vector150:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $150
801062c1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801062c6:	e9 6f f5 ff ff       	jmp    8010583a <alltraps>

801062cb <vector151>:
.globl vector151
vector151:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $151
801062cd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801062d2:	e9 63 f5 ff ff       	jmp    8010583a <alltraps>

801062d7 <vector152>:
.globl vector152
vector152:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $152
801062d9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801062de:	e9 57 f5 ff ff       	jmp    8010583a <alltraps>

801062e3 <vector153>:
.globl vector153
vector153:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $153
801062e5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801062ea:	e9 4b f5 ff ff       	jmp    8010583a <alltraps>

801062ef <vector154>:
.globl vector154
vector154:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $154
801062f1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801062f6:	e9 3f f5 ff ff       	jmp    8010583a <alltraps>

801062fb <vector155>:
.globl vector155
vector155:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $155
801062fd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106302:	e9 33 f5 ff ff       	jmp    8010583a <alltraps>

80106307 <vector156>:
.globl vector156
vector156:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $156
80106309:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010630e:	e9 27 f5 ff ff       	jmp    8010583a <alltraps>

80106313 <vector157>:
.globl vector157
vector157:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $157
80106315:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010631a:	e9 1b f5 ff ff       	jmp    8010583a <alltraps>

8010631f <vector158>:
.globl vector158
vector158:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $158
80106321:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106326:	e9 0f f5 ff ff       	jmp    8010583a <alltraps>

8010632b <vector159>:
.globl vector159
vector159:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $159
8010632d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106332:	e9 03 f5 ff ff       	jmp    8010583a <alltraps>

80106337 <vector160>:
.globl vector160
vector160:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $160
80106339:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010633e:	e9 f7 f4 ff ff       	jmp    8010583a <alltraps>

80106343 <vector161>:
.globl vector161
vector161:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $161
80106345:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010634a:	e9 eb f4 ff ff       	jmp    8010583a <alltraps>

8010634f <vector162>:
.globl vector162
vector162:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $162
80106351:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106356:	e9 df f4 ff ff       	jmp    8010583a <alltraps>

8010635b <vector163>:
.globl vector163
vector163:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $163
8010635d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106362:	e9 d3 f4 ff ff       	jmp    8010583a <alltraps>

80106367 <vector164>:
.globl vector164
vector164:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $164
80106369:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010636e:	e9 c7 f4 ff ff       	jmp    8010583a <alltraps>

80106373 <vector165>:
.globl vector165
vector165:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $165
80106375:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010637a:	e9 bb f4 ff ff       	jmp    8010583a <alltraps>

8010637f <vector166>:
.globl vector166
vector166:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $166
80106381:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106386:	e9 af f4 ff ff       	jmp    8010583a <alltraps>

8010638b <vector167>:
.globl vector167
vector167:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $167
8010638d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106392:	e9 a3 f4 ff ff       	jmp    8010583a <alltraps>

80106397 <vector168>:
.globl vector168
vector168:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $168
80106399:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010639e:	e9 97 f4 ff ff       	jmp    8010583a <alltraps>

801063a3 <vector169>:
.globl vector169
vector169:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $169
801063a5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801063aa:	e9 8b f4 ff ff       	jmp    8010583a <alltraps>

801063af <vector170>:
.globl vector170
vector170:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $170
801063b1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801063b6:	e9 7f f4 ff ff       	jmp    8010583a <alltraps>

801063bb <vector171>:
.globl vector171
vector171:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $171
801063bd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801063c2:	e9 73 f4 ff ff       	jmp    8010583a <alltraps>

801063c7 <vector172>:
.globl vector172
vector172:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $172
801063c9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801063ce:	e9 67 f4 ff ff       	jmp    8010583a <alltraps>

801063d3 <vector173>:
.globl vector173
vector173:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $173
801063d5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801063da:	e9 5b f4 ff ff       	jmp    8010583a <alltraps>

801063df <vector174>:
.globl vector174
vector174:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $174
801063e1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801063e6:	e9 4f f4 ff ff       	jmp    8010583a <alltraps>

801063eb <vector175>:
.globl vector175
vector175:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $175
801063ed:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801063f2:	e9 43 f4 ff ff       	jmp    8010583a <alltraps>

801063f7 <vector176>:
.globl vector176
vector176:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $176
801063f9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801063fe:	e9 37 f4 ff ff       	jmp    8010583a <alltraps>

80106403 <vector177>:
.globl vector177
vector177:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $177
80106405:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010640a:	e9 2b f4 ff ff       	jmp    8010583a <alltraps>

8010640f <vector178>:
.globl vector178
vector178:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $178
80106411:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106416:	e9 1f f4 ff ff       	jmp    8010583a <alltraps>

8010641b <vector179>:
.globl vector179
vector179:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $179
8010641d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106422:	e9 13 f4 ff ff       	jmp    8010583a <alltraps>

80106427 <vector180>:
.globl vector180
vector180:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $180
80106429:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010642e:	e9 07 f4 ff ff       	jmp    8010583a <alltraps>

80106433 <vector181>:
.globl vector181
vector181:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $181
80106435:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010643a:	e9 fb f3 ff ff       	jmp    8010583a <alltraps>

8010643f <vector182>:
.globl vector182
vector182:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $182
80106441:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106446:	e9 ef f3 ff ff       	jmp    8010583a <alltraps>

8010644b <vector183>:
.globl vector183
vector183:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $183
8010644d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106452:	e9 e3 f3 ff ff       	jmp    8010583a <alltraps>

80106457 <vector184>:
.globl vector184
vector184:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $184
80106459:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010645e:	e9 d7 f3 ff ff       	jmp    8010583a <alltraps>

80106463 <vector185>:
.globl vector185
vector185:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $185
80106465:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010646a:	e9 cb f3 ff ff       	jmp    8010583a <alltraps>

8010646f <vector186>:
.globl vector186
vector186:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $186
80106471:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106476:	e9 bf f3 ff ff       	jmp    8010583a <alltraps>

8010647b <vector187>:
.globl vector187
vector187:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $187
8010647d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106482:	e9 b3 f3 ff ff       	jmp    8010583a <alltraps>

80106487 <vector188>:
.globl vector188
vector188:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $188
80106489:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010648e:	e9 a7 f3 ff ff       	jmp    8010583a <alltraps>

80106493 <vector189>:
.globl vector189
vector189:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $189
80106495:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010649a:	e9 9b f3 ff ff       	jmp    8010583a <alltraps>

8010649f <vector190>:
.globl vector190
vector190:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $190
801064a1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801064a6:	e9 8f f3 ff ff       	jmp    8010583a <alltraps>

801064ab <vector191>:
.globl vector191
vector191:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $191
801064ad:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801064b2:	e9 83 f3 ff ff       	jmp    8010583a <alltraps>

801064b7 <vector192>:
.globl vector192
vector192:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $192
801064b9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801064be:	e9 77 f3 ff ff       	jmp    8010583a <alltraps>

801064c3 <vector193>:
.globl vector193
vector193:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $193
801064c5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801064ca:	e9 6b f3 ff ff       	jmp    8010583a <alltraps>

801064cf <vector194>:
.globl vector194
vector194:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $194
801064d1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801064d6:	e9 5f f3 ff ff       	jmp    8010583a <alltraps>

801064db <vector195>:
.globl vector195
vector195:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $195
801064dd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801064e2:	e9 53 f3 ff ff       	jmp    8010583a <alltraps>

801064e7 <vector196>:
.globl vector196
vector196:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $196
801064e9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801064ee:	e9 47 f3 ff ff       	jmp    8010583a <alltraps>

801064f3 <vector197>:
.globl vector197
vector197:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $197
801064f5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801064fa:	e9 3b f3 ff ff       	jmp    8010583a <alltraps>

801064ff <vector198>:
.globl vector198
vector198:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $198
80106501:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106506:	e9 2f f3 ff ff       	jmp    8010583a <alltraps>

8010650b <vector199>:
.globl vector199
vector199:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $199
8010650d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106512:	e9 23 f3 ff ff       	jmp    8010583a <alltraps>

80106517 <vector200>:
.globl vector200
vector200:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $200
80106519:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010651e:	e9 17 f3 ff ff       	jmp    8010583a <alltraps>

80106523 <vector201>:
.globl vector201
vector201:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $201
80106525:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010652a:	e9 0b f3 ff ff       	jmp    8010583a <alltraps>

8010652f <vector202>:
.globl vector202
vector202:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $202
80106531:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106536:	e9 ff f2 ff ff       	jmp    8010583a <alltraps>

8010653b <vector203>:
.globl vector203
vector203:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $203
8010653d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106542:	e9 f3 f2 ff ff       	jmp    8010583a <alltraps>

80106547 <vector204>:
.globl vector204
vector204:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $204
80106549:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010654e:	e9 e7 f2 ff ff       	jmp    8010583a <alltraps>

80106553 <vector205>:
.globl vector205
vector205:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $205
80106555:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010655a:	e9 db f2 ff ff       	jmp    8010583a <alltraps>

8010655f <vector206>:
.globl vector206
vector206:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $206
80106561:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106566:	e9 cf f2 ff ff       	jmp    8010583a <alltraps>

8010656b <vector207>:
.globl vector207
vector207:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $207
8010656d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106572:	e9 c3 f2 ff ff       	jmp    8010583a <alltraps>

80106577 <vector208>:
.globl vector208
vector208:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $208
80106579:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010657e:	e9 b7 f2 ff ff       	jmp    8010583a <alltraps>

80106583 <vector209>:
.globl vector209
vector209:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $209
80106585:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010658a:	e9 ab f2 ff ff       	jmp    8010583a <alltraps>

8010658f <vector210>:
.globl vector210
vector210:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $210
80106591:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106596:	e9 9f f2 ff ff       	jmp    8010583a <alltraps>

8010659b <vector211>:
.globl vector211
vector211:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $211
8010659d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801065a2:	e9 93 f2 ff ff       	jmp    8010583a <alltraps>

801065a7 <vector212>:
.globl vector212
vector212:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $212
801065a9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801065ae:	e9 87 f2 ff ff       	jmp    8010583a <alltraps>

801065b3 <vector213>:
.globl vector213
vector213:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $213
801065b5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801065ba:	e9 7b f2 ff ff       	jmp    8010583a <alltraps>

801065bf <vector214>:
.globl vector214
vector214:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $214
801065c1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801065c6:	e9 6f f2 ff ff       	jmp    8010583a <alltraps>

801065cb <vector215>:
.globl vector215
vector215:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $215
801065cd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801065d2:	e9 63 f2 ff ff       	jmp    8010583a <alltraps>

801065d7 <vector216>:
.globl vector216
vector216:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $216
801065d9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801065de:	e9 57 f2 ff ff       	jmp    8010583a <alltraps>

801065e3 <vector217>:
.globl vector217
vector217:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $217
801065e5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801065ea:	e9 4b f2 ff ff       	jmp    8010583a <alltraps>

801065ef <vector218>:
.globl vector218
vector218:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $218
801065f1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801065f6:	e9 3f f2 ff ff       	jmp    8010583a <alltraps>

801065fb <vector219>:
.globl vector219
vector219:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $219
801065fd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106602:	e9 33 f2 ff ff       	jmp    8010583a <alltraps>

80106607 <vector220>:
.globl vector220
vector220:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $220
80106609:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010660e:	e9 27 f2 ff ff       	jmp    8010583a <alltraps>

80106613 <vector221>:
.globl vector221
vector221:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $221
80106615:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010661a:	e9 1b f2 ff ff       	jmp    8010583a <alltraps>

8010661f <vector222>:
.globl vector222
vector222:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $222
80106621:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106626:	e9 0f f2 ff ff       	jmp    8010583a <alltraps>

8010662b <vector223>:
.globl vector223
vector223:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $223
8010662d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106632:	e9 03 f2 ff ff       	jmp    8010583a <alltraps>

80106637 <vector224>:
.globl vector224
vector224:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $224
80106639:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010663e:	e9 f7 f1 ff ff       	jmp    8010583a <alltraps>

80106643 <vector225>:
.globl vector225
vector225:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $225
80106645:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010664a:	e9 eb f1 ff ff       	jmp    8010583a <alltraps>

8010664f <vector226>:
.globl vector226
vector226:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $226
80106651:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106656:	e9 df f1 ff ff       	jmp    8010583a <alltraps>

8010665b <vector227>:
.globl vector227
vector227:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $227
8010665d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106662:	e9 d3 f1 ff ff       	jmp    8010583a <alltraps>

80106667 <vector228>:
.globl vector228
vector228:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $228
80106669:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010666e:	e9 c7 f1 ff ff       	jmp    8010583a <alltraps>

80106673 <vector229>:
.globl vector229
vector229:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $229
80106675:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010667a:	e9 bb f1 ff ff       	jmp    8010583a <alltraps>

8010667f <vector230>:
.globl vector230
vector230:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $230
80106681:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106686:	e9 af f1 ff ff       	jmp    8010583a <alltraps>

8010668b <vector231>:
.globl vector231
vector231:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $231
8010668d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106692:	e9 a3 f1 ff ff       	jmp    8010583a <alltraps>

80106697 <vector232>:
.globl vector232
vector232:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $232
80106699:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010669e:	e9 97 f1 ff ff       	jmp    8010583a <alltraps>

801066a3 <vector233>:
.globl vector233
vector233:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $233
801066a5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801066aa:	e9 8b f1 ff ff       	jmp    8010583a <alltraps>

801066af <vector234>:
.globl vector234
vector234:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $234
801066b1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801066b6:	e9 7f f1 ff ff       	jmp    8010583a <alltraps>

801066bb <vector235>:
.globl vector235
vector235:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $235
801066bd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801066c2:	e9 73 f1 ff ff       	jmp    8010583a <alltraps>

801066c7 <vector236>:
.globl vector236
vector236:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $236
801066c9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801066ce:	e9 67 f1 ff ff       	jmp    8010583a <alltraps>

801066d3 <vector237>:
.globl vector237
vector237:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $237
801066d5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801066da:	e9 5b f1 ff ff       	jmp    8010583a <alltraps>

801066df <vector238>:
.globl vector238
vector238:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $238
801066e1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801066e6:	e9 4f f1 ff ff       	jmp    8010583a <alltraps>

801066eb <vector239>:
.globl vector239
vector239:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $239
801066ed:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801066f2:	e9 43 f1 ff ff       	jmp    8010583a <alltraps>

801066f7 <vector240>:
.globl vector240
vector240:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $240
801066f9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801066fe:	e9 37 f1 ff ff       	jmp    8010583a <alltraps>

80106703 <vector241>:
.globl vector241
vector241:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $241
80106705:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010670a:	e9 2b f1 ff ff       	jmp    8010583a <alltraps>

8010670f <vector242>:
.globl vector242
vector242:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $242
80106711:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106716:	e9 1f f1 ff ff       	jmp    8010583a <alltraps>

8010671b <vector243>:
.globl vector243
vector243:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $243
8010671d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106722:	e9 13 f1 ff ff       	jmp    8010583a <alltraps>

80106727 <vector244>:
.globl vector244
vector244:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $244
80106729:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010672e:	e9 07 f1 ff ff       	jmp    8010583a <alltraps>

80106733 <vector245>:
.globl vector245
vector245:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $245
80106735:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010673a:	e9 fb f0 ff ff       	jmp    8010583a <alltraps>

8010673f <vector246>:
.globl vector246
vector246:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $246
80106741:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106746:	e9 ef f0 ff ff       	jmp    8010583a <alltraps>

8010674b <vector247>:
.globl vector247
vector247:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $247
8010674d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106752:	e9 e3 f0 ff ff       	jmp    8010583a <alltraps>

80106757 <vector248>:
.globl vector248
vector248:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $248
80106759:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010675e:	e9 d7 f0 ff ff       	jmp    8010583a <alltraps>

80106763 <vector249>:
.globl vector249
vector249:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $249
80106765:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010676a:	e9 cb f0 ff ff       	jmp    8010583a <alltraps>

8010676f <vector250>:
.globl vector250
vector250:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $250
80106771:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106776:	e9 bf f0 ff ff       	jmp    8010583a <alltraps>

8010677b <vector251>:
.globl vector251
vector251:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $251
8010677d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106782:	e9 b3 f0 ff ff       	jmp    8010583a <alltraps>

80106787 <vector252>:
.globl vector252
vector252:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $252
80106789:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010678e:	e9 a7 f0 ff ff       	jmp    8010583a <alltraps>

80106793 <vector253>:
.globl vector253
vector253:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $253
80106795:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010679a:	e9 9b f0 ff ff       	jmp    8010583a <alltraps>

8010679f <vector254>:
.globl vector254
vector254:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $254
801067a1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801067a6:	e9 8f f0 ff ff       	jmp    8010583a <alltraps>

801067ab <vector255>:
.globl vector255
vector255:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $255
801067ad:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801067b2:	e9 83 f0 ff ff       	jmp    8010583a <alltraps>
801067b7:	66 90                	xchg   %ax,%ax
801067b9:	66 90                	xchg   %ax,%ax
801067bb:	66 90                	xchg   %ax,%ax
801067bd:	66 90                	xchg   %ax,%ax
801067bf:	90                   	nop

801067c0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801067c0:	55                   	push   %ebp
801067c1:	89 e5                	mov    %esp,%ebp
801067c3:	57                   	push   %edi
801067c4:	56                   	push   %esi
801067c5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801067c6:	89 d3                	mov    %edx,%ebx
{
801067c8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
801067ca:	c1 eb 16             	shr    $0x16,%ebx
801067cd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
801067d0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801067d3:	8b 06                	mov    (%esi),%eax
801067d5:	a8 01                	test   $0x1,%al
801067d7:	74 27                	je     80106800 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801067d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801067de:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801067e4:	c1 ef 0a             	shr    $0xa,%edi
}
801067e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801067ea:	89 fa                	mov    %edi,%edx
801067ec:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801067f2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801067f5:	5b                   	pop    %ebx
801067f6:	5e                   	pop    %esi
801067f7:	5f                   	pop    %edi
801067f8:	5d                   	pop    %ebp
801067f9:	c3                   	ret    
801067fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106800:	85 c9                	test   %ecx,%ecx
80106802:	74 2c                	je     80106830 <walkpgdir+0x70>
80106804:	e8 c7 bc ff ff       	call   801024d0 <kalloc>
80106809:	85 c0                	test   %eax,%eax
8010680b:	89 c3                	mov    %eax,%ebx
8010680d:	74 21                	je     80106830 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010680f:	83 ec 04             	sub    $0x4,%esp
80106812:	68 00 10 00 00       	push   $0x1000
80106817:	6a 00                	push   $0x0
80106819:	50                   	push   %eax
8010681a:	e8 c1 dd ff ff       	call   801045e0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010681f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106825:	83 c4 10             	add    $0x10,%esp
80106828:	83 c8 07             	or     $0x7,%eax
8010682b:	89 06                	mov    %eax,(%esi)
8010682d:	eb b5                	jmp    801067e4 <walkpgdir+0x24>
8010682f:	90                   	nop
}
80106830:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106833:	31 c0                	xor    %eax,%eax
}
80106835:	5b                   	pop    %ebx
80106836:	5e                   	pop    %esi
80106837:	5f                   	pop    %edi
80106838:	5d                   	pop    %ebp
80106839:	c3                   	ret    
8010683a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106840 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106840:	55                   	push   %ebp
80106841:	89 e5                	mov    %esp,%ebp
80106843:	57                   	push   %edi
80106844:	56                   	push   %esi
80106845:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106846:	89 d3                	mov    %edx,%ebx
80106848:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010684e:	83 ec 1c             	sub    $0x1c,%esp
80106851:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106854:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106858:	8b 7d 08             	mov    0x8(%ebp),%edi
8010685b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106860:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106863:	8b 45 0c             	mov    0xc(%ebp),%eax
80106866:	29 df                	sub    %ebx,%edi
80106868:	83 c8 01             	or     $0x1,%eax
8010686b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010686e:	eb 15                	jmp    80106885 <mappages+0x45>
    if(*pte & PTE_P)
80106870:	f6 00 01             	testb  $0x1,(%eax)
80106873:	75 45                	jne    801068ba <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106875:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106878:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010687b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010687d:	74 31                	je     801068b0 <mappages+0x70>
      break;
    a += PGSIZE;
8010687f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106885:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106888:	b9 01 00 00 00       	mov    $0x1,%ecx
8010688d:	89 da                	mov    %ebx,%edx
8010688f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106892:	e8 29 ff ff ff       	call   801067c0 <walkpgdir>
80106897:	85 c0                	test   %eax,%eax
80106899:	75 d5                	jne    80106870 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010689b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010689e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801068a3:	5b                   	pop    %ebx
801068a4:	5e                   	pop    %esi
801068a5:	5f                   	pop    %edi
801068a6:	5d                   	pop    %ebp
801068a7:	c3                   	ret    
801068a8:	90                   	nop
801068a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801068b3:	31 c0                	xor    %eax,%eax
}
801068b5:	5b                   	pop    %ebx
801068b6:	5e                   	pop    %esi
801068b7:	5f                   	pop    %edi
801068b8:	5d                   	pop    %ebp
801068b9:	c3                   	ret    
      panic("remap");
801068ba:	83 ec 0c             	sub    $0xc,%esp
801068bd:	68 d8 79 10 80       	push   $0x801079d8
801068c2:	e8 c9 9a ff ff       	call   80100390 <panic>
801068c7:	89 f6                	mov    %esi,%esi
801068c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068d0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801068d0:	55                   	push   %ebp
801068d1:	89 e5                	mov    %esp,%ebp
801068d3:	57                   	push   %edi
801068d4:	56                   	push   %esi
801068d5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801068d6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801068dc:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
801068de:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801068e4:	83 ec 1c             	sub    $0x1c,%esp
801068e7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801068ea:	39 d3                	cmp    %edx,%ebx
801068ec:	73 66                	jae    80106954 <deallocuvm.part.0+0x84>
801068ee:	89 d6                	mov    %edx,%esi
801068f0:	eb 3d                	jmp    8010692f <deallocuvm.part.0+0x5f>
801068f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801068f8:	8b 10                	mov    (%eax),%edx
801068fa:	f6 c2 01             	test   $0x1,%dl
801068fd:	74 26                	je     80106925 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801068ff:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106905:	74 58                	je     8010695f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106907:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010690a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106910:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106913:	52                   	push   %edx
80106914:	e8 07 ba ff ff       	call   80102320 <kfree>
      *pte = 0;
80106919:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010691c:	83 c4 10             	add    $0x10,%esp
8010691f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106925:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010692b:	39 f3                	cmp    %esi,%ebx
8010692d:	73 25                	jae    80106954 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010692f:	31 c9                	xor    %ecx,%ecx
80106931:	89 da                	mov    %ebx,%edx
80106933:	89 f8                	mov    %edi,%eax
80106935:	e8 86 fe ff ff       	call   801067c0 <walkpgdir>
    if(!pte)
8010693a:	85 c0                	test   %eax,%eax
8010693c:	75 ba                	jne    801068f8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010693e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106944:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010694a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106950:	39 f3                	cmp    %esi,%ebx
80106952:	72 db                	jb     8010692f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106954:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106957:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010695a:	5b                   	pop    %ebx
8010695b:	5e                   	pop    %esi
8010695c:	5f                   	pop    %edi
8010695d:	5d                   	pop    %ebp
8010695e:	c3                   	ret    
        panic("kfree");
8010695f:	83 ec 0c             	sub    $0xc,%esp
80106962:	68 66 73 10 80       	push   $0x80107366
80106967:	e8 24 9a ff ff       	call   80100390 <panic>
8010696c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106970 <seginit>:
{
80106970:	55                   	push   %ebp
80106971:	89 e5                	mov    %esp,%ebp
80106973:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106976:	e8 85 ce ff ff       	call   80103800 <cpuid>
8010697b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106981:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106986:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010698a:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106991:	ff 00 00 
80106994:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
8010699b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010699e:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
801069a5:	ff 00 00 
801069a8:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
801069af:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801069b2:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
801069b9:	ff 00 00 
801069bc:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
801069c3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801069c6:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
801069cd:	ff 00 00 
801069d0:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
801069d7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801069da:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
801069df:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801069e3:	c1 e8 10             	shr    $0x10,%eax
801069e6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801069ea:	8d 45 f2             	lea    -0xe(%ebp),%eax
801069ed:	0f 01 10             	lgdtl  (%eax)
}
801069f0:	c9                   	leave  
801069f1:	c3                   	ret    
801069f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a00 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106a00:	a1 a4 6d 11 80       	mov    0x80116da4,%eax
{
80106a05:	55                   	push   %ebp
80106a06:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106a08:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a0d:	0f 22 d8             	mov    %eax,%cr3
}
80106a10:	5d                   	pop    %ebp
80106a11:	c3                   	ret    
80106a12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a20 <switchuvm>:
{
80106a20:	55                   	push   %ebp
80106a21:	89 e5                	mov    %esp,%ebp
80106a23:	57                   	push   %edi
80106a24:	56                   	push   %esi
80106a25:	53                   	push   %ebx
80106a26:	83 ec 1c             	sub    $0x1c,%esp
80106a29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106a2c:	85 db                	test   %ebx,%ebx
80106a2e:	0f 84 cb 00 00 00    	je     80106aff <switchuvm+0xdf>
  if(p->kstack == 0)
80106a34:	8b 43 6c             	mov    0x6c(%ebx),%eax
80106a37:	85 c0                	test   %eax,%eax
80106a39:	0f 84 da 00 00 00    	je     80106b19 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106a3f:	8b 43 68             	mov    0x68(%ebx),%eax
80106a42:	85 c0                	test   %eax,%eax
80106a44:	0f 84 c2 00 00 00    	je     80106b0c <switchuvm+0xec>
  pushcli();
80106a4a:	e8 b1 d9 ff ff       	call   80104400 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106a4f:	e8 2c cd ff ff       	call   80103780 <mycpu>
80106a54:	89 c6                	mov    %eax,%esi
80106a56:	e8 25 cd ff ff       	call   80103780 <mycpu>
80106a5b:	89 c7                	mov    %eax,%edi
80106a5d:	e8 1e cd ff ff       	call   80103780 <mycpu>
80106a62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a65:	83 c7 08             	add    $0x8,%edi
80106a68:	e8 13 cd ff ff       	call   80103780 <mycpu>
80106a6d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106a70:	83 c0 08             	add    $0x8,%eax
80106a73:	ba 67 00 00 00       	mov    $0x67,%edx
80106a78:	c1 e8 18             	shr    $0x18,%eax
80106a7b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106a82:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106a89:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106a8f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106a94:	83 c1 08             	add    $0x8,%ecx
80106a97:	c1 e9 10             	shr    $0x10,%ecx
80106a9a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106aa0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106aa5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106aac:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106ab1:	e8 ca cc ff ff       	call   80103780 <mycpu>
80106ab6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106abd:	e8 be cc ff ff       	call   80103780 <mycpu>
80106ac2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106ac6:	8b 73 6c             	mov    0x6c(%ebx),%esi
80106ac9:	e8 b2 cc ff ff       	call   80103780 <mycpu>
80106ace:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106ad4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ad7:	e8 a4 cc ff ff       	call   80103780 <mycpu>
80106adc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106ae0:	b8 28 00 00 00       	mov    $0x28,%eax
80106ae5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106ae8:	8b 43 68             	mov    0x68(%ebx),%eax
80106aeb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106af0:	0f 22 d8             	mov    %eax,%cr3
}
80106af3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106af6:	5b                   	pop    %ebx
80106af7:	5e                   	pop    %esi
80106af8:	5f                   	pop    %edi
80106af9:	5d                   	pop    %ebp
  popcli();
80106afa:	e9 41 d9 ff ff       	jmp    80104440 <popcli>
    panic("switchuvm: no process");
80106aff:	83 ec 0c             	sub    $0xc,%esp
80106b02:	68 de 79 10 80       	push   $0x801079de
80106b07:	e8 84 98 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106b0c:	83 ec 0c             	sub    $0xc,%esp
80106b0f:	68 09 7a 10 80       	push   $0x80107a09
80106b14:	e8 77 98 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106b19:	83 ec 0c             	sub    $0xc,%esp
80106b1c:	68 f4 79 10 80       	push   $0x801079f4
80106b21:	e8 6a 98 ff ff       	call   80100390 <panic>
80106b26:	8d 76 00             	lea    0x0(%esi),%esi
80106b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b30 <inituvm>:
{
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
80106b33:	57                   	push   %edi
80106b34:	56                   	push   %esi
80106b35:	53                   	push   %ebx
80106b36:	83 ec 1c             	sub    $0x1c,%esp
80106b39:	8b 75 10             	mov    0x10(%ebp),%esi
80106b3c:	8b 45 08             	mov    0x8(%ebp),%eax
80106b3f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106b42:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106b48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106b4b:	77 49                	ja     80106b96 <inituvm+0x66>
  mem = kalloc();
80106b4d:	e8 7e b9 ff ff       	call   801024d0 <kalloc>
  memset(mem, 0, PGSIZE);
80106b52:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106b55:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106b57:	68 00 10 00 00       	push   $0x1000
80106b5c:	6a 00                	push   $0x0
80106b5e:	50                   	push   %eax
80106b5f:	e8 7c da ff ff       	call   801045e0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106b64:	58                   	pop    %eax
80106b65:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b6b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106b70:	5a                   	pop    %edx
80106b71:	6a 06                	push   $0x6
80106b73:	50                   	push   %eax
80106b74:	31 d2                	xor    %edx,%edx
80106b76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b79:	e8 c2 fc ff ff       	call   80106840 <mappages>
  memmove(mem, init, sz);
80106b7e:	89 75 10             	mov    %esi,0x10(%ebp)
80106b81:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106b84:	83 c4 10             	add    $0x10,%esp
80106b87:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106b8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b8d:	5b                   	pop    %ebx
80106b8e:	5e                   	pop    %esi
80106b8f:	5f                   	pop    %edi
80106b90:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106b91:	e9 fa da ff ff       	jmp    80104690 <memmove>
    panic("inituvm: more than a page");
80106b96:	83 ec 0c             	sub    $0xc,%esp
80106b99:	68 1d 7a 10 80       	push   $0x80107a1d
80106b9e:	e8 ed 97 ff ff       	call   80100390 <panic>
80106ba3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106bb0 <loaduvm>:
{
80106bb0:	55                   	push   %ebp
80106bb1:	89 e5                	mov    %esp,%ebp
80106bb3:	57                   	push   %edi
80106bb4:	56                   	push   %esi
80106bb5:	53                   	push   %ebx
80106bb6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106bb9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106bc0:	0f 85 91 00 00 00    	jne    80106c57 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106bc6:	8b 75 18             	mov    0x18(%ebp),%esi
80106bc9:	31 db                	xor    %ebx,%ebx
80106bcb:	85 f6                	test   %esi,%esi
80106bcd:	75 1a                	jne    80106be9 <loaduvm+0x39>
80106bcf:	eb 6f                	jmp    80106c40 <loaduvm+0x90>
80106bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bd8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bde:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106be4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106be7:	76 57                	jbe    80106c40 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106be9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106bec:	8b 45 08             	mov    0x8(%ebp),%eax
80106bef:	31 c9                	xor    %ecx,%ecx
80106bf1:	01 da                	add    %ebx,%edx
80106bf3:	e8 c8 fb ff ff       	call   801067c0 <walkpgdir>
80106bf8:	85 c0                	test   %eax,%eax
80106bfa:	74 4e                	je     80106c4a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106bfc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106bfe:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106c01:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106c06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106c0b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106c11:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c14:	01 d9                	add    %ebx,%ecx
80106c16:	05 00 00 00 80       	add    $0x80000000,%eax
80106c1b:	57                   	push   %edi
80106c1c:	51                   	push   %ecx
80106c1d:	50                   	push   %eax
80106c1e:	ff 75 10             	pushl  0x10(%ebp)
80106c21:	e8 3a ad ff ff       	call   80101960 <readi>
80106c26:	83 c4 10             	add    $0x10,%esp
80106c29:	39 f8                	cmp    %edi,%eax
80106c2b:	74 ab                	je     80106bd8 <loaduvm+0x28>
}
80106c2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106c30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c35:	5b                   	pop    %ebx
80106c36:	5e                   	pop    %esi
80106c37:	5f                   	pop    %edi
80106c38:	5d                   	pop    %ebp
80106c39:	c3                   	ret    
80106c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106c43:	31 c0                	xor    %eax,%eax
}
80106c45:	5b                   	pop    %ebx
80106c46:	5e                   	pop    %esi
80106c47:	5f                   	pop    %edi
80106c48:	5d                   	pop    %ebp
80106c49:	c3                   	ret    
      panic("loaduvm: address should exist");
80106c4a:	83 ec 0c             	sub    $0xc,%esp
80106c4d:	68 37 7a 10 80       	push   $0x80107a37
80106c52:	e8 39 97 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106c57:	83 ec 0c             	sub    $0xc,%esp
80106c5a:	68 d8 7a 10 80       	push   $0x80107ad8
80106c5f:	e8 2c 97 ff ff       	call   80100390 <panic>
80106c64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c70 <allocuvm>:
{
80106c70:	55                   	push   %ebp
80106c71:	89 e5                	mov    %esp,%ebp
80106c73:	57                   	push   %edi
80106c74:	56                   	push   %esi
80106c75:	53                   	push   %ebx
80106c76:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106c79:	8b 7d 10             	mov    0x10(%ebp),%edi
80106c7c:	85 ff                	test   %edi,%edi
80106c7e:	0f 88 8e 00 00 00    	js     80106d12 <allocuvm+0xa2>
  if(newsz < oldsz)
80106c84:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106c87:	0f 82 93 00 00 00    	jb     80106d20 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80106c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c90:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106c96:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106c9c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106c9f:	0f 86 7e 00 00 00    	jbe    80106d23 <allocuvm+0xb3>
80106ca5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106ca8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106cab:	eb 42                	jmp    80106cef <allocuvm+0x7f>
80106cad:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106cb0:	83 ec 04             	sub    $0x4,%esp
80106cb3:	68 00 10 00 00       	push   $0x1000
80106cb8:	6a 00                	push   $0x0
80106cba:	50                   	push   %eax
80106cbb:	e8 20 d9 ff ff       	call   801045e0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106cc0:	58                   	pop    %eax
80106cc1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106cc7:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ccc:	5a                   	pop    %edx
80106ccd:	6a 06                	push   $0x6
80106ccf:	50                   	push   %eax
80106cd0:	89 da                	mov    %ebx,%edx
80106cd2:	89 f8                	mov    %edi,%eax
80106cd4:	e8 67 fb ff ff       	call   80106840 <mappages>
80106cd9:	83 c4 10             	add    $0x10,%esp
80106cdc:	85 c0                	test   %eax,%eax
80106cde:	78 50                	js     80106d30 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80106ce0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ce6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106ce9:	0f 86 81 00 00 00    	jbe    80106d70 <allocuvm+0x100>
    mem = kalloc();
80106cef:	e8 dc b7 ff ff       	call   801024d0 <kalloc>
    if(mem == 0){
80106cf4:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106cf6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106cf8:	75 b6                	jne    80106cb0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106cfa:	83 ec 0c             	sub    $0xc,%esp
80106cfd:	68 55 7a 10 80       	push   $0x80107a55
80106d02:	e8 59 99 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106d07:	83 c4 10             	add    $0x10,%esp
80106d0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d0d:	39 45 10             	cmp    %eax,0x10(%ebp)
80106d10:	77 6e                	ja     80106d80 <allocuvm+0x110>
}
80106d12:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106d15:	31 ff                	xor    %edi,%edi
}
80106d17:	89 f8                	mov    %edi,%eax
80106d19:	5b                   	pop    %ebx
80106d1a:	5e                   	pop    %esi
80106d1b:	5f                   	pop    %edi
80106d1c:	5d                   	pop    %ebp
80106d1d:	c3                   	ret    
80106d1e:	66 90                	xchg   %ax,%ax
    return oldsz;
80106d20:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106d23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d26:	89 f8                	mov    %edi,%eax
80106d28:	5b                   	pop    %ebx
80106d29:	5e                   	pop    %esi
80106d2a:	5f                   	pop    %edi
80106d2b:	5d                   	pop    %ebp
80106d2c:	c3                   	ret    
80106d2d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106d30:	83 ec 0c             	sub    $0xc,%esp
80106d33:	68 6d 7a 10 80       	push   $0x80107a6d
80106d38:	e8 23 99 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106d3d:	83 c4 10             	add    $0x10,%esp
80106d40:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d43:	39 45 10             	cmp    %eax,0x10(%ebp)
80106d46:	76 0d                	jbe    80106d55 <allocuvm+0xe5>
80106d48:	89 c1                	mov    %eax,%ecx
80106d4a:	8b 55 10             	mov    0x10(%ebp),%edx
80106d4d:	8b 45 08             	mov    0x8(%ebp),%eax
80106d50:	e8 7b fb ff ff       	call   801068d0 <deallocuvm.part.0>
      kfree(mem);
80106d55:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80106d58:	31 ff                	xor    %edi,%edi
      kfree(mem);
80106d5a:	56                   	push   %esi
80106d5b:	e8 c0 b5 ff ff       	call   80102320 <kfree>
      return 0;
80106d60:	83 c4 10             	add    $0x10,%esp
}
80106d63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d66:	89 f8                	mov    %edi,%eax
80106d68:	5b                   	pop    %ebx
80106d69:	5e                   	pop    %esi
80106d6a:	5f                   	pop    %edi
80106d6b:	5d                   	pop    %ebp
80106d6c:	c3                   	ret    
80106d6d:	8d 76 00             	lea    0x0(%esi),%esi
80106d70:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106d73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d76:	5b                   	pop    %ebx
80106d77:	89 f8                	mov    %edi,%eax
80106d79:	5e                   	pop    %esi
80106d7a:	5f                   	pop    %edi
80106d7b:	5d                   	pop    %ebp
80106d7c:	c3                   	ret    
80106d7d:	8d 76 00             	lea    0x0(%esi),%esi
80106d80:	89 c1                	mov    %eax,%ecx
80106d82:	8b 55 10             	mov    0x10(%ebp),%edx
80106d85:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80106d88:	31 ff                	xor    %edi,%edi
80106d8a:	e8 41 fb ff ff       	call   801068d0 <deallocuvm.part.0>
80106d8f:	eb 92                	jmp    80106d23 <allocuvm+0xb3>
80106d91:	eb 0d                	jmp    80106da0 <deallocuvm>
80106d93:	90                   	nop
80106d94:	90                   	nop
80106d95:	90                   	nop
80106d96:	90                   	nop
80106d97:	90                   	nop
80106d98:	90                   	nop
80106d99:	90                   	nop
80106d9a:	90                   	nop
80106d9b:	90                   	nop
80106d9c:	90                   	nop
80106d9d:	90                   	nop
80106d9e:	90                   	nop
80106d9f:	90                   	nop

80106da0 <deallocuvm>:
{
80106da0:	55                   	push   %ebp
80106da1:	89 e5                	mov    %esp,%ebp
80106da3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106da6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106da9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106dac:	39 d1                	cmp    %edx,%ecx
80106dae:	73 10                	jae    80106dc0 <deallocuvm+0x20>
}
80106db0:	5d                   	pop    %ebp
80106db1:	e9 1a fb ff ff       	jmp    801068d0 <deallocuvm.part.0>
80106db6:	8d 76 00             	lea    0x0(%esi),%esi
80106db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106dc0:	89 d0                	mov    %edx,%eax
80106dc2:	5d                   	pop    %ebp
80106dc3:	c3                   	ret    
80106dc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106dca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106dd0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106dd0:	55                   	push   %ebp
80106dd1:	89 e5                	mov    %esp,%ebp
80106dd3:	57                   	push   %edi
80106dd4:	56                   	push   %esi
80106dd5:	53                   	push   %ebx
80106dd6:	83 ec 0c             	sub    $0xc,%esp
80106dd9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106ddc:	85 f6                	test   %esi,%esi
80106dde:	74 59                	je     80106e39 <freevm+0x69>
80106de0:	31 c9                	xor    %ecx,%ecx
80106de2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106de7:	89 f0                	mov    %esi,%eax
80106de9:	e8 e2 fa ff ff       	call   801068d0 <deallocuvm.part.0>
80106dee:	89 f3                	mov    %esi,%ebx
80106df0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106df6:	eb 0f                	jmp    80106e07 <freevm+0x37>
80106df8:	90                   	nop
80106df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e00:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106e03:	39 fb                	cmp    %edi,%ebx
80106e05:	74 23                	je     80106e2a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106e07:	8b 03                	mov    (%ebx),%eax
80106e09:	a8 01                	test   $0x1,%al
80106e0b:	74 f3                	je     80106e00 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106e0d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106e12:	83 ec 0c             	sub    $0xc,%esp
80106e15:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106e18:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106e1d:	50                   	push   %eax
80106e1e:	e8 fd b4 ff ff       	call   80102320 <kfree>
80106e23:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106e26:	39 fb                	cmp    %edi,%ebx
80106e28:	75 dd                	jne    80106e07 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106e2a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106e2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e30:	5b                   	pop    %ebx
80106e31:	5e                   	pop    %esi
80106e32:	5f                   	pop    %edi
80106e33:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106e34:	e9 e7 b4 ff ff       	jmp    80102320 <kfree>
    panic("freevm: no pgdir");
80106e39:	83 ec 0c             	sub    $0xc,%esp
80106e3c:	68 89 7a 10 80       	push   $0x80107a89
80106e41:	e8 4a 95 ff ff       	call   80100390 <panic>
80106e46:	8d 76 00             	lea    0x0(%esi),%esi
80106e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e50 <setupkvm>:
{
80106e50:	55                   	push   %ebp
80106e51:	89 e5                	mov    %esp,%ebp
80106e53:	56                   	push   %esi
80106e54:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106e55:	e8 76 b6 ff ff       	call   801024d0 <kalloc>
80106e5a:	85 c0                	test   %eax,%eax
80106e5c:	89 c6                	mov    %eax,%esi
80106e5e:	74 42                	je     80106ea2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106e60:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106e63:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106e68:	68 00 10 00 00       	push   $0x1000
80106e6d:	6a 00                	push   $0x0
80106e6f:	50                   	push   %eax
80106e70:	e8 6b d7 ff ff       	call   801045e0 <memset>
80106e75:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106e78:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106e7b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106e7e:	83 ec 08             	sub    $0x8,%esp
80106e81:	8b 13                	mov    (%ebx),%edx
80106e83:	ff 73 0c             	pushl  0xc(%ebx)
80106e86:	50                   	push   %eax
80106e87:	29 c1                	sub    %eax,%ecx
80106e89:	89 f0                	mov    %esi,%eax
80106e8b:	e8 b0 f9 ff ff       	call   80106840 <mappages>
80106e90:	83 c4 10             	add    $0x10,%esp
80106e93:	85 c0                	test   %eax,%eax
80106e95:	78 19                	js     80106eb0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106e97:	83 c3 10             	add    $0x10,%ebx
80106e9a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106ea0:	75 d6                	jne    80106e78 <setupkvm+0x28>
}
80106ea2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106ea5:	89 f0                	mov    %esi,%eax
80106ea7:	5b                   	pop    %ebx
80106ea8:	5e                   	pop    %esi
80106ea9:	5d                   	pop    %ebp
80106eaa:	c3                   	ret    
80106eab:	90                   	nop
80106eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80106eb0:	83 ec 0c             	sub    $0xc,%esp
80106eb3:	56                   	push   %esi
      return 0;
80106eb4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106eb6:	e8 15 ff ff ff       	call   80106dd0 <freevm>
      return 0;
80106ebb:	83 c4 10             	add    $0x10,%esp
}
80106ebe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106ec1:	89 f0                	mov    %esi,%eax
80106ec3:	5b                   	pop    %ebx
80106ec4:	5e                   	pop    %esi
80106ec5:	5d                   	pop    %ebp
80106ec6:	c3                   	ret    
80106ec7:	89 f6                	mov    %esi,%esi
80106ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ed0 <kvmalloc>:
{
80106ed0:	55                   	push   %ebp
80106ed1:	89 e5                	mov    %esp,%ebp
80106ed3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106ed6:	e8 75 ff ff ff       	call   80106e50 <setupkvm>
80106edb:	a3 a4 6d 11 80       	mov    %eax,0x80116da4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ee0:	05 00 00 00 80       	add    $0x80000000,%eax
80106ee5:	0f 22 d8             	mov    %eax,%cr3
}
80106ee8:	c9                   	leave  
80106ee9:	c3                   	ret    
80106eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ef0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106ef0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ef1:	31 c9                	xor    %ecx,%ecx
{
80106ef3:	89 e5                	mov    %esp,%ebp
80106ef5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106ef8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106efb:	8b 45 08             	mov    0x8(%ebp),%eax
80106efe:	e8 bd f8 ff ff       	call   801067c0 <walkpgdir>
  if(pte == 0)
80106f03:	85 c0                	test   %eax,%eax
80106f05:	74 05                	je     80106f0c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106f07:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106f0a:	c9                   	leave  
80106f0b:	c3                   	ret    
    panic("clearpteu");
80106f0c:	83 ec 0c             	sub    $0xc,%esp
80106f0f:	68 9a 7a 10 80       	push   $0x80107a9a
80106f14:	e8 77 94 ff ff       	call   80100390 <panic>
80106f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f20 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	57                   	push   %edi
80106f24:	56                   	push   %esi
80106f25:	53                   	push   %ebx
80106f26:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106f29:	e8 22 ff ff ff       	call   80106e50 <setupkvm>
80106f2e:	85 c0                	test   %eax,%eax
80106f30:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106f33:	0f 84 9f 00 00 00    	je     80106fd8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106f39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106f3c:	85 c9                	test   %ecx,%ecx
80106f3e:	0f 84 94 00 00 00    	je     80106fd8 <copyuvm+0xb8>
80106f44:	31 ff                	xor    %edi,%edi
80106f46:	eb 4a                	jmp    80106f92 <copyuvm+0x72>
80106f48:	90                   	nop
80106f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106f50:	83 ec 04             	sub    $0x4,%esp
80106f53:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80106f59:	68 00 10 00 00       	push   $0x1000
80106f5e:	53                   	push   %ebx
80106f5f:	50                   	push   %eax
80106f60:	e8 2b d7 ff ff       	call   80104690 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106f65:	58                   	pop    %eax
80106f66:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106f6c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f71:	5a                   	pop    %edx
80106f72:	ff 75 e4             	pushl  -0x1c(%ebp)
80106f75:	50                   	push   %eax
80106f76:	89 fa                	mov    %edi,%edx
80106f78:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f7b:	e8 c0 f8 ff ff       	call   80106840 <mappages>
80106f80:	83 c4 10             	add    $0x10,%esp
80106f83:	85 c0                	test   %eax,%eax
80106f85:	78 61                	js     80106fe8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106f87:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106f8d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106f90:	76 46                	jbe    80106fd8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106f92:	8b 45 08             	mov    0x8(%ebp),%eax
80106f95:	31 c9                	xor    %ecx,%ecx
80106f97:	89 fa                	mov    %edi,%edx
80106f99:	e8 22 f8 ff ff       	call   801067c0 <walkpgdir>
80106f9e:	85 c0                	test   %eax,%eax
80106fa0:	74 61                	je     80107003 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80106fa2:	8b 00                	mov    (%eax),%eax
80106fa4:	a8 01                	test   $0x1,%al
80106fa6:	74 4e                	je     80106ff6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80106fa8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80106faa:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
80106faf:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80106fb5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80106fb8:	e8 13 b5 ff ff       	call   801024d0 <kalloc>
80106fbd:	85 c0                	test   %eax,%eax
80106fbf:	89 c6                	mov    %eax,%esi
80106fc1:	75 8d                	jne    80106f50 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80106fc3:	83 ec 0c             	sub    $0xc,%esp
80106fc6:	ff 75 e0             	pushl  -0x20(%ebp)
80106fc9:	e8 02 fe ff ff       	call   80106dd0 <freevm>
  return 0;
80106fce:	83 c4 10             	add    $0x10,%esp
80106fd1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80106fd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106fdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fde:	5b                   	pop    %ebx
80106fdf:	5e                   	pop    %esi
80106fe0:	5f                   	pop    %edi
80106fe1:	5d                   	pop    %ebp
80106fe2:	c3                   	ret    
80106fe3:	90                   	nop
80106fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80106fe8:	83 ec 0c             	sub    $0xc,%esp
80106feb:	56                   	push   %esi
80106fec:	e8 2f b3 ff ff       	call   80102320 <kfree>
      goto bad;
80106ff1:	83 c4 10             	add    $0x10,%esp
80106ff4:	eb cd                	jmp    80106fc3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80106ff6:	83 ec 0c             	sub    $0xc,%esp
80106ff9:	68 be 7a 10 80       	push   $0x80107abe
80106ffe:	e8 8d 93 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107003:	83 ec 0c             	sub    $0xc,%esp
80107006:	68 a4 7a 10 80       	push   $0x80107aa4
8010700b:	e8 80 93 ff ff       	call   80100390 <panic>

80107010 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107010:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107011:	31 c9                	xor    %ecx,%ecx
{
80107013:	89 e5                	mov    %esp,%ebp
80107015:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107018:	8b 55 0c             	mov    0xc(%ebp),%edx
8010701b:	8b 45 08             	mov    0x8(%ebp),%eax
8010701e:	e8 9d f7 ff ff       	call   801067c0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107023:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107025:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107026:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107028:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010702d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107030:	05 00 00 00 80       	add    $0x80000000,%eax
80107035:	83 fa 05             	cmp    $0x5,%edx
80107038:	ba 00 00 00 00       	mov    $0x0,%edx
8010703d:	0f 45 c2             	cmovne %edx,%eax
}
80107040:	c3                   	ret    
80107041:	eb 0d                	jmp    80107050 <copyout>
80107043:	90                   	nop
80107044:	90                   	nop
80107045:	90                   	nop
80107046:	90                   	nop
80107047:	90                   	nop
80107048:	90                   	nop
80107049:	90                   	nop
8010704a:	90                   	nop
8010704b:	90                   	nop
8010704c:	90                   	nop
8010704d:	90                   	nop
8010704e:	90                   	nop
8010704f:	90                   	nop

80107050 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107050:	55                   	push   %ebp
80107051:	89 e5                	mov    %esp,%ebp
80107053:	57                   	push   %edi
80107054:	56                   	push   %esi
80107055:	53                   	push   %ebx
80107056:	83 ec 1c             	sub    $0x1c,%esp
80107059:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010705c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010705f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107062:	85 db                	test   %ebx,%ebx
80107064:	75 40                	jne    801070a6 <copyout+0x56>
80107066:	eb 70                	jmp    801070d8 <copyout+0x88>
80107068:	90                   	nop
80107069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107070:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107073:	89 f1                	mov    %esi,%ecx
80107075:	29 d1                	sub    %edx,%ecx
80107077:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010707d:	39 d9                	cmp    %ebx,%ecx
8010707f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107082:	29 f2                	sub    %esi,%edx
80107084:	83 ec 04             	sub    $0x4,%esp
80107087:	01 d0                	add    %edx,%eax
80107089:	51                   	push   %ecx
8010708a:	57                   	push   %edi
8010708b:	50                   	push   %eax
8010708c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010708f:	e8 fc d5 ff ff       	call   80104690 <memmove>
    len -= n;
    buf += n;
80107094:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107097:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010709a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
801070a0:	01 cf                	add    %ecx,%edi
  while(len > 0){
801070a2:	29 cb                	sub    %ecx,%ebx
801070a4:	74 32                	je     801070d8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801070a6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801070a8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801070ab:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801070ae:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801070b4:	56                   	push   %esi
801070b5:	ff 75 08             	pushl  0x8(%ebp)
801070b8:	e8 53 ff ff ff       	call   80107010 <uva2ka>
    if(pa0 == 0)
801070bd:	83 c4 10             	add    $0x10,%esp
801070c0:	85 c0                	test   %eax,%eax
801070c2:	75 ac                	jne    80107070 <copyout+0x20>
  }
  return 0;
}
801070c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801070c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801070cc:	5b                   	pop    %ebx
801070cd:	5e                   	pop    %esi
801070ce:	5f                   	pop    %edi
801070cf:	5d                   	pop    %ebp
801070d0:	c3                   	ret    
801070d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801070db:	31 c0                	xor    %eax,%eax
}
801070dd:	5b                   	pop    %ebx
801070de:	5e                   	pop    %esi
801070df:	5f                   	pop    %edi
801070e0:	5d                   	pop    %ebp
801070e1:	c3                   	ret    
