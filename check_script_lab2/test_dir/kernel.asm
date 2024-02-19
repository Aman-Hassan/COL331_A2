
kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <multiboot_header>:
  100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
  100006:	00 00                	add    %al,(%eax)
  100008:	fe 4f 52             	decb   0x52(%edi)
  10000b:	e4                   	.byte 0xe4

0010000c <_start>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
  10000c:	bc b0 04 11 00       	mov    $0x1104b0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
  100011:	b8 68 08 10 00       	mov    $0x100868,%eax
  jmp *%eax
  100016:	ff e0                	jmp    *%eax

00100018 <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
  100018:	55                   	push   %ebp
  100019:	89 e5                	mov    %esp,%ebp
  10001b:	83 ec 08             	sub    $0x8,%esp
  10001e:	8b 55 08             	mov    0x8(%ebp),%edx
  100021:	8b 45 0c             	mov    0xc(%ebp),%eax
  100024:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
  100028:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  10002c:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100030:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  100034:	66 ef                	out    %ax,(%dx)
}
  100036:	90                   	nop
  100037:	c9                   	leave  
  100038:	c3                   	ret    

00100039 <cli>:
  return eflags;
}

static inline void
cli(void)
{
  100039:	55                   	push   %ebp
  10003a:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
  10003c:	fa                   	cli    
}
  10003d:	90                   	nop
  10003e:	5d                   	pop    %ebp
  10003f:	c3                   	ret    

00100040 <printint>:

static int panicked = 0;

static void
printint(int xx, int base, int sign)
{
  100040:	55                   	push   %ebp
  100041:	89 e5                	mov    %esp,%ebp
  100043:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
  100046:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10004a:	74 1c                	je     100068 <printint+0x28>
  10004c:	8b 45 08             	mov    0x8(%ebp),%eax
  10004f:	c1 e8 1f             	shr    $0x1f,%eax
  100052:	0f b6 c0             	movzbl %al,%eax
  100055:	89 45 10             	mov    %eax,0x10(%ebp)
  100058:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10005c:	74 0a                	je     100068 <printint+0x28>
    x = -xx;
  10005e:	8b 45 08             	mov    0x8(%ebp),%eax
  100061:	f7 d8                	neg    %eax
  100063:	89 45 f0             	mov    %eax,-0x10(%ebp)
  100066:	eb 06                	jmp    10006e <printint+0x2e>
  else
    x = xx;
  100068:	8b 45 08             	mov    0x8(%ebp),%eax
  10006b:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
  10006e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
  100075:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10007b:	ba 00 00 00 00       	mov    $0x0,%edx
  100080:	f7 f1                	div    %ecx
  100082:	89 d1                	mov    %edx,%ecx
  100084:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100087:	8d 50 01             	lea    0x1(%eax),%edx
  10008a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10008d:	0f b6 91 00 50 10 00 	movzbl 0x105000(%ecx),%edx
  100094:	88 54 05 e0          	mov    %dl,-0x20(%ebp,%eax,1)
  }while((x /= base) != 0);
  100098:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  10009b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10009e:	ba 00 00 00 00       	mov    $0x0,%edx
  1000a3:	f7 f1                	div    %ecx
  1000a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1000a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1000ac:	75 c7                	jne    100075 <printint+0x35>

  if(sign)
  1000ae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1000b2:	74 2a                	je     1000de <printint+0x9e>
    buf[i++] = '-';
  1000b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1000b7:	8d 50 01             	lea    0x1(%eax),%edx
  1000ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1000bd:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
  1000c2:	eb 1a                	jmp    1000de <printint+0x9e>
    consputc(buf[i]);
  1000c4:	8d 55 e0             	lea    -0x20(%ebp),%edx
  1000c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1000ca:	01 d0                	add    %edx,%eax
  1000cc:	0f b6 00             	movzbl (%eax),%eax
  1000cf:	0f be c0             	movsbl %al,%eax
  1000d2:	83 ec 0c             	sub    $0xc,%esp
  1000d5:	50                   	push   %eax
  1000d6:	e8 5f 02 00 00       	call   10033a <consputc>
  1000db:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
  1000de:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1000e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1000e6:	79 dc                	jns    1000c4 <printint+0x84>
}
  1000e8:	90                   	nop
  1000e9:	90                   	nop
  1000ea:	c9                   	leave  
  1000eb:	c3                   	ret    

001000ec <cprintf>:

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
  1000ec:	55                   	push   %ebp
  1000ed:	89 e5                	mov    %esp,%ebp
  1000ef:	83 ec 18             	sub    $0x18,%esp
  int i, c;
  uint *argp;
  char *s;

  if (fmt == 0)
  1000f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1000f5:	85 c0                	test   %eax,%eax
  1000f7:	0f 84 63 01 00 00    	je     100260 <cprintf+0x174>
    // panic("null fmt");
    return;

  argp = (uint*)(void*)(&fmt + 1);
  1000fd:	8d 45 0c             	lea    0xc(%ebp),%eax
  100100:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  100103:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10010a:	e9 2f 01 00 00       	jmp    10023e <cprintf+0x152>
    if(c != '%'){
  10010f:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
  100113:	74 13                	je     100128 <cprintf+0x3c>
      consputc(c);
  100115:	83 ec 0c             	sub    $0xc,%esp
  100118:	ff 75 e8             	push   -0x18(%ebp)
  10011b:	e8 1a 02 00 00       	call   10033a <consputc>
  100120:	83 c4 10             	add    $0x10,%esp
      continue;
  100123:	e9 12 01 00 00       	jmp    10023a <cprintf+0x14e>
    }
    c = fmt[++i] & 0xff;
  100128:	8b 55 08             	mov    0x8(%ebp),%edx
  10012b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10012f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100132:	01 d0                	add    %edx,%eax
  100134:	0f b6 00             	movzbl (%eax),%eax
  100137:	0f be c0             	movsbl %al,%eax
  10013a:	25 ff 00 00 00       	and    $0xff,%eax
  10013f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(c == 0)
  100142:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  100146:	0f 84 17 01 00 00    	je     100263 <cprintf+0x177>
      break;
    switch(c){
  10014c:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
  100150:	74 5e                	je     1001b0 <cprintf+0xc4>
  100152:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
  100156:	0f 8f c2 00 00 00    	jg     10021e <cprintf+0x132>
  10015c:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
  100160:	74 6b                	je     1001cd <cprintf+0xe1>
  100162:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
  100166:	0f 8f b2 00 00 00    	jg     10021e <cprintf+0x132>
  10016c:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
  100170:	74 3e                	je     1001b0 <cprintf+0xc4>
  100172:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
  100176:	0f 8f a2 00 00 00    	jg     10021e <cprintf+0x132>
  10017c:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
  100180:	0f 84 89 00 00 00    	je     10020f <cprintf+0x123>
  100186:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
  10018a:	0f 85 8e 00 00 00    	jne    10021e <cprintf+0x132>
    case 'd':
      printint(*argp++, 10, 1);
  100190:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100193:	8d 50 04             	lea    0x4(%eax),%edx
  100196:	89 55 f0             	mov    %edx,-0x10(%ebp)
  100199:	8b 00                	mov    (%eax),%eax
  10019b:	83 ec 04             	sub    $0x4,%esp
  10019e:	6a 01                	push   $0x1
  1001a0:	6a 0a                	push   $0xa
  1001a2:	50                   	push   %eax
  1001a3:	e8 98 fe ff ff       	call   100040 <printint>
  1001a8:	83 c4 10             	add    $0x10,%esp
      break;
  1001ab:	e9 8a 00 00 00       	jmp    10023a <cprintf+0x14e>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
  1001b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1001b3:	8d 50 04             	lea    0x4(%eax),%edx
  1001b6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1001b9:	8b 00                	mov    (%eax),%eax
  1001bb:	83 ec 04             	sub    $0x4,%esp
  1001be:	6a 00                	push   $0x0
  1001c0:	6a 10                	push   $0x10
  1001c2:	50                   	push   %eax
  1001c3:	e8 78 fe ff ff       	call   100040 <printint>
  1001c8:	83 c4 10             	add    $0x10,%esp
      break;
  1001cb:	eb 6d                	jmp    10023a <cprintf+0x14e>
    case 's':
      if((s = (char*)*argp++) == 0)
  1001cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1001d0:	8d 50 04             	lea    0x4(%eax),%edx
  1001d3:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1001d6:	8b 00                	mov    (%eax),%eax
  1001d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1001db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1001df:	75 22                	jne    100203 <cprintf+0x117>
        s = "(null)";
  1001e1:	c7 45 ec c4 3f 10 00 	movl   $0x103fc4,-0x14(%ebp)
      for(; *s; s++)
  1001e8:	eb 19                	jmp    100203 <cprintf+0x117>
        consputc(*s);
  1001ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1001ed:	0f b6 00             	movzbl (%eax),%eax
  1001f0:	0f be c0             	movsbl %al,%eax
  1001f3:	83 ec 0c             	sub    $0xc,%esp
  1001f6:	50                   	push   %eax
  1001f7:	e8 3e 01 00 00       	call   10033a <consputc>
  1001fc:	83 c4 10             	add    $0x10,%esp
      for(; *s; s++)
  1001ff:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100203:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100206:	0f b6 00             	movzbl (%eax),%eax
  100209:	84 c0                	test   %al,%al
  10020b:	75 dd                	jne    1001ea <cprintf+0xfe>
      break;
  10020d:	eb 2b                	jmp    10023a <cprintf+0x14e>
    case '%':
      consputc('%');
  10020f:	83 ec 0c             	sub    $0xc,%esp
  100212:	6a 25                	push   $0x25
  100214:	e8 21 01 00 00       	call   10033a <consputc>
  100219:	83 c4 10             	add    $0x10,%esp
      break;
  10021c:	eb 1c                	jmp    10023a <cprintf+0x14e>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
  10021e:	83 ec 0c             	sub    $0xc,%esp
  100221:	6a 25                	push   $0x25
  100223:	e8 12 01 00 00       	call   10033a <consputc>
  100228:	83 c4 10             	add    $0x10,%esp
      consputc(c);
  10022b:	83 ec 0c             	sub    $0xc,%esp
  10022e:	ff 75 e8             	push   -0x18(%ebp)
  100231:	e8 04 01 00 00       	call   10033a <consputc>
  100236:	83 c4 10             	add    $0x10,%esp
      break;
  100239:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  10023a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10023e:	8b 55 08             	mov    0x8(%ebp),%edx
  100241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100244:	01 d0                	add    %edx,%eax
  100246:	0f b6 00             	movzbl (%eax),%eax
  100249:	0f be c0             	movsbl %al,%eax
  10024c:	25 ff 00 00 00       	and    $0xff,%eax
  100251:	89 45 e8             	mov    %eax,-0x18(%ebp)
  100254:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  100258:	0f 85 b1 fe ff ff    	jne    10010f <cprintf+0x23>
  10025e:	eb 04                	jmp    100264 <cprintf+0x178>
    return;
  100260:	90                   	nop
  100261:	eb 01                	jmp    100264 <cprintf+0x178>
      break;
  100263:	90                   	nop
    }
  }
}
  100264:	c9                   	leave  
  100265:	c3                   	ret    

00100266 <halt>:

void
halt(void)
{
  100266:	55                   	push   %ebp
  100267:	89 e5                	mov    %esp,%ebp
  100269:	83 ec 08             	sub    $0x8,%esp
  cprintf("Bye COL%d!\n\0", 331);
  10026c:	83 ec 08             	sub    $0x8,%esp
  10026f:	68 4b 01 00 00       	push   $0x14b
  100274:	68 cb 3f 10 00       	push   $0x103fcb
  100279:	e8 6e fe ff ff       	call   1000ec <cprintf>
  10027e:	83 c4 10             	add    $0x10,%esp
  outw(0x602, 0x2000);
  100281:	83 ec 08             	sub    $0x8,%esp
  100284:	68 00 20 00 00       	push   $0x2000
  100289:	68 02 06 00 00       	push   $0x602
  10028e:	e8 85 fd ff ff       	call   100018 <outw>
  100293:	83 c4 10             	add    $0x10,%esp
  // For older versions of QEMU, 
  outw(0xB002, 0x2000);
  100296:	83 ec 08             	sub    $0x8,%esp
  100299:	68 00 20 00 00       	push   $0x2000
  10029e:	68 02 b0 00 00       	push   $0xb002
  1002a3:	e8 70 fd ff ff       	call   100018 <outw>
  1002a8:	83 c4 10             	add    $0x10,%esp
  for(;;);
  1002ab:	eb fe                	jmp    1002ab <halt+0x45>

001002ad <panic>:
}

void
panic(char *s)
{
  1002ad:	55                   	push   %ebp
  1002ae:	89 e5                	mov    %esp,%ebp
  1002b0:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];

  cli();
  1002b3:	e8 81 fd ff ff       	call   100039 <cli>
  cprintf("lapicid %d: panic: ", lapicid());
  1002b8:	e8 57 04 00 00       	call   100714 <lapicid>
  1002bd:	83 ec 08             	sub    $0x8,%esp
  1002c0:	50                   	push   %eax
  1002c1:	68 d8 3f 10 00       	push   $0x103fd8
  1002c6:	e8 21 fe ff ff       	call   1000ec <cprintf>
  1002cb:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
  1002ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1002d1:	83 ec 0c             	sub    $0xc,%esp
  1002d4:	50                   	push   %eax
  1002d5:	e8 12 fe ff ff       	call   1000ec <cprintf>
  1002da:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
  1002dd:	83 ec 0c             	sub    $0xc,%esp
  1002e0:	68 ec 3f 10 00       	push   $0x103fec
  1002e5:	e8 02 fe ff ff       	call   1000ec <cprintf>
  1002ea:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
  1002ed:	83 ec 08             	sub    $0x8,%esp
  1002f0:	8d 45 cc             	lea    -0x34(%ebp),%eax
  1002f3:	50                   	push   %eax
  1002f4:	8d 45 08             	lea    0x8(%ebp),%eax
  1002f7:	50                   	push   %eax
  1002f8:	e8 ad 0e 00 00       	call   1011aa <getcallerpcs>
  1002fd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
  100300:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100307:	eb 1c                	jmp    100325 <panic+0x78>
    cprintf(" %p", pcs[i]);
  100309:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10030c:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
  100310:	83 ec 08             	sub    $0x8,%esp
  100313:	50                   	push   %eax
  100314:	68 ee 3f 10 00       	push   $0x103fee
  100319:	e8 ce fd ff ff       	call   1000ec <cprintf>
  10031e:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
  100321:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100325:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
  100329:	7e de                	jle    100309 <panic+0x5c>
  panicked = 1; // freeze other CPU
  10032b:	c7 05 ac 54 10 00 01 	movl   $0x1,0x1054ac
  100332:	00 00 00 
  halt();
  100335:	e8 2c ff ff ff       	call   100266 <halt>

0010033a <consputc>:

#define BACKSPACE 0x100

void
consputc(int c)
{
  10033a:	55                   	push   %ebp
  10033b:	89 e5                	mov    %esp,%ebp
  10033d:	83 ec 08             	sub    $0x8,%esp
  if(c == BACKSPACE){
  100340:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
  100347:	75 29                	jne    100372 <consputc+0x38>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  100349:	83 ec 0c             	sub    $0xc,%esp
  10034c:	6a 08                	push   $0x8
  10034e:	e8 5a 0a 00 00       	call   100dad <uartputc>
  100353:	83 c4 10             	add    $0x10,%esp
  100356:	83 ec 0c             	sub    $0xc,%esp
  100359:	6a 20                	push   $0x20
  10035b:	e8 4d 0a 00 00       	call   100dad <uartputc>
  100360:	83 c4 10             	add    $0x10,%esp
  100363:	83 ec 0c             	sub    $0xc,%esp
  100366:	6a 08                	push   $0x8
  100368:	e8 40 0a 00 00       	call   100dad <uartputc>
  10036d:	83 c4 10             	add    $0x10,%esp
  } else
    uartputc(c);
}
  100370:	eb 0e                	jmp    100380 <consputc+0x46>
    uartputc(c);
  100372:	83 ec 0c             	sub    $0xc,%esp
  100375:	ff 75 08             	push   0x8(%ebp)
  100378:	e8 30 0a 00 00       	call   100dad <uartputc>
  10037d:	83 c4 10             	add    $0x10,%esp
}
  100380:	90                   	nop
  100381:	c9                   	leave  
  100382:	c3                   	ret    

00100383 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
  100383:	55                   	push   %ebp
  100384:	89 e5                	mov    %esp,%ebp
  100386:	83 ec 18             	sub    $0x18,%esp
  int c;

  while((c = getc()) >= 0){
  100389:	e9 17 01 00 00       	jmp    1004a5 <consoleintr+0x122>
    switch(c){
  10038e:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
  100392:	74 63                	je     1003f7 <consoleintr+0x74>
  100394:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
  100398:	0f 8f 8b 00 00 00    	jg     100429 <consoleintr+0xa6>
  10039e:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
  1003a2:	74 53                	je     1003f7 <consoleintr+0x74>
  1003a4:	83 7d f4 15          	cmpl   $0x15,-0xc(%ebp)
  1003a8:	75 7f                	jne    100429 <consoleintr+0xa6>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
  1003aa:	eb 1d                	jmp    1003c9 <consoleintr+0x46>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
  1003ac:	a1 a8 54 10 00       	mov    0x1054a8,%eax
  1003b1:	83 e8 01             	sub    $0x1,%eax
  1003b4:	a3 a8 54 10 00       	mov    %eax,0x1054a8
        consputc(BACKSPACE);
  1003b9:	83 ec 0c             	sub    $0xc,%esp
  1003bc:	68 00 01 00 00       	push   $0x100
  1003c1:	e8 74 ff ff ff       	call   10033a <consputc>
  1003c6:	83 c4 10             	add    $0x10,%esp
      while(input.e != input.w &&
  1003c9:	8b 15 a8 54 10 00    	mov    0x1054a8,%edx
  1003cf:	a1 a4 54 10 00       	mov    0x1054a4,%eax
  1003d4:	39 c2                	cmp    %eax,%edx
  1003d6:	0f 84 c9 00 00 00    	je     1004a5 <consoleintr+0x122>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
  1003dc:	a1 a8 54 10 00       	mov    0x1054a8,%eax
  1003e1:	83 e8 01             	sub    $0x1,%eax
  1003e4:	83 e0 7f             	and    $0x7f,%eax
  1003e7:	0f b6 80 20 54 10 00 	movzbl 0x105420(%eax),%eax
      while(input.e != input.w &&
  1003ee:	3c 0a                	cmp    $0xa,%al
  1003f0:	75 ba                	jne    1003ac <consoleintr+0x29>
      }
      break;
  1003f2:	e9 ae 00 00 00       	jmp    1004a5 <consoleintr+0x122>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
  1003f7:	8b 15 a8 54 10 00    	mov    0x1054a8,%edx
  1003fd:	a1 a4 54 10 00       	mov    0x1054a4,%eax
  100402:	39 c2                	cmp    %eax,%edx
  100404:	0f 84 9b 00 00 00    	je     1004a5 <consoleintr+0x122>
        input.e--;
  10040a:	a1 a8 54 10 00       	mov    0x1054a8,%eax
  10040f:	83 e8 01             	sub    $0x1,%eax
  100412:	a3 a8 54 10 00       	mov    %eax,0x1054a8
        consputc(BACKSPACE);
  100417:	83 ec 0c             	sub    $0xc,%esp
  10041a:	68 00 01 00 00       	push   $0x100
  10041f:	e8 16 ff ff ff       	call   10033a <consputc>
  100424:	83 c4 10             	add    $0x10,%esp
      }
      break;
  100427:	eb 7c                	jmp    1004a5 <consoleintr+0x122>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
  100429:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10042d:	74 75                	je     1004a4 <consoleintr+0x121>
  10042f:	a1 a8 54 10 00       	mov    0x1054a8,%eax
  100434:	8b 15 a0 54 10 00    	mov    0x1054a0,%edx
  10043a:	29 d0                	sub    %edx,%eax
  10043c:	83 f8 7f             	cmp    $0x7f,%eax
  10043f:	77 63                	ja     1004a4 <consoleintr+0x121>
        c = (c == '\r') ? '\n' : c;
  100441:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
  100445:	74 05                	je     10044c <consoleintr+0xc9>
  100447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10044a:	eb 05                	jmp    100451 <consoleintr+0xce>
  10044c:	b8 0a 00 00 00       	mov    $0xa,%eax
  100451:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
  100454:	a1 a8 54 10 00       	mov    0x1054a8,%eax
  100459:	8d 50 01             	lea    0x1(%eax),%edx
  10045c:	89 15 a8 54 10 00    	mov    %edx,0x1054a8
  100462:	83 e0 7f             	and    $0x7f,%eax
  100465:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100468:	88 90 20 54 10 00    	mov    %dl,0x105420(%eax)
        consputc(c);
  10046e:	83 ec 0c             	sub    $0xc,%esp
  100471:	ff 75 f4             	push   -0xc(%ebp)
  100474:	e8 c1 fe ff ff       	call   10033a <consputc>
  100479:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  10047c:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
  100480:	74 18                	je     10049a <consoleintr+0x117>
  100482:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
  100486:	74 12                	je     10049a <consoleintr+0x117>
  100488:	a1 a8 54 10 00       	mov    0x1054a8,%eax
  10048d:	8b 15 a0 54 10 00    	mov    0x1054a0,%edx
  100493:	83 ea 80             	sub    $0xffffff80,%edx
  100496:	39 d0                	cmp    %edx,%eax
  100498:	75 0a                	jne    1004a4 <consoleintr+0x121>
          input.w = input.e;
  10049a:	a1 a8 54 10 00       	mov    0x1054a8,%eax
  10049f:	a3 a4 54 10 00       	mov    %eax,0x1054a4
        }
      }
      break;
  1004a4:	90                   	nop
  while((c = getc()) >= 0){
  1004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1004a8:	ff d0                	call   *%eax
  1004aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1004ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004b1:	0f 89 d7 fe ff ff    	jns    10038e <consoleintr+0xb>
    }
  }
  1004b7:	90                   	nop
  1004b8:	90                   	nop
  1004b9:	c9                   	leave  
  1004ba:	c3                   	ret    

001004bb <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
  1004bb:	55                   	push   %ebp
  1004bc:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
  1004be:	a1 b0 54 10 00       	mov    0x1054b0,%eax
  1004c3:	8b 55 08             	mov    0x8(%ebp),%edx
  1004c6:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
  1004c8:	a1 b0 54 10 00       	mov    0x1054b0,%eax
  1004cd:	8b 40 10             	mov    0x10(%eax),%eax
}
  1004d0:	5d                   	pop    %ebp
  1004d1:	c3                   	ret    

001004d2 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
  1004d2:	55                   	push   %ebp
  1004d3:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
  1004d5:	a1 b0 54 10 00       	mov    0x1054b0,%eax
  1004da:	8b 55 08             	mov    0x8(%ebp),%edx
  1004dd:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
  1004df:	a1 b0 54 10 00       	mov    0x1054b0,%eax
  1004e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1004e7:	89 50 10             	mov    %edx,0x10(%eax)
}
  1004ea:	90                   	nop
  1004eb:	5d                   	pop    %ebp
  1004ec:	c3                   	ret    

001004ed <ioapicinit>:

void
ioapicinit(void)
{
  1004ed:	55                   	push   %ebp
  1004ee:	89 e5                	mov    %esp,%ebp
  1004f0:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  1004f3:	c7 05 b0 54 10 00 00 	movl   $0xfec00000,0x1054b0
  1004fa:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  1004fd:	6a 01                	push   $0x1
  1004ff:	e8 b7 ff ff ff       	call   1004bb <ioapicread>
  100504:	83 c4 04             	add    $0x4,%esp
  100507:	c1 e8 10             	shr    $0x10,%eax
  10050a:	25 ff 00 00 00       	and    $0xff,%eax
  10050f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
  100512:	6a 00                	push   $0x0
  100514:	e8 a2 ff ff ff       	call   1004bb <ioapicread>
  100519:	83 c4 04             	add    $0x4,%esp
  10051c:	c1 e8 18             	shr    $0x18,%eax
  10051f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
  100522:	0f b6 05 c4 54 10 00 	movzbl 0x1054c4,%eax
  100529:	0f b6 c0             	movzbl %al,%eax
  10052c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  10052f:	74 10                	je     100541 <ioapicinit+0x54>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
  100531:	83 ec 0c             	sub    $0xc,%esp
  100534:	68 f4 3f 10 00       	push   $0x103ff4
  100539:	e8 ae fb ff ff       	call   1000ec <cprintf>
  10053e:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  100541:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100548:	eb 3f                	jmp    100589 <ioapicinit+0x9c>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
  10054a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10054d:	83 c0 20             	add    $0x20,%eax
  100550:	0d 00 00 01 00       	or     $0x10000,%eax
  100555:	89 c2                	mov    %eax,%edx
  100557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10055a:	83 c0 08             	add    $0x8,%eax
  10055d:	01 c0                	add    %eax,%eax
  10055f:	83 ec 08             	sub    $0x8,%esp
  100562:	52                   	push   %edx
  100563:	50                   	push   %eax
  100564:	e8 69 ff ff ff       	call   1004d2 <ioapicwrite>
  100569:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
  10056c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10056f:	83 c0 08             	add    $0x8,%eax
  100572:	01 c0                	add    %eax,%eax
  100574:	83 c0 01             	add    $0x1,%eax
  100577:	83 ec 08             	sub    $0x8,%esp
  10057a:	6a 00                	push   $0x0
  10057c:	50                   	push   %eax
  10057d:	e8 50 ff ff ff       	call   1004d2 <ioapicwrite>
  100582:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i <= maxintr; i++){
  100585:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10058c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  10058f:	7e b9                	jle    10054a <ioapicinit+0x5d>
  }
}
  100591:	90                   	nop
  100592:	90                   	nop
  100593:	c9                   	leave  
  100594:	c3                   	ret    

00100595 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  100595:	55                   	push   %ebp
  100596:	89 e5                	mov    %esp,%ebp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  100598:	8b 45 08             	mov    0x8(%ebp),%eax
  10059b:	83 c0 20             	add    $0x20,%eax
  10059e:	89 c2                	mov    %eax,%edx
  1005a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1005a3:	83 c0 08             	add    $0x8,%eax
  1005a6:	01 c0                	add    %eax,%eax
  1005a8:	52                   	push   %edx
  1005a9:	50                   	push   %eax
  1005aa:	e8 23 ff ff ff       	call   1004d2 <ioapicwrite>
  1005af:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
  1005b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005b5:	c1 e0 18             	shl    $0x18,%eax
  1005b8:	89 c2                	mov    %eax,%edx
  1005ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1005bd:	83 c0 08             	add    $0x8,%eax
  1005c0:	01 c0                	add    %eax,%eax
  1005c2:	83 c0 01             	add    $0x1,%eax
  1005c5:	52                   	push   %edx
  1005c6:	50                   	push   %eax
  1005c7:	e8 06 ff ff ff       	call   1004d2 <ioapicwrite>
  1005cc:	83 c4 08             	add    $0x8,%esp
}
  1005cf:	90                   	nop
  1005d0:	c9                   	leave  
  1005d1:	c3                   	ret    

001005d2 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  1005d2:	55                   	push   %ebp
  1005d3:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
  1005d5:	8b 15 b4 54 10 00    	mov    0x1054b4,%edx
  1005db:	8b 45 08             	mov    0x8(%ebp),%eax
  1005de:	c1 e0 02             	shl    $0x2,%eax
  1005e1:	01 c2                	add    %eax,%edx
  1005e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e6:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
  1005e8:	a1 b4 54 10 00       	mov    0x1054b4,%eax
  1005ed:	83 c0 20             	add    $0x20,%eax
  1005f0:	8b 00                	mov    (%eax),%eax
}
  1005f2:	90                   	nop
  1005f3:	5d                   	pop    %ebp
  1005f4:	c3                   	ret    

001005f5 <lapicinit>:

void
lapicinit(void)
{
  1005f5:	55                   	push   %ebp
  1005f6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
  1005f8:	a1 b4 54 10 00       	mov    0x1054b4,%eax
  1005fd:	85 c0                	test   %eax,%eax
  1005ff:	0f 84 0c 01 00 00    	je     100711 <lapicinit+0x11c>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
  100605:	68 3f 01 00 00       	push   $0x13f
  10060a:	6a 3c                	push   $0x3c
  10060c:	e8 c1 ff ff ff       	call   1005d2 <lapicw>
  100611:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
  100614:	6a 0b                	push   $0xb
  100616:	68 f8 00 00 00       	push   $0xf8
  10061b:	e8 b2 ff ff ff       	call   1005d2 <lapicw>
  100620:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
  100623:	68 20 00 02 00       	push   $0x20020
  100628:	68 c8 00 00 00       	push   $0xc8
  10062d:	e8 a0 ff ff ff       	call   1005d2 <lapicw>
  100632:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000);
  100635:	68 80 96 98 00       	push   $0x989680
  10063a:	68 e0 00 00 00       	push   $0xe0
  10063f:	e8 8e ff ff ff       	call   1005d2 <lapicw>
  100644:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
  100647:	68 00 00 01 00       	push   $0x10000
  10064c:	68 d4 00 00 00       	push   $0xd4
  100651:	e8 7c ff ff ff       	call   1005d2 <lapicw>
  100656:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
  100659:	68 00 00 01 00       	push   $0x10000
  10065e:	68 d8 00 00 00       	push   $0xd8
  100663:	e8 6a ff ff ff       	call   1005d2 <lapicw>
  100668:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
  10066b:	a1 b4 54 10 00       	mov    0x1054b4,%eax
  100670:	83 c0 30             	add    $0x30,%eax
  100673:	8b 00                	mov    (%eax),%eax
  100675:	c1 e8 10             	shr    $0x10,%eax
  100678:	25 fc 00 00 00       	and    $0xfc,%eax
  10067d:	85 c0                	test   %eax,%eax
  10067f:	74 12                	je     100693 <lapicinit+0x9e>
    lapicw(PCINT, MASKED);
  100681:	68 00 00 01 00       	push   $0x10000
  100686:	68 d0 00 00 00       	push   $0xd0
  10068b:	e8 42 ff ff ff       	call   1005d2 <lapicw>
  100690:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
  100693:	6a 33                	push   $0x33
  100695:	68 dc 00 00 00       	push   $0xdc
  10069a:	e8 33 ff ff ff       	call   1005d2 <lapicw>
  10069f:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
  1006a2:	6a 00                	push   $0x0
  1006a4:	68 a0 00 00 00       	push   $0xa0
  1006a9:	e8 24 ff ff ff       	call   1005d2 <lapicw>
  1006ae:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
  1006b1:	6a 00                	push   $0x0
  1006b3:	68 a0 00 00 00       	push   $0xa0
  1006b8:	e8 15 ff ff ff       	call   1005d2 <lapicw>
  1006bd:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
  1006c0:	6a 00                	push   $0x0
  1006c2:	6a 2c                	push   $0x2c
  1006c4:	e8 09 ff ff ff       	call   1005d2 <lapicw>
  1006c9:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  1006cc:	6a 00                	push   $0x0
  1006ce:	68 c4 00 00 00       	push   $0xc4
  1006d3:	e8 fa fe ff ff       	call   1005d2 <lapicw>
  1006d8:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  1006db:	68 00 85 08 00       	push   $0x88500
  1006e0:	68 c0 00 00 00       	push   $0xc0
  1006e5:	e8 e8 fe ff ff       	call   1005d2 <lapicw>
  1006ea:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
  1006ed:	90                   	nop
  1006ee:	a1 b4 54 10 00       	mov    0x1054b4,%eax
  1006f3:	05 00 03 00 00       	add    $0x300,%eax
  1006f8:	8b 00                	mov    (%eax),%eax
  1006fa:	25 00 10 00 00       	and    $0x1000,%eax
  1006ff:	85 c0                	test   %eax,%eax
  100701:	75 eb                	jne    1006ee <lapicinit+0xf9>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
  100703:	6a 00                	push   $0x0
  100705:	6a 20                	push   $0x20
  100707:	e8 c6 fe ff ff       	call   1005d2 <lapicw>
  10070c:	83 c4 08             	add    $0x8,%esp
  10070f:	eb 01                	jmp    100712 <lapicinit+0x11d>
    return;
  100711:	90                   	nop
}
  100712:	c9                   	leave  
  100713:	c3                   	ret    

00100714 <lapicid>:

int
lapicid(void)
{
  100714:	55                   	push   %ebp
  100715:	89 e5                	mov    %esp,%ebp
  if (!lapic)
  100717:	a1 b4 54 10 00       	mov    0x1054b4,%eax
  10071c:	85 c0                	test   %eax,%eax
  10071e:	75 07                	jne    100727 <lapicid+0x13>
    return 0;
  100720:	b8 00 00 00 00       	mov    $0x0,%eax
  100725:	eb 0d                	jmp    100734 <lapicid+0x20>
  return lapic[ID] >> 24;
  100727:	a1 b4 54 10 00       	mov    0x1054b4,%eax
  10072c:	83 c0 20             	add    $0x20,%eax
  10072f:	8b 00                	mov    (%eax),%eax
  100731:	c1 e8 18             	shr    $0x18,%eax
}
  100734:	5d                   	pop    %ebp
  100735:	c3                   	ret    

00100736 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  100736:	55                   	push   %ebp
  100737:	89 e5                	mov    %esp,%ebp
  if(lapic)
  100739:	a1 b4 54 10 00       	mov    0x1054b4,%eax
  10073e:	85 c0                	test   %eax,%eax
  100740:	74 0c                	je     10074e <lapiceoi+0x18>
    lapicw(EOI, 0);
  100742:	6a 00                	push   $0x0
  100744:	6a 2c                	push   $0x2c
  100746:	e8 87 fe ff ff       	call   1005d2 <lapicw>
  10074b:	83 c4 08             	add    $0x8,%esp
}
  10074e:	90                   	nop
  10074f:	c9                   	leave  
  100750:	c3                   	ret    

00100751 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
  100751:	55                   	push   %ebp
  100752:	89 e5                	mov    %esp,%ebp
  100754:	90                   	nop
  100755:	5d                   	pop    %ebp
  100756:	c3                   	ret    

00100757 <sti>:


static inline void
sti(void)
{
  100757:	55                   	push   %ebp
  100758:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
  10075a:	fb                   	sti    
}
  10075b:	90                   	nop
  10075c:	5d                   	pop    %ebp
  10075d:	c3                   	ret    

0010075e <wfi>:

static inline void
wfi(void)
{
  10075e:	55                   	push   %ebp
  10075f:	89 e5                	mov    %esp,%ebp
  asm volatile("hlt");
  100761:	f4                   	hlt    
}
  100762:	90                   	nop
  100763:	5d                   	pop    %ebp
  100764:	c3                   	ret    

00100765 <log_test>:
#include "logflag.h"

extern char end[]; // first address after kernel loaded from ELF file

static inline void 
log_test(void) {
  100765:	55                   	push   %ebp
  100766:	89 e5                	mov    %esp,%ebp
  100768:	81 ec 18 02 00 00    	sub    $0x218,%esp
  struct file* gtxt;
  int n;
  char buffer[512];

  if((gtxt=open("/hello.txt", O_RDONLY)) == 0) {
  10076e:	83 ec 08             	sub    $0x8,%esp
  100771:	6a 00                	push   $0x0
  100773:	68 28 40 10 00       	push   $0x104028
  100778:	e8 d8 32 00 00       	call   103a55 <open>
  10077d:	83 c4 10             	add    $0x10,%esp
  100780:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100783:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100787:	75 0d                	jne    100796 <log_test+0x31>
    panic("Unable to open /hello.txt");
  100789:	83 ec 0c             	sub    $0xc,%esp
  10078c:	68 33 40 10 00       	push   $0x104033
  100791:	e8 17 fb ff ff       	call   1002ad <panic>
  } 

  n = fileread(gtxt, buffer, 5);
  100796:	83 ec 04             	sub    $0x4,%esp
  100799:	6a 05                	push   $0x5
  10079b:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  1007a1:	50                   	push   %eax
  1007a2:	ff 75 f4             	push   -0xc(%ebp)
  1007a5:	e8 34 2d 00 00       	call   1034de <fileread>
  1007aa:	83 c4 10             	add    $0x10,%esp
  1007ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cprintf("[UNDOLOG] READ: %d %s\n", n, buffer);
  1007b0:	83 ec 04             	sub    $0x4,%esp
  1007b3:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  1007b9:	50                   	push   %eax
  1007ba:	ff 75 f0             	push   -0x10(%ebp)
  1007bd:	68 4d 40 10 00       	push   $0x10404d
  1007c2:	e8 25 f9 ff ff       	call   1000ec <cprintf>
  1007c7:	83 c4 10             	add    $0x10,%esp
  fileclose(gtxt);
  1007ca:	83 ec 0c             	sub    $0xc,%esp
  1007cd:	ff 75 f4             	push   -0xc(%ebp)
  1007d0:	e8 35 2c 00 00       	call   10340a <fileclose>
  1007d5:	83 c4 10             	add    $0x10,%esp

  buffer[0] = '0' + PANIC_1;
  1007d8:	c6 85 f0 fd ff ff 30 	movb   $0x30,-0x210(%ebp)
  buffer[1] = '0' + PANIC_2;
  1007df:	c6 85 f1 fd ff ff 30 	movb   $0x30,-0x20f(%ebp)
  buffer[2] = '0' + PANIC_3;
  1007e6:	c6 85 f2 fd ff ff 30 	movb   $0x30,-0x20e(%ebp)
  buffer[3] = '0' + PANIC_4;
  1007ed:	c6 85 f3 fd ff ff 30 	movb   $0x30,-0x20d(%ebp)
  buffer[4] = '0' + PANIC_5;
  1007f4:	c6 85 f4 fd ff ff 30 	movb   $0x30,-0x20c(%ebp)

  // Open for writing 
  if((gtxt = open("/hello.txt", O_WRONLY)) == 0){
  1007fb:	83 ec 08             	sub    $0x8,%esp
  1007fe:	6a 01                	push   $0x1
  100800:	68 28 40 10 00       	push   $0x104028
  100805:	e8 4b 32 00 00       	call   103a55 <open>
  10080a:	83 c4 10             	add    $0x10,%esp
  10080d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100810:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100814:	75 0d                	jne    100823 <log_test+0xbe>
    panic("Failed to create /foo/hello.txt");
  100816:	83 ec 0c             	sub    $0xc,%esp
  100819:	68 64 40 10 00       	push   $0x104064
  10081e:	e8 8a fa ff ff       	call   1002ad <panic>
  }  
  n = filewrite(gtxt, buffer, 5);
  100823:	83 ec 04             	sub    $0x4,%esp
  100826:	6a 05                	push   $0x5
  100828:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  10082e:	50                   	push   %eax
  10082f:	ff 75 f4             	push   -0xc(%ebp)
  100832:	e8 26 2d 00 00       	call   10355d <filewrite>
  100837:	83 c4 10             	add    $0x10,%esp
  10083a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cprintf("[UNDOLOG] WRITE: %d %s\n", n, buffer);
  10083d:	83 ec 04             	sub    $0x4,%esp
  100840:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  100846:	50                   	push   %eax
  100847:	ff 75 f0             	push   -0x10(%ebp)
  10084a:	68 84 40 10 00       	push   $0x104084
  10084f:	e8 98 f8 ff ff       	call   1000ec <cprintf>
  100854:	83 c4 10             	add    $0x10,%esp
  fileclose(gtxt);
  100857:	83 ec 0c             	sub    $0xc,%esp
  10085a:	ff 75 f4             	push   -0xc(%ebp)
  10085d:	e8 a8 2b 00 00       	call   10340a <fileclose>
  100862:	83 c4 10             	add    $0x10,%esp
}
  100865:	90                   	nop
  100866:	c9                   	leave  
  100867:	c3                   	ret    

00100868 <main>:

// Bootstrap processor starts running C code here.
int
main(int argc, char* argv[])
{
  100868:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  10086c:	83 e4 f0             	and    $0xfffffff0,%esp
  10086f:	ff 71 fc             	push   -0x4(%ecx)
  100872:	55                   	push   %ebp
  100873:	89 e5                	mov    %esp,%ebp
  100875:	51                   	push   %ecx
  100876:	83 ec 04             	sub    $0x4,%esp
  mpinit();        // detect other processors
  100879:	e8 85 02 00 00       	call   100b03 <mpinit>
  lapicinit();     // interrupt controller
  10087e:	e8 72 fd ff ff       	call   1005f5 <lapicinit>
  picinit();       // disable pic
  100883:	e8 d9 03 00 00       	call   100c61 <picinit>
  ioapicinit();    // another interrupt controller
  100888:	e8 60 fc ff ff       	call   1004ed <ioapicinit>
  uartinit();      // serial port
  10088d:	e8 34 04 00 00       	call   100cc6 <uartinit>
  ideinit();       // disk 
  100892:	e8 00 19 00 00       	call   102197 <ideinit>
  tvinit();        // trap vectors
  100897:	e8 ca 09 00 00       	call   101266 <tvinit>
  binit();         // buffer cache
  10089c:	e8 ea 15 00 00       	call   101e8b <binit>
  idtinit();       // load idt register
  1008a1:	e8 a6 0a 00 00       	call   10134c <idtinit>
  sti();           // enable interrupts
  1008a6:	e8 ac fe ff ff       	call   100757 <sti>
  iinit(ROOTDEV);  // Read superblock to start reading inodes
  1008ab:	83 ec 0c             	sub    $0xc,%esp
  1008ae:	6a 01                	push   $0x1
  1008b0:	e8 c5 1e 00 00       	call   10277a <iinit>
  1008b5:	83 c4 10             	add    $0x10,%esp
  initlog(ROOTDEV);  // Initialize log
  1008b8:	83 ec 0c             	sub    $0xc,%esp
  1008bb:	6a 01                	push   $0x1
  1008bd:	e8 0b 33 00 00       	call   103bcd <initlog>
  1008c2:	83 c4 10             	add    $0x10,%esp
  log_test();
  1008c5:	e8 9b fe ff ff       	call   100765 <log_test>
  for(;;)
    wfi();
  1008ca:	e8 8f fe ff ff       	call   10075e <wfi>
  1008cf:	eb f9                	jmp    1008ca <main+0x62>

001008d1 <inb>:
{
  1008d1:	55                   	push   %ebp
  1008d2:	89 e5                	mov    %esp,%ebp
  1008d4:	83 ec 14             	sub    $0x14,%esp
  1008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1008da:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1008de:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1008e2:	89 c2                	mov    %eax,%edx
  1008e4:	ec                   	in     (%dx),%al
  1008e5:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
  1008e8:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
  1008ec:	c9                   	leave  
  1008ed:	c3                   	ret    

001008ee <outb>:
{
  1008ee:	55                   	push   %ebp
  1008ef:	89 e5                	mov    %esp,%ebp
  1008f1:	83 ec 08             	sub    $0x8,%esp
  1008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1008f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  1008fa:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  1008fe:	89 d0                	mov    %edx,%eax
  100900:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  100903:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
  100907:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  10090b:	ee                   	out    %al,(%dx)
}
  10090c:	90                   	nop
  10090d:	c9                   	leave  
  10090e:	c3                   	ret    

0010090f <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
  10090f:	55                   	push   %ebp
  100910:	89 e5                	mov    %esp,%ebp
  100912:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
  100915:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
  10091c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100923:	eb 15                	jmp    10093a <sum+0x2b>
    sum += addr[i];
  100925:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100928:	8b 45 08             	mov    0x8(%ebp),%eax
  10092b:	01 d0                	add    %edx,%eax
  10092d:	0f b6 00             	movzbl (%eax),%eax
  100930:	0f b6 c0             	movzbl %al,%eax
  100933:	01 45 f8             	add    %eax,-0x8(%ebp)
  for(i=0; i<len; i++)
  100936:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10093a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10093d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  100940:	7c e3                	jl     100925 <sum+0x16>
  return sum;
  100942:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  100945:	c9                   	leave  
  100946:	c3                   	ret    

00100947 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
  100947:	55                   	push   %ebp
  100948:	89 e5                	mov    %esp,%ebp
  10094a:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  // addr = P2V(a);
  addr = (uchar*) a;
  10094d:	8b 45 08             	mov    0x8(%ebp),%eax
  100950:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
  100953:	8b 55 0c             	mov    0xc(%ebp),%edx
  100956:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100959:	01 d0                	add    %edx,%eax
  10095b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
  10095e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100961:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100964:	eb 36                	jmp    10099c <mpsearch1+0x55>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  100966:	83 ec 04             	sub    $0x4,%esp
  100969:	6a 04                	push   $0x4
  10096b:	68 9c 40 10 00       	push   $0x10409c
  100970:	ff 75 f4             	push   -0xc(%ebp)
  100973:	e8 96 05 00 00       	call   100f0e <memcmp>
  100978:	83 c4 10             	add    $0x10,%esp
  10097b:	85 c0                	test   %eax,%eax
  10097d:	75 19                	jne    100998 <mpsearch1+0x51>
  10097f:	83 ec 08             	sub    $0x8,%esp
  100982:	6a 10                	push   $0x10
  100984:	ff 75 f4             	push   -0xc(%ebp)
  100987:	e8 83 ff ff ff       	call   10090f <sum>
  10098c:	83 c4 10             	add    $0x10,%esp
  10098f:	84 c0                	test   %al,%al
  100991:	75 05                	jne    100998 <mpsearch1+0x51>
      return (struct mp*)p;
  100993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100996:	eb 11                	jmp    1009a9 <mpsearch1+0x62>
  for(p = addr; p < e; p += sizeof(struct mp))
  100998:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
  10099c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10099f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1009a2:	72 c2                	jb     100966 <mpsearch1+0x1f>
  return 0;
  1009a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1009a9:	c9                   	leave  
  1009aa:	c3                   	ret    

001009ab <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
  1009ab:	55                   	push   %ebp
  1009ac:	89 e5                	mov    %esp,%ebp
  1009ae:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  // bda = (uchar *) P2V(0x400);
  bda = (uchar *) 0x400;
  1009b1:	c7 45 f4 00 04 00 00 	movl   $0x400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
  1009b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009bb:	83 c0 0f             	add    $0xf,%eax
  1009be:	0f b6 00             	movzbl (%eax),%eax
  1009c1:	0f b6 c0             	movzbl %al,%eax
  1009c4:	c1 e0 08             	shl    $0x8,%eax
  1009c7:	89 c2                	mov    %eax,%edx
  1009c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009cc:	83 c0 0e             	add    $0xe,%eax
  1009cf:	0f b6 00             	movzbl (%eax),%eax
  1009d2:	0f b6 c0             	movzbl %al,%eax
  1009d5:	09 d0                	or     %edx,%eax
  1009d7:	c1 e0 04             	shl    $0x4,%eax
  1009da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1009dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1009e1:	74 21                	je     100a04 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
  1009e3:	83 ec 08             	sub    $0x8,%esp
  1009e6:	68 00 04 00 00       	push   $0x400
  1009eb:	ff 75 f0             	push   -0x10(%ebp)
  1009ee:	e8 54 ff ff ff       	call   100947 <mpsearch1>
  1009f3:	83 c4 10             	add    $0x10,%esp
  1009f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1009f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1009fd:	74 51                	je     100a50 <mpsearch+0xa5>
      return mp;
  1009ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100a02:	eb 61                	jmp    100a65 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
  100a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a07:	83 c0 14             	add    $0x14,%eax
  100a0a:	0f b6 00             	movzbl (%eax),%eax
  100a0d:	0f b6 c0             	movzbl %al,%eax
  100a10:	c1 e0 08             	shl    $0x8,%eax
  100a13:	89 c2                	mov    %eax,%edx
  100a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a18:	83 c0 13             	add    $0x13,%eax
  100a1b:	0f b6 00             	movzbl (%eax),%eax
  100a1e:	0f b6 c0             	movzbl %al,%eax
  100a21:	09 d0                	or     %edx,%eax
  100a23:	c1 e0 0a             	shl    $0xa,%eax
  100a26:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
  100a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a2c:	2d 00 04 00 00       	sub    $0x400,%eax
  100a31:	83 ec 08             	sub    $0x8,%esp
  100a34:	68 00 04 00 00       	push   $0x400
  100a39:	50                   	push   %eax
  100a3a:	e8 08 ff ff ff       	call   100947 <mpsearch1>
  100a3f:	83 c4 10             	add    $0x10,%esp
  100a42:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100a45:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  100a49:	74 05                	je     100a50 <mpsearch+0xa5>
      return mp;
  100a4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100a4e:	eb 15                	jmp    100a65 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
  100a50:	83 ec 08             	sub    $0x8,%esp
  100a53:	68 00 00 01 00       	push   $0x10000
  100a58:	68 00 00 0f 00       	push   $0xf0000
  100a5d:	e8 e5 fe ff ff       	call   100947 <mpsearch1>
  100a62:	83 c4 10             	add    $0x10,%esp
}
  100a65:	c9                   	leave  
  100a66:	c3                   	ret    

00100a67 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
  100a67:	55                   	push   %ebp
  100a68:	89 e5                	mov    %esp,%ebp
  100a6a:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
  100a6d:	e8 39 ff ff ff       	call   1009ab <mpsearch>
  100a72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100a75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a79:	74 0a                	je     100a85 <mpconfig+0x1e>
  100a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a7e:	8b 40 04             	mov    0x4(%eax),%eax
  100a81:	85 c0                	test   %eax,%eax
  100a83:	75 07                	jne    100a8c <mpconfig+0x25>
    return 0;
  100a85:	b8 00 00 00 00       	mov    $0x0,%eax
  100a8a:	eb 75                	jmp    100b01 <mpconfig+0x9a>
  // conf = (struct mpconf*) P2V((uint) mp->physaddr);
  conf = (struct mpconf*) (uint) mp->physaddr;
  100a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a8f:	8b 40 04             	mov    0x4(%eax),%eax
  100a92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
  100a95:	83 ec 04             	sub    $0x4,%esp
  100a98:	6a 04                	push   $0x4
  100a9a:	68 a1 40 10 00       	push   $0x1040a1
  100a9f:	ff 75 f0             	push   -0x10(%ebp)
  100aa2:	e8 67 04 00 00       	call   100f0e <memcmp>
  100aa7:	83 c4 10             	add    $0x10,%esp
  100aaa:	85 c0                	test   %eax,%eax
  100aac:	74 07                	je     100ab5 <mpconfig+0x4e>
    return 0;
  100aae:	b8 00 00 00 00       	mov    $0x0,%eax
  100ab3:	eb 4c                	jmp    100b01 <mpconfig+0x9a>
  if(conf->version != 1 && conf->version != 4)
  100ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ab8:	0f b6 40 06          	movzbl 0x6(%eax),%eax
  100abc:	3c 01                	cmp    $0x1,%al
  100abe:	74 12                	je     100ad2 <mpconfig+0x6b>
  100ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ac3:	0f b6 40 06          	movzbl 0x6(%eax),%eax
  100ac7:	3c 04                	cmp    $0x4,%al
  100ac9:	74 07                	je     100ad2 <mpconfig+0x6b>
    return 0;
  100acb:	b8 00 00 00 00       	mov    $0x0,%eax
  100ad0:	eb 2f                	jmp    100b01 <mpconfig+0x9a>
  if(sum((uchar*)conf, conf->length) != 0)
  100ad2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ad5:	0f b7 40 04          	movzwl 0x4(%eax),%eax
  100ad9:	0f b7 c0             	movzwl %ax,%eax
  100adc:	83 ec 08             	sub    $0x8,%esp
  100adf:	50                   	push   %eax
  100ae0:	ff 75 f0             	push   -0x10(%ebp)
  100ae3:	e8 27 fe ff ff       	call   10090f <sum>
  100ae8:	83 c4 10             	add    $0x10,%esp
  100aeb:	84 c0                	test   %al,%al
  100aed:	74 07                	je     100af6 <mpconfig+0x8f>
    return 0;
  100aef:	b8 00 00 00 00       	mov    $0x0,%eax
  100af4:	eb 0b                	jmp    100b01 <mpconfig+0x9a>
  *pmp = mp;
  100af6:	8b 45 08             	mov    0x8(%ebp),%eax
  100af9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100afc:	89 10                	mov    %edx,(%eax)
  return conf;
  100afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100b01:	c9                   	leave  
  100b02:	c3                   	ret    

00100b03 <mpinit>:

void
mpinit(void)
{
  100b03:	55                   	push   %ebp
  100b04:	89 e5                	mov    %esp,%ebp
  100b06:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
  100b09:	83 ec 0c             	sub    $0xc,%esp
  100b0c:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100b0f:	50                   	push   %eax
  100b10:	e8 52 ff ff ff       	call   100a67 <mpconfig>
  100b15:	83 c4 10             	add    $0x10,%esp
  100b18:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100b1b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  100b1f:	75 0d                	jne    100b2e <mpinit+0x2b>
    panic("Expect to run on an SMP");
  100b21:	83 ec 0c             	sub    $0xc,%esp
  100b24:	68 a6 40 10 00       	push   $0x1040a6
  100b29:	e8 7f f7 ff ff       	call   1002ad <panic>
  ismp = 1;
  100b2e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  lapic = (uint*)conf->lapicaddr;
  100b35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100b38:	8b 40 24             	mov    0x24(%eax),%eax
  100b3b:	a3 b4 54 10 00       	mov    %eax,0x1054b4
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  100b40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100b43:	83 c0 2c             	add    $0x2c,%eax
  100b46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100b49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100b4c:	0f b7 40 04          	movzwl 0x4(%eax),%eax
  100b50:	0f b7 d0             	movzwl %ax,%edx
  100b53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100b56:	01 d0                	add    %edx,%eax
  100b58:	89 45 e8             	mov    %eax,-0x18(%ebp)
  100b5b:	e9 83 00 00 00       	jmp    100be3 <mpinit+0xe0>
    switch(*p){
  100b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b63:	0f b6 00             	movzbl (%eax),%eax
  100b66:	0f b6 c0             	movzbl %al,%eax
  100b69:	83 f8 04             	cmp    $0x4,%eax
  100b6c:	7f 6d                	jg     100bdb <mpinit+0xd8>
  100b6e:	83 f8 03             	cmp    $0x3,%eax
  100b71:	7d 62                	jge    100bd5 <mpinit+0xd2>
  100b73:	83 f8 02             	cmp    $0x2,%eax
  100b76:	74 45                	je     100bbd <mpinit+0xba>
  100b78:	83 f8 02             	cmp    $0x2,%eax
  100b7b:	7f 5e                	jg     100bdb <mpinit+0xd8>
  100b7d:	85 c0                	test   %eax,%eax
  100b7f:	74 07                	je     100b88 <mpinit+0x85>
  100b81:	83 f8 01             	cmp    $0x1,%eax
  100b84:	74 4f                	je     100bd5 <mpinit+0xd2>
  100b86:	eb 53                	jmp    100bdb <mpinit+0xd8>
    case MPPROC:
      proc = (struct mpproc*)p;
  100b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b8b:	89 45 e0             	mov    %eax,-0x20(%ebp)
      if(ncpu < NCPU) {
  100b8e:	a1 c0 54 10 00       	mov    0x1054c0,%eax
  100b93:	83 f8 07             	cmp    $0x7,%eax
  100b96:	7f 1f                	jg     100bb7 <mpinit+0xb4>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
  100b98:	a1 c0 54 10 00       	mov    0x1054c0,%eax
  100b9d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100ba0:	0f b6 52 01          	movzbl 0x1(%edx),%edx
  100ba4:	88 90 b8 54 10 00    	mov    %dl,0x1054b8(%eax)
        ncpu++;
  100baa:	a1 c0 54 10 00       	mov    0x1054c0,%eax
  100baf:	83 c0 01             	add    $0x1,%eax
  100bb2:	a3 c0 54 10 00       	mov    %eax,0x1054c0
      }
      p += sizeof(struct mpproc);
  100bb7:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
  100bbb:	eb 26                	jmp    100be3 <mpinit+0xe0>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
  100bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bc0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
  100bc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100bc6:	0f b6 40 01          	movzbl 0x1(%eax),%eax
  100bca:	a2 c4 54 10 00       	mov    %al,0x1054c4
      p += sizeof(struct mpioapic);
  100bcf:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
  100bd3:	eb 0e                	jmp    100be3 <mpinit+0xe0>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
  100bd5:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
  100bd9:	eb 08                	jmp    100be3 <mpinit+0xe0>
    default:
      ismp = 0;
  100bdb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      break;
  100be2:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  100be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100be6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  100be9:	0f 82 71 ff ff ff    	jb     100b60 <mpinit+0x5d>
    }
  }
  if(!ismp)
  100bef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bf3:	75 0d                	jne    100c02 <mpinit+0xff>
    panic("Didn't find a suitable machine");
  100bf5:	83 ec 0c             	sub    $0xc,%esp
  100bf8:	68 c0 40 10 00       	push   $0x1040c0
  100bfd:	e8 ab f6 ff ff       	call   1002ad <panic>

  if(mp->imcrp){
  100c02:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100c05:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
  100c09:	84 c0                	test   %al,%al
  100c0b:	74 30                	je     100c3d <mpinit+0x13a>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
  100c0d:	83 ec 08             	sub    $0x8,%esp
  100c10:	6a 70                	push   $0x70
  100c12:	6a 22                	push   $0x22
  100c14:	e8 d5 fc ff ff       	call   1008ee <outb>
  100c19:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  100c1c:	83 ec 0c             	sub    $0xc,%esp
  100c1f:	6a 23                	push   $0x23
  100c21:	e8 ab fc ff ff       	call   1008d1 <inb>
  100c26:	83 c4 10             	add    $0x10,%esp
  100c29:	83 c8 01             	or     $0x1,%eax
  100c2c:	0f b6 c0             	movzbl %al,%eax
  100c2f:	83 ec 08             	sub    $0x8,%esp
  100c32:	50                   	push   %eax
  100c33:	6a 23                	push   $0x23
  100c35:	e8 b4 fc ff ff       	call   1008ee <outb>
  100c3a:	83 c4 10             	add    $0x10,%esp
  }
}
  100c3d:	90                   	nop
  100c3e:	c9                   	leave  
  100c3f:	c3                   	ret    

00100c40 <outb>:
{
  100c40:	55                   	push   %ebp
  100c41:	89 e5                	mov    %esp,%ebp
  100c43:	83 ec 08             	sub    $0x8,%esp
  100c46:	8b 45 08             	mov    0x8(%ebp),%eax
  100c49:	8b 55 0c             	mov    0xc(%ebp),%edx
  100c4c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  100c50:	89 d0                	mov    %edx,%eax
  100c52:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  100c55:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
  100c59:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  100c5d:	ee                   	out    %al,(%dx)
}
  100c5e:	90                   	nop
  100c5f:	c9                   	leave  
  100c60:	c3                   	ret    

00100c61 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
  100c61:	55                   	push   %ebp
  100c62:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  100c64:	68 ff 00 00 00       	push   $0xff
  100c69:	6a 21                	push   $0x21
  100c6b:	e8 d0 ff ff ff       	call   100c40 <outb>
  100c70:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
  100c73:	68 ff 00 00 00       	push   $0xff
  100c78:	68 a1 00 00 00       	push   $0xa1
  100c7d:	e8 be ff ff ff       	call   100c40 <outb>
  100c82:	83 c4 08             	add    $0x8,%esp
  100c85:	90                   	nop
  100c86:	c9                   	leave  
  100c87:	c3                   	ret    

00100c88 <inb>:
{
  100c88:	55                   	push   %ebp
  100c89:	89 e5                	mov    %esp,%ebp
  100c8b:	83 ec 14             	sub    $0x14,%esp
  100c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  100c91:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  100c95:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  100c99:	89 c2                	mov    %eax,%edx
  100c9b:	ec                   	in     (%dx),%al
  100c9c:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
  100c9f:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
  100ca3:	c9                   	leave  
  100ca4:	c3                   	ret    

00100ca5 <outb>:
{
  100ca5:	55                   	push   %ebp
  100ca6:	89 e5                	mov    %esp,%ebp
  100ca8:	83 ec 08             	sub    $0x8,%esp
  100cab:	8b 45 08             	mov    0x8(%ebp),%eax
  100cae:	8b 55 0c             	mov    0xc(%ebp),%edx
  100cb1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  100cb5:	89 d0                	mov    %edx,%eax
  100cb7:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  100cba:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
  100cbe:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  100cc2:	ee                   	out    %al,(%dx)
}
  100cc3:	90                   	nop
  100cc4:	c9                   	leave  
  100cc5:	c3                   	ret    

00100cc6 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
  100cc6:	55                   	push   %ebp
  100cc7:	89 e5                	mov    %esp,%ebp
  100cc9:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
  100ccc:	6a 00                	push   $0x0
  100cce:	68 fa 03 00 00       	push   $0x3fa
  100cd3:	e8 cd ff ff ff       	call   100ca5 <outb>
  100cd8:	83 c4 08             	add    $0x8,%esp

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
  100cdb:	68 80 00 00 00       	push   $0x80
  100ce0:	68 fb 03 00 00       	push   $0x3fb
  100ce5:	e8 bb ff ff ff       	call   100ca5 <outb>
  100cea:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
  100ced:	6a 0c                	push   $0xc
  100cef:	68 f8 03 00 00       	push   $0x3f8
  100cf4:	e8 ac ff ff ff       	call   100ca5 <outb>
  100cf9:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
  100cfc:	6a 00                	push   $0x0
  100cfe:	68 f9 03 00 00       	push   $0x3f9
  100d03:	e8 9d ff ff ff       	call   100ca5 <outb>
  100d08:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  100d0b:	6a 03                	push   $0x3
  100d0d:	68 fb 03 00 00       	push   $0x3fb
  100d12:	e8 8e ff ff ff       	call   100ca5 <outb>
  100d17:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
  100d1a:	6a 00                	push   $0x0
  100d1c:	68 fc 03 00 00       	push   $0x3fc
  100d21:	e8 7f ff ff ff       	call   100ca5 <outb>
  100d26:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
  100d29:	6a 01                	push   $0x1
  100d2b:	68 f9 03 00 00       	push   $0x3f9
  100d30:	e8 70 ff ff ff       	call   100ca5 <outb>
  100d35:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
  100d38:	68 fd 03 00 00       	push   $0x3fd
  100d3d:	e8 46 ff ff ff       	call   100c88 <inb>
  100d42:	83 c4 04             	add    $0x4,%esp
  100d45:	3c ff                	cmp    $0xff,%al
  100d47:	74 61                	je     100daa <uartinit+0xe4>
    return;
  uart = 1;
  100d49:	c7 05 c8 54 10 00 01 	movl   $0x1,0x1054c8
  100d50:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  100d53:	68 fa 03 00 00       	push   $0x3fa
  100d58:	e8 2b ff ff ff       	call   100c88 <inb>
  100d5d:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
  100d60:	68 f8 03 00 00       	push   $0x3f8
  100d65:	e8 1e ff ff ff       	call   100c88 <inb>
  100d6a:	83 c4 04             	add    $0x4,%esp
  ioapicenable(IRQ_COM1, 0);
  100d6d:	83 ec 08             	sub    $0x8,%esp
  100d70:	6a 00                	push   $0x0
  100d72:	6a 04                	push   $0x4
  100d74:	e8 1c f8 ff ff       	call   100595 <ioapicenable>
  100d79:	83 c4 10             	add    $0x10,%esp

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
  100d7c:	c7 45 f4 df 40 10 00 	movl   $0x1040df,-0xc(%ebp)
  100d83:	eb 19                	jmp    100d9e <uartinit+0xd8>
    uartputc(*p);
  100d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d88:	0f b6 00             	movzbl (%eax),%eax
  100d8b:	0f be c0             	movsbl %al,%eax
  100d8e:	83 ec 0c             	sub    $0xc,%esp
  100d91:	50                   	push   %eax
  100d92:	e8 16 00 00 00       	call   100dad <uartputc>
  100d97:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
  100d9a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100da1:	0f b6 00             	movzbl (%eax),%eax
  100da4:	84 c0                	test   %al,%al
  100da6:	75 dd                	jne    100d85 <uartinit+0xbf>
  100da8:	eb 01                	jmp    100dab <uartinit+0xe5>
    return;
  100daa:	90                   	nop
}
  100dab:	c9                   	leave  
  100dac:	c3                   	ret    

00100dad <uartputc>:

void
uartputc(int c)
{
  100dad:	55                   	push   %ebp
  100dae:	89 e5                	mov    %esp,%ebp
  100db0:	83 ec 10             	sub    $0x10,%esp
  int i;

  if(!uart)
  100db3:	a1 c8 54 10 00       	mov    0x1054c8,%eax
  100db8:	85 c0                	test   %eax,%eax
  100dba:	74 40                	je     100dfc <uartputc+0x4f>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++);
  100dbc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100dc3:	eb 04                	jmp    100dc9 <uartputc+0x1c>
  100dc5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100dc9:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  100dcd:	7f 17                	jg     100de6 <uartputc+0x39>
  100dcf:	68 fd 03 00 00       	push   $0x3fd
  100dd4:	e8 af fe ff ff       	call   100c88 <inb>
  100dd9:	83 c4 04             	add    $0x4,%esp
  100ddc:	0f b6 c0             	movzbl %al,%eax
  100ddf:	83 e0 20             	and    $0x20,%eax
  100de2:	85 c0                	test   %eax,%eax
  100de4:	74 df                	je     100dc5 <uartputc+0x18>
  outb(COM1+0, c);
  100de6:	8b 45 08             	mov    0x8(%ebp),%eax
  100de9:	0f b6 c0             	movzbl %al,%eax
  100dec:	50                   	push   %eax
  100ded:	68 f8 03 00 00       	push   $0x3f8
  100df2:	e8 ae fe ff ff       	call   100ca5 <outb>
  100df7:	83 c4 08             	add    $0x8,%esp
  100dfa:	eb 01                	jmp    100dfd <uartputc+0x50>
    return;
  100dfc:	90                   	nop
}
  100dfd:	c9                   	leave  
  100dfe:	c3                   	ret    

00100dff <uartgetc>:


static int
uartgetc(void)
{
  100dff:	55                   	push   %ebp
  100e00:	89 e5                	mov    %esp,%ebp
  if(!uart)
  100e02:	a1 c8 54 10 00       	mov    0x1054c8,%eax
  100e07:	85 c0                	test   %eax,%eax
  100e09:	75 07                	jne    100e12 <uartgetc+0x13>
    return -1;
  100e0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100e10:	eb 2e                	jmp    100e40 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
  100e12:	68 fd 03 00 00       	push   $0x3fd
  100e17:	e8 6c fe ff ff       	call   100c88 <inb>
  100e1c:	83 c4 04             	add    $0x4,%esp
  100e1f:	0f b6 c0             	movzbl %al,%eax
  100e22:	83 e0 01             	and    $0x1,%eax
  100e25:	85 c0                	test   %eax,%eax
  100e27:	75 07                	jne    100e30 <uartgetc+0x31>
    return -1;
  100e29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100e2e:	eb 10                	jmp    100e40 <uartgetc+0x41>
  return inb(COM1+0);
  100e30:	68 f8 03 00 00       	push   $0x3f8
  100e35:	e8 4e fe ff ff       	call   100c88 <inb>
  100e3a:	83 c4 04             	add    $0x4,%esp
  100e3d:	0f b6 c0             	movzbl %al,%eax
}
  100e40:	c9                   	leave  
  100e41:	c3                   	ret    

00100e42 <uartintr>:

void
uartintr(void)
{
  100e42:	55                   	push   %ebp
  100e43:	89 e5                	mov    %esp,%ebp
  100e45:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
  100e48:	83 ec 0c             	sub    $0xc,%esp
  100e4b:	68 ff 0d 10 00       	push   $0x100dff
  100e50:	e8 2e f5 ff ff       	call   100383 <consoleintr>
  100e55:	83 c4 10             	add    $0x10,%esp
  100e58:	90                   	nop
  100e59:	c9                   	leave  
  100e5a:	c3                   	ret    

00100e5b <stosb>:
{
  100e5b:	55                   	push   %ebp
  100e5c:	89 e5                	mov    %esp,%ebp
  100e5e:	57                   	push   %edi
  100e5f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  100e60:	8b 4d 08             	mov    0x8(%ebp),%ecx
  100e63:	8b 55 10             	mov    0x10(%ebp),%edx
  100e66:	8b 45 0c             	mov    0xc(%ebp),%eax
  100e69:	89 cb                	mov    %ecx,%ebx
  100e6b:	89 df                	mov    %ebx,%edi
  100e6d:	89 d1                	mov    %edx,%ecx
  100e6f:	fc                   	cld    
  100e70:	f3 aa                	rep stos %al,%es:(%edi)
  100e72:	89 ca                	mov    %ecx,%edx
  100e74:	89 fb                	mov    %edi,%ebx
  100e76:	89 5d 08             	mov    %ebx,0x8(%ebp)
  100e79:	89 55 10             	mov    %edx,0x10(%ebp)
}
  100e7c:	90                   	nop
  100e7d:	5b                   	pop    %ebx
  100e7e:	5f                   	pop    %edi
  100e7f:	5d                   	pop    %ebp
  100e80:	c3                   	ret    

00100e81 <stosl>:
{
  100e81:	55                   	push   %ebp
  100e82:	89 e5                	mov    %esp,%ebp
  100e84:	57                   	push   %edi
  100e85:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
  100e86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  100e89:	8b 55 10             	mov    0x10(%ebp),%edx
  100e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  100e8f:	89 cb                	mov    %ecx,%ebx
  100e91:	89 df                	mov    %ebx,%edi
  100e93:	89 d1                	mov    %edx,%ecx
  100e95:	fc                   	cld    
  100e96:	f3 ab                	rep stos %eax,%es:(%edi)
  100e98:	89 ca                	mov    %ecx,%edx
  100e9a:	89 fb                	mov    %edi,%ebx
  100e9c:	89 5d 08             	mov    %ebx,0x8(%ebp)
  100e9f:	89 55 10             	mov    %edx,0x10(%ebp)
}
  100ea2:	90                   	nop
  100ea3:	5b                   	pop    %ebx
  100ea4:	5f                   	pop    %edi
  100ea5:	5d                   	pop    %ebp
  100ea6:	c3                   	ret    

00100ea7 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
  100ea7:	55                   	push   %ebp
  100ea8:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
  100eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  100ead:	83 e0 03             	and    $0x3,%eax
  100eb0:	85 c0                	test   %eax,%eax
  100eb2:	75 43                	jne    100ef7 <memset+0x50>
  100eb4:	8b 45 10             	mov    0x10(%ebp),%eax
  100eb7:	83 e0 03             	and    $0x3,%eax
  100eba:	85 c0                	test   %eax,%eax
  100ebc:	75 39                	jne    100ef7 <memset+0x50>
    c &= 0xFF;
  100ebe:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  100ec5:	8b 45 10             	mov    0x10(%ebp),%eax
  100ec8:	c1 e8 02             	shr    $0x2,%eax
  100ecb:	89 c2                	mov    %eax,%edx
  100ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ed0:	c1 e0 18             	shl    $0x18,%eax
  100ed3:	89 c1                	mov    %eax,%ecx
  100ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ed8:	c1 e0 10             	shl    $0x10,%eax
  100edb:	09 c1                	or     %eax,%ecx
  100edd:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ee0:	c1 e0 08             	shl    $0x8,%eax
  100ee3:	09 c8                	or     %ecx,%eax
  100ee5:	0b 45 0c             	or     0xc(%ebp),%eax
  100ee8:	52                   	push   %edx
  100ee9:	50                   	push   %eax
  100eea:	ff 75 08             	push   0x8(%ebp)
  100eed:	e8 8f ff ff ff       	call   100e81 <stosl>
  100ef2:	83 c4 0c             	add    $0xc,%esp
  100ef5:	eb 12                	jmp    100f09 <memset+0x62>
  } else
    stosb(dst, c, n);
  100ef7:	8b 45 10             	mov    0x10(%ebp),%eax
  100efa:	50                   	push   %eax
  100efb:	ff 75 0c             	push   0xc(%ebp)
  100efe:	ff 75 08             	push   0x8(%ebp)
  100f01:	e8 55 ff ff ff       	call   100e5b <stosb>
  100f06:	83 c4 0c             	add    $0xc,%esp
  return dst;
  100f09:	8b 45 08             	mov    0x8(%ebp),%eax
}
  100f0c:	c9                   	leave  
  100f0d:	c3                   	ret    

00100f0e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
  100f0e:	55                   	push   %ebp
  100f0f:	89 e5                	mov    %esp,%ebp
  100f11:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
  100f14:	8b 45 08             	mov    0x8(%ebp),%eax
  100f17:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
  100f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  100f1d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
  100f20:	eb 30                	jmp    100f52 <memcmp+0x44>
    if(*s1 != *s2)
  100f22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f25:	0f b6 10             	movzbl (%eax),%edx
  100f28:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100f2b:	0f b6 00             	movzbl (%eax),%eax
  100f2e:	38 c2                	cmp    %al,%dl
  100f30:	74 18                	je     100f4a <memcmp+0x3c>
      return *s1 - *s2;
  100f32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f35:	0f b6 00             	movzbl (%eax),%eax
  100f38:	0f b6 d0             	movzbl %al,%edx
  100f3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100f3e:	0f b6 00             	movzbl (%eax),%eax
  100f41:	0f b6 c8             	movzbl %al,%ecx
  100f44:	89 d0                	mov    %edx,%eax
  100f46:	29 c8                	sub    %ecx,%eax
  100f48:	eb 1a                	jmp    100f64 <memcmp+0x56>
    s1++, s2++;
  100f4a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100f4e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
  100f52:	8b 45 10             	mov    0x10(%ebp),%eax
  100f55:	8d 50 ff             	lea    -0x1(%eax),%edx
  100f58:	89 55 10             	mov    %edx,0x10(%ebp)
  100f5b:	85 c0                	test   %eax,%eax
  100f5d:	75 c3                	jne    100f22 <memcmp+0x14>
  }

  return 0;
  100f5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100f64:	c9                   	leave  
  100f65:	c3                   	ret    

00100f66 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
  100f66:	55                   	push   %ebp
  100f67:	89 e5                	mov    %esp,%ebp
  100f69:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
  100f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  100f6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
  100f72:	8b 45 08             	mov    0x8(%ebp),%eax
  100f75:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
  100f78:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f7b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100f7e:	73 54                	jae    100fd4 <memmove+0x6e>
  100f80:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100f83:	8b 45 10             	mov    0x10(%ebp),%eax
  100f86:	01 d0                	add    %edx,%eax
  100f88:	39 45 f8             	cmp    %eax,-0x8(%ebp)
  100f8b:	73 47                	jae    100fd4 <memmove+0x6e>
    s += n;
  100f8d:	8b 45 10             	mov    0x10(%ebp),%eax
  100f90:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
  100f93:	8b 45 10             	mov    0x10(%ebp),%eax
  100f96:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
  100f99:	eb 13                	jmp    100fae <memmove+0x48>
      *--d = *--s;
  100f9b:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100f9f:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  100fa3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100fa6:	0f b6 10             	movzbl (%eax),%edx
  100fa9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100fac:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
  100fae:	8b 45 10             	mov    0x10(%ebp),%eax
  100fb1:	8d 50 ff             	lea    -0x1(%eax),%edx
  100fb4:	89 55 10             	mov    %edx,0x10(%ebp)
  100fb7:	85 c0                	test   %eax,%eax
  100fb9:	75 e0                	jne    100f9b <memmove+0x35>
  if(s < d && s + n > d){
  100fbb:	eb 24                	jmp    100fe1 <memmove+0x7b>
  } else
    while(n-- > 0)
      *d++ = *s++;
  100fbd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100fc0:	8d 42 01             	lea    0x1(%edx),%eax
  100fc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100fc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100fc9:	8d 48 01             	lea    0x1(%eax),%ecx
  100fcc:	89 4d f8             	mov    %ecx,-0x8(%ebp)
  100fcf:	0f b6 12             	movzbl (%edx),%edx
  100fd2:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
  100fd4:	8b 45 10             	mov    0x10(%ebp),%eax
  100fd7:	8d 50 ff             	lea    -0x1(%eax),%edx
  100fda:	89 55 10             	mov    %edx,0x10(%ebp)
  100fdd:	85 c0                	test   %eax,%eax
  100fdf:	75 dc                	jne    100fbd <memmove+0x57>

  return dst;
  100fe1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  100fe4:	c9                   	leave  
  100fe5:	c3                   	ret    

00100fe6 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  100fe6:	55                   	push   %ebp
  100fe7:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
  100fe9:	ff 75 10             	push   0x10(%ebp)
  100fec:	ff 75 0c             	push   0xc(%ebp)
  100fef:	ff 75 08             	push   0x8(%ebp)
  100ff2:	e8 6f ff ff ff       	call   100f66 <memmove>
  100ff7:	83 c4 0c             	add    $0xc,%esp
}
  100ffa:	c9                   	leave  
  100ffb:	c3                   	ret    

00100ffc <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  100ffc:	55                   	push   %ebp
  100ffd:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
  100fff:	eb 0c                	jmp    10100d <strncmp+0x11>
    n--, p++, q++;
  101001:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  101005:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  101009:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
  10100d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  101011:	74 1a                	je     10102d <strncmp+0x31>
  101013:	8b 45 08             	mov    0x8(%ebp),%eax
  101016:	0f b6 00             	movzbl (%eax),%eax
  101019:	84 c0                	test   %al,%al
  10101b:	74 10                	je     10102d <strncmp+0x31>
  10101d:	8b 45 08             	mov    0x8(%ebp),%eax
  101020:	0f b6 10             	movzbl (%eax),%edx
  101023:	8b 45 0c             	mov    0xc(%ebp),%eax
  101026:	0f b6 00             	movzbl (%eax),%eax
  101029:	38 c2                	cmp    %al,%dl
  10102b:	74 d4                	je     101001 <strncmp+0x5>
  if(n == 0)
  10102d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  101031:	75 07                	jne    10103a <strncmp+0x3e>
    return 0;
  101033:	b8 00 00 00 00       	mov    $0x0,%eax
  101038:	eb 16                	jmp    101050 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
  10103a:	8b 45 08             	mov    0x8(%ebp),%eax
  10103d:	0f b6 00             	movzbl (%eax),%eax
  101040:	0f b6 d0             	movzbl %al,%edx
  101043:	8b 45 0c             	mov    0xc(%ebp),%eax
  101046:	0f b6 00             	movzbl (%eax),%eax
  101049:	0f b6 c8             	movzbl %al,%ecx
  10104c:	89 d0                	mov    %edx,%eax
  10104e:	29 c8                	sub    %ecx,%eax
}
  101050:	5d                   	pop    %ebp
  101051:	c3                   	ret    

00101052 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
  101052:	55                   	push   %ebp
  101053:	89 e5                	mov    %esp,%ebp
  101055:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  101058:	8b 45 08             	mov    0x8(%ebp),%eax
  10105b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
  10105e:	90                   	nop
  10105f:	8b 45 10             	mov    0x10(%ebp),%eax
  101062:	8d 50 ff             	lea    -0x1(%eax),%edx
  101065:	89 55 10             	mov    %edx,0x10(%ebp)
  101068:	85 c0                	test   %eax,%eax
  10106a:	7e 2c                	jle    101098 <strncpy+0x46>
  10106c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10106f:	8d 42 01             	lea    0x1(%edx),%eax
  101072:	89 45 0c             	mov    %eax,0xc(%ebp)
  101075:	8b 45 08             	mov    0x8(%ebp),%eax
  101078:	8d 48 01             	lea    0x1(%eax),%ecx
  10107b:	89 4d 08             	mov    %ecx,0x8(%ebp)
  10107e:	0f b6 12             	movzbl (%edx),%edx
  101081:	88 10                	mov    %dl,(%eax)
  101083:	0f b6 00             	movzbl (%eax),%eax
  101086:	84 c0                	test   %al,%al
  101088:	75 d5                	jne    10105f <strncpy+0xd>
    ;
  while(n-- > 0)
  10108a:	eb 0c                	jmp    101098 <strncpy+0x46>
    *s++ = 0;
  10108c:	8b 45 08             	mov    0x8(%ebp),%eax
  10108f:	8d 50 01             	lea    0x1(%eax),%edx
  101092:	89 55 08             	mov    %edx,0x8(%ebp)
  101095:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
  101098:	8b 45 10             	mov    0x10(%ebp),%eax
  10109b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10109e:	89 55 10             	mov    %edx,0x10(%ebp)
  1010a1:	85 c0                	test   %eax,%eax
  1010a3:	7f e7                	jg     10108c <strncpy+0x3a>
  return os;
  1010a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1010a8:	c9                   	leave  
  1010a9:	c3                   	ret    

001010aa <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  1010aa:	55                   	push   %ebp
  1010ab:	89 e5                	mov    %esp,%ebp
  1010ad:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  1010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1010b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
  1010b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1010ba:	7f 05                	jg     1010c1 <safestrcpy+0x17>
    return os;
  1010bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1010bf:	eb 32                	jmp    1010f3 <safestrcpy+0x49>
  while(--n > 0 && (*s++ = *t++) != 0)
  1010c1:	90                   	nop
  1010c2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1010c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1010ca:	7e 1e                	jle    1010ea <safestrcpy+0x40>
  1010cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  1010cf:	8d 42 01             	lea    0x1(%edx),%eax
  1010d2:	89 45 0c             	mov    %eax,0xc(%ebp)
  1010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1010d8:	8d 48 01             	lea    0x1(%eax),%ecx
  1010db:	89 4d 08             	mov    %ecx,0x8(%ebp)
  1010de:	0f b6 12             	movzbl (%edx),%edx
  1010e1:	88 10                	mov    %dl,(%eax)
  1010e3:	0f b6 00             	movzbl (%eax),%eax
  1010e6:	84 c0                	test   %al,%al
  1010e8:	75 d8                	jne    1010c2 <safestrcpy+0x18>
    ;
  *s = 0;
  1010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1010ed:	c6 00 00             	movb   $0x0,(%eax)
  return os;
  1010f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1010f3:	c9                   	leave  
  1010f4:	c3                   	ret    

001010f5 <strlen>:

int
strlen(const char *s)
{
  1010f5:	55                   	push   %ebp
  1010f6:	89 e5                	mov    %esp,%ebp
  1010f8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  1010fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101102:	eb 04                	jmp    101108 <strlen+0x13>
  101104:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101108:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10110b:	8b 45 08             	mov    0x8(%ebp),%eax
  10110e:	01 d0                	add    %edx,%eax
  101110:	0f b6 00             	movzbl (%eax),%eax
  101113:	84 c0                	test   %al,%al
  101115:	75 ed                	jne    101104 <strlen+0xf>
    ;
  return n;
  101117:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10111a:	c9                   	leave  
  10111b:	c3                   	ret    

0010111c <readeflags>:
{
  10111c:	55                   	push   %ebp
  10111d:	89 e5                	mov    %esp,%ebp
  10111f:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  101122:	9c                   	pushf  
  101123:	58                   	pop    %eax
  101124:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
  101127:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10112a:	c9                   	leave  
  10112b:	c3                   	ret    

0010112c <cpuid>:
#include "x86.h"
#include "proc.h"

// Must be called with interrupts disabled
int
cpuid() {
  10112c:	55                   	push   %ebp
  10112d:	89 e5                	mov    %esp,%ebp
  10112f:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
  101132:	e8 07 00 00 00       	call   10113e <mycpu>
  101137:	2d b8 54 10 00       	sub    $0x1054b8,%eax
}
  10113c:	c9                   	leave  
  10113d:	c3                   	ret    

0010113e <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  10113e:	55                   	push   %ebp
  10113f:	89 e5                	mov    %esp,%ebp
  101141:	83 ec 18             	sub    $0x18,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF)
  101144:	e8 d3 ff ff ff       	call   10111c <readeflags>
  101149:	25 00 02 00 00       	and    $0x200,%eax
  10114e:	85 c0                	test   %eax,%eax
  101150:	74 0d                	je     10115f <mycpu+0x21>
    panic("mycpu called with interrupts enabled\n");
  101152:	83 ec 0c             	sub    $0xc,%esp
  101155:	68 e8 40 10 00       	push   $0x1040e8
  10115a:	e8 4e f1 ff ff       	call   1002ad <panic>
  
  apicid = lapicid();
  10115f:	e8 b0 f5 ff ff       	call   100714 <lapicid>
  101164:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
  101167:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10116e:	eb 21                	jmp    101191 <mycpu+0x53>
    if (cpus[i].apicid == apicid)
  101170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101173:	05 b8 54 10 00       	add    $0x1054b8,%eax
  101178:	0f b6 00             	movzbl (%eax),%eax
  10117b:	0f b6 c0             	movzbl %al,%eax
  10117e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  101181:	75 0a                	jne    10118d <mycpu+0x4f>
      return &cpus[i];
  101183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101186:	05 b8 54 10 00       	add    $0x1054b8,%eax
  10118b:	eb 1b                	jmp    1011a8 <mycpu+0x6a>
  for (i = 0; i < ncpu; ++i) {
  10118d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101191:	a1 c0 54 10 00       	mov    0x1054c0,%eax
  101196:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  101199:	7c d5                	jl     101170 <mycpu+0x32>
  }
  panic("unknown apicid\n");
  10119b:	83 ec 0c             	sub    $0xc,%esp
  10119e:	68 0e 41 10 00       	push   $0x10410e
  1011a3:	e8 05 f1 ff ff       	call   1002ad <panic>
  1011a8:	c9                   	leave  
  1011a9:	c3                   	ret    

001011aa <getcallerpcs>:
// #include "memlayout.h"

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  1011aa:	55                   	push   %ebp
  1011ab:	89 e5                	mov    %esp,%ebp
  1011ad:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  1011b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1011b3:	83 e8 08             	sub    $0x8,%eax
  1011b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
  1011b9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  1011c0:	eb 2f                	jmp    1011f1 <getcallerpcs+0x47>
    // if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
    if(ebp == 0 || ebp == (uint*)0xffffffff)
  1011c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1011c6:	74 4a                	je     101212 <getcallerpcs+0x68>
  1011c8:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
  1011cc:	74 44                	je     101212 <getcallerpcs+0x68>
      break;
    pcs[i] = ebp[1];     // saved %eip
  1011ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1011d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1011db:	01 c2                	add    %eax,%edx
  1011dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1011e0:	8b 40 04             	mov    0x4(%eax),%eax
  1011e3:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
  1011e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1011e8:	8b 00                	mov    (%eax),%eax
  1011ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
  1011ed:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  1011f1:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
  1011f5:	7e cb                	jle    1011c2 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
  1011f7:	eb 19                	jmp    101212 <getcallerpcs+0x68>
    pcs[i] = 0;
  1011f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1011fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101203:	8b 45 0c             	mov    0xc(%ebp),%eax
  101206:	01 d0                	add    %edx,%eax
  101208:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
  10120e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  101212:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
  101216:	7e e1                	jle    1011f9 <getcallerpcs+0x4f>
  101218:	90                   	nop
  101219:	90                   	nop
  10121a:	c9                   	leave  
  10121b:	c3                   	ret    

0010121c <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushal
  10121c:	60                   	pusha  
  
  # Call trap(tf), where tf=%esp
  pushl %esp
  10121d:	54                   	push   %esp
  call trap
  10121e:	e8 41 01 00 00       	call   101364 <trap>
  addl $4, %esp
  101223:	83 c4 04             	add    $0x4,%esp

00101226 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
  101226:	61                   	popa   
  addl $0x8, %esp  # trapno and errcode
  101227:	83 c4 08             	add    $0x8,%esp
  iret
  10122a:	cf                   	iret   

0010122b <lidt>:
{
  10122b:	55                   	push   %ebp
  10122c:	89 e5                	mov    %esp,%ebp
  10122e:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
  101231:	8b 45 0c             	mov    0xc(%ebp),%eax
  101234:	83 e8 01             	sub    $0x1,%eax
  101237:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
  10123b:	8b 45 08             	mov    0x8(%ebp),%eax
  10123e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  101242:	8b 45 08             	mov    0x8(%ebp),%eax
  101245:	c1 e8 10             	shr    $0x10,%eax
  101248:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
  10124c:	8d 45 fa             	lea    -0x6(%ebp),%eax
  10124f:	0f 01 18             	lidtl  (%eax)
}
  101252:	90                   	nop
  101253:	c9                   	leave  
  101254:	c3                   	ret    

00101255 <rcr2>:

static inline uint
rcr2(void)
{
  101255:	55                   	push   %ebp
  101256:	89 e5                	mov    %esp,%ebp
  101258:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
  10125b:	0f 20 d0             	mov    %cr2,%eax
  10125e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
  101261:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101264:	c9                   	leave  
  101265:	c3                   	ret    

00101266 <tvinit>:
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
uint ticks;

void
tvinit(void)
{
  101266:	55                   	push   %ebp
  101267:	89 e5                	mov    %esp,%ebp
  101269:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
  10126c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101273:	e9 c3 00 00 00       	jmp    10133b <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  101278:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10127b:	8b 04 85 11 50 10 00 	mov    0x105011(,%eax,4),%eax
  101282:	89 c2                	mov    %eax,%edx
  101284:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101287:	66 89 14 c5 e0 54 10 	mov    %dx,0x1054e0(,%eax,8)
  10128e:	00 
  10128f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101292:	66 c7 04 c5 e2 54 10 	movw   $0x8,0x1054e2(,%eax,8)
  101299:	00 08 00 
  10129c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10129f:	0f b6 14 c5 e4 54 10 	movzbl 0x1054e4(,%eax,8),%edx
  1012a6:	00 
  1012a7:	83 e2 e0             	and    $0xffffffe0,%edx
  1012aa:	88 14 c5 e4 54 10 00 	mov    %dl,0x1054e4(,%eax,8)
  1012b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1012b4:	0f b6 14 c5 e4 54 10 	movzbl 0x1054e4(,%eax,8),%edx
  1012bb:	00 
  1012bc:	83 e2 1f             	and    $0x1f,%edx
  1012bf:	88 14 c5 e4 54 10 00 	mov    %dl,0x1054e4(,%eax,8)
  1012c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1012c9:	0f b6 14 c5 e5 54 10 	movzbl 0x1054e5(,%eax,8),%edx
  1012d0:	00 
  1012d1:	83 e2 f0             	and    $0xfffffff0,%edx
  1012d4:	83 ca 0e             	or     $0xe,%edx
  1012d7:	88 14 c5 e5 54 10 00 	mov    %dl,0x1054e5(,%eax,8)
  1012de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1012e1:	0f b6 14 c5 e5 54 10 	movzbl 0x1054e5(,%eax,8),%edx
  1012e8:	00 
  1012e9:	83 e2 ef             	and    $0xffffffef,%edx
  1012ec:	88 14 c5 e5 54 10 00 	mov    %dl,0x1054e5(,%eax,8)
  1012f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1012f6:	0f b6 14 c5 e5 54 10 	movzbl 0x1054e5(,%eax,8),%edx
  1012fd:	00 
  1012fe:	83 e2 9f             	and    $0xffffff9f,%edx
  101301:	88 14 c5 e5 54 10 00 	mov    %dl,0x1054e5(,%eax,8)
  101308:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10130b:	0f b6 14 c5 e5 54 10 	movzbl 0x1054e5(,%eax,8),%edx
  101312:	00 
  101313:	83 ca 80             	or     $0xffffff80,%edx
  101316:	88 14 c5 e5 54 10 00 	mov    %dl,0x1054e5(,%eax,8)
  10131d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101320:	8b 04 85 11 50 10 00 	mov    0x105011(,%eax,4),%eax
  101327:	c1 e8 10             	shr    $0x10,%eax
  10132a:	89 c2                	mov    %eax,%edx
  10132c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10132f:	66 89 14 c5 e6 54 10 	mov    %dx,0x1054e6(,%eax,8)
  101336:	00 
  for(i = 0; i < 256; i++)
  101337:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10133b:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101342:	0f 8e 30 ff ff ff    	jle    101278 <tvinit+0x12>
}
  101348:	90                   	nop
  101349:	90                   	nop
  10134a:	c9                   	leave  
  10134b:	c3                   	ret    

0010134c <idtinit>:

void
idtinit(void)
{
  10134c:	55                   	push   %ebp
  10134d:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
  10134f:	68 00 08 00 00       	push   $0x800
  101354:	68 e0 54 10 00       	push   $0x1054e0
  101359:	e8 cd fe ff ff       	call   10122b <lidt>
  10135e:	83 c4 08             	add    $0x8,%esp
}
  101361:	90                   	nop
  101362:	c9                   	leave  
  101363:	c3                   	ret    

00101364 <trap>:

void
trap(struct trapframe *tf)
{
  101364:	55                   	push   %ebp
  101365:	89 e5                	mov    %esp,%ebp
  101367:	56                   	push   %esi
  101368:	53                   	push   %ebx
  switch(tf->trapno){
  101369:	8b 45 08             	mov    0x8(%ebp),%eax
  10136c:	8b 40 20             	mov    0x20(%eax),%eax
  10136f:	83 e8 20             	sub    $0x20,%eax
  101372:	83 f8 1f             	cmp    $0x1f,%eax
  101375:	77 61                	ja     1013d8 <trap+0x74>
  101377:	8b 04 85 7c 41 10 00 	mov    0x10417c(,%eax,4),%eax
  10137e:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    ticks++;
  101380:	a1 e0 5c 10 00       	mov    0x105ce0,%eax
  101385:	83 c0 01             	add    $0x1,%eax
  101388:	a3 e0 5c 10 00       	mov    %eax,0x105ce0
    lapiceoi();
  10138d:	e8 a4 f3 ff ff       	call   100736 <lapiceoi>
    break;
  101392:	eb 7d                	jmp    101411 <trap+0xad>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
  101394:	e8 1c 10 00 00       	call   1023b5 <ideintr>
    lapiceoi();
  101399:	e8 98 f3 ff ff       	call   100736 <lapiceoi>
    break;
  10139e:	eb 71                	jmp    101411 <trap+0xad>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
  1013a0:	e8 9d fa ff ff       	call   100e42 <uartintr>
    lapiceoi();
  1013a5:	e8 8c f3 ff ff       	call   100736 <lapiceoi>
    break;
  1013aa:	eb 65                	jmp    101411 <trap+0xad>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  1013ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1013af:	8b 70 28             	mov    0x28(%eax),%esi
            cpuid(), tf->cs, tf->eip);
  1013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1013b5:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  1013b9:	0f b7 d8             	movzwl %ax,%ebx
  1013bc:	e8 6b fd ff ff       	call   10112c <cpuid>
  1013c1:	56                   	push   %esi
  1013c2:	53                   	push   %ebx
  1013c3:	50                   	push   %eax
  1013c4:	68 20 41 10 00       	push   $0x104120
  1013c9:	e8 1e ed ff ff       	call   1000ec <cprintf>
  1013ce:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
  1013d1:	e8 60 f3 ff ff       	call   100736 <lapiceoi>
    break;
  1013d6:	eb 39                	jmp    101411 <trap+0xad>

  default:
    cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
  1013d8:	e8 78 fe ff ff       	call   101255 <rcr2>
  1013dd:	89 c3                	mov    %eax,%ebx
  1013df:	8b 45 08             	mov    0x8(%ebp),%eax
  1013e2:	8b 70 28             	mov    0x28(%eax),%esi
  1013e5:	e8 42 fd ff ff       	call   10112c <cpuid>
  1013ea:	8b 55 08             	mov    0x8(%ebp),%edx
  1013ed:	8b 52 20             	mov    0x20(%edx),%edx
  1013f0:	83 ec 0c             	sub    $0xc,%esp
  1013f3:	53                   	push   %ebx
  1013f4:	56                   	push   %esi
  1013f5:	50                   	push   %eax
  1013f6:	52                   	push   %edx
  1013f7:	68 44 41 10 00       	push   $0x104144
  1013fc:	e8 eb ec ff ff       	call   1000ec <cprintf>
  101401:	83 c4 20             	add    $0x20,%esp
            tf->trapno, cpuid(), tf->eip, rcr2());
    panic("trap");
  101404:	83 ec 0c             	sub    $0xc,%esp
  101407:	68 76 41 10 00       	push   $0x104176
  10140c:	e8 9c ee ff ff       	call   1002ad <panic>
  }
}
  101411:	90                   	nop
  101412:	8d 65 f8             	lea    -0x8(%ebp),%esp
  101415:	5b                   	pop    %ebx
  101416:	5e                   	pop    %esi
  101417:	5d                   	pop    %ebp
  101418:	c3                   	ret    

00101419 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
  101419:	6a 00                	push   $0x0
  pushl $0
  10141b:	6a 00                	push   $0x0
  jmp alltraps
  10141d:	e9 fa fd ff ff       	jmp    10121c <alltraps>

00101422 <vector1>:
.globl vector1
vector1:
  pushl $0
  101422:	6a 00                	push   $0x0
  pushl $1
  101424:	6a 01                	push   $0x1
  jmp alltraps
  101426:	e9 f1 fd ff ff       	jmp    10121c <alltraps>

0010142b <vector2>:
.globl vector2
vector2:
  pushl $0
  10142b:	6a 00                	push   $0x0
  pushl $2
  10142d:	6a 02                	push   $0x2
  jmp alltraps
  10142f:	e9 e8 fd ff ff       	jmp    10121c <alltraps>

00101434 <vector3>:
.globl vector3
vector3:
  pushl $0
  101434:	6a 00                	push   $0x0
  pushl $3
  101436:	6a 03                	push   $0x3
  jmp alltraps
  101438:	e9 df fd ff ff       	jmp    10121c <alltraps>

0010143d <vector4>:
.globl vector4
vector4:
  pushl $0
  10143d:	6a 00                	push   $0x0
  pushl $4
  10143f:	6a 04                	push   $0x4
  jmp alltraps
  101441:	e9 d6 fd ff ff       	jmp    10121c <alltraps>

00101446 <vector5>:
.globl vector5
vector5:
  pushl $0
  101446:	6a 00                	push   $0x0
  pushl $5
  101448:	6a 05                	push   $0x5
  jmp alltraps
  10144a:	e9 cd fd ff ff       	jmp    10121c <alltraps>

0010144f <vector6>:
.globl vector6
vector6:
  pushl $0
  10144f:	6a 00                	push   $0x0
  pushl $6
  101451:	6a 06                	push   $0x6
  jmp alltraps
  101453:	e9 c4 fd ff ff       	jmp    10121c <alltraps>

00101458 <vector7>:
.globl vector7
vector7:
  pushl $0
  101458:	6a 00                	push   $0x0
  pushl $7
  10145a:	6a 07                	push   $0x7
  jmp alltraps
  10145c:	e9 bb fd ff ff       	jmp    10121c <alltraps>

00101461 <vector8>:
.globl vector8
vector8:
  pushl $8
  101461:	6a 08                	push   $0x8
  jmp alltraps
  101463:	e9 b4 fd ff ff       	jmp    10121c <alltraps>

00101468 <vector9>:
.globl vector9
vector9:
  pushl $0
  101468:	6a 00                	push   $0x0
  pushl $9
  10146a:	6a 09                	push   $0x9
  jmp alltraps
  10146c:	e9 ab fd ff ff       	jmp    10121c <alltraps>

00101471 <vector10>:
.globl vector10
vector10:
  pushl $10
  101471:	6a 0a                	push   $0xa
  jmp alltraps
  101473:	e9 a4 fd ff ff       	jmp    10121c <alltraps>

00101478 <vector11>:
.globl vector11
vector11:
  pushl $11
  101478:	6a 0b                	push   $0xb
  jmp alltraps
  10147a:	e9 9d fd ff ff       	jmp    10121c <alltraps>

0010147f <vector12>:
.globl vector12
vector12:
  pushl $12
  10147f:	6a 0c                	push   $0xc
  jmp alltraps
  101481:	e9 96 fd ff ff       	jmp    10121c <alltraps>

00101486 <vector13>:
.globl vector13
vector13:
  pushl $13
  101486:	6a 0d                	push   $0xd
  jmp alltraps
  101488:	e9 8f fd ff ff       	jmp    10121c <alltraps>

0010148d <vector14>:
.globl vector14
vector14:
  pushl $14
  10148d:	6a 0e                	push   $0xe
  jmp alltraps
  10148f:	e9 88 fd ff ff       	jmp    10121c <alltraps>

00101494 <vector15>:
.globl vector15
vector15:
  pushl $0
  101494:	6a 00                	push   $0x0
  pushl $15
  101496:	6a 0f                	push   $0xf
  jmp alltraps
  101498:	e9 7f fd ff ff       	jmp    10121c <alltraps>

0010149d <vector16>:
.globl vector16
vector16:
  pushl $0
  10149d:	6a 00                	push   $0x0
  pushl $16
  10149f:	6a 10                	push   $0x10
  jmp alltraps
  1014a1:	e9 76 fd ff ff       	jmp    10121c <alltraps>

001014a6 <vector17>:
.globl vector17
vector17:
  pushl $17
  1014a6:	6a 11                	push   $0x11
  jmp alltraps
  1014a8:	e9 6f fd ff ff       	jmp    10121c <alltraps>

001014ad <vector18>:
.globl vector18
vector18:
  pushl $0
  1014ad:	6a 00                	push   $0x0
  pushl $18
  1014af:	6a 12                	push   $0x12
  jmp alltraps
  1014b1:	e9 66 fd ff ff       	jmp    10121c <alltraps>

001014b6 <vector19>:
.globl vector19
vector19:
  pushl $0
  1014b6:	6a 00                	push   $0x0
  pushl $19
  1014b8:	6a 13                	push   $0x13
  jmp alltraps
  1014ba:	e9 5d fd ff ff       	jmp    10121c <alltraps>

001014bf <vector20>:
.globl vector20
vector20:
  pushl $0
  1014bf:	6a 00                	push   $0x0
  pushl $20
  1014c1:	6a 14                	push   $0x14
  jmp alltraps
  1014c3:	e9 54 fd ff ff       	jmp    10121c <alltraps>

001014c8 <vector21>:
.globl vector21
vector21:
  pushl $0
  1014c8:	6a 00                	push   $0x0
  pushl $21
  1014ca:	6a 15                	push   $0x15
  jmp alltraps
  1014cc:	e9 4b fd ff ff       	jmp    10121c <alltraps>

001014d1 <vector22>:
.globl vector22
vector22:
  pushl $0
  1014d1:	6a 00                	push   $0x0
  pushl $22
  1014d3:	6a 16                	push   $0x16
  jmp alltraps
  1014d5:	e9 42 fd ff ff       	jmp    10121c <alltraps>

001014da <vector23>:
.globl vector23
vector23:
  pushl $0
  1014da:	6a 00                	push   $0x0
  pushl $23
  1014dc:	6a 17                	push   $0x17
  jmp alltraps
  1014de:	e9 39 fd ff ff       	jmp    10121c <alltraps>

001014e3 <vector24>:
.globl vector24
vector24:
  pushl $0
  1014e3:	6a 00                	push   $0x0
  pushl $24
  1014e5:	6a 18                	push   $0x18
  jmp alltraps
  1014e7:	e9 30 fd ff ff       	jmp    10121c <alltraps>

001014ec <vector25>:
.globl vector25
vector25:
  pushl $0
  1014ec:	6a 00                	push   $0x0
  pushl $25
  1014ee:	6a 19                	push   $0x19
  jmp alltraps
  1014f0:	e9 27 fd ff ff       	jmp    10121c <alltraps>

001014f5 <vector26>:
.globl vector26
vector26:
  pushl $0
  1014f5:	6a 00                	push   $0x0
  pushl $26
  1014f7:	6a 1a                	push   $0x1a
  jmp alltraps
  1014f9:	e9 1e fd ff ff       	jmp    10121c <alltraps>

001014fe <vector27>:
.globl vector27
vector27:
  pushl $0
  1014fe:	6a 00                	push   $0x0
  pushl $27
  101500:	6a 1b                	push   $0x1b
  jmp alltraps
  101502:	e9 15 fd ff ff       	jmp    10121c <alltraps>

00101507 <vector28>:
.globl vector28
vector28:
  pushl $0
  101507:	6a 00                	push   $0x0
  pushl $28
  101509:	6a 1c                	push   $0x1c
  jmp alltraps
  10150b:	e9 0c fd ff ff       	jmp    10121c <alltraps>

00101510 <vector29>:
.globl vector29
vector29:
  pushl $0
  101510:	6a 00                	push   $0x0
  pushl $29
  101512:	6a 1d                	push   $0x1d
  jmp alltraps
  101514:	e9 03 fd ff ff       	jmp    10121c <alltraps>

00101519 <vector30>:
.globl vector30
vector30:
  pushl $0
  101519:	6a 00                	push   $0x0
  pushl $30
  10151b:	6a 1e                	push   $0x1e
  jmp alltraps
  10151d:	e9 fa fc ff ff       	jmp    10121c <alltraps>

00101522 <vector31>:
.globl vector31
vector31:
  pushl $0
  101522:	6a 00                	push   $0x0
  pushl $31
  101524:	6a 1f                	push   $0x1f
  jmp alltraps
  101526:	e9 f1 fc ff ff       	jmp    10121c <alltraps>

0010152b <vector32>:
.globl vector32
vector32:
  pushl $0
  10152b:	6a 00                	push   $0x0
  pushl $32
  10152d:	6a 20                	push   $0x20
  jmp alltraps
  10152f:	e9 e8 fc ff ff       	jmp    10121c <alltraps>

00101534 <vector33>:
.globl vector33
vector33:
  pushl $0
  101534:	6a 00                	push   $0x0
  pushl $33
  101536:	6a 21                	push   $0x21
  jmp alltraps
  101538:	e9 df fc ff ff       	jmp    10121c <alltraps>

0010153d <vector34>:
.globl vector34
vector34:
  pushl $0
  10153d:	6a 00                	push   $0x0
  pushl $34
  10153f:	6a 22                	push   $0x22
  jmp alltraps
  101541:	e9 d6 fc ff ff       	jmp    10121c <alltraps>

00101546 <vector35>:
.globl vector35
vector35:
  pushl $0
  101546:	6a 00                	push   $0x0
  pushl $35
  101548:	6a 23                	push   $0x23
  jmp alltraps
  10154a:	e9 cd fc ff ff       	jmp    10121c <alltraps>

0010154f <vector36>:
.globl vector36
vector36:
  pushl $0
  10154f:	6a 00                	push   $0x0
  pushl $36
  101551:	6a 24                	push   $0x24
  jmp alltraps
  101553:	e9 c4 fc ff ff       	jmp    10121c <alltraps>

00101558 <vector37>:
.globl vector37
vector37:
  pushl $0
  101558:	6a 00                	push   $0x0
  pushl $37
  10155a:	6a 25                	push   $0x25
  jmp alltraps
  10155c:	e9 bb fc ff ff       	jmp    10121c <alltraps>

00101561 <vector38>:
.globl vector38
vector38:
  pushl $0
  101561:	6a 00                	push   $0x0
  pushl $38
  101563:	6a 26                	push   $0x26
  jmp alltraps
  101565:	e9 b2 fc ff ff       	jmp    10121c <alltraps>

0010156a <vector39>:
.globl vector39
vector39:
  pushl $0
  10156a:	6a 00                	push   $0x0
  pushl $39
  10156c:	6a 27                	push   $0x27
  jmp alltraps
  10156e:	e9 a9 fc ff ff       	jmp    10121c <alltraps>

00101573 <vector40>:
.globl vector40
vector40:
  pushl $0
  101573:	6a 00                	push   $0x0
  pushl $40
  101575:	6a 28                	push   $0x28
  jmp alltraps
  101577:	e9 a0 fc ff ff       	jmp    10121c <alltraps>

0010157c <vector41>:
.globl vector41
vector41:
  pushl $0
  10157c:	6a 00                	push   $0x0
  pushl $41
  10157e:	6a 29                	push   $0x29
  jmp alltraps
  101580:	e9 97 fc ff ff       	jmp    10121c <alltraps>

00101585 <vector42>:
.globl vector42
vector42:
  pushl $0
  101585:	6a 00                	push   $0x0
  pushl $42
  101587:	6a 2a                	push   $0x2a
  jmp alltraps
  101589:	e9 8e fc ff ff       	jmp    10121c <alltraps>

0010158e <vector43>:
.globl vector43
vector43:
  pushl $0
  10158e:	6a 00                	push   $0x0
  pushl $43
  101590:	6a 2b                	push   $0x2b
  jmp alltraps
  101592:	e9 85 fc ff ff       	jmp    10121c <alltraps>

00101597 <vector44>:
.globl vector44
vector44:
  pushl $0
  101597:	6a 00                	push   $0x0
  pushl $44
  101599:	6a 2c                	push   $0x2c
  jmp alltraps
  10159b:	e9 7c fc ff ff       	jmp    10121c <alltraps>

001015a0 <vector45>:
.globl vector45
vector45:
  pushl $0
  1015a0:	6a 00                	push   $0x0
  pushl $45
  1015a2:	6a 2d                	push   $0x2d
  jmp alltraps
  1015a4:	e9 73 fc ff ff       	jmp    10121c <alltraps>

001015a9 <vector46>:
.globl vector46
vector46:
  pushl $0
  1015a9:	6a 00                	push   $0x0
  pushl $46
  1015ab:	6a 2e                	push   $0x2e
  jmp alltraps
  1015ad:	e9 6a fc ff ff       	jmp    10121c <alltraps>

001015b2 <vector47>:
.globl vector47
vector47:
  pushl $0
  1015b2:	6a 00                	push   $0x0
  pushl $47
  1015b4:	6a 2f                	push   $0x2f
  jmp alltraps
  1015b6:	e9 61 fc ff ff       	jmp    10121c <alltraps>

001015bb <vector48>:
.globl vector48
vector48:
  pushl $0
  1015bb:	6a 00                	push   $0x0
  pushl $48
  1015bd:	6a 30                	push   $0x30
  jmp alltraps
  1015bf:	e9 58 fc ff ff       	jmp    10121c <alltraps>

001015c4 <vector49>:
.globl vector49
vector49:
  pushl $0
  1015c4:	6a 00                	push   $0x0
  pushl $49
  1015c6:	6a 31                	push   $0x31
  jmp alltraps
  1015c8:	e9 4f fc ff ff       	jmp    10121c <alltraps>

001015cd <vector50>:
.globl vector50
vector50:
  pushl $0
  1015cd:	6a 00                	push   $0x0
  pushl $50
  1015cf:	6a 32                	push   $0x32
  jmp alltraps
  1015d1:	e9 46 fc ff ff       	jmp    10121c <alltraps>

001015d6 <vector51>:
.globl vector51
vector51:
  pushl $0
  1015d6:	6a 00                	push   $0x0
  pushl $51
  1015d8:	6a 33                	push   $0x33
  jmp alltraps
  1015da:	e9 3d fc ff ff       	jmp    10121c <alltraps>

001015df <vector52>:
.globl vector52
vector52:
  pushl $0
  1015df:	6a 00                	push   $0x0
  pushl $52
  1015e1:	6a 34                	push   $0x34
  jmp alltraps
  1015e3:	e9 34 fc ff ff       	jmp    10121c <alltraps>

001015e8 <vector53>:
.globl vector53
vector53:
  pushl $0
  1015e8:	6a 00                	push   $0x0
  pushl $53
  1015ea:	6a 35                	push   $0x35
  jmp alltraps
  1015ec:	e9 2b fc ff ff       	jmp    10121c <alltraps>

001015f1 <vector54>:
.globl vector54
vector54:
  pushl $0
  1015f1:	6a 00                	push   $0x0
  pushl $54
  1015f3:	6a 36                	push   $0x36
  jmp alltraps
  1015f5:	e9 22 fc ff ff       	jmp    10121c <alltraps>

001015fa <vector55>:
.globl vector55
vector55:
  pushl $0
  1015fa:	6a 00                	push   $0x0
  pushl $55
  1015fc:	6a 37                	push   $0x37
  jmp alltraps
  1015fe:	e9 19 fc ff ff       	jmp    10121c <alltraps>

00101603 <vector56>:
.globl vector56
vector56:
  pushl $0
  101603:	6a 00                	push   $0x0
  pushl $56
  101605:	6a 38                	push   $0x38
  jmp alltraps
  101607:	e9 10 fc ff ff       	jmp    10121c <alltraps>

0010160c <vector57>:
.globl vector57
vector57:
  pushl $0
  10160c:	6a 00                	push   $0x0
  pushl $57
  10160e:	6a 39                	push   $0x39
  jmp alltraps
  101610:	e9 07 fc ff ff       	jmp    10121c <alltraps>

00101615 <vector58>:
.globl vector58
vector58:
  pushl $0
  101615:	6a 00                	push   $0x0
  pushl $58
  101617:	6a 3a                	push   $0x3a
  jmp alltraps
  101619:	e9 fe fb ff ff       	jmp    10121c <alltraps>

0010161e <vector59>:
.globl vector59
vector59:
  pushl $0
  10161e:	6a 00                	push   $0x0
  pushl $59
  101620:	6a 3b                	push   $0x3b
  jmp alltraps
  101622:	e9 f5 fb ff ff       	jmp    10121c <alltraps>

00101627 <vector60>:
.globl vector60
vector60:
  pushl $0
  101627:	6a 00                	push   $0x0
  pushl $60
  101629:	6a 3c                	push   $0x3c
  jmp alltraps
  10162b:	e9 ec fb ff ff       	jmp    10121c <alltraps>

00101630 <vector61>:
.globl vector61
vector61:
  pushl $0
  101630:	6a 00                	push   $0x0
  pushl $61
  101632:	6a 3d                	push   $0x3d
  jmp alltraps
  101634:	e9 e3 fb ff ff       	jmp    10121c <alltraps>

00101639 <vector62>:
.globl vector62
vector62:
  pushl $0
  101639:	6a 00                	push   $0x0
  pushl $62
  10163b:	6a 3e                	push   $0x3e
  jmp alltraps
  10163d:	e9 da fb ff ff       	jmp    10121c <alltraps>

00101642 <vector63>:
.globl vector63
vector63:
  pushl $0
  101642:	6a 00                	push   $0x0
  pushl $63
  101644:	6a 3f                	push   $0x3f
  jmp alltraps
  101646:	e9 d1 fb ff ff       	jmp    10121c <alltraps>

0010164b <vector64>:
.globl vector64
vector64:
  pushl $0
  10164b:	6a 00                	push   $0x0
  pushl $64
  10164d:	6a 40                	push   $0x40
  jmp alltraps
  10164f:	e9 c8 fb ff ff       	jmp    10121c <alltraps>

00101654 <vector65>:
.globl vector65
vector65:
  pushl $0
  101654:	6a 00                	push   $0x0
  pushl $65
  101656:	6a 41                	push   $0x41
  jmp alltraps
  101658:	e9 bf fb ff ff       	jmp    10121c <alltraps>

0010165d <vector66>:
.globl vector66
vector66:
  pushl $0
  10165d:	6a 00                	push   $0x0
  pushl $66
  10165f:	6a 42                	push   $0x42
  jmp alltraps
  101661:	e9 b6 fb ff ff       	jmp    10121c <alltraps>

00101666 <vector67>:
.globl vector67
vector67:
  pushl $0
  101666:	6a 00                	push   $0x0
  pushl $67
  101668:	6a 43                	push   $0x43
  jmp alltraps
  10166a:	e9 ad fb ff ff       	jmp    10121c <alltraps>

0010166f <vector68>:
.globl vector68
vector68:
  pushl $0
  10166f:	6a 00                	push   $0x0
  pushl $68
  101671:	6a 44                	push   $0x44
  jmp alltraps
  101673:	e9 a4 fb ff ff       	jmp    10121c <alltraps>

00101678 <vector69>:
.globl vector69
vector69:
  pushl $0
  101678:	6a 00                	push   $0x0
  pushl $69
  10167a:	6a 45                	push   $0x45
  jmp alltraps
  10167c:	e9 9b fb ff ff       	jmp    10121c <alltraps>

00101681 <vector70>:
.globl vector70
vector70:
  pushl $0
  101681:	6a 00                	push   $0x0
  pushl $70
  101683:	6a 46                	push   $0x46
  jmp alltraps
  101685:	e9 92 fb ff ff       	jmp    10121c <alltraps>

0010168a <vector71>:
.globl vector71
vector71:
  pushl $0
  10168a:	6a 00                	push   $0x0
  pushl $71
  10168c:	6a 47                	push   $0x47
  jmp alltraps
  10168e:	e9 89 fb ff ff       	jmp    10121c <alltraps>

00101693 <vector72>:
.globl vector72
vector72:
  pushl $0
  101693:	6a 00                	push   $0x0
  pushl $72
  101695:	6a 48                	push   $0x48
  jmp alltraps
  101697:	e9 80 fb ff ff       	jmp    10121c <alltraps>

0010169c <vector73>:
.globl vector73
vector73:
  pushl $0
  10169c:	6a 00                	push   $0x0
  pushl $73
  10169e:	6a 49                	push   $0x49
  jmp alltraps
  1016a0:	e9 77 fb ff ff       	jmp    10121c <alltraps>

001016a5 <vector74>:
.globl vector74
vector74:
  pushl $0
  1016a5:	6a 00                	push   $0x0
  pushl $74
  1016a7:	6a 4a                	push   $0x4a
  jmp alltraps
  1016a9:	e9 6e fb ff ff       	jmp    10121c <alltraps>

001016ae <vector75>:
.globl vector75
vector75:
  pushl $0
  1016ae:	6a 00                	push   $0x0
  pushl $75
  1016b0:	6a 4b                	push   $0x4b
  jmp alltraps
  1016b2:	e9 65 fb ff ff       	jmp    10121c <alltraps>

001016b7 <vector76>:
.globl vector76
vector76:
  pushl $0
  1016b7:	6a 00                	push   $0x0
  pushl $76
  1016b9:	6a 4c                	push   $0x4c
  jmp alltraps
  1016bb:	e9 5c fb ff ff       	jmp    10121c <alltraps>

001016c0 <vector77>:
.globl vector77
vector77:
  pushl $0
  1016c0:	6a 00                	push   $0x0
  pushl $77
  1016c2:	6a 4d                	push   $0x4d
  jmp alltraps
  1016c4:	e9 53 fb ff ff       	jmp    10121c <alltraps>

001016c9 <vector78>:
.globl vector78
vector78:
  pushl $0
  1016c9:	6a 00                	push   $0x0
  pushl $78
  1016cb:	6a 4e                	push   $0x4e
  jmp alltraps
  1016cd:	e9 4a fb ff ff       	jmp    10121c <alltraps>

001016d2 <vector79>:
.globl vector79
vector79:
  pushl $0
  1016d2:	6a 00                	push   $0x0
  pushl $79
  1016d4:	6a 4f                	push   $0x4f
  jmp alltraps
  1016d6:	e9 41 fb ff ff       	jmp    10121c <alltraps>

001016db <vector80>:
.globl vector80
vector80:
  pushl $0
  1016db:	6a 00                	push   $0x0
  pushl $80
  1016dd:	6a 50                	push   $0x50
  jmp alltraps
  1016df:	e9 38 fb ff ff       	jmp    10121c <alltraps>

001016e4 <vector81>:
.globl vector81
vector81:
  pushl $0
  1016e4:	6a 00                	push   $0x0
  pushl $81
  1016e6:	6a 51                	push   $0x51
  jmp alltraps
  1016e8:	e9 2f fb ff ff       	jmp    10121c <alltraps>

001016ed <vector82>:
.globl vector82
vector82:
  pushl $0
  1016ed:	6a 00                	push   $0x0
  pushl $82
  1016ef:	6a 52                	push   $0x52
  jmp alltraps
  1016f1:	e9 26 fb ff ff       	jmp    10121c <alltraps>

001016f6 <vector83>:
.globl vector83
vector83:
  pushl $0
  1016f6:	6a 00                	push   $0x0
  pushl $83
  1016f8:	6a 53                	push   $0x53
  jmp alltraps
  1016fa:	e9 1d fb ff ff       	jmp    10121c <alltraps>

001016ff <vector84>:
.globl vector84
vector84:
  pushl $0
  1016ff:	6a 00                	push   $0x0
  pushl $84
  101701:	6a 54                	push   $0x54
  jmp alltraps
  101703:	e9 14 fb ff ff       	jmp    10121c <alltraps>

00101708 <vector85>:
.globl vector85
vector85:
  pushl $0
  101708:	6a 00                	push   $0x0
  pushl $85
  10170a:	6a 55                	push   $0x55
  jmp alltraps
  10170c:	e9 0b fb ff ff       	jmp    10121c <alltraps>

00101711 <vector86>:
.globl vector86
vector86:
  pushl $0
  101711:	6a 00                	push   $0x0
  pushl $86
  101713:	6a 56                	push   $0x56
  jmp alltraps
  101715:	e9 02 fb ff ff       	jmp    10121c <alltraps>

0010171a <vector87>:
.globl vector87
vector87:
  pushl $0
  10171a:	6a 00                	push   $0x0
  pushl $87
  10171c:	6a 57                	push   $0x57
  jmp alltraps
  10171e:	e9 f9 fa ff ff       	jmp    10121c <alltraps>

00101723 <vector88>:
.globl vector88
vector88:
  pushl $0
  101723:	6a 00                	push   $0x0
  pushl $88
  101725:	6a 58                	push   $0x58
  jmp alltraps
  101727:	e9 f0 fa ff ff       	jmp    10121c <alltraps>

0010172c <vector89>:
.globl vector89
vector89:
  pushl $0
  10172c:	6a 00                	push   $0x0
  pushl $89
  10172e:	6a 59                	push   $0x59
  jmp alltraps
  101730:	e9 e7 fa ff ff       	jmp    10121c <alltraps>

00101735 <vector90>:
.globl vector90
vector90:
  pushl $0
  101735:	6a 00                	push   $0x0
  pushl $90
  101737:	6a 5a                	push   $0x5a
  jmp alltraps
  101739:	e9 de fa ff ff       	jmp    10121c <alltraps>

0010173e <vector91>:
.globl vector91
vector91:
  pushl $0
  10173e:	6a 00                	push   $0x0
  pushl $91
  101740:	6a 5b                	push   $0x5b
  jmp alltraps
  101742:	e9 d5 fa ff ff       	jmp    10121c <alltraps>

00101747 <vector92>:
.globl vector92
vector92:
  pushl $0
  101747:	6a 00                	push   $0x0
  pushl $92
  101749:	6a 5c                	push   $0x5c
  jmp alltraps
  10174b:	e9 cc fa ff ff       	jmp    10121c <alltraps>

00101750 <vector93>:
.globl vector93
vector93:
  pushl $0
  101750:	6a 00                	push   $0x0
  pushl $93
  101752:	6a 5d                	push   $0x5d
  jmp alltraps
  101754:	e9 c3 fa ff ff       	jmp    10121c <alltraps>

00101759 <vector94>:
.globl vector94
vector94:
  pushl $0
  101759:	6a 00                	push   $0x0
  pushl $94
  10175b:	6a 5e                	push   $0x5e
  jmp alltraps
  10175d:	e9 ba fa ff ff       	jmp    10121c <alltraps>

00101762 <vector95>:
.globl vector95
vector95:
  pushl $0
  101762:	6a 00                	push   $0x0
  pushl $95
  101764:	6a 5f                	push   $0x5f
  jmp alltraps
  101766:	e9 b1 fa ff ff       	jmp    10121c <alltraps>

0010176b <vector96>:
.globl vector96
vector96:
  pushl $0
  10176b:	6a 00                	push   $0x0
  pushl $96
  10176d:	6a 60                	push   $0x60
  jmp alltraps
  10176f:	e9 a8 fa ff ff       	jmp    10121c <alltraps>

00101774 <vector97>:
.globl vector97
vector97:
  pushl $0
  101774:	6a 00                	push   $0x0
  pushl $97
  101776:	6a 61                	push   $0x61
  jmp alltraps
  101778:	e9 9f fa ff ff       	jmp    10121c <alltraps>

0010177d <vector98>:
.globl vector98
vector98:
  pushl $0
  10177d:	6a 00                	push   $0x0
  pushl $98
  10177f:	6a 62                	push   $0x62
  jmp alltraps
  101781:	e9 96 fa ff ff       	jmp    10121c <alltraps>

00101786 <vector99>:
.globl vector99
vector99:
  pushl $0
  101786:	6a 00                	push   $0x0
  pushl $99
  101788:	6a 63                	push   $0x63
  jmp alltraps
  10178a:	e9 8d fa ff ff       	jmp    10121c <alltraps>

0010178f <vector100>:
.globl vector100
vector100:
  pushl $0
  10178f:	6a 00                	push   $0x0
  pushl $100
  101791:	6a 64                	push   $0x64
  jmp alltraps
  101793:	e9 84 fa ff ff       	jmp    10121c <alltraps>

00101798 <vector101>:
.globl vector101
vector101:
  pushl $0
  101798:	6a 00                	push   $0x0
  pushl $101
  10179a:	6a 65                	push   $0x65
  jmp alltraps
  10179c:	e9 7b fa ff ff       	jmp    10121c <alltraps>

001017a1 <vector102>:
.globl vector102
vector102:
  pushl $0
  1017a1:	6a 00                	push   $0x0
  pushl $102
  1017a3:	6a 66                	push   $0x66
  jmp alltraps
  1017a5:	e9 72 fa ff ff       	jmp    10121c <alltraps>

001017aa <vector103>:
.globl vector103
vector103:
  pushl $0
  1017aa:	6a 00                	push   $0x0
  pushl $103
  1017ac:	6a 67                	push   $0x67
  jmp alltraps
  1017ae:	e9 69 fa ff ff       	jmp    10121c <alltraps>

001017b3 <vector104>:
.globl vector104
vector104:
  pushl $0
  1017b3:	6a 00                	push   $0x0
  pushl $104
  1017b5:	6a 68                	push   $0x68
  jmp alltraps
  1017b7:	e9 60 fa ff ff       	jmp    10121c <alltraps>

001017bc <vector105>:
.globl vector105
vector105:
  pushl $0
  1017bc:	6a 00                	push   $0x0
  pushl $105
  1017be:	6a 69                	push   $0x69
  jmp alltraps
  1017c0:	e9 57 fa ff ff       	jmp    10121c <alltraps>

001017c5 <vector106>:
.globl vector106
vector106:
  pushl $0
  1017c5:	6a 00                	push   $0x0
  pushl $106
  1017c7:	6a 6a                	push   $0x6a
  jmp alltraps
  1017c9:	e9 4e fa ff ff       	jmp    10121c <alltraps>

001017ce <vector107>:
.globl vector107
vector107:
  pushl $0
  1017ce:	6a 00                	push   $0x0
  pushl $107
  1017d0:	6a 6b                	push   $0x6b
  jmp alltraps
  1017d2:	e9 45 fa ff ff       	jmp    10121c <alltraps>

001017d7 <vector108>:
.globl vector108
vector108:
  pushl $0
  1017d7:	6a 00                	push   $0x0
  pushl $108
  1017d9:	6a 6c                	push   $0x6c
  jmp alltraps
  1017db:	e9 3c fa ff ff       	jmp    10121c <alltraps>

001017e0 <vector109>:
.globl vector109
vector109:
  pushl $0
  1017e0:	6a 00                	push   $0x0
  pushl $109
  1017e2:	6a 6d                	push   $0x6d
  jmp alltraps
  1017e4:	e9 33 fa ff ff       	jmp    10121c <alltraps>

001017e9 <vector110>:
.globl vector110
vector110:
  pushl $0
  1017e9:	6a 00                	push   $0x0
  pushl $110
  1017eb:	6a 6e                	push   $0x6e
  jmp alltraps
  1017ed:	e9 2a fa ff ff       	jmp    10121c <alltraps>

001017f2 <vector111>:
.globl vector111
vector111:
  pushl $0
  1017f2:	6a 00                	push   $0x0
  pushl $111
  1017f4:	6a 6f                	push   $0x6f
  jmp alltraps
  1017f6:	e9 21 fa ff ff       	jmp    10121c <alltraps>

001017fb <vector112>:
.globl vector112
vector112:
  pushl $0
  1017fb:	6a 00                	push   $0x0
  pushl $112
  1017fd:	6a 70                	push   $0x70
  jmp alltraps
  1017ff:	e9 18 fa ff ff       	jmp    10121c <alltraps>

00101804 <vector113>:
.globl vector113
vector113:
  pushl $0
  101804:	6a 00                	push   $0x0
  pushl $113
  101806:	6a 71                	push   $0x71
  jmp alltraps
  101808:	e9 0f fa ff ff       	jmp    10121c <alltraps>

0010180d <vector114>:
.globl vector114
vector114:
  pushl $0
  10180d:	6a 00                	push   $0x0
  pushl $114
  10180f:	6a 72                	push   $0x72
  jmp alltraps
  101811:	e9 06 fa ff ff       	jmp    10121c <alltraps>

00101816 <vector115>:
.globl vector115
vector115:
  pushl $0
  101816:	6a 00                	push   $0x0
  pushl $115
  101818:	6a 73                	push   $0x73
  jmp alltraps
  10181a:	e9 fd f9 ff ff       	jmp    10121c <alltraps>

0010181f <vector116>:
.globl vector116
vector116:
  pushl $0
  10181f:	6a 00                	push   $0x0
  pushl $116
  101821:	6a 74                	push   $0x74
  jmp alltraps
  101823:	e9 f4 f9 ff ff       	jmp    10121c <alltraps>

00101828 <vector117>:
.globl vector117
vector117:
  pushl $0
  101828:	6a 00                	push   $0x0
  pushl $117
  10182a:	6a 75                	push   $0x75
  jmp alltraps
  10182c:	e9 eb f9 ff ff       	jmp    10121c <alltraps>

00101831 <vector118>:
.globl vector118
vector118:
  pushl $0
  101831:	6a 00                	push   $0x0
  pushl $118
  101833:	6a 76                	push   $0x76
  jmp alltraps
  101835:	e9 e2 f9 ff ff       	jmp    10121c <alltraps>

0010183a <vector119>:
.globl vector119
vector119:
  pushl $0
  10183a:	6a 00                	push   $0x0
  pushl $119
  10183c:	6a 77                	push   $0x77
  jmp alltraps
  10183e:	e9 d9 f9 ff ff       	jmp    10121c <alltraps>

00101843 <vector120>:
.globl vector120
vector120:
  pushl $0
  101843:	6a 00                	push   $0x0
  pushl $120
  101845:	6a 78                	push   $0x78
  jmp alltraps
  101847:	e9 d0 f9 ff ff       	jmp    10121c <alltraps>

0010184c <vector121>:
.globl vector121
vector121:
  pushl $0
  10184c:	6a 00                	push   $0x0
  pushl $121
  10184e:	6a 79                	push   $0x79
  jmp alltraps
  101850:	e9 c7 f9 ff ff       	jmp    10121c <alltraps>

00101855 <vector122>:
.globl vector122
vector122:
  pushl $0
  101855:	6a 00                	push   $0x0
  pushl $122
  101857:	6a 7a                	push   $0x7a
  jmp alltraps
  101859:	e9 be f9 ff ff       	jmp    10121c <alltraps>

0010185e <vector123>:
.globl vector123
vector123:
  pushl $0
  10185e:	6a 00                	push   $0x0
  pushl $123
  101860:	6a 7b                	push   $0x7b
  jmp alltraps
  101862:	e9 b5 f9 ff ff       	jmp    10121c <alltraps>

00101867 <vector124>:
.globl vector124
vector124:
  pushl $0
  101867:	6a 00                	push   $0x0
  pushl $124
  101869:	6a 7c                	push   $0x7c
  jmp alltraps
  10186b:	e9 ac f9 ff ff       	jmp    10121c <alltraps>

00101870 <vector125>:
.globl vector125
vector125:
  pushl $0
  101870:	6a 00                	push   $0x0
  pushl $125
  101872:	6a 7d                	push   $0x7d
  jmp alltraps
  101874:	e9 a3 f9 ff ff       	jmp    10121c <alltraps>

00101879 <vector126>:
.globl vector126
vector126:
  pushl $0
  101879:	6a 00                	push   $0x0
  pushl $126
  10187b:	6a 7e                	push   $0x7e
  jmp alltraps
  10187d:	e9 9a f9 ff ff       	jmp    10121c <alltraps>

00101882 <vector127>:
.globl vector127
vector127:
  pushl $0
  101882:	6a 00                	push   $0x0
  pushl $127
  101884:	6a 7f                	push   $0x7f
  jmp alltraps
  101886:	e9 91 f9 ff ff       	jmp    10121c <alltraps>

0010188b <vector128>:
.globl vector128
vector128:
  pushl $0
  10188b:	6a 00                	push   $0x0
  pushl $128
  10188d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
  101892:	e9 85 f9 ff ff       	jmp    10121c <alltraps>

00101897 <vector129>:
.globl vector129
vector129:
  pushl $0
  101897:	6a 00                	push   $0x0
  pushl $129
  101899:	68 81 00 00 00       	push   $0x81
  jmp alltraps
  10189e:	e9 79 f9 ff ff       	jmp    10121c <alltraps>

001018a3 <vector130>:
.globl vector130
vector130:
  pushl $0
  1018a3:	6a 00                	push   $0x0
  pushl $130
  1018a5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
  1018aa:	e9 6d f9 ff ff       	jmp    10121c <alltraps>

001018af <vector131>:
.globl vector131
vector131:
  pushl $0
  1018af:	6a 00                	push   $0x0
  pushl $131
  1018b1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
  1018b6:	e9 61 f9 ff ff       	jmp    10121c <alltraps>

001018bb <vector132>:
.globl vector132
vector132:
  pushl $0
  1018bb:	6a 00                	push   $0x0
  pushl $132
  1018bd:	68 84 00 00 00       	push   $0x84
  jmp alltraps
  1018c2:	e9 55 f9 ff ff       	jmp    10121c <alltraps>

001018c7 <vector133>:
.globl vector133
vector133:
  pushl $0
  1018c7:	6a 00                	push   $0x0
  pushl $133
  1018c9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
  1018ce:	e9 49 f9 ff ff       	jmp    10121c <alltraps>

001018d3 <vector134>:
.globl vector134
vector134:
  pushl $0
  1018d3:	6a 00                	push   $0x0
  pushl $134
  1018d5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
  1018da:	e9 3d f9 ff ff       	jmp    10121c <alltraps>

001018df <vector135>:
.globl vector135
vector135:
  pushl $0
  1018df:	6a 00                	push   $0x0
  pushl $135
  1018e1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
  1018e6:	e9 31 f9 ff ff       	jmp    10121c <alltraps>

001018eb <vector136>:
.globl vector136
vector136:
  pushl $0
  1018eb:	6a 00                	push   $0x0
  pushl $136
  1018ed:	68 88 00 00 00       	push   $0x88
  jmp alltraps
  1018f2:	e9 25 f9 ff ff       	jmp    10121c <alltraps>

001018f7 <vector137>:
.globl vector137
vector137:
  pushl $0
  1018f7:	6a 00                	push   $0x0
  pushl $137
  1018f9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
  1018fe:	e9 19 f9 ff ff       	jmp    10121c <alltraps>

00101903 <vector138>:
.globl vector138
vector138:
  pushl $0
  101903:	6a 00                	push   $0x0
  pushl $138
  101905:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
  10190a:	e9 0d f9 ff ff       	jmp    10121c <alltraps>

0010190f <vector139>:
.globl vector139
vector139:
  pushl $0
  10190f:	6a 00                	push   $0x0
  pushl $139
  101911:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
  101916:	e9 01 f9 ff ff       	jmp    10121c <alltraps>

0010191b <vector140>:
.globl vector140
vector140:
  pushl $0
  10191b:	6a 00                	push   $0x0
  pushl $140
  10191d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
  101922:	e9 f5 f8 ff ff       	jmp    10121c <alltraps>

00101927 <vector141>:
.globl vector141
vector141:
  pushl $0
  101927:	6a 00                	push   $0x0
  pushl $141
  101929:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
  10192e:	e9 e9 f8 ff ff       	jmp    10121c <alltraps>

00101933 <vector142>:
.globl vector142
vector142:
  pushl $0
  101933:	6a 00                	push   $0x0
  pushl $142
  101935:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
  10193a:	e9 dd f8 ff ff       	jmp    10121c <alltraps>

0010193f <vector143>:
.globl vector143
vector143:
  pushl $0
  10193f:	6a 00                	push   $0x0
  pushl $143
  101941:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
  101946:	e9 d1 f8 ff ff       	jmp    10121c <alltraps>

0010194b <vector144>:
.globl vector144
vector144:
  pushl $0
  10194b:	6a 00                	push   $0x0
  pushl $144
  10194d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
  101952:	e9 c5 f8 ff ff       	jmp    10121c <alltraps>

00101957 <vector145>:
.globl vector145
vector145:
  pushl $0
  101957:	6a 00                	push   $0x0
  pushl $145
  101959:	68 91 00 00 00       	push   $0x91
  jmp alltraps
  10195e:	e9 b9 f8 ff ff       	jmp    10121c <alltraps>

00101963 <vector146>:
.globl vector146
vector146:
  pushl $0
  101963:	6a 00                	push   $0x0
  pushl $146
  101965:	68 92 00 00 00       	push   $0x92
  jmp alltraps
  10196a:	e9 ad f8 ff ff       	jmp    10121c <alltraps>

0010196f <vector147>:
.globl vector147
vector147:
  pushl $0
  10196f:	6a 00                	push   $0x0
  pushl $147
  101971:	68 93 00 00 00       	push   $0x93
  jmp alltraps
  101976:	e9 a1 f8 ff ff       	jmp    10121c <alltraps>

0010197b <vector148>:
.globl vector148
vector148:
  pushl $0
  10197b:	6a 00                	push   $0x0
  pushl $148
  10197d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
  101982:	e9 95 f8 ff ff       	jmp    10121c <alltraps>

00101987 <vector149>:
.globl vector149
vector149:
  pushl $0
  101987:	6a 00                	push   $0x0
  pushl $149
  101989:	68 95 00 00 00       	push   $0x95
  jmp alltraps
  10198e:	e9 89 f8 ff ff       	jmp    10121c <alltraps>

00101993 <vector150>:
.globl vector150
vector150:
  pushl $0
  101993:	6a 00                	push   $0x0
  pushl $150
  101995:	68 96 00 00 00       	push   $0x96
  jmp alltraps
  10199a:	e9 7d f8 ff ff       	jmp    10121c <alltraps>

0010199f <vector151>:
.globl vector151
vector151:
  pushl $0
  10199f:	6a 00                	push   $0x0
  pushl $151
  1019a1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
  1019a6:	e9 71 f8 ff ff       	jmp    10121c <alltraps>

001019ab <vector152>:
.globl vector152
vector152:
  pushl $0
  1019ab:	6a 00                	push   $0x0
  pushl $152
  1019ad:	68 98 00 00 00       	push   $0x98
  jmp alltraps
  1019b2:	e9 65 f8 ff ff       	jmp    10121c <alltraps>

001019b7 <vector153>:
.globl vector153
vector153:
  pushl $0
  1019b7:	6a 00                	push   $0x0
  pushl $153
  1019b9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
  1019be:	e9 59 f8 ff ff       	jmp    10121c <alltraps>

001019c3 <vector154>:
.globl vector154
vector154:
  pushl $0
  1019c3:	6a 00                	push   $0x0
  pushl $154
  1019c5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
  1019ca:	e9 4d f8 ff ff       	jmp    10121c <alltraps>

001019cf <vector155>:
.globl vector155
vector155:
  pushl $0
  1019cf:	6a 00                	push   $0x0
  pushl $155
  1019d1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
  1019d6:	e9 41 f8 ff ff       	jmp    10121c <alltraps>

001019db <vector156>:
.globl vector156
vector156:
  pushl $0
  1019db:	6a 00                	push   $0x0
  pushl $156
  1019dd:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
  1019e2:	e9 35 f8 ff ff       	jmp    10121c <alltraps>

001019e7 <vector157>:
.globl vector157
vector157:
  pushl $0
  1019e7:	6a 00                	push   $0x0
  pushl $157
  1019e9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
  1019ee:	e9 29 f8 ff ff       	jmp    10121c <alltraps>

001019f3 <vector158>:
.globl vector158
vector158:
  pushl $0
  1019f3:	6a 00                	push   $0x0
  pushl $158
  1019f5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
  1019fa:	e9 1d f8 ff ff       	jmp    10121c <alltraps>

001019ff <vector159>:
.globl vector159
vector159:
  pushl $0
  1019ff:	6a 00                	push   $0x0
  pushl $159
  101a01:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
  101a06:	e9 11 f8 ff ff       	jmp    10121c <alltraps>

00101a0b <vector160>:
.globl vector160
vector160:
  pushl $0
  101a0b:	6a 00                	push   $0x0
  pushl $160
  101a0d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
  101a12:	e9 05 f8 ff ff       	jmp    10121c <alltraps>

00101a17 <vector161>:
.globl vector161
vector161:
  pushl $0
  101a17:	6a 00                	push   $0x0
  pushl $161
  101a19:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
  101a1e:	e9 f9 f7 ff ff       	jmp    10121c <alltraps>

00101a23 <vector162>:
.globl vector162
vector162:
  pushl $0
  101a23:	6a 00                	push   $0x0
  pushl $162
  101a25:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
  101a2a:	e9 ed f7 ff ff       	jmp    10121c <alltraps>

00101a2f <vector163>:
.globl vector163
vector163:
  pushl $0
  101a2f:	6a 00                	push   $0x0
  pushl $163
  101a31:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
  101a36:	e9 e1 f7 ff ff       	jmp    10121c <alltraps>

00101a3b <vector164>:
.globl vector164
vector164:
  pushl $0
  101a3b:	6a 00                	push   $0x0
  pushl $164
  101a3d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
  101a42:	e9 d5 f7 ff ff       	jmp    10121c <alltraps>

00101a47 <vector165>:
.globl vector165
vector165:
  pushl $0
  101a47:	6a 00                	push   $0x0
  pushl $165
  101a49:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
  101a4e:	e9 c9 f7 ff ff       	jmp    10121c <alltraps>

00101a53 <vector166>:
.globl vector166
vector166:
  pushl $0
  101a53:	6a 00                	push   $0x0
  pushl $166
  101a55:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
  101a5a:	e9 bd f7 ff ff       	jmp    10121c <alltraps>

00101a5f <vector167>:
.globl vector167
vector167:
  pushl $0
  101a5f:	6a 00                	push   $0x0
  pushl $167
  101a61:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
  101a66:	e9 b1 f7 ff ff       	jmp    10121c <alltraps>

00101a6b <vector168>:
.globl vector168
vector168:
  pushl $0
  101a6b:	6a 00                	push   $0x0
  pushl $168
  101a6d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
  101a72:	e9 a5 f7 ff ff       	jmp    10121c <alltraps>

00101a77 <vector169>:
.globl vector169
vector169:
  pushl $0
  101a77:	6a 00                	push   $0x0
  pushl $169
  101a79:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
  101a7e:	e9 99 f7 ff ff       	jmp    10121c <alltraps>

00101a83 <vector170>:
.globl vector170
vector170:
  pushl $0
  101a83:	6a 00                	push   $0x0
  pushl $170
  101a85:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
  101a8a:	e9 8d f7 ff ff       	jmp    10121c <alltraps>

00101a8f <vector171>:
.globl vector171
vector171:
  pushl $0
  101a8f:	6a 00                	push   $0x0
  pushl $171
  101a91:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
  101a96:	e9 81 f7 ff ff       	jmp    10121c <alltraps>

00101a9b <vector172>:
.globl vector172
vector172:
  pushl $0
  101a9b:	6a 00                	push   $0x0
  pushl $172
  101a9d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
  101aa2:	e9 75 f7 ff ff       	jmp    10121c <alltraps>

00101aa7 <vector173>:
.globl vector173
vector173:
  pushl $0
  101aa7:	6a 00                	push   $0x0
  pushl $173
  101aa9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
  101aae:	e9 69 f7 ff ff       	jmp    10121c <alltraps>

00101ab3 <vector174>:
.globl vector174
vector174:
  pushl $0
  101ab3:	6a 00                	push   $0x0
  pushl $174
  101ab5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
  101aba:	e9 5d f7 ff ff       	jmp    10121c <alltraps>

00101abf <vector175>:
.globl vector175
vector175:
  pushl $0
  101abf:	6a 00                	push   $0x0
  pushl $175
  101ac1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
  101ac6:	e9 51 f7 ff ff       	jmp    10121c <alltraps>

00101acb <vector176>:
.globl vector176
vector176:
  pushl $0
  101acb:	6a 00                	push   $0x0
  pushl $176
  101acd:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
  101ad2:	e9 45 f7 ff ff       	jmp    10121c <alltraps>

00101ad7 <vector177>:
.globl vector177
vector177:
  pushl $0
  101ad7:	6a 00                	push   $0x0
  pushl $177
  101ad9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
  101ade:	e9 39 f7 ff ff       	jmp    10121c <alltraps>

00101ae3 <vector178>:
.globl vector178
vector178:
  pushl $0
  101ae3:	6a 00                	push   $0x0
  pushl $178
  101ae5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
  101aea:	e9 2d f7 ff ff       	jmp    10121c <alltraps>

00101aef <vector179>:
.globl vector179
vector179:
  pushl $0
  101aef:	6a 00                	push   $0x0
  pushl $179
  101af1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
  101af6:	e9 21 f7 ff ff       	jmp    10121c <alltraps>

00101afb <vector180>:
.globl vector180
vector180:
  pushl $0
  101afb:	6a 00                	push   $0x0
  pushl $180
  101afd:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
  101b02:	e9 15 f7 ff ff       	jmp    10121c <alltraps>

00101b07 <vector181>:
.globl vector181
vector181:
  pushl $0
  101b07:	6a 00                	push   $0x0
  pushl $181
  101b09:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
  101b0e:	e9 09 f7 ff ff       	jmp    10121c <alltraps>

00101b13 <vector182>:
.globl vector182
vector182:
  pushl $0
  101b13:	6a 00                	push   $0x0
  pushl $182
  101b15:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
  101b1a:	e9 fd f6 ff ff       	jmp    10121c <alltraps>

00101b1f <vector183>:
.globl vector183
vector183:
  pushl $0
  101b1f:	6a 00                	push   $0x0
  pushl $183
  101b21:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
  101b26:	e9 f1 f6 ff ff       	jmp    10121c <alltraps>

00101b2b <vector184>:
.globl vector184
vector184:
  pushl $0
  101b2b:	6a 00                	push   $0x0
  pushl $184
  101b2d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
  101b32:	e9 e5 f6 ff ff       	jmp    10121c <alltraps>

00101b37 <vector185>:
.globl vector185
vector185:
  pushl $0
  101b37:	6a 00                	push   $0x0
  pushl $185
  101b39:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
  101b3e:	e9 d9 f6 ff ff       	jmp    10121c <alltraps>

00101b43 <vector186>:
.globl vector186
vector186:
  pushl $0
  101b43:	6a 00                	push   $0x0
  pushl $186
  101b45:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
  101b4a:	e9 cd f6 ff ff       	jmp    10121c <alltraps>

00101b4f <vector187>:
.globl vector187
vector187:
  pushl $0
  101b4f:	6a 00                	push   $0x0
  pushl $187
  101b51:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
  101b56:	e9 c1 f6 ff ff       	jmp    10121c <alltraps>

00101b5b <vector188>:
.globl vector188
vector188:
  pushl $0
  101b5b:	6a 00                	push   $0x0
  pushl $188
  101b5d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
  101b62:	e9 b5 f6 ff ff       	jmp    10121c <alltraps>

00101b67 <vector189>:
.globl vector189
vector189:
  pushl $0
  101b67:	6a 00                	push   $0x0
  pushl $189
  101b69:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
  101b6e:	e9 a9 f6 ff ff       	jmp    10121c <alltraps>

00101b73 <vector190>:
.globl vector190
vector190:
  pushl $0
  101b73:	6a 00                	push   $0x0
  pushl $190
  101b75:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
  101b7a:	e9 9d f6 ff ff       	jmp    10121c <alltraps>

00101b7f <vector191>:
.globl vector191
vector191:
  pushl $0
  101b7f:	6a 00                	push   $0x0
  pushl $191
  101b81:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
  101b86:	e9 91 f6 ff ff       	jmp    10121c <alltraps>

00101b8b <vector192>:
.globl vector192
vector192:
  pushl $0
  101b8b:	6a 00                	push   $0x0
  pushl $192
  101b8d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
  101b92:	e9 85 f6 ff ff       	jmp    10121c <alltraps>

00101b97 <vector193>:
.globl vector193
vector193:
  pushl $0
  101b97:	6a 00                	push   $0x0
  pushl $193
  101b99:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
  101b9e:	e9 79 f6 ff ff       	jmp    10121c <alltraps>

00101ba3 <vector194>:
.globl vector194
vector194:
  pushl $0
  101ba3:	6a 00                	push   $0x0
  pushl $194
  101ba5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
  101baa:	e9 6d f6 ff ff       	jmp    10121c <alltraps>

00101baf <vector195>:
.globl vector195
vector195:
  pushl $0
  101baf:	6a 00                	push   $0x0
  pushl $195
  101bb1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
  101bb6:	e9 61 f6 ff ff       	jmp    10121c <alltraps>

00101bbb <vector196>:
.globl vector196
vector196:
  pushl $0
  101bbb:	6a 00                	push   $0x0
  pushl $196
  101bbd:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
  101bc2:	e9 55 f6 ff ff       	jmp    10121c <alltraps>

00101bc7 <vector197>:
.globl vector197
vector197:
  pushl $0
  101bc7:	6a 00                	push   $0x0
  pushl $197
  101bc9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
  101bce:	e9 49 f6 ff ff       	jmp    10121c <alltraps>

00101bd3 <vector198>:
.globl vector198
vector198:
  pushl $0
  101bd3:	6a 00                	push   $0x0
  pushl $198
  101bd5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
  101bda:	e9 3d f6 ff ff       	jmp    10121c <alltraps>

00101bdf <vector199>:
.globl vector199
vector199:
  pushl $0
  101bdf:	6a 00                	push   $0x0
  pushl $199
  101be1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
  101be6:	e9 31 f6 ff ff       	jmp    10121c <alltraps>

00101beb <vector200>:
.globl vector200
vector200:
  pushl $0
  101beb:	6a 00                	push   $0x0
  pushl $200
  101bed:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
  101bf2:	e9 25 f6 ff ff       	jmp    10121c <alltraps>

00101bf7 <vector201>:
.globl vector201
vector201:
  pushl $0
  101bf7:	6a 00                	push   $0x0
  pushl $201
  101bf9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
  101bfe:	e9 19 f6 ff ff       	jmp    10121c <alltraps>

00101c03 <vector202>:
.globl vector202
vector202:
  pushl $0
  101c03:	6a 00                	push   $0x0
  pushl $202
  101c05:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
  101c0a:	e9 0d f6 ff ff       	jmp    10121c <alltraps>

00101c0f <vector203>:
.globl vector203
vector203:
  pushl $0
  101c0f:	6a 00                	push   $0x0
  pushl $203
  101c11:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
  101c16:	e9 01 f6 ff ff       	jmp    10121c <alltraps>

00101c1b <vector204>:
.globl vector204
vector204:
  pushl $0
  101c1b:	6a 00                	push   $0x0
  pushl $204
  101c1d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
  101c22:	e9 f5 f5 ff ff       	jmp    10121c <alltraps>

00101c27 <vector205>:
.globl vector205
vector205:
  pushl $0
  101c27:	6a 00                	push   $0x0
  pushl $205
  101c29:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
  101c2e:	e9 e9 f5 ff ff       	jmp    10121c <alltraps>

00101c33 <vector206>:
.globl vector206
vector206:
  pushl $0
  101c33:	6a 00                	push   $0x0
  pushl $206
  101c35:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
  101c3a:	e9 dd f5 ff ff       	jmp    10121c <alltraps>

00101c3f <vector207>:
.globl vector207
vector207:
  pushl $0
  101c3f:	6a 00                	push   $0x0
  pushl $207
  101c41:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
  101c46:	e9 d1 f5 ff ff       	jmp    10121c <alltraps>

00101c4b <vector208>:
.globl vector208
vector208:
  pushl $0
  101c4b:	6a 00                	push   $0x0
  pushl $208
  101c4d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
  101c52:	e9 c5 f5 ff ff       	jmp    10121c <alltraps>

00101c57 <vector209>:
.globl vector209
vector209:
  pushl $0
  101c57:	6a 00                	push   $0x0
  pushl $209
  101c59:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
  101c5e:	e9 b9 f5 ff ff       	jmp    10121c <alltraps>

00101c63 <vector210>:
.globl vector210
vector210:
  pushl $0
  101c63:	6a 00                	push   $0x0
  pushl $210
  101c65:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
  101c6a:	e9 ad f5 ff ff       	jmp    10121c <alltraps>

00101c6f <vector211>:
.globl vector211
vector211:
  pushl $0
  101c6f:	6a 00                	push   $0x0
  pushl $211
  101c71:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
  101c76:	e9 a1 f5 ff ff       	jmp    10121c <alltraps>

00101c7b <vector212>:
.globl vector212
vector212:
  pushl $0
  101c7b:	6a 00                	push   $0x0
  pushl $212
  101c7d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
  101c82:	e9 95 f5 ff ff       	jmp    10121c <alltraps>

00101c87 <vector213>:
.globl vector213
vector213:
  pushl $0
  101c87:	6a 00                	push   $0x0
  pushl $213
  101c89:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
  101c8e:	e9 89 f5 ff ff       	jmp    10121c <alltraps>

00101c93 <vector214>:
.globl vector214
vector214:
  pushl $0
  101c93:	6a 00                	push   $0x0
  pushl $214
  101c95:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
  101c9a:	e9 7d f5 ff ff       	jmp    10121c <alltraps>

00101c9f <vector215>:
.globl vector215
vector215:
  pushl $0
  101c9f:	6a 00                	push   $0x0
  pushl $215
  101ca1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
  101ca6:	e9 71 f5 ff ff       	jmp    10121c <alltraps>

00101cab <vector216>:
.globl vector216
vector216:
  pushl $0
  101cab:	6a 00                	push   $0x0
  pushl $216
  101cad:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
  101cb2:	e9 65 f5 ff ff       	jmp    10121c <alltraps>

00101cb7 <vector217>:
.globl vector217
vector217:
  pushl $0
  101cb7:	6a 00                	push   $0x0
  pushl $217
  101cb9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
  101cbe:	e9 59 f5 ff ff       	jmp    10121c <alltraps>

00101cc3 <vector218>:
.globl vector218
vector218:
  pushl $0
  101cc3:	6a 00                	push   $0x0
  pushl $218
  101cc5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
  101cca:	e9 4d f5 ff ff       	jmp    10121c <alltraps>

00101ccf <vector219>:
.globl vector219
vector219:
  pushl $0
  101ccf:	6a 00                	push   $0x0
  pushl $219
  101cd1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
  101cd6:	e9 41 f5 ff ff       	jmp    10121c <alltraps>

00101cdb <vector220>:
.globl vector220
vector220:
  pushl $0
  101cdb:	6a 00                	push   $0x0
  pushl $220
  101cdd:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
  101ce2:	e9 35 f5 ff ff       	jmp    10121c <alltraps>

00101ce7 <vector221>:
.globl vector221
vector221:
  pushl $0
  101ce7:	6a 00                	push   $0x0
  pushl $221
  101ce9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
  101cee:	e9 29 f5 ff ff       	jmp    10121c <alltraps>

00101cf3 <vector222>:
.globl vector222
vector222:
  pushl $0
  101cf3:	6a 00                	push   $0x0
  pushl $222
  101cf5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
  101cfa:	e9 1d f5 ff ff       	jmp    10121c <alltraps>

00101cff <vector223>:
.globl vector223
vector223:
  pushl $0
  101cff:	6a 00                	push   $0x0
  pushl $223
  101d01:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
  101d06:	e9 11 f5 ff ff       	jmp    10121c <alltraps>

00101d0b <vector224>:
.globl vector224
vector224:
  pushl $0
  101d0b:	6a 00                	push   $0x0
  pushl $224
  101d0d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
  101d12:	e9 05 f5 ff ff       	jmp    10121c <alltraps>

00101d17 <vector225>:
.globl vector225
vector225:
  pushl $0
  101d17:	6a 00                	push   $0x0
  pushl $225
  101d19:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
  101d1e:	e9 f9 f4 ff ff       	jmp    10121c <alltraps>

00101d23 <vector226>:
.globl vector226
vector226:
  pushl $0
  101d23:	6a 00                	push   $0x0
  pushl $226
  101d25:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
  101d2a:	e9 ed f4 ff ff       	jmp    10121c <alltraps>

00101d2f <vector227>:
.globl vector227
vector227:
  pushl $0
  101d2f:	6a 00                	push   $0x0
  pushl $227
  101d31:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
  101d36:	e9 e1 f4 ff ff       	jmp    10121c <alltraps>

00101d3b <vector228>:
.globl vector228
vector228:
  pushl $0
  101d3b:	6a 00                	push   $0x0
  pushl $228
  101d3d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
  101d42:	e9 d5 f4 ff ff       	jmp    10121c <alltraps>

00101d47 <vector229>:
.globl vector229
vector229:
  pushl $0
  101d47:	6a 00                	push   $0x0
  pushl $229
  101d49:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
  101d4e:	e9 c9 f4 ff ff       	jmp    10121c <alltraps>

00101d53 <vector230>:
.globl vector230
vector230:
  pushl $0
  101d53:	6a 00                	push   $0x0
  pushl $230
  101d55:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
  101d5a:	e9 bd f4 ff ff       	jmp    10121c <alltraps>

00101d5f <vector231>:
.globl vector231
vector231:
  pushl $0
  101d5f:	6a 00                	push   $0x0
  pushl $231
  101d61:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
  101d66:	e9 b1 f4 ff ff       	jmp    10121c <alltraps>

00101d6b <vector232>:
.globl vector232
vector232:
  pushl $0
  101d6b:	6a 00                	push   $0x0
  pushl $232
  101d6d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
  101d72:	e9 a5 f4 ff ff       	jmp    10121c <alltraps>

00101d77 <vector233>:
.globl vector233
vector233:
  pushl $0
  101d77:	6a 00                	push   $0x0
  pushl $233
  101d79:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
  101d7e:	e9 99 f4 ff ff       	jmp    10121c <alltraps>

00101d83 <vector234>:
.globl vector234
vector234:
  pushl $0
  101d83:	6a 00                	push   $0x0
  pushl $234
  101d85:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
  101d8a:	e9 8d f4 ff ff       	jmp    10121c <alltraps>

00101d8f <vector235>:
.globl vector235
vector235:
  pushl $0
  101d8f:	6a 00                	push   $0x0
  pushl $235
  101d91:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
  101d96:	e9 81 f4 ff ff       	jmp    10121c <alltraps>

00101d9b <vector236>:
.globl vector236
vector236:
  pushl $0
  101d9b:	6a 00                	push   $0x0
  pushl $236
  101d9d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
  101da2:	e9 75 f4 ff ff       	jmp    10121c <alltraps>

00101da7 <vector237>:
.globl vector237
vector237:
  pushl $0
  101da7:	6a 00                	push   $0x0
  pushl $237
  101da9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
  101dae:	e9 69 f4 ff ff       	jmp    10121c <alltraps>

00101db3 <vector238>:
.globl vector238
vector238:
  pushl $0
  101db3:	6a 00                	push   $0x0
  pushl $238
  101db5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
  101dba:	e9 5d f4 ff ff       	jmp    10121c <alltraps>

00101dbf <vector239>:
.globl vector239
vector239:
  pushl $0
  101dbf:	6a 00                	push   $0x0
  pushl $239
  101dc1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
  101dc6:	e9 51 f4 ff ff       	jmp    10121c <alltraps>

00101dcb <vector240>:
.globl vector240
vector240:
  pushl $0
  101dcb:	6a 00                	push   $0x0
  pushl $240
  101dcd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
  101dd2:	e9 45 f4 ff ff       	jmp    10121c <alltraps>

00101dd7 <vector241>:
.globl vector241
vector241:
  pushl $0
  101dd7:	6a 00                	push   $0x0
  pushl $241
  101dd9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
  101dde:	e9 39 f4 ff ff       	jmp    10121c <alltraps>

00101de3 <vector242>:
.globl vector242
vector242:
  pushl $0
  101de3:	6a 00                	push   $0x0
  pushl $242
  101de5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
  101dea:	e9 2d f4 ff ff       	jmp    10121c <alltraps>

00101def <vector243>:
.globl vector243
vector243:
  pushl $0
  101def:	6a 00                	push   $0x0
  pushl $243
  101df1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
  101df6:	e9 21 f4 ff ff       	jmp    10121c <alltraps>

00101dfb <vector244>:
.globl vector244
vector244:
  pushl $0
  101dfb:	6a 00                	push   $0x0
  pushl $244
  101dfd:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
  101e02:	e9 15 f4 ff ff       	jmp    10121c <alltraps>

00101e07 <vector245>:
.globl vector245
vector245:
  pushl $0
  101e07:	6a 00                	push   $0x0
  pushl $245
  101e09:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
  101e0e:	e9 09 f4 ff ff       	jmp    10121c <alltraps>

00101e13 <vector246>:
.globl vector246
vector246:
  pushl $0
  101e13:	6a 00                	push   $0x0
  pushl $246
  101e15:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
  101e1a:	e9 fd f3 ff ff       	jmp    10121c <alltraps>

00101e1f <vector247>:
.globl vector247
vector247:
  pushl $0
  101e1f:	6a 00                	push   $0x0
  pushl $247
  101e21:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
  101e26:	e9 f1 f3 ff ff       	jmp    10121c <alltraps>

00101e2b <vector248>:
.globl vector248
vector248:
  pushl $0
  101e2b:	6a 00                	push   $0x0
  pushl $248
  101e2d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
  101e32:	e9 e5 f3 ff ff       	jmp    10121c <alltraps>

00101e37 <vector249>:
.globl vector249
vector249:
  pushl $0
  101e37:	6a 00                	push   $0x0
  pushl $249
  101e39:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
  101e3e:	e9 d9 f3 ff ff       	jmp    10121c <alltraps>

00101e43 <vector250>:
.globl vector250
vector250:
  pushl $0
  101e43:	6a 00                	push   $0x0
  pushl $250
  101e45:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
  101e4a:	e9 cd f3 ff ff       	jmp    10121c <alltraps>

00101e4f <vector251>:
.globl vector251
vector251:
  pushl $0
  101e4f:	6a 00                	push   $0x0
  pushl $251
  101e51:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
  101e56:	e9 c1 f3 ff ff       	jmp    10121c <alltraps>

00101e5b <vector252>:
.globl vector252
vector252:
  pushl $0
  101e5b:	6a 00                	push   $0x0
  pushl $252
  101e5d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
  101e62:	e9 b5 f3 ff ff       	jmp    10121c <alltraps>

00101e67 <vector253>:
.globl vector253
vector253:
  pushl $0
  101e67:	6a 00                	push   $0x0
  pushl $253
  101e69:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
  101e6e:	e9 a9 f3 ff ff       	jmp    10121c <alltraps>

00101e73 <vector254>:
.globl vector254
vector254:
  pushl $0
  101e73:	6a 00                	push   $0x0
  pushl $254
  101e75:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
  101e7a:	e9 9d f3 ff ff       	jmp    10121c <alltraps>

00101e7f <vector255>:
.globl vector255
vector255:
  pushl $0
  101e7f:	6a 00                	push   $0x0
  pushl $255
  101e81:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
  101e86:	e9 91 f3 ff ff       	jmp    10121c <alltraps>

00101e8b <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
  101e8b:	55                   	push   %ebp
  101e8c:	89 e5                	mov    %esp,%ebp
  101e8e:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  101e91:	c7 05 58 d8 10 00 48 	movl   $0x10d848,0x10d858
  101e98:	d8 10 00 
  bcache.head.next = &bcache.head;
  101e9b:	c7 05 5c d8 10 00 48 	movl   $0x10d848,0x10d85c
  101ea2:	d8 10 00 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
  101ea5:	c7 45 fc 00 5d 10 00 	movl   $0x105d00,-0x4(%ebp)
  101eac:	eb 30                	jmp    101ede <binit+0x53>
    b->next = bcache.head.next;
  101eae:	8b 15 5c d8 10 00    	mov    0x10d85c,%edx
  101eb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101eb7:	89 50 14             	mov    %edx,0x14(%eax)
    b->prev = &bcache.head;
  101eba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101ebd:	c7 40 10 48 d8 10 00 	movl   $0x10d848,0x10(%eax)
    bcache.head.next->prev = b;
  101ec4:	a1 5c d8 10 00       	mov    0x10d85c,%eax
  101ec9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101ecc:	89 50 10             	mov    %edx,0x10(%eax)
    bcache.head.next = b;
  101ecf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101ed2:	a3 5c d8 10 00       	mov    %eax,0x10d85c
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
  101ed7:	81 45 fc 1c 04 00 00 	addl   $0x41c,-0x4(%ebp)
  101ede:	b8 48 d8 10 00       	mov    $0x10d848,%eax
  101ee3:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  101ee6:	72 c6                	jb     101eae <binit+0x23>
  }
}
  101ee8:	90                   	nop
  101ee9:	90                   	nop
  101eea:	c9                   	leave  
  101eeb:	c3                   	ret    

00101eec <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
  101eec:	55                   	push   %ebp
  101eed:	89 e5                	mov    %esp,%ebp
  101eef:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
  101ef2:	a1 5c d8 10 00       	mov    0x10d85c,%eax
  101ef7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101efa:	eb 33                	jmp    101f2f <bget+0x43>
    if(b->dev == dev && b->blockno == blockno){
  101efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101eff:	8b 40 04             	mov    0x4(%eax),%eax
  101f02:	39 45 08             	cmp    %eax,0x8(%ebp)
  101f05:	75 1f                	jne    101f26 <bget+0x3a>
  101f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101f0a:	8b 40 08             	mov    0x8(%eax),%eax
  101f0d:	39 45 0c             	cmp    %eax,0xc(%ebp)
  101f10:	75 14                	jne    101f26 <bget+0x3a>
      b->refcnt++;
  101f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101f15:	8b 40 0c             	mov    0xc(%eax),%eax
  101f18:	8d 50 01             	lea    0x1(%eax),%edx
  101f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101f1e:	89 50 0c             	mov    %edx,0xc(%eax)
      return b;
  101f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101f24:	eb 7b                	jmp    101fa1 <bget+0xb5>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
  101f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101f29:	8b 40 14             	mov    0x14(%eax),%eax
  101f2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101f2f:	81 7d f4 48 d8 10 00 	cmpl   $0x10d848,-0xc(%ebp)
  101f36:	75 c4                	jne    101efc <bget+0x10>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
  101f38:	a1 58 d8 10 00       	mov    0x10d858,%eax
  101f3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101f40:	eb 49                	jmp    101f8b <bget+0x9f>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
  101f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101f45:	8b 40 0c             	mov    0xc(%eax),%eax
  101f48:	85 c0                	test   %eax,%eax
  101f4a:	75 36                	jne    101f82 <bget+0x96>
  101f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101f4f:	8b 00                	mov    (%eax),%eax
  101f51:	83 e0 04             	and    $0x4,%eax
  101f54:	85 c0                	test   %eax,%eax
  101f56:	75 2a                	jne    101f82 <bget+0x96>
      b->dev = dev;
  101f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101f5b:	8b 55 08             	mov    0x8(%ebp),%edx
  101f5e:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
  101f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101f64:	8b 55 0c             	mov    0xc(%ebp),%edx
  101f67:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
  101f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101f6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
  101f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101f76:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
      return b;
  101f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101f80:	eb 1f                	jmp    101fa1 <bget+0xb5>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
  101f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101f85:	8b 40 10             	mov    0x10(%eax),%eax
  101f88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101f8b:	81 7d f4 48 d8 10 00 	cmpl   $0x10d848,-0xc(%ebp)
  101f92:	75 ae                	jne    101f42 <bget+0x56>
    }
  }
  panic("bget: no buffers");
  101f94:	83 ec 0c             	sub    $0xc,%esp
  101f97:	68 fc 41 10 00       	push   $0x1041fc
  101f9c:	e8 0c e3 ff ff       	call   1002ad <panic>
}
  101fa1:	c9                   	leave  
  101fa2:	c3                   	ret    

00101fa3 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  101fa3:	55                   	push   %ebp
  101fa4:	89 e5                	mov    %esp,%ebp
  101fa6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
  101fa9:	83 ec 08             	sub    $0x8,%esp
  101fac:	ff 75 0c             	push   0xc(%ebp)
  101faf:	ff 75 08             	push   0x8(%ebp)
  101fb2:	e8 35 ff ff ff       	call   101eec <bget>
  101fb7:	83 c4 10             	add    $0x10,%esp
  101fba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((b->flags & B_VALID) == 0) {
  101fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101fc0:	8b 00                	mov    (%eax),%eax
  101fc2:	83 e0 02             	and    $0x2,%eax
  101fc5:	85 c0                	test   %eax,%eax
  101fc7:	75 0e                	jne    101fd7 <bread+0x34>
    iderw(b);
  101fc9:	83 ec 0c             	sub    $0xc,%esp
  101fcc:	ff 75 f4             	push   -0xc(%ebp)
  101fcf:	e8 70 04 00 00       	call   102444 <iderw>
  101fd4:	83 c4 10             	add    $0x10,%esp
  }
  return b;
  101fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101fda:	c9                   	leave  
  101fdb:	c3                   	ret    

00101fdc <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  101fdc:	55                   	push   %ebp
  101fdd:	89 e5                	mov    %esp,%ebp
  101fdf:	83 ec 08             	sub    $0x8,%esp
  b->flags |= B_DIRTY;
  101fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  101fe5:	8b 00                	mov    (%eax),%eax
  101fe7:	83 c8 04             	or     $0x4,%eax
  101fea:	89 c2                	mov    %eax,%edx
  101fec:	8b 45 08             	mov    0x8(%ebp),%eax
  101fef:	89 10                	mov    %edx,(%eax)
  iderw(b);
  101ff1:	83 ec 0c             	sub    $0xc,%esp
  101ff4:	ff 75 08             	push   0x8(%ebp)
  101ff7:	e8 48 04 00 00       	call   102444 <iderw>
  101ffc:	83 c4 10             	add    $0x10,%esp
}
  101fff:	90                   	nop
  102000:	c9                   	leave  
  102001:	c3                   	ret    

00102002 <bread_wr>:

struct buf* 
bread_wr(uint dev, uint blockno) {
  102002:	55                   	push   %ebp
  102003:	89 e5                	mov    %esp,%ebp
  102005:	83 ec 18             	sub    $0x18,%esp
  // IMPLEMENT YOUR CODE HERE
  struct buf *b;

  b = bget(dev, blockno);
  102008:	83 ec 08             	sub    $0x8,%esp
  10200b:	ff 75 0c             	push   0xc(%ebp)
  10200e:	ff 75 08             	push   0x8(%ebp)
  102011:	e8 d6 fe ff ff       	call   101eec <bget>
  102016:	83 c4 10             	add    $0x10,%esp
  102019:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((b->flags & B_VALID) == 0) {
  10201c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10201f:	8b 00                	mov    (%eax),%eax
  102021:	83 e0 02             	and    $0x2,%eax
  102024:	85 c0                	test   %eax,%eax
  102026:	75 0e                	jne    102036 <bread_wr+0x34>
    iderw(b);
  102028:	83 ec 0c             	sub    $0xc,%esp
  10202b:	ff 75 f4             	push   -0xc(%ebp)
  10202e:	e8 11 04 00 00       	call   102444 <iderw>
  102033:	83 c4 10             	add    $0x10,%esp
  }

  //~ Caching the old value for undo log
  memmove(b->old_data, b->data, BSIZE);
  102036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102039:	8d 50 1c             	lea    0x1c(%eax),%edx
  10203c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10203f:	05 1c 02 00 00       	add    $0x21c,%eax
  102044:	83 ec 04             	sub    $0x4,%esp
  102047:	68 00 02 00 00       	push   $0x200
  10204c:	52                   	push   %edx
  10204d:	50                   	push   %eax
  10204e:	e8 13 ef ff ff       	call   100f66 <memmove>
  102053:	83 c4 10             	add    $0x10,%esp

  return b;
  102056:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102059:	c9                   	leave  
  10205a:	c3                   	ret    

0010205b <brelse>:

// Release a buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  10205b:	55                   	push   %ebp
  10205c:	89 e5                	mov    %esp,%ebp
  b->refcnt--;
  10205e:	8b 45 08             	mov    0x8(%ebp),%eax
  102061:	8b 40 0c             	mov    0xc(%eax),%eax
  102064:	8d 50 ff             	lea    -0x1(%eax),%edx
  102067:	8b 45 08             	mov    0x8(%ebp),%eax
  10206a:	89 50 0c             	mov    %edx,0xc(%eax)
  if (b->refcnt == 0) {
  10206d:	8b 45 08             	mov    0x8(%ebp),%eax
  102070:	8b 40 0c             	mov    0xc(%eax),%eax
  102073:	85 c0                	test   %eax,%eax
  102075:	75 47                	jne    1020be <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
  102077:	8b 45 08             	mov    0x8(%ebp),%eax
  10207a:	8b 40 14             	mov    0x14(%eax),%eax
  10207d:	8b 55 08             	mov    0x8(%ebp),%edx
  102080:	8b 52 10             	mov    0x10(%edx),%edx
  102083:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev->next = b->next;
  102086:	8b 45 08             	mov    0x8(%ebp),%eax
  102089:	8b 40 10             	mov    0x10(%eax),%eax
  10208c:	8b 55 08             	mov    0x8(%ebp),%edx
  10208f:	8b 52 14             	mov    0x14(%edx),%edx
  102092:	89 50 14             	mov    %edx,0x14(%eax)
    b->next = bcache.head.next;
  102095:	8b 15 5c d8 10 00    	mov    0x10d85c,%edx
  10209b:	8b 45 08             	mov    0x8(%ebp),%eax
  10209e:	89 50 14             	mov    %edx,0x14(%eax)
    b->prev = &bcache.head;
  1020a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1020a4:	c7 40 10 48 d8 10 00 	movl   $0x10d848,0x10(%eax)
    bcache.head.next->prev = b;
  1020ab:	a1 5c d8 10 00       	mov    0x10d85c,%eax
  1020b0:	8b 55 08             	mov    0x8(%ebp),%edx
  1020b3:	89 50 10             	mov    %edx,0x10(%eax)
    bcache.head.next = b;
  1020b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1020b9:	a3 5c d8 10 00       	mov    %eax,0x10d85c
  }
}
  1020be:	90                   	nop
  1020bf:	5d                   	pop    %ebp
  1020c0:	c3                   	ret    

001020c1 <inb>:
{
  1020c1:	55                   	push   %ebp
  1020c2:	89 e5                	mov    %esp,%ebp
  1020c4:	83 ec 14             	sub    $0x14,%esp
  1020c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1020ca:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1020ce:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1020d2:	89 c2                	mov    %eax,%edx
  1020d4:	ec                   	in     (%dx),%al
  1020d5:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
  1020d8:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
  1020dc:	c9                   	leave  
  1020dd:	c3                   	ret    

001020de <insl>:
{
  1020de:	55                   	push   %ebp
  1020df:	89 e5                	mov    %esp,%ebp
  1020e1:	57                   	push   %edi
  1020e2:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
  1020e3:	8b 55 08             	mov    0x8(%ebp),%edx
  1020e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1020e9:	8b 45 10             	mov    0x10(%ebp),%eax
  1020ec:	89 cb                	mov    %ecx,%ebx
  1020ee:	89 df                	mov    %ebx,%edi
  1020f0:	89 c1                	mov    %eax,%ecx
  1020f2:	fc                   	cld    
  1020f3:	f3 6d                	rep insl (%dx),%es:(%edi)
  1020f5:	89 c8                	mov    %ecx,%eax
  1020f7:	89 fb                	mov    %edi,%ebx
  1020f9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  1020fc:	89 45 10             	mov    %eax,0x10(%ebp)
}
  1020ff:	90                   	nop
  102100:	5b                   	pop    %ebx
  102101:	5f                   	pop    %edi
  102102:	5d                   	pop    %ebp
  102103:	c3                   	ret    

00102104 <outb>:
{
  102104:	55                   	push   %ebp
  102105:	89 e5                	mov    %esp,%ebp
  102107:	83 ec 08             	sub    $0x8,%esp
  10210a:	8b 45 08             	mov    0x8(%ebp),%eax
  10210d:	8b 55 0c             	mov    0xc(%ebp),%edx
  102110:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  102114:	89 d0                	mov    %edx,%eax
  102116:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102119:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
  10211d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  102121:	ee                   	out    %al,(%dx)
}
  102122:	90                   	nop
  102123:	c9                   	leave  
  102124:	c3                   	ret    

00102125 <outsl>:
{
  102125:	55                   	push   %ebp
  102126:	89 e5                	mov    %esp,%ebp
  102128:	56                   	push   %esi
  102129:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
  10212a:	8b 55 08             	mov    0x8(%ebp),%edx
  10212d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  102130:	8b 45 10             	mov    0x10(%ebp),%eax
  102133:	89 cb                	mov    %ecx,%ebx
  102135:	89 de                	mov    %ebx,%esi
  102137:	89 c1                	mov    %eax,%ecx
  102139:	fc                   	cld    
  10213a:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  10213c:	89 c8                	mov    %ecx,%eax
  10213e:	89 f3                	mov    %esi,%ebx
  102140:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  102143:	89 45 10             	mov    %eax,0x10(%ebp)
}
  102146:	90                   	nop
  102147:	5b                   	pop    %ebx
  102148:	5e                   	pop    %esi
  102149:	5d                   	pop    %ebp
  10214a:	c3                   	ret    

0010214b <noop>:

static inline void
noop(void)
{
  10214b:	55                   	push   %ebp
  10214c:	89 e5                	mov    %esp,%ebp
  asm volatile("nop");
  10214e:	90                   	nop
}
  10214f:	90                   	nop
  102150:	5d                   	pop    %ebp
  102151:	c3                   	ret    

00102152 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
  102152:	55                   	push   %ebp
  102153:	89 e5                	mov    %esp,%ebp
  102155:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY);
  102158:	90                   	nop
  102159:	68 f7 01 00 00       	push   $0x1f7
  10215e:	e8 5e ff ff ff       	call   1020c1 <inb>
  102163:	83 c4 04             	add    $0x4,%esp
  102166:	0f b6 c0             	movzbl %al,%eax
  102169:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10216c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10216f:	25 c0 00 00 00       	and    $0xc0,%eax
  102174:	83 f8 40             	cmp    $0x40,%eax
  102177:	75 e0                	jne    102159 <idewait+0x7>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
  102179:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10217d:	74 11                	je     102190 <idewait+0x3e>
  10217f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102182:	83 e0 21             	and    $0x21,%eax
  102185:	85 c0                	test   %eax,%eax
  102187:	74 07                	je     102190 <idewait+0x3e>
    return -1;
  102189:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10218e:	eb 05                	jmp    102195 <idewait+0x43>
  return 0;
  102190:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102195:	c9                   	leave  
  102196:	c3                   	ret    

00102197 <ideinit>:

void
ideinit(void)
{
  102197:	55                   	push   %ebp
  102198:	89 e5                	mov    %esp,%ebp
  10219a:	83 ec 18             	sub    $0x18,%esp
  int i;

  // initlock(&idelock, "ide");
  ioapicenable(IRQ_IDE, ncpu - 1);
  10219d:	a1 c0 54 10 00       	mov    0x1054c0,%eax
  1021a2:	83 e8 01             	sub    $0x1,%eax
  1021a5:	83 ec 08             	sub    $0x8,%esp
  1021a8:	50                   	push   %eax
  1021a9:	6a 0e                	push   $0xe
  1021ab:	e8 e5 e3 ff ff       	call   100595 <ioapicenable>
  1021b0:	83 c4 10             	add    $0x10,%esp
  idewait(0);
  1021b3:	83 ec 0c             	sub    $0xc,%esp
  1021b6:	6a 00                	push   $0x0
  1021b8:	e8 95 ff ff ff       	call   102152 <idewait>
  1021bd:	83 c4 10             	add    $0x10,%esp

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  1021c0:	83 ec 08             	sub    $0x8,%esp
  1021c3:	68 f0 00 00 00       	push   $0xf0
  1021c8:	68 f6 01 00 00       	push   $0x1f6
  1021cd:	e8 32 ff ff ff       	call   102104 <outb>
  1021d2:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
  1021d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1021dc:	eb 24                	jmp    102202 <ideinit+0x6b>
    if(inb(0x1f7) != 0){
  1021de:	83 ec 0c             	sub    $0xc,%esp
  1021e1:	68 f7 01 00 00       	push   $0x1f7
  1021e6:	e8 d6 fe ff ff       	call   1020c1 <inb>
  1021eb:	83 c4 10             	add    $0x10,%esp
  1021ee:	84 c0                	test   %al,%al
  1021f0:	74 0c                	je     1021fe <ideinit+0x67>
      havedisk1 = 1;
  1021f2:	c7 05 68 dc 10 00 01 	movl   $0x1,0x10dc68
  1021f9:	00 00 00 
      break;
  1021fc:	eb 0d                	jmp    10220b <ideinit+0x74>
  for(i=0; i<1000; i++){
  1021fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  102202:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
  102209:	7e d3                	jle    1021de <ideinit+0x47>
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
  10220b:	83 ec 08             	sub    $0x8,%esp
  10220e:	68 e0 00 00 00       	push   $0xe0
  102213:	68 f6 01 00 00       	push   $0x1f6
  102218:	e8 e7 fe ff ff       	call   102104 <outb>
  10221d:	83 c4 10             	add    $0x10,%esp
}
  102220:	90                   	nop
  102221:	c9                   	leave  
  102222:	c3                   	ret    

00102223 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  102223:	55                   	push   %ebp
  102224:	89 e5                	mov    %esp,%ebp
  102226:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
  102229:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10222d:	75 0d                	jne    10223c <idestart+0x19>
    panic("idestart");
  10222f:	83 ec 0c             	sub    $0xc,%esp
  102232:	68 0d 42 10 00       	push   $0x10420d
  102237:	e8 71 e0 ff ff       	call   1002ad <panic>
  if(b->blockno >= FSSIZE)
  10223c:	8b 45 08             	mov    0x8(%ebp),%eax
  10223f:	8b 40 08             	mov    0x8(%eax),%eax
  102242:	3d e7 03 00 00       	cmp    $0x3e7,%eax
  102247:	76 0d                	jbe    102256 <idestart+0x33>
    panic("incorrect blockno");
  102249:	83 ec 0c             	sub    $0xc,%esp
  10224c:	68 16 42 10 00       	push   $0x104216
  102251:	e8 57 e0 ff ff       	call   1002ad <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
  102256:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
  10225d:	8b 45 08             	mov    0x8(%ebp),%eax
  102260:	8b 50 08             	mov    0x8(%eax),%edx
  102263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102266:	0f af c2             	imul   %edx,%eax
  102269:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
  10226c:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  102270:	75 07                	jne    102279 <idestart+0x56>
  102272:	b8 20 00 00 00       	mov    $0x20,%eax
  102277:	eb 05                	jmp    10227e <idestart+0x5b>
  102279:	b8 c4 00 00 00       	mov    $0xc4,%eax
  10227e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
  102281:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  102285:	75 07                	jne    10228e <idestart+0x6b>
  102287:	b8 30 00 00 00       	mov    $0x30,%eax
  10228c:	eb 05                	jmp    102293 <idestart+0x70>
  10228e:	b8 c5 00 00 00       	mov    $0xc5,%eax
  102293:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
  102296:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
  10229a:	7e 0d                	jle    1022a9 <idestart+0x86>
  10229c:	83 ec 0c             	sub    $0xc,%esp
  10229f:	68 0d 42 10 00       	push   $0x10420d
  1022a4:	e8 04 e0 ff ff       	call   1002ad <panic>

  idewait(0);
  1022a9:	83 ec 0c             	sub    $0xc,%esp
  1022ac:	6a 00                	push   $0x0
  1022ae:	e8 9f fe ff ff       	call   102152 <idewait>
  1022b3:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
  1022b6:	83 ec 08             	sub    $0x8,%esp
  1022b9:	6a 00                	push   $0x0
  1022bb:	68 f6 03 00 00       	push   $0x3f6
  1022c0:	e8 3f fe ff ff       	call   102104 <outb>
  1022c5:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
  1022c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1022cb:	0f b6 c0             	movzbl %al,%eax
  1022ce:	83 ec 08             	sub    $0x8,%esp
  1022d1:	50                   	push   %eax
  1022d2:	68 f2 01 00 00       	push   $0x1f2
  1022d7:	e8 28 fe ff ff       	call   102104 <outb>
  1022dc:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
  1022df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1022e2:	0f b6 c0             	movzbl %al,%eax
  1022e5:	83 ec 08             	sub    $0x8,%esp
  1022e8:	50                   	push   %eax
  1022e9:	68 f3 01 00 00       	push   $0x1f3
  1022ee:	e8 11 fe ff ff       	call   102104 <outb>
  1022f3:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
  1022f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1022f9:	c1 f8 08             	sar    $0x8,%eax
  1022fc:	0f b6 c0             	movzbl %al,%eax
  1022ff:	83 ec 08             	sub    $0x8,%esp
  102302:	50                   	push   %eax
  102303:	68 f4 01 00 00       	push   $0x1f4
  102308:	e8 f7 fd ff ff       	call   102104 <outb>
  10230d:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
  102310:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102313:	c1 f8 10             	sar    $0x10,%eax
  102316:	0f b6 c0             	movzbl %al,%eax
  102319:	83 ec 08             	sub    $0x8,%esp
  10231c:	50                   	push   %eax
  10231d:	68 f5 01 00 00       	push   $0x1f5
  102322:	e8 dd fd ff ff       	call   102104 <outb>
  102327:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  10232a:	8b 45 08             	mov    0x8(%ebp),%eax
  10232d:	8b 40 04             	mov    0x4(%eax),%eax
  102330:	c1 e0 04             	shl    $0x4,%eax
  102333:	83 e0 10             	and    $0x10,%eax
  102336:	89 c2                	mov    %eax,%edx
  102338:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10233b:	c1 f8 18             	sar    $0x18,%eax
  10233e:	83 e0 0f             	and    $0xf,%eax
  102341:	09 d0                	or     %edx,%eax
  102343:	83 c8 e0             	or     $0xffffffe0,%eax
  102346:	0f b6 c0             	movzbl %al,%eax
  102349:	83 ec 08             	sub    $0x8,%esp
  10234c:	50                   	push   %eax
  10234d:	68 f6 01 00 00       	push   $0x1f6
  102352:	e8 ad fd ff ff       	call   102104 <outb>
  102357:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
  10235a:	8b 45 08             	mov    0x8(%ebp),%eax
  10235d:	8b 00                	mov    (%eax),%eax
  10235f:	83 e0 04             	and    $0x4,%eax
  102362:	85 c0                	test   %eax,%eax
  102364:	74 35                	je     10239b <idestart+0x178>
    outb(0x1f7, write_cmd);
  102366:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102369:	0f b6 c0             	movzbl %al,%eax
  10236c:	83 ec 08             	sub    $0x8,%esp
  10236f:	50                   	push   %eax
  102370:	68 f7 01 00 00       	push   $0x1f7
  102375:	e8 8a fd ff ff       	call   102104 <outb>
  10237a:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
  10237d:	8b 45 08             	mov    0x8(%ebp),%eax
  102380:	83 c0 1c             	add    $0x1c,%eax
  102383:	83 ec 04             	sub    $0x4,%esp
  102386:	68 80 00 00 00       	push   $0x80
  10238b:	50                   	push   %eax
  10238c:	68 f0 01 00 00       	push   $0x1f0
  102391:	e8 8f fd ff ff       	call   102125 <outsl>
  102396:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, read_cmd);
  }
}
  102399:	eb 17                	jmp    1023b2 <idestart+0x18f>
    outb(0x1f7, read_cmd);
  10239b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10239e:	0f b6 c0             	movzbl %al,%eax
  1023a1:	83 ec 08             	sub    $0x8,%esp
  1023a4:	50                   	push   %eax
  1023a5:	68 f7 01 00 00       	push   $0x1f7
  1023aa:	e8 55 fd ff ff       	call   102104 <outb>
  1023af:	83 c4 10             	add    $0x10,%esp
}
  1023b2:	90                   	nop
  1023b3:	c9                   	leave  
  1023b4:	c3                   	ret    

001023b5 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
  1023b5:	55                   	push   %ebp
  1023b6:	89 e5                	mov    %esp,%ebp
  1023b8:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  if((b = idequeue) == 0){
  1023bb:	a1 64 dc 10 00       	mov    0x10dc64,%eax
  1023c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1023c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1023c7:	74 78                	je     102441 <ideintr+0x8c>
    return;
  }
  idequeue = b->qnext;
  1023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1023cc:	8b 40 18             	mov    0x18(%eax),%eax
  1023cf:	a3 64 dc 10 00       	mov    %eax,0x10dc64

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
  1023d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1023d7:	8b 00                	mov    (%eax),%eax
  1023d9:	83 e0 04             	and    $0x4,%eax
  1023dc:	85 c0                	test   %eax,%eax
  1023de:	75 27                	jne    102407 <ideintr+0x52>
  1023e0:	6a 01                	push   $0x1
  1023e2:	e8 6b fd ff ff       	call   102152 <idewait>
  1023e7:	83 c4 04             	add    $0x4,%esp
  1023ea:	85 c0                	test   %eax,%eax
  1023ec:	78 19                	js     102407 <ideintr+0x52>
    insl(0x1f0, b->data, BSIZE/4);
  1023ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1023f1:	83 c0 1c             	add    $0x1c,%eax
  1023f4:	68 80 00 00 00       	push   $0x80
  1023f9:	50                   	push   %eax
  1023fa:	68 f0 01 00 00       	push   $0x1f0
  1023ff:	e8 da fc ff ff       	call   1020de <insl>
  102404:	83 c4 0c             	add    $0xc,%esp

  b->flags |= B_VALID;
  102407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10240a:	8b 00                	mov    (%eax),%eax
  10240c:	83 c8 02             	or     $0x2,%eax
  10240f:	89 c2                	mov    %eax,%edx
  102411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102414:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
  102416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102419:	8b 00                	mov    (%eax),%eax
  10241b:	83 e0 fb             	and    $0xfffffffb,%eax
  10241e:	89 c2                	mov    %eax,%edx
  102420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102423:	89 10                	mov    %edx,(%eax)

  // Start disk on next buf in queue.
  if(idequeue != 0)
  102425:	a1 64 dc 10 00       	mov    0x10dc64,%eax
  10242a:	85 c0                	test   %eax,%eax
  10242c:	74 14                	je     102442 <ideintr+0x8d>
    idestart(idequeue);
  10242e:	a1 64 dc 10 00       	mov    0x10dc64,%eax
  102433:	83 ec 0c             	sub    $0xc,%esp
  102436:	50                   	push   %eax
  102437:	e8 e7 fd ff ff       	call   102223 <idestart>
  10243c:	83 c4 10             	add    $0x10,%esp
  10243f:	eb 01                	jmp    102442 <ideintr+0x8d>
    return;
  102441:	90                   	nop
}
  102442:	c9                   	leave  
  102443:	c3                   	ret    

00102444 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
  102444:	55                   	push   %ebp
  102445:	89 e5                	mov    %esp,%ebp
  102447:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
  10244a:	8b 45 08             	mov    0x8(%ebp),%eax
  10244d:	8b 00                	mov    (%eax),%eax
  10244f:	83 e0 06             	and    $0x6,%eax
  102452:	83 f8 02             	cmp    $0x2,%eax
  102455:	75 0d                	jne    102464 <iderw+0x20>
    panic("iderw: nothing to do");
  102457:	83 ec 0c             	sub    $0xc,%esp
  10245a:	68 28 42 10 00       	push   $0x104228
  10245f:	e8 49 de ff ff       	call   1002ad <panic>
  if(b->dev != 0 && !havedisk1)
  102464:	8b 45 08             	mov    0x8(%ebp),%eax
  102467:	8b 40 04             	mov    0x4(%eax),%eax
  10246a:	85 c0                	test   %eax,%eax
  10246c:	74 16                	je     102484 <iderw+0x40>
  10246e:	a1 68 dc 10 00       	mov    0x10dc68,%eax
  102473:	85 c0                	test   %eax,%eax
  102475:	75 0d                	jne    102484 <iderw+0x40>
    panic("iderw: ide disk 1 not present");
  102477:	83 ec 0c             	sub    $0xc,%esp
  10247a:	68 3d 42 10 00       	push   $0x10423d
  10247f:	e8 29 de ff ff       	call   1002ad <panic>

  // Append b to idequeue.
  b->qnext = 0;
  102484:	8b 45 08             	mov    0x8(%ebp),%eax
  102487:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
  10248e:	c7 45 f4 64 dc 10 00 	movl   $0x10dc64,-0xc(%ebp)
  102495:	eb 0b                	jmp    1024a2 <iderw+0x5e>
  102497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10249a:	8b 00                	mov    (%eax),%eax
  10249c:	83 c0 18             	add    $0x18,%eax
  10249f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1024a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1024a5:	8b 00                	mov    (%eax),%eax
  1024a7:	85 c0                	test   %eax,%eax
  1024a9:	75 ec                	jne    102497 <iderw+0x53>
    ;
  *pp = b;
  1024ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1024ae:	8b 55 08             	mov    0x8(%ebp),%edx
  1024b1:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
  1024b3:	a1 64 dc 10 00       	mov    0x10dc64,%eax
  1024b8:	39 45 08             	cmp    %eax,0x8(%ebp)
  1024bb:	75 15                	jne    1024d2 <iderw+0x8e>
    idestart(b);
  1024bd:	83 ec 0c             	sub    $0xc,%esp
  1024c0:	ff 75 08             	push   0x8(%ebp)
  1024c3:	e8 5b fd ff ff       	call   102223 <idestart>
  1024c8:	83 c4 10             	add    $0x10,%esp

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
  1024cb:	eb 05                	jmp    1024d2 <iderw+0x8e>
  {
    // Warning: If we do not call noop(), compiler generates code that does not
    // read "b->flags" again and therefore never come out of this while loop. 
    // "b->flags" is modified by the trap handler in ideintr().  
    noop();
  1024cd:	e8 79 fc ff ff       	call   10214b <noop>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
  1024d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1024d5:	8b 00                	mov    (%eax),%eax
  1024d7:	83 e0 06             	and    $0x6,%eax
  1024da:	83 f8 02             	cmp    $0x2,%eax
  1024dd:	75 ee                	jne    1024cd <iderw+0x89>
  }
}
  1024df:	90                   	nop
  1024e0:	90                   	nop
  1024e1:	c9                   	leave  
  1024e2:	c3                   	ret    

001024e3 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
  1024e3:	55                   	push   %ebp
  1024e4:	89 e5                	mov    %esp,%ebp
  1024e6:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread(dev, 1);
  1024e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1024ec:	83 ec 08             	sub    $0x8,%esp
  1024ef:	6a 01                	push   $0x1
  1024f1:	50                   	push   %eax
  1024f2:	e8 ac fa ff ff       	call   101fa3 <bread>
  1024f7:	83 c4 10             	add    $0x10,%esp
  1024fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
  1024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102500:	83 c0 1c             	add    $0x1c,%eax
  102503:	83 ec 04             	sub    $0x4,%esp
  102506:	6a 1c                	push   $0x1c
  102508:	50                   	push   %eax
  102509:	ff 75 0c             	push   0xc(%ebp)
  10250c:	e8 55 ea ff ff       	call   100f66 <memmove>
  102511:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
  102514:	83 ec 0c             	sub    $0xc,%esp
  102517:	ff 75 f4             	push   -0xc(%ebp)
  10251a:	e8 3c fb ff ff       	call   10205b <brelse>
  10251f:	83 c4 10             	add    $0x10,%esp
}
  102522:	90                   	nop
  102523:	c9                   	leave  
  102524:	c3                   	ret    

00102525 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
  102525:	55                   	push   %ebp
  102526:	89 e5                	mov    %esp,%ebp
  102528:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;

  bp = bread_wr(dev, bno);
  10252b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10252e:	8b 45 08             	mov    0x8(%ebp),%eax
  102531:	83 ec 08             	sub    $0x8,%esp
  102534:	52                   	push   %edx
  102535:	50                   	push   %eax
  102536:	e8 c7 fa ff ff       	call   102002 <bread_wr>
  10253b:	83 c4 10             	add    $0x10,%esp
  10253e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
  102541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102544:	83 c0 1c             	add    $0x1c,%eax
  102547:	83 ec 04             	sub    $0x4,%esp
  10254a:	68 00 02 00 00       	push   $0x200
  10254f:	6a 00                	push   $0x0
  102551:	50                   	push   %eax
  102552:	e8 50 e9 ff ff       	call   100ea7 <memset>
  102557:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
  10255a:	83 ec 0c             	sub    $0xc,%esp
  10255d:	ff 75 f4             	push   -0xc(%ebp)
  102560:	e8 af 19 00 00       	call   103f14 <log_write>
  102565:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
  102568:	83 ec 0c             	sub    $0xc,%esp
  10256b:	ff 75 f4             	push   -0xc(%ebp)
  10256e:	e8 e8 fa ff ff       	call   10205b <brelse>
  102573:	83 c4 10             	add    $0x10,%esp
}
  102576:	90                   	nop
  102577:	c9                   	leave  
  102578:	c3                   	ret    

00102579 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
  102579:	55                   	push   %ebp
  10257a:	89 e5                	mov    %esp,%ebp
  10257c:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  10257f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
  102586:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10258d:	e9 0b 01 00 00       	jmp    10269d <balloc+0x124>
    bp = bread_wr(dev, BBLOCK(b, sb));
  102592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102595:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  10259b:	85 c0                	test   %eax,%eax
  10259d:	0f 48 c2             	cmovs  %edx,%eax
  1025a0:	c1 f8 0c             	sar    $0xc,%eax
  1025a3:	89 c2                	mov    %eax,%edx
  1025a5:	a1 98 dc 10 00       	mov    0x10dc98,%eax
  1025aa:	01 d0                	add    %edx,%eax
  1025ac:	83 ec 08             	sub    $0x8,%esp
  1025af:	50                   	push   %eax
  1025b0:	ff 75 08             	push   0x8(%ebp)
  1025b3:	e8 4a fa ff ff       	call   102002 <bread_wr>
  1025b8:	83 c4 10             	add    $0x10,%esp
  1025bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
  1025be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1025c5:	e9 9e 00 00 00       	jmp    102668 <balloc+0xef>
      m = 1 << (bi % 8);
  1025ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1025cd:	83 e0 07             	and    $0x7,%eax
  1025d0:	ba 01 00 00 00       	mov    $0x1,%edx
  1025d5:	89 c1                	mov    %eax,%ecx
  1025d7:	d3 e2                	shl    %cl,%edx
  1025d9:	89 d0                	mov    %edx,%eax
  1025db:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  1025de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1025e1:	8d 50 07             	lea    0x7(%eax),%edx
  1025e4:	85 c0                	test   %eax,%eax
  1025e6:	0f 48 c2             	cmovs  %edx,%eax
  1025e9:	c1 f8 03             	sar    $0x3,%eax
  1025ec:	89 c2                	mov    %eax,%edx
  1025ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1025f1:	0f b6 44 10 1c       	movzbl 0x1c(%eax,%edx,1),%eax
  1025f6:	0f b6 c0             	movzbl %al,%eax
  1025f9:	23 45 e8             	and    -0x18(%ebp),%eax
  1025fc:	85 c0                	test   %eax,%eax
  1025fe:	75 64                	jne    102664 <balloc+0xeb>
        bp->data[bi/8] |= m;  // Mark block in use.
  102600:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102603:	8d 50 07             	lea    0x7(%eax),%edx
  102606:	85 c0                	test   %eax,%eax
  102608:	0f 48 c2             	cmovs  %edx,%eax
  10260b:	c1 f8 03             	sar    $0x3,%eax
  10260e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102611:	0f b6 54 02 1c       	movzbl 0x1c(%edx,%eax,1),%edx
  102616:	89 d1                	mov    %edx,%ecx
  102618:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10261b:	09 ca                	or     %ecx,%edx
  10261d:	89 d1                	mov    %edx,%ecx
  10261f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102622:	88 4c 02 1c          	mov    %cl,0x1c(%edx,%eax,1)
        log_write(bp);
  102626:	83 ec 0c             	sub    $0xc,%esp
  102629:	ff 75 ec             	push   -0x14(%ebp)
  10262c:	e8 e3 18 00 00       	call   103f14 <log_write>
  102631:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
  102634:	83 ec 0c             	sub    $0xc,%esp
  102637:	ff 75 ec             	push   -0x14(%ebp)
  10263a:	e8 1c fa ff ff       	call   10205b <brelse>
  10263f:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
  102642:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102645:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102648:	01 c2                	add    %eax,%edx
  10264a:	8b 45 08             	mov    0x8(%ebp),%eax
  10264d:	83 ec 08             	sub    $0x8,%esp
  102650:	52                   	push   %edx
  102651:	50                   	push   %eax
  102652:	e8 ce fe ff ff       	call   102525 <bzero>
  102657:	83 c4 10             	add    $0x10,%esp
        return b + bi;
  10265a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10265d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102660:	01 d0                	add    %edx,%eax
  102662:	eb 57                	jmp    1026bb <balloc+0x142>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
  102664:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  102668:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
  10266f:	7f 17                	jg     102688 <balloc+0x10f>
  102671:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102674:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102677:	01 d0                	add    %edx,%eax
  102679:	89 c2                	mov    %eax,%edx
  10267b:	a1 80 dc 10 00       	mov    0x10dc80,%eax
  102680:	39 c2                	cmp    %eax,%edx
  102682:	0f 82 42 ff ff ff    	jb     1025ca <balloc+0x51>
      }
    }
    brelse(bp);
  102688:	83 ec 0c             	sub    $0xc,%esp
  10268b:	ff 75 ec             	push   -0x14(%ebp)
  10268e:	e8 c8 f9 ff ff       	call   10205b <brelse>
  102693:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
  102696:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  10269d:	8b 15 80 dc 10 00    	mov    0x10dc80,%edx
  1026a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1026a6:	39 c2                	cmp    %eax,%edx
  1026a8:	0f 87 e4 fe ff ff    	ja     102592 <balloc+0x19>
  }
  panic("balloc: out of blocks");
  1026ae:	83 ec 0c             	sub    $0xc,%esp
  1026b1:	68 5c 42 10 00       	push   $0x10425c
  1026b6:	e8 f2 db ff ff       	call   1002ad <panic>
}
  1026bb:	c9                   	leave  
  1026bc:	c3                   	ret    

001026bd <bfree>:


// Free a disk block.
static void
bfree(int dev, uint b)
{
  1026bd:	55                   	push   %ebp
  1026be:	89 e5                	mov    %esp,%ebp
  1026c0:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  bp = bread_wr(dev, BBLOCK(b, sb));
  1026c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1026c6:	c1 e8 0c             	shr    $0xc,%eax
  1026c9:	89 c2                	mov    %eax,%edx
  1026cb:	a1 98 dc 10 00       	mov    0x10dc98,%eax
  1026d0:	01 c2                	add    %eax,%edx
  1026d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1026d5:	83 ec 08             	sub    $0x8,%esp
  1026d8:	52                   	push   %edx
  1026d9:	50                   	push   %eax
  1026da:	e8 23 f9 ff ff       	call   102002 <bread_wr>
  1026df:	83 c4 10             	add    $0x10,%esp
  1026e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
  1026e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1026e8:	25 ff 0f 00 00       	and    $0xfff,%eax
  1026ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
  1026f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1026f3:	83 e0 07             	and    $0x7,%eax
  1026f6:	ba 01 00 00 00       	mov    $0x1,%edx
  1026fb:	89 c1                	mov    %eax,%ecx
  1026fd:	d3 e2                	shl    %cl,%edx
  1026ff:	89 d0                	mov    %edx,%eax
  102701:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
  102704:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102707:	8d 50 07             	lea    0x7(%eax),%edx
  10270a:	85 c0                	test   %eax,%eax
  10270c:	0f 48 c2             	cmovs  %edx,%eax
  10270f:	c1 f8 03             	sar    $0x3,%eax
  102712:	89 c2                	mov    %eax,%edx
  102714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102717:	0f b6 44 10 1c       	movzbl 0x1c(%eax,%edx,1),%eax
  10271c:	0f b6 c0             	movzbl %al,%eax
  10271f:	23 45 ec             	and    -0x14(%ebp),%eax
  102722:	85 c0                	test   %eax,%eax
  102724:	75 0d                	jne    102733 <bfree+0x76>
    panic("freeing free block");
  102726:	83 ec 0c             	sub    $0xc,%esp
  102729:	68 72 42 10 00       	push   $0x104272
  10272e:	e8 7a db ff ff       	call   1002ad <panic>
  bp->data[bi/8] &= ~m;
  102733:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102736:	8d 50 07             	lea    0x7(%eax),%edx
  102739:	85 c0                	test   %eax,%eax
  10273b:	0f 48 c2             	cmovs  %edx,%eax
  10273e:	c1 f8 03             	sar    $0x3,%eax
  102741:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102744:	0f b6 54 02 1c       	movzbl 0x1c(%edx,%eax,1),%edx
  102749:	89 d1                	mov    %edx,%ecx
  10274b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10274e:	f7 d2                	not    %edx
  102750:	21 ca                	and    %ecx,%edx
  102752:	89 d1                	mov    %edx,%ecx
  102754:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102757:	88 4c 02 1c          	mov    %cl,0x1c(%edx,%eax,1)
  log_write(bp);
  10275b:	83 ec 0c             	sub    $0xc,%esp
  10275e:	ff 75 f4             	push   -0xc(%ebp)
  102761:	e8 ae 17 00 00       	call   103f14 <log_write>
  102766:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
  102769:	83 ec 0c             	sub    $0xc,%esp
  10276c:	ff 75 f4             	push   -0xc(%ebp)
  10276f:	e8 e7 f8 ff ff       	call   10205b <brelse>
  102774:	83 c4 10             	add    $0x10,%esp
}
  102777:	90                   	nop
  102778:	c9                   	leave  
  102779:	c3                   	ret    

0010277a <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
  10277a:	55                   	push   %ebp
  10277b:	89 e5                	mov    %esp,%ebp
  10277d:	57                   	push   %edi
  10277e:	56                   	push   %esi
  10277f:	53                   	push   %ebx
  102780:	83 ec 1c             	sub    $0x1c,%esp
  readsb(dev, &sb);
  102783:	83 ec 08             	sub    $0x8,%esp
  102786:	68 80 dc 10 00       	push   $0x10dc80
  10278b:	ff 75 08             	push   0x8(%ebp)
  10278e:	e8 50 fd ff ff       	call   1024e3 <readsb>
  102793:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
  102796:	a1 98 dc 10 00       	mov    0x10dc98,%eax
  10279b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10279e:	8b 3d 94 dc 10 00    	mov    0x10dc94,%edi
  1027a4:	8b 35 90 dc 10 00    	mov    0x10dc90,%esi
  1027aa:	8b 1d 8c dc 10 00    	mov    0x10dc8c,%ebx
  1027b0:	8b 0d 88 dc 10 00    	mov    0x10dc88,%ecx
  1027b6:	8b 15 84 dc 10 00    	mov    0x10dc84,%edx
  1027bc:	a1 80 dc 10 00       	mov    0x10dc80,%eax
  1027c1:	ff 75 e4             	push   -0x1c(%ebp)
  1027c4:	57                   	push   %edi
  1027c5:	56                   	push   %esi
  1027c6:	53                   	push   %ebx
  1027c7:	51                   	push   %ecx
  1027c8:	52                   	push   %edx
  1027c9:	50                   	push   %eax
  1027ca:	68 88 42 10 00       	push   $0x104288
  1027cf:	e8 18 d9 ff ff       	call   1000ec <cprintf>
  1027d4:	83 c4 20             	add    $0x20,%esp
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
  1027d7:	90                   	nop
  1027d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  1027db:	5b                   	pop    %ebx
  1027dc:	5e                   	pop    %esi
  1027dd:	5f                   	pop    %edi
  1027de:	5d                   	pop    %ebp
  1027df:	c3                   	ret    

001027e0 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
  1027e0:	55                   	push   %ebp
  1027e1:	89 e5                	mov    %esp,%ebp
  1027e3:	83 ec 28             	sub    $0x28,%esp
  1027e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1027e9:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
  1027ed:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  1027f4:	e9 9e 00 00 00       	jmp    102897 <ialloc+0xb7>
    bp = bread_wr(dev, IBLOCK(inum, sb));
  1027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1027fc:	c1 e8 03             	shr    $0x3,%eax
  1027ff:	89 c2                	mov    %eax,%edx
  102801:	a1 94 dc 10 00       	mov    0x10dc94,%eax
  102806:	01 d0                	add    %edx,%eax
  102808:	83 ec 08             	sub    $0x8,%esp
  10280b:	50                   	push   %eax
  10280c:	ff 75 08             	push   0x8(%ebp)
  10280f:	e8 ee f7 ff ff       	call   102002 <bread_wr>
  102814:	83 c4 10             	add    $0x10,%esp
  102817:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
  10281a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10281d:	8d 50 1c             	lea    0x1c(%eax),%edx
  102820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102823:	83 e0 07             	and    $0x7,%eax
  102826:	c1 e0 06             	shl    $0x6,%eax
  102829:	01 d0                	add    %edx,%eax
  10282b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
  10282e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102831:	0f b7 00             	movzwl (%eax),%eax
  102834:	66 85 c0             	test   %ax,%ax
  102837:	75 4c                	jne    102885 <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
  102839:	83 ec 04             	sub    $0x4,%esp
  10283c:	6a 40                	push   $0x40
  10283e:	6a 00                	push   $0x0
  102840:	ff 75 ec             	push   -0x14(%ebp)
  102843:	e8 5f e6 ff ff       	call   100ea7 <memset>
  102848:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
  10284b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10284e:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  102852:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
  102855:	83 ec 0c             	sub    $0xc,%esp
  102858:	ff 75 f0             	push   -0x10(%ebp)
  10285b:	e8 b4 16 00 00       	call   103f14 <log_write>
  102860:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
  102863:	83 ec 0c             	sub    $0xc,%esp
  102866:	ff 75 f0             	push   -0x10(%ebp)
  102869:	e8 ed f7 ff ff       	call   10205b <brelse>
  10286e:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
  102871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102874:	83 ec 08             	sub    $0x8,%esp
  102877:	50                   	push   %eax
  102878:	ff 75 08             	push   0x8(%ebp)
  10287b:	e8 64 01 00 00       	call   1029e4 <iget>
  102880:	83 c4 10             	add    $0x10,%esp
  102883:	eb 30                	jmp    1028b5 <ialloc+0xd5>
    }
    brelse(bp);
  102885:	83 ec 0c             	sub    $0xc,%esp
  102888:	ff 75 f0             	push   -0x10(%ebp)
  10288b:	e8 cb f7 ff ff       	call   10205b <brelse>
  102890:	83 c4 10             	add    $0x10,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
  102893:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  102897:	8b 15 88 dc 10 00    	mov    0x10dc88,%edx
  10289d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1028a0:	39 c2                	cmp    %eax,%edx
  1028a2:	0f 87 51 ff ff ff    	ja     1027f9 <ialloc+0x19>
  }
  panic("ialloc: no inodes");
  1028a8:	83 ec 0c             	sub    $0xc,%esp
  1028ab:	68 db 42 10 00       	push   $0x1042db
  1028b0:	e8 f8 d9 ff ff       	call   1002ad <panic>
}
  1028b5:	c9                   	leave  
  1028b6:	c3                   	ret    

001028b7 <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
  1028b7:	55                   	push   %ebp
  1028b8:	89 e5                	mov    %esp,%ebp
  1028ba:	83 ec 18             	sub    $0x18,%esp
  if(ip->valid && ip->nlink == 0){
  1028bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1028c0:	8b 40 0c             	mov    0xc(%eax),%eax
  1028c3:	85 c0                	test   %eax,%eax
  1028c5:	74 4a                	je     102911 <iput+0x5a>
  1028c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1028ca:	0f b7 40 16          	movzwl 0x16(%eax),%eax
  1028ce:	66 85 c0             	test   %ax,%ax
  1028d1:	75 3e                	jne    102911 <iput+0x5a>
    int r = ip->ref;
  1028d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1028d6:	8b 40 08             	mov    0x8(%eax),%eax
  1028d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(r == 1){
  1028dc:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  1028e0:	75 2f                	jne    102911 <iput+0x5a>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
  1028e2:	83 ec 0c             	sub    $0xc,%esp
  1028e5:	ff 75 08             	push   0x8(%ebp)
  1028e8:	e8 c1 03 00 00       	call   102cae <itrunc>
  1028ed:	83 c4 10             	add    $0x10,%esp
      ip->type = 0;
  1028f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1028f3:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
      iupdate(ip);
  1028f9:	83 ec 0c             	sub    $0xc,%esp
  1028fc:	ff 75 08             	push   0x8(%ebp)
  1028ff:	e8 1f 00 00 00       	call   102923 <iupdate>
  102904:	83 c4 10             	add    $0x10,%esp
      ip->valid = 0;
  102907:	8b 45 08             	mov    0x8(%ebp),%eax
  10290a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    }
  }
  ip->ref--;
  102911:	8b 45 08             	mov    0x8(%ebp),%eax
  102914:	8b 40 08             	mov    0x8(%eax),%eax
  102917:	8d 50 ff             	lea    -0x1(%eax),%edx
  10291a:	8b 45 08             	mov    0x8(%ebp),%eax
  10291d:	89 50 08             	mov    %edx,0x8(%eax)
}
  102920:	90                   	nop
  102921:	c9                   	leave  
  102922:	c3                   	ret    

00102923 <iupdate>:
// Copy a modified in-memory inode to disk.
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
void
iupdate(struct inode *ip)
{
  102923:	55                   	push   %ebp
  102924:	89 e5                	mov    %esp,%ebp
  102926:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread_wr(ip->dev, IBLOCK(ip->inum, sb));
  102929:	8b 45 08             	mov    0x8(%ebp),%eax
  10292c:	8b 40 04             	mov    0x4(%eax),%eax
  10292f:	c1 e8 03             	shr    $0x3,%eax
  102932:	89 c2                	mov    %eax,%edx
  102934:	a1 94 dc 10 00       	mov    0x10dc94,%eax
  102939:	01 c2                	add    %eax,%edx
  10293b:	8b 45 08             	mov    0x8(%ebp),%eax
  10293e:	8b 00                	mov    (%eax),%eax
  102940:	83 ec 08             	sub    $0x8,%esp
  102943:	52                   	push   %edx
  102944:	50                   	push   %eax
  102945:	e8 b8 f6 ff ff       	call   102002 <bread_wr>
  10294a:	83 c4 10             	add    $0x10,%esp
  10294d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  102950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102953:	8d 50 1c             	lea    0x1c(%eax),%edx
  102956:	8b 45 08             	mov    0x8(%ebp),%eax
  102959:	8b 40 04             	mov    0x4(%eax),%eax
  10295c:	83 e0 07             	and    $0x7,%eax
  10295f:	c1 e0 06             	shl    $0x6,%eax
  102962:	01 d0                	add    %edx,%eax
  102964:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
  102967:	8b 45 08             	mov    0x8(%ebp),%eax
  10296a:	0f b7 50 10          	movzwl 0x10(%eax),%edx
  10296e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102971:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
  102974:	8b 45 08             	mov    0x8(%ebp),%eax
  102977:	0f b7 50 12          	movzwl 0x12(%eax),%edx
  10297b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10297e:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
  102982:	8b 45 08             	mov    0x8(%ebp),%eax
  102985:	0f b7 50 14          	movzwl 0x14(%eax),%edx
  102989:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10298c:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
  102990:	8b 45 08             	mov    0x8(%ebp),%eax
  102993:	0f b7 50 16          	movzwl 0x16(%eax),%edx
  102997:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10299a:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
  10299e:	8b 45 08             	mov    0x8(%ebp),%eax
  1029a1:	8b 50 18             	mov    0x18(%eax),%edx
  1029a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029a7:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  1029aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1029ad:	8d 50 1c             	lea    0x1c(%eax),%edx
  1029b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029b3:	83 c0 0c             	add    $0xc,%eax
  1029b6:	83 ec 04             	sub    $0x4,%esp
  1029b9:	6a 34                	push   $0x34
  1029bb:	52                   	push   %edx
  1029bc:	50                   	push   %eax
  1029bd:	e8 a4 e5 ff ff       	call   100f66 <memmove>
  1029c2:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
  1029c5:	83 ec 0c             	sub    $0xc,%esp
  1029c8:	ff 75 f4             	push   -0xc(%ebp)
  1029cb:	e8 44 15 00 00       	call   103f14 <log_write>
  1029d0:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
  1029d3:	83 ec 0c             	sub    $0xc,%esp
  1029d6:	ff 75 f4             	push   -0xc(%ebp)
  1029d9:	e8 7d f6 ff ff       	call   10205b <brelse>
  1029de:	83 c4 10             	add    $0x10,%esp
}
  1029e1:	90                   	nop
  1029e2:	c9                   	leave  
  1029e3:	c3                   	ret    

001029e4 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
struct inode*
iget(uint dev, uint inum)
{
  1029e4:	55                   	push   %ebp
  1029e5:	89 e5                	mov    %esp,%ebp
  1029e7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  // Is the inode already cached?
  empty = 0;
  1029ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  1029f1:	c7 45 f4 a0 dc 10 00 	movl   $0x10dca0,-0xc(%ebp)
  1029f8:	eb 4d                	jmp    102a47 <iget+0x63>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
  1029fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029fd:	8b 40 08             	mov    0x8(%eax),%eax
  102a00:	85 c0                	test   %eax,%eax
  102a02:	7e 29                	jle    102a2d <iget+0x49>
  102a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a07:	8b 00                	mov    (%eax),%eax
  102a09:	39 45 08             	cmp    %eax,0x8(%ebp)
  102a0c:	75 1f                	jne    102a2d <iget+0x49>
  102a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a11:	8b 40 04             	mov    0x4(%eax),%eax
  102a14:	39 45 0c             	cmp    %eax,0xc(%ebp)
  102a17:	75 14                	jne    102a2d <iget+0x49>
      ip->ref++;
  102a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a1c:	8b 40 08             	mov    0x8(%eax),%eax
  102a1f:	8d 50 01             	lea    0x1(%eax),%edx
  102a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a25:	89 50 08             	mov    %edx,0x8(%eax)
      return ip;
  102a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a2b:	eb 64                	jmp    102a91 <iget+0xad>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  102a2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102a31:	75 10                	jne    102a43 <iget+0x5f>
  102a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a36:	8b 40 08             	mov    0x8(%eax),%eax
  102a39:	85 c0                	test   %eax,%eax
  102a3b:	75 06                	jne    102a43 <iget+0x5f>
      empty = ip;
  102a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  102a43:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
  102a47:	81 7d f4 40 ec 10 00 	cmpl   $0x10ec40,-0xc(%ebp)
  102a4e:	72 aa                	jb     1029fa <iget+0x16>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
  102a50:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102a54:	75 0d                	jne    102a63 <iget+0x7f>
    panic("iget: no inodes");
  102a56:	83 ec 0c             	sub    $0xc,%esp
  102a59:	68 ed 42 10 00       	push   $0x1042ed
  102a5e:	e8 4a d8 ff ff       	call   1002ad <panic>

  ip = empty;
  102a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
  102a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a6c:	8b 55 08             	mov    0x8(%ebp),%edx
  102a6f:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
  102a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a74:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a77:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
  102a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a7d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
  102a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a87:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

  return ip;
  102a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102a91:	c9                   	leave  
  102a92:	c3                   	ret    

00102a93 <iread>:

// Reads the inode from disk if necessary.
void
iread(struct inode *ip)
{
  102a93:	55                   	push   %ebp
  102a94:	89 e5                	mov    %esp,%ebp
  102a96:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
  102a99:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102a9d:	74 0a                	je     102aa9 <iread+0x16>
  102a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa2:	8b 40 08             	mov    0x8(%eax),%eax
  102aa5:	85 c0                	test   %eax,%eax
  102aa7:	7f 0d                	jg     102ab6 <iread+0x23>
    panic("iread");
  102aa9:	83 ec 0c             	sub    $0xc,%esp
  102aac:	68 fd 42 10 00       	push   $0x1042fd
  102ab1:	e8 f7 d7 ff ff       	call   1002ad <panic>

  if(ip->valid == 0){
  102ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab9:	8b 40 0c             	mov    0xc(%eax),%eax
  102abc:	85 c0                	test   %eax,%eax
  102abe:	0f 85 cd 00 00 00    	jne    102b91 <iread+0xfe>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  102ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac7:	8b 40 04             	mov    0x4(%eax),%eax
  102aca:	c1 e8 03             	shr    $0x3,%eax
  102acd:	89 c2                	mov    %eax,%edx
  102acf:	a1 94 dc 10 00       	mov    0x10dc94,%eax
  102ad4:	01 c2                	add    %eax,%edx
  102ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad9:	8b 00                	mov    (%eax),%eax
  102adb:	83 ec 08             	sub    $0x8,%esp
  102ade:	52                   	push   %edx
  102adf:	50                   	push   %eax
  102ae0:	e8 be f4 ff ff       	call   101fa3 <bread>
  102ae5:	83 c4 10             	add    $0x10,%esp
  102ae8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
  102aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102aee:	8d 50 1c             	lea    0x1c(%eax),%edx
  102af1:	8b 45 08             	mov    0x8(%ebp),%eax
  102af4:	8b 40 04             	mov    0x4(%eax),%eax
  102af7:	83 e0 07             	and    $0x7,%eax
  102afa:	c1 e0 06             	shl    $0x6,%eax
  102afd:	01 d0                	add    %edx,%eax
  102aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
  102b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b05:	0f b7 10             	movzwl (%eax),%edx
  102b08:	8b 45 08             	mov    0x8(%ebp),%eax
  102b0b:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
  102b0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b12:	0f b7 50 02          	movzwl 0x2(%eax),%edx
  102b16:	8b 45 08             	mov    0x8(%ebp),%eax
  102b19:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
  102b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b20:	0f b7 50 04          	movzwl 0x4(%eax),%edx
  102b24:	8b 45 08             	mov    0x8(%ebp),%eax
  102b27:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
  102b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b2e:	0f b7 50 06          	movzwl 0x6(%eax),%edx
  102b32:	8b 45 08             	mov    0x8(%ebp),%eax
  102b35:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
  102b39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b3c:	8b 50 08             	mov    0x8(%eax),%edx
  102b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  102b42:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  102b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b48:	8d 50 0c             	lea    0xc(%eax),%edx
  102b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  102b4e:	83 c0 1c             	add    $0x1c,%eax
  102b51:	83 ec 04             	sub    $0x4,%esp
  102b54:	6a 34                	push   $0x34
  102b56:	52                   	push   %edx
  102b57:	50                   	push   %eax
  102b58:	e8 09 e4 ff ff       	call   100f66 <memmove>
  102b5d:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
  102b60:	83 ec 0c             	sub    $0xc,%esp
  102b63:	ff 75 f4             	push   -0xc(%ebp)
  102b66:	e8 f0 f4 ff ff       	call   10205b <brelse>
  102b6b:	83 c4 10             	add    $0x10,%esp
    ip->valid = 1;
  102b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  102b71:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
    if(ip->type == 0)
  102b78:	8b 45 08             	mov    0x8(%ebp),%eax
  102b7b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  102b7f:	66 85 c0             	test   %ax,%ax
  102b82:	75 0d                	jne    102b91 <iread+0xfe>
      panic("iread: no type");
  102b84:	83 ec 0c             	sub    $0xc,%esp
  102b87:	68 03 43 10 00       	push   $0x104303
  102b8c:	e8 1c d7 ff ff       	call   1002ad <panic>
  }
}
  102b91:	90                   	nop
  102b92:	c9                   	leave  
  102b93:	c3                   	ret    

00102b94 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
  102b94:	55                   	push   %ebp
  102b95:	89 e5                	mov    %esp,%ebp
  102b97:	83 ec 18             	sub    $0x18,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
  102b9a:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
  102b9e:	77 42                	ja     102be2 <bmap+0x4e>
    if((addr = ip->addrs[bn]) == 0)
  102ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ba3:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ba6:	83 c2 04             	add    $0x4,%edx
  102ba9:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
  102bad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102bb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102bb4:	75 24                	jne    102bda <bmap+0x46>
      ip->addrs[bn] = addr = balloc(ip->dev);
  102bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  102bb9:	8b 00                	mov    (%eax),%eax
  102bbb:	83 ec 0c             	sub    $0xc,%esp
  102bbe:	50                   	push   %eax
  102bbf:	e8 b5 f9 ff ff       	call   102579 <balloc>
  102bc4:	83 c4 10             	add    $0x10,%esp
  102bc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102bca:	8b 45 08             	mov    0x8(%ebp),%eax
  102bcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  102bd0:	8d 4a 04             	lea    0x4(%edx),%ecx
  102bd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102bd6:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
  102bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bdd:	e9 ca 00 00 00       	jmp    102cac <bmap+0x118>
  }
  bn -= NDIRECT;
  102be2:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
  102be6:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
  102bea:	0f 87 af 00 00 00    	ja     102c9f <bmap+0x10b>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
  102bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf3:	8b 40 4c             	mov    0x4c(%eax),%eax
  102bf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102bf9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102bfd:	75 1d                	jne    102c1c <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
  102bff:	8b 45 08             	mov    0x8(%ebp),%eax
  102c02:	8b 00                	mov    (%eax),%eax
  102c04:	83 ec 0c             	sub    $0xc,%esp
  102c07:	50                   	push   %eax
  102c08:	e8 6c f9 ff ff       	call   102579 <balloc>
  102c0d:	83 c4 10             	add    $0x10,%esp
  102c10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c13:	8b 45 08             	mov    0x8(%ebp),%eax
  102c16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102c19:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread_wr(ip->dev, addr);
  102c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  102c1f:	8b 00                	mov    (%eax),%eax
  102c21:	83 ec 08             	sub    $0x8,%esp
  102c24:	ff 75 f4             	push   -0xc(%ebp)
  102c27:	50                   	push   %eax
  102c28:	e8 d5 f3 ff ff       	call   102002 <bread_wr>
  102c2d:	83 c4 10             	add    $0x10,%esp
  102c30:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
  102c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c36:	83 c0 1c             	add    $0x1c,%eax
  102c39:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
  102c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c3f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  102c46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c49:	01 d0                	add    %edx,%eax
  102c4b:	8b 00                	mov    (%eax),%eax
  102c4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102c54:	75 36                	jne    102c8c <bmap+0xf8>
      a[bn] = addr = balloc(ip->dev);
  102c56:	8b 45 08             	mov    0x8(%ebp),%eax
  102c59:	8b 00                	mov    (%eax),%eax
  102c5b:	83 ec 0c             	sub    $0xc,%esp
  102c5e:	50                   	push   %eax
  102c5f:	e8 15 f9 ff ff       	call   102579 <balloc>
  102c64:	83 c4 10             	add    $0x10,%esp
  102c67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c6d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  102c74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c77:	01 c2                	add    %eax,%edx
  102c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c7c:	89 02                	mov    %eax,(%edx)
      log_write(bp);
  102c7e:	83 ec 0c             	sub    $0xc,%esp
  102c81:	ff 75 f0             	push   -0x10(%ebp)
  102c84:	e8 8b 12 00 00       	call   103f14 <log_write>
  102c89:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  102c8c:	83 ec 0c             	sub    $0xc,%esp
  102c8f:	ff 75 f0             	push   -0x10(%ebp)
  102c92:	e8 c4 f3 ff ff       	call   10205b <brelse>
  102c97:	83 c4 10             	add    $0x10,%esp
    return addr;
  102c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c9d:	eb 0d                	jmp    102cac <bmap+0x118>
  }

  panic("bmap: out of range");
  102c9f:	83 ec 0c             	sub    $0xc,%esp
  102ca2:	68 12 43 10 00       	push   $0x104312
  102ca7:	e8 01 d6 ff ff       	call   1002ad <panic>
}
  102cac:	c9                   	leave  
  102cad:	c3                   	ret    

00102cae <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
  102cae:	55                   	push   %ebp
  102caf:	89 e5                	mov    %esp,%ebp
  102cb1:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  102cb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102cbb:	eb 45                	jmp    102d02 <itrunc+0x54>
    if(ip->addrs[i]){
  102cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  102cc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102cc3:	83 c2 04             	add    $0x4,%edx
  102cc6:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
  102cca:	85 c0                	test   %eax,%eax
  102ccc:	74 30                	je     102cfe <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
  102cce:	8b 45 08             	mov    0x8(%ebp),%eax
  102cd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102cd4:	83 c2 04             	add    $0x4,%edx
  102cd7:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
  102cdb:	8b 55 08             	mov    0x8(%ebp),%edx
  102cde:	8b 12                	mov    (%edx),%edx
  102ce0:	83 ec 08             	sub    $0x8,%esp
  102ce3:	50                   	push   %eax
  102ce4:	52                   	push   %edx
  102ce5:	e8 d3 f9 ff ff       	call   1026bd <bfree>
  102cea:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
  102ced:	8b 45 08             	mov    0x8(%ebp),%eax
  102cf0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102cf3:	83 c2 04             	add    $0x4,%edx
  102cf6:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
  102cfd:	00 
  for(i = 0; i < NDIRECT; i++){
  102cfe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  102d02:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
  102d06:	7e b5                	jle    102cbd <itrunc+0xf>
    }
  }

  if(ip->addrs[NDIRECT]){
  102d08:	8b 45 08             	mov    0x8(%ebp),%eax
  102d0b:	8b 40 4c             	mov    0x4c(%eax),%eax
  102d0e:	85 c0                	test   %eax,%eax
  102d10:	0f 84 a1 00 00 00    	je     102db7 <itrunc+0x109>
    bp = bread_wr(ip->dev, ip->addrs[NDIRECT]);
  102d16:	8b 45 08             	mov    0x8(%ebp),%eax
  102d19:	8b 50 4c             	mov    0x4c(%eax),%edx
  102d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d1f:	8b 00                	mov    (%eax),%eax
  102d21:	83 ec 08             	sub    $0x8,%esp
  102d24:	52                   	push   %edx
  102d25:	50                   	push   %eax
  102d26:	e8 d7 f2 ff ff       	call   102002 <bread_wr>
  102d2b:	83 c4 10             	add    $0x10,%esp
  102d2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
  102d31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d34:	83 c0 1c             	add    $0x1c,%eax
  102d37:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
  102d3a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102d41:	eb 3c                	jmp    102d7f <itrunc+0xd1>
      if(a[j])
  102d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d46:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  102d4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d50:	01 d0                	add    %edx,%eax
  102d52:	8b 00                	mov    (%eax),%eax
  102d54:	85 c0                	test   %eax,%eax
  102d56:	74 23                	je     102d7b <itrunc+0xcd>
        bfree(ip->dev, a[j]);
  102d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d5b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  102d62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d65:	01 d0                	add    %edx,%eax
  102d67:	8b 00                	mov    (%eax),%eax
  102d69:	8b 55 08             	mov    0x8(%ebp),%edx
  102d6c:	8b 12                	mov    (%edx),%edx
  102d6e:	83 ec 08             	sub    $0x8,%esp
  102d71:	50                   	push   %eax
  102d72:	52                   	push   %edx
  102d73:	e8 45 f9 ff ff       	call   1026bd <bfree>
  102d78:	83 c4 10             	add    $0x10,%esp
    for(j = 0; j < NINDIRECT; j++){
  102d7b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  102d7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d82:	83 f8 7f             	cmp    $0x7f,%eax
  102d85:	76 bc                	jbe    102d43 <itrunc+0x95>
    }
    brelse(bp);
  102d87:	83 ec 0c             	sub    $0xc,%esp
  102d8a:	ff 75 ec             	push   -0x14(%ebp)
  102d8d:	e8 c9 f2 ff ff       	call   10205b <brelse>
  102d92:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
  102d95:	8b 45 08             	mov    0x8(%ebp),%eax
  102d98:	8b 40 4c             	mov    0x4c(%eax),%eax
  102d9b:	8b 55 08             	mov    0x8(%ebp),%edx
  102d9e:	8b 12                	mov    (%edx),%edx
  102da0:	83 ec 08             	sub    $0x8,%esp
  102da3:	50                   	push   %eax
  102da4:	52                   	push   %edx
  102da5:	e8 13 f9 ff ff       	call   1026bd <bfree>
  102daa:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
  102dad:	8b 45 08             	mov    0x8(%ebp),%eax
  102db0:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
  102db7:	8b 45 08             	mov    0x8(%ebp),%eax
  102dba:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
  102dc1:	83 ec 0c             	sub    $0xc,%esp
  102dc4:	ff 75 08             	push   0x8(%ebp)
  102dc7:	e8 57 fb ff ff       	call   102923 <iupdate>
  102dcc:	83 c4 10             	add    $0x10,%esp
}
  102dcf:	90                   	nop
  102dd0:	c9                   	leave  
  102dd1:	c3                   	ret    

00102dd2 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
  102dd2:	55                   	push   %ebp
  102dd3:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
  102dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  102dd8:	8b 00                	mov    (%eax),%eax
  102dda:	89 c2                	mov    %eax,%edx
  102ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ddf:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
  102de2:	8b 45 08             	mov    0x8(%ebp),%eax
  102de5:	8b 50 04             	mov    0x4(%eax),%edx
  102de8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102deb:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
  102dee:	8b 45 08             	mov    0x8(%ebp),%eax
  102df1:	0f b7 50 10          	movzwl 0x10(%eax),%edx
  102df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102df8:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
  102dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  102dfe:	0f b7 50 16          	movzwl 0x16(%eax),%edx
  102e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e05:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
  102e09:	8b 45 08             	mov    0x8(%ebp),%eax
  102e0c:	8b 50 18             	mov    0x18(%eax),%edx
  102e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e12:	89 50 10             	mov    %edx,0x10(%eax)
}
  102e15:	90                   	nop
  102e16:	5d                   	pop    %ebp
  102e17:	c3                   	ret    

00102e18 <readi>:

// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  102e18:	55                   	push   %ebp
  102e19:	89 e5                	mov    %esp,%ebp
  102e1b:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off || ip->nlink < 1)
  102e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  102e21:	8b 40 18             	mov    0x18(%eax),%eax
  102e24:	39 45 10             	cmp    %eax,0x10(%ebp)
  102e27:	77 19                	ja     102e42 <readi+0x2a>
  102e29:	8b 55 10             	mov    0x10(%ebp),%edx
  102e2c:	8b 45 14             	mov    0x14(%ebp),%eax
  102e2f:	01 d0                	add    %edx,%eax
  102e31:	39 45 10             	cmp    %eax,0x10(%ebp)
  102e34:	77 0c                	ja     102e42 <readi+0x2a>
  102e36:	8b 45 08             	mov    0x8(%ebp),%eax
  102e39:	0f b7 40 16          	movzwl 0x16(%eax),%eax
  102e3d:	66 85 c0             	test   %ax,%ax
  102e40:	7f 0a                	jg     102e4c <readi+0x34>
    return -1;
  102e42:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  102e47:	e9 c2 00 00 00       	jmp    102f0e <readi+0xf6>
  if(off + n > ip->size)
  102e4c:	8b 55 10             	mov    0x10(%ebp),%edx
  102e4f:	8b 45 14             	mov    0x14(%ebp),%eax
  102e52:	01 c2                	add    %eax,%edx
  102e54:	8b 45 08             	mov    0x8(%ebp),%eax
  102e57:	8b 40 18             	mov    0x18(%eax),%eax
  102e5a:	39 c2                	cmp    %eax,%edx
  102e5c:	76 0c                	jbe    102e6a <readi+0x52>
    n = ip->size - off;
  102e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  102e61:	8b 40 18             	mov    0x18(%eax),%eax
  102e64:	2b 45 10             	sub    0x10(%ebp),%eax
  102e67:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  102e6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102e71:	e9 89 00 00 00       	jmp    102eff <readi+0xe7>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
  102e76:	8b 45 10             	mov    0x10(%ebp),%eax
  102e79:	c1 e8 09             	shr    $0x9,%eax
  102e7c:	83 ec 08             	sub    $0x8,%esp
  102e7f:	50                   	push   %eax
  102e80:	ff 75 08             	push   0x8(%ebp)
  102e83:	e8 0c fd ff ff       	call   102b94 <bmap>
  102e88:	83 c4 10             	add    $0x10,%esp
  102e8b:	8b 55 08             	mov    0x8(%ebp),%edx
  102e8e:	8b 12                	mov    (%edx),%edx
  102e90:	83 ec 08             	sub    $0x8,%esp
  102e93:	50                   	push   %eax
  102e94:	52                   	push   %edx
  102e95:	e8 09 f1 ff ff       	call   101fa3 <bread>
  102e9a:	83 c4 10             	add    $0x10,%esp
  102e9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
  102ea0:	8b 45 10             	mov    0x10(%ebp),%eax
  102ea3:	25 ff 01 00 00       	and    $0x1ff,%eax
  102ea8:	ba 00 02 00 00       	mov    $0x200,%edx
  102ead:	29 c2                	sub    %eax,%edx
  102eaf:	8b 45 14             	mov    0x14(%ebp),%eax
  102eb2:	2b 45 f4             	sub    -0xc(%ebp),%eax
  102eb5:	39 c2                	cmp    %eax,%edx
  102eb7:	0f 46 c2             	cmovbe %edx,%eax
  102eba:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
  102ebd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ec0:	8d 50 1c             	lea    0x1c(%eax),%edx
  102ec3:	8b 45 10             	mov    0x10(%ebp),%eax
  102ec6:	25 ff 01 00 00       	and    $0x1ff,%eax
  102ecb:	01 d0                	add    %edx,%eax
  102ecd:	83 ec 04             	sub    $0x4,%esp
  102ed0:	ff 75 ec             	push   -0x14(%ebp)
  102ed3:	50                   	push   %eax
  102ed4:	ff 75 0c             	push   0xc(%ebp)
  102ed7:	e8 8a e0 ff ff       	call   100f66 <memmove>
  102edc:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
  102edf:	83 ec 0c             	sub    $0xc,%esp
  102ee2:	ff 75 f0             	push   -0x10(%ebp)
  102ee5:	e8 71 f1 ff ff       	call   10205b <brelse>
  102eea:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  102eed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ef0:	01 45 f4             	add    %eax,-0xc(%ebp)
  102ef3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ef6:	01 45 10             	add    %eax,0x10(%ebp)
  102ef9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102efc:	01 45 0c             	add    %eax,0xc(%ebp)
  102eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f02:	3b 45 14             	cmp    0x14(%ebp),%eax
  102f05:	0f 82 6b ff ff ff    	jb     102e76 <readi+0x5e>
  }
  return n;
  102f0b:	8b 45 14             	mov    0x14(%ebp),%eax
}
  102f0e:	c9                   	leave  
  102f0f:	c3                   	ret    

00102f10 <writei>:

// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  102f10:	55                   	push   %ebp
  102f11:	89 e5                	mov    %esp,%ebp
  102f13:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
  102f16:	8b 45 08             	mov    0x8(%ebp),%eax
  102f19:	8b 40 18             	mov    0x18(%eax),%eax
  102f1c:	39 45 10             	cmp    %eax,0x10(%ebp)
  102f1f:	77 0d                	ja     102f2e <writei+0x1e>
  102f21:	8b 55 10             	mov    0x10(%ebp),%edx
  102f24:	8b 45 14             	mov    0x14(%ebp),%eax
  102f27:	01 d0                	add    %edx,%eax
  102f29:	39 45 10             	cmp    %eax,0x10(%ebp)
  102f2c:	76 0a                	jbe    102f38 <writei+0x28>
    return -1;
  102f2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  102f33:	e9 f3 00 00 00       	jmp    10302b <writei+0x11b>
  if(off + n > MAXFILE*BSIZE)
  102f38:	8b 55 10             	mov    0x10(%ebp),%edx
  102f3b:	8b 45 14             	mov    0x14(%ebp),%eax
  102f3e:	01 d0                	add    %edx,%eax
  102f40:	3d 00 18 01 00       	cmp    $0x11800,%eax
  102f45:	76 0a                	jbe    102f51 <writei+0x41>
    return -1;
  102f47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  102f4c:	e9 da 00 00 00       	jmp    10302b <writei+0x11b>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  102f51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102f58:	e9 97 00 00 00       	jmp    102ff4 <writei+0xe4>
    bp = bread_wr(ip->dev, bmap(ip, off/BSIZE));
  102f5d:	8b 45 10             	mov    0x10(%ebp),%eax
  102f60:	c1 e8 09             	shr    $0x9,%eax
  102f63:	83 ec 08             	sub    $0x8,%esp
  102f66:	50                   	push   %eax
  102f67:	ff 75 08             	push   0x8(%ebp)
  102f6a:	e8 25 fc ff ff       	call   102b94 <bmap>
  102f6f:	83 c4 10             	add    $0x10,%esp
  102f72:	8b 55 08             	mov    0x8(%ebp),%edx
  102f75:	8b 12                	mov    (%edx),%edx
  102f77:	83 ec 08             	sub    $0x8,%esp
  102f7a:	50                   	push   %eax
  102f7b:	52                   	push   %edx
  102f7c:	e8 81 f0 ff ff       	call   102002 <bread_wr>
  102f81:	83 c4 10             	add    $0x10,%esp
  102f84:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
  102f87:	8b 45 10             	mov    0x10(%ebp),%eax
  102f8a:	25 ff 01 00 00       	and    $0x1ff,%eax
  102f8f:	ba 00 02 00 00       	mov    $0x200,%edx
  102f94:	29 c2                	sub    %eax,%edx
  102f96:	8b 45 14             	mov    0x14(%ebp),%eax
  102f99:	2b 45 f4             	sub    -0xc(%ebp),%eax
  102f9c:	39 c2                	cmp    %eax,%edx
  102f9e:	0f 46 c2             	cmovbe %edx,%eax
  102fa1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
  102fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fa7:	8d 50 1c             	lea    0x1c(%eax),%edx
  102faa:	8b 45 10             	mov    0x10(%ebp),%eax
  102fad:	25 ff 01 00 00       	and    $0x1ff,%eax
  102fb2:	01 d0                	add    %edx,%eax
  102fb4:	83 ec 04             	sub    $0x4,%esp
  102fb7:	ff 75 ec             	push   -0x14(%ebp)
  102fba:	ff 75 0c             	push   0xc(%ebp)
  102fbd:	50                   	push   %eax
  102fbe:	e8 a3 df ff ff       	call   100f66 <memmove>
  102fc3:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
  102fc6:	83 ec 0c             	sub    $0xc,%esp
  102fc9:	ff 75 f0             	push   -0x10(%ebp)
  102fcc:	e8 43 0f 00 00       	call   103f14 <log_write>
  102fd1:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
  102fd4:	83 ec 0c             	sub    $0xc,%esp
  102fd7:	ff 75 f0             	push   -0x10(%ebp)
  102fda:	e8 7c f0 ff ff       	call   10205b <brelse>
  102fdf:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  102fe2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fe5:	01 45 f4             	add    %eax,-0xc(%ebp)
  102fe8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102feb:	01 45 10             	add    %eax,0x10(%ebp)
  102fee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ff1:	01 45 0c             	add    %eax,0xc(%ebp)
  102ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ff7:	3b 45 14             	cmp    0x14(%ebp),%eax
  102ffa:	0f 82 5d ff ff ff    	jb     102f5d <writei+0x4d>
  }

  if(n > 0 && off > ip->size){
  103000:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  103004:	74 22                	je     103028 <writei+0x118>
  103006:	8b 45 08             	mov    0x8(%ebp),%eax
  103009:	8b 40 18             	mov    0x18(%eax),%eax
  10300c:	39 45 10             	cmp    %eax,0x10(%ebp)
  10300f:	76 17                	jbe    103028 <writei+0x118>
    ip->size = off;
  103011:	8b 45 08             	mov    0x8(%ebp),%eax
  103014:	8b 55 10             	mov    0x10(%ebp),%edx
  103017:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
  10301a:	83 ec 0c             	sub    $0xc,%esp
  10301d:	ff 75 08             	push   0x8(%ebp)
  103020:	e8 fe f8 ff ff       	call   102923 <iupdate>
  103025:	83 c4 10             	add    $0x10,%esp
  }
  return n;
  103028:	8b 45 14             	mov    0x14(%ebp),%eax
}
  10302b:	c9                   	leave  
  10302c:	c3                   	ret    

0010302d <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
  10302d:	55                   	push   %ebp
  10302e:	89 e5                	mov    %esp,%ebp
  103030:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
  103033:	83 ec 04             	sub    $0x4,%esp
  103036:	6a 0e                	push   $0xe
  103038:	ff 75 0c             	push   0xc(%ebp)
  10303b:	ff 75 08             	push   0x8(%ebp)
  10303e:	e8 b9 df ff ff       	call   100ffc <strncmp>
  103043:	83 c4 10             	add    $0x10,%esp
}
  103046:	c9                   	leave  
  103047:	c3                   	ret    

00103048 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  103048:	55                   	push   %ebp
  103049:	89 e5                	mov    %esp,%ebp
  10304b:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
  10304e:	8b 45 08             	mov    0x8(%ebp),%eax
  103051:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  103055:	66 83 f8 01          	cmp    $0x1,%ax
  103059:	74 0d                	je     103068 <dirlookup+0x20>
    panic("dirlookup not DIR");
  10305b:	83 ec 0c             	sub    $0xc,%esp
  10305e:	68 25 43 10 00       	push   $0x104325
  103063:	e8 45 d2 ff ff       	call   1002ad <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
  103068:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10306f:	eb 7b                	jmp    1030ec <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  103071:	6a 10                	push   $0x10
  103073:	ff 75 f4             	push   -0xc(%ebp)
  103076:	8d 45 e0             	lea    -0x20(%ebp),%eax
  103079:	50                   	push   %eax
  10307a:	ff 75 08             	push   0x8(%ebp)
  10307d:	e8 96 fd ff ff       	call   102e18 <readi>
  103082:	83 c4 10             	add    $0x10,%esp
  103085:	83 f8 10             	cmp    $0x10,%eax
  103088:	74 0d                	je     103097 <dirlookup+0x4f>
      panic("dirlookup read");
  10308a:	83 ec 0c             	sub    $0xc,%esp
  10308d:	68 37 43 10 00       	push   $0x104337
  103092:	e8 16 d2 ff ff       	call   1002ad <panic>
    if(de.inum == 0)
  103097:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
  10309b:	66 85 c0             	test   %ax,%ax
  10309e:	74 47                	je     1030e7 <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
  1030a0:	83 ec 08             	sub    $0x8,%esp
  1030a3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1030a6:	83 c0 02             	add    $0x2,%eax
  1030a9:	50                   	push   %eax
  1030aa:	ff 75 0c             	push   0xc(%ebp)
  1030ad:	e8 7b ff ff ff       	call   10302d <namecmp>
  1030b2:	83 c4 10             	add    $0x10,%esp
  1030b5:	85 c0                	test   %eax,%eax
  1030b7:	75 2f                	jne    1030e8 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
  1030b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030bd:	74 08                	je     1030c7 <dirlookup+0x7f>
        *poff = off;
  1030bf:	8b 45 10             	mov    0x10(%ebp),%eax
  1030c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1030c5:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
  1030c7:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
  1030cb:	0f b7 c0             	movzwl %ax,%eax
  1030ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
  1030d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1030d4:	8b 00                	mov    (%eax),%eax
  1030d6:	83 ec 08             	sub    $0x8,%esp
  1030d9:	ff 75 f0             	push   -0x10(%ebp)
  1030dc:	50                   	push   %eax
  1030dd:	e8 02 f9 ff ff       	call   1029e4 <iget>
  1030e2:	83 c4 10             	add    $0x10,%esp
  1030e5:	eb 19                	jmp    103100 <dirlookup+0xb8>
      continue;
  1030e7:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
  1030e8:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
  1030ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ef:	8b 40 18             	mov    0x18(%eax),%eax
  1030f2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1030f5:	0f 82 76 ff ff ff    	jb     103071 <dirlookup+0x29>
    }
  }

  return 0;
  1030fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103100:	c9                   	leave  
  103101:	c3                   	ret    

00103102 <dirlink>:


// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
  103102:	55                   	push   %ebp
  103103:	89 e5                	mov    %esp,%ebp
  103105:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
  103108:	83 ec 04             	sub    $0x4,%esp
  10310b:	6a 00                	push   $0x0
  10310d:	ff 75 0c             	push   0xc(%ebp)
  103110:	ff 75 08             	push   0x8(%ebp)
  103113:	e8 30 ff ff ff       	call   103048 <dirlookup>
  103118:	83 c4 10             	add    $0x10,%esp
  10311b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10311e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103122:	74 18                	je     10313c <dirlink+0x3a>
    iput(ip);
  103124:	83 ec 0c             	sub    $0xc,%esp
  103127:	ff 75 f0             	push   -0x10(%ebp)
  10312a:	e8 88 f7 ff ff       	call   1028b7 <iput>
  10312f:	83 c4 10             	add    $0x10,%esp
    return -1;
  103132:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103137:	e9 9c 00 00 00       	jmp    1031d8 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  10313c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103143:	eb 39                	jmp    10317e <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  103145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103148:	6a 10                	push   $0x10
  10314a:	50                   	push   %eax
  10314b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  10314e:	50                   	push   %eax
  10314f:	ff 75 08             	push   0x8(%ebp)
  103152:	e8 c1 fc ff ff       	call   102e18 <readi>
  103157:	83 c4 10             	add    $0x10,%esp
  10315a:	83 f8 10             	cmp    $0x10,%eax
  10315d:	74 0d                	je     10316c <dirlink+0x6a>
      panic("dirlink read");
  10315f:	83 ec 0c             	sub    $0xc,%esp
  103162:	68 46 43 10 00       	push   $0x104346
  103167:	e8 41 d1 ff ff       	call   1002ad <panic>
    if(de.inum == 0)
  10316c:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
  103170:	66 85 c0             	test   %ax,%ax
  103173:	74 18                	je     10318d <dirlink+0x8b>
  for(off = 0; off < dp->size; off += sizeof(de)){
  103175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103178:	83 c0 10             	add    $0x10,%eax
  10317b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10317e:	8b 45 08             	mov    0x8(%ebp),%eax
  103181:	8b 50 18             	mov    0x18(%eax),%edx
  103184:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103187:	39 c2                	cmp    %eax,%edx
  103189:	77 ba                	ja     103145 <dirlink+0x43>
  10318b:	eb 01                	jmp    10318e <dirlink+0x8c>
      break;
  10318d:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
  10318e:	83 ec 04             	sub    $0x4,%esp
  103191:	6a 0e                	push   $0xe
  103193:	ff 75 0c             	push   0xc(%ebp)
  103196:	8d 45 e0             	lea    -0x20(%ebp),%eax
  103199:	83 c0 02             	add    $0x2,%eax
  10319c:	50                   	push   %eax
  10319d:	e8 b0 de ff ff       	call   101052 <strncpy>
  1031a2:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
  1031a5:	8b 45 10             	mov    0x10(%ebp),%eax
  1031a8:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  1031ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031af:	6a 10                	push   $0x10
  1031b1:	50                   	push   %eax
  1031b2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1031b5:	50                   	push   %eax
  1031b6:	ff 75 08             	push   0x8(%ebp)
  1031b9:	e8 52 fd ff ff       	call   102f10 <writei>
  1031be:	83 c4 10             	add    $0x10,%esp
  1031c1:	83 f8 10             	cmp    $0x10,%eax
  1031c4:	74 0d                	je     1031d3 <dirlink+0xd1>
    panic("dirlink");
  1031c6:	83 ec 0c             	sub    $0xc,%esp
  1031c9:	68 53 43 10 00       	push   $0x104353
  1031ce:	e8 da d0 ff ff       	call   1002ad <panic>

  return 0;
  1031d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1031d8:	c9                   	leave  
  1031d9:	c3                   	ret    

001031da <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
  1031da:	55                   	push   %ebp
  1031db:	89 e5                	mov    %esp,%ebp
  1031dd:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
  1031e0:	eb 04                	jmp    1031e6 <skipelem+0xc>
    path++;
  1031e2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
  1031e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1031e9:	0f b6 00             	movzbl (%eax),%eax
  1031ec:	3c 2f                	cmp    $0x2f,%al
  1031ee:	74 f2                	je     1031e2 <skipelem+0x8>
  if(*path == 0)
  1031f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1031f3:	0f b6 00             	movzbl (%eax),%eax
  1031f6:	84 c0                	test   %al,%al
  1031f8:	75 07                	jne    103201 <skipelem+0x27>
    return 0;
  1031fa:	b8 00 00 00 00       	mov    $0x0,%eax
  1031ff:	eb 77                	jmp    103278 <skipelem+0x9e>
  s = path;
  103201:	8b 45 08             	mov    0x8(%ebp),%eax
  103204:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
  103207:	eb 04                	jmp    10320d <skipelem+0x33>
    path++;
  103209:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
  10320d:	8b 45 08             	mov    0x8(%ebp),%eax
  103210:	0f b6 00             	movzbl (%eax),%eax
  103213:	3c 2f                	cmp    $0x2f,%al
  103215:	74 0a                	je     103221 <skipelem+0x47>
  103217:	8b 45 08             	mov    0x8(%ebp),%eax
  10321a:	0f b6 00             	movzbl (%eax),%eax
  10321d:	84 c0                	test   %al,%al
  10321f:	75 e8                	jne    103209 <skipelem+0x2f>
  len = path - s;
  103221:	8b 45 08             	mov    0x8(%ebp),%eax
  103224:	2b 45 f4             	sub    -0xc(%ebp),%eax
  103227:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
  10322a:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10322e:	7e 15                	jle    103245 <skipelem+0x6b>
    memmove(name, s, DIRSIZ);
  103230:	83 ec 04             	sub    $0x4,%esp
  103233:	6a 0e                	push   $0xe
  103235:	ff 75 f4             	push   -0xc(%ebp)
  103238:	ff 75 0c             	push   0xc(%ebp)
  10323b:	e8 26 dd ff ff       	call   100f66 <memmove>
  103240:	83 c4 10             	add    $0x10,%esp
  103243:	eb 26                	jmp    10326b <skipelem+0x91>
  else {
    memmove(name, s, len);
  103245:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103248:	83 ec 04             	sub    $0x4,%esp
  10324b:	50                   	push   %eax
  10324c:	ff 75 f4             	push   -0xc(%ebp)
  10324f:	ff 75 0c             	push   0xc(%ebp)
  103252:	e8 0f dd ff ff       	call   100f66 <memmove>
  103257:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
  10325a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10325d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103260:	01 d0                	add    %edx,%eax
  103262:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
  103265:	eb 04                	jmp    10326b <skipelem+0x91>
    path++;
  103267:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
  10326b:	8b 45 08             	mov    0x8(%ebp),%eax
  10326e:	0f b6 00             	movzbl (%eax),%eax
  103271:	3c 2f                	cmp    $0x2f,%al
  103273:	74 f2                	je     103267 <skipelem+0x8d>
  return path;
  103275:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103278:	c9                   	leave  
  103279:	c3                   	ret    

0010327a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
  10327a:	55                   	push   %ebp
  10327b:	89 e5                	mov    %esp,%ebp
  10327d:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  ip = iget(ROOTDEV, ROOTINO);
  103280:	83 ec 08             	sub    $0x8,%esp
  103283:	6a 01                	push   $0x1
  103285:	6a 01                	push   $0x1
  103287:	e8 58 f7 ff ff       	call   1029e4 <iget>
  10328c:	83 c4 10             	add    $0x10,%esp
  10328f:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
  103292:	e9 90 00 00 00       	jmp    103327 <namex+0xad>
    iread(ip);
  103297:	83 ec 0c             	sub    $0xc,%esp
  10329a:	ff 75 f4             	push   -0xc(%ebp)
  10329d:	e8 f1 f7 ff ff       	call   102a93 <iread>
  1032a2:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
  1032a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032a8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  1032ac:	66 83 f8 01          	cmp    $0x1,%ax
  1032b0:	74 18                	je     1032ca <namex+0x50>
      iput(ip);
  1032b2:	83 ec 0c             	sub    $0xc,%esp
  1032b5:	ff 75 f4             	push   -0xc(%ebp)
  1032b8:	e8 fa f5 ff ff       	call   1028b7 <iput>
  1032bd:	83 c4 10             	add    $0x10,%esp
      return 0;
  1032c0:	b8 00 00 00 00       	mov    $0x0,%eax
  1032c5:	e9 99 00 00 00       	jmp    103363 <namex+0xe9>
    }
    if(nameiparent && *path == '\0'){
  1032ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1032ce:	74 12                	je     1032e2 <namex+0x68>
  1032d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1032d3:	0f b6 00             	movzbl (%eax),%eax
  1032d6:	84 c0                	test   %al,%al
  1032d8:	75 08                	jne    1032e2 <namex+0x68>
      // Stop one level early.
      return ip;
  1032da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032dd:	e9 81 00 00 00       	jmp    103363 <namex+0xe9>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
  1032e2:	83 ec 04             	sub    $0x4,%esp
  1032e5:	6a 00                	push   $0x0
  1032e7:	ff 75 10             	push   0x10(%ebp)
  1032ea:	ff 75 f4             	push   -0xc(%ebp)
  1032ed:	e8 56 fd ff ff       	call   103048 <dirlookup>
  1032f2:	83 c4 10             	add    $0x10,%esp
  1032f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1032fc:	75 15                	jne    103313 <namex+0x99>
      iput(ip);
  1032fe:	83 ec 0c             	sub    $0xc,%esp
  103301:	ff 75 f4             	push   -0xc(%ebp)
  103304:	e8 ae f5 ff ff       	call   1028b7 <iput>
  103309:	83 c4 10             	add    $0x10,%esp
      return 0;
  10330c:	b8 00 00 00 00       	mov    $0x0,%eax
  103311:	eb 50                	jmp    103363 <namex+0xe9>
    }
    iput(ip);
  103313:	83 ec 0c             	sub    $0xc,%esp
  103316:	ff 75 f4             	push   -0xc(%ebp)
  103319:	e8 99 f5 ff ff       	call   1028b7 <iput>
  10331e:	83 c4 10             	add    $0x10,%esp
    ip = next;
  103321:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103324:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
  103327:	83 ec 08             	sub    $0x8,%esp
  10332a:	ff 75 10             	push   0x10(%ebp)
  10332d:	ff 75 08             	push   0x8(%ebp)
  103330:	e8 a5 fe ff ff       	call   1031da <skipelem>
  103335:	83 c4 10             	add    $0x10,%esp
  103338:	89 45 08             	mov    %eax,0x8(%ebp)
  10333b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10333f:	0f 85 52 ff ff ff    	jne    103297 <namex+0x1d>
  }
  if(nameiparent){
  103345:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103349:	74 15                	je     103360 <namex+0xe6>
    iput(ip);
  10334b:	83 ec 0c             	sub    $0xc,%esp
  10334e:	ff 75 f4             	push   -0xc(%ebp)
  103351:	e8 61 f5 ff ff       	call   1028b7 <iput>
  103356:	83 c4 10             	add    $0x10,%esp
    return 0;
  103359:	b8 00 00 00 00       	mov    $0x0,%eax
  10335e:	eb 03                	jmp    103363 <namex+0xe9>
  }
  return ip;
  103360:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103363:	c9                   	leave  
  103364:	c3                   	ret    

00103365 <namei>:

struct inode*
namei(char *path)
{
  103365:	55                   	push   %ebp
  103366:	89 e5                	mov    %esp,%ebp
  103368:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
  10336b:	83 ec 04             	sub    $0x4,%esp
  10336e:	8d 45 ea             	lea    -0x16(%ebp),%eax
  103371:	50                   	push   %eax
  103372:	6a 00                	push   $0x0
  103374:	ff 75 08             	push   0x8(%ebp)
  103377:	e8 fe fe ff ff       	call   10327a <namex>
  10337c:	83 c4 10             	add    $0x10,%esp
}
  10337f:	c9                   	leave  
  103380:	c3                   	ret    

00103381 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
  103381:	55                   	push   %ebp
  103382:	89 e5                	mov    %esp,%ebp
  103384:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
  103387:	83 ec 04             	sub    $0x4,%esp
  10338a:	ff 75 0c             	push   0xc(%ebp)
  10338d:	6a 01                	push   $0x1
  10338f:	ff 75 08             	push   0x8(%ebp)
  103392:	e8 e3 fe ff ff       	call   10327a <namex>
  103397:	83 c4 10             	add    $0x10,%esp
}
  10339a:	c9                   	leave  
  10339b:	c3                   	ret    

0010339c <filealloc>:
} ftable;

// Allocate a file structure.
struct file*
filealloc(void)
{
  10339c:	55                   	push   %ebp
  10339d:	89 e5                	mov    %esp,%ebp
  10339f:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  for(f = ftable.file; f < ftable.file + NFILE; f++){
  1033a2:	c7 45 fc 40 ec 10 00 	movl   $0x10ec40,-0x4(%ebp)
  1033a9:	eb 1d                	jmp    1033c8 <filealloc+0x2c>
    if(f->ref == 0){
  1033ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1033ae:	8b 40 04             	mov    0x4(%eax),%eax
  1033b1:	85 c0                	test   %eax,%eax
  1033b3:	75 0f                	jne    1033c4 <filealloc+0x28>
      f->ref = 1;
  1033b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1033b8:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      return f;
  1033bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1033c2:	eb 13                	jmp    1033d7 <filealloc+0x3b>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
  1033c4:	83 45 fc 14          	addl   $0x14,-0x4(%ebp)
  1033c8:	b8 10 f4 10 00       	mov    $0x10f410,%eax
  1033cd:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1033d0:	72 d9                	jb     1033ab <filealloc+0xf>
    }
  }
  return 0;
  1033d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1033d7:	c9                   	leave  
  1033d8:	c3                   	ret    

001033d9 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
  1033d9:	55                   	push   %ebp
  1033da:	89 e5                	mov    %esp,%ebp
  1033dc:	83 ec 08             	sub    $0x8,%esp
  if(f->ref < 1)
  1033df:	8b 45 08             	mov    0x8(%ebp),%eax
  1033e2:	8b 40 04             	mov    0x4(%eax),%eax
  1033e5:	85 c0                	test   %eax,%eax
  1033e7:	7f 0d                	jg     1033f6 <filedup+0x1d>
    panic("filedup");
  1033e9:	83 ec 0c             	sub    $0xc,%esp
  1033ec:	68 5b 43 10 00       	push   $0x10435b
  1033f1:	e8 b7 ce ff ff       	call   1002ad <panic>
  f->ref++;
  1033f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1033f9:	8b 40 04             	mov    0x4(%eax),%eax
  1033fc:	8d 50 01             	lea    0x1(%eax),%edx
  1033ff:	8b 45 08             	mov    0x8(%ebp),%eax
  103402:	89 50 04             	mov    %edx,0x4(%eax)
  return f;
  103405:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103408:	c9                   	leave  
  103409:	c3                   	ret    

0010340a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
  10340a:	55                   	push   %ebp
  10340b:	89 e5                	mov    %esp,%ebp
  10340d:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  if(f->ref < 1)
  103410:	8b 45 08             	mov    0x8(%ebp),%eax
  103413:	8b 40 04             	mov    0x4(%eax),%eax
  103416:	85 c0                	test   %eax,%eax
  103418:	7f 0d                	jg     103427 <fileclose+0x1d>
    panic("fileclose");
  10341a:	83 ec 0c             	sub    $0xc,%esp
  10341d:	68 63 43 10 00       	push   $0x104363
  103422:	e8 86 ce ff ff       	call   1002ad <panic>
  if(--f->ref > 0){
  103427:	8b 45 08             	mov    0x8(%ebp),%eax
  10342a:	8b 40 04             	mov    0x4(%eax),%eax
  10342d:	8d 50 ff             	lea    -0x1(%eax),%edx
  103430:	8b 45 08             	mov    0x8(%ebp),%eax
  103433:	89 50 04             	mov    %edx,0x4(%eax)
  103436:	8b 45 08             	mov    0x8(%ebp),%eax
  103439:	8b 40 04             	mov    0x4(%eax),%eax
  10343c:	85 c0                	test   %eax,%eax
  10343e:	7f 56                	jg     103496 <fileclose+0x8c>
    return;
  }
  ff = *f;
  103440:	8b 45 08             	mov    0x8(%ebp),%eax
  103443:	8b 10                	mov    (%eax),%edx
  103445:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103448:	8b 50 04             	mov    0x4(%eax),%edx
  10344b:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10344e:	8b 50 08             	mov    0x8(%eax),%edx
  103451:	89 55 ec             	mov    %edx,-0x14(%ebp)
  103454:	8b 50 0c             	mov    0xc(%eax),%edx
  103457:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10345a:	8b 40 10             	mov    0x10(%eax),%eax
  10345d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
  103460:	8b 45 08             	mov    0x8(%ebp),%eax
  103463:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
  10346a:	8b 45 08             	mov    0x8(%ebp),%eax
  10346d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(ff.type == FD_INODE){
  103473:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103476:	83 f8 01             	cmp    $0x1,%eax
  103479:	75 1c                	jne    103497 <fileclose+0x8d>
    begin_op();
  10347b:	e8 b8 09 00 00       	call   103e38 <begin_op>
    iput(ff.ip);
  103480:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103483:	83 ec 0c             	sub    $0xc,%esp
  103486:	50                   	push   %eax
  103487:	e8 2b f4 ff ff       	call   1028b7 <iput>
  10348c:	83 c4 10             	add    $0x10,%esp
    end_op();
  10348f:	e8 aa 09 00 00       	call   103e3e <end_op>
  103494:	eb 01                	jmp    103497 <fileclose+0x8d>
    return;
  103496:	90                   	nop
  }
}
  103497:	c9                   	leave  
  103498:	c3                   	ret    

00103499 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  103499:	55                   	push   %ebp
  10349a:	89 e5                	mov    %esp,%ebp
  10349c:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
  10349f:	8b 45 08             	mov    0x8(%ebp),%eax
  1034a2:	8b 00                	mov    (%eax),%eax
  1034a4:	83 f8 01             	cmp    $0x1,%eax
  1034a7:	75 2e                	jne    1034d7 <filestat+0x3e>
    iread(f->ip);
  1034a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1034ac:	8b 40 0c             	mov    0xc(%eax),%eax
  1034af:	83 ec 0c             	sub    $0xc,%esp
  1034b2:	50                   	push   %eax
  1034b3:	e8 db f5 ff ff       	call   102a93 <iread>
  1034b8:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
  1034bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1034be:	8b 40 0c             	mov    0xc(%eax),%eax
  1034c1:	83 ec 08             	sub    $0x8,%esp
  1034c4:	ff 75 0c             	push   0xc(%ebp)
  1034c7:	50                   	push   %eax
  1034c8:	e8 05 f9 ff ff       	call   102dd2 <stati>
  1034cd:	83 c4 10             	add    $0x10,%esp
    return 0;
  1034d0:	b8 00 00 00 00       	mov    $0x0,%eax
  1034d5:	eb 05                	jmp    1034dc <filestat+0x43>
  }
  return -1;
  1034d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1034dc:	c9                   	leave  
  1034dd:	c3                   	ret    

001034de <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
  1034de:	55                   	push   %ebp
  1034df:	89 e5                	mov    %esp,%ebp
  1034e1:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
  1034e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1034e7:	0f b6 40 08          	movzbl 0x8(%eax),%eax
  1034eb:	84 c0                	test   %al,%al
  1034ed:	75 07                	jne    1034f6 <fileread+0x18>
    return -1;
  1034ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1034f4:	eb 65                	jmp    10355b <fileread+0x7d>
  if(f->type == FD_INODE){
  1034f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1034f9:	8b 00                	mov    (%eax),%eax
  1034fb:	83 f8 01             	cmp    $0x1,%eax
  1034fe:	75 4e                	jne    10354e <fileread+0x70>
    iread(f->ip);
  103500:	8b 45 08             	mov    0x8(%ebp),%eax
  103503:	8b 40 0c             	mov    0xc(%eax),%eax
  103506:	83 ec 0c             	sub    $0xc,%esp
  103509:	50                   	push   %eax
  10350a:	e8 84 f5 ff ff       	call   102a93 <iread>
  10350f:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
  103512:	8b 4d 10             	mov    0x10(%ebp),%ecx
  103515:	8b 45 08             	mov    0x8(%ebp),%eax
  103518:	8b 50 10             	mov    0x10(%eax),%edx
  10351b:	8b 45 08             	mov    0x8(%ebp),%eax
  10351e:	8b 40 0c             	mov    0xc(%eax),%eax
  103521:	51                   	push   %ecx
  103522:	52                   	push   %edx
  103523:	ff 75 0c             	push   0xc(%ebp)
  103526:	50                   	push   %eax
  103527:	e8 ec f8 ff ff       	call   102e18 <readi>
  10352c:	83 c4 10             	add    $0x10,%esp
  10352f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103532:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103536:	7e 11                	jle    103549 <fileread+0x6b>
      f->off += r;
  103538:	8b 45 08             	mov    0x8(%ebp),%eax
  10353b:	8b 50 10             	mov    0x10(%eax),%edx
  10353e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103541:	01 c2                	add    %eax,%edx
  103543:	8b 45 08             	mov    0x8(%ebp),%eax
  103546:	89 50 10             	mov    %edx,0x10(%eax)
    return r;
  103549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10354c:	eb 0d                	jmp    10355b <fileread+0x7d>
  }
  panic("fileread");
  10354e:	83 ec 0c             	sub    $0xc,%esp
  103551:	68 6d 43 10 00       	push   $0x10436d
  103556:	e8 52 cd ff ff       	call   1002ad <panic>
}
  10355b:	c9                   	leave  
  10355c:	c3                   	ret    

0010355d <filewrite>:

// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
  10355d:	55                   	push   %ebp
  10355e:	89 e5                	mov    %esp,%ebp
  103560:	53                   	push   %ebx
  103561:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
  103564:	8b 45 08             	mov    0x8(%ebp),%eax
  103567:	0f b6 40 09          	movzbl 0x9(%eax),%eax
  10356b:	84 c0                	test   %al,%al
  10356d:	75 0a                	jne    103579 <filewrite+0x1c>
    return -1;
  10356f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103574:	e9 e2 00 00 00       	jmp    10365b <filewrite+0xfe>
  if(f->type == FD_INODE){
  103579:	8b 45 08             	mov    0x8(%ebp),%eax
  10357c:	8b 00                	mov    (%eax),%eax
  10357e:	83 f8 01             	cmp    $0x1,%eax
  103581:	0f 85 c7 00 00 00    	jne    10364e <filewrite+0xf1>
    // write a few blocks at a time
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
  103587:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
  10358e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
  103595:	e9 91 00 00 00       	jmp    10362b <filewrite+0xce>
      int n1 = n - i;
  10359a:	8b 45 10             	mov    0x10(%ebp),%eax
  10359d:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1035a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
  1035a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035a6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1035a9:	7e 06                	jle    1035b1 <filewrite+0x54>
        n1 = max;
  1035ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035ae:	89 45 f0             	mov    %eax,-0x10(%ebp)

			begin_op();
  1035b1:	e8 82 08 00 00       	call   103e38 <begin_op>
      iread(f->ip);
  1035b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1035b9:	8b 40 0c             	mov    0xc(%eax),%eax
  1035bc:	83 ec 0c             	sub    $0xc,%esp
  1035bf:	50                   	push   %eax
  1035c0:	e8 ce f4 ff ff       	call   102a93 <iread>
  1035c5:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
  1035c8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1035cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1035ce:	8b 50 10             	mov    0x10(%eax),%edx
  1035d1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1035d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035d7:	01 c3                	add    %eax,%ebx
  1035d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1035dc:	8b 40 0c             	mov    0xc(%eax),%eax
  1035df:	51                   	push   %ecx
  1035e0:	52                   	push   %edx
  1035e1:	53                   	push   %ebx
  1035e2:	50                   	push   %eax
  1035e3:	e8 28 f9 ff ff       	call   102f10 <writei>
  1035e8:	83 c4 10             	add    $0x10,%esp
  1035eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1035ee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1035f2:	7e 11                	jle    103605 <filewrite+0xa8>
        f->off += r;
  1035f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1035f7:	8b 50 10             	mov    0x10(%eax),%edx
  1035fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1035fd:	01 c2                	add    %eax,%edx
  1035ff:	8b 45 08             	mov    0x8(%ebp),%eax
  103602:	89 50 10             	mov    %edx,0x10(%eax)
      end_op();
  103605:	e8 34 08 00 00       	call   103e3e <end_op>

      if(r < 0)
  10360a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10360e:	78 29                	js     103639 <filewrite+0xdc>
        break;
      if(r != n1)
  103610:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103613:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  103616:	74 0d                	je     103625 <filewrite+0xc8>
        panic("short filewrite");
  103618:	83 ec 0c             	sub    $0xc,%esp
  10361b:	68 76 43 10 00       	push   $0x104376
  103620:	e8 88 cc ff ff       	call   1002ad <panic>
      i += r;
  103625:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103628:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
  10362b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10362e:	3b 45 10             	cmp    0x10(%ebp),%eax
  103631:	0f 8c 63 ff ff ff    	jl     10359a <filewrite+0x3d>
  103637:	eb 01                	jmp    10363a <filewrite+0xdd>
        break;
  103639:	90                   	nop
    }
    return i == n ? n : -1;
  10363a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10363d:	3b 45 10             	cmp    0x10(%ebp),%eax
  103640:	75 05                	jne    103647 <filewrite+0xea>
  103642:	8b 45 10             	mov    0x10(%ebp),%eax
  103645:	eb 14                	jmp    10365b <filewrite+0xfe>
  103647:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10364c:	eb 0d                	jmp    10365b <filewrite+0xfe>
  }
  panic("filewrite");
  10364e:	83 ec 0c             	sub    $0xc,%esp
  103651:	68 86 43 10 00       	push   $0x104386
  103656:	e8 52 cc ff ff       	call   1002ad <panic>
}
  10365b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  10365e:	c9                   	leave  
  10365f:	c3                   	ret    

00103660 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
  103660:	55                   	push   %ebp
  103661:	89 e5                	mov    %esp,%ebp
  103663:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
  103666:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
  10366d:	eb 40                	jmp    1036af <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  10366f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103672:	6a 10                	push   $0x10
  103674:	50                   	push   %eax
  103675:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  103678:	50                   	push   %eax
  103679:	ff 75 08             	push   0x8(%ebp)
  10367c:	e8 97 f7 ff ff       	call   102e18 <readi>
  103681:	83 c4 10             	add    $0x10,%esp
  103684:	83 f8 10             	cmp    $0x10,%eax
  103687:	74 0d                	je     103696 <isdirempty+0x36>
      panic("isdirempty: readi");
  103689:	83 ec 0c             	sub    $0xc,%esp
  10368c:	68 90 43 10 00       	push   $0x104390
  103691:	e8 17 cc ff ff       	call   1002ad <panic>
    if(de.inum != 0)
  103696:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
  10369a:	66 85 c0             	test   %ax,%ax
  10369d:	74 07                	je     1036a6 <isdirempty+0x46>
      return 0;
  10369f:	b8 00 00 00 00       	mov    $0x0,%eax
  1036a4:	eb 1b                	jmp    1036c1 <isdirempty+0x61>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
  1036a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036a9:	83 c0 10             	add    $0x10,%eax
  1036ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1036af:	8b 45 08             	mov    0x8(%ebp),%eax
  1036b2:	8b 50 18             	mov    0x18(%eax),%edx
  1036b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036b8:	39 c2                	cmp    %eax,%edx
  1036ba:	77 b3                	ja     10366f <isdirempty+0xf>
  }
  return 1;
  1036bc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  1036c1:	c9                   	leave  
  1036c2:	c3                   	ret    

001036c3 <unlink>:

int
unlink(char* path, char* name)
{
  1036c3:	55                   	push   %ebp
  1036c4:	89 e5                	mov    %esp,%ebp
  1036c6:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *dp;
  struct dirent de;
  uint off;

	begin_op();
  1036c9:	e8 6a 07 00 00       	call   103e38 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
  1036ce:	83 ec 08             	sub    $0x8,%esp
  1036d1:	ff 75 0c             	push   0xc(%ebp)
  1036d4:	ff 75 08             	push   0x8(%ebp)
  1036d7:	e8 a5 fc ff ff       	call   103381 <nameiparent>
  1036dc:	83 c4 10             	add    $0x10,%esp
  1036df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1036e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1036e6:	75 0f                	jne    1036f7 <unlink+0x34>
    end_op();
  1036e8:	e8 51 07 00 00       	call   103e3e <end_op>
    return -1;
  1036ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1036f2:	e9 8c 01 00 00       	jmp    103883 <unlink+0x1c0>
  }

  iread(dp);
  1036f7:	83 ec 0c             	sub    $0xc,%esp
  1036fa:	ff 75 f4             	push   -0xc(%ebp)
  1036fd:	e8 91 f3 ff ff       	call   102a93 <iread>
  103702:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
  103705:	83 ec 08             	sub    $0x8,%esp
  103708:	68 a2 43 10 00       	push   $0x1043a2
  10370d:	ff 75 0c             	push   0xc(%ebp)
  103710:	e8 18 f9 ff ff       	call   10302d <namecmp>
  103715:	83 c4 10             	add    $0x10,%esp
  103718:	85 c0                	test   %eax,%eax
  10371a:	0f 84 47 01 00 00    	je     103867 <unlink+0x1a4>
  103720:	83 ec 08             	sub    $0x8,%esp
  103723:	68 a4 43 10 00       	push   $0x1043a4
  103728:	ff 75 0c             	push   0xc(%ebp)
  10372b:	e8 fd f8 ff ff       	call   10302d <namecmp>
  103730:	83 c4 10             	add    $0x10,%esp
  103733:	85 c0                	test   %eax,%eax
  103735:	0f 84 2c 01 00 00    	je     103867 <unlink+0x1a4>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
  10373b:	83 ec 04             	sub    $0x4,%esp
  10373e:	8d 45 dc             	lea    -0x24(%ebp),%eax
  103741:	50                   	push   %eax
  103742:	ff 75 0c             	push   0xc(%ebp)
  103745:	ff 75 f4             	push   -0xc(%ebp)
  103748:	e8 fb f8 ff ff       	call   103048 <dirlookup>
  10374d:	83 c4 10             	add    $0x10,%esp
  103750:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103753:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103757:	0f 84 0d 01 00 00    	je     10386a <unlink+0x1a7>
    goto bad;
  iread(ip);
  10375d:	83 ec 0c             	sub    $0xc,%esp
  103760:	ff 75 f0             	push   -0x10(%ebp)
  103763:	e8 2b f3 ff ff       	call   102a93 <iread>
  103768:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
  10376b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10376e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
  103772:	66 85 c0             	test   %ax,%ax
  103775:	7f 0d                	jg     103784 <unlink+0xc1>
    panic("unlink: nlink < 1");
  103777:	83 ec 0c             	sub    $0xc,%esp
  10377a:	68 a7 43 10 00       	push   $0x1043a7
  10377f:	e8 29 cb ff ff       	call   1002ad <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
  103784:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103787:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  10378b:	66 83 f8 01          	cmp    $0x1,%ax
  10378f:	75 25                	jne    1037b6 <unlink+0xf3>
  103791:	83 ec 0c             	sub    $0xc,%esp
  103794:	ff 75 f0             	push   -0x10(%ebp)
  103797:	e8 c4 fe ff ff       	call   103660 <isdirempty>
  10379c:	83 c4 10             	add    $0x10,%esp
  10379f:	85 c0                	test   %eax,%eax
  1037a1:	75 13                	jne    1037b6 <unlink+0xf3>
    iput(ip);
  1037a3:	83 ec 0c             	sub    $0xc,%esp
  1037a6:	ff 75 f0             	push   -0x10(%ebp)
  1037a9:	e8 09 f1 ff ff       	call   1028b7 <iput>
  1037ae:	83 c4 10             	add    $0x10,%esp
    goto bad;
  1037b1:	e9 b5 00 00 00       	jmp    10386b <unlink+0x1a8>
  }

  memset(&de, 0, sizeof(de));
  1037b6:	83 ec 04             	sub    $0x4,%esp
  1037b9:	6a 10                	push   $0x10
  1037bb:	6a 00                	push   $0x0
  1037bd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1037c0:	50                   	push   %eax
  1037c1:	e8 e1 d6 ff ff       	call   100ea7 <memset>
  1037c6:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  1037c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1037cc:	6a 10                	push   $0x10
  1037ce:	50                   	push   %eax
  1037cf:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1037d2:	50                   	push   %eax
  1037d3:	ff 75 f4             	push   -0xc(%ebp)
  1037d6:	e8 35 f7 ff ff       	call   102f10 <writei>
  1037db:	83 c4 10             	add    $0x10,%esp
  1037de:	83 f8 10             	cmp    $0x10,%eax
  1037e1:	74 0d                	je     1037f0 <unlink+0x12d>
    panic("unlink: writei");
  1037e3:	83 ec 0c             	sub    $0xc,%esp
  1037e6:	68 b9 43 10 00       	push   $0x1043b9
  1037eb:	e8 bd ca ff ff       	call   1002ad <panic>
  if(ip->type == T_DIR){
  1037f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1037f3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  1037f7:	66 83 f8 01          	cmp    $0x1,%ax
  1037fb:	75 21                	jne    10381e <unlink+0x15b>
    dp->nlink--;
  1037fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103800:	0f b7 40 16          	movzwl 0x16(%eax),%eax
  103804:	83 e8 01             	sub    $0x1,%eax
  103807:	89 c2                	mov    %eax,%edx
  103809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10380c:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
  103810:	83 ec 0c             	sub    $0xc,%esp
  103813:	ff 75 f4             	push   -0xc(%ebp)
  103816:	e8 08 f1 ff ff       	call   102923 <iupdate>
  10381b:	83 c4 10             	add    $0x10,%esp
  }
  iput(dp);
  10381e:	83 ec 0c             	sub    $0xc,%esp
  103821:	ff 75 f4             	push   -0xc(%ebp)
  103824:	e8 8e f0 ff ff       	call   1028b7 <iput>
  103829:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
  10382c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10382f:	0f b7 40 16          	movzwl 0x16(%eax),%eax
  103833:	83 e8 01             	sub    $0x1,%eax
  103836:	89 c2                	mov    %eax,%edx
  103838:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10383b:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
  10383f:	83 ec 0c             	sub    $0xc,%esp
  103842:	ff 75 f0             	push   -0x10(%ebp)
  103845:	e8 d9 f0 ff ff       	call   102923 <iupdate>
  10384a:	83 c4 10             	add    $0x10,%esp
  iput(ip);
  10384d:	83 ec 0c             	sub    $0xc,%esp
  103850:	ff 75 f0             	push   -0x10(%ebp)
  103853:	e8 5f f0 ff ff       	call   1028b7 <iput>
  103858:	83 c4 10             	add    $0x10,%esp

  end_op();
  10385b:	e8 de 05 00 00       	call   103e3e <end_op>
  return 0;
  103860:	b8 00 00 00 00       	mov    $0x0,%eax
  103865:	eb 1c                	jmp    103883 <unlink+0x1c0>
    goto bad;
  103867:	90                   	nop
  103868:	eb 01                	jmp    10386b <unlink+0x1a8>
    goto bad;
  10386a:	90                   	nop

bad:
  iput(dp);
  10386b:	83 ec 0c             	sub    $0xc,%esp
  10386e:	ff 75 f4             	push   -0xc(%ebp)
  103871:	e8 41 f0 ff ff       	call   1028b7 <iput>
  103876:	83 c4 10             	add    $0x10,%esp
  end_op();
  103879:	e8 c0 05 00 00       	call   103e3e <end_op>
  return -1;
  10387e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  103883:	c9                   	leave  
  103884:	c3                   	ret    

00103885 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
  103885:	55                   	push   %ebp
  103886:	89 e5                	mov    %esp,%ebp
  103888:	83 ec 38             	sub    $0x38,%esp
  10388b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  10388e:	8b 55 10             	mov    0x10(%ebp),%edx
  103891:	8b 45 14             	mov    0x14(%ebp),%eax
  103894:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
  103898:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
  10389c:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  1038a0:	83 ec 08             	sub    $0x8,%esp
  1038a3:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  1038a6:	50                   	push   %eax
  1038a7:	ff 75 08             	push   0x8(%ebp)
  1038aa:	e8 d2 fa ff ff       	call   103381 <nameiparent>
  1038af:	83 c4 10             	add    $0x10,%esp
  1038b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1038b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1038b9:	75 0a                	jne    1038c5 <create+0x40>
    return 0;
  1038bb:	b8 00 00 00 00       	mov    $0x0,%eax
  1038c0:	e9 8e 01 00 00       	jmp    103a53 <create+0x1ce>
  iread(dp);
  1038c5:	83 ec 0c             	sub    $0xc,%esp
  1038c8:	ff 75 f4             	push   -0xc(%ebp)
  1038cb:	e8 c3 f1 ff ff       	call   102a93 <iread>
  1038d0:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, 0)) != 0){
  1038d3:	83 ec 04             	sub    $0x4,%esp
  1038d6:	6a 00                	push   $0x0
  1038d8:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  1038db:	50                   	push   %eax
  1038dc:	ff 75 f4             	push   -0xc(%ebp)
  1038df:	e8 64 f7 ff ff       	call   103048 <dirlookup>
  1038e4:	83 c4 10             	add    $0x10,%esp
  1038e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1038ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1038ee:	74 50                	je     103940 <create+0xbb>
    iput(dp);
  1038f0:	83 ec 0c             	sub    $0xc,%esp
  1038f3:	ff 75 f4             	push   -0xc(%ebp)
  1038f6:	e8 bc ef ff ff       	call   1028b7 <iput>
  1038fb:	83 c4 10             	add    $0x10,%esp
    iread(ip);
  1038fe:	83 ec 0c             	sub    $0xc,%esp
  103901:	ff 75 f0             	push   -0x10(%ebp)
  103904:	e8 8a f1 ff ff       	call   102a93 <iread>
  103909:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
  10390c:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
  103911:	75 15                	jne    103928 <create+0xa3>
  103913:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103916:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  10391a:	66 83 f8 02          	cmp    $0x2,%ax
  10391e:	75 08                	jne    103928 <create+0xa3>
      return ip;
  103920:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103923:	e9 2b 01 00 00       	jmp    103a53 <create+0x1ce>
    iput(ip);
  103928:	83 ec 0c             	sub    $0xc,%esp
  10392b:	ff 75 f0             	push   -0x10(%ebp)
  10392e:	e8 84 ef ff ff       	call   1028b7 <iput>
  103933:	83 c4 10             	add    $0x10,%esp
    return 0;
  103936:	b8 00 00 00 00       	mov    $0x0,%eax
  10393b:	e9 13 01 00 00       	jmp    103a53 <create+0x1ce>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
  103940:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
  103944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103947:	8b 00                	mov    (%eax),%eax
  103949:	83 ec 08             	sub    $0x8,%esp
  10394c:	52                   	push   %edx
  10394d:	50                   	push   %eax
  10394e:	e8 8d ee ff ff       	call   1027e0 <ialloc>
  103953:	83 c4 10             	add    $0x10,%esp
  103956:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103959:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10395d:	75 0d                	jne    10396c <create+0xe7>
    panic("create: ialloc");
  10395f:	83 ec 0c             	sub    $0xc,%esp
  103962:	68 c8 43 10 00       	push   $0x1043c8
  103967:	e8 41 c9 ff ff       	call   1002ad <panic>

  iread(ip);
  10396c:	83 ec 0c             	sub    $0xc,%esp
  10396f:	ff 75 f0             	push   -0x10(%ebp)
  103972:	e8 1c f1 ff ff       	call   102a93 <iread>
  103977:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
  10397a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10397d:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
  103981:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
  103985:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103988:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
  10398c:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
  103990:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103993:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
  103999:	83 ec 0c             	sub    $0xc,%esp
  10399c:	ff 75 f0             	push   -0x10(%ebp)
  10399f:	e8 7f ef ff ff       	call   102923 <iupdate>
  1039a4:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
  1039a7:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
  1039ac:	75 6a                	jne    103a18 <create+0x193>
    dp->nlink++;  // for ".."
  1039ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039b1:	0f b7 40 16          	movzwl 0x16(%eax),%eax
  1039b5:	83 c0 01             	add    $0x1,%eax
  1039b8:	89 c2                	mov    %eax,%edx
  1039ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039bd:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
  1039c1:	83 ec 0c             	sub    $0xc,%esp
  1039c4:	ff 75 f4             	push   -0xc(%ebp)
  1039c7:	e8 57 ef ff ff       	call   102923 <iupdate>
  1039cc:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
  1039cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1039d2:	8b 40 04             	mov    0x4(%eax),%eax
  1039d5:	83 ec 04             	sub    $0x4,%esp
  1039d8:	50                   	push   %eax
  1039d9:	68 a2 43 10 00       	push   $0x1043a2
  1039de:	ff 75 f0             	push   -0x10(%ebp)
  1039e1:	e8 1c f7 ff ff       	call   103102 <dirlink>
  1039e6:	83 c4 10             	add    $0x10,%esp
  1039e9:	85 c0                	test   %eax,%eax
  1039eb:	78 1e                	js     103a0b <create+0x186>
  1039ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039f0:	8b 40 04             	mov    0x4(%eax),%eax
  1039f3:	83 ec 04             	sub    $0x4,%esp
  1039f6:	50                   	push   %eax
  1039f7:	68 a4 43 10 00       	push   $0x1043a4
  1039fc:	ff 75 f0             	push   -0x10(%ebp)
  1039ff:	e8 fe f6 ff ff       	call   103102 <dirlink>
  103a04:	83 c4 10             	add    $0x10,%esp
  103a07:	85 c0                	test   %eax,%eax
  103a09:	79 0d                	jns    103a18 <create+0x193>
      panic("create dots");
  103a0b:	83 ec 0c             	sub    $0xc,%esp
  103a0e:	68 d7 43 10 00       	push   $0x1043d7
  103a13:	e8 95 c8 ff ff       	call   1002ad <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
  103a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a1b:	8b 40 04             	mov    0x4(%eax),%eax
  103a1e:	83 ec 04             	sub    $0x4,%esp
  103a21:	50                   	push   %eax
  103a22:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  103a25:	50                   	push   %eax
  103a26:	ff 75 f4             	push   -0xc(%ebp)
  103a29:	e8 d4 f6 ff ff       	call   103102 <dirlink>
  103a2e:	83 c4 10             	add    $0x10,%esp
  103a31:	85 c0                	test   %eax,%eax
  103a33:	79 0d                	jns    103a42 <create+0x1bd>
    panic("create: dirlink");
  103a35:	83 ec 0c             	sub    $0xc,%esp
  103a38:	68 e3 43 10 00       	push   $0x1043e3
  103a3d:	e8 6b c8 ff ff       	call   1002ad <panic>

  iput(dp);
  103a42:	83 ec 0c             	sub    $0xc,%esp
  103a45:	ff 75 f4             	push   -0xc(%ebp)
  103a48:	e8 6a ee ff ff       	call   1028b7 <iput>
  103a4d:	83 c4 10             	add    $0x10,%esp

  return ip;
  103a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103a53:	c9                   	leave  
  103a54:	c3                   	ret    

00103a55 <open>:


struct file*
open(char* path, int omode)
{
  103a55:	55                   	push   %ebp
  103a56:	89 e5                	mov    %esp,%ebp
  103a58:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;

  begin_op();
  103a5b:	e8 d8 03 00 00       	call   103e38 <begin_op>

  if(omode & O_CREATE){
  103a60:	8b 45 0c             	mov    0xc(%ebp),%eax
  103a63:	25 00 02 00 00       	and    $0x200,%eax
  103a68:	85 c0                	test   %eax,%eax
  103a6a:	74 29                	je     103a95 <open+0x40>
    ip = create(path, T_FILE, 0, 0);
  103a6c:	6a 00                	push   $0x0
  103a6e:	6a 00                	push   $0x0
  103a70:	6a 02                	push   $0x2
  103a72:	ff 75 08             	push   0x8(%ebp)
  103a75:	e8 0b fe ff ff       	call   103885 <create>
  103a7a:	83 c4 10             	add    $0x10,%esp
  103a7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
  103a80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103a84:	75 73                	jne    103af9 <open+0xa4>
      end_op();
  103a86:	e8 b3 03 00 00       	call   103e3e <end_op>
      return 0;
  103a8b:	b8 00 00 00 00       	mov    $0x0,%eax
  103a90:	e9 eb 00 00 00       	jmp    103b80 <open+0x12b>
    }
  } else {
    if((ip = namei(path)) == 0){
  103a95:	83 ec 0c             	sub    $0xc,%esp
  103a98:	ff 75 08             	push   0x8(%ebp)
  103a9b:	e8 c5 f8 ff ff       	call   103365 <namei>
  103aa0:	83 c4 10             	add    $0x10,%esp
  103aa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103aa6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103aaa:	75 0f                	jne    103abb <open+0x66>
      end_op();
  103aac:	e8 8d 03 00 00       	call   103e3e <end_op>
      return 0;
  103ab1:	b8 00 00 00 00       	mov    $0x0,%eax
  103ab6:	e9 c5 00 00 00       	jmp    103b80 <open+0x12b>
    }
    iread(ip);
  103abb:	83 ec 0c             	sub    $0xc,%esp
  103abe:	ff 75 f4             	push   -0xc(%ebp)
  103ac1:	e8 cd ef ff ff       	call   102a93 <iread>
  103ac6:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
  103ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103acc:	0f b7 40 10          	movzwl 0x10(%eax),%eax
  103ad0:	66 83 f8 01          	cmp    $0x1,%ax
  103ad4:	75 23                	jne    103af9 <open+0xa4>
  103ad6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103ada:	74 1d                	je     103af9 <open+0xa4>
      iput(ip);
  103adc:	83 ec 0c             	sub    $0xc,%esp
  103adf:	ff 75 f4             	push   -0xc(%ebp)
  103ae2:	e8 d0 ed ff ff       	call   1028b7 <iput>
  103ae7:	83 c4 10             	add    $0x10,%esp
      end_op();
  103aea:	e8 4f 03 00 00       	call   103e3e <end_op>
      return 0;
  103aef:	b8 00 00 00 00       	mov    $0x0,%eax
  103af4:	e9 87 00 00 00       	jmp    103b80 <open+0x12b>
    }
  }

  struct file* f;
  if((f = filealloc()) == 0) { 
  103af9:	e8 9e f8 ff ff       	call   10339c <filealloc>
  103afe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103b01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103b05:	75 1a                	jne    103b21 <open+0xcc>
    iput(ip);
  103b07:	83 ec 0c             	sub    $0xc,%esp
  103b0a:	ff 75 f4             	push   -0xc(%ebp)
  103b0d:	e8 a5 ed ff ff       	call   1028b7 <iput>
  103b12:	83 c4 10             	add    $0x10,%esp
    end_op();
  103b15:	e8 24 03 00 00       	call   103e3e <end_op>
    return 0;
  103b1a:	b8 00 00 00 00       	mov    $0x0,%eax
  103b1f:	eb 5f                	jmp    103b80 <open+0x12b>
  }

  f->type = FD_INODE;
  103b21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103b24:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  f->ip = ip;
  103b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103b2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103b30:	89 50 0c             	mov    %edx,0xc(%eax)
  f->off = 0;
  103b33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103b36:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
  f->readable = !(omode & O_WRONLY);
  103b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103b40:	83 e0 01             	and    $0x1,%eax
  103b43:	85 c0                	test   %eax,%eax
  103b45:	0f 94 c0             	sete   %al
  103b48:	89 c2                	mov    %eax,%edx
  103b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103b4d:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  103b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  103b53:	83 e0 01             	and    $0x1,%eax
  103b56:	85 c0                	test   %eax,%eax
  103b58:	75 0a                	jne    103b64 <open+0x10f>
  103b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  103b5d:	83 e0 02             	and    $0x2,%eax
  103b60:	85 c0                	test   %eax,%eax
  103b62:	74 07                	je     103b6b <open+0x116>
  103b64:	b8 01 00 00 00       	mov    $0x1,%eax
  103b69:	eb 05                	jmp    103b70 <open+0x11b>
  103b6b:	b8 00 00 00 00       	mov    $0x0,%eax
  103b70:	89 c2                	mov    %eax,%edx
  103b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103b75:	88 50 09             	mov    %dl,0x9(%eax)
  end_op();
  103b78:	e8 c1 02 00 00       	call   103e3e <end_op>
  return f;
  103b7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103b80:	c9                   	leave  
  103b81:	c3                   	ret    

00103b82 <mkdir>:

int mkdir(char *path)
{
  103b82:	55                   	push   %ebp
  103b83:	89 e5                	mov    %esp,%ebp
  103b85:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;

  begin_op();
  103b88:	e8 ab 02 00 00       	call   103e38 <begin_op>
  if((ip = create(path, T_DIR, 0, 0)) == 0){
  103b8d:	6a 00                	push   $0x0
  103b8f:	6a 00                	push   $0x0
  103b91:	6a 01                	push   $0x1
  103b93:	ff 75 08             	push   0x8(%ebp)
  103b96:	e8 ea fc ff ff       	call   103885 <create>
  103b9b:	83 c4 10             	add    $0x10,%esp
  103b9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103ba1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103ba5:	75 0c                	jne    103bb3 <mkdir+0x31>
    end_op();
  103ba7:	e8 92 02 00 00       	call   103e3e <end_op>
    return -1;
  103bac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103bb1:	eb 18                	jmp    103bcb <mkdir+0x49>
  }
  iput(ip);
  103bb3:	83 ec 0c             	sub    $0xc,%esp
  103bb6:	ff 75 f4             	push   -0xc(%ebp)
  103bb9:	e8 f9 ec ff ff       	call   1028b7 <iput>
  103bbe:	83 c4 10             	add    $0x10,%esp
  end_op();
  103bc1:	e8 78 02 00 00       	call   103e3e <end_op>
  return 0;
  103bc6:	b8 00 00 00 00       	mov    $0x0,%eax
  103bcb:	c9                   	leave  
  103bcc:	c3                   	ret    

00103bcd <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
  103bcd:	55                   	push   %ebp
  103bce:	89 e5                	mov    %esp,%ebp
  103bd0:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  readsb(dev, &sb);
  103bd3:	83 ec 08             	sub    $0x8,%esp
  103bd6:	8d 45 dc             	lea    -0x24(%ebp),%eax
  103bd9:	50                   	push   %eax
  103bda:	ff 75 08             	push   0x8(%ebp)
  103bdd:	e8 01 e9 ff ff       	call   1024e3 <readsb>
  103be2:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
  103be5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103be8:	a3 20 f4 10 00       	mov    %eax,0x10f420
  log.size = sb.nlog;
  103bed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103bf0:	a3 24 f4 10 00       	mov    %eax,0x10f424
  log.dev = dev;
  103bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  103bf8:	a3 2c f4 10 00       	mov    %eax,0x10f42c
  recover_from_log();
  103bfd:	e8 14 02 00 00       	call   103e16 <recover_from_log>
}
  103c02:	90                   	nop
  103c03:	c9                   	leave  
  103c04:	c3                   	ret    

00103c05 <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
  103c05:	55                   	push   %ebp
  103c06:	89 e5                	mov    %esp,%ebp
  103c08:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
  103c0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103c12:	eb 44                	jmp    103c58 <install_trans+0x53>
    if (LOG_FLAG == 5) {
      if (tail == log.lh.n/2) panic("[UNDOLOG] Panic in install_trans type 5");
    }
    // struct buf *lbuf = bread(log.dev, log.start+tail+1); // log block would now contain the undo data
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // so we directly read dst and write into disk
  103c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c17:	83 c0 04             	add    $0x4,%eax
  103c1a:	8b 04 85 24 f4 10 00 	mov    0x10f424(,%eax,4),%eax
  103c21:	89 c2                	mov    %eax,%edx
  103c23:	a1 2c f4 10 00       	mov    0x10f42c,%eax
  103c28:	83 ec 08             	sub    $0x8,%esp
  103c2b:	52                   	push   %edx
  103c2c:	50                   	push   %eax
  103c2d:	e8 71 e3 ff ff       	call   101fa3 <bread>
  103c32:	83 c4 10             	add    $0x10,%esp
  103c35:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // memmove(dbuf->data, lbuf->data, BSIZE);  // no need to copy from log to dst
    bwrite(dbuf);  // write dst to disk
  103c38:	83 ec 0c             	sub    $0xc,%esp
  103c3b:	ff 75 f0             	push   -0x10(%ebp)
  103c3e:	e8 99 e3 ff ff       	call   101fdc <bwrite>
  103c43:	83 c4 10             	add    $0x10,%esp
    // brelse(lbuf);
    brelse(dbuf);
  103c46:	83 ec 0c             	sub    $0xc,%esp
  103c49:	ff 75 f0             	push   -0x10(%ebp)
  103c4c:	e8 0a e4 ff ff       	call   10205b <brelse>
  103c51:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
  103c54:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103c58:	a1 30 f4 10 00       	mov    0x10f430,%eax
  103c5d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103c60:	7c b2                	jl     103c14 <install_trans+0xf>
  }
}
  103c62:	90                   	nop
  103c63:	90                   	nop
  103c64:	c9                   	leave  
  103c65:	c3                   	ret    

00103c66 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  103c66:	55                   	push   %ebp
  103c67:	89 e5                	mov    %esp,%ebp
  103c69:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
  103c6c:	a1 20 f4 10 00       	mov    0x10f420,%eax
  103c71:	89 c2                	mov    %eax,%edx
  103c73:	a1 2c f4 10 00       	mov    0x10f42c,%eax
  103c78:	83 ec 08             	sub    $0x8,%esp
  103c7b:	52                   	push   %edx
  103c7c:	50                   	push   %eax
  103c7d:	e8 21 e3 ff ff       	call   101fa3 <bread>
  103c82:	83 c4 10             	add    $0x10,%esp
  103c85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
  103c88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c8b:	83 c0 1c             	add    $0x1c,%eax
  103c8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
  103c91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103c94:	8b 00                	mov    (%eax),%eax
  103c96:	a3 30 f4 10 00       	mov    %eax,0x10f430
  for (i = 0; i < log.lh.n; i++) {
  103c9b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103ca2:	eb 1b                	jmp    103cbf <read_head+0x59>
    log.lh.block[i] = lh->block[i];
  103ca4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103ca7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103caa:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
  103cae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103cb1:	83 c2 04             	add    $0x4,%edx
  103cb4:	89 04 95 24 f4 10 00 	mov    %eax,0x10f424(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
  103cbb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103cbf:	a1 30 f4 10 00       	mov    0x10f430,%eax
  103cc4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103cc7:	7c db                	jl     103ca4 <read_head+0x3e>
  }
  brelse(buf);
  103cc9:	83 ec 0c             	sub    $0xc,%esp
  103ccc:	ff 75 f0             	push   -0x10(%ebp)
  103ccf:	e8 87 e3 ff ff       	call   10205b <brelse>
  103cd4:	83 c4 10             	add    $0x10,%esp
}
  103cd7:	90                   	nop
  103cd8:	c9                   	leave  
  103cd9:	c3                   	ret    

00103cda <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  103cda:	55                   	push   %ebp
  103cdb:	89 e5                	mov    %esp,%ebp
  103cdd:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
  103ce0:	a1 20 f4 10 00       	mov    0x10f420,%eax
  103ce5:	89 c2                	mov    %eax,%edx
  103ce7:	a1 2c f4 10 00       	mov    0x10f42c,%eax
  103cec:	83 ec 08             	sub    $0x8,%esp
  103cef:	52                   	push   %edx
  103cf0:	50                   	push   %eax
  103cf1:	e8 ad e2 ff ff       	call   101fa3 <bread>
  103cf6:	83 c4 10             	add    $0x10,%esp
  103cf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
  103cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103cff:	83 c0 1c             	add    $0x1c,%eax
  103d02:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
  103d05:	8b 15 30 f4 10 00    	mov    0x10f430,%edx
  103d0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103d0e:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
  103d10:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103d17:	eb 1b                	jmp    103d34 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
  103d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d1c:	83 c0 04             	add    $0x4,%eax
  103d1f:	8b 0c 85 24 f4 10 00 	mov    0x10f424(,%eax,4),%ecx
  103d26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103d29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103d2c:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
  103d30:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103d34:	a1 30 f4 10 00       	mov    0x10f430,%eax
  103d39:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103d3c:	7c db                	jl     103d19 <write_head+0x3f>
  }
  bwrite(buf);
  103d3e:	83 ec 0c             	sub    $0xc,%esp
  103d41:	ff 75 f0             	push   -0x10(%ebp)
  103d44:	e8 93 e2 ff ff       	call   101fdc <bwrite>
  103d49:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
  103d4c:	83 ec 0c             	sub    $0xc,%esp
  103d4f:	ff 75 f0             	push   -0x10(%ebp)
  103d52:	e8 04 e3 ff ff       	call   10205b <brelse>
  103d57:	83 c4 10             	add    $0x10,%esp
}
  103d5a:	90                   	nop
  103d5b:	c9                   	leave  
  103d5c:	c3                   	ret    

00103d5d <recover_trans>:

static void
recover_trans(void)
{
  103d5d:	55                   	push   %ebp
  103d5e:	89 e5                	mov    %esp,%ebp
  103d60:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
  103d63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103d6a:	e9 95 00 00 00       	jmp    103e04 <recover_trans+0xa7>
    if (LOG_FLAG == 5) {
      if (tail == log.lh.n/2) panic("[UNDOLOG] Panic in install_trans type 5");
    }
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
  103d6f:	8b 15 20 f4 10 00    	mov    0x10f420,%edx
  103d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d78:	01 d0                	add    %edx,%eax
  103d7a:	83 c0 01             	add    $0x1,%eax
  103d7d:	89 c2                	mov    %eax,%edx
  103d7f:	a1 2c f4 10 00       	mov    0x10f42c,%eax
  103d84:	83 ec 08             	sub    $0x8,%esp
  103d87:	52                   	push   %edx
  103d88:	50                   	push   %eax
  103d89:	e8 15 e2 ff ff       	call   101fa3 <bread>
  103d8e:	83 c4 10             	add    $0x10,%esp
  103d91:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
  103d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d97:	83 c0 04             	add    $0x4,%eax
  103d9a:	8b 04 85 24 f4 10 00 	mov    0x10f424(,%eax,4),%eax
  103da1:	89 c2                	mov    %eax,%edx
  103da3:	a1 2c f4 10 00       	mov    0x10f42c,%eax
  103da8:	83 ec 08             	sub    $0x8,%esp
  103dab:	52                   	push   %edx
  103dac:	50                   	push   %eax
  103dad:	e8 f1 e1 ff ff       	call   101fa3 <bread>
  103db2:	83 c4 10             	add    $0x10,%esp
  103db5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
  103db8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103dbb:	8d 50 1c             	lea    0x1c(%eax),%edx
  103dbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103dc1:	83 c0 1c             	add    $0x1c,%eax
  103dc4:	83 ec 04             	sub    $0x4,%esp
  103dc7:	68 00 02 00 00       	push   $0x200
  103dcc:	52                   	push   %edx
  103dcd:	50                   	push   %eax
  103dce:	e8 93 d1 ff ff       	call   100f66 <memmove>
  103dd3:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
  103dd6:	83 ec 0c             	sub    $0xc,%esp
  103dd9:	ff 75 ec             	push   -0x14(%ebp)
  103ddc:	e8 fb e1 ff ff       	call   101fdc <bwrite>
  103de1:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf);
  103de4:	83 ec 0c             	sub    $0xc,%esp
  103de7:	ff 75 f0             	push   -0x10(%ebp)
  103dea:	e8 6c e2 ff ff       	call   10205b <brelse>
  103def:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
  103df2:	83 ec 0c             	sub    $0xc,%esp
  103df5:	ff 75 ec             	push   -0x14(%ebp)
  103df8:	e8 5e e2 ff ff       	call   10205b <brelse>
  103dfd:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
  103e00:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103e04:	a1 30 f4 10 00       	mov    0x10f430,%eax
  103e09:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103e0c:	0f 8c 5d ff ff ff    	jl     103d6f <recover_trans+0x12>
  }
}
  103e12:	90                   	nop
  103e13:	90                   	nop
  103e14:	c9                   	leave  
  103e15:	c3                   	ret    

00103e16 <recover_from_log>:

static void
recover_from_log(void)
{
  103e16:	55                   	push   %ebp
  103e17:	89 e5                	mov    %esp,%ebp
  103e19:	83 ec 08             	sub    $0x8,%esp
  read_head();
  103e1c:	e8 45 fe ff ff       	call   103c66 <read_head>
  recover_trans(); // if committed, copy from log to disk
  103e21:	e8 37 ff ff ff       	call   103d5d <recover_trans>
  log.lh.n = 0;
  103e26:	c7 05 30 f4 10 00 00 	movl   $0x0,0x10f430
  103e2d:	00 00 00 
  write_head(); // clear the log
  103e30:	e8 a5 fe ff ff       	call   103cda <write_head>
}
  103e35:	90                   	nop
  103e36:	c9                   	leave  
  103e37:	c3                   	ret    

00103e38 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
  103e38:	55                   	push   %ebp
  103e39:	89 e5                	mov    %esp,%ebp
  
}
  103e3b:	90                   	nop
  103e3c:	5d                   	pop    %ebp
  103e3d:	c3                   	ret    

00103e3e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
  103e3e:	55                   	push   %ebp
  103e3f:	89 e5                	mov    %esp,%ebp
  103e41:	83 ec 08             	sub    $0x8,%esp
  // call commit w/o holding locks, since not allowed
  // to sleep with locks.
  commit();
  103e44:	e8 a0 00 00 00       	call   103ee9 <commit>
}
  103e49:	90                   	nop
  103e4a:	c9                   	leave  
  103e4b:	c3                   	ret    

00103e4c <write_log>:

// Copy modified blocks from cache to log.
//~ Since, we are eagerly writing back to log, we can just specify which specific block to write
static void
write_log(int i)
{
  103e4c:	55                   	push   %ebp
  103e4d:	89 e5                	mov    %esp,%ebp
  103e4f:	83 ec 18             	sub    $0x18,%esp
  struct buf *to = bread(log.dev, log.start+i+1); // log block
  103e52:	8b 15 20 f4 10 00    	mov    0x10f420,%edx
  103e58:	8b 45 08             	mov    0x8(%ebp),%eax
  103e5b:	01 d0                	add    %edx,%eax
  103e5d:	83 c0 01             	add    $0x1,%eax
  103e60:	89 c2                	mov    %eax,%edx
  103e62:	a1 2c f4 10 00       	mov    0x10f42c,%eax
  103e67:	83 ec 08             	sub    $0x8,%esp
  103e6a:	52                   	push   %edx
  103e6b:	50                   	push   %eax
  103e6c:	e8 32 e1 ff ff       	call   101fa3 <bread>
  103e71:	83 c4 10             	add    $0x10,%esp
  103e74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct buf *from = bread(log.dev, log.lh.block[i]); // cache block
  103e77:	8b 45 08             	mov    0x8(%ebp),%eax
  103e7a:	83 c0 04             	add    $0x4,%eax
  103e7d:	8b 04 85 24 f4 10 00 	mov    0x10f424(,%eax,4),%eax
  103e84:	89 c2                	mov    %eax,%edx
  103e86:	a1 2c f4 10 00       	mov    0x10f42c,%eax
  103e8b:	83 ec 08             	sub    $0x8,%esp
  103e8e:	52                   	push   %edx
  103e8f:	50                   	push   %eax
  103e90:	e8 0e e1 ff ff       	call   101fa3 <bread>
  103e95:	83 c4 10             	add    $0x10,%esp
  103e98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(to->data, from->old_data, BSIZE);
  103e9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e9e:	8d 90 1c 02 00 00    	lea    0x21c(%eax),%edx
  103ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ea7:	83 c0 1c             	add    $0x1c,%eax
  103eaa:	83 ec 04             	sub    $0x4,%esp
  103ead:	68 00 02 00 00       	push   $0x200
  103eb2:	52                   	push   %edx
  103eb3:	50                   	push   %eax
  103eb4:	e8 ad d0 ff ff       	call   100f66 <memmove>
  103eb9:	83 c4 10             	add    $0x10,%esp
  bwrite(to);  // write the log
  103ebc:	83 ec 0c             	sub    $0xc,%esp
  103ebf:	ff 75 f4             	push   -0xc(%ebp)
  103ec2:	e8 15 e1 ff ff       	call   101fdc <bwrite>
  103ec7:	83 c4 10             	add    $0x10,%esp
  brelse(from);
  103eca:	83 ec 0c             	sub    $0xc,%esp
  103ecd:	ff 75 f0             	push   -0x10(%ebp)
  103ed0:	e8 86 e1 ff ff       	call   10205b <brelse>
  103ed5:	83 c4 10             	add    $0x10,%esp
  brelse(to);
  103ed8:	83 ec 0c             	sub    $0xc,%esp
  103edb:	ff 75 f4             	push   -0xc(%ebp)
  103ede:	e8 78 e1 ff ff       	call   10205b <brelse>
  103ee3:	83 c4 10             	add    $0x10,%esp
}
  103ee6:	90                   	nop
  103ee7:	c9                   	leave  
  103ee8:	c3                   	ret    

00103ee9 <commit>:

/* DO NOT MODIFY THIS FUNCTION*/
static void
commit()
{
  103ee9:	55                   	push   %ebp
  103eea:	89 e5                	mov    %esp,%ebp
  103eec:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
  103eef:	a1 30 f4 10 00       	mov    0x10f430,%eax
  103ef4:	85 c0                	test   %eax,%eax
  103ef6:	7e 19                	jle    103f11 <commit+0x28>
    if (PANIC_1) {
      panic("[UNDOLOG] Panic in commit type 1");
    }
    write_head();    // Write header to disk 
  103ef8:	e8 dd fd ff ff       	call   103cda <write_head>
    if (PANIC_2) {
      panic("[UNDOLOG] Panic in commit type 2");
    }
    install_trans(); // Now install writes to home locations    
  103efd:	e8 03 fd ff ff       	call   103c05 <install_trans>
    if (PANIC_3) {
      panic("[UNDOLOG] Panic in commit type 3");
    }
    log.lh.n = 0;
  103f02:	c7 05 30 f4 10 00 00 	movl   $0x0,0x10f430
  103f09:	00 00 00 
    write_head();    // Erase the transaction from the log 
  103f0c:	e8 c9 fd ff ff       	call   103cda <write_head>
    if (PANIC_4) {
      panic("[UNDOLOG] Panic in commit type 4");
    }  
  }
}
  103f11:	90                   	nop
  103f12:	c9                   	leave  
  103f13:	c3                   	ret    

00103f14 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
  103f14:	55                   	push   %ebp
  103f15:	89 e5                	mov    %esp,%ebp
  103f17:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
  103f1a:	a1 30 f4 10 00       	mov    0x10f430,%eax
  103f1f:	83 f8 1d             	cmp    $0x1d,%eax
  103f22:	7f 12                	jg     103f36 <log_write+0x22>
  103f24:	a1 30 f4 10 00       	mov    0x10f430,%eax
  103f29:	8b 15 24 f4 10 00    	mov    0x10f424,%edx
  103f2f:	83 ea 01             	sub    $0x1,%edx
  103f32:	39 d0                	cmp    %edx,%eax
  103f34:	7c 0d                	jl     103f43 <log_write+0x2f>
    panic("too big a transaction");
  103f36:	83 ec 0c             	sub    $0xc,%esp
  103f39:	68 f3 43 10 00       	push   $0x1043f3
  103f3e:	e8 6a c3 ff ff       	call   1002ad <panic>

  for (i = 0; i < log.lh.n; i++) {
  103f43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103f4a:	eb 1d                	jmp    103f69 <log_write+0x55>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
  103f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f4f:	83 c0 04             	add    $0x4,%eax
  103f52:	8b 04 85 24 f4 10 00 	mov    0x10f424(,%eax,4),%eax
  103f59:	89 c2                	mov    %eax,%edx
  103f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  103f5e:	8b 40 08             	mov    0x8(%eax),%eax
  103f61:	39 c2                	cmp    %eax,%edx
  103f63:	74 10                	je     103f75 <log_write+0x61>
  for (i = 0; i < log.lh.n; i++) {
  103f65:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103f69:	a1 30 f4 10 00       	mov    0x10f430,%eax
  103f6e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103f71:	7c d9                	jl     103f4c <log_write+0x38>
  103f73:	eb 01                	jmp    103f76 <log_write+0x62>
      break;
  103f75:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
  103f76:	8b 45 08             	mov    0x8(%ebp),%eax
  103f79:	8b 40 08             	mov    0x8(%eax),%eax
  103f7c:	89 c2                	mov    %eax,%edx
  103f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f81:	83 c0 04             	add    $0x4,%eax
  103f84:	89 14 85 24 f4 10 00 	mov    %edx,0x10f424(,%eax,4)
  if (i == log.lh.n)
  103f8b:	a1 30 f4 10 00       	mov    0x10f430,%eax
  103f90:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103f93:	75 0d                	jne    103fa2 <log_write+0x8e>
    log.lh.n++;
  103f95:	a1 30 f4 10 00       	mov    0x10f430,%eax
  103f9a:	83 c0 01             	add    $0x1,%eax
  103f9d:	a3 30 f4 10 00       	mov    %eax,0x10f430
  b->flags |= B_DIRTY; // prevent eviction
  103fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  103fa5:	8b 00                	mov    (%eax),%eax
  103fa7:	83 c8 04             	or     $0x4,%eax
  103faa:	89 c2                	mov    %eax,%edx
  103fac:	8b 45 08             	mov    0x8(%ebp),%eax
  103faf:	89 10                	mov    %edx,(%eax)

  write_log(i); //~ Writing eagerly to the log
  103fb1:	83 ec 0c             	sub    $0xc,%esp
  103fb4:	ff 75 f4             	push   -0xc(%ebp)
  103fb7:	e8 90 fe ff ff       	call   103e4c <write_log>
  103fbc:	83 c4 10             	add    $0x10,%esp
  103fbf:	90                   	nop
  103fc0:	c9                   	leave  
  103fc1:	c3                   	ret    
