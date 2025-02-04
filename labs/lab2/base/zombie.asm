
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 55 02 00 00       	call   26b <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7e 0d                	jle    27 <main+0x27>
    sleep(5);  // Let child exit before parent.
  1a:	83 ec 0c             	sub    $0xc,%esp
  1d:	6a 05                	push   $0x5
  1f:	e8 df 02 00 00       	call   303 <sleep>
  24:	83 c4 10             	add    $0x10,%esp
  exit();
  27:	e8 47 02 00 00       	call   273 <exit>
  2c:	66 90                	xchg   %ax,%ax
  2e:	66 90                	xchg   %ax,%ax

00000030 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  30:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  31:	31 c0                	xor    %eax,%eax
{
  33:	89 e5                	mov    %esp,%ebp
  35:	53                   	push   %ebx
  36:	8b 4d 08             	mov    0x8(%ebp),%ecx
  39:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  40:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  44:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  47:	83 c0 01             	add    $0x1,%eax
  4a:	84 d2                	test   %dl,%dl
  4c:	75 f2                	jne    40 <strcpy+0x10>
    ;
  return os;
}
  4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  51:	89 c8                	mov    %ecx,%eax
  53:	c9                   	leave
  54:	c3                   	ret
  55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000060 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	53                   	push   %ebx
  64:	8b 55 08             	mov    0x8(%ebp),%edx
  67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  6a:	0f b6 02             	movzbl (%edx),%eax
  6d:	84 c0                	test   %al,%al
  6f:	75 17                	jne    88 <strcmp+0x28>
  71:	eb 3a                	jmp    ad <strcmp+0x4d>
  73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  77:	90                   	nop
  78:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  7c:	83 c2 01             	add    $0x1,%edx
  7f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
  82:	84 c0                	test   %al,%al
  84:	74 1a                	je     a0 <strcmp+0x40>
    p++, q++;
  86:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
  88:	0f b6 19             	movzbl (%ecx),%ebx
  8b:	38 c3                	cmp    %al,%bl
  8d:	74 e9                	je     78 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  8f:	29 d8                	sub    %ebx,%eax
}
  91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  94:	c9                   	leave
  95:	c3                   	ret
  96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  9d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
  a0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  a4:	31 c0                	xor    %eax,%eax
  a6:	29 d8                	sub    %ebx,%eax
}
  a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  ab:	c9                   	leave
  ac:	c3                   	ret
  return (uchar)*p - (uchar)*q;
  ad:	0f b6 19             	movzbl (%ecx),%ebx
  b0:	31 c0                	xor    %eax,%eax
  b2:	eb db                	jmp    8f <strcmp+0x2f>
  b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bf:	90                   	nop

000000c0 <strlen>:

uint
strlen(char *s)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  c6:	80 3a 00             	cmpb   $0x0,(%edx)
  c9:	74 15                	je     e0 <strlen+0x20>
  cb:	31 c0                	xor    %eax,%eax
  cd:	8d 76 00             	lea    0x0(%esi),%esi
  d0:	83 c0 01             	add    $0x1,%eax
  d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  d7:	89 c1                	mov    %eax,%ecx
  d9:	75 f5                	jne    d0 <strlen+0x10>
    ;
  return n;
}
  db:	89 c8                	mov    %ecx,%eax
  dd:	5d                   	pop    %ebp
  de:	c3                   	ret
  df:	90                   	nop
  for(n = 0; s[n]; n++)
  e0:	31 c9                	xor    %ecx,%ecx
}
  e2:	5d                   	pop    %ebp
  e3:	89 c8                	mov    %ecx,%eax
  e5:	c3                   	ret
  e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ed:	8d 76 00             	lea    0x0(%esi),%esi

000000f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	57                   	push   %edi
  f4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	89 d7                	mov    %edx,%edi
  ff:	fc                   	cld
 100:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 102:	8b 7d fc             	mov    -0x4(%ebp),%edi
 105:	89 d0                	mov    %edx,%eax
 107:	c9                   	leave
 108:	c3                   	ret
 109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000110 <strchr>:

