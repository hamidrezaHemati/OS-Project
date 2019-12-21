
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
8010002d:	b8 c0 2e 10 80       	mov    $0x80102ec0,%eax
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
8010004c:	68 80 76 10 80       	push   $0x80107680
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 05 48 00 00       	call   80104860 <initlock>
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
80100092:	68 87 76 10 80       	push   $0x80107687
80100097:	50                   	push   %eax
80100098:	e8 93 46 00 00       	call   80104730 <initsleeplock>
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
801000e4:	e8 b7 48 00 00       	call   801049a0 <acquire>
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
80100162:	e8 f9 48 00 00       	call   80104a60 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 fe 45 00 00       	call   80104770 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 bd 1f 00 00       	call   80102140 <iderw>
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
80100193:	68 8e 76 10 80       	push   $0x8010768e
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
801001ae:	e8 5d 46 00 00       	call   80104810 <holdingsleep>
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
801001c4:	e9 77 1f 00 00       	jmp    80102140 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 9f 76 10 80       	push   $0x8010769f
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
801001ef:	e8 1c 46 00 00       	call   80104810 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 cc 45 00 00       	call   801047d0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 90 47 00 00       	call   801049a0 <acquire>
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
8010025c:	e9 ff 47 00 00       	jmp    80104a60 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 a6 76 10 80       	push   $0x801076a6
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
8010028c:	e8 0f 47 00 00       	call   801049a0 <acquire>
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
801002c5:	e8 86 3d 00 00       	call   80104050 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 0f 11 80    	cmp    0x80110fa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 10 36 00 00       	call   801038f0 <myproc>
801002e0:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801002e6:	85 c0                	test   %eax,%eax
801002e8:	74 ce                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002ea:	83 ec 0c             	sub    $0xc,%esp
801002ed:	68 20 b5 10 80       	push   $0x8010b520
801002f2:	e8 69 47 00 00       	call   80104a60 <release>
        ilock(ip);
801002f7:	89 3c 24             	mov    %edi,(%esp)
801002fa:	e8 91 13 00 00       	call   80101690 <ilock>
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
8010034d:	e8 0e 47 00 00       	call   80104a60 <release>
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
801003a9:	e8 a2 23 00 00       	call   80102750 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ad 76 10 80       	push   $0x801076ad
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 13 80 10 80 	movl   $0x80108013,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 a3 44 00 00       	call   80104880 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 c1 76 10 80       	push   $0x801076c1
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
8010043a:	e8 41 5e 00 00       	call   80106280 <uartputc>
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
801004ec:	e8 8f 5d 00 00       	call   80106280 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 83 5d 00 00       	call   80106280 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 77 5d 00 00       	call   80106280 <uartputc>
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
80100524:	e8 37 46 00 00       	call   80104b60 <memmove>
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
80100541:	e8 6a 45 00 00       	call   80104ab0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 c5 76 10 80       	push   $0x801076c5
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
801005b1:	0f b6 92 f0 76 10 80 	movzbl -0x7fef8910(%edx),%edx
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
8010061b:	e8 80 43 00 00       	call   801049a0 <acquire>
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
80100647:	e8 14 44 00 00       	call   80104a60 <release>
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
8010071f:	e8 3c 43 00 00       	call   80104a60 <release>
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
801007d0:	ba d8 76 10 80       	mov    $0x801076d8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 ab 41 00 00       	call   801049a0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 df 76 10 80       	push   $0x801076df
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
80100823:	e8 78 41 00 00       	call   801049a0 <acquire>
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
80100888:	e8 d3 41 00 00       	call   80104a60 <release>
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
80100916:	e8 35 39 00 00       	call   80104250 <wakeup>
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
80100997:	e9 b4 39 00 00       	jmp    80104350 <procdump>
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
801009c6:	68 e8 76 10 80       	push   $0x801076e8
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 8b 3e 00 00       	call   80104860 <initlock>

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
801009f9:	e8 f2 18 00 00       	call   801022f0 <ioapicenable>
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
80100a1c:	e8 cf 2e 00 00       	call   801038f0 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 94 21 00 00       	call   80102bc0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 c9 14 00 00       	call   80101f00 <namei>
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
80100a6f:	e8 bc 21 00 00       	call   80102c30 <end_op>
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
80100a94:	e8 47 69 00 00       	call   801073e0 <setupkvm>
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
80100ab9:	0f 84 9e 02 00 00    	je     80100d5d <exec+0x34d>
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
80100af6:	e8 05 67 00 00       	call   80107200 <allocuvm>
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
80100b28:	e8 13 66 00 00       	call   80107140 <loaduvm>
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
80100b72:	e8 e9 67 00 00       	call   80107360 <freevm>
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
80100b9a:	e8 91 20 00 00       	call   80102c30 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 51 66 00 00       	call   80107200 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 9a 67 00 00       	call   80107360 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 58 20 00 00       	call   80102c30 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 01 77 10 80       	push   $0x80107701
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
80100c06:	e8 75 68 00 00       	call   80107480 <clearpteu>
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
80100c39:	e8 92 40 00 00       	call   80104cd0 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 7f 40 00 00       	call   80104cd0 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 7e 69 00 00       	call   801075e0 <copyout>
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
80100cc7:	e8 14 69 00 00       	call   801075e0 <copyout>
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
80100d06:	05 f8 00 00 00       	add    $0xf8,%eax
80100d0b:	50                   	push   %eax
80100d0c:	e8 7f 3f 00 00       	call   80104c90 <safestrcpy>
  curproc->pgdir = pgdir;
80100d11:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d17:	89 f9                	mov    %edi,%ecx
80100d19:	8b bf 90 00 00 00    	mov    0x90(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1f:	8b 81 a4 00 00 00    	mov    0xa4(%ecx),%eax
  curproc->sz = sz;
80100d25:	89 b1 8c 00 00 00    	mov    %esi,0x8c(%ecx)
  curproc->pgdir = pgdir;
80100d2b:	89 91 90 00 00 00    	mov    %edx,0x90(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d31:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d37:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d3a:	8b 81 a4 00 00 00    	mov    0xa4(%ecx),%eax
80100d40:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d43:	89 0c 24             	mov    %ecx,(%esp)
80100d46:	e8 55 62 00 00       	call   80106fa0 <switchuvm>
  freevm(oldpgdir);
80100d4b:	89 3c 24             	mov    %edi,(%esp)
80100d4e:	e8 0d 66 00 00       	call   80107360 <freevm>
  return 0;
80100d53:	83 c4 10             	add    $0x10,%esp
80100d56:	31 c0                	xor    %eax,%eax
80100d58:	e9 1f fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d5d:	be 00 20 00 00       	mov    $0x2000,%esi
80100d62:	e9 2a fe ff ff       	jmp    80100b91 <exec+0x181>
80100d67:	66 90                	xchg   %ax,%ax
80100d69:	66 90                	xchg   %ax,%ax
80100d6b:	66 90                	xchg   %ax,%ax
80100d6d:	66 90                	xchg   %ax,%ax
80100d6f:	90                   	nop

80100d70 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d76:	68 0d 77 10 80       	push   $0x8010770d
80100d7b:	68 c0 0f 11 80       	push   $0x80110fc0
80100d80:	e8 db 3a 00 00       	call   80104860 <initlock>
}
80100d85:	83 c4 10             	add    $0x10,%esp
80100d88:	c9                   	leave  
80100d89:	c3                   	ret    
80100d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d90 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d90:	55                   	push   %ebp
80100d91:	89 e5                	mov    %esp,%ebp
80100d93:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d94:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100d99:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d9c:	68 c0 0f 11 80       	push   $0x80110fc0
80100da1:	e8 fa 3b 00 00       	call   801049a0 <acquire>
80100da6:	83 c4 10             	add    $0x10,%esp
80100da9:	eb 10                	jmp    80100dbb <filealloc+0x2b>
80100dab:	90                   	nop
80100dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100db0:	83 c3 18             	add    $0x18,%ebx
80100db3:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100db9:	73 25                	jae    80100de0 <filealloc+0x50>
    if(f->ref == 0){
80100dbb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dbe:	85 c0                	test   %eax,%eax
80100dc0:	75 ee                	jne    80100db0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100dc2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100dc5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dcc:	68 c0 0f 11 80       	push   $0x80110fc0
80100dd1:	e8 8a 3c 00 00       	call   80104a60 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dd6:	89 d8                	mov    %ebx,%eax
      return f;
80100dd8:	83 c4 10             	add    $0x10,%esp
}
80100ddb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dde:	c9                   	leave  
80100ddf:	c3                   	ret    
  release(&ftable.lock);
80100de0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100de3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100de5:	68 c0 0f 11 80       	push   $0x80110fc0
80100dea:	e8 71 3c 00 00       	call   80104a60 <release>
}
80100def:	89 d8                	mov    %ebx,%eax
  return 0;
80100df1:	83 c4 10             	add    $0x10,%esp
}
80100df4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100df7:	c9                   	leave  
80100df8:	c3                   	ret    
80100df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e00 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e00:	55                   	push   %ebp
80100e01:	89 e5                	mov    %esp,%ebp
80100e03:	53                   	push   %ebx
80100e04:	83 ec 10             	sub    $0x10,%esp
80100e07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e0a:	68 c0 0f 11 80       	push   $0x80110fc0
80100e0f:	e8 8c 3b 00 00       	call   801049a0 <acquire>
  if(f->ref < 1)
80100e14:	8b 43 04             	mov    0x4(%ebx),%eax
80100e17:	83 c4 10             	add    $0x10,%esp
80100e1a:	85 c0                	test   %eax,%eax
80100e1c:	7e 1a                	jle    80100e38 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e1e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e21:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e24:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e27:	68 c0 0f 11 80       	push   $0x80110fc0
80100e2c:	e8 2f 3c 00 00       	call   80104a60 <release>
  return f;
}
80100e31:	89 d8                	mov    %ebx,%eax
80100e33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e36:	c9                   	leave  
80100e37:	c3                   	ret    
    panic("filedup");
80100e38:	83 ec 0c             	sub    $0xc,%esp
80100e3b:	68 14 77 10 80       	push   $0x80107714
80100e40:	e8 4b f5 ff ff       	call   80100390 <panic>
80100e45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e50 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e50:	55                   	push   %ebp
80100e51:	89 e5                	mov    %esp,%ebp
80100e53:	57                   	push   %edi
80100e54:	56                   	push   %esi
80100e55:	53                   	push   %ebx
80100e56:	83 ec 28             	sub    $0x28,%esp
80100e59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e5c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e61:	e8 3a 3b 00 00       	call   801049a0 <acquire>
  if(f->ref < 1)
80100e66:	8b 43 04             	mov    0x4(%ebx),%eax
80100e69:	83 c4 10             	add    $0x10,%esp
80100e6c:	85 c0                	test   %eax,%eax
80100e6e:	0f 8e 9b 00 00 00    	jle    80100f0f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e74:	83 e8 01             	sub    $0x1,%eax
80100e77:	85 c0                	test   %eax,%eax
80100e79:	89 43 04             	mov    %eax,0x4(%ebx)
80100e7c:	74 1a                	je     80100e98 <fileclose+0x48>
    release(&ftable.lock);
80100e7e:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e88:	5b                   	pop    %ebx
80100e89:	5e                   	pop    %esi
80100e8a:	5f                   	pop    %edi
80100e8b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e8c:	e9 cf 3b 00 00       	jmp    80104a60 <release>
80100e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e98:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e9c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e9e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ea1:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100ea4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eaa:	88 45 e7             	mov    %al,-0x19(%ebp)
80100ead:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100eb0:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100eb5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100eb8:	e8 a3 3b 00 00       	call   80104a60 <release>
  if(ff.type == FD_PIPE)
80100ebd:	83 c4 10             	add    $0x10,%esp
80100ec0:	83 ff 01             	cmp    $0x1,%edi
80100ec3:	74 13                	je     80100ed8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100ec5:	83 ff 02             	cmp    $0x2,%edi
80100ec8:	74 26                	je     80100ef0 <fileclose+0xa0>
}
80100eca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ecd:	5b                   	pop    %ebx
80100ece:	5e                   	pop    %esi
80100ecf:	5f                   	pop    %edi
80100ed0:	5d                   	pop    %ebp
80100ed1:	c3                   	ret    
80100ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ed8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100edc:	83 ec 08             	sub    $0x8,%esp
80100edf:	53                   	push   %ebx
80100ee0:	56                   	push   %esi
80100ee1:	e8 8a 24 00 00       	call   80103370 <pipeclose>
80100ee6:	83 c4 10             	add    $0x10,%esp
80100ee9:	eb df                	jmp    80100eca <fileclose+0x7a>
80100eeb:	90                   	nop
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ef0:	e8 cb 1c 00 00       	call   80102bc0 <begin_op>
    iput(ff.ip);
80100ef5:	83 ec 0c             	sub    $0xc,%esp
80100ef8:	ff 75 e0             	pushl  -0x20(%ebp)
80100efb:	e8 c0 08 00 00       	call   801017c0 <iput>
    end_op();
80100f00:	83 c4 10             	add    $0x10,%esp
}
80100f03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f06:	5b                   	pop    %ebx
80100f07:	5e                   	pop    %esi
80100f08:	5f                   	pop    %edi
80100f09:	5d                   	pop    %ebp
    end_op();
80100f0a:	e9 21 1d 00 00       	jmp    80102c30 <end_op>
    panic("fileclose");
80100f0f:	83 ec 0c             	sub    $0xc,%esp
80100f12:	68 1c 77 10 80       	push   $0x8010771c
80100f17:	e8 74 f4 ff ff       	call   80100390 <panic>
80100f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f20 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f20:	55                   	push   %ebp
80100f21:	89 e5                	mov    %esp,%ebp
80100f23:	53                   	push   %ebx
80100f24:	83 ec 04             	sub    $0x4,%esp
80100f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f2a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f2d:	75 31                	jne    80100f60 <filestat+0x40>
    ilock(f->ip);
80100f2f:	83 ec 0c             	sub    $0xc,%esp
80100f32:	ff 73 10             	pushl  0x10(%ebx)
80100f35:	e8 56 07 00 00       	call   80101690 <ilock>
    stati(f->ip, st);
80100f3a:	58                   	pop    %eax
80100f3b:	5a                   	pop    %edx
80100f3c:	ff 75 0c             	pushl  0xc(%ebp)
80100f3f:	ff 73 10             	pushl  0x10(%ebx)
80100f42:	e8 f9 09 00 00       	call   80101940 <stati>
    iunlock(f->ip);
80100f47:	59                   	pop    %ecx
80100f48:	ff 73 10             	pushl  0x10(%ebx)
80100f4b:	e8 20 08 00 00       	call   80101770 <iunlock>
    return 0;
80100f50:	83 c4 10             	add    $0x10,%esp
80100f53:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f58:	c9                   	leave  
80100f59:	c3                   	ret    
80100f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f65:	eb ee                	jmp    80100f55 <filestat+0x35>
80100f67:	89 f6                	mov    %esi,%esi
80100f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f70 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f70:	55                   	push   %ebp
80100f71:	89 e5                	mov    %esp,%ebp
80100f73:	57                   	push   %edi
80100f74:	56                   	push   %esi
80100f75:	53                   	push   %ebx
80100f76:	83 ec 0c             	sub    $0xc,%esp
80100f79:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f7f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f82:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f86:	74 60                	je     80100fe8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f88:	8b 03                	mov    (%ebx),%eax
80100f8a:	83 f8 01             	cmp    $0x1,%eax
80100f8d:	74 41                	je     80100fd0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f8f:	83 f8 02             	cmp    $0x2,%eax
80100f92:	75 5b                	jne    80100fef <fileread+0x7f>
    ilock(f->ip);
80100f94:	83 ec 0c             	sub    $0xc,%esp
80100f97:	ff 73 10             	pushl  0x10(%ebx)
80100f9a:	e8 f1 06 00 00       	call   80101690 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f9f:	57                   	push   %edi
80100fa0:	ff 73 14             	pushl  0x14(%ebx)
80100fa3:	56                   	push   %esi
80100fa4:	ff 73 10             	pushl  0x10(%ebx)
80100fa7:	e8 c4 09 00 00       	call   80101970 <readi>
80100fac:	83 c4 20             	add    $0x20,%esp
80100faf:	85 c0                	test   %eax,%eax
80100fb1:	89 c6                	mov    %eax,%esi
80100fb3:	7e 03                	jle    80100fb8 <fileread+0x48>
      f->off += r;
80100fb5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fb8:	83 ec 0c             	sub    $0xc,%esp
80100fbb:	ff 73 10             	pushl  0x10(%ebx)
80100fbe:	e8 ad 07 00 00       	call   80101770 <iunlock>
    return r;
80100fc3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	89 f0                	mov    %esi,%eax
80100fcb:	5b                   	pop    %ebx
80100fcc:	5e                   	pop    %esi
80100fcd:	5f                   	pop    %edi
80100fce:	5d                   	pop    %ebp
80100fcf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fd0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fd3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fd9:	5b                   	pop    %ebx
80100fda:	5e                   	pop    %esi
80100fdb:	5f                   	pop    %edi
80100fdc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fdd:	e9 3e 25 00 00       	jmp    80103520 <piperead>
80100fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fe8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fed:	eb d7                	jmp    80100fc6 <fileread+0x56>
  panic("fileread");
80100fef:	83 ec 0c             	sub    $0xc,%esp
80100ff2:	68 26 77 10 80       	push   $0x80107726
80100ff7:	e8 94 f3 ff ff       	call   80100390 <panic>
80100ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101000 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101000:	55                   	push   %ebp
80101001:	89 e5                	mov    %esp,%ebp
80101003:	57                   	push   %edi
80101004:	56                   	push   %esi
80101005:	53                   	push   %ebx
80101006:	83 ec 1c             	sub    $0x1c,%esp
80101009:	8b 75 08             	mov    0x8(%ebp),%esi
8010100c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010100f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101013:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101016:	8b 45 10             	mov    0x10(%ebp),%eax
80101019:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010101c:	0f 84 aa 00 00 00    	je     801010cc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101022:	8b 06                	mov    (%esi),%eax
80101024:	83 f8 01             	cmp    $0x1,%eax
80101027:	0f 84 c3 00 00 00    	je     801010f0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010102d:	83 f8 02             	cmp    $0x2,%eax
80101030:	0f 85 d9 00 00 00    	jne    8010110f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101036:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101039:	31 ff                	xor    %edi,%edi
    while(i < n){
8010103b:	85 c0                	test   %eax,%eax
8010103d:	7f 34                	jg     80101073 <filewrite+0x73>
8010103f:	e9 9c 00 00 00       	jmp    801010e0 <filewrite+0xe0>
80101044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101048:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010104b:	83 ec 0c             	sub    $0xc,%esp
8010104e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101051:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101054:	e8 17 07 00 00       	call   80101770 <iunlock>
      end_op();
80101059:	e8 d2 1b 00 00       	call   80102c30 <end_op>
8010105e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101061:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101064:	39 c3                	cmp    %eax,%ebx
80101066:	0f 85 96 00 00 00    	jne    80101102 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010106c:	01 df                	add    %ebx,%edi
    while(i < n){
8010106e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101071:	7e 6d                	jle    801010e0 <filewrite+0xe0>
      int n1 = n - i;
80101073:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101076:	b8 00 06 00 00       	mov    $0x600,%eax
8010107b:	29 fb                	sub    %edi,%ebx
8010107d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101083:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101086:	e8 35 1b 00 00       	call   80102bc0 <begin_op>
      ilock(f->ip);
8010108b:	83 ec 0c             	sub    $0xc,%esp
8010108e:	ff 76 10             	pushl  0x10(%esi)
80101091:	e8 fa 05 00 00       	call   80101690 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101096:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101099:	53                   	push   %ebx
8010109a:	ff 76 14             	pushl  0x14(%esi)
8010109d:	01 f8                	add    %edi,%eax
8010109f:	50                   	push   %eax
801010a0:	ff 76 10             	pushl  0x10(%esi)
801010a3:	e8 c8 09 00 00       	call   80101a70 <writei>
801010a8:	83 c4 20             	add    $0x20,%esp
801010ab:	85 c0                	test   %eax,%eax
801010ad:	7f 99                	jg     80101048 <filewrite+0x48>
      iunlock(f->ip);
801010af:	83 ec 0c             	sub    $0xc,%esp
801010b2:	ff 76 10             	pushl  0x10(%esi)
801010b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010b8:	e8 b3 06 00 00       	call   80101770 <iunlock>
      end_op();
801010bd:	e8 6e 1b 00 00       	call   80102c30 <end_op>
      if(r < 0)
801010c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010c5:	83 c4 10             	add    $0x10,%esp
801010c8:	85 c0                	test   %eax,%eax
801010ca:	74 98                	je     80101064 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010cf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010d4:	89 f8                	mov    %edi,%eax
801010d6:	5b                   	pop    %ebx
801010d7:	5e                   	pop    %esi
801010d8:	5f                   	pop    %edi
801010d9:	5d                   	pop    %ebp
801010da:	c3                   	ret    
801010db:	90                   	nop
801010dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010e0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010e3:	75 e7                	jne    801010cc <filewrite+0xcc>
}
801010e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e8:	89 f8                	mov    %edi,%eax
801010ea:	5b                   	pop    %ebx
801010eb:	5e                   	pop    %esi
801010ec:	5f                   	pop    %edi
801010ed:	5d                   	pop    %ebp
801010ee:	c3                   	ret    
801010ef:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010f0:	8b 46 0c             	mov    0xc(%esi),%eax
801010f3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010f9:	5b                   	pop    %ebx
801010fa:	5e                   	pop    %esi
801010fb:	5f                   	pop    %edi
801010fc:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010fd:	e9 0e 23 00 00       	jmp    80103410 <pipewrite>
        panic("short filewrite");
80101102:	83 ec 0c             	sub    $0xc,%esp
80101105:	68 2f 77 10 80       	push   $0x8010772f
8010110a:	e8 81 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010110f:	83 ec 0c             	sub    $0xc,%esp
80101112:	68 35 77 10 80       	push   $0x80107735
80101117:	e8 74 f2 ff ff       	call   80100390 <panic>
8010111c:	66 90                	xchg   %ax,%ax
8010111e:	66 90                	xchg   %ax,%ax

80101120 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101120:	55                   	push   %ebp
80101121:	89 e5                	mov    %esp,%ebp
80101123:	56                   	push   %esi
80101124:	53                   	push   %ebx
80101125:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101127:	c1 ea 0c             	shr    $0xc,%edx
8010112a:	03 15 d8 19 11 80    	add    0x801119d8,%edx
80101130:	83 ec 08             	sub    $0x8,%esp
80101133:	52                   	push   %edx
80101134:	50                   	push   %eax
80101135:	e8 96 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010113a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010113c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010113f:	ba 01 00 00 00       	mov    $0x1,%edx
80101144:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101147:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010114d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101150:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101152:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101157:	85 d1                	test   %edx,%ecx
80101159:	74 25                	je     80101180 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010115b:	f7 d2                	not    %edx
8010115d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010115f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101162:	21 ca                	and    %ecx,%edx
80101164:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101168:	56                   	push   %esi
80101169:	e8 22 1c 00 00       	call   80102d90 <log_write>
  brelse(bp);
8010116e:	89 34 24             	mov    %esi,(%esp)
80101171:	e8 6a f0 ff ff       	call   801001e0 <brelse>
}
80101176:	83 c4 10             	add    $0x10,%esp
80101179:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010117c:	5b                   	pop    %ebx
8010117d:	5e                   	pop    %esi
8010117e:	5d                   	pop    %ebp
8010117f:	c3                   	ret    
    panic("freeing free block");
80101180:	83 ec 0c             	sub    $0xc,%esp
80101183:	68 3f 77 10 80       	push   $0x8010773f
80101188:	e8 03 f2 ff ff       	call   80100390 <panic>
8010118d:	8d 76 00             	lea    0x0(%esi),%esi

80101190 <balloc>:
{
80101190:	55                   	push   %ebp
80101191:	89 e5                	mov    %esp,%ebp
80101193:	57                   	push   %edi
80101194:	56                   	push   %esi
80101195:	53                   	push   %ebx
80101196:	83 ec 1c             	sub    $0x1c,%esp
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
80101211:	83 ec 0c             	sub    $0xc,%esp
80101214:	ff 75 e4             	pushl  -0x1c(%ebp)
80101217:	e8 c4 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010121c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101223:	83 c4 10             	add    $0x10,%esp
80101226:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101229:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
8010122f:	77 80                	ja     801011b1 <balloc+0x21>
  panic("balloc: out of blocks");
80101231:	83 ec 0c             	sub    $0xc,%esp
80101234:	68 52 77 10 80       	push   $0x80107752
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
8010124d:	e8 3e 1b 00 00       	call   80102d90 <log_write>
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
80101275:	e8 36 38 00 00       	call   80104ab0 <memset>
  log_write(bp);
8010127a:	89 1c 24             	mov    %ebx,(%esp)
8010127d:	e8 0e 1b 00 00       	call   80102d90 <log_write>
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
801012ba:	e8 e1 36 00 00       	call   801049a0 <acquire>
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
8010131f:	e8 3c 37 00 00       	call   80104a60 <release>

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
8010134d:	e8 0e 37 00 00       	call   80104a60 <release>
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
80101362:	68 68 77 10 80       	push   $0x80107768
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
801013de:	e8 ad 19 00 00       	call   80102d90 <log_write>
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
80101437:	68 78 77 10 80       	push   $0x80107778
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
80101471:	e8 ea 36 00 00       	call   80104b60 <memmove>
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

80101490 <iinit>:
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	53                   	push   %ebx
80101494:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
80101499:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010149c:	68 8b 77 10 80       	push   $0x8010778b
801014a1:	68 e0 19 11 80       	push   $0x801119e0
801014a6:	e8 b5 33 00 00       	call   80104860 <initlock>
801014ab:	83 c4 10             	add    $0x10,%esp
801014ae:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014b0:	83 ec 08             	sub    $0x8,%esp
801014b3:	68 92 77 10 80       	push   $0x80107792
801014b8:	53                   	push   %ebx
801014b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014bf:	e8 6c 32 00 00       	call   80104730 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014c4:	83 c4 10             	add    $0x10,%esp
801014c7:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
801014cd:	75 e1                	jne    801014b0 <iinit+0x20>
  readsb(dev, &sb);
801014cf:	83 ec 08             	sub    $0x8,%esp
801014d2:	68 c0 19 11 80       	push   $0x801119c0
801014d7:	ff 75 08             	pushl  0x8(%ebp)
801014da:	e8 71 ff ff ff       	call   80101450 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014df:	ff 35 d8 19 11 80    	pushl  0x801119d8
801014e5:	ff 35 d4 19 11 80    	pushl  0x801119d4
801014eb:	ff 35 d0 19 11 80    	pushl  0x801119d0
801014f1:	ff 35 cc 19 11 80    	pushl  0x801119cc
801014f7:	ff 35 c8 19 11 80    	pushl  0x801119c8
801014fd:	ff 35 c4 19 11 80    	pushl  0x801119c4
80101503:	ff 35 c0 19 11 80    	pushl  0x801119c0
80101509:	68 f8 77 10 80       	push   $0x801077f8
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
8010159e:	e8 0d 35 00 00       	call   80104ab0 <memset>
      dip->type = type;
801015a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ad:	89 3c 24             	mov    %edi,(%esp)
801015b0:	e8 db 17 00 00       	call   80102d90 <log_write>
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
801015cb:	e9 d0 fc ff ff       	jmp    801012a0 <iget>
  panic("ialloc: no inodes");
801015d0:	83 ec 0c             	sub    $0xc,%esp
801015d3:	68 98 77 10 80       	push   $0x80107798
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
80101641:	e8 1a 35 00 00       	call   80104b60 <memmove>
  log_write(bp);
80101646:	89 34 24             	mov    %esi,(%esp)
80101649:	e8 42 17 00 00       	call   80102d90 <log_write>
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
8010166f:	e8 2c 33 00 00       	call   801049a0 <acquire>
  ip->ref++;
80101674:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101678:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010167f:	e8 dc 33 00 00       	call   80104a60 <release>
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
801016b2:	e8 b9 30 00 00       	call   80104770 <acquiresleep>
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
80101728:	e8 33 34 00 00       	call   80104b60 <memmove>
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
8010174d:	68 b0 77 10 80       	push   $0x801077b0
80101752:	e8 39 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101757:	83 ec 0c             	sub    $0xc,%esp
8010175a:	68 aa 77 10 80       	push   $0x801077aa
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
80101783:	e8 88 30 00 00       	call   80104810 <holdingsleep>
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
8010179f:	e9 2c 30 00 00       	jmp    801047d0 <releasesleep>
    panic("iunlock");
801017a4:	83 ec 0c             	sub    $0xc,%esp
801017a7:	68 bf 77 10 80       	push   $0x801077bf
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
801017d0:	e8 9b 2f 00 00       	call   80104770 <acquiresleep>
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
801017ea:	e8 e1 2f 00 00       	call   801047d0 <releasesleep>
  acquire(&icache.lock);
801017ef:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801017f6:	e8 a5 31 00 00       	call   801049a0 <acquire>
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
80101810:	e9 4b 32 00 00       	jmp    80104a60 <release>
80101815:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101818:	83 ec 0c             	sub    $0xc,%esp
8010181b:	68 e0 19 11 80       	push   $0x801119e0
80101820:	e8 7b 31 00 00       	call   801049a0 <acquire>
    int r = ip->ref;
80101825:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101828:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010182f:	e8 2c 32 00 00       	call   80104a60 <release>
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
8010185f:	e8 bc f8 ff ff       	call   80101120 <bfree>
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
801018e7:	e8 34 f8 ff ff       	call   80101120 <bfree>
801018ec:	eb ea                	jmp    801018d8 <iput+0x118>
    brelse(bp);
801018ee:	83 ec 0c             	sub    $0xc,%esp
801018f1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018f7:	e8 e4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018fc:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101902:	8b 03                	mov    (%ebx),%eax
80101904:	e8 17 f8 ff ff       	call   80101120 <bfree>
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
801019da:	e8 91 f9 ff ff       	call   80101370 <bmap>
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
80101a17:	e8 44 31 00 00       	call   80104b60 <memmove>
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
80101ada:	e8 91 f8 ff ff       	call   80101370 <bmap>
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
80101b13:	e8 48 30 00 00       	call   80104b60 <memmove>
    log_write(bp);
80101b18:	89 3c 24             	mov    %edi,(%esp)
80101b1b:	e8 70 12 00 00       	call   80102d90 <log_write>
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
80101bae:	e8 1d 30 00 00       	call   80104bd0 <strncmp>
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
80101c0d:	e8 be 2f 00 00       	call   80104bd0 <strncmp>
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
80101c42:	e8 59 f6 ff ff       	call   801012a0 <iget>
}
80101c47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c4a:	5b                   	pop    %ebx
80101c4b:	5e                   	pop    %esi
80101c4c:	5f                   	pop    %edi
80101c4d:	5d                   	pop    %ebp
80101c4e:	c3                   	ret    
      panic("dirlookup read");
80101c4f:	83 ec 0c             	sub    $0xc,%esp
80101c52:	68 d9 77 10 80       	push   $0x801077d9
80101c57:	e8 34 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c5c:	83 ec 0c             	sub    $0xc,%esp
80101c5f:	68 c7 77 10 80       	push   $0x801077c7
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
80101c83:	0f 84 77 01 00 00    	je     80101e00 <namex+0x190>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c89:	e8 62 1c 00 00       	call   801038f0 <myproc>
  acquire(&icache.lock);
80101c8e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c91:	8b b0 f4 00 00 00    	mov    0xf4(%eax),%esi
  acquire(&icache.lock);
80101c97:	68 e0 19 11 80       	push   $0x801119e0
80101c9c:	e8 ff 2c 00 00       	call   801049a0 <acquire>
  ip->ref++;
80101ca1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ca5:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101cac:	e8 af 2d 00 00       	call   80104a60 <release>
80101cb1:	83 c4 10             	add    $0x10,%esp
80101cb4:	eb 0d                	jmp    80101cc3 <namex+0x53>
80101cb6:	8d 76 00             	lea    0x0(%esi),%esi
80101cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101cc0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cc3:	0f b6 03             	movzbl (%ebx),%eax
80101cc6:	3c 2f                	cmp    $0x2f,%al
80101cc8:	74 f6                	je     80101cc0 <namex+0x50>
  if(*path == 0)
80101cca:	84 c0                	test   %al,%al
80101ccc:	0f 84 f6 00 00 00    	je     80101dc8 <namex+0x158>
  while(*path != '/' && *path != 0)
80101cd2:	0f b6 03             	movzbl (%ebx),%eax
80101cd5:	3c 2f                	cmp    $0x2f,%al
80101cd7:	0f 84 bb 00 00 00    	je     80101d98 <namex+0x128>
80101cdd:	84 c0                	test   %al,%al
80101cdf:	89 da                	mov    %ebx,%edx
80101ce1:	75 11                	jne    80101cf4 <namex+0x84>
80101ce3:	e9 b0 00 00 00       	jmp    80101d98 <namex+0x128>
80101ce8:	90                   	nop
80101ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cf0:	84 c0                	test   %al,%al
80101cf2:	74 0a                	je     80101cfe <namex+0x8e>
    path++;
80101cf4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101cf7:	0f b6 02             	movzbl (%edx),%eax
80101cfa:	3c 2f                	cmp    $0x2f,%al
80101cfc:	75 f2                	jne    80101cf0 <namex+0x80>
80101cfe:	89 d1                	mov    %edx,%ecx
80101d00:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d02:	83 f9 0d             	cmp    $0xd,%ecx
80101d05:	0f 8e 91 00 00 00    	jle    80101d9c <namex+0x12c>
    memmove(name, s, DIRSIZ);
80101d0b:	83 ec 04             	sub    $0x4,%esp
80101d0e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d11:	6a 0e                	push   $0xe
80101d13:	53                   	push   %ebx
80101d14:	57                   	push   %edi
80101d15:	e8 46 2e 00 00       	call   80104b60 <memmove>
    path++;
80101d1a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d1d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d20:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d22:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d25:	75 11                	jne    80101d38 <namex+0xc8>
80101d27:	89 f6                	mov    %esi,%esi
80101d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d30:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d33:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d36:	74 f8                	je     80101d30 <namex+0xc0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d38:	83 ec 0c             	sub    $0xc,%esp
80101d3b:	56                   	push   %esi
80101d3c:	e8 4f f9 ff ff       	call   80101690 <ilock>
    if(ip->type != T_DIR){
80101d41:	83 c4 10             	add    $0x10,%esp
80101d44:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d49:	0f 85 91 00 00 00    	jne    80101de0 <namex+0x170>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d4f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d52:	85 d2                	test   %edx,%edx
80101d54:	74 09                	je     80101d5f <namex+0xef>
80101d56:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d59:	0f 84 b7 00 00 00    	je     80101e16 <namex+0x1a6>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d5f:	83 ec 04             	sub    $0x4,%esp
80101d62:	6a 00                	push   $0x0
80101d64:	57                   	push   %edi
80101d65:	56                   	push   %esi
80101d66:	e8 55 fe ff ff       	call   80101bc0 <dirlookup>
80101d6b:	83 c4 10             	add    $0x10,%esp
80101d6e:	85 c0                	test   %eax,%eax
80101d70:	74 6e                	je     80101de0 <namex+0x170>
  iunlock(ip);
80101d72:	83 ec 0c             	sub    $0xc,%esp
80101d75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d78:	56                   	push   %esi
80101d79:	e8 f2 f9 ff ff       	call   80101770 <iunlock>
  iput(ip);
80101d7e:	89 34 24             	mov    %esi,(%esp)
80101d81:	e8 3a fa ff ff       	call   801017c0 <iput>
80101d86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d89:	83 c4 10             	add    $0x10,%esp
80101d8c:	89 c6                	mov    %eax,%esi
80101d8e:	e9 30 ff ff ff       	jmp    80101cc3 <namex+0x53>
80101d93:	90                   	nop
80101d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d98:	89 da                	mov    %ebx,%edx
80101d9a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d9c:	83 ec 04             	sub    $0x4,%esp
80101d9f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101da5:	51                   	push   %ecx
80101da6:	53                   	push   %ebx
80101da7:	57                   	push   %edi
80101da8:	e8 b3 2d 00 00       	call   80104b60 <memmove>
    name[len] = 0;
80101dad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101db0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101db3:	83 c4 10             	add    $0x10,%esp
80101db6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101dba:	89 d3                	mov    %edx,%ebx
80101dbc:	e9 61 ff ff ff       	jmp    80101d22 <namex+0xb2>
80101dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101dc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dcb:	85 c0                	test   %eax,%eax
80101dcd:	75 5d                	jne    80101e2c <namex+0x1bc>
    iput(ip);
    return 0;
  }
  return ip;
}
80101dcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd2:	89 f0                	mov    %esi,%eax
80101dd4:	5b                   	pop    %ebx
80101dd5:	5e                   	pop    %esi
80101dd6:	5f                   	pop    %edi
80101dd7:	5d                   	pop    %ebp
80101dd8:	c3                   	ret    
80101dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101de0:	83 ec 0c             	sub    $0xc,%esp
80101de3:	56                   	push   %esi
80101de4:	e8 87 f9 ff ff       	call   80101770 <iunlock>
  iput(ip);
80101de9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101dec:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dee:	e8 cd f9 ff ff       	call   801017c0 <iput>
      return 0;
80101df3:	83 c4 10             	add    $0x10,%esp
}
80101df6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101df9:	89 f0                	mov    %esi,%eax
80101dfb:	5b                   	pop    %ebx
80101dfc:	5e                   	pop    %esi
80101dfd:	5f                   	pop    %edi
80101dfe:	5d                   	pop    %ebp
80101dff:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e00:	ba 01 00 00 00       	mov    $0x1,%edx
80101e05:	b8 01 00 00 00       	mov    $0x1,%eax
80101e0a:	e8 91 f4 ff ff       	call   801012a0 <iget>
80101e0f:	89 c6                	mov    %eax,%esi
80101e11:	e9 ad fe ff ff       	jmp    80101cc3 <namex+0x53>
      iunlock(ip);
80101e16:	83 ec 0c             	sub    $0xc,%esp
80101e19:	56                   	push   %esi
80101e1a:	e8 51 f9 ff ff       	call   80101770 <iunlock>
      return ip;
80101e1f:	83 c4 10             	add    $0x10,%esp
}
80101e22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e25:	89 f0                	mov    %esi,%eax
80101e27:	5b                   	pop    %ebx
80101e28:	5e                   	pop    %esi
80101e29:	5f                   	pop    %edi
80101e2a:	5d                   	pop    %ebp
80101e2b:	c3                   	ret    
    iput(ip);
80101e2c:	83 ec 0c             	sub    $0xc,%esp
80101e2f:	56                   	push   %esi
    return 0;
80101e30:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e32:	e8 89 f9 ff ff       	call   801017c0 <iput>
    return 0;
80101e37:	83 c4 10             	add    $0x10,%esp
80101e3a:	eb 93                	jmp    80101dcf <namex+0x15f>
80101e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e40 <dirlink>:
{
80101e40:	55                   	push   %ebp
80101e41:	89 e5                	mov    %esp,%ebp
80101e43:	57                   	push   %edi
80101e44:	56                   	push   %esi
80101e45:	53                   	push   %ebx
80101e46:	83 ec 20             	sub    $0x20,%esp
80101e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e4c:	6a 00                	push   $0x0
80101e4e:	ff 75 0c             	pushl  0xc(%ebp)
80101e51:	53                   	push   %ebx
80101e52:	e8 69 fd ff ff       	call   80101bc0 <dirlookup>
80101e57:	83 c4 10             	add    $0x10,%esp
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	75 67                	jne    80101ec5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e5e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e61:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e64:	85 ff                	test   %edi,%edi
80101e66:	74 29                	je     80101e91 <dirlink+0x51>
80101e68:	31 ff                	xor    %edi,%edi
80101e6a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e6d:	eb 09                	jmp    80101e78 <dirlink+0x38>
80101e6f:	90                   	nop
80101e70:	83 c7 10             	add    $0x10,%edi
80101e73:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e76:	73 19                	jae    80101e91 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e78:	6a 10                	push   $0x10
80101e7a:	57                   	push   %edi
80101e7b:	56                   	push   %esi
80101e7c:	53                   	push   %ebx
80101e7d:	e8 ee fa ff ff       	call   80101970 <readi>
80101e82:	83 c4 10             	add    $0x10,%esp
80101e85:	83 f8 10             	cmp    $0x10,%eax
80101e88:	75 4e                	jne    80101ed8 <dirlink+0x98>
    if(de.inum == 0)
80101e8a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e8f:	75 df                	jne    80101e70 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e91:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e94:	83 ec 04             	sub    $0x4,%esp
80101e97:	6a 0e                	push   $0xe
80101e99:	ff 75 0c             	pushl  0xc(%ebp)
80101e9c:	50                   	push   %eax
80101e9d:	e8 8e 2d 00 00       	call   80104c30 <strncpy>
  de.inum = inum;
80101ea2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ea5:	6a 10                	push   $0x10
80101ea7:	57                   	push   %edi
80101ea8:	56                   	push   %esi
80101ea9:	53                   	push   %ebx
  de.inum = inum;
80101eaa:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eae:	e8 bd fb ff ff       	call   80101a70 <writei>
80101eb3:	83 c4 20             	add    $0x20,%esp
80101eb6:	83 f8 10             	cmp    $0x10,%eax
80101eb9:	75 2a                	jne    80101ee5 <dirlink+0xa5>
  return 0;
80101ebb:	31 c0                	xor    %eax,%eax
}
80101ebd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ec0:	5b                   	pop    %ebx
80101ec1:	5e                   	pop    %esi
80101ec2:	5f                   	pop    %edi
80101ec3:	5d                   	pop    %ebp
80101ec4:	c3                   	ret    
    iput(ip);
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	50                   	push   %eax
80101ec9:	e8 f2 f8 ff ff       	call   801017c0 <iput>
    return -1;
80101ece:	83 c4 10             	add    $0x10,%esp
80101ed1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ed6:	eb e5                	jmp    80101ebd <dirlink+0x7d>
      panic("dirlink read");
80101ed8:	83 ec 0c             	sub    $0xc,%esp
80101edb:	68 e8 77 10 80       	push   $0x801077e8
80101ee0:	e8 ab e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ee5:	83 ec 0c             	sub    $0xc,%esp
80101ee8:	68 fa 7d 10 80       	push   $0x80107dfa
80101eed:	e8 9e e4 ff ff       	call   80100390 <panic>
80101ef2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <namei>:

struct inode*
namei(char *path)
{
80101f00:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f01:	31 d2                	xor    %edx,%edx
{
80101f03:	89 e5                	mov    %esp,%ebp
80101f05:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f08:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f0e:	e8 5d fd ff ff       	call   80101c70 <namex>
}
80101f13:	c9                   	leave  
80101f14:	c3                   	ret    
80101f15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f20 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f20:	55                   	push   %ebp
  return namex(path, 1, name);
80101f21:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f26:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f2b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f2e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f2f:	e9 3c fd ff ff       	jmp    80101c70 <namex>
80101f34:	66 90                	xchg   %ax,%ax
80101f36:	66 90                	xchg   %ax,%ax
80101f38:	66 90                	xchg   %ax,%ax
80101f3a:	66 90                	xchg   %ax,%ax
80101f3c:	66 90                	xchg   %ax,%ax
80101f3e:	66 90                	xchg   %ax,%ax

80101f40 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f40:	55                   	push   %ebp
80101f41:	89 e5                	mov    %esp,%ebp
80101f43:	57                   	push   %edi
80101f44:	56                   	push   %esi
80101f45:	53                   	push   %ebx
80101f46:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f49:	85 c0                	test   %eax,%eax
80101f4b:	0f 84 b4 00 00 00    	je     80102005 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f51:	8b 58 08             	mov    0x8(%eax),%ebx
80101f54:	89 c6                	mov    %eax,%esi
80101f56:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f5c:	0f 87 96 00 00 00    	ja     80101ff8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f62:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f67:	89 f6                	mov    %esi,%esi
80101f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f70:	89 ca                	mov    %ecx,%edx
80101f72:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f73:	83 e0 c0             	and    $0xffffffc0,%eax
80101f76:	3c 40                	cmp    $0x40,%al
80101f78:	75 f6                	jne    80101f70 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f7a:	31 ff                	xor    %edi,%edi
80101f7c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f81:	89 f8                	mov    %edi,%eax
80101f83:	ee                   	out    %al,(%dx)
80101f84:	b8 01 00 00 00       	mov    $0x1,%eax
80101f89:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f8e:	ee                   	out    %al,(%dx)
80101f8f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f94:	89 d8                	mov    %ebx,%eax
80101f96:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f97:	89 d8                	mov    %ebx,%eax
80101f99:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f9e:	c1 f8 08             	sar    $0x8,%eax
80101fa1:	ee                   	out    %al,(%dx)
80101fa2:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101fa7:	89 f8                	mov    %edi,%eax
80101fa9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101faa:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fae:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fb3:	c1 e0 04             	shl    $0x4,%eax
80101fb6:	83 e0 10             	and    $0x10,%eax
80101fb9:	83 c8 e0             	or     $0xffffffe0,%eax
80101fbc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fbd:	f6 06 04             	testb  $0x4,(%esi)
80101fc0:	75 16                	jne    80101fd8 <idestart+0x98>
80101fc2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fc7:	89 ca                	mov    %ecx,%edx
80101fc9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fcd:	5b                   	pop    %ebx
80101fce:	5e                   	pop    %esi
80101fcf:	5f                   	pop    %edi
80101fd0:	5d                   	pop    %ebp
80101fd1:	c3                   	ret    
80101fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fd8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fdd:	89 ca                	mov    %ecx,%edx
80101fdf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fe0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fe5:	83 c6 5c             	add    $0x5c,%esi
80101fe8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fed:	fc                   	cld    
80101fee:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101ff0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff3:	5b                   	pop    %ebx
80101ff4:	5e                   	pop    %esi
80101ff5:	5f                   	pop    %edi
80101ff6:	5d                   	pop    %ebp
80101ff7:	c3                   	ret    
    panic("incorrect blockno");
80101ff8:	83 ec 0c             	sub    $0xc,%esp
80101ffb:	68 54 78 10 80       	push   $0x80107854
80102000:	e8 8b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80102005:	83 ec 0c             	sub    $0xc,%esp
80102008:	68 4b 78 10 80       	push   $0x8010784b
8010200d:	e8 7e e3 ff ff       	call   80100390 <panic>
80102012:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102020 <ideinit>:
{
80102020:	55                   	push   %ebp
80102021:	89 e5                	mov    %esp,%ebp
80102023:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102026:	68 66 78 10 80       	push   $0x80107866
8010202b:	68 80 b5 10 80       	push   $0x8010b580
80102030:	e8 2b 28 00 00       	call   80104860 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102035:	58                   	pop    %eax
80102036:	a1 00 3d 11 80       	mov    0x80113d00,%eax
8010203b:	5a                   	pop    %edx
8010203c:	83 e8 01             	sub    $0x1,%eax
8010203f:	50                   	push   %eax
80102040:	6a 0e                	push   $0xe
80102042:	e8 a9 02 00 00       	call   801022f0 <ioapicenable>
80102047:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010204a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010204f:	90                   	nop
80102050:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102051:	83 e0 c0             	and    $0xffffffc0,%eax
80102054:	3c 40                	cmp    $0x40,%al
80102056:	75 f8                	jne    80102050 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102058:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010205d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102062:	ee                   	out    %al,(%dx)
80102063:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102068:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010206d:	eb 06                	jmp    80102075 <ideinit+0x55>
8010206f:	90                   	nop
  for(i=0; i<1000; i++){
80102070:	83 e9 01             	sub    $0x1,%ecx
80102073:	74 0f                	je     80102084 <ideinit+0x64>
80102075:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102076:	84 c0                	test   %al,%al
80102078:	74 f6                	je     80102070 <ideinit+0x50>
      havedisk1 = 1;
8010207a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102081:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102084:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102089:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010208e:	ee                   	out    %al,(%dx)
}
8010208f:	c9                   	leave  
80102090:	c3                   	ret    
80102091:	eb 0d                	jmp    801020a0 <ideintr>
80102093:	90                   	nop
80102094:	90                   	nop
80102095:	90                   	nop
80102096:	90                   	nop
80102097:	90                   	nop
80102098:	90                   	nop
80102099:	90                   	nop
8010209a:	90                   	nop
8010209b:	90                   	nop
8010209c:	90                   	nop
8010209d:	90                   	nop
8010209e:	90                   	nop
8010209f:	90                   	nop

801020a0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801020a0:	55                   	push   %ebp
801020a1:	89 e5                	mov    %esp,%ebp
801020a3:	57                   	push   %edi
801020a4:	56                   	push   %esi
801020a5:	53                   	push   %ebx
801020a6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020a9:	68 80 b5 10 80       	push   $0x8010b580
801020ae:	e8 ed 28 00 00       	call   801049a0 <acquire>

  if((b = idequeue) == 0){
801020b3:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801020b9:	83 c4 10             	add    $0x10,%esp
801020bc:	85 db                	test   %ebx,%ebx
801020be:	74 67                	je     80102127 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020c0:	8b 43 58             	mov    0x58(%ebx),%eax
801020c3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020c8:	8b 3b                	mov    (%ebx),%edi
801020ca:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020d0:	75 31                	jne    80102103 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020d2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020d7:	89 f6                	mov    %esi,%esi
801020d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020e0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020e1:	89 c6                	mov    %eax,%esi
801020e3:	83 e6 c0             	and    $0xffffffc0,%esi
801020e6:	89 f1                	mov    %esi,%ecx
801020e8:	80 f9 40             	cmp    $0x40,%cl
801020eb:	75 f3                	jne    801020e0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020ed:	a8 21                	test   $0x21,%al
801020ef:	75 12                	jne    80102103 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801020f1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020f4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020f9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020fe:	fc                   	cld    
801020ff:	f3 6d                	rep insl (%dx),%es:(%edi)
80102101:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102103:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102106:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102109:	89 f9                	mov    %edi,%ecx
8010210b:	83 c9 02             	or     $0x2,%ecx
8010210e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102110:	53                   	push   %ebx
80102111:	e8 3a 21 00 00       	call   80104250 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102116:	a1 64 b5 10 80       	mov    0x8010b564,%eax
8010211b:	83 c4 10             	add    $0x10,%esp
8010211e:	85 c0                	test   %eax,%eax
80102120:	74 05                	je     80102127 <ideintr+0x87>
    idestart(idequeue);
80102122:	e8 19 fe ff ff       	call   80101f40 <idestart>
    release(&idelock);
80102127:	83 ec 0c             	sub    $0xc,%esp
8010212a:	68 80 b5 10 80       	push   $0x8010b580
8010212f:	e8 2c 29 00 00       	call   80104a60 <release>

  release(&idelock);
}
80102134:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102137:	5b                   	pop    %ebx
80102138:	5e                   	pop    %esi
80102139:	5f                   	pop    %edi
8010213a:	5d                   	pop    %ebp
8010213b:	c3                   	ret    
8010213c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102140 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102140:	55                   	push   %ebp
80102141:	89 e5                	mov    %esp,%ebp
80102143:	53                   	push   %ebx
80102144:	83 ec 10             	sub    $0x10,%esp
80102147:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010214a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010214d:	50                   	push   %eax
8010214e:	e8 bd 26 00 00       	call   80104810 <holdingsleep>
80102153:	83 c4 10             	add    $0x10,%esp
80102156:	85 c0                	test   %eax,%eax
80102158:	0f 84 c6 00 00 00    	je     80102224 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010215e:	8b 03                	mov    (%ebx),%eax
80102160:	83 e0 06             	and    $0x6,%eax
80102163:	83 f8 02             	cmp    $0x2,%eax
80102166:	0f 84 ab 00 00 00    	je     80102217 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010216c:	8b 53 04             	mov    0x4(%ebx),%edx
8010216f:	85 d2                	test   %edx,%edx
80102171:	74 0d                	je     80102180 <iderw+0x40>
80102173:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102178:	85 c0                	test   %eax,%eax
8010217a:	0f 84 b1 00 00 00    	je     80102231 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102180:	83 ec 0c             	sub    $0xc,%esp
80102183:	68 80 b5 10 80       	push   $0x8010b580
80102188:	e8 13 28 00 00       	call   801049a0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010218d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102193:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102196:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010219d:	85 d2                	test   %edx,%edx
8010219f:	75 09                	jne    801021aa <iderw+0x6a>
801021a1:	eb 6d                	jmp    80102210 <iderw+0xd0>
801021a3:	90                   	nop
801021a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021a8:	89 c2                	mov    %eax,%edx
801021aa:	8b 42 58             	mov    0x58(%edx),%eax
801021ad:	85 c0                	test   %eax,%eax
801021af:	75 f7                	jne    801021a8 <iderw+0x68>
801021b1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801021b4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801021b6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
801021bc:	74 42                	je     80102200 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021be:	8b 03                	mov    (%ebx),%eax
801021c0:	83 e0 06             	and    $0x6,%eax
801021c3:	83 f8 02             	cmp    $0x2,%eax
801021c6:	74 23                	je     801021eb <iderw+0xab>
801021c8:	90                   	nop
801021c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021d0:	83 ec 08             	sub    $0x8,%esp
801021d3:	68 80 b5 10 80       	push   $0x8010b580
801021d8:	53                   	push   %ebx
801021d9:	e8 72 1e 00 00       	call   80104050 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021de:	8b 03                	mov    (%ebx),%eax
801021e0:	83 c4 10             	add    $0x10,%esp
801021e3:	83 e0 06             	and    $0x6,%eax
801021e6:	83 f8 02             	cmp    $0x2,%eax
801021e9:	75 e5                	jne    801021d0 <iderw+0x90>
  }


  release(&idelock);
801021eb:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801021f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021f5:	c9                   	leave  
  release(&idelock);
801021f6:	e9 65 28 00 00       	jmp    80104a60 <release>
801021fb:	90                   	nop
801021fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102200:	89 d8                	mov    %ebx,%eax
80102202:	e8 39 fd ff ff       	call   80101f40 <idestart>
80102207:	eb b5                	jmp    801021be <iderw+0x7e>
80102209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102210:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102215:	eb 9d                	jmp    801021b4 <iderw+0x74>
    panic("iderw: nothing to do");
80102217:	83 ec 0c             	sub    $0xc,%esp
8010221a:	68 80 78 10 80       	push   $0x80107880
8010221f:	e8 6c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102224:	83 ec 0c             	sub    $0xc,%esp
80102227:	68 6a 78 10 80       	push   $0x8010786a
8010222c:	e8 5f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102231:	83 ec 0c             	sub    $0xc,%esp
80102234:	68 95 78 10 80       	push   $0x80107895
80102239:	e8 52 e1 ff ff       	call   80100390 <panic>
8010223e:	66 90                	xchg   %ax,%ax

80102240 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102240:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102241:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
80102248:	00 c0 fe 
{
8010224b:	89 e5                	mov    %esp,%ebp
8010224d:	56                   	push   %esi
8010224e:	53                   	push   %ebx
  ioapic->reg = reg;
8010224f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102256:	00 00 00 
  return ioapic->data;
80102259:	a1 34 36 11 80       	mov    0x80113634,%eax
8010225e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102261:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102267:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010226d:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102274:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102277:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010227a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010227d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102280:	39 c2                	cmp    %eax,%edx
80102282:	74 16                	je     8010229a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102284:	83 ec 0c             	sub    $0xc,%esp
80102287:	68 b4 78 10 80       	push   $0x801078b4
8010228c:	e8 cf e3 ff ff       	call   80100660 <cprintf>
80102291:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102297:	83 c4 10             	add    $0x10,%esp
8010229a:	83 c3 21             	add    $0x21,%ebx
{
8010229d:	ba 10 00 00 00       	mov    $0x10,%edx
801022a2:	b8 20 00 00 00       	mov    $0x20,%eax
801022a7:	89 f6                	mov    %esi,%esi
801022a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801022b0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801022b2:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022b8:	89 c6                	mov    %eax,%esi
801022ba:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022c0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022c3:	89 71 10             	mov    %esi,0x10(%ecx)
801022c6:	8d 72 01             	lea    0x1(%edx),%esi
801022c9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022cc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022ce:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022d0:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801022d6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022dd:	75 d1                	jne    801022b0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022e2:	5b                   	pop    %ebx
801022e3:	5e                   	pop    %esi
801022e4:	5d                   	pop    %ebp
801022e5:	c3                   	ret    
801022e6:	8d 76 00             	lea    0x0(%esi),%esi
801022e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022f0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022f0:	55                   	push   %ebp
  ioapic->reg = reg;
801022f1:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
{
801022f7:	89 e5                	mov    %esp,%ebp
801022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022fc:	8d 50 20             	lea    0x20(%eax),%edx
801022ff:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102303:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102305:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010230b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010230e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102311:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102314:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102316:	a1 34 36 11 80       	mov    0x80113634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010231b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010231e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102321:	5d                   	pop    %ebp
80102322:	c3                   	ret    
80102323:	66 90                	xchg   %ax,%ax
80102325:	66 90                	xchg   %ax,%ax
80102327:	66 90                	xchg   %ax,%ax
80102329:	66 90                	xchg   %ax,%ax
8010232b:	66 90                	xchg   %ax,%ax
8010232d:	66 90                	xchg   %ax,%ax
8010232f:	90                   	nop

80102330 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102330:	55                   	push   %ebp
80102331:	89 e5                	mov    %esp,%ebp
80102333:	53                   	push   %ebx
80102334:	83 ec 04             	sub    $0x4,%esp
80102337:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010233a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102340:	75 70                	jne    801023b2 <kfree+0x82>
80102342:	81 fb a8 87 11 80    	cmp    $0x801187a8,%ebx
80102348:	72 68                	jb     801023b2 <kfree+0x82>
8010234a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102350:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102355:	77 5b                	ja     801023b2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102357:	83 ec 04             	sub    $0x4,%esp
8010235a:	68 00 10 00 00       	push   $0x1000
8010235f:	6a 01                	push   $0x1
80102361:	53                   	push   %ebx
80102362:	e8 49 27 00 00       	call   80104ab0 <memset>

  if(kmem.use_lock)
80102367:	8b 15 74 36 11 80    	mov    0x80113674,%edx
8010236d:	83 c4 10             	add    $0x10,%esp
80102370:	85 d2                	test   %edx,%edx
80102372:	75 2c                	jne    801023a0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102374:	a1 78 36 11 80       	mov    0x80113678,%eax
80102379:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010237b:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
80102380:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
80102386:	85 c0                	test   %eax,%eax
80102388:	75 06                	jne    80102390 <kfree+0x60>
    release(&kmem.lock);
}
8010238a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010238d:	c9                   	leave  
8010238e:	c3                   	ret    
8010238f:	90                   	nop
    release(&kmem.lock);
80102390:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
80102397:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010239a:	c9                   	leave  
    release(&kmem.lock);
8010239b:	e9 c0 26 00 00       	jmp    80104a60 <release>
    acquire(&kmem.lock);
801023a0:	83 ec 0c             	sub    $0xc,%esp
801023a3:	68 40 36 11 80       	push   $0x80113640
801023a8:	e8 f3 25 00 00       	call   801049a0 <acquire>
801023ad:	83 c4 10             	add    $0x10,%esp
801023b0:	eb c2                	jmp    80102374 <kfree+0x44>
    panic("kfree");
801023b2:	83 ec 0c             	sub    $0xc,%esp
801023b5:	68 e6 78 10 80       	push   $0x801078e6
801023ba:	e8 d1 df ff ff       	call   80100390 <panic>
801023bf:	90                   	nop

801023c0 <freerange>:
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	56                   	push   %esi
801023c4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023c5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023dd:	39 de                	cmp    %ebx,%esi
801023df:	72 23                	jb     80102404 <freerange+0x44>
801023e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023e8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023ee:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023f7:	50                   	push   %eax
801023f8:	e8 33 ff ff ff       	call   80102330 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023fd:	83 c4 10             	add    $0x10,%esp
80102400:	39 f3                	cmp    %esi,%ebx
80102402:	76 e4                	jbe    801023e8 <freerange+0x28>
}
80102404:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102407:	5b                   	pop    %ebx
80102408:	5e                   	pop    %esi
80102409:	5d                   	pop    %ebp
8010240a:	c3                   	ret    
8010240b:	90                   	nop
8010240c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102410 <kinit1>:
{
80102410:	55                   	push   %ebp
80102411:	89 e5                	mov    %esp,%ebp
80102413:	56                   	push   %esi
80102414:	53                   	push   %ebx
80102415:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102418:	83 ec 08             	sub    $0x8,%esp
8010241b:	68 ec 78 10 80       	push   $0x801078ec
80102420:	68 40 36 11 80       	push   $0x80113640
80102425:	e8 36 24 00 00       	call   80104860 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010242a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010242d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102430:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
80102437:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010243a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102440:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102446:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010244c:	39 de                	cmp    %ebx,%esi
8010244e:	72 1c                	jb     8010246c <kinit1+0x5c>
    kfree(p);
80102450:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102456:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102459:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010245f:	50                   	push   %eax
80102460:	e8 cb fe ff ff       	call   80102330 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102465:	83 c4 10             	add    $0x10,%esp
80102468:	39 de                	cmp    %ebx,%esi
8010246a:	73 e4                	jae    80102450 <kinit1+0x40>
}
8010246c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010246f:	5b                   	pop    %ebx
80102470:	5e                   	pop    %esi
80102471:	5d                   	pop    %ebp
80102472:	c3                   	ret    
80102473:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102480 <kinit2>:
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	56                   	push   %esi
80102484:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102485:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102488:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010248b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102491:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102497:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010249d:	39 de                	cmp    %ebx,%esi
8010249f:	72 23                	jb     801024c4 <kinit2+0x44>
801024a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024a8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024ae:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024b7:	50                   	push   %eax
801024b8:	e8 73 fe ff ff       	call   80102330 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024bd:	83 c4 10             	add    $0x10,%esp
801024c0:	39 de                	cmp    %ebx,%esi
801024c2:	73 e4                	jae    801024a8 <kinit2+0x28>
  kmem.use_lock = 1;
801024c4:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
801024cb:	00 00 00 
}
801024ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024d1:	5b                   	pop    %ebx
801024d2:	5e                   	pop    %esi
801024d3:	5d                   	pop    %ebp
801024d4:	c3                   	ret    
801024d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024e0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801024e0:	a1 74 36 11 80       	mov    0x80113674,%eax
801024e5:	85 c0                	test   %eax,%eax
801024e7:	75 1f                	jne    80102508 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024e9:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
801024ee:	85 c0                	test   %eax,%eax
801024f0:	74 0e                	je     80102500 <kalloc+0x20>
    kmem.freelist = r->next;
801024f2:	8b 10                	mov    (%eax),%edx
801024f4:	89 15 78 36 11 80    	mov    %edx,0x80113678
801024fa:	c3                   	ret    
801024fb:	90                   	nop
801024fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102500:	f3 c3                	repz ret 
80102502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102508:	55                   	push   %ebp
80102509:	89 e5                	mov    %esp,%ebp
8010250b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010250e:	68 40 36 11 80       	push   $0x80113640
80102513:	e8 88 24 00 00       	call   801049a0 <acquire>
  r = kmem.freelist;
80102518:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010251d:	83 c4 10             	add    $0x10,%esp
80102520:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102526:	85 c0                	test   %eax,%eax
80102528:	74 08                	je     80102532 <kalloc+0x52>
    kmem.freelist = r->next;
8010252a:	8b 08                	mov    (%eax),%ecx
8010252c:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
80102532:	85 d2                	test   %edx,%edx
80102534:	74 16                	je     8010254c <kalloc+0x6c>
    release(&kmem.lock);
80102536:	83 ec 0c             	sub    $0xc,%esp
80102539:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010253c:	68 40 36 11 80       	push   $0x80113640
80102541:	e8 1a 25 00 00       	call   80104a60 <release>
  return (char*)r;
80102546:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102549:	83 c4 10             	add    $0x10,%esp
}
8010254c:	c9                   	leave  
8010254d:	c3                   	ret    
8010254e:	66 90                	xchg   %ax,%ax

80102550 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102550:	ba 64 00 00 00       	mov    $0x64,%edx
80102555:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102556:	a8 01                	test   $0x1,%al
80102558:	0f 84 c2 00 00 00    	je     80102620 <kbdgetc+0xd0>
8010255e:	ba 60 00 00 00       	mov    $0x60,%edx
80102563:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102564:	0f b6 d0             	movzbl %al,%edx
80102567:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
8010256d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102573:	0f 84 7f 00 00 00    	je     801025f8 <kbdgetc+0xa8>
{
80102579:	55                   	push   %ebp
8010257a:	89 e5                	mov    %esp,%ebp
8010257c:	53                   	push   %ebx
8010257d:	89 cb                	mov    %ecx,%ebx
8010257f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102582:	84 c0                	test   %al,%al
80102584:	78 4a                	js     801025d0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102586:	85 db                	test   %ebx,%ebx
80102588:	74 09                	je     80102593 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010258a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010258d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102590:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102593:	0f b6 82 20 7a 10 80 	movzbl -0x7fef85e0(%edx),%eax
8010259a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010259c:	0f b6 82 20 79 10 80 	movzbl -0x7fef86e0(%edx),%eax
801025a3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025a5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801025a7:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801025ad:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801025b0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025b3:	8b 04 85 00 79 10 80 	mov    -0x7fef8700(,%eax,4),%eax
801025ba:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801025be:	74 31                	je     801025f1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025c0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025c3:	83 fa 19             	cmp    $0x19,%edx
801025c6:	77 40                	ja     80102608 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025c8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025cb:	5b                   	pop    %ebx
801025cc:	5d                   	pop    %ebp
801025cd:	c3                   	ret    
801025ce:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025d0:	83 e0 7f             	and    $0x7f,%eax
801025d3:	85 db                	test   %ebx,%ebx
801025d5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025d8:	0f b6 82 20 7a 10 80 	movzbl -0x7fef85e0(%edx),%eax
801025df:	83 c8 40             	or     $0x40,%eax
801025e2:	0f b6 c0             	movzbl %al,%eax
801025e5:	f7 d0                	not    %eax
801025e7:	21 c1                	and    %eax,%ecx
    return 0;
801025e9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801025eb:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
801025f1:	5b                   	pop    %ebx
801025f2:	5d                   	pop    %ebp
801025f3:	c3                   	ret    
801025f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025f8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801025fb:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801025fd:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
80102603:	c3                   	ret    
80102604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102608:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010260b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010260e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010260f:	83 f9 1a             	cmp    $0x1a,%ecx
80102612:	0f 42 c2             	cmovb  %edx,%eax
}
80102615:	5d                   	pop    %ebp
80102616:	c3                   	ret    
80102617:	89 f6                	mov    %esi,%esi
80102619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102625:	c3                   	ret    
80102626:	8d 76 00             	lea    0x0(%esi),%esi
80102629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102630 <kbdintr>:

void
kbdintr(void)
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102636:	68 50 25 10 80       	push   $0x80102550
8010263b:	e8 d0 e1 ff ff       	call   80100810 <consoleintr>
}
80102640:	83 c4 10             	add    $0x10,%esp
80102643:	c9                   	leave  
80102644:	c3                   	ret    
80102645:	66 90                	xchg   %ax,%ax
80102647:	66 90                	xchg   %ax,%ax
80102649:	66 90                	xchg   %ax,%ax
8010264b:	66 90                	xchg   %ax,%ax
8010264d:	66 90                	xchg   %ax,%ax
8010264f:	90                   	nop

80102650 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102650:	a1 7c 36 11 80       	mov    0x8011367c,%eax
{
80102655:	55                   	push   %ebp
80102656:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102658:	85 c0                	test   %eax,%eax
8010265a:	0f 84 c8 00 00 00    	je     80102728 <lapicinit+0xd8>
  lapic[index] = value;
80102660:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102667:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010266a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010266d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102674:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102677:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010267a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102681:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102684:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102687:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010268e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102691:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102694:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010269b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010269e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026a8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ab:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026ae:	8b 50 30             	mov    0x30(%eax),%edx
801026b1:	c1 ea 10             	shr    $0x10,%edx
801026b4:	80 fa 03             	cmp    $0x3,%dl
801026b7:	77 77                	ja     80102730 <lapicinit+0xe0>
  lapic[index] = value;
801026b9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026c0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026c3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026cd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026d3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026da:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026dd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026e0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026e7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ea:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026ed:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026fa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102701:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102704:	8b 50 20             	mov    0x20(%eax),%edx
80102707:	89 f6                	mov    %esi,%esi
80102709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102710:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102716:	80 e6 10             	and    $0x10,%dh
80102719:	75 f5                	jne    80102710 <lapicinit+0xc0>
  lapic[index] = value;
8010271b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102722:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102725:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102728:	5d                   	pop    %ebp
80102729:	c3                   	ret    
8010272a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102730:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102737:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010273a:	8b 50 20             	mov    0x20(%eax),%edx
8010273d:	e9 77 ff ff ff       	jmp    801026b9 <lapicinit+0x69>
80102742:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102750:	8b 15 7c 36 11 80    	mov    0x8011367c,%edx
{
80102756:	55                   	push   %ebp
80102757:	31 c0                	xor    %eax,%eax
80102759:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010275b:	85 d2                	test   %edx,%edx
8010275d:	74 06                	je     80102765 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010275f:	8b 42 20             	mov    0x20(%edx),%eax
80102762:	c1 e8 18             	shr    $0x18,%eax
}
80102765:	5d                   	pop    %ebp
80102766:	c3                   	ret    
80102767:	89 f6                	mov    %esi,%esi
80102769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102770 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102770:	a1 7c 36 11 80       	mov    0x8011367c,%eax
{
80102775:	55                   	push   %ebp
80102776:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102778:	85 c0                	test   %eax,%eax
8010277a:	74 0d                	je     80102789 <lapiceoi+0x19>
  lapic[index] = value;
8010277c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102783:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102786:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102789:	5d                   	pop    %ebp
8010278a:	c3                   	ret    
8010278b:	90                   	nop
8010278c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102790 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
}
80102793:	5d                   	pop    %ebp
80102794:	c3                   	ret    
80102795:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027a0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027a0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027a1:	b8 0f 00 00 00       	mov    $0xf,%eax
801027a6:	ba 70 00 00 00       	mov    $0x70,%edx
801027ab:	89 e5                	mov    %esp,%ebp
801027ad:	53                   	push   %ebx
801027ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027b4:	ee                   	out    %al,(%dx)
801027b5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027ba:	ba 71 00 00 00       	mov    $0x71,%edx
801027bf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027c0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027c2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027c5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027cb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027cd:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027d0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027d3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027d5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027d8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027de:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801027e3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027e9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027ec:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027f3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027f9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102800:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102803:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102806:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010280c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010280f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102815:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102818:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010281e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102821:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102827:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010282a:	5b                   	pop    %ebx
8010282b:	5d                   	pop    %ebp
8010282c:	c3                   	ret    
8010282d:	8d 76 00             	lea    0x0(%esi),%esi

80102830 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102830:	55                   	push   %ebp
80102831:	b8 0b 00 00 00       	mov    $0xb,%eax
80102836:	ba 70 00 00 00       	mov    $0x70,%edx
8010283b:	89 e5                	mov    %esp,%ebp
8010283d:	57                   	push   %edi
8010283e:	56                   	push   %esi
8010283f:	53                   	push   %ebx
80102840:	83 ec 4c             	sub    $0x4c,%esp
80102843:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102844:	ba 71 00 00 00       	mov    $0x71,%edx
80102849:	ec                   	in     (%dx),%al
8010284a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010284d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102852:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102855:	8d 76 00             	lea    0x0(%esi),%esi
80102858:	31 c0                	xor    %eax,%eax
8010285a:	89 da                	mov    %ebx,%edx
8010285c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010285d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102862:	89 ca                	mov    %ecx,%edx
80102864:	ec                   	in     (%dx),%al
80102865:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102868:	89 da                	mov    %ebx,%edx
8010286a:	b8 02 00 00 00       	mov    $0x2,%eax
8010286f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102870:	89 ca                	mov    %ecx,%edx
80102872:	ec                   	in     (%dx),%al
80102873:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102876:	89 da                	mov    %ebx,%edx
80102878:	b8 04 00 00 00       	mov    $0x4,%eax
8010287d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287e:	89 ca                	mov    %ecx,%edx
80102880:	ec                   	in     (%dx),%al
80102881:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102884:	89 da                	mov    %ebx,%edx
80102886:	b8 07 00 00 00       	mov    $0x7,%eax
8010288b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288c:	89 ca                	mov    %ecx,%edx
8010288e:	ec                   	in     (%dx),%al
8010288f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102892:	89 da                	mov    %ebx,%edx
80102894:	b8 08 00 00 00       	mov    $0x8,%eax
80102899:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289a:	89 ca                	mov    %ecx,%edx
8010289c:	ec                   	in     (%dx),%al
8010289d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010289f:	89 da                	mov    %ebx,%edx
801028a1:	b8 09 00 00 00       	mov    $0x9,%eax
801028a6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028a7:	89 ca                	mov    %ecx,%edx
801028a9:	ec                   	in     (%dx),%al
801028aa:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ac:	89 da                	mov    %ebx,%edx
801028ae:	b8 0a 00 00 00       	mov    $0xa,%eax
801028b3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028b4:	89 ca                	mov    %ecx,%edx
801028b6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028b7:	84 c0                	test   %al,%al
801028b9:	78 9d                	js     80102858 <cmostime+0x28>
  return inb(CMOS_RETURN);
801028bb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801028bf:	89 fa                	mov    %edi,%edx
801028c1:	0f b6 fa             	movzbl %dl,%edi
801028c4:	89 f2                	mov    %esi,%edx
801028c6:	0f b6 f2             	movzbl %dl,%esi
801028c9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028cc:	89 da                	mov    %ebx,%edx
801028ce:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028d1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028d4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028d8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028db:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028df:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028e2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801028e6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028e9:	31 c0                	xor    %eax,%eax
801028eb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ec:	89 ca                	mov    %ecx,%edx
801028ee:	ec                   	in     (%dx),%al
801028ef:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f2:	89 da                	mov    %ebx,%edx
801028f4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028f7:	b8 02 00 00 00       	mov    $0x2,%eax
801028fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028fd:	89 ca                	mov    %ecx,%edx
801028ff:	ec                   	in     (%dx),%al
80102900:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102903:	89 da                	mov    %ebx,%edx
80102905:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102908:	b8 04 00 00 00       	mov    $0x4,%eax
8010290d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290e:	89 ca                	mov    %ecx,%edx
80102910:	ec                   	in     (%dx),%al
80102911:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102914:	89 da                	mov    %ebx,%edx
80102916:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102919:	b8 07 00 00 00       	mov    $0x7,%eax
8010291e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010291f:	89 ca                	mov    %ecx,%edx
80102921:	ec                   	in     (%dx),%al
80102922:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102925:	89 da                	mov    %ebx,%edx
80102927:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010292a:	b8 08 00 00 00       	mov    $0x8,%eax
8010292f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102930:	89 ca                	mov    %ecx,%edx
80102932:	ec                   	in     (%dx),%al
80102933:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102936:	89 da                	mov    %ebx,%edx
80102938:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010293b:	b8 09 00 00 00       	mov    $0x9,%eax
80102940:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102941:	89 ca                	mov    %ecx,%edx
80102943:	ec                   	in     (%dx),%al
80102944:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102947:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010294a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010294d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102950:	6a 18                	push   $0x18
80102952:	50                   	push   %eax
80102953:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102956:	50                   	push   %eax
80102957:	e8 a4 21 00 00       	call   80104b00 <memcmp>
8010295c:	83 c4 10             	add    $0x10,%esp
8010295f:	85 c0                	test   %eax,%eax
80102961:	0f 85 f1 fe ff ff    	jne    80102858 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102967:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010296b:	75 78                	jne    801029e5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010296d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102970:	89 c2                	mov    %eax,%edx
80102972:	83 e0 0f             	and    $0xf,%eax
80102975:	c1 ea 04             	shr    $0x4,%edx
80102978:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010297b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010297e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102981:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102984:	89 c2                	mov    %eax,%edx
80102986:	83 e0 0f             	and    $0xf,%eax
80102989:	c1 ea 04             	shr    $0x4,%edx
8010298c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010298f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102992:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102995:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102998:	89 c2                	mov    %eax,%edx
8010299a:	83 e0 0f             	and    $0xf,%eax
8010299d:	c1 ea 04             	shr    $0x4,%edx
801029a0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029a3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029a6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801029a9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029ac:	89 c2                	mov    %eax,%edx
801029ae:	83 e0 0f             	and    $0xf,%eax
801029b1:	c1 ea 04             	shr    $0x4,%edx
801029b4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029b7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ba:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029bd:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029c0:	89 c2                	mov    %eax,%edx
801029c2:	83 e0 0f             	and    $0xf,%eax
801029c5:	c1 ea 04             	shr    $0x4,%edx
801029c8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029cb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ce:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029d4:	89 c2                	mov    %eax,%edx
801029d6:	83 e0 0f             	and    $0xf,%eax
801029d9:	c1 ea 04             	shr    $0x4,%edx
801029dc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029df:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029e2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029e5:	8b 75 08             	mov    0x8(%ebp),%esi
801029e8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029eb:	89 06                	mov    %eax,(%esi)
801029ed:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029f0:	89 46 04             	mov    %eax,0x4(%esi)
801029f3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029f6:	89 46 08             	mov    %eax,0x8(%esi)
801029f9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029fc:	89 46 0c             	mov    %eax,0xc(%esi)
801029ff:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a02:	89 46 10             	mov    %eax,0x10(%esi)
80102a05:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a08:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102a0b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a15:	5b                   	pop    %ebx
80102a16:	5e                   	pop    %esi
80102a17:	5f                   	pop    %edi
80102a18:	5d                   	pop    %ebp
80102a19:	c3                   	ret    
80102a1a:	66 90                	xchg   %ax,%ax
80102a1c:	66 90                	xchg   %ax,%ax
80102a1e:	66 90                	xchg   %ax,%ax

80102a20 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a20:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102a26:	85 c9                	test   %ecx,%ecx
80102a28:	0f 8e 8a 00 00 00    	jle    80102ab8 <install_trans+0x98>
{
80102a2e:	55                   	push   %ebp
80102a2f:	89 e5                	mov    %esp,%ebp
80102a31:	57                   	push   %edi
80102a32:	56                   	push   %esi
80102a33:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a34:	31 db                	xor    %ebx,%ebx
{
80102a36:	83 ec 0c             	sub    $0xc,%esp
80102a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a40:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102a45:	83 ec 08             	sub    $0x8,%esp
80102a48:	01 d8                	add    %ebx,%eax
80102a4a:	83 c0 01             	add    $0x1,%eax
80102a4d:	50                   	push   %eax
80102a4e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102a54:	e8 77 d6 ff ff       	call   801000d0 <bread>
80102a59:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a5b:	58                   	pop    %eax
80102a5c:	5a                   	pop    %edx
80102a5d:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102a64:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102a6a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a6d:	e8 5e d6 ff ff       	call   801000d0 <bread>
80102a72:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a74:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a77:	83 c4 0c             	add    $0xc,%esp
80102a7a:	68 00 02 00 00       	push   $0x200
80102a7f:	50                   	push   %eax
80102a80:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a83:	50                   	push   %eax
80102a84:	e8 d7 20 00 00       	call   80104b60 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a89:	89 34 24             	mov    %esi,(%esp)
80102a8c:	e8 0f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a91:	89 3c 24             	mov    %edi,(%esp)
80102a94:	e8 47 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a99:	89 34 24             	mov    %esi,(%esp)
80102a9c:	e8 3f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102aa1:	83 c4 10             	add    $0x10,%esp
80102aa4:	39 1d c8 36 11 80    	cmp    %ebx,0x801136c8
80102aaa:	7f 94                	jg     80102a40 <install_trans+0x20>
  }
}
80102aac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102aaf:	5b                   	pop    %ebx
80102ab0:	5e                   	pop    %esi
80102ab1:	5f                   	pop    %edi
80102ab2:	5d                   	pop    %ebp
80102ab3:	c3                   	ret    
80102ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ab8:	f3 c3                	repz ret 
80102aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ac0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ac0:	55                   	push   %ebp
80102ac1:	89 e5                	mov    %esp,%ebp
80102ac3:	56                   	push   %esi
80102ac4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102ac5:	83 ec 08             	sub    $0x8,%esp
80102ac8:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102ace:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102ad4:	e8 f7 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ad9:	8b 1d c8 36 11 80    	mov    0x801136c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102adf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ae2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102ae4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102ae6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ae9:	7e 16                	jle    80102b01 <write_head+0x41>
80102aeb:	c1 e3 02             	shl    $0x2,%ebx
80102aee:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102af0:	8b 8a cc 36 11 80    	mov    -0x7feec934(%edx),%ecx
80102af6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102afa:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102afd:	39 da                	cmp    %ebx,%edx
80102aff:	75 ef                	jne    80102af0 <write_head+0x30>
  }
  bwrite(buf);
80102b01:	83 ec 0c             	sub    $0xc,%esp
80102b04:	56                   	push   %esi
80102b05:	e8 96 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b0a:	89 34 24             	mov    %esi,(%esp)
80102b0d:	e8 ce d6 ff ff       	call   801001e0 <brelse>
}
80102b12:	83 c4 10             	add    $0x10,%esp
80102b15:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b18:	5b                   	pop    %ebx
80102b19:	5e                   	pop    %esi
80102b1a:	5d                   	pop    %ebp
80102b1b:	c3                   	ret    
80102b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b20 <initlog>:
{
80102b20:	55                   	push   %ebp
80102b21:	89 e5                	mov    %esp,%ebp
80102b23:	53                   	push   %ebx
80102b24:	83 ec 2c             	sub    $0x2c,%esp
80102b27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b2a:	68 20 7b 10 80       	push   $0x80107b20
80102b2f:	68 80 36 11 80       	push   $0x80113680
80102b34:	e8 27 1d 00 00       	call   80104860 <initlock>
  readsb(dev, &sb);
80102b39:	58                   	pop    %eax
80102b3a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b3d:	5a                   	pop    %edx
80102b3e:	50                   	push   %eax
80102b3f:	53                   	push   %ebx
80102b40:	e8 0b e9 ff ff       	call   80101450 <readsb>
  log.size = sb.nlog;
80102b45:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b4b:	59                   	pop    %ecx
  log.dev = dev;
80102b4c:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4
  log.size = sb.nlog;
80102b52:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  log.start = sb.logstart;
80102b58:	a3 b4 36 11 80       	mov    %eax,0x801136b4
  struct buf *buf = bread(log.dev, log.start);
80102b5d:	5a                   	pop    %edx
80102b5e:	50                   	push   %eax
80102b5f:	53                   	push   %ebx
80102b60:	e8 6b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b65:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b68:	83 c4 10             	add    $0x10,%esp
80102b6b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b6d:	89 1d c8 36 11 80    	mov    %ebx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102b73:	7e 1c                	jle    80102b91 <initlog+0x71>
80102b75:	c1 e3 02             	shl    $0x2,%ebx
80102b78:	31 d2                	xor    %edx,%edx
80102b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102b80:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b84:	83 c2 04             	add    $0x4,%edx
80102b87:	89 8a c8 36 11 80    	mov    %ecx,-0x7feec938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102b8d:	39 d3                	cmp    %edx,%ebx
80102b8f:	75 ef                	jne    80102b80 <initlog+0x60>
  brelse(buf);
80102b91:	83 ec 0c             	sub    $0xc,%esp
80102b94:	50                   	push   %eax
80102b95:	e8 46 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b9a:	e8 81 fe ff ff       	call   80102a20 <install_trans>
  log.lh.n = 0;
80102b9f:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102ba6:	00 00 00 
  write_head(); // clear the log
80102ba9:	e8 12 ff ff ff       	call   80102ac0 <write_head>
}
80102bae:	83 c4 10             	add    $0x10,%esp
80102bb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bb4:	c9                   	leave  
80102bb5:	c3                   	ret    
80102bb6:	8d 76 00             	lea    0x0(%esi),%esi
80102bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bc0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102bc0:	55                   	push   %ebp
80102bc1:	89 e5                	mov    %esp,%ebp
80102bc3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102bc6:	68 80 36 11 80       	push   $0x80113680
80102bcb:	e8 d0 1d 00 00       	call   801049a0 <acquire>
80102bd0:	83 c4 10             	add    $0x10,%esp
80102bd3:	eb 18                	jmp    80102bed <begin_op+0x2d>
80102bd5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bd8:	83 ec 08             	sub    $0x8,%esp
80102bdb:	68 80 36 11 80       	push   $0x80113680
80102be0:	68 80 36 11 80       	push   $0x80113680
80102be5:	e8 66 14 00 00       	call   80104050 <sleep>
80102bea:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102bed:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102bf2:	85 c0                	test   %eax,%eax
80102bf4:	75 e2                	jne    80102bd8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102bf6:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102bfb:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102c01:	83 c0 01             	add    $0x1,%eax
80102c04:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c07:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c0a:	83 fa 1e             	cmp    $0x1e,%edx
80102c0d:	7f c9                	jg     80102bd8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c0f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102c12:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102c17:	68 80 36 11 80       	push   $0x80113680
80102c1c:	e8 3f 1e 00 00       	call   80104a60 <release>
      break;
    }
  }
}
80102c21:	83 c4 10             	add    $0x10,%esp
80102c24:	c9                   	leave  
80102c25:	c3                   	ret    
80102c26:	8d 76 00             	lea    0x0(%esi),%esi
80102c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c30 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c30:	55                   	push   %ebp
80102c31:	89 e5                	mov    %esp,%ebp
80102c33:	57                   	push   %edi
80102c34:	56                   	push   %esi
80102c35:	53                   	push   %ebx
80102c36:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c39:	68 80 36 11 80       	push   $0x80113680
80102c3e:	e8 5d 1d 00 00       	call   801049a0 <acquire>
  log.outstanding -= 1;
80102c43:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102c48:	8b 35 c0 36 11 80    	mov    0x801136c0,%esi
80102c4e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c51:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c54:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c56:	89 1d bc 36 11 80    	mov    %ebx,0x801136bc
  if(log.committing)
80102c5c:	0f 85 1a 01 00 00    	jne    80102d7c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c62:	85 db                	test   %ebx,%ebx
80102c64:	0f 85 ee 00 00 00    	jne    80102d58 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c6a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c6d:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102c74:	00 00 00 
  release(&log.lock);
80102c77:	68 80 36 11 80       	push   $0x80113680
80102c7c:	e8 df 1d 00 00       	call   80104a60 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c81:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102c87:	83 c4 10             	add    $0x10,%esp
80102c8a:	85 c9                	test   %ecx,%ecx
80102c8c:	0f 8e 85 00 00 00    	jle    80102d17 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c92:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102c97:	83 ec 08             	sub    $0x8,%esp
80102c9a:	01 d8                	add    %ebx,%eax
80102c9c:	83 c0 01             	add    $0x1,%eax
80102c9f:	50                   	push   %eax
80102ca0:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102ca6:	e8 25 d4 ff ff       	call   801000d0 <bread>
80102cab:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cad:	58                   	pop    %eax
80102cae:	5a                   	pop    %edx
80102caf:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102cb6:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102cbc:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cbf:	e8 0c d4 ff ff       	call   801000d0 <bread>
80102cc4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102cc6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102cc9:	83 c4 0c             	add    $0xc,%esp
80102ccc:	68 00 02 00 00       	push   $0x200
80102cd1:	50                   	push   %eax
80102cd2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cd5:	50                   	push   %eax
80102cd6:	e8 85 1e 00 00       	call   80104b60 <memmove>
    bwrite(to);  // write the log
80102cdb:	89 34 24             	mov    %esi,(%esp)
80102cde:	e8 bd d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102ce3:	89 3c 24             	mov    %edi,(%esp)
80102ce6:	e8 f5 d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102ceb:	89 34 24             	mov    %esi,(%esp)
80102cee:	e8 ed d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cf3:	83 c4 10             	add    $0x10,%esp
80102cf6:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80102cfc:	7c 94                	jl     80102c92 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cfe:	e8 bd fd ff ff       	call   80102ac0 <write_head>
    install_trans(); // Now install writes to home locations
80102d03:	e8 18 fd ff ff       	call   80102a20 <install_trans>
    log.lh.n = 0;
80102d08:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102d0f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d12:	e8 a9 fd ff ff       	call   80102ac0 <write_head>
    acquire(&log.lock);
80102d17:	83 ec 0c             	sub    $0xc,%esp
80102d1a:	68 80 36 11 80       	push   $0x80113680
80102d1f:	e8 7c 1c 00 00       	call   801049a0 <acquire>
    wakeup(&log);
80102d24:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
80102d2b:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102d32:	00 00 00 
    wakeup(&log);
80102d35:	e8 16 15 00 00       	call   80104250 <wakeup>
    release(&log.lock);
80102d3a:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102d41:	e8 1a 1d 00 00       	call   80104a60 <release>
80102d46:	83 c4 10             	add    $0x10,%esp
}
80102d49:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d4c:	5b                   	pop    %ebx
80102d4d:	5e                   	pop    %esi
80102d4e:	5f                   	pop    %edi
80102d4f:	5d                   	pop    %ebp
80102d50:	c3                   	ret    
80102d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d58:	83 ec 0c             	sub    $0xc,%esp
80102d5b:	68 80 36 11 80       	push   $0x80113680
80102d60:	e8 eb 14 00 00       	call   80104250 <wakeup>
  release(&log.lock);
80102d65:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102d6c:	e8 ef 1c 00 00       	call   80104a60 <release>
80102d71:	83 c4 10             	add    $0x10,%esp
}
80102d74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d77:	5b                   	pop    %ebx
80102d78:	5e                   	pop    %esi
80102d79:	5f                   	pop    %edi
80102d7a:	5d                   	pop    %ebp
80102d7b:	c3                   	ret    
    panic("log.committing");
80102d7c:	83 ec 0c             	sub    $0xc,%esp
80102d7f:	68 24 7b 10 80       	push   $0x80107b24
80102d84:	e8 07 d6 ff ff       	call   80100390 <panic>
80102d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d90 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d90:	55                   	push   %ebp
80102d91:	89 e5                	mov    %esp,%ebp
80102d93:	53                   	push   %ebx
80102d94:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d97:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
{
80102d9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102da0:	83 fa 1d             	cmp    $0x1d,%edx
80102da3:	0f 8f 9d 00 00 00    	jg     80102e46 <log_write+0xb6>
80102da9:	a1 b8 36 11 80       	mov    0x801136b8,%eax
80102dae:	83 e8 01             	sub    $0x1,%eax
80102db1:	39 c2                	cmp    %eax,%edx
80102db3:	0f 8d 8d 00 00 00    	jge    80102e46 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102db9:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102dbe:	85 c0                	test   %eax,%eax
80102dc0:	0f 8e 8d 00 00 00    	jle    80102e53 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102dc6:	83 ec 0c             	sub    $0xc,%esp
80102dc9:	68 80 36 11 80       	push   $0x80113680
80102dce:	e8 cd 1b 00 00       	call   801049a0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102dd3:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102dd9:	83 c4 10             	add    $0x10,%esp
80102ddc:	83 f9 00             	cmp    $0x0,%ecx
80102ddf:	7e 57                	jle    80102e38 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102de1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102de4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102de6:	3b 15 cc 36 11 80    	cmp    0x801136cc,%edx
80102dec:	75 0b                	jne    80102df9 <log_write+0x69>
80102dee:	eb 38                	jmp    80102e28 <log_write+0x98>
80102df0:	39 14 85 cc 36 11 80 	cmp    %edx,-0x7feec934(,%eax,4)
80102df7:	74 2f                	je     80102e28 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102df9:	83 c0 01             	add    $0x1,%eax
80102dfc:	39 c1                	cmp    %eax,%ecx
80102dfe:	75 f0                	jne    80102df0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102e00:	89 14 85 cc 36 11 80 	mov    %edx,-0x7feec934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e07:	83 c0 01             	add    $0x1,%eax
80102e0a:	a3 c8 36 11 80       	mov    %eax,0x801136c8
  b->flags |= B_DIRTY; // prevent eviction
80102e0f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e12:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80102e19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e1c:	c9                   	leave  
  release(&log.lock);
80102e1d:	e9 3e 1c 00 00       	jmp    80104a60 <release>
80102e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e28:	89 14 85 cc 36 11 80 	mov    %edx,-0x7feec934(,%eax,4)
80102e2f:	eb de                	jmp    80102e0f <log_write+0x7f>
80102e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e38:	8b 43 08             	mov    0x8(%ebx),%eax
80102e3b:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80102e40:	75 cd                	jne    80102e0f <log_write+0x7f>
80102e42:	31 c0                	xor    %eax,%eax
80102e44:	eb c1                	jmp    80102e07 <log_write+0x77>
    panic("too big a transaction");
80102e46:	83 ec 0c             	sub    $0xc,%esp
80102e49:	68 33 7b 10 80       	push   $0x80107b33
80102e4e:	e8 3d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e53:	83 ec 0c             	sub    $0xc,%esp
80102e56:	68 49 7b 10 80       	push   $0x80107b49
80102e5b:	e8 30 d5 ff ff       	call   80100390 <panic>

80102e60 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	53                   	push   %ebx
80102e64:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e67:	e8 64 0a 00 00       	call   801038d0 <cpuid>
80102e6c:	89 c3                	mov    %eax,%ebx
80102e6e:	e8 5d 0a 00 00       	call   801038d0 <cpuid>
80102e73:	83 ec 04             	sub    $0x4,%esp
80102e76:	53                   	push   %ebx
80102e77:	50                   	push   %eax
80102e78:	68 64 7b 10 80       	push   $0x80107b64
80102e7d:	e8 de d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e82:	e8 a9 2f 00 00       	call   80105e30 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e87:	e8 c4 09 00 00       	call   80103850 <mycpu>
80102e8c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e8e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e93:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e9a:	e8 91 0d 00 00       	call   80103c30 <scheduler>
80102e9f:	90                   	nop

80102ea0 <mpenter>:
{
80102ea0:	55                   	push   %ebp
80102ea1:	89 e5                	mov    %esp,%ebp
80102ea3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102ea6:	e8 d5 40 00 00       	call   80106f80 <switchkvm>
  seginit();
80102eab:	e8 40 40 00 00       	call   80106ef0 <seginit>
  lapicinit();
80102eb0:	e8 9b f7 ff ff       	call   80102650 <lapicinit>
  mpmain();
80102eb5:	e8 a6 ff ff ff       	call   80102e60 <mpmain>
80102eba:	66 90                	xchg   %ax,%ax
80102ebc:	66 90                	xchg   %ax,%ax
80102ebe:	66 90                	xchg   %ax,%ax

80102ec0 <main>:
{
80102ec0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ec4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ec7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eca:	55                   	push   %ebp
80102ecb:	89 e5                	mov    %esp,%ebp
80102ecd:	53                   	push   %ebx
80102ece:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102ecf:	83 ec 08             	sub    $0x8,%esp
80102ed2:	68 00 00 40 80       	push   $0x80400000
80102ed7:	68 a8 87 11 80       	push   $0x801187a8
80102edc:	e8 2f f5 ff ff       	call   80102410 <kinit1>
  kvmalloc();      // kernel page table
80102ee1:	e8 7a 45 00 00       	call   80107460 <kvmalloc>
  mpinit();        // detect other processors
80102ee6:	e8 75 01 00 00       	call   80103060 <mpinit>
  lapicinit();     // interrupt controller
80102eeb:	e8 60 f7 ff ff       	call   80102650 <lapicinit>
  seginit();       // segment descriptors
80102ef0:	e8 fb 3f 00 00       	call   80106ef0 <seginit>
  picinit();       // disable pic
80102ef5:	e8 46 03 00 00       	call   80103240 <picinit>
  ioapicinit();    // another interrupt controller
80102efa:	e8 41 f3 ff ff       	call   80102240 <ioapicinit>
  consoleinit();   // console hardware
80102eff:	e8 bc da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102f04:	e8 b7 32 00 00       	call   801061c0 <uartinit>
  pinit();         // process table
80102f09:	e8 22 09 00 00       	call   80103830 <pinit>
  tvinit();        // trap vectors
80102f0e:	e8 9d 2e 00 00       	call   80105db0 <tvinit>
  binit();         // buffer cache
80102f13:	e8 28 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f18:	e8 53 de ff ff       	call   80100d70 <fileinit>
  ideinit();       // disk 
80102f1d:	e8 fe f0 ff ff       	call   80102020 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f22:	83 c4 0c             	add    $0xc,%esp
80102f25:	68 8a 00 00 00       	push   $0x8a
80102f2a:	68 8c b4 10 80       	push   $0x8010b48c
80102f2f:	68 00 70 00 80       	push   $0x80007000
80102f34:	e8 27 1c 00 00       	call   80104b60 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f39:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80102f40:	00 00 00 
80102f43:	83 c4 10             	add    $0x10,%esp
80102f46:	05 80 37 11 80       	add    $0x80113780,%eax
80102f4b:	3d 80 37 11 80       	cmp    $0x80113780,%eax
80102f50:	76 71                	jbe    80102fc3 <main+0x103>
80102f52:	bb 80 37 11 80       	mov    $0x80113780,%ebx
80102f57:	89 f6                	mov    %esi,%esi
80102f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f60:	e8 eb 08 00 00       	call   80103850 <mycpu>
80102f65:	39 d8                	cmp    %ebx,%eax
80102f67:	74 41                	je     80102faa <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f69:	e8 72 f5 ff ff       	call   801024e0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f6e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f73:	c7 05 f8 6f 00 80 a0 	movl   $0x80102ea0,0x80006ff8
80102f7a:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f7d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102f84:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f87:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102f8c:	0f b6 03             	movzbl (%ebx),%eax
80102f8f:	83 ec 08             	sub    $0x8,%esp
80102f92:	68 00 70 00 00       	push   $0x7000
80102f97:	50                   	push   %eax
80102f98:	e8 03 f8 ff ff       	call   801027a0 <lapicstartap>
80102f9d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102fa0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102fa6:	85 c0                	test   %eax,%eax
80102fa8:	74 f6                	je     80102fa0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102faa:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80102fb1:	00 00 00 
80102fb4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102fba:	05 80 37 11 80       	add    $0x80113780,%eax
80102fbf:	39 c3                	cmp    %eax,%ebx
80102fc1:	72 9d                	jb     80102f60 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fc3:	83 ec 08             	sub    $0x8,%esp
80102fc6:	68 00 00 00 8e       	push   $0x8e000000
80102fcb:	68 00 00 40 80       	push   $0x80400000
80102fd0:	e8 ab f4 ff ff       	call   80102480 <kinit2>
  userinit();      // first user process
80102fd5:	e8 46 09 00 00       	call   80103920 <userinit>
  mpmain();        // finish this processor's setup
80102fda:	e8 81 fe ff ff       	call   80102e60 <mpmain>
80102fdf:	90                   	nop

80102fe0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	57                   	push   %edi
80102fe4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fe5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102feb:	53                   	push   %ebx
  e = addr+len;
80102fec:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102fef:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102ff2:	39 de                	cmp    %ebx,%esi
80102ff4:	72 10                	jb     80103006 <mpsearch1+0x26>
80102ff6:	eb 50                	jmp    80103048 <mpsearch1+0x68>
80102ff8:	90                   	nop
80102ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103000:	39 fb                	cmp    %edi,%ebx
80103002:	89 fe                	mov    %edi,%esi
80103004:	76 42                	jbe    80103048 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103006:	83 ec 04             	sub    $0x4,%esp
80103009:	8d 7e 10             	lea    0x10(%esi),%edi
8010300c:	6a 04                	push   $0x4
8010300e:	68 78 7b 10 80       	push   $0x80107b78
80103013:	56                   	push   %esi
80103014:	e8 e7 1a 00 00       	call   80104b00 <memcmp>
80103019:	83 c4 10             	add    $0x10,%esp
8010301c:	85 c0                	test   %eax,%eax
8010301e:	75 e0                	jne    80103000 <mpsearch1+0x20>
80103020:	89 f1                	mov    %esi,%ecx
80103022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103028:	0f b6 11             	movzbl (%ecx),%edx
8010302b:	83 c1 01             	add    $0x1,%ecx
8010302e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103030:	39 f9                	cmp    %edi,%ecx
80103032:	75 f4                	jne    80103028 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103034:	84 c0                	test   %al,%al
80103036:	75 c8                	jne    80103000 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103038:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010303b:	89 f0                	mov    %esi,%eax
8010303d:	5b                   	pop    %ebx
8010303e:	5e                   	pop    %esi
8010303f:	5f                   	pop    %edi
80103040:	5d                   	pop    %ebp
80103041:	c3                   	ret    
80103042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103048:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010304b:	31 f6                	xor    %esi,%esi
}
8010304d:	89 f0                	mov    %esi,%eax
8010304f:	5b                   	pop    %ebx
80103050:	5e                   	pop    %esi
80103051:	5f                   	pop    %edi
80103052:	5d                   	pop    %ebp
80103053:	c3                   	ret    
80103054:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010305a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103060 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103060:	55                   	push   %ebp
80103061:	89 e5                	mov    %esp,%ebp
80103063:	57                   	push   %edi
80103064:	56                   	push   %esi
80103065:	53                   	push   %ebx
80103066:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103069:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103070:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103077:	c1 e0 08             	shl    $0x8,%eax
8010307a:	09 d0                	or     %edx,%eax
8010307c:	c1 e0 04             	shl    $0x4,%eax
8010307f:	85 c0                	test   %eax,%eax
80103081:	75 1b                	jne    8010309e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103083:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010308a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103091:	c1 e0 08             	shl    $0x8,%eax
80103094:	09 d0                	or     %edx,%eax
80103096:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103099:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010309e:	ba 00 04 00 00       	mov    $0x400,%edx
801030a3:	e8 38 ff ff ff       	call   80102fe0 <mpsearch1>
801030a8:	85 c0                	test   %eax,%eax
801030aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801030ad:	0f 84 3d 01 00 00    	je     801031f0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030b6:	8b 58 04             	mov    0x4(%eax),%ebx
801030b9:	85 db                	test   %ebx,%ebx
801030bb:	0f 84 4f 01 00 00    	je     80103210 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030c1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030c7:	83 ec 04             	sub    $0x4,%esp
801030ca:	6a 04                	push   $0x4
801030cc:	68 95 7b 10 80       	push   $0x80107b95
801030d1:	56                   	push   %esi
801030d2:	e8 29 1a 00 00       	call   80104b00 <memcmp>
801030d7:	83 c4 10             	add    $0x10,%esp
801030da:	85 c0                	test   %eax,%eax
801030dc:	0f 85 2e 01 00 00    	jne    80103210 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801030e2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801030e9:	3c 01                	cmp    $0x1,%al
801030eb:	0f 95 c2             	setne  %dl
801030ee:	3c 04                	cmp    $0x4,%al
801030f0:	0f 95 c0             	setne  %al
801030f3:	20 c2                	and    %al,%dl
801030f5:	0f 85 15 01 00 00    	jne    80103210 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801030fb:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103102:	66 85 ff             	test   %di,%di
80103105:	74 1a                	je     80103121 <mpinit+0xc1>
80103107:	89 f0                	mov    %esi,%eax
80103109:	01 f7                	add    %esi,%edi
  sum = 0;
8010310b:	31 d2                	xor    %edx,%edx
8010310d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103110:	0f b6 08             	movzbl (%eax),%ecx
80103113:	83 c0 01             	add    $0x1,%eax
80103116:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103118:	39 c7                	cmp    %eax,%edi
8010311a:	75 f4                	jne    80103110 <mpinit+0xb0>
8010311c:	84 d2                	test   %dl,%dl
8010311e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103121:	85 f6                	test   %esi,%esi
80103123:	0f 84 e7 00 00 00    	je     80103210 <mpinit+0x1b0>
80103129:	84 d2                	test   %dl,%dl
8010312b:	0f 85 df 00 00 00    	jne    80103210 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103131:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103137:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010313c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103143:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103149:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010314e:	01 d6                	add    %edx,%esi
80103150:	39 c6                	cmp    %eax,%esi
80103152:	76 23                	jbe    80103177 <mpinit+0x117>
    switch(*p){
80103154:	0f b6 10             	movzbl (%eax),%edx
80103157:	80 fa 04             	cmp    $0x4,%dl
8010315a:	0f 87 ca 00 00 00    	ja     8010322a <mpinit+0x1ca>
80103160:	ff 24 95 bc 7b 10 80 	jmp    *-0x7fef8444(,%edx,4)
80103167:	89 f6                	mov    %esi,%esi
80103169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103170:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103173:	39 c6                	cmp    %eax,%esi
80103175:	77 dd                	ja     80103154 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103177:	85 db                	test   %ebx,%ebx
80103179:	0f 84 9e 00 00 00    	je     8010321d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010317f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103182:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103186:	74 15                	je     8010319d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103188:	b8 70 00 00 00       	mov    $0x70,%eax
8010318d:	ba 22 00 00 00       	mov    $0x22,%edx
80103192:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103193:	ba 23 00 00 00       	mov    $0x23,%edx
80103198:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103199:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010319c:	ee                   	out    %al,(%dx)
  }
}
8010319d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031a0:	5b                   	pop    %ebx
801031a1:	5e                   	pop    %esi
801031a2:	5f                   	pop    %edi
801031a3:	5d                   	pop    %ebp
801031a4:	c3                   	ret    
801031a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801031a8:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
801031ae:	83 f9 07             	cmp    $0x7,%ecx
801031b1:	7f 19                	jg     801031cc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031b3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031b7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801031bd:	83 c1 01             	add    $0x1,%ecx
801031c0:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031c6:	88 97 80 37 11 80    	mov    %dl,-0x7feec880(%edi)
      p += sizeof(struct mpproc);
801031cc:	83 c0 14             	add    $0x14,%eax
      continue;
801031cf:	e9 7c ff ff ff       	jmp    80103150 <mpinit+0xf0>
801031d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801031d8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031dc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031df:	88 15 60 37 11 80    	mov    %dl,0x80113760
      continue;
801031e5:	e9 66 ff ff ff       	jmp    80103150 <mpinit+0xf0>
801031ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801031f0:	ba 00 00 01 00       	mov    $0x10000,%edx
801031f5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031fa:	e8 e1 fd ff ff       	call   80102fe0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031ff:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103201:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103204:	0f 85 a9 fe ff ff    	jne    801030b3 <mpinit+0x53>
8010320a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103210:	83 ec 0c             	sub    $0xc,%esp
80103213:	68 7d 7b 10 80       	push   $0x80107b7d
80103218:	e8 73 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010321d:	83 ec 0c             	sub    $0xc,%esp
80103220:	68 9c 7b 10 80       	push   $0x80107b9c
80103225:	e8 66 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010322a:	31 db                	xor    %ebx,%ebx
8010322c:	e9 26 ff ff ff       	jmp    80103157 <mpinit+0xf7>
80103231:	66 90                	xchg   %ax,%ax
80103233:	66 90                	xchg   %ax,%ax
80103235:	66 90                	xchg   %ax,%ax
80103237:	66 90                	xchg   %ax,%ax
80103239:	66 90                	xchg   %ax,%ax
8010323b:	66 90                	xchg   %ax,%ax
8010323d:	66 90                	xchg   %ax,%ax
8010323f:	90                   	nop

80103240 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103240:	55                   	push   %ebp
80103241:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103246:	ba 21 00 00 00       	mov    $0x21,%edx
8010324b:	89 e5                	mov    %esp,%ebp
8010324d:	ee                   	out    %al,(%dx)
8010324e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103253:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103254:	5d                   	pop    %ebp
80103255:	c3                   	ret    
80103256:	66 90                	xchg   %ax,%ax
80103258:	66 90                	xchg   %ax,%ax
8010325a:	66 90                	xchg   %ax,%ax
8010325c:	66 90                	xchg   %ax,%ax
8010325e:	66 90                	xchg   %ax,%ax

80103260 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103260:	55                   	push   %ebp
80103261:	89 e5                	mov    %esp,%ebp
80103263:	57                   	push   %edi
80103264:	56                   	push   %esi
80103265:	53                   	push   %ebx
80103266:	83 ec 0c             	sub    $0xc,%esp
80103269:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010326c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010326f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103275:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010327b:	e8 10 db ff ff       	call   80100d90 <filealloc>
80103280:	85 c0                	test   %eax,%eax
80103282:	89 03                	mov    %eax,(%ebx)
80103284:	74 22                	je     801032a8 <pipealloc+0x48>
80103286:	e8 05 db ff ff       	call   80100d90 <filealloc>
8010328b:	85 c0                	test   %eax,%eax
8010328d:	89 06                	mov    %eax,(%esi)
8010328f:	74 3f                	je     801032d0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103291:	e8 4a f2 ff ff       	call   801024e0 <kalloc>
80103296:	85 c0                	test   %eax,%eax
80103298:	89 c7                	mov    %eax,%edi
8010329a:	75 54                	jne    801032f0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010329c:	8b 03                	mov    (%ebx),%eax
8010329e:	85 c0                	test   %eax,%eax
801032a0:	75 34                	jne    801032d6 <pipealloc+0x76>
801032a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801032a8:	8b 06                	mov    (%esi),%eax
801032aa:	85 c0                	test   %eax,%eax
801032ac:	74 0c                	je     801032ba <pipealloc+0x5a>
    fileclose(*f1);
801032ae:	83 ec 0c             	sub    $0xc,%esp
801032b1:	50                   	push   %eax
801032b2:	e8 99 db ff ff       	call   80100e50 <fileclose>
801032b7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801032bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032c2:	5b                   	pop    %ebx
801032c3:	5e                   	pop    %esi
801032c4:	5f                   	pop    %edi
801032c5:	5d                   	pop    %ebp
801032c6:	c3                   	ret    
801032c7:	89 f6                	mov    %esi,%esi
801032c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032d0:	8b 03                	mov    (%ebx),%eax
801032d2:	85 c0                	test   %eax,%eax
801032d4:	74 e4                	je     801032ba <pipealloc+0x5a>
    fileclose(*f0);
801032d6:	83 ec 0c             	sub    $0xc,%esp
801032d9:	50                   	push   %eax
801032da:	e8 71 db ff ff       	call   80100e50 <fileclose>
  if(*f1)
801032df:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801032e1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032e4:	85 c0                	test   %eax,%eax
801032e6:	75 c6                	jne    801032ae <pipealloc+0x4e>
801032e8:	eb d0                	jmp    801032ba <pipealloc+0x5a>
801032ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801032f0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801032f3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801032fa:	00 00 00 
  p->writeopen = 1;
801032fd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103304:	00 00 00 
  p->nwrite = 0;
80103307:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010330e:	00 00 00 
  p->nread = 0;
80103311:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103318:	00 00 00 
  initlock(&p->lock, "pipe");
8010331b:	68 d0 7b 10 80       	push   $0x80107bd0
80103320:	50                   	push   %eax
80103321:	e8 3a 15 00 00       	call   80104860 <initlock>
  (*f0)->type = FD_PIPE;
80103326:	8b 03                	mov    (%ebx),%eax
  return 0;
80103328:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010332b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103331:	8b 03                	mov    (%ebx),%eax
80103333:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103337:	8b 03                	mov    (%ebx),%eax
80103339:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010333d:	8b 03                	mov    (%ebx),%eax
8010333f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103342:	8b 06                	mov    (%esi),%eax
80103344:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010334a:	8b 06                	mov    (%esi),%eax
8010334c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103350:	8b 06                	mov    (%esi),%eax
80103352:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103356:	8b 06                	mov    (%esi),%eax
80103358:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010335b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010335e:	31 c0                	xor    %eax,%eax
}
80103360:	5b                   	pop    %ebx
80103361:	5e                   	pop    %esi
80103362:	5f                   	pop    %edi
80103363:	5d                   	pop    %ebp
80103364:	c3                   	ret    
80103365:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103370 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103370:	55                   	push   %ebp
80103371:	89 e5                	mov    %esp,%ebp
80103373:	56                   	push   %esi
80103374:	53                   	push   %ebx
80103375:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103378:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010337b:	83 ec 0c             	sub    $0xc,%esp
8010337e:	53                   	push   %ebx
8010337f:	e8 1c 16 00 00       	call   801049a0 <acquire>
  if(writable){
80103384:	83 c4 10             	add    $0x10,%esp
80103387:	85 f6                	test   %esi,%esi
80103389:	74 45                	je     801033d0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010338b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103391:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103394:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010339b:	00 00 00 
    wakeup(&p->nread);
8010339e:	50                   	push   %eax
8010339f:	e8 ac 0e 00 00       	call   80104250 <wakeup>
801033a4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801033a7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033ad:	85 d2                	test   %edx,%edx
801033af:	75 0a                	jne    801033bb <pipeclose+0x4b>
801033b1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033b7:	85 c0                	test   %eax,%eax
801033b9:	74 35                	je     801033f0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033bb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033c1:	5b                   	pop    %ebx
801033c2:	5e                   	pop    %esi
801033c3:	5d                   	pop    %ebp
    release(&p->lock);
801033c4:	e9 97 16 00 00       	jmp    80104a60 <release>
801033c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033d0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033d6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033d9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033e0:	00 00 00 
    wakeup(&p->nwrite);
801033e3:	50                   	push   %eax
801033e4:	e8 67 0e 00 00       	call   80104250 <wakeup>
801033e9:	83 c4 10             	add    $0x10,%esp
801033ec:	eb b9                	jmp    801033a7 <pipeclose+0x37>
801033ee:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801033f0:	83 ec 0c             	sub    $0xc,%esp
801033f3:	53                   	push   %ebx
801033f4:	e8 67 16 00 00       	call   80104a60 <release>
    kfree((char*)p);
801033f9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801033fc:	83 c4 10             	add    $0x10,%esp
}
801033ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103402:	5b                   	pop    %ebx
80103403:	5e                   	pop    %esi
80103404:	5d                   	pop    %ebp
    kfree((char*)p);
80103405:	e9 26 ef ff ff       	jmp    80102330 <kfree>
8010340a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103410 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103410:	55                   	push   %ebp
80103411:	89 e5                	mov    %esp,%ebp
80103413:	57                   	push   %edi
80103414:	56                   	push   %esi
80103415:	53                   	push   %ebx
80103416:	83 ec 28             	sub    $0x28,%esp
80103419:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010341c:	53                   	push   %ebx
8010341d:	e8 7e 15 00 00       	call   801049a0 <acquire>
  for(i = 0; i < n; i++){
80103422:	8b 45 10             	mov    0x10(%ebp),%eax
80103425:	83 c4 10             	add    $0x10,%esp
80103428:	85 c0                	test   %eax,%eax
8010342a:	0f 8e c9 00 00 00    	jle    801034f9 <pipewrite+0xe9>
80103430:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103433:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103439:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010343f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103442:	03 4d 10             	add    0x10(%ebp),%ecx
80103445:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103448:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010344e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103454:	39 d0                	cmp    %edx,%eax
80103456:	75 74                	jne    801034cc <pipewrite+0xbc>
      if(p->readopen == 0 || myproc()->killed){
80103458:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010345e:	85 c0                	test   %eax,%eax
80103460:	74 51                	je     801034b3 <pipewrite+0xa3>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103462:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103468:	eb 3a                	jmp    801034a4 <pipewrite+0x94>
8010346a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103470:	83 ec 0c             	sub    $0xc,%esp
80103473:	57                   	push   %edi
80103474:	e8 d7 0d 00 00       	call   80104250 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103479:	5a                   	pop    %edx
8010347a:	59                   	pop    %ecx
8010347b:	53                   	push   %ebx
8010347c:	56                   	push   %esi
8010347d:	e8 ce 0b 00 00       	call   80104050 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103482:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103488:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010348e:	83 c4 10             	add    $0x10,%esp
80103491:	05 00 02 00 00       	add    $0x200,%eax
80103496:	39 c2                	cmp    %eax,%edx
80103498:	75 36                	jne    801034d0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010349a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801034a0:	85 c0                	test   %eax,%eax
801034a2:	74 0f                	je     801034b3 <pipewrite+0xa3>
801034a4:	e8 47 04 00 00       	call   801038f0 <myproc>
801034a9:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801034af:	85 c0                	test   %eax,%eax
801034b1:	74 bd                	je     80103470 <pipewrite+0x60>
        release(&p->lock);
801034b3:	83 ec 0c             	sub    $0xc,%esp
801034b6:	53                   	push   %ebx
801034b7:	e8 a4 15 00 00       	call   80104a60 <release>
        return -1;
801034bc:	83 c4 10             	add    $0x10,%esp
801034bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034c7:	5b                   	pop    %ebx
801034c8:	5e                   	pop    %esi
801034c9:	5f                   	pop    %edi
801034ca:	5d                   	pop    %ebp
801034cb:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034cc:	89 c2                	mov    %eax,%edx
801034ce:	66 90                	xchg   %ax,%ax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034d0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034d3:	8d 42 01             	lea    0x1(%edx),%eax
801034d6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034dc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034e2:	83 c6 01             	add    $0x1,%esi
801034e5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801034e9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801034ec:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034ef:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801034f3:	0f 85 4f ff ff ff    	jne    80103448 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801034f9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034ff:	83 ec 0c             	sub    $0xc,%esp
80103502:	50                   	push   %eax
80103503:	e8 48 0d 00 00       	call   80104250 <wakeup>
  release(&p->lock);
80103508:	89 1c 24             	mov    %ebx,(%esp)
8010350b:	e8 50 15 00 00       	call   80104a60 <release>
  return n;
80103510:	83 c4 10             	add    $0x10,%esp
80103513:	8b 45 10             	mov    0x10(%ebp),%eax
80103516:	eb ac                	jmp    801034c4 <pipewrite+0xb4>
80103518:	90                   	nop
80103519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103520 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103520:	55                   	push   %ebp
80103521:	89 e5                	mov    %esp,%ebp
80103523:	57                   	push   %edi
80103524:	56                   	push   %esi
80103525:	53                   	push   %ebx
80103526:	83 ec 18             	sub    $0x18,%esp
80103529:	8b 75 08             	mov    0x8(%ebp),%esi
8010352c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010352f:	56                   	push   %esi
80103530:	e8 6b 14 00 00       	call   801049a0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103535:	83 c4 10             	add    $0x10,%esp
80103538:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010353e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103544:	75 72                	jne    801035b8 <piperead+0x98>
80103546:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010354c:	85 db                	test   %ebx,%ebx
8010354e:	0f 84 cc 00 00 00    	je     80103620 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103554:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010355a:	eb 2d                	jmp    80103589 <piperead+0x69>
8010355c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103560:	83 ec 08             	sub    $0x8,%esp
80103563:	56                   	push   %esi
80103564:	53                   	push   %ebx
80103565:	e8 e6 0a 00 00       	call   80104050 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010356a:	83 c4 10             	add    $0x10,%esp
8010356d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103573:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103579:	75 3d                	jne    801035b8 <piperead+0x98>
8010357b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103581:	85 d2                	test   %edx,%edx
80103583:	0f 84 97 00 00 00    	je     80103620 <piperead+0x100>
    if(myproc()->killed){
80103589:	e8 62 03 00 00       	call   801038f0 <myproc>
8010358e:	8b 88 b0 00 00 00    	mov    0xb0(%eax),%ecx
80103594:	85 c9                	test   %ecx,%ecx
80103596:	74 c8                	je     80103560 <piperead+0x40>
      release(&p->lock);
80103598:	83 ec 0c             	sub    $0xc,%esp
      return -1;
8010359b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801035a0:	56                   	push   %esi
801035a1:	e8 ba 14 00 00       	call   80104a60 <release>
      return -1;
801035a6:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801035a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035ac:	89 d8                	mov    %ebx,%eax
801035ae:	5b                   	pop    %ebx
801035af:	5e                   	pop    %esi
801035b0:	5f                   	pop    %edi
801035b1:	5d                   	pop    %ebp
801035b2:	c3                   	ret    
801035b3:	90                   	nop
801035b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035b8:	8b 45 10             	mov    0x10(%ebp),%eax
801035bb:	85 c0                	test   %eax,%eax
801035bd:	7e 61                	jle    80103620 <piperead+0x100>
    if(p->nread == p->nwrite)
801035bf:	31 db                	xor    %ebx,%ebx
801035c1:	eb 13                	jmp    801035d6 <piperead+0xb6>
801035c3:	90                   	nop
801035c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035c8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035ce:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035d4:	74 1f                	je     801035f5 <piperead+0xd5>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035d6:	8d 41 01             	lea    0x1(%ecx),%eax
801035d9:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035df:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035e5:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801035ea:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035ed:	83 c3 01             	add    $0x1,%ebx
801035f0:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801035f3:	75 d3                	jne    801035c8 <piperead+0xa8>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801035f5:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801035fb:	83 ec 0c             	sub    $0xc,%esp
801035fe:	50                   	push   %eax
801035ff:	e8 4c 0c 00 00       	call   80104250 <wakeup>
  release(&p->lock);
80103604:	89 34 24             	mov    %esi,(%esp)
80103607:	e8 54 14 00 00       	call   80104a60 <release>
  return i;
8010360c:	83 c4 10             	add    $0x10,%esp
}
8010360f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103612:	89 d8                	mov    %ebx,%eax
80103614:	5b                   	pop    %ebx
80103615:	5e                   	pop    %esi
80103616:	5f                   	pop    %edi
80103617:	5d                   	pop    %ebp
80103618:	c3                   	ret    
80103619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103620:	31 db                	xor    %ebx,%ebx
80103622:	eb d1                	jmp    801035f5 <piperead+0xd5>
80103624:	66 90                	xchg   %ax,%ax
80103626:	66 90                	xchg   %ax,%ax
80103628:	66 90                	xchg   %ax,%ax
8010362a:	66 90                	xchg   %ax,%ax
8010362c:	66 90                	xchg   %ax,%ax
8010362e:	66 90                	xchg   %ax,%ax

80103630 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	57                   	push   %edi
80103634:	56                   	push   %esi
80103635:	53                   	push   %ebx
 
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103636:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
8010363b:	83 ec 28             	sub    $0x28,%esp
  acquire(&ptable.lock);
8010363e:	68 20 3d 11 80       	push   $0x80113d20
80103643:	e8 58 13 00 00       	call   801049a0 <acquire>
80103648:	83 c4 10             	add    $0x10,%esp
8010364b:	eb 15                	jmp    80103662 <allocproc+0x32>
8010364d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103650:	81 c3 08 01 00 00    	add    $0x108,%ebx
80103656:	81 fb 54 7f 11 80    	cmp    $0x80117f54,%ebx
8010365c:	0f 83 53 01 00 00    	jae    801037b5 <allocproc+0x185>
    if(p->state == UNUSED)
80103662:	8b 93 98 00 00 00    	mov    0x98(%ebx),%edx
80103668:	85 d2                	test   %edx,%edx
8010366a:	75 e4                	jne    80103650 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  ////initial variables in proc structure
  p->creationTime = ticks;
8010366c:	a1 a0 87 11 80       	mov    0x801187a0,%eax
80103671:	8d 93 8c 00 00 00    	lea    0x8c(%ebx),%edx
  p->terminationTime = 0;
80103677:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  p->runningTime = 0;
8010367e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  p->sleepingTime = 0;
80103685:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  p->readyTime = 0;
8010368c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  p->creationTime = ticks;
80103693:	89 03                	mov    %eax,(%ebx)
80103695:	8d 43 20             	lea    0x20(%ebx),%eax
80103698:	90                   	nop
80103699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(int i=0; i<27; i++){ 
      p->hit[i] = 0;
801036a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801036a6:	83 c0 04             	add    $0x4,%eax
  for(int i=0; i<27; i++){ 
801036a9:	39 c2                	cmp    %eax,%edx
801036ab:	75 f3                	jne    801036a0 <allocproc+0x70>
  }
  p->priority = 5;
801036ad:	c7 43 14 05 00 00 00 	movl   $0x5,0x14(%ebx)
  int minCP = __INT32_MAX__;                                ////maximum int value 
  int proccessExistFlag = 0;
801036b4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  int minCP = __INT32_MAX__;                                ////maximum int value 
801036bb:	b9 ff ff ff 7f       	mov    $0x7fffffff,%ecx
  for(p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++){
801036c0:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801036c5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p1->state != RUNNABLE || p1->pid == p->pid){
801036c8:	83 b8 98 00 00 00 03 	cmpl   $0x3,0x98(%eax)
801036cf:	75 2f                	jne    80103700 <allocproc+0xd0>
801036d1:	8b bb 9c 00 00 00    	mov    0x9c(%ebx),%edi
801036d7:	39 b8 9c 00 00 00    	cmp    %edi,0x9c(%eax)
801036dd:	74 21                	je     80103700 <allocproc+0xd0>
        continue;
      }
      if(p1->calculatedPriority < minCP){
801036df:	89 cf                	mov    %ecx,%edi
801036e1:	8b 50 18             	mov    0x18(%eax),%edx
801036e4:	c1 ff 1f             	sar    $0x1f,%edi
801036e7:	39 78 1c             	cmp    %edi,0x1c(%eax)
801036ea:	7f 14                	jg     80103700 <allocproc+0xd0>
801036ec:	7c 04                	jl     801036f2 <allocproc+0xc2>
801036ee:	39 ca                	cmp    %ecx,%edx
801036f0:	73 0e                	jae    80103700 <allocproc+0xd0>
          minCP = p1->calculatedPriority;
801036f2:	89 d1                	mov    %edx,%ecx
          proccessExistFlag = 1;
801036f4:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
801036fb:	90                   	nop
801036fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++){
80103700:	05 08 01 00 00       	add    $0x108,%eax
80103705:	3d 54 7f 11 80       	cmp    $0x80117f54,%eax
8010370a:	72 bc                	jb     801036c8 <allocproc+0x98>
      }
  }
  if(proccessExistFlag)
8010370c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010370f:	85 c0                	test   %eax,%eax
80103711:	0f 85 90 00 00 00    	jne    801037a7 <allocproc+0x177>
    p->calculatedPriority = minCP;
  else
    p->calculatedPriority = 0;
80103717:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
8010371e:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
  
  p->state = EMBRYO;
  p->pid = nextpid++;
80103725:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
8010372a:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010372d:	c7 83 98 00 00 00 01 	movl   $0x1,0x98(%ebx)
80103734:	00 00 00 
  p->pid = nextpid++;
80103737:	8d 50 01             	lea    0x1(%eax),%edx
8010373a:	89 83 9c 00 00 00    	mov    %eax,0x9c(%ebx)
  release(&ptable.lock);
80103740:	68 20 3d 11 80       	push   $0x80113d20
  p->pid = nextpid++;
80103745:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
8010374b:	e8 10 13 00 00       	call   80104a60 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103750:	e8 8b ed ff ff       	call   801024e0 <kalloc>
80103755:	83 c4 10             	add    $0x10,%esp
80103758:	85 c0                	test   %eax,%eax
8010375a:	89 83 94 00 00 00    	mov    %eax,0x94(%ebx)
80103760:	74 6f                	je     801037d1 <allocproc+0x1a1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103762:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103768:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010376b:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103770:	89 93 a4 00 00 00    	mov    %edx,0xa4(%ebx)
  *(uint*)sp = (uint)trapret;
80103776:	c7 40 14 a2 5d 10 80 	movl   $0x80105da2,0x14(%eax)
  p->context = (struct context*)sp;
8010377d:	89 83 a8 00 00 00    	mov    %eax,0xa8(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103783:	6a 14                	push   $0x14
80103785:	6a 00                	push   $0x0
80103787:	50                   	push   %eax
80103788:	e8 23 13 00 00       	call   80104ab0 <memset>
  p->context->eip = (uint)forkret;
8010378d:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax

  return p;
80103793:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103796:	c7 40 10 e0 37 10 80 	movl   $0x801037e0,0x10(%eax)
}
8010379d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a0:	89 d8                	mov    %ebx,%eax
801037a2:	5b                   	pop    %ebx
801037a3:	5e                   	pop    %esi
801037a4:	5f                   	pop    %edi
801037a5:	5d                   	pop    %ebp
801037a6:	c3                   	ret    
    p->calculatedPriority = minCP;
801037a7:	89 4b 18             	mov    %ecx,0x18(%ebx)
801037aa:	c1 f9 1f             	sar    $0x1f,%ecx
801037ad:	89 4b 1c             	mov    %ecx,0x1c(%ebx)
801037b0:	e9 70 ff ff ff       	jmp    80103725 <allocproc+0xf5>
  release(&ptable.lock);
801037b5:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801037b8:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801037ba:	68 20 3d 11 80       	push   $0x80113d20
801037bf:	e8 9c 12 00 00       	call   80104a60 <release>
  return 0;
801037c4:	83 c4 10             	add    $0x10,%esp
}
801037c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037ca:	89 d8                	mov    %ebx,%eax
801037cc:	5b                   	pop    %ebx
801037cd:	5e                   	pop    %esi
801037ce:	5f                   	pop    %edi
801037cf:	5d                   	pop    %ebp
801037d0:	c3                   	ret    
    p->state = UNUSED;
801037d1:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
801037d8:	00 00 00 
    return 0;
801037db:	31 db                	xor    %ebx,%ebx
801037dd:	eb be                	jmp    8010379d <allocproc+0x16d>
801037df:	90                   	nop

801037e0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801037e6:	68 20 3d 11 80       	push   $0x80113d20
801037eb:	e8 70 12 00 00       	call   80104a60 <release>

  if (first) {
801037f0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801037f5:	83 c4 10             	add    $0x10,%esp
801037f8:	85 c0                	test   %eax,%eax
801037fa:	75 04                	jne    80103800 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801037fc:	c9                   	leave  
801037fd:	c3                   	ret    
801037fe:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103800:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103803:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010380a:	00 00 00 
    iinit(ROOTDEV);
8010380d:	6a 01                	push   $0x1
8010380f:	e8 7c dc ff ff       	call   80101490 <iinit>
    initlog(ROOTDEV);
80103814:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010381b:	e8 00 f3 ff ff       	call   80102b20 <initlog>
80103820:	83 c4 10             	add    $0x10,%esp
}
80103823:	c9                   	leave  
80103824:	c3                   	ret    
80103825:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103830 <pinit>:
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103836:	68 d5 7b 10 80       	push   $0x80107bd5
8010383b:	68 20 3d 11 80       	push   $0x80113d20
80103840:	e8 1b 10 00 00       	call   80104860 <initlock>
}
80103845:	83 c4 10             	add    $0x10,%esp
80103848:	c9                   	leave  
80103849:	c3                   	ret    
8010384a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103850 <mycpu>:
{
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	56                   	push   %esi
80103854:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103855:	9c                   	pushf  
80103856:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103857:	f6 c4 02             	test   $0x2,%ah
8010385a:	75 5e                	jne    801038ba <mycpu+0x6a>
  apicid = lapicid();
8010385c:	e8 ef ee ff ff       	call   80102750 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103861:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
80103867:	85 f6                	test   %esi,%esi
80103869:	7e 42                	jle    801038ad <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010386b:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
80103872:	39 d0                	cmp    %edx,%eax
80103874:	74 30                	je     801038a6 <mycpu+0x56>
80103876:	b9 30 38 11 80       	mov    $0x80113830,%ecx
  for (i = 0; i < ncpu; ++i) {
8010387b:	31 d2                	xor    %edx,%edx
8010387d:	8d 76 00             	lea    0x0(%esi),%esi
80103880:	83 c2 01             	add    $0x1,%edx
80103883:	39 f2                	cmp    %esi,%edx
80103885:	74 26                	je     801038ad <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103887:	0f b6 19             	movzbl (%ecx),%ebx
8010388a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103890:	39 c3                	cmp    %eax,%ebx
80103892:	75 ec                	jne    80103880 <mycpu+0x30>
80103894:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010389a:	05 80 37 11 80       	add    $0x80113780,%eax
}
8010389f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038a2:	5b                   	pop    %ebx
801038a3:	5e                   	pop    %esi
801038a4:	5d                   	pop    %ebp
801038a5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
801038a6:	b8 80 37 11 80       	mov    $0x80113780,%eax
      return &cpus[i];
801038ab:	eb f2                	jmp    8010389f <mycpu+0x4f>
  panic("unknown apicid\n");
801038ad:	83 ec 0c             	sub    $0xc,%esp
801038b0:	68 dc 7b 10 80       	push   $0x80107bdc
801038b5:	e8 d6 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801038ba:	83 ec 0c             	sub    $0xc,%esp
801038bd:	68 b8 7c 10 80       	push   $0x80107cb8
801038c2:	e8 c9 ca ff ff       	call   80100390 <panic>
801038c7:	89 f6                	mov    %esi,%esi
801038c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038d0 <cpuid>:
cpuid() {
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801038d6:	e8 75 ff ff ff       	call   80103850 <mycpu>
801038db:	2d 80 37 11 80       	sub    $0x80113780,%eax
}
801038e0:	c9                   	leave  
  return mycpu()-cpus;
801038e1:	c1 f8 04             	sar    $0x4,%eax
801038e4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801038ea:	c3                   	ret    
801038eb:	90                   	nop
801038ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038f0 <myproc>:
myproc(void) {
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	53                   	push   %ebx
801038f4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801038f7:	e8 d4 0f 00 00       	call   801048d0 <pushcli>
  c = mycpu();
801038fc:	e8 4f ff ff ff       	call   80103850 <mycpu>
  p = c->proc;
80103901:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103907:	e8 04 10 00 00       	call   80104910 <popcli>
}
8010390c:	83 c4 04             	add    $0x4,%esp
8010390f:	89 d8                	mov    %ebx,%eax
80103911:	5b                   	pop    %ebx
80103912:	5d                   	pop    %ebp
80103913:	c3                   	ret    
80103914:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010391a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103920 <userinit>:
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	53                   	push   %ebx
80103924:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103927:	e8 04 fd ff ff       	call   80103630 <allocproc>
8010392c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010392e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103933:	e8 a8 3a 00 00       	call   801073e0 <setupkvm>
80103938:	85 c0                	test   %eax,%eax
8010393a:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
80103940:	0f 84 e2 00 00 00    	je     80103a28 <userinit+0x108>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103946:	83 ec 04             	sub    $0x4,%esp
80103949:	68 2c 00 00 00       	push   $0x2c
8010394e:	68 60 b4 10 80       	push   $0x8010b460
80103953:	50                   	push   %eax
80103954:	e8 67 37 00 00       	call   801070c0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103959:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
8010395c:	c7 83 8c 00 00 00 00 	movl   $0x1000,0x8c(%ebx)
80103963:	10 00 00 
  memset(p->tf, 0, sizeof(*p->tf));
80103966:	6a 4c                	push   $0x4c
80103968:	6a 00                	push   $0x0
8010396a:	ff b3 a4 00 00 00    	pushl  0xa4(%ebx)
80103970:	e8 3b 11 00 00       	call   80104ab0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103975:	8b 83 a4 00 00 00    	mov    0xa4(%ebx),%eax
8010397b:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103980:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103985:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103988:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010398c:	8b 83 a4 00 00 00    	mov    0xa4(%ebx),%eax
80103992:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103996:	8b 83 a4 00 00 00    	mov    0xa4(%ebx),%eax
8010399c:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039a0:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801039a4:	8b 83 a4 00 00 00    	mov    0xa4(%ebx),%eax
801039aa:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039ae:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801039b2:	8b 83 a4 00 00 00    	mov    0xa4(%ebx),%eax
801039b8:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801039bf:	8b 83 a4 00 00 00    	mov    0xa4(%ebx),%eax
801039c5:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801039cc:	8b 83 a4 00 00 00    	mov    0xa4(%ebx),%eax
801039d2:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039d9:	8d 83 f8 00 00 00    	lea    0xf8(%ebx),%eax
801039df:	6a 10                	push   $0x10
801039e1:	68 05 7c 10 80       	push   $0x80107c05
801039e6:	50                   	push   %eax
801039e7:	e8 a4 12 00 00       	call   80104c90 <safestrcpy>
  p->cwd = namei("/");
801039ec:	c7 04 24 0e 7c 10 80 	movl   $0x80107c0e,(%esp)
801039f3:	e8 08 e5 ff ff       	call   80101f00 <namei>
801039f8:	89 83 f4 00 00 00    	mov    %eax,0xf4(%ebx)
  acquire(&ptable.lock);
801039fe:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103a05:	e8 96 0f 00 00       	call   801049a0 <acquire>
  p->state = RUNNABLE;
80103a0a:	c7 83 98 00 00 00 03 	movl   $0x3,0x98(%ebx)
80103a11:	00 00 00 
  release(&ptable.lock);
80103a14:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103a1b:	e8 40 10 00 00       	call   80104a60 <release>
}
80103a20:	83 c4 10             	add    $0x10,%esp
80103a23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a26:	c9                   	leave  
80103a27:	c3                   	ret    
    panic("userinit: out of memory?");
80103a28:	83 ec 0c             	sub    $0xc,%esp
80103a2b:	68 ec 7b 10 80       	push   $0x80107bec
80103a30:	e8 5b c9 ff ff       	call   80100390 <panic>
80103a35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a40 <growproc>:
{
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	56                   	push   %esi
80103a44:	53                   	push   %ebx
80103a45:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103a48:	e8 83 0e 00 00       	call   801048d0 <pushcli>
  c = mycpu();
80103a4d:	e8 fe fd ff ff       	call   80103850 <mycpu>
  p = c->proc;
80103a52:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a58:	e8 b3 0e 00 00       	call   80104910 <popcli>
  if(n > 0){
80103a5d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103a60:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
  if(n > 0){
80103a66:	7f 20                	jg     80103a88 <growproc+0x48>
  } else if(n < 0){
80103a68:	75 46                	jne    80103ab0 <growproc+0x70>
  switchuvm(curproc);
80103a6a:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103a6d:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
  switchuvm(curproc);
80103a73:	53                   	push   %ebx
80103a74:	e8 27 35 00 00       	call   80106fa0 <switchuvm>
  return 0;
80103a79:	83 c4 10             	add    $0x10,%esp
80103a7c:	31 c0                	xor    %eax,%eax
}
80103a7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a81:	5b                   	pop    %ebx
80103a82:	5e                   	pop    %esi
80103a83:	5d                   	pop    %ebp
80103a84:	c3                   	ret    
80103a85:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a88:	83 ec 04             	sub    $0x4,%esp
80103a8b:	01 c6                	add    %eax,%esi
80103a8d:	56                   	push   %esi
80103a8e:	50                   	push   %eax
80103a8f:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
80103a95:	e8 66 37 00 00       	call   80107200 <allocuvm>
80103a9a:	83 c4 10             	add    $0x10,%esp
80103a9d:	85 c0                	test   %eax,%eax
80103a9f:	75 c9                	jne    80103a6a <growproc+0x2a>
      return -1;
80103aa1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103aa6:	eb d6                	jmp    80103a7e <growproc+0x3e>
80103aa8:	90                   	nop
80103aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ab0:	83 ec 04             	sub    $0x4,%esp
80103ab3:	01 c6                	add    %eax,%esi
80103ab5:	56                   	push   %esi
80103ab6:	50                   	push   %eax
80103ab7:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
80103abd:	e8 6e 38 00 00       	call   80107330 <deallocuvm>
80103ac2:	83 c4 10             	add    $0x10,%esp
80103ac5:	85 c0                	test   %eax,%eax
80103ac7:	75 a1                	jne    80103a6a <growproc+0x2a>
80103ac9:	eb d6                	jmp    80103aa1 <growproc+0x61>
80103acb:	90                   	nop
80103acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ad0 <fork>:
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	57                   	push   %edi
80103ad4:	56                   	push   %esi
80103ad5:	53                   	push   %ebx
80103ad6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103ad9:	e8 f2 0d 00 00       	call   801048d0 <pushcli>
  c = mycpu();
80103ade:	e8 6d fd ff ff       	call   80103850 <mycpu>
  p = c->proc;
80103ae3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ae9:	e8 22 0e 00 00       	call   80104910 <popcli>
  if((np = allocproc()) == 0){
80103aee:	e8 3d fb ff ff       	call   80103630 <allocproc>
80103af3:	85 c0                	test   %eax,%eax
80103af5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103af8:	0f 84 ef 00 00 00    	je     80103bed <fork+0x11d>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103afe:	83 ec 08             	sub    $0x8,%esp
80103b01:	ff b3 8c 00 00 00    	pushl  0x8c(%ebx)
80103b07:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
80103b0d:	89 c7                	mov    %eax,%edi
80103b0f:	e8 9c 39 00 00       	call   801074b0 <copyuvm>
80103b14:	83 c4 10             	add    $0x10,%esp
80103b17:	85 c0                	test   %eax,%eax
80103b19:	89 87 90 00 00 00    	mov    %eax,0x90(%edi)
80103b1f:	0f 84 cf 00 00 00    	je     80103bf4 <fork+0x124>
  np->sz = curproc->sz;
80103b25:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80103b2b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b2e:	89 81 8c 00 00 00    	mov    %eax,0x8c(%ecx)
  np->parent = curproc;
80103b34:	89 99 a0 00 00 00    	mov    %ebx,0xa0(%ecx)
80103b3a:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103b3c:	8b b9 a4 00 00 00    	mov    0xa4(%ecx),%edi
80103b42:	8b b3 a4 00 00 00    	mov    0xa4(%ebx),%esi
80103b48:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b4d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b4f:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b51:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80103b57:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103b5e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[i])
80103b60:	8b 84 b3 b4 00 00 00 	mov    0xb4(%ebx,%esi,4),%eax
80103b67:	85 c0                	test   %eax,%eax
80103b69:	74 16                	je     80103b81 <fork+0xb1>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b6b:	83 ec 0c             	sub    $0xc,%esp
80103b6e:	50                   	push   %eax
80103b6f:	e8 8c d2 ff ff       	call   80100e00 <filedup>
80103b74:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b77:	83 c4 10             	add    $0x10,%esp
80103b7a:	89 84 b2 b4 00 00 00 	mov    %eax,0xb4(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103b81:	83 c6 01             	add    $0x1,%esi
80103b84:	83 fe 10             	cmp    $0x10,%esi
80103b87:	75 d7                	jne    80103b60 <fork+0x90>
  np->cwd = idup(curproc->cwd);
80103b89:	83 ec 0c             	sub    $0xc,%esp
80103b8c:	ff b3 f4 00 00 00    	pushl  0xf4(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b92:	81 c3 f8 00 00 00    	add    $0xf8,%ebx
  np->cwd = idup(curproc->cwd);
80103b98:	e8 c3 da ff ff       	call   80101660 <idup>
80103b9d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ba0:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103ba3:	89 87 f4 00 00 00    	mov    %eax,0xf4(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ba9:	8d 87 f8 00 00 00    	lea    0xf8(%edi),%eax
80103baf:	6a 10                	push   $0x10
80103bb1:	53                   	push   %ebx
80103bb2:	50                   	push   %eax
80103bb3:	e8 d8 10 00 00       	call   80104c90 <safestrcpy>
  pid = np->pid;
80103bb8:	8b 9f 9c 00 00 00    	mov    0x9c(%edi),%ebx
  acquire(&ptable.lock);
80103bbe:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103bc5:	e8 d6 0d 00 00       	call   801049a0 <acquire>
  np->state = RUNNABLE;
80103bca:	c7 87 98 00 00 00 03 	movl   $0x3,0x98(%edi)
80103bd1:	00 00 00 
  release(&ptable.lock);
80103bd4:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103bdb:	e8 80 0e 00 00       	call   80104a60 <release>
  return pid;
80103be0:	83 c4 10             	add    $0x10,%esp
}
80103be3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103be6:	89 d8                	mov    %ebx,%eax
80103be8:	5b                   	pop    %ebx
80103be9:	5e                   	pop    %esi
80103bea:	5f                   	pop    %edi
80103beb:	5d                   	pop    %ebp
80103bec:	c3                   	ret    
    return -1;
80103bed:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103bf2:	eb ef                	jmp    80103be3 <fork+0x113>
    kfree(np->kstack);
80103bf4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103bf7:	83 ec 0c             	sub    $0xc,%esp
80103bfa:	ff b3 94 00 00 00    	pushl  0x94(%ebx)
80103c00:	e8 2b e7 ff ff       	call   80102330 <kfree>
    np->kstack = 0;
80103c05:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
80103c0c:	00 00 00 
    np->state = UNUSED;
80103c0f:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
80103c16:	00 00 00 
    return -1;
80103c19:	83 c4 10             	add    $0x10,%esp
80103c1c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c21:	eb c0                	jmp    80103be3 <fork+0x113>
80103c23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c30 <scheduler>:
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	57                   	push   %edi
80103c34:	56                   	push   %esi
80103c35:	53                   	push   %ebx
80103c36:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103c39:	e8 12 fc ff ff       	call   80103850 <mycpu>
80103c3e:	89 c7                	mov    %eax,%edi
  c->proc = 0;
80103c40:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c47:	00 00 00 
80103c4a:	8d 40 04             	lea    0x4(%eax),%eax
80103c4d:	89 7d dc             	mov    %edi,-0x24(%ebp)
80103c50:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103c53:	eb 1c                	jmp    80103c71 <scheduler+0x41>
80103c55:	8d 76 00             	lea    0x0(%esi),%esi
    if(policy == 2){
80103c58:	83 f8 02             	cmp    $0x2,%eax
80103c5b:	0f 84 9d 00 00 00    	je     80103cfe <scheduler+0xce>
    release(&ptable.lock);
80103c61:	83 ec 0c             	sub    $0xc,%esp
80103c64:	68 20 3d 11 80       	push   $0x80113d20
80103c69:	e8 f2 0d 00 00       	call   80104a60 <release>
  for(;;){
80103c6e:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
80103c71:	fb                   	sti    
    acquire(&ptable.lock);
80103c72:	83 ec 0c             	sub    $0xc,%esp
80103c75:	68 20 3d 11 80       	push   $0x80113d20
80103c7a:	e8 21 0d 00 00       	call   801049a0 <acquire>
    if(policy == 0 || policy == 1){
80103c7f:	a1 08 b0 10 80       	mov    0x8010b008,%eax
80103c84:	83 c4 10             	add    $0x10,%esp
80103c87:	83 f8 01             	cmp    $0x1,%eax
80103c8a:	77 cc                	ja     80103c58 <scheduler+0x28>
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c8c:	8b 75 dc             	mov    -0x24(%ebp),%esi
80103c8f:	8b 7d e0             	mov    -0x20(%ebp),%edi
80103c92:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80103c97:	89 f6                	mov    %esi,%esi
80103c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
          if(p->state != RUNNABLE)
80103ca0:	83 bb 98 00 00 00 03 	cmpl   $0x3,0x98(%ebx)
80103ca7:	75 39                	jne    80103ce2 <scheduler+0xb2>
        switchuvm(p);
80103ca9:	83 ec 0c             	sub    $0xc,%esp
        c->proc = p;
80103cac:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
        switchuvm(p);
80103cb2:	53                   	push   %ebx
80103cb3:	e8 e8 32 00 00       	call   80106fa0 <switchuvm>
        p->state = RUNNING;
80103cb8:	c7 83 98 00 00 00 04 	movl   $0x4,0x98(%ebx)
80103cbf:	00 00 00 
        swtch(&(c->scheduler), p->context);
80103cc2:	59                   	pop    %ecx
80103cc3:	58                   	pop    %eax
80103cc4:	ff b3 a8 00 00 00    	pushl  0xa8(%ebx)
80103cca:	57                   	push   %edi
80103ccb:	e8 1b 10 00 00       	call   80104ceb <swtch>
        switchkvm();
80103cd0:	e8 ab 32 00 00       	call   80106f80 <switchkvm>
        c->proc = 0;
80103cd5:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103cdc:	00 00 00 
80103cdf:	83 c4 10             	add    $0x10,%esp
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ce2:	81 c3 08 01 00 00    	add    $0x108,%ebx
80103ce8:	81 fb 54 7f 11 80    	cmp    $0x80117f54,%ebx
80103cee:	72 b0                	jb     80103ca0 <scheduler+0x70>
80103cf0:	a1 08 b0 10 80       	mov    0x8010b008,%eax
    if(policy == 2){
80103cf5:	83 f8 02             	cmp    $0x2,%eax
80103cf8:	0f 85 63 ff ff ff    	jne    80103c61 <scheduler+0x31>
    int minID = -1;
80103cfe:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    int minTemp =-1;
80103d03:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d08:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103d0d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
        if(p->state != RUNNABLE)
80103d10:	83 b8 98 00 00 00 03 	cmpl   $0x3,0x98(%eax)
80103d17:	75 2a                	jne    80103d43 <scheduler+0x113>
        if(minTemp == -1){
80103d19:	83 f9 ff             	cmp    $0xffffffff,%ecx
80103d1c:	8b 50 18             	mov    0x18(%eax),%edx
80103d1f:	8b 58 1c             	mov    0x1c(%eax),%ebx
80103d22:	74 14                	je     80103d38 <scheduler+0x108>
          if(minTemp > p->calculatedPriority){
80103d24:	89 cf                	mov    %ecx,%edi
80103d26:	c1 ff 1f             	sar    $0x1f,%edi
80103d29:	39 df                	cmp    %ebx,%edi
80103d2b:	7c 16                	jl     80103d43 <scheduler+0x113>
80103d2d:	7f 09                	jg     80103d38 <scheduler+0x108>
80103d2f:	39 d1                	cmp    %edx,%ecx
80103d31:	76 10                	jbe    80103d43 <scheduler+0x113>
80103d33:	90                   	nop
80103d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
              minID = p->pid;
80103d38:	8b b8 9c 00 00 00    	mov    0x9c(%eax),%edi
              minTemp = p->calculatedPriority;
80103d3e:	89 d1                	mov    %edx,%ecx
              minID = p->pid;
80103d40:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d43:	05 08 01 00 00       	add    $0x108,%eax
80103d48:	3d 54 7f 11 80       	cmp    $0x80117f54,%eax
80103d4d:	72 c1                	jb     80103d10 <scheduler+0xe0>
80103d4f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d52:	be 54 3d 11 80       	mov    $0x80113d54,%esi
80103d57:	8b 7d dc             	mov    -0x24(%ebp),%edi
80103d5a:	eb 16                	jmp    80103d72 <scheduler+0x142>
80103d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d60:	81 c6 08 01 00 00    	add    $0x108,%esi
80103d66:	81 fe 54 7f 11 80    	cmp    $0x80117f54,%esi
80103d6c:	0f 83 ef fe ff ff    	jae    80103c61 <scheduler+0x31>
        if(p->state != RUNNABLE)
80103d72:	83 be 98 00 00 00 03 	cmpl   $0x3,0x98(%esi)
80103d79:	75 e5                	jne    80103d60 <scheduler+0x130>
        if(minID == p->pid && minID != -1){
80103d7b:	39 9e 9c 00 00 00    	cmp    %ebx,0x9c(%esi)
80103d81:	75 dd                	jne    80103d60 <scheduler+0x130>
80103d83:	83 fb ff             	cmp    $0xffffffff,%ebx
80103d86:	74 d8                	je     80103d60 <scheduler+0x130>
          p->calculatedPriority += p->priority;
80103d88:	8b 46 14             	mov    0x14(%esi),%eax
80103d8b:	99                   	cltd   
80103d8c:	01 46 18             	add    %eax,0x18(%esi)
80103d8f:	11 56 1c             	adc    %edx,0x1c(%esi)
          switchuvm(p);
80103d92:	83 ec 0c             	sub    $0xc,%esp
          c->proc = p;
80103d95:	89 b7 ac 00 00 00    	mov    %esi,0xac(%edi)
          switchuvm(p);
80103d9b:	56                   	push   %esi
80103d9c:	e8 ff 31 00 00       	call   80106fa0 <switchuvm>
          p->state = RUNNING;
80103da1:	c7 86 98 00 00 00 04 	movl   $0x4,0x98(%esi)
80103da8:	00 00 00 
          swtch(&(c->scheduler), p->context);
80103dab:	58                   	pop    %eax
80103dac:	5a                   	pop    %edx
80103dad:	ff b6 a8 00 00 00    	pushl  0xa8(%esi)
80103db3:	ff 75 e0             	pushl  -0x20(%ebp)
80103db6:	e8 30 0f 00 00       	call   80104ceb <swtch>
          switchkvm();
80103dbb:	e8 c0 31 00 00       	call   80106f80 <switchkvm>
          c->proc = 0;
80103dc0:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
80103dc7:	00 00 00 
80103dca:	83 c4 10             	add    $0x10,%esp
80103dcd:	eb 91                	jmp    80103d60 <scheduler+0x130>
80103dcf:	90                   	nop

80103dd0 <sched>:
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	56                   	push   %esi
80103dd4:	53                   	push   %ebx
  pushcli();
80103dd5:	e8 f6 0a 00 00       	call   801048d0 <pushcli>
  c = mycpu();
80103dda:	e8 71 fa ff ff       	call   80103850 <mycpu>
  p = c->proc;
80103ddf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103de5:	e8 26 0b 00 00       	call   80104910 <popcli>
  if(!holding(&ptable.lock))
80103dea:	83 ec 0c             	sub    $0xc,%esp
80103ded:	68 20 3d 11 80       	push   $0x80113d20
80103df2:	e8 79 0b 00 00       	call   80104970 <holding>
80103df7:	83 c4 10             	add    $0x10,%esp
80103dfa:	85 c0                	test   %eax,%eax
80103dfc:	74 55                	je     80103e53 <sched+0x83>
  if(mycpu()->ncli != 1)
80103dfe:	e8 4d fa ff ff       	call   80103850 <mycpu>
80103e03:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e0a:	75 6e                	jne    80103e7a <sched+0xaa>
  if(p->state == RUNNING)
80103e0c:	83 bb 98 00 00 00 04 	cmpl   $0x4,0x98(%ebx)
80103e13:	74 58                	je     80103e6d <sched+0x9d>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e15:	9c                   	pushf  
80103e16:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e17:	f6 c4 02             	test   $0x2,%ah
80103e1a:	75 44                	jne    80103e60 <sched+0x90>
  intena = mycpu()->intena;
80103e1c:	e8 2f fa ff ff       	call   80103850 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103e21:	81 c3 a8 00 00 00    	add    $0xa8,%ebx
  intena = mycpu()->intena;
80103e27:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103e2d:	e8 1e fa ff ff       	call   80103850 <mycpu>
80103e32:	83 ec 08             	sub    $0x8,%esp
80103e35:	ff 70 04             	pushl  0x4(%eax)
80103e38:	53                   	push   %ebx
80103e39:	e8 ad 0e 00 00       	call   80104ceb <swtch>
  mycpu()->intena = intena;
80103e3e:	e8 0d fa ff ff       	call   80103850 <mycpu>
}
80103e43:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103e46:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e4f:	5b                   	pop    %ebx
80103e50:	5e                   	pop    %esi
80103e51:	5d                   	pop    %ebp
80103e52:	c3                   	ret    
    panic("sched ptable.lock");
80103e53:	83 ec 0c             	sub    $0xc,%esp
80103e56:	68 10 7c 10 80       	push   $0x80107c10
80103e5b:	e8 30 c5 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103e60:	83 ec 0c             	sub    $0xc,%esp
80103e63:	68 3c 7c 10 80       	push   $0x80107c3c
80103e68:	e8 23 c5 ff ff       	call   80100390 <panic>
    panic("sched running");
80103e6d:	83 ec 0c             	sub    $0xc,%esp
80103e70:	68 2e 7c 10 80       	push   $0x80107c2e
80103e75:	e8 16 c5 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103e7a:	83 ec 0c             	sub    $0xc,%esp
80103e7d:	68 22 7c 10 80       	push   $0x80107c22
80103e82:	e8 09 c5 ff ff       	call   80100390 <panic>
80103e87:	89 f6                	mov    %esi,%esi
80103e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e90 <exit>:
{
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	57                   	push   %edi
80103e94:	56                   	push   %esi
80103e95:	53                   	push   %ebx
80103e96:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103e99:	e8 32 0a 00 00       	call   801048d0 <pushcli>
  c = mycpu();
80103e9e:	e8 ad f9 ff ff       	call   80103850 <mycpu>
  p = c->proc;
80103ea3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ea9:	e8 62 0a 00 00       	call   80104910 <popcli>
  if(curproc == initproc)
80103eae:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80103eb4:	8d 9e b4 00 00 00    	lea    0xb4(%esi),%ebx
80103eba:	8d be f4 00 00 00    	lea    0xf4(%esi),%edi
80103ec0:	0f 84 27 01 00 00    	je     80103fed <exit+0x15d>
80103ec6:	8d 76 00             	lea    0x0(%esi),%esi
80103ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(curproc->ofile[fd]){
80103ed0:	8b 03                	mov    (%ebx),%eax
80103ed2:	85 c0                	test   %eax,%eax
80103ed4:	74 12                	je     80103ee8 <exit+0x58>
      fileclose(curproc->ofile[fd]);
80103ed6:	83 ec 0c             	sub    $0xc,%esp
80103ed9:	50                   	push   %eax
80103eda:	e8 71 cf ff ff       	call   80100e50 <fileclose>
      curproc->ofile[fd] = 0;
80103edf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103ee5:	83 c4 10             	add    $0x10,%esp
80103ee8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103eeb:	39 fb                	cmp    %edi,%ebx
80103eed:	75 e1                	jne    80103ed0 <exit+0x40>
  begin_op();
80103eef:	e8 cc ec ff ff       	call   80102bc0 <begin_op>
  iput(curproc->cwd);
80103ef4:	83 ec 0c             	sub    $0xc,%esp
80103ef7:	ff b6 f4 00 00 00    	pushl  0xf4(%esi)
80103efd:	e8 be d8 ff ff       	call   801017c0 <iput>
  end_op();
80103f02:	e8 29 ed ff ff       	call   80102c30 <end_op>
  curproc->cwd = 0;
80103f07:	c7 86 f4 00 00 00 00 	movl   $0x0,0xf4(%esi)
80103f0e:	00 00 00 
  acquire(&ptable.lock);
80103f11:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103f18:	e8 83 0a 00 00       	call   801049a0 <acquire>
  wakeup1(curproc->parent);
80103f1d:	8b 96 a0 00 00 00    	mov    0xa0(%esi),%edx
80103f23:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f26:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103f2b:	eb 0f                	jmp    80103f3c <exit+0xac>
80103f2d:	8d 76 00             	lea    0x0(%esi),%esi
80103f30:	05 08 01 00 00       	add    $0x108,%eax
80103f35:	3d 54 7f 11 80       	cmp    $0x80117f54,%eax
80103f3a:	73 27                	jae    80103f63 <exit+0xd3>
    if(p->state == SLEEPING && p->chan == chan)
80103f3c:	83 b8 98 00 00 00 02 	cmpl   $0x2,0x98(%eax)
80103f43:	75 eb                	jne    80103f30 <exit+0xa0>
80103f45:	3b 90 ac 00 00 00    	cmp    0xac(%eax),%edx
80103f4b:	75 e3                	jne    80103f30 <exit+0xa0>
      p->state = RUNNABLE;
80103f4d:	c7 80 98 00 00 00 03 	movl   $0x3,0x98(%eax)
80103f54:	00 00 00 
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f57:	05 08 01 00 00       	add    $0x108,%eax
80103f5c:	3d 54 7f 11 80       	cmp    $0x80117f54,%eax
80103f61:	72 d9                	jb     80103f3c <exit+0xac>
      p->parent = initproc;
80103f63:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f69:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80103f6e:	eb 0e                	jmp    80103f7e <exit+0xee>
80103f70:	81 c2 08 01 00 00    	add    $0x108,%edx
80103f76:	81 fa 54 7f 11 80    	cmp    $0x80117f54,%edx
80103f7c:	73 4b                	jae    80103fc9 <exit+0x139>
    if(p->parent == curproc){
80103f7e:	39 b2 a0 00 00 00    	cmp    %esi,0xa0(%edx)
80103f84:	75 ea                	jne    80103f70 <exit+0xe0>
      if(p->state == ZOMBIE)
80103f86:	83 ba 98 00 00 00 05 	cmpl   $0x5,0x98(%edx)
      p->parent = initproc;
80103f8d:	89 8a a0 00 00 00    	mov    %ecx,0xa0(%edx)
      if(p->state == ZOMBIE)
80103f93:	75 db                	jne    80103f70 <exit+0xe0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f95:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103f9a:	eb 10                	jmp    80103fac <exit+0x11c>
80103f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fa0:	05 08 01 00 00       	add    $0x108,%eax
80103fa5:	3d 54 7f 11 80       	cmp    $0x80117f54,%eax
80103faa:	73 c4                	jae    80103f70 <exit+0xe0>
    if(p->state == SLEEPING && p->chan == chan)
80103fac:	83 b8 98 00 00 00 02 	cmpl   $0x2,0x98(%eax)
80103fb3:	75 eb                	jne    80103fa0 <exit+0x110>
80103fb5:	3b 88 ac 00 00 00    	cmp    0xac(%eax),%ecx
80103fbb:	75 e3                	jne    80103fa0 <exit+0x110>
      p->state = RUNNABLE;
80103fbd:	c7 80 98 00 00 00 03 	movl   $0x3,0x98(%eax)
80103fc4:	00 00 00 
80103fc7:	eb d7                	jmp    80103fa0 <exit+0x110>
  curproc->terminationTime = ticks;
80103fc9:	a1 a0 87 11 80       	mov    0x801187a0,%eax
  curproc->state = ZOMBIE;
80103fce:	c7 86 98 00 00 00 05 	movl   $0x5,0x98(%esi)
80103fd5:	00 00 00 
  curproc->terminationTime = ticks;
80103fd8:	89 46 04             	mov    %eax,0x4(%esi)
  sched();
80103fdb:	e8 f0 fd ff ff       	call   80103dd0 <sched>
  panic("zombie exit");
80103fe0:	83 ec 0c             	sub    $0xc,%esp
80103fe3:	68 5d 7c 10 80       	push   $0x80107c5d
80103fe8:	e8 a3 c3 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103fed:	83 ec 0c             	sub    $0xc,%esp
80103ff0:	68 50 7c 10 80       	push   $0x80107c50
80103ff5:	e8 96 c3 ff ff       	call   80100390 <panic>
80103ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104000 <yield>:
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	53                   	push   %ebx
80104004:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104007:	68 20 3d 11 80       	push   $0x80113d20
8010400c:	e8 8f 09 00 00       	call   801049a0 <acquire>
  pushcli();
80104011:	e8 ba 08 00 00       	call   801048d0 <pushcli>
  c = mycpu();
80104016:	e8 35 f8 ff ff       	call   80103850 <mycpu>
  p = c->proc;
8010401b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104021:	e8 ea 08 00 00       	call   80104910 <popcli>
  myproc()->state = RUNNABLE;
80104026:	c7 83 98 00 00 00 03 	movl   $0x3,0x98(%ebx)
8010402d:	00 00 00 
  sched();
80104030:	e8 9b fd ff ff       	call   80103dd0 <sched>
  release(&ptable.lock);
80104035:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010403c:	e8 1f 0a 00 00       	call   80104a60 <release>
}
80104041:	83 c4 10             	add    $0x10,%esp
80104044:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104047:	c9                   	leave  
80104048:	c3                   	ret    
80104049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104050 <sleep>:
{
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	57                   	push   %edi
80104054:	56                   	push   %esi
80104055:	53                   	push   %ebx
80104056:	83 ec 0c             	sub    $0xc,%esp
80104059:	8b 7d 08             	mov    0x8(%ebp),%edi
8010405c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010405f:	e8 6c 08 00 00       	call   801048d0 <pushcli>
  c = mycpu();
80104064:	e8 e7 f7 ff ff       	call   80103850 <mycpu>
  p = c->proc;
80104069:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010406f:	e8 9c 08 00 00       	call   80104910 <popcli>
  if(p == 0)
80104074:	85 db                	test   %ebx,%ebx
80104076:	0f 84 98 00 00 00    	je     80104114 <sleep+0xc4>
  if(lk == 0)
8010407c:	85 f6                	test   %esi,%esi
8010407e:	0f 84 83 00 00 00    	je     80104107 <sleep+0xb7>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104084:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
8010408a:	74 54                	je     801040e0 <sleep+0x90>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010408c:	83 ec 0c             	sub    $0xc,%esp
8010408f:	68 20 3d 11 80       	push   $0x80113d20
80104094:	e8 07 09 00 00       	call   801049a0 <acquire>
    release(lk);
80104099:	89 34 24             	mov    %esi,(%esp)
8010409c:	e8 bf 09 00 00       	call   80104a60 <release>
  p->chan = chan;
801040a1:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
  p->state = SLEEPING;
801040a7:	c7 83 98 00 00 00 02 	movl   $0x2,0x98(%ebx)
801040ae:	00 00 00 
  sched();
801040b1:	e8 1a fd ff ff       	call   80103dd0 <sched>
  p->chan = 0;
801040b6:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
801040bd:	00 00 00 
    release(&ptable.lock);
801040c0:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801040c7:	e8 94 09 00 00       	call   80104a60 <release>
    acquire(lk);
801040cc:	89 75 08             	mov    %esi,0x8(%ebp)
801040cf:	83 c4 10             	add    $0x10,%esp
}
801040d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040d5:	5b                   	pop    %ebx
801040d6:	5e                   	pop    %esi
801040d7:	5f                   	pop    %edi
801040d8:	5d                   	pop    %ebp
    acquire(lk);
801040d9:	e9 c2 08 00 00       	jmp    801049a0 <acquire>
801040de:	66 90                	xchg   %ax,%ax
  p->chan = chan;
801040e0:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
  p->state = SLEEPING;
801040e6:	c7 83 98 00 00 00 02 	movl   $0x2,0x98(%ebx)
801040ed:	00 00 00 
  sched();
801040f0:	e8 db fc ff ff       	call   80103dd0 <sched>
  p->chan = 0;
801040f5:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
801040fc:	00 00 00 
}
801040ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104102:	5b                   	pop    %ebx
80104103:	5e                   	pop    %esi
80104104:	5f                   	pop    %edi
80104105:	5d                   	pop    %ebp
80104106:	c3                   	ret    
    panic("sleep without lk");
80104107:	83 ec 0c             	sub    $0xc,%esp
8010410a:	68 6f 7c 10 80       	push   $0x80107c6f
8010410f:	e8 7c c2 ff ff       	call   80100390 <panic>
    panic("sleep");
80104114:	83 ec 0c             	sub    $0xc,%esp
80104117:	68 69 7c 10 80       	push   $0x80107c69
8010411c:	e8 6f c2 ff ff       	call   80100390 <panic>
80104121:	eb 0d                	jmp    80104130 <wait>
80104123:	90                   	nop
80104124:	90                   	nop
80104125:	90                   	nop
80104126:	90                   	nop
80104127:	90                   	nop
80104128:	90                   	nop
80104129:	90                   	nop
8010412a:	90                   	nop
8010412b:	90                   	nop
8010412c:	90                   	nop
8010412d:	90                   	nop
8010412e:	90                   	nop
8010412f:	90                   	nop

80104130 <wait>:
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	56                   	push   %esi
80104134:	53                   	push   %ebx
  pushcli();
80104135:	e8 96 07 00 00       	call   801048d0 <pushcli>
  c = mycpu();
8010413a:	e8 11 f7 ff ff       	call   80103850 <mycpu>
  p = c->proc;
8010413f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104145:	e8 c6 07 00 00       	call   80104910 <popcli>
  acquire(&ptable.lock);
8010414a:	83 ec 0c             	sub    $0xc,%esp
8010414d:	68 20 3d 11 80       	push   $0x80113d20
80104152:	e8 49 08 00 00       	call   801049a0 <acquire>
80104157:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010415a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010415c:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80104161:	eb 13                	jmp    80104176 <wait+0x46>
80104163:	90                   	nop
80104164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104168:	81 c3 08 01 00 00    	add    $0x108,%ebx
8010416e:	81 fb 54 7f 11 80    	cmp    $0x80117f54,%ebx
80104174:	73 24                	jae    8010419a <wait+0x6a>
      if(p->parent != curproc)
80104176:	39 b3 a0 00 00 00    	cmp    %esi,0xa0(%ebx)
8010417c:	75 ea                	jne    80104168 <wait+0x38>
      if(p->state == ZOMBIE){
8010417e:	83 bb 98 00 00 00 05 	cmpl   $0x5,0x98(%ebx)
80104185:	74 41                	je     801041c8 <wait+0x98>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104187:	81 c3 08 01 00 00    	add    $0x108,%ebx
      havekids = 1;
8010418d:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104192:	81 fb 54 7f 11 80    	cmp    $0x80117f54,%ebx
80104198:	72 dc                	jb     80104176 <wait+0x46>
    if(!havekids || curproc->killed){
8010419a:	85 c0                	test   %eax,%eax
8010419c:	0f 84 97 00 00 00    	je     80104239 <wait+0x109>
801041a2:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
801041a8:	85 c0                	test   %eax,%eax
801041aa:	0f 85 89 00 00 00    	jne    80104239 <wait+0x109>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801041b0:	83 ec 08             	sub    $0x8,%esp
801041b3:	68 20 3d 11 80       	push   $0x80113d20
801041b8:	56                   	push   %esi
801041b9:	e8 92 fe ff ff       	call   80104050 <sleep>
    havekids = 0;
801041be:	83 c4 10             	add    $0x10,%esp
801041c1:	eb 97                	jmp    8010415a <wait+0x2a>
801041c3:	90                   	nop
801041c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
801041c8:	83 ec 0c             	sub    $0xc,%esp
801041cb:	ff b3 94 00 00 00    	pushl  0x94(%ebx)
        pid = p->pid;
801041d1:	8b b3 9c 00 00 00    	mov    0x9c(%ebx),%esi
        kfree(p->kstack);
801041d7:	e8 54 e1 ff ff       	call   80102330 <kfree>
        freevm(p->pgdir);
801041dc:	5a                   	pop    %edx
801041dd:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
        p->kstack = 0;
801041e3:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
801041ea:	00 00 00 
        freevm(p->pgdir);
801041ed:	e8 6e 31 00 00       	call   80107360 <freevm>
        release(&ptable.lock);
801041f2:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
        p->pid = 0;
801041f9:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
80104200:	00 00 00 
        p->parent = 0;
80104203:	c7 83 a0 00 00 00 00 	movl   $0x0,0xa0(%ebx)
8010420a:	00 00 00 
        p->name[0] = 0;
8010420d:	c6 83 f8 00 00 00 00 	movb   $0x0,0xf8(%ebx)
        p->killed = 0;
80104214:	c7 83 b0 00 00 00 00 	movl   $0x0,0xb0(%ebx)
8010421b:	00 00 00 
        p->state = UNUSED;
8010421e:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
80104225:	00 00 00 
        release(&ptable.lock);
80104228:	e8 33 08 00 00       	call   80104a60 <release>
        return pid;
8010422d:	83 c4 10             	add    $0x10,%esp
}
80104230:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104233:	89 f0                	mov    %esi,%eax
80104235:	5b                   	pop    %ebx
80104236:	5e                   	pop    %esi
80104237:	5d                   	pop    %ebp
80104238:	c3                   	ret    
      release(&ptable.lock);
80104239:	83 ec 0c             	sub    $0xc,%esp
      return -1;
8010423c:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104241:	68 20 3d 11 80       	push   $0x80113d20
80104246:	e8 15 08 00 00       	call   80104a60 <release>
      return -1;
8010424b:	83 c4 10             	add    $0x10,%esp
8010424e:	eb e0                	jmp    80104230 <wait+0x100>

80104250 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	53                   	push   %ebx
80104254:	83 ec 10             	sub    $0x10,%esp
80104257:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010425a:	68 20 3d 11 80       	push   $0x80113d20
8010425f:	e8 3c 07 00 00       	call   801049a0 <acquire>
80104264:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104267:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010426c:	eb 0e                	jmp    8010427c <wakeup+0x2c>
8010426e:	66 90                	xchg   %ax,%ax
80104270:	05 08 01 00 00       	add    $0x108,%eax
80104275:	3d 54 7f 11 80       	cmp    $0x80117f54,%eax
8010427a:	73 27                	jae    801042a3 <wakeup+0x53>
    if(p->state == SLEEPING && p->chan == chan)
8010427c:	83 b8 98 00 00 00 02 	cmpl   $0x2,0x98(%eax)
80104283:	75 eb                	jne    80104270 <wakeup+0x20>
80104285:	3b 98 ac 00 00 00    	cmp    0xac(%eax),%ebx
8010428b:	75 e3                	jne    80104270 <wakeup+0x20>
      p->state = RUNNABLE;
8010428d:	c7 80 98 00 00 00 03 	movl   $0x3,0x98(%eax)
80104294:	00 00 00 
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104297:	05 08 01 00 00       	add    $0x108,%eax
8010429c:	3d 54 7f 11 80       	cmp    $0x80117f54,%eax
801042a1:	72 d9                	jb     8010427c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
801042a3:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
801042aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042ad:	c9                   	leave  
  release(&ptable.lock);
801042ae:	e9 ad 07 00 00       	jmp    80104a60 <release>
801042b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801042b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042c0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	53                   	push   %ebx
801042c4:	83 ec 10             	sub    $0x10,%esp
801042c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801042ca:	68 20 3d 11 80       	push   $0x80113d20
801042cf:	e8 cc 06 00 00       	call   801049a0 <acquire>
801042d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042d7:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801042dc:	eb 0e                	jmp    801042ec <kill+0x2c>
801042de:	66 90                	xchg   %ax,%ax
801042e0:	05 08 01 00 00       	add    $0x108,%eax
801042e5:	3d 54 7f 11 80       	cmp    $0x80117f54,%eax
801042ea:	73 44                	jae    80104330 <kill+0x70>
    if(p->pid == pid){
801042ec:	39 98 9c 00 00 00    	cmp    %ebx,0x9c(%eax)
801042f2:	75 ec                	jne    801042e0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801042f4:	83 b8 98 00 00 00 02 	cmpl   $0x2,0x98(%eax)
      p->killed = 1;
801042fb:	c7 80 b0 00 00 00 01 	movl   $0x1,0xb0(%eax)
80104302:	00 00 00 
      if(p->state == SLEEPING)
80104305:	75 0a                	jne    80104311 <kill+0x51>
        p->state = RUNNABLE;
80104307:	c7 80 98 00 00 00 03 	movl   $0x3,0x98(%eax)
8010430e:	00 00 00 
      release(&ptable.lock);
80104311:	83 ec 0c             	sub    $0xc,%esp
80104314:	68 20 3d 11 80       	push   $0x80113d20
80104319:	e8 42 07 00 00       	call   80104a60 <release>
      return 0;
8010431e:	83 c4 10             	add    $0x10,%esp
80104321:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104323:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104326:	c9                   	leave  
80104327:	c3                   	ret    
80104328:	90                   	nop
80104329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104330:	83 ec 0c             	sub    $0xc,%esp
80104333:	68 20 3d 11 80       	push   $0x80113d20
80104338:	e8 23 07 00 00       	call   80104a60 <release>
  return -1;
8010433d:	83 c4 10             	add    $0x10,%esp
80104340:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104345:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104348:	c9                   	leave  
80104349:	c3                   	ret    
8010434a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104350 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	57                   	push   %edi
80104354:	56                   	push   %esi
80104355:	53                   	push   %ebx
80104356:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104359:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
8010435e:	83 ec 3c             	sub    $0x3c,%esp
80104361:	eb 27                	jmp    8010438a <procdump+0x3a>
80104363:	90                   	nop
80104364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104368:	83 ec 0c             	sub    $0xc,%esp
8010436b:	68 13 80 10 80       	push   $0x80108013
80104370:	e8 eb c2 ff ff       	call   80100660 <cprintf>
80104375:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104378:	81 c3 08 01 00 00    	add    $0x108,%ebx
8010437e:	81 fb 54 7f 11 80    	cmp    $0x80117f54,%ebx
80104384:	0f 83 96 00 00 00    	jae    80104420 <procdump+0xd0>
    if(p->state == UNUSED)
8010438a:	8b 83 98 00 00 00    	mov    0x98(%ebx),%eax
80104390:	85 c0                	test   %eax,%eax
80104392:	74 e4                	je     80104378 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104394:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104397:	ba 80 7c 10 80       	mov    $0x80107c80,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010439c:	77 11                	ja     801043af <procdump+0x5f>
8010439e:	8b 14 85 e0 7c 10 80 	mov    -0x7fef8320(,%eax,4),%edx
      state = "???";
801043a5:	b8 80 7c 10 80       	mov    $0x80107c80,%eax
801043aa:	85 d2                	test   %edx,%edx
801043ac:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801043af:	8d 83 f8 00 00 00    	lea    0xf8(%ebx),%eax
801043b5:	50                   	push   %eax
801043b6:	52                   	push   %edx
801043b7:	ff b3 9c 00 00 00    	pushl  0x9c(%ebx)
801043bd:	68 84 7c 10 80       	push   $0x80107c84
801043c2:	e8 99 c2 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801043c7:	83 c4 10             	add    $0x10,%esp
801043ca:	83 bb 98 00 00 00 02 	cmpl   $0x2,0x98(%ebx)
801043d1:	75 95                	jne    80104368 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801043d3:	8d 45 c0             	lea    -0x40(%ebp),%eax
801043d6:	83 ec 08             	sub    $0x8,%esp
801043d9:	8d 7d c0             	lea    -0x40(%ebp),%edi
801043dc:	50                   	push   %eax
801043dd:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
801043e3:	8b 40 0c             	mov    0xc(%eax),%eax
801043e6:	83 c0 08             	add    $0x8,%eax
801043e9:	50                   	push   %eax
801043ea:	e8 91 04 00 00       	call   80104880 <getcallerpcs>
801043ef:	83 c4 10             	add    $0x10,%esp
801043f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801043f8:	8b 17                	mov    (%edi),%edx
801043fa:	85 d2                	test   %edx,%edx
801043fc:	0f 84 66 ff ff ff    	je     80104368 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104402:	83 ec 08             	sub    $0x8,%esp
80104405:	83 c7 04             	add    $0x4,%edi
80104408:	52                   	push   %edx
80104409:	68 c1 76 10 80       	push   $0x801076c1
8010440e:	e8 4d c2 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104413:	83 c4 10             	add    $0x10,%esp
80104416:	39 fe                	cmp    %edi,%esi
80104418:	75 de                	jne    801043f8 <procdump+0xa8>
8010441a:	e9 49 ff ff ff       	jmp    80104368 <procdump+0x18>
8010441f:	90                   	nop
  }
}
80104420:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104423:	5b                   	pop    %ebx
80104424:	5e                   	pop    %esi
80104425:	5f                   	pop    %edi
80104426:	5d                   	pop    %ebp
80104427:	c3                   	ret    
80104428:	90                   	nop
80104429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104430 <getppid>:

int getppid(void){
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	53                   	push   %ebx
80104434:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104437:	e8 94 04 00 00       	call   801048d0 <pushcli>
  c = mycpu();
8010443c:	e8 0f f4 ff ff       	call   80103850 <mycpu>
  p = c->proc;
80104441:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104447:	e8 c4 04 00 00       	call   80104910 <popcli>
	return myproc() -> parent ->pid;
8010444c:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80104452:	8b 80 9c 00 00 00    	mov    0x9c(%eax),%eax
}
80104458:	83 c4 04             	add    $0x4,%esp
8010445b:	5b                   	pop    %ebx
8010445c:	5d                   	pop    %ebp
8010445d:	c3                   	ret    
8010445e:	66 90                	xchg   %ax,%ax

80104460 <getchildren>:
int getchildren(void){
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	57                   	push   %edi
80104464:	56                   	push   %esi
80104465:	53                   	push   %ebx
    struct proc *p;
    int result=0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104466:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
int getchildren(void){
8010446b:	83 ec 1c             	sub    $0x1c,%esp
    int result=0;
8010446e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104475:	8d 76 00             	lea    0x0(%esi),%esi
        if(p->parent->pid == myproc()->pid){
80104478:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
8010447e:	8b b8 9c 00 00 00    	mov    0x9c(%eax),%edi
  pushcli();
80104484:	e8 47 04 00 00       	call   801048d0 <pushcli>
  c = mycpu();
80104489:	e8 c2 f3 ff ff       	call   80103850 <mycpu>
  p = c->proc;
8010448e:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104494:	e8 77 04 00 00       	call   80104910 <popcli>
        if(p->parent->pid == myproc()->pid){
80104499:	3b be 9c 00 00 00    	cmp    0x9c(%esi),%edi
8010449f:	75 0d                	jne    801044ae <getchildren+0x4e>
            result *= 100;
801044a1:	6b 7d e4 64          	imul   $0x64,-0x1c(%ebp),%edi
            result += p->pid;
801044a5:	03 bb 9c 00 00 00    	add    0x9c(%ebx),%edi
801044ab:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044ae:	81 c3 08 01 00 00    	add    $0x108,%ebx
801044b4:	81 fb 54 7f 11 80    	cmp    $0x80117f54,%ebx
801044ba:	72 bc                	jb     80104478 <getchildren+0x18>
        }
    }
    return result;
}
801044bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801044bf:	83 c4 1c             	add    $0x1c,%esp
801044c2:	5b                   	pop    %ebx
801044c3:	5e                   	pop    %esi
801044c4:	5f                   	pop    %edi
801044c5:	5d                   	pop    %ebp
801044c6:	c3                   	ret    
801044c7:	89 f6                	mov    %esi,%esi
801044c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044d0 <getcount>:
int getcount(int input){
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	53                   	push   %ebx
801044d4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801044d7:	e8 f4 03 00 00       	call   801048d0 <pushcli>
  c = mycpu();
801044dc:	e8 6f f3 ff ff       	call   80103850 <mycpu>
  p = c->proc;
801044e1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044e7:	e8 24 04 00 00       	call   80104910 <popcli>
   return myproc()->hit[input];
801044ec:	8b 45 08             	mov    0x8(%ebp),%eax
801044ef:	8b 44 83 20          	mov    0x20(%ebx,%eax,4),%eax
}
801044f3:	83 c4 04             	add    $0x4,%esp
801044f6:	5b                   	pop    %ebx
801044f7:	5d                   	pop    %ebp
801044f8:	c3                   	ret    
801044f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104500 <changePriority>:

int changePriority(int priority){
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	56                   	push   %esi
80104504:	53                   	push   %ebx
80104505:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(priority >=1 && priority <=5){
80104508:	8d 43 ff             	lea    -0x1(%ebx),%eax
8010450b:	83 f8 04             	cmp    $0x4,%eax
8010450e:	77 28                	ja     80104538 <changePriority+0x38>
  pushcli();
80104510:	e8 bb 03 00 00       	call   801048d0 <pushcli>
  c = mycpu();
80104515:	e8 36 f3 ff ff       	call   80103850 <mycpu>
  p = c->proc;
8010451a:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104520:	e8 eb 03 00 00       	call   80104910 <popcli>
    myproc()->priority = priority;
    return 1;
80104525:	b8 01 00 00 00       	mov    $0x1,%eax
    myproc()->priority = priority;
8010452a:	89 5e 14             	mov    %ebx,0x14(%esi)
  }
  return -1;
}
8010452d:	5b                   	pop    %ebx
8010452e:	5e                   	pop    %esi
8010452f:	5d                   	pop    %ebp
80104530:	c3                   	ret    
80104531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return -1;
80104538:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010453d:	eb ee                	jmp    8010452d <changePriority+0x2d>
8010453f:	90                   	nop

80104540 <getPolicy>:

int getPolicy(){
80104540:	55                   	push   %ebp
    return policy;
}
80104541:	a1 08 b0 10 80       	mov    0x8010b008,%eax
int getPolicy(){
80104546:	89 e5                	mov    %esp,%ebp
}
80104548:	5d                   	pop    %ebp
80104549:	c3                   	ret    
8010454a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104550 <timerUpdate>:
void timerUpdate(){
80104550:	55                   	push   %ebp
        break;
      case RUNNABLE:
        p->readyTime++;
        break;
      case ZOMBIE:
        p->terminationTime = ticks;
80104551:	8b 0d a0 87 11 80    	mov    0x801187a0,%ecx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104557:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
void timerUpdate(){
8010455c:	89 e5                	mov    %esp,%ebp
8010455e:	eb 19                	jmp    80104579 <timerUpdate+0x29>
      switch (p->state)
80104560:	83 fa 04             	cmp    $0x4,%edx
80104563:	74 3b                	je     801045a0 <timerUpdate+0x50>
80104565:	83 fa 05             	cmp    $0x5,%edx
80104568:	75 03                	jne    8010456d <timerUpdate+0x1d>
        p->terminationTime = ticks;
8010456a:	89 48 04             	mov    %ecx,0x4(%eax)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010456d:	05 08 01 00 00       	add    $0x108,%eax
80104572:	3d 54 7f 11 80       	cmp    $0x80117f54,%eax
80104577:	73 22                	jae    8010459b <timerUpdate+0x4b>
      switch (p->state)
80104579:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
8010457f:	83 fa 03             	cmp    $0x3,%edx
80104582:	74 2c                	je     801045b0 <timerUpdate+0x60>
80104584:	77 da                	ja     80104560 <timerUpdate+0x10>
80104586:	83 fa 02             	cmp    $0x2,%edx
80104589:	75 e2                	jne    8010456d <timerUpdate+0x1d>
        p->sleepingTime++;
8010458b:	83 40 08 01          	addl   $0x1,0x8(%eax)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010458f:	05 08 01 00 00       	add    $0x108,%eax
80104594:	3d 54 7f 11 80       	cmp    $0x80117f54,%eax
80104599:	72 de                	jb     80104579 <timerUpdate+0x29>
        break;
      default:
        break;
    }
    }
}
8010459b:	5d                   	pop    %ebp
8010459c:	c3                   	ret    
8010459d:	8d 76 00             	lea    0x0(%esi),%esi
        p->runningTime++;
801045a0:	83 40 10 01          	addl   $0x1,0x10(%eax)
        p->readyTime++;
801045a4:	83 40 0c 01          	addl   $0x1,0xc(%eax)
        break;
801045a8:	eb c3                	jmp    8010456d <timerUpdate+0x1d>
801045aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        p->readyTime++;
801045b0:	83 40 0c 01          	addl   $0x1,0xc(%eax)
        break;
801045b4:	eb b7                	jmp    8010456d <timerUpdate+0x1d>
801045b6:	8d 76 00             	lea    0x0(%esi),%esi
801045b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045c0 <changePolicy>:

int changePolicy(int policy){
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
          break;
        case 2:
          policy = 2;
          break;
        }
        return 1;
801045c3:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
    }
    return -1;
    
}
801045c7:	5d                   	pop    %ebp
        return 1;
801045c8:	19 c0                	sbb    %eax,%eax
801045ca:	83 e0 02             	and    $0x2,%eax
801045cd:	83 e8 01             	sub    $0x1,%eax
}
801045d0:	c3                   	ret    
801045d1:	eb 0d                	jmp    801045e0 <waitForChild>
801045d3:	90                   	nop
801045d4:	90                   	nop
801045d5:	90                   	nop
801045d6:	90                   	nop
801045d7:	90                   	nop
801045d8:	90                   	nop
801045d9:	90                   	nop
801045da:	90                   	nop
801045db:	90                   	nop
801045dc:	90                   	nop
801045dd:	90                   	nop
801045de:	90                   	nop
801045df:	90                   	nop

801045e0 <waitForChild>:


int waitForChild(struct timeVariables *tv){
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	57                   	push   %edi
801045e4:	56                   	push   %esi
801045e5:	53                   	push   %ebx
801045e6:	83 ec 0c             	sub    $0xc,%esp
801045e9:	8b 7d 08             	mov    0x8(%ebp),%edi
  pushcli();
801045ec:	e8 df 02 00 00       	call   801048d0 <pushcli>
  c = mycpu();
801045f1:	e8 5a f2 ff ff       	call   80103850 <mycpu>
  p = c->proc;
801045f6:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801045fc:	e8 0f 03 00 00       	call   80104910 <popcli>
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
80104601:	83 ec 0c             	sub    $0xc,%esp
80104604:	68 20 3d 11 80       	push   $0x80113d20
80104609:	e8 92 03 00 00       	call   801049a0 <acquire>
8010460e:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104611:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104613:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80104618:	eb 14                	jmp    8010462e <waitForChild+0x4e>
8010461a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104620:	81 c3 08 01 00 00    	add    $0x108,%ebx
80104626:	81 fb 54 7f 11 80    	cmp    $0x80117f54,%ebx
8010462c:	73 24                	jae    80104652 <waitForChild+0x72>
      if(p->parent != curproc)
8010462e:	39 b3 a0 00 00 00    	cmp    %esi,0xa0(%ebx)
80104634:	75 ea                	jne    80104620 <waitForChild+0x40>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80104636:	83 bb 98 00 00 00 05 	cmpl   $0x5,0x98(%ebx)
8010463d:	74 41                	je     80104680 <waitForChild+0xa0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010463f:	81 c3 08 01 00 00    	add    $0x108,%ebx
      havekids = 1;
80104645:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010464a:	81 fb 54 7f 11 80    	cmp    $0x80117f54,%ebx
80104650:	72 dc                	jb     8010462e <waitForChild+0x4e>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104652:	85 c0                	test   %eax,%eax
80104654:	0f 84 b4 00 00 00    	je     8010470e <waitForChild+0x12e>
8010465a:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
80104660:	85 c0                	test   %eax,%eax
80104662:	0f 85 a6 00 00 00    	jne    8010470e <waitForChild+0x12e>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104668:	83 ec 08             	sub    $0x8,%esp
8010466b:	68 20 3d 11 80       	push   $0x80113d20
80104670:	56                   	push   %esi
80104671:	e8 da f9 ff ff       	call   80104050 <sleep>
    havekids = 0;
80104676:	83 c4 10             	add    $0x10,%esp
80104679:	eb 96                	jmp    80104611 <waitForChild+0x31>
8010467b:	90                   	nop
8010467c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104680:	83 ec 0c             	sub    $0xc,%esp
80104683:	ff b3 94 00 00 00    	pushl  0x94(%ebx)
        pid = p->pid;
80104689:	8b b3 9c 00 00 00    	mov    0x9c(%ebx),%esi
        kfree(p->kstack);
8010468f:	e8 9c dc ff ff       	call   80102330 <kfree>
        freevm(p->pgdir);
80104694:	5a                   	pop    %edx
80104695:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
        p->kstack = 0;
8010469b:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
801046a2:	00 00 00 
        freevm(p->pgdir);
801046a5:	e8 b6 2c 00 00       	call   80107360 <freevm>
        tv->creationTime = p->creationTime;
801046aa:	8b 03                	mov    (%ebx),%eax
801046ac:	89 07                	mov    %eax,(%edi)
        tv->terminationTime = p->terminationTime;
801046ae:	8b 43 04             	mov    0x4(%ebx),%eax
801046b1:	89 47 04             	mov    %eax,0x4(%edi)
        tv->sleepingTime = p->sleepingTime;
801046b4:	8b 43 08             	mov    0x8(%ebx),%eax
801046b7:	89 47 08             	mov    %eax,0x8(%edi)
        tv->readyTime = p->readyTime;
801046ba:	8b 43 0c             	mov    0xc(%ebx),%eax
801046bd:	89 47 0c             	mov    %eax,0xc(%edi)
        tv->runningTime = p->runningTime;
801046c0:	8b 43 10             	mov    0x10(%ebx),%eax
801046c3:	89 47 10             	mov    %eax,0x10(%edi)
        release(&ptable.lock);
801046c6:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
        p->pid = 0;
801046cd:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
801046d4:	00 00 00 
        p->parent = 0;
801046d7:	c7 83 a0 00 00 00 00 	movl   $0x0,0xa0(%ebx)
801046de:	00 00 00 
        p->name[0] = 0;
801046e1:	c6 83 f8 00 00 00 00 	movb   $0x0,0xf8(%ebx)
        p->killed = 0;
801046e8:	c7 83 b0 00 00 00 00 	movl   $0x0,0xb0(%ebx)
801046ef:	00 00 00 
        p->state = UNUSED;
801046f2:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
801046f9:	00 00 00 
        release(&ptable.lock);
801046fc:	e8 5f 03 00 00       	call   80104a60 <release>
        return pid;
80104701:	83 c4 10             	add    $0x10,%esp
  }
}
80104704:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104707:	89 f0                	mov    %esi,%eax
80104709:	5b                   	pop    %ebx
8010470a:	5e                   	pop    %esi
8010470b:	5f                   	pop    %edi
8010470c:	5d                   	pop    %ebp
8010470d:	c3                   	ret    
      release(&ptable.lock);
8010470e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104711:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104716:	68 20 3d 11 80       	push   $0x80113d20
8010471b:	e8 40 03 00 00       	call   80104a60 <release>
      return -1;
80104720:	83 c4 10             	add    $0x10,%esp
80104723:	eb df                	jmp    80104704 <waitForChild+0x124>
80104725:	66 90                	xchg   %ax,%ax
80104727:	66 90                	xchg   %ax,%ax
80104729:	66 90                	xchg   %ax,%ax
8010472b:	66 90                	xchg   %ax,%ax
8010472d:	66 90                	xchg   %ax,%ax
8010472f:	90                   	nop

80104730 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	53                   	push   %ebx
80104734:	83 ec 0c             	sub    $0xc,%esp
80104737:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010473a:	68 f8 7c 10 80       	push   $0x80107cf8
8010473f:	8d 43 04             	lea    0x4(%ebx),%eax
80104742:	50                   	push   %eax
80104743:	e8 18 01 00 00       	call   80104860 <initlock>
  lk->name = name;
80104748:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010474b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104751:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104754:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010475b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010475e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104761:	c9                   	leave  
80104762:	c3                   	ret    
80104763:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104770 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	56                   	push   %esi
80104774:	53                   	push   %ebx
80104775:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104778:	83 ec 0c             	sub    $0xc,%esp
8010477b:	8d 73 04             	lea    0x4(%ebx),%esi
8010477e:	56                   	push   %esi
8010477f:	e8 1c 02 00 00       	call   801049a0 <acquire>
  while (lk->locked) {
80104784:	8b 13                	mov    (%ebx),%edx
80104786:	83 c4 10             	add    $0x10,%esp
80104789:	85 d2                	test   %edx,%edx
8010478b:	74 16                	je     801047a3 <acquiresleep+0x33>
8010478d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104790:	83 ec 08             	sub    $0x8,%esp
80104793:	56                   	push   %esi
80104794:	53                   	push   %ebx
80104795:	e8 b6 f8 ff ff       	call   80104050 <sleep>
  while (lk->locked) {
8010479a:	8b 03                	mov    (%ebx),%eax
8010479c:	83 c4 10             	add    $0x10,%esp
8010479f:	85 c0                	test   %eax,%eax
801047a1:	75 ed                	jne    80104790 <acquiresleep+0x20>
  }
  lk->locked = 1;
801047a3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801047a9:	e8 42 f1 ff ff       	call   801038f0 <myproc>
801047ae:	8b 80 9c 00 00 00    	mov    0x9c(%eax),%eax
801047b4:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801047b7:	89 75 08             	mov    %esi,0x8(%ebp)
}
801047ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047bd:	5b                   	pop    %ebx
801047be:	5e                   	pop    %esi
801047bf:	5d                   	pop    %ebp
  release(&lk->lk);
801047c0:	e9 9b 02 00 00       	jmp    80104a60 <release>
801047c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047d0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	56                   	push   %esi
801047d4:	53                   	push   %ebx
801047d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801047d8:	83 ec 0c             	sub    $0xc,%esp
801047db:	8d 73 04             	lea    0x4(%ebx),%esi
801047de:	56                   	push   %esi
801047df:	e8 bc 01 00 00       	call   801049a0 <acquire>
  lk->locked = 0;
801047e4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801047ea:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801047f1:	89 1c 24             	mov    %ebx,(%esp)
801047f4:	e8 57 fa ff ff       	call   80104250 <wakeup>
  release(&lk->lk);
801047f9:	89 75 08             	mov    %esi,0x8(%ebp)
801047fc:	83 c4 10             	add    $0x10,%esp
}
801047ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104802:	5b                   	pop    %ebx
80104803:	5e                   	pop    %esi
80104804:	5d                   	pop    %ebp
  release(&lk->lk);
80104805:	e9 56 02 00 00       	jmp    80104a60 <release>
8010480a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104810 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	57                   	push   %edi
80104814:	56                   	push   %esi
80104815:	53                   	push   %ebx
80104816:	31 ff                	xor    %edi,%edi
80104818:	83 ec 18             	sub    $0x18,%esp
8010481b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010481e:	8d 73 04             	lea    0x4(%ebx),%esi
80104821:	56                   	push   %esi
80104822:	e8 79 01 00 00       	call   801049a0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104827:	8b 03                	mov    (%ebx),%eax
80104829:	83 c4 10             	add    $0x10,%esp
8010482c:	85 c0                	test   %eax,%eax
8010482e:	74 16                	je     80104846 <holdingsleep+0x36>
80104830:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104833:	e8 b8 f0 ff ff       	call   801038f0 <myproc>
80104838:	39 98 9c 00 00 00    	cmp    %ebx,0x9c(%eax)
8010483e:	0f 94 c0             	sete   %al
80104841:	0f b6 c0             	movzbl %al,%eax
80104844:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104846:	83 ec 0c             	sub    $0xc,%esp
80104849:	56                   	push   %esi
8010484a:	e8 11 02 00 00       	call   80104a60 <release>
  return r;
}
8010484f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104852:	89 f8                	mov    %edi,%eax
80104854:	5b                   	pop    %ebx
80104855:	5e                   	pop    %esi
80104856:	5f                   	pop    %edi
80104857:	5d                   	pop    %ebp
80104858:	c3                   	ret    
80104859:	66 90                	xchg   %ax,%ax
8010485b:	66 90                	xchg   %ax,%ax
8010485d:	66 90                	xchg   %ax,%ax
8010485f:	90                   	nop

80104860 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104866:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104869:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010486f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104872:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104879:	5d                   	pop    %ebp
8010487a:	c3                   	ret    
8010487b:	90                   	nop
8010487c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104880 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104880:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104881:	31 d2                	xor    %edx,%edx
{
80104883:	89 e5                	mov    %esp,%ebp
80104885:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104886:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104889:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010488c:	83 e8 08             	sub    $0x8,%eax
8010488f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104890:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104896:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010489c:	77 1a                	ja     801048b8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010489e:	8b 58 04             	mov    0x4(%eax),%ebx
801048a1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801048a4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801048a7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801048a9:	83 fa 0a             	cmp    $0xa,%edx
801048ac:	75 e2                	jne    80104890 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801048ae:	5b                   	pop    %ebx
801048af:	5d                   	pop    %ebp
801048b0:	c3                   	ret    
801048b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048b8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801048bb:	83 c1 28             	add    $0x28,%ecx
801048be:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801048c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801048c6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801048c9:	39 c1                	cmp    %eax,%ecx
801048cb:	75 f3                	jne    801048c0 <getcallerpcs+0x40>
}
801048cd:	5b                   	pop    %ebx
801048ce:	5d                   	pop    %ebp
801048cf:	c3                   	ret    

801048d0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	53                   	push   %ebx
801048d4:	83 ec 04             	sub    $0x4,%esp
801048d7:	9c                   	pushf  
801048d8:	5b                   	pop    %ebx
  asm volatile("cli");
801048d9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801048da:	e8 71 ef ff ff       	call   80103850 <mycpu>
801048df:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801048e5:	85 c0                	test   %eax,%eax
801048e7:	75 11                	jne    801048fa <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801048e9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801048ef:	e8 5c ef ff ff       	call   80103850 <mycpu>
801048f4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801048fa:	e8 51 ef ff ff       	call   80103850 <mycpu>
801048ff:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104906:	83 c4 04             	add    $0x4,%esp
80104909:	5b                   	pop    %ebx
8010490a:	5d                   	pop    %ebp
8010490b:	c3                   	ret    
8010490c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104910 <popcli>:

void
popcli(void)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104916:	9c                   	pushf  
80104917:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104918:	f6 c4 02             	test   $0x2,%ah
8010491b:	75 35                	jne    80104952 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010491d:	e8 2e ef ff ff       	call   80103850 <mycpu>
80104922:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104929:	78 34                	js     8010495f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010492b:	e8 20 ef ff ff       	call   80103850 <mycpu>
80104930:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104936:	85 d2                	test   %edx,%edx
80104938:	74 06                	je     80104940 <popcli+0x30>
    sti();
}
8010493a:	c9                   	leave  
8010493b:	c3                   	ret    
8010493c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104940:	e8 0b ef ff ff       	call   80103850 <mycpu>
80104945:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010494b:	85 c0                	test   %eax,%eax
8010494d:	74 eb                	je     8010493a <popcli+0x2a>
  asm volatile("sti");
8010494f:	fb                   	sti    
}
80104950:	c9                   	leave  
80104951:	c3                   	ret    
    panic("popcli - interruptible");
80104952:	83 ec 0c             	sub    $0xc,%esp
80104955:	68 03 7d 10 80       	push   $0x80107d03
8010495a:	e8 31 ba ff ff       	call   80100390 <panic>
    panic("popcli");
8010495f:	83 ec 0c             	sub    $0xc,%esp
80104962:	68 1a 7d 10 80       	push   $0x80107d1a
80104967:	e8 24 ba ff ff       	call   80100390 <panic>
8010496c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104970 <holding>:
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	56                   	push   %esi
80104974:	53                   	push   %ebx
80104975:	8b 75 08             	mov    0x8(%ebp),%esi
80104978:	31 db                	xor    %ebx,%ebx
  pushcli();
8010497a:	e8 51 ff ff ff       	call   801048d0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010497f:	8b 06                	mov    (%esi),%eax
80104981:	85 c0                	test   %eax,%eax
80104983:	74 10                	je     80104995 <holding+0x25>
80104985:	8b 5e 08             	mov    0x8(%esi),%ebx
80104988:	e8 c3 ee ff ff       	call   80103850 <mycpu>
8010498d:	39 c3                	cmp    %eax,%ebx
8010498f:	0f 94 c3             	sete   %bl
80104992:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104995:	e8 76 ff ff ff       	call   80104910 <popcli>
}
8010499a:	89 d8                	mov    %ebx,%eax
8010499c:	5b                   	pop    %ebx
8010499d:	5e                   	pop    %esi
8010499e:	5d                   	pop    %ebp
8010499f:	c3                   	ret    

801049a0 <acquire>:
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	56                   	push   %esi
801049a4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801049a5:	e8 26 ff ff ff       	call   801048d0 <pushcli>
  if(holding(lk))
801049aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049ad:	83 ec 0c             	sub    $0xc,%esp
801049b0:	53                   	push   %ebx
801049b1:	e8 ba ff ff ff       	call   80104970 <holding>
801049b6:	83 c4 10             	add    $0x10,%esp
801049b9:	85 c0                	test   %eax,%eax
801049bb:	0f 85 83 00 00 00    	jne    80104a44 <acquire+0xa4>
801049c1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801049c3:	ba 01 00 00 00       	mov    $0x1,%edx
801049c8:	eb 09                	jmp    801049d3 <acquire+0x33>
801049ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049d3:	89 d0                	mov    %edx,%eax
801049d5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801049d8:	85 c0                	test   %eax,%eax
801049da:	75 f4                	jne    801049d0 <acquire+0x30>
  __sync_synchronize();
801049dc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801049e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049e4:	e8 67 ee ff ff       	call   80103850 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801049e9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
801049ec:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801049ef:	89 e8                	mov    %ebp,%eax
801049f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801049f8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801049fe:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104a04:	77 1a                	ja     80104a20 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104a06:	8b 48 04             	mov    0x4(%eax),%ecx
80104a09:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104a0c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104a0f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104a11:	83 fe 0a             	cmp    $0xa,%esi
80104a14:	75 e2                	jne    801049f8 <acquire+0x58>
}
80104a16:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a19:	5b                   	pop    %ebx
80104a1a:	5e                   	pop    %esi
80104a1b:	5d                   	pop    %ebp
80104a1c:	c3                   	ret    
80104a1d:	8d 76 00             	lea    0x0(%esi),%esi
80104a20:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104a23:	83 c2 28             	add    $0x28,%edx
80104a26:	8d 76 00             	lea    0x0(%esi),%esi
80104a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104a30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104a36:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104a39:	39 d0                	cmp    %edx,%eax
80104a3b:	75 f3                	jne    80104a30 <acquire+0x90>
}
80104a3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a40:	5b                   	pop    %ebx
80104a41:	5e                   	pop    %esi
80104a42:	5d                   	pop    %ebp
80104a43:	c3                   	ret    
    panic("acquire");
80104a44:	83 ec 0c             	sub    $0xc,%esp
80104a47:	68 21 7d 10 80       	push   $0x80107d21
80104a4c:	e8 3f b9 ff ff       	call   80100390 <panic>
80104a51:	eb 0d                	jmp    80104a60 <release>
80104a53:	90                   	nop
80104a54:	90                   	nop
80104a55:	90                   	nop
80104a56:	90                   	nop
80104a57:	90                   	nop
80104a58:	90                   	nop
80104a59:	90                   	nop
80104a5a:	90                   	nop
80104a5b:	90                   	nop
80104a5c:	90                   	nop
80104a5d:	90                   	nop
80104a5e:	90                   	nop
80104a5f:	90                   	nop

80104a60 <release>:
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	53                   	push   %ebx
80104a64:	83 ec 10             	sub    $0x10,%esp
80104a67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104a6a:	53                   	push   %ebx
80104a6b:	e8 00 ff ff ff       	call   80104970 <holding>
80104a70:	83 c4 10             	add    $0x10,%esp
80104a73:	85 c0                	test   %eax,%eax
80104a75:	74 22                	je     80104a99 <release+0x39>
  lk->pcs[0] = 0;
80104a77:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104a7e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104a85:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104a8a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104a90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a93:	c9                   	leave  
  popcli();
80104a94:	e9 77 fe ff ff       	jmp    80104910 <popcli>
    panic("release");
80104a99:	83 ec 0c             	sub    $0xc,%esp
80104a9c:	68 29 7d 10 80       	push   $0x80107d29
80104aa1:	e8 ea b8 ff ff       	call   80100390 <panic>
80104aa6:	66 90                	xchg   %ax,%ax
80104aa8:	66 90                	xchg   %ax,%ax
80104aaa:	66 90                	xchg   %ax,%ax
80104aac:	66 90                	xchg   %ax,%ax
80104aae:	66 90                	xchg   %ax,%ax

80104ab0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	57                   	push   %edi
80104ab4:	53                   	push   %ebx
80104ab5:	8b 55 08             	mov    0x8(%ebp),%edx
80104ab8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104abb:	f6 c2 03             	test   $0x3,%dl
80104abe:	75 05                	jne    80104ac5 <memset+0x15>
80104ac0:	f6 c1 03             	test   $0x3,%cl
80104ac3:	74 13                	je     80104ad8 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104ac5:	89 d7                	mov    %edx,%edi
80104ac7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aca:	fc                   	cld    
80104acb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104acd:	5b                   	pop    %ebx
80104ace:	89 d0                	mov    %edx,%eax
80104ad0:	5f                   	pop    %edi
80104ad1:	5d                   	pop    %ebp
80104ad2:	c3                   	ret    
80104ad3:	90                   	nop
80104ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104ad8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104adc:	c1 e9 02             	shr    $0x2,%ecx
80104adf:	89 f8                	mov    %edi,%eax
80104ae1:	89 fb                	mov    %edi,%ebx
80104ae3:	c1 e0 18             	shl    $0x18,%eax
80104ae6:	c1 e3 10             	shl    $0x10,%ebx
80104ae9:	09 d8                	or     %ebx,%eax
80104aeb:	09 f8                	or     %edi,%eax
80104aed:	c1 e7 08             	shl    $0x8,%edi
80104af0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104af2:	89 d7                	mov    %edx,%edi
80104af4:	fc                   	cld    
80104af5:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104af7:	5b                   	pop    %ebx
80104af8:	89 d0                	mov    %edx,%eax
80104afa:	5f                   	pop    %edi
80104afb:	5d                   	pop    %ebp
80104afc:	c3                   	ret    
80104afd:	8d 76 00             	lea    0x0(%esi),%esi

80104b00 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	57                   	push   %edi
80104b04:	56                   	push   %esi
80104b05:	53                   	push   %ebx
80104b06:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104b09:	8b 75 08             	mov    0x8(%ebp),%esi
80104b0c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104b0f:	85 db                	test   %ebx,%ebx
80104b11:	74 29                	je     80104b3c <memcmp+0x3c>
    if(*s1 != *s2)
80104b13:	0f b6 16             	movzbl (%esi),%edx
80104b16:	0f b6 0f             	movzbl (%edi),%ecx
80104b19:	38 d1                	cmp    %dl,%cl
80104b1b:	75 2b                	jne    80104b48 <memcmp+0x48>
80104b1d:	b8 01 00 00 00       	mov    $0x1,%eax
80104b22:	eb 14                	jmp    80104b38 <memcmp+0x38>
80104b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b28:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104b2c:	83 c0 01             	add    $0x1,%eax
80104b2f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104b34:	38 ca                	cmp    %cl,%dl
80104b36:	75 10                	jne    80104b48 <memcmp+0x48>
  while(n-- > 0){
80104b38:	39 d8                	cmp    %ebx,%eax
80104b3a:	75 ec                	jne    80104b28 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104b3c:	5b                   	pop    %ebx
  return 0;
80104b3d:	31 c0                	xor    %eax,%eax
}
80104b3f:	5e                   	pop    %esi
80104b40:	5f                   	pop    %edi
80104b41:	5d                   	pop    %ebp
80104b42:	c3                   	ret    
80104b43:	90                   	nop
80104b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104b48:	0f b6 c2             	movzbl %dl,%eax
}
80104b4b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104b4c:	29 c8                	sub    %ecx,%eax
}
80104b4e:	5e                   	pop    %esi
80104b4f:	5f                   	pop    %edi
80104b50:	5d                   	pop    %ebp
80104b51:	c3                   	ret    
80104b52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b60 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	56                   	push   %esi
80104b64:	53                   	push   %ebx
80104b65:	8b 45 08             	mov    0x8(%ebp),%eax
80104b68:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104b6b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104b6e:	39 c3                	cmp    %eax,%ebx
80104b70:	73 26                	jae    80104b98 <memmove+0x38>
80104b72:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104b75:	39 c8                	cmp    %ecx,%eax
80104b77:	73 1f                	jae    80104b98 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104b79:	85 f6                	test   %esi,%esi
80104b7b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104b7e:	74 0f                	je     80104b8f <memmove+0x2f>
      *--d = *--s;
80104b80:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104b84:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104b87:	83 ea 01             	sub    $0x1,%edx
80104b8a:	83 fa ff             	cmp    $0xffffffff,%edx
80104b8d:	75 f1                	jne    80104b80 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104b8f:	5b                   	pop    %ebx
80104b90:	5e                   	pop    %esi
80104b91:	5d                   	pop    %ebp
80104b92:	c3                   	ret    
80104b93:	90                   	nop
80104b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104b98:	31 d2                	xor    %edx,%edx
80104b9a:	85 f6                	test   %esi,%esi
80104b9c:	74 f1                	je     80104b8f <memmove+0x2f>
80104b9e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104ba0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104ba4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104ba7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104baa:	39 d6                	cmp    %edx,%esi
80104bac:	75 f2                	jne    80104ba0 <memmove+0x40>
}
80104bae:	5b                   	pop    %ebx
80104baf:	5e                   	pop    %esi
80104bb0:	5d                   	pop    %ebp
80104bb1:	c3                   	ret    
80104bb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bc0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104bc3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104bc4:	eb 9a                	jmp    80104b60 <memmove>
80104bc6:	8d 76 00             	lea    0x0(%esi),%esi
80104bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bd0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	57                   	push   %edi
80104bd4:	56                   	push   %esi
80104bd5:	8b 7d 10             	mov    0x10(%ebp),%edi
80104bd8:	53                   	push   %ebx
80104bd9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104bdc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104bdf:	85 ff                	test   %edi,%edi
80104be1:	74 2f                	je     80104c12 <strncmp+0x42>
80104be3:	0f b6 01             	movzbl (%ecx),%eax
80104be6:	0f b6 1e             	movzbl (%esi),%ebx
80104be9:	84 c0                	test   %al,%al
80104beb:	74 37                	je     80104c24 <strncmp+0x54>
80104bed:	38 c3                	cmp    %al,%bl
80104bef:	75 33                	jne    80104c24 <strncmp+0x54>
80104bf1:	01 f7                	add    %esi,%edi
80104bf3:	eb 13                	jmp    80104c08 <strncmp+0x38>
80104bf5:	8d 76 00             	lea    0x0(%esi),%esi
80104bf8:	0f b6 01             	movzbl (%ecx),%eax
80104bfb:	84 c0                	test   %al,%al
80104bfd:	74 21                	je     80104c20 <strncmp+0x50>
80104bff:	0f b6 1a             	movzbl (%edx),%ebx
80104c02:	89 d6                	mov    %edx,%esi
80104c04:	38 d8                	cmp    %bl,%al
80104c06:	75 1c                	jne    80104c24 <strncmp+0x54>
    n--, p++, q++;
80104c08:	8d 56 01             	lea    0x1(%esi),%edx
80104c0b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104c0e:	39 fa                	cmp    %edi,%edx
80104c10:	75 e6                	jne    80104bf8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104c12:	5b                   	pop    %ebx
    return 0;
80104c13:	31 c0                	xor    %eax,%eax
}
80104c15:	5e                   	pop    %esi
80104c16:	5f                   	pop    %edi
80104c17:	5d                   	pop    %ebp
80104c18:	c3                   	ret    
80104c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c20:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104c24:	29 d8                	sub    %ebx,%eax
}
80104c26:	5b                   	pop    %ebx
80104c27:	5e                   	pop    %esi
80104c28:	5f                   	pop    %edi
80104c29:	5d                   	pop    %ebp
80104c2a:	c3                   	ret    
80104c2b:	90                   	nop
80104c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c30 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	56                   	push   %esi
80104c34:	53                   	push   %ebx
80104c35:	8b 45 08             	mov    0x8(%ebp),%eax
80104c38:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104c3b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104c3e:	89 c2                	mov    %eax,%edx
80104c40:	eb 19                	jmp    80104c5b <strncpy+0x2b>
80104c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c48:	83 c3 01             	add    $0x1,%ebx
80104c4b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104c4f:	83 c2 01             	add    $0x1,%edx
80104c52:	84 c9                	test   %cl,%cl
80104c54:	88 4a ff             	mov    %cl,-0x1(%edx)
80104c57:	74 09                	je     80104c62 <strncpy+0x32>
80104c59:	89 f1                	mov    %esi,%ecx
80104c5b:	85 c9                	test   %ecx,%ecx
80104c5d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104c60:	7f e6                	jg     80104c48 <strncpy+0x18>
    ;
  while(n-- > 0)
80104c62:	31 c9                	xor    %ecx,%ecx
80104c64:	85 f6                	test   %esi,%esi
80104c66:	7e 17                	jle    80104c7f <strncpy+0x4f>
80104c68:	90                   	nop
80104c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104c70:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104c74:	89 f3                	mov    %esi,%ebx
80104c76:	83 c1 01             	add    $0x1,%ecx
80104c79:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104c7b:	85 db                	test   %ebx,%ebx
80104c7d:	7f f1                	jg     80104c70 <strncpy+0x40>
  return os;
}
80104c7f:	5b                   	pop    %ebx
80104c80:	5e                   	pop    %esi
80104c81:	5d                   	pop    %ebp
80104c82:	c3                   	ret    
80104c83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c90 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	56                   	push   %esi
80104c94:	53                   	push   %ebx
80104c95:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c98:	8b 45 08             	mov    0x8(%ebp),%eax
80104c9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104c9e:	85 c9                	test   %ecx,%ecx
80104ca0:	7e 26                	jle    80104cc8 <safestrcpy+0x38>
80104ca2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104ca6:	89 c1                	mov    %eax,%ecx
80104ca8:	eb 17                	jmp    80104cc1 <safestrcpy+0x31>
80104caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104cb0:	83 c2 01             	add    $0x1,%edx
80104cb3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104cb7:	83 c1 01             	add    $0x1,%ecx
80104cba:	84 db                	test   %bl,%bl
80104cbc:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104cbf:	74 04                	je     80104cc5 <safestrcpy+0x35>
80104cc1:	39 f2                	cmp    %esi,%edx
80104cc3:	75 eb                	jne    80104cb0 <safestrcpy+0x20>
    ;
  *s = 0;
80104cc5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104cc8:	5b                   	pop    %ebx
80104cc9:	5e                   	pop    %esi
80104cca:	5d                   	pop    %ebp
80104ccb:	c3                   	ret    
80104ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104cd0 <strlen>:

int
strlen(const char *s)
{
80104cd0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104cd1:	31 c0                	xor    %eax,%eax
{
80104cd3:	89 e5                	mov    %esp,%ebp
80104cd5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104cd8:	80 3a 00             	cmpb   $0x0,(%edx)
80104cdb:	74 0c                	je     80104ce9 <strlen+0x19>
80104cdd:	8d 76 00             	lea    0x0(%esi),%esi
80104ce0:	83 c0 01             	add    $0x1,%eax
80104ce3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ce7:	75 f7                	jne    80104ce0 <strlen+0x10>
    ;
  return n;
}
80104ce9:	5d                   	pop    %ebp
80104cea:	c3                   	ret    

80104ceb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104ceb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104cef:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104cf3:	55                   	push   %ebp
  pushl %ebx
80104cf4:	53                   	push   %ebx
  pushl %esi
80104cf5:	56                   	push   %esi
  pushl %edi
80104cf6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104cf7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104cf9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104cfb:	5f                   	pop    %edi
  popl %esi
80104cfc:	5e                   	pop    %esi
  popl %ebx
80104cfd:	5b                   	pop    %ebx
  popl %ebp
80104cfe:	5d                   	pop    %ebp
  ret
80104cff:	c3                   	ret    

80104d00 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	53                   	push   %ebx
80104d04:	83 ec 04             	sub    $0x4,%esp
80104d07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104d0a:	e8 e1 eb ff ff       	call   801038f0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d0f:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80104d15:	39 d8                	cmp    %ebx,%eax
80104d17:	76 17                	jbe    80104d30 <fetchint+0x30>
80104d19:	8d 53 04             	lea    0x4(%ebx),%edx
80104d1c:	39 d0                	cmp    %edx,%eax
80104d1e:	72 10                	jb     80104d30 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104d20:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d23:	8b 13                	mov    (%ebx),%edx
80104d25:	89 10                	mov    %edx,(%eax)
  return 0;
80104d27:	31 c0                	xor    %eax,%eax
}
80104d29:	83 c4 04             	add    $0x4,%esp
80104d2c:	5b                   	pop    %ebx
80104d2d:	5d                   	pop    %ebp
80104d2e:	c3                   	ret    
80104d2f:	90                   	nop
    return -1;
80104d30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d35:	eb f2                	jmp    80104d29 <fetchint+0x29>
80104d37:	89 f6                	mov    %esi,%esi
80104d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d40 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	53                   	push   %ebx
80104d44:	83 ec 04             	sub    $0x4,%esp
80104d47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104d4a:	e8 a1 eb ff ff       	call   801038f0 <myproc>

  if(addr >= curproc->sz)
80104d4f:	39 98 8c 00 00 00    	cmp    %ebx,0x8c(%eax)
80104d55:	76 25                	jbe    80104d7c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104d57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104d5a:	89 da                	mov    %ebx,%edx
80104d5c:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104d5e:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
  for(s = *pp; s < ep; s++){
80104d64:	39 c3                	cmp    %eax,%ebx
80104d66:	73 14                	jae    80104d7c <fetchstr+0x3c>
    if(*s == 0)
80104d68:	80 3b 00             	cmpb   $0x0,(%ebx)
80104d6b:	75 08                	jne    80104d75 <fetchstr+0x35>
80104d6d:	eb 31                	jmp    80104da0 <fetchstr+0x60>
80104d6f:	90                   	nop
80104d70:	80 3a 00             	cmpb   $0x0,(%edx)
80104d73:	74 1b                	je     80104d90 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104d75:	83 c2 01             	add    $0x1,%edx
80104d78:	39 d0                	cmp    %edx,%eax
80104d7a:	77 f4                	ja     80104d70 <fetchstr+0x30>
    return -1;
80104d7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104d81:	83 c4 04             	add    $0x4,%esp
80104d84:	5b                   	pop    %ebx
80104d85:	5d                   	pop    %ebp
80104d86:	c3                   	ret    
80104d87:	89 f6                	mov    %esi,%esi
80104d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d90:	83 c4 04             	add    $0x4,%esp
80104d93:	89 d0                	mov    %edx,%eax
80104d95:	29 d8                	sub    %ebx,%eax
80104d97:	5b                   	pop    %ebx
80104d98:	5d                   	pop    %ebp
80104d99:	c3                   	ret    
80104d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104da0:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104da2:	eb dd                	jmp    80104d81 <fetchstr+0x41>
80104da4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104daa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104db0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	56                   	push   %esi
80104db4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104db5:	e8 36 eb ff ff       	call   801038f0 <myproc>
80104dba:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104dc0:	8b 55 08             	mov    0x8(%ebp),%edx
80104dc3:	8b 40 44             	mov    0x44(%eax),%eax
80104dc6:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104dc9:	e8 22 eb ff ff       	call   801038f0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104dce:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104dd4:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104dd7:	39 c6                	cmp    %eax,%esi
80104dd9:	73 15                	jae    80104df0 <argint+0x40>
80104ddb:	8d 53 08             	lea    0x8(%ebx),%edx
80104dde:	39 d0                	cmp    %edx,%eax
80104de0:	72 0e                	jb     80104df0 <argint+0x40>
  *ip = *(int*)(addr);
80104de2:	8b 45 0c             	mov    0xc(%ebp),%eax
80104de5:	8b 53 04             	mov    0x4(%ebx),%edx
80104de8:	89 10                	mov    %edx,(%eax)
  return 0;
80104dea:	31 c0                	xor    %eax,%eax
}
80104dec:	5b                   	pop    %ebx
80104ded:	5e                   	pop    %esi
80104dee:	5d                   	pop    %ebp
80104def:	c3                   	ret    
    return -1;
80104df0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104df5:	eb f5                	jmp    80104dec <argint+0x3c>
80104df7:	89 f6                	mov    %esi,%esi
80104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e00 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	56                   	push   %esi
80104e04:	53                   	push   %ebx
80104e05:	83 ec 10             	sub    $0x10,%esp
80104e08:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104e0b:	e8 e0 ea ff ff       	call   801038f0 <myproc>
80104e10:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104e12:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e15:	83 ec 08             	sub    $0x8,%esp
80104e18:	50                   	push   %eax
80104e19:	ff 75 08             	pushl  0x8(%ebp)
80104e1c:	e8 8f ff ff ff       	call   80104db0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104e21:	83 c4 10             	add    $0x10,%esp
80104e24:	85 c0                	test   %eax,%eax
80104e26:	78 28                	js     80104e50 <argptr+0x50>
80104e28:	85 db                	test   %ebx,%ebx
80104e2a:	78 24                	js     80104e50 <argptr+0x50>
80104e2c:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80104e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e35:	39 c2                	cmp    %eax,%edx
80104e37:	76 17                	jbe    80104e50 <argptr+0x50>
80104e39:	01 c3                	add    %eax,%ebx
80104e3b:	39 da                	cmp    %ebx,%edx
80104e3d:	72 11                	jb     80104e50 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104e3f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e42:	89 02                	mov    %eax,(%edx)
  return 0;
80104e44:	31 c0                	xor    %eax,%eax
}
80104e46:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e49:	5b                   	pop    %ebx
80104e4a:	5e                   	pop    %esi
80104e4b:	5d                   	pop    %ebp
80104e4c:	c3                   	ret    
80104e4d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104e50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e55:	eb ef                	jmp    80104e46 <argptr+0x46>
80104e57:	89 f6                	mov    %esi,%esi
80104e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e60 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104e66:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e69:	50                   	push   %eax
80104e6a:	ff 75 08             	pushl  0x8(%ebp)
80104e6d:	e8 3e ff ff ff       	call   80104db0 <argint>
80104e72:	83 c4 10             	add    $0x10,%esp
80104e75:	85 c0                	test   %eax,%eax
80104e77:	78 17                	js     80104e90 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104e79:	83 ec 08             	sub    $0x8,%esp
80104e7c:	ff 75 0c             	pushl  0xc(%ebp)
80104e7f:	ff 75 f4             	pushl  -0xc(%ebp)
80104e82:	e8 b9 fe ff ff       	call   80104d40 <fetchstr>
80104e87:	83 c4 10             	add    $0x10,%esp
}
80104e8a:	c9                   	leave  
80104e8b:	c3                   	ret    
80104e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e95:	c9                   	leave  
80104e96:	c3                   	ret    
80104e97:	89 f6                	mov    %esi,%esi
80104e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ea0 <syscall>:
};


void
syscall(void)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	56                   	push   %esi
80104ea4:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104ea5:	e8 46 ea ff ff       	call   801038f0 <myproc>
80104eaa:	89 c6                	mov    %eax,%esi

  num = curproc->tf->eax;
80104eac:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104eb2:	8b 58 1c             	mov    0x1c(%eax),%ebx
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104eb5:	8d 43 ff             	lea    -0x1(%ebx),%eax
80104eb8:	83 f8 1b             	cmp    $0x1b,%eax
80104ebb:	77 2b                	ja     80104ee8 <syscall+0x48>
80104ebd:	8b 04 9d 60 7d 10 80 	mov    -0x7fef82a0(,%ebx,4),%eax
80104ec4:	85 c0                	test   %eax,%eax
80104ec6:	74 20                	je     80104ee8 <syscall+0x48>
    curproc->tf->eax = syscalls[num]();
80104ec8:	ff d0                	call   *%eax
80104eca:	8b 96 a4 00 00 00    	mov    0xa4(%esi),%edx
80104ed0:	89 42 1c             	mov    %eax,0x1c(%edx)
    myproc()->hit[num]++;
80104ed3:	e8 18 ea ff ff       	call   801038f0 <myproc>
80104ed8:	83 44 98 20 01       	addl   $0x1,0x20(%eax,%ebx,4)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104edd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ee0:	5b                   	pop    %ebx
80104ee1:	5e                   	pop    %esi
80104ee2:	5d                   	pop    %ebp
80104ee3:	c3                   	ret    
80104ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            curproc->pid, curproc->name, num);
80104ee8:	8d 86 f8 00 00 00    	lea    0xf8(%esi),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104eee:	53                   	push   %ebx
80104eef:	50                   	push   %eax
80104ef0:	ff b6 9c 00 00 00    	pushl  0x9c(%esi)
80104ef6:	68 31 7d 10 80       	push   $0x80107d31
80104efb:	e8 60 b7 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104f00:	8b 86 a4 00 00 00    	mov    0xa4(%esi),%eax
80104f06:	83 c4 10             	add    $0x10,%esp
80104f09:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104f10:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f13:	5b                   	pop    %ebx
80104f14:	5e                   	pop    %esi
80104f15:	5d                   	pop    %ebp
80104f16:	c3                   	ret    
80104f17:	66 90                	xchg   %ax,%ax
80104f19:	66 90                	xchg   %ax,%ax
80104f1b:	66 90                	xchg   %ax,%ax
80104f1d:	66 90                	xchg   %ax,%ax
80104f1f:	90                   	nop

80104f20 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	57                   	push   %edi
80104f24:	56                   	push   %esi
80104f25:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104f26:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104f29:	83 ec 34             	sub    $0x34,%esp
80104f2c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104f2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104f32:	56                   	push   %esi
80104f33:	50                   	push   %eax
{
80104f34:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104f37:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104f3a:	e8 e1 cf ff ff       	call   80101f20 <nameiparent>
80104f3f:	83 c4 10             	add    $0x10,%esp
80104f42:	85 c0                	test   %eax,%eax
80104f44:	0f 84 46 01 00 00    	je     80105090 <create+0x170>
    return 0;
  ilock(dp);
80104f4a:	83 ec 0c             	sub    $0xc,%esp
80104f4d:	89 c3                	mov    %eax,%ebx
80104f4f:	50                   	push   %eax
80104f50:	e8 3b c7 ff ff       	call   80101690 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104f55:	83 c4 0c             	add    $0xc,%esp
80104f58:	6a 00                	push   $0x0
80104f5a:	56                   	push   %esi
80104f5b:	53                   	push   %ebx
80104f5c:	e8 5f cc ff ff       	call   80101bc0 <dirlookup>
80104f61:	83 c4 10             	add    $0x10,%esp
80104f64:	85 c0                	test   %eax,%eax
80104f66:	89 c7                	mov    %eax,%edi
80104f68:	74 36                	je     80104fa0 <create+0x80>
    iunlockput(dp);
80104f6a:	83 ec 0c             	sub    $0xc,%esp
80104f6d:	53                   	push   %ebx
80104f6e:	e8 ad c9 ff ff       	call   80101920 <iunlockput>
    ilock(ip);
80104f73:	89 3c 24             	mov    %edi,(%esp)
80104f76:	e8 15 c7 ff ff       	call   80101690 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104f7b:	83 c4 10             	add    $0x10,%esp
80104f7e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104f83:	0f 85 97 00 00 00    	jne    80105020 <create+0x100>
80104f89:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104f8e:	0f 85 8c 00 00 00    	jne    80105020 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104f94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f97:	89 f8                	mov    %edi,%eax
80104f99:	5b                   	pop    %ebx
80104f9a:	5e                   	pop    %esi
80104f9b:	5f                   	pop    %edi
80104f9c:	5d                   	pop    %ebp
80104f9d:	c3                   	ret    
80104f9e:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80104fa0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104fa4:	83 ec 08             	sub    $0x8,%esp
80104fa7:	50                   	push   %eax
80104fa8:	ff 33                	pushl  (%ebx)
80104faa:	e8 71 c5 ff ff       	call   80101520 <ialloc>
80104faf:	83 c4 10             	add    $0x10,%esp
80104fb2:	85 c0                	test   %eax,%eax
80104fb4:	89 c7                	mov    %eax,%edi
80104fb6:	0f 84 e8 00 00 00    	je     801050a4 <create+0x184>
  ilock(ip);
80104fbc:	83 ec 0c             	sub    $0xc,%esp
80104fbf:	50                   	push   %eax
80104fc0:	e8 cb c6 ff ff       	call   80101690 <ilock>
  ip->major = major;
80104fc5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104fc9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104fcd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104fd1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104fd5:	b8 01 00 00 00       	mov    $0x1,%eax
80104fda:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104fde:	89 3c 24             	mov    %edi,(%esp)
80104fe1:	e8 fa c5 ff ff       	call   801015e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104fe6:	83 c4 10             	add    $0x10,%esp
80104fe9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104fee:	74 50                	je     80105040 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104ff0:	83 ec 04             	sub    $0x4,%esp
80104ff3:	ff 77 04             	pushl  0x4(%edi)
80104ff6:	56                   	push   %esi
80104ff7:	53                   	push   %ebx
80104ff8:	e8 43 ce ff ff       	call   80101e40 <dirlink>
80104ffd:	83 c4 10             	add    $0x10,%esp
80105000:	85 c0                	test   %eax,%eax
80105002:	0f 88 8f 00 00 00    	js     80105097 <create+0x177>
  iunlockput(dp);
80105008:	83 ec 0c             	sub    $0xc,%esp
8010500b:	53                   	push   %ebx
8010500c:	e8 0f c9 ff ff       	call   80101920 <iunlockput>
  return ip;
80105011:	83 c4 10             	add    $0x10,%esp
}
80105014:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105017:	89 f8                	mov    %edi,%eax
80105019:	5b                   	pop    %ebx
8010501a:	5e                   	pop    %esi
8010501b:	5f                   	pop    %edi
8010501c:	5d                   	pop    %ebp
8010501d:	c3                   	ret    
8010501e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105020:	83 ec 0c             	sub    $0xc,%esp
80105023:	57                   	push   %edi
    return 0;
80105024:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105026:	e8 f5 c8 ff ff       	call   80101920 <iunlockput>
    return 0;
8010502b:	83 c4 10             	add    $0x10,%esp
}
8010502e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105031:	89 f8                	mov    %edi,%eax
80105033:	5b                   	pop    %ebx
80105034:	5e                   	pop    %esi
80105035:	5f                   	pop    %edi
80105036:	5d                   	pop    %ebp
80105037:	c3                   	ret    
80105038:	90                   	nop
80105039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105040:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105045:	83 ec 0c             	sub    $0xc,%esp
80105048:	53                   	push   %ebx
80105049:	e8 92 c5 ff ff       	call   801015e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010504e:	83 c4 0c             	add    $0xc,%esp
80105051:	ff 77 04             	pushl  0x4(%edi)
80105054:	68 f0 7d 10 80       	push   $0x80107df0
80105059:	57                   	push   %edi
8010505a:	e8 e1 cd ff ff       	call   80101e40 <dirlink>
8010505f:	83 c4 10             	add    $0x10,%esp
80105062:	85 c0                	test   %eax,%eax
80105064:	78 1c                	js     80105082 <create+0x162>
80105066:	83 ec 04             	sub    $0x4,%esp
80105069:	ff 73 04             	pushl  0x4(%ebx)
8010506c:	68 ef 7d 10 80       	push   $0x80107def
80105071:	57                   	push   %edi
80105072:	e8 c9 cd ff ff       	call   80101e40 <dirlink>
80105077:	83 c4 10             	add    $0x10,%esp
8010507a:	85 c0                	test   %eax,%eax
8010507c:	0f 89 6e ff ff ff    	jns    80104ff0 <create+0xd0>
      panic("create dots");
80105082:	83 ec 0c             	sub    $0xc,%esp
80105085:	68 e3 7d 10 80       	push   $0x80107de3
8010508a:	e8 01 b3 ff ff       	call   80100390 <panic>
8010508f:	90                   	nop
    return 0;
80105090:	31 ff                	xor    %edi,%edi
80105092:	e9 fd fe ff ff       	jmp    80104f94 <create+0x74>
    panic("create: dirlink");
80105097:	83 ec 0c             	sub    $0xc,%esp
8010509a:	68 f2 7d 10 80       	push   $0x80107df2
8010509f:	e8 ec b2 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801050a4:	83 ec 0c             	sub    $0xc,%esp
801050a7:	68 d4 7d 10 80       	push   $0x80107dd4
801050ac:	e8 df b2 ff ff       	call   80100390 <panic>
801050b1:	eb 0d                	jmp    801050c0 <argfd.constprop.0>
801050b3:	90                   	nop
801050b4:	90                   	nop
801050b5:	90                   	nop
801050b6:	90                   	nop
801050b7:	90                   	nop
801050b8:	90                   	nop
801050b9:	90                   	nop
801050ba:	90                   	nop
801050bb:	90                   	nop
801050bc:	90                   	nop
801050bd:	90                   	nop
801050be:	90                   	nop
801050bf:	90                   	nop

801050c0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	56                   	push   %esi
801050c4:	53                   	push   %ebx
801050c5:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
801050c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801050ca:	89 d6                	mov    %edx,%esi
801050cc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050cf:	50                   	push   %eax
801050d0:	6a 00                	push   $0x0
801050d2:	e8 d9 fc ff ff       	call   80104db0 <argint>
801050d7:	83 c4 10             	add    $0x10,%esp
801050da:	85 c0                	test   %eax,%eax
801050dc:	78 32                	js     80105110 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050de:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050e2:	77 2c                	ja     80105110 <argfd.constprop.0+0x50>
801050e4:	e8 07 e8 ff ff       	call   801038f0 <myproc>
801050e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050ec:	8b 84 90 b4 00 00 00 	mov    0xb4(%eax,%edx,4),%eax
801050f3:	85 c0                	test   %eax,%eax
801050f5:	74 19                	je     80105110 <argfd.constprop.0+0x50>
  if(pfd)
801050f7:	85 db                	test   %ebx,%ebx
801050f9:	74 02                	je     801050fd <argfd.constprop.0+0x3d>
    *pfd = fd;
801050fb:	89 13                	mov    %edx,(%ebx)
    *pf = f;
801050fd:	89 06                	mov    %eax,(%esi)
  return 0;
801050ff:	31 c0                	xor    %eax,%eax
}
80105101:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105104:	5b                   	pop    %ebx
80105105:	5e                   	pop    %esi
80105106:	5d                   	pop    %ebp
80105107:	c3                   	ret    
80105108:	90                   	nop
80105109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105110:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105115:	eb ea                	jmp    80105101 <argfd.constprop.0+0x41>
80105117:	89 f6                	mov    %esi,%esi
80105119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105120 <sys_dup>:
{
80105120:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105121:	31 c0                	xor    %eax,%eax
{
80105123:	89 e5                	mov    %esp,%ebp
80105125:	56                   	push   %esi
80105126:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105127:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010512a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010512d:	e8 8e ff ff ff       	call   801050c0 <argfd.constprop.0>
80105132:	85 c0                	test   %eax,%eax
80105134:	78 4a                	js     80105180 <sys_dup+0x60>
  if((fd=fdalloc(f)) < 0)
80105136:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105139:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010513b:	e8 b0 e7 ff ff       	call   801038f0 <myproc>
80105140:	eb 0e                	jmp    80105150 <sys_dup+0x30>
80105142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105148:	83 c3 01             	add    $0x1,%ebx
8010514b:	83 fb 10             	cmp    $0x10,%ebx
8010514e:	74 30                	je     80105180 <sys_dup+0x60>
    if(curproc->ofile[fd] == 0){
80105150:	8b 94 98 b4 00 00 00 	mov    0xb4(%eax,%ebx,4),%edx
80105157:	85 d2                	test   %edx,%edx
80105159:	75 ed                	jne    80105148 <sys_dup+0x28>
      curproc->ofile[fd] = f;
8010515b:	89 b4 98 b4 00 00 00 	mov    %esi,0xb4(%eax,%ebx,4)
  filedup(f);
80105162:	83 ec 0c             	sub    $0xc,%esp
80105165:	ff 75 f4             	pushl  -0xc(%ebp)
80105168:	e8 93 bc ff ff       	call   80100e00 <filedup>
  return fd;
8010516d:	83 c4 10             	add    $0x10,%esp
}
80105170:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105173:	89 d8                	mov    %ebx,%eax
80105175:	5b                   	pop    %ebx
80105176:	5e                   	pop    %esi
80105177:	5d                   	pop    %ebp
80105178:	c3                   	ret    
80105179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105180:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105183:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105188:	89 d8                	mov    %ebx,%eax
8010518a:	5b                   	pop    %ebx
8010518b:	5e                   	pop    %esi
8010518c:	5d                   	pop    %ebp
8010518d:	c3                   	ret    
8010518e:	66 90                	xchg   %ax,%ax

80105190 <sys_read>:
{
80105190:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105191:	31 c0                	xor    %eax,%eax
{
80105193:	89 e5                	mov    %esp,%ebp
80105195:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105198:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010519b:	e8 20 ff ff ff       	call   801050c0 <argfd.constprop.0>
801051a0:	85 c0                	test   %eax,%eax
801051a2:	78 4c                	js     801051f0 <sys_read+0x60>
801051a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051a7:	83 ec 08             	sub    $0x8,%esp
801051aa:	50                   	push   %eax
801051ab:	6a 02                	push   $0x2
801051ad:	e8 fe fb ff ff       	call   80104db0 <argint>
801051b2:	83 c4 10             	add    $0x10,%esp
801051b5:	85 c0                	test   %eax,%eax
801051b7:	78 37                	js     801051f0 <sys_read+0x60>
801051b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051bc:	83 ec 04             	sub    $0x4,%esp
801051bf:	ff 75 f0             	pushl  -0x10(%ebp)
801051c2:	50                   	push   %eax
801051c3:	6a 01                	push   $0x1
801051c5:	e8 36 fc ff ff       	call   80104e00 <argptr>
801051ca:	83 c4 10             	add    $0x10,%esp
801051cd:	85 c0                	test   %eax,%eax
801051cf:	78 1f                	js     801051f0 <sys_read+0x60>
  return fileread(f, p, n);
801051d1:	83 ec 04             	sub    $0x4,%esp
801051d4:	ff 75 f0             	pushl  -0x10(%ebp)
801051d7:	ff 75 f4             	pushl  -0xc(%ebp)
801051da:	ff 75 ec             	pushl  -0x14(%ebp)
801051dd:	e8 8e bd ff ff       	call   80100f70 <fileread>
801051e2:	83 c4 10             	add    $0x10,%esp
}
801051e5:	c9                   	leave  
801051e6:	c3                   	ret    
801051e7:	89 f6                	mov    %esi,%esi
801051e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801051f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051f5:	c9                   	leave  
801051f6:	c3                   	ret    
801051f7:	89 f6                	mov    %esi,%esi
801051f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105200 <sys_write>:
{
80105200:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105201:	31 c0                	xor    %eax,%eax
{
80105203:	89 e5                	mov    %esp,%ebp
80105205:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105208:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010520b:	e8 b0 fe ff ff       	call   801050c0 <argfd.constprop.0>
80105210:	85 c0                	test   %eax,%eax
80105212:	78 4c                	js     80105260 <sys_write+0x60>
80105214:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105217:	83 ec 08             	sub    $0x8,%esp
8010521a:	50                   	push   %eax
8010521b:	6a 02                	push   $0x2
8010521d:	e8 8e fb ff ff       	call   80104db0 <argint>
80105222:	83 c4 10             	add    $0x10,%esp
80105225:	85 c0                	test   %eax,%eax
80105227:	78 37                	js     80105260 <sys_write+0x60>
80105229:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010522c:	83 ec 04             	sub    $0x4,%esp
8010522f:	ff 75 f0             	pushl  -0x10(%ebp)
80105232:	50                   	push   %eax
80105233:	6a 01                	push   $0x1
80105235:	e8 c6 fb ff ff       	call   80104e00 <argptr>
8010523a:	83 c4 10             	add    $0x10,%esp
8010523d:	85 c0                	test   %eax,%eax
8010523f:	78 1f                	js     80105260 <sys_write+0x60>
  return filewrite(f, p, n);
80105241:	83 ec 04             	sub    $0x4,%esp
80105244:	ff 75 f0             	pushl  -0x10(%ebp)
80105247:	ff 75 f4             	pushl  -0xc(%ebp)
8010524a:	ff 75 ec             	pushl  -0x14(%ebp)
8010524d:	e8 ae bd ff ff       	call   80101000 <filewrite>
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

80105270 <sys_close>:
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105276:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105279:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010527c:	e8 3f fe ff ff       	call   801050c0 <argfd.constprop.0>
80105281:	85 c0                	test   %eax,%eax
80105283:	78 2b                	js     801052b0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105285:	e8 66 e6 ff ff       	call   801038f0 <myproc>
8010528a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010528d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105290:	c7 84 90 b4 00 00 00 	movl   $0x0,0xb4(%eax,%edx,4)
80105297:	00 00 00 00 
  fileclose(f);
8010529b:	ff 75 f4             	pushl  -0xc(%ebp)
8010529e:	e8 ad bb ff ff       	call   80100e50 <fileclose>
  return 0;
801052a3:	83 c4 10             	add    $0x10,%esp
801052a6:	31 c0                	xor    %eax,%eax
}
801052a8:	c9                   	leave  
801052a9:	c3                   	ret    
801052aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801052b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052b5:	c9                   	leave  
801052b6:	c3                   	ret    
801052b7:	89 f6                	mov    %esi,%esi
801052b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052c0 <sys_fstat>:
{
801052c0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801052c1:	31 c0                	xor    %eax,%eax
{
801052c3:	89 e5                	mov    %esp,%ebp
801052c5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801052c8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801052cb:	e8 f0 fd ff ff       	call   801050c0 <argfd.constprop.0>
801052d0:	85 c0                	test   %eax,%eax
801052d2:	78 2c                	js     80105300 <sys_fstat+0x40>
801052d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052d7:	83 ec 04             	sub    $0x4,%esp
801052da:	6a 14                	push   $0x14
801052dc:	50                   	push   %eax
801052dd:	6a 01                	push   $0x1
801052df:	e8 1c fb ff ff       	call   80104e00 <argptr>
801052e4:	83 c4 10             	add    $0x10,%esp
801052e7:	85 c0                	test   %eax,%eax
801052e9:	78 15                	js     80105300 <sys_fstat+0x40>
  return filestat(f, st);
801052eb:	83 ec 08             	sub    $0x8,%esp
801052ee:	ff 75 f4             	pushl  -0xc(%ebp)
801052f1:	ff 75 f0             	pushl  -0x10(%ebp)
801052f4:	e8 27 bc ff ff       	call   80100f20 <filestat>
801052f9:	83 c4 10             	add    $0x10,%esp
}
801052fc:	c9                   	leave  
801052fd:	c3                   	ret    
801052fe:	66 90                	xchg   %ax,%ax
    return -1;
80105300:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105305:	c9                   	leave  
80105306:	c3                   	ret    
80105307:	89 f6                	mov    %esi,%esi
80105309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105310 <sys_link>:
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	57                   	push   %edi
80105314:	56                   	push   %esi
80105315:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105316:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105319:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010531c:	50                   	push   %eax
8010531d:	6a 00                	push   $0x0
8010531f:	e8 3c fb ff ff       	call   80104e60 <argstr>
80105324:	83 c4 10             	add    $0x10,%esp
80105327:	85 c0                	test   %eax,%eax
80105329:	0f 88 fb 00 00 00    	js     8010542a <sys_link+0x11a>
8010532f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105332:	83 ec 08             	sub    $0x8,%esp
80105335:	50                   	push   %eax
80105336:	6a 01                	push   $0x1
80105338:	e8 23 fb ff ff       	call   80104e60 <argstr>
8010533d:	83 c4 10             	add    $0x10,%esp
80105340:	85 c0                	test   %eax,%eax
80105342:	0f 88 e2 00 00 00    	js     8010542a <sys_link+0x11a>
  begin_op();
80105348:	e8 73 d8 ff ff       	call   80102bc0 <begin_op>
  if((ip = namei(old)) == 0){
8010534d:	83 ec 0c             	sub    $0xc,%esp
80105350:	ff 75 d4             	pushl  -0x2c(%ebp)
80105353:	e8 a8 cb ff ff       	call   80101f00 <namei>
80105358:	83 c4 10             	add    $0x10,%esp
8010535b:	85 c0                	test   %eax,%eax
8010535d:	89 c3                	mov    %eax,%ebx
8010535f:	0f 84 ea 00 00 00    	je     8010544f <sys_link+0x13f>
  ilock(ip);
80105365:	83 ec 0c             	sub    $0xc,%esp
80105368:	50                   	push   %eax
80105369:	e8 22 c3 ff ff       	call   80101690 <ilock>
  if(ip->type == T_DIR){
8010536e:	83 c4 10             	add    $0x10,%esp
80105371:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105376:	0f 84 bb 00 00 00    	je     80105437 <sys_link+0x127>
  ip->nlink++;
8010537c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105381:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105384:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105387:	53                   	push   %ebx
80105388:	e8 53 c2 ff ff       	call   801015e0 <iupdate>
  iunlock(ip);
8010538d:	89 1c 24             	mov    %ebx,(%esp)
80105390:	e8 db c3 ff ff       	call   80101770 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105395:	58                   	pop    %eax
80105396:	5a                   	pop    %edx
80105397:	57                   	push   %edi
80105398:	ff 75 d0             	pushl  -0x30(%ebp)
8010539b:	e8 80 cb ff ff       	call   80101f20 <nameiparent>
801053a0:	83 c4 10             	add    $0x10,%esp
801053a3:	85 c0                	test   %eax,%eax
801053a5:	89 c6                	mov    %eax,%esi
801053a7:	74 5b                	je     80105404 <sys_link+0xf4>
  ilock(dp);
801053a9:	83 ec 0c             	sub    $0xc,%esp
801053ac:	50                   	push   %eax
801053ad:	e8 de c2 ff ff       	call   80101690 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801053b2:	83 c4 10             	add    $0x10,%esp
801053b5:	8b 03                	mov    (%ebx),%eax
801053b7:	39 06                	cmp    %eax,(%esi)
801053b9:	75 3d                	jne    801053f8 <sys_link+0xe8>
801053bb:	83 ec 04             	sub    $0x4,%esp
801053be:	ff 73 04             	pushl  0x4(%ebx)
801053c1:	57                   	push   %edi
801053c2:	56                   	push   %esi
801053c3:	e8 78 ca ff ff       	call   80101e40 <dirlink>
801053c8:	83 c4 10             	add    $0x10,%esp
801053cb:	85 c0                	test   %eax,%eax
801053cd:	78 29                	js     801053f8 <sys_link+0xe8>
  iunlockput(dp);
801053cf:	83 ec 0c             	sub    $0xc,%esp
801053d2:	56                   	push   %esi
801053d3:	e8 48 c5 ff ff       	call   80101920 <iunlockput>
  iput(ip);
801053d8:	89 1c 24             	mov    %ebx,(%esp)
801053db:	e8 e0 c3 ff ff       	call   801017c0 <iput>
  end_op();
801053e0:	e8 4b d8 ff ff       	call   80102c30 <end_op>
  return 0;
801053e5:	83 c4 10             	add    $0x10,%esp
801053e8:	31 c0                	xor    %eax,%eax
}
801053ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053ed:	5b                   	pop    %ebx
801053ee:	5e                   	pop    %esi
801053ef:	5f                   	pop    %edi
801053f0:	5d                   	pop    %ebp
801053f1:	c3                   	ret    
801053f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801053f8:	83 ec 0c             	sub    $0xc,%esp
801053fb:	56                   	push   %esi
801053fc:	e8 1f c5 ff ff       	call   80101920 <iunlockput>
    goto bad;
80105401:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105404:	83 ec 0c             	sub    $0xc,%esp
80105407:	53                   	push   %ebx
80105408:	e8 83 c2 ff ff       	call   80101690 <ilock>
  ip->nlink--;
8010540d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105412:	89 1c 24             	mov    %ebx,(%esp)
80105415:	e8 c6 c1 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
8010541a:	89 1c 24             	mov    %ebx,(%esp)
8010541d:	e8 fe c4 ff ff       	call   80101920 <iunlockput>
  end_op();
80105422:	e8 09 d8 ff ff       	call   80102c30 <end_op>
  return -1;
80105427:	83 c4 10             	add    $0x10,%esp
}
8010542a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010542d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105432:	5b                   	pop    %ebx
80105433:	5e                   	pop    %esi
80105434:	5f                   	pop    %edi
80105435:	5d                   	pop    %ebp
80105436:	c3                   	ret    
    iunlockput(ip);
80105437:	83 ec 0c             	sub    $0xc,%esp
8010543a:	53                   	push   %ebx
8010543b:	e8 e0 c4 ff ff       	call   80101920 <iunlockput>
    end_op();
80105440:	e8 eb d7 ff ff       	call   80102c30 <end_op>
    return -1;
80105445:	83 c4 10             	add    $0x10,%esp
80105448:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010544d:	eb 9b                	jmp    801053ea <sys_link+0xda>
    end_op();
8010544f:	e8 dc d7 ff ff       	call   80102c30 <end_op>
    return -1;
80105454:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105459:	eb 8f                	jmp    801053ea <sys_link+0xda>
8010545b:	90                   	nop
8010545c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105460 <sys_unlink>:
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	57                   	push   %edi
80105464:	56                   	push   %esi
80105465:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105466:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105469:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010546c:	50                   	push   %eax
8010546d:	6a 00                	push   $0x0
8010546f:	e8 ec f9 ff ff       	call   80104e60 <argstr>
80105474:	83 c4 10             	add    $0x10,%esp
80105477:	85 c0                	test   %eax,%eax
80105479:	0f 88 77 01 00 00    	js     801055f6 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010547f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105482:	e8 39 d7 ff ff       	call   80102bc0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105487:	83 ec 08             	sub    $0x8,%esp
8010548a:	53                   	push   %ebx
8010548b:	ff 75 c0             	pushl  -0x40(%ebp)
8010548e:	e8 8d ca ff ff       	call   80101f20 <nameiparent>
80105493:	83 c4 10             	add    $0x10,%esp
80105496:	85 c0                	test   %eax,%eax
80105498:	89 c6                	mov    %eax,%esi
8010549a:	0f 84 60 01 00 00    	je     80105600 <sys_unlink+0x1a0>
  ilock(dp);
801054a0:	83 ec 0c             	sub    $0xc,%esp
801054a3:	50                   	push   %eax
801054a4:	e8 e7 c1 ff ff       	call   80101690 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801054a9:	58                   	pop    %eax
801054aa:	5a                   	pop    %edx
801054ab:	68 f0 7d 10 80       	push   $0x80107df0
801054b0:	53                   	push   %ebx
801054b1:	e8 ea c6 ff ff       	call   80101ba0 <namecmp>
801054b6:	83 c4 10             	add    $0x10,%esp
801054b9:	85 c0                	test   %eax,%eax
801054bb:	0f 84 03 01 00 00    	je     801055c4 <sys_unlink+0x164>
801054c1:	83 ec 08             	sub    $0x8,%esp
801054c4:	68 ef 7d 10 80       	push   $0x80107def
801054c9:	53                   	push   %ebx
801054ca:	e8 d1 c6 ff ff       	call   80101ba0 <namecmp>
801054cf:	83 c4 10             	add    $0x10,%esp
801054d2:	85 c0                	test   %eax,%eax
801054d4:	0f 84 ea 00 00 00    	je     801055c4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
801054da:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801054dd:	83 ec 04             	sub    $0x4,%esp
801054e0:	50                   	push   %eax
801054e1:	53                   	push   %ebx
801054e2:	56                   	push   %esi
801054e3:	e8 d8 c6 ff ff       	call   80101bc0 <dirlookup>
801054e8:	83 c4 10             	add    $0x10,%esp
801054eb:	85 c0                	test   %eax,%eax
801054ed:	89 c3                	mov    %eax,%ebx
801054ef:	0f 84 cf 00 00 00    	je     801055c4 <sys_unlink+0x164>
  ilock(ip);
801054f5:	83 ec 0c             	sub    $0xc,%esp
801054f8:	50                   	push   %eax
801054f9:	e8 92 c1 ff ff       	call   80101690 <ilock>
  if(ip->nlink < 1)
801054fe:	83 c4 10             	add    $0x10,%esp
80105501:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105506:	0f 8e 10 01 00 00    	jle    8010561c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010550c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105511:	74 6d                	je     80105580 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105513:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105516:	83 ec 04             	sub    $0x4,%esp
80105519:	6a 10                	push   $0x10
8010551b:	6a 00                	push   $0x0
8010551d:	50                   	push   %eax
8010551e:	e8 8d f5 ff ff       	call   80104ab0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105523:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105526:	6a 10                	push   $0x10
80105528:	ff 75 c4             	pushl  -0x3c(%ebp)
8010552b:	50                   	push   %eax
8010552c:	56                   	push   %esi
8010552d:	e8 3e c5 ff ff       	call   80101a70 <writei>
80105532:	83 c4 20             	add    $0x20,%esp
80105535:	83 f8 10             	cmp    $0x10,%eax
80105538:	0f 85 eb 00 00 00    	jne    80105629 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010553e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105543:	0f 84 97 00 00 00    	je     801055e0 <sys_unlink+0x180>
  iunlockput(dp);
80105549:	83 ec 0c             	sub    $0xc,%esp
8010554c:	56                   	push   %esi
8010554d:	e8 ce c3 ff ff       	call   80101920 <iunlockput>
  ip->nlink--;
80105552:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105557:	89 1c 24             	mov    %ebx,(%esp)
8010555a:	e8 81 c0 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
8010555f:	89 1c 24             	mov    %ebx,(%esp)
80105562:	e8 b9 c3 ff ff       	call   80101920 <iunlockput>
  end_op();
80105567:	e8 c4 d6 ff ff       	call   80102c30 <end_op>
  return 0;
8010556c:	83 c4 10             	add    $0x10,%esp
8010556f:	31 c0                	xor    %eax,%eax
}
80105571:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105574:	5b                   	pop    %ebx
80105575:	5e                   	pop    %esi
80105576:	5f                   	pop    %edi
80105577:	5d                   	pop    %ebp
80105578:	c3                   	ret    
80105579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105580:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105584:	76 8d                	jbe    80105513 <sys_unlink+0xb3>
80105586:	bf 20 00 00 00       	mov    $0x20,%edi
8010558b:	eb 0f                	jmp    8010559c <sys_unlink+0x13c>
8010558d:	8d 76 00             	lea    0x0(%esi),%esi
80105590:	83 c7 10             	add    $0x10,%edi
80105593:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105596:	0f 83 77 ff ff ff    	jae    80105513 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010559c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010559f:	6a 10                	push   $0x10
801055a1:	57                   	push   %edi
801055a2:	50                   	push   %eax
801055a3:	53                   	push   %ebx
801055a4:	e8 c7 c3 ff ff       	call   80101970 <readi>
801055a9:	83 c4 10             	add    $0x10,%esp
801055ac:	83 f8 10             	cmp    $0x10,%eax
801055af:	75 5e                	jne    8010560f <sys_unlink+0x1af>
    if(de.inum != 0)
801055b1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801055b6:	74 d8                	je     80105590 <sys_unlink+0x130>
    iunlockput(ip);
801055b8:	83 ec 0c             	sub    $0xc,%esp
801055bb:	53                   	push   %ebx
801055bc:	e8 5f c3 ff ff       	call   80101920 <iunlockput>
    goto bad;
801055c1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801055c4:	83 ec 0c             	sub    $0xc,%esp
801055c7:	56                   	push   %esi
801055c8:	e8 53 c3 ff ff       	call   80101920 <iunlockput>
  end_op();
801055cd:	e8 5e d6 ff ff       	call   80102c30 <end_op>
  return -1;
801055d2:	83 c4 10             	add    $0x10,%esp
801055d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055da:	eb 95                	jmp    80105571 <sys_unlink+0x111>
801055dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
801055e0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801055e5:	83 ec 0c             	sub    $0xc,%esp
801055e8:	56                   	push   %esi
801055e9:	e8 f2 bf ff ff       	call   801015e0 <iupdate>
801055ee:	83 c4 10             	add    $0x10,%esp
801055f1:	e9 53 ff ff ff       	jmp    80105549 <sys_unlink+0xe9>
    return -1;
801055f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055fb:	e9 71 ff ff ff       	jmp    80105571 <sys_unlink+0x111>
    end_op();
80105600:	e8 2b d6 ff ff       	call   80102c30 <end_op>
    return -1;
80105605:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010560a:	e9 62 ff ff ff       	jmp    80105571 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010560f:	83 ec 0c             	sub    $0xc,%esp
80105612:	68 14 7e 10 80       	push   $0x80107e14
80105617:	e8 74 ad ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010561c:	83 ec 0c             	sub    $0xc,%esp
8010561f:	68 02 7e 10 80       	push   $0x80107e02
80105624:	e8 67 ad ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105629:	83 ec 0c             	sub    $0xc,%esp
8010562c:	68 26 7e 10 80       	push   $0x80107e26
80105631:	e8 5a ad ff ff       	call   80100390 <panic>
80105636:	8d 76 00             	lea    0x0(%esi),%esi
80105639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105640 <sys_open>:

int
sys_open(void)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	57                   	push   %edi
80105644:	56                   	push   %esi
80105645:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105646:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105649:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010564c:	50                   	push   %eax
8010564d:	6a 00                	push   $0x0
8010564f:	e8 0c f8 ff ff       	call   80104e60 <argstr>
80105654:	83 c4 10             	add    $0x10,%esp
80105657:	85 c0                	test   %eax,%eax
80105659:	0f 88 1d 01 00 00    	js     8010577c <sys_open+0x13c>
8010565f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105662:	83 ec 08             	sub    $0x8,%esp
80105665:	50                   	push   %eax
80105666:	6a 01                	push   $0x1
80105668:	e8 43 f7 ff ff       	call   80104db0 <argint>
8010566d:	83 c4 10             	add    $0x10,%esp
80105670:	85 c0                	test   %eax,%eax
80105672:	0f 88 04 01 00 00    	js     8010577c <sys_open+0x13c>
    return -1;

  begin_op();
80105678:	e8 43 d5 ff ff       	call   80102bc0 <begin_op>

  if(omode & O_CREATE){
8010567d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105681:	0f 85 a9 00 00 00    	jne    80105730 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105687:	83 ec 0c             	sub    $0xc,%esp
8010568a:	ff 75 e0             	pushl  -0x20(%ebp)
8010568d:	e8 6e c8 ff ff       	call   80101f00 <namei>
80105692:	83 c4 10             	add    $0x10,%esp
80105695:	85 c0                	test   %eax,%eax
80105697:	89 c6                	mov    %eax,%esi
80105699:	0f 84 b2 00 00 00    	je     80105751 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010569f:	83 ec 0c             	sub    $0xc,%esp
801056a2:	50                   	push   %eax
801056a3:	e8 e8 bf ff ff       	call   80101690 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801056a8:	83 c4 10             	add    $0x10,%esp
801056ab:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801056b0:	0f 84 aa 00 00 00    	je     80105760 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801056b6:	e8 d5 b6 ff ff       	call   80100d90 <filealloc>
801056bb:	85 c0                	test   %eax,%eax
801056bd:	89 c7                	mov    %eax,%edi
801056bf:	0f 84 a6 00 00 00    	je     8010576b <sys_open+0x12b>
  struct proc *curproc = myproc();
801056c5:	e8 26 e2 ff ff       	call   801038f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801056ca:	31 db                	xor    %ebx,%ebx
801056cc:	eb 0e                	jmp    801056dc <sys_open+0x9c>
801056ce:	66 90                	xchg   %ax,%ax
801056d0:	83 c3 01             	add    $0x1,%ebx
801056d3:	83 fb 10             	cmp    $0x10,%ebx
801056d6:	0f 84 ac 00 00 00    	je     80105788 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801056dc:	8b 94 98 b4 00 00 00 	mov    0xb4(%eax,%ebx,4),%edx
801056e3:	85 d2                	test   %edx,%edx
801056e5:	75 e9                	jne    801056d0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801056e7:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801056ea:	89 bc 98 b4 00 00 00 	mov    %edi,0xb4(%eax,%ebx,4)
  iunlock(ip);
801056f1:	56                   	push   %esi
801056f2:	e8 79 c0 ff ff       	call   80101770 <iunlock>
  end_op();
801056f7:	e8 34 d5 ff ff       	call   80102c30 <end_op>

  f->type = FD_INODE;
801056fc:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105702:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105705:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105708:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
8010570b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105712:	89 d0                	mov    %edx,%eax
80105714:	f7 d0                	not    %eax
80105716:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105719:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010571c:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010571f:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105726:	89 d8                	mov    %ebx,%eax
80105728:	5b                   	pop    %ebx
80105729:	5e                   	pop    %esi
8010572a:	5f                   	pop    %edi
8010572b:	5d                   	pop    %ebp
8010572c:	c3                   	ret    
8010572d:	8d 76 00             	lea    0x0(%esi),%esi
    ip = create(path, T_FILE, 0, 0);
80105730:	83 ec 0c             	sub    $0xc,%esp
80105733:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105736:	31 c9                	xor    %ecx,%ecx
80105738:	6a 00                	push   $0x0
8010573a:	ba 02 00 00 00       	mov    $0x2,%edx
8010573f:	e8 dc f7 ff ff       	call   80104f20 <create>
    if(ip == 0){
80105744:	83 c4 10             	add    $0x10,%esp
80105747:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105749:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010574b:	0f 85 65 ff ff ff    	jne    801056b6 <sys_open+0x76>
      end_op();
80105751:	e8 da d4 ff ff       	call   80102c30 <end_op>
      return -1;
80105756:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010575b:	eb c6                	jmp    80105723 <sys_open+0xe3>
8010575d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105760:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105763:	85 c9                	test   %ecx,%ecx
80105765:	0f 84 4b ff ff ff    	je     801056b6 <sys_open+0x76>
    iunlockput(ip);
8010576b:	83 ec 0c             	sub    $0xc,%esp
8010576e:	56                   	push   %esi
8010576f:	e8 ac c1 ff ff       	call   80101920 <iunlockput>
    end_op();
80105774:	e8 b7 d4 ff ff       	call   80102c30 <end_op>
    return -1;
80105779:	83 c4 10             	add    $0x10,%esp
8010577c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105781:	eb a0                	jmp    80105723 <sys_open+0xe3>
80105783:	90                   	nop
80105784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105788:	83 ec 0c             	sub    $0xc,%esp
8010578b:	57                   	push   %edi
8010578c:	e8 bf b6 ff ff       	call   80100e50 <fileclose>
80105791:	83 c4 10             	add    $0x10,%esp
80105794:	eb d5                	jmp    8010576b <sys_open+0x12b>
80105796:	8d 76 00             	lea    0x0(%esi),%esi
80105799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057a0 <sys_mkdir>:

int
sys_mkdir(void)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801057a6:	e8 15 d4 ff ff       	call   80102bc0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801057ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057ae:	83 ec 08             	sub    $0x8,%esp
801057b1:	50                   	push   %eax
801057b2:	6a 00                	push   $0x0
801057b4:	e8 a7 f6 ff ff       	call   80104e60 <argstr>
801057b9:	83 c4 10             	add    $0x10,%esp
801057bc:	85 c0                	test   %eax,%eax
801057be:	78 30                	js     801057f0 <sys_mkdir+0x50>
801057c0:	83 ec 0c             	sub    $0xc,%esp
801057c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057c6:	31 c9                	xor    %ecx,%ecx
801057c8:	6a 00                	push   $0x0
801057ca:	ba 01 00 00 00       	mov    $0x1,%edx
801057cf:	e8 4c f7 ff ff       	call   80104f20 <create>
801057d4:	83 c4 10             	add    $0x10,%esp
801057d7:	85 c0                	test   %eax,%eax
801057d9:	74 15                	je     801057f0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801057db:	83 ec 0c             	sub    $0xc,%esp
801057de:	50                   	push   %eax
801057df:	e8 3c c1 ff ff       	call   80101920 <iunlockput>
  end_op();
801057e4:	e8 47 d4 ff ff       	call   80102c30 <end_op>
  return 0;
801057e9:	83 c4 10             	add    $0x10,%esp
801057ec:	31 c0                	xor    %eax,%eax
}
801057ee:	c9                   	leave  
801057ef:	c3                   	ret    
    end_op();
801057f0:	e8 3b d4 ff ff       	call   80102c30 <end_op>
    return -1;
801057f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057fa:	c9                   	leave  
801057fb:	c3                   	ret    
801057fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105800 <sys_mknod>:

int
sys_mknod(void)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105806:	e8 b5 d3 ff ff       	call   80102bc0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010580b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010580e:	83 ec 08             	sub    $0x8,%esp
80105811:	50                   	push   %eax
80105812:	6a 00                	push   $0x0
80105814:	e8 47 f6 ff ff       	call   80104e60 <argstr>
80105819:	83 c4 10             	add    $0x10,%esp
8010581c:	85 c0                	test   %eax,%eax
8010581e:	78 60                	js     80105880 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105820:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105823:	83 ec 08             	sub    $0x8,%esp
80105826:	50                   	push   %eax
80105827:	6a 01                	push   $0x1
80105829:	e8 82 f5 ff ff       	call   80104db0 <argint>
  if((argstr(0, &path)) < 0 ||
8010582e:	83 c4 10             	add    $0x10,%esp
80105831:	85 c0                	test   %eax,%eax
80105833:	78 4b                	js     80105880 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105835:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105838:	83 ec 08             	sub    $0x8,%esp
8010583b:	50                   	push   %eax
8010583c:	6a 02                	push   $0x2
8010583e:	e8 6d f5 ff ff       	call   80104db0 <argint>
     argint(1, &major) < 0 ||
80105843:	83 c4 10             	add    $0x10,%esp
80105846:	85 c0                	test   %eax,%eax
80105848:	78 36                	js     80105880 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010584a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010584e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105851:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105855:	ba 03 00 00 00       	mov    $0x3,%edx
8010585a:	50                   	push   %eax
8010585b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010585e:	e8 bd f6 ff ff       	call   80104f20 <create>
80105863:	83 c4 10             	add    $0x10,%esp
80105866:	85 c0                	test   %eax,%eax
80105868:	74 16                	je     80105880 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010586a:	83 ec 0c             	sub    $0xc,%esp
8010586d:	50                   	push   %eax
8010586e:	e8 ad c0 ff ff       	call   80101920 <iunlockput>
  end_op();
80105873:	e8 b8 d3 ff ff       	call   80102c30 <end_op>
  return 0;
80105878:	83 c4 10             	add    $0x10,%esp
8010587b:	31 c0                	xor    %eax,%eax
}
8010587d:	c9                   	leave  
8010587e:	c3                   	ret    
8010587f:	90                   	nop
    end_op();
80105880:	e8 ab d3 ff ff       	call   80102c30 <end_op>
    return -1;
80105885:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010588a:	c9                   	leave  
8010588b:	c3                   	ret    
8010588c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105890 <sys_chdir>:

int
sys_chdir(void)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	56                   	push   %esi
80105894:	53                   	push   %ebx
80105895:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105898:	e8 53 e0 ff ff       	call   801038f0 <myproc>
8010589d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010589f:	e8 1c d3 ff ff       	call   80102bc0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801058a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058a7:	83 ec 08             	sub    $0x8,%esp
801058aa:	50                   	push   %eax
801058ab:	6a 00                	push   $0x0
801058ad:	e8 ae f5 ff ff       	call   80104e60 <argstr>
801058b2:	83 c4 10             	add    $0x10,%esp
801058b5:	85 c0                	test   %eax,%eax
801058b7:	78 77                	js     80105930 <sys_chdir+0xa0>
801058b9:	83 ec 0c             	sub    $0xc,%esp
801058bc:	ff 75 f4             	pushl  -0xc(%ebp)
801058bf:	e8 3c c6 ff ff       	call   80101f00 <namei>
801058c4:	83 c4 10             	add    $0x10,%esp
801058c7:	85 c0                	test   %eax,%eax
801058c9:	89 c3                	mov    %eax,%ebx
801058cb:	74 63                	je     80105930 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801058cd:	83 ec 0c             	sub    $0xc,%esp
801058d0:	50                   	push   %eax
801058d1:	e8 ba bd ff ff       	call   80101690 <ilock>
  if(ip->type != T_DIR){
801058d6:	83 c4 10             	add    $0x10,%esp
801058d9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058de:	75 30                	jne    80105910 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801058e0:	83 ec 0c             	sub    $0xc,%esp
801058e3:	53                   	push   %ebx
801058e4:	e8 87 be ff ff       	call   80101770 <iunlock>
  iput(curproc->cwd);
801058e9:	58                   	pop    %eax
801058ea:	ff b6 f4 00 00 00    	pushl  0xf4(%esi)
801058f0:	e8 cb be ff ff       	call   801017c0 <iput>
  end_op();
801058f5:	e8 36 d3 ff ff       	call   80102c30 <end_op>
  curproc->cwd = ip;
801058fa:	89 9e f4 00 00 00    	mov    %ebx,0xf4(%esi)
  return 0;
80105900:	83 c4 10             	add    $0x10,%esp
80105903:	31 c0                	xor    %eax,%eax
}
80105905:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105908:	5b                   	pop    %ebx
80105909:	5e                   	pop    %esi
8010590a:	5d                   	pop    %ebp
8010590b:	c3                   	ret    
8010590c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80105910:	83 ec 0c             	sub    $0xc,%esp
80105913:	53                   	push   %ebx
80105914:	e8 07 c0 ff ff       	call   80101920 <iunlockput>
    end_op();
80105919:	e8 12 d3 ff ff       	call   80102c30 <end_op>
    return -1;
8010591e:	83 c4 10             	add    $0x10,%esp
80105921:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105926:	eb dd                	jmp    80105905 <sys_chdir+0x75>
80105928:	90                   	nop
80105929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105930:	e8 fb d2 ff ff       	call   80102c30 <end_op>
    return -1;
80105935:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010593a:	eb c9                	jmp    80105905 <sys_chdir+0x75>
8010593c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105940 <sys_exec>:

int
sys_exec(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	57                   	push   %edi
80105944:	56                   	push   %esi
80105945:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105946:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010594c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105952:	50                   	push   %eax
80105953:	6a 00                	push   $0x0
80105955:	e8 06 f5 ff ff       	call   80104e60 <argstr>
8010595a:	83 c4 10             	add    $0x10,%esp
8010595d:	85 c0                	test   %eax,%eax
8010595f:	0f 88 87 00 00 00    	js     801059ec <sys_exec+0xac>
80105965:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010596b:	83 ec 08             	sub    $0x8,%esp
8010596e:	50                   	push   %eax
8010596f:	6a 01                	push   $0x1
80105971:	e8 3a f4 ff ff       	call   80104db0 <argint>
80105976:	83 c4 10             	add    $0x10,%esp
80105979:	85 c0                	test   %eax,%eax
8010597b:	78 6f                	js     801059ec <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010597d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105983:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105986:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105988:	68 80 00 00 00       	push   $0x80
8010598d:	6a 00                	push   $0x0
8010598f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105995:	50                   	push   %eax
80105996:	e8 15 f1 ff ff       	call   80104ab0 <memset>
8010599b:	83 c4 10             	add    $0x10,%esp
8010599e:	eb 2c                	jmp    801059cc <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801059a0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801059a6:	85 c0                	test   %eax,%eax
801059a8:	74 56                	je     80105a00 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801059aa:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801059b0:	83 ec 08             	sub    $0x8,%esp
801059b3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801059b6:	52                   	push   %edx
801059b7:	50                   	push   %eax
801059b8:	e8 83 f3 ff ff       	call   80104d40 <fetchstr>
801059bd:	83 c4 10             	add    $0x10,%esp
801059c0:	85 c0                	test   %eax,%eax
801059c2:	78 28                	js     801059ec <sys_exec+0xac>
  for(i=0;; i++){
801059c4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801059c7:	83 fb 20             	cmp    $0x20,%ebx
801059ca:	74 20                	je     801059ec <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801059cc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801059d2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801059d9:	83 ec 08             	sub    $0x8,%esp
801059dc:	57                   	push   %edi
801059dd:	01 f0                	add    %esi,%eax
801059df:	50                   	push   %eax
801059e0:	e8 1b f3 ff ff       	call   80104d00 <fetchint>
801059e5:	83 c4 10             	add    $0x10,%esp
801059e8:	85 c0                	test   %eax,%eax
801059ea:	79 b4                	jns    801059a0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801059ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801059ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059f4:	5b                   	pop    %ebx
801059f5:	5e                   	pop    %esi
801059f6:	5f                   	pop    %edi
801059f7:	5d                   	pop    %ebp
801059f8:	c3                   	ret    
801059f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105a00:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105a06:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105a09:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105a10:	00 00 00 00 
  return exec(path, argv);
80105a14:	50                   	push   %eax
80105a15:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105a1b:	e8 f0 af ff ff       	call   80100a10 <exec>
80105a20:	83 c4 10             	add    $0x10,%esp
}
80105a23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a26:	5b                   	pop    %ebx
80105a27:	5e                   	pop    %esi
80105a28:	5f                   	pop    %edi
80105a29:	5d                   	pop    %ebp
80105a2a:	c3                   	ret    
80105a2b:	90                   	nop
80105a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a30 <sys_pipe>:

int
sys_pipe(void)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	57                   	push   %edi
80105a34:	56                   	push   %esi
80105a35:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105a36:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105a39:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105a3c:	6a 08                	push   $0x8
80105a3e:	50                   	push   %eax
80105a3f:	6a 00                	push   $0x0
80105a41:	e8 ba f3 ff ff       	call   80104e00 <argptr>
80105a46:	83 c4 10             	add    $0x10,%esp
80105a49:	85 c0                	test   %eax,%eax
80105a4b:	0f 88 b6 00 00 00    	js     80105b07 <sys_pipe+0xd7>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105a51:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a54:	83 ec 08             	sub    $0x8,%esp
80105a57:	50                   	push   %eax
80105a58:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105a5b:	50                   	push   %eax
80105a5c:	e8 ff d7 ff ff       	call   80103260 <pipealloc>
80105a61:	83 c4 10             	add    $0x10,%esp
80105a64:	85 c0                	test   %eax,%eax
80105a66:	0f 88 9b 00 00 00    	js     80105b07 <sys_pipe+0xd7>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a6c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105a6f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105a71:	e8 7a de ff ff       	call   801038f0 <myproc>
80105a76:	eb 10                	jmp    80105a88 <sys_pipe+0x58>
80105a78:	90                   	nop
80105a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105a80:	83 c3 01             	add    $0x1,%ebx
80105a83:	83 fb 10             	cmp    $0x10,%ebx
80105a86:	74 68                	je     80105af0 <sys_pipe+0xc0>
    if(curproc->ofile[fd] == 0){
80105a88:	8b b4 98 b4 00 00 00 	mov    0xb4(%eax,%ebx,4),%esi
80105a8f:	85 f6                	test   %esi,%esi
80105a91:	75 ed                	jne    80105a80 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105a93:	8d 73 2c             	lea    0x2c(%ebx),%esi
80105a96:	89 7c b0 04          	mov    %edi,0x4(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a9a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105a9d:	e8 4e de ff ff       	call   801038f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105aa2:	31 d2                	xor    %edx,%edx
80105aa4:	eb 12                	jmp    80105ab8 <sys_pipe+0x88>
80105aa6:	8d 76 00             	lea    0x0(%esi),%esi
80105aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105ab0:	83 c2 01             	add    $0x1,%edx
80105ab3:	83 fa 10             	cmp    $0x10,%edx
80105ab6:	74 28                	je     80105ae0 <sys_pipe+0xb0>
    if(curproc->ofile[fd] == 0){
80105ab8:	8b 8c 90 b4 00 00 00 	mov    0xb4(%eax,%edx,4),%ecx
80105abf:	85 c9                	test   %ecx,%ecx
80105ac1:	75 ed                	jne    80105ab0 <sys_pipe+0x80>
      curproc->ofile[fd] = f;
80105ac3:	89 bc 90 b4 00 00 00 	mov    %edi,0xb4(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105aca:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105acd:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105acf:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ad2:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105ad5:	31 c0                	xor    %eax,%eax
}
80105ad7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ada:	5b                   	pop    %ebx
80105adb:	5e                   	pop    %esi
80105adc:	5f                   	pop    %edi
80105add:	5d                   	pop    %ebp
80105ade:	c3                   	ret    
80105adf:	90                   	nop
      myproc()->ofile[fd0] = 0;
80105ae0:	e8 0b de ff ff       	call   801038f0 <myproc>
80105ae5:	c7 44 b0 04 00 00 00 	movl   $0x0,0x4(%eax,%esi,4)
80105aec:	00 
80105aed:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105af0:	83 ec 0c             	sub    $0xc,%esp
80105af3:	ff 75 e0             	pushl  -0x20(%ebp)
80105af6:	e8 55 b3 ff ff       	call   80100e50 <fileclose>
    fileclose(wf);
80105afb:	58                   	pop    %eax
80105afc:	ff 75 e4             	pushl  -0x1c(%ebp)
80105aff:	e8 4c b3 ff ff       	call   80100e50 <fileclose>
    return -1;
80105b04:	83 c4 10             	add    $0x10,%esp
80105b07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b0c:	eb c9                	jmp    80105ad7 <sys_pipe+0xa7>
80105b0e:	66 90                	xchg   %ax,%ax

80105b10 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105b13:	5d                   	pop    %ebp
  return fork();
80105b14:	e9 b7 df ff ff       	jmp    80103ad0 <fork>
80105b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b20 <sys_exit>:

int
sys_exit(void)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	83 ec 08             	sub    $0x8,%esp
  exit();
80105b26:	e8 65 e3 ff ff       	call   80103e90 <exit>
  return 0;  // not reached
}
80105b2b:	31 c0                	xor    %eax,%eax
80105b2d:	c9                   	leave  
80105b2e:	c3                   	ret    
80105b2f:	90                   	nop

80105b30 <sys_wait>:

int
sys_wait(void)
{
80105b30:	55                   	push   %ebp
80105b31:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105b33:	5d                   	pop    %ebp
  return wait();
80105b34:	e9 f7 e5 ff ff       	jmp    80104130 <wait>
80105b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b40 <sys_kill>:

int
sys_kill(void)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105b46:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b49:	50                   	push   %eax
80105b4a:	6a 00                	push   $0x0
80105b4c:	e8 5f f2 ff ff       	call   80104db0 <argint>
80105b51:	83 c4 10             	add    $0x10,%esp
80105b54:	85 c0                	test   %eax,%eax
80105b56:	78 18                	js     80105b70 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105b58:	83 ec 0c             	sub    $0xc,%esp
80105b5b:	ff 75 f4             	pushl  -0xc(%ebp)
80105b5e:	e8 5d e7 ff ff       	call   801042c0 <kill>
80105b63:	83 c4 10             	add    $0x10,%esp
}
80105b66:	c9                   	leave  
80105b67:	c3                   	ret    
80105b68:	90                   	nop
80105b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b75:	c9                   	leave  
80105b76:	c3                   	ret    
80105b77:	89 f6                	mov    %esi,%esi
80105b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b80 <sys_getpid>:

int
sys_getpid(void)
{
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105b86:	e8 65 dd ff ff       	call   801038f0 <myproc>
80105b8b:	8b 80 9c 00 00 00    	mov    0x9c(%eax),%eax
}
80105b91:	c9                   	leave  
80105b92:	c3                   	ret    
80105b93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ba0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ba0:	55                   	push   %ebp
80105ba1:	89 e5                	mov    %esp,%ebp
80105ba3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105ba4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ba7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105baa:	50                   	push   %eax
80105bab:	6a 00                	push   $0x0
80105bad:	e8 fe f1 ff ff       	call   80104db0 <argint>
80105bb2:	83 c4 10             	add    $0x10,%esp
80105bb5:	85 c0                	test   %eax,%eax
80105bb7:	78 27                	js     80105be0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105bb9:	e8 32 dd ff ff       	call   801038f0 <myproc>
  if(growproc(n) < 0)
80105bbe:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105bc1:	8b 98 8c 00 00 00    	mov    0x8c(%eax),%ebx
  if(growproc(n) < 0)
80105bc7:	ff 75 f4             	pushl  -0xc(%ebp)
80105bca:	e8 71 de ff ff       	call   80103a40 <growproc>
80105bcf:	83 c4 10             	add    $0x10,%esp
80105bd2:	85 c0                	test   %eax,%eax
80105bd4:	78 0a                	js     80105be0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105bd6:	89 d8                	mov    %ebx,%eax
80105bd8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bdb:	c9                   	leave  
80105bdc:	c3                   	ret    
80105bdd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105be0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105be5:	eb ef                	jmp    80105bd6 <sys_sbrk+0x36>
80105be7:	89 f6                	mov    %esi,%esi
80105be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105bf0 <sys_sleep>:

int
sys_sleep(void)
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105bf4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105bf7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105bfa:	50                   	push   %eax
80105bfb:	6a 00                	push   $0x0
80105bfd:	e8 ae f1 ff ff       	call   80104db0 <argint>
80105c02:	83 c4 10             	add    $0x10,%esp
80105c05:	85 c0                	test   %eax,%eax
80105c07:	0f 88 8a 00 00 00    	js     80105c97 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105c0d:	83 ec 0c             	sub    $0xc,%esp
80105c10:	68 60 7f 11 80       	push   $0x80117f60
80105c15:	e8 86 ed ff ff       	call   801049a0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105c1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c1d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105c20:	8b 1d a0 87 11 80    	mov    0x801187a0,%ebx
  while(ticks - ticks0 < n){
80105c26:	85 d2                	test   %edx,%edx
80105c28:	75 27                	jne    80105c51 <sys_sleep+0x61>
80105c2a:	eb 54                	jmp    80105c80 <sys_sleep+0x90>
80105c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105c30:	83 ec 08             	sub    $0x8,%esp
80105c33:	68 60 7f 11 80       	push   $0x80117f60
80105c38:	68 a0 87 11 80       	push   $0x801187a0
80105c3d:	e8 0e e4 ff ff       	call   80104050 <sleep>
  while(ticks - ticks0 < n){
80105c42:	a1 a0 87 11 80       	mov    0x801187a0,%eax
80105c47:	83 c4 10             	add    $0x10,%esp
80105c4a:	29 d8                	sub    %ebx,%eax
80105c4c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105c4f:	73 2f                	jae    80105c80 <sys_sleep+0x90>
    if(myproc()->killed){
80105c51:	e8 9a dc ff ff       	call   801038f0 <myproc>
80105c56:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105c5c:	85 c0                	test   %eax,%eax
80105c5e:	74 d0                	je     80105c30 <sys_sleep+0x40>
      release(&tickslock);
80105c60:	83 ec 0c             	sub    $0xc,%esp
80105c63:	68 60 7f 11 80       	push   $0x80117f60
80105c68:	e8 f3 ed ff ff       	call   80104a60 <release>
      return -1;
80105c6d:	83 c4 10             	add    $0x10,%esp
80105c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105c75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c78:	c9                   	leave  
80105c79:	c3                   	ret    
80105c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&tickslock);
80105c80:	83 ec 0c             	sub    $0xc,%esp
80105c83:	68 60 7f 11 80       	push   $0x80117f60
80105c88:	e8 d3 ed ff ff       	call   80104a60 <release>
  return 0;
80105c8d:	83 c4 10             	add    $0x10,%esp
80105c90:	31 c0                	xor    %eax,%eax
}
80105c92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c95:	c9                   	leave  
80105c96:	c3                   	ret    
    return -1;
80105c97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c9c:	eb f4                	jmp    80105c92 <sys_sleep+0xa2>
80105c9e:	66 90                	xchg   %ax,%ax

80105ca0 <sys_getyear>:
int 
sys_getyear(void)
{
80105ca0:	55                   	push   %ebp
    return 2010;
}
80105ca1:	b8 da 07 00 00       	mov    $0x7da,%eax
{
80105ca6:	89 e5                	mov    %esp,%ebp
}
80105ca8:	5d                   	pop    %ebp
80105ca9:	c3                   	ret    
80105caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105cb0 <sys_getppid>:
int sys_getppid(void){
80105cb0:	55                   	push   %ebp
80105cb1:	89 e5                	mov    %esp,%ebp
80105cb3:	83 ec 08             	sub    $0x8,%esp
  	return myproc() -> parent ->pid;
80105cb6:	e8 35 dc ff ff       	call   801038f0 <myproc>
80105cbb:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
80105cc1:	8b 80 9c 00 00 00    	mov    0x9c(%eax),%eax
}
80105cc7:	c9                   	leave  
80105cc8:	c3                   	ret    
80105cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105cd0 <sys_getchildren>:
int sys_getchildren(void){
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
   return getchildren();
}
80105cd3:	5d                   	pop    %ebp
   return getchildren();
80105cd4:	e9 87 e7 ff ff       	jmp    80104460 <getchildren>
80105cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ce0 <sys_getcount>:
int sys_getcount(void){
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	83 ec 20             	sub    $0x20,%esp
    int pid;
    argint(0, &pid);
80105ce6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ce9:	50                   	push   %eax
80105cea:	6a 00                	push   $0x0
80105cec:	e8 bf f0 ff ff       	call   80104db0 <argint>
    return getcount(pid);
80105cf1:	58                   	pop    %eax
80105cf2:	ff 75 f4             	pushl  -0xc(%ebp)
80105cf5:	e8 d6 e7 ff ff       	call   801044d0 <getcount>
}
80105cfa:	c9                   	leave  
80105cfb:	c3                   	ret    
80105cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d00 <sys_changePriority>:
int sys_changePriority(void){
80105d00:	55                   	push   %ebp
80105d01:	89 e5                	mov    %esp,%ebp
80105d03:	83 ec 20             	sub    $0x20,%esp
    int priority;
    argint(0, &priority);
80105d06:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d09:	50                   	push   %eax
80105d0a:	6a 00                	push   $0x0
80105d0c:	e8 9f f0 ff ff       	call   80104db0 <argint>
    return changePriority(priority);
80105d11:	58                   	pop    %eax
80105d12:	ff 75 f4             	pushl  -0xc(%ebp)
80105d15:	e8 e6 e7 ff ff       	call   80104500 <changePriority>
}
80105d1a:	c9                   	leave  
80105d1b:	c3                   	ret    
80105d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d20 <sys_changePolicy>:
int sys_changePolicy(void){
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	83 ec 20             	sub    $0x20,%esp
    int policy;
    argint(0, &policy);
80105d26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d29:	50                   	push   %eax
80105d2a:	6a 00                	push   $0x0
80105d2c:	e8 7f f0 ff ff       	call   80104db0 <argint>
    return changePolicy(policy);
80105d31:	58                   	pop    %eax
80105d32:	ff 75 f4             	pushl  -0xc(%ebp)
80105d35:	e8 86 e8 ff ff       	call   801045c0 <changePolicy>
}
80105d3a:	c9                   	leave  
80105d3b:	c3                   	ret    
80105d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d40 <sys_waitForChild>:
int sys_waitForChild(void){
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
80105d43:	83 ec 1c             	sub    $0x1c,%esp
    struct timeVariables *tv;
    argptr(0, (void*)&tv, sizeof(*tv));
80105d46:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d49:	6a 14                	push   $0x14
80105d4b:	50                   	push   %eax
80105d4c:	6a 00                	push   $0x0
80105d4e:	e8 ad f0 ff ff       	call   80104e00 <argptr>
    return waitForChild(tv);
80105d53:	58                   	pop    %eax
80105d54:	ff 75 f4             	pushl  -0xc(%ebp)
80105d57:	e8 84 e8 ff ff       	call   801045e0 <waitForChild>
    
}
80105d5c:	c9                   	leave  
80105d5d:	c3                   	ret    
80105d5e:	66 90                	xchg   %ax,%ax

80105d60 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
80105d63:	53                   	push   %ebx
80105d64:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105d67:	68 60 7f 11 80       	push   $0x80117f60
80105d6c:	e8 2f ec ff ff       	call   801049a0 <acquire>
  xticks = ticks;
80105d71:	8b 1d a0 87 11 80    	mov    0x801187a0,%ebx
  release(&tickslock);
80105d77:	c7 04 24 60 7f 11 80 	movl   $0x80117f60,(%esp)
80105d7e:	e8 dd ec ff ff       	call   80104a60 <release>
  return xticks;
}
80105d83:	89 d8                	mov    %ebx,%eax
80105d85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d88:	c9                   	leave  
80105d89:	c3                   	ret    

80105d8a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105d8a:	1e                   	push   %ds
  pushl %es
80105d8b:	06                   	push   %es
  pushl %fs
80105d8c:	0f a0                	push   %fs
  pushl %gs
80105d8e:	0f a8                	push   %gs
  pushal
80105d90:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105d91:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105d95:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105d97:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105d99:	54                   	push   %esp
  call trap
80105d9a:	e8 c1 00 00 00       	call   80105e60 <trap>
  addl $4, %esp
80105d9f:	83 c4 04             	add    $0x4,%esp

80105da2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105da2:	61                   	popa   
  popl %gs
80105da3:	0f a9                	pop    %gs
  popl %fs
80105da5:	0f a1                	pop    %fs
  popl %es
80105da7:	07                   	pop    %es
  popl %ds
80105da8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105da9:	83 c4 08             	add    $0x8,%esp
  iret
80105dac:	cf                   	iret   
80105dad:	66 90                	xchg   %ax,%ax
80105daf:	90                   	nop

80105db0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105db0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105db1:	31 c0                	xor    %eax,%eax
{
80105db3:	89 e5                	mov    %esp,%ebp
80105db5:	83 ec 08             	sub    $0x8,%esp
80105db8:	90                   	nop
80105db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105dc0:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
80105dc7:	c7 04 c5 a2 7f 11 80 	movl   $0x8e000008,-0x7fee805e(,%eax,8)
80105dce:	08 00 00 8e 
80105dd2:	66 89 14 c5 a0 7f 11 	mov    %dx,-0x7fee8060(,%eax,8)
80105dd9:	80 
80105dda:	c1 ea 10             	shr    $0x10,%edx
80105ddd:	66 89 14 c5 a6 7f 11 	mov    %dx,-0x7fee805a(,%eax,8)
80105de4:	80 
  for(i = 0; i < 256; i++)
80105de5:	83 c0 01             	add    $0x1,%eax
80105de8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105ded:	75 d1                	jne    80105dc0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105def:	a1 0c b1 10 80       	mov    0x8010b10c,%eax

  initlock(&tickslock, "time");
80105df4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105df7:	c7 05 a2 81 11 80 08 	movl   $0xef000008,0x801181a2
80105dfe:	00 00 ef 
  initlock(&tickslock, "time");
80105e01:	68 35 7e 10 80       	push   $0x80107e35
80105e06:	68 60 7f 11 80       	push   $0x80117f60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e0b:	66 a3 a0 81 11 80    	mov    %ax,0x801181a0
80105e11:	c1 e8 10             	shr    $0x10,%eax
80105e14:	66 a3 a6 81 11 80    	mov    %ax,0x801181a6
  initlock(&tickslock, "time");
80105e1a:	e8 41 ea ff ff       	call   80104860 <initlock>
}
80105e1f:	83 c4 10             	add    $0x10,%esp
80105e22:	c9                   	leave  
80105e23:	c3                   	ret    
80105e24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105e2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105e30 <idtinit>:

void
idtinit(void)
{
80105e30:	55                   	push   %ebp
  pd[0] = size-1;
80105e31:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105e36:	89 e5                	mov    %esp,%ebp
80105e38:	83 ec 10             	sub    $0x10,%esp
80105e3b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105e3f:	b8 a0 7f 11 80       	mov    $0x80117fa0,%eax
80105e44:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105e48:	c1 e8 10             	shr    $0x10,%eax
80105e4b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105e4f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105e52:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105e55:	c9                   	leave  
80105e56:	c3                   	ret    
80105e57:	89 f6                	mov    %esi,%esi
80105e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e60 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105e60:	55                   	push   %ebp
80105e61:	89 e5                	mov    %esp,%ebp
80105e63:	57                   	push   %edi
80105e64:	56                   	push   %esi
80105e65:	53                   	push   %ebx
80105e66:	83 ec 1c             	sub    $0x1c,%esp
80105e69:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105e6c:	8b 47 30             	mov    0x30(%edi),%eax
80105e6f:	83 f8 40             	cmp    $0x40,%eax
80105e72:	0f 84 00 01 00 00    	je     80105f78 <trap+0x118>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105e78:	83 e8 20             	sub    $0x20,%eax
80105e7b:	83 f8 1f             	cmp    $0x1f,%eax
80105e7e:	77 10                	ja     80105e90 <trap+0x30>
80105e80:	ff 24 85 dc 7e 10 80 	jmp    *-0x7fef8124(,%eax,4)
80105e87:	89 f6                	mov    %esi,%esi
80105e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105e90:	e8 5b da ff ff       	call   801038f0 <myproc>
80105e95:	85 c0                	test   %eax,%eax
80105e97:	8b 5f 38             	mov    0x38(%edi),%ebx
80105e9a:	0f 84 69 02 00 00    	je     80106109 <trap+0x2a9>
80105ea0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105ea4:	0f 84 5f 02 00 00    	je     80106109 <trap+0x2a9>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105eaa:	0f 20 d1             	mov    %cr2,%ecx
80105ead:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105eb0:	e8 1b da ff ff       	call   801038d0 <cpuid>
80105eb5:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105eb8:	8b 47 34             	mov    0x34(%edi),%eax
80105ebb:	8b 77 30             	mov    0x30(%edi),%esi
80105ebe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105ec1:	e8 2a da ff ff       	call   801038f0 <myproc>
80105ec6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105ec9:	e8 22 da ff ff       	call   801038f0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ece:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ed1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ed4:	51                   	push   %ecx
80105ed5:	53                   	push   %ebx
80105ed6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105ed7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105eda:	ff 75 e4             	pushl  -0x1c(%ebp)
80105edd:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105ede:	81 c2 f8 00 00 00    	add    $0xf8,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ee4:	52                   	push   %edx
80105ee5:	ff b0 9c 00 00 00    	pushl  0x9c(%eax)
80105eeb:	68 98 7e 10 80       	push   $0x80107e98
80105ef0:	e8 6b a7 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105ef5:	83 c4 20             	add    $0x20,%esp
80105ef8:	e8 f3 d9 ff ff       	call   801038f0 <myproc>
80105efd:	c7 80 b0 00 00 00 01 	movl   $0x1,0xb0(%eax)
80105f04:	00 00 00 
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f07:	e8 e4 d9 ff ff       	call   801038f0 <myproc>
80105f0c:	85 c0                	test   %eax,%eax
80105f0e:	74 20                	je     80105f30 <trap+0xd0>
80105f10:	e8 db d9 ff ff       	call   801038f0 <myproc>
80105f15:	8b 90 b0 00 00 00    	mov    0xb0(%eax),%edx
80105f1b:	85 d2                	test   %edx,%edx
80105f1d:	74 11                	je     80105f30 <trap+0xd0>
80105f1f:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105f23:	83 e0 03             	and    $0x3,%eax
80105f26:	66 83 f8 03          	cmp    $0x3,%ax
80105f2a:	0f 84 90 01 00 00    	je     801060c0 <trap+0x260>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if( myproc() && myproc()->state == RUNNING &&  tf->trapno == T_IRQ0+IRQ_TIMER){
80105f30:	e8 bb d9 ff ff       	call   801038f0 <myproc>
80105f35:	85 c0                	test   %eax,%eax
80105f37:	74 0e                	je     80105f47 <trap+0xe7>
80105f39:	e8 b2 d9 ff ff       	call   801038f0 <myproc>
80105f3e:	83 b8 98 00 00 00 04 	cmpl   $0x4,0x98(%eax)
80105f45:	74 79                	je     80105fc0 <trap+0x160>
      }
  }
    

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f47:	e8 a4 d9 ff ff       	call   801038f0 <myproc>
80105f4c:	85 c0                	test   %eax,%eax
80105f4e:	74 1c                	je     80105f6c <trap+0x10c>
80105f50:	e8 9b d9 ff ff       	call   801038f0 <myproc>
80105f55:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105f5b:	85 c0                	test   %eax,%eax
80105f5d:	74 0d                	je     80105f6c <trap+0x10c>
80105f5f:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105f63:	83 e0 03             	and    $0x3,%eax
80105f66:	66 83 f8 03          	cmp    $0x3,%ax
80105f6a:	74 3e                	je     80105faa <trap+0x14a>
    exit();
}
80105f6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f6f:	5b                   	pop    %ebx
80105f70:	5e                   	pop    %esi
80105f71:	5f                   	pop    %edi
80105f72:	5d                   	pop    %ebp
80105f73:	c3                   	ret    
80105f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105f78:	e8 73 d9 ff ff       	call   801038f0 <myproc>
80105f7d:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
80105f83:	85 db                	test   %ebx,%ebx
80105f85:	0f 85 25 01 00 00    	jne    801060b0 <trap+0x250>
    myproc()->tf = tf;
80105f8b:	e8 60 d9 ff ff       	call   801038f0 <myproc>
80105f90:	89 b8 a4 00 00 00    	mov    %edi,0xa4(%eax)
    syscall();
80105f96:	e8 05 ef ff ff       	call   80104ea0 <syscall>
    if(myproc()->killed)
80105f9b:	e8 50 d9 ff ff       	call   801038f0 <myproc>
80105fa0:	8b 88 b0 00 00 00    	mov    0xb0(%eax),%ecx
80105fa6:	85 c9                	test   %ecx,%ecx
80105fa8:	74 c2                	je     80105f6c <trap+0x10c>
}
80105faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fad:	5b                   	pop    %ebx
80105fae:	5e                   	pop    %esi
80105faf:	5f                   	pop    %edi
80105fb0:	5d                   	pop    %ebp
      exit();
80105fb1:	e9 da de ff ff       	jmp    80103e90 <exit>
80105fb6:	8d 76 00             	lea    0x0(%esi),%esi
80105fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if( myproc() && myproc()->state == RUNNING &&  tf->trapno == T_IRQ0+IRQ_TIMER){
80105fc0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105fc4:	75 81                	jne    80105f47 <trap+0xe7>
      if( getPolicy() != 0 ){
80105fc6:	e8 75 e5 ff ff       	call   80104540 <getPolicy>
80105fcb:	85 c0                	test   %eax,%eax
80105fcd:	74 20                	je     80105fef <trap+0x18f>
        if(ticks % QUANTUM == 0){
80105fcf:	8b 0d a0 87 11 80    	mov    0x801187a0,%ecx
80105fd5:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
80105fda:	89 c8                	mov    %ecx,%eax
80105fdc:	f7 e2                	mul    %edx
80105fde:	c1 ea 06             	shr    $0x6,%edx
80105fe1:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
80105fe7:	39 d1                	cmp    %edx,%ecx
80105fe9:	0f 85 58 ff ff ff    	jne    80105f47 <trap+0xe7>
          yield();
80105fef:	e8 0c e0 ff ff       	call   80104000 <yield>
80105ff4:	e9 4e ff ff ff       	jmp    80105f47 <trap+0xe7>
80105ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106000:	e8 cb d8 ff ff       	call   801038d0 <cpuid>
80106005:	85 c0                	test   %eax,%eax
80106007:	0f 84 c3 00 00 00    	je     801060d0 <trap+0x270>
    lapiceoi();
8010600d:	e8 5e c7 ff ff       	call   80102770 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106012:	e8 d9 d8 ff ff       	call   801038f0 <myproc>
80106017:	85 c0                	test   %eax,%eax
80106019:	0f 85 f1 fe ff ff    	jne    80105f10 <trap+0xb0>
8010601f:	e9 0c ff ff ff       	jmp    80105f30 <trap+0xd0>
80106024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106028:	e8 03 c6 ff ff       	call   80102630 <kbdintr>
    lapiceoi();
8010602d:	e8 3e c7 ff ff       	call   80102770 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106032:	e8 b9 d8 ff ff       	call   801038f0 <myproc>
80106037:	85 c0                	test   %eax,%eax
80106039:	0f 85 d1 fe ff ff    	jne    80105f10 <trap+0xb0>
8010603f:	e9 ec fe ff ff       	jmp    80105f30 <trap+0xd0>
80106044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106048:	e8 63 02 00 00       	call   801062b0 <uartintr>
    lapiceoi();
8010604d:	e8 1e c7 ff ff       	call   80102770 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106052:	e8 99 d8 ff ff       	call   801038f0 <myproc>
80106057:	85 c0                	test   %eax,%eax
80106059:	0f 85 b1 fe ff ff    	jne    80105f10 <trap+0xb0>
8010605f:	e9 cc fe ff ff       	jmp    80105f30 <trap+0xd0>
80106064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106068:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
8010606c:	8b 77 38             	mov    0x38(%edi),%esi
8010606f:	e8 5c d8 ff ff       	call   801038d0 <cpuid>
80106074:	56                   	push   %esi
80106075:	53                   	push   %ebx
80106076:	50                   	push   %eax
80106077:	68 40 7e 10 80       	push   $0x80107e40
8010607c:	e8 df a5 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106081:	e8 ea c6 ff ff       	call   80102770 <lapiceoi>
    break;
80106086:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106089:	e8 62 d8 ff ff       	call   801038f0 <myproc>
8010608e:	85 c0                	test   %eax,%eax
80106090:	0f 85 7a fe ff ff    	jne    80105f10 <trap+0xb0>
80106096:	e9 95 fe ff ff       	jmp    80105f30 <trap+0xd0>
8010609b:	90                   	nop
8010609c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
801060a0:	e8 fb bf ff ff       	call   801020a0 <ideintr>
801060a5:	e9 63 ff ff ff       	jmp    8010600d <trap+0x1ad>
801060aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801060b0:	e8 db dd ff ff       	call   80103e90 <exit>
801060b5:	e9 d1 fe ff ff       	jmp    80105f8b <trap+0x12b>
801060ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
801060c0:	e8 cb dd ff ff       	call   80103e90 <exit>
801060c5:	e9 66 fe ff ff       	jmp    80105f30 <trap+0xd0>
801060ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
801060d0:	83 ec 0c             	sub    $0xc,%esp
801060d3:	68 60 7f 11 80       	push   $0x80117f60
801060d8:	e8 c3 e8 ff ff       	call   801049a0 <acquire>
      ticks++;
801060dd:	83 05 a0 87 11 80 01 	addl   $0x1,0x801187a0
      timerUpdate();
801060e4:	e8 67 e4 ff ff       	call   80104550 <timerUpdate>
      wakeup(&ticks);
801060e9:	c7 04 24 a0 87 11 80 	movl   $0x801187a0,(%esp)
801060f0:	e8 5b e1 ff ff       	call   80104250 <wakeup>
      release(&tickslock);
801060f5:	c7 04 24 60 7f 11 80 	movl   $0x80117f60,(%esp)
801060fc:	e8 5f e9 ff ff       	call   80104a60 <release>
80106101:	83 c4 10             	add    $0x10,%esp
80106104:	e9 04 ff ff ff       	jmp    8010600d <trap+0x1ad>
80106109:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010610c:	e8 bf d7 ff ff       	call   801038d0 <cpuid>
80106111:	83 ec 0c             	sub    $0xc,%esp
80106114:	56                   	push   %esi
80106115:	53                   	push   %ebx
80106116:	50                   	push   %eax
80106117:	ff 77 30             	pushl  0x30(%edi)
8010611a:	68 64 7e 10 80       	push   $0x80107e64
8010611f:	e8 3c a5 ff ff       	call   80100660 <cprintf>
      panic("trap");
80106124:	83 c4 14             	add    $0x14,%esp
80106127:	68 3a 7e 10 80       	push   $0x80107e3a
8010612c:	e8 5f a2 ff ff       	call   80100390 <panic>
80106131:	66 90                	xchg   %ax,%ax
80106133:	66 90                	xchg   %ax,%ax
80106135:	66 90                	xchg   %ax,%ax
80106137:	66 90                	xchg   %ax,%ax
80106139:	66 90                	xchg   %ax,%ax
8010613b:	66 90                	xchg   %ax,%ax
8010613d:	66 90                	xchg   %ax,%ax
8010613f:	90                   	nop

80106140 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106140:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
80106145:	55                   	push   %ebp
80106146:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106148:	85 c0                	test   %eax,%eax
8010614a:	74 1c                	je     80106168 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010614c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106151:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106152:	a8 01                	test   $0x1,%al
80106154:	74 12                	je     80106168 <uartgetc+0x28>
80106156:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010615b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010615c:	0f b6 c0             	movzbl %al,%eax
}
8010615f:	5d                   	pop    %ebp
80106160:	c3                   	ret    
80106161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106168:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010616d:	5d                   	pop    %ebp
8010616e:	c3                   	ret    
8010616f:	90                   	nop

80106170 <uartputc.part.0>:
uartputc(int c)
80106170:	55                   	push   %ebp
80106171:	89 e5                	mov    %esp,%ebp
80106173:	57                   	push   %edi
80106174:	56                   	push   %esi
80106175:	53                   	push   %ebx
80106176:	89 c7                	mov    %eax,%edi
80106178:	bb 80 00 00 00       	mov    $0x80,%ebx
8010617d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106182:	83 ec 0c             	sub    $0xc,%esp
80106185:	eb 1b                	jmp    801061a2 <uartputc.part.0+0x32>
80106187:	89 f6                	mov    %esi,%esi
80106189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106190:	83 ec 0c             	sub    $0xc,%esp
80106193:	6a 0a                	push   $0xa
80106195:	e8 f6 c5 ff ff       	call   80102790 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010619a:	83 c4 10             	add    $0x10,%esp
8010619d:	83 eb 01             	sub    $0x1,%ebx
801061a0:	74 07                	je     801061a9 <uartputc.part.0+0x39>
801061a2:	89 f2                	mov    %esi,%edx
801061a4:	ec                   	in     (%dx),%al
801061a5:	a8 20                	test   $0x20,%al
801061a7:	74 e7                	je     80106190 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801061a9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061ae:	89 f8                	mov    %edi,%eax
801061b0:	ee                   	out    %al,(%dx)
}
801061b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061b4:	5b                   	pop    %ebx
801061b5:	5e                   	pop    %esi
801061b6:	5f                   	pop    %edi
801061b7:	5d                   	pop    %ebp
801061b8:	c3                   	ret    
801061b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061c0 <uartinit>:
{
801061c0:	55                   	push   %ebp
801061c1:	31 c9                	xor    %ecx,%ecx
801061c3:	89 c8                	mov    %ecx,%eax
801061c5:	89 e5                	mov    %esp,%ebp
801061c7:	57                   	push   %edi
801061c8:	56                   	push   %esi
801061c9:	53                   	push   %ebx
801061ca:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801061cf:	89 da                	mov    %ebx,%edx
801061d1:	83 ec 0c             	sub    $0xc,%esp
801061d4:	ee                   	out    %al,(%dx)
801061d5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801061da:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801061df:	89 fa                	mov    %edi,%edx
801061e1:	ee                   	out    %al,(%dx)
801061e2:	b8 0c 00 00 00       	mov    $0xc,%eax
801061e7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061ec:	ee                   	out    %al,(%dx)
801061ed:	be f9 03 00 00       	mov    $0x3f9,%esi
801061f2:	89 c8                	mov    %ecx,%eax
801061f4:	89 f2                	mov    %esi,%edx
801061f6:	ee                   	out    %al,(%dx)
801061f7:	b8 03 00 00 00       	mov    $0x3,%eax
801061fc:	89 fa                	mov    %edi,%edx
801061fe:	ee                   	out    %al,(%dx)
801061ff:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106204:	89 c8                	mov    %ecx,%eax
80106206:	ee                   	out    %al,(%dx)
80106207:	b8 01 00 00 00       	mov    $0x1,%eax
8010620c:	89 f2                	mov    %esi,%edx
8010620e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010620f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106214:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106215:	3c ff                	cmp    $0xff,%al
80106217:	74 5a                	je     80106273 <uartinit+0xb3>
  uart = 1;
80106219:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106220:	00 00 00 
80106223:	89 da                	mov    %ebx,%edx
80106225:	ec                   	in     (%dx),%al
80106226:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010622b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010622c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010622f:	bb 5c 7f 10 80       	mov    $0x80107f5c,%ebx
  ioapicenable(IRQ_COM1, 0);
80106234:	6a 00                	push   $0x0
80106236:	6a 04                	push   $0x4
80106238:	e8 b3 c0 ff ff       	call   801022f0 <ioapicenable>
8010623d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106240:	b8 78 00 00 00       	mov    $0x78,%eax
80106245:	eb 13                	jmp    8010625a <uartinit+0x9a>
80106247:	89 f6                	mov    %esi,%esi
80106249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106250:	83 c3 01             	add    $0x1,%ebx
80106253:	0f be 03             	movsbl (%ebx),%eax
80106256:	84 c0                	test   %al,%al
80106258:	74 19                	je     80106273 <uartinit+0xb3>
  if(!uart)
8010625a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106260:	85 d2                	test   %edx,%edx
80106262:	74 ec                	je     80106250 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106264:	83 c3 01             	add    $0x1,%ebx
80106267:	e8 04 ff ff ff       	call   80106170 <uartputc.part.0>
8010626c:	0f be 03             	movsbl (%ebx),%eax
8010626f:	84 c0                	test   %al,%al
80106271:	75 e7                	jne    8010625a <uartinit+0x9a>
}
80106273:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106276:	5b                   	pop    %ebx
80106277:	5e                   	pop    %esi
80106278:	5f                   	pop    %edi
80106279:	5d                   	pop    %ebp
8010627a:	c3                   	ret    
8010627b:	90                   	nop
8010627c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106280 <uartputc>:
  if(!uart)
80106280:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
80106286:	55                   	push   %ebp
80106287:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106289:	85 d2                	test   %edx,%edx
{
8010628b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010628e:	74 10                	je     801062a0 <uartputc+0x20>
}
80106290:	5d                   	pop    %ebp
80106291:	e9 da fe ff ff       	jmp    80106170 <uartputc.part.0>
80106296:	8d 76 00             	lea    0x0(%esi),%esi
80106299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801062a0:	5d                   	pop    %ebp
801062a1:	c3                   	ret    
801062a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801062b0 <uartintr>:

void
uartintr(void)
{
801062b0:	55                   	push   %ebp
801062b1:	89 e5                	mov    %esp,%ebp
801062b3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801062b6:	68 40 61 10 80       	push   $0x80106140
801062bb:	e8 50 a5 ff ff       	call   80100810 <consoleintr>
}
801062c0:	83 c4 10             	add    $0x10,%esp
801062c3:	c9                   	leave  
801062c4:	c3                   	ret    

801062c5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801062c5:	6a 00                	push   $0x0
  pushl $0
801062c7:	6a 00                	push   $0x0
  jmp alltraps
801062c9:	e9 bc fa ff ff       	jmp    80105d8a <alltraps>

801062ce <vector1>:
.globl vector1
vector1:
  pushl $0
801062ce:	6a 00                	push   $0x0
  pushl $1
801062d0:	6a 01                	push   $0x1
  jmp alltraps
801062d2:	e9 b3 fa ff ff       	jmp    80105d8a <alltraps>

801062d7 <vector2>:
.globl vector2
vector2:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $2
801062d9:	6a 02                	push   $0x2
  jmp alltraps
801062db:	e9 aa fa ff ff       	jmp    80105d8a <alltraps>

801062e0 <vector3>:
.globl vector3
vector3:
  pushl $0
801062e0:	6a 00                	push   $0x0
  pushl $3
801062e2:	6a 03                	push   $0x3
  jmp alltraps
801062e4:	e9 a1 fa ff ff       	jmp    80105d8a <alltraps>

801062e9 <vector4>:
.globl vector4
vector4:
  pushl $0
801062e9:	6a 00                	push   $0x0
  pushl $4
801062eb:	6a 04                	push   $0x4
  jmp alltraps
801062ed:	e9 98 fa ff ff       	jmp    80105d8a <alltraps>

801062f2 <vector5>:
.globl vector5
vector5:
  pushl $0
801062f2:	6a 00                	push   $0x0
  pushl $5
801062f4:	6a 05                	push   $0x5
  jmp alltraps
801062f6:	e9 8f fa ff ff       	jmp    80105d8a <alltraps>

801062fb <vector6>:
.globl vector6
vector6:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $6
801062fd:	6a 06                	push   $0x6
  jmp alltraps
801062ff:	e9 86 fa ff ff       	jmp    80105d8a <alltraps>

80106304 <vector7>:
.globl vector7
vector7:
  pushl $0
80106304:	6a 00                	push   $0x0
  pushl $7
80106306:	6a 07                	push   $0x7
  jmp alltraps
80106308:	e9 7d fa ff ff       	jmp    80105d8a <alltraps>

8010630d <vector8>:
.globl vector8
vector8:
  pushl $8
8010630d:	6a 08                	push   $0x8
  jmp alltraps
8010630f:	e9 76 fa ff ff       	jmp    80105d8a <alltraps>

80106314 <vector9>:
.globl vector9
vector9:
  pushl $0
80106314:	6a 00                	push   $0x0
  pushl $9
80106316:	6a 09                	push   $0x9
  jmp alltraps
80106318:	e9 6d fa ff ff       	jmp    80105d8a <alltraps>

8010631d <vector10>:
.globl vector10
vector10:
  pushl $10
8010631d:	6a 0a                	push   $0xa
  jmp alltraps
8010631f:	e9 66 fa ff ff       	jmp    80105d8a <alltraps>

80106324 <vector11>:
.globl vector11
vector11:
  pushl $11
80106324:	6a 0b                	push   $0xb
  jmp alltraps
80106326:	e9 5f fa ff ff       	jmp    80105d8a <alltraps>

8010632b <vector12>:
.globl vector12
vector12:
  pushl $12
8010632b:	6a 0c                	push   $0xc
  jmp alltraps
8010632d:	e9 58 fa ff ff       	jmp    80105d8a <alltraps>

80106332 <vector13>:
.globl vector13
vector13:
  pushl $13
80106332:	6a 0d                	push   $0xd
  jmp alltraps
80106334:	e9 51 fa ff ff       	jmp    80105d8a <alltraps>

80106339 <vector14>:
.globl vector14
vector14:
  pushl $14
80106339:	6a 0e                	push   $0xe
  jmp alltraps
8010633b:	e9 4a fa ff ff       	jmp    80105d8a <alltraps>

80106340 <vector15>:
.globl vector15
vector15:
  pushl $0
80106340:	6a 00                	push   $0x0
  pushl $15
80106342:	6a 0f                	push   $0xf
  jmp alltraps
80106344:	e9 41 fa ff ff       	jmp    80105d8a <alltraps>

80106349 <vector16>:
.globl vector16
vector16:
  pushl $0
80106349:	6a 00                	push   $0x0
  pushl $16
8010634b:	6a 10                	push   $0x10
  jmp alltraps
8010634d:	e9 38 fa ff ff       	jmp    80105d8a <alltraps>

80106352 <vector17>:
.globl vector17
vector17:
  pushl $17
80106352:	6a 11                	push   $0x11
  jmp alltraps
80106354:	e9 31 fa ff ff       	jmp    80105d8a <alltraps>

80106359 <vector18>:
.globl vector18
vector18:
  pushl $0
80106359:	6a 00                	push   $0x0
  pushl $18
8010635b:	6a 12                	push   $0x12
  jmp alltraps
8010635d:	e9 28 fa ff ff       	jmp    80105d8a <alltraps>

80106362 <vector19>:
.globl vector19
vector19:
  pushl $0
80106362:	6a 00                	push   $0x0
  pushl $19
80106364:	6a 13                	push   $0x13
  jmp alltraps
80106366:	e9 1f fa ff ff       	jmp    80105d8a <alltraps>

8010636b <vector20>:
.globl vector20
vector20:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $20
8010636d:	6a 14                	push   $0x14
  jmp alltraps
8010636f:	e9 16 fa ff ff       	jmp    80105d8a <alltraps>

80106374 <vector21>:
.globl vector21
vector21:
  pushl $0
80106374:	6a 00                	push   $0x0
  pushl $21
80106376:	6a 15                	push   $0x15
  jmp alltraps
80106378:	e9 0d fa ff ff       	jmp    80105d8a <alltraps>

8010637d <vector22>:
.globl vector22
vector22:
  pushl $0
8010637d:	6a 00                	push   $0x0
  pushl $22
8010637f:	6a 16                	push   $0x16
  jmp alltraps
80106381:	e9 04 fa ff ff       	jmp    80105d8a <alltraps>

80106386 <vector23>:
.globl vector23
vector23:
  pushl $0
80106386:	6a 00                	push   $0x0
  pushl $23
80106388:	6a 17                	push   $0x17
  jmp alltraps
8010638a:	e9 fb f9 ff ff       	jmp    80105d8a <alltraps>

8010638f <vector24>:
.globl vector24
vector24:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $24
80106391:	6a 18                	push   $0x18
  jmp alltraps
80106393:	e9 f2 f9 ff ff       	jmp    80105d8a <alltraps>

80106398 <vector25>:
.globl vector25
vector25:
  pushl $0
80106398:	6a 00                	push   $0x0
  pushl $25
8010639a:	6a 19                	push   $0x19
  jmp alltraps
8010639c:	e9 e9 f9 ff ff       	jmp    80105d8a <alltraps>

801063a1 <vector26>:
.globl vector26
vector26:
  pushl $0
801063a1:	6a 00                	push   $0x0
  pushl $26
801063a3:	6a 1a                	push   $0x1a
  jmp alltraps
801063a5:	e9 e0 f9 ff ff       	jmp    80105d8a <alltraps>

801063aa <vector27>:
.globl vector27
vector27:
  pushl $0
801063aa:	6a 00                	push   $0x0
  pushl $27
801063ac:	6a 1b                	push   $0x1b
  jmp alltraps
801063ae:	e9 d7 f9 ff ff       	jmp    80105d8a <alltraps>

801063b3 <vector28>:
.globl vector28
vector28:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $28
801063b5:	6a 1c                	push   $0x1c
  jmp alltraps
801063b7:	e9 ce f9 ff ff       	jmp    80105d8a <alltraps>

801063bc <vector29>:
.globl vector29
vector29:
  pushl $0
801063bc:	6a 00                	push   $0x0
  pushl $29
801063be:	6a 1d                	push   $0x1d
  jmp alltraps
801063c0:	e9 c5 f9 ff ff       	jmp    80105d8a <alltraps>

801063c5 <vector30>:
.globl vector30
vector30:
  pushl $0
801063c5:	6a 00                	push   $0x0
  pushl $30
801063c7:	6a 1e                	push   $0x1e
  jmp alltraps
801063c9:	e9 bc f9 ff ff       	jmp    80105d8a <alltraps>

801063ce <vector31>:
.globl vector31
vector31:
  pushl $0
801063ce:	6a 00                	push   $0x0
  pushl $31
801063d0:	6a 1f                	push   $0x1f
  jmp alltraps
801063d2:	e9 b3 f9 ff ff       	jmp    80105d8a <alltraps>

801063d7 <vector32>:
.globl vector32
vector32:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $32
801063d9:	6a 20                	push   $0x20
  jmp alltraps
801063db:	e9 aa f9 ff ff       	jmp    80105d8a <alltraps>

801063e0 <vector33>:
.globl vector33
vector33:
  pushl $0
801063e0:	6a 00                	push   $0x0
  pushl $33
801063e2:	6a 21                	push   $0x21
  jmp alltraps
801063e4:	e9 a1 f9 ff ff       	jmp    80105d8a <alltraps>

801063e9 <vector34>:
.globl vector34
vector34:
  pushl $0
801063e9:	6a 00                	push   $0x0
  pushl $34
801063eb:	6a 22                	push   $0x22
  jmp alltraps
801063ed:	e9 98 f9 ff ff       	jmp    80105d8a <alltraps>

801063f2 <vector35>:
.globl vector35
vector35:
  pushl $0
801063f2:	6a 00                	push   $0x0
  pushl $35
801063f4:	6a 23                	push   $0x23
  jmp alltraps
801063f6:	e9 8f f9 ff ff       	jmp    80105d8a <alltraps>

801063fb <vector36>:
.globl vector36
vector36:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $36
801063fd:	6a 24                	push   $0x24
  jmp alltraps
801063ff:	e9 86 f9 ff ff       	jmp    80105d8a <alltraps>

80106404 <vector37>:
.globl vector37
vector37:
  pushl $0
80106404:	6a 00                	push   $0x0
  pushl $37
80106406:	6a 25                	push   $0x25
  jmp alltraps
80106408:	e9 7d f9 ff ff       	jmp    80105d8a <alltraps>

8010640d <vector38>:
.globl vector38
vector38:
  pushl $0
8010640d:	6a 00                	push   $0x0
  pushl $38
8010640f:	6a 26                	push   $0x26
  jmp alltraps
80106411:	e9 74 f9 ff ff       	jmp    80105d8a <alltraps>

80106416 <vector39>:
.globl vector39
vector39:
  pushl $0
80106416:	6a 00                	push   $0x0
  pushl $39
80106418:	6a 27                	push   $0x27
  jmp alltraps
8010641a:	e9 6b f9 ff ff       	jmp    80105d8a <alltraps>

8010641f <vector40>:
.globl vector40
vector40:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $40
80106421:	6a 28                	push   $0x28
  jmp alltraps
80106423:	e9 62 f9 ff ff       	jmp    80105d8a <alltraps>

80106428 <vector41>:
.globl vector41
vector41:
  pushl $0
80106428:	6a 00                	push   $0x0
  pushl $41
8010642a:	6a 29                	push   $0x29
  jmp alltraps
8010642c:	e9 59 f9 ff ff       	jmp    80105d8a <alltraps>

80106431 <vector42>:
.globl vector42
vector42:
  pushl $0
80106431:	6a 00                	push   $0x0
  pushl $42
80106433:	6a 2a                	push   $0x2a
  jmp alltraps
80106435:	e9 50 f9 ff ff       	jmp    80105d8a <alltraps>

8010643a <vector43>:
.globl vector43
vector43:
  pushl $0
8010643a:	6a 00                	push   $0x0
  pushl $43
8010643c:	6a 2b                	push   $0x2b
  jmp alltraps
8010643e:	e9 47 f9 ff ff       	jmp    80105d8a <alltraps>

80106443 <vector44>:
.globl vector44
vector44:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $44
80106445:	6a 2c                	push   $0x2c
  jmp alltraps
80106447:	e9 3e f9 ff ff       	jmp    80105d8a <alltraps>

8010644c <vector45>:
.globl vector45
vector45:
  pushl $0
8010644c:	6a 00                	push   $0x0
  pushl $45
8010644e:	6a 2d                	push   $0x2d
  jmp alltraps
80106450:	e9 35 f9 ff ff       	jmp    80105d8a <alltraps>

80106455 <vector46>:
.globl vector46
vector46:
  pushl $0
80106455:	6a 00                	push   $0x0
  pushl $46
80106457:	6a 2e                	push   $0x2e
  jmp alltraps
80106459:	e9 2c f9 ff ff       	jmp    80105d8a <alltraps>

8010645e <vector47>:
.globl vector47
vector47:
  pushl $0
8010645e:	6a 00                	push   $0x0
  pushl $47
80106460:	6a 2f                	push   $0x2f
  jmp alltraps
80106462:	e9 23 f9 ff ff       	jmp    80105d8a <alltraps>

80106467 <vector48>:
.globl vector48
vector48:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $48
80106469:	6a 30                	push   $0x30
  jmp alltraps
8010646b:	e9 1a f9 ff ff       	jmp    80105d8a <alltraps>

80106470 <vector49>:
.globl vector49
vector49:
  pushl $0
80106470:	6a 00                	push   $0x0
  pushl $49
80106472:	6a 31                	push   $0x31
  jmp alltraps
80106474:	e9 11 f9 ff ff       	jmp    80105d8a <alltraps>

80106479 <vector50>:
.globl vector50
vector50:
  pushl $0
80106479:	6a 00                	push   $0x0
  pushl $50
8010647b:	6a 32                	push   $0x32
  jmp alltraps
8010647d:	e9 08 f9 ff ff       	jmp    80105d8a <alltraps>

80106482 <vector51>:
.globl vector51
vector51:
  pushl $0
80106482:	6a 00                	push   $0x0
  pushl $51
80106484:	6a 33                	push   $0x33
  jmp alltraps
80106486:	e9 ff f8 ff ff       	jmp    80105d8a <alltraps>

8010648b <vector52>:
.globl vector52
vector52:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $52
8010648d:	6a 34                	push   $0x34
  jmp alltraps
8010648f:	e9 f6 f8 ff ff       	jmp    80105d8a <alltraps>

80106494 <vector53>:
.globl vector53
vector53:
  pushl $0
80106494:	6a 00                	push   $0x0
  pushl $53
80106496:	6a 35                	push   $0x35
  jmp alltraps
80106498:	e9 ed f8 ff ff       	jmp    80105d8a <alltraps>

8010649d <vector54>:
.globl vector54
vector54:
  pushl $0
8010649d:	6a 00                	push   $0x0
  pushl $54
8010649f:	6a 36                	push   $0x36
  jmp alltraps
801064a1:	e9 e4 f8 ff ff       	jmp    80105d8a <alltraps>

801064a6 <vector55>:
.globl vector55
vector55:
  pushl $0
801064a6:	6a 00                	push   $0x0
  pushl $55
801064a8:	6a 37                	push   $0x37
  jmp alltraps
801064aa:	e9 db f8 ff ff       	jmp    80105d8a <alltraps>

801064af <vector56>:
.globl vector56
vector56:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $56
801064b1:	6a 38                	push   $0x38
  jmp alltraps
801064b3:	e9 d2 f8 ff ff       	jmp    80105d8a <alltraps>

801064b8 <vector57>:
.globl vector57
vector57:
  pushl $0
801064b8:	6a 00                	push   $0x0
  pushl $57
801064ba:	6a 39                	push   $0x39
  jmp alltraps
801064bc:	e9 c9 f8 ff ff       	jmp    80105d8a <alltraps>

801064c1 <vector58>:
.globl vector58
vector58:
  pushl $0
801064c1:	6a 00                	push   $0x0
  pushl $58
801064c3:	6a 3a                	push   $0x3a
  jmp alltraps
801064c5:	e9 c0 f8 ff ff       	jmp    80105d8a <alltraps>

801064ca <vector59>:
.globl vector59
vector59:
  pushl $0
801064ca:	6a 00                	push   $0x0
  pushl $59
801064cc:	6a 3b                	push   $0x3b
  jmp alltraps
801064ce:	e9 b7 f8 ff ff       	jmp    80105d8a <alltraps>

801064d3 <vector60>:
.globl vector60
vector60:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $60
801064d5:	6a 3c                	push   $0x3c
  jmp alltraps
801064d7:	e9 ae f8 ff ff       	jmp    80105d8a <alltraps>

801064dc <vector61>:
.globl vector61
vector61:
  pushl $0
801064dc:	6a 00                	push   $0x0
  pushl $61
801064de:	6a 3d                	push   $0x3d
  jmp alltraps
801064e0:	e9 a5 f8 ff ff       	jmp    80105d8a <alltraps>

801064e5 <vector62>:
.globl vector62
vector62:
  pushl $0
801064e5:	6a 00                	push   $0x0
  pushl $62
801064e7:	6a 3e                	push   $0x3e
  jmp alltraps
801064e9:	e9 9c f8 ff ff       	jmp    80105d8a <alltraps>

801064ee <vector63>:
.globl vector63
vector63:
  pushl $0
801064ee:	6a 00                	push   $0x0
  pushl $63
801064f0:	6a 3f                	push   $0x3f
  jmp alltraps
801064f2:	e9 93 f8 ff ff       	jmp    80105d8a <alltraps>

801064f7 <vector64>:
.globl vector64
vector64:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $64
801064f9:	6a 40                	push   $0x40
  jmp alltraps
801064fb:	e9 8a f8 ff ff       	jmp    80105d8a <alltraps>

80106500 <vector65>:
.globl vector65
vector65:
  pushl $0
80106500:	6a 00                	push   $0x0
  pushl $65
80106502:	6a 41                	push   $0x41
  jmp alltraps
80106504:	e9 81 f8 ff ff       	jmp    80105d8a <alltraps>

80106509 <vector66>:
.globl vector66
vector66:
  pushl $0
80106509:	6a 00                	push   $0x0
  pushl $66
8010650b:	6a 42                	push   $0x42
  jmp alltraps
8010650d:	e9 78 f8 ff ff       	jmp    80105d8a <alltraps>

80106512 <vector67>:
.globl vector67
vector67:
  pushl $0
80106512:	6a 00                	push   $0x0
  pushl $67
80106514:	6a 43                	push   $0x43
  jmp alltraps
80106516:	e9 6f f8 ff ff       	jmp    80105d8a <alltraps>

8010651b <vector68>:
.globl vector68
vector68:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $68
8010651d:	6a 44                	push   $0x44
  jmp alltraps
8010651f:	e9 66 f8 ff ff       	jmp    80105d8a <alltraps>

80106524 <vector69>:
.globl vector69
vector69:
  pushl $0
80106524:	6a 00                	push   $0x0
  pushl $69
80106526:	6a 45                	push   $0x45
  jmp alltraps
80106528:	e9 5d f8 ff ff       	jmp    80105d8a <alltraps>

8010652d <vector70>:
.globl vector70
vector70:
  pushl $0
8010652d:	6a 00                	push   $0x0
  pushl $70
8010652f:	6a 46                	push   $0x46
  jmp alltraps
80106531:	e9 54 f8 ff ff       	jmp    80105d8a <alltraps>

80106536 <vector71>:
.globl vector71
vector71:
  pushl $0
80106536:	6a 00                	push   $0x0
  pushl $71
80106538:	6a 47                	push   $0x47
  jmp alltraps
8010653a:	e9 4b f8 ff ff       	jmp    80105d8a <alltraps>

8010653f <vector72>:
.globl vector72
vector72:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $72
80106541:	6a 48                	push   $0x48
  jmp alltraps
80106543:	e9 42 f8 ff ff       	jmp    80105d8a <alltraps>

80106548 <vector73>:
.globl vector73
vector73:
  pushl $0
80106548:	6a 00                	push   $0x0
  pushl $73
8010654a:	6a 49                	push   $0x49
  jmp alltraps
8010654c:	e9 39 f8 ff ff       	jmp    80105d8a <alltraps>

80106551 <vector74>:
.globl vector74
vector74:
  pushl $0
80106551:	6a 00                	push   $0x0
  pushl $74
80106553:	6a 4a                	push   $0x4a
  jmp alltraps
80106555:	e9 30 f8 ff ff       	jmp    80105d8a <alltraps>

8010655a <vector75>:
.globl vector75
vector75:
  pushl $0
8010655a:	6a 00                	push   $0x0
  pushl $75
8010655c:	6a 4b                	push   $0x4b
  jmp alltraps
8010655e:	e9 27 f8 ff ff       	jmp    80105d8a <alltraps>

80106563 <vector76>:
.globl vector76
vector76:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $76
80106565:	6a 4c                	push   $0x4c
  jmp alltraps
80106567:	e9 1e f8 ff ff       	jmp    80105d8a <alltraps>

8010656c <vector77>:
.globl vector77
vector77:
  pushl $0
8010656c:	6a 00                	push   $0x0
  pushl $77
8010656e:	6a 4d                	push   $0x4d
  jmp alltraps
80106570:	e9 15 f8 ff ff       	jmp    80105d8a <alltraps>

80106575 <vector78>:
.globl vector78
vector78:
  pushl $0
80106575:	6a 00                	push   $0x0
  pushl $78
80106577:	6a 4e                	push   $0x4e
  jmp alltraps
80106579:	e9 0c f8 ff ff       	jmp    80105d8a <alltraps>

8010657e <vector79>:
.globl vector79
vector79:
  pushl $0
8010657e:	6a 00                	push   $0x0
  pushl $79
80106580:	6a 4f                	push   $0x4f
  jmp alltraps
80106582:	e9 03 f8 ff ff       	jmp    80105d8a <alltraps>

80106587 <vector80>:
.globl vector80
vector80:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $80
80106589:	6a 50                	push   $0x50
  jmp alltraps
8010658b:	e9 fa f7 ff ff       	jmp    80105d8a <alltraps>

80106590 <vector81>:
.globl vector81
vector81:
  pushl $0
80106590:	6a 00                	push   $0x0
  pushl $81
80106592:	6a 51                	push   $0x51
  jmp alltraps
80106594:	e9 f1 f7 ff ff       	jmp    80105d8a <alltraps>

80106599 <vector82>:
.globl vector82
vector82:
  pushl $0
80106599:	6a 00                	push   $0x0
  pushl $82
8010659b:	6a 52                	push   $0x52
  jmp alltraps
8010659d:	e9 e8 f7 ff ff       	jmp    80105d8a <alltraps>

801065a2 <vector83>:
.globl vector83
vector83:
  pushl $0
801065a2:	6a 00                	push   $0x0
  pushl $83
801065a4:	6a 53                	push   $0x53
  jmp alltraps
801065a6:	e9 df f7 ff ff       	jmp    80105d8a <alltraps>

801065ab <vector84>:
.globl vector84
vector84:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $84
801065ad:	6a 54                	push   $0x54
  jmp alltraps
801065af:	e9 d6 f7 ff ff       	jmp    80105d8a <alltraps>

801065b4 <vector85>:
.globl vector85
vector85:
  pushl $0
801065b4:	6a 00                	push   $0x0
  pushl $85
801065b6:	6a 55                	push   $0x55
  jmp alltraps
801065b8:	e9 cd f7 ff ff       	jmp    80105d8a <alltraps>

801065bd <vector86>:
.globl vector86
vector86:
  pushl $0
801065bd:	6a 00                	push   $0x0
  pushl $86
801065bf:	6a 56                	push   $0x56
  jmp alltraps
801065c1:	e9 c4 f7 ff ff       	jmp    80105d8a <alltraps>

801065c6 <vector87>:
.globl vector87
vector87:
  pushl $0
801065c6:	6a 00                	push   $0x0
  pushl $87
801065c8:	6a 57                	push   $0x57
  jmp alltraps
801065ca:	e9 bb f7 ff ff       	jmp    80105d8a <alltraps>

801065cf <vector88>:
.globl vector88
vector88:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $88
801065d1:	6a 58                	push   $0x58
  jmp alltraps
801065d3:	e9 b2 f7 ff ff       	jmp    80105d8a <alltraps>

801065d8 <vector89>:
.globl vector89
vector89:
  pushl $0
801065d8:	6a 00                	push   $0x0
  pushl $89
801065da:	6a 59                	push   $0x59
  jmp alltraps
801065dc:	e9 a9 f7 ff ff       	jmp    80105d8a <alltraps>

801065e1 <vector90>:
.globl vector90
vector90:
  pushl $0
801065e1:	6a 00                	push   $0x0
  pushl $90
801065e3:	6a 5a                	push   $0x5a
  jmp alltraps
801065e5:	e9 a0 f7 ff ff       	jmp    80105d8a <alltraps>

801065ea <vector91>:
.globl vector91
vector91:
  pushl $0
801065ea:	6a 00                	push   $0x0
  pushl $91
801065ec:	6a 5b                	push   $0x5b
  jmp alltraps
801065ee:	e9 97 f7 ff ff       	jmp    80105d8a <alltraps>

801065f3 <vector92>:
.globl vector92
vector92:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $92
801065f5:	6a 5c                	push   $0x5c
  jmp alltraps
801065f7:	e9 8e f7 ff ff       	jmp    80105d8a <alltraps>

801065fc <vector93>:
.globl vector93
vector93:
  pushl $0
801065fc:	6a 00                	push   $0x0
  pushl $93
801065fe:	6a 5d                	push   $0x5d
  jmp alltraps
80106600:	e9 85 f7 ff ff       	jmp    80105d8a <alltraps>

80106605 <vector94>:
.globl vector94
vector94:
  pushl $0
80106605:	6a 00                	push   $0x0
  pushl $94
80106607:	6a 5e                	push   $0x5e
  jmp alltraps
80106609:	e9 7c f7 ff ff       	jmp    80105d8a <alltraps>

8010660e <vector95>:
.globl vector95
vector95:
  pushl $0
8010660e:	6a 00                	push   $0x0
  pushl $95
80106610:	6a 5f                	push   $0x5f
  jmp alltraps
80106612:	e9 73 f7 ff ff       	jmp    80105d8a <alltraps>

80106617 <vector96>:
.globl vector96
vector96:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $96
80106619:	6a 60                	push   $0x60
  jmp alltraps
8010661b:	e9 6a f7 ff ff       	jmp    80105d8a <alltraps>

80106620 <vector97>:
.globl vector97
vector97:
  pushl $0
80106620:	6a 00                	push   $0x0
  pushl $97
80106622:	6a 61                	push   $0x61
  jmp alltraps
80106624:	e9 61 f7 ff ff       	jmp    80105d8a <alltraps>

80106629 <vector98>:
.globl vector98
vector98:
  pushl $0
80106629:	6a 00                	push   $0x0
  pushl $98
8010662b:	6a 62                	push   $0x62
  jmp alltraps
8010662d:	e9 58 f7 ff ff       	jmp    80105d8a <alltraps>

80106632 <vector99>:
.globl vector99
vector99:
  pushl $0
80106632:	6a 00                	push   $0x0
  pushl $99
80106634:	6a 63                	push   $0x63
  jmp alltraps
80106636:	e9 4f f7 ff ff       	jmp    80105d8a <alltraps>

8010663b <vector100>:
.globl vector100
vector100:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $100
8010663d:	6a 64                	push   $0x64
  jmp alltraps
8010663f:	e9 46 f7 ff ff       	jmp    80105d8a <alltraps>

80106644 <vector101>:
.globl vector101
vector101:
  pushl $0
80106644:	6a 00                	push   $0x0
  pushl $101
80106646:	6a 65                	push   $0x65
  jmp alltraps
80106648:	e9 3d f7 ff ff       	jmp    80105d8a <alltraps>

8010664d <vector102>:
.globl vector102
vector102:
  pushl $0
8010664d:	6a 00                	push   $0x0
  pushl $102
8010664f:	6a 66                	push   $0x66
  jmp alltraps
80106651:	e9 34 f7 ff ff       	jmp    80105d8a <alltraps>

80106656 <vector103>:
.globl vector103
vector103:
  pushl $0
80106656:	6a 00                	push   $0x0
  pushl $103
80106658:	6a 67                	push   $0x67
  jmp alltraps
8010665a:	e9 2b f7 ff ff       	jmp    80105d8a <alltraps>

8010665f <vector104>:
.globl vector104
vector104:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $104
80106661:	6a 68                	push   $0x68
  jmp alltraps
80106663:	e9 22 f7 ff ff       	jmp    80105d8a <alltraps>

80106668 <vector105>:
.globl vector105
vector105:
  pushl $0
80106668:	6a 00                	push   $0x0
  pushl $105
8010666a:	6a 69                	push   $0x69
  jmp alltraps
8010666c:	e9 19 f7 ff ff       	jmp    80105d8a <alltraps>

80106671 <vector106>:
.globl vector106
vector106:
  pushl $0
80106671:	6a 00                	push   $0x0
  pushl $106
80106673:	6a 6a                	push   $0x6a
  jmp alltraps
80106675:	e9 10 f7 ff ff       	jmp    80105d8a <alltraps>

8010667a <vector107>:
.globl vector107
vector107:
  pushl $0
8010667a:	6a 00                	push   $0x0
  pushl $107
8010667c:	6a 6b                	push   $0x6b
  jmp alltraps
8010667e:	e9 07 f7 ff ff       	jmp    80105d8a <alltraps>

80106683 <vector108>:
.globl vector108
vector108:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $108
80106685:	6a 6c                	push   $0x6c
  jmp alltraps
80106687:	e9 fe f6 ff ff       	jmp    80105d8a <alltraps>

8010668c <vector109>:
.globl vector109
vector109:
  pushl $0
8010668c:	6a 00                	push   $0x0
  pushl $109
8010668e:	6a 6d                	push   $0x6d
  jmp alltraps
80106690:	e9 f5 f6 ff ff       	jmp    80105d8a <alltraps>

80106695 <vector110>:
.globl vector110
vector110:
  pushl $0
80106695:	6a 00                	push   $0x0
  pushl $110
80106697:	6a 6e                	push   $0x6e
  jmp alltraps
80106699:	e9 ec f6 ff ff       	jmp    80105d8a <alltraps>

8010669e <vector111>:
.globl vector111
vector111:
  pushl $0
8010669e:	6a 00                	push   $0x0
  pushl $111
801066a0:	6a 6f                	push   $0x6f
  jmp alltraps
801066a2:	e9 e3 f6 ff ff       	jmp    80105d8a <alltraps>

801066a7 <vector112>:
.globl vector112
vector112:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $112
801066a9:	6a 70                	push   $0x70
  jmp alltraps
801066ab:	e9 da f6 ff ff       	jmp    80105d8a <alltraps>

801066b0 <vector113>:
.globl vector113
vector113:
  pushl $0
801066b0:	6a 00                	push   $0x0
  pushl $113
801066b2:	6a 71                	push   $0x71
  jmp alltraps
801066b4:	e9 d1 f6 ff ff       	jmp    80105d8a <alltraps>

801066b9 <vector114>:
.globl vector114
vector114:
  pushl $0
801066b9:	6a 00                	push   $0x0
  pushl $114
801066bb:	6a 72                	push   $0x72
  jmp alltraps
801066bd:	e9 c8 f6 ff ff       	jmp    80105d8a <alltraps>

801066c2 <vector115>:
.globl vector115
vector115:
  pushl $0
801066c2:	6a 00                	push   $0x0
  pushl $115
801066c4:	6a 73                	push   $0x73
  jmp alltraps
801066c6:	e9 bf f6 ff ff       	jmp    80105d8a <alltraps>

801066cb <vector116>:
.globl vector116
vector116:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $116
801066cd:	6a 74                	push   $0x74
  jmp alltraps
801066cf:	e9 b6 f6 ff ff       	jmp    80105d8a <alltraps>

801066d4 <vector117>:
.globl vector117
vector117:
  pushl $0
801066d4:	6a 00                	push   $0x0
  pushl $117
801066d6:	6a 75                	push   $0x75
  jmp alltraps
801066d8:	e9 ad f6 ff ff       	jmp    80105d8a <alltraps>

801066dd <vector118>:
.globl vector118
vector118:
  pushl $0
801066dd:	6a 00                	push   $0x0
  pushl $118
801066df:	6a 76                	push   $0x76
  jmp alltraps
801066e1:	e9 a4 f6 ff ff       	jmp    80105d8a <alltraps>

801066e6 <vector119>:
.globl vector119
vector119:
  pushl $0
801066e6:	6a 00                	push   $0x0
  pushl $119
801066e8:	6a 77                	push   $0x77
  jmp alltraps
801066ea:	e9 9b f6 ff ff       	jmp    80105d8a <alltraps>

801066ef <vector120>:
.globl vector120
vector120:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $120
801066f1:	6a 78                	push   $0x78
  jmp alltraps
801066f3:	e9 92 f6 ff ff       	jmp    80105d8a <alltraps>

801066f8 <vector121>:
.globl vector121
vector121:
  pushl $0
801066f8:	6a 00                	push   $0x0
  pushl $121
801066fa:	6a 79                	push   $0x79
  jmp alltraps
801066fc:	e9 89 f6 ff ff       	jmp    80105d8a <alltraps>

80106701 <vector122>:
.globl vector122
vector122:
  pushl $0
80106701:	6a 00                	push   $0x0
  pushl $122
80106703:	6a 7a                	push   $0x7a
  jmp alltraps
80106705:	e9 80 f6 ff ff       	jmp    80105d8a <alltraps>

8010670a <vector123>:
.globl vector123
vector123:
  pushl $0
8010670a:	6a 00                	push   $0x0
  pushl $123
8010670c:	6a 7b                	push   $0x7b
  jmp alltraps
8010670e:	e9 77 f6 ff ff       	jmp    80105d8a <alltraps>

80106713 <vector124>:
.globl vector124
vector124:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $124
80106715:	6a 7c                	push   $0x7c
  jmp alltraps
80106717:	e9 6e f6 ff ff       	jmp    80105d8a <alltraps>

8010671c <vector125>:
.globl vector125
vector125:
  pushl $0
8010671c:	6a 00                	push   $0x0
  pushl $125
8010671e:	6a 7d                	push   $0x7d
  jmp alltraps
80106720:	e9 65 f6 ff ff       	jmp    80105d8a <alltraps>

80106725 <vector126>:
.globl vector126
vector126:
  pushl $0
80106725:	6a 00                	push   $0x0
  pushl $126
80106727:	6a 7e                	push   $0x7e
  jmp alltraps
80106729:	e9 5c f6 ff ff       	jmp    80105d8a <alltraps>

8010672e <vector127>:
.globl vector127
vector127:
  pushl $0
8010672e:	6a 00                	push   $0x0
  pushl $127
80106730:	6a 7f                	push   $0x7f
  jmp alltraps
80106732:	e9 53 f6 ff ff       	jmp    80105d8a <alltraps>

80106737 <vector128>:
.globl vector128
vector128:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $128
80106739:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010673e:	e9 47 f6 ff ff       	jmp    80105d8a <alltraps>

80106743 <vector129>:
.globl vector129
vector129:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $129
80106745:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010674a:	e9 3b f6 ff ff       	jmp    80105d8a <alltraps>

8010674f <vector130>:
.globl vector130
vector130:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $130
80106751:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106756:	e9 2f f6 ff ff       	jmp    80105d8a <alltraps>

8010675b <vector131>:
.globl vector131
vector131:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $131
8010675d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106762:	e9 23 f6 ff ff       	jmp    80105d8a <alltraps>

80106767 <vector132>:
.globl vector132
vector132:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $132
80106769:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010676e:	e9 17 f6 ff ff       	jmp    80105d8a <alltraps>

80106773 <vector133>:
.globl vector133
vector133:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $133
80106775:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010677a:	e9 0b f6 ff ff       	jmp    80105d8a <alltraps>

8010677f <vector134>:
.globl vector134
vector134:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $134
80106781:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106786:	e9 ff f5 ff ff       	jmp    80105d8a <alltraps>

8010678b <vector135>:
.globl vector135
vector135:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $135
8010678d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106792:	e9 f3 f5 ff ff       	jmp    80105d8a <alltraps>

80106797 <vector136>:
.globl vector136
vector136:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $136
80106799:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010679e:	e9 e7 f5 ff ff       	jmp    80105d8a <alltraps>

801067a3 <vector137>:
.globl vector137
vector137:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $137
801067a5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801067aa:	e9 db f5 ff ff       	jmp    80105d8a <alltraps>

801067af <vector138>:
.globl vector138
vector138:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $138
801067b1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801067b6:	e9 cf f5 ff ff       	jmp    80105d8a <alltraps>

801067bb <vector139>:
.globl vector139
vector139:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $139
801067bd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801067c2:	e9 c3 f5 ff ff       	jmp    80105d8a <alltraps>

801067c7 <vector140>:
.globl vector140
vector140:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $140
801067c9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801067ce:	e9 b7 f5 ff ff       	jmp    80105d8a <alltraps>

801067d3 <vector141>:
.globl vector141
vector141:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $141
801067d5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801067da:	e9 ab f5 ff ff       	jmp    80105d8a <alltraps>

801067df <vector142>:
.globl vector142
vector142:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $142
801067e1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801067e6:	e9 9f f5 ff ff       	jmp    80105d8a <alltraps>

801067eb <vector143>:
.globl vector143
vector143:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $143
801067ed:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801067f2:	e9 93 f5 ff ff       	jmp    80105d8a <alltraps>

801067f7 <vector144>:
.globl vector144
vector144:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $144
801067f9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801067fe:	e9 87 f5 ff ff       	jmp    80105d8a <alltraps>

80106803 <vector145>:
.globl vector145
vector145:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $145
80106805:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010680a:	e9 7b f5 ff ff       	jmp    80105d8a <alltraps>

8010680f <vector146>:
.globl vector146
vector146:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $146
80106811:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106816:	e9 6f f5 ff ff       	jmp    80105d8a <alltraps>

8010681b <vector147>:
.globl vector147
vector147:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $147
8010681d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106822:	e9 63 f5 ff ff       	jmp    80105d8a <alltraps>

80106827 <vector148>:
.globl vector148
vector148:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $148
80106829:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010682e:	e9 57 f5 ff ff       	jmp    80105d8a <alltraps>

80106833 <vector149>:
.globl vector149
vector149:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $149
80106835:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010683a:	e9 4b f5 ff ff       	jmp    80105d8a <alltraps>

8010683f <vector150>:
.globl vector150
vector150:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $150
80106841:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106846:	e9 3f f5 ff ff       	jmp    80105d8a <alltraps>

8010684b <vector151>:
.globl vector151
vector151:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $151
8010684d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106852:	e9 33 f5 ff ff       	jmp    80105d8a <alltraps>

80106857 <vector152>:
.globl vector152
vector152:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $152
80106859:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010685e:	e9 27 f5 ff ff       	jmp    80105d8a <alltraps>

80106863 <vector153>:
.globl vector153
vector153:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $153
80106865:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010686a:	e9 1b f5 ff ff       	jmp    80105d8a <alltraps>

8010686f <vector154>:
.globl vector154
vector154:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $154
80106871:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106876:	e9 0f f5 ff ff       	jmp    80105d8a <alltraps>

8010687b <vector155>:
.globl vector155
vector155:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $155
8010687d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106882:	e9 03 f5 ff ff       	jmp    80105d8a <alltraps>

80106887 <vector156>:
.globl vector156
vector156:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $156
80106889:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010688e:	e9 f7 f4 ff ff       	jmp    80105d8a <alltraps>

80106893 <vector157>:
.globl vector157
vector157:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $157
80106895:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010689a:	e9 eb f4 ff ff       	jmp    80105d8a <alltraps>

8010689f <vector158>:
.globl vector158
vector158:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $158
801068a1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801068a6:	e9 df f4 ff ff       	jmp    80105d8a <alltraps>

801068ab <vector159>:
.globl vector159
vector159:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $159
801068ad:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801068b2:	e9 d3 f4 ff ff       	jmp    80105d8a <alltraps>

801068b7 <vector160>:
.globl vector160
vector160:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $160
801068b9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801068be:	e9 c7 f4 ff ff       	jmp    80105d8a <alltraps>

801068c3 <vector161>:
.globl vector161
vector161:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $161
801068c5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801068ca:	e9 bb f4 ff ff       	jmp    80105d8a <alltraps>

801068cf <vector162>:
.globl vector162
vector162:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $162
801068d1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801068d6:	e9 af f4 ff ff       	jmp    80105d8a <alltraps>

801068db <vector163>:
.globl vector163
vector163:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $163
801068dd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801068e2:	e9 a3 f4 ff ff       	jmp    80105d8a <alltraps>

801068e7 <vector164>:
.globl vector164
vector164:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $164
801068e9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801068ee:	e9 97 f4 ff ff       	jmp    80105d8a <alltraps>

801068f3 <vector165>:
.globl vector165
vector165:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $165
801068f5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801068fa:	e9 8b f4 ff ff       	jmp    80105d8a <alltraps>

801068ff <vector166>:
.globl vector166
vector166:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $166
80106901:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106906:	e9 7f f4 ff ff       	jmp    80105d8a <alltraps>

8010690b <vector167>:
.globl vector167
vector167:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $167
8010690d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106912:	e9 73 f4 ff ff       	jmp    80105d8a <alltraps>

80106917 <vector168>:
.globl vector168
vector168:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $168
80106919:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010691e:	e9 67 f4 ff ff       	jmp    80105d8a <alltraps>

80106923 <vector169>:
.globl vector169
vector169:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $169
80106925:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010692a:	e9 5b f4 ff ff       	jmp    80105d8a <alltraps>

8010692f <vector170>:
.globl vector170
vector170:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $170
80106931:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106936:	e9 4f f4 ff ff       	jmp    80105d8a <alltraps>

8010693b <vector171>:
.globl vector171
vector171:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $171
8010693d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106942:	e9 43 f4 ff ff       	jmp    80105d8a <alltraps>

80106947 <vector172>:
.globl vector172
vector172:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $172
80106949:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010694e:	e9 37 f4 ff ff       	jmp    80105d8a <alltraps>

80106953 <vector173>:
.globl vector173
vector173:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $173
80106955:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010695a:	e9 2b f4 ff ff       	jmp    80105d8a <alltraps>

8010695f <vector174>:
.globl vector174
vector174:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $174
80106961:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106966:	e9 1f f4 ff ff       	jmp    80105d8a <alltraps>

8010696b <vector175>:
.globl vector175
vector175:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $175
8010696d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106972:	e9 13 f4 ff ff       	jmp    80105d8a <alltraps>

80106977 <vector176>:
.globl vector176
vector176:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $176
80106979:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010697e:	e9 07 f4 ff ff       	jmp    80105d8a <alltraps>

80106983 <vector177>:
.globl vector177
vector177:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $177
80106985:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010698a:	e9 fb f3 ff ff       	jmp    80105d8a <alltraps>

8010698f <vector178>:
.globl vector178
vector178:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $178
80106991:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106996:	e9 ef f3 ff ff       	jmp    80105d8a <alltraps>

8010699b <vector179>:
.globl vector179
vector179:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $179
8010699d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801069a2:	e9 e3 f3 ff ff       	jmp    80105d8a <alltraps>

801069a7 <vector180>:
.globl vector180
vector180:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $180
801069a9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801069ae:	e9 d7 f3 ff ff       	jmp    80105d8a <alltraps>

801069b3 <vector181>:
.globl vector181
vector181:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $181
801069b5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801069ba:	e9 cb f3 ff ff       	jmp    80105d8a <alltraps>

801069bf <vector182>:
.globl vector182
vector182:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $182
801069c1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801069c6:	e9 bf f3 ff ff       	jmp    80105d8a <alltraps>

801069cb <vector183>:
.globl vector183
vector183:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $183
801069cd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801069d2:	e9 b3 f3 ff ff       	jmp    80105d8a <alltraps>

801069d7 <vector184>:
.globl vector184
vector184:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $184
801069d9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801069de:	e9 a7 f3 ff ff       	jmp    80105d8a <alltraps>

801069e3 <vector185>:
.globl vector185
vector185:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $185
801069e5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801069ea:	e9 9b f3 ff ff       	jmp    80105d8a <alltraps>

801069ef <vector186>:
.globl vector186
vector186:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $186
801069f1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801069f6:	e9 8f f3 ff ff       	jmp    80105d8a <alltraps>

801069fb <vector187>:
.globl vector187
vector187:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $187
801069fd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106a02:	e9 83 f3 ff ff       	jmp    80105d8a <alltraps>

80106a07 <vector188>:
.globl vector188
vector188:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $188
80106a09:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106a0e:	e9 77 f3 ff ff       	jmp    80105d8a <alltraps>

80106a13 <vector189>:
.globl vector189
vector189:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $189
80106a15:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106a1a:	e9 6b f3 ff ff       	jmp    80105d8a <alltraps>

80106a1f <vector190>:
.globl vector190
vector190:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $190
80106a21:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106a26:	e9 5f f3 ff ff       	jmp    80105d8a <alltraps>

80106a2b <vector191>:
.globl vector191
vector191:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $191
80106a2d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106a32:	e9 53 f3 ff ff       	jmp    80105d8a <alltraps>

80106a37 <vector192>:
.globl vector192
vector192:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $192
80106a39:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106a3e:	e9 47 f3 ff ff       	jmp    80105d8a <alltraps>

80106a43 <vector193>:
.globl vector193
vector193:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $193
80106a45:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106a4a:	e9 3b f3 ff ff       	jmp    80105d8a <alltraps>

80106a4f <vector194>:
.globl vector194
vector194:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $194
80106a51:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106a56:	e9 2f f3 ff ff       	jmp    80105d8a <alltraps>

80106a5b <vector195>:
.globl vector195
vector195:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $195
80106a5d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106a62:	e9 23 f3 ff ff       	jmp    80105d8a <alltraps>

80106a67 <vector196>:
.globl vector196
vector196:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $196
80106a69:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106a6e:	e9 17 f3 ff ff       	jmp    80105d8a <alltraps>

80106a73 <vector197>:
.globl vector197
vector197:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $197
80106a75:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106a7a:	e9 0b f3 ff ff       	jmp    80105d8a <alltraps>

80106a7f <vector198>:
.globl vector198
vector198:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $198
80106a81:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106a86:	e9 ff f2 ff ff       	jmp    80105d8a <alltraps>

80106a8b <vector199>:
.globl vector199
vector199:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $199
80106a8d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106a92:	e9 f3 f2 ff ff       	jmp    80105d8a <alltraps>

80106a97 <vector200>:
.globl vector200
vector200:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $200
80106a99:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106a9e:	e9 e7 f2 ff ff       	jmp    80105d8a <alltraps>

80106aa3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $201
80106aa5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106aaa:	e9 db f2 ff ff       	jmp    80105d8a <alltraps>

80106aaf <vector202>:
.globl vector202
vector202:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $202
80106ab1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106ab6:	e9 cf f2 ff ff       	jmp    80105d8a <alltraps>

80106abb <vector203>:
.globl vector203
vector203:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $203
80106abd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106ac2:	e9 c3 f2 ff ff       	jmp    80105d8a <alltraps>

80106ac7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $204
80106ac9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106ace:	e9 b7 f2 ff ff       	jmp    80105d8a <alltraps>

80106ad3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $205
80106ad5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106ada:	e9 ab f2 ff ff       	jmp    80105d8a <alltraps>

80106adf <vector206>:
.globl vector206
vector206:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $206
80106ae1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106ae6:	e9 9f f2 ff ff       	jmp    80105d8a <alltraps>

80106aeb <vector207>:
.globl vector207
vector207:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $207
80106aed:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106af2:	e9 93 f2 ff ff       	jmp    80105d8a <alltraps>

80106af7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $208
80106af9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106afe:	e9 87 f2 ff ff       	jmp    80105d8a <alltraps>

80106b03 <vector209>:
.globl vector209
vector209:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $209
80106b05:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106b0a:	e9 7b f2 ff ff       	jmp    80105d8a <alltraps>

80106b0f <vector210>:
.globl vector210
vector210:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $210
80106b11:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106b16:	e9 6f f2 ff ff       	jmp    80105d8a <alltraps>

80106b1b <vector211>:
.globl vector211
vector211:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $211
80106b1d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106b22:	e9 63 f2 ff ff       	jmp    80105d8a <alltraps>

80106b27 <vector212>:
.globl vector212
vector212:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $212
80106b29:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106b2e:	e9 57 f2 ff ff       	jmp    80105d8a <alltraps>

80106b33 <vector213>:
.globl vector213
vector213:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $213
80106b35:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106b3a:	e9 4b f2 ff ff       	jmp    80105d8a <alltraps>

80106b3f <vector214>:
.globl vector214
vector214:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $214
80106b41:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106b46:	e9 3f f2 ff ff       	jmp    80105d8a <alltraps>

80106b4b <vector215>:
.globl vector215
vector215:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $215
80106b4d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106b52:	e9 33 f2 ff ff       	jmp    80105d8a <alltraps>

80106b57 <vector216>:
.globl vector216
vector216:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $216
80106b59:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106b5e:	e9 27 f2 ff ff       	jmp    80105d8a <alltraps>

80106b63 <vector217>:
.globl vector217
vector217:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $217
80106b65:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106b6a:	e9 1b f2 ff ff       	jmp    80105d8a <alltraps>

80106b6f <vector218>:
.globl vector218
vector218:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $218
80106b71:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106b76:	e9 0f f2 ff ff       	jmp    80105d8a <alltraps>

80106b7b <vector219>:
.globl vector219
vector219:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $219
80106b7d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106b82:	e9 03 f2 ff ff       	jmp    80105d8a <alltraps>

80106b87 <vector220>:
.globl vector220
vector220:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $220
80106b89:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106b8e:	e9 f7 f1 ff ff       	jmp    80105d8a <alltraps>

80106b93 <vector221>:
.globl vector221
vector221:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $221
80106b95:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106b9a:	e9 eb f1 ff ff       	jmp    80105d8a <alltraps>

80106b9f <vector222>:
.globl vector222
vector222:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $222
80106ba1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106ba6:	e9 df f1 ff ff       	jmp    80105d8a <alltraps>

80106bab <vector223>:
.globl vector223
vector223:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $223
80106bad:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106bb2:	e9 d3 f1 ff ff       	jmp    80105d8a <alltraps>

80106bb7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $224
80106bb9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106bbe:	e9 c7 f1 ff ff       	jmp    80105d8a <alltraps>

80106bc3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $225
80106bc5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106bca:	e9 bb f1 ff ff       	jmp    80105d8a <alltraps>

80106bcf <vector226>:
.globl vector226
vector226:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $226
80106bd1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106bd6:	e9 af f1 ff ff       	jmp    80105d8a <alltraps>

80106bdb <vector227>:
.globl vector227
vector227:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $227
80106bdd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106be2:	e9 a3 f1 ff ff       	jmp    80105d8a <alltraps>

80106be7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $228
80106be9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106bee:	e9 97 f1 ff ff       	jmp    80105d8a <alltraps>

80106bf3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $229
80106bf5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106bfa:	e9 8b f1 ff ff       	jmp    80105d8a <alltraps>

80106bff <vector230>:
.globl vector230
vector230:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $230
80106c01:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106c06:	e9 7f f1 ff ff       	jmp    80105d8a <alltraps>

80106c0b <vector231>:
.globl vector231
vector231:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $231
80106c0d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106c12:	e9 73 f1 ff ff       	jmp    80105d8a <alltraps>

80106c17 <vector232>:
.globl vector232
vector232:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $232
80106c19:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106c1e:	e9 67 f1 ff ff       	jmp    80105d8a <alltraps>

80106c23 <vector233>:
.globl vector233
vector233:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $233
80106c25:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106c2a:	e9 5b f1 ff ff       	jmp    80105d8a <alltraps>

80106c2f <vector234>:
.globl vector234
vector234:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $234
80106c31:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106c36:	e9 4f f1 ff ff       	jmp    80105d8a <alltraps>

80106c3b <vector235>:
.globl vector235
vector235:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $235
80106c3d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106c42:	e9 43 f1 ff ff       	jmp    80105d8a <alltraps>

80106c47 <vector236>:
.globl vector236
vector236:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $236
80106c49:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106c4e:	e9 37 f1 ff ff       	jmp    80105d8a <alltraps>

80106c53 <vector237>:
.globl vector237
vector237:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $237
80106c55:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106c5a:	e9 2b f1 ff ff       	jmp    80105d8a <alltraps>

80106c5f <vector238>:
.globl vector238
vector238:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $238
80106c61:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106c66:	e9 1f f1 ff ff       	jmp    80105d8a <alltraps>

80106c6b <vector239>:
.globl vector239
vector239:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $239
80106c6d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106c72:	e9 13 f1 ff ff       	jmp    80105d8a <alltraps>

80106c77 <vector240>:
.globl vector240
vector240:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $240
80106c79:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106c7e:	e9 07 f1 ff ff       	jmp    80105d8a <alltraps>

80106c83 <vector241>:
.globl vector241
vector241:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $241
80106c85:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106c8a:	e9 fb f0 ff ff       	jmp    80105d8a <alltraps>

80106c8f <vector242>:
.globl vector242
vector242:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $242
80106c91:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106c96:	e9 ef f0 ff ff       	jmp    80105d8a <alltraps>

80106c9b <vector243>:
.globl vector243
vector243:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $243
80106c9d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106ca2:	e9 e3 f0 ff ff       	jmp    80105d8a <alltraps>

80106ca7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $244
80106ca9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106cae:	e9 d7 f0 ff ff       	jmp    80105d8a <alltraps>

80106cb3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $245
80106cb5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106cba:	e9 cb f0 ff ff       	jmp    80105d8a <alltraps>

80106cbf <vector246>:
.globl vector246
vector246:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $246
80106cc1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106cc6:	e9 bf f0 ff ff       	jmp    80105d8a <alltraps>

80106ccb <vector247>:
.globl vector247
vector247:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $247
80106ccd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106cd2:	e9 b3 f0 ff ff       	jmp    80105d8a <alltraps>

80106cd7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $248
80106cd9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106cde:	e9 a7 f0 ff ff       	jmp    80105d8a <alltraps>

80106ce3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $249
80106ce5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106cea:	e9 9b f0 ff ff       	jmp    80105d8a <alltraps>

80106cef <vector250>:
.globl vector250
vector250:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $250
80106cf1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106cf6:	e9 8f f0 ff ff       	jmp    80105d8a <alltraps>

80106cfb <vector251>:
.globl vector251
vector251:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $251
80106cfd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106d02:	e9 83 f0 ff ff       	jmp    80105d8a <alltraps>

80106d07 <vector252>:
.globl vector252
vector252:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $252
80106d09:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106d0e:	e9 77 f0 ff ff       	jmp    80105d8a <alltraps>

80106d13 <vector253>:
.globl vector253
vector253:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $253
80106d15:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106d1a:	e9 6b f0 ff ff       	jmp    80105d8a <alltraps>

80106d1f <vector254>:
.globl vector254
vector254:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $254
80106d21:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106d26:	e9 5f f0 ff ff       	jmp    80105d8a <alltraps>

80106d2b <vector255>:
.globl vector255
vector255:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $255
80106d2d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106d32:	e9 53 f0 ff ff       	jmp    80105d8a <alltraps>
80106d37:	66 90                	xchg   %ax,%ax
80106d39:	66 90                	xchg   %ax,%ax
80106d3b:	66 90                	xchg   %ax,%ax
80106d3d:	66 90                	xchg   %ax,%ax
80106d3f:	90                   	nop

80106d40 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	57                   	push   %edi
80106d44:	56                   	push   %esi
80106d45:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106d46:	89 d3                	mov    %edx,%ebx
{
80106d48:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106d4a:	c1 eb 16             	shr    $0x16,%ebx
80106d4d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106d50:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106d53:	8b 06                	mov    (%esi),%eax
80106d55:	a8 01                	test   $0x1,%al
80106d57:	74 27                	je     80106d80 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d59:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d5e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106d64:	c1 ef 0a             	shr    $0xa,%edi
}
80106d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106d6a:	89 fa                	mov    %edi,%edx
80106d6c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106d72:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106d75:	5b                   	pop    %ebx
80106d76:	5e                   	pop    %esi
80106d77:	5f                   	pop    %edi
80106d78:	5d                   	pop    %ebp
80106d79:	c3                   	ret    
80106d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106d80:	85 c9                	test   %ecx,%ecx
80106d82:	74 2c                	je     80106db0 <walkpgdir+0x70>
80106d84:	e8 57 b7 ff ff       	call   801024e0 <kalloc>
80106d89:	85 c0                	test   %eax,%eax
80106d8b:	89 c3                	mov    %eax,%ebx
80106d8d:	74 21                	je     80106db0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106d8f:	83 ec 04             	sub    $0x4,%esp
80106d92:	68 00 10 00 00       	push   $0x1000
80106d97:	6a 00                	push   $0x0
80106d99:	50                   	push   %eax
80106d9a:	e8 11 dd ff ff       	call   80104ab0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d9f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106da5:	83 c4 10             	add    $0x10,%esp
80106da8:	83 c8 07             	or     $0x7,%eax
80106dab:	89 06                	mov    %eax,(%esi)
80106dad:	eb b5                	jmp    80106d64 <walkpgdir+0x24>
80106daf:	90                   	nop
}
80106db0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106db3:	31 c0                	xor    %eax,%eax
}
80106db5:	5b                   	pop    %ebx
80106db6:	5e                   	pop    %esi
80106db7:	5f                   	pop    %edi
80106db8:	5d                   	pop    %ebp
80106db9:	c3                   	ret    
80106dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106dc0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106dc0:	55                   	push   %ebp
80106dc1:	89 e5                	mov    %esp,%ebp
80106dc3:	57                   	push   %edi
80106dc4:	56                   	push   %esi
80106dc5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106dc6:	89 d3                	mov    %edx,%ebx
80106dc8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106dce:	83 ec 1c             	sub    $0x1c,%esp
80106dd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106dd4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106dd8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106ddb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106de0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106de3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106de6:	29 df                	sub    %ebx,%edi
80106de8:	83 c8 01             	or     $0x1,%eax
80106deb:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106dee:	eb 15                	jmp    80106e05 <mappages+0x45>
    if(*pte & PTE_P)
80106df0:	f6 00 01             	testb  $0x1,(%eax)
80106df3:	75 45                	jne    80106e3a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106df5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106df8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106dfb:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106dfd:	74 31                	je     80106e30 <mappages+0x70>
      break;
    a += PGSIZE;
80106dff:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106e05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e08:	b9 01 00 00 00       	mov    $0x1,%ecx
80106e0d:	89 da                	mov    %ebx,%edx
80106e0f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106e12:	e8 29 ff ff ff       	call   80106d40 <walkpgdir>
80106e17:	85 c0                	test   %eax,%eax
80106e19:	75 d5                	jne    80106df0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106e1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e23:	5b                   	pop    %ebx
80106e24:	5e                   	pop    %esi
80106e25:	5f                   	pop    %edi
80106e26:	5d                   	pop    %ebp
80106e27:	c3                   	ret    
80106e28:	90                   	nop
80106e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e33:	31 c0                	xor    %eax,%eax
}
80106e35:	5b                   	pop    %ebx
80106e36:	5e                   	pop    %esi
80106e37:	5f                   	pop    %edi
80106e38:	5d                   	pop    %ebp
80106e39:	c3                   	ret    
      panic("remap");
80106e3a:	83 ec 0c             	sub    $0xc,%esp
80106e3d:	68 64 7f 10 80       	push   $0x80107f64
80106e42:	e8 49 95 ff ff       	call   80100390 <panic>
80106e47:	89 f6                	mov    %esi,%esi
80106e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e50 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e50:	55                   	push   %ebp
80106e51:	89 e5                	mov    %esp,%ebp
80106e53:	57                   	push   %edi
80106e54:	56                   	push   %esi
80106e55:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106e56:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e5c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106e5e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e64:	83 ec 1c             	sub    $0x1c,%esp
80106e67:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106e6a:	39 d3                	cmp    %edx,%ebx
80106e6c:	73 66                	jae    80106ed4 <deallocuvm.part.0+0x84>
80106e6e:	89 d6                	mov    %edx,%esi
80106e70:	eb 3d                	jmp    80106eaf <deallocuvm.part.0+0x5f>
80106e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106e78:	8b 10                	mov    (%eax),%edx
80106e7a:	f6 c2 01             	test   $0x1,%dl
80106e7d:	74 26                	je     80106ea5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106e7f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106e85:	74 58                	je     80106edf <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106e87:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106e8a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106e90:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106e93:	52                   	push   %edx
80106e94:	e8 97 b4 ff ff       	call   80102330 <kfree>
      *pte = 0;
80106e99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e9c:	83 c4 10             	add    $0x10,%esp
80106e9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106ea5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106eab:	39 f3                	cmp    %esi,%ebx
80106ead:	73 25                	jae    80106ed4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106eaf:	31 c9                	xor    %ecx,%ecx
80106eb1:	89 da                	mov    %ebx,%edx
80106eb3:	89 f8                	mov    %edi,%eax
80106eb5:	e8 86 fe ff ff       	call   80106d40 <walkpgdir>
    if(!pte)
80106eba:	85 c0                	test   %eax,%eax
80106ebc:	75 ba                	jne    80106e78 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106ebe:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106ec4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106eca:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ed0:	39 f3                	cmp    %esi,%ebx
80106ed2:	72 db                	jb     80106eaf <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106ed4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ed7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106eda:	5b                   	pop    %ebx
80106edb:	5e                   	pop    %esi
80106edc:	5f                   	pop    %edi
80106edd:	5d                   	pop    %ebp
80106ede:	c3                   	ret    
        panic("kfree");
80106edf:	83 ec 0c             	sub    $0xc,%esp
80106ee2:	68 e6 78 10 80       	push   $0x801078e6
80106ee7:	e8 a4 94 ff ff       	call   80100390 <panic>
80106eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ef0 <seginit>:
{
80106ef0:	55                   	push   %ebp
80106ef1:	89 e5                	mov    %esp,%ebp
80106ef3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106ef6:	e8 d5 c9 ff ff       	call   801038d0 <cpuid>
80106efb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106f01:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106f06:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106f0a:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
80106f11:	ff 00 00 
80106f14:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
80106f1b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106f1e:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
80106f25:	ff 00 00 
80106f28:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
80106f2f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106f32:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
80106f39:	ff 00 00 
80106f3c:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
80106f43:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106f46:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
80106f4d:	ff 00 00 
80106f50:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
80106f57:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106f5a:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
80106f5f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106f63:	c1 e8 10             	shr    $0x10,%eax
80106f66:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106f6a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106f6d:	0f 01 10             	lgdtl  (%eax)
}
80106f70:	c9                   	leave  
80106f71:	c3                   	ret    
80106f72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f80 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f80:	a1 a4 87 11 80       	mov    0x801187a4,%eax
{
80106f85:	55                   	push   %ebp
80106f86:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f88:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f8d:	0f 22 d8             	mov    %eax,%cr3
}
80106f90:	5d                   	pop    %ebp
80106f91:	c3                   	ret    
80106f92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fa0 <switchuvm>:
{
80106fa0:	55                   	push   %ebp
80106fa1:	89 e5                	mov    %esp,%ebp
80106fa3:	57                   	push   %edi
80106fa4:	56                   	push   %esi
80106fa5:	53                   	push   %ebx
80106fa6:	83 ec 1c             	sub    $0x1c,%esp
80106fa9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106fac:	85 db                	test   %ebx,%ebx
80106fae:	0f 84 d7 00 00 00    	je     8010708b <switchuvm+0xeb>
  if(p->kstack == 0)
80106fb4:	8b 83 94 00 00 00    	mov    0x94(%ebx),%eax
80106fba:	85 c0                	test   %eax,%eax
80106fbc:	0f 84 e3 00 00 00    	je     801070a5 <switchuvm+0x105>
  if(p->pgdir == 0)
80106fc2:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
80106fc8:	85 c0                	test   %eax,%eax
80106fca:	0f 84 c8 00 00 00    	je     80107098 <switchuvm+0xf8>
  pushcli();
80106fd0:	e8 fb d8 ff ff       	call   801048d0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106fd5:	e8 76 c8 ff ff       	call   80103850 <mycpu>
80106fda:	89 c6                	mov    %eax,%esi
80106fdc:	e8 6f c8 ff ff       	call   80103850 <mycpu>
80106fe1:	89 c7                	mov    %eax,%edi
80106fe3:	e8 68 c8 ff ff       	call   80103850 <mycpu>
80106fe8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106feb:	83 c7 08             	add    $0x8,%edi
80106fee:	e8 5d c8 ff ff       	call   80103850 <mycpu>
80106ff3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106ff6:	83 c0 08             	add    $0x8,%eax
80106ff9:	ba 67 00 00 00       	mov    $0x67,%edx
80106ffe:	c1 e8 18             	shr    $0x18,%eax
80107001:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107008:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
8010700f:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107015:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010701a:	83 c1 08             	add    $0x8,%ecx
8010701d:	c1 e9 10             	shr    $0x10,%ecx
80107020:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107026:	b9 99 40 00 00       	mov    $0x4099,%ecx
8010702b:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107032:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107037:	e8 14 c8 ff ff       	call   80103850 <mycpu>
8010703c:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107043:	e8 08 c8 ff ff       	call   80103850 <mycpu>
80107048:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010704c:	8b b3 94 00 00 00    	mov    0x94(%ebx),%esi
80107052:	e8 f9 c7 ff ff       	call   80103850 <mycpu>
80107057:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010705d:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107060:	e8 eb c7 ff ff       	call   80103850 <mycpu>
80107065:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107069:	b8 28 00 00 00       	mov    $0x28,%eax
8010706e:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107071:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
80107077:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010707c:	0f 22 d8             	mov    %eax,%cr3
}
8010707f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107082:	5b                   	pop    %ebx
80107083:	5e                   	pop    %esi
80107084:	5f                   	pop    %edi
80107085:	5d                   	pop    %ebp
  popcli();
80107086:	e9 85 d8 ff ff       	jmp    80104910 <popcli>
    panic("switchuvm: no process");
8010708b:	83 ec 0c             	sub    $0xc,%esp
8010708e:	68 6a 7f 10 80       	push   $0x80107f6a
80107093:	e8 f8 92 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107098:	83 ec 0c             	sub    $0xc,%esp
8010709b:	68 95 7f 10 80       	push   $0x80107f95
801070a0:	e8 eb 92 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801070a5:	83 ec 0c             	sub    $0xc,%esp
801070a8:	68 80 7f 10 80       	push   $0x80107f80
801070ad:	e8 de 92 ff ff       	call   80100390 <panic>
801070b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070c0 <inituvm>:
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	57                   	push   %edi
801070c4:	56                   	push   %esi
801070c5:	53                   	push   %ebx
801070c6:	83 ec 1c             	sub    $0x1c,%esp
801070c9:	8b 75 10             	mov    0x10(%ebp),%esi
801070cc:	8b 45 08             	mov    0x8(%ebp),%eax
801070cf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
801070d2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
801070d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801070db:	77 49                	ja     80107126 <inituvm+0x66>
  mem = kalloc();
801070dd:	e8 fe b3 ff ff       	call   801024e0 <kalloc>
  memset(mem, 0, PGSIZE);
801070e2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
801070e5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801070e7:	68 00 10 00 00       	push   $0x1000
801070ec:	6a 00                	push   $0x0
801070ee:	50                   	push   %eax
801070ef:	e8 bc d9 ff ff       	call   80104ab0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801070f4:	58                   	pop    %eax
801070f5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801070fb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107100:	5a                   	pop    %edx
80107101:	6a 06                	push   $0x6
80107103:	50                   	push   %eax
80107104:	31 d2                	xor    %edx,%edx
80107106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107109:	e8 b2 fc ff ff       	call   80106dc0 <mappages>
  memmove(mem, init, sz);
8010710e:	89 75 10             	mov    %esi,0x10(%ebp)
80107111:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107114:	83 c4 10             	add    $0x10,%esp
80107117:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010711a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010711d:	5b                   	pop    %ebx
8010711e:	5e                   	pop    %esi
8010711f:	5f                   	pop    %edi
80107120:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107121:	e9 3a da ff ff       	jmp    80104b60 <memmove>
    panic("inituvm: more than a page");
80107126:	83 ec 0c             	sub    $0xc,%esp
80107129:	68 a9 7f 10 80       	push   $0x80107fa9
8010712e:	e8 5d 92 ff ff       	call   80100390 <panic>
80107133:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107140 <loaduvm>:
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	57                   	push   %edi
80107144:	56                   	push   %esi
80107145:	53                   	push   %ebx
80107146:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107149:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107150:	0f 85 91 00 00 00    	jne    801071e7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107156:	8b 75 18             	mov    0x18(%ebp),%esi
80107159:	31 db                	xor    %ebx,%ebx
8010715b:	85 f6                	test   %esi,%esi
8010715d:	75 1a                	jne    80107179 <loaduvm+0x39>
8010715f:	eb 6f                	jmp    801071d0 <loaduvm+0x90>
80107161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107168:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010716e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107174:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107177:	76 57                	jbe    801071d0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107179:	8b 55 0c             	mov    0xc(%ebp),%edx
8010717c:	8b 45 08             	mov    0x8(%ebp),%eax
8010717f:	31 c9                	xor    %ecx,%ecx
80107181:	01 da                	add    %ebx,%edx
80107183:	e8 b8 fb ff ff       	call   80106d40 <walkpgdir>
80107188:	85 c0                	test   %eax,%eax
8010718a:	74 4e                	je     801071da <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
8010718c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010718e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107191:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107196:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010719b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801071a1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801071a4:	01 d9                	add    %ebx,%ecx
801071a6:	05 00 00 00 80       	add    $0x80000000,%eax
801071ab:	57                   	push   %edi
801071ac:	51                   	push   %ecx
801071ad:	50                   	push   %eax
801071ae:	ff 75 10             	pushl  0x10(%ebp)
801071b1:	e8 ba a7 ff ff       	call   80101970 <readi>
801071b6:	83 c4 10             	add    $0x10,%esp
801071b9:	39 f8                	cmp    %edi,%eax
801071bb:	74 ab                	je     80107168 <loaduvm+0x28>
}
801071bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801071c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071c5:	5b                   	pop    %ebx
801071c6:	5e                   	pop    %esi
801071c7:	5f                   	pop    %edi
801071c8:	5d                   	pop    %ebp
801071c9:	c3                   	ret    
801071ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801071d3:	31 c0                	xor    %eax,%eax
}
801071d5:	5b                   	pop    %ebx
801071d6:	5e                   	pop    %esi
801071d7:	5f                   	pop    %edi
801071d8:	5d                   	pop    %ebp
801071d9:	c3                   	ret    
      panic("loaduvm: address should exist");
801071da:	83 ec 0c             	sub    $0xc,%esp
801071dd:	68 c3 7f 10 80       	push   $0x80107fc3
801071e2:	e8 a9 91 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801071e7:	83 ec 0c             	sub    $0xc,%esp
801071ea:	68 64 80 10 80       	push   $0x80108064
801071ef:	e8 9c 91 ff ff       	call   80100390 <panic>
801071f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107200 <allocuvm>:
{
80107200:	55                   	push   %ebp
80107201:	89 e5                	mov    %esp,%ebp
80107203:	57                   	push   %edi
80107204:	56                   	push   %esi
80107205:	53                   	push   %ebx
80107206:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107209:	8b 7d 10             	mov    0x10(%ebp),%edi
8010720c:	85 ff                	test   %edi,%edi
8010720e:	0f 88 8e 00 00 00    	js     801072a2 <allocuvm+0xa2>
  if(newsz < oldsz)
80107214:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107217:	0f 82 93 00 00 00    	jb     801072b0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010721d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107220:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107226:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010722c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010722f:	0f 86 7e 00 00 00    	jbe    801072b3 <allocuvm+0xb3>
80107235:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107238:	8b 7d 08             	mov    0x8(%ebp),%edi
8010723b:	eb 42                	jmp    8010727f <allocuvm+0x7f>
8010723d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107240:	83 ec 04             	sub    $0x4,%esp
80107243:	68 00 10 00 00       	push   $0x1000
80107248:	6a 00                	push   $0x0
8010724a:	50                   	push   %eax
8010724b:	e8 60 d8 ff ff       	call   80104ab0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107250:	58                   	pop    %eax
80107251:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107257:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010725c:	5a                   	pop    %edx
8010725d:	6a 06                	push   $0x6
8010725f:	50                   	push   %eax
80107260:	89 da                	mov    %ebx,%edx
80107262:	89 f8                	mov    %edi,%eax
80107264:	e8 57 fb ff ff       	call   80106dc0 <mappages>
80107269:	83 c4 10             	add    $0x10,%esp
8010726c:	85 c0                	test   %eax,%eax
8010726e:	78 50                	js     801072c0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107270:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107276:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107279:	0f 86 81 00 00 00    	jbe    80107300 <allocuvm+0x100>
    mem = kalloc();
8010727f:	e8 5c b2 ff ff       	call   801024e0 <kalloc>
    if(mem == 0){
80107284:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107286:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107288:	75 b6                	jne    80107240 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010728a:	83 ec 0c             	sub    $0xc,%esp
8010728d:	68 e1 7f 10 80       	push   $0x80107fe1
80107292:	e8 c9 93 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107297:	83 c4 10             	add    $0x10,%esp
8010729a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010729d:	39 45 10             	cmp    %eax,0x10(%ebp)
801072a0:	77 6e                	ja     80107310 <allocuvm+0x110>
}
801072a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801072a5:	31 ff                	xor    %edi,%edi
}
801072a7:	89 f8                	mov    %edi,%eax
801072a9:	5b                   	pop    %ebx
801072aa:	5e                   	pop    %esi
801072ab:	5f                   	pop    %edi
801072ac:	5d                   	pop    %ebp
801072ad:	c3                   	ret    
801072ae:	66 90                	xchg   %ax,%ax
    return oldsz;
801072b0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801072b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072b6:	89 f8                	mov    %edi,%eax
801072b8:	5b                   	pop    %ebx
801072b9:	5e                   	pop    %esi
801072ba:	5f                   	pop    %edi
801072bb:	5d                   	pop    %ebp
801072bc:	c3                   	ret    
801072bd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801072c0:	83 ec 0c             	sub    $0xc,%esp
801072c3:	68 f9 7f 10 80       	push   $0x80107ff9
801072c8:	e8 93 93 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801072cd:	83 c4 10             	add    $0x10,%esp
801072d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801072d3:	39 45 10             	cmp    %eax,0x10(%ebp)
801072d6:	76 0d                	jbe    801072e5 <allocuvm+0xe5>
801072d8:	89 c1                	mov    %eax,%ecx
801072da:	8b 55 10             	mov    0x10(%ebp),%edx
801072dd:	8b 45 08             	mov    0x8(%ebp),%eax
801072e0:	e8 6b fb ff ff       	call   80106e50 <deallocuvm.part.0>
      kfree(mem);
801072e5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
801072e8:	31 ff                	xor    %edi,%edi
      kfree(mem);
801072ea:	56                   	push   %esi
801072eb:	e8 40 b0 ff ff       	call   80102330 <kfree>
      return 0;
801072f0:	83 c4 10             	add    $0x10,%esp
}
801072f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072f6:	89 f8                	mov    %edi,%eax
801072f8:	5b                   	pop    %ebx
801072f9:	5e                   	pop    %esi
801072fa:	5f                   	pop    %edi
801072fb:	5d                   	pop    %ebp
801072fc:	c3                   	ret    
801072fd:	8d 76 00             	lea    0x0(%esi),%esi
80107300:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107303:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107306:	5b                   	pop    %ebx
80107307:	89 f8                	mov    %edi,%eax
80107309:	5e                   	pop    %esi
8010730a:	5f                   	pop    %edi
8010730b:	5d                   	pop    %ebp
8010730c:	c3                   	ret    
8010730d:	8d 76 00             	lea    0x0(%esi),%esi
80107310:	89 c1                	mov    %eax,%ecx
80107312:	8b 55 10             	mov    0x10(%ebp),%edx
80107315:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107318:	31 ff                	xor    %edi,%edi
8010731a:	e8 31 fb ff ff       	call   80106e50 <deallocuvm.part.0>
8010731f:	eb 92                	jmp    801072b3 <allocuvm+0xb3>
80107321:	eb 0d                	jmp    80107330 <deallocuvm>
80107323:	90                   	nop
80107324:	90                   	nop
80107325:	90                   	nop
80107326:	90                   	nop
80107327:	90                   	nop
80107328:	90                   	nop
80107329:	90                   	nop
8010732a:	90                   	nop
8010732b:	90                   	nop
8010732c:	90                   	nop
8010732d:	90                   	nop
8010732e:	90                   	nop
8010732f:	90                   	nop

80107330 <deallocuvm>:
{
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	8b 55 0c             	mov    0xc(%ebp),%edx
80107336:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107339:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010733c:	39 d1                	cmp    %edx,%ecx
8010733e:	73 10                	jae    80107350 <deallocuvm+0x20>
}
80107340:	5d                   	pop    %ebp
80107341:	e9 0a fb ff ff       	jmp    80106e50 <deallocuvm.part.0>
80107346:	8d 76 00             	lea    0x0(%esi),%esi
80107349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107350:	89 d0                	mov    %edx,%eax
80107352:	5d                   	pop    %ebp
80107353:	c3                   	ret    
80107354:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010735a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107360 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107360:	55                   	push   %ebp
80107361:	89 e5                	mov    %esp,%ebp
80107363:	57                   	push   %edi
80107364:	56                   	push   %esi
80107365:	53                   	push   %ebx
80107366:	83 ec 0c             	sub    $0xc,%esp
80107369:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010736c:	85 f6                	test   %esi,%esi
8010736e:	74 59                	je     801073c9 <freevm+0x69>
80107370:	31 c9                	xor    %ecx,%ecx
80107372:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107377:	89 f0                	mov    %esi,%eax
80107379:	e8 d2 fa ff ff       	call   80106e50 <deallocuvm.part.0>
8010737e:	89 f3                	mov    %esi,%ebx
80107380:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107386:	eb 0f                	jmp    80107397 <freevm+0x37>
80107388:	90                   	nop
80107389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107390:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107393:	39 fb                	cmp    %edi,%ebx
80107395:	74 23                	je     801073ba <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107397:	8b 03                	mov    (%ebx),%eax
80107399:	a8 01                	test   $0x1,%al
8010739b:	74 f3                	je     80107390 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010739d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801073a2:	83 ec 0c             	sub    $0xc,%esp
801073a5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801073a8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801073ad:	50                   	push   %eax
801073ae:	e8 7d af ff ff       	call   80102330 <kfree>
801073b3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801073b6:	39 fb                	cmp    %edi,%ebx
801073b8:	75 dd                	jne    80107397 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801073ba:	89 75 08             	mov    %esi,0x8(%ebp)
}
801073bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073c0:	5b                   	pop    %ebx
801073c1:	5e                   	pop    %esi
801073c2:	5f                   	pop    %edi
801073c3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801073c4:	e9 67 af ff ff       	jmp    80102330 <kfree>
    panic("freevm: no pgdir");
801073c9:	83 ec 0c             	sub    $0xc,%esp
801073cc:	68 15 80 10 80       	push   $0x80108015
801073d1:	e8 ba 8f ff ff       	call   80100390 <panic>
801073d6:	8d 76 00             	lea    0x0(%esi),%esi
801073d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073e0 <setupkvm>:
{
801073e0:	55                   	push   %ebp
801073e1:	89 e5                	mov    %esp,%ebp
801073e3:	56                   	push   %esi
801073e4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801073e5:	e8 f6 b0 ff ff       	call   801024e0 <kalloc>
801073ea:	85 c0                	test   %eax,%eax
801073ec:	89 c6                	mov    %eax,%esi
801073ee:	74 42                	je     80107432 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801073f0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801073f3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801073f8:	68 00 10 00 00       	push   $0x1000
801073fd:	6a 00                	push   $0x0
801073ff:	50                   	push   %eax
80107400:	e8 ab d6 ff ff       	call   80104ab0 <memset>
80107405:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107408:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010740b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010740e:	83 ec 08             	sub    $0x8,%esp
80107411:	8b 13                	mov    (%ebx),%edx
80107413:	ff 73 0c             	pushl  0xc(%ebx)
80107416:	50                   	push   %eax
80107417:	29 c1                	sub    %eax,%ecx
80107419:	89 f0                	mov    %esi,%eax
8010741b:	e8 a0 f9 ff ff       	call   80106dc0 <mappages>
80107420:	83 c4 10             	add    $0x10,%esp
80107423:	85 c0                	test   %eax,%eax
80107425:	78 19                	js     80107440 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107427:	83 c3 10             	add    $0x10,%ebx
8010742a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107430:	75 d6                	jne    80107408 <setupkvm+0x28>
}
80107432:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107435:	89 f0                	mov    %esi,%eax
80107437:	5b                   	pop    %ebx
80107438:	5e                   	pop    %esi
80107439:	5d                   	pop    %ebp
8010743a:	c3                   	ret    
8010743b:	90                   	nop
8010743c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107440:	83 ec 0c             	sub    $0xc,%esp
80107443:	56                   	push   %esi
      return 0;
80107444:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107446:	e8 15 ff ff ff       	call   80107360 <freevm>
      return 0;
8010744b:	83 c4 10             	add    $0x10,%esp
}
8010744e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107451:	89 f0                	mov    %esi,%eax
80107453:	5b                   	pop    %ebx
80107454:	5e                   	pop    %esi
80107455:	5d                   	pop    %ebp
80107456:	c3                   	ret    
80107457:	89 f6                	mov    %esi,%esi
80107459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107460 <kvmalloc>:
{
80107460:	55                   	push   %ebp
80107461:	89 e5                	mov    %esp,%ebp
80107463:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107466:	e8 75 ff ff ff       	call   801073e0 <setupkvm>
8010746b:	a3 a4 87 11 80       	mov    %eax,0x801187a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107470:	05 00 00 00 80       	add    $0x80000000,%eax
80107475:	0f 22 d8             	mov    %eax,%cr3
}
80107478:	c9                   	leave  
80107479:	c3                   	ret    
8010747a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107480 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107480:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107481:	31 c9                	xor    %ecx,%ecx
{
80107483:	89 e5                	mov    %esp,%ebp
80107485:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107488:	8b 55 0c             	mov    0xc(%ebp),%edx
8010748b:	8b 45 08             	mov    0x8(%ebp),%eax
8010748e:	e8 ad f8 ff ff       	call   80106d40 <walkpgdir>
  if(pte == 0)
80107493:	85 c0                	test   %eax,%eax
80107495:	74 05                	je     8010749c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107497:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010749a:	c9                   	leave  
8010749b:	c3                   	ret    
    panic("clearpteu");
8010749c:	83 ec 0c             	sub    $0xc,%esp
8010749f:	68 26 80 10 80       	push   $0x80108026
801074a4:	e8 e7 8e ff ff       	call   80100390 <panic>
801074a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801074b0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801074b0:	55                   	push   %ebp
801074b1:	89 e5                	mov    %esp,%ebp
801074b3:	57                   	push   %edi
801074b4:	56                   	push   %esi
801074b5:	53                   	push   %ebx
801074b6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801074b9:	e8 22 ff ff ff       	call   801073e0 <setupkvm>
801074be:	85 c0                	test   %eax,%eax
801074c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801074c3:	0f 84 9f 00 00 00    	je     80107568 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801074c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801074cc:	85 c9                	test   %ecx,%ecx
801074ce:	0f 84 94 00 00 00    	je     80107568 <copyuvm+0xb8>
801074d4:	31 ff                	xor    %edi,%edi
801074d6:	eb 4a                	jmp    80107522 <copyuvm+0x72>
801074d8:	90                   	nop
801074d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801074e0:	83 ec 04             	sub    $0x4,%esp
801074e3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801074e9:	68 00 10 00 00       	push   $0x1000
801074ee:	53                   	push   %ebx
801074ef:	50                   	push   %eax
801074f0:	e8 6b d6 ff ff       	call   80104b60 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801074f5:	58                   	pop    %eax
801074f6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801074fc:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107501:	5a                   	pop    %edx
80107502:	ff 75 e4             	pushl  -0x1c(%ebp)
80107505:	50                   	push   %eax
80107506:	89 fa                	mov    %edi,%edx
80107508:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010750b:	e8 b0 f8 ff ff       	call   80106dc0 <mappages>
80107510:	83 c4 10             	add    $0x10,%esp
80107513:	85 c0                	test   %eax,%eax
80107515:	78 61                	js     80107578 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107517:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010751d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107520:	76 46                	jbe    80107568 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107522:	8b 45 08             	mov    0x8(%ebp),%eax
80107525:	31 c9                	xor    %ecx,%ecx
80107527:	89 fa                	mov    %edi,%edx
80107529:	e8 12 f8 ff ff       	call   80106d40 <walkpgdir>
8010752e:	85 c0                	test   %eax,%eax
80107530:	74 61                	je     80107593 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107532:	8b 00                	mov    (%eax),%eax
80107534:	a8 01                	test   $0x1,%al
80107536:	74 4e                	je     80107586 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107538:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010753a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010753f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107545:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107548:	e8 93 af ff ff       	call   801024e0 <kalloc>
8010754d:	85 c0                	test   %eax,%eax
8010754f:	89 c6                	mov    %eax,%esi
80107551:	75 8d                	jne    801074e0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107553:	83 ec 0c             	sub    $0xc,%esp
80107556:	ff 75 e0             	pushl  -0x20(%ebp)
80107559:	e8 02 fe ff ff       	call   80107360 <freevm>
  return 0;
8010755e:	83 c4 10             	add    $0x10,%esp
80107561:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107568:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010756b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010756e:	5b                   	pop    %ebx
8010756f:	5e                   	pop    %esi
80107570:	5f                   	pop    %edi
80107571:	5d                   	pop    %ebp
80107572:	c3                   	ret    
80107573:	90                   	nop
80107574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107578:	83 ec 0c             	sub    $0xc,%esp
8010757b:	56                   	push   %esi
8010757c:	e8 af ad ff ff       	call   80102330 <kfree>
      goto bad;
80107581:	83 c4 10             	add    $0x10,%esp
80107584:	eb cd                	jmp    80107553 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107586:	83 ec 0c             	sub    $0xc,%esp
80107589:	68 4a 80 10 80       	push   $0x8010804a
8010758e:	e8 fd 8d ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107593:	83 ec 0c             	sub    $0xc,%esp
80107596:	68 30 80 10 80       	push   $0x80108030
8010759b:	e8 f0 8d ff ff       	call   80100390 <panic>

801075a0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801075a0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801075a1:	31 c9                	xor    %ecx,%ecx
{
801075a3:	89 e5                	mov    %esp,%ebp
801075a5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801075a8:	8b 55 0c             	mov    0xc(%ebp),%edx
801075ab:	8b 45 08             	mov    0x8(%ebp),%eax
801075ae:	e8 8d f7 ff ff       	call   80106d40 <walkpgdir>
  if((*pte & PTE_P) == 0)
801075b3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801075b5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801075b6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801075b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801075bd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801075c0:	05 00 00 00 80       	add    $0x80000000,%eax
801075c5:	83 fa 05             	cmp    $0x5,%edx
801075c8:	ba 00 00 00 00       	mov    $0x0,%edx
801075cd:	0f 45 c2             	cmovne %edx,%eax
}
801075d0:	c3                   	ret    
801075d1:	eb 0d                	jmp    801075e0 <copyout>
801075d3:	90                   	nop
801075d4:	90                   	nop
801075d5:	90                   	nop
801075d6:	90                   	nop
801075d7:	90                   	nop
801075d8:	90                   	nop
801075d9:	90                   	nop
801075da:	90                   	nop
801075db:	90                   	nop
801075dc:	90                   	nop
801075dd:	90                   	nop
801075de:	90                   	nop
801075df:	90                   	nop

801075e0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801075e0:	55                   	push   %ebp
801075e1:	89 e5                	mov    %esp,%ebp
801075e3:	57                   	push   %edi
801075e4:	56                   	push   %esi
801075e5:	53                   	push   %ebx
801075e6:	83 ec 1c             	sub    $0x1c,%esp
801075e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801075ec:	8b 55 0c             	mov    0xc(%ebp),%edx
801075ef:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801075f2:	85 db                	test   %ebx,%ebx
801075f4:	75 40                	jne    80107636 <copyout+0x56>
801075f6:	eb 70                	jmp    80107668 <copyout+0x88>
801075f8:	90                   	nop
801075f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107600:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107603:	89 f1                	mov    %esi,%ecx
80107605:	29 d1                	sub    %edx,%ecx
80107607:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010760d:	39 d9                	cmp    %ebx,%ecx
8010760f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107612:	29 f2                	sub    %esi,%edx
80107614:	83 ec 04             	sub    $0x4,%esp
80107617:	01 d0                	add    %edx,%eax
80107619:	51                   	push   %ecx
8010761a:	57                   	push   %edi
8010761b:	50                   	push   %eax
8010761c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010761f:	e8 3c d5 ff ff       	call   80104b60 <memmove>
    len -= n;
    buf += n;
80107624:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107627:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010762a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107630:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107632:	29 cb                	sub    %ecx,%ebx
80107634:	74 32                	je     80107668 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107636:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107638:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010763b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010763e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107644:	56                   	push   %esi
80107645:	ff 75 08             	pushl  0x8(%ebp)
80107648:	e8 53 ff ff ff       	call   801075a0 <uva2ka>
    if(pa0 == 0)
8010764d:	83 c4 10             	add    $0x10,%esp
80107650:	85 c0                	test   %eax,%eax
80107652:	75 ac                	jne    80107600 <copyout+0x20>
  }
  return 0;
}
80107654:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107657:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010765c:	5b                   	pop    %ebx
8010765d:	5e                   	pop    %esi
8010765e:	5f                   	pop    %edi
8010765f:	5d                   	pop    %ebp
80107660:	c3                   	ret    
80107661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107668:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010766b:	31 c0                	xor    %eax,%eax
}
8010766d:	5b                   	pop    %ebx
8010766e:	5e                   	pop    %esi
8010766f:	5f                   	pop    %edi
80107670:	5d                   	pop    %ebp
80107671:	c3                   	ret    
