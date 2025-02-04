
_shutdown:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    Failure to follow this instruction will lead to zero point 
	for this part */

int 
main(int argc, char * argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 0c             	sub    $0xc,%esp
    printf(1, "BYE~\n");
  11:	68 f8 06 00 00       	push   $0x6f8
  16:	6a 01                	push   $0x1
  18:	e8 b3 03 00 00       	call   3d0 <printf>
    shutdown();
    exit(); //return 0;
  1d:	e8 61 02 00 00       	call   283 <exit>
  22:	66 90                	xchg   %ax,%ax
  24:	66 90                	xchg   %ax,%ax
  26:	66 90                	xchg   %ax,%ax
  28:	66 90                	xchg   %ax,%ax
  2a:	66 90                	xchg   %ax,%ax
  2c:	66 90                	xchg   %ax,%ax
  2e:	66 90                	xchg   %ax,%ax

00000030 <shutdown>:
void shutdown(void) {}
  30:	c3                   	ret
  31:	66 90                	xchg   %ax,%ax
  33:	66 90                	xchg   %ax,%ax
  35:	66 90                	xchg   %ax,%ax
  37:	66 90                	xchg   %ax,%ax
  39:	66 90                	xchg   %ax,%ax
  3b:	66 90                	xchg   %ax,%ax
  3d:	66 90                	xchg   %ax,%ax
  3f:	90                   	nop

00000040 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  40:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  41:	31 c0                	xor    %eax,%eax
{
  43:	89 e5                	mov    %esp,%ebp
  45:	53                   	push   %ebx
  46:	8b 4d 08             	mov    0x8(%ebp),%ecx
  49:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  50:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  54:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  57:	83 c0 01             	add    $0x1,%eax
  5a:	84 d2                	test   %dl,%dl
  5c:	75 f2                	jne    50 <strcpy+0x10>
    ;
  return os;
}
  5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  61:	89 c8                	mov    %ecx,%eax
  63:	c9                   	leave
  64:	c3                   	ret
  65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000070 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	53                   	push   %ebx
  74:	8b 55 08             	mov    0x8(%ebp),%edx
  77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  7a:	0f b6 02             	movzbl (%edx),%eax
  7d:	84 c0                	test   %al,%al
  7f:	75 17                	jne    98 <strcmp+0x28>
  81:	eb 3a                	jmp    bd <strcmp+0x4d>
  83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  87:	90                   	nop
  88:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  8c:	83 c2 01             	add    $0x1,%edx
  8f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
  92:	84 c0                	test   %al,%al
  94:	74 1a                	je     b0 <strcmp+0x40>
    p++, q++;
  96:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
  98:	0f b6 19             	movzbl (%ecx),%ebx
  9b:	38 c3                	cmp    %al,%bl
  9d:	74 e9                	je     88 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  9f:	29 d8                	sub    %ebx,%eax
}
  a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  a4:	c9                   	leave
  a5:	c3                   	ret
  a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ad:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
  b0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  b4:	31 c0                	xor    %eax,%eax
  b6:	29 d8                	sub    %ebx,%eax
}
  b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  bb:	c9                   	leave
  bc:	c3                   	ret
  return (uchar)*p - (uchar)*q;
  bd:	0f b6 19             	movzbl (%ecx),%ebx
  c0:	31 c0                	xor    %eax,%eax
  c2:	eb db                	jmp    9f <strcmp+0x2f>
  c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  cf:	90                   	nop

000000d0 <strlen>:

uint
strlen(char *s)
{
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  d6:	80 3a 00             	cmpb   $0x0,(%edx)
  d9:	74 15                	je     f0 <strlen+0x20>
  db:	31 c0                	xor    %eax,%eax
  dd:	8d 76 00             	lea    0x0(%esi),%esi
  e0:	83 c0 01             	add    $0x1,%eax
  e3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  e7:	89 c1                	mov    %eax,%ecx
  e9:	75 f5                	jne    e0 <strlen+0x10>
    ;
  return n;
}
  eb:	89 c8                	mov    %ecx,%eax
  ed:	5d                   	pop    %ebp
  ee:	c3                   	ret
  ef:	90                   	nop
  for(n = 0; s[n]; n++)
  f0:	31 c9                	xor    %ecx,%ecx
}
  f2:	5d                   	pop    %ebp
  f3:	89 c8                	mov    %ecx,%eax
  f5:	c3                   	ret
  f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  fd:	8d 76 00             	lea    0x0(%esi),%esi