char*
strchr(const char *s, char c)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	8b 45 08             	mov    0x8(%ebp),%eax
 116:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 11a:	0f b6 10             	movzbl (%eax),%edx
 11d:	84 d2                	test   %dl,%dl
 11f:	75 12                	jne    133 <strchr+0x23>
 121:	eb 1d                	jmp    140 <strchr+0x30>
 123:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 127:	90                   	nop
 128:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 12c:	83 c0 01             	add    $0x1,%eax
 12f:	84 d2                	test   %dl,%dl
 131:	74 0d                	je     140 <strchr+0x30>
    if(*s == c)
 133:	38 d1                	cmp    %dl,%cl
 135:	75 f1                	jne    128 <strchr+0x18>
      return (char*)s;
  return 0;
}
 137:	5d                   	pop    %ebp
 138:	c3                   	ret
 139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 140:	31 c0                	xor    %eax,%eax
}
 142:	5d                   	pop    %ebp
 143:	c3                   	ret
 144:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 14b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 14f:	90                   	nop

00000150 <gets>:

char*
gets(char *buf, int max)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	57                   	push   %edi
 154:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 155:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 158:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 159:	31 db                	xor    %ebx,%ebx
{
 15b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 15e:	eb 27                	jmp    187 <gets+0x37>
    cc = read(0, &c, 1);
 160:	83 ec 04             	sub    $0x4,%esp
 163:	6a 01                	push   $0x1
 165:	56                   	push   %esi
 166:	6a 00                	push   $0x0
 168:	e8 1e 01 00 00       	call   28b <read>
    if(cc < 1)
 16d:	83 c4 10             	add    $0x10,%esp
 170:	85 c0                	test   %eax,%eax
 172:	7e 1d                	jle    191 <gets+0x41>
      break;
    buf[i++] = c;
 174:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 178:	8b 55 08             	mov    0x8(%ebp),%edx
 17b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 17f:	3c 0a                	cmp    $0xa,%al
 181:	74 10                	je     193 <gets+0x43>
 183:	3c 0d                	cmp    $0xd,%al
 185:	74 0c                	je     193 <gets+0x43>
  for(i=0; i+1 < max; ){
 187:	89 df                	mov    %ebx,%edi
 189:	83 c3 01             	add    $0x1,%ebx
 18c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 18f:	7c cf                	jl     160 <gets+0x10>
 191:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 19a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 19d:	5b                   	pop    %ebx
 19e:	5e                   	pop    %esi
 19f:	5f                   	pop    %edi
 1a0:	5d                   	pop    %ebp
 1a1:	c3                   	ret
 1a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001b0 <stat>:

int
stat(char *n, struct stat *st)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	56                   	push   %esi
 1b4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b5:	83 ec 08             	sub    $0x8,%esp
 1b8:	6a 00                	push   $0x0
 1ba:	ff 75 08             	push   0x8(%ebp)
 1bd:	e8 f1 00 00 00       	call   2b3 <open>
  if(fd < 0)
 1c2:	83 c4 10             	add    $0x10,%esp
 1c5:	85 c0                	test   %eax,%eax
 1c7:	78 27                	js     1f0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 1c9:	83 ec 08             	sub    $0x8,%esp
 1cc:	ff 75 0c             	push   0xc(%ebp)
 1cf:	89 c3                	mov    %eax,%ebx
 1d1:	50                   	push   %eax
 1d2:	e8 f4 00 00 00       	call   2cb <fstat>
  close(fd);
 1d7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 1da:	89 c6                	mov    %eax,%esi
  close(fd);
 1dc:	e8 ba 00 00 00       	call   29b <close>
  return r;
 1e1:	83 c4 10             	add    $0x10,%esp
}
 1e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1e7:	89 f0                	mov    %esi,%eax
 1e9:	5b                   	pop    %ebx
 1ea:	5e                   	pop    %esi
 1eb:	5d                   	pop    %ebp
 1ec:	c3                   	ret
 1ed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 1f0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1f5:	eb ed                	jmp    1e4 <stat+0x34>
 1f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1fe:	66 90                	xchg   %ax,%ax

00000200 <atoi>:

int
atoi(const char *s)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	53                   	push   %ebx
 204:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 207:	0f be 02             	movsbl (%edx),%eax
 20a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 20d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 210:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 215:	77 1e                	ja     235 <atoi+0x35>
 217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 21e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 220:	83 c2 01             	add    $0x1,%edx
 223:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 226:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 22a:	0f be 02             	movsbl (%edx),%eax
 22d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 230:	80 fb 09             	cmp    $0x9,%bl
 233:	76 eb                	jbe    220 <atoi+0x20>
  return n;
}
 235:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 238:	89 c8                	mov    %ecx,%eax
 23a:	c9                   	leave
 23b:	c3                   	ret
 23c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000240 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	57                   	push   %edi
 244:	56                   	push   %esi
 245:	8b 45 10             	mov    0x10(%ebp),%eax
 248:	8b 55 08             	mov    0x8(%ebp),%edx
 24b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 24e:	85 c0                	test   %eax,%eax
 250:	7e 13                	jle    265 <memmove+0x25>
 252:	01 d0                	add    %edx,%eax
  dst = vdst;
 254:	89 d7                	mov    %edx,%edi
 256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 25d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 260:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 261:	39 f8                	cmp    %edi,%eax
 263:	75 fb                	jne    260 <memmove+0x20>
  return vdst;
}
 265:	5e                   	pop    %esi
 266:	89 d0                	mov    %edx,%eax
 268:	5f                   	pop    %edi
 269:	5d                   	pop    %ebp
 26a:	c3                   	ret

