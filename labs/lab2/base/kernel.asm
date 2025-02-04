
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
80100028:	bc d0 54 11 80       	mov    $0x801154d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 f0 30 10 80       	mov    $0x801030f0,%eax
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
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 72 10 80       	push   $0x80107200
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 05 44 00 00       	call   80104460 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 72 10 80       	push   $0x80107207
80100097:	50                   	push   %eax
80100098:	e8 b3 42 00 00       	call   80104350 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave
801000c2:	c3                   	ret
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

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
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 97 44 00 00       	call   80104580 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
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
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 59 45 00 00       	call   801046c0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 1e 42 00 00       	call   80104390 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 df 21 00 00       	call   80102370 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 0e 72 10 80       	push   $0x8010720e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 6d 42 00 00       	call   80104430 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave
  iderw(b);
801001d4:	e9 97 21 00 00       	jmp    80102370 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 1f 72 10 80       	push   $0x8010721f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 2c 42 00 00       	call   80104430 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 dc 41 00 00       	call   801043f0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 60 43 00 00       	call   80104580 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2c                	jne    8010025c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 53 54             	mov    0x54(%ebx),%edx
80100233:	8b 43 50             	mov    0x50(%ebx),%eax
80100236:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100239:	8b 53 54             	mov    0x54(%ebx),%edx
8010023c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010023f:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 52 44 00 00       	jmp    801046c0 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 26 72 10 80       	push   $0x80107226
80100276:	e8 05 01 00 00       	call   80100380 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 37 16 00 00       	call   801018d0 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 db 42 00 00       	call   80104580 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002b5:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ef 10 80       	push   $0x8010ef20
801002c8:	68 00 ef 10 80       	push   $0x8010ef00
801002cd:	e8 1e 3e 00 00       	call   801040f0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 39 37 00 00       	call   80103a20 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 c5 43 00 00       	call   801046c0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 ec 14 00 00       	call   801017f0 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ef 10 80       	push   $0x8010ef20
8010034c:	e8 6f 43 00 00       	call   801046c0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 96 14 00 00       	call   801017f0 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli
  cons.locking = 0;
80100389:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 e2 25 00 00       	call   80102980 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 2d 72 10 80       	push   $0x8010722d
801003a7:	e8 04 03 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 77 7b 10 80 	movl   $0x80107b77,(%esp)
801003bc:	e8 ef 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 b3 40 00 00       	call   80104480 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 41 72 10 80       	push   $0x80107241
801003dd:	e8 ce 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
80100409:	3d 00 01 00 00       	cmp    $0x100,%eax
8010040e:	0f 84 cc 00 00 00    	je     801004e0 <consputc.part.0+0xe0>
    uartputc(c);
80100414:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100417:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010041c:	89 c3                	mov    %eax,%ebx
8010041e:	50                   	push   %eax
8010041f:	e8 2c 59 00 00       	call   80105d50 <uartputc>
80100424:	b8 0e 00 00 00       	mov    $0xe,%eax
80100429:	89 fa                	mov    %edi,%edx
8010042b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042c:	be d5 03 00 00       	mov    $0x3d5,%esi
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100434:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100437:	89 fa                	mov    %edi,%edx
80100439:	b8 0f 00 00 00       	mov    $0xf,%eax
8010043e:	c1 e1 08             	shl    $0x8,%ecx
80100441:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100442:	89 f2                	mov    %esi,%edx
80100444:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100445:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
80100448:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	75 76                	jne    801004c8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100452:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100457:	f7 e2                	mul    %edx
80100459:	c1 ea 06             	shr    $0x6,%edx
8010045c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010045f:	c1 e0 04             	shl    $0x4,%eax
80100462:	8d 70 50             	lea    0x50(%eax),%esi
  if(pos < 0 || pos > 25*80)
80100465:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
8010046b:	0f 8f 2f 01 00 00    	jg     801005a0 <consputc.part.0+0x1a0>
  if((pos/80) >= 24){  // Scroll up.
80100471:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100477:	0f 8f c3 00 00 00    	jg     80100540 <consputc.part.0+0x140>
  outb(CRTPORT+1, pos>>8);
8010047d:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
8010047f:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100486:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100489:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048c:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100491:	b8 0e 00 00 00       	mov    $0xe,%eax
80100496:	89 da                	mov    %ebx,%edx
80100498:	ee                   	out    %al,(%dx)
80100499:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010049e:	89 f8                	mov    %edi,%eax
801004a0:	89 ca                	mov    %ecx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b8 0f 00 00 00       	mov    $0xf,%eax
801004a8:	89 da                	mov    %ebx,%edx
801004aa:	ee                   	out    %al,(%dx)
801004ab:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004af:	89 ca                	mov    %ecx,%edx
801004b1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b2:	b8 20 07 00 00       	mov    $0x720,%eax
801004b7:	66 89 06             	mov    %ax,(%esi)
}
801004ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004bd:	5b                   	pop    %ebx
801004be:	5e                   	pop    %esi
801004bf:	5f                   	pop    %edi
801004c0:	5d                   	pop    %ebp
801004c1:	c3                   	ret
801004c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004c8:	0f b6 db             	movzbl %bl,%ebx
801004cb:	8d 70 01             	lea    0x1(%eax),%esi
801004ce:	80 cf 07             	or     $0x7,%bh
801004d1:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004d8:	80 
801004d9:	eb 8a                	jmp    80100465 <consputc.part.0+0x65>
801004db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801004df:	90                   	nop
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e0:	83 ec 0c             	sub    $0xc,%esp
801004e3:	be d4 03 00 00       	mov    $0x3d4,%esi
801004e8:	6a 08                	push   $0x8
801004ea:	e8 61 58 00 00       	call   80105d50 <uartputc>
801004ef:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f6:	e8 55 58 00 00       	call   80105d50 <uartputc>
801004fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100502:	e8 49 58 00 00       	call   80105d50 <uartputc>
80100507:	b8 0e 00 00 00       	mov    $0xe,%eax
8010050c:	89 f2                	mov    %esi,%edx
8010050e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010050f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100514:	89 da                	mov    %ebx,%edx
80100516:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100517:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010051a:	89 f2                	mov    %esi,%edx
8010051c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100521:	c1 e1 08             	shl    $0x8,%ecx
80100524:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100525:	89 da                	mov    %ebx,%edx
80100527:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100528:	0f b6 f0             	movzbl %al,%esi
    if(pos > 0) --pos;
8010052b:	83 c4 10             	add    $0x10,%esp
8010052e:	09 ce                	or     %ecx,%esi
80100530:	74 5e                	je     80100590 <consputc.part.0+0x190>
80100532:	83 ee 01             	sub    $0x1,%esi
80100535:	e9 2b ff ff ff       	jmp    80100465 <consputc.part.0+0x65>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 3a 42 00 00       	call   801047a0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 95 41 00 00       	call   80104710 <memset>
  outb(CRTPORT+1, pos);
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 06 ff ff ff       	jmp    8010048c <consputc.part.0+0x8c>
80100586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058d:	8d 76 00             	lea    0x0(%esi),%esi
80100590:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100594:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100599:	31 ff                	xor    %edi,%edi
8010059b:	e9 ec fe ff ff       	jmp    8010048c <consputc.part.0+0x8c>
    panic("pos under/overflow");
801005a0:	83 ec 0c             	sub    $0xc,%esp
801005a3:	68 45 72 10 80       	push   $0x80107245
801005a8:	e8 d3 fd ff ff       	call   80100380 <panic>
801005ad:	8d 76 00             	lea    0x0(%esi),%esi

801005b0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005b0:	55                   	push   %ebp
801005b1:	89 e5                	mov    %esp,%ebp
801005b3:	57                   	push   %edi
801005b4:	56                   	push   %esi
801005b5:	53                   	push   %ebx
801005b6:	83 ec 18             	sub    $0x18,%esp
801005b9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005bc:	ff 75 08             	push   0x8(%ebp)
801005bf:	e8 0c 13 00 00       	call   801018d0 <iunlock>
  acquire(&cons.lock);
801005c4:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005cb:	e8 b0 3f 00 00       	call   80104580 <acquire>
  for(i = 0; i < n; i++)
801005d0:	83 c4 10             	add    $0x10,%esp
801005d3:	85 f6                	test   %esi,%esi
801005d5:	7e 25                	jle    801005fc <consolewrite+0x4c>
801005d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005da:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005dd:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i] & 0xff);
801005e3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005e6:	85 d2                	test   %edx,%edx
801005e8:	74 06                	je     801005f0 <consolewrite+0x40>
  asm volatile("cli");
801005ea:	fa                   	cli
    for(;;)
801005eb:	eb fe                	jmp    801005eb <consolewrite+0x3b>
801005ed:	8d 76 00             	lea    0x0(%esi),%esi
801005f0:	e8 0b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005f5:	83 c3 01             	add    $0x1,%ebx
801005f8:	39 df                	cmp    %ebx,%edi
801005fa:	75 e1                	jne    801005dd <consolewrite+0x2d>
  release(&cons.lock);
801005fc:	83 ec 0c             	sub    $0xc,%esp
801005ff:	68 20 ef 10 80       	push   $0x8010ef20
80100604:	e8 b7 40 00 00       	call   801046c0 <release>
  ilock(ip);
80100609:	58                   	pop    %eax
8010060a:	ff 75 08             	push   0x8(%ebp)
8010060d:	e8 de 11 00 00       	call   801017f0 <ilock>

  return n;
}
80100612:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100615:	89 f0                	mov    %esi,%eax
80100617:	5b                   	pop    %ebx
80100618:	5e                   	pop    %esi
80100619:	5f                   	pop    %edi
8010061a:	5d                   	pop    %ebp
8010061b:	c3                   	ret
8010061c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100620 <printint>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	89 c6                	mov    %eax,%esi
80100627:	53                   	push   %ebx
80100628:	89 d3                	mov    %edx,%ebx
8010062a:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010062d:	85 c9                	test   %ecx,%ecx
8010062f:	74 04                	je     80100635 <printint+0x15>
80100631:	85 c0                	test   %eax,%eax
80100633:	78 63                	js     80100698 <printint+0x78>
    x = xx;
80100635:	89 f1                	mov    %esi,%ecx
80100637:	31 c0                	xor    %eax,%eax
  i = 0;
80100639:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010063c:	31 f6                	xor    %esi,%esi
8010063e:	66 90                	xchg   %ax,%ax
    buf[i++] = digits[x % base];
80100640:	89 c8                	mov    %ecx,%eax
80100642:	31 d2                	xor    %edx,%edx
80100644:	89 f7                	mov    %esi,%edi
80100646:	f7 f3                	div    %ebx
80100648:	8d 76 01             	lea    0x1(%esi),%esi
8010064b:	0f b6 92 70 72 10 80 	movzbl -0x7fef8d90(%edx),%edx
80100652:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100656:	89 ca                	mov    %ecx,%edx
80100658:	89 c1                	mov    %eax,%ecx
8010065a:	39 da                	cmp    %ebx,%edx
8010065c:	73 e2                	jae    80100640 <printint+0x20>
  if(sign)
8010065e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100661:	85 c0                	test   %eax,%eax
80100663:	74 07                	je     8010066c <printint+0x4c>
    buf[i++] = '-';
80100665:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
    buf[i++] = digits[x % base];
8010066a:	89 f7                	mov    %esi,%edi
8010066c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010066f:	01 df                	add    %ebx,%edi
  if(panicked){
80100671:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i]);
80100677:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
8010067a:	85 d2                	test   %edx,%edx
8010067c:	74 0a                	je     80100688 <printint+0x68>
8010067e:	fa                   	cli
    for(;;)
8010067f:	eb fe                	jmp    8010067f <printint+0x5f>
80100681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100688:	e8 73 fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
8010068d:	8d 47 ff             	lea    -0x1(%edi),%eax
80100690:	39 df                	cmp    %ebx,%edi
80100692:	74 0c                	je     801006a0 <printint+0x80>
80100694:	89 c7                	mov    %eax,%edi
80100696:	eb d9                	jmp    80100671 <printint+0x51>
80100698:	89 c8                	mov    %ecx,%eax
    x = -xx;
8010069a:	89 f1                	mov    %esi,%ecx
8010069c:	f7 d9                	neg    %ecx
8010069e:	eb 99                	jmp    80100639 <printint+0x19>
}
801006a0:	83 c4 2c             	add    $0x2c,%esp
801006a3:	5b                   	pop    %ebx
801006a4:	5e                   	pop    %esi
801006a5:	5f                   	pop    %edi
801006a6:	5d                   	pop    %ebp
801006a7:	c3                   	ret
801006a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	8b 3d 54 ef 10 80    	mov    0x8010ef54,%edi
  if (fmt == 0)
801006bf:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801006c2:	85 ff                	test   %edi,%edi
801006c4:	0f 85 36 01 00 00    	jne    80100800 <cprintf+0x150>
  if (fmt == 0)
801006ca:	85 f6                	test   %esi,%esi
801006cc:	0f 84 e0 01 00 00    	je     801008b2 <cprintf+0x202>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d2:	0f b6 06             	movzbl (%esi),%eax
801006d5:	85 c0                	test   %eax,%eax
801006d7:	74 6b                	je     80100744 <cprintf+0x94>
  argp = (uint*)(void*)(&fmt + 1);
801006d9:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006dc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801006df:	31 db                	xor    %ebx,%ebx
801006e1:	89 d7                	mov    %edx,%edi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	0f 85 dc 00 00 00    	jne    801007c8 <cprintf+0x118>
    c = fmt[++i] & 0xff;
801006ec:	83 c3 01             	add    $0x1,%ebx
801006ef:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
801006f3:	85 c9                	test   %ecx,%ecx
801006f5:	74 42                	je     80100739 <cprintf+0x89>
    switch(c){
801006f7:	83 f9 70             	cmp    $0x70,%ecx
801006fa:	0f 84 99 00 00 00    	je     80100799 <cprintf+0xe9>
80100700:	7f 4e                	jg     80100750 <cprintf+0xa0>
80100702:	83 f9 25             	cmp    $0x25,%ecx
80100705:	0f 84 cd 00 00 00    	je     801007d8 <cprintf+0x128>
8010070b:	83 f9 64             	cmp    $0x64,%ecx
8010070e:	0f 85 24 01 00 00    	jne    80100838 <cprintf+0x188>
      printint(*argp++, 10, 1);
80100714:	8d 47 04             	lea    0x4(%edi),%eax
80100717:	b9 01 00 00 00       	mov    $0x1,%ecx
8010071c:	ba 0a 00 00 00       	mov    $0xa,%edx
80100721:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100724:	8b 07                	mov    (%edi),%eax
80100726:	e8 f5 fe ff ff       	call   80100620 <printint>
8010072b:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010072e:	83 c3 01             	add    $0x1,%ebx
80100731:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100735:	85 c0                	test   %eax,%eax
80100737:	75 aa                	jne    801006e3 <cprintf+0x33>
80100739:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
8010073c:	85 ff                	test   %edi,%edi
8010073e:	0f 85 df 00 00 00    	jne    80100823 <cprintf+0x173>
}
80100744:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100747:	5b                   	pop    %ebx
80100748:	5e                   	pop    %esi
80100749:	5f                   	pop    %edi
8010074a:	5d                   	pop    %ebp
8010074b:	c3                   	ret
8010074c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100750:	83 f9 73             	cmp    $0x73,%ecx
80100753:	75 3b                	jne    80100790 <cprintf+0xe0>
      if((s = (char*)*argp++) == 0)
80100755:	8b 17                	mov    (%edi),%edx
80100757:	8d 47 04             	lea    0x4(%edi),%eax
8010075a:	85 d2                	test   %edx,%edx
8010075c:	0f 85 0e 01 00 00    	jne    80100870 <cprintf+0x1c0>
80100762:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
80100767:	bf 58 72 10 80       	mov    $0x80107258,%edi
8010076c:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010076f:	89 fb                	mov    %edi,%ebx
80100771:	89 f7                	mov    %esi,%edi
80100773:	89 c6                	mov    %eax,%esi
80100775:	0f be c1             	movsbl %cl,%eax
  if(panicked){
80100778:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010077e:	85 d2                	test   %edx,%edx
80100780:	0f 84 fe 00 00 00    	je     80100884 <cprintf+0x1d4>
80100786:	fa                   	cli
    for(;;)
80100787:	eb fe                	jmp    80100787 <cprintf+0xd7>
80100789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100790:	83 f9 78             	cmp    $0x78,%ecx
80100793:	0f 85 9f 00 00 00    	jne    80100838 <cprintf+0x188>
      printint(*argp++, 16, 0);
80100799:	8d 47 04             	lea    0x4(%edi),%eax
8010079c:	31 c9                	xor    %ecx,%ecx
8010079e:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007a3:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
801007a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007a9:	8b 07                	mov    (%edi),%eax
801007ab:	e8 70 fe ff ff       	call   80100620 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007b0:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
801007b4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007b7:	85 c0                	test   %eax,%eax
801007b9:	0f 85 24 ff ff ff    	jne    801006e3 <cprintf+0x33>
801007bf:	e9 75 ff ff ff       	jmp    80100739 <cprintf+0x89>
801007c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007c8:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007ce:	85 c9                	test   %ecx,%ecx
801007d0:	74 15                	je     801007e7 <cprintf+0x137>
801007d2:	fa                   	cli
    for(;;)
801007d3:	eb fe                	jmp    801007d3 <cprintf+0x123>
801007d5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007d8:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007de:	85 c9                	test   %ecx,%ecx
801007e0:	75 7e                	jne    80100860 <cprintf+0x1b0>
801007e2:	b8 25 00 00 00       	mov    $0x25,%eax
801007e7:	e8 14 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007ec:	83 c3 01             	add    $0x1,%ebx
801007ef:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007f3:	85 c0                	test   %eax,%eax
801007f5:	0f 85 e8 fe ff ff    	jne    801006e3 <cprintf+0x33>
801007fb:	e9 39 ff ff ff       	jmp    80100739 <cprintf+0x89>
    acquire(&cons.lock);
80100800:	83 ec 0c             	sub    $0xc,%esp
80100803:	68 20 ef 10 80       	push   $0x8010ef20
80100808:	e8 73 3d 00 00       	call   80104580 <acquire>
  if (fmt == 0)
8010080d:	83 c4 10             	add    $0x10,%esp
80100810:	85 f6                	test   %esi,%esi
80100812:	0f 84 9a 00 00 00    	je     801008b2 <cprintf+0x202>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100818:	0f b6 06             	movzbl (%esi),%eax
8010081b:	85 c0                	test   %eax,%eax
8010081d:	0f 85 b6 fe ff ff    	jne    801006d9 <cprintf+0x29>
    release(&cons.lock);
80100823:	83 ec 0c             	sub    $0xc,%esp
80100826:	68 20 ef 10 80       	push   $0x8010ef20
8010082b:	e8 90 3e 00 00       	call   801046c0 <release>
80100830:	83 c4 10             	add    $0x10,%esp
80100833:	e9 0c ff ff ff       	jmp    80100744 <cprintf+0x94>
  if(panicked){
80100838:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010083e:	85 d2                	test   %edx,%edx
80100840:	75 26                	jne    80100868 <cprintf+0x1b8>
80100842:	b8 25 00 00 00       	mov    $0x25,%eax
80100847:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010084a:	e8 b1 fb ff ff       	call   80100400 <consputc.part.0>
8010084f:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100854:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100857:	85 c0                	test   %eax,%eax
80100859:	74 4b                	je     801008a6 <cprintf+0x1f6>
8010085b:	fa                   	cli
    for(;;)
8010085c:	eb fe                	jmp    8010085c <cprintf+0x1ac>
8010085e:	66 90                	xchg   %ax,%ax
80100860:	fa                   	cli
80100861:	eb fe                	jmp    80100861 <cprintf+0x1b1>
80100863:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100867:	90                   	nop
80100868:	fa                   	cli
80100869:	eb fe                	jmp    80100869 <cprintf+0x1b9>
8010086b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010086f:	90                   	nop
      for(; *s; s++)
80100870:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100873:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100875:	84 c9                	test   %cl,%cl
80100877:	0f 85 ef fe ff ff    	jne    8010076c <cprintf+0xbc>
      if((s = (char*)*argp++) == 0)
8010087d:	89 c7                	mov    %eax,%edi
8010087f:	e9 aa fe ff ff       	jmp    8010072e <cprintf+0x7e>
80100884:	e8 77 fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100889:	0f be 43 01          	movsbl 0x1(%ebx),%eax
8010088d:	83 c3 01             	add    $0x1,%ebx
80100890:	84 c0                	test   %al,%al
80100892:	0f 85 e0 fe ff ff    	jne    80100778 <cprintf+0xc8>
      if((s = (char*)*argp++) == 0)
80100898:	89 f0                	mov    %esi,%eax
8010089a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010089d:	89 fe                	mov    %edi,%esi
8010089f:	89 c7                	mov    %eax,%edi
801008a1:	e9 88 fe ff ff       	jmp    8010072e <cprintf+0x7e>
801008a6:	89 c8                	mov    %ecx,%eax
801008a8:	e8 53 fb ff ff       	call   80100400 <consputc.part.0>
801008ad:	e9 7c fe ff ff       	jmp    8010072e <cprintf+0x7e>
    panic("null fmt");
801008b2:	83 ec 0c             	sub    $0xc,%esp
801008b5:	68 5f 72 10 80       	push   $0x8010725f
801008ba:	e8 c1 fa ff ff       	call   80100380 <panic>
801008bf:	90                   	nop

801008c0 <consoleintr>:
{
801008c0:	55                   	push   %ebp
801008c1:	89 e5                	mov    %esp,%ebp
801008c3:	57                   	push   %edi
801008c4:	56                   	push   %esi
  int c, doprocdump = 0;
801008c5:	31 f6                	xor    %esi,%esi
{
801008c7:	53                   	push   %ebx
801008c8:	83 ec 18             	sub    $0x18,%esp
801008cb:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
801008ce:	68 20 ef 10 80       	push   $0x8010ef20
801008d3:	e8 a8 3c 00 00       	call   80104580 <acquire>
  while((c = getc()) >= 0){
801008d8:	83 c4 10             	add    $0x10,%esp
801008db:	eb 1a                	jmp    801008f7 <consoleintr+0x37>
801008dd:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008e0:	83 fb 08             	cmp    $0x8,%ebx
801008e3:	0f 84 d7 00 00 00    	je     801009c0 <consoleintr+0x100>
801008e9:	83 fb 10             	cmp    $0x10,%ebx
801008ec:	0f 85 2d 01 00 00    	jne    80100a1f <consoleintr+0x15f>
801008f2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008f7:	ff d7                	call   *%edi
801008f9:	89 c3                	mov    %eax,%ebx
801008fb:	85 c0                	test   %eax,%eax
801008fd:	0f 88 e5 00 00 00    	js     801009e8 <consoleintr+0x128>
    switch(c){
80100903:	83 fb 15             	cmp    $0x15,%ebx
80100906:	74 7a                	je     80100982 <consoleintr+0xc2>
80100908:	7e d6                	jle    801008e0 <consoleintr+0x20>
8010090a:	83 fb 7f             	cmp    $0x7f,%ebx
8010090d:	0f 84 ad 00 00 00    	je     801009c0 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100913:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100918:	89 c2                	mov    %eax,%edx
8010091a:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100920:	83 fa 7f             	cmp    $0x7f,%edx
80100923:	77 d2                	ja     801008f7 <consoleintr+0x37>
  if(panicked){
80100925:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
8010092b:	8d 48 01             	lea    0x1(%eax),%ecx
8010092e:	83 e0 7f             	and    $0x7f,%eax
80100931:	89 0d 08 ef 10 80    	mov    %ecx,0x8010ef08
80100937:	88 98 80 ee 10 80    	mov    %bl,-0x7fef1180(%eax)
  if(panicked){
8010093d:	85 d2                	test   %edx,%edx
8010093f:	0f 85 47 01 00 00    	jne    80100a8c <consoleintr+0x1cc>
80100945:	89 d8                	mov    %ebx,%eax
80100947:	e8 b4 fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010094c:	83 fb 0a             	cmp    $0xa,%ebx
8010094f:	0f 84 18 01 00 00    	je     80100a6d <consoleintr+0x1ad>
80100955:	83 fb 04             	cmp    $0x4,%ebx
80100958:	0f 84 0f 01 00 00    	je     80100a6d <consoleintr+0x1ad>
8010095e:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
80100963:	83 e8 80             	sub    $0xffffff80,%eax
80100966:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
8010096c:	75 89                	jne    801008f7 <consoleintr+0x37>
8010096e:	e9 ff 00 00 00       	jmp    80100a72 <consoleintr+0x1b2>
80100973:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100977:	90                   	nop
80100978:	b8 00 01 00 00       	mov    $0x100,%eax
8010097d:	e8 7e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
80100982:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100987:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
8010098d:	0f 84 64 ff ff ff    	je     801008f7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100993:	83 e8 01             	sub    $0x1,%eax
80100996:	89 c2                	mov    %eax,%edx
80100998:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
8010099b:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
801009a2:	0f 84 4f ff ff ff    	je     801008f7 <consoleintr+0x37>
  if(panicked){
801009a8:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
801009ae:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
801009b3:	85 d2                	test   %edx,%edx
801009b5:	74 c1                	je     80100978 <consoleintr+0xb8>
801009b7:	fa                   	cli
    for(;;)
801009b8:	eb fe                	jmp    801009b8 <consoleintr+0xf8>
801009ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(input.e != input.w){
801009c0:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801009c5:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801009cb:	0f 84 26 ff ff ff    	je     801008f7 <consoleintr+0x37>
        input.e--;
801009d1:	83 e8 01             	sub    $0x1,%eax
801009d4:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
801009d9:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
801009de:	85 c0                	test   %eax,%eax
801009e0:	74 22                	je     80100a04 <consoleintr+0x144>
801009e2:	fa                   	cli
    for(;;)
801009e3:	eb fe                	jmp    801009e3 <consoleintr+0x123>
801009e5:	8d 76 00             	lea    0x0(%esi),%esi
  release(&cons.lock);
801009e8:	83 ec 0c             	sub    $0xc,%esp
801009eb:	68 20 ef 10 80       	push   $0x8010ef20
801009f0:	e8 cb 3c 00 00       	call   801046c0 <release>
  if(doprocdump) {
801009f5:	83 c4 10             	add    $0x10,%esp
801009f8:	85 f6                	test   %esi,%esi
801009fa:	75 17                	jne    80100a13 <consoleintr+0x153>
}
801009fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009ff:	5b                   	pop    %ebx
80100a00:	5e                   	pop    %esi
80100a01:	5f                   	pop    %edi
80100a02:	5d                   	pop    %ebp
80100a03:	c3                   	ret
80100a04:	b8 00 01 00 00       	mov    $0x100,%eax
80100a09:	e8 f2 f9 ff ff       	call   80100400 <consputc.part.0>
80100a0e:	e9 e4 fe ff ff       	jmp    801008f7 <consoleintr+0x37>
80100a13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a16:	5b                   	pop    %ebx
80100a17:	5e                   	pop    %esi
80100a18:	5f                   	pop    %edi
80100a19:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a1a:	e9 71 38 00 00       	jmp    80104290 <procdump>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100a1f:	85 db                	test   %ebx,%ebx
80100a21:	0f 84 d0 fe ff ff    	je     801008f7 <consoleintr+0x37>
80100a27:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100a2c:	89 c2                	mov    %eax,%edx
80100a2e:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100a34:	83 fa 7f             	cmp    $0x7f,%edx
80100a37:	0f 87 ba fe ff ff    	ja     801008f7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a3d:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
80100a40:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
80100a46:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100a49:	83 fb 0d             	cmp    $0xd,%ebx
80100a4c:	0f 85 df fe ff ff    	jne    80100931 <consoleintr+0x71>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a52:	89 0d 08 ef 10 80    	mov    %ecx,0x8010ef08
80100a58:	c6 80 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%eax)
  if(panicked){
80100a5f:	85 d2                	test   %edx,%edx
80100a61:	75 29                	jne    80100a8c <consoleintr+0x1cc>
80100a63:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a68:	e8 93 f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a6d:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
          wakeup(&input.r);
80100a72:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a75:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100a7a:	68 00 ef 10 80       	push   $0x8010ef00
80100a7f:	e8 2c 37 00 00       	call   801041b0 <wakeup>
80100a84:	83 c4 10             	add    $0x10,%esp
80100a87:	e9 6b fe ff ff       	jmp    801008f7 <consoleintr+0x37>
80100a8c:	fa                   	cli
    for(;;)
80100a8d:	eb fe                	jmp    80100a8d <consoleintr+0x1cd>
80100a8f:	90                   	nop

80100a90 <consoleinit>:

void
consoleinit(void)
{
80100a90:	55                   	push   %ebp
80100a91:	89 e5                	mov    %esp,%ebp
80100a93:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a96:	68 68 72 10 80       	push   $0x80107268
80100a9b:	68 20 ef 10 80       	push   $0x8010ef20
80100aa0:	e8 bb 39 00 00       	call   80104460 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100aa5:	c7 05 0c f9 10 80 b0 	movl   $0x801005b0,0x8010f90c
80100aac:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100aaf:	c7 05 08 f9 10 80 80 	movl   $0x80100280,0x8010f908
80100ab6:	02 10 80 
  cons.locking = 1;
80100ab9:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100ac0:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100ac3:	58                   	pop    %eax
80100ac4:	5a                   	pop    %edx
80100ac5:	6a 00                	push   $0x0
80100ac7:	6a 01                	push   $0x1
80100ac9:	e8 32 1a 00 00       	call   80102500 <ioapicenable>
}
80100ace:	83 c4 10             	add    $0x10,%esp
80100ad1:	c9                   	leave
80100ad2:	c3                   	ret
80100ad3:	66 90                	xchg   %ax,%ax
80100ad5:	66 90                	xchg   %ax,%ax
80100ad7:	66 90                	xchg   %ax,%ax
80100ad9:	66 90                	xchg   %ax,%ax
80100adb:	66 90                	xchg   %ax,%ax
80100add:	66 90                	xchg   %ax,%ax
80100adf:	90                   	nop

80100ae0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ae0:	55                   	push   %ebp
80100ae1:	89 e5                	mov    %esp,%ebp
80100ae3:	57                   	push   %edi
80100ae4:	56                   	push   %esi
80100ae5:	53                   	push   %ebx
80100ae6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100aec:	e8 2f 2f 00 00       	call   80103a20 <myproc>
80100af1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100af7:	e8 f4 22 00 00       	call   80102df0 <begin_op>

  if((ip = namei(path)) == 0){
80100afc:	83 ec 0c             	sub    $0xc,%esp
80100aff:	ff 75 08             	push   0x8(%ebp)
80100b02:	e8 19 16 00 00       	call   80102120 <namei>
80100b07:	83 c4 10             	add    $0x10,%esp
80100b0a:	85 c0                	test   %eax,%eax
80100b0c:	0f 84 30 03 00 00    	je     80100e42 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b12:	83 ec 0c             	sub    $0xc,%esp
80100b15:	89 c7                	mov    %eax,%edi
80100b17:	50                   	push   %eax
80100b18:	e8 d3 0c 00 00       	call   801017f0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b1d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b23:	6a 34                	push   $0x34
80100b25:	6a 00                	push   $0x0
80100b27:	50                   	push   %eax
80100b28:	57                   	push   %edi
80100b29:	e8 d2 0f 00 00       	call   80101b00 <readi>
80100b2e:	83 c4 20             	add    $0x20,%esp
80100b31:	83 f8 34             	cmp    $0x34,%eax
80100b34:	0f 85 01 01 00 00    	jne    80100c3b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b3a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b41:	45 4c 46 
80100b44:	0f 85 f1 00 00 00    	jne    80100c3b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b4a:	e8 71 63 00 00       	call   80106ec0 <setupkvm>
80100b4f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b55:	85 c0                	test   %eax,%eax
80100b57:	0f 84 de 00 00 00    	je     80100c3b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b5d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b64:	00 
80100b65:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b6b:	0f 84 a1 02 00 00    	je     80100e12 <exec+0x332>
  sz = 0;
80100b71:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b78:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b7b:	31 db                	xor    %ebx,%ebx
80100b7d:	e9 8c 00 00 00       	jmp    80100c0e <exec+0x12e>
80100b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100b88:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b8f:	75 6c                	jne    80100bfd <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100b91:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b97:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b9d:	0f 82 87 00 00 00    	jb     80100c2a <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ba3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ba9:	72 7f                	jb     80100c2a <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bab:	83 ec 04             	sub    $0x4,%esp
80100bae:	50                   	push   %eax
80100baf:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100bb5:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bbb:	e8 30 61 00 00       	call   80106cf0 <allocuvm>
80100bc0:	83 c4 10             	add    $0x10,%esp
80100bc3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bc9:	85 c0                	test   %eax,%eax
80100bcb:	74 5d                	je     80100c2a <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100bcd:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bd3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bd8:	75 50                	jne    80100c2a <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bda:	83 ec 0c             	sub    $0xc,%esp
80100bdd:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100be3:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100be9:	57                   	push   %edi
80100bea:	50                   	push   %eax
80100beb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bf1:	e8 2a 60 00 00       	call   80106c20 <loaduvm>
80100bf6:	83 c4 20             	add    $0x20,%esp
80100bf9:	85 c0                	test   %eax,%eax
80100bfb:	78 2d                	js     80100c2a <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bfd:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100c04:	83 c3 01             	add    $0x1,%ebx
80100c07:	83 c6 20             	add    $0x20,%esi
80100c0a:	39 d8                	cmp    %ebx,%eax
80100c0c:	7e 52                	jle    80100c60 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c0e:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c14:	6a 20                	push   $0x20
80100c16:	56                   	push   %esi
80100c17:	50                   	push   %eax
80100c18:	57                   	push   %edi
80100c19:	e8 e2 0e 00 00       	call   80101b00 <readi>
80100c1e:	83 c4 10             	add    $0x10,%esp
80100c21:	83 f8 20             	cmp    $0x20,%eax
80100c24:	0f 84 5e ff ff ff    	je     80100b88 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c2a:	83 ec 0c             	sub    $0xc,%esp
80100c2d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c33:	e8 08 62 00 00       	call   80106e40 <freevm>
  if(ip){
80100c38:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c3b:	83 ec 0c             	sub    $0xc,%esp
80100c3e:	57                   	push   %edi
80100c3f:	e8 3c 0e 00 00       	call   80101a80 <iunlockput>
    end_op();
80100c44:	e8 17 22 00 00       	call   80102e60 <end_op>
80100c49:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100c51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c54:	5b                   	pop    %ebx
80100c55:	5e                   	pop    %esi
80100c56:	5f                   	pop    %edi
80100c57:	5d                   	pop    %ebp
80100c58:	c3                   	ret
80100c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100c60:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c66:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c6c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c72:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100c78:	83 ec 0c             	sub    $0xc,%esp
80100c7b:	57                   	push   %edi
80100c7c:	e8 ff 0d 00 00       	call   80101a80 <iunlockput>
  end_op();
80100c81:	e8 da 21 00 00       	call   80102e60 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c86:	83 c4 0c             	add    $0xc,%esp
80100c89:	53                   	push   %ebx
80100c8a:	56                   	push   %esi
80100c8b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c91:	56                   	push   %esi
80100c92:	e8 59 60 00 00       	call   80106cf0 <allocuvm>
80100c97:	83 c4 10             	add    $0x10,%esp
80100c9a:	89 c7                	mov    %eax,%edi
80100c9c:	85 c0                	test   %eax,%eax
80100c9e:	0f 84 86 00 00 00    	je     80100d2a <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ca4:	83 ec 08             	sub    $0x8,%esp
80100ca7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100cad:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100caf:	50                   	push   %eax
80100cb0:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100cb1:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cb3:	e8 a8 62 00 00       	call   80106f60 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cbb:	83 c4 10             	add    $0x10,%esp
80100cbe:	8b 10                	mov    (%eax),%edx
80100cc0:	85 d2                	test   %edx,%edx
80100cc2:	0f 84 56 01 00 00    	je     80100e1e <exec+0x33e>
80100cc8:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100cce:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100cd1:	eb 23                	jmp    80100cf6 <exec+0x216>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
80100cd8:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100cdb:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100ce2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100ce8:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100ceb:	85 d2                	test   %edx,%edx
80100ced:	74 51                	je     80100d40 <exec+0x260>
    if(argc >= MAXARG)
80100cef:	83 f8 20             	cmp    $0x20,%eax
80100cf2:	74 36                	je     80100d2a <exec+0x24a>
  for(argc = 0; argv[argc]; argc++) {
80100cf4:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cf6:	83 ec 0c             	sub    $0xc,%esp
80100cf9:	52                   	push   %edx
80100cfa:	e8 01 3c 00 00       	call   80104900 <strlen>
80100cff:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d01:	58                   	pop    %eax
80100d02:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d05:	83 eb 01             	sub    $0x1,%ebx
80100d08:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d0b:	e8 f0 3b 00 00       	call   80104900 <strlen>
80100d10:	83 c0 01             	add    $0x1,%eax
80100d13:	50                   	push   %eax
80100d14:	ff 34 b7             	push   (%edi,%esi,4)
80100d17:	53                   	push   %ebx
80100d18:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d1e:	e8 fd 63 00 00       	call   80107120 <copyout>
80100d23:	83 c4 20             	add    $0x20,%esp
80100d26:	85 c0                	test   %eax,%eax
80100d28:	79 ae                	jns    80100cd8 <exec+0x1f8>
    freevm(pgdir);
80100d2a:	83 ec 0c             	sub    $0xc,%esp
80100d2d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d33:	e8 08 61 00 00       	call   80106e40 <freevm>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	e9 0c ff ff ff       	jmp    80100c4c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d40:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100d47:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d4d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d53:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100d56:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d59:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100d60:	00 00 00 00 
  ustack[1] = argc;
80100d64:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100d6a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d71:	ff ff ff 
  ustack[1] = argc;
80100d74:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d7a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100d7c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d7e:	29 d0                	sub    %edx,%eax
80100d80:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d86:	56                   	push   %esi
80100d87:	51                   	push   %ecx
80100d88:	53                   	push   %ebx
80100d89:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d8f:	e8 8c 63 00 00       	call   80107120 <copyout>
80100d94:	83 c4 10             	add    $0x10,%esp
80100d97:	85 c0                	test   %eax,%eax
80100d99:	78 8f                	js     80100d2a <exec+0x24a>
  for(last=s=path; *s; s++)
80100d9b:	8b 45 08             	mov    0x8(%ebp),%eax
80100d9e:	8b 55 08             	mov    0x8(%ebp),%edx
80100da1:	0f b6 00             	movzbl (%eax),%eax
80100da4:	84 c0                	test   %al,%al
80100da6:	74 17                	je     80100dbf <exec+0x2df>
80100da8:	89 d1                	mov    %edx,%ecx
80100daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100db0:	83 c1 01             	add    $0x1,%ecx
80100db3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100db5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100db8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100dbb:	84 c0                	test   %al,%al
80100dbd:	75 f1                	jne    80100db0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100dbf:	83 ec 04             	sub    $0x4,%esp
80100dc2:	6a 10                	push   $0x10
80100dc4:	52                   	push   %edx
80100dc5:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100dcb:	8d 46 6c             	lea    0x6c(%esi),%eax
80100dce:	50                   	push   %eax
80100dcf:	e8 ec 3a 00 00       	call   801048c0 <safestrcpy>
  curproc->pgdir = pgdir;
80100dd4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dda:	89 f0                	mov    %esi,%eax
80100ddc:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100ddf:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100de1:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100de4:	89 c1                	mov    %eax,%ecx
80100de6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dec:	8b 40 18             	mov    0x18(%eax),%eax
80100def:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100df2:	8b 41 18             	mov    0x18(%ecx),%eax
80100df5:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100df8:	89 0c 24             	mov    %ecx,(%esp)
80100dfb:	e8 90 5c 00 00       	call   80106a90 <switchuvm>
  freevm(oldpgdir);
80100e00:	89 34 24             	mov    %esi,(%esp)
80100e03:	e8 38 60 00 00       	call   80106e40 <freevm>
  return 0;
80100e08:	83 c4 10             	add    $0x10,%esp
80100e0b:	31 c0                	xor    %eax,%eax
80100e0d:	e9 3f fe ff ff       	jmp    80100c51 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e12:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100e17:	31 f6                	xor    %esi,%esi
80100e19:	e9 5a fe ff ff       	jmp    80100c78 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100e1e:	be 10 00 00 00       	mov    $0x10,%esi
80100e23:	ba 04 00 00 00       	mov    $0x4,%edx
80100e28:	b8 03 00 00 00       	mov    $0x3,%eax
80100e2d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e34:	00 00 00 
80100e37:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e3d:	e9 17 ff ff ff       	jmp    80100d59 <exec+0x279>
    end_op();
80100e42:	e8 19 20 00 00       	call   80102e60 <end_op>
    cprintf("exec: fail\n");
80100e47:	83 ec 0c             	sub    $0xc,%esp
80100e4a:	68 81 72 10 80       	push   $0x80107281
80100e4f:	e8 5c f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e54:	83 c4 10             	add    $0x10,%esp
80100e57:	e9 f0 fd ff ff       	jmp    80100c4c <exec+0x16c>
80100e5c:	66 90                	xchg   %ax,%ax
80100e5e:	66 90                	xchg   %ax,%ax

80100e60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e66:	68 8d 72 10 80       	push   $0x8010728d
80100e6b:	68 60 ef 10 80       	push   $0x8010ef60
80100e70:	e8 eb 35 00 00       	call   80104460 <initlock>
}
80100e75:	83 c4 10             	add    $0x10,%esp
80100e78:	c9                   	leave
80100e79:	c3                   	ret
80100e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e84:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100e89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e8c:	68 60 ef 10 80       	push   $0x8010ef60
80100e91:	e8 ea 36 00 00       	call   80104580 <acquire>
80100e96:	83 c4 10             	add    $0x10,%esp
80100e99:	eb 10                	jmp    80100eab <filealloc+0x2b>
80100e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e9f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ea0:	83 c3 18             	add    $0x18,%ebx
80100ea3:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100ea9:	74 25                	je     80100ed0 <filealloc+0x50>
    if(f->ref == 0){
80100eab:	8b 43 04             	mov    0x4(%ebx),%eax
80100eae:	85 c0                	test   %eax,%eax
80100eb0:	75 ee                	jne    80100ea0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100eb2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100eb5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100ebc:	68 60 ef 10 80       	push   $0x8010ef60
80100ec1:	e8 fa 37 00 00       	call   801046c0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ec6:	89 d8                	mov    %ebx,%eax
      return f;
80100ec8:	83 c4 10             	add    $0x10,%esp
}
80100ecb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ece:	c9                   	leave
80100ecf:	c3                   	ret
  release(&ftable.lock);
80100ed0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ed3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ed5:	68 60 ef 10 80       	push   $0x8010ef60
80100eda:	e8 e1 37 00 00       	call   801046c0 <release>
}
80100edf:	89 d8                	mov    %ebx,%eax
  return 0;
80100ee1:	83 c4 10             	add    $0x10,%esp
}
80100ee4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ee7:	c9                   	leave
80100ee8:	c3                   	ret
80100ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 10             	sub    $0x10,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100efa:	68 60 ef 10 80       	push   $0x8010ef60
80100eff:	e8 7c 36 00 00       	call   80104580 <acquire>
  if(f->ref < 1)
80100f04:	8b 43 04             	mov    0x4(%ebx),%eax
80100f07:	83 c4 10             	add    $0x10,%esp
80100f0a:	85 c0                	test   %eax,%eax
80100f0c:	7e 1a                	jle    80100f28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f17:	68 60 ef 10 80       	push   $0x8010ef60
80100f1c:	e8 9f 37 00 00       	call   801046c0 <release>
  return f;
}
80100f21:	89 d8                	mov    %ebx,%eax
80100f23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f26:	c9                   	leave
80100f27:	c3                   	ret
    panic("filedup");
80100f28:	83 ec 0c             	sub    $0xc,%esp
80100f2b:	68 94 72 10 80       	push   $0x80107294
80100f30:	e8 4b f4 ff ff       	call   80100380 <panic>
80100f35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 28             	sub    $0x28,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f4c:	68 60 ef 10 80       	push   $0x8010ef60
80100f51:	e8 2a 36 00 00       	call   80104580 <acquire>
  if(f->ref < 1)
80100f56:	8b 53 04             	mov    0x4(%ebx),%edx
80100f59:	83 c4 10             	add    $0x10,%esp
80100f5c:	85 d2                	test   %edx,%edx
80100f5e:	0f 8e a5 00 00 00    	jle    80101009 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f64:	83 ea 01             	sub    $0x1,%edx
80100f67:	89 53 04             	mov    %edx,0x4(%ebx)
80100f6a:	75 44                	jne    80100fb0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f6c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f70:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f73:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f75:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f7b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f7e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f81:	8b 43 10             	mov    0x10(%ebx),%eax
80100f84:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f87:	68 60 ef 10 80       	push   $0x8010ef60
80100f8c:	e8 2f 37 00 00       	call   801046c0 <release>

  if(ff.type == FD_PIPE)
80100f91:	83 c4 10             	add    $0x10,%esp
80100f94:	83 ff 01             	cmp    $0x1,%edi
80100f97:	74 57                	je     80100ff0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f99:	83 ff 02             	cmp    $0x2,%edi
80100f9c:	74 2a                	je     80100fc8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fa1:	5b                   	pop    %ebx
80100fa2:	5e                   	pop    %esi
80100fa3:	5f                   	pop    %edi
80100fa4:	5d                   	pop    %ebp
80100fa5:	c3                   	ret
80100fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fad:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100fb0:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100fb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fba:	5b                   	pop    %ebx
80100fbb:	5e                   	pop    %esi
80100fbc:	5f                   	pop    %edi
80100fbd:	5d                   	pop    %ebp
    release(&ftable.lock);
80100fbe:	e9 fd 36 00 00       	jmp    801046c0 <release>
80100fc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100fc7:	90                   	nop
    begin_op();
80100fc8:	e8 23 1e 00 00       	call   80102df0 <begin_op>
    iput(ff.ip);
80100fcd:	83 ec 0c             	sub    $0xc,%esp
80100fd0:	ff 75 e0             	push   -0x20(%ebp)
80100fd3:	e8 48 09 00 00       	call   80101920 <iput>
    end_op();
80100fd8:	83 c4 10             	add    $0x10,%esp
}
80100fdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fde:	5b                   	pop    %ebx
80100fdf:	5e                   	pop    %esi
80100fe0:	5f                   	pop    %edi
80100fe1:	5d                   	pop    %ebp
    end_op();
80100fe2:	e9 79 1e 00 00       	jmp    80102e60 <end_op>
80100fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fee:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100ff0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ff4:	83 ec 08             	sub    $0x8,%esp
80100ff7:	53                   	push   %ebx
80100ff8:	56                   	push   %esi
80100ff9:	e8 c2 25 00 00       	call   801035c0 <pipeclose>
80100ffe:	83 c4 10             	add    $0x10,%esp
}
80101001:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101004:	5b                   	pop    %ebx
80101005:	5e                   	pop    %esi
80101006:	5f                   	pop    %edi
80101007:	5d                   	pop    %ebp
80101008:	c3                   	ret
    panic("fileclose");
80101009:	83 ec 0c             	sub    $0xc,%esp
8010100c:	68 9c 72 10 80       	push   $0x8010729c
80101011:	e8 6a f3 ff ff       	call   80100380 <panic>
80101016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010101d:	8d 76 00             	lea    0x0(%esi),%esi

80101020 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	53                   	push   %ebx
80101024:	83 ec 04             	sub    $0x4,%esp
80101027:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010102a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010102d:	75 31                	jne    80101060 <filestat+0x40>
    ilock(f->ip);
8010102f:	83 ec 0c             	sub    $0xc,%esp
80101032:	ff 73 10             	push   0x10(%ebx)
80101035:	e8 b6 07 00 00       	call   801017f0 <ilock>
    stati(f->ip, st);
8010103a:	58                   	pop    %eax
8010103b:	5a                   	pop    %edx
8010103c:	ff 75 0c             	push   0xc(%ebp)
8010103f:	ff 73 10             	push   0x10(%ebx)
80101042:	e8 89 0a 00 00       	call   80101ad0 <stati>
    iunlock(f->ip);
80101047:	59                   	pop    %ecx
80101048:	ff 73 10             	push   0x10(%ebx)
8010104b:	e8 80 08 00 00       	call   801018d0 <iunlock>
    return 0;
  }
  return -1;
}
80101050:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101053:	83 c4 10             	add    $0x10,%esp
80101056:	31 c0                	xor    %eax,%eax
}
80101058:	c9                   	leave
80101059:	c3                   	ret
8010105a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101060:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101063:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101068:	c9                   	leave
80101069:	c3                   	ret
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101070 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101070:	55                   	push   %ebp
80101071:	89 e5                	mov    %esp,%ebp
80101073:	57                   	push   %edi
80101074:	56                   	push   %esi
80101075:	53                   	push   %ebx
80101076:	83 ec 0c             	sub    $0xc,%esp
80101079:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010107c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010107f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101082:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101086:	74 60                	je     801010e8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101088:	8b 03                	mov    (%ebx),%eax
8010108a:	83 f8 01             	cmp    $0x1,%eax
8010108d:	74 41                	je     801010d0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010108f:	83 f8 02             	cmp    $0x2,%eax
80101092:	75 5b                	jne    801010ef <fileread+0x7f>
    ilock(f->ip);
80101094:	83 ec 0c             	sub    $0xc,%esp
80101097:	ff 73 10             	push   0x10(%ebx)
8010109a:	e8 51 07 00 00       	call   801017f0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010109f:	57                   	push   %edi
801010a0:	ff 73 14             	push   0x14(%ebx)
801010a3:	56                   	push   %esi
801010a4:	ff 73 10             	push   0x10(%ebx)
801010a7:	e8 54 0a 00 00       	call   80101b00 <readi>
801010ac:	83 c4 20             	add    $0x20,%esp
801010af:	89 c6                	mov    %eax,%esi
801010b1:	85 c0                	test   %eax,%eax
801010b3:	7e 03                	jle    801010b8 <fileread+0x48>
      f->off += r;
801010b5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010b8:	83 ec 0c             	sub    $0xc,%esp
801010bb:	ff 73 10             	push   0x10(%ebx)
801010be:	e8 0d 08 00 00       	call   801018d0 <iunlock>
    return r;
801010c3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c9:	89 f0                	mov    %esi,%eax
801010cb:	5b                   	pop    %ebx
801010cc:	5e                   	pop    %esi
801010cd:	5f                   	pop    %edi
801010ce:	5d                   	pop    %ebp
801010cf:	c3                   	ret
    return piperead(f->pipe, addr, n);
801010d0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010d3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d9:	5b                   	pop    %ebx
801010da:	5e                   	pop    %esi
801010db:	5f                   	pop    %edi
801010dc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010dd:	e9 9e 26 00 00       	jmp    80103780 <piperead>
801010e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010e8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010ed:	eb d7                	jmp    801010c6 <fileread+0x56>
  panic("fileread");
801010ef:	83 ec 0c             	sub    $0xc,%esp
801010f2:	68 a6 72 10 80       	push   $0x801072a6
801010f7:	e8 84 f2 ff ff       	call   80100380 <panic>
801010fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101100 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 1c             	sub    $0x1c,%esp
80101109:	8b 45 0c             	mov    0xc(%ebp),%eax
8010110c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010110f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101112:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101115:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101119:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010111c:	0f 84 bb 00 00 00    	je     801011dd <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
80101122:	8b 03                	mov    (%ebx),%eax
80101124:	83 f8 01             	cmp    $0x1,%eax
80101127:	0f 84 bf 00 00 00    	je     801011ec <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010112d:	83 f8 02             	cmp    $0x2,%eax
80101130:	0f 85 c8 00 00 00    	jne    801011fe <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101136:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101139:	31 f6                	xor    %esi,%esi
    while(i < n){
8010113b:	85 c0                	test   %eax,%eax
8010113d:	7f 30                	jg     8010116f <filewrite+0x6f>
8010113f:	e9 94 00 00 00       	jmp    801011d8 <filewrite+0xd8>
80101144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101148:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010114b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010114e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101151:	ff 73 10             	push   0x10(%ebx)
80101154:	e8 77 07 00 00       	call   801018d0 <iunlock>
      end_op();
80101159:	e8 02 1d 00 00       	call   80102e60 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010115e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101161:	83 c4 10             	add    $0x10,%esp
80101164:	39 c7                	cmp    %eax,%edi
80101166:	75 5c                	jne    801011c4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101168:	01 fe                	add    %edi,%esi
    while(i < n){
8010116a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010116d:	7e 69                	jle    801011d8 <filewrite+0xd8>
      int n1 = n - i;
8010116f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101172:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101177:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101179:	39 c7                	cmp    %eax,%edi
8010117b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010117e:	e8 6d 1c 00 00       	call   80102df0 <begin_op>
      ilock(f->ip);
80101183:	83 ec 0c             	sub    $0xc,%esp
80101186:	ff 73 10             	push   0x10(%ebx)
80101189:	e8 62 06 00 00       	call   801017f0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010118e:	57                   	push   %edi
8010118f:	ff 73 14             	push   0x14(%ebx)
80101192:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101195:	01 f0                	add    %esi,%eax
80101197:	50                   	push   %eax
80101198:	ff 73 10             	push   0x10(%ebx)
8010119b:	e8 60 0a 00 00       	call   80101c00 <writei>
801011a0:	83 c4 20             	add    $0x20,%esp
801011a3:	85 c0                	test   %eax,%eax
801011a5:	7f a1                	jg     80101148 <filewrite+0x48>
801011a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801011aa:	83 ec 0c             	sub    $0xc,%esp
801011ad:	ff 73 10             	push   0x10(%ebx)
801011b0:	e8 1b 07 00 00       	call   801018d0 <iunlock>
      end_op();
801011b5:	e8 a6 1c 00 00       	call   80102e60 <end_op>
      if(r < 0)
801011ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011bd:	83 c4 10             	add    $0x10,%esp
801011c0:	85 c0                	test   %eax,%eax
801011c2:	75 14                	jne    801011d8 <filewrite+0xd8>
        panic("short filewrite");
801011c4:	83 ec 0c             	sub    $0xc,%esp
801011c7:	68 af 72 10 80       	push   $0x801072af
801011cc:	e8 af f1 ff ff       	call   80100380 <panic>
801011d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801011d8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011db:	74 05                	je     801011e2 <filewrite+0xe2>
    return -1;
801011dd:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
801011e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011e5:	89 f0                	mov    %esi,%eax
801011e7:	5b                   	pop    %ebx
801011e8:	5e                   	pop    %esi
801011e9:	5f                   	pop    %edi
801011ea:	5d                   	pop    %ebp
801011eb:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801011ec:	8b 43 0c             	mov    0xc(%ebx),%eax
801011ef:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011f5:	5b                   	pop    %ebx
801011f6:	5e                   	pop    %esi
801011f7:	5f                   	pop    %edi
801011f8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011f9:	e9 62 24 00 00       	jmp    80103660 <pipewrite>
  panic("filewrite");
801011fe:	83 ec 0c             	sub    $0xc,%esp
80101201:	68 b5 72 10 80       	push   $0x801072b5
80101206:	e8 75 f1 ff ff       	call   80100380 <panic>
8010120b:	66 90                	xchg   %ax,%ax
8010120d:	66 90                	xchg   %ax,%ax
8010120f:	90                   	nop

80101210 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	56                   	push   %esi
80101215:	53                   	push   %ebx
80101216:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101219:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
8010121f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101222:	85 c9                	test   %ecx,%ecx
80101224:	0f 84 8c 00 00 00    	je     801012b6 <balloc+0xa6>
8010122a:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
8010122c:	89 f8                	mov    %edi,%eax
8010122e:	83 ec 08             	sub    $0x8,%esp
80101231:	89 fe                	mov    %edi,%esi
80101233:	c1 f8 0c             	sar    $0xc,%eax
80101236:	03 05 cc 15 11 80    	add    0x801115cc,%eax
8010123c:	50                   	push   %eax
8010123d:	ff 75 dc             	push   -0x24(%ebp)
80101240:	e8 8b ee ff ff       	call   801000d0 <bread>
80101245:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101248:	83 c4 10             	add    $0x10,%esp
8010124b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010124e:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101253:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101256:	31 c0                	xor    %eax,%eax
80101258:	eb 32                	jmp    8010128c <balloc+0x7c>
8010125a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101260:	89 c1                	mov    %eax,%ecx
80101262:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101267:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010126a:	83 e1 07             	and    $0x7,%ecx
8010126d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010126f:	89 c1                	mov    %eax,%ecx
80101271:	c1 f9 03             	sar    $0x3,%ecx
80101274:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101279:	89 fa                	mov    %edi,%edx
8010127b:	85 df                	test   %ebx,%edi
8010127d:	74 49                	je     801012c8 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010127f:	83 c0 01             	add    $0x1,%eax
80101282:	83 c6 01             	add    $0x1,%esi
80101285:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010128a:	74 07                	je     80101293 <balloc+0x83>
8010128c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010128f:	39 d6                	cmp    %edx,%esi
80101291:	72 cd                	jb     80101260 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101293:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101296:	83 ec 0c             	sub    $0xc,%esp
80101299:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010129c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
801012a2:	e8 49 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012a7:	83 c4 10             	add    $0x10,%esp
801012aa:	3b 3d b4 15 11 80    	cmp    0x801115b4,%edi
801012b0:	0f 82 76 ff ff ff    	jb     8010122c <balloc+0x1c>
  }
  panic("balloc: out of blocks");
801012b6:	83 ec 0c             	sub    $0xc,%esp
801012b9:	68 bf 72 10 80       	push   $0x801072bf
801012be:	e8 bd f0 ff ff       	call   80100380 <panic>
801012c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012c7:	90                   	nop
        bp->data[bi/8] |= m;  // Mark block in use.
801012c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012cb:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012ce:	09 da                	or     %ebx,%edx
801012d0:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012d4:	57                   	push   %edi
801012d5:	e8 f6 1c 00 00       	call   80102fd0 <log_write>
        brelse(bp);
801012da:	89 3c 24             	mov    %edi,(%esp)
801012dd:	e8 0e ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012e2:	58                   	pop    %eax
801012e3:	5a                   	pop    %edx
801012e4:	56                   	push   %esi
801012e5:	ff 75 dc             	push   -0x24(%ebp)
801012e8:	e8 e3 ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801012ed:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801012f0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012f2:	8d 40 5c             	lea    0x5c(%eax),%eax
801012f5:	68 00 02 00 00       	push   $0x200
801012fa:	6a 00                	push   $0x0
801012fc:	50                   	push   %eax
801012fd:	e8 0e 34 00 00       	call   80104710 <memset>
  log_write(bp);
80101302:	89 1c 24             	mov    %ebx,(%esp)
80101305:	e8 c6 1c 00 00       	call   80102fd0 <log_write>
  brelse(bp);
8010130a:	89 1c 24             	mov    %ebx,(%esp)
8010130d:	e8 de ee ff ff       	call   801001f0 <brelse>
}
80101312:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101315:	89 f0                	mov    %esi,%eax
80101317:	5b                   	pop    %ebx
80101318:	5e                   	pop    %esi
80101319:	5f                   	pop    %edi
8010131a:	5d                   	pop    %ebp
8010131b:	c3                   	ret
8010131c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101320 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101320:	55                   	push   %ebp
80101321:	89 e5                	mov    %esp,%ebp
80101323:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101324:	31 ff                	xor    %edi,%edi
{
80101326:	56                   	push   %esi
80101327:	89 c6                	mov    %eax,%esi
80101329:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010132a:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
8010132f:	83 ec 28             	sub    $0x28,%esp
80101332:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101335:	68 60 f9 10 80       	push   $0x8010f960
8010133a:	e8 41 32 00 00       	call   80104580 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010133f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101342:	83 c4 10             	add    $0x10,%esp
80101345:	eb 1b                	jmp    80101362 <iget+0x42>
80101347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101350:	39 33                	cmp    %esi,(%ebx)
80101352:	74 6c                	je     801013c0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101354:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010135a:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101360:	74 26                	je     80101388 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101362:	8b 43 08             	mov    0x8(%ebx),%eax
80101365:	85 c0                	test   %eax,%eax
80101367:	7f e7                	jg     80101350 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101369:	85 ff                	test   %edi,%edi
8010136b:	75 e7                	jne    80101354 <iget+0x34>
8010136d:	85 c0                	test   %eax,%eax
8010136f:	75 76                	jne    801013e7 <iget+0xc7>
80101371:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101373:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101379:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
8010137f:	75 e1                	jne    80101362 <iget+0x42>
80101381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101388:	85 ff                	test   %edi,%edi
8010138a:	74 79                	je     80101405 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010138c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010138f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101391:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101394:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
8010139b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
801013a2:	68 60 f9 10 80       	push   $0x8010f960
801013a7:	e8 14 33 00 00       	call   801046c0 <release>

  return ip;
801013ac:	83 c4 10             	add    $0x10,%esp
}
801013af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013b2:	89 f8                	mov    %edi,%eax
801013b4:	5b                   	pop    %ebx
801013b5:	5e                   	pop    %esi
801013b6:	5f                   	pop    %edi
801013b7:	5d                   	pop    %ebp
801013b8:	c3                   	ret
801013b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013c0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013c3:	75 8f                	jne    80101354 <iget+0x34>
      ip->ref++;
801013c5:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
801013c8:	83 ec 0c             	sub    $0xc,%esp
      return ip;
801013cb:	89 df                	mov    %ebx,%edi
      ip->ref++;
801013cd:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801013d0:	68 60 f9 10 80       	push   $0x8010f960
801013d5:	e8 e6 32 00 00       	call   801046c0 <release>
      return ip;
801013da:	83 c4 10             	add    $0x10,%esp
}
801013dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e0:	89 f8                	mov    %edi,%eax
801013e2:	5b                   	pop    %ebx
801013e3:	5e                   	pop    %esi
801013e4:	5f                   	pop    %edi
801013e5:	5d                   	pop    %ebp
801013e6:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013e7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013ed:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801013f3:	74 10                	je     80101405 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f5:	8b 43 08             	mov    0x8(%ebx),%eax
801013f8:	85 c0                	test   %eax,%eax
801013fa:	0f 8f 50 ff ff ff    	jg     80101350 <iget+0x30>
80101400:	e9 68 ff ff ff       	jmp    8010136d <iget+0x4d>
    panic("iget: no inodes");
80101405:	83 ec 0c             	sub    $0xc,%esp
80101408:	68 d5 72 10 80       	push   $0x801072d5
8010140d:	e8 6e ef ff ff       	call   80100380 <panic>
80101412:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101420 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	57                   	push   %edi
80101424:	56                   	push   %esi
80101425:	89 c6                	mov    %eax,%esi
80101427:	53                   	push   %ebx
80101428:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010142b:	83 fa 0b             	cmp    $0xb,%edx
8010142e:	0f 86 8c 00 00 00    	jbe    801014c0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101434:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101437:	83 fb 7f             	cmp    $0x7f,%ebx
8010143a:	0f 87 a2 00 00 00    	ja     801014e2 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101440:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101446:	85 c0                	test   %eax,%eax
80101448:	74 5e                	je     801014a8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010144a:	83 ec 08             	sub    $0x8,%esp
8010144d:	50                   	push   %eax
8010144e:	ff 36                	push   (%esi)
80101450:	e8 7b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101455:	83 c4 10             	add    $0x10,%esp
80101458:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010145c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010145e:	8b 3b                	mov    (%ebx),%edi
80101460:	85 ff                	test   %edi,%edi
80101462:	74 1c                	je     80101480 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101464:	83 ec 0c             	sub    $0xc,%esp
80101467:	52                   	push   %edx
80101468:	e8 83 ed ff ff       	call   801001f0 <brelse>
8010146d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101470:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101473:	89 f8                	mov    %edi,%eax
80101475:	5b                   	pop    %ebx
80101476:	5e                   	pop    %esi
80101477:	5f                   	pop    %edi
80101478:	5d                   	pop    %ebp
80101479:	c3                   	ret
8010147a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101480:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101483:	8b 06                	mov    (%esi),%eax
80101485:	e8 86 fd ff ff       	call   80101210 <balloc>
      log_write(bp);
8010148a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010148d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101490:	89 03                	mov    %eax,(%ebx)
80101492:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101494:	52                   	push   %edx
80101495:	e8 36 1b 00 00       	call   80102fd0 <log_write>
8010149a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010149d:	83 c4 10             	add    $0x10,%esp
801014a0:	eb c2                	jmp    80101464 <bmap+0x44>
801014a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014a8:	8b 06                	mov    (%esi),%eax
801014aa:	e8 61 fd ff ff       	call   80101210 <balloc>
801014af:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014b5:	eb 93                	jmp    8010144a <bmap+0x2a>
801014b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014be:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801014c0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014c3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014c7:	85 ff                	test   %edi,%edi
801014c9:	75 a5                	jne    80101470 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014cb:	8b 00                	mov    (%eax),%eax
801014cd:	e8 3e fd ff ff       	call   80101210 <balloc>
801014d2:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
801014d6:	89 c7                	mov    %eax,%edi
}
801014d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014db:	5b                   	pop    %ebx
801014dc:	89 f8                	mov    %edi,%eax
801014de:	5e                   	pop    %esi
801014df:	5f                   	pop    %edi
801014e0:	5d                   	pop    %ebp
801014e1:	c3                   	ret
  panic("bmap: out of range");
801014e2:	83 ec 0c             	sub    $0xc,%esp
801014e5:	68 e5 72 10 80       	push   $0x801072e5
801014ea:	e8 91 ee ff ff       	call   80100380 <panic>
801014ef:	90                   	nop

801014f0 <bfree>:
{
801014f0:	55                   	push   %ebp
801014f1:	89 e5                	mov    %esp,%ebp
801014f3:	57                   	push   %edi
801014f4:	56                   	push   %esi
801014f5:	89 c6                	mov    %eax,%esi
801014f7:	53                   	push   %ebx
801014f8:	89 d3                	mov    %edx,%ebx
801014fa:	83 ec 14             	sub    $0x14,%esp
  bp = bread(dev, 1);
801014fd:	6a 01                	push   $0x1
801014ff:	50                   	push   %eax
80101500:	e8 cb eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101505:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101508:	89 c7                	mov    %eax,%edi
  memmove(sb, bp->data, sizeof(*sb));
8010150a:	83 c0 5c             	add    $0x5c,%eax
8010150d:	6a 1c                	push   $0x1c
8010150f:	50                   	push   %eax
80101510:	68 b4 15 11 80       	push   $0x801115b4
80101515:	e8 86 32 00 00       	call   801047a0 <memmove>
  brelse(bp);
8010151a:	89 3c 24             	mov    %edi,(%esp)
8010151d:	e8 ce ec ff ff       	call   801001f0 <brelse>
  bp = bread(dev, BBLOCK(b, sb));
80101522:	58                   	pop    %eax
80101523:	89 d8                	mov    %ebx,%eax
80101525:	5a                   	pop    %edx
80101526:	c1 e8 0c             	shr    $0xc,%eax
80101529:	03 05 cc 15 11 80    	add    0x801115cc,%eax
8010152f:	50                   	push   %eax
80101530:	56                   	push   %esi
80101531:	e8 9a eb ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
80101536:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101538:	c1 fb 03             	sar    $0x3,%ebx
8010153b:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
8010153e:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101540:	83 e1 07             	and    $0x7,%ecx
80101543:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101548:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
8010154e:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101550:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
80101555:	85 c1                	test   %eax,%ecx
80101557:	74 24                	je     8010157d <bfree+0x8d>
  bp->data[bi/8] &= ~m;
80101559:	f7 d0                	not    %eax
  log_write(bp);
8010155b:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
8010155e:	21 c8                	and    %ecx,%eax
80101560:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
80101564:	56                   	push   %esi
80101565:	e8 66 1a 00 00       	call   80102fd0 <log_write>
  brelse(bp);
8010156a:	89 34 24             	mov    %esi,(%esp)
8010156d:	e8 7e ec ff ff       	call   801001f0 <brelse>
}
80101572:	83 c4 10             	add    $0x10,%esp
80101575:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101578:	5b                   	pop    %ebx
80101579:	5e                   	pop    %esi
8010157a:	5f                   	pop    %edi
8010157b:	5d                   	pop    %ebp
8010157c:	c3                   	ret
    panic("freeing free block");
8010157d:	83 ec 0c             	sub    $0xc,%esp
80101580:	68 f8 72 10 80       	push   $0x801072f8
80101585:	e8 f6 ed ff ff       	call   80100380 <panic>
8010158a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101590 <readsb>:
{
80101590:	55                   	push   %ebp
80101591:	89 e5                	mov    %esp,%ebp
80101593:	56                   	push   %esi
80101594:	53                   	push   %ebx
80101595:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101598:	83 ec 08             	sub    $0x8,%esp
8010159b:	6a 01                	push   $0x1
8010159d:	ff 75 08             	push   0x8(%ebp)
801015a0:	e8 2b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015a5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015a8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015aa:	8d 40 5c             	lea    0x5c(%eax),%eax
801015ad:	6a 1c                	push   $0x1c
801015af:	50                   	push   %eax
801015b0:	56                   	push   %esi
801015b1:	e8 ea 31 00 00       	call   801047a0 <memmove>
  brelse(bp);
801015b6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801015b9:	83 c4 10             	add    $0x10,%esp
}
801015bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015bf:	5b                   	pop    %ebx
801015c0:	5e                   	pop    %esi
801015c1:	5d                   	pop    %ebp
  brelse(bp);
801015c2:	e9 29 ec ff ff       	jmp    801001f0 <brelse>
801015c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ce:	66 90                	xchg   %ax,%ax

801015d0 <iinit>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	53                   	push   %ebx
801015d4:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
801015d9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015dc:	68 0b 73 10 80       	push   $0x8010730b
801015e1:	68 60 f9 10 80       	push   $0x8010f960
801015e6:	e8 75 2e 00 00       	call   80104460 <initlock>
  for(i = 0; i < NINODE; i++) {
801015eb:	83 c4 10             	add    $0x10,%esp
801015ee:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015f0:	83 ec 08             	sub    $0x8,%esp
801015f3:	68 12 73 10 80       	push   $0x80107312
801015f8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015f9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015ff:	e8 4c 2d 00 00       	call   80104350 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101604:	83 c4 10             	add    $0x10,%esp
80101607:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
8010160d:	75 e1                	jne    801015f0 <iinit+0x20>
  bp = bread(dev, 1);
8010160f:	83 ec 08             	sub    $0x8,%esp
80101612:	6a 01                	push   $0x1
80101614:	ff 75 08             	push   0x8(%ebp)
80101617:	e8 b4 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010161c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010161f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101621:	8d 40 5c             	lea    0x5c(%eax),%eax
80101624:	6a 1c                	push   $0x1c
80101626:	50                   	push   %eax
80101627:	68 b4 15 11 80       	push   $0x801115b4
8010162c:	e8 6f 31 00 00       	call   801047a0 <memmove>
  brelse(bp);
80101631:	89 1c 24             	mov    %ebx,(%esp)
80101634:	e8 b7 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101639:	ff 35 cc 15 11 80    	push   0x801115cc
8010163f:	ff 35 c8 15 11 80    	push   0x801115c8
80101645:	ff 35 c4 15 11 80    	push   0x801115c4
8010164b:	ff 35 c0 15 11 80    	push   0x801115c0
80101651:	ff 35 bc 15 11 80    	push   0x801115bc
80101657:	ff 35 b8 15 11 80    	push   0x801115b8
8010165d:	ff 35 b4 15 11 80    	push   0x801115b4
80101663:	68 78 73 10 80       	push   $0x80107378
80101668:	e8 43 f0 ff ff       	call   801006b0 <cprintf>
}
8010166d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101670:	83 c4 30             	add    $0x30,%esp
80101673:	c9                   	leave
80101674:	c3                   	ret
80101675:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <ialloc>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	57                   	push   %edi
80101684:	56                   	push   %esi
80101685:	53                   	push   %ebx
80101686:	83 ec 1c             	sub    $0x1c,%esp
80101689:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010168c:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
80101693:	8b 75 08             	mov    0x8(%ebp),%esi
80101696:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101699:	0f 86 91 00 00 00    	jbe    80101730 <ialloc+0xb0>
8010169f:	bf 01 00 00 00       	mov    $0x1,%edi
801016a4:	eb 21                	jmp    801016c7 <ialloc+0x47>
801016a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016ad:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801016b0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801016b3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801016b6:	53                   	push   %ebx
801016b7:	e8 34 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801016bc:	83 c4 10             	add    $0x10,%esp
801016bf:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
801016c5:	73 69                	jae    80101730 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801016c7:	89 f8                	mov    %edi,%eax
801016c9:	83 ec 08             	sub    $0x8,%esp
801016cc:	c1 e8 03             	shr    $0x3,%eax
801016cf:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801016d5:	50                   	push   %eax
801016d6:	56                   	push   %esi
801016d7:	e8 f4 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801016dc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801016df:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801016e1:	89 f8                	mov    %edi,%eax
801016e3:	83 e0 07             	and    $0x7,%eax
801016e6:	c1 e0 06             	shl    $0x6,%eax
801016e9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016ed:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016f1:	75 bd                	jne    801016b0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016f3:	83 ec 04             	sub    $0x4,%esp
801016f6:	6a 40                	push   $0x40
801016f8:	6a 00                	push   $0x0
801016fa:	51                   	push   %ecx
801016fb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016fe:	e8 0d 30 00 00       	call   80104710 <memset>
      dip->type = type;
80101703:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101707:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010170a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010170d:	89 1c 24             	mov    %ebx,(%esp)
80101710:	e8 bb 18 00 00       	call   80102fd0 <log_write>
      brelse(bp);
80101715:	89 1c 24             	mov    %ebx,(%esp)
80101718:	e8 d3 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010171d:	83 c4 10             	add    $0x10,%esp
}
80101720:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101723:	89 fa                	mov    %edi,%edx
}
80101725:	5b                   	pop    %ebx
      return iget(dev, inum);
80101726:	89 f0                	mov    %esi,%eax
}
80101728:	5e                   	pop    %esi
80101729:	5f                   	pop    %edi
8010172a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010172b:	e9 f0 fb ff ff       	jmp    80101320 <iget>
  panic("ialloc: no inodes");
80101730:	83 ec 0c             	sub    $0xc,%esp
80101733:	68 18 73 10 80       	push   $0x80107318
80101738:	e8 43 ec ff ff       	call   80100380 <panic>
8010173d:	8d 76 00             	lea    0x0(%esi),%esi

80101740 <iupdate>:
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	56                   	push   %esi
80101744:	53                   	push   %ebx
80101745:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101748:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010174b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010174e:	83 ec 08             	sub    $0x8,%esp
80101751:	c1 e8 03             	shr    $0x3,%eax
80101754:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010175a:	50                   	push   %eax
8010175b:	ff 73 a4             	push   -0x5c(%ebx)
8010175e:	e8 6d e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101763:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101767:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010176a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010176c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010176f:	83 e0 07             	and    $0x7,%eax
80101772:	c1 e0 06             	shl    $0x6,%eax
80101775:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101779:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010177c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101780:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101783:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101787:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010178b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010178f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101793:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101797:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010179a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010179d:	6a 34                	push   $0x34
8010179f:	53                   	push   %ebx
801017a0:	50                   	push   %eax
801017a1:	e8 fa 2f 00 00       	call   801047a0 <memmove>
  log_write(bp);
801017a6:	89 34 24             	mov    %esi,(%esp)
801017a9:	e8 22 18 00 00       	call   80102fd0 <log_write>
  brelse(bp);
801017ae:	89 75 08             	mov    %esi,0x8(%ebp)
801017b1:	83 c4 10             	add    $0x10,%esp
}
801017b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b7:	5b                   	pop    %ebx
801017b8:	5e                   	pop    %esi
801017b9:	5d                   	pop    %ebp
  brelse(bp);
801017ba:	e9 31 ea ff ff       	jmp    801001f0 <brelse>
801017bf:	90                   	nop

801017c0 <idup>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	53                   	push   %ebx
801017c4:	83 ec 10             	sub    $0x10,%esp
801017c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801017ca:	68 60 f9 10 80       	push   $0x8010f960
801017cf:	e8 ac 2d 00 00       	call   80104580 <acquire>
  ip->ref++;
801017d4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017d8:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801017df:	e8 dc 2e 00 00       	call   801046c0 <release>
}
801017e4:	89 d8                	mov    %ebx,%eax
801017e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017e9:	c9                   	leave
801017ea:	c3                   	ret
801017eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017ef:	90                   	nop

801017f0 <ilock>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	56                   	push   %esi
801017f4:	53                   	push   %ebx
801017f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017f8:	85 db                	test   %ebx,%ebx
801017fa:	0f 84 b7 00 00 00    	je     801018b7 <ilock+0xc7>
80101800:	8b 53 08             	mov    0x8(%ebx),%edx
80101803:	85 d2                	test   %edx,%edx
80101805:	0f 8e ac 00 00 00    	jle    801018b7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010180b:	83 ec 0c             	sub    $0xc,%esp
8010180e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101811:	50                   	push   %eax
80101812:	e8 79 2b 00 00       	call   80104390 <acquiresleep>
  if(ip->valid == 0){
80101817:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010181a:	83 c4 10             	add    $0x10,%esp
8010181d:	85 c0                	test   %eax,%eax
8010181f:	74 0f                	je     80101830 <ilock+0x40>
}
80101821:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101824:	5b                   	pop    %ebx
80101825:	5e                   	pop    %esi
80101826:	5d                   	pop    %ebp
80101827:	c3                   	ret
80101828:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010182f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101830:	8b 43 04             	mov    0x4(%ebx),%eax
80101833:	83 ec 08             	sub    $0x8,%esp
80101836:	c1 e8 03             	shr    $0x3,%eax
80101839:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010183f:	50                   	push   %eax
80101840:	ff 33                	push   (%ebx)
80101842:	e8 89 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101847:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010184a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010184c:	8b 43 04             	mov    0x4(%ebx),%eax
8010184f:	83 e0 07             	and    $0x7,%eax
80101852:	c1 e0 06             	shl    $0x6,%eax
80101855:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101859:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010185c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010185f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101863:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101867:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010186b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010186f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101873:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101877:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010187b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010187e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101881:	6a 34                	push   $0x34
80101883:	50                   	push   %eax
80101884:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101887:	50                   	push   %eax
80101888:	e8 13 2f 00 00       	call   801047a0 <memmove>
    brelse(bp);
8010188d:	89 34 24             	mov    %esi,(%esp)
80101890:	e8 5b e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101895:	83 c4 10             	add    $0x10,%esp
80101898:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010189d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801018a4:	0f 85 77 ff ff ff    	jne    80101821 <ilock+0x31>
      panic("ilock: no type");
801018aa:	83 ec 0c             	sub    $0xc,%esp
801018ad:	68 30 73 10 80       	push   $0x80107330
801018b2:	e8 c9 ea ff ff       	call   80100380 <panic>
    panic("ilock");
801018b7:	83 ec 0c             	sub    $0xc,%esp
801018ba:	68 2a 73 10 80       	push   $0x8010732a
801018bf:	e8 bc ea ff ff       	call   80100380 <panic>
801018c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018cf:	90                   	nop

801018d0 <iunlock>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	56                   	push   %esi
801018d4:	53                   	push   %ebx
801018d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018d8:	85 db                	test   %ebx,%ebx
801018da:	74 28                	je     80101904 <iunlock+0x34>
801018dc:	83 ec 0c             	sub    $0xc,%esp
801018df:	8d 73 0c             	lea    0xc(%ebx),%esi
801018e2:	56                   	push   %esi
801018e3:	e8 48 2b 00 00       	call   80104430 <holdingsleep>
801018e8:	83 c4 10             	add    $0x10,%esp
801018eb:	85 c0                	test   %eax,%eax
801018ed:	74 15                	je     80101904 <iunlock+0x34>
801018ef:	8b 43 08             	mov    0x8(%ebx),%eax
801018f2:	85 c0                	test   %eax,%eax
801018f4:	7e 0e                	jle    80101904 <iunlock+0x34>
  releasesleep(&ip->lock);
801018f6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018ff:	e9 ec 2a 00 00       	jmp    801043f0 <releasesleep>
    panic("iunlock");
80101904:	83 ec 0c             	sub    $0xc,%esp
80101907:	68 3f 73 10 80       	push   $0x8010733f
8010190c:	e8 6f ea ff ff       	call   80100380 <panic>
80101911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101918:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010191f:	90                   	nop

80101920 <iput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	57                   	push   %edi
80101924:	56                   	push   %esi
80101925:	53                   	push   %ebx
80101926:	83 ec 28             	sub    $0x28,%esp
80101929:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010192c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010192f:	57                   	push   %edi
80101930:	e8 5b 2a 00 00       	call   80104390 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101935:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101938:	83 c4 10             	add    $0x10,%esp
8010193b:	85 d2                	test   %edx,%edx
8010193d:	74 07                	je     80101946 <iput+0x26>
8010193f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101944:	74 32                	je     80101978 <iput+0x58>
  releasesleep(&ip->lock);
80101946:	83 ec 0c             	sub    $0xc,%esp
80101949:	57                   	push   %edi
8010194a:	e8 a1 2a 00 00       	call   801043f0 <releasesleep>
  acquire(&icache.lock);
8010194f:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101956:	e8 25 2c 00 00       	call   80104580 <acquire>
  ip->ref--;
8010195b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010195f:	83 c4 10             	add    $0x10,%esp
80101962:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
80101969:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010196c:	5b                   	pop    %ebx
8010196d:	5e                   	pop    %esi
8010196e:	5f                   	pop    %edi
8010196f:	5d                   	pop    %ebp
  release(&icache.lock);
80101970:	e9 4b 2d 00 00       	jmp    801046c0 <release>
80101975:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101978:	83 ec 0c             	sub    $0xc,%esp
8010197b:	68 60 f9 10 80       	push   $0x8010f960
80101980:	e8 fb 2b 00 00       	call   80104580 <acquire>
    int r = ip->ref;
80101985:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101988:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010198f:	e8 2c 2d 00 00       	call   801046c0 <release>
    if(r == 1){
80101994:	83 c4 10             	add    $0x10,%esp
80101997:	83 fe 01             	cmp    $0x1,%esi
8010199a:	75 aa                	jne    80101946 <iput+0x26>
8010199c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801019a2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019a5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801019a8:	89 df                	mov    %ebx,%edi
801019aa:	89 cb                	mov    %ecx,%ebx
801019ac:	eb 09                	jmp    801019b7 <iput+0x97>
801019ae:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801019b0:	83 c6 04             	add    $0x4,%esi
801019b3:	39 de                	cmp    %ebx,%esi
801019b5:	74 19                	je     801019d0 <iput+0xb0>
    if(ip->addrs[i]){
801019b7:	8b 16                	mov    (%esi),%edx
801019b9:	85 d2                	test   %edx,%edx
801019bb:	74 f3                	je     801019b0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801019bd:	8b 07                	mov    (%edi),%eax
801019bf:	e8 2c fb ff ff       	call   801014f0 <bfree>
      ip->addrs[i] = 0;
801019c4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801019ca:	eb e4                	jmp    801019b0 <iput+0x90>
801019cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019d0:	89 fb                	mov    %edi,%ebx
801019d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019d5:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801019db:	85 c0                	test   %eax,%eax
801019dd:	75 2d                	jne    80101a0c <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801019df:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801019e2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801019e9:	53                   	push   %ebx
801019ea:	e8 51 fd ff ff       	call   80101740 <iupdate>
      ip->type = 0;
801019ef:	31 c0                	xor    %eax,%eax
801019f1:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019f5:	89 1c 24             	mov    %ebx,(%esp)
801019f8:	e8 43 fd ff ff       	call   80101740 <iupdate>
      ip->valid = 0;
801019fd:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a04:	83 c4 10             	add    $0x10,%esp
80101a07:	e9 3a ff ff ff       	jmp    80101946 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a0c:	83 ec 08             	sub    $0x8,%esp
80101a0f:	50                   	push   %eax
80101a10:	ff 33                	push   (%ebx)
80101a12:	e8 b9 e6 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80101a17:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a1a:	83 c4 10             	add    $0x10,%esp
80101a1d:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a23:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101a26:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a29:	89 cf                	mov    %ecx,%edi
80101a2b:	eb 0a                	jmp    80101a37 <iput+0x117>
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi
80101a30:	83 c6 04             	add    $0x4,%esi
80101a33:	39 fe                	cmp    %edi,%esi
80101a35:	74 0f                	je     80101a46 <iput+0x126>
      if(a[j])
80101a37:	8b 16                	mov    (%esi),%edx
80101a39:	85 d2                	test   %edx,%edx
80101a3b:	74 f3                	je     80101a30 <iput+0x110>
        bfree(ip->dev, a[j]);
80101a3d:	8b 03                	mov    (%ebx),%eax
80101a3f:	e8 ac fa ff ff       	call   801014f0 <bfree>
80101a44:	eb ea                	jmp    80101a30 <iput+0x110>
    brelse(bp);
80101a46:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101a49:	83 ec 0c             	sub    $0xc,%esp
80101a4c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a4f:	50                   	push   %eax
80101a50:	e8 9b e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a55:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a5b:	8b 03                	mov    (%ebx),%eax
80101a5d:	e8 8e fa ff ff       	call   801014f0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a62:	83 c4 10             	add    $0x10,%esp
80101a65:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a6c:	00 00 00 
80101a6f:	e9 6b ff ff ff       	jmp    801019df <iput+0xbf>
80101a74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a7f:	90                   	nop

80101a80 <iunlockput>:
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	56                   	push   %esi
80101a84:	53                   	push   %ebx
80101a85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a88:	85 db                	test   %ebx,%ebx
80101a8a:	74 34                	je     80101ac0 <iunlockput+0x40>
80101a8c:	83 ec 0c             	sub    $0xc,%esp
80101a8f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a92:	56                   	push   %esi
80101a93:	e8 98 29 00 00       	call   80104430 <holdingsleep>
80101a98:	83 c4 10             	add    $0x10,%esp
80101a9b:	85 c0                	test   %eax,%eax
80101a9d:	74 21                	je     80101ac0 <iunlockput+0x40>
80101a9f:	8b 43 08             	mov    0x8(%ebx),%eax
80101aa2:	85 c0                	test   %eax,%eax
80101aa4:	7e 1a                	jle    80101ac0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101aa6:	83 ec 0c             	sub    $0xc,%esp
80101aa9:	56                   	push   %esi
80101aaa:	e8 41 29 00 00       	call   801043f0 <releasesleep>
  iput(ip);
80101aaf:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101ab2:	83 c4 10             	add    $0x10,%esp
}
80101ab5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ab8:	5b                   	pop    %ebx
80101ab9:	5e                   	pop    %esi
80101aba:	5d                   	pop    %ebp
  iput(ip);
80101abb:	e9 60 fe ff ff       	jmp    80101920 <iput>
    panic("iunlock");
80101ac0:	83 ec 0c             	sub    $0xc,%esp
80101ac3:	68 3f 73 10 80       	push   $0x8010733f
80101ac8:	e8 b3 e8 ff ff       	call   80100380 <panic>
80101acd:	8d 76 00             	lea    0x0(%esi),%esi

80101ad0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ad0:	55                   	push   %ebp
80101ad1:	89 e5                	mov    %esp,%ebp
80101ad3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101ad9:	8b 0a                	mov    (%edx),%ecx
80101adb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101ade:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ae1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ae4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ae8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101aeb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101aef:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101af3:	8b 52 58             	mov    0x58(%edx),%edx
80101af6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101af9:	5d                   	pop    %ebp
80101afa:	c3                   	ret
80101afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aff:	90                   	nop

80101b00 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	57                   	push   %edi
80101b04:	56                   	push   %esi
80101b05:	53                   	push   %ebx
80101b06:	83 ec 1c             	sub    $0x1c,%esp
80101b09:	8b 75 08             	mov    0x8(%ebp),%esi
80101b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b0f:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b12:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101b17:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101b1a:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101b1d:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101b20:	0f 84 aa 00 00 00    	je     80101bd0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b26:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101b29:	8b 56 58             	mov    0x58(%esi),%edx
80101b2c:	39 fa                	cmp    %edi,%edx
80101b2e:	0f 82 bd 00 00 00    	jb     80101bf1 <readi+0xf1>
80101b34:	89 f9                	mov    %edi,%ecx
80101b36:	31 db                	xor    %ebx,%ebx
80101b38:	01 c1                	add    %eax,%ecx
80101b3a:	0f 92 c3             	setb   %bl
80101b3d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101b40:	0f 82 ab 00 00 00    	jb     80101bf1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b46:	89 d3                	mov    %edx,%ebx
80101b48:	29 fb                	sub    %edi,%ebx
80101b4a:	39 ca                	cmp    %ecx,%edx
80101b4c:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b4f:	85 c0                	test   %eax,%eax
80101b51:	74 73                	je     80101bc6 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b53:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b60:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b63:	89 fa                	mov    %edi,%edx
80101b65:	c1 ea 09             	shr    $0x9,%edx
80101b68:	89 d8                	mov    %ebx,%eax
80101b6a:	e8 b1 f8 ff ff       	call   80101420 <bmap>
80101b6f:	83 ec 08             	sub    $0x8,%esp
80101b72:	50                   	push   %eax
80101b73:	ff 33                	push   (%ebx)
80101b75:	e8 56 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b7a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b7d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b82:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b84:	89 f8                	mov    %edi,%eax
80101b86:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b8b:	29 f3                	sub    %esi,%ebx
80101b8d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b8f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b93:	39 d9                	cmp    %ebx,%ecx
80101b95:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b98:	83 c4 0c             	add    $0xc,%esp
80101b9b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b9c:	01 de                	add    %ebx,%esi
80101b9e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101ba0:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101ba3:	50                   	push   %eax
80101ba4:	ff 75 e0             	push   -0x20(%ebp)
80101ba7:	e8 f4 2b 00 00       	call   801047a0 <memmove>
    brelse(bp);
80101bac:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101baf:	89 14 24             	mov    %edx,(%esp)
80101bb2:	e8 39 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bb7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101bba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101bbd:	83 c4 10             	add    $0x10,%esp
80101bc0:	39 de                	cmp    %ebx,%esi
80101bc2:	72 9c                	jb     80101b60 <readi+0x60>
80101bc4:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101bc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bc9:	5b                   	pop    %ebx
80101bca:	5e                   	pop    %esi
80101bcb:	5f                   	pop    %edi
80101bcc:	5d                   	pop    %ebp
80101bcd:	c3                   	ret
80101bce:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101bd0:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101bd4:	66 83 fa 09          	cmp    $0x9,%dx
80101bd8:	77 17                	ja     80101bf1 <readi+0xf1>
80101bda:	8b 14 d5 00 f9 10 80 	mov    -0x7fef0700(,%edx,8),%edx
80101be1:	85 d2                	test   %edx,%edx
80101be3:	74 0c                	je     80101bf1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101be5:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101be8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101beb:	5b                   	pop    %ebx
80101bec:	5e                   	pop    %esi
80101bed:	5f                   	pop    %edi
80101bee:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101bef:	ff e2                	jmp    *%edx
      return -1;
80101bf1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bf6:	eb ce                	jmp    80101bc6 <readi+0xc6>
80101bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bff:	90                   	nop

80101c00 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c00:	55                   	push   %ebp
80101c01:	89 e5                	mov    %esp,%ebp
80101c03:	57                   	push   %edi
80101c04:	56                   	push   %esi
80101c05:	53                   	push   %ebx
80101c06:	83 ec 1c             	sub    $0x1c,%esp
80101c09:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101c0f:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c12:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c17:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101c1a:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101c1d:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101c20:	0f 84 ca 00 00 00    	je     80101cf0 <writei+0xf0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c26:	39 78 58             	cmp    %edi,0x58(%eax)
80101c29:	0f 82 fa 00 00 00    	jb     80101d29 <writei+0x129>
80101c2f:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101c32:	31 c9                	xor    %ecx,%ecx
80101c34:	89 f2                	mov    %esi,%edx
80101c36:	01 fa                	add    %edi,%edx
80101c38:	0f 92 c1             	setb   %cl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c3b:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101c41:	0f 87 e2 00 00 00    	ja     80101d29 <writei+0x129>
80101c47:	85 c9                	test   %ecx,%ecx
80101c49:	0f 85 da 00 00 00    	jne    80101d29 <writei+0x129>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c4f:	85 f6                	test   %esi,%esi
80101c51:	0f 84 86 00 00 00    	je     80101cdd <writei+0xdd>
80101c57:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c5e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c68:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101c6b:	89 fa                	mov    %edi,%edx
80101c6d:	c1 ea 09             	shr    $0x9,%edx
80101c70:	89 f0                	mov    %esi,%eax
80101c72:	e8 a9 f7 ff ff       	call   80101420 <bmap>
80101c77:	83 ec 08             	sub    $0x8,%esp
80101c7a:	50                   	push   %eax
80101c7b:	ff 36                	push   (%esi)
80101c7d:	e8 4e e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c82:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c85:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c88:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c8d:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c8f:	89 f8                	mov    %edi,%eax
80101c91:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c96:	29 d3                	sub    %edx,%ebx
80101c98:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c9a:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c9e:	39 d9                	cmp    %ebx,%ecx
80101ca0:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ca3:	83 c4 0c             	add    $0xc,%esp
80101ca6:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ca7:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101ca9:	ff 75 dc             	push   -0x24(%ebp)
80101cac:	50                   	push   %eax
80101cad:	e8 ee 2a 00 00       	call   801047a0 <memmove>
    log_write(bp);
80101cb2:	89 34 24             	mov    %esi,(%esp)
80101cb5:	e8 16 13 00 00       	call   80102fd0 <log_write>
    brelse(bp);
80101cba:	89 34 24             	mov    %esi,(%esp)
80101cbd:	e8 2e e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cc2:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101cc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101cc8:	83 c4 10             	add    $0x10,%esp
80101ccb:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101cce:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101cd1:	39 d8                	cmp    %ebx,%eax
80101cd3:	72 93                	jb     80101c68 <writei+0x68>
  }

  if(n > 0 && off > ip->size){
80101cd5:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cd8:	39 78 58             	cmp    %edi,0x58(%eax)
80101cdb:	72 3b                	jb     80101d18 <writei+0x118>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101cdd:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ce3:	5b                   	pop    %ebx
80101ce4:	5e                   	pop    %esi
80101ce5:	5f                   	pop    %edi
80101ce6:	5d                   	pop    %ebp
80101ce7:	c3                   	ret
80101ce8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cef:	90                   	nop
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101cf0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cf4:	66 83 f8 09          	cmp    $0x9,%ax
80101cf8:	77 2f                	ja     80101d29 <writei+0x129>
80101cfa:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101d01:	85 c0                	test   %eax,%eax
80101d03:	74 24                	je     80101d29 <writei+0x129>
    return devsw[ip->major].write(ip, src, n);
80101d05:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101d08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d0b:	5b                   	pop    %ebx
80101d0c:	5e                   	pop    %esi
80101d0d:	5f                   	pop    %edi
80101d0e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d0f:	ff e0                	jmp    *%eax
80101d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101d18:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d1b:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101d1e:	50                   	push   %eax
80101d1f:	e8 1c fa ff ff       	call   80101740 <iupdate>
80101d24:	83 c4 10             	add    $0x10,%esp
80101d27:	eb b4                	jmp    80101cdd <writei+0xdd>
      return -1;
80101d29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d2e:	eb b0                	jmp    80101ce0 <writei+0xe0>

80101d30 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d30:	55                   	push   %ebp
80101d31:	89 e5                	mov    %esp,%ebp
80101d33:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d36:	6a 0e                	push   $0xe
80101d38:	ff 75 0c             	push   0xc(%ebp)
80101d3b:	ff 75 08             	push   0x8(%ebp)
80101d3e:	e8 cd 2a 00 00       	call   80104810 <strncmp>
}
80101d43:	c9                   	leave
80101d44:	c3                   	ret
80101d45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d50 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d50:	55                   	push   %ebp
80101d51:	89 e5                	mov    %esp,%ebp
80101d53:	57                   	push   %edi
80101d54:	56                   	push   %esi
80101d55:	53                   	push   %ebx
80101d56:	83 ec 1c             	sub    $0x1c,%esp
80101d59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d5c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d61:	0f 85 85 00 00 00    	jne    80101dec <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d67:	8b 53 58             	mov    0x58(%ebx),%edx
80101d6a:	31 ff                	xor    %edi,%edi
80101d6c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d6f:	85 d2                	test   %edx,%edx
80101d71:	74 3e                	je     80101db1 <dirlookup+0x61>
80101d73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d77:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d78:	6a 10                	push   $0x10
80101d7a:	57                   	push   %edi
80101d7b:	56                   	push   %esi
80101d7c:	53                   	push   %ebx
80101d7d:	e8 7e fd ff ff       	call   80101b00 <readi>
80101d82:	83 c4 10             	add    $0x10,%esp
80101d85:	83 f8 10             	cmp    $0x10,%eax
80101d88:	75 55                	jne    80101ddf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d8a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d8f:	74 18                	je     80101da9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d91:	83 ec 04             	sub    $0x4,%esp
80101d94:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d97:	6a 0e                	push   $0xe
80101d99:	50                   	push   %eax
80101d9a:	ff 75 0c             	push   0xc(%ebp)
80101d9d:	e8 6e 2a 00 00       	call   80104810 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101da2:	83 c4 10             	add    $0x10,%esp
80101da5:	85 c0                	test   %eax,%eax
80101da7:	74 17                	je     80101dc0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101da9:	83 c7 10             	add    $0x10,%edi
80101dac:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101daf:	72 c7                	jb     80101d78 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101db1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101db4:	31 c0                	xor    %eax,%eax
}
80101db6:	5b                   	pop    %ebx
80101db7:	5e                   	pop    %esi
80101db8:	5f                   	pop    %edi
80101db9:	5d                   	pop    %ebp
80101dba:	c3                   	ret
80101dbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101dbf:	90                   	nop
      if(poff)
80101dc0:	8b 45 10             	mov    0x10(%ebp),%eax
80101dc3:	85 c0                	test   %eax,%eax
80101dc5:	74 05                	je     80101dcc <dirlookup+0x7c>
        *poff = off;
80101dc7:	8b 45 10             	mov    0x10(%ebp),%eax
80101dca:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101dcc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101dd0:	8b 03                	mov    (%ebx),%eax
80101dd2:	e8 49 f5 ff ff       	call   80101320 <iget>
}
80101dd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dda:	5b                   	pop    %ebx
80101ddb:	5e                   	pop    %esi
80101ddc:	5f                   	pop    %edi
80101ddd:	5d                   	pop    %ebp
80101dde:	c3                   	ret
      panic("dirlookup read");
80101ddf:	83 ec 0c             	sub    $0xc,%esp
80101de2:	68 59 73 10 80       	push   $0x80107359
80101de7:	e8 94 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101dec:	83 ec 0c             	sub    $0xc,%esp
80101def:	68 47 73 10 80       	push   $0x80107347
80101df4:	e8 87 e5 ff ff       	call   80100380 <panic>
80101df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e00 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	57                   	push   %edi
80101e04:	56                   	push   %esi
80101e05:	53                   	push   %ebx
80101e06:	89 c3                	mov    %eax,%ebx
80101e08:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e0b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e0e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e11:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101e14:	0f 84 64 01 00 00    	je     80101f7e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e1a:	e8 01 1c 00 00       	call   80103a20 <myproc>
  acquire(&icache.lock);
80101e1f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e22:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101e25:	68 60 f9 10 80       	push   $0x8010f960
80101e2a:	e8 51 27 00 00       	call   80104580 <acquire>
  ip->ref++;
80101e2f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e33:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101e3a:	e8 81 28 00 00       	call   801046c0 <release>
80101e3f:	83 c4 10             	add    $0x10,%esp
80101e42:	eb 07                	jmp    80101e4b <namex+0x4b>
80101e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e4b:	0f b6 03             	movzbl (%ebx),%eax
80101e4e:	3c 2f                	cmp    $0x2f,%al
80101e50:	74 f6                	je     80101e48 <namex+0x48>
  if(*path == 0)
80101e52:	84 c0                	test   %al,%al
80101e54:	0f 84 06 01 00 00    	je     80101f60 <namex+0x160>
  while(*path != '/' && *path != 0)
80101e5a:	0f b6 03             	movzbl (%ebx),%eax
80101e5d:	84 c0                	test   %al,%al
80101e5f:	0f 84 10 01 00 00    	je     80101f75 <namex+0x175>
80101e65:	89 df                	mov    %ebx,%edi
80101e67:	3c 2f                	cmp    $0x2f,%al
80101e69:	0f 84 06 01 00 00    	je     80101f75 <namex+0x175>
80101e6f:	90                   	nop
80101e70:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e74:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e77:	3c 2f                	cmp    $0x2f,%al
80101e79:	74 04                	je     80101e7f <namex+0x7f>
80101e7b:	84 c0                	test   %al,%al
80101e7d:	75 f1                	jne    80101e70 <namex+0x70>
  len = path - s;
80101e7f:	89 f8                	mov    %edi,%eax
80101e81:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e83:	83 f8 0d             	cmp    $0xd,%eax
80101e86:	0f 8e ac 00 00 00    	jle    80101f38 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e8c:	83 ec 04             	sub    $0x4,%esp
80101e8f:	6a 0e                	push   $0xe
80101e91:	53                   	push   %ebx
    path++;
80101e92:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e94:	ff 75 e4             	push   -0x1c(%ebp)
80101e97:	e8 04 29 00 00       	call   801047a0 <memmove>
80101e9c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e9f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101ea2:	75 0c                	jne    80101eb0 <namex+0xb0>
80101ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ea8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101eab:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101eae:	74 f8                	je     80101ea8 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101eb0:	83 ec 0c             	sub    $0xc,%esp
80101eb3:	56                   	push   %esi
80101eb4:	e8 37 f9 ff ff       	call   801017f0 <ilock>
    if(ip->type != T_DIR){
80101eb9:	83 c4 10             	add    $0x10,%esp
80101ebc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ec1:	0f 85 cd 00 00 00    	jne    80101f94 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101ec7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eca:	85 c0                	test   %eax,%eax
80101ecc:	74 09                	je     80101ed7 <namex+0xd7>
80101ece:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ed1:	0f 84 34 01 00 00    	je     8010200b <namex+0x20b>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101ed7:	83 ec 04             	sub    $0x4,%esp
80101eda:	6a 00                	push   $0x0
80101edc:	ff 75 e4             	push   -0x1c(%ebp)
80101edf:	56                   	push   %esi
80101ee0:	e8 6b fe ff ff       	call   80101d50 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ee5:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101ee8:	83 c4 10             	add    $0x10,%esp
80101eeb:	89 c7                	mov    %eax,%edi
80101eed:	85 c0                	test   %eax,%eax
80101eef:	0f 84 e1 00 00 00    	je     80101fd6 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ef5:	83 ec 0c             	sub    $0xc,%esp
80101ef8:	52                   	push   %edx
80101ef9:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101efc:	e8 2f 25 00 00       	call   80104430 <holdingsleep>
80101f01:	83 c4 10             	add    $0x10,%esp
80101f04:	85 c0                	test   %eax,%eax
80101f06:	0f 84 3f 01 00 00    	je     8010204b <namex+0x24b>
80101f0c:	8b 56 08             	mov    0x8(%esi),%edx
80101f0f:	85 d2                	test   %edx,%edx
80101f11:	0f 8e 34 01 00 00    	jle    8010204b <namex+0x24b>
  releasesleep(&ip->lock);
80101f17:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f1a:	83 ec 0c             	sub    $0xc,%esp
80101f1d:	52                   	push   %edx
80101f1e:	e8 cd 24 00 00       	call   801043f0 <releasesleep>
  iput(ip);
80101f23:	89 34 24             	mov    %esi,(%esp)
80101f26:	89 fe                	mov    %edi,%esi
80101f28:	e8 f3 f9 ff ff       	call   80101920 <iput>
80101f2d:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f30:	e9 16 ff ff ff       	jmp    80101e4b <namex+0x4b>
80101f35:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101f38:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f3b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101f3e:	83 ec 04             	sub    $0x4,%esp
80101f41:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101f44:	50                   	push   %eax
80101f45:	53                   	push   %ebx
    name[len] = 0;
80101f46:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101f48:	ff 75 e4             	push   -0x1c(%ebp)
80101f4b:	e8 50 28 00 00       	call   801047a0 <memmove>
    name[len] = 0;
80101f50:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f53:	83 c4 10             	add    $0x10,%esp
80101f56:	c6 02 00             	movb   $0x0,(%edx)
80101f59:	e9 41 ff ff ff       	jmp    80101e9f <namex+0x9f>
80101f5e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f60:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f63:	85 c0                	test   %eax,%eax
80101f65:	0f 85 d0 00 00 00    	jne    8010203b <namex+0x23b>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f6e:	89 f0                	mov    %esi,%eax
80101f70:	5b                   	pop    %ebx
80101f71:	5e                   	pop    %esi
80101f72:	5f                   	pop    %edi
80101f73:	5d                   	pop    %ebp
80101f74:	c3                   	ret
  while(*path != '/' && *path != 0)
80101f75:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f78:	89 df                	mov    %ebx,%edi
80101f7a:	31 c0                	xor    %eax,%eax
80101f7c:	eb c0                	jmp    80101f3e <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f7e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f83:	b8 01 00 00 00       	mov    $0x1,%eax
80101f88:	e8 93 f3 ff ff       	call   80101320 <iget>
80101f8d:	89 c6                	mov    %eax,%esi
80101f8f:	e9 b7 fe ff ff       	jmp    80101e4b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f94:	83 ec 0c             	sub    $0xc,%esp
80101f97:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f9a:	53                   	push   %ebx
80101f9b:	e8 90 24 00 00       	call   80104430 <holdingsleep>
80101fa0:	83 c4 10             	add    $0x10,%esp
80101fa3:	85 c0                	test   %eax,%eax
80101fa5:	0f 84 a0 00 00 00    	je     8010204b <namex+0x24b>
80101fab:	8b 46 08             	mov    0x8(%esi),%eax
80101fae:	85 c0                	test   %eax,%eax
80101fb0:	0f 8e 95 00 00 00    	jle    8010204b <namex+0x24b>
  releasesleep(&ip->lock);
80101fb6:	83 ec 0c             	sub    $0xc,%esp
80101fb9:	53                   	push   %ebx
80101fba:	e8 31 24 00 00       	call   801043f0 <releasesleep>
  iput(ip);
80101fbf:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101fc2:	31 f6                	xor    %esi,%esi
  iput(ip);
80101fc4:	e8 57 f9 ff ff       	call   80101920 <iput>
      return 0;
80101fc9:	83 c4 10             	add    $0x10,%esp
}
80101fcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fcf:	89 f0                	mov    %esi,%eax
80101fd1:	5b                   	pop    %ebx
80101fd2:	5e                   	pop    %esi
80101fd3:	5f                   	pop    %edi
80101fd4:	5d                   	pop    %ebp
80101fd5:	c3                   	ret
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fd6:	83 ec 0c             	sub    $0xc,%esp
80101fd9:	52                   	push   %edx
80101fda:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101fdd:	e8 4e 24 00 00       	call   80104430 <holdingsleep>
80101fe2:	83 c4 10             	add    $0x10,%esp
80101fe5:	85 c0                	test   %eax,%eax
80101fe7:	74 62                	je     8010204b <namex+0x24b>
80101fe9:	8b 4e 08             	mov    0x8(%esi),%ecx
80101fec:	85 c9                	test   %ecx,%ecx
80101fee:	7e 5b                	jle    8010204b <namex+0x24b>
  releasesleep(&ip->lock);
80101ff0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ff3:	83 ec 0c             	sub    $0xc,%esp
80101ff6:	52                   	push   %edx
80101ff7:	e8 f4 23 00 00       	call   801043f0 <releasesleep>
  iput(ip);
80101ffc:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101fff:	31 f6                	xor    %esi,%esi
  iput(ip);
80102001:	e8 1a f9 ff ff       	call   80101920 <iput>
      return 0;
80102006:	83 c4 10             	add    $0x10,%esp
80102009:	eb c1                	jmp    80101fcc <namex+0x1cc>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010200b:	83 ec 0c             	sub    $0xc,%esp
8010200e:	8d 5e 0c             	lea    0xc(%esi),%ebx
80102011:	53                   	push   %ebx
80102012:	e8 19 24 00 00       	call   80104430 <holdingsleep>
80102017:	83 c4 10             	add    $0x10,%esp
8010201a:	85 c0                	test   %eax,%eax
8010201c:	74 2d                	je     8010204b <namex+0x24b>
8010201e:	8b 7e 08             	mov    0x8(%esi),%edi
80102021:	85 ff                	test   %edi,%edi
80102023:	7e 26                	jle    8010204b <namex+0x24b>
  releasesleep(&ip->lock);
80102025:	83 ec 0c             	sub    $0xc,%esp
80102028:	53                   	push   %ebx
80102029:	e8 c2 23 00 00       	call   801043f0 <releasesleep>
}
8010202e:	83 c4 10             	add    $0x10,%esp
}
80102031:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102034:	89 f0                	mov    %esi,%eax
80102036:	5b                   	pop    %ebx
80102037:	5e                   	pop    %esi
80102038:	5f                   	pop    %edi
80102039:	5d                   	pop    %ebp
8010203a:	c3                   	ret
    iput(ip);
8010203b:	83 ec 0c             	sub    $0xc,%esp
8010203e:	56                   	push   %esi
      return 0;
8010203f:	31 f6                	xor    %esi,%esi
    iput(ip);
80102041:	e8 da f8 ff ff       	call   80101920 <iput>
    return 0;
80102046:	83 c4 10             	add    $0x10,%esp
80102049:	eb 81                	jmp    80101fcc <namex+0x1cc>
    panic("iunlock");
8010204b:	83 ec 0c             	sub    $0xc,%esp
8010204e:	68 3f 73 10 80       	push   $0x8010733f
80102053:	e8 28 e3 ff ff       	call   80100380 <panic>
80102058:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010205f:	90                   	nop

80102060 <dirlink>:
{
80102060:	55                   	push   %ebp
80102061:	89 e5                	mov    %esp,%ebp
80102063:	57                   	push   %edi
80102064:	56                   	push   %esi
80102065:	53                   	push   %ebx
80102066:	83 ec 20             	sub    $0x20,%esp
80102069:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010206c:	6a 00                	push   $0x0
8010206e:	ff 75 0c             	push   0xc(%ebp)
80102071:	53                   	push   %ebx
80102072:	e8 d9 fc ff ff       	call   80101d50 <dirlookup>
80102077:	83 c4 10             	add    $0x10,%esp
8010207a:	85 c0                	test   %eax,%eax
8010207c:	75 67                	jne    801020e5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010207e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102081:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102084:	85 ff                	test   %edi,%edi
80102086:	74 29                	je     801020b1 <dirlink+0x51>
80102088:	31 ff                	xor    %edi,%edi
8010208a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010208d:	eb 09                	jmp    80102098 <dirlink+0x38>
8010208f:	90                   	nop
80102090:	83 c7 10             	add    $0x10,%edi
80102093:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102096:	73 19                	jae    801020b1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102098:	6a 10                	push   $0x10
8010209a:	57                   	push   %edi
8010209b:	56                   	push   %esi
8010209c:	53                   	push   %ebx
8010209d:	e8 5e fa ff ff       	call   80101b00 <readi>
801020a2:	83 c4 10             	add    $0x10,%esp
801020a5:	83 f8 10             	cmp    $0x10,%eax
801020a8:	75 4e                	jne    801020f8 <dirlink+0x98>
    if(de.inum == 0)
801020aa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801020af:	75 df                	jne    80102090 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801020b1:	83 ec 04             	sub    $0x4,%esp
801020b4:	8d 45 da             	lea    -0x26(%ebp),%eax
801020b7:	6a 0e                	push   $0xe
801020b9:	ff 75 0c             	push   0xc(%ebp)
801020bc:	50                   	push   %eax
801020bd:	e8 9e 27 00 00       	call   80104860 <strncpy>
  de.inum = inum;
801020c2:	8b 45 10             	mov    0x10(%ebp),%eax
801020c5:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020c9:	6a 10                	push   $0x10
801020cb:	57                   	push   %edi
801020cc:	56                   	push   %esi
801020cd:	53                   	push   %ebx
801020ce:	e8 2d fb ff ff       	call   80101c00 <writei>
801020d3:	83 c4 20             	add    $0x20,%esp
801020d6:	83 f8 10             	cmp    $0x10,%eax
801020d9:	75 2a                	jne    80102105 <dirlink+0xa5>
  return 0;
801020db:	31 c0                	xor    %eax,%eax
}
801020dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020e0:	5b                   	pop    %ebx
801020e1:	5e                   	pop    %esi
801020e2:	5f                   	pop    %edi
801020e3:	5d                   	pop    %ebp
801020e4:	c3                   	ret
    iput(ip);
801020e5:	83 ec 0c             	sub    $0xc,%esp
801020e8:	50                   	push   %eax
801020e9:	e8 32 f8 ff ff       	call   80101920 <iput>
    return -1;
801020ee:	83 c4 10             	add    $0x10,%esp
801020f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020f6:	eb e5                	jmp    801020dd <dirlink+0x7d>
      panic("dirlink read");
801020f8:	83 ec 0c             	sub    $0xc,%esp
801020fb:	68 68 73 10 80       	push   $0x80107368
80102100:	e8 7b e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102105:	83 ec 0c             	sub    $0xc,%esp
80102108:	68 5e 79 10 80       	push   $0x8010795e
8010210d:	e8 6e e2 ff ff       	call   80100380 <panic>
80102112:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102120 <namei>:

struct inode*
namei(char *path)
{
80102120:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102121:	31 d2                	xor    %edx,%edx
{
80102123:	89 e5                	mov    %esp,%ebp
80102125:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102128:	8b 45 08             	mov    0x8(%ebp),%eax
8010212b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010212e:	e8 cd fc ff ff       	call   80101e00 <namex>
}
80102133:	c9                   	leave
80102134:	c3                   	ret
80102135:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010213c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102140 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102140:	55                   	push   %ebp
  return namex(path, 1, name);
80102141:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102146:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102148:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010214b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010214e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010214f:	e9 ac fc ff ff       	jmp    80101e00 <namex>
80102154:	66 90                	xchg   %ax,%ax
80102156:	66 90                	xchg   %ax,%ax
80102158:	66 90                	xchg   %ax,%ax
8010215a:	66 90                	xchg   %ax,%ax
8010215c:	66 90                	xchg   %ax,%ax
8010215e:	66 90                	xchg   %ax,%ax

80102160 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102160:	55                   	push   %ebp
80102161:	89 e5                	mov    %esp,%ebp
80102163:	57                   	push   %edi
80102164:	56                   	push   %esi
80102165:	53                   	push   %ebx
80102166:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102169:	85 c0                	test   %eax,%eax
8010216b:	0f 84 b4 00 00 00    	je     80102225 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102171:	8b 70 08             	mov    0x8(%eax),%esi
80102174:	89 c3                	mov    %eax,%ebx
80102176:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010217c:	0f 87 96 00 00 00    	ja     80102218 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102182:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010218e:	66 90                	xchg   %ax,%ax
80102190:	89 ca                	mov    %ecx,%edx
80102192:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102193:	83 e0 c0             	and    $0xffffffc0,%eax
80102196:	3c 40                	cmp    $0x40,%al
80102198:	75 f6                	jne    80102190 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010219a:	31 ff                	xor    %edi,%edi
8010219c:	ba f6 03 00 00       	mov    $0x3f6,%edx
801021a1:	89 f8                	mov    %edi,%eax
801021a3:	ee                   	out    %al,(%dx)
801021a4:	b8 01 00 00 00       	mov    $0x1,%eax
801021a9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801021ae:	ee                   	out    %al,(%dx)
801021af:	ba f3 01 00 00       	mov    $0x1f3,%edx
801021b4:	89 f0                	mov    %esi,%eax
801021b6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801021b7:	89 f0                	mov    %esi,%eax
801021b9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801021be:	c1 f8 08             	sar    $0x8,%eax
801021c1:	ee                   	out    %al,(%dx)
801021c2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801021c7:	89 f8                	mov    %edi,%eax
801021c9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801021ca:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801021ce:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021d3:	c1 e0 04             	shl    $0x4,%eax
801021d6:	83 e0 10             	and    $0x10,%eax
801021d9:	83 c8 e0             	or     $0xffffffe0,%eax
801021dc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801021dd:	f6 03 04             	testb  $0x4,(%ebx)
801021e0:	75 16                	jne    801021f8 <idestart+0x98>
801021e2:	b8 20 00 00 00       	mov    $0x20,%eax
801021e7:	89 ca                	mov    %ecx,%edx
801021e9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801021ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021ed:	5b                   	pop    %ebx
801021ee:	5e                   	pop    %esi
801021ef:	5f                   	pop    %edi
801021f0:	5d                   	pop    %ebp
801021f1:	c3                   	ret
801021f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021f8:	b8 30 00 00 00       	mov    $0x30,%eax
801021fd:	89 ca                	mov    %ecx,%edx
801021ff:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102200:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102205:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102208:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010220d:	fc                   	cld
8010220e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102210:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102213:	5b                   	pop    %ebx
80102214:	5e                   	pop    %esi
80102215:	5f                   	pop    %edi
80102216:	5d                   	pop    %ebp
80102217:	c3                   	ret
    panic("incorrect blockno");
80102218:	83 ec 0c             	sub    $0xc,%esp
8010221b:	68 d4 73 10 80       	push   $0x801073d4
80102220:	e8 5b e1 ff ff       	call   80100380 <panic>
    panic("idestart");
80102225:	83 ec 0c             	sub    $0xc,%esp
80102228:	68 cb 73 10 80       	push   $0x801073cb
8010222d:	e8 4e e1 ff ff       	call   80100380 <panic>
80102232:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102240 <ideinit>:
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102246:	68 e6 73 10 80       	push   $0x801073e6
8010224b:	68 00 16 11 80       	push   $0x80111600
80102250:	e8 0b 22 00 00       	call   80104460 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102255:	58                   	pop    %eax
80102256:	a1 84 17 11 80       	mov    0x80111784,%eax
8010225b:	5a                   	pop    %edx
8010225c:	83 e8 01             	sub    $0x1,%eax
8010225f:	50                   	push   %eax
80102260:	6a 0e                	push   $0xe
80102262:	e8 99 02 00 00       	call   80102500 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102267:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010226a:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
8010226f:	90                   	nop
80102270:	89 ca                	mov    %ecx,%edx
80102272:	ec                   	in     (%dx),%al
80102273:	83 e0 c0             	and    $0xffffffc0,%eax
80102276:	3c 40                	cmp    $0x40,%al
80102278:	75 f6                	jne    80102270 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010227a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010227f:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102284:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102285:	89 ca                	mov    %ecx,%edx
80102287:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102288:	84 c0                	test   %al,%al
8010228a:	75 1e                	jne    801022aa <ideinit+0x6a>
8010228c:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102291:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010229d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i=0; i<1000; i++){
801022a0:	83 e9 01             	sub    $0x1,%ecx
801022a3:	74 0f                	je     801022b4 <ideinit+0x74>
801022a5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801022a6:	84 c0                	test   %al,%al
801022a8:	74 f6                	je     801022a0 <ideinit+0x60>
      havedisk1 = 1;
801022aa:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
801022b1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022b4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801022b9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022be:	ee                   	out    %al,(%dx)
}
801022bf:	c9                   	leave
801022c0:	c3                   	ret
801022c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022cf:	90                   	nop

801022d0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	57                   	push   %edi
801022d4:	56                   	push   %esi
801022d5:	53                   	push   %ebx
801022d6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801022d9:	68 00 16 11 80       	push   $0x80111600
801022de:	e8 9d 22 00 00       	call   80104580 <acquire>

  if((b = idequeue) == 0){
801022e3:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
801022e9:	83 c4 10             	add    $0x10,%esp
801022ec:	85 db                	test   %ebx,%ebx
801022ee:	74 63                	je     80102353 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801022f0:	8b 43 58             	mov    0x58(%ebx),%eax
801022f3:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801022f8:	8b 33                	mov    (%ebx),%esi
801022fa:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102300:	75 2f                	jne    80102331 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102302:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102307:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010230e:	66 90                	xchg   %ax,%ax
80102310:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102311:	89 c1                	mov    %eax,%ecx
80102313:	83 e1 c0             	and    $0xffffffc0,%ecx
80102316:	80 f9 40             	cmp    $0x40,%cl
80102319:	75 f5                	jne    80102310 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010231b:	a8 21                	test   $0x21,%al
8010231d:	75 12                	jne    80102331 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010231f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102322:	b9 80 00 00 00       	mov    $0x80,%ecx
80102327:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010232c:	fc                   	cld
8010232d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010232f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102331:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102334:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102337:	83 ce 02             	or     $0x2,%esi
8010233a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010233c:	53                   	push   %ebx
8010233d:	e8 6e 1e 00 00       	call   801041b0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102342:	a1 e4 15 11 80       	mov    0x801115e4,%eax
80102347:	83 c4 10             	add    $0x10,%esp
8010234a:	85 c0                	test   %eax,%eax
8010234c:	74 05                	je     80102353 <ideintr+0x83>
    idestart(idequeue);
8010234e:	e8 0d fe ff ff       	call   80102160 <idestart>
    release(&idelock);
80102353:	83 ec 0c             	sub    $0xc,%esp
80102356:	68 00 16 11 80       	push   $0x80111600
8010235b:	e8 60 23 00 00       	call   801046c0 <release>

  release(&idelock);
}
80102360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102363:	5b                   	pop    %ebx
80102364:	5e                   	pop    %esi
80102365:	5f                   	pop    %edi
80102366:	5d                   	pop    %ebp
80102367:	c3                   	ret
80102368:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010236f:	90                   	nop

80102370 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
80102373:	53                   	push   %ebx
80102374:	83 ec 10             	sub    $0x10,%esp
80102377:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010237a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010237d:	50                   	push   %eax
8010237e:	e8 ad 20 00 00       	call   80104430 <holdingsleep>
80102383:	83 c4 10             	add    $0x10,%esp
80102386:	85 c0                	test   %eax,%eax
80102388:	0f 84 c3 00 00 00    	je     80102451 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010238e:	8b 03                	mov    (%ebx),%eax
80102390:	83 e0 06             	and    $0x6,%eax
80102393:	83 f8 02             	cmp    $0x2,%eax
80102396:	0f 84 a8 00 00 00    	je     80102444 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010239c:	8b 53 04             	mov    0x4(%ebx),%edx
8010239f:	85 d2                	test   %edx,%edx
801023a1:	74 0d                	je     801023b0 <iderw+0x40>
801023a3:	a1 e0 15 11 80       	mov    0x801115e0,%eax
801023a8:	85 c0                	test   %eax,%eax
801023aa:	0f 84 87 00 00 00    	je     80102437 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801023b0:	83 ec 0c             	sub    $0xc,%esp
801023b3:	68 00 16 11 80       	push   $0x80111600
801023b8:	e8 c3 21 00 00       	call   80104580 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023bd:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
801023c2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023c9:	83 c4 10             	add    $0x10,%esp
801023cc:	85 c0                	test   %eax,%eax
801023ce:	74 60                	je     80102430 <iderw+0xc0>
801023d0:	89 c2                	mov    %eax,%edx
801023d2:	8b 40 58             	mov    0x58(%eax),%eax
801023d5:	85 c0                	test   %eax,%eax
801023d7:	75 f7                	jne    801023d0 <iderw+0x60>
801023d9:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801023dc:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801023de:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
801023e4:	74 3a                	je     80102420 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023e6:	8b 03                	mov    (%ebx),%eax
801023e8:	83 e0 06             	and    $0x6,%eax
801023eb:	83 f8 02             	cmp    $0x2,%eax
801023ee:	74 1b                	je     8010240b <iderw+0x9b>
    sleep(b, &idelock);
801023f0:	83 ec 08             	sub    $0x8,%esp
801023f3:	68 00 16 11 80       	push   $0x80111600
801023f8:	53                   	push   %ebx
801023f9:	e8 f2 1c 00 00       	call   801040f0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023fe:	8b 03                	mov    (%ebx),%eax
80102400:	83 c4 10             	add    $0x10,%esp
80102403:	83 e0 06             	and    $0x6,%eax
80102406:	83 f8 02             	cmp    $0x2,%eax
80102409:	75 e5                	jne    801023f0 <iderw+0x80>
  }


  release(&idelock);
8010240b:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
80102412:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102415:	c9                   	leave
  release(&idelock);
80102416:	e9 a5 22 00 00       	jmp    801046c0 <release>
8010241b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010241f:	90                   	nop
    idestart(b);
80102420:	89 d8                	mov    %ebx,%eax
80102422:	e8 39 fd ff ff       	call   80102160 <idestart>
80102427:	eb bd                	jmp    801023e6 <iderw+0x76>
80102429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102430:	ba e4 15 11 80       	mov    $0x801115e4,%edx
80102435:	eb a5                	jmp    801023dc <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102437:	83 ec 0c             	sub    $0xc,%esp
8010243a:	68 15 74 10 80       	push   $0x80107415
8010243f:	e8 3c df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102444:	83 ec 0c             	sub    $0xc,%esp
80102447:	68 00 74 10 80       	push   $0x80107400
8010244c:	e8 2f df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102451:	83 ec 0c             	sub    $0xc,%esp
80102454:	68 ea 73 10 80       	push   $0x801073ea
80102459:	e8 22 df ff ff       	call   80100380 <panic>
8010245e:	66 90                	xchg   %ax,%ax

80102460 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102465:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
8010246c:	00 c0 fe 
  ioapic->reg = reg;
8010246f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102476:	00 00 00 
  return ioapic->data;
80102479:	8b 15 34 16 11 80    	mov    0x80111634,%edx
8010247f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102482:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102488:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010248e:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102495:	c1 ee 10             	shr    $0x10,%esi
80102498:	89 f0                	mov    %esi,%eax
8010249a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010249d:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
801024a0:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801024a3:	39 c2                	cmp    %eax,%edx
801024a5:	74 16                	je     801024bd <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801024a7:	83 ec 0c             	sub    $0xc,%esp
801024aa:	68 34 74 10 80       	push   $0x80107434
801024af:	e8 fc e1 ff ff       	call   801006b0 <cprintf>
  ioapic->reg = reg;
801024b4:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
801024ba:	83 c4 10             	add    $0x10,%esp
{
801024bd:	ba 10 00 00 00       	mov    $0x10,%edx
801024c2:	31 c0                	xor    %eax,%eax
801024c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
801024c8:	89 13                	mov    %edx,(%ebx)
801024ca:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
801024cd:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801024d3:	83 c0 01             	add    $0x1,%eax
801024d6:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
801024dc:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
801024df:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
801024e2:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801024e5:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801024e7:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
801024ed:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
801024f4:	39 c6                	cmp    %eax,%esi
801024f6:	7d d0                	jge    801024c8 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801024f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024fb:	5b                   	pop    %ebx
801024fc:	5e                   	pop    %esi
801024fd:	5d                   	pop    %ebp
801024fe:	c3                   	ret
801024ff:	90                   	nop

80102500 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102500:	55                   	push   %ebp
  ioapic->reg = reg;
80102501:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
80102507:	89 e5                	mov    %esp,%ebp
80102509:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010250c:	8d 50 20             	lea    0x20(%eax),%edx
8010250f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102513:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102515:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010251b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010251e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102521:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102524:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102526:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010252b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010252e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102531:	5d                   	pop    %ebp
80102532:	c3                   	ret
80102533:	66 90                	xchg   %ax,%ax
80102535:	66 90                	xchg   %ax,%ax
80102537:	66 90                	xchg   %ax,%ax
80102539:	66 90                	xchg   %ax,%ax
8010253b:	66 90                	xchg   %ax,%ax
8010253d:	66 90                	xchg   %ax,%ax
8010253f:	90                   	nop

80102540 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	53                   	push   %ebx
80102544:	83 ec 04             	sub    $0x4,%esp
80102547:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010254a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102550:	75 76                	jne    801025c8 <kfree+0x88>
80102552:	81 fb d0 54 11 80    	cmp    $0x801154d0,%ebx
80102558:	72 6e                	jb     801025c8 <kfree+0x88>
8010255a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102560:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102565:	77 61                	ja     801025c8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102567:	83 ec 04             	sub    $0x4,%esp
8010256a:	68 00 10 00 00       	push   $0x1000
8010256f:	6a 01                	push   $0x1
80102571:	53                   	push   %ebx
80102572:	e8 99 21 00 00       	call   80104710 <memset>

  if(kmem.use_lock)
80102577:	8b 15 74 16 11 80    	mov    0x80111674,%edx
8010257d:	83 c4 10             	add    $0x10,%esp
80102580:	85 d2                	test   %edx,%edx
80102582:	75 1c                	jne    801025a0 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102584:	a1 78 16 11 80       	mov    0x80111678,%eax
80102589:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010258b:	a1 74 16 11 80       	mov    0x80111674,%eax
  kmem.freelist = r;
80102590:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80102596:	85 c0                	test   %eax,%eax
80102598:	75 1e                	jne    801025b8 <kfree+0x78>
    release(&kmem.lock);
}
8010259a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010259d:	c9                   	leave
8010259e:	c3                   	ret
8010259f:	90                   	nop
    acquire(&kmem.lock);
801025a0:	83 ec 0c             	sub    $0xc,%esp
801025a3:	68 40 16 11 80       	push   $0x80111640
801025a8:	e8 d3 1f 00 00       	call   80104580 <acquire>
801025ad:	83 c4 10             	add    $0x10,%esp
801025b0:	eb d2                	jmp    80102584 <kfree+0x44>
801025b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801025b8:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
801025bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025c2:	c9                   	leave
    release(&kmem.lock);
801025c3:	e9 f8 20 00 00       	jmp    801046c0 <release>
    panic("kfree");
801025c8:	83 ec 0c             	sub    $0xc,%esp
801025cb:	68 66 74 10 80       	push   $0x80107466
801025d0:	e8 ab dd ff ff       	call   80100380 <panic>
801025d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025e0 <freerange>:
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	56                   	push   %esi
801025e4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025e5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801025eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025fd:	39 de                	cmp    %ebx,%esi
801025ff:	72 23                	jb     80102624 <freerange+0x44>
80102601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102608:	83 ec 0c             	sub    $0xc,%esp
8010260b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102611:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102617:	50                   	push   %eax
80102618:	e8 23 ff ff ff       	call   80102540 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010261d:	83 c4 10             	add    $0x10,%esp
80102620:	39 de                	cmp    %ebx,%esi
80102622:	73 e4                	jae    80102608 <freerange+0x28>
}
80102624:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102627:	5b                   	pop    %ebx
80102628:	5e                   	pop    %esi
80102629:	5d                   	pop    %ebp
8010262a:	c3                   	ret
8010262b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010262f:	90                   	nop

80102630 <kinit2>:
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	56                   	push   %esi
80102634:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102635:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102638:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010263b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102641:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102647:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264d:	39 de                	cmp    %ebx,%esi
8010264f:	72 23                	jb     80102674 <kinit2+0x44>
80102651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102658:	83 ec 0c             	sub    $0xc,%esp
8010265b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102661:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102667:	50                   	push   %eax
80102668:	e8 d3 fe ff ff       	call   80102540 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010266d:	83 c4 10             	add    $0x10,%esp
80102670:	39 de                	cmp    %ebx,%esi
80102672:	73 e4                	jae    80102658 <kinit2+0x28>
  kmem.use_lock = 1;
80102674:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
8010267b:	00 00 00 
}
8010267e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102681:	5b                   	pop    %ebx
80102682:	5e                   	pop    %esi
80102683:	5d                   	pop    %ebp
80102684:	c3                   	ret
80102685:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010268c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102690 <kinit1>:
{
80102690:	55                   	push   %ebp
80102691:	89 e5                	mov    %esp,%ebp
80102693:	56                   	push   %esi
80102694:	53                   	push   %ebx
80102695:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102698:	83 ec 08             	sub    $0x8,%esp
8010269b:	68 6c 74 10 80       	push   $0x8010746c
801026a0:	68 40 16 11 80       	push   $0x80111640
801026a5:	e8 b6 1d 00 00       	call   80104460 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801026aa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026ad:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801026b0:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
801026b7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801026ba:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026c0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026c6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026cc:	39 de                	cmp    %ebx,%esi
801026ce:	72 1c                	jb     801026ec <kinit1+0x5c>
    kfree(p);
801026d0:	83 ec 0c             	sub    $0xc,%esp
801026d3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026d9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026df:	50                   	push   %eax
801026e0:	e8 5b fe ff ff       	call   80102540 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026e5:	83 c4 10             	add    $0x10,%esp
801026e8:	39 de                	cmp    %ebx,%esi
801026ea:	73 e4                	jae    801026d0 <kinit1+0x40>
}
801026ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026ef:	5b                   	pop    %ebx
801026f0:	5e                   	pop    %esi
801026f1:	5d                   	pop    %ebp
801026f2:	c3                   	ret
801026f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102700 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102700:	55                   	push   %ebp
80102701:	89 e5                	mov    %esp,%ebp
80102703:	53                   	push   %ebx
80102704:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102707:	a1 74 16 11 80       	mov    0x80111674,%eax
8010270c:	85 c0                	test   %eax,%eax
8010270e:	75 20                	jne    80102730 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102710:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(r)
80102716:	85 db                	test   %ebx,%ebx
80102718:	74 07                	je     80102721 <kalloc+0x21>
    kmem.freelist = r->next;
8010271a:	8b 03                	mov    (%ebx),%eax
8010271c:	a3 78 16 11 80       	mov    %eax,0x80111678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102721:	89 d8                	mov    %ebx,%eax
80102723:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102726:	c9                   	leave
80102727:	c3                   	ret
80102728:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010272f:	90                   	nop
    acquire(&kmem.lock);
80102730:	83 ec 0c             	sub    $0xc,%esp
80102733:	68 40 16 11 80       	push   $0x80111640
80102738:	e8 43 1e 00 00       	call   80104580 <acquire>
  r = kmem.freelist;
8010273d:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(kmem.use_lock)
80102743:	a1 74 16 11 80       	mov    0x80111674,%eax
  if(r)
80102748:	83 c4 10             	add    $0x10,%esp
8010274b:	85 db                	test   %ebx,%ebx
8010274d:	74 08                	je     80102757 <kalloc+0x57>
    kmem.freelist = r->next;
8010274f:	8b 13                	mov    (%ebx),%edx
80102751:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
80102757:	85 c0                	test   %eax,%eax
80102759:	74 c6                	je     80102721 <kalloc+0x21>
    release(&kmem.lock);
8010275b:	83 ec 0c             	sub    $0xc,%esp
8010275e:	68 40 16 11 80       	push   $0x80111640
80102763:	e8 58 1f 00 00       	call   801046c0 <release>
}
80102768:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010276a:	83 c4 10             	add    $0x10,%esp
}
8010276d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102770:	c9                   	leave
80102771:	c3                   	ret
80102772:	66 90                	xchg   %ax,%ax
80102774:	66 90                	xchg   %ax,%ax
80102776:	66 90                	xchg   %ax,%ax
80102778:	66 90                	xchg   %ax,%ax
8010277a:	66 90                	xchg   %ax,%ax
8010277c:	66 90                	xchg   %ax,%ax
8010277e:	66 90                	xchg   %ax,%ax

80102780 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102780:	ba 64 00 00 00       	mov    $0x64,%edx
80102785:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102786:	a8 01                	test   $0x1,%al
80102788:	0f 84 c2 00 00 00    	je     80102850 <kbdgetc+0xd0>
{
8010278e:	55                   	push   %ebp
8010278f:	ba 60 00 00 00       	mov    $0x60,%edx
80102794:	89 e5                	mov    %esp,%ebp
80102796:	53                   	push   %ebx
80102797:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102798:	8b 1d 7c 16 11 80    	mov    0x8011167c,%ebx
  data = inb(KBDATAP);
8010279e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801027a1:	3c e0                	cmp    $0xe0,%al
801027a3:	74 5b                	je     80102800 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801027a5:	89 da                	mov    %ebx,%edx
801027a7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801027aa:	84 c0                	test   %al,%al
801027ac:	78 6a                	js     80102818 <kbdgetc+0x98>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801027ae:	85 d2                	test   %edx,%edx
801027b0:	74 09                	je     801027bb <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801027b2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801027b5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801027b8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
801027bb:	0f b6 91 a0 75 10 80 	movzbl -0x7fef8a60(%ecx),%edx
  shift ^= togglecode[data];
801027c2:	0f b6 81 a0 74 10 80 	movzbl -0x7fef8b60(%ecx),%eax
  shift |= shiftcode[data];
801027c9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801027cb:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027cd:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
801027cf:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
801027d5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801027d8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027db:	8b 04 85 80 74 10 80 	mov    -0x7fef8b80(,%eax,4),%eax
801027e2:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801027e6:	74 0b                	je     801027f3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
801027e8:	8d 50 9f             	lea    -0x61(%eax),%edx
801027eb:	83 fa 19             	cmp    $0x19,%edx
801027ee:	77 48                	ja     80102838 <kbdgetc+0xb8>
      c += 'A' - 'a';
801027f0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801027f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027f6:	c9                   	leave
801027f7:	c3                   	ret
801027f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ff:	90                   	nop
    shift |= E0ESC;
80102800:	89 d8                	mov    %ebx,%eax
80102802:	83 c8 40             	or     $0x40,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102805:	a3 7c 16 11 80       	mov    %eax,0x8011167c
    return 0;
8010280a:	31 c0                	xor    %eax,%eax
}
8010280c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010280f:	c9                   	leave
80102810:	c3                   	ret
80102811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    data = (shift & E0ESC ? data : data & 0x7F);
80102818:	83 e0 7f             	and    $0x7f,%eax
8010281b:	85 d2                	test   %edx,%edx
8010281d:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102820:	0f b6 81 a0 75 10 80 	movzbl -0x7fef8a60(%ecx),%eax
80102827:	83 c8 40             	or     $0x40,%eax
8010282a:	0f b6 c0             	movzbl %al,%eax
8010282d:	f7 d0                	not    %eax
8010282f:	21 d8                	and    %ebx,%eax
    return 0;
80102831:	eb d2                	jmp    80102805 <kbdgetc+0x85>
80102833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102837:	90                   	nop
    else if('A' <= c && c <= 'Z')
80102838:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010283b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010283e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102841:	c9                   	leave
      c += 'a' - 'A';
80102842:	83 f9 1a             	cmp    $0x1a,%ecx
80102845:	0f 42 c2             	cmovb  %edx,%eax
}
80102848:	c3                   	ret
80102849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102850:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102855:	c3                   	ret
80102856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010285d:	8d 76 00             	lea    0x0(%esi),%esi

80102860 <kbdintr>:

void
kbdintr(void)
{
80102860:	55                   	push   %ebp
80102861:	89 e5                	mov    %esp,%ebp
80102863:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102866:	68 80 27 10 80       	push   $0x80102780
8010286b:	e8 50 e0 ff ff       	call   801008c0 <consoleintr>
}
80102870:	83 c4 10             	add    $0x10,%esp
80102873:	c9                   	leave
80102874:	c3                   	ret
80102875:	66 90                	xchg   %ax,%ax
80102877:	66 90                	xchg   %ax,%ax
80102879:	66 90                	xchg   %ax,%ax
8010287b:	66 90                	xchg   %ax,%ax
8010287d:	66 90                	xchg   %ax,%ax
8010287f:	90                   	nop

80102880 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102880:	a1 80 16 11 80       	mov    0x80111680,%eax
80102885:	85 c0                	test   %eax,%eax
80102887:	0f 84 cb 00 00 00    	je     80102958 <lapicinit+0xd8>
  lapic[index] = value;
8010288d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102894:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102897:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801028a1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028a4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028a7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801028ae:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801028b1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028b4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801028bb:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801028be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028c1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801028c8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ce:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801028d5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028d8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801028db:	8b 50 30             	mov    0x30(%eax),%edx
801028de:	c1 ea 10             	shr    $0x10,%edx
801028e1:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801028e7:	75 77                	jne    80102960 <lapicinit+0xe0>
  lapic[index] = value;
801028e9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801028f0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028f3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028f6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028fd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102900:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102903:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010290a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010290d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102910:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102917:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010291a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010291d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102924:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102927:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010292a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102931:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102934:	8b 50 20             	mov    0x20(%eax),%edx
80102937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102940:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102946:	80 e6 10             	and    $0x10,%dh
80102949:	75 f5                	jne    80102940 <lapicinit+0xc0>
  lapic[index] = value;
8010294b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102952:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102955:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102958:	c3                   	ret
80102959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102960:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102967:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010296a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010296d:	e9 77 ff ff ff       	jmp    801028e9 <lapicinit+0x69>
80102972:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102980 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102980:	a1 80 16 11 80       	mov    0x80111680,%eax
80102985:	85 c0                	test   %eax,%eax
80102987:	74 07                	je     80102990 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102989:	8b 40 20             	mov    0x20(%eax),%eax
8010298c:	c1 e8 18             	shr    $0x18,%eax
8010298f:	c3                   	ret
    return 0;
80102990:	31 c0                	xor    %eax,%eax
}
80102992:	c3                   	ret
80102993:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010299a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801029a0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801029a0:	a1 80 16 11 80       	mov    0x80111680,%eax
801029a5:	85 c0                	test   %eax,%eax
801029a7:	74 0d                	je     801029b6 <lapiceoi+0x16>
  lapic[index] = value;
801029a9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801029b0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801029b6:	c3                   	ret
801029b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029be:	66 90                	xchg   %ax,%ax

801029c0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
801029c0:	c3                   	ret
801029c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029cf:	90                   	nop

801029d0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801029d0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d1:	b8 0f 00 00 00       	mov    $0xf,%eax
801029d6:	ba 70 00 00 00       	mov    $0x70,%edx
801029db:	89 e5                	mov    %esp,%ebp
801029dd:	53                   	push   %ebx
801029de:	8b 5d 08             	mov    0x8(%ebp),%ebx
801029e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029e4:	ee                   	out    %al,(%dx)
801029e5:	b8 0a 00 00 00       	mov    $0xa,%eax
801029ea:	ba 71 00 00 00       	mov    $0x71,%edx
801029ef:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801029f0:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
801029f2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801029f5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801029fb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801029fd:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102a00:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102a02:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a05:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102a08:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102a0e:	a1 80 16 11 80       	mov    0x80111680,%eax
80102a13:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a19:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a1c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102a23:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a26:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a29:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102a30:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a33:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a36:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a3c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a3f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a45:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a48:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a4e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a51:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a57:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102a5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a5d:	c9                   	leave
80102a5e:	c3                   	ret
80102a5f:	90                   	nop

80102a60 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102a60:	55                   	push   %ebp
80102a61:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a66:	ba 70 00 00 00       	mov    $0x70,%edx
80102a6b:	89 e5                	mov    %esp,%ebp
80102a6d:	57                   	push   %edi
80102a6e:	56                   	push   %esi
80102a6f:	53                   	push   %ebx
80102a70:	83 ec 4c             	sub    $0x4c,%esp
80102a73:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a74:	ba 71 00 00 00       	mov    $0x71,%edx
80102a79:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a7a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7d:	bf 70 00 00 00       	mov    $0x70,%edi
80102a82:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a85:	8d 76 00             	lea    0x0(%esi),%esi
80102a88:	31 c0                	xor    %eax,%eax
80102a8a:	89 fa                	mov    %edi,%edx
80102a8c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a92:	89 ca                	mov    %ecx,%edx
80102a94:	ec                   	in     (%dx),%al
80102a95:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a98:	89 fa                	mov    %edi,%edx
80102a9a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a9f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa0:	89 ca                	mov    %ecx,%edx
80102aa2:	ec                   	in     (%dx),%al
80102aa3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa6:	89 fa                	mov    %edi,%edx
80102aa8:	b8 04 00 00 00       	mov    $0x4,%eax
80102aad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aae:	89 ca                	mov    %ecx,%edx
80102ab0:	ec                   	in     (%dx),%al
80102ab1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab4:	89 fa                	mov    %edi,%edx
80102ab6:	b8 07 00 00 00       	mov    $0x7,%eax
80102abb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abc:	89 ca                	mov    %ecx,%edx
80102abe:	ec                   	in     (%dx),%al
80102abf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac2:	89 fa                	mov    %edi,%edx
80102ac4:	b8 08 00 00 00       	mov    $0x8,%eax
80102ac9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aca:	89 ca                	mov    %ecx,%edx
80102acc:	ec                   	in     (%dx),%al
80102acd:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102acf:	89 fa                	mov    %edi,%edx
80102ad1:	b8 09 00 00 00       	mov    $0x9,%eax
80102ad6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad7:	89 ca                	mov    %ecx,%edx
80102ad9:	ec                   	in     (%dx),%al
80102ada:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102add:	89 fa                	mov    %edi,%edx
80102adf:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ae4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae5:	89 ca                	mov    %ecx,%edx
80102ae7:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ae8:	84 c0                	test   %al,%al
80102aea:	78 9c                	js     80102a88 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102aec:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102af0:	89 f2                	mov    %esi,%edx
80102af2:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102af5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af8:	89 fa                	mov    %edi,%edx
80102afa:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102afd:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102b01:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102b04:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102b07:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102b0b:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102b0e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102b12:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102b15:	31 c0                	xor    %eax,%eax
80102b17:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b18:	89 ca                	mov    %ecx,%edx
80102b1a:	ec                   	in     (%dx),%al
80102b1b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b1e:	89 fa                	mov    %edi,%edx
80102b20:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102b23:	b8 02 00 00 00       	mov    $0x2,%eax
80102b28:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b29:	89 ca                	mov    %ecx,%edx
80102b2b:	ec                   	in     (%dx),%al
80102b2c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b2f:	89 fa                	mov    %edi,%edx
80102b31:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b34:	b8 04 00 00 00       	mov    $0x4,%eax
80102b39:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b3a:	89 ca                	mov    %ecx,%edx
80102b3c:	ec                   	in     (%dx),%al
80102b3d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b40:	89 fa                	mov    %edi,%edx
80102b42:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b45:	b8 07 00 00 00       	mov    $0x7,%eax
80102b4a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4b:	89 ca                	mov    %ecx,%edx
80102b4d:	ec                   	in     (%dx),%al
80102b4e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b51:	89 fa                	mov    %edi,%edx
80102b53:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b56:	b8 08 00 00 00       	mov    $0x8,%eax
80102b5b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b5c:	89 ca                	mov    %ecx,%edx
80102b5e:	ec                   	in     (%dx),%al
80102b5f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b62:	89 fa                	mov    %edi,%edx
80102b64:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b67:	b8 09 00 00 00       	mov    $0x9,%eax
80102b6c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b6d:	89 ca                	mov    %ecx,%edx
80102b6f:	ec                   	in     (%dx),%al
80102b70:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b73:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b79:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b7c:	6a 18                	push   $0x18
80102b7e:	50                   	push   %eax
80102b7f:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b82:	50                   	push   %eax
80102b83:	e8 c8 1b 00 00       	call   80104750 <memcmp>
80102b88:	83 c4 10             	add    $0x10,%esp
80102b8b:	85 c0                	test   %eax,%eax
80102b8d:	0f 85 f5 fe ff ff    	jne    80102a88 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b93:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102b97:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b9a:	89 f0                	mov    %esi,%eax
80102b9c:	84 c0                	test   %al,%al
80102b9e:	75 78                	jne    80102c18 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ba0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ba3:	89 c2                	mov    %eax,%edx
80102ba5:	83 e0 0f             	and    $0xf,%eax
80102ba8:	c1 ea 04             	shr    $0x4,%edx
80102bab:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bae:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bb1:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102bb4:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bb7:	89 c2                	mov    %eax,%edx
80102bb9:	83 e0 0f             	and    $0xf,%eax
80102bbc:	c1 ea 04             	shr    $0x4,%edx
80102bbf:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bc2:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bc5:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102bc8:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bcb:	89 c2                	mov    %eax,%edx
80102bcd:	83 e0 0f             	and    $0xf,%eax
80102bd0:	c1 ea 04             	shr    $0x4,%edx
80102bd3:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bd6:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bd9:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102bdc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bdf:	89 c2                	mov    %eax,%edx
80102be1:	83 e0 0f             	and    $0xf,%eax
80102be4:	c1 ea 04             	shr    $0x4,%edx
80102be7:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bea:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bed:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102bf0:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bf3:	89 c2                	mov    %eax,%edx
80102bf5:	83 e0 0f             	and    $0xf,%eax
80102bf8:	c1 ea 04             	shr    $0x4,%edx
80102bfb:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bfe:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c01:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102c04:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c07:	89 c2                	mov    %eax,%edx
80102c09:	83 e0 0f             	and    $0xf,%eax
80102c0c:	c1 ea 04             	shr    $0x4,%edx
80102c0f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c12:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c15:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102c18:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c1b:	89 03                	mov    %eax,(%ebx)
80102c1d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c20:	89 43 04             	mov    %eax,0x4(%ebx)
80102c23:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c26:	89 43 08             	mov    %eax,0x8(%ebx)
80102c29:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c2c:	89 43 0c             	mov    %eax,0xc(%ebx)
80102c2f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c32:	89 43 10             	mov    %eax,0x10(%ebx)
80102c35:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c38:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102c3b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102c42:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c45:	5b                   	pop    %ebx
80102c46:	5e                   	pop    %esi
80102c47:	5f                   	pop    %edi
80102c48:	5d                   	pop    %ebp
80102c49:	c3                   	ret
80102c4a:	66 90                	xchg   %ax,%ax
80102c4c:	66 90                	xchg   %ax,%ax
80102c4e:	66 90                	xchg   %ax,%ax

80102c50 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c50:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102c56:	85 c9                	test   %ecx,%ecx
80102c58:	0f 8e 8a 00 00 00    	jle    80102ce8 <install_trans+0x98>
{
80102c5e:	55                   	push   %ebp
80102c5f:	89 e5                	mov    %esp,%ebp
80102c61:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c62:	31 ff                	xor    %edi,%edi
{
80102c64:	56                   	push   %esi
80102c65:	53                   	push   %ebx
80102c66:	83 ec 0c             	sub    $0xc,%esp
80102c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c70:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102c75:	83 ec 08             	sub    $0x8,%esp
80102c78:	01 f8                	add    %edi,%eax
80102c7a:	83 c0 01             	add    $0x1,%eax
80102c7d:	50                   	push   %eax
80102c7e:	ff 35 e4 16 11 80    	push   0x801116e4
80102c84:	e8 47 d4 ff ff       	call   801000d0 <bread>
80102c89:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c8b:	58                   	pop    %eax
80102c8c:	5a                   	pop    %edx
80102c8d:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
80102c94:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c9a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c9d:	e8 2e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102ca2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ca5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102ca7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102caa:	68 00 02 00 00       	push   $0x200
80102caf:	50                   	push   %eax
80102cb0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102cb3:	50                   	push   %eax
80102cb4:	e8 e7 1a 00 00       	call   801047a0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102cb9:	89 1c 24             	mov    %ebx,(%esp)
80102cbc:	e8 ef d4 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102cc1:	89 34 24             	mov    %esi,(%esp)
80102cc4:	e8 27 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102cc9:	89 1c 24             	mov    %ebx,(%esp)
80102ccc:	e8 1f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cd1:	83 c4 10             	add    $0x10,%esp
80102cd4:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102cda:	7f 94                	jg     80102c70 <install_trans+0x20>
  }
}
80102cdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cdf:	5b                   	pop    %ebx
80102ce0:	5e                   	pop    %esi
80102ce1:	5f                   	pop    %edi
80102ce2:	5d                   	pop    %ebp
80102ce3:	c3                   	ret
80102ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ce8:	c3                   	ret
80102ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102cf0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102cf0:	55                   	push   %ebp
80102cf1:	89 e5                	mov    %esp,%ebp
80102cf3:	53                   	push   %ebx
80102cf4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cf7:	ff 35 d4 16 11 80    	push   0x801116d4
80102cfd:	ff 35 e4 16 11 80    	push   0x801116e4
80102d03:	e8 c8 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102d08:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d0b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102d0d:	a1 e8 16 11 80       	mov    0x801116e8,%eax
80102d12:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102d15:	85 c0                	test   %eax,%eax
80102d17:	7e 19                	jle    80102d32 <write_head+0x42>
80102d19:	31 d2                	xor    %edx,%edx
80102d1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d1f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102d20:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
80102d27:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d2b:	83 c2 01             	add    $0x1,%edx
80102d2e:	39 d0                	cmp    %edx,%eax
80102d30:	75 ee                	jne    80102d20 <write_head+0x30>
  }
  bwrite(buf);
80102d32:	83 ec 0c             	sub    $0xc,%esp
80102d35:	53                   	push   %ebx
80102d36:	e8 75 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102d3b:	89 1c 24             	mov    %ebx,(%esp)
80102d3e:	e8 ad d4 ff ff       	call   801001f0 <brelse>
}
80102d43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d46:	83 c4 10             	add    $0x10,%esp
80102d49:	c9                   	leave
80102d4a:	c3                   	ret
80102d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d4f:	90                   	nop

80102d50 <initlog>:
{
80102d50:	55                   	push   %ebp
80102d51:	89 e5                	mov    %esp,%ebp
80102d53:	53                   	push   %ebx
80102d54:	83 ec 2c             	sub    $0x2c,%esp
80102d57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d5a:	68 a0 76 10 80       	push   $0x801076a0
80102d5f:	68 a0 16 11 80       	push   $0x801116a0
80102d64:	e8 f7 16 00 00       	call   80104460 <initlock>
  readsb(dev, &sb);
80102d69:	58                   	pop    %eax
80102d6a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d6d:	5a                   	pop    %edx
80102d6e:	50                   	push   %eax
80102d6f:	53                   	push   %ebx
80102d70:	e8 1b e8 ff ff       	call   80101590 <readsb>
  log.size = sb.nlog;
80102d75:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.dev = dev;
80102d7b:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  log.start = sb.logstart;
80102d81:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102d86:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  struct buf *buf = bread(log.dev, log.start);
80102d8c:	59                   	pop    %ecx
80102d8d:	5a                   	pop    %edx
80102d8e:	50                   	push   %eax
80102d8f:	53                   	push   %ebx
80102d90:	e8 3b d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d95:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d98:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d9b:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102da1:	85 db                	test   %ebx,%ebx
80102da3:	7e 1d                	jle    80102dc2 <initlog+0x72>
80102da5:	31 d2                	xor    %edx,%edx
80102da7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dae:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102db0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102db4:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102dbb:	83 c2 01             	add    $0x1,%edx
80102dbe:	39 d3                	cmp    %edx,%ebx
80102dc0:	75 ee                	jne    80102db0 <initlog+0x60>
  brelse(buf);
80102dc2:	83 ec 0c             	sub    $0xc,%esp
80102dc5:	50                   	push   %eax
80102dc6:	e8 25 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102dcb:	e8 80 fe ff ff       	call   80102c50 <install_trans>
  log.lh.n = 0;
80102dd0:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102dd7:	00 00 00 
  write_head(); // clear the log
80102dda:	e8 11 ff ff ff       	call   80102cf0 <write_head>
}
80102ddf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102de2:	83 c4 10             	add    $0x10,%esp
80102de5:	c9                   	leave
80102de6:	c3                   	ret
80102de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dee:	66 90                	xchg   %ax,%ax

80102df0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102df6:	68 a0 16 11 80       	push   $0x801116a0
80102dfb:	e8 80 17 00 00       	call   80104580 <acquire>
80102e00:	83 c4 10             	add    $0x10,%esp
80102e03:	eb 18                	jmp    80102e1d <begin_op+0x2d>
80102e05:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102e08:	83 ec 08             	sub    $0x8,%esp
80102e0b:	68 a0 16 11 80       	push   $0x801116a0
80102e10:	68 a0 16 11 80       	push   $0x801116a0
80102e15:	e8 d6 12 00 00       	call   801040f0 <sleep>
80102e1a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102e1d:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102e22:	85 c0                	test   %eax,%eax
80102e24:	75 e2                	jne    80102e08 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102e26:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102e2b:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102e31:	83 c0 01             	add    $0x1,%eax
80102e34:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102e37:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e3a:	83 fa 1e             	cmp    $0x1e,%edx
80102e3d:	7f c9                	jg     80102e08 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e3f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e42:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
80102e47:	68 a0 16 11 80       	push   $0x801116a0
80102e4c:	e8 6f 18 00 00       	call   801046c0 <release>
      break;
    }
  }
}
80102e51:	83 c4 10             	add    $0x10,%esp
80102e54:	c9                   	leave
80102e55:	c3                   	ret
80102e56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e5d:	8d 76 00             	lea    0x0(%esi),%esi

80102e60 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	57                   	push   %edi
80102e64:	56                   	push   %esi
80102e65:	53                   	push   %ebx
80102e66:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e69:	68 a0 16 11 80       	push   $0x801116a0
80102e6e:	e8 0d 17 00 00       	call   80104580 <acquire>
  log.outstanding -= 1;
80102e73:	a1 dc 16 11 80       	mov    0x801116dc,%eax
  if(log.committing)
80102e78:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102e7e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e81:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e84:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102e8a:	85 f6                	test   %esi,%esi
80102e8c:	0f 85 22 01 00 00    	jne    80102fb4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e92:	85 db                	test   %ebx,%ebx
80102e94:	0f 85 f6 00 00 00    	jne    80102f90 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e9a:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102ea1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102ea4:	83 ec 0c             	sub    $0xc,%esp
80102ea7:	68 a0 16 11 80       	push   $0x801116a0
80102eac:	e8 0f 18 00 00       	call   801046c0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102eb1:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102eb7:	83 c4 10             	add    $0x10,%esp
80102eba:	85 c9                	test   %ecx,%ecx
80102ebc:	7f 42                	jg     80102f00 <end_op+0xa0>
    acquire(&log.lock);
80102ebe:	83 ec 0c             	sub    $0xc,%esp
80102ec1:	68 a0 16 11 80       	push   $0x801116a0
80102ec6:	e8 b5 16 00 00       	call   80104580 <acquire>
    log.committing = 0;
80102ecb:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102ed2:	00 00 00 
    wakeup(&log);
80102ed5:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102edc:	e8 cf 12 00 00       	call   801041b0 <wakeup>
    release(&log.lock);
80102ee1:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102ee8:	e8 d3 17 00 00       	call   801046c0 <release>
80102eed:	83 c4 10             	add    $0x10,%esp
}
80102ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ef3:	5b                   	pop    %ebx
80102ef4:	5e                   	pop    %esi
80102ef5:	5f                   	pop    %edi
80102ef6:	5d                   	pop    %ebp
80102ef7:	c3                   	ret
80102ef8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102eff:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102f00:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102f05:	83 ec 08             	sub    $0x8,%esp
80102f08:	01 d8                	add    %ebx,%eax
80102f0a:	83 c0 01             	add    $0x1,%eax
80102f0d:	50                   	push   %eax
80102f0e:	ff 35 e4 16 11 80    	push   0x801116e4
80102f14:	e8 b7 d1 ff ff       	call   801000d0 <bread>
80102f19:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f1b:	58                   	pop    %eax
80102f1c:	5a                   	pop    %edx
80102f1d:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80102f24:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102f2a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f2d:	e8 9e d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102f32:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f35:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f37:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f3a:	68 00 02 00 00       	push   $0x200
80102f3f:	50                   	push   %eax
80102f40:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f43:	50                   	push   %eax
80102f44:	e8 57 18 00 00       	call   801047a0 <memmove>
    bwrite(to);  // write the log
80102f49:	89 34 24             	mov    %esi,(%esp)
80102f4c:	e8 5f d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102f51:	89 3c 24             	mov    %edi,(%esp)
80102f54:	e8 97 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102f59:	89 34 24             	mov    %esi,(%esp)
80102f5c:	e8 8f d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f61:	83 c4 10             	add    $0x10,%esp
80102f64:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
80102f6a:	7c 94                	jl     80102f00 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f6c:	e8 7f fd ff ff       	call   80102cf0 <write_head>
    install_trans(); // Now install writes to home locations
80102f71:	e8 da fc ff ff       	call   80102c50 <install_trans>
    log.lh.n = 0;
80102f76:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102f7d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f80:	e8 6b fd ff ff       	call   80102cf0 <write_head>
80102f85:	e9 34 ff ff ff       	jmp    80102ebe <end_op+0x5e>
80102f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f90:	83 ec 0c             	sub    $0xc,%esp
80102f93:	68 a0 16 11 80       	push   $0x801116a0
80102f98:	e8 13 12 00 00       	call   801041b0 <wakeup>
  release(&log.lock);
80102f9d:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102fa4:	e8 17 17 00 00       	call   801046c0 <release>
80102fa9:	83 c4 10             	add    $0x10,%esp
}
80102fac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102faf:	5b                   	pop    %ebx
80102fb0:	5e                   	pop    %esi
80102fb1:	5f                   	pop    %edi
80102fb2:	5d                   	pop    %ebp
80102fb3:	c3                   	ret
    panic("log.committing");
80102fb4:	83 ec 0c             	sub    $0xc,%esp
80102fb7:	68 a4 76 10 80       	push   $0x801076a4
80102fbc:	e8 bf d3 ff ff       	call   80100380 <panic>
80102fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fcf:	90                   	nop

80102fd0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
80102fd3:	53                   	push   %ebx
80102fd4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fd7:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
{
80102fdd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fe0:	83 fa 1d             	cmp    $0x1d,%edx
80102fe3:	7f 7d                	jg     80103062 <log_write+0x92>
80102fe5:	a1 d8 16 11 80       	mov    0x801116d8,%eax
80102fea:	83 e8 01             	sub    $0x1,%eax
80102fed:	39 c2                	cmp    %eax,%edx
80102fef:	7d 71                	jge    80103062 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102ff1:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102ff6:	85 c0                	test   %eax,%eax
80102ff8:	7e 75                	jle    8010306f <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102ffa:	83 ec 0c             	sub    $0xc,%esp
80102ffd:	68 a0 16 11 80       	push   $0x801116a0
80103002:	e8 79 15 00 00       	call   80104580 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103007:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010300a:	83 c4 10             	add    $0x10,%esp
8010300d:	31 c0                	xor    %eax,%eax
8010300f:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80103015:	85 d2                	test   %edx,%edx
80103017:	7f 0e                	jg     80103027 <log_write+0x57>
80103019:	eb 15                	jmp    80103030 <log_write+0x60>
8010301b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010301f:	90                   	nop
80103020:	83 c0 01             	add    $0x1,%eax
80103023:	39 c2                	cmp    %eax,%edx
80103025:	74 29                	je     80103050 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103027:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
8010302e:	75 f0                	jne    80103020 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103030:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
80103037:	39 c2                	cmp    %eax,%edx
80103039:	74 1c                	je     80103057 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
8010303b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010303e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103041:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80103048:	c9                   	leave
  release(&log.lock);
80103049:	e9 72 16 00 00       	jmp    801046c0 <release>
8010304e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80103050:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
80103057:	83 c2 01             	add    $0x1,%edx
8010305a:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80103060:	eb d9                	jmp    8010303b <log_write+0x6b>
    panic("too big a transaction");
80103062:	83 ec 0c             	sub    $0xc,%esp
80103065:	68 b3 76 10 80       	push   $0x801076b3
8010306a:	e8 11 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010306f:	83 ec 0c             	sub    $0xc,%esp
80103072:	68 c9 76 10 80       	push   $0x801076c9
80103077:	e8 04 d3 ff ff       	call   80100380 <panic>
8010307c:	66 90                	xchg   %ax,%ax
8010307e:	66 90                	xchg   %ax,%ax

80103080 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103080:	55                   	push   %ebp
80103081:	89 e5                	mov    %esp,%ebp
80103083:	53                   	push   %ebx
80103084:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103087:	e8 74 09 00 00       	call   80103a00 <cpuid>
8010308c:	89 c3                	mov    %eax,%ebx
8010308e:	e8 6d 09 00 00       	call   80103a00 <cpuid>
80103093:	83 ec 04             	sub    $0x4,%esp
80103096:	53                   	push   %ebx
80103097:	50                   	push   %eax
80103098:	68 e4 76 10 80       	push   $0x801076e4
8010309d:	e8 0e d6 ff ff       	call   801006b0 <cprintf>
  cprintf("I am printing right now");
801030a2:	c7 04 24 f8 76 10 80 	movl   $0x801076f8,(%esp)
801030a9:	e8 02 d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
801030ae:	e8 bd 28 00 00       	call   80105970 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801030b3:	e8 e8 08 00 00       	call   801039a0 <mycpu>
801030b8:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801030ba:	b8 01 00 00 00       	mov    $0x1,%eax
801030bf:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801030c6:	e8 05 0c 00 00       	call   80103cd0 <scheduler>
801030cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030cf:	90                   	nop

801030d0 <mpenter>:
{
801030d0:	55                   	push   %ebp
801030d1:	89 e5                	mov    %esp,%ebp
801030d3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801030d6:	e8 a5 39 00 00       	call   80106a80 <switchkvm>
  seginit();
801030db:	e8 10 39 00 00       	call   801069f0 <seginit>
  lapicinit();
801030e0:	e8 9b f7 ff ff       	call   80102880 <lapicinit>
  mpmain();
801030e5:	e8 96 ff ff ff       	call   80103080 <mpmain>
801030ea:	66 90                	xchg   %ax,%ax
801030ec:	66 90                	xchg   %ax,%ax
801030ee:	66 90                	xchg   %ax,%ax

801030f0 <main>:
{ 
801030f0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801030f4:	83 e4 f0             	and    $0xfffffff0,%esp
801030f7:	ff 71 fc             	push   -0x4(%ecx)
801030fa:	55                   	push   %ebp
801030fb:	89 e5                	mov    %esp,%ebp
801030fd:	53                   	push   %ebx
801030fe:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030ff:	83 ec 08             	sub    $0x8,%esp
80103102:	68 00 00 40 80       	push   $0x80400000
80103107:	68 d0 54 11 80       	push   $0x801154d0
8010310c:	e8 7f f5 ff ff       	call   80102690 <kinit1>
  kvmalloc();      // kernel page table
80103111:	e8 2a 3e 00 00       	call   80106f40 <kvmalloc>
  mpinit();        // detect other processors
80103116:	e8 85 01 00 00       	call   801032a0 <mpinit>
  lapicinit();     // interrupt controller
8010311b:	e8 60 f7 ff ff       	call   80102880 <lapicinit>
  seginit();       // segment descriptors
80103120:	e8 cb 38 00 00       	call   801069f0 <seginit>
  picinit();       // disable pic
80103125:	e8 86 03 00 00       	call   801034b0 <picinit>
  ioapicinit();    // another interrupt controller
8010312a:	e8 31 f3 ff ff       	call   80102460 <ioapicinit>
  consoleinit();   // console hardware
8010312f:	e8 5c d9 ff ff       	call   80100a90 <consoleinit>
  uartinit();      // serial port
80103134:	e8 27 2b 00 00       	call   80105c60 <uartinit>
  pinit();         // process table
80103139:	e8 42 08 00 00       	call   80103980 <pinit>
  tvinit();        // trap vectors
8010313e:	e8 ad 27 00 00       	call   801058f0 <tvinit>
  binit();         // buffer cache
80103143:	e8 f8 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103148:	e8 13 dd ff ff       	call   80100e60 <fileinit>
  ideinit();       // disk 
8010314d:	e8 ee f0 ff ff       	call   80102240 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103152:	83 c4 0c             	add    $0xc,%esp
80103155:	68 8a 00 00 00       	push   $0x8a
8010315a:	68 8c a4 10 80       	push   $0x8010a48c
8010315f:	68 00 70 00 80       	push   $0x80007000
80103164:	e8 37 16 00 00       	call   801047a0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103169:	83 c4 10             	add    $0x10,%esp
8010316c:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103173:	00 00 00 
80103176:	05 a0 17 11 80       	add    $0x801117a0,%eax
8010317b:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
80103180:	76 7e                	jbe    80103200 <main+0x110>
80103182:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
80103187:	eb 20                	jmp    801031a9 <main+0xb9>
80103189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103190:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103197:	00 00 00 
8010319a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801031a0:	05 a0 17 11 80       	add    $0x801117a0,%eax
801031a5:	39 c3                	cmp    %eax,%ebx
801031a7:	73 57                	jae    80103200 <main+0x110>
    if(c == mycpu())  // We've started already.
801031a9:	e8 f2 07 00 00       	call   801039a0 <mycpu>
801031ae:	39 c3                	cmp    %eax,%ebx
801031b0:	74 de                	je     80103190 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801031b2:	e8 49 f5 ff ff       	call   80102700 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801031b7:	83 ec 08             	sub    $0x8,%esp
    *(void**)(code-8) = mpenter;
801031ba:	c7 05 f8 6f 00 80 d0 	movl   $0x801030d0,0x80006ff8
801031c1:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801031c4:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801031cb:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801031ce:	05 00 10 00 00       	add    $0x1000,%eax
801031d3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801031d8:	0f b6 03             	movzbl (%ebx),%eax
801031db:	68 00 70 00 00       	push   $0x7000
801031e0:	50                   	push   %eax
801031e1:	e8 ea f7 ff ff       	call   801029d0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801031e6:	83 c4 10             	add    $0x10,%esp
801031e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031f0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801031f6:	85 c0                	test   %eax,%eax
801031f8:	74 f6                	je     801031f0 <main+0x100>
801031fa:	eb 94                	jmp    80103190 <main+0xa0>
801031fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103200:	83 ec 08             	sub    $0x8,%esp
80103203:	68 00 00 00 8e       	push   $0x8e000000
80103208:	68 00 00 40 80       	push   $0x80400000
8010320d:	e8 1e f4 ff ff       	call   80102630 <kinit2>
  userinit();      // first user process
80103212:	e8 39 08 00 00       	call   80103a50 <userinit>
  mpmain();        // finish this processor's setup
80103217:	e8 64 fe ff ff       	call   80103080 <mpmain>
8010321c:	66 90                	xchg   %ax,%ax
8010321e:	66 90                	xchg   %ax,%ax

80103220 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103220:	55                   	push   %ebp
80103221:	89 e5                	mov    %esp,%ebp
80103223:	57                   	push   %edi
80103224:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103225:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010322b:	53                   	push   %ebx
  e = addr+len;
8010322c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010322f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103232:	39 de                	cmp    %ebx,%esi
80103234:	72 10                	jb     80103246 <mpsearch1+0x26>
80103236:	eb 50                	jmp    80103288 <mpsearch1+0x68>
80103238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010323f:	90                   	nop
80103240:	89 fe                	mov    %edi,%esi
80103242:	39 df                	cmp    %ebx,%edi
80103244:	73 42                	jae    80103288 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103246:	83 ec 04             	sub    $0x4,%esp
80103249:	8d 7e 10             	lea    0x10(%esi),%edi
8010324c:	6a 04                	push   $0x4
8010324e:	68 10 77 10 80       	push   $0x80107710
80103253:	56                   	push   %esi
80103254:	e8 f7 14 00 00       	call   80104750 <memcmp>
80103259:	83 c4 10             	add    $0x10,%esp
8010325c:	85 c0                	test   %eax,%eax
8010325e:	75 e0                	jne    80103240 <mpsearch1+0x20>
80103260:	89 f2                	mov    %esi,%edx
80103262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103268:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010326b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010326e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103270:	39 fa                	cmp    %edi,%edx
80103272:	75 f4                	jne    80103268 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103274:	84 c0                	test   %al,%al
80103276:	75 c8                	jne    80103240 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103278:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010327b:	89 f0                	mov    %esi,%eax
8010327d:	5b                   	pop    %ebx
8010327e:	5e                   	pop    %esi
8010327f:	5f                   	pop    %edi
80103280:	5d                   	pop    %ebp
80103281:	c3                   	ret
80103282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103288:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010328b:	31 f6                	xor    %esi,%esi
}
8010328d:	5b                   	pop    %ebx
8010328e:	89 f0                	mov    %esi,%eax
80103290:	5e                   	pop    %esi
80103291:	5f                   	pop    %edi
80103292:	5d                   	pop    %ebp
80103293:	c3                   	ret
80103294:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010329b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010329f:	90                   	nop

801032a0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801032a0:	55                   	push   %ebp
801032a1:	89 e5                	mov    %esp,%ebp
801032a3:	57                   	push   %edi
801032a4:	56                   	push   %esi
801032a5:	53                   	push   %ebx
801032a6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801032a9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801032b0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801032b7:	c1 e0 08             	shl    $0x8,%eax
801032ba:	09 d0                	or     %edx,%eax
801032bc:	c1 e0 04             	shl    $0x4,%eax
801032bf:	75 1b                	jne    801032dc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801032c1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801032c8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801032cf:	c1 e0 08             	shl    $0x8,%eax
801032d2:	09 d0                	or     %edx,%eax
801032d4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801032d7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801032dc:	ba 00 04 00 00       	mov    $0x400,%edx
801032e1:	e8 3a ff ff ff       	call   80103220 <mpsearch1>
801032e6:	89 c3                	mov    %eax,%ebx
801032e8:	85 c0                	test   %eax,%eax
801032ea:	0f 84 50 01 00 00    	je     80103440 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032f0:	8b 73 04             	mov    0x4(%ebx),%esi
801032f3:	85 f6                	test   %esi,%esi
801032f5:	0f 84 35 01 00 00    	je     80103430 <mpinit+0x190>
  if(memcmp(conf, "PCMP", 4) != 0)
801032fb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032fe:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80103304:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103307:	6a 04                	push   $0x4
80103309:	68 15 77 10 80       	push   $0x80107715
8010330e:	50                   	push   %eax
8010330f:	e8 3c 14 00 00       	call   80104750 <memcmp>
80103314:	83 c4 10             	add    $0x10,%esp
80103317:	85 c0                	test   %eax,%eax
80103319:	0f 85 11 01 00 00    	jne    80103430 <mpinit+0x190>
  if(conf->version != 1 && conf->version != 4)
8010331f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103326:	3c 01                	cmp    $0x1,%al
80103328:	74 08                	je     80103332 <mpinit+0x92>
8010332a:	3c 04                	cmp    $0x4,%al
8010332c:	0f 85 fe 00 00 00    	jne    80103430 <mpinit+0x190>
  if(sum((uchar*)conf, conf->length) != 0)
80103332:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103339:	66 85 d2             	test   %dx,%dx
8010333c:	74 22                	je     80103360 <mpinit+0xc0>
8010333e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103341:	89 f0                	mov    %esi,%eax
  sum = 0;
80103343:	31 d2                	xor    %edx,%edx
80103345:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103348:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010334f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103352:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103354:	39 c7                	cmp    %eax,%edi
80103356:	75 f0                	jne    80103348 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103358:	84 d2                	test   %dl,%dl
8010335a:	0f 85 d0 00 00 00    	jne    80103430 <mpinit+0x190>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103360:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103366:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103369:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
8010336c:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103371:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103378:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
8010337e:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103383:	01 d7                	add    %edx,%edi
80103385:	89 fa                	mov    %edi,%edx
80103387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010338e:	66 90                	xchg   %ax,%ax
80103390:	39 d0                	cmp    %edx,%eax
80103392:	73 15                	jae    801033a9 <mpinit+0x109>
    switch(*p){
80103394:	0f b6 08             	movzbl (%eax),%ecx
80103397:	80 f9 02             	cmp    $0x2,%cl
8010339a:	74 54                	je     801033f0 <mpinit+0x150>
8010339c:	77 42                	ja     801033e0 <mpinit+0x140>
8010339e:	84 c9                	test   %cl,%cl
801033a0:	74 5e                	je     80103400 <mpinit+0x160>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801033a2:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033a5:	39 d0                	cmp    %edx,%eax
801033a7:	72 eb                	jb     80103394 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801033a9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801033ac:	85 f6                	test   %esi,%esi
801033ae:	0f 84 e1 00 00 00    	je     80103495 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801033b4:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801033b8:	74 15                	je     801033cf <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033ba:	b8 70 00 00 00       	mov    $0x70,%eax
801033bf:	ba 22 00 00 00       	mov    $0x22,%edx
801033c4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033c5:	ba 23 00 00 00       	mov    $0x23,%edx
801033ca:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801033cb:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033ce:	ee                   	out    %al,(%dx)
  }
}
801033cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033d2:	5b                   	pop    %ebx
801033d3:	5e                   	pop    %esi
801033d4:	5f                   	pop    %edi
801033d5:	5d                   	pop    %ebp
801033d6:	c3                   	ret
801033d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033de:	66 90                	xchg   %ax,%ax
    switch(*p){
801033e0:	83 e9 03             	sub    $0x3,%ecx
801033e3:	80 f9 01             	cmp    $0x1,%cl
801033e6:	76 ba                	jbe    801033a2 <mpinit+0x102>
801033e8:	31 f6                	xor    %esi,%esi
801033ea:	eb a4                	jmp    80103390 <mpinit+0xf0>
801033ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801033f0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801033f4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801033f7:	88 0d 80 17 11 80    	mov    %cl,0x80111780
      continue;
801033fd:	eb 91                	jmp    80103390 <mpinit+0xf0>
801033ff:	90                   	nop
      if(ncpu < NCPU) {
80103400:	8b 0d 84 17 11 80    	mov    0x80111784,%ecx
80103406:	83 f9 07             	cmp    $0x7,%ecx
80103409:	7f 19                	jg     80103424 <mpinit+0x184>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010340b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103411:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103415:	83 c1 01             	add    $0x1,%ecx
80103418:	89 0d 84 17 11 80    	mov    %ecx,0x80111784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010341e:	88 9f a0 17 11 80    	mov    %bl,-0x7feee860(%edi)
      p += sizeof(struct mpproc);
80103424:	83 c0 14             	add    $0x14,%eax
      continue;
80103427:	e9 64 ff ff ff       	jmp    80103390 <mpinit+0xf0>
8010342c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103430:	83 ec 0c             	sub    $0xc,%esp
80103433:	68 1a 77 10 80       	push   $0x8010771a
80103438:	e8 43 cf ff ff       	call   80100380 <panic>
8010343d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103440:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103445:	eb 13                	jmp    8010345a <mpinit+0x1ba>
80103447:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010344e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103450:	89 f3                	mov    %esi,%ebx
80103452:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103458:	74 d6                	je     80103430 <mpinit+0x190>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010345a:	83 ec 04             	sub    $0x4,%esp
8010345d:	8d 73 10             	lea    0x10(%ebx),%esi
80103460:	6a 04                	push   $0x4
80103462:	68 10 77 10 80       	push   $0x80107710
80103467:	53                   	push   %ebx
80103468:	e8 e3 12 00 00       	call   80104750 <memcmp>
8010346d:	83 c4 10             	add    $0x10,%esp
80103470:	85 c0                	test   %eax,%eax
80103472:	75 dc                	jne    80103450 <mpinit+0x1b0>
80103474:	89 da                	mov    %ebx,%edx
80103476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010347d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103480:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103483:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103486:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103488:	39 f2                	cmp    %esi,%edx
8010348a:	75 f4                	jne    80103480 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010348c:	84 c0                	test   %al,%al
8010348e:	75 c0                	jne    80103450 <mpinit+0x1b0>
80103490:	e9 5b fe ff ff       	jmp    801032f0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103495:	83 ec 0c             	sub    $0xc,%esp
80103498:	68 34 77 10 80       	push   $0x80107734
8010349d:	e8 de ce ff ff       	call   80100380 <panic>
801034a2:	66 90                	xchg   %ax,%ax
801034a4:	66 90                	xchg   %ax,%ax
801034a6:	66 90                	xchg   %ax,%ax
801034a8:	66 90                	xchg   %ax,%ax
801034aa:	66 90                	xchg   %ax,%ax
801034ac:	66 90                	xchg   %ax,%ax
801034ae:	66 90                	xchg   %ax,%ax

801034b0 <picinit>:
801034b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034b5:	ba 21 00 00 00       	mov    $0x21,%edx
801034ba:	ee                   	out    %al,(%dx)
801034bb:	ba a1 00 00 00       	mov    $0xa1,%edx
801034c0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801034c1:	c3                   	ret
801034c2:	66 90                	xchg   %ax,%ax
801034c4:	66 90                	xchg   %ax,%ax
801034c6:	66 90                	xchg   %ax,%ax
801034c8:	66 90                	xchg   %ax,%ax
801034ca:	66 90                	xchg   %ax,%ax
801034cc:	66 90                	xchg   %ax,%ax
801034ce:	66 90                	xchg   %ax,%ax

801034d0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801034d0:	55                   	push   %ebp
801034d1:	89 e5                	mov    %esp,%ebp
801034d3:	57                   	push   %edi
801034d4:	56                   	push   %esi
801034d5:	53                   	push   %ebx
801034d6:	83 ec 0c             	sub    $0xc,%esp
801034d9:	8b 75 08             	mov    0x8(%ebp),%esi
801034dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801034df:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
801034e5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801034eb:	e8 90 d9 ff ff       	call   80100e80 <filealloc>
801034f0:	89 06                	mov    %eax,(%esi)
801034f2:	85 c0                	test   %eax,%eax
801034f4:	0f 84 a5 00 00 00    	je     8010359f <pipealloc+0xcf>
801034fa:	e8 81 d9 ff ff       	call   80100e80 <filealloc>
801034ff:	89 07                	mov    %eax,(%edi)
80103501:	85 c0                	test   %eax,%eax
80103503:	0f 84 84 00 00 00    	je     8010358d <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103509:	e8 f2 f1 ff ff       	call   80102700 <kalloc>
8010350e:	89 c3                	mov    %eax,%ebx
80103510:	85 c0                	test   %eax,%eax
80103512:	0f 84 a0 00 00 00    	je     801035b8 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103518:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010351f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103522:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103525:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010352c:	00 00 00 
  p->nwrite = 0;
8010352f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103536:	00 00 00 
  p->nread = 0;
80103539:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103540:	00 00 00 
  initlock(&p->lock, "pipe");
80103543:	68 53 77 10 80       	push   $0x80107753
80103548:	50                   	push   %eax
80103549:	e8 12 0f 00 00       	call   80104460 <initlock>
  (*f0)->type = FD_PIPE;
8010354e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103550:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103553:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103559:	8b 06                	mov    (%esi),%eax
8010355b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010355f:	8b 06                	mov    (%esi),%eax
80103561:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103565:	8b 06                	mov    (%esi),%eax
80103567:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010356a:	8b 07                	mov    (%edi),%eax
8010356c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103572:	8b 07                	mov    (%edi),%eax
80103574:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103578:	8b 07                	mov    (%edi),%eax
8010357a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010357e:	8b 07                	mov    (%edi),%eax
80103580:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
80103583:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103585:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103588:	5b                   	pop    %ebx
80103589:	5e                   	pop    %esi
8010358a:	5f                   	pop    %edi
8010358b:	5d                   	pop    %ebp
8010358c:	c3                   	ret
  if(*f0)
8010358d:	8b 06                	mov    (%esi),%eax
8010358f:	85 c0                	test   %eax,%eax
80103591:	74 1e                	je     801035b1 <pipealloc+0xe1>
    fileclose(*f0);
80103593:	83 ec 0c             	sub    $0xc,%esp
80103596:	50                   	push   %eax
80103597:	e8 a4 d9 ff ff       	call   80100f40 <fileclose>
8010359c:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010359f:	8b 07                	mov    (%edi),%eax
801035a1:	85 c0                	test   %eax,%eax
801035a3:	74 0c                	je     801035b1 <pipealloc+0xe1>
    fileclose(*f1);
801035a5:	83 ec 0c             	sub    $0xc,%esp
801035a8:	50                   	push   %eax
801035a9:	e8 92 d9 ff ff       	call   80100f40 <fileclose>
801035ae:	83 c4 10             	add    $0x10,%esp
  return -1;
801035b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035b6:	eb cd                	jmp    80103585 <pipealloc+0xb5>
  if(*f0)
801035b8:	8b 06                	mov    (%esi),%eax
801035ba:	85 c0                	test   %eax,%eax
801035bc:	75 d5                	jne    80103593 <pipealloc+0xc3>
801035be:	eb df                	jmp    8010359f <pipealloc+0xcf>

801035c0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	56                   	push   %esi
801035c4:	53                   	push   %ebx
801035c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801035cb:	83 ec 0c             	sub    $0xc,%esp
801035ce:	53                   	push   %ebx
801035cf:	e8 ac 0f 00 00       	call   80104580 <acquire>
  if(writable){
801035d4:	83 c4 10             	add    $0x10,%esp
801035d7:	85 f6                	test   %esi,%esi
801035d9:	74 65                	je     80103640 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801035db:	83 ec 0c             	sub    $0xc,%esp
801035de:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801035e4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801035eb:	00 00 00 
    wakeup(&p->nread);
801035ee:	50                   	push   %eax
801035ef:	e8 bc 0b 00 00       	call   801041b0 <wakeup>
801035f4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801035f7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801035fd:	85 d2                	test   %edx,%edx
801035ff:	75 0a                	jne    8010360b <pipeclose+0x4b>
80103601:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103607:	85 c0                	test   %eax,%eax
80103609:	74 15                	je     80103620 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010360b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010360e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103611:	5b                   	pop    %ebx
80103612:	5e                   	pop    %esi
80103613:	5d                   	pop    %ebp
    release(&p->lock);
80103614:	e9 a7 10 00 00       	jmp    801046c0 <release>
80103619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103620:	83 ec 0c             	sub    $0xc,%esp
80103623:	53                   	push   %ebx
80103624:	e8 97 10 00 00       	call   801046c0 <release>
    kfree((char*)p);
80103629:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010362c:	83 c4 10             	add    $0x10,%esp
}
8010362f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103632:	5b                   	pop    %ebx
80103633:	5e                   	pop    %esi
80103634:	5d                   	pop    %ebp
    kfree((char*)p);
80103635:	e9 06 ef ff ff       	jmp    80102540 <kfree>
8010363a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103640:	83 ec 0c             	sub    $0xc,%esp
80103643:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103649:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103650:	00 00 00 
    wakeup(&p->nwrite);
80103653:	50                   	push   %eax
80103654:	e8 57 0b 00 00       	call   801041b0 <wakeup>
80103659:	83 c4 10             	add    $0x10,%esp
8010365c:	eb 99                	jmp    801035f7 <pipeclose+0x37>
8010365e:	66 90                	xchg   %ax,%ax

80103660 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103660:	55                   	push   %ebp
80103661:	89 e5                	mov    %esp,%ebp
80103663:	57                   	push   %edi
80103664:	56                   	push   %esi
80103665:	53                   	push   %ebx
80103666:	83 ec 28             	sub    $0x28,%esp
80103669:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010366c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010366f:	53                   	push   %ebx
80103670:	e8 0b 0f 00 00       	call   80104580 <acquire>
  for(i = 0; i < n; i++){
80103675:	83 c4 10             	add    $0x10,%esp
80103678:	85 ff                	test   %edi,%edi
8010367a:	0f 8e ce 00 00 00    	jle    8010374e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103680:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103686:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103689:	89 7d 10             	mov    %edi,0x10(%ebp)
8010368c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010368f:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103692:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103695:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010369b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036a1:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036a7:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
801036ad:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
801036b0:	0f 85 b6 00 00 00    	jne    8010376c <pipewrite+0x10c>
801036b6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801036b9:	eb 3b                	jmp    801036f6 <pipewrite+0x96>
801036bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036bf:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
801036c0:	e8 5b 03 00 00       	call   80103a20 <myproc>
801036c5:	8b 48 24             	mov    0x24(%eax),%ecx
801036c8:	85 c9                	test   %ecx,%ecx
801036ca:	75 34                	jne    80103700 <pipewrite+0xa0>
      wakeup(&p->nread);
801036cc:	83 ec 0c             	sub    $0xc,%esp
801036cf:	56                   	push   %esi
801036d0:	e8 db 0a 00 00       	call   801041b0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036d5:	58                   	pop    %eax
801036d6:	5a                   	pop    %edx
801036d7:	53                   	push   %ebx
801036d8:	57                   	push   %edi
801036d9:	e8 12 0a 00 00       	call   801040f0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036de:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801036e4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801036ea:	83 c4 10             	add    $0x10,%esp
801036ed:	05 00 02 00 00       	add    $0x200,%eax
801036f2:	39 c2                	cmp    %eax,%edx
801036f4:	75 2a                	jne    80103720 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801036f6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801036fc:	85 c0                	test   %eax,%eax
801036fe:	75 c0                	jne    801036c0 <pipewrite+0x60>
        release(&p->lock);
80103700:	83 ec 0c             	sub    $0xc,%esp
80103703:	53                   	push   %ebx
80103704:	e8 b7 0f 00 00       	call   801046c0 <release>
        return -1;
80103709:	83 c4 10             	add    $0x10,%esp
8010370c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103711:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103714:	5b                   	pop    %ebx
80103715:	5e                   	pop    %esi
80103716:	5f                   	pop    %edi
80103717:	5d                   	pop    %ebp
80103718:	c3                   	ret
80103719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103720:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103723:	8d 42 01             	lea    0x1(%edx),%eax
80103726:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
8010372c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010372f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103735:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103738:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
8010373c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103740:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103743:	39 c1                	cmp    %eax,%ecx
80103745:	0f 85 50 ff ff ff    	jne    8010369b <pipewrite+0x3b>
8010374b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010374e:	83 ec 0c             	sub    $0xc,%esp
80103751:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103757:	50                   	push   %eax
80103758:	e8 53 0a 00 00       	call   801041b0 <wakeup>
  release(&p->lock);
8010375d:	89 1c 24             	mov    %ebx,(%esp)
80103760:	e8 5b 0f 00 00       	call   801046c0 <release>
  return n;
80103765:	83 c4 10             	add    $0x10,%esp
80103768:	89 f8                	mov    %edi,%eax
8010376a:	eb a5                	jmp    80103711 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010376c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010376f:	eb b2                	jmp    80103723 <pipewrite+0xc3>
80103771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103778:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010377f:	90                   	nop

80103780 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	57                   	push   %edi
80103784:	56                   	push   %esi
80103785:	53                   	push   %ebx
80103786:	83 ec 18             	sub    $0x18,%esp
80103789:	8b 75 08             	mov    0x8(%ebp),%esi
8010378c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010378f:	56                   	push   %esi
80103790:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103796:	e8 e5 0d 00 00       	call   80104580 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010379b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037a1:	83 c4 10             	add    $0x10,%esp
801037a4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801037aa:	74 2f                	je     801037db <piperead+0x5b>
801037ac:	eb 37                	jmp    801037e5 <piperead+0x65>
801037ae:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801037b0:	e8 6b 02 00 00       	call   80103a20 <myproc>
801037b5:	8b 48 24             	mov    0x24(%eax),%ecx
801037b8:	85 c9                	test   %ecx,%ecx
801037ba:	0f 85 80 00 00 00    	jne    80103840 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801037c0:	83 ec 08             	sub    $0x8,%esp
801037c3:	56                   	push   %esi
801037c4:	53                   	push   %ebx
801037c5:	e8 26 09 00 00       	call   801040f0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037ca:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
801037d0:	83 c4 10             	add    $0x10,%esp
801037d3:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
801037d9:	75 0a                	jne    801037e5 <piperead+0x65>
801037db:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
801037e1:	85 c0                	test   %eax,%eax
801037e3:	75 cb                	jne    801037b0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037e5:	8b 55 10             	mov    0x10(%ebp),%edx
801037e8:	31 db                	xor    %ebx,%ebx
801037ea:	85 d2                	test   %edx,%edx
801037ec:	7f 20                	jg     8010380e <piperead+0x8e>
801037ee:	eb 2c                	jmp    8010381c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801037f0:	8d 48 01             	lea    0x1(%eax),%ecx
801037f3:	25 ff 01 00 00       	and    $0x1ff,%eax
801037f8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801037fe:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103803:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103806:	83 c3 01             	add    $0x1,%ebx
80103809:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010380c:	74 0e                	je     8010381c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010380e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103814:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010381a:	75 d4                	jne    801037f0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010381c:	83 ec 0c             	sub    $0xc,%esp
8010381f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103825:	50                   	push   %eax
80103826:	e8 85 09 00 00       	call   801041b0 <wakeup>
  release(&p->lock);
8010382b:	89 34 24             	mov    %esi,(%esp)
8010382e:	e8 8d 0e 00 00       	call   801046c0 <release>
  return i;
80103833:	83 c4 10             	add    $0x10,%esp
}
80103836:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103839:	89 d8                	mov    %ebx,%eax
8010383b:	5b                   	pop    %ebx
8010383c:	5e                   	pop    %esi
8010383d:	5f                   	pop    %edi
8010383e:	5d                   	pop    %ebp
8010383f:	c3                   	ret
      release(&p->lock);
80103840:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103843:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103848:	56                   	push   %esi
80103849:	e8 72 0e 00 00       	call   801046c0 <release>
      return -1;
8010384e:	83 c4 10             	add    $0x10,%esp
}
80103851:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103854:	89 d8                	mov    %ebx,%eax
80103856:	5b                   	pop    %ebx
80103857:	5e                   	pop    %esi
80103858:	5f                   	pop    %edi
80103859:	5d                   	pop    %ebp
8010385a:	c3                   	ret
8010385b:	66 90                	xchg   %ax,%ax
8010385d:	66 90                	xchg   %ax,%ax
8010385f:	90                   	nop

80103860 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103864:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
{
80103869:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010386c:	68 20 1d 11 80       	push   $0x80111d20
80103871:	e8 0a 0d 00 00       	call   80104580 <acquire>
80103876:	83 c4 10             	add    $0x10,%esp
80103879:	eb 10                	jmp    8010388b <allocproc+0x2b>
8010387b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010387f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103880:	83 c3 7c             	add    $0x7c,%ebx
80103883:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103889:	74 75                	je     80103900 <allocproc+0xa0>
    if(p->state == UNUSED)
8010388b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010388e:	85 c0                	test   %eax,%eax
80103890:	75 ee                	jne    80103880 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103892:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103897:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010389a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801038a1:	8d 50 01             	lea    0x1(%eax),%edx
801038a4:	89 43 10             	mov    %eax,0x10(%ebx)
801038a7:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
801038ad:	68 20 1d 11 80       	push   $0x80111d20
801038b2:	e8 09 0e 00 00       	call   801046c0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801038b7:	e8 44 ee ff ff       	call   80102700 <kalloc>
801038bc:	83 c4 10             	add    $0x10,%esp
801038bf:	89 43 08             	mov    %eax,0x8(%ebx)
801038c2:	85 c0                	test   %eax,%eax
801038c4:	74 53                	je     80103919 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801038c6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801038cc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801038cf:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801038d4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801038d7:	c7 40 14 e2 58 10 80 	movl   $0x801058e2,0x14(%eax)
  p->context = (struct context*)sp;
801038de:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801038e1:	6a 14                	push   $0x14
801038e3:	6a 00                	push   $0x0
801038e5:	50                   	push   %eax
801038e6:	e8 25 0e 00 00       	call   80104710 <memset>
  p->context->eip = (uint)forkret;
801038eb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801038ee:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801038f1:	c7 40 10 30 39 10 80 	movl   $0x80103930,0x10(%eax)
}
801038f8:	89 d8                	mov    %ebx,%eax
801038fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038fd:	c9                   	leave
801038fe:	c3                   	ret
801038ff:	90                   	nop
  release(&ptable.lock);
80103900:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103903:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103905:	68 20 1d 11 80       	push   $0x80111d20
8010390a:	e8 b1 0d 00 00       	call   801046c0 <release>
  return 0;
8010390f:	83 c4 10             	add    $0x10,%esp
}
80103912:	89 d8                	mov    %ebx,%eax
80103914:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103917:	c9                   	leave
80103918:	c3                   	ret
    p->state = UNUSED;
80103919:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80103920:	31 db                	xor    %ebx,%ebx
80103922:	eb ee                	jmp    80103912 <allocproc+0xb2>
80103924:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010392b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010392f:	90                   	nop

80103930 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103936:	68 20 1d 11 80       	push   $0x80111d20
8010393b:	e8 80 0d 00 00       	call   801046c0 <release>

  if (first) {
80103940:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103945:	83 c4 10             	add    $0x10,%esp
80103948:	85 c0                	test   %eax,%eax
8010394a:	75 04                	jne    80103950 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010394c:	c9                   	leave
8010394d:	c3                   	ret
8010394e:	66 90                	xchg   %ax,%ax
    first = 0;
80103950:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103957:	00 00 00 
    iinit(ROOTDEV);
8010395a:	83 ec 0c             	sub    $0xc,%esp
8010395d:	6a 01                	push   $0x1
8010395f:	e8 6c dc ff ff       	call   801015d0 <iinit>
    initlog(ROOTDEV);
80103964:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010396b:	e8 e0 f3 ff ff       	call   80102d50 <initlog>
}
80103970:	83 c4 10             	add    $0x10,%esp
80103973:	c9                   	leave
80103974:	c3                   	ret
80103975:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010397c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103980 <pinit>:
{
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103986:	68 58 77 10 80       	push   $0x80107758
8010398b:	68 20 1d 11 80       	push   $0x80111d20
80103990:	e8 cb 0a 00 00       	call   80104460 <initlock>
}
80103995:	83 c4 10             	add    $0x10,%esp
80103998:	c9                   	leave
80103999:	c3                   	ret
8010399a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039a0 <mycpu>:
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	56                   	push   %esi
801039a4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039a5:	9c                   	pushf
801039a6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801039a7:	f6 c4 02             	test   $0x2,%ah
801039aa:	75 46                	jne    801039f2 <mycpu+0x52>
  apicid = lapicid();
801039ac:	e8 cf ef ff ff       	call   80102980 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801039b1:	8b 35 84 17 11 80    	mov    0x80111784,%esi
801039b7:	85 f6                	test   %esi,%esi
801039b9:	7e 2a                	jle    801039e5 <mycpu+0x45>
801039bb:	31 d2                	xor    %edx,%edx
801039bd:	eb 08                	jmp    801039c7 <mycpu+0x27>
801039bf:	90                   	nop
801039c0:	83 c2 01             	add    $0x1,%edx
801039c3:	39 f2                	cmp    %esi,%edx
801039c5:	74 1e                	je     801039e5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
801039c7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801039cd:	0f b6 99 a0 17 11 80 	movzbl -0x7feee860(%ecx),%ebx
801039d4:	39 c3                	cmp    %eax,%ebx
801039d6:	75 e8                	jne    801039c0 <mycpu+0x20>
}
801039d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801039db:	8d 81 a0 17 11 80    	lea    -0x7feee860(%ecx),%eax
}
801039e1:	5b                   	pop    %ebx
801039e2:	5e                   	pop    %esi
801039e3:	5d                   	pop    %ebp
801039e4:	c3                   	ret
  panic("unknown apicid\n");
801039e5:	83 ec 0c             	sub    $0xc,%esp
801039e8:	68 5f 77 10 80       	push   $0x8010775f
801039ed:	e8 8e c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
801039f2:	83 ec 0c             	sub    $0xc,%esp
801039f5:	68 3c 78 10 80       	push   $0x8010783c
801039fa:	e8 81 c9 ff ff       	call   80100380 <panic>
801039ff:	90                   	nop

80103a00 <cpuid>:
cpuid() {
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a06:	e8 95 ff ff ff       	call   801039a0 <mycpu>
}
80103a0b:	c9                   	leave
  return mycpu()-cpus;
80103a0c:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103a11:	c1 f8 04             	sar    $0x4,%eax
80103a14:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a1a:	c3                   	ret
80103a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a1f:	90                   	nop

80103a20 <myproc>:
myproc(void) {
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	53                   	push   %ebx
80103a24:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a27:	e8 04 0b 00 00       	call   80104530 <pushcli>
  c = mycpu();
80103a2c:	e8 6f ff ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103a31:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a37:	e8 24 0c 00 00       	call   80104660 <popcli>
}
80103a3c:	89 d8                	mov    %ebx,%eax
80103a3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a41:	c9                   	leave
80103a42:	c3                   	ret
80103a43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a50 <userinit>:
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	53                   	push   %ebx
80103a54:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a57:	e8 04 fe ff ff       	call   80103860 <allocproc>
80103a5c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a5e:	a3 54 3c 11 80       	mov    %eax,0x80113c54
  if((p->pgdir = setupkvm()) == 0)
80103a63:	e8 58 34 00 00       	call   80106ec0 <setupkvm>
80103a68:	89 43 04             	mov    %eax,0x4(%ebx)
80103a6b:	85 c0                	test   %eax,%eax
80103a6d:	0f 84 bd 00 00 00    	je     80103b30 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a73:	83 ec 04             	sub    $0x4,%esp
80103a76:	68 2c 00 00 00       	push   $0x2c
80103a7b:	68 60 a4 10 80       	push   $0x8010a460
80103a80:	50                   	push   %eax
80103a81:	e8 1a 31 00 00       	call   80106ba0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a86:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a89:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a8f:	6a 4c                	push   $0x4c
80103a91:	6a 00                	push   $0x0
80103a93:	ff 73 18             	push   0x18(%ebx)
80103a96:	e8 75 0c 00 00       	call   80104710 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a9b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a9e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103aa3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103aa6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103aab:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103aaf:	8b 43 18             	mov    0x18(%ebx),%eax
80103ab2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103ab6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ab9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103abd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103ac1:	8b 43 18             	mov    0x18(%ebx),%eax
80103ac4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ac8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103acc:	8b 43 18             	mov    0x18(%ebx),%eax
80103acf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103ad6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ad9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103ae0:	8b 43 18             	mov    0x18(%ebx),%eax
80103ae3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103aea:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103aed:	6a 10                	push   $0x10
80103aef:	68 88 77 10 80       	push   $0x80107788
80103af4:	50                   	push   %eax
80103af5:	e8 c6 0d 00 00       	call   801048c0 <safestrcpy>
  p->cwd = namei("/");
80103afa:	c7 04 24 91 77 10 80 	movl   $0x80107791,(%esp)
80103b01:	e8 1a e6 ff ff       	call   80102120 <namei>
80103b06:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103b09:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103b10:	e8 6b 0a 00 00       	call   80104580 <acquire>
  p->state = RUNNABLE;
80103b15:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103b1c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103b23:	e8 98 0b 00 00       	call   801046c0 <release>
}
80103b28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b2b:	83 c4 10             	add    $0x10,%esp
80103b2e:	c9                   	leave
80103b2f:	c3                   	ret
    panic("userinit: out of memory?");
80103b30:	83 ec 0c             	sub    $0xc,%esp
80103b33:	68 6f 77 10 80       	push   $0x8010776f
80103b38:	e8 43 c8 ff ff       	call   80100380 <panic>
80103b3d:	8d 76 00             	lea    0x0(%esi),%esi

80103b40 <growproc>:
{
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	56                   	push   %esi
80103b44:	53                   	push   %ebx
80103b45:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103b48:	e8 e3 09 00 00       	call   80104530 <pushcli>
  c = mycpu();
80103b4d:	e8 4e fe ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103b52:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b58:	e8 03 0b 00 00       	call   80104660 <popcli>
  sz = curproc->sz;
80103b5d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b5f:	85 f6                	test   %esi,%esi
80103b61:	7f 1d                	jg     80103b80 <growproc+0x40>
  } else if(n < 0){
80103b63:	75 3b                	jne    80103ba0 <growproc+0x60>
  switchuvm(curproc);
80103b65:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b68:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b6a:	53                   	push   %ebx
80103b6b:	e8 20 2f 00 00       	call   80106a90 <switchuvm>
  return 0;
80103b70:	83 c4 10             	add    $0x10,%esp
80103b73:	31 c0                	xor    %eax,%eax
}
80103b75:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b78:	5b                   	pop    %ebx
80103b79:	5e                   	pop    %esi
80103b7a:	5d                   	pop    %ebp
80103b7b:	c3                   	ret
80103b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b80:	83 ec 04             	sub    $0x4,%esp
80103b83:	01 c6                	add    %eax,%esi
80103b85:	56                   	push   %esi
80103b86:	50                   	push   %eax
80103b87:	ff 73 04             	push   0x4(%ebx)
80103b8a:	e8 61 31 00 00       	call   80106cf0 <allocuvm>
80103b8f:	83 c4 10             	add    $0x10,%esp
80103b92:	85 c0                	test   %eax,%eax
80103b94:	75 cf                	jne    80103b65 <growproc+0x25>
      return -1;
80103b96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b9b:	eb d8                	jmp    80103b75 <growproc+0x35>
80103b9d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ba0:	83 ec 04             	sub    $0x4,%esp
80103ba3:	01 c6                	add    %eax,%esi
80103ba5:	56                   	push   %esi
80103ba6:	50                   	push   %eax
80103ba7:	ff 73 04             	push   0x4(%ebx)
80103baa:	e8 61 32 00 00       	call   80106e10 <deallocuvm>
80103baf:	83 c4 10             	add    $0x10,%esp
80103bb2:	85 c0                	test   %eax,%eax
80103bb4:	75 af                	jne    80103b65 <growproc+0x25>
80103bb6:	eb de                	jmp    80103b96 <growproc+0x56>
80103bb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bbf:	90                   	nop

80103bc0 <fork>:
{
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	57                   	push   %edi
80103bc4:	56                   	push   %esi
80103bc5:	53                   	push   %ebx
80103bc6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103bc9:	e8 62 09 00 00       	call   80104530 <pushcli>
  c = mycpu();
80103bce:	e8 cd fd ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103bd3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bd9:	e8 82 0a 00 00       	call   80104660 <popcli>
  if((np = allocproc()) == 0){
80103bde:	e8 7d fc ff ff       	call   80103860 <allocproc>
80103be3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103be6:	85 c0                	test   %eax,%eax
80103be8:	0f 84 d6 00 00 00    	je     80103cc4 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103bee:	83 ec 08             	sub    $0x8,%esp
80103bf1:	ff 33                	push   (%ebx)
80103bf3:	89 c7                	mov    %eax,%edi
80103bf5:	ff 73 04             	push   0x4(%ebx)
80103bf8:	e8 b3 33 00 00       	call   80106fb0 <copyuvm>
80103bfd:	83 c4 10             	add    $0x10,%esp
80103c00:	89 47 04             	mov    %eax,0x4(%edi)
80103c03:	85 c0                	test   %eax,%eax
80103c05:	0f 84 9a 00 00 00    	je     80103ca5 <fork+0xe5>
  np->sz = curproc->sz;
80103c0b:	8b 03                	mov    (%ebx),%eax
80103c0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103c10:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103c12:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103c15:	89 c8                	mov    %ecx,%eax
80103c17:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103c1a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103c1f:	8b 73 18             	mov    0x18(%ebx),%esi
80103c22:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103c24:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103c26:	8b 40 18             	mov    0x18(%eax),%eax
80103c29:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103c30:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c34:	85 c0                	test   %eax,%eax
80103c36:	74 13                	je     80103c4b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c38:	83 ec 0c             	sub    $0xc,%esp
80103c3b:	50                   	push   %eax
80103c3c:	e8 af d2 ff ff       	call   80100ef0 <filedup>
80103c41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c44:	83 c4 10             	add    $0x10,%esp
80103c47:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103c4b:	83 c6 01             	add    $0x1,%esi
80103c4e:	83 fe 10             	cmp    $0x10,%esi
80103c51:	75 dd                	jne    80103c30 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103c53:	83 ec 0c             	sub    $0xc,%esp
80103c56:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c59:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103c5c:	e8 5f db ff ff       	call   801017c0 <idup>
80103c61:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c64:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c67:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c6a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c6d:	6a 10                	push   $0x10
80103c6f:	53                   	push   %ebx
80103c70:	50                   	push   %eax
80103c71:	e8 4a 0c 00 00       	call   801048c0 <safestrcpy>
  pid = np->pid;
80103c76:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c79:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103c80:	e8 fb 08 00 00       	call   80104580 <acquire>
  np->state = RUNNABLE;
80103c85:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c8c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103c93:	e8 28 0a 00 00       	call   801046c0 <release>
  return pid;
80103c98:	83 c4 10             	add    $0x10,%esp
}
80103c9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c9e:	89 d8                	mov    %ebx,%eax
80103ca0:	5b                   	pop    %ebx
80103ca1:	5e                   	pop    %esi
80103ca2:	5f                   	pop    %edi
80103ca3:	5d                   	pop    %ebp
80103ca4:	c3                   	ret
    kfree(np->kstack);
80103ca5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103ca8:	83 ec 0c             	sub    $0xc,%esp
80103cab:	ff 73 08             	push   0x8(%ebx)
80103cae:	e8 8d e8 ff ff       	call   80102540 <kfree>
    np->kstack = 0;
80103cb3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103cba:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103cbd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103cc4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103cc9:	eb d0                	jmp    80103c9b <fork+0xdb>
80103ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ccf:	90                   	nop

80103cd0 <scheduler>:
{
80103cd0:	55                   	push   %ebp
80103cd1:	89 e5                	mov    %esp,%ebp
80103cd3:	57                   	push   %edi
80103cd4:	56                   	push   %esi
80103cd5:	53                   	push   %ebx
80103cd6:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103cd9:	e8 c2 fc ff ff       	call   801039a0 <mycpu>
  c->proc = 0;
80103cde:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103ce5:	00 00 00 
  struct cpu *c = mycpu();
80103ce8:	89 c6                	mov    %eax,%esi
  int ran = 0; // CS 350/550: to solve the 100%-CPU-utilization-when-idling problem
80103cea:	8d 78 04             	lea    0x4(%eax),%edi
80103ced:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103cf0:	fb                   	sti
    acquire(&ptable.lock);
80103cf1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cf4:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
    acquire(&ptable.lock);
80103cf9:	68 20 1d 11 80       	push   $0x80111d20
80103cfe:	e8 7d 08 00 00       	call   80104580 <acquire>
80103d03:	83 c4 10             	add    $0x10,%esp
    ran = 0;
80103d06:	31 c0                	xor    %eax,%eax
80103d08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d0f:	90                   	nop
      if(p->state != RUNNABLE)
80103d10:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103d14:	75 38                	jne    80103d4e <scheduler+0x7e>
      switchuvm(p);
80103d16:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103d19:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103d1f:	53                   	push   %ebx
80103d20:	e8 6b 2d 00 00       	call   80106a90 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103d25:	58                   	pop    %eax
80103d26:	5a                   	pop    %edx
80103d27:	ff 73 1c             	push   0x1c(%ebx)
80103d2a:	57                   	push   %edi
      p->state = RUNNING;
80103d2b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103d32:	e8 e4 0b 00 00       	call   8010491b <swtch>
      switchkvm();
80103d37:	e8 44 2d 00 00       	call   80106a80 <switchkvm>
      c->proc = 0;
80103d3c:	83 c4 10             	add    $0x10,%esp
      ran = 1;
80103d3f:	b8 01 00 00 00       	mov    $0x1,%eax
      c->proc = 0;
80103d44:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103d4b:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d4e:	83 c3 7c             	add    $0x7c,%ebx
80103d51:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103d57:	75 b7                	jne    80103d10 <scheduler+0x40>
    release(&ptable.lock);
80103d59:	83 ec 0c             	sub    $0xc,%esp
80103d5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d5f:	68 20 1d 11 80       	push   $0x80111d20
80103d64:	e8 57 09 00 00       	call   801046c0 <release>
    if (ran == 0){
80103d69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d6c:	83 c4 10             	add    $0x10,%esp
80103d6f:	85 c0                	test   %eax,%eax
80103d71:	0f 85 79 ff ff ff    	jne    80103cf0 <scheduler+0x20>

// CS 350/550: to solve the 100%-CPU-utilization-when-idling problem - "hlt" instruction puts CPU to sleep
static inline void
halt()
{
    asm volatile("hlt" : : :"memory");
80103d77:	f4                   	hlt
}
80103d78:	e9 73 ff ff ff       	jmp    80103cf0 <scheduler+0x20>
80103d7d:	8d 76 00             	lea    0x0(%esi),%esi

80103d80 <sched>:
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	56                   	push   %esi
80103d84:	53                   	push   %ebx
  pushcli();
80103d85:	e8 a6 07 00 00       	call   80104530 <pushcli>
  c = mycpu();
80103d8a:	e8 11 fc ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103d8f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d95:	e8 c6 08 00 00       	call   80104660 <popcli>
  if(!holding(&ptable.lock))
80103d9a:	83 ec 0c             	sub    $0xc,%esp
80103d9d:	68 20 1d 11 80       	push   $0x80111d20
80103da2:	e8 49 07 00 00       	call   801044f0 <holding>
80103da7:	83 c4 10             	add    $0x10,%esp
80103daa:	85 c0                	test   %eax,%eax
80103dac:	74 4f                	je     80103dfd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103dae:	e8 ed fb ff ff       	call   801039a0 <mycpu>
80103db3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103dba:	75 68                	jne    80103e24 <sched+0xa4>
  if(p->state == RUNNING)
80103dbc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103dc0:	74 55                	je     80103e17 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103dc2:	9c                   	pushf
80103dc3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103dc4:	f6 c4 02             	test   $0x2,%ah
80103dc7:	75 41                	jne    80103e0a <sched+0x8a>
  intena = mycpu()->intena;
80103dc9:	e8 d2 fb ff ff       	call   801039a0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103dce:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103dd1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103dd7:	e8 c4 fb ff ff       	call   801039a0 <mycpu>
80103ddc:	83 ec 08             	sub    $0x8,%esp
80103ddf:	ff 70 04             	push   0x4(%eax)
80103de2:	53                   	push   %ebx
80103de3:	e8 33 0b 00 00       	call   8010491b <swtch>
  mycpu()->intena = intena;
80103de8:	e8 b3 fb ff ff       	call   801039a0 <mycpu>
}
80103ded:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103df0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103df6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103df9:	5b                   	pop    %ebx
80103dfa:	5e                   	pop    %esi
80103dfb:	5d                   	pop    %ebp
80103dfc:	c3                   	ret
    panic("sched ptable.lock");
80103dfd:	83 ec 0c             	sub    $0xc,%esp
80103e00:	68 93 77 10 80       	push   $0x80107793
80103e05:	e8 76 c5 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103e0a:	83 ec 0c             	sub    $0xc,%esp
80103e0d:	68 bf 77 10 80       	push   $0x801077bf
80103e12:	e8 69 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103e17:	83 ec 0c             	sub    $0xc,%esp
80103e1a:	68 b1 77 10 80       	push   $0x801077b1
80103e1f:	e8 5c c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103e24:	83 ec 0c             	sub    $0xc,%esp
80103e27:	68 a5 77 10 80       	push   $0x801077a5
80103e2c:	e8 4f c5 ff ff       	call   80100380 <panic>
80103e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e3f:	90                   	nop

80103e40 <exit>:
{
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	57                   	push   %edi
80103e44:	56                   	push   %esi
80103e45:	53                   	push   %ebx
80103e46:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103e49:	e8 d2 fb ff ff       	call   80103a20 <myproc>
  if(curproc == initproc)
80103e4e:	39 05 54 3c 11 80    	cmp    %eax,0x80113c54
80103e54:	0f 84 fd 00 00 00    	je     80103f57 <exit+0x117>
80103e5a:	89 c3                	mov    %eax,%ebx
80103e5c:	8d 70 28             	lea    0x28(%eax),%esi
80103e5f:	8d 78 68             	lea    0x68(%eax),%edi
80103e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103e68:	8b 06                	mov    (%esi),%eax
80103e6a:	85 c0                	test   %eax,%eax
80103e6c:	74 12                	je     80103e80 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103e6e:	83 ec 0c             	sub    $0xc,%esp
80103e71:	50                   	push   %eax
80103e72:	e8 c9 d0 ff ff       	call   80100f40 <fileclose>
      curproc->ofile[fd] = 0;
80103e77:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103e7d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e80:	83 c6 04             	add    $0x4,%esi
80103e83:	39 f7                	cmp    %esi,%edi
80103e85:	75 e1                	jne    80103e68 <exit+0x28>
  begin_op();
80103e87:	e8 64 ef ff ff       	call   80102df0 <begin_op>
  iput(curproc->cwd);
80103e8c:	83 ec 0c             	sub    $0xc,%esp
80103e8f:	ff 73 68             	push   0x68(%ebx)
80103e92:	e8 89 da ff ff       	call   80101920 <iput>
  end_op();
80103e97:	e8 c4 ef ff ff       	call   80102e60 <end_op>
  curproc->cwd = 0;
80103e9c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103ea3:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103eaa:	e8 d1 06 00 00       	call   80104580 <acquire>
  wakeup1(curproc->parent);
80103eaf:	8b 53 14             	mov    0x14(%ebx),%edx
80103eb2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103eb5:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103eba:	eb 0e                	jmp    80103eca <exit+0x8a>
80103ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ec0:	83 c0 7c             	add    $0x7c,%eax
80103ec3:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103ec8:	74 1c                	je     80103ee6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103eca:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ece:	75 f0                	jne    80103ec0 <exit+0x80>
80103ed0:	3b 50 20             	cmp    0x20(%eax),%edx
80103ed3:	75 eb                	jne    80103ec0 <exit+0x80>
      p->state = RUNNABLE;
80103ed5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103edc:	83 c0 7c             	add    $0x7c,%eax
80103edf:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103ee4:	75 e4                	jne    80103eca <exit+0x8a>
      p->parent = initproc;
80103ee6:	8b 0d 54 3c 11 80    	mov    0x80113c54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eec:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80103ef1:	eb 10                	jmp    80103f03 <exit+0xc3>
80103ef3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ef7:	90                   	nop
80103ef8:	83 c2 7c             	add    $0x7c,%edx
80103efb:	81 fa 54 3c 11 80    	cmp    $0x80113c54,%edx
80103f01:	74 3b                	je     80103f3e <exit+0xfe>
    if(p->parent == curproc){
80103f03:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103f06:	75 f0                	jne    80103ef8 <exit+0xb8>
      if(p->state == ZOMBIE)
80103f08:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103f0c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103f0f:	75 e7                	jne    80103ef8 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f11:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103f16:	eb 12                	jmp    80103f2a <exit+0xea>
80103f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f1f:	90                   	nop
80103f20:	83 c0 7c             	add    $0x7c,%eax
80103f23:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103f28:	74 ce                	je     80103ef8 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103f2a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f2e:	75 f0                	jne    80103f20 <exit+0xe0>
80103f30:	3b 48 20             	cmp    0x20(%eax),%ecx
80103f33:	75 eb                	jne    80103f20 <exit+0xe0>
      p->state = RUNNABLE;
80103f35:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f3c:	eb e2                	jmp    80103f20 <exit+0xe0>
  curproc->state = ZOMBIE;
80103f3e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103f45:	e8 36 fe ff ff       	call   80103d80 <sched>
  panic("zombie exit");
80103f4a:	83 ec 0c             	sub    $0xc,%esp
80103f4d:	68 e0 77 10 80       	push   $0x801077e0
80103f52:	e8 29 c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103f57:	83 ec 0c             	sub    $0xc,%esp
80103f5a:	68 d3 77 10 80       	push   $0x801077d3
80103f5f:	e8 1c c4 ff ff       	call   80100380 <panic>
80103f64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f6f:	90                   	nop

80103f70 <wait>:
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	56                   	push   %esi
80103f74:	53                   	push   %ebx
  pushcli();
80103f75:	e8 b6 05 00 00       	call   80104530 <pushcli>
  c = mycpu();
80103f7a:	e8 21 fa ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103f7f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f85:	e8 d6 06 00 00       	call   80104660 <popcli>
  acquire(&ptable.lock);
80103f8a:	83 ec 0c             	sub    $0xc,%esp
80103f8d:	68 20 1d 11 80       	push   $0x80111d20
80103f92:	e8 e9 05 00 00       	call   80104580 <acquire>
80103f97:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f9a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f9c:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103fa1:	eb 10                	jmp    80103fb3 <wait+0x43>
80103fa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fa7:	90                   	nop
80103fa8:	83 c3 7c             	add    $0x7c,%ebx
80103fab:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103fb1:	74 1b                	je     80103fce <wait+0x5e>
      if(p->parent != curproc)
80103fb3:	39 73 14             	cmp    %esi,0x14(%ebx)
80103fb6:	75 f0                	jne    80103fa8 <wait+0x38>
      if(p->state == ZOMBIE){
80103fb8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103fbc:	74 62                	je     80104020 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fbe:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103fc1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fc6:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103fcc:	75 e5                	jne    80103fb3 <wait+0x43>
    if(!havekids || curproc->killed){
80103fce:	85 c0                	test   %eax,%eax
80103fd0:	0f 84 a0 00 00 00    	je     80104076 <wait+0x106>
80103fd6:	8b 46 24             	mov    0x24(%esi),%eax
80103fd9:	85 c0                	test   %eax,%eax
80103fdb:	0f 85 95 00 00 00    	jne    80104076 <wait+0x106>
  pushcli();
80103fe1:	e8 4a 05 00 00       	call   80104530 <pushcli>
  c = mycpu();
80103fe6:	e8 b5 f9 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103feb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ff1:	e8 6a 06 00 00       	call   80104660 <popcli>
  if(p == 0)
80103ff6:	85 db                	test   %ebx,%ebx
80103ff8:	0f 84 8f 00 00 00    	je     8010408d <wait+0x11d>
  p->chan = chan;
80103ffe:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104001:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104008:	e8 73 fd ff ff       	call   80103d80 <sched>
  p->chan = 0;
8010400d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104014:	eb 84                	jmp    80103f9a <wait+0x2a>
80104016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010401d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104020:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104023:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104026:	ff 73 08             	push   0x8(%ebx)
80104029:	e8 12 e5 ff ff       	call   80102540 <kfree>
        p->kstack = 0;
8010402e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104035:	5a                   	pop    %edx
80104036:	ff 73 04             	push   0x4(%ebx)
80104039:	e8 02 2e 00 00       	call   80106e40 <freevm>
        p->pid = 0;
8010403e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104045:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010404c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104050:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104057:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010405e:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104065:	e8 56 06 00 00       	call   801046c0 <release>
        return pid;
8010406a:	83 c4 10             	add    $0x10,%esp
}
8010406d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104070:	89 f0                	mov    %esi,%eax
80104072:	5b                   	pop    %ebx
80104073:	5e                   	pop    %esi
80104074:	5d                   	pop    %ebp
80104075:	c3                   	ret
      release(&ptable.lock);
80104076:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104079:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010407e:	68 20 1d 11 80       	push   $0x80111d20
80104083:	e8 38 06 00 00       	call   801046c0 <release>
      return -1;
80104088:	83 c4 10             	add    $0x10,%esp
8010408b:	eb e0                	jmp    8010406d <wait+0xfd>
    panic("sleep");
8010408d:	83 ec 0c             	sub    $0xc,%esp
80104090:	68 ec 77 10 80       	push   $0x801077ec
80104095:	e8 e6 c2 ff ff       	call   80100380 <panic>
8010409a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040a0 <yield>:
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	53                   	push   %ebx
801040a4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801040a7:	68 20 1d 11 80       	push   $0x80111d20
801040ac:	e8 cf 04 00 00       	call   80104580 <acquire>
  pushcli();
801040b1:	e8 7a 04 00 00       	call   80104530 <pushcli>
  c = mycpu();
801040b6:	e8 e5 f8 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
801040bb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040c1:	e8 9a 05 00 00       	call   80104660 <popcli>
  myproc()->state = RUNNABLE;
801040c6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801040cd:	e8 ae fc ff ff       	call   80103d80 <sched>
  release(&ptable.lock);
801040d2:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801040d9:	e8 e2 05 00 00       	call   801046c0 <release>
}
801040de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040e1:	83 c4 10             	add    $0x10,%esp
801040e4:	c9                   	leave
801040e5:	c3                   	ret
801040e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040ed:	8d 76 00             	lea    0x0(%esi),%esi

801040f0 <sleep>:
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	57                   	push   %edi
801040f4:	56                   	push   %esi
801040f5:	53                   	push   %ebx
801040f6:	83 ec 0c             	sub    $0xc,%esp
801040f9:	8b 7d 08             	mov    0x8(%ebp),%edi
801040fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801040ff:	e8 2c 04 00 00       	call   80104530 <pushcli>
  c = mycpu();
80104104:	e8 97 f8 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80104109:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010410f:	e8 4c 05 00 00       	call   80104660 <popcli>
  if(p == 0)
80104114:	85 db                	test   %ebx,%ebx
80104116:	0f 84 87 00 00 00    	je     801041a3 <sleep+0xb3>
  if(lk == 0)
8010411c:	85 f6                	test   %esi,%esi
8010411e:	74 76                	je     80104196 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104120:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
80104126:	74 50                	je     80104178 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104128:	83 ec 0c             	sub    $0xc,%esp
8010412b:	68 20 1d 11 80       	push   $0x80111d20
80104130:	e8 4b 04 00 00       	call   80104580 <acquire>
    release(lk);
80104135:	89 34 24             	mov    %esi,(%esp)
80104138:	e8 83 05 00 00       	call   801046c0 <release>
  p->chan = chan;
8010413d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104140:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104147:	e8 34 fc ff ff       	call   80103d80 <sched>
  p->chan = 0;
8010414c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104153:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
8010415a:	e8 61 05 00 00       	call   801046c0 <release>
    acquire(lk);
8010415f:	89 75 08             	mov    %esi,0x8(%ebp)
80104162:	83 c4 10             	add    $0x10,%esp
}
80104165:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104168:	5b                   	pop    %ebx
80104169:	5e                   	pop    %esi
8010416a:	5f                   	pop    %edi
8010416b:	5d                   	pop    %ebp
    acquire(lk);
8010416c:	e9 0f 04 00 00       	jmp    80104580 <acquire>
80104171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104178:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010417b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104182:	e8 f9 fb ff ff       	call   80103d80 <sched>
  p->chan = 0;
80104187:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010418e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104191:	5b                   	pop    %ebx
80104192:	5e                   	pop    %esi
80104193:	5f                   	pop    %edi
80104194:	5d                   	pop    %ebp
80104195:	c3                   	ret
    panic("sleep without lk");
80104196:	83 ec 0c             	sub    $0xc,%esp
80104199:	68 f2 77 10 80       	push   $0x801077f2
8010419e:	e8 dd c1 ff ff       	call   80100380 <panic>
    panic("sleep");
801041a3:	83 ec 0c             	sub    $0xc,%esp
801041a6:	68 ec 77 10 80       	push   $0x801077ec
801041ab:	e8 d0 c1 ff ff       	call   80100380 <panic>

801041b0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	53                   	push   %ebx
801041b4:	83 ec 10             	sub    $0x10,%esp
801041b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801041ba:	68 20 1d 11 80       	push   $0x80111d20
801041bf:	e8 bc 03 00 00       	call   80104580 <acquire>
801041c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041c7:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
801041cc:	eb 0c                	jmp    801041da <wakeup+0x2a>
801041ce:	66 90                	xchg   %ax,%ax
801041d0:	83 c0 7c             	add    $0x7c,%eax
801041d3:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
801041d8:	74 1c                	je     801041f6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801041da:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041de:	75 f0                	jne    801041d0 <wakeup+0x20>
801041e0:	3b 58 20             	cmp    0x20(%eax),%ebx
801041e3:	75 eb                	jne    801041d0 <wakeup+0x20>
      p->state = RUNNABLE;
801041e5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041ec:	83 c0 7c             	add    $0x7c,%eax
801041ef:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
801041f4:	75 e4                	jne    801041da <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801041f6:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
801041fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104200:	c9                   	leave
  release(&ptable.lock);
80104201:	e9 ba 04 00 00       	jmp    801046c0 <release>
80104206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010420d:	8d 76 00             	lea    0x0(%esi),%esi

80104210 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	53                   	push   %ebx
80104214:	83 ec 10             	sub    $0x10,%esp
80104217:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010421a:	68 20 1d 11 80       	push   $0x80111d20
8010421f:	e8 5c 03 00 00       	call   80104580 <acquire>
80104224:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104227:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010422c:	eb 0c                	jmp    8010423a <kill+0x2a>
8010422e:	66 90                	xchg   %ax,%ax
80104230:	83 c0 7c             	add    $0x7c,%eax
80104233:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104238:	74 36                	je     80104270 <kill+0x60>
    if(p->pid == pid){
8010423a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010423d:	75 f1                	jne    80104230 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010423f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104243:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010424a:	75 07                	jne    80104253 <kill+0x43>
        p->state = RUNNABLE;
8010424c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104253:	83 ec 0c             	sub    $0xc,%esp
80104256:	68 20 1d 11 80       	push   $0x80111d20
8010425b:	e8 60 04 00 00       	call   801046c0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104260:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104263:	83 c4 10             	add    $0x10,%esp
80104266:	31 c0                	xor    %eax,%eax
}
80104268:	c9                   	leave
80104269:	c3                   	ret
8010426a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104270:	83 ec 0c             	sub    $0xc,%esp
80104273:	68 20 1d 11 80       	push   $0x80111d20
80104278:	e8 43 04 00 00       	call   801046c0 <release>
}
8010427d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104280:	83 c4 10             	add    $0x10,%esp
80104283:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104288:	c9                   	leave
80104289:	c3                   	ret
8010428a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104290 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	57                   	push   %edi
80104294:	56                   	push   %esi
80104295:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104298:	53                   	push   %ebx
80104299:	bb c0 1d 11 80       	mov    $0x80111dc0,%ebx
8010429e:	83 ec 3c             	sub    $0x3c,%esp
801042a1:	eb 24                	jmp    801042c7 <procdump+0x37>
801042a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042a7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801042a8:	83 ec 0c             	sub    $0xc,%esp
801042ab:	68 77 7b 10 80       	push   $0x80107b77
801042b0:	e8 fb c3 ff ff       	call   801006b0 <cprintf>
801042b5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042b8:	83 c3 7c             	add    $0x7c,%ebx
801042bb:	81 fb c0 3c 11 80    	cmp    $0x80113cc0,%ebx
801042c1:	0f 84 81 00 00 00    	je     80104348 <procdump+0xb8>
    if(p->state == UNUSED)
801042c7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801042ca:	85 c0                	test   %eax,%eax
801042cc:	74 ea                	je     801042b8 <procdump+0x28>
      state = "???";
801042ce:	ba 03 78 10 80       	mov    $0x80107803,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801042d3:	83 f8 05             	cmp    $0x5,%eax
801042d6:	77 11                	ja     801042e9 <procdump+0x59>
801042d8:	8b 14 85 64 78 10 80 	mov    -0x7fef879c(,%eax,4),%edx
      state = "???";
801042df:	b8 03 78 10 80       	mov    $0x80107803,%eax
801042e4:	85 d2                	test   %edx,%edx
801042e6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801042e9:	53                   	push   %ebx
801042ea:	52                   	push   %edx
801042eb:	ff 73 a4             	push   -0x5c(%ebx)
801042ee:	68 07 78 10 80       	push   $0x80107807
801042f3:	e8 b8 c3 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
801042f8:	83 c4 10             	add    $0x10,%esp
801042fb:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801042ff:	75 a7                	jne    801042a8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104301:	83 ec 08             	sub    $0x8,%esp
80104304:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104307:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010430a:	50                   	push   %eax
8010430b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010430e:	8b 40 0c             	mov    0xc(%eax),%eax
80104311:	83 c0 08             	add    $0x8,%eax
80104314:	50                   	push   %eax
80104315:	e8 66 01 00 00       	call   80104480 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010431a:	83 c4 10             	add    $0x10,%esp
8010431d:	8d 76 00             	lea    0x0(%esi),%esi
80104320:	8b 17                	mov    (%edi),%edx
80104322:	85 d2                	test   %edx,%edx
80104324:	74 82                	je     801042a8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104326:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104329:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010432c:	52                   	push   %edx
8010432d:	68 41 72 10 80       	push   $0x80107241
80104332:	e8 79 c3 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104337:	83 c4 10             	add    $0x10,%esp
8010433a:	39 f7                	cmp    %esi,%edi
8010433c:	75 e2                	jne    80104320 <procdump+0x90>
8010433e:	e9 65 ff ff ff       	jmp    801042a8 <procdump+0x18>
80104343:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104347:	90                   	nop
  }
}
80104348:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010434b:	5b                   	pop    %ebx
8010434c:	5e                   	pop    %esi
8010434d:	5f                   	pop    %edi
8010434e:	5d                   	pop    %ebp
8010434f:	c3                   	ret

80104350 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	53                   	push   %ebx
80104354:	83 ec 0c             	sub    $0xc,%esp
80104357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010435a:	68 7c 78 10 80       	push   $0x8010787c
8010435f:	8d 43 04             	lea    0x4(%ebx),%eax
80104362:	50                   	push   %eax
80104363:	e8 f8 00 00 00       	call   80104460 <initlock>
  lk->name = name;
80104368:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010436b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104371:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104374:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010437b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010437e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104381:	c9                   	leave
80104382:	c3                   	ret
80104383:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010438a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104390 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	56                   	push   %esi
80104394:	53                   	push   %ebx
80104395:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104398:	8d 73 04             	lea    0x4(%ebx),%esi
8010439b:	83 ec 0c             	sub    $0xc,%esp
8010439e:	56                   	push   %esi
8010439f:	e8 dc 01 00 00       	call   80104580 <acquire>
  while (lk->locked) {
801043a4:	8b 13                	mov    (%ebx),%edx
801043a6:	83 c4 10             	add    $0x10,%esp
801043a9:	85 d2                	test   %edx,%edx
801043ab:	74 16                	je     801043c3 <acquiresleep+0x33>
801043ad:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801043b0:	83 ec 08             	sub    $0x8,%esp
801043b3:	56                   	push   %esi
801043b4:	53                   	push   %ebx
801043b5:	e8 36 fd ff ff       	call   801040f0 <sleep>
  while (lk->locked) {
801043ba:	8b 03                	mov    (%ebx),%eax
801043bc:	83 c4 10             	add    $0x10,%esp
801043bf:	85 c0                	test   %eax,%eax
801043c1:	75 ed                	jne    801043b0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801043c3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801043c9:	e8 52 f6 ff ff       	call   80103a20 <myproc>
801043ce:	8b 40 10             	mov    0x10(%eax),%eax
801043d1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801043d4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801043d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043da:	5b                   	pop    %ebx
801043db:	5e                   	pop    %esi
801043dc:	5d                   	pop    %ebp
  release(&lk->lk);
801043dd:	e9 de 02 00 00       	jmp    801046c0 <release>
801043e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801043f0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	56                   	push   %esi
801043f4:	53                   	push   %ebx
801043f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801043f8:	8d 73 04             	lea    0x4(%ebx),%esi
801043fb:	83 ec 0c             	sub    $0xc,%esp
801043fe:	56                   	push   %esi
801043ff:	e8 7c 01 00 00       	call   80104580 <acquire>
  lk->locked = 0;
80104404:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010440a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104411:	89 1c 24             	mov    %ebx,(%esp)
80104414:	e8 97 fd ff ff       	call   801041b0 <wakeup>
  release(&lk->lk);
80104419:	89 75 08             	mov    %esi,0x8(%ebp)
8010441c:	83 c4 10             	add    $0x10,%esp
}
8010441f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104422:	5b                   	pop    %ebx
80104423:	5e                   	pop    %esi
80104424:	5d                   	pop    %ebp
  release(&lk->lk);
80104425:	e9 96 02 00 00       	jmp    801046c0 <release>
8010442a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104430 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	56                   	push   %esi
80104434:	53                   	push   %ebx
80104435:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104438:	8d 5e 04             	lea    0x4(%esi),%ebx
8010443b:	83 ec 0c             	sub    $0xc,%esp
8010443e:	53                   	push   %ebx
8010443f:	e8 3c 01 00 00       	call   80104580 <acquire>
  r = lk->locked;
80104444:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104446:	89 1c 24             	mov    %ebx,(%esp)
80104449:	e8 72 02 00 00       	call   801046c0 <release>
  return r;
}
8010444e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104451:	89 f0                	mov    %esi,%eax
80104453:	5b                   	pop    %ebx
80104454:	5e                   	pop    %esi
80104455:	5d                   	pop    %ebp
80104456:	c3                   	ret
80104457:	66 90                	xchg   %ax,%ax
80104459:	66 90                	xchg   %ax,%ax
8010445b:	66 90                	xchg   %ax,%ax
8010445d:	66 90                	xchg   %ax,%ax
8010445f:	90                   	nop

80104460 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104466:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104469:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010446f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104472:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104479:	5d                   	pop    %ebp
8010447a:	c3                   	ret
8010447b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010447f:	90                   	nop

80104480 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	53                   	push   %ebx
80104484:	8b 45 08             	mov    0x8(%ebp),%eax
80104487:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010448a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010448d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80104492:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80104497:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010449c:	76 10                	jbe    801044ae <getcallerpcs+0x2e>
8010449e:	eb 28                	jmp    801044c8 <getcallerpcs+0x48>
801044a0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801044a6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801044ac:	77 1a                	ja     801044c8 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
801044ae:	8b 5a 04             	mov    0x4(%edx),%ebx
801044b1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801044b4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801044b7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801044b9:	83 f8 0a             	cmp    $0xa,%eax
801044bc:	75 e2                	jne    801044a0 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801044be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044c1:	c9                   	leave
801044c2:	c3                   	ret
801044c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044c7:	90                   	nop
801044c8:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801044cb:	8d 51 28             	lea    0x28(%ecx),%edx
801044ce:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801044d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801044d6:	83 c0 04             	add    $0x4,%eax
801044d9:	39 d0                	cmp    %edx,%eax
801044db:	75 f3                	jne    801044d0 <getcallerpcs+0x50>
}
801044dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044e0:	c9                   	leave
801044e1:	c3                   	ret
801044e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044f0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	53                   	push   %ebx
801044f4:	83 ec 04             	sub    $0x4,%esp
801044f7:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801044fa:	8b 02                	mov    (%edx),%eax
801044fc:	85 c0                	test   %eax,%eax
801044fe:	75 10                	jne    80104510 <holding+0x20>
}
80104500:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104503:	31 c0                	xor    %eax,%eax
80104505:	c9                   	leave
80104506:	c3                   	ret
80104507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010450e:	66 90                	xchg   %ax,%ax
  return lock->locked && lock->cpu == mycpu();
80104510:	8b 5a 08             	mov    0x8(%edx),%ebx
80104513:	e8 88 f4 ff ff       	call   801039a0 <mycpu>
80104518:	39 c3                	cmp    %eax,%ebx
}
8010451a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010451d:	c9                   	leave
  return lock->locked && lock->cpu == mycpu();
8010451e:	0f 94 c0             	sete   %al
80104521:	0f b6 c0             	movzbl %al,%eax
}
80104524:	c3                   	ret
80104525:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010452c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104530 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	53                   	push   %ebx
80104534:	83 ec 04             	sub    $0x4,%esp
80104537:	9c                   	pushf
80104538:	5b                   	pop    %ebx
  asm volatile("cli");
80104539:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010453a:	e8 61 f4 ff ff       	call   801039a0 <mycpu>
8010453f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104545:	85 c0                	test   %eax,%eax
80104547:	74 17                	je     80104560 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104549:	e8 52 f4 ff ff       	call   801039a0 <mycpu>
8010454e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104555:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104558:	c9                   	leave
80104559:	c3                   	ret
8010455a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104560:	e8 3b f4 ff ff       	call   801039a0 <mycpu>
80104565:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010456b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104571:	eb d6                	jmp    80104549 <pushcli+0x19>
80104573:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010457a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104580 <acquire>:
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	53                   	push   %ebx
80104584:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104587:	e8 a4 ff ff ff       	call   80104530 <pushcli>
  if(holding(lk))
8010458c:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010458f:	8b 02                	mov    (%edx),%eax
80104591:	85 c0                	test   %eax,%eax
80104593:	0f 85 9f 00 00 00    	jne    80104638 <acquire+0xb8>
  asm volatile("lock; xchgl %0, %1" :
80104599:	b8 01 00 00 00       	mov    $0x1,%eax
8010459e:	f0 87 02             	lock xchg %eax,(%edx)
801045a1:	b9 01 00 00 00       	mov    $0x1,%ecx
  while(xchg(&lk->locked, 1) != 0)
801045a6:	85 c0                	test   %eax,%eax
801045a8:	74 12                	je     801045bc <acquire+0x3c>
801045aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045b0:	8b 55 08             	mov    0x8(%ebp),%edx
801045b3:	89 c8                	mov    %ecx,%eax
801045b5:	f0 87 02             	lock xchg %eax,(%edx)
801045b8:	85 c0                	test   %eax,%eax
801045ba:	75 f4                	jne    801045b0 <acquire+0x30>
  __sync_synchronize();
801045bc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801045c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801045c4:	e8 d7 f3 ff ff       	call   801039a0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801045c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
801045cc:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
801045ce:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045d1:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
801045d7:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
801045dc:	77 32                	ja     80104610 <acquire+0x90>
  ebp = (uint*)v - 2;
801045de:	89 e8                	mov    %ebp,%eax
801045e0:	eb 14                	jmp    801045f6 <acquire+0x76>
801045e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045e8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801045ee:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801045f4:	77 1a                	ja     80104610 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
801045f6:	8b 58 04             	mov    0x4(%eax),%ebx
801045f9:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801045fd:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104600:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104602:	83 fa 0a             	cmp    $0xa,%edx
80104605:	75 e1                	jne    801045e8 <acquire+0x68>
}
80104607:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010460a:	c9                   	leave
8010460b:	c3                   	ret
8010460c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104610:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80104614:	8d 51 34             	lea    0x34(%ecx),%edx
80104617:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010461e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104620:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104626:	83 c0 04             	add    $0x4,%eax
80104629:	39 d0                	cmp    %edx,%eax
8010462b:	75 f3                	jne    80104620 <acquire+0xa0>
}
8010462d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104630:	c9                   	leave
80104631:	c3                   	ret
80104632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return lock->locked && lock->cpu == mycpu();
80104638:	8b 5a 08             	mov    0x8(%edx),%ebx
8010463b:	e8 60 f3 ff ff       	call   801039a0 <mycpu>
80104640:	39 c3                	cmp    %eax,%ebx
80104642:	74 0c                	je     80104650 <acquire+0xd0>
  while(xchg(&lk->locked, 1) != 0)
80104644:	8b 55 08             	mov    0x8(%ebp),%edx
80104647:	e9 4d ff ff ff       	jmp    80104599 <acquire+0x19>
8010464c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("acquire");
80104650:	83 ec 0c             	sub    $0xc,%esp
80104653:	68 87 78 10 80       	push   $0x80107887
80104658:	e8 23 bd ff ff       	call   80100380 <panic>
8010465d:	8d 76 00             	lea    0x0(%esi),%esi

80104660 <popcli>:

void
popcli(void)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104666:	9c                   	pushf
80104667:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104668:	f6 c4 02             	test   $0x2,%ah
8010466b:	75 35                	jne    801046a2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010466d:	e8 2e f3 ff ff       	call   801039a0 <mycpu>
80104672:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104679:	78 34                	js     801046af <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010467b:	e8 20 f3 ff ff       	call   801039a0 <mycpu>
80104680:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104686:	85 d2                	test   %edx,%edx
80104688:	74 06                	je     80104690 <popcli+0x30>
    sti();
}
8010468a:	c9                   	leave
8010468b:	c3                   	ret
8010468c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104690:	e8 0b f3 ff ff       	call   801039a0 <mycpu>
80104695:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010469b:	85 c0                	test   %eax,%eax
8010469d:	74 eb                	je     8010468a <popcli+0x2a>
  asm volatile("sti");
8010469f:	fb                   	sti
}
801046a0:	c9                   	leave
801046a1:	c3                   	ret
    panic("popcli - interruptible");
801046a2:	83 ec 0c             	sub    $0xc,%esp
801046a5:	68 8f 78 10 80       	push   $0x8010788f
801046aa:	e8 d1 bc ff ff       	call   80100380 <panic>
    panic("popcli");
801046af:	83 ec 0c             	sub    $0xc,%esp
801046b2:	68 a6 78 10 80       	push   $0x801078a6
801046b7:	e8 c4 bc ff ff       	call   80100380 <panic>
801046bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046c0 <release>:
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	56                   	push   %esi
801046c4:	53                   	push   %ebx
801046c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801046c8:	8b 03                	mov    (%ebx),%eax
801046ca:	85 c0                	test   %eax,%eax
801046cc:	75 12                	jne    801046e0 <release+0x20>
    panic("release");
801046ce:	83 ec 0c             	sub    $0xc,%esp
801046d1:	68 ad 78 10 80       	push   $0x801078ad
801046d6:	e8 a5 bc ff ff       	call   80100380 <panic>
801046db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046df:	90                   	nop
  return lock->locked && lock->cpu == mycpu();
801046e0:	8b 73 08             	mov    0x8(%ebx),%esi
801046e3:	e8 b8 f2 ff ff       	call   801039a0 <mycpu>
801046e8:	39 c6                	cmp    %eax,%esi
801046ea:	75 e2                	jne    801046ce <release+0xe>
  lk->pcs[0] = 0;
801046ec:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801046f3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801046fa:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801046ff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104705:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104708:	5b                   	pop    %ebx
80104709:	5e                   	pop    %esi
8010470a:	5d                   	pop    %ebp
  popcli();
8010470b:	e9 50 ff ff ff       	jmp    80104660 <popcli>

80104710 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	57                   	push   %edi
80104714:	8b 55 08             	mov    0x8(%ebp),%edx
80104717:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010471a:	89 d0                	mov    %edx,%eax
8010471c:	09 c8                	or     %ecx,%eax
8010471e:	a8 03                	test   $0x3,%al
80104720:	75 1e                	jne    80104740 <memset+0x30>
    c &= 0xFF;
80104722:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104726:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104729:	89 d7                	mov    %edx,%edi
8010472b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80104731:	fc                   	cld
80104732:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104734:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104737:	89 d0                	mov    %edx,%eax
80104739:	c9                   	leave
8010473a:	c3                   	ret
8010473b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010473f:	90                   	nop
  asm volatile("cld; rep stosb" :
80104740:	8b 45 0c             	mov    0xc(%ebp),%eax
80104743:	89 d7                	mov    %edx,%edi
80104745:	fc                   	cld
80104746:	f3 aa                	rep stos %al,%es:(%edi)
80104748:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010474b:	89 d0                	mov    %edx,%eax
8010474d:	c9                   	leave
8010474e:	c3                   	ret
8010474f:	90                   	nop

80104750 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	56                   	push   %esi
80104754:	53                   	push   %ebx
80104755:	8b 75 10             	mov    0x10(%ebp),%esi
80104758:	8b 55 08             	mov    0x8(%ebp),%edx
8010475b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010475e:	85 f6                	test   %esi,%esi
80104760:	74 2e                	je     80104790 <memcmp+0x40>
80104762:	01 c6                	add    %eax,%esi
80104764:	eb 14                	jmp    8010477a <memcmp+0x2a>
80104766:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010476d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104770:	83 c0 01             	add    $0x1,%eax
80104773:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104776:	39 f0                	cmp    %esi,%eax
80104778:	74 16                	je     80104790 <memcmp+0x40>
    if(*s1 != *s2)
8010477a:	0f b6 0a             	movzbl (%edx),%ecx
8010477d:	0f b6 18             	movzbl (%eax),%ebx
80104780:	38 d9                	cmp    %bl,%cl
80104782:	74 ec                	je     80104770 <memcmp+0x20>
      return *s1 - *s2;
80104784:	0f b6 c1             	movzbl %cl,%eax
80104787:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104789:	5b                   	pop    %ebx
8010478a:	5e                   	pop    %esi
8010478b:	5d                   	pop    %ebp
8010478c:	c3                   	ret
8010478d:	8d 76 00             	lea    0x0(%esi),%esi
80104790:	5b                   	pop    %ebx
  return 0;
80104791:	31 c0                	xor    %eax,%eax
}
80104793:	5e                   	pop    %esi
80104794:	5d                   	pop    %ebp
80104795:	c3                   	ret
80104796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010479d:	8d 76 00             	lea    0x0(%esi),%esi

801047a0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	57                   	push   %edi
801047a4:	56                   	push   %esi
801047a5:	8b 55 08             	mov    0x8(%ebp),%edx
801047a8:	8b 75 0c             	mov    0xc(%ebp),%esi
801047ab:	8b 45 10             	mov    0x10(%ebp),%eax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801047ae:	39 d6                	cmp    %edx,%esi
801047b0:	73 26                	jae    801047d8 <memmove+0x38>
801047b2:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
801047b5:	39 ca                	cmp    %ecx,%edx
801047b7:	73 1f                	jae    801047d8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801047b9:	85 c0                	test   %eax,%eax
801047bb:	74 0f                	je     801047cc <memmove+0x2c>
801047bd:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
801047c0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801047c4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801047c7:	83 e8 01             	sub    $0x1,%eax
801047ca:	73 f4                	jae    801047c0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801047cc:	5e                   	pop    %esi
801047cd:	89 d0                	mov    %edx,%eax
801047cf:	5f                   	pop    %edi
801047d0:	5d                   	pop    %ebp
801047d1:	c3                   	ret
801047d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801047d8:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
801047db:	89 d7                	mov    %edx,%edi
801047dd:	85 c0                	test   %eax,%eax
801047df:	74 eb                	je     801047cc <memmove+0x2c>
801047e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801047e8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801047e9:	39 ce                	cmp    %ecx,%esi
801047eb:	75 fb                	jne    801047e8 <memmove+0x48>
}
801047ed:	5e                   	pop    %esi
801047ee:	89 d0                	mov    %edx,%eax
801047f0:	5f                   	pop    %edi
801047f1:	5d                   	pop    %ebp
801047f2:	c3                   	ret
801047f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104800 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104800:	eb 9e                	jmp    801047a0 <memmove>
80104802:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104810 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	53                   	push   %ebx
80104814:	8b 55 10             	mov    0x10(%ebp),%edx
80104817:	8b 45 08             	mov    0x8(%ebp),%eax
8010481a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
8010481d:	85 d2                	test   %edx,%edx
8010481f:	75 16                	jne    80104837 <strncmp+0x27>
80104821:	eb 2d                	jmp    80104850 <strncmp+0x40>
80104823:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104827:	90                   	nop
80104828:	3a 19                	cmp    (%ecx),%bl
8010482a:	75 12                	jne    8010483e <strncmp+0x2e>
    n--, p++, q++;
8010482c:	83 c0 01             	add    $0x1,%eax
8010482f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104832:	83 ea 01             	sub    $0x1,%edx
80104835:	74 19                	je     80104850 <strncmp+0x40>
80104837:	0f b6 18             	movzbl (%eax),%ebx
8010483a:	84 db                	test   %bl,%bl
8010483c:	75 ea                	jne    80104828 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010483e:	0f b6 00             	movzbl (%eax),%eax
80104841:	0f b6 11             	movzbl (%ecx),%edx
}
80104844:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104847:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104848:	29 d0                	sub    %edx,%eax
}
8010484a:	c3                   	ret
8010484b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010484f:	90                   	nop
80104850:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104853:	31 c0                	xor    %eax,%eax
}
80104855:	c9                   	leave
80104856:	c3                   	ret
80104857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010485e:	66 90                	xchg   %ax,%ax

80104860 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	57                   	push   %edi
80104864:	56                   	push   %esi
80104865:	53                   	push   %ebx
80104866:	8b 75 08             	mov    0x8(%ebp),%esi
80104869:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010486c:	89 f0                	mov    %esi,%eax
8010486e:	eb 15                	jmp    80104885 <strncpy+0x25>
80104870:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104874:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104877:	83 c0 01             	add    $0x1,%eax
8010487a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
8010487e:	88 48 ff             	mov    %cl,-0x1(%eax)
80104881:	84 c9                	test   %cl,%cl
80104883:	74 13                	je     80104898 <strncpy+0x38>
80104885:	89 d3                	mov    %edx,%ebx
80104887:	83 ea 01             	sub    $0x1,%edx
8010488a:	85 db                	test   %ebx,%ebx
8010488c:	7f e2                	jg     80104870 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
8010488e:	5b                   	pop    %ebx
8010488f:	89 f0                	mov    %esi,%eax
80104891:	5e                   	pop    %esi
80104892:	5f                   	pop    %edi
80104893:	5d                   	pop    %ebp
80104894:	c3                   	ret
80104895:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104898:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
8010489b:	83 e9 01             	sub    $0x1,%ecx
8010489e:	85 d2                	test   %edx,%edx
801048a0:	74 ec                	je     8010488e <strncpy+0x2e>
801048a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
801048a8:	83 c0 01             	add    $0x1,%eax
801048ab:	89 ca                	mov    %ecx,%edx
801048ad:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
801048b1:	29 c2                	sub    %eax,%edx
801048b3:	85 d2                	test   %edx,%edx
801048b5:	7f f1                	jg     801048a8 <strncpy+0x48>
}
801048b7:	5b                   	pop    %ebx
801048b8:	89 f0                	mov    %esi,%eax
801048ba:	5e                   	pop    %esi
801048bb:	5f                   	pop    %edi
801048bc:	5d                   	pop    %ebp
801048bd:	c3                   	ret
801048be:	66 90                	xchg   %ax,%ax

801048c0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	56                   	push   %esi
801048c4:	53                   	push   %ebx
801048c5:	8b 55 10             	mov    0x10(%ebp),%edx
801048c8:	8b 75 08             	mov    0x8(%ebp),%esi
801048cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801048ce:	85 d2                	test   %edx,%edx
801048d0:	7e 25                	jle    801048f7 <safestrcpy+0x37>
801048d2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801048d6:	89 f2                	mov    %esi,%edx
801048d8:	eb 16                	jmp    801048f0 <safestrcpy+0x30>
801048da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801048e0:	0f b6 08             	movzbl (%eax),%ecx
801048e3:	83 c0 01             	add    $0x1,%eax
801048e6:	83 c2 01             	add    $0x1,%edx
801048e9:	88 4a ff             	mov    %cl,-0x1(%edx)
801048ec:	84 c9                	test   %cl,%cl
801048ee:	74 04                	je     801048f4 <safestrcpy+0x34>
801048f0:	39 d8                	cmp    %ebx,%eax
801048f2:	75 ec                	jne    801048e0 <safestrcpy+0x20>
    ;
  *s = 0;
801048f4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801048f7:	89 f0                	mov    %esi,%eax
801048f9:	5b                   	pop    %ebx
801048fa:	5e                   	pop    %esi
801048fb:	5d                   	pop    %ebp
801048fc:	c3                   	ret
801048fd:	8d 76 00             	lea    0x0(%esi),%esi

80104900 <strlen>:

int
strlen(const char *s)
{
80104900:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104901:	31 c0                	xor    %eax,%eax
{
80104903:	89 e5                	mov    %esp,%ebp
80104905:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104908:	80 3a 00             	cmpb   $0x0,(%edx)
8010490b:	74 0c                	je     80104919 <strlen+0x19>
8010490d:	8d 76 00             	lea    0x0(%esi),%esi
80104910:	83 c0 01             	add    $0x1,%eax
80104913:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104917:	75 f7                	jne    80104910 <strlen+0x10>
    ;
  return n;
}
80104919:	5d                   	pop    %ebp
8010491a:	c3                   	ret

8010491b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010491b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010491f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104923:	55                   	push   %ebp
  pushl %ebx
80104924:	53                   	push   %ebx
  pushl %esi
80104925:	56                   	push   %esi
  pushl %edi
80104926:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104927:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104929:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010492b:	5f                   	pop    %edi
  popl %esi
8010492c:	5e                   	pop    %esi
  popl %ebx
8010492d:	5b                   	pop    %ebx
  popl %ebp
8010492e:	5d                   	pop    %ebp
  ret
8010492f:	c3                   	ret

80104930 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	53                   	push   %ebx
80104934:	83 ec 04             	sub    $0x4,%esp
80104937:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010493a:	e8 e1 f0 ff ff       	call   80103a20 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010493f:	8b 00                	mov    (%eax),%eax
80104941:	39 c3                	cmp    %eax,%ebx
80104943:	73 1b                	jae    80104960 <fetchint+0x30>
80104945:	8d 53 04             	lea    0x4(%ebx),%edx
80104948:	39 d0                	cmp    %edx,%eax
8010494a:	72 14                	jb     80104960 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010494c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010494f:	8b 13                	mov    (%ebx),%edx
80104951:	89 10                	mov    %edx,(%eax)
  return 0;
80104953:	31 c0                	xor    %eax,%eax
}
80104955:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104958:	c9                   	leave
80104959:	c3                   	ret
8010495a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104960:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104965:	eb ee                	jmp    80104955 <fetchint+0x25>
80104967:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010496e:	66 90                	xchg   %ax,%ax

80104970 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	53                   	push   %ebx
80104974:	83 ec 04             	sub    $0x4,%esp
80104977:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010497a:	e8 a1 f0 ff ff       	call   80103a20 <myproc>

  if(addr >= curproc->sz)
8010497f:	3b 18                	cmp    (%eax),%ebx
80104981:	73 2d                	jae    801049b0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104983:	8b 55 0c             	mov    0xc(%ebp),%edx
80104986:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104988:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010498a:	39 d3                	cmp    %edx,%ebx
8010498c:	73 22                	jae    801049b0 <fetchstr+0x40>
8010498e:	89 d8                	mov    %ebx,%eax
80104990:	eb 0d                	jmp    8010499f <fetchstr+0x2f>
80104992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104998:	83 c0 01             	add    $0x1,%eax
8010499b:	39 d0                	cmp    %edx,%eax
8010499d:	73 11                	jae    801049b0 <fetchstr+0x40>
    if(*s == 0)
8010499f:	80 38 00             	cmpb   $0x0,(%eax)
801049a2:	75 f4                	jne    80104998 <fetchstr+0x28>
      return s - *pp;
801049a4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801049a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049a9:	c9                   	leave
801049aa:	c3                   	ret
801049ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049af:	90                   	nop
801049b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
801049b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049b8:	c9                   	leave
801049b9:	c3                   	ret
801049ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049c0 <my_kernel>:

void my_kernel(){
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	83 ec 14             	sub    $0x14,%esp
	cprintf("hello");
801049c6:	68 b5 78 10 80       	push   $0x801078b5
801049cb:	e8 e0 bc ff ff       	call   801006b0 <cprintf>
}
801049d0:	83 c4 10             	add    $0x10,%esp
801049d3:	c9                   	leave
801049d4:	c3                   	ret
801049d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049e0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	56                   	push   %esi
801049e4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049e5:	e8 36 f0 ff ff       	call   80103a20 <myproc>
801049ea:	8b 55 08             	mov    0x8(%ebp),%edx
801049ed:	8b 40 18             	mov    0x18(%eax),%eax
801049f0:	8b 40 44             	mov    0x44(%eax),%eax
801049f3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801049f6:	e8 25 f0 ff ff       	call   80103a20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049fb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049fe:	8b 00                	mov    (%eax),%eax
80104a00:	39 c6                	cmp    %eax,%esi
80104a02:	73 1c                	jae    80104a20 <argint+0x40>
80104a04:	8d 53 08             	lea    0x8(%ebx),%edx
80104a07:	39 d0                	cmp    %edx,%eax
80104a09:	72 15                	jb     80104a20 <argint+0x40>
  *ip = *(int*)(addr);
80104a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a0e:	8b 53 04             	mov    0x4(%ebx),%edx
80104a11:	89 10                	mov    %edx,(%eax)
  return 0;
80104a13:	31 c0                	xor    %eax,%eax
}
80104a15:	5b                   	pop    %ebx
80104a16:	5e                   	pop    %esi
80104a17:	5d                   	pop    %ebp
80104a18:	c3                   	ret
80104a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a25:	eb ee                	jmp    80104a15 <argint+0x35>
80104a27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a2e:	66 90                	xchg   %ax,%ax

80104a30 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	57                   	push   %edi
80104a34:	56                   	push   %esi
80104a35:	53                   	push   %ebx
80104a36:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104a39:	e8 e2 ef ff ff       	call   80103a20 <myproc>
80104a3e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a40:	e8 db ef ff ff       	call   80103a20 <myproc>
80104a45:	8b 55 08             	mov    0x8(%ebp),%edx
80104a48:	8b 40 18             	mov    0x18(%eax),%eax
80104a4b:	8b 40 44             	mov    0x44(%eax),%eax
80104a4e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a51:	e8 ca ef ff ff       	call   80103a20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a56:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a59:	8b 00                	mov    (%eax),%eax
80104a5b:	39 c7                	cmp    %eax,%edi
80104a5d:	73 31                	jae    80104a90 <argptr+0x60>
80104a5f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104a62:	39 c8                	cmp    %ecx,%eax
80104a64:	72 2a                	jb     80104a90 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104a66:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104a69:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104a6c:	85 d2                	test   %edx,%edx
80104a6e:	78 20                	js     80104a90 <argptr+0x60>
80104a70:	8b 16                	mov    (%esi),%edx
80104a72:	39 d0                	cmp    %edx,%eax
80104a74:	73 1a                	jae    80104a90 <argptr+0x60>
80104a76:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104a79:	01 c3                	add    %eax,%ebx
80104a7b:	39 da                	cmp    %ebx,%edx
80104a7d:	72 11                	jb     80104a90 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104a7f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a82:	89 02                	mov    %eax,(%edx)
  return 0;
80104a84:	31 c0                	xor    %eax,%eax
}
80104a86:	83 c4 0c             	add    $0xc,%esp
80104a89:	5b                   	pop    %ebx
80104a8a:	5e                   	pop    %esi
80104a8b:	5f                   	pop    %edi
80104a8c:	5d                   	pop    %ebp
80104a8d:	c3                   	ret
80104a8e:	66 90                	xchg   %ax,%ax
    return -1;
80104a90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a95:	eb ef                	jmp    80104a86 <argptr+0x56>
80104a97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a9e:	66 90                	xchg   %ax,%ax

80104aa0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	56                   	push   %esi
80104aa4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104aa5:	e8 76 ef ff ff       	call   80103a20 <myproc>
80104aaa:	8b 55 08             	mov    0x8(%ebp),%edx
80104aad:	8b 40 18             	mov    0x18(%eax),%eax
80104ab0:	8b 40 44             	mov    0x44(%eax),%eax
80104ab3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ab6:	e8 65 ef ff ff       	call   80103a20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104abb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104abe:	8b 00                	mov    (%eax),%eax
80104ac0:	39 c6                	cmp    %eax,%esi
80104ac2:	73 44                	jae    80104b08 <argstr+0x68>
80104ac4:	8d 53 08             	lea    0x8(%ebx),%edx
80104ac7:	39 d0                	cmp    %edx,%eax
80104ac9:	72 3d                	jb     80104b08 <argstr+0x68>
  *ip = *(int*)(addr);
80104acb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104ace:	e8 4d ef ff ff       	call   80103a20 <myproc>
  if(addr >= curproc->sz)
80104ad3:	3b 18                	cmp    (%eax),%ebx
80104ad5:	73 31                	jae    80104b08 <argstr+0x68>
  *pp = (char*)addr;
80104ad7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ada:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104adc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104ade:	39 d3                	cmp    %edx,%ebx
80104ae0:	73 26                	jae    80104b08 <argstr+0x68>
80104ae2:	89 d8                	mov    %ebx,%eax
80104ae4:	eb 11                	jmp    80104af7 <argstr+0x57>
80104ae6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aed:	8d 76 00             	lea    0x0(%esi),%esi
80104af0:	83 c0 01             	add    $0x1,%eax
80104af3:	39 d0                	cmp    %edx,%eax
80104af5:	73 11                	jae    80104b08 <argstr+0x68>
    if(*s == 0)
80104af7:	80 38 00             	cmpb   $0x0,(%eax)
80104afa:	75 f4                	jne    80104af0 <argstr+0x50>
      return s - *pp;
80104afc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104afe:	5b                   	pop    %ebx
80104aff:	5e                   	pop    %esi
80104b00:	5d                   	pop    %ebp
80104b01:	c3                   	ret
80104b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b08:	5b                   	pop    %ebx
    return -1;
80104b09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b0e:	5e                   	pop    %esi
80104b0f:	5d                   	pop    %ebp
80104b10:	c3                   	ret
80104b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b1f:	90                   	nop

80104b20 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	53                   	push   %ebx
80104b24:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104b27:	e8 f4 ee ff ff       	call   80103a20 <myproc>
80104b2c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104b2e:	8b 40 18             	mov    0x18(%eax),%eax
80104b31:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104b34:	8d 50 ff             	lea    -0x1(%eax),%edx
80104b37:	83 fa 14             	cmp    $0x14,%edx
80104b3a:	77 24                	ja     80104b60 <syscall+0x40>
80104b3c:	8b 14 85 e0 78 10 80 	mov    -0x7fef8720(,%eax,4),%edx
80104b43:	85 d2                	test   %edx,%edx
80104b45:	74 19                	je     80104b60 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104b47:	ff d2                	call   *%edx
80104b49:	89 c2                	mov    %eax,%edx
80104b4b:	8b 43 18             	mov    0x18(%ebx),%eax
80104b4e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104b51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b54:	c9                   	leave
80104b55:	c3                   	ret
80104b56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b5d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104b60:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104b61:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104b64:	50                   	push   %eax
80104b65:	ff 73 10             	push   0x10(%ebx)
80104b68:	68 bb 78 10 80       	push   $0x801078bb
80104b6d:	e8 3e bb ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104b72:	8b 43 18             	mov    0x18(%ebx),%eax
80104b75:	83 c4 10             	add    $0x10,%esp
80104b78:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104b7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b82:	c9                   	leave
80104b83:	c3                   	ret
80104b84:	66 90                	xchg   %ax,%ax
80104b86:	66 90                	xchg   %ax,%ax
80104b88:	66 90                	xchg   %ax,%ax
80104b8a:	66 90                	xchg   %ax,%ax
80104b8c:	66 90                	xchg   %ax,%ax
80104b8e:	66 90                	xchg   %ax,%ax

80104b90 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	57                   	push   %edi
80104b94:	56                   	push   %esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104b95:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104b98:	53                   	push   %ebx
80104b99:	83 ec 44             	sub    $0x44,%esp
80104b9c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104b9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104ba2:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104ba5:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104ba8:	57                   	push   %edi
80104ba9:	50                   	push   %eax
80104baa:	e8 91 d5 ff ff       	call   80102140 <nameiparent>
80104baf:	83 c4 10             	add    $0x10,%esp
80104bb2:	85 c0                	test   %eax,%eax
80104bb4:	74 5e                	je     80104c14 <create+0x84>
    return 0;
  ilock(dp);
80104bb6:	83 ec 0c             	sub    $0xc,%esp
80104bb9:	89 c3                	mov    %eax,%ebx
80104bbb:	50                   	push   %eax
80104bbc:	e8 2f cc ff ff       	call   801017f0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104bc1:	83 c4 0c             	add    $0xc,%esp
80104bc4:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104bc7:	50                   	push   %eax
80104bc8:	57                   	push   %edi
80104bc9:	53                   	push   %ebx
80104bca:	e8 81 d1 ff ff       	call   80101d50 <dirlookup>
80104bcf:	83 c4 10             	add    $0x10,%esp
80104bd2:	89 c6                	mov    %eax,%esi
80104bd4:	85 c0                	test   %eax,%eax
80104bd6:	74 48                	je     80104c20 <create+0x90>
    iunlockput(dp);
80104bd8:	83 ec 0c             	sub    $0xc,%esp
80104bdb:	53                   	push   %ebx
80104bdc:	e8 9f ce ff ff       	call   80101a80 <iunlockput>
    ilock(ip);
80104be1:	89 34 24             	mov    %esi,(%esp)
80104be4:	e8 07 cc ff ff       	call   801017f0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104be9:	83 c4 10             	add    $0x10,%esp
80104bec:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104bf1:	75 15                	jne    80104c08 <create+0x78>
80104bf3:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104bf8:	75 0e                	jne    80104c08 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104bfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bfd:	89 f0                	mov    %esi,%eax
80104bff:	5b                   	pop    %ebx
80104c00:	5e                   	pop    %esi
80104c01:	5f                   	pop    %edi
80104c02:	5d                   	pop    %ebp
80104c03:	c3                   	ret
80104c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80104c08:	83 ec 0c             	sub    $0xc,%esp
80104c0b:	56                   	push   %esi
80104c0c:	e8 6f ce ff ff       	call   80101a80 <iunlockput>
    return 0;
80104c11:	83 c4 10             	add    $0x10,%esp
}
80104c14:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104c17:	31 f6                	xor    %esi,%esi
}
80104c19:	5b                   	pop    %ebx
80104c1a:	89 f0                	mov    %esi,%eax
80104c1c:	5e                   	pop    %esi
80104c1d:	5f                   	pop    %edi
80104c1e:	5d                   	pop    %ebp
80104c1f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104c20:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104c24:	83 ec 08             	sub    $0x8,%esp
80104c27:	50                   	push   %eax
80104c28:	ff 33                	push   (%ebx)
80104c2a:	e8 51 ca ff ff       	call   80101680 <ialloc>
80104c2f:	83 c4 10             	add    $0x10,%esp
80104c32:	89 c6                	mov    %eax,%esi
80104c34:	85 c0                	test   %eax,%eax
80104c36:	0f 84 bc 00 00 00    	je     80104cf8 <create+0x168>
  ilock(ip);
80104c3c:	83 ec 0c             	sub    $0xc,%esp
80104c3f:	50                   	push   %eax
80104c40:	e8 ab cb ff ff       	call   801017f0 <ilock>
  ip->major = major;
80104c45:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104c49:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104c4d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104c51:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104c55:	b8 01 00 00 00       	mov    $0x1,%eax
80104c5a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104c5e:	89 34 24             	mov    %esi,(%esp)
80104c61:	e8 da ca ff ff       	call   80101740 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104c66:	83 c4 10             	add    $0x10,%esp
80104c69:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104c6e:	74 30                	je     80104ca0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104c70:	83 ec 04             	sub    $0x4,%esp
80104c73:	ff 76 04             	push   0x4(%esi)
80104c76:	57                   	push   %edi
80104c77:	53                   	push   %ebx
80104c78:	e8 e3 d3 ff ff       	call   80102060 <dirlink>
80104c7d:	83 c4 10             	add    $0x10,%esp
80104c80:	85 c0                	test   %eax,%eax
80104c82:	78 67                	js     80104ceb <create+0x15b>
  iunlockput(dp);
80104c84:	83 ec 0c             	sub    $0xc,%esp
80104c87:	53                   	push   %ebx
80104c88:	e8 f3 cd ff ff       	call   80101a80 <iunlockput>
  return ip;
80104c8d:	83 c4 10             	add    $0x10,%esp
}
80104c90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c93:	89 f0                	mov    %esi,%eax
80104c95:	5b                   	pop    %ebx
80104c96:	5e                   	pop    %esi
80104c97:	5f                   	pop    %edi
80104c98:	5d                   	pop    %ebp
80104c99:	c3                   	ret
80104c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104ca0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104ca3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104ca8:	53                   	push   %ebx
80104ca9:	e8 92 ca ff ff       	call   80101740 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104cae:	83 c4 0c             	add    $0xc,%esp
80104cb1:	ff 76 04             	push   0x4(%esi)
80104cb4:	68 54 79 10 80       	push   $0x80107954
80104cb9:	56                   	push   %esi
80104cba:	e8 a1 d3 ff ff       	call   80102060 <dirlink>
80104cbf:	83 c4 10             	add    $0x10,%esp
80104cc2:	85 c0                	test   %eax,%eax
80104cc4:	78 18                	js     80104cde <create+0x14e>
80104cc6:	83 ec 04             	sub    $0x4,%esp
80104cc9:	ff 73 04             	push   0x4(%ebx)
80104ccc:	68 53 79 10 80       	push   $0x80107953
80104cd1:	56                   	push   %esi
80104cd2:	e8 89 d3 ff ff       	call   80102060 <dirlink>
80104cd7:	83 c4 10             	add    $0x10,%esp
80104cda:	85 c0                	test   %eax,%eax
80104cdc:	79 92                	jns    80104c70 <create+0xe0>
      panic("create dots");
80104cde:	83 ec 0c             	sub    $0xc,%esp
80104ce1:	68 47 79 10 80       	push   $0x80107947
80104ce6:	e8 95 b6 ff ff       	call   80100380 <panic>
    panic("create: dirlink");
80104ceb:	83 ec 0c             	sub    $0xc,%esp
80104cee:	68 56 79 10 80       	push   $0x80107956
80104cf3:	e8 88 b6 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104cf8:	83 ec 0c             	sub    $0xc,%esp
80104cfb:	68 38 79 10 80       	push   $0x80107938
80104d00:	e8 7b b6 ff ff       	call   80100380 <panic>
80104d05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d10 <sys_dup>:
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	56                   	push   %esi
80104d14:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104d15:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104d18:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d1b:	50                   	push   %eax
80104d1c:	6a 00                	push   $0x0
80104d1e:	e8 bd fc ff ff       	call   801049e0 <argint>
80104d23:	83 c4 10             	add    $0x10,%esp
80104d26:	85 c0                	test   %eax,%eax
80104d28:	78 36                	js     80104d60 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d2a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d2e:	77 30                	ja     80104d60 <sys_dup+0x50>
80104d30:	e8 eb ec ff ff       	call   80103a20 <myproc>
80104d35:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d38:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104d3c:	85 f6                	test   %esi,%esi
80104d3e:	74 20                	je     80104d60 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104d40:	e8 db ec ff ff       	call   80103a20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104d45:	31 db                	xor    %ebx,%ebx
80104d47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d4e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104d50:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104d54:	85 d2                	test   %edx,%edx
80104d56:	74 18                	je     80104d70 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104d58:	83 c3 01             	add    $0x1,%ebx
80104d5b:	83 fb 10             	cmp    $0x10,%ebx
80104d5e:	75 f0                	jne    80104d50 <sys_dup+0x40>
}
80104d60:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104d63:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104d68:	89 d8                	mov    %ebx,%eax
80104d6a:	5b                   	pop    %ebx
80104d6b:	5e                   	pop    %esi
80104d6c:	5d                   	pop    %ebp
80104d6d:	c3                   	ret
80104d6e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104d70:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104d73:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104d77:	56                   	push   %esi
80104d78:	e8 73 c1 ff ff       	call   80100ef0 <filedup>
  return fd;
80104d7d:	83 c4 10             	add    $0x10,%esp
}
80104d80:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d83:	89 d8                	mov    %ebx,%eax
80104d85:	5b                   	pop    %ebx
80104d86:	5e                   	pop    %esi
80104d87:	5d                   	pop    %ebp
80104d88:	c3                   	ret
80104d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d90 <sys_read>:
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	56                   	push   %esi
80104d94:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104d95:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104d98:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d9b:	53                   	push   %ebx
80104d9c:	6a 00                	push   $0x0
80104d9e:	e8 3d fc ff ff       	call   801049e0 <argint>
80104da3:	83 c4 10             	add    $0x10,%esp
80104da6:	85 c0                	test   %eax,%eax
80104da8:	78 5e                	js     80104e08 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104daa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104dae:	77 58                	ja     80104e08 <sys_read+0x78>
80104db0:	e8 6b ec ff ff       	call   80103a20 <myproc>
80104db5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104db8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104dbc:	85 f6                	test   %esi,%esi
80104dbe:	74 48                	je     80104e08 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104dc0:	83 ec 08             	sub    $0x8,%esp
80104dc3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104dc6:	50                   	push   %eax
80104dc7:	6a 02                	push   $0x2
80104dc9:	e8 12 fc ff ff       	call   801049e0 <argint>
80104dce:	83 c4 10             	add    $0x10,%esp
80104dd1:	85 c0                	test   %eax,%eax
80104dd3:	78 33                	js     80104e08 <sys_read+0x78>
80104dd5:	83 ec 04             	sub    $0x4,%esp
80104dd8:	ff 75 f0             	push   -0x10(%ebp)
80104ddb:	53                   	push   %ebx
80104ddc:	6a 01                	push   $0x1
80104dde:	e8 4d fc ff ff       	call   80104a30 <argptr>
80104de3:	83 c4 10             	add    $0x10,%esp
80104de6:	85 c0                	test   %eax,%eax
80104de8:	78 1e                	js     80104e08 <sys_read+0x78>
  return fileread(f, p, n);
80104dea:	83 ec 04             	sub    $0x4,%esp
80104ded:	ff 75 f0             	push   -0x10(%ebp)
80104df0:	ff 75 f4             	push   -0xc(%ebp)
80104df3:	56                   	push   %esi
80104df4:	e8 77 c2 ff ff       	call   80101070 <fileread>
80104df9:	83 c4 10             	add    $0x10,%esp
}
80104dfc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dff:	5b                   	pop    %ebx
80104e00:	5e                   	pop    %esi
80104e01:	5d                   	pop    %ebp
80104e02:	c3                   	ret
80104e03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e07:	90                   	nop
    return -1;
80104e08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e0d:	eb ed                	jmp    80104dfc <sys_read+0x6c>
80104e0f:	90                   	nop

80104e10 <sys_write>:
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	56                   	push   %esi
80104e14:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e15:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104e18:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e1b:	53                   	push   %ebx
80104e1c:	6a 00                	push   $0x0
80104e1e:	e8 bd fb ff ff       	call   801049e0 <argint>
80104e23:	83 c4 10             	add    $0x10,%esp
80104e26:	85 c0                	test   %eax,%eax
80104e28:	78 5e                	js     80104e88 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e2a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e2e:	77 58                	ja     80104e88 <sys_write+0x78>
80104e30:	e8 eb eb ff ff       	call   80103a20 <myproc>
80104e35:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e38:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e3c:	85 f6                	test   %esi,%esi
80104e3e:	74 48                	je     80104e88 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e40:	83 ec 08             	sub    $0x8,%esp
80104e43:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e46:	50                   	push   %eax
80104e47:	6a 02                	push   $0x2
80104e49:	e8 92 fb ff ff       	call   801049e0 <argint>
80104e4e:	83 c4 10             	add    $0x10,%esp
80104e51:	85 c0                	test   %eax,%eax
80104e53:	78 33                	js     80104e88 <sys_write+0x78>
80104e55:	83 ec 04             	sub    $0x4,%esp
80104e58:	ff 75 f0             	push   -0x10(%ebp)
80104e5b:	53                   	push   %ebx
80104e5c:	6a 01                	push   $0x1
80104e5e:	e8 cd fb ff ff       	call   80104a30 <argptr>
80104e63:	83 c4 10             	add    $0x10,%esp
80104e66:	85 c0                	test   %eax,%eax
80104e68:	78 1e                	js     80104e88 <sys_write+0x78>
  return filewrite(f, p, n);
80104e6a:	83 ec 04             	sub    $0x4,%esp
80104e6d:	ff 75 f0             	push   -0x10(%ebp)
80104e70:	ff 75 f4             	push   -0xc(%ebp)
80104e73:	56                   	push   %esi
80104e74:	e8 87 c2 ff ff       	call   80101100 <filewrite>
80104e79:	83 c4 10             	add    $0x10,%esp
}
80104e7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e7f:	5b                   	pop    %ebx
80104e80:	5e                   	pop    %esi
80104e81:	5d                   	pop    %ebp
80104e82:	c3                   	ret
80104e83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e87:	90                   	nop
    return -1;
80104e88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e8d:	eb ed                	jmp    80104e7c <sys_write+0x6c>
80104e8f:	90                   	nop

80104e90 <sys_close>:
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	56                   	push   %esi
80104e94:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e95:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e98:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e9b:	50                   	push   %eax
80104e9c:	6a 00                	push   $0x0
80104e9e:	e8 3d fb ff ff       	call   801049e0 <argint>
80104ea3:	83 c4 10             	add    $0x10,%esp
80104ea6:	85 c0                	test   %eax,%eax
80104ea8:	78 3e                	js     80104ee8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eaa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104eae:	77 38                	ja     80104ee8 <sys_close+0x58>
80104eb0:	e8 6b eb ff ff       	call   80103a20 <myproc>
80104eb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104eb8:	8d 5a 08             	lea    0x8(%edx),%ebx
80104ebb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104ebf:	85 f6                	test   %esi,%esi
80104ec1:	74 25                	je     80104ee8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104ec3:	e8 58 eb ff ff       	call   80103a20 <myproc>
  fileclose(f);
80104ec8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104ecb:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104ed2:	00 
  fileclose(f);
80104ed3:	56                   	push   %esi
80104ed4:	e8 67 c0 ff ff       	call   80100f40 <fileclose>
  return 0;
80104ed9:	83 c4 10             	add    $0x10,%esp
80104edc:	31 c0                	xor    %eax,%eax
}
80104ede:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ee1:	5b                   	pop    %ebx
80104ee2:	5e                   	pop    %esi
80104ee3:	5d                   	pop    %ebp
80104ee4:	c3                   	ret
80104ee5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104ee8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104eed:	eb ef                	jmp    80104ede <sys_close+0x4e>
80104eef:	90                   	nop

80104ef0 <sys_fstat>:
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	56                   	push   %esi
80104ef4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ef5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104ef8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104efb:	53                   	push   %ebx
80104efc:	6a 00                	push   $0x0
80104efe:	e8 dd fa ff ff       	call   801049e0 <argint>
80104f03:	83 c4 10             	add    $0x10,%esp
80104f06:	85 c0                	test   %eax,%eax
80104f08:	78 46                	js     80104f50 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f0a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f0e:	77 40                	ja     80104f50 <sys_fstat+0x60>
80104f10:	e8 0b eb ff ff       	call   80103a20 <myproc>
80104f15:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f18:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f1c:	85 f6                	test   %esi,%esi
80104f1e:	74 30                	je     80104f50 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f20:	83 ec 04             	sub    $0x4,%esp
80104f23:	6a 14                	push   $0x14
80104f25:	53                   	push   %ebx
80104f26:	6a 01                	push   $0x1
80104f28:	e8 03 fb ff ff       	call   80104a30 <argptr>
80104f2d:	83 c4 10             	add    $0x10,%esp
80104f30:	85 c0                	test   %eax,%eax
80104f32:	78 1c                	js     80104f50 <sys_fstat+0x60>
  return filestat(f, st);
80104f34:	83 ec 08             	sub    $0x8,%esp
80104f37:	ff 75 f4             	push   -0xc(%ebp)
80104f3a:	56                   	push   %esi
80104f3b:	e8 e0 c0 ff ff       	call   80101020 <filestat>
80104f40:	83 c4 10             	add    $0x10,%esp
}
80104f43:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f46:	5b                   	pop    %ebx
80104f47:	5e                   	pop    %esi
80104f48:	5d                   	pop    %ebp
80104f49:	c3                   	ret
80104f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f55:	eb ec                	jmp    80104f43 <sys_fstat+0x53>
80104f57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f5e:	66 90                	xchg   %ax,%ax

80104f60 <sys_link>:
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	57                   	push   %edi
80104f64:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f65:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104f68:	53                   	push   %ebx
80104f69:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f6c:	50                   	push   %eax
80104f6d:	6a 00                	push   $0x0
80104f6f:	e8 2c fb ff ff       	call   80104aa0 <argstr>
80104f74:	83 c4 10             	add    $0x10,%esp
80104f77:	85 c0                	test   %eax,%eax
80104f79:	0f 88 fb 00 00 00    	js     8010507a <sys_link+0x11a>
80104f7f:	83 ec 08             	sub    $0x8,%esp
80104f82:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104f85:	50                   	push   %eax
80104f86:	6a 01                	push   $0x1
80104f88:	e8 13 fb ff ff       	call   80104aa0 <argstr>
80104f8d:	83 c4 10             	add    $0x10,%esp
80104f90:	85 c0                	test   %eax,%eax
80104f92:	0f 88 e2 00 00 00    	js     8010507a <sys_link+0x11a>
  begin_op();
80104f98:	e8 53 de ff ff       	call   80102df0 <begin_op>
  if((ip = namei(old)) == 0){
80104f9d:	83 ec 0c             	sub    $0xc,%esp
80104fa0:	ff 75 d4             	push   -0x2c(%ebp)
80104fa3:	e8 78 d1 ff ff       	call   80102120 <namei>
80104fa8:	83 c4 10             	add    $0x10,%esp
80104fab:	89 c3                	mov    %eax,%ebx
80104fad:	85 c0                	test   %eax,%eax
80104faf:	0f 84 df 00 00 00    	je     80105094 <sys_link+0x134>
  ilock(ip);
80104fb5:	83 ec 0c             	sub    $0xc,%esp
80104fb8:	50                   	push   %eax
80104fb9:	e8 32 c8 ff ff       	call   801017f0 <ilock>
  if(ip->type == T_DIR){
80104fbe:	83 c4 10             	add    $0x10,%esp
80104fc1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104fc6:	0f 84 b5 00 00 00    	je     80105081 <sys_link+0x121>
  iupdate(ip);
80104fcc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104fcf:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104fd4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104fd7:	53                   	push   %ebx
80104fd8:	e8 63 c7 ff ff       	call   80101740 <iupdate>
  iunlock(ip);
80104fdd:	89 1c 24             	mov    %ebx,(%esp)
80104fe0:	e8 eb c8 ff ff       	call   801018d0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104fe5:	58                   	pop    %eax
80104fe6:	5a                   	pop    %edx
80104fe7:	57                   	push   %edi
80104fe8:	ff 75 d0             	push   -0x30(%ebp)
80104feb:	e8 50 d1 ff ff       	call   80102140 <nameiparent>
80104ff0:	83 c4 10             	add    $0x10,%esp
80104ff3:	89 c6                	mov    %eax,%esi
80104ff5:	85 c0                	test   %eax,%eax
80104ff7:	74 5b                	je     80105054 <sys_link+0xf4>
  ilock(dp);
80104ff9:	83 ec 0c             	sub    $0xc,%esp
80104ffc:	50                   	push   %eax
80104ffd:	e8 ee c7 ff ff       	call   801017f0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105002:	8b 03                	mov    (%ebx),%eax
80105004:	83 c4 10             	add    $0x10,%esp
80105007:	39 06                	cmp    %eax,(%esi)
80105009:	75 3d                	jne    80105048 <sys_link+0xe8>
8010500b:	83 ec 04             	sub    $0x4,%esp
8010500e:	ff 73 04             	push   0x4(%ebx)
80105011:	57                   	push   %edi
80105012:	56                   	push   %esi
80105013:	e8 48 d0 ff ff       	call   80102060 <dirlink>
80105018:	83 c4 10             	add    $0x10,%esp
8010501b:	85 c0                	test   %eax,%eax
8010501d:	78 29                	js     80105048 <sys_link+0xe8>
  iunlockput(dp);
8010501f:	83 ec 0c             	sub    $0xc,%esp
80105022:	56                   	push   %esi
80105023:	e8 58 ca ff ff       	call   80101a80 <iunlockput>
  iput(ip);
80105028:	89 1c 24             	mov    %ebx,(%esp)
8010502b:	e8 f0 c8 ff ff       	call   80101920 <iput>
  end_op();
80105030:	e8 2b de ff ff       	call   80102e60 <end_op>
  return 0;
80105035:	83 c4 10             	add    $0x10,%esp
80105038:	31 c0                	xor    %eax,%eax
}
8010503a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010503d:	5b                   	pop    %ebx
8010503e:	5e                   	pop    %esi
8010503f:	5f                   	pop    %edi
80105040:	5d                   	pop    %ebp
80105041:	c3                   	ret
80105042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105048:	83 ec 0c             	sub    $0xc,%esp
8010504b:	56                   	push   %esi
8010504c:	e8 2f ca ff ff       	call   80101a80 <iunlockput>
    goto bad;
80105051:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105054:	83 ec 0c             	sub    $0xc,%esp
80105057:	53                   	push   %ebx
80105058:	e8 93 c7 ff ff       	call   801017f0 <ilock>
  ip->nlink--;
8010505d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105062:	89 1c 24             	mov    %ebx,(%esp)
80105065:	e8 d6 c6 ff ff       	call   80101740 <iupdate>
  iunlockput(ip);
8010506a:	89 1c 24             	mov    %ebx,(%esp)
8010506d:	e8 0e ca ff ff       	call   80101a80 <iunlockput>
  end_op();
80105072:	e8 e9 dd ff ff       	call   80102e60 <end_op>
  return -1;
80105077:	83 c4 10             	add    $0x10,%esp
    return -1;
8010507a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010507f:	eb b9                	jmp    8010503a <sys_link+0xda>
    iunlockput(ip);
80105081:	83 ec 0c             	sub    $0xc,%esp
80105084:	53                   	push   %ebx
80105085:	e8 f6 c9 ff ff       	call   80101a80 <iunlockput>
    end_op();
8010508a:	e8 d1 dd ff ff       	call   80102e60 <end_op>
    return -1;
8010508f:	83 c4 10             	add    $0x10,%esp
80105092:	eb e6                	jmp    8010507a <sys_link+0x11a>
    end_op();
80105094:	e8 c7 dd ff ff       	call   80102e60 <end_op>
    return -1;
80105099:	eb df                	jmp    8010507a <sys_link+0x11a>
8010509b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010509f:	90                   	nop

801050a0 <sys_unlink>:
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	57                   	push   %edi
801050a4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801050a5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801050a8:	53                   	push   %ebx
801050a9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801050ac:	50                   	push   %eax
801050ad:	6a 00                	push   $0x0
801050af:	e8 ec f9 ff ff       	call   80104aa0 <argstr>
801050b4:	83 c4 10             	add    $0x10,%esp
801050b7:	85 c0                	test   %eax,%eax
801050b9:	0f 88 54 01 00 00    	js     80105213 <sys_unlink+0x173>
  begin_op();
801050bf:	e8 2c dd ff ff       	call   80102df0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801050c4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801050c7:	83 ec 08             	sub    $0x8,%esp
801050ca:	53                   	push   %ebx
801050cb:	ff 75 c0             	push   -0x40(%ebp)
801050ce:	e8 6d d0 ff ff       	call   80102140 <nameiparent>
801050d3:	83 c4 10             	add    $0x10,%esp
801050d6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801050d9:	85 c0                	test   %eax,%eax
801050db:	0f 84 58 01 00 00    	je     80105239 <sys_unlink+0x199>
  ilock(dp);
801050e1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801050e4:	83 ec 0c             	sub    $0xc,%esp
801050e7:	57                   	push   %edi
801050e8:	e8 03 c7 ff ff       	call   801017f0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801050ed:	58                   	pop    %eax
801050ee:	5a                   	pop    %edx
801050ef:	68 54 79 10 80       	push   $0x80107954
801050f4:	53                   	push   %ebx
801050f5:	e8 36 cc ff ff       	call   80101d30 <namecmp>
801050fa:	83 c4 10             	add    $0x10,%esp
801050fd:	85 c0                	test   %eax,%eax
801050ff:	0f 84 fb 00 00 00    	je     80105200 <sys_unlink+0x160>
80105105:	83 ec 08             	sub    $0x8,%esp
80105108:	68 53 79 10 80       	push   $0x80107953
8010510d:	53                   	push   %ebx
8010510e:	e8 1d cc ff ff       	call   80101d30 <namecmp>
80105113:	83 c4 10             	add    $0x10,%esp
80105116:	85 c0                	test   %eax,%eax
80105118:	0f 84 e2 00 00 00    	je     80105200 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010511e:	83 ec 04             	sub    $0x4,%esp
80105121:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105124:	50                   	push   %eax
80105125:	53                   	push   %ebx
80105126:	57                   	push   %edi
80105127:	e8 24 cc ff ff       	call   80101d50 <dirlookup>
8010512c:	83 c4 10             	add    $0x10,%esp
8010512f:	89 c3                	mov    %eax,%ebx
80105131:	85 c0                	test   %eax,%eax
80105133:	0f 84 c7 00 00 00    	je     80105200 <sys_unlink+0x160>
  ilock(ip);
80105139:	83 ec 0c             	sub    $0xc,%esp
8010513c:	50                   	push   %eax
8010513d:	e8 ae c6 ff ff       	call   801017f0 <ilock>
  if(ip->nlink < 1)
80105142:	83 c4 10             	add    $0x10,%esp
80105145:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010514a:	0f 8e 0a 01 00 00    	jle    8010525a <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105150:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105155:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105158:	74 66                	je     801051c0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010515a:	83 ec 04             	sub    $0x4,%esp
8010515d:	6a 10                	push   $0x10
8010515f:	6a 00                	push   $0x0
80105161:	57                   	push   %edi
80105162:	e8 a9 f5 ff ff       	call   80104710 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105167:	6a 10                	push   $0x10
80105169:	ff 75 c4             	push   -0x3c(%ebp)
8010516c:	57                   	push   %edi
8010516d:	ff 75 b4             	push   -0x4c(%ebp)
80105170:	e8 8b ca ff ff       	call   80101c00 <writei>
80105175:	83 c4 20             	add    $0x20,%esp
80105178:	83 f8 10             	cmp    $0x10,%eax
8010517b:	0f 85 cc 00 00 00    	jne    8010524d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
80105181:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105186:	0f 84 94 00 00 00    	je     80105220 <sys_unlink+0x180>
  iunlockput(dp);
8010518c:	83 ec 0c             	sub    $0xc,%esp
8010518f:	ff 75 b4             	push   -0x4c(%ebp)
80105192:	e8 e9 c8 ff ff       	call   80101a80 <iunlockput>
  ip->nlink--;
80105197:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010519c:	89 1c 24             	mov    %ebx,(%esp)
8010519f:	e8 9c c5 ff ff       	call   80101740 <iupdate>
  iunlockput(ip);
801051a4:	89 1c 24             	mov    %ebx,(%esp)
801051a7:	e8 d4 c8 ff ff       	call   80101a80 <iunlockput>
  end_op();
801051ac:	e8 af dc ff ff       	call   80102e60 <end_op>
  return 0;
801051b1:	83 c4 10             	add    $0x10,%esp
801051b4:	31 c0                	xor    %eax,%eax
}
801051b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051b9:	5b                   	pop    %ebx
801051ba:	5e                   	pop    %esi
801051bb:	5f                   	pop    %edi
801051bc:	5d                   	pop    %ebp
801051bd:	c3                   	ret
801051be:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801051c0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801051c4:	76 94                	jbe    8010515a <sys_unlink+0xba>
801051c6:	be 20 00 00 00       	mov    $0x20,%esi
801051cb:	eb 0b                	jmp    801051d8 <sys_unlink+0x138>
801051cd:	8d 76 00             	lea    0x0(%esi),%esi
801051d0:	83 c6 10             	add    $0x10,%esi
801051d3:	3b 73 58             	cmp    0x58(%ebx),%esi
801051d6:	73 82                	jae    8010515a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051d8:	6a 10                	push   $0x10
801051da:	56                   	push   %esi
801051db:	57                   	push   %edi
801051dc:	53                   	push   %ebx
801051dd:	e8 1e c9 ff ff       	call   80101b00 <readi>
801051e2:	83 c4 10             	add    $0x10,%esp
801051e5:	83 f8 10             	cmp    $0x10,%eax
801051e8:	75 56                	jne    80105240 <sys_unlink+0x1a0>
    if(de.inum != 0)
801051ea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801051ef:	74 df                	je     801051d0 <sys_unlink+0x130>
    iunlockput(ip);
801051f1:	83 ec 0c             	sub    $0xc,%esp
801051f4:	53                   	push   %ebx
801051f5:	e8 86 c8 ff ff       	call   80101a80 <iunlockput>
    goto bad;
801051fa:	83 c4 10             	add    $0x10,%esp
801051fd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105200:	83 ec 0c             	sub    $0xc,%esp
80105203:	ff 75 b4             	push   -0x4c(%ebp)
80105206:	e8 75 c8 ff ff       	call   80101a80 <iunlockput>
  end_op();
8010520b:	e8 50 dc ff ff       	call   80102e60 <end_op>
  return -1;
80105210:	83 c4 10             	add    $0x10,%esp
    return -1;
80105213:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105218:	eb 9c                	jmp    801051b6 <sys_unlink+0x116>
8010521a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105220:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105223:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105226:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010522b:	50                   	push   %eax
8010522c:	e8 0f c5 ff ff       	call   80101740 <iupdate>
80105231:	83 c4 10             	add    $0x10,%esp
80105234:	e9 53 ff ff ff       	jmp    8010518c <sys_unlink+0xec>
    end_op();
80105239:	e8 22 dc ff ff       	call   80102e60 <end_op>
    return -1;
8010523e:	eb d3                	jmp    80105213 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105240:	83 ec 0c             	sub    $0xc,%esp
80105243:	68 78 79 10 80       	push   $0x80107978
80105248:	e8 33 b1 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010524d:	83 ec 0c             	sub    $0xc,%esp
80105250:	68 8a 79 10 80       	push   $0x8010798a
80105255:	e8 26 b1 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010525a:	83 ec 0c             	sub    $0xc,%esp
8010525d:	68 66 79 10 80       	push   $0x80107966
80105262:	e8 19 b1 ff ff       	call   80100380 <panic>
80105267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010526e:	66 90                	xchg   %ax,%ax

80105270 <sys_open>:

int
sys_open(void)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	57                   	push   %edi
80105274:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105275:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105278:	53                   	push   %ebx
80105279:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010527c:	50                   	push   %eax
8010527d:	6a 00                	push   $0x0
8010527f:	e8 1c f8 ff ff       	call   80104aa0 <argstr>
80105284:	83 c4 10             	add    $0x10,%esp
80105287:	85 c0                	test   %eax,%eax
80105289:	0f 88 8e 00 00 00    	js     8010531d <sys_open+0xad>
8010528f:	83 ec 08             	sub    $0x8,%esp
80105292:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105295:	50                   	push   %eax
80105296:	6a 01                	push   $0x1
80105298:	e8 43 f7 ff ff       	call   801049e0 <argint>
8010529d:	83 c4 10             	add    $0x10,%esp
801052a0:	85 c0                	test   %eax,%eax
801052a2:	78 79                	js     8010531d <sys_open+0xad>
    return -1;

  begin_op();
801052a4:	e8 47 db ff ff       	call   80102df0 <begin_op>

  if(omode & O_CREATE){
801052a9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801052ad:	75 79                	jne    80105328 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801052af:	83 ec 0c             	sub    $0xc,%esp
801052b2:	ff 75 e0             	push   -0x20(%ebp)
801052b5:	e8 66 ce ff ff       	call   80102120 <namei>
801052ba:	83 c4 10             	add    $0x10,%esp
801052bd:	89 c6                	mov    %eax,%esi
801052bf:	85 c0                	test   %eax,%eax
801052c1:	0f 84 7e 00 00 00    	je     80105345 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801052c7:	83 ec 0c             	sub    $0xc,%esp
801052ca:	50                   	push   %eax
801052cb:	e8 20 c5 ff ff       	call   801017f0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801052d0:	83 c4 10             	add    $0x10,%esp
801052d3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801052d8:	0f 84 ba 00 00 00    	je     80105398 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801052de:	e8 9d bb ff ff       	call   80100e80 <filealloc>
801052e3:	89 c7                	mov    %eax,%edi
801052e5:	85 c0                	test   %eax,%eax
801052e7:	74 23                	je     8010530c <sys_open+0x9c>
  struct proc *curproc = myproc();
801052e9:	e8 32 e7 ff ff       	call   80103a20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801052ee:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801052f0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801052f4:	85 d2                	test   %edx,%edx
801052f6:	74 58                	je     80105350 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
801052f8:	83 c3 01             	add    $0x1,%ebx
801052fb:	83 fb 10             	cmp    $0x10,%ebx
801052fe:	75 f0                	jne    801052f0 <sys_open+0x80>
    if(f)
      fileclose(f);
80105300:	83 ec 0c             	sub    $0xc,%esp
80105303:	57                   	push   %edi
80105304:	e8 37 bc ff ff       	call   80100f40 <fileclose>
80105309:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010530c:	83 ec 0c             	sub    $0xc,%esp
8010530f:	56                   	push   %esi
80105310:	e8 6b c7 ff ff       	call   80101a80 <iunlockput>
    end_op();
80105315:	e8 46 db ff ff       	call   80102e60 <end_op>
    return -1;
8010531a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010531d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105322:	eb 65                	jmp    80105389 <sys_open+0x119>
80105324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105328:	83 ec 0c             	sub    $0xc,%esp
8010532b:	31 c9                	xor    %ecx,%ecx
8010532d:	ba 02 00 00 00       	mov    $0x2,%edx
80105332:	6a 00                	push   $0x0
80105334:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105337:	e8 54 f8 ff ff       	call   80104b90 <create>
    if(ip == 0){
8010533c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010533f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105341:	85 c0                	test   %eax,%eax
80105343:	75 99                	jne    801052de <sys_open+0x6e>
      end_op();
80105345:	e8 16 db ff ff       	call   80102e60 <end_op>
      return -1;
8010534a:	eb d1                	jmp    8010531d <sys_open+0xad>
8010534c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105350:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105353:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105357:	56                   	push   %esi
80105358:	e8 73 c5 ff ff       	call   801018d0 <iunlock>
  end_op();
8010535d:	e8 fe da ff ff       	call   80102e60 <end_op>

  f->type = FD_INODE;
80105362:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105368:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010536b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010536e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105371:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105373:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010537a:	f7 d0                	not    %eax
8010537c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010537f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105382:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105385:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105389:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010538c:	89 d8                	mov    %ebx,%eax
8010538e:	5b                   	pop    %ebx
8010538f:	5e                   	pop    %esi
80105390:	5f                   	pop    %edi
80105391:	5d                   	pop    %ebp
80105392:	c3                   	ret
80105393:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105397:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105398:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010539b:	85 c9                	test   %ecx,%ecx
8010539d:	0f 84 3b ff ff ff    	je     801052de <sys_open+0x6e>
801053a3:	e9 64 ff ff ff       	jmp    8010530c <sys_open+0x9c>
801053a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053af:	90                   	nop

801053b0 <sys_mkdir>:

int
sys_mkdir(void)
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
801053b3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801053b6:	e8 35 da ff ff       	call   80102df0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801053bb:	83 ec 08             	sub    $0x8,%esp
801053be:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053c1:	50                   	push   %eax
801053c2:	6a 00                	push   $0x0
801053c4:	e8 d7 f6 ff ff       	call   80104aa0 <argstr>
801053c9:	83 c4 10             	add    $0x10,%esp
801053cc:	85 c0                	test   %eax,%eax
801053ce:	78 30                	js     80105400 <sys_mkdir+0x50>
801053d0:	83 ec 0c             	sub    $0xc,%esp
801053d3:	31 c9                	xor    %ecx,%ecx
801053d5:	ba 01 00 00 00       	mov    $0x1,%edx
801053da:	6a 00                	push   $0x0
801053dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053df:	e8 ac f7 ff ff       	call   80104b90 <create>
801053e4:	83 c4 10             	add    $0x10,%esp
801053e7:	85 c0                	test   %eax,%eax
801053e9:	74 15                	je     80105400 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801053eb:	83 ec 0c             	sub    $0xc,%esp
801053ee:	50                   	push   %eax
801053ef:	e8 8c c6 ff ff       	call   80101a80 <iunlockput>
  end_op();
801053f4:	e8 67 da ff ff       	call   80102e60 <end_op>
  return 0;
801053f9:	83 c4 10             	add    $0x10,%esp
801053fc:	31 c0                	xor    %eax,%eax
}
801053fe:	c9                   	leave
801053ff:	c3                   	ret
    end_op();
80105400:	e8 5b da ff ff       	call   80102e60 <end_op>
    return -1;
80105405:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010540a:	c9                   	leave
8010540b:	c3                   	ret
8010540c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105410 <sys_mknod>:

int
sys_mknod(void)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105416:	e8 d5 d9 ff ff       	call   80102df0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010541b:	83 ec 08             	sub    $0x8,%esp
8010541e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105421:	50                   	push   %eax
80105422:	6a 00                	push   $0x0
80105424:	e8 77 f6 ff ff       	call   80104aa0 <argstr>
80105429:	83 c4 10             	add    $0x10,%esp
8010542c:	85 c0                	test   %eax,%eax
8010542e:	78 60                	js     80105490 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105430:	83 ec 08             	sub    $0x8,%esp
80105433:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105436:	50                   	push   %eax
80105437:	6a 01                	push   $0x1
80105439:	e8 a2 f5 ff ff       	call   801049e0 <argint>
  if((argstr(0, &path)) < 0 ||
8010543e:	83 c4 10             	add    $0x10,%esp
80105441:	85 c0                	test   %eax,%eax
80105443:	78 4b                	js     80105490 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105445:	83 ec 08             	sub    $0x8,%esp
80105448:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010544b:	50                   	push   %eax
8010544c:	6a 02                	push   $0x2
8010544e:	e8 8d f5 ff ff       	call   801049e0 <argint>
     argint(1, &major) < 0 ||
80105453:	83 c4 10             	add    $0x10,%esp
80105456:	85 c0                	test   %eax,%eax
80105458:	78 36                	js     80105490 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010545a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010545e:	83 ec 0c             	sub    $0xc,%esp
80105461:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105465:	ba 03 00 00 00       	mov    $0x3,%edx
8010546a:	50                   	push   %eax
8010546b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010546e:	e8 1d f7 ff ff       	call   80104b90 <create>
     argint(2, &minor) < 0 ||
80105473:	83 c4 10             	add    $0x10,%esp
80105476:	85 c0                	test   %eax,%eax
80105478:	74 16                	je     80105490 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010547a:	83 ec 0c             	sub    $0xc,%esp
8010547d:	50                   	push   %eax
8010547e:	e8 fd c5 ff ff       	call   80101a80 <iunlockput>
  end_op();
80105483:	e8 d8 d9 ff ff       	call   80102e60 <end_op>
  return 0;
80105488:	83 c4 10             	add    $0x10,%esp
8010548b:	31 c0                	xor    %eax,%eax
}
8010548d:	c9                   	leave
8010548e:	c3                   	ret
8010548f:	90                   	nop
    end_op();
80105490:	e8 cb d9 ff ff       	call   80102e60 <end_op>
    return -1;
80105495:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010549a:	c9                   	leave
8010549b:	c3                   	ret
8010549c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054a0 <sys_chdir>:

int
sys_chdir(void)
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	56                   	push   %esi
801054a4:	53                   	push   %ebx
801054a5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801054a8:	e8 73 e5 ff ff       	call   80103a20 <myproc>
801054ad:	89 c6                	mov    %eax,%esi
  
  begin_op();
801054af:	e8 3c d9 ff ff       	call   80102df0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801054b4:	83 ec 08             	sub    $0x8,%esp
801054b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054ba:	50                   	push   %eax
801054bb:	6a 00                	push   $0x0
801054bd:	e8 de f5 ff ff       	call   80104aa0 <argstr>
801054c2:	83 c4 10             	add    $0x10,%esp
801054c5:	85 c0                	test   %eax,%eax
801054c7:	78 77                	js     80105540 <sys_chdir+0xa0>
801054c9:	83 ec 0c             	sub    $0xc,%esp
801054cc:	ff 75 f4             	push   -0xc(%ebp)
801054cf:	e8 4c cc ff ff       	call   80102120 <namei>
801054d4:	83 c4 10             	add    $0x10,%esp
801054d7:	89 c3                	mov    %eax,%ebx
801054d9:	85 c0                	test   %eax,%eax
801054db:	74 63                	je     80105540 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801054dd:	83 ec 0c             	sub    $0xc,%esp
801054e0:	50                   	push   %eax
801054e1:	e8 0a c3 ff ff       	call   801017f0 <ilock>
  if(ip->type != T_DIR){
801054e6:	83 c4 10             	add    $0x10,%esp
801054e9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054ee:	75 30                	jne    80105520 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801054f0:	83 ec 0c             	sub    $0xc,%esp
801054f3:	53                   	push   %ebx
801054f4:	e8 d7 c3 ff ff       	call   801018d0 <iunlock>
  iput(curproc->cwd);
801054f9:	58                   	pop    %eax
801054fa:	ff 76 68             	push   0x68(%esi)
801054fd:	e8 1e c4 ff ff       	call   80101920 <iput>
  end_op();
80105502:	e8 59 d9 ff ff       	call   80102e60 <end_op>
  curproc->cwd = ip;
80105507:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010550a:	83 c4 10             	add    $0x10,%esp
8010550d:	31 c0                	xor    %eax,%eax
}
8010550f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105512:	5b                   	pop    %ebx
80105513:	5e                   	pop    %esi
80105514:	5d                   	pop    %ebp
80105515:	c3                   	ret
80105516:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010551d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105520:	83 ec 0c             	sub    $0xc,%esp
80105523:	53                   	push   %ebx
80105524:	e8 57 c5 ff ff       	call   80101a80 <iunlockput>
    end_op();
80105529:	e8 32 d9 ff ff       	call   80102e60 <end_op>
    return -1;
8010552e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105531:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105536:	eb d7                	jmp    8010550f <sys_chdir+0x6f>
80105538:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010553f:	90                   	nop
    end_op();
80105540:	e8 1b d9 ff ff       	call   80102e60 <end_op>
    return -1;
80105545:	eb ea                	jmp    80105531 <sys_chdir+0x91>
80105547:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010554e:	66 90                	xchg   %ax,%ax

80105550 <sys_exec>:

int
sys_exec(void)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	57                   	push   %edi
80105554:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105555:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010555b:	53                   	push   %ebx
8010555c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105562:	50                   	push   %eax
80105563:	6a 00                	push   $0x0
80105565:	e8 36 f5 ff ff       	call   80104aa0 <argstr>
8010556a:	83 c4 10             	add    $0x10,%esp
8010556d:	85 c0                	test   %eax,%eax
8010556f:	0f 88 87 00 00 00    	js     801055fc <sys_exec+0xac>
80105575:	83 ec 08             	sub    $0x8,%esp
80105578:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010557e:	50                   	push   %eax
8010557f:	6a 01                	push   $0x1
80105581:	e8 5a f4 ff ff       	call   801049e0 <argint>
80105586:	83 c4 10             	add    $0x10,%esp
80105589:	85 c0                	test   %eax,%eax
8010558b:	78 6f                	js     801055fc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010558d:	83 ec 04             	sub    $0x4,%esp
80105590:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105596:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105598:	68 80 00 00 00       	push   $0x80
8010559d:	6a 00                	push   $0x0
8010559f:	56                   	push   %esi
801055a0:	e8 6b f1 ff ff       	call   80104710 <memset>
801055a5:	83 c4 10             	add    $0x10,%esp
801055a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055af:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801055b0:	83 ec 08             	sub    $0x8,%esp
801055b3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801055b9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801055c0:	50                   	push   %eax
801055c1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801055c7:	01 f8                	add    %edi,%eax
801055c9:	50                   	push   %eax
801055ca:	e8 61 f3 ff ff       	call   80104930 <fetchint>
801055cf:	83 c4 10             	add    $0x10,%esp
801055d2:	85 c0                	test   %eax,%eax
801055d4:	78 26                	js     801055fc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801055d6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801055dc:	85 c0                	test   %eax,%eax
801055de:	74 30                	je     80105610 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801055e0:	83 ec 08             	sub    $0x8,%esp
801055e3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801055e6:	52                   	push   %edx
801055e7:	50                   	push   %eax
801055e8:	e8 83 f3 ff ff       	call   80104970 <fetchstr>
801055ed:	83 c4 10             	add    $0x10,%esp
801055f0:	85 c0                	test   %eax,%eax
801055f2:	78 08                	js     801055fc <sys_exec+0xac>
  for(i=0;; i++){
801055f4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801055f7:	83 fb 20             	cmp    $0x20,%ebx
801055fa:	75 b4                	jne    801055b0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801055fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801055ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105604:	5b                   	pop    %ebx
80105605:	5e                   	pop    %esi
80105606:	5f                   	pop    %edi
80105607:	5d                   	pop    %ebp
80105608:	c3                   	ret
80105609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105610:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105617:	00 00 00 00 
  return exec(path, argv);
8010561b:	83 ec 08             	sub    $0x8,%esp
8010561e:	56                   	push   %esi
8010561f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105625:	e8 b6 b4 ff ff       	call   80100ae0 <exec>
8010562a:	83 c4 10             	add    $0x10,%esp
}
8010562d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105630:	5b                   	pop    %ebx
80105631:	5e                   	pop    %esi
80105632:	5f                   	pop    %edi
80105633:	5d                   	pop    %ebp
80105634:	c3                   	ret
80105635:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010563c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105640 <sys_pipe>:

int
sys_pipe(void)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	57                   	push   %edi
80105644:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105645:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105648:	53                   	push   %ebx
80105649:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010564c:	6a 08                	push   $0x8
8010564e:	50                   	push   %eax
8010564f:	6a 00                	push   $0x0
80105651:	e8 da f3 ff ff       	call   80104a30 <argptr>
80105656:	83 c4 10             	add    $0x10,%esp
80105659:	85 c0                	test   %eax,%eax
8010565b:	0f 88 8b 00 00 00    	js     801056ec <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105661:	83 ec 08             	sub    $0x8,%esp
80105664:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105667:	50                   	push   %eax
80105668:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010566b:	50                   	push   %eax
8010566c:	e8 5f de ff ff       	call   801034d0 <pipealloc>
80105671:	83 c4 10             	add    $0x10,%esp
80105674:	85 c0                	test   %eax,%eax
80105676:	78 74                	js     801056ec <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105678:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010567b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010567d:	e8 9e e3 ff ff       	call   80103a20 <myproc>
    if(curproc->ofile[fd] == 0){
80105682:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105686:	85 f6                	test   %esi,%esi
80105688:	74 16                	je     801056a0 <sys_pipe+0x60>
8010568a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105690:	83 c3 01             	add    $0x1,%ebx
80105693:	83 fb 10             	cmp    $0x10,%ebx
80105696:	74 3d                	je     801056d5 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
80105698:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010569c:	85 f6                	test   %esi,%esi
8010569e:	75 f0                	jne    80105690 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801056a0:	8d 73 08             	lea    0x8(%ebx),%esi
801056a3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801056a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801056aa:	e8 71 e3 ff ff       	call   80103a20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801056af:	31 d2                	xor    %edx,%edx
801056b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801056b8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801056bc:	85 c9                	test   %ecx,%ecx
801056be:	74 38                	je     801056f8 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
801056c0:	83 c2 01             	add    $0x1,%edx
801056c3:	83 fa 10             	cmp    $0x10,%edx
801056c6:	75 f0                	jne    801056b8 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801056c8:	e8 53 e3 ff ff       	call   80103a20 <myproc>
801056cd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801056d4:	00 
    fileclose(rf);
801056d5:	83 ec 0c             	sub    $0xc,%esp
801056d8:	ff 75 e0             	push   -0x20(%ebp)
801056db:	e8 60 b8 ff ff       	call   80100f40 <fileclose>
    fileclose(wf);
801056e0:	58                   	pop    %eax
801056e1:	ff 75 e4             	push   -0x1c(%ebp)
801056e4:	e8 57 b8 ff ff       	call   80100f40 <fileclose>
    return -1;
801056e9:	83 c4 10             	add    $0x10,%esp
    return -1;
801056ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056f1:	eb 16                	jmp    80105709 <sys_pipe+0xc9>
801056f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056f7:	90                   	nop
      curproc->ofile[fd] = f;
801056f8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801056fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056ff:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105701:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105704:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105707:	31 c0                	xor    %eax,%eax
}
80105709:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010570c:	5b                   	pop    %ebx
8010570d:	5e                   	pop    %esi
8010570e:	5f                   	pop    %edi
8010570f:	5d                   	pop    %ebp
80105710:	c3                   	ret
80105711:	66 90                	xchg   %ax,%ax
80105713:	66 90                	xchg   %ax,%ax
80105715:	66 90                	xchg   %ax,%ax
80105717:	66 90                	xchg   %ax,%ax
80105719:	66 90                	xchg   %ax,%ax
8010571b:	66 90                	xchg   %ax,%ax
8010571d:	66 90                	xchg   %ax,%ax
8010571f:	90                   	nop

80105720 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105720:	e9 9b e4 ff ff       	jmp    80103bc0 <fork>
80105725:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010572c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105730 <sys_exit>:
}

int
sys_exit(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	83 ec 08             	sub    $0x8,%esp
  exit();
80105736:	e8 05 e7 ff ff       	call   80103e40 <exit>
  return 0;  // not reached
}
8010573b:	31 c0                	xor    %eax,%eax
8010573d:	c9                   	leave
8010573e:	c3                   	ret
8010573f:	90                   	nop

80105740 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105740:	e9 2b e8 ff ff       	jmp    80103f70 <wait>
80105745:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010574c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105750 <sys_kill>:
}

int
sys_kill(void)
{
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105756:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105759:	50                   	push   %eax
8010575a:	6a 00                	push   $0x0
8010575c:	e8 7f f2 ff ff       	call   801049e0 <argint>
80105761:	83 c4 10             	add    $0x10,%esp
80105764:	85 c0                	test   %eax,%eax
80105766:	78 18                	js     80105780 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105768:	83 ec 0c             	sub    $0xc,%esp
8010576b:	ff 75 f4             	push   -0xc(%ebp)
8010576e:	e8 9d ea ff ff       	call   80104210 <kill>
80105773:	83 c4 10             	add    $0x10,%esp
}
80105776:	c9                   	leave
80105777:	c3                   	ret
80105778:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010577f:	90                   	nop
80105780:	c9                   	leave
    return -1;
80105781:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105786:	c3                   	ret
80105787:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010578e:	66 90                	xchg   %ax,%ax

80105790 <sys_getpid>:

int
sys_getpid(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105796:	e8 85 e2 ff ff       	call   80103a20 <myproc>
8010579b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010579e:	c9                   	leave
8010579f:	c3                   	ret

801057a0 <sys_sbrk>:

int
sys_sbrk(void)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801057a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057a7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057aa:	50                   	push   %eax
801057ab:	6a 00                	push   $0x0
801057ad:	e8 2e f2 ff ff       	call   801049e0 <argint>
801057b2:	83 c4 10             	add    $0x10,%esp
801057b5:	85 c0                	test   %eax,%eax
801057b7:	78 27                	js     801057e0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801057b9:	e8 62 e2 ff ff       	call   80103a20 <myproc>
  if(growproc(n) < 0)
801057be:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801057c1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801057c3:	ff 75 f4             	push   -0xc(%ebp)
801057c6:	e8 75 e3 ff ff       	call   80103b40 <growproc>
801057cb:	83 c4 10             	add    $0x10,%esp
801057ce:	85 c0                	test   %eax,%eax
801057d0:	78 0e                	js     801057e0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801057d2:	89 d8                	mov    %ebx,%eax
801057d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057d7:	c9                   	leave
801057d8:	c3                   	ret
801057d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801057e0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801057e5:	eb eb                	jmp    801057d2 <sys_sbrk+0x32>
801057e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ee:	66 90                	xchg   %ax,%ax

801057f0 <sys_sleep>:

int
sys_sleep(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801057f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057f7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057fa:	50                   	push   %eax
801057fb:	6a 00                	push   $0x0
801057fd:	e8 de f1 ff ff       	call   801049e0 <argint>
80105802:	83 c4 10             	add    $0x10,%esp
80105805:	85 c0                	test   %eax,%eax
80105807:	78 64                	js     8010586d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105809:	83 ec 0c             	sub    $0xc,%esp
8010580c:	68 80 3c 11 80       	push   $0x80113c80
80105811:	e8 6a ed ff ff       	call   80104580 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105816:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105819:	8b 1d 60 3c 11 80    	mov    0x80113c60,%ebx
  while(ticks - ticks0 < n){
8010581f:	83 c4 10             	add    $0x10,%esp
80105822:	85 d2                	test   %edx,%edx
80105824:	75 2b                	jne    80105851 <sys_sleep+0x61>
80105826:	eb 58                	jmp    80105880 <sys_sleep+0x90>
80105828:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010582f:	90                   	nop
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105830:	83 ec 08             	sub    $0x8,%esp
80105833:	68 80 3c 11 80       	push   $0x80113c80
80105838:	68 60 3c 11 80       	push   $0x80113c60
8010583d:	e8 ae e8 ff ff       	call   801040f0 <sleep>
  while(ticks - ticks0 < n){
80105842:	a1 60 3c 11 80       	mov    0x80113c60,%eax
80105847:	83 c4 10             	add    $0x10,%esp
8010584a:	29 d8                	sub    %ebx,%eax
8010584c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010584f:	73 2f                	jae    80105880 <sys_sleep+0x90>
    if(myproc()->killed){
80105851:	e8 ca e1 ff ff       	call   80103a20 <myproc>
80105856:	8b 40 24             	mov    0x24(%eax),%eax
80105859:	85 c0                	test   %eax,%eax
8010585b:	74 d3                	je     80105830 <sys_sleep+0x40>
      release(&tickslock);
8010585d:	83 ec 0c             	sub    $0xc,%esp
80105860:	68 80 3c 11 80       	push   $0x80113c80
80105865:	e8 56 ee ff ff       	call   801046c0 <release>
      return -1;
8010586a:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
8010586d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105870:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105875:	c9                   	leave
80105876:	c3                   	ret
80105877:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010587e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105880:	83 ec 0c             	sub    $0xc,%esp
80105883:	68 80 3c 11 80       	push   $0x80113c80
80105888:	e8 33 ee ff ff       	call   801046c0 <release>
}
8010588d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105890:	83 c4 10             	add    $0x10,%esp
80105893:	31 c0                	xor    %eax,%eax
}
80105895:	c9                   	leave
80105896:	c3                   	ret
80105897:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010589e:	66 90                	xchg   %ax,%ax

801058a0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	53                   	push   %ebx
801058a4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801058a7:	68 80 3c 11 80       	push   $0x80113c80
801058ac:	e8 cf ec ff ff       	call   80104580 <acquire>
  xticks = ticks;
801058b1:	8b 1d 60 3c 11 80    	mov    0x80113c60,%ebx
  release(&tickslock);
801058b7:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
801058be:	e8 fd ed ff ff       	call   801046c0 <release>
  return xticks;
}
801058c3:	89 d8                	mov    %ebx,%eax
801058c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058c8:	c9                   	leave
801058c9:	c3                   	ret

801058ca <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801058ca:	1e                   	push   %ds
  pushl %es
801058cb:	06                   	push   %es
  pushl %fs
801058cc:	0f a0                	push   %fs
  pushl %gs
801058ce:	0f a8                	push   %gs
  pushal
801058d0:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801058d1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801058d5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801058d7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801058d9:	54                   	push   %esp
  call trap
801058da:	e8 c1 00 00 00       	call   801059a0 <trap>
  addl $4, %esp
801058df:	83 c4 04             	add    $0x4,%esp

801058e2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801058e2:	61                   	popa
  popl %gs
801058e3:	0f a9                	pop    %gs
  popl %fs
801058e5:	0f a1                	pop    %fs
  popl %es
801058e7:	07                   	pop    %es
  popl %ds
801058e8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801058e9:	83 c4 08             	add    $0x8,%esp
  iret
801058ec:	cf                   	iret
801058ed:	66 90                	xchg   %ax,%ax
801058ef:	90                   	nop

801058f0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801058f0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801058f1:	31 c0                	xor    %eax,%eax
{
801058f3:	89 e5                	mov    %esp,%ebp
801058f5:	83 ec 08             	sub    $0x8,%esp
801058f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ff:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105900:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105907:	c7 04 c5 c2 3c 11 80 	movl   $0x8e000008,-0x7feec33e(,%eax,8)
8010590e:	08 00 00 8e 
80105912:	66 89 14 c5 c0 3c 11 	mov    %dx,-0x7feec340(,%eax,8)
80105919:	80 
8010591a:	c1 ea 10             	shr    $0x10,%edx
8010591d:	66 89 14 c5 c6 3c 11 	mov    %dx,-0x7feec33a(,%eax,8)
80105924:	80 
  for(i = 0; i < 256; i++)
80105925:	83 c0 01             	add    $0x1,%eax
80105928:	3d 00 01 00 00       	cmp    $0x100,%eax
8010592d:	75 d1                	jne    80105900 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010592f:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105934:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105937:	c7 05 c2 3e 11 80 08 	movl   $0xef000008,0x80113ec2
8010593e:	00 00 ef 
80105941:	66 a3 c0 3e 11 80    	mov    %ax,0x80113ec0
80105947:	c1 e8 10             	shr    $0x10,%eax
8010594a:	66 a3 c6 3e 11 80    	mov    %ax,0x80113ec6
  initlock(&tickslock, "time");
80105950:	68 99 79 10 80       	push   $0x80107999
80105955:	68 80 3c 11 80       	push   $0x80113c80
8010595a:	e8 01 eb ff ff       	call   80104460 <initlock>
}
8010595f:	83 c4 10             	add    $0x10,%esp
80105962:	c9                   	leave
80105963:	c3                   	ret
80105964:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010596b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010596f:	90                   	nop

80105970 <idtinit>:

void
idtinit(void)
{
80105970:	55                   	push   %ebp
  pd[0] = size-1;
80105971:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105976:	89 e5                	mov    %esp,%ebp
80105978:	83 ec 10             	sub    $0x10,%esp
8010597b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010597f:	b8 c0 3c 11 80       	mov    $0x80113cc0,%eax
80105984:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105988:	c1 e8 10             	shr    $0x10,%eax
8010598b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010598f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105992:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105995:	c9                   	leave
80105996:	c3                   	ret
80105997:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010599e:	66 90                	xchg   %ax,%ax

801059a0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	57                   	push   %edi
801059a4:	56                   	push   %esi
801059a5:	53                   	push   %ebx
801059a6:	83 ec 1c             	sub    $0x1c,%esp
801059a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801059ac:	8b 43 30             	mov    0x30(%ebx),%eax
801059af:	83 f8 40             	cmp    $0x40,%eax
801059b2:	0f 84 68 01 00 00    	je     80105b20 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801059b8:	83 e8 20             	sub    $0x20,%eax
801059bb:	83 f8 1f             	cmp    $0x1f,%eax
801059be:	0f 87 8c 00 00 00    	ja     80105a50 <trap+0xb0>
801059c4:	ff 24 85 40 7a 10 80 	jmp    *-0x7fef85c0(,%eax,4)
801059cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059cf:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801059d0:	e8 fb c8 ff ff       	call   801022d0 <ideintr>
    lapiceoi();
801059d5:	e8 c6 cf ff ff       	call   801029a0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059da:	e8 41 e0 ff ff       	call   80103a20 <myproc>
801059df:	85 c0                	test   %eax,%eax
801059e1:	74 1d                	je     80105a00 <trap+0x60>
801059e3:	e8 38 e0 ff ff       	call   80103a20 <myproc>
801059e8:	8b 50 24             	mov    0x24(%eax),%edx
801059eb:	85 d2                	test   %edx,%edx
801059ed:	74 11                	je     80105a00 <trap+0x60>
801059ef:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801059f3:	83 e0 03             	and    $0x3,%eax
801059f6:	66 83 f8 03          	cmp    $0x3,%ax
801059fa:	0f 84 e8 01 00 00    	je     80105be8 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105a00:	e8 1b e0 ff ff       	call   80103a20 <myproc>
80105a05:	85 c0                	test   %eax,%eax
80105a07:	74 0f                	je     80105a18 <trap+0x78>
80105a09:	e8 12 e0 ff ff       	call   80103a20 <myproc>
80105a0e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105a12:	0f 84 b8 00 00 00    	je     80105ad0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a18:	e8 03 e0 ff ff       	call   80103a20 <myproc>
80105a1d:	85 c0                	test   %eax,%eax
80105a1f:	74 1d                	je     80105a3e <trap+0x9e>
80105a21:	e8 fa df ff ff       	call   80103a20 <myproc>
80105a26:	8b 40 24             	mov    0x24(%eax),%eax
80105a29:	85 c0                	test   %eax,%eax
80105a2b:	74 11                	je     80105a3e <trap+0x9e>
80105a2d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a31:	83 e0 03             	and    $0x3,%eax
80105a34:	66 83 f8 03          	cmp    $0x3,%ax
80105a38:	0f 84 0f 01 00 00    	je     80105b4d <trap+0x1ad>
    exit();
}
80105a3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a41:	5b                   	pop    %ebx
80105a42:	5e                   	pop    %esi
80105a43:	5f                   	pop    %edi
80105a44:	5d                   	pop    %ebp
80105a45:	c3                   	ret
80105a46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a4d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105a50:	e8 cb df ff ff       	call   80103a20 <myproc>
80105a55:	8b 7b 38             	mov    0x38(%ebx),%edi
80105a58:	85 c0                	test   %eax,%eax
80105a5a:	0f 84 a2 01 00 00    	je     80105c02 <trap+0x262>
80105a60:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105a64:	0f 84 98 01 00 00    	je     80105c02 <trap+0x262>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105a6a:	0f 20 d1             	mov    %cr2,%ecx
80105a6d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a70:	e8 8b df ff ff       	call   80103a00 <cpuid>
80105a75:	8b 73 30             	mov    0x30(%ebx),%esi
80105a78:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105a7b:	8b 43 34             	mov    0x34(%ebx),%eax
80105a7e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105a81:	e8 9a df ff ff       	call   80103a20 <myproc>
80105a86:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a89:	e8 92 df ff ff       	call   80103a20 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a8e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105a91:	51                   	push   %ecx
80105a92:	57                   	push   %edi
80105a93:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105a96:	52                   	push   %edx
80105a97:	ff 75 e4             	push   -0x1c(%ebp)
80105a9a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105a9b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105a9e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105aa1:	56                   	push   %esi
80105aa2:	ff 70 10             	push   0x10(%eax)
80105aa5:	68 fc 79 10 80       	push   $0x801079fc
80105aaa:	e8 01 ac ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
80105aaf:	83 c4 20             	add    $0x20,%esp
80105ab2:	e8 69 df ff ff       	call   80103a20 <myproc>
80105ab7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105abe:	e8 5d df ff ff       	call   80103a20 <myproc>
80105ac3:	85 c0                	test   %eax,%eax
80105ac5:	0f 85 18 ff ff ff    	jne    801059e3 <trap+0x43>
80105acb:	e9 30 ff ff ff       	jmp    80105a00 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105ad0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105ad4:	0f 85 3e ff ff ff    	jne    80105a18 <trap+0x78>
    yield();
80105ada:	e8 c1 e5 ff ff       	call   801040a0 <yield>
80105adf:	e9 34 ff ff ff       	jmp    80105a18 <trap+0x78>
80105ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105ae8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105aeb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105aef:	e8 0c df ff ff       	call   80103a00 <cpuid>
80105af4:	57                   	push   %edi
80105af5:	56                   	push   %esi
80105af6:	50                   	push   %eax
80105af7:	68 a4 79 10 80       	push   $0x801079a4
80105afc:	e8 af ab ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105b01:	e8 9a ce ff ff       	call   801029a0 <lapiceoi>
    break;
80105b06:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b09:	e8 12 df ff ff       	call   80103a20 <myproc>
80105b0e:	85 c0                	test   %eax,%eax
80105b10:	0f 85 cd fe ff ff    	jne    801059e3 <trap+0x43>
80105b16:	e9 e5 fe ff ff       	jmp    80105a00 <trap+0x60>
80105b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b1f:	90                   	nop
    if(myproc()->killed)
80105b20:	e8 fb de ff ff       	call   80103a20 <myproc>
80105b25:	8b 70 24             	mov    0x24(%eax),%esi
80105b28:	85 f6                	test   %esi,%esi
80105b2a:	0f 85 c8 00 00 00    	jne    80105bf8 <trap+0x258>
    myproc()->tf = tf;
80105b30:	e8 eb de ff ff       	call   80103a20 <myproc>
80105b35:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105b38:	e8 e3 ef ff ff       	call   80104b20 <syscall>
    if(myproc()->killed)
80105b3d:	e8 de de ff ff       	call   80103a20 <myproc>
80105b42:	8b 48 24             	mov    0x24(%eax),%ecx
80105b45:	85 c9                	test   %ecx,%ecx
80105b47:	0f 84 f1 fe ff ff    	je     80105a3e <trap+0x9e>
}
80105b4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b50:	5b                   	pop    %ebx
80105b51:	5e                   	pop    %esi
80105b52:	5f                   	pop    %edi
80105b53:	5d                   	pop    %ebp
      exit();
80105b54:	e9 e7 e2 ff ff       	jmp    80103e40 <exit>
80105b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105b60:	e8 4b 02 00 00       	call   80105db0 <uartintr>
    lapiceoi();
80105b65:	e8 36 ce ff ff       	call   801029a0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b6a:	e8 b1 de ff ff       	call   80103a20 <myproc>
80105b6f:	85 c0                	test   %eax,%eax
80105b71:	0f 85 6c fe ff ff    	jne    801059e3 <trap+0x43>
80105b77:	e9 84 fe ff ff       	jmp    80105a00 <trap+0x60>
80105b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105b80:	e8 db cc ff ff       	call   80102860 <kbdintr>
    lapiceoi();
80105b85:	e8 16 ce ff ff       	call   801029a0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b8a:	e8 91 de ff ff       	call   80103a20 <myproc>
80105b8f:	85 c0                	test   %eax,%eax
80105b91:	0f 85 4c fe ff ff    	jne    801059e3 <trap+0x43>
80105b97:	e9 64 fe ff ff       	jmp    80105a00 <trap+0x60>
80105b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105ba0:	e8 5b de ff ff       	call   80103a00 <cpuid>
80105ba5:	85 c0                	test   %eax,%eax
80105ba7:	0f 85 28 fe ff ff    	jne    801059d5 <trap+0x35>
      acquire(&tickslock);
80105bad:	83 ec 0c             	sub    $0xc,%esp
80105bb0:	68 80 3c 11 80       	push   $0x80113c80
80105bb5:	e8 c6 e9 ff ff       	call   80104580 <acquire>
      ticks++;
80105bba:	83 05 60 3c 11 80 01 	addl   $0x1,0x80113c60
      wakeup(&ticks);
80105bc1:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
80105bc8:	e8 e3 e5 ff ff       	call   801041b0 <wakeup>
      release(&tickslock);
80105bcd:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
80105bd4:	e8 e7 ea ff ff       	call   801046c0 <release>
80105bd9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105bdc:	e9 f4 fd ff ff       	jmp    801059d5 <trap+0x35>
80105be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105be8:	e8 53 e2 ff ff       	call   80103e40 <exit>
80105bed:	e9 0e fe ff ff       	jmp    80105a00 <trap+0x60>
80105bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105bf8:	e8 43 e2 ff ff       	call   80103e40 <exit>
80105bfd:	e9 2e ff ff ff       	jmp    80105b30 <trap+0x190>
80105c02:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105c05:	e8 f6 dd ff ff       	call   80103a00 <cpuid>
80105c0a:	83 ec 0c             	sub    $0xc,%esp
80105c0d:	56                   	push   %esi
80105c0e:	57                   	push   %edi
80105c0f:	50                   	push   %eax
80105c10:	ff 73 30             	push   0x30(%ebx)
80105c13:	68 c8 79 10 80       	push   $0x801079c8
80105c18:	e8 93 aa ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105c1d:	83 c4 14             	add    $0x14,%esp
80105c20:	68 9e 79 10 80       	push   $0x8010799e
80105c25:	e8 56 a7 ff ff       	call   80100380 <panic>
80105c2a:	66 90                	xchg   %ax,%ax
80105c2c:	66 90                	xchg   %ax,%ax
80105c2e:	66 90                	xchg   %ax,%ax

80105c30 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105c30:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105c35:	85 c0                	test   %eax,%eax
80105c37:	74 17                	je     80105c50 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c39:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c3e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105c3f:	a8 01                	test   $0x1,%al
80105c41:	74 0d                	je     80105c50 <uartgetc+0x20>
80105c43:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c48:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105c49:	0f b6 c0             	movzbl %al,%eax
80105c4c:	c3                   	ret
80105c4d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c55:	c3                   	ret
80105c56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c5d:	8d 76 00             	lea    0x0(%esi),%esi

80105c60 <uartinit>:
{
80105c60:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105c61:	31 c9                	xor    %ecx,%ecx
80105c63:	89 c8                	mov    %ecx,%eax
80105c65:	89 e5                	mov    %esp,%ebp
80105c67:	57                   	push   %edi
80105c68:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105c6d:	56                   	push   %esi
80105c6e:	89 fa                	mov    %edi,%edx
80105c70:	53                   	push   %ebx
80105c71:	83 ec 1c             	sub    $0x1c,%esp
80105c74:	ee                   	out    %al,(%dx)
80105c75:	be fb 03 00 00       	mov    $0x3fb,%esi
80105c7a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105c7f:	89 f2                	mov    %esi,%edx
80105c81:	ee                   	out    %al,(%dx)
80105c82:	b8 0c 00 00 00       	mov    $0xc,%eax
80105c87:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c8c:	ee                   	out    %al,(%dx)
80105c8d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105c92:	89 c8                	mov    %ecx,%eax
80105c94:	89 da                	mov    %ebx,%edx
80105c96:	ee                   	out    %al,(%dx)
80105c97:	b8 03 00 00 00       	mov    $0x3,%eax
80105c9c:	89 f2                	mov    %esi,%edx
80105c9e:	ee                   	out    %al,(%dx)
80105c9f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105ca4:	89 c8                	mov    %ecx,%eax
80105ca6:	ee                   	out    %al,(%dx)
80105ca7:	b8 01 00 00 00       	mov    $0x1,%eax
80105cac:	89 da                	mov    %ebx,%edx
80105cae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105caf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105cb4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105cb5:	3c ff                	cmp    $0xff,%al
80105cb7:	0f 84 7c 00 00 00    	je     80105d39 <uartinit+0xd9>
  uart = 1;
80105cbd:	c7 05 c0 44 11 80 01 	movl   $0x1,0x801144c0
80105cc4:	00 00 00 
80105cc7:	89 fa                	mov    %edi,%edx
80105cc9:	ec                   	in     (%dx),%al
80105cca:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ccf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105cd0:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105cd3:	bf c0 7a 10 80       	mov    $0x80107ac0,%edi
80105cd8:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105cdd:	6a 00                	push   $0x0
80105cdf:	6a 04                	push   $0x4
80105ce1:	e8 1a c8 ff ff       	call   80102500 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105ce6:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105cea:	83 c4 10             	add    $0x10,%esp
80105ced:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80105cf0:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105cf5:	85 c0                	test   %eax,%eax
80105cf7:	74 32                	je     80105d2b <uartinit+0xcb>
80105cf9:	89 f2                	mov    %esi,%edx
80105cfb:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105cfc:	a8 20                	test   $0x20,%al
80105cfe:	75 21                	jne    80105d21 <uartinit+0xc1>
80105d00:	bb 80 00 00 00       	mov    $0x80,%ebx
80105d05:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105d08:	83 ec 0c             	sub    $0xc,%esp
80105d0b:	6a 0a                	push   $0xa
80105d0d:	e8 ae cc ff ff       	call   801029c0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105d12:	83 c4 10             	add    $0x10,%esp
80105d15:	83 eb 01             	sub    $0x1,%ebx
80105d18:	74 07                	je     80105d21 <uartinit+0xc1>
80105d1a:	89 f2                	mov    %esi,%edx
80105d1c:	ec                   	in     (%dx),%al
80105d1d:	a8 20                	test   $0x20,%al
80105d1f:	74 e7                	je     80105d08 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105d21:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d26:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105d2a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105d2b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105d2f:	83 c7 01             	add    $0x1,%edi
80105d32:	88 45 e7             	mov    %al,-0x19(%ebp)
80105d35:	84 c0                	test   %al,%al
80105d37:	75 b7                	jne    80105cf0 <uartinit+0x90>
}
80105d39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d3c:	5b                   	pop    %ebx
80105d3d:	5e                   	pop    %esi
80105d3e:	5f                   	pop    %edi
80105d3f:	5d                   	pop    %ebp
80105d40:	c3                   	ret
80105d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d4f:	90                   	nop

80105d50 <uartputc>:
  if(!uart)
80105d50:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105d55:	85 c0                	test   %eax,%eax
80105d57:	74 4f                	je     80105da8 <uartputc+0x58>
{
80105d59:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d5a:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d5f:	89 e5                	mov    %esp,%ebp
80105d61:	56                   	push   %esi
80105d62:	53                   	push   %ebx
80105d63:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105d64:	a8 20                	test   $0x20,%al
80105d66:	75 29                	jne    80105d91 <uartputc+0x41>
80105d68:	bb 80 00 00 00       	mov    $0x80,%ebx
80105d6d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105d78:	83 ec 0c             	sub    $0xc,%esp
80105d7b:	6a 0a                	push   $0xa
80105d7d:	e8 3e cc ff ff       	call   801029c0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105d82:	83 c4 10             	add    $0x10,%esp
80105d85:	83 eb 01             	sub    $0x1,%ebx
80105d88:	74 07                	je     80105d91 <uartputc+0x41>
80105d8a:	89 f2                	mov    %esi,%edx
80105d8c:	ec                   	in     (%dx),%al
80105d8d:	a8 20                	test   $0x20,%al
80105d8f:	74 e7                	je     80105d78 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105d91:	8b 45 08             	mov    0x8(%ebp),%eax
80105d94:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d99:	ee                   	out    %al,(%dx)
}
80105d9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d9d:	5b                   	pop    %ebx
80105d9e:	5e                   	pop    %esi
80105d9f:	5d                   	pop    %ebp
80105da0:	c3                   	ret
80105da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105da8:	c3                   	ret
80105da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105db0 <uartintr>:

void
uartintr(void)
{
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105db6:	68 30 5c 10 80       	push   $0x80105c30
80105dbb:	e8 00 ab ff ff       	call   801008c0 <consoleintr>
}
80105dc0:	83 c4 10             	add    $0x10,%esp
80105dc3:	c9                   	leave
80105dc4:	c3                   	ret

80105dc5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105dc5:	6a 00                	push   $0x0
  pushl $0
80105dc7:	6a 00                	push   $0x0
  jmp alltraps
80105dc9:	e9 fc fa ff ff       	jmp    801058ca <alltraps>

80105dce <vector1>:
.globl vector1
vector1:
  pushl $0
80105dce:	6a 00                	push   $0x0
  pushl $1
80105dd0:	6a 01                	push   $0x1
  jmp alltraps
80105dd2:	e9 f3 fa ff ff       	jmp    801058ca <alltraps>

80105dd7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105dd7:	6a 00                	push   $0x0
  pushl $2
80105dd9:	6a 02                	push   $0x2
  jmp alltraps
80105ddb:	e9 ea fa ff ff       	jmp    801058ca <alltraps>

80105de0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105de0:	6a 00                	push   $0x0
  pushl $3
80105de2:	6a 03                	push   $0x3
  jmp alltraps
80105de4:	e9 e1 fa ff ff       	jmp    801058ca <alltraps>

80105de9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105de9:	6a 00                	push   $0x0
  pushl $4
80105deb:	6a 04                	push   $0x4
  jmp alltraps
80105ded:	e9 d8 fa ff ff       	jmp    801058ca <alltraps>

80105df2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105df2:	6a 00                	push   $0x0
  pushl $5
80105df4:	6a 05                	push   $0x5
  jmp alltraps
80105df6:	e9 cf fa ff ff       	jmp    801058ca <alltraps>

80105dfb <vector6>:
.globl vector6
vector6:
  pushl $0
80105dfb:	6a 00                	push   $0x0
  pushl $6
80105dfd:	6a 06                	push   $0x6
  jmp alltraps
80105dff:	e9 c6 fa ff ff       	jmp    801058ca <alltraps>

80105e04 <vector7>:
.globl vector7
vector7:
  pushl $0
80105e04:	6a 00                	push   $0x0
  pushl $7
80105e06:	6a 07                	push   $0x7
  jmp alltraps
80105e08:	e9 bd fa ff ff       	jmp    801058ca <alltraps>

80105e0d <vector8>:
.globl vector8
vector8:
  pushl $8
80105e0d:	6a 08                	push   $0x8
  jmp alltraps
80105e0f:	e9 b6 fa ff ff       	jmp    801058ca <alltraps>

80105e14 <vector9>:
.globl vector9
vector9:
  pushl $0
80105e14:	6a 00                	push   $0x0
  pushl $9
80105e16:	6a 09                	push   $0x9
  jmp alltraps
80105e18:	e9 ad fa ff ff       	jmp    801058ca <alltraps>

80105e1d <vector10>:
.globl vector10
vector10:
  pushl $10
80105e1d:	6a 0a                	push   $0xa
  jmp alltraps
80105e1f:	e9 a6 fa ff ff       	jmp    801058ca <alltraps>

80105e24 <vector11>:
.globl vector11
vector11:
  pushl $11
80105e24:	6a 0b                	push   $0xb
  jmp alltraps
80105e26:	e9 9f fa ff ff       	jmp    801058ca <alltraps>

80105e2b <vector12>:
.globl vector12
vector12:
  pushl $12
80105e2b:	6a 0c                	push   $0xc
  jmp alltraps
80105e2d:	e9 98 fa ff ff       	jmp    801058ca <alltraps>

80105e32 <vector13>:
.globl vector13
vector13:
  pushl $13
80105e32:	6a 0d                	push   $0xd
  jmp alltraps
80105e34:	e9 91 fa ff ff       	jmp    801058ca <alltraps>

80105e39 <vector14>:
.globl vector14
vector14:
  pushl $14
80105e39:	6a 0e                	push   $0xe
  jmp alltraps
80105e3b:	e9 8a fa ff ff       	jmp    801058ca <alltraps>

80105e40 <vector15>:
.globl vector15
vector15:
  pushl $0
80105e40:	6a 00                	push   $0x0
  pushl $15
80105e42:	6a 0f                	push   $0xf
  jmp alltraps
80105e44:	e9 81 fa ff ff       	jmp    801058ca <alltraps>

80105e49 <vector16>:
.globl vector16
vector16:
  pushl $0
80105e49:	6a 00                	push   $0x0
  pushl $16
80105e4b:	6a 10                	push   $0x10
  jmp alltraps
80105e4d:	e9 78 fa ff ff       	jmp    801058ca <alltraps>

80105e52 <vector17>:
.globl vector17
vector17:
  pushl $17
80105e52:	6a 11                	push   $0x11
  jmp alltraps
80105e54:	e9 71 fa ff ff       	jmp    801058ca <alltraps>

80105e59 <vector18>:
.globl vector18
vector18:
  pushl $0
80105e59:	6a 00                	push   $0x0
  pushl $18
80105e5b:	6a 12                	push   $0x12
  jmp alltraps
80105e5d:	e9 68 fa ff ff       	jmp    801058ca <alltraps>

80105e62 <vector19>:
.globl vector19
vector19:
  pushl $0
80105e62:	6a 00                	push   $0x0
  pushl $19
80105e64:	6a 13                	push   $0x13
  jmp alltraps
80105e66:	e9 5f fa ff ff       	jmp    801058ca <alltraps>

80105e6b <vector20>:
.globl vector20
vector20:
  pushl $0
80105e6b:	6a 00                	push   $0x0
  pushl $20
80105e6d:	6a 14                	push   $0x14
  jmp alltraps
80105e6f:	e9 56 fa ff ff       	jmp    801058ca <alltraps>

80105e74 <vector21>:
.globl vector21
vector21:
  pushl $0
80105e74:	6a 00                	push   $0x0
  pushl $21
80105e76:	6a 15                	push   $0x15
  jmp alltraps
80105e78:	e9 4d fa ff ff       	jmp    801058ca <alltraps>

80105e7d <vector22>:
.globl vector22
vector22:
  pushl $0
80105e7d:	6a 00                	push   $0x0
  pushl $22
80105e7f:	6a 16                	push   $0x16
  jmp alltraps
80105e81:	e9 44 fa ff ff       	jmp    801058ca <alltraps>

80105e86 <vector23>:
.globl vector23
vector23:
  pushl $0
80105e86:	6a 00                	push   $0x0
  pushl $23
80105e88:	6a 17                	push   $0x17
  jmp alltraps
80105e8a:	e9 3b fa ff ff       	jmp    801058ca <alltraps>

80105e8f <vector24>:
.globl vector24
vector24:
  pushl $0
80105e8f:	6a 00                	push   $0x0
  pushl $24
80105e91:	6a 18                	push   $0x18
  jmp alltraps
80105e93:	e9 32 fa ff ff       	jmp    801058ca <alltraps>

80105e98 <vector25>:
.globl vector25
vector25:
  pushl $0
80105e98:	6a 00                	push   $0x0
  pushl $25
80105e9a:	6a 19                	push   $0x19
  jmp alltraps
80105e9c:	e9 29 fa ff ff       	jmp    801058ca <alltraps>

80105ea1 <vector26>:
.globl vector26
vector26:
  pushl $0
80105ea1:	6a 00                	push   $0x0
  pushl $26
80105ea3:	6a 1a                	push   $0x1a
  jmp alltraps
80105ea5:	e9 20 fa ff ff       	jmp    801058ca <alltraps>

80105eaa <vector27>:
.globl vector27
vector27:
  pushl $0
80105eaa:	6a 00                	push   $0x0
  pushl $27
80105eac:	6a 1b                	push   $0x1b
  jmp alltraps
80105eae:	e9 17 fa ff ff       	jmp    801058ca <alltraps>

80105eb3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105eb3:	6a 00                	push   $0x0
  pushl $28
80105eb5:	6a 1c                	push   $0x1c
  jmp alltraps
80105eb7:	e9 0e fa ff ff       	jmp    801058ca <alltraps>

80105ebc <vector29>:
.globl vector29
vector29:
  pushl $0
80105ebc:	6a 00                	push   $0x0
  pushl $29
80105ebe:	6a 1d                	push   $0x1d
  jmp alltraps
80105ec0:	e9 05 fa ff ff       	jmp    801058ca <alltraps>

80105ec5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105ec5:	6a 00                	push   $0x0
  pushl $30
80105ec7:	6a 1e                	push   $0x1e
  jmp alltraps
80105ec9:	e9 fc f9 ff ff       	jmp    801058ca <alltraps>

80105ece <vector31>:
.globl vector31
vector31:
  pushl $0
80105ece:	6a 00                	push   $0x0
  pushl $31
80105ed0:	6a 1f                	push   $0x1f
  jmp alltraps
80105ed2:	e9 f3 f9 ff ff       	jmp    801058ca <alltraps>

80105ed7 <vector32>:
.globl vector32
vector32:
  pushl $0
80105ed7:	6a 00                	push   $0x0
  pushl $32
80105ed9:	6a 20                	push   $0x20
  jmp alltraps
80105edb:	e9 ea f9 ff ff       	jmp    801058ca <alltraps>

80105ee0 <vector33>:
.globl vector33
vector33:
  pushl $0
80105ee0:	6a 00                	push   $0x0
  pushl $33
80105ee2:	6a 21                	push   $0x21
  jmp alltraps
80105ee4:	e9 e1 f9 ff ff       	jmp    801058ca <alltraps>

80105ee9 <vector34>:
.globl vector34
vector34:
  pushl $0
80105ee9:	6a 00                	push   $0x0
  pushl $34
80105eeb:	6a 22                	push   $0x22
  jmp alltraps
80105eed:	e9 d8 f9 ff ff       	jmp    801058ca <alltraps>

80105ef2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105ef2:	6a 00                	push   $0x0
  pushl $35
80105ef4:	6a 23                	push   $0x23
  jmp alltraps
80105ef6:	e9 cf f9 ff ff       	jmp    801058ca <alltraps>

80105efb <vector36>:
.globl vector36
vector36:
  pushl $0
80105efb:	6a 00                	push   $0x0
  pushl $36
80105efd:	6a 24                	push   $0x24
  jmp alltraps
80105eff:	e9 c6 f9 ff ff       	jmp    801058ca <alltraps>

80105f04 <vector37>:
.globl vector37
vector37:
  pushl $0
80105f04:	6a 00                	push   $0x0
  pushl $37
80105f06:	6a 25                	push   $0x25
  jmp alltraps
80105f08:	e9 bd f9 ff ff       	jmp    801058ca <alltraps>

80105f0d <vector38>:
.globl vector38
vector38:
  pushl $0
80105f0d:	6a 00                	push   $0x0
  pushl $38
80105f0f:	6a 26                	push   $0x26
  jmp alltraps
80105f11:	e9 b4 f9 ff ff       	jmp    801058ca <alltraps>

80105f16 <vector39>:
.globl vector39
vector39:
  pushl $0
80105f16:	6a 00                	push   $0x0
  pushl $39
80105f18:	6a 27                	push   $0x27
  jmp alltraps
80105f1a:	e9 ab f9 ff ff       	jmp    801058ca <alltraps>

80105f1f <vector40>:
.globl vector40
vector40:
  pushl $0
80105f1f:	6a 00                	push   $0x0
  pushl $40
80105f21:	6a 28                	push   $0x28
  jmp alltraps
80105f23:	e9 a2 f9 ff ff       	jmp    801058ca <alltraps>

80105f28 <vector41>:
.globl vector41
vector41:
  pushl $0
80105f28:	6a 00                	push   $0x0
  pushl $41
80105f2a:	6a 29                	push   $0x29
  jmp alltraps
80105f2c:	e9 99 f9 ff ff       	jmp    801058ca <alltraps>

80105f31 <vector42>:
.globl vector42
vector42:
  pushl $0
80105f31:	6a 00                	push   $0x0
  pushl $42
80105f33:	6a 2a                	push   $0x2a
  jmp alltraps
80105f35:	e9 90 f9 ff ff       	jmp    801058ca <alltraps>

80105f3a <vector43>:
.globl vector43
vector43:
  pushl $0
80105f3a:	6a 00                	push   $0x0
  pushl $43
80105f3c:	6a 2b                	push   $0x2b
  jmp alltraps
80105f3e:	e9 87 f9 ff ff       	jmp    801058ca <alltraps>

80105f43 <vector44>:
.globl vector44
vector44:
  pushl $0
80105f43:	6a 00                	push   $0x0
  pushl $44
80105f45:	6a 2c                	push   $0x2c
  jmp alltraps
80105f47:	e9 7e f9 ff ff       	jmp    801058ca <alltraps>

80105f4c <vector45>:
.globl vector45
vector45:
  pushl $0
80105f4c:	6a 00                	push   $0x0
  pushl $45
80105f4e:	6a 2d                	push   $0x2d
  jmp alltraps
80105f50:	e9 75 f9 ff ff       	jmp    801058ca <alltraps>

80105f55 <vector46>:
.globl vector46
vector46:
  pushl $0
80105f55:	6a 00                	push   $0x0
  pushl $46
80105f57:	6a 2e                	push   $0x2e
  jmp alltraps
80105f59:	e9 6c f9 ff ff       	jmp    801058ca <alltraps>

80105f5e <vector47>:
.globl vector47
vector47:
  pushl $0
80105f5e:	6a 00                	push   $0x0
  pushl $47
80105f60:	6a 2f                	push   $0x2f
  jmp alltraps
80105f62:	e9 63 f9 ff ff       	jmp    801058ca <alltraps>

80105f67 <vector48>:
.globl vector48
vector48:
  pushl $0
80105f67:	6a 00                	push   $0x0
  pushl $48
80105f69:	6a 30                	push   $0x30
  jmp alltraps
80105f6b:	e9 5a f9 ff ff       	jmp    801058ca <alltraps>

80105f70 <vector49>:
.globl vector49
vector49:
  pushl $0
80105f70:	6a 00                	push   $0x0
  pushl $49
80105f72:	6a 31                	push   $0x31
  jmp alltraps
80105f74:	e9 51 f9 ff ff       	jmp    801058ca <alltraps>

80105f79 <vector50>:
.globl vector50
vector50:
  pushl $0
80105f79:	6a 00                	push   $0x0
  pushl $50
80105f7b:	6a 32                	push   $0x32
  jmp alltraps
80105f7d:	e9 48 f9 ff ff       	jmp    801058ca <alltraps>

80105f82 <vector51>:
.globl vector51
vector51:
  pushl $0
80105f82:	6a 00                	push   $0x0
  pushl $51
80105f84:	6a 33                	push   $0x33
  jmp alltraps
80105f86:	e9 3f f9 ff ff       	jmp    801058ca <alltraps>

80105f8b <vector52>:
.globl vector52
vector52:
  pushl $0
80105f8b:	6a 00                	push   $0x0
  pushl $52
80105f8d:	6a 34                	push   $0x34
  jmp alltraps
80105f8f:	e9 36 f9 ff ff       	jmp    801058ca <alltraps>

80105f94 <vector53>:
.globl vector53
vector53:
  pushl $0
80105f94:	6a 00                	push   $0x0
  pushl $53
80105f96:	6a 35                	push   $0x35
  jmp alltraps
80105f98:	e9 2d f9 ff ff       	jmp    801058ca <alltraps>

80105f9d <vector54>:
.globl vector54
vector54:
  pushl $0
80105f9d:	6a 00                	push   $0x0
  pushl $54
80105f9f:	6a 36                	push   $0x36
  jmp alltraps
80105fa1:	e9 24 f9 ff ff       	jmp    801058ca <alltraps>

80105fa6 <vector55>:
.globl vector55
vector55:
  pushl $0
80105fa6:	6a 00                	push   $0x0
  pushl $55
80105fa8:	6a 37                	push   $0x37
  jmp alltraps
80105faa:	e9 1b f9 ff ff       	jmp    801058ca <alltraps>

80105faf <vector56>:
.globl vector56
vector56:
  pushl $0
80105faf:	6a 00                	push   $0x0
  pushl $56
80105fb1:	6a 38                	push   $0x38
  jmp alltraps
80105fb3:	e9 12 f9 ff ff       	jmp    801058ca <alltraps>

80105fb8 <vector57>:
.globl vector57
vector57:
  pushl $0
80105fb8:	6a 00                	push   $0x0
  pushl $57
80105fba:	6a 39                	push   $0x39
  jmp alltraps
80105fbc:	e9 09 f9 ff ff       	jmp    801058ca <alltraps>

80105fc1 <vector58>:
.globl vector58
vector58:
  pushl $0
80105fc1:	6a 00                	push   $0x0
  pushl $58
80105fc3:	6a 3a                	push   $0x3a
  jmp alltraps
80105fc5:	e9 00 f9 ff ff       	jmp    801058ca <alltraps>

80105fca <vector59>:
.globl vector59
vector59:
  pushl $0
80105fca:	6a 00                	push   $0x0
  pushl $59
80105fcc:	6a 3b                	push   $0x3b
  jmp alltraps
80105fce:	e9 f7 f8 ff ff       	jmp    801058ca <alltraps>

80105fd3 <vector60>:
.globl vector60
vector60:
  pushl $0
80105fd3:	6a 00                	push   $0x0
  pushl $60
80105fd5:	6a 3c                	push   $0x3c
  jmp alltraps
80105fd7:	e9 ee f8 ff ff       	jmp    801058ca <alltraps>

80105fdc <vector61>:
.globl vector61
vector61:
  pushl $0
80105fdc:	6a 00                	push   $0x0
  pushl $61
80105fde:	6a 3d                	push   $0x3d
  jmp alltraps
80105fe0:	e9 e5 f8 ff ff       	jmp    801058ca <alltraps>

80105fe5 <vector62>:
.globl vector62
vector62:
  pushl $0
80105fe5:	6a 00                	push   $0x0
  pushl $62
80105fe7:	6a 3e                	push   $0x3e
  jmp alltraps
80105fe9:	e9 dc f8 ff ff       	jmp    801058ca <alltraps>

80105fee <vector63>:
.globl vector63
vector63:
  pushl $0
80105fee:	6a 00                	push   $0x0
  pushl $63
80105ff0:	6a 3f                	push   $0x3f
  jmp alltraps
80105ff2:	e9 d3 f8 ff ff       	jmp    801058ca <alltraps>

80105ff7 <vector64>:
.globl vector64
vector64:
  pushl $0
80105ff7:	6a 00                	push   $0x0
  pushl $64
80105ff9:	6a 40                	push   $0x40
  jmp alltraps
80105ffb:	e9 ca f8 ff ff       	jmp    801058ca <alltraps>

80106000 <vector65>:
.globl vector65
vector65:
  pushl $0
80106000:	6a 00                	push   $0x0
  pushl $65
80106002:	6a 41                	push   $0x41
  jmp alltraps
80106004:	e9 c1 f8 ff ff       	jmp    801058ca <alltraps>

80106009 <vector66>:
.globl vector66
vector66:
  pushl $0
80106009:	6a 00                	push   $0x0
  pushl $66
8010600b:	6a 42                	push   $0x42
  jmp alltraps
8010600d:	e9 b8 f8 ff ff       	jmp    801058ca <alltraps>

80106012 <vector67>:
.globl vector67
vector67:
  pushl $0
80106012:	6a 00                	push   $0x0
  pushl $67
80106014:	6a 43                	push   $0x43
  jmp alltraps
80106016:	e9 af f8 ff ff       	jmp    801058ca <alltraps>

8010601b <vector68>:
.globl vector68
vector68:
  pushl $0
8010601b:	6a 00                	push   $0x0
  pushl $68
8010601d:	6a 44                	push   $0x44
  jmp alltraps
8010601f:	e9 a6 f8 ff ff       	jmp    801058ca <alltraps>

80106024 <vector69>:
.globl vector69
vector69:
  pushl $0
80106024:	6a 00                	push   $0x0
  pushl $69
80106026:	6a 45                	push   $0x45
  jmp alltraps
80106028:	e9 9d f8 ff ff       	jmp    801058ca <alltraps>

8010602d <vector70>:
.globl vector70
vector70:
  pushl $0
8010602d:	6a 00                	push   $0x0
  pushl $70
8010602f:	6a 46                	push   $0x46
  jmp alltraps
80106031:	e9 94 f8 ff ff       	jmp    801058ca <alltraps>

80106036 <vector71>:
.globl vector71
vector71:
  pushl $0
80106036:	6a 00                	push   $0x0
  pushl $71
80106038:	6a 47                	push   $0x47
  jmp alltraps
8010603a:	e9 8b f8 ff ff       	jmp    801058ca <alltraps>

8010603f <vector72>:
.globl vector72
vector72:
  pushl $0
8010603f:	6a 00                	push   $0x0
  pushl $72
80106041:	6a 48                	push   $0x48
  jmp alltraps
80106043:	e9 82 f8 ff ff       	jmp    801058ca <alltraps>

80106048 <vector73>:
.globl vector73
vector73:
  pushl $0
80106048:	6a 00                	push   $0x0
  pushl $73
8010604a:	6a 49                	push   $0x49
  jmp alltraps
8010604c:	e9 79 f8 ff ff       	jmp    801058ca <alltraps>

80106051 <vector74>:
.globl vector74
vector74:
  pushl $0
80106051:	6a 00                	push   $0x0
  pushl $74
80106053:	6a 4a                	push   $0x4a
  jmp alltraps
80106055:	e9 70 f8 ff ff       	jmp    801058ca <alltraps>

8010605a <vector75>:
.globl vector75
vector75:
  pushl $0
8010605a:	6a 00                	push   $0x0
  pushl $75
8010605c:	6a 4b                	push   $0x4b
  jmp alltraps
8010605e:	e9 67 f8 ff ff       	jmp    801058ca <alltraps>

80106063 <vector76>:
.globl vector76
vector76:
  pushl $0
80106063:	6a 00                	push   $0x0
  pushl $76
80106065:	6a 4c                	push   $0x4c
  jmp alltraps
80106067:	e9 5e f8 ff ff       	jmp    801058ca <alltraps>

8010606c <vector77>:
.globl vector77
vector77:
  pushl $0
8010606c:	6a 00                	push   $0x0
  pushl $77
8010606e:	6a 4d                	push   $0x4d
  jmp alltraps
80106070:	e9 55 f8 ff ff       	jmp    801058ca <alltraps>

80106075 <vector78>:
.globl vector78
vector78:
  pushl $0
80106075:	6a 00                	push   $0x0
  pushl $78
80106077:	6a 4e                	push   $0x4e
  jmp alltraps
80106079:	e9 4c f8 ff ff       	jmp    801058ca <alltraps>

8010607e <vector79>:
.globl vector79
vector79:
  pushl $0
8010607e:	6a 00                	push   $0x0
  pushl $79
80106080:	6a 4f                	push   $0x4f
  jmp alltraps
80106082:	e9 43 f8 ff ff       	jmp    801058ca <alltraps>

80106087 <vector80>:
.globl vector80
vector80:
  pushl $0
80106087:	6a 00                	push   $0x0
  pushl $80
80106089:	6a 50                	push   $0x50
  jmp alltraps
8010608b:	e9 3a f8 ff ff       	jmp    801058ca <alltraps>

80106090 <vector81>:
.globl vector81
vector81:
  pushl $0
80106090:	6a 00                	push   $0x0
  pushl $81
80106092:	6a 51                	push   $0x51
  jmp alltraps
80106094:	e9 31 f8 ff ff       	jmp    801058ca <alltraps>

80106099 <vector82>:
.globl vector82
vector82:
  pushl $0
80106099:	6a 00                	push   $0x0
  pushl $82
8010609b:	6a 52                	push   $0x52
  jmp alltraps
8010609d:	e9 28 f8 ff ff       	jmp    801058ca <alltraps>

801060a2 <vector83>:
.globl vector83
vector83:
  pushl $0
801060a2:	6a 00                	push   $0x0
  pushl $83
801060a4:	6a 53                	push   $0x53
  jmp alltraps
801060a6:	e9 1f f8 ff ff       	jmp    801058ca <alltraps>

801060ab <vector84>:
.globl vector84
vector84:
  pushl $0
801060ab:	6a 00                	push   $0x0
  pushl $84
801060ad:	6a 54                	push   $0x54
  jmp alltraps
801060af:	e9 16 f8 ff ff       	jmp    801058ca <alltraps>

801060b4 <vector85>:
.globl vector85
vector85:
  pushl $0
801060b4:	6a 00                	push   $0x0
  pushl $85
801060b6:	6a 55                	push   $0x55
  jmp alltraps
801060b8:	e9 0d f8 ff ff       	jmp    801058ca <alltraps>

801060bd <vector86>:
.globl vector86
vector86:
  pushl $0
801060bd:	6a 00                	push   $0x0
  pushl $86
801060bf:	6a 56                	push   $0x56
  jmp alltraps
801060c1:	e9 04 f8 ff ff       	jmp    801058ca <alltraps>

801060c6 <vector87>:
.globl vector87
vector87:
  pushl $0
801060c6:	6a 00                	push   $0x0
  pushl $87
801060c8:	6a 57                	push   $0x57
  jmp alltraps
801060ca:	e9 fb f7 ff ff       	jmp    801058ca <alltraps>

801060cf <vector88>:
.globl vector88
vector88:
  pushl $0
801060cf:	6a 00                	push   $0x0
  pushl $88
801060d1:	6a 58                	push   $0x58
  jmp alltraps
801060d3:	e9 f2 f7 ff ff       	jmp    801058ca <alltraps>

801060d8 <vector89>:
.globl vector89
vector89:
  pushl $0
801060d8:	6a 00                	push   $0x0
  pushl $89
801060da:	6a 59                	push   $0x59
  jmp alltraps
801060dc:	e9 e9 f7 ff ff       	jmp    801058ca <alltraps>

801060e1 <vector90>:
.globl vector90
vector90:
  pushl $0
801060e1:	6a 00                	push   $0x0
  pushl $90
801060e3:	6a 5a                	push   $0x5a
  jmp alltraps
801060e5:	e9 e0 f7 ff ff       	jmp    801058ca <alltraps>

801060ea <vector91>:
.globl vector91
vector91:
  pushl $0
801060ea:	6a 00                	push   $0x0
  pushl $91
801060ec:	6a 5b                	push   $0x5b
  jmp alltraps
801060ee:	e9 d7 f7 ff ff       	jmp    801058ca <alltraps>

801060f3 <vector92>:
.globl vector92
vector92:
  pushl $0
801060f3:	6a 00                	push   $0x0
  pushl $92
801060f5:	6a 5c                	push   $0x5c
  jmp alltraps
801060f7:	e9 ce f7 ff ff       	jmp    801058ca <alltraps>

801060fc <vector93>:
.globl vector93
vector93:
  pushl $0
801060fc:	6a 00                	push   $0x0
  pushl $93
801060fe:	6a 5d                	push   $0x5d
  jmp alltraps
80106100:	e9 c5 f7 ff ff       	jmp    801058ca <alltraps>

80106105 <vector94>:
.globl vector94
vector94:
  pushl $0
80106105:	6a 00                	push   $0x0
  pushl $94
80106107:	6a 5e                	push   $0x5e
  jmp alltraps
80106109:	e9 bc f7 ff ff       	jmp    801058ca <alltraps>

8010610e <vector95>:
.globl vector95
vector95:
  pushl $0
8010610e:	6a 00                	push   $0x0
  pushl $95
80106110:	6a 5f                	push   $0x5f
  jmp alltraps
80106112:	e9 b3 f7 ff ff       	jmp    801058ca <alltraps>

80106117 <vector96>:
.globl vector96
vector96:
  pushl $0
80106117:	6a 00                	push   $0x0
  pushl $96
80106119:	6a 60                	push   $0x60
  jmp alltraps
8010611b:	e9 aa f7 ff ff       	jmp    801058ca <alltraps>

80106120 <vector97>:
.globl vector97
vector97:
  pushl $0
80106120:	6a 00                	push   $0x0
  pushl $97
80106122:	6a 61                	push   $0x61
  jmp alltraps
80106124:	e9 a1 f7 ff ff       	jmp    801058ca <alltraps>

80106129 <vector98>:
.globl vector98
vector98:
  pushl $0
80106129:	6a 00                	push   $0x0
  pushl $98
8010612b:	6a 62                	push   $0x62
  jmp alltraps
8010612d:	e9 98 f7 ff ff       	jmp    801058ca <alltraps>

80106132 <vector99>:
.globl vector99
vector99:
  pushl $0
80106132:	6a 00                	push   $0x0
  pushl $99
80106134:	6a 63                	push   $0x63
  jmp alltraps
80106136:	e9 8f f7 ff ff       	jmp    801058ca <alltraps>

8010613b <vector100>:
.globl vector100
vector100:
  pushl $0
8010613b:	6a 00                	push   $0x0
  pushl $100
8010613d:	6a 64                	push   $0x64
  jmp alltraps
8010613f:	e9 86 f7 ff ff       	jmp    801058ca <alltraps>

80106144 <vector101>:
.globl vector101
vector101:
  pushl $0
80106144:	6a 00                	push   $0x0
  pushl $101
80106146:	6a 65                	push   $0x65
  jmp alltraps
80106148:	e9 7d f7 ff ff       	jmp    801058ca <alltraps>

8010614d <vector102>:
.globl vector102
vector102:
  pushl $0
8010614d:	6a 00                	push   $0x0
  pushl $102
8010614f:	6a 66                	push   $0x66
  jmp alltraps
80106151:	e9 74 f7 ff ff       	jmp    801058ca <alltraps>

80106156 <vector103>:
.globl vector103
vector103:
  pushl $0
80106156:	6a 00                	push   $0x0
  pushl $103
80106158:	6a 67                	push   $0x67
  jmp alltraps
8010615a:	e9 6b f7 ff ff       	jmp    801058ca <alltraps>

8010615f <vector104>:
.globl vector104
vector104:
  pushl $0
8010615f:	6a 00                	push   $0x0
  pushl $104
80106161:	6a 68                	push   $0x68
  jmp alltraps
80106163:	e9 62 f7 ff ff       	jmp    801058ca <alltraps>

80106168 <vector105>:
.globl vector105
vector105:
  pushl $0
80106168:	6a 00                	push   $0x0
  pushl $105
8010616a:	6a 69                	push   $0x69
  jmp alltraps
8010616c:	e9 59 f7 ff ff       	jmp    801058ca <alltraps>

80106171 <vector106>:
.globl vector106
vector106:
  pushl $0
80106171:	6a 00                	push   $0x0
  pushl $106
80106173:	6a 6a                	push   $0x6a
  jmp alltraps
80106175:	e9 50 f7 ff ff       	jmp    801058ca <alltraps>

8010617a <vector107>:
.globl vector107
vector107:
  pushl $0
8010617a:	6a 00                	push   $0x0
  pushl $107
8010617c:	6a 6b                	push   $0x6b
  jmp alltraps
8010617e:	e9 47 f7 ff ff       	jmp    801058ca <alltraps>

80106183 <vector108>:
.globl vector108
vector108:
  pushl $0
80106183:	6a 00                	push   $0x0
  pushl $108
80106185:	6a 6c                	push   $0x6c
  jmp alltraps
80106187:	e9 3e f7 ff ff       	jmp    801058ca <alltraps>

8010618c <vector109>:
.globl vector109
vector109:
  pushl $0
8010618c:	6a 00                	push   $0x0
  pushl $109
8010618e:	6a 6d                	push   $0x6d
  jmp alltraps
80106190:	e9 35 f7 ff ff       	jmp    801058ca <alltraps>

80106195 <vector110>:
.globl vector110
vector110:
  pushl $0
80106195:	6a 00                	push   $0x0
  pushl $110
80106197:	6a 6e                	push   $0x6e
  jmp alltraps
80106199:	e9 2c f7 ff ff       	jmp    801058ca <alltraps>

8010619e <vector111>:
.globl vector111
vector111:
  pushl $0
8010619e:	6a 00                	push   $0x0
  pushl $111
801061a0:	6a 6f                	push   $0x6f
  jmp alltraps
801061a2:	e9 23 f7 ff ff       	jmp    801058ca <alltraps>

801061a7 <vector112>:
.globl vector112
vector112:
  pushl $0
801061a7:	6a 00                	push   $0x0
  pushl $112
801061a9:	6a 70                	push   $0x70
  jmp alltraps
801061ab:	e9 1a f7 ff ff       	jmp    801058ca <alltraps>

801061b0 <vector113>:
.globl vector113
vector113:
  pushl $0
801061b0:	6a 00                	push   $0x0
  pushl $113
801061b2:	6a 71                	push   $0x71
  jmp alltraps
801061b4:	e9 11 f7 ff ff       	jmp    801058ca <alltraps>

801061b9 <vector114>:
.globl vector114
vector114:
  pushl $0
801061b9:	6a 00                	push   $0x0
  pushl $114
801061bb:	6a 72                	push   $0x72
  jmp alltraps
801061bd:	e9 08 f7 ff ff       	jmp    801058ca <alltraps>

801061c2 <vector115>:
.globl vector115
vector115:
  pushl $0
801061c2:	6a 00                	push   $0x0
  pushl $115
801061c4:	6a 73                	push   $0x73
  jmp alltraps
801061c6:	e9 ff f6 ff ff       	jmp    801058ca <alltraps>

801061cb <vector116>:
.globl vector116
vector116:
  pushl $0
801061cb:	6a 00                	push   $0x0
  pushl $116
801061cd:	6a 74                	push   $0x74
  jmp alltraps
801061cf:	e9 f6 f6 ff ff       	jmp    801058ca <alltraps>

801061d4 <vector117>:
.globl vector117
vector117:
  pushl $0
801061d4:	6a 00                	push   $0x0
  pushl $117
801061d6:	6a 75                	push   $0x75
  jmp alltraps
801061d8:	e9 ed f6 ff ff       	jmp    801058ca <alltraps>

801061dd <vector118>:
.globl vector118
vector118:
  pushl $0
801061dd:	6a 00                	push   $0x0
  pushl $118
801061df:	6a 76                	push   $0x76
  jmp alltraps
801061e1:	e9 e4 f6 ff ff       	jmp    801058ca <alltraps>

801061e6 <vector119>:
.globl vector119
vector119:
  pushl $0
801061e6:	6a 00                	push   $0x0
  pushl $119
801061e8:	6a 77                	push   $0x77
  jmp alltraps
801061ea:	e9 db f6 ff ff       	jmp    801058ca <alltraps>

801061ef <vector120>:
.globl vector120
vector120:
  pushl $0
801061ef:	6a 00                	push   $0x0
  pushl $120
801061f1:	6a 78                	push   $0x78
  jmp alltraps
801061f3:	e9 d2 f6 ff ff       	jmp    801058ca <alltraps>

801061f8 <vector121>:
.globl vector121
vector121:
  pushl $0
801061f8:	6a 00                	push   $0x0
  pushl $121
801061fa:	6a 79                	push   $0x79
  jmp alltraps
801061fc:	e9 c9 f6 ff ff       	jmp    801058ca <alltraps>

80106201 <vector122>:
.globl vector122
vector122:
  pushl $0
80106201:	6a 00                	push   $0x0
  pushl $122
80106203:	6a 7a                	push   $0x7a
  jmp alltraps
80106205:	e9 c0 f6 ff ff       	jmp    801058ca <alltraps>

8010620a <vector123>:
.globl vector123
vector123:
  pushl $0
8010620a:	6a 00                	push   $0x0
  pushl $123
8010620c:	6a 7b                	push   $0x7b
  jmp alltraps
8010620e:	e9 b7 f6 ff ff       	jmp    801058ca <alltraps>

80106213 <vector124>:
.globl vector124
vector124:
  pushl $0
80106213:	6a 00                	push   $0x0
  pushl $124
80106215:	6a 7c                	push   $0x7c
  jmp alltraps
80106217:	e9 ae f6 ff ff       	jmp    801058ca <alltraps>

8010621c <vector125>:
.globl vector125
vector125:
  pushl $0
8010621c:	6a 00                	push   $0x0
  pushl $125
8010621e:	6a 7d                	push   $0x7d
  jmp alltraps
80106220:	e9 a5 f6 ff ff       	jmp    801058ca <alltraps>

80106225 <vector126>:
.globl vector126
vector126:
  pushl $0
80106225:	6a 00                	push   $0x0
  pushl $126
80106227:	6a 7e                	push   $0x7e
  jmp alltraps
80106229:	e9 9c f6 ff ff       	jmp    801058ca <alltraps>

8010622e <vector127>:
.globl vector127
vector127:
  pushl $0
8010622e:	6a 00                	push   $0x0
  pushl $127
80106230:	6a 7f                	push   $0x7f
  jmp alltraps
80106232:	e9 93 f6 ff ff       	jmp    801058ca <alltraps>

80106237 <vector128>:
.globl vector128
vector128:
  pushl $0
80106237:	6a 00                	push   $0x0
  pushl $128
80106239:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010623e:	e9 87 f6 ff ff       	jmp    801058ca <alltraps>

80106243 <vector129>:
.globl vector129
vector129:
  pushl $0
80106243:	6a 00                	push   $0x0
  pushl $129
80106245:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010624a:	e9 7b f6 ff ff       	jmp    801058ca <alltraps>

8010624f <vector130>:
.globl vector130
vector130:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $130
80106251:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106256:	e9 6f f6 ff ff       	jmp    801058ca <alltraps>

8010625b <vector131>:
.globl vector131
vector131:
  pushl $0
8010625b:	6a 00                	push   $0x0
  pushl $131
8010625d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106262:	e9 63 f6 ff ff       	jmp    801058ca <alltraps>

80106267 <vector132>:
.globl vector132
vector132:
  pushl $0
80106267:	6a 00                	push   $0x0
  pushl $132
80106269:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010626e:	e9 57 f6 ff ff       	jmp    801058ca <alltraps>

80106273 <vector133>:
.globl vector133
vector133:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $133
80106275:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010627a:	e9 4b f6 ff ff       	jmp    801058ca <alltraps>

8010627f <vector134>:
.globl vector134
vector134:
  pushl $0
8010627f:	6a 00                	push   $0x0
  pushl $134
80106281:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106286:	e9 3f f6 ff ff       	jmp    801058ca <alltraps>

8010628b <vector135>:
.globl vector135
vector135:
  pushl $0
8010628b:	6a 00                	push   $0x0
  pushl $135
8010628d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106292:	e9 33 f6 ff ff       	jmp    801058ca <alltraps>

80106297 <vector136>:
.globl vector136
vector136:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $136
80106299:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010629e:	e9 27 f6 ff ff       	jmp    801058ca <alltraps>

801062a3 <vector137>:
.globl vector137
vector137:
  pushl $0
801062a3:	6a 00                	push   $0x0
  pushl $137
801062a5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801062aa:	e9 1b f6 ff ff       	jmp    801058ca <alltraps>

801062af <vector138>:
.globl vector138
vector138:
  pushl $0
801062af:	6a 00                	push   $0x0
  pushl $138
801062b1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801062b6:	e9 0f f6 ff ff       	jmp    801058ca <alltraps>

801062bb <vector139>:
.globl vector139
vector139:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $139
801062bd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801062c2:	e9 03 f6 ff ff       	jmp    801058ca <alltraps>

801062c7 <vector140>:
.globl vector140
vector140:
  pushl $0
801062c7:	6a 00                	push   $0x0
  pushl $140
801062c9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801062ce:	e9 f7 f5 ff ff       	jmp    801058ca <alltraps>

801062d3 <vector141>:
.globl vector141
vector141:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $141
801062d5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801062da:	e9 eb f5 ff ff       	jmp    801058ca <alltraps>

801062df <vector142>:
.globl vector142
vector142:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $142
801062e1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801062e6:	e9 df f5 ff ff       	jmp    801058ca <alltraps>

801062eb <vector143>:
.globl vector143
vector143:
  pushl $0
801062eb:	6a 00                	push   $0x0
  pushl $143
801062ed:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801062f2:	e9 d3 f5 ff ff       	jmp    801058ca <alltraps>

801062f7 <vector144>:
.globl vector144
vector144:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $144
801062f9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801062fe:	e9 c7 f5 ff ff       	jmp    801058ca <alltraps>

80106303 <vector145>:
.globl vector145
vector145:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $145
80106305:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010630a:	e9 bb f5 ff ff       	jmp    801058ca <alltraps>

8010630f <vector146>:
.globl vector146
vector146:
  pushl $0
8010630f:	6a 00                	push   $0x0
  pushl $146
80106311:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106316:	e9 af f5 ff ff       	jmp    801058ca <alltraps>

8010631b <vector147>:
.globl vector147
vector147:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $147
8010631d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106322:	e9 a3 f5 ff ff       	jmp    801058ca <alltraps>

80106327 <vector148>:
.globl vector148
vector148:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $148
80106329:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010632e:	e9 97 f5 ff ff       	jmp    801058ca <alltraps>

80106333 <vector149>:
.globl vector149
vector149:
  pushl $0
80106333:	6a 00                	push   $0x0
  pushl $149
80106335:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010633a:	e9 8b f5 ff ff       	jmp    801058ca <alltraps>

8010633f <vector150>:
.globl vector150
vector150:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $150
80106341:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106346:	e9 7f f5 ff ff       	jmp    801058ca <alltraps>

8010634b <vector151>:
.globl vector151
vector151:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $151
8010634d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106352:	e9 73 f5 ff ff       	jmp    801058ca <alltraps>

80106357 <vector152>:
.globl vector152
vector152:
  pushl $0
80106357:	6a 00                	push   $0x0
  pushl $152
80106359:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010635e:	e9 67 f5 ff ff       	jmp    801058ca <alltraps>

80106363 <vector153>:
.globl vector153
vector153:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $153
80106365:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010636a:	e9 5b f5 ff ff       	jmp    801058ca <alltraps>

8010636f <vector154>:
.globl vector154
vector154:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $154
80106371:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106376:	e9 4f f5 ff ff       	jmp    801058ca <alltraps>

8010637b <vector155>:
.globl vector155
vector155:
  pushl $0
8010637b:	6a 00                	push   $0x0
  pushl $155
8010637d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106382:	e9 43 f5 ff ff       	jmp    801058ca <alltraps>

80106387 <vector156>:
.globl vector156
vector156:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $156
80106389:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010638e:	e9 37 f5 ff ff       	jmp    801058ca <alltraps>

80106393 <vector157>:
.globl vector157
vector157:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $157
80106395:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010639a:	e9 2b f5 ff ff       	jmp    801058ca <alltraps>

8010639f <vector158>:
.globl vector158
vector158:
  pushl $0
8010639f:	6a 00                	push   $0x0
  pushl $158
801063a1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801063a6:	e9 1f f5 ff ff       	jmp    801058ca <alltraps>

801063ab <vector159>:
.globl vector159
vector159:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $159
801063ad:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801063b2:	e9 13 f5 ff ff       	jmp    801058ca <alltraps>

801063b7 <vector160>:
.globl vector160
vector160:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $160
801063b9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801063be:	e9 07 f5 ff ff       	jmp    801058ca <alltraps>

801063c3 <vector161>:
.globl vector161
vector161:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $161
801063c5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801063ca:	e9 fb f4 ff ff       	jmp    801058ca <alltraps>

801063cf <vector162>:
.globl vector162
vector162:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $162
801063d1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801063d6:	e9 ef f4 ff ff       	jmp    801058ca <alltraps>

801063db <vector163>:
.globl vector163
vector163:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $163
801063dd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801063e2:	e9 e3 f4 ff ff       	jmp    801058ca <alltraps>

801063e7 <vector164>:
.globl vector164
vector164:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $164
801063e9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801063ee:	e9 d7 f4 ff ff       	jmp    801058ca <alltraps>

801063f3 <vector165>:
.globl vector165
vector165:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $165
801063f5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801063fa:	e9 cb f4 ff ff       	jmp    801058ca <alltraps>

801063ff <vector166>:
.globl vector166
vector166:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $166
80106401:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106406:	e9 bf f4 ff ff       	jmp    801058ca <alltraps>

8010640b <vector167>:
.globl vector167
vector167:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $167
8010640d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106412:	e9 b3 f4 ff ff       	jmp    801058ca <alltraps>

80106417 <vector168>:
.globl vector168
vector168:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $168
80106419:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010641e:	e9 a7 f4 ff ff       	jmp    801058ca <alltraps>

80106423 <vector169>:
.globl vector169
vector169:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $169
80106425:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010642a:	e9 9b f4 ff ff       	jmp    801058ca <alltraps>

8010642f <vector170>:
.globl vector170
vector170:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $170
80106431:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106436:	e9 8f f4 ff ff       	jmp    801058ca <alltraps>

8010643b <vector171>:
.globl vector171
vector171:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $171
8010643d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106442:	e9 83 f4 ff ff       	jmp    801058ca <alltraps>

80106447 <vector172>:
.globl vector172
vector172:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $172
80106449:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010644e:	e9 77 f4 ff ff       	jmp    801058ca <alltraps>

80106453 <vector173>:
.globl vector173
vector173:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $173
80106455:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010645a:	e9 6b f4 ff ff       	jmp    801058ca <alltraps>

8010645f <vector174>:
.globl vector174
vector174:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $174
80106461:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106466:	e9 5f f4 ff ff       	jmp    801058ca <alltraps>

8010646b <vector175>:
.globl vector175
vector175:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $175
8010646d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106472:	e9 53 f4 ff ff       	jmp    801058ca <alltraps>

80106477 <vector176>:
.globl vector176
vector176:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $176
80106479:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010647e:	e9 47 f4 ff ff       	jmp    801058ca <alltraps>

80106483 <vector177>:
.globl vector177
vector177:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $177
80106485:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010648a:	e9 3b f4 ff ff       	jmp    801058ca <alltraps>

8010648f <vector178>:
.globl vector178
vector178:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $178
80106491:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106496:	e9 2f f4 ff ff       	jmp    801058ca <alltraps>

8010649b <vector179>:
.globl vector179
vector179:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $179
8010649d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801064a2:	e9 23 f4 ff ff       	jmp    801058ca <alltraps>

801064a7 <vector180>:
.globl vector180
vector180:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $180
801064a9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801064ae:	e9 17 f4 ff ff       	jmp    801058ca <alltraps>

801064b3 <vector181>:
.globl vector181
vector181:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $181
801064b5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801064ba:	e9 0b f4 ff ff       	jmp    801058ca <alltraps>

801064bf <vector182>:
.globl vector182
vector182:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $182
801064c1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801064c6:	e9 ff f3 ff ff       	jmp    801058ca <alltraps>

801064cb <vector183>:
.globl vector183
vector183:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $183
801064cd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801064d2:	e9 f3 f3 ff ff       	jmp    801058ca <alltraps>

801064d7 <vector184>:
.globl vector184
vector184:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $184
801064d9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801064de:	e9 e7 f3 ff ff       	jmp    801058ca <alltraps>

801064e3 <vector185>:
.globl vector185
vector185:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $185
801064e5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801064ea:	e9 db f3 ff ff       	jmp    801058ca <alltraps>

801064ef <vector186>:
.globl vector186
vector186:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $186
801064f1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801064f6:	e9 cf f3 ff ff       	jmp    801058ca <alltraps>

801064fb <vector187>:
.globl vector187
vector187:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $187
801064fd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106502:	e9 c3 f3 ff ff       	jmp    801058ca <alltraps>

80106507 <vector188>:
.globl vector188
vector188:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $188
80106509:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010650e:	e9 b7 f3 ff ff       	jmp    801058ca <alltraps>

80106513 <vector189>:
.globl vector189
vector189:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $189
80106515:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010651a:	e9 ab f3 ff ff       	jmp    801058ca <alltraps>

8010651f <vector190>:
.globl vector190
vector190:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $190
80106521:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106526:	e9 9f f3 ff ff       	jmp    801058ca <alltraps>

8010652b <vector191>:
.globl vector191
vector191:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $191
8010652d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106532:	e9 93 f3 ff ff       	jmp    801058ca <alltraps>

80106537 <vector192>:
.globl vector192
vector192:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $192
80106539:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010653e:	e9 87 f3 ff ff       	jmp    801058ca <alltraps>

80106543 <vector193>:
.globl vector193
vector193:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $193
80106545:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010654a:	e9 7b f3 ff ff       	jmp    801058ca <alltraps>

8010654f <vector194>:
.globl vector194
vector194:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $194
80106551:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106556:	e9 6f f3 ff ff       	jmp    801058ca <alltraps>

8010655b <vector195>:
.globl vector195
vector195:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $195
8010655d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106562:	e9 63 f3 ff ff       	jmp    801058ca <alltraps>

80106567 <vector196>:
.globl vector196
vector196:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $196
80106569:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010656e:	e9 57 f3 ff ff       	jmp    801058ca <alltraps>

80106573 <vector197>:
.globl vector197
vector197:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $197
80106575:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010657a:	e9 4b f3 ff ff       	jmp    801058ca <alltraps>

8010657f <vector198>:
.globl vector198
vector198:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $198
80106581:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106586:	e9 3f f3 ff ff       	jmp    801058ca <alltraps>

8010658b <vector199>:
.globl vector199
vector199:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $199
8010658d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106592:	e9 33 f3 ff ff       	jmp    801058ca <alltraps>

80106597 <vector200>:
.globl vector200
vector200:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $200
80106599:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010659e:	e9 27 f3 ff ff       	jmp    801058ca <alltraps>

801065a3 <vector201>:
.globl vector201
vector201:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $201
801065a5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801065aa:	e9 1b f3 ff ff       	jmp    801058ca <alltraps>

801065af <vector202>:
.globl vector202
vector202:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $202
801065b1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801065b6:	e9 0f f3 ff ff       	jmp    801058ca <alltraps>

801065bb <vector203>:
.globl vector203
vector203:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $203
801065bd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801065c2:	e9 03 f3 ff ff       	jmp    801058ca <alltraps>

801065c7 <vector204>:
.globl vector204
vector204:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $204
801065c9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801065ce:	e9 f7 f2 ff ff       	jmp    801058ca <alltraps>

801065d3 <vector205>:
.globl vector205
vector205:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $205
801065d5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801065da:	e9 eb f2 ff ff       	jmp    801058ca <alltraps>

801065df <vector206>:
.globl vector206
vector206:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $206
801065e1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801065e6:	e9 df f2 ff ff       	jmp    801058ca <alltraps>

801065eb <vector207>:
.globl vector207
vector207:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $207
801065ed:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801065f2:	e9 d3 f2 ff ff       	jmp    801058ca <alltraps>

801065f7 <vector208>:
.globl vector208
vector208:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $208
801065f9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801065fe:	e9 c7 f2 ff ff       	jmp    801058ca <alltraps>

80106603 <vector209>:
.globl vector209
vector209:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $209
80106605:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010660a:	e9 bb f2 ff ff       	jmp    801058ca <alltraps>

8010660f <vector210>:
.globl vector210
vector210:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $210
80106611:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106616:	e9 af f2 ff ff       	jmp    801058ca <alltraps>

8010661b <vector211>:
.globl vector211
vector211:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $211
8010661d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106622:	e9 a3 f2 ff ff       	jmp    801058ca <alltraps>

80106627 <vector212>:
.globl vector212
vector212:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $212
80106629:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010662e:	e9 97 f2 ff ff       	jmp    801058ca <alltraps>

80106633 <vector213>:
.globl vector213
vector213:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $213
80106635:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010663a:	e9 8b f2 ff ff       	jmp    801058ca <alltraps>

8010663f <vector214>:
.globl vector214
vector214:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $214
80106641:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106646:	e9 7f f2 ff ff       	jmp    801058ca <alltraps>

8010664b <vector215>:
.globl vector215
vector215:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $215
8010664d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106652:	e9 73 f2 ff ff       	jmp    801058ca <alltraps>

80106657 <vector216>:
.globl vector216
vector216:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $216
80106659:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010665e:	e9 67 f2 ff ff       	jmp    801058ca <alltraps>

80106663 <vector217>:
.globl vector217
vector217:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $217
80106665:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010666a:	e9 5b f2 ff ff       	jmp    801058ca <alltraps>

8010666f <vector218>:
.globl vector218
vector218:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $218
80106671:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106676:	e9 4f f2 ff ff       	jmp    801058ca <alltraps>

8010667b <vector219>:
.globl vector219
vector219:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $219
8010667d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106682:	e9 43 f2 ff ff       	jmp    801058ca <alltraps>

80106687 <vector220>:
.globl vector220
vector220:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $220
80106689:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010668e:	e9 37 f2 ff ff       	jmp    801058ca <alltraps>

80106693 <vector221>:
.globl vector221
vector221:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $221
80106695:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010669a:	e9 2b f2 ff ff       	jmp    801058ca <alltraps>

8010669f <vector222>:
.globl vector222
vector222:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $222
801066a1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801066a6:	e9 1f f2 ff ff       	jmp    801058ca <alltraps>

801066ab <vector223>:
.globl vector223
vector223:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $223
801066ad:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801066b2:	e9 13 f2 ff ff       	jmp    801058ca <alltraps>

801066b7 <vector224>:
.globl vector224
vector224:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $224
801066b9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801066be:	e9 07 f2 ff ff       	jmp    801058ca <alltraps>

801066c3 <vector225>:
.globl vector225
vector225:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $225
801066c5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801066ca:	e9 fb f1 ff ff       	jmp    801058ca <alltraps>

801066cf <vector226>:
.globl vector226
vector226:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $226
801066d1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801066d6:	e9 ef f1 ff ff       	jmp    801058ca <alltraps>

801066db <vector227>:
.globl vector227
vector227:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $227
801066dd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801066e2:	e9 e3 f1 ff ff       	jmp    801058ca <alltraps>

801066e7 <vector228>:
.globl vector228
vector228:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $228
801066e9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801066ee:	e9 d7 f1 ff ff       	jmp    801058ca <alltraps>

801066f3 <vector229>:
.globl vector229
vector229:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $229
801066f5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801066fa:	e9 cb f1 ff ff       	jmp    801058ca <alltraps>

801066ff <vector230>:
.globl vector230
vector230:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $230
80106701:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106706:	e9 bf f1 ff ff       	jmp    801058ca <alltraps>

8010670b <vector231>:
.globl vector231
vector231:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $231
8010670d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106712:	e9 b3 f1 ff ff       	jmp    801058ca <alltraps>

80106717 <vector232>:
.globl vector232
vector232:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $232
80106719:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010671e:	e9 a7 f1 ff ff       	jmp    801058ca <alltraps>

80106723 <vector233>:
.globl vector233
vector233:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $233
80106725:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010672a:	e9 9b f1 ff ff       	jmp    801058ca <alltraps>

8010672f <vector234>:
.globl vector234
vector234:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $234
80106731:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106736:	e9 8f f1 ff ff       	jmp    801058ca <alltraps>

8010673b <vector235>:
.globl vector235
vector235:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $235
8010673d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106742:	e9 83 f1 ff ff       	jmp    801058ca <alltraps>

80106747 <vector236>:
.globl vector236
vector236:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $236
80106749:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010674e:	e9 77 f1 ff ff       	jmp    801058ca <alltraps>

80106753 <vector237>:
.globl vector237
vector237:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $237
80106755:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010675a:	e9 6b f1 ff ff       	jmp    801058ca <alltraps>

8010675f <vector238>:
.globl vector238
vector238:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $238
80106761:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106766:	e9 5f f1 ff ff       	jmp    801058ca <alltraps>

8010676b <vector239>:
.globl vector239
vector239:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $239
8010676d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106772:	e9 53 f1 ff ff       	jmp    801058ca <alltraps>

80106777 <vector240>:
.globl vector240
vector240:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $240
80106779:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010677e:	e9 47 f1 ff ff       	jmp    801058ca <alltraps>

80106783 <vector241>:
.globl vector241
vector241:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $241
80106785:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010678a:	e9 3b f1 ff ff       	jmp    801058ca <alltraps>

8010678f <vector242>:
.globl vector242
vector242:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $242
80106791:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106796:	e9 2f f1 ff ff       	jmp    801058ca <alltraps>

8010679b <vector243>:
.globl vector243
vector243:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $243
8010679d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801067a2:	e9 23 f1 ff ff       	jmp    801058ca <alltraps>

801067a7 <vector244>:
.globl vector244
vector244:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $244
801067a9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801067ae:	e9 17 f1 ff ff       	jmp    801058ca <alltraps>

801067b3 <vector245>:
.globl vector245
vector245:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $245
801067b5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801067ba:	e9 0b f1 ff ff       	jmp    801058ca <alltraps>

801067bf <vector246>:
.globl vector246
vector246:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $246
801067c1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801067c6:	e9 ff f0 ff ff       	jmp    801058ca <alltraps>

801067cb <vector247>:
.globl vector247
vector247:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $247
801067cd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801067d2:	e9 f3 f0 ff ff       	jmp    801058ca <alltraps>

801067d7 <vector248>:
.globl vector248
vector248:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $248
801067d9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801067de:	e9 e7 f0 ff ff       	jmp    801058ca <alltraps>

801067e3 <vector249>:
.globl vector249
vector249:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $249
801067e5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801067ea:	e9 db f0 ff ff       	jmp    801058ca <alltraps>

801067ef <vector250>:
.globl vector250
vector250:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $250
801067f1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801067f6:	e9 cf f0 ff ff       	jmp    801058ca <alltraps>

801067fb <vector251>:
.globl vector251
vector251:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $251
801067fd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106802:	e9 c3 f0 ff ff       	jmp    801058ca <alltraps>

80106807 <vector252>:
.globl vector252
vector252:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $252
80106809:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010680e:	e9 b7 f0 ff ff       	jmp    801058ca <alltraps>

80106813 <vector253>:
.globl vector253
vector253:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $253
80106815:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010681a:	e9 ab f0 ff ff       	jmp    801058ca <alltraps>

8010681f <vector254>:
.globl vector254
vector254:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $254
80106821:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106826:	e9 9f f0 ff ff       	jmp    801058ca <alltraps>

8010682b <vector255>:
.globl vector255
vector255:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $255
8010682d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106832:	e9 93 f0 ff ff       	jmp    801058ca <alltraps>
80106837:	66 90                	xchg   %ax,%ax
80106839:	66 90                	xchg   %ax,%ax
8010683b:	66 90                	xchg   %ax,%ax
8010683d:	66 90                	xchg   %ax,%ax
8010683f:	90                   	nop

80106840 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106840:	55                   	push   %ebp
80106841:	89 e5                	mov    %esp,%ebp
80106843:	57                   	push   %edi
80106844:	56                   	push   %esi
80106845:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106846:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010684c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106852:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106855:	39 d3                	cmp    %edx,%ebx
80106857:	73 56                	jae    801068af <deallocuvm.part.0+0x6f>
80106859:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010685c:	89 c6                	mov    %eax,%esi
8010685e:	89 d7                	mov    %edx,%edi
80106860:	eb 12                	jmp    80106874 <deallocuvm.part.0+0x34>
80106862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106868:	83 c2 01             	add    $0x1,%edx
8010686b:	89 d3                	mov    %edx,%ebx
8010686d:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106870:	39 fb                	cmp    %edi,%ebx
80106872:	73 38                	jae    801068ac <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80106874:	89 da                	mov    %ebx,%edx
80106876:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106879:	8b 04 96             	mov    (%esi,%edx,4),%eax
8010687c:	a8 01                	test   $0x1,%al
8010687e:	74 e8                	je     80106868 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80106880:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106882:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106887:	c1 e9 0a             	shr    $0xa,%ecx
8010688a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106890:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106897:	85 c0                	test   %eax,%eax
80106899:	74 cd                	je     80106868 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
8010689b:	8b 10                	mov    (%eax),%edx
8010689d:	f6 c2 01             	test   $0x1,%dl
801068a0:	75 1e                	jne    801068c0 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
801068a2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068a8:	39 fb                	cmp    %edi,%ebx
801068aa:	72 c8                	jb     80106874 <deallocuvm.part.0+0x34>
801068ac:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801068af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068b2:	89 c8                	mov    %ecx,%eax
801068b4:	5b                   	pop    %ebx
801068b5:	5e                   	pop    %esi
801068b6:	5f                   	pop    %edi
801068b7:	5d                   	pop    %ebp
801068b8:	c3                   	ret
801068b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
801068c0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801068c6:	74 26                	je     801068ee <deallocuvm.part.0+0xae>
      kfree(v);
801068c8:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801068cb:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801068d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801068d4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
801068da:	52                   	push   %edx
801068db:	e8 60 bc ff ff       	call   80102540 <kfree>
      *pte = 0;
801068e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
801068e3:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
801068e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801068ec:	eb 82                	jmp    80106870 <deallocuvm.part.0+0x30>
        panic("kfree");
801068ee:	83 ec 0c             	sub    $0xc,%esp
801068f1:	68 66 74 10 80       	push   $0x80107466
801068f6:	e8 85 9a ff ff       	call   80100380 <panic>
801068fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801068ff:	90                   	nop

80106900 <mappages>:
{
80106900:	55                   	push   %ebp
80106901:	89 e5                	mov    %esp,%ebp
80106903:	57                   	push   %edi
80106904:	56                   	push   %esi
80106905:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106906:	89 d3                	mov    %edx,%ebx
80106908:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010690e:	83 ec 1c             	sub    $0x1c,%esp
80106911:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106914:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106918:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010691d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106920:	8b 45 08             	mov    0x8(%ebp),%eax
80106923:	29 d8                	sub    %ebx,%eax
80106925:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106928:	eb 3f                	jmp    80106969 <mappages+0x69>
8010692a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106930:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106932:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106937:	c1 ea 0a             	shr    $0xa,%edx
8010693a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106940:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106947:	85 c0                	test   %eax,%eax
80106949:	74 75                	je     801069c0 <mappages+0xc0>
    if(*pte & PTE_P)
8010694b:	f6 00 01             	testb  $0x1,(%eax)
8010694e:	0f 85 86 00 00 00    	jne    801069da <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106954:	0b 75 0c             	or     0xc(%ebp),%esi
80106957:	83 ce 01             	or     $0x1,%esi
8010695a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010695c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010695f:	39 c3                	cmp    %eax,%ebx
80106961:	74 6d                	je     801069d0 <mappages+0xd0>
    a += PGSIZE;
80106963:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106969:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010696c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010696f:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106972:	89 d8                	mov    %ebx,%eax
80106974:	c1 e8 16             	shr    $0x16,%eax
80106977:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
8010697a:	8b 07                	mov    (%edi),%eax
8010697c:	a8 01                	test   $0x1,%al
8010697e:	75 b0                	jne    80106930 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106980:	e8 7b bd ff ff       	call   80102700 <kalloc>
80106985:	85 c0                	test   %eax,%eax
80106987:	74 37                	je     801069c0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106989:	83 ec 04             	sub    $0x4,%esp
8010698c:	68 00 10 00 00       	push   $0x1000
80106991:	6a 00                	push   $0x0
80106993:	50                   	push   %eax
80106994:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106997:	e8 74 dd ff ff       	call   80104710 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010699c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010699f:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801069a2:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
801069a8:	83 c8 07             	or     $0x7,%eax
801069ab:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
801069ad:	89 d8                	mov    %ebx,%eax
801069af:	c1 e8 0a             	shr    $0xa,%eax
801069b2:	25 fc 0f 00 00       	and    $0xffc,%eax
801069b7:	01 d0                	add    %edx,%eax
801069b9:	eb 90                	jmp    8010694b <mappages+0x4b>
801069bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801069bf:	90                   	nop
}
801069c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801069c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801069c8:	5b                   	pop    %ebx
801069c9:	5e                   	pop    %esi
801069ca:	5f                   	pop    %edi
801069cb:	5d                   	pop    %ebp
801069cc:	c3                   	ret
801069cd:	8d 76 00             	lea    0x0(%esi),%esi
801069d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801069d3:	31 c0                	xor    %eax,%eax
}
801069d5:	5b                   	pop    %ebx
801069d6:	5e                   	pop    %esi
801069d7:	5f                   	pop    %edi
801069d8:	5d                   	pop    %ebp
801069d9:	c3                   	ret
      panic("remap");
801069da:	83 ec 0c             	sub    $0xc,%esp
801069dd:	68 c8 7a 10 80       	push   $0x80107ac8
801069e2:	e8 99 99 ff ff       	call   80100380 <panic>
801069e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069ee:	66 90                	xchg   %ax,%ax

801069f0 <seginit>:
{
801069f0:	55                   	push   %ebp
801069f1:	89 e5                	mov    %esp,%ebp
801069f3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801069f6:	e8 05 d0 ff ff       	call   80103a00 <cpuid>
  pd[0] = size-1;
801069fb:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106a00:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106a06:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
80106a0d:	ff 00 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a10:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
80106a17:	ff 00 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a1a:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
80106a21:	ff 00 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a24:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
80106a2b:	ff 00 00 
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106a2e:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
80106a35:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a38:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
80106a3f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a42:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
80106a49:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a4c:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106a53:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106a56:	05 10 18 11 80       	add    $0x80111810,%eax
80106a5b:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106a5f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106a63:	c1 e8 10             	shr    $0x10,%eax
80106a66:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106a6a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106a6d:	0f 01 10             	lgdtl  (%eax)
}
80106a70:	c9                   	leave
80106a71:	c3                   	ret
80106a72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106a80 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106a80:	a1 c4 44 11 80       	mov    0x801144c4,%eax
80106a85:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a8a:	0f 22 d8             	mov    %eax,%cr3
}
80106a8d:	c3                   	ret
80106a8e:	66 90                	xchg   %ax,%ax

80106a90 <switchuvm>:
{
80106a90:	55                   	push   %ebp
80106a91:	89 e5                	mov    %esp,%ebp
80106a93:	57                   	push   %edi
80106a94:	56                   	push   %esi
80106a95:	53                   	push   %ebx
80106a96:	83 ec 1c             	sub    $0x1c,%esp
80106a99:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106a9c:	85 f6                	test   %esi,%esi
80106a9e:	0f 84 cb 00 00 00    	je     80106b6f <switchuvm+0xdf>
  if(p->kstack == 0)
80106aa4:	8b 46 08             	mov    0x8(%esi),%eax
80106aa7:	85 c0                	test   %eax,%eax
80106aa9:	0f 84 da 00 00 00    	je     80106b89 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106aaf:	8b 46 04             	mov    0x4(%esi),%eax
80106ab2:	85 c0                	test   %eax,%eax
80106ab4:	0f 84 c2 00 00 00    	je     80106b7c <switchuvm+0xec>
  pushcli();
80106aba:	e8 71 da ff ff       	call   80104530 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106abf:	e8 dc ce ff ff       	call   801039a0 <mycpu>
80106ac4:	89 c3                	mov    %eax,%ebx
80106ac6:	e8 d5 ce ff ff       	call   801039a0 <mycpu>
80106acb:	89 c7                	mov    %eax,%edi
80106acd:	e8 ce ce ff ff       	call   801039a0 <mycpu>
80106ad2:	83 c7 08             	add    $0x8,%edi
80106ad5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ad8:	e8 c3 ce ff ff       	call   801039a0 <mycpu>
80106add:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106ae0:	ba 67 00 00 00       	mov    $0x67,%edx
80106ae5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106aec:	83 c0 08             	add    $0x8,%eax
80106aef:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106af6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106afb:	83 c1 08             	add    $0x8,%ecx
80106afe:	c1 e8 18             	shr    $0x18,%eax
80106b01:	c1 e9 10             	shr    $0x10,%ecx
80106b04:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106b0a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106b10:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106b15:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b1c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106b21:	e8 7a ce ff ff       	call   801039a0 <mycpu>
80106b26:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b2d:	e8 6e ce ff ff       	call   801039a0 <mycpu>
80106b32:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106b36:	8b 5e 08             	mov    0x8(%esi),%ebx
80106b39:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b3f:	e8 5c ce ff ff       	call   801039a0 <mycpu>
80106b44:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b47:	e8 54 ce ff ff       	call   801039a0 <mycpu>
80106b4c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106b50:	b8 28 00 00 00       	mov    $0x28,%eax
80106b55:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106b58:	8b 46 04             	mov    0x4(%esi),%eax
80106b5b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b60:	0f 22 d8             	mov    %eax,%cr3
}
80106b63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b66:	5b                   	pop    %ebx
80106b67:	5e                   	pop    %esi
80106b68:	5f                   	pop    %edi
80106b69:	5d                   	pop    %ebp
  popcli();
80106b6a:	e9 f1 da ff ff       	jmp    80104660 <popcli>
    panic("switchuvm: no process");
80106b6f:	83 ec 0c             	sub    $0xc,%esp
80106b72:	68 ce 7a 10 80       	push   $0x80107ace
80106b77:	e8 04 98 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106b7c:	83 ec 0c             	sub    $0xc,%esp
80106b7f:	68 f9 7a 10 80       	push   $0x80107af9
80106b84:	e8 f7 97 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106b89:	83 ec 0c             	sub    $0xc,%esp
80106b8c:	68 e4 7a 10 80       	push   $0x80107ae4
80106b91:	e8 ea 97 ff ff       	call   80100380 <panic>
80106b96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b9d:	8d 76 00             	lea    0x0(%esi),%esi

80106ba0 <inituvm>:
{
80106ba0:	55                   	push   %ebp
80106ba1:	89 e5                	mov    %esp,%ebp
80106ba3:	57                   	push   %edi
80106ba4:	56                   	push   %esi
80106ba5:	53                   	push   %ebx
80106ba6:	83 ec 1c             	sub    $0x1c,%esp
80106ba9:	8b 45 08             	mov    0x8(%ebp),%eax
80106bac:	8b 75 10             	mov    0x10(%ebp),%esi
80106baf:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106bb2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106bb5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106bbb:	77 49                	ja     80106c06 <inituvm+0x66>
  mem = kalloc();
80106bbd:	e8 3e bb ff ff       	call   80102700 <kalloc>
  memset(mem, 0, PGSIZE);
80106bc2:	83 ec 04             	sub    $0x4,%esp
80106bc5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106bca:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106bcc:	6a 00                	push   $0x0
80106bce:	50                   	push   %eax
80106bcf:	e8 3c db ff ff       	call   80104710 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106bd4:	58                   	pop    %eax
80106bd5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106bdb:	5a                   	pop    %edx
80106bdc:	6a 06                	push   $0x6
80106bde:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106be3:	31 d2                	xor    %edx,%edx
80106be5:	50                   	push   %eax
80106be6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106be9:	e8 12 fd ff ff       	call   80106900 <mappages>
  memmove(mem, init, sz);
80106bee:	89 75 10             	mov    %esi,0x10(%ebp)
80106bf1:	83 c4 10             	add    $0x10,%esp
80106bf4:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106bf7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106bfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bfd:	5b                   	pop    %ebx
80106bfe:	5e                   	pop    %esi
80106bff:	5f                   	pop    %edi
80106c00:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106c01:	e9 9a db ff ff       	jmp    801047a0 <memmove>
    panic("inituvm: more than a page");
80106c06:	83 ec 0c             	sub    $0xc,%esp
80106c09:	68 0d 7b 10 80       	push   $0x80107b0d
80106c0e:	e8 6d 97 ff ff       	call   80100380 <panic>
80106c13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c20 <loaduvm>:
{
80106c20:	55                   	push   %ebp
80106c21:	89 e5                	mov    %esp,%ebp
80106c23:	57                   	push   %edi
80106c24:	56                   	push   %esi
80106c25:	53                   	push   %ebx
80106c26:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106c29:	8b 75 0c             	mov    0xc(%ebp),%esi
{
80106c2c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
80106c2f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106c35:	0f 85 a2 00 00 00    	jne    80106cdd <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
80106c3b:	85 ff                	test   %edi,%edi
80106c3d:	74 7d                	je     80106cbc <loaduvm+0x9c>
80106c3f:	90                   	nop
  pde = &pgdir[PDX(va)];
80106c40:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106c43:	8b 55 08             	mov    0x8(%ebp),%edx
80106c46:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80106c48:	89 c1                	mov    %eax,%ecx
80106c4a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106c4d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80106c50:	f6 c1 01             	test   $0x1,%cl
80106c53:	75 13                	jne    80106c68 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80106c55:	83 ec 0c             	sub    $0xc,%esp
80106c58:	68 27 7b 10 80       	push   $0x80107b27
80106c5d:	e8 1e 97 ff ff       	call   80100380 <panic>
80106c62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106c68:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c6b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106c71:	25 fc 0f 00 00       	and    $0xffc,%eax
80106c76:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106c7d:	85 c9                	test   %ecx,%ecx
80106c7f:	74 d4                	je     80106c55 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80106c81:	89 fb                	mov    %edi,%ebx
80106c83:	b8 00 10 00 00       	mov    $0x1000,%eax
80106c88:	29 f3                	sub    %esi,%ebx
80106c8a:	39 c3                	cmp    %eax,%ebx
80106c8c:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c8f:	53                   	push   %ebx
80106c90:	8b 45 14             	mov    0x14(%ebp),%eax
80106c93:	01 f0                	add    %esi,%eax
80106c95:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80106c96:	8b 01                	mov    (%ecx),%eax
80106c98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c9d:	05 00 00 00 80       	add    $0x80000000,%eax
80106ca2:	50                   	push   %eax
80106ca3:	ff 75 10             	push   0x10(%ebp)
80106ca6:	e8 55 ae ff ff       	call   80101b00 <readi>
80106cab:	83 c4 10             	add    $0x10,%esp
80106cae:	39 d8                	cmp    %ebx,%eax
80106cb0:	75 1e                	jne    80106cd0 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80106cb2:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106cb8:	39 fe                	cmp    %edi,%esi
80106cba:	72 84                	jb     80106c40 <loaduvm+0x20>
}
80106cbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106cbf:	31 c0                	xor    %eax,%eax
}
80106cc1:	5b                   	pop    %ebx
80106cc2:	5e                   	pop    %esi
80106cc3:	5f                   	pop    %edi
80106cc4:	5d                   	pop    %ebp
80106cc5:	c3                   	ret
80106cc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ccd:	8d 76 00             	lea    0x0(%esi),%esi
80106cd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106cd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106cd8:	5b                   	pop    %ebx
80106cd9:	5e                   	pop    %esi
80106cda:	5f                   	pop    %edi
80106cdb:	5d                   	pop    %ebp
80106cdc:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80106cdd:	83 ec 0c             	sub    $0xc,%esp
80106ce0:	68 c8 7b 10 80       	push   $0x80107bc8
80106ce5:	e8 96 96 ff ff       	call   80100380 <panic>
80106cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106cf0 <allocuvm>:
{
80106cf0:	55                   	push   %ebp
80106cf1:	89 e5                	mov    %esp,%ebp
80106cf3:	57                   	push   %edi
80106cf4:	56                   	push   %esi
80106cf5:	53                   	push   %ebx
80106cf6:	83 ec 1c             	sub    $0x1c,%esp
80106cf9:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
80106cfc:	85 f6                	test   %esi,%esi
80106cfe:	0f 88 98 00 00 00    	js     80106d9c <allocuvm+0xac>
80106d04:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80106d06:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106d09:	0f 82 a1 00 00 00    	jb     80106db0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d12:	05 ff 0f 00 00       	add    $0xfff,%eax
80106d17:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d1c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
80106d1e:	39 f0                	cmp    %esi,%eax
80106d20:	0f 83 8d 00 00 00    	jae    80106db3 <allocuvm+0xc3>
80106d26:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80106d29:	eb 44                	jmp    80106d6f <allocuvm+0x7f>
80106d2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d2f:	90                   	nop
    memset(mem, 0, PGSIZE);
80106d30:	83 ec 04             	sub    $0x4,%esp
80106d33:	68 00 10 00 00       	push   $0x1000
80106d38:	6a 00                	push   $0x0
80106d3a:	50                   	push   %eax
80106d3b:	e8 d0 d9 ff ff       	call   80104710 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106d40:	58                   	pop    %eax
80106d41:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d47:	5a                   	pop    %edx
80106d48:	6a 06                	push   $0x6
80106d4a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d4f:	89 fa                	mov    %edi,%edx
80106d51:	50                   	push   %eax
80106d52:	8b 45 08             	mov    0x8(%ebp),%eax
80106d55:	e8 a6 fb ff ff       	call   80106900 <mappages>
80106d5a:	83 c4 10             	add    $0x10,%esp
80106d5d:	85 c0                	test   %eax,%eax
80106d5f:	78 5f                	js     80106dc0 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80106d61:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106d67:	39 f7                	cmp    %esi,%edi
80106d69:	0f 83 89 00 00 00    	jae    80106df8 <allocuvm+0x108>
    mem = kalloc();
80106d6f:	e8 8c b9 ff ff       	call   80102700 <kalloc>
80106d74:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106d76:	85 c0                	test   %eax,%eax
80106d78:	75 b6                	jne    80106d30 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106d7a:	83 ec 0c             	sub    $0xc,%esp
80106d7d:	68 45 7b 10 80       	push   $0x80107b45
80106d82:	e8 29 99 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106d87:	83 c4 10             	add    $0x10,%esp
80106d8a:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106d8d:	74 0d                	je     80106d9c <allocuvm+0xac>
80106d8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d92:	8b 45 08             	mov    0x8(%ebp),%eax
80106d95:	89 f2                	mov    %esi,%edx
80106d97:	e8 a4 fa ff ff       	call   80106840 <deallocuvm.part.0>
    return 0;
80106d9c:	31 d2                	xor    %edx,%edx
}
80106d9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106da1:	89 d0                	mov    %edx,%eax
80106da3:	5b                   	pop    %ebx
80106da4:	5e                   	pop    %esi
80106da5:	5f                   	pop    %edi
80106da6:	5d                   	pop    %ebp
80106da7:	c3                   	ret
80106da8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106daf:	90                   	nop
    return oldsz;
80106db0:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80106db3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106db6:	89 d0                	mov    %edx,%eax
80106db8:	5b                   	pop    %ebx
80106db9:	5e                   	pop    %esi
80106dba:	5f                   	pop    %edi
80106dbb:	5d                   	pop    %ebp
80106dbc:	c3                   	ret
80106dbd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106dc0:	83 ec 0c             	sub    $0xc,%esp
80106dc3:	68 5d 7b 10 80       	push   $0x80107b5d
80106dc8:	e8 e3 98 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106dcd:	83 c4 10             	add    $0x10,%esp
80106dd0:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106dd3:	74 0d                	je     80106de2 <allocuvm+0xf2>
80106dd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106dd8:	8b 45 08             	mov    0x8(%ebp),%eax
80106ddb:	89 f2                	mov    %esi,%edx
80106ddd:	e8 5e fa ff ff       	call   80106840 <deallocuvm.part.0>
      kfree(mem);
80106de2:	83 ec 0c             	sub    $0xc,%esp
80106de5:	53                   	push   %ebx
80106de6:	e8 55 b7 ff ff       	call   80102540 <kfree>
      return 0;
80106deb:	83 c4 10             	add    $0x10,%esp
    return 0;
80106dee:	31 d2                	xor    %edx,%edx
80106df0:	eb ac                	jmp    80106d9e <allocuvm+0xae>
80106df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106df8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
80106dfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dfe:	5b                   	pop    %ebx
80106dff:	5e                   	pop    %esi
80106e00:	89 d0                	mov    %edx,%eax
80106e02:	5f                   	pop    %edi
80106e03:	5d                   	pop    %ebp
80106e04:	c3                   	ret
80106e05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e10 <deallocuvm>:
{
80106e10:	55                   	push   %ebp
80106e11:	89 e5                	mov    %esp,%ebp
80106e13:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e16:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106e19:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106e1c:	39 d1                	cmp    %edx,%ecx
80106e1e:	73 10                	jae    80106e30 <deallocuvm+0x20>
}
80106e20:	5d                   	pop    %ebp
80106e21:	e9 1a fa ff ff       	jmp    80106840 <deallocuvm.part.0>
80106e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e2d:	8d 76 00             	lea    0x0(%esi),%esi
80106e30:	89 d0                	mov    %edx,%eax
80106e32:	5d                   	pop    %ebp
80106e33:	c3                   	ret
80106e34:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e3f:	90                   	nop

80106e40 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	57                   	push   %edi
80106e44:	56                   	push   %esi
80106e45:	53                   	push   %ebx
80106e46:	83 ec 0c             	sub    $0xc,%esp
80106e49:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106e4c:	85 f6                	test   %esi,%esi
80106e4e:	74 59                	je     80106ea9 <freevm+0x69>
  if(newsz >= oldsz)
80106e50:	31 c9                	xor    %ecx,%ecx
80106e52:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106e57:	89 f0                	mov    %esi,%eax
80106e59:	89 f3                	mov    %esi,%ebx
80106e5b:	e8 e0 f9 ff ff       	call   80106840 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106e60:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106e66:	eb 0f                	jmp    80106e77 <freevm+0x37>
80106e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e6f:	90                   	nop
80106e70:	83 c3 04             	add    $0x4,%ebx
80106e73:	39 fb                	cmp    %edi,%ebx
80106e75:	74 23                	je     80106e9a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106e77:	8b 03                	mov    (%ebx),%eax
80106e79:	a8 01                	test   $0x1,%al
80106e7b:	74 f3                	je     80106e70 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106e7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106e82:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106e85:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106e88:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106e8d:	50                   	push   %eax
80106e8e:	e8 ad b6 ff ff       	call   80102540 <kfree>
80106e93:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106e96:	39 fb                	cmp    %edi,%ebx
80106e98:	75 dd                	jne    80106e77 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106e9a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ea0:	5b                   	pop    %ebx
80106ea1:	5e                   	pop    %esi
80106ea2:	5f                   	pop    %edi
80106ea3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106ea4:	e9 97 b6 ff ff       	jmp    80102540 <kfree>
    panic("freevm: no pgdir");
80106ea9:	83 ec 0c             	sub    $0xc,%esp
80106eac:	68 79 7b 10 80       	push   $0x80107b79
80106eb1:	e8 ca 94 ff ff       	call   80100380 <panic>
80106eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ebd:	8d 76 00             	lea    0x0(%esi),%esi

80106ec0 <setupkvm>:
{
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	56                   	push   %esi
80106ec4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106ec5:	e8 36 b8 ff ff       	call   80102700 <kalloc>
80106eca:	85 c0                	test   %eax,%eax
80106ecc:	74 5e                	je     80106f2c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
80106ece:	83 ec 04             	sub    $0x4,%esp
80106ed1:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106ed3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106ed8:	68 00 10 00 00       	push   $0x1000
80106edd:	6a 00                	push   $0x0
80106edf:	50                   	push   %eax
80106ee0:	e8 2b d8 ff ff       	call   80104710 <memset>
80106ee5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106ee8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106eeb:	83 ec 08             	sub    $0x8,%esp
80106eee:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106ef1:	8b 13                	mov    (%ebx),%edx
80106ef3:	ff 73 0c             	push   0xc(%ebx)
80106ef6:	50                   	push   %eax
80106ef7:	29 c1                	sub    %eax,%ecx
80106ef9:	89 f0                	mov    %esi,%eax
80106efb:	e8 00 fa ff ff       	call   80106900 <mappages>
80106f00:	83 c4 10             	add    $0x10,%esp
80106f03:	85 c0                	test   %eax,%eax
80106f05:	78 19                	js     80106f20 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f07:	83 c3 10             	add    $0x10,%ebx
80106f0a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106f10:	75 d6                	jne    80106ee8 <setupkvm+0x28>
}
80106f12:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f15:	89 f0                	mov    %esi,%eax
80106f17:	5b                   	pop    %ebx
80106f18:	5e                   	pop    %esi
80106f19:	5d                   	pop    %ebp
80106f1a:	c3                   	ret
80106f1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f1f:	90                   	nop
      freevm(pgdir);
80106f20:	83 ec 0c             	sub    $0xc,%esp
80106f23:	56                   	push   %esi
80106f24:	e8 17 ff ff ff       	call   80106e40 <freevm>
      return 0;
80106f29:	83 c4 10             	add    $0x10,%esp
}
80106f2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
80106f2f:	31 f6                	xor    %esi,%esi
}
80106f31:	89 f0                	mov    %esi,%eax
80106f33:	5b                   	pop    %ebx
80106f34:	5e                   	pop    %esi
80106f35:	5d                   	pop    %ebp
80106f36:	c3                   	ret
80106f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f3e:	66 90                	xchg   %ax,%ax

80106f40 <kvmalloc>:
{
80106f40:	55                   	push   %ebp
80106f41:	89 e5                	mov    %esp,%ebp
80106f43:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106f46:	e8 75 ff ff ff       	call   80106ec0 <setupkvm>
80106f4b:	a3 c4 44 11 80       	mov    %eax,0x801144c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f50:	05 00 00 00 80       	add    $0x80000000,%eax
80106f55:	0f 22 d8             	mov    %eax,%cr3
}
80106f58:	c9                   	leave
80106f59:	c3                   	ret
80106f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f60 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	83 ec 08             	sub    $0x8,%esp
80106f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106f69:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80106f6c:	89 c1                	mov    %eax,%ecx
80106f6e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106f71:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80106f74:	f6 c2 01             	test   $0x1,%dl
80106f77:	75 17                	jne    80106f90 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106f79:	83 ec 0c             	sub    $0xc,%esp
80106f7c:	68 8a 7b 10 80       	push   $0x80107b8a
80106f81:	e8 fa 93 ff ff       	call   80100380 <panic>
80106f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f8d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106f90:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f93:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106f99:	25 fc 0f 00 00       	and    $0xffc,%eax
80106f9e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80106fa5:	85 c0                	test   %eax,%eax
80106fa7:	74 d0                	je     80106f79 <clearpteu+0x19>
  *pte &= ~PTE_U;
80106fa9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106fac:	c9                   	leave
80106fad:	c3                   	ret
80106fae:	66 90                	xchg   %ax,%ax

80106fb0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106fb0:	55                   	push   %ebp
80106fb1:	89 e5                	mov    %esp,%ebp
80106fb3:	57                   	push   %edi
80106fb4:	56                   	push   %esi
80106fb5:	53                   	push   %ebx
80106fb6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106fb9:	e8 02 ff ff ff       	call   80106ec0 <setupkvm>
80106fbe:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106fc1:	85 c0                	test   %eax,%eax
80106fc3:	0f 84 dd 00 00 00    	je     801070a6 <copyuvm+0xf6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106fc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106fcc:	85 c9                	test   %ecx,%ecx
80106fce:	0f 84 b3 00 00 00    	je     80107087 <copyuvm+0xd7>
80106fd4:	31 f6                	xor    %esi,%esi
80106fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fdd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80106fe0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80106fe3:	89 f0                	mov    %esi,%eax
80106fe5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106fe8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
80106feb:	a8 01                	test   $0x1,%al
80106fed:	75 11                	jne    80107000 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106fef:	83 ec 0c             	sub    $0xc,%esp
80106ff2:	68 94 7b 10 80       	push   $0x80107b94
80106ff7:	e8 84 93 ff ff       	call   80100380 <panic>
80106ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107000:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107002:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107007:	c1 ea 0a             	shr    $0xa,%edx
8010700a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107010:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107017:	85 c0                	test   %eax,%eax
80107019:	74 d4                	je     80106fef <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010701b:	8b 18                	mov    (%eax),%ebx
8010701d:	f6 c3 01             	test   $0x1,%bl
80107020:	0f 84 92 00 00 00    	je     801070b8 <copyuvm+0x108>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107026:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80107028:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
8010702e:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107034:	e8 c7 b6 ff ff       	call   80102700 <kalloc>
80107039:	85 c0                	test   %eax,%eax
8010703b:	74 5b                	je     80107098 <copyuvm+0xe8>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010703d:	83 ec 04             	sub    $0x4,%esp
80107040:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107046:	68 00 10 00 00       	push   $0x1000
8010704b:	57                   	push   %edi
8010704c:	50                   	push   %eax
8010704d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107050:	e8 4b d7 ff ff       	call   801047a0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107055:	58                   	pop    %eax
80107056:	5a                   	pop    %edx
80107057:	53                   	push   %ebx
80107058:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010705b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107060:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107066:	52                   	push   %edx
80107067:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010706a:	89 f2                	mov    %esi,%edx
8010706c:	e8 8f f8 ff ff       	call   80106900 <mappages>
80107071:	83 c4 10             	add    $0x10,%esp
80107074:	85 c0                	test   %eax,%eax
80107076:	78 20                	js     80107098 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107078:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010707e:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107081:	0f 82 59 ff ff ff    	jb     80106fe0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107087:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010708a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010708d:	5b                   	pop    %ebx
8010708e:	5e                   	pop    %esi
8010708f:	5f                   	pop    %edi
80107090:	5d                   	pop    %ebp
80107091:	c3                   	ret
80107092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(d);
80107098:	83 ec 0c             	sub    $0xc,%esp
8010709b:	ff 75 e0             	push   -0x20(%ebp)
8010709e:	e8 9d fd ff ff       	call   80106e40 <freevm>
  return 0;
801070a3:	83 c4 10             	add    $0x10,%esp
    return 0;
801070a6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801070ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070b3:	5b                   	pop    %ebx
801070b4:	5e                   	pop    %esi
801070b5:	5f                   	pop    %edi
801070b6:	5d                   	pop    %ebp
801070b7:	c3                   	ret
      panic("copyuvm: page not present");
801070b8:	83 ec 0c             	sub    $0xc,%esp
801070bb:	68 ae 7b 10 80       	push   $0x80107bae
801070c0:	e8 bb 92 ff ff       	call   80100380 <panic>
801070c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801070d0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801070d6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801070d9:	89 c1                	mov    %eax,%ecx
801070db:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801070de:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801070e1:	f6 c2 01             	test   $0x1,%dl
801070e4:	0f 84 00 01 00 00    	je     801071ea <uva2ka.cold>
  return &pgtab[PTX(va)];
801070ea:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070ed:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801070f3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801070f4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801070f9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107100:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107102:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107107:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010710a:	05 00 00 00 80       	add    $0x80000000,%eax
8010710f:	83 fa 05             	cmp    $0x5,%edx
80107112:	ba 00 00 00 00       	mov    $0x0,%edx
80107117:	0f 45 c2             	cmovne %edx,%eax
}
8010711a:	c3                   	ret
8010711b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010711f:	90                   	nop

80107120 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107120:	55                   	push   %ebp
80107121:	89 e5                	mov    %esp,%ebp
80107123:	57                   	push   %edi
80107124:	56                   	push   %esi
80107125:	53                   	push   %ebx
80107126:	83 ec 0c             	sub    $0xc,%esp
80107129:	8b 75 14             	mov    0x14(%ebp),%esi
8010712c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010712f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107132:	85 f6                	test   %esi,%esi
80107134:	75 51                	jne    80107187 <copyout+0x67>
80107136:	e9 a5 00 00 00       	jmp    801071e0 <copyout+0xc0>
8010713b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010713f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107140:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107146:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010714c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107152:	74 75                	je     801071c9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107154:	89 fb                	mov    %edi,%ebx
80107156:	29 c3                	sub    %eax,%ebx
80107158:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010715e:	39 f3                	cmp    %esi,%ebx
80107160:	0f 47 de             	cmova  %esi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107163:	29 f8                	sub    %edi,%eax
80107165:	83 ec 04             	sub    $0x4,%esp
80107168:	01 c1                	add    %eax,%ecx
8010716a:	53                   	push   %ebx
8010716b:	52                   	push   %edx
8010716c:	89 55 10             	mov    %edx,0x10(%ebp)
8010716f:	51                   	push   %ecx
80107170:	e8 2b d6 ff ff       	call   801047a0 <memmove>
    len -= n;
    buf += n;
80107175:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107178:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010717e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107181:	01 da                	add    %ebx,%edx
  while(len > 0){
80107183:	29 de                	sub    %ebx,%esi
80107185:	74 59                	je     801071e0 <copyout+0xc0>
  if(*pde & PTE_P){
80107187:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010718a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010718c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010718e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107191:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107197:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010719a:	f6 c1 01             	test   $0x1,%cl
8010719d:	0f 84 4e 00 00 00    	je     801071f1 <copyout.cold>
  return &pgtab[PTX(va)];
801071a3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071a5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801071ab:	c1 eb 0c             	shr    $0xc,%ebx
801071ae:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801071b4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801071bb:	89 d9                	mov    %ebx,%ecx
801071bd:	83 e1 05             	and    $0x5,%ecx
801071c0:	83 f9 05             	cmp    $0x5,%ecx
801071c3:	0f 84 77 ff ff ff    	je     80107140 <copyout+0x20>
  }
  return 0;
}
801071c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801071cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071d1:	5b                   	pop    %ebx
801071d2:	5e                   	pop    %esi
801071d3:	5f                   	pop    %edi
801071d4:	5d                   	pop    %ebp
801071d5:	c3                   	ret
801071d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071dd:	8d 76 00             	lea    0x0(%esi),%esi
801071e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801071e3:	31 c0                	xor    %eax,%eax
}
801071e5:	5b                   	pop    %ebx
801071e6:	5e                   	pop    %esi
801071e7:	5f                   	pop    %edi
801071e8:	5d                   	pop    %ebp
801071e9:	c3                   	ret

801071ea <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801071ea:	a1 00 00 00 00       	mov    0x0,%eax
801071ef:	0f 0b                	ud2

801071f1 <copyout.cold>:
801071f1:	a1 00 00 00 00       	mov    0x0,%eax
801071f6:	0f 0b                	ud2