00000100 <memset>:

void*
memset(void *dst, int c, uint n)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	57                   	push   %edi
 104:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 107:	8b 4d 10             	mov    0x10(%ebp),%ecx
 10a:	8b 45 0c             	mov    0xc(%ebp),%eax
 10d:	89 d7                	mov    %edx,%edi
 10f:	fc                   	cld
 110:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 112:	8b 7d fc             	mov    -0x4(%ebp),%edi
 115:	89 d0                	mov    %edx,%eax
 117:	c9                   	leave
 118:	c3                   	ret
 119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000120 <strchr>:

char*
strchr(const char *s, char c)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	8b 45 08             	mov    0x8(%ebp),%eax
 126:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 12a:	0f b6 10             	movzbl (%eax),%edx
 12d:	84 d2                	test   %dl,%dl
 12f:	75 12                	jne    143 <strchr+0x23>
 131:	eb 1d                	jmp    150 <strchr+0x30>
 133:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 137:	90                   	nop
 138:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 13c:	83 c0 01             	add    $0x1,%eax
 13f:	84 d2                	test   %dl,%dl
 141:	74 0d                	je     150 <strchr+0x30>
    if(*s == c)
 143:	38 d1                	cmp    %dl,%cl
 145:	75 f1                	jne    138 <strchr+0x18>
      return (char*)s;
  return 0;
}
 147:	5d                   	pop    %ebp
 148:	c3                   	ret
 149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 150:	31 c0                	xor    %eax,%eax
}
 152:	5d                   	pop    %ebp
 153:	c3                   	ret
 154:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 15b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 15f:	90                   	nop

00000160 <gets>:

char*
gets(char *buf, int max)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	57                   	push   %edi
 164:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 165:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 168:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 169:	31 db                	xor    %ebx,%ebx
{
 16b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 16e:	eb 27                	jmp    197 <gets+0x37>
    cc = read(0, &c, 1);
 170:	83 ec 04             	sub    $0x4,%esp
 173:	6a 01                	push   $0x1
 175:	56                   	push   %esi
 176:	6a 00                	push   $0x0
 178:	e8 1e 01 00 00       	call   29b <read>
    if(cc < 1)
 17d:	83 c4 10             	add    $0x10,%esp
 180:	85 c0                	test   %eax,%eax
 182:	7e 1d                	jle    1a1 <gets+0x41>
      break;
    buf[i++] = c;
 184:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 188:	8b 55 08             	mov    0x8(%ebp),%edx
 18b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 18f:	3c 0a                	cmp    $0xa,%al
 191:	74 10                	je     1a3 <gets+0x43>
 193:	3c 0d                	cmp    $0xd,%al
 195:	74 0c                	je     1a3 <gets+0x43>
  for(i=0; i+1 < max; ){
 197:	89 df                	mov    %ebx,%edi
 199:	83 c3 01             	add    $0x1,%ebx
 19c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 19f:	7c cf                	jl     170 <gets+0x10>
 1a1:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 1a3:	8b 45 08             	mov    0x8(%ebp),%eax
 1a6:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 1aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1ad:	5b                   	pop    %ebx
 1ae:	5e                   	pop    %esi
 1af:	5f                   	pop    %edi
 1b0:	5d                   	pop    %ebp
 1b1:	c3                   	ret
 1b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001c0 <stat>:

int
stat(char *n, struct stat *st)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	56                   	push   %esi
 1c4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c5:	83 ec 08             	sub    $0x8,%esp
 1c8:	6a 00                	push   $0x0
 1ca:	ff 75 08             	push   0x8(%ebp)
 1cd:	e8 f1 00 00 00       	call   2c3 <open>
  if(fd < 0)
 1d2:	83 c4 10             	add    $0x10,%esp
 1d5:	85 c0                	test   %eax,%eax
 1d7:	78 27                	js     200 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 1d9:	83 ec 08             	sub    $0x8,%esp
 1dc:	ff 75 0c             	push   0xc(%ebp)
 1df:	89 c3                	mov    %eax,%ebx
 1e1:	50                   	push   %eax
 1e2:	e8 f4 00 00 00       	call   2db <fstat>
  close(fd);
 1e7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 1ea:	89 c6                	mov    %eax,%esi
  close(fd);
 1ec:	e8 ba 00 00 00       	call   2ab <close>
  return r;
 1f1:	83 c4 10             	add    $0x10,%esp
}
 1f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1f7:	89 f0                	mov    %esi,%eax
 1f9:	5b                   	pop    %ebx
 1fa:	5e                   	pop    %esi
 1fb:	5d                   	pop    %ebp
 1fc:	c3                   	ret
 1fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 200:	be ff ff ff ff       	mov    $0xffffffff,%esi
 205:	eb ed                	jmp    1f4 <stat+0x34>
 207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 20e:	66 90                	xchg   %ax,%ax

00000210 <atoi>:

int
atoi(const char *s)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	53                   	push   %ebx
 214:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 217:	0f be 02             	movsbl (%edx),%eax
 21a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 21d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 220:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 225:	77 1e                	ja     245 <atoi+0x35>
 227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 22e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 230:	83 c2 01             	add    $0x1,%edx
 233:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 236:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 23a:	0f be 02             	movsbl (%edx),%eax
 23d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 240:	80 fb 09             	cmp    $0x9,%bl
 243:	76 eb                	jbe    230 <atoi+0x20>
  return n;
}
 245:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 248:	89 c8                	mov    %ecx,%eax
 24a:	c9                   	leave
 24b:	c3                   	ret
 24c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000250 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	57                   	push   %edi
 254:	56                   	push   %esi
 255:	8b 45 10             	mov    0x10(%ebp),%eax
 258:	8b 55 08             	mov    0x8(%ebp),%edx
 25b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 25e:	85 c0                	test   %eax,%eax
 260:	7e 13                	jle    275 <memmove+0x25>
 262:	01 d0                	add    %edx,%eax
  dst = vdst;
 264:	89 d7                	mov    %edx,%edi
 266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 26d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 270:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 271:	39 f8                	cmp    %edi,%eax
 273:	75 fb                	jne    270 <memmove+0x20>
  return vdst;
}
 275:	5e                   	pop    %esi
 276:	89 d0                	mov    %edx,%eax
 278:	5f                   	pop    %edi
 279:	5d                   	pop    %ebp
 27a:	c3                   	ret