0000026b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 26b:	b8 01 00 00 00       	mov    $0x1,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret

00000273 <exit>:
SYSCALL(exit)
 273:	b8 02 00 00 00       	mov    $0x2,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret

0000027b <wait>:
SYSCALL(wait)
 27b:	b8 03 00 00 00       	mov    $0x3,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret

00000283 <pipe>:
SYSCALL(pipe)
 283:	b8 04 00 00 00       	mov    $0x4,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret

0000028b <read>:
SYSCALL(read)
 28b:	b8 05 00 00 00       	mov    $0x5,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret

00000293 <write>:
SYSCALL(write)
 293:	b8 10 00 00 00       	mov    $0x10,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret

0000029b <close>:
SYSCALL(close)
 29b:	b8 15 00 00 00       	mov    $0x15,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret

000002a3 <kill>:
SYSCALL(kill)
 2a3:	b8 06 00 00 00       	mov    $0x6,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret

000002ab <exec>:
SYSCALL(exec)
 2ab:	b8 07 00 00 00       	mov    $0x7,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret

000002b3 <open>:
SYSCALL(open)
 2b3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret

000002bb <mknod>:
SYSCALL(mknod)
 2bb:	b8 11 00 00 00       	mov    $0x11,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret

000002c3 <unlink>:
SYSCALL(unlink)
 2c3:	b8 12 00 00 00       	mov    $0x12,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret

000002cb <fstat>:
SYSCALL(fstat)
 2cb:	b8 08 00 00 00       	mov    $0x8,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret

000002d3 <link>:
SYSCALL(link)
 2d3:	b8 13 00 00 00       	mov    $0x13,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret

000002db <mkdir>:
SYSCALL(mkdir)
 2db:	b8 14 00 00 00       	mov    $0x14,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret

000002e3 <chdir>:
SYSCALL(chdir)
 2e3:	b8 09 00 00 00       	mov    $0x9,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret

000002eb <dup>:
SYSCALL(dup)
 2eb:	b8 0a 00 00 00       	mov    $0xa,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret

000002f3 <getpid>:
SYSCALL(getpid)
 2f3:	b8 0b 00 00 00       	mov    $0xb,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret

000002fb <sbrk>:
SYSCALL(sbrk)
 2fb:	b8 0c 00 00 00       	mov    $0xc,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret

00000303 <sleep>:
SYSCALL(sleep)
 303:	b8 0d 00 00 00       	mov    $0xd,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret

0000030b <uptime>:
SYSCALL(uptime)
 30b:	b8 0e 00 00 00       	mov    $0xe,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret
 313:	66 90                	xchg   %ax,%ax
 315:	66 90                	xchg   %ax,%ax
 317:	66 90                	xchg   %ax,%ax
 319:	66 90                	xchg   %ax,%ax
 31b:	66 90                	xchg   %ax,%ax
 31d:	66 90                	xchg   %ax,%ax
 31f:	90                   	nop

00000320 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	57                   	push   %edi
 324:	56                   	push   %esi
 325:	53                   	push   %ebx
 326:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 328:	89 d1                	mov    %edx,%ecx
{
 32a:	83 ec 3c             	sub    $0x3c,%esp
 32d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 330:	85 d2                	test   %edx,%edx
 332:	0f 89 80 00 00 00    	jns    3b8 <printint+0x98>
 338:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 33c:	74 7a                	je     3b8 <printint+0x98>
    x = -xx;
 33e:	f7 d9                	neg    %ecx
    neg = 1;
 340:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 345:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 348:	31 f6                	xor    %esi,%esi
 34a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 350:	89 c8                	mov    %ecx,%eax
 352:	31 d2                	xor    %edx,%edx
 354:	89 f7                	mov    %esi,%edi
 356:	f7 f3                	div    %ebx
 358:	8d 76 01             	lea    0x1(%esi),%esi
 35b:	0f b6 92 48 07 00 00 	movzbl 0x748(%edx),%edx
 362:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 366:	89 ca                	mov    %ecx,%edx
 368:	89 c1                	mov    %eax,%ecx
 36a:	39 da                	cmp    %ebx,%edx
 36c:	73 e2                	jae    350 <printint+0x30>
  if(neg)
 36e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 371:	85 c0                	test   %eax,%eax
 373:	74 07                	je     37c <printint+0x5c>
    buf[i++] = '-';
 375:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
    buf[i++] = digits[x % base];
 37a:	89 f7                	mov    %esi,%edi
 37c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 37f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 382:	01 df                	add    %ebx,%edi
 384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  while(--i >= 0)
    putc(fd, buf[i]);
 388:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 38b:	83 ec 04             	sub    $0x4,%esp
 38e:	88 45 d7             	mov    %al,-0x29(%ebp)
 391:	8d 45 d7             	lea    -0x29(%ebp),%eax
 394:	6a 01                	push   $0x1
 396:	50                   	push   %eax
 397:	56                   	push   %esi
 398:	e8 f6 fe ff ff       	call   293 <write>
  while(--i >= 0)
 39d:	89 f8                	mov    %edi,%eax
 39f:	83 c4 10             	add    $0x10,%esp
 3a2:	83 ef 01             	sub    $0x1,%edi
 3a5:	39 d8                	cmp    %ebx,%eax
 3a7:	75 df                	jne    388 <printint+0x68>
}
 3a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ac:	5b                   	pop    %ebx
 3ad:	5e                   	pop    %esi
 3ae:	5f                   	pop    %edi
 3af:	5d                   	pop    %ebp
 3b0:	c3                   	ret
 3b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 3b8:	31 c0                	xor    %eax,%eax
 3ba:	eb 89                	jmp    345 <printint+0x25>
 3bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003c0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	57                   	push   %edi
 3c4:	56                   	push   %esi
 3c5:	53                   	push   %ebx
 3c6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3c9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 3cc:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 3cf:	0f b6 1e             	movzbl (%esi),%ebx
 3d2:	83 c6 01             	add    $0x1,%esi
 3d5:	84 db                	test   %bl,%bl
 3d7:	74 67                	je     440 <printf+0x80>
 3d9:	8d 4d 10             	lea    0x10(%ebp),%ecx
 3dc:	31 d2                	xor    %edx,%edx
 3de:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 3e1:	eb 34                	jmp    417 <printf+0x57>
 3e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3e7:	90                   	nop
 3e8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 3eb:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 3f0:	83 f8 25             	cmp    $0x25,%eax
 3f3:	74 18                	je     40d <printf+0x4d>
  write(fd, &c, 1);
 3f5:	83 ec 04             	sub    $0x4,%esp
 3f8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3fb:	88 5d e7             	mov    %bl,-0x19(%ebp)
 3fe:	6a 01                	push   $0x1
 400:	50                   	push   %eax
 401:	57                   	push   %edi
 402:	e8 8c fe ff ff       	call   293 <write>
 407:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 40a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 40d:	0f b6 1e             	movzbl (%esi),%ebx
 410:	83 c6 01             	add    $0x1,%esi
 413:	84 db                	test   %bl,%bl
 415:	74 29                	je     440 <printf+0x80>
    c = fmt[i] & 0xff;
 417:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 41a:	85 d2                	test   %edx,%edx
 41c:	74 ca                	je     3e8 <printf+0x28>
      }
    } else if(state == '%'){
 41e:	83 fa 25             	cmp    $0x25,%edx
 421:	75 ea                	jne    40d <printf+0x4d>
      if(c == 'd'){
 423:	83 f8 25             	cmp    $0x25,%eax
 426:	0f 84 24 01 00 00    	je     550 <printf+0x190>
 42c:	83 e8 63             	sub    $0x63,%eax
 42f:	83 f8 15             	cmp    $0x15,%eax
 432:	77 1c                	ja     450 <printf+0x90>
 434:	ff 24 85 f0 06 00 00 	jmp    *0x6f0(,%eax,4)
 43b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 43f:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 440:	8d 65 f4             	lea    -0xc(%ebp),%esp
 443:	5b                   	pop    %ebx
 444:	5e                   	pop    %esi
 445:	5f                   	pop    %edi
 446:	5d                   	pop    %ebp
 447:	c3                   	ret
 448:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 44f:	90                   	nop
  write(fd, &c, 1);
 450:	83 ec 04             	sub    $0x4,%esp
 453:	8d 55 e7             	lea    -0x19(%ebp),%edx
 456:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 45a:	6a 01                	push   $0x1
 45c:	52                   	push   %edx
 45d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 460:	57                   	push   %edi
 461:	e8 2d fe ff ff       	call   293 <write>
 466:	83 c4 0c             	add    $0xc,%esp
 469:	88 5d e7             	mov    %bl,-0x19(%ebp)
 46c:	6a 01                	push   $0x1
 46e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 471:	52                   	push   %edx
 472:	57                   	push   %edi
 473:	e8 1b fe ff ff       	call   293 <write>
        putc(fd, c);
 478:	83 c4 10             	add    $0x10,%esp
      state = 0;
 47b:	31 d2                	xor    %edx,%edx
 47d:	eb 8e                	jmp    40d <printf+0x4d>
 47f:	90                   	nop
        printint(fd, *ap, 16, 0);
 480:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 483:	83 ec 0c             	sub    $0xc,%esp
 486:	b9 10 00 00 00       	mov    $0x10,%ecx
 48b:	8b 13                	mov    (%ebx),%edx
 48d:	6a 00                	push   $0x0
 48f:	89 f8                	mov    %edi,%eax
        ap++;
 491:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 494:	e8 87 fe ff ff       	call   320 <printint>
        ap++;
 499:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 49c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 49f:	31 d2                	xor    %edx,%edx
 4a1:	e9 67 ff ff ff       	jmp    40d <printf+0x4d>
 4a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ad:	8d 76 00             	lea    0x0(%esi),%esi
        s = (char*)*ap;
 4b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 4b3:	8b 18                	mov    (%eax),%ebx
        ap++;
 4b5:	83 c0 04             	add    $0x4,%eax
 4b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 4bb:	85 db                	test   %ebx,%ebx
 4bd:	0f 84 9d 00 00 00    	je     560 <printf+0x1a0>
        while(*s != 0){
 4c3:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 4c6:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 4c8:	84 c0                	test   %al,%al
 4ca:	0f 84 3d ff ff ff    	je     40d <printf+0x4d>
 4d0:	8d 55 e7             	lea    -0x19(%ebp),%edx
 4d3:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 4d6:	89 de                	mov    %ebx,%esi
 4d8:	89 d3                	mov    %edx,%ebx
 4da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 4e0:	83 ec 04             	sub    $0x4,%esp
 4e3:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 4e6:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 4e9:	6a 01                	push   $0x1
 4eb:	53                   	push   %ebx
 4ec:	57                   	push   %edi
 4ed:	e8 a1 fd ff ff       	call   293 <write>
        while(*s != 0){
 4f2:	0f b6 06             	movzbl (%esi),%eax
 4f5:	83 c4 10             	add    $0x10,%esp
 4f8:	84 c0                	test   %al,%al
 4fa:	75 e4                	jne    4e0 <printf+0x120>
      state = 0;
 4fc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 4ff:	31 d2                	xor    %edx,%edx
 501:	e9 07 ff ff ff       	jmp    40d <printf+0x4d>
 506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 50d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 510:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 513:	83 ec 0c             	sub    $0xc,%esp
 516:	b9 0a 00 00 00       	mov    $0xa,%ecx
 51b:	8b 13                	mov    (%ebx),%edx
 51d:	6a 01                	push   $0x1
 51f:	e9 6b ff ff ff       	jmp    48f <printf+0xcf>
 524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 528:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 52b:	83 ec 04             	sub    $0x4,%esp
 52e:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 531:	8b 03                	mov    (%ebx),%eax
        ap++;
 533:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 536:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 539:	6a 01                	push   $0x1
 53b:	52                   	push   %edx
 53c:	57                   	push   %edi
 53d:	e8 51 fd ff ff       	call   293 <write>
        ap++;
 542:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 545:	83 c4 10             	add    $0x10,%esp
      state = 0;
 548:	31 d2                	xor    %edx,%edx
 54a:	e9 be fe ff ff       	jmp    40d <printf+0x4d>
 54f:	90                   	nop
  write(fd, &c, 1);
 550:	83 ec 04             	sub    $0x4,%esp
 553:	88 5d e7             	mov    %bl,-0x19(%ebp)
 556:	8d 55 e7             	lea    -0x19(%ebp),%edx
 559:	6a 01                	push   $0x1
 55b:	e9 11 ff ff ff       	jmp    471 <printf+0xb1>
 560:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 565:	bb e8 06 00 00       	mov    $0x6e8,%ebx
 56a:	e9 61 ff ff ff       	jmp    4d0 <printf+0x110>
 56f:	90                   	nop

00000570 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 570:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 571:	a1 e4 09 00 00       	mov    0x9e4,%eax
{
 576:	89 e5                	mov    %esp,%ebp
 578:	57                   	push   %edi
 579:	56                   	push   %esi
 57a:	53                   	push   %ebx
 57b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 57e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 588:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 58a:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 58c:	39 ca                	cmp    %ecx,%edx
 58e:	73 30                	jae    5c0 <free+0x50>
 590:	39 c1                	cmp    %eax,%ecx
 592:	72 04                	jb     598 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 594:	39 c2                	cmp    %eax,%edx
 596:	72 f0                	jb     588 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 598:	8b 73 fc             	mov    -0x4(%ebx),%esi
 59b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 59e:	39 f8                	cmp    %edi,%eax
 5a0:	74 2e                	je     5d0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 5a2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 5a5:	8b 42 04             	mov    0x4(%edx),%eax
 5a8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5ab:	39 f1                	cmp    %esi,%ecx
 5ad:	74 38                	je     5e7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 5af:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 5b1:	5b                   	pop    %ebx
  freep = p;
 5b2:	89 15 e4 09 00 00    	mov    %edx,0x9e4
}
 5b8:	5e                   	pop    %esi
 5b9:	5f                   	pop    %edi
 5ba:	5d                   	pop    %ebp
 5bb:	c3                   	ret
 5bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5c0:	39 c1                	cmp    %eax,%ecx
 5c2:	72 d0                	jb     594 <free+0x24>
 5c4:	eb c2                	jmp    588 <free+0x18>
 5c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5cd:	8d 76 00             	lea    0x0(%esi),%esi
    bp->s.size += p->s.ptr->s.size;
 5d0:	03 70 04             	add    0x4(%eax),%esi
 5d3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5d6:	8b 02                	mov    (%edx),%eax
 5d8:	8b 00                	mov    (%eax),%eax
 5da:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 5dd:	8b 42 04             	mov    0x4(%edx),%eax
 5e0:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5e3:	39 f1                	cmp    %esi,%ecx
 5e5:	75 c8                	jne    5af <free+0x3f>
    p->s.size += bp->s.size;
 5e7:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 5ea:	89 15 e4 09 00 00    	mov    %edx,0x9e4
    p->s.size += bp->s.size;
 5f0:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 5f3:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 5f6:	89 0a                	mov    %ecx,(%edx)
}
 5f8:	5b                   	pop    %ebx
 5f9:	5e                   	pop    %esi
 5fa:	5f                   	pop    %edi
 5fb:	5d                   	pop    %ebp
 5fc:	c3                   	ret
 5fd:	8d 76 00             	lea    0x0(%esi),%esi

00000600 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	57                   	push   %edi
 604:	56                   	push   %esi
 605:	53                   	push   %ebx
 606:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 609:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 60c:	8b 15 e4 09 00 00    	mov    0x9e4,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 612:	8d 78 07             	lea    0x7(%eax),%edi
 615:	c1 ef 03             	shr    $0x3,%edi
 618:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 61b:	85 d2                	test   %edx,%edx
 61d:	0f 84 8d 00 00 00    	je     6b0 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 623:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 625:	8b 48 04             	mov    0x4(%eax),%ecx
 628:	39 f9                	cmp    %edi,%ecx
 62a:	73 64                	jae    690 <malloc+0x90>
  if(nu < 4096)
 62c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 631:	39 df                	cmp    %ebx,%edi
 633:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 636:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 63d:	eb 0a                	jmp    649 <malloc+0x49>
 63f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 640:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 642:	8b 48 04             	mov    0x4(%eax),%ecx
 645:	39 f9                	cmp    %edi,%ecx
 647:	73 47                	jae    690 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 649:	89 c2                	mov    %eax,%edx
 64b:	39 05 e4 09 00 00    	cmp    %eax,0x9e4
 651:	75 ed                	jne    640 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 653:	83 ec 0c             	sub    $0xc,%esp
 656:	56                   	push   %esi
 657:	e8 9f fc ff ff       	call   2fb <sbrk>
  if(p == (char*)-1)
 65c:	83 c4 10             	add    $0x10,%esp
 65f:	83 f8 ff             	cmp    $0xffffffff,%eax
 662:	74 1c                	je     680 <malloc+0x80>
  hp->s.size = nu;
 664:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 667:	83 ec 0c             	sub    $0xc,%esp
 66a:	83 c0 08             	add    $0x8,%eax
 66d:	50                   	push   %eax
 66e:	e8 fd fe ff ff       	call   570 <free>
  return freep;
 673:	8b 15 e4 09 00 00    	mov    0x9e4,%edx
      if((p = morecore(nunits)) == 0)
 679:	83 c4 10             	add    $0x10,%esp
 67c:	85 d2                	test   %edx,%edx
 67e:	75 c0                	jne    640 <malloc+0x40>
        return 0;
  }
}
 680:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 683:	31 c0                	xor    %eax,%eax
}
 685:	5b                   	pop    %ebx
 686:	5e                   	pop    %esi
 687:	5f                   	pop    %edi
 688:	5d                   	pop    %ebp
 689:	c3                   	ret
 68a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 690:	39 cf                	cmp    %ecx,%edi
 692:	74 4c                	je     6e0 <malloc+0xe0>
        p->s.size -= nunits;
 694:	29 f9                	sub    %edi,%ecx
 696:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 699:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 69c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 69f:	89 15 e4 09 00 00    	mov    %edx,0x9e4
}
 6a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 6a8:	83 c0 08             	add    $0x8,%eax
}
 6ab:	5b                   	pop    %ebx
 6ac:	5e                   	pop    %esi
 6ad:	5f                   	pop    %edi
 6ae:	5d                   	pop    %ebp
 6af:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 6b0:	c7 05 e4 09 00 00 e8 	movl   $0x9e8,0x9e4
 6b7:	09 00 00 
    base.s.size = 0;
 6ba:	b8 e8 09 00 00       	mov    $0x9e8,%eax
    base.s.ptr = freep = prevp = &base;
 6bf:	c7 05 e8 09 00 00 e8 	movl   $0x9e8,0x9e8
 6c6:	09 00 00 
    base.s.size = 0;
 6c9:	c7 05 ec 09 00 00 00 	movl   $0x0,0x9ec
 6d0:	00 00 00 
    if(p->s.size >= nunits){
 6d3:	e9 54 ff ff ff       	jmp    62c <malloc+0x2c>
 6d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6df:	90                   	nop
        prevp->s.ptr = p->s.ptr;
 6e0:	8b 08                	mov    (%eax),%ecx
 6e2:	89 0a                	mov    %ecx,(%edx)
 6e4:	eb b9                	jmp    69f <malloc+0x9f>