0000027b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 27b:	b8 01 00 00 00       	mov    $0x1,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret

00000283 <exit>:
SYSCALL(exit)
 283:	b8 02 00 00 00       	mov    $0x2,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret

0000028b <wait>:
SYSCALL(wait)
 28b:	b8 03 00 00 00       	mov    $0x3,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret

00000293 <pipe>:
SYSCALL(pipe)
 293:	b8 04 00 00 00       	mov    $0x4,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret

0000029b <read>:
SYSCALL(read)
 29b:	b8 05 00 00 00       	mov    $0x5,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret

000002a3 <write>:
SYSCALL(write)
 2a3:	b8 10 00 00 00       	mov    $0x10,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret

000002ab <close>:
SYSCALL(close)
 2ab:	b8 15 00 00 00       	mov    $0x15,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret

000002b3 <kill>:
SYSCALL(kill)
 2b3:	b8 06 00 00 00       	mov    $0x6,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret

000002bb <exec>:
SYSCALL(exec)
 2bb:	b8 07 00 00 00       	mov    $0x7,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret

000002c3 <open>:
SYSCALL(open)
 2c3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret

000002cb <mknod>:
SYSCALL(mknod)
 2cb:	b8 11 00 00 00       	mov    $0x11,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret

000002d3 <unlink>:
SYSCALL(unlink)
 2d3:	b8 12 00 00 00       	mov    $0x12,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret

000002db <fstat>:
SYSCALL(fstat)
 2db:	b8 08 00 00 00       	mov    $0x8,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret

000002e3 <link>:
SYSCALL(link)
 2e3:	b8 13 00 00 00       	mov    $0x13,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret

000002eb <mkdir>:
SYSCALL(mkdir)
 2eb:	b8 14 00 00 00       	mov    $0x14,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret

000002f3 <chdir>:
SYSCALL(chdir)
 2f3:	b8 09 00 00 00       	mov    $0x9,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret

000002fb <dup>:
SYSCALL(dup)
 2fb:	b8 0a 00 00 00       	mov    $0xa,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret

00000303 <getpid>:
SYSCALL(getpid)
 303:	b8 0b 00 00 00       	mov    $0xb,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret

0000030b <sbrk>:
SYSCALL(sbrk)
 30b:	b8 0c 00 00 00       	mov    $0xc,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret

00000313 <sleep>:
SYSCALL(sleep)
 313:	b8 0d 00 00 00       	mov    $0xd,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret

0000031b <uptime>:
SYSCALL(uptime)
 31b:	b8 0e 00 00 00       	mov    $0xe,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret
 323:	66 90                	xchg   %ax,%ax
 325:	66 90                	xchg   %ax,%ax
 327:	66 90                	xchg   %ax,%ax
 329:	66 90                	xchg   %ax,%ax
 32b:	66 90                	xchg   %ax,%ax
 32d:	66 90                	xchg   %ax,%ax
 32f:	90                   	nop

00000330 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	57                   	push   %edi
 334:	56                   	push   %esi
 335:	53                   	push   %ebx
 336:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 338:	89 d1                	mov    %edx,%ecx
{
 33a:	83 ec 3c             	sub    $0x3c,%esp
 33d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 340:	85 d2                	test   %edx,%edx
 342:	0f 89 80 00 00 00    	jns    3c8 <printint+0x98>
 348:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 34c:	74 7a                	je     3c8 <printint+0x98>
    x = -xx;
 34e:	f7 d9                	neg    %ecx
    neg = 1;
 350:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 355:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 358:	31 f6                	xor    %esi,%esi
 35a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 360:	89 c8                	mov    %ecx,%eax
 362:	31 d2                	xor    %edx,%edx
 364:	89 f7                	mov    %esi,%edi
 366:	f7 f3                	div    %ebx
 368:	8d 76 01             	lea    0x1(%esi),%esi
 36b:	0f b6 92 60 07 00 00 	movzbl 0x760(%edx),%edx
 372:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 376:	89 ca                	mov    %ecx,%edx
 378:	89 c1                	mov    %eax,%ecx
 37a:	39 da                	cmp    %ebx,%edx
 37c:	73 e2                	jae    360 <printint+0x30>
  if(neg)
 37e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 381:	85 c0                	test   %eax,%eax
 383:	74 07                	je     38c <printint+0x5c>
    buf[i++] = '-';
 385:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
    buf[i++] = digits[x % base];
 38a:	89 f7                	mov    %esi,%edi
 38c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 38f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 392:	01 df                	add    %ebx,%edi
 394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  while(--i >= 0)
    putc(fd, buf[i]);
 398:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 39b:	83 ec 04             	sub    $0x4,%esp
 39e:	88 45 d7             	mov    %al,-0x29(%ebp)
 3a1:	8d 45 d7             	lea    -0x29(%ebp),%eax
 3a4:	6a 01                	push   $0x1
 3a6:	50                   	push   %eax
 3a7:	56                   	push   %esi
 3a8:	e8 f6 fe ff ff       	call   2a3 <write>
  while(--i >= 0)
 3ad:	89 f8                	mov    %edi,%eax
 3af:	83 c4 10             	add    $0x10,%esp
 3b2:	83 ef 01             	sub    $0x1,%edi
 3b5:	39 d8                	cmp    %ebx,%eax
 3b7:	75 df                	jne    398 <printint+0x68>
}
 3b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3bc:	5b                   	pop    %ebx
 3bd:	5e                   	pop    %esi
 3be:	5f                   	pop    %edi
 3bf:	5d                   	pop    %ebp
 3c0:	c3                   	ret
 3c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 3c8:	31 c0                	xor    %eax,%eax
 3ca:	eb 89                	jmp    355 <printint+0x25>
 3cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003d0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	57                   	push   %edi
 3d4:	56                   	push   %esi
 3d5:	53                   	push   %ebx
 3d6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3d9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 3dc:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 3df:	0f b6 1e             	movzbl (%esi),%ebx
 3e2:	83 c6 01             	add    $0x1,%esi
 3e5:	84 db                	test   %bl,%bl
 3e7:	74 67                	je     450 <printf+0x80>
 3e9:	8d 4d 10             	lea    0x10(%ebp),%ecx
 3ec:	31 d2                	xor    %edx,%edx
 3ee:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 3f1:	eb 34                	jmp    427 <printf+0x57>
 3f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3f7:	90                   	nop
 3f8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 3fb:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 400:	83 f8 25             	cmp    $0x25,%eax
 403:	74 18                	je     41d <printf+0x4d>
  write(fd, &c, 1);
 405:	83 ec 04             	sub    $0x4,%esp
 408:	8d 45 e7             	lea    -0x19(%ebp),%eax
 40b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 40e:	6a 01                	push   $0x1
 410:	50                   	push   %eax
 411:	57                   	push   %edi
 412:	e8 8c fe ff ff       	call   2a3 <write>
 417:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 41a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 41d:	0f b6 1e             	movzbl (%esi),%ebx
 420:	83 c6 01             	add    $0x1,%esi
 423:	84 db                	test   %bl,%bl
 425:	74 29                	je     450 <printf+0x80>
    c = fmt[i] & 0xff;
 427:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 42a:	85 d2                	test   %edx,%edx
 42c:	74 ca                	je     3f8 <printf+0x28>
      }
    } else if(state == '%'){
 42e:	83 fa 25             	cmp    $0x25,%edx
 431:	75 ea                	jne    41d <printf+0x4d>
      if(c == 'd'){
 433:	83 f8 25             	cmp    $0x25,%eax
 436:	0f 84 24 01 00 00    	je     560 <printf+0x190>
 43c:	83 e8 63             	sub    $0x63,%eax
 43f:	83 f8 15             	cmp    $0x15,%eax
 442:	77 1c                	ja     460 <printf+0x90>
 444:	ff 24 85 08 07 00 00 	jmp    *0x708(,%eax,4)
 44b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 44f:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 450:	8d 65 f4             	lea    -0xc(%ebp),%esp
 453:	5b                   	pop    %ebx
 454:	5e                   	pop    %esi
 455:	5f                   	pop    %edi
 456:	5d                   	pop    %ebp
 457:	c3                   	ret
 458:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 45f:	90                   	nop
  write(fd, &c, 1);
 460:	83 ec 04             	sub    $0x4,%esp
 463:	8d 55 e7             	lea    -0x19(%ebp),%edx
 466:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 46a:	6a 01                	push   $0x1
 46c:	52                   	push   %edx
 46d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 470:	57                   	push   %edi
 471:	e8 2d fe ff ff       	call   2a3 <write>
 476:	83 c4 0c             	add    $0xc,%esp
 479:	88 5d e7             	mov    %bl,-0x19(%ebp)
 47c:	6a 01                	push   $0x1
 47e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 481:	52                   	push   %edx
 482:	57                   	push   %edi
 483:	e8 1b fe ff ff       	call   2a3 <write>
        putc(fd, c);
 488:	83 c4 10             	add    $0x10,%esp
      state = 0;
 48b:	31 d2                	xor    %edx,%edx
 48d:	eb 8e                	jmp    41d <printf+0x4d>
 48f:	90                   	nop
        printint(fd, *ap, 16, 0);
 490:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 493:	83 ec 0c             	sub    $0xc,%esp
 496:	b9 10 00 00 00       	mov    $0x10,%ecx
 49b:	8b 13                	mov    (%ebx),%edx
 49d:	6a 00                	push   $0x0
 49f:	89 f8                	mov    %edi,%eax
        ap++;
 4a1:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 4a4:	e8 87 fe ff ff       	call   330 <printint>
        ap++;
 4a9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 4ac:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4af:	31 d2                	xor    %edx,%edx
 4b1:	e9 67 ff ff ff       	jmp    41d <printf+0x4d>
 4b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4bd:	8d 76 00             	lea    0x0(%esi),%esi
        s = (char*)*ap;
 4c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 4c3:	8b 18                	mov    (%eax),%ebx
        ap++;
 4c5:	83 c0 04             	add    $0x4,%eax
 4c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 4cb:	85 db                	test   %ebx,%ebx
 4cd:	0f 84 9d 00 00 00    	je     570 <printf+0x1a0>
        while(*s != 0){
 4d3:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 4d6:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 4d8:	84 c0                	test   %al,%al
 4da:	0f 84 3d ff ff ff    	je     41d <printf+0x4d>
 4e0:	8d 55 e7             	lea    -0x19(%ebp),%edx
 4e3:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 4e6:	89 de                	mov    %ebx,%esi
 4e8:	89 d3                	mov    %edx,%ebx
 4ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 4f0:	83 ec 04             	sub    $0x4,%esp
 4f3:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 4f6:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 4f9:	6a 01                	push   $0x1
 4fb:	53                   	push   %ebx
 4fc:	57                   	push   %edi
 4fd:	e8 a1 fd ff ff       	call   2a3 <write>
        while(*s != 0){
 502:	0f b6 06             	movzbl (%esi),%eax
 505:	83 c4 10             	add    $0x10,%esp
 508:	84 c0                	test   %al,%al
 50a:	75 e4                	jne    4f0 <printf+0x120>
      state = 0;
 50c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 50f:	31 d2                	xor    %edx,%edx
 511:	e9 07 ff ff ff       	jmp    41d <printf+0x4d>
 516:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 51d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 520:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 523:	83 ec 0c             	sub    $0xc,%esp
 526:	b9 0a 00 00 00       	mov    $0xa,%ecx
 52b:	8b 13                	mov    (%ebx),%edx
 52d:	6a 01                	push   $0x1
 52f:	e9 6b ff ff ff       	jmp    49f <printf+0xcf>
 534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 538:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 53b:	83 ec 04             	sub    $0x4,%esp
 53e:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 541:	8b 03                	mov    (%ebx),%eax
        ap++;
 543:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 546:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 549:	6a 01                	push   $0x1
 54b:	52                   	push   %edx
 54c:	57                   	push   %edi
 54d:	e8 51 fd ff ff       	call   2a3 <write>
        ap++;
 552:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 555:	83 c4 10             	add    $0x10,%esp
      state = 0;
 558:	31 d2                	xor    %edx,%edx
 55a:	e9 be fe ff ff       	jmp    41d <printf+0x4d>
 55f:	90                   	nop
  write(fd, &c, 1);
 560:	83 ec 04             	sub    $0x4,%esp
 563:	88 5d e7             	mov    %bl,-0x19(%ebp)
 566:	8d 55 e7             	lea    -0x19(%ebp),%edx
 569:	6a 01                	push   $0x1
 56b:	e9 11 ff ff ff       	jmp    481 <printf+0xb1>
 570:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 575:	bb fe 06 00 00       	mov    $0x6fe,%ebx
 57a:	e9 61 ff ff ff       	jmp    4e0 <printf+0x110>
 57f:	90                   	nop

00000580 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 580:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 581:	a1 10 0a 00 00       	mov    0xa10,%eax
{
 586:	89 e5                	mov    %esp,%ebp
 588:	57                   	push   %edi
 589:	56                   	push   %esi
 58a:	53                   	push   %ebx
 58b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 58e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 598:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 59a:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 59c:	39 ca                	cmp    %ecx,%edx
 59e:	73 30                	jae    5d0 <free+0x50>
 5a0:	39 c1                	cmp    %eax,%ecx
 5a2:	72 04                	jb     5a8 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5a4:	39 c2                	cmp    %eax,%edx
 5a6:	72 f0                	jb     598 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5a8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5ab:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5ae:	39 f8                	cmp    %edi,%eax
 5b0:	74 2e                	je     5e0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 5b2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 5b5:	8b 42 04             	mov    0x4(%edx),%eax
 5b8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5bb:	39 f1                	cmp    %esi,%ecx
 5bd:	74 38                	je     5f7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 5bf:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 5c1:	5b                   	pop    %ebx
  freep = p;
 5c2:	89 15 10 0a 00 00    	mov    %edx,0xa10
}
 5c8:	5e                   	pop    %esi
 5c9:	5f                   	pop    %edi
 5ca:	5d                   	pop    %ebp
 5cb:	c3                   	ret
 5cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d0:	39 c1                	cmp    %eax,%ecx
 5d2:	72 d0                	jb     5a4 <free+0x24>
 5d4:	eb c2                	jmp    598 <free+0x18>
 5d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5dd:	8d 76 00             	lea    0x0(%esi),%esi
    bp->s.size += p->s.ptr->s.size;
 5e0:	03 70 04             	add    0x4(%eax),%esi
 5e3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5e6:	8b 02                	mov    (%edx),%eax
 5e8:	8b 00                	mov    (%eax),%eax
 5ea:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 5ed:	8b 42 04             	mov    0x4(%edx),%eax
 5f0:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5f3:	39 f1                	cmp    %esi,%ecx
 5f5:	75 c8                	jne    5bf <free+0x3f>
    p->s.size += bp->s.size;
 5f7:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 5fa:	89 15 10 0a 00 00    	mov    %edx,0xa10
    p->s.size += bp->s.size;
 600:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 603:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 606:	89 0a                	mov    %ecx,(%edx)
}
 608:	5b                   	pop    %ebx
 609:	5e                   	pop    %esi
 60a:	5f                   	pop    %edi
 60b:	5d                   	pop    %ebp
 60c:	c3                   	ret
 60d:	8d 76 00             	lea    0x0(%esi),%esi

00000610 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 610:	55                   	push   %ebp
 611:	89 e5                	mov    %esp,%ebp
 613:	57                   	push   %edi
 614:	56                   	push   %esi
 615:	53                   	push   %ebx
 616:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 619:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 61c:	8b 15 10 0a 00 00    	mov    0xa10,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 622:	8d 78 07             	lea    0x7(%eax),%edi
 625:	c1 ef 03             	shr    $0x3,%edi
 628:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 62b:	85 d2                	test   %edx,%edx
 62d:	0f 84 8d 00 00 00    	je     6c0 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 633:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 635:	8b 48 04             	mov    0x4(%eax),%ecx
 638:	39 f9                	cmp    %edi,%ecx
 63a:	73 64                	jae    6a0 <malloc+0x90>
  if(nu < 4096)
 63c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 641:	39 df                	cmp    %ebx,%edi
 643:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 646:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 64d:	eb 0a                	jmp    659 <malloc+0x49>
 64f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 650:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 652:	8b 48 04             	mov    0x4(%eax),%ecx
 655:	39 f9                	cmp    %edi,%ecx
 657:	73 47                	jae    6a0 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 659:	89 c2                	mov    %eax,%edx
 65b:	39 05 10 0a 00 00    	cmp    %eax,0xa10
 661:	75 ed                	jne    650 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 663:	83 ec 0c             	sub    $0xc,%esp
 666:	56                   	push   %esi
 667:	e8 9f fc ff ff       	call   30b <sbrk>
  if(p == (char*)-1)
 66c:	83 c4 10             	add    $0x10,%esp
 66f:	83 f8 ff             	cmp    $0xffffffff,%eax
 672:	74 1c                	je     690 <malloc+0x80>
  hp->s.size = nu;
 674:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 677:	83 ec 0c             	sub    $0xc,%esp
 67a:	83 c0 08             	add    $0x8,%eax
 67d:	50                   	push   %eax
 67e:	e8 fd fe ff ff       	call   580 <free>
  return freep;
 683:	8b 15 10 0a 00 00    	mov    0xa10,%edx
      if((p = morecore(nunits)) == 0)
 689:	83 c4 10             	add    $0x10,%esp
 68c:	85 d2                	test   %edx,%edx
 68e:	75 c0                	jne    650 <malloc+0x40>
        return 0;
  }
}
 690:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 693:	31 c0                	xor    %eax,%eax
}
 695:	5b                   	pop    %ebx
 696:	5e                   	pop    %esi
 697:	5f                   	pop    %edi
 698:	5d                   	pop    %ebp
 699:	c3                   	ret
 69a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 6a0:	39 cf                	cmp    %ecx,%edi
 6a2:	74 4c                	je     6f0 <malloc+0xe0>
        p->s.size -= nunits;
 6a4:	29 f9                	sub    %edi,%ecx
 6a6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6a9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6ac:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 6af:	89 15 10 0a 00 00    	mov    %edx,0xa10
}
 6b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 6b8:	83 c0 08             	add    $0x8,%eax
}
 6bb:	5b                   	pop    %ebx
 6bc:	5e                   	pop    %esi
 6bd:	5f                   	pop    %edi
 6be:	5d                   	pop    %ebp
 6bf:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 6c0:	c7 05 10 0a 00 00 14 	movl   $0xa14,0xa10
 6c7:	0a 00 00 
    base.s.size = 0;
 6ca:	b8 14 0a 00 00       	mov    $0xa14,%eax
    base.s.ptr = freep = prevp = &base;
 6cf:	c7 05 14 0a 00 00 14 	movl   $0xa14,0xa14
 6d6:	0a 00 00 
    base.s.size = 0;
 6d9:	c7 05 18 0a 00 00 00 	movl   $0x0,0xa18
 6e0:	00 00 00 
    if(p->s.size >= nunits){
 6e3:	e9 54 ff ff ff       	jmp    63c <malloc+0x2c>
 6e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6ef:	90                   	nop
        prevp->s.ptr = p->s.ptr;
 6f0:	8b 08                	mov    (%eax),%ecx
 6f2:	89 0a                	mov    %ecx,(%edx)
 6f4:	eb b9                	jmp    6af <malloc+0x9f>
