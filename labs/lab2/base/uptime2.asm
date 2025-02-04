
_uptime2:     file format elf32-i386


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
   e:	83 ec 10             	sub    $0x10,%esp
  11:	8b 41 04             	mov    0x4(%ecx),%eax
	int i = atoi(argv[1]);
  14:	ff 70 04             	push   0x4(%eax)
  17:	e8 54 02 00 00       	call   270 <atoi>
    
    // "msg" now holds the shutdown message provided by the user
    //shutdown2(msg);
	
    if(i<1 || i>3)
  1c:	83 c4 10             	add    $0x10,%esp
  1f:	8d 50 ff             	lea    -0x1(%eax),%edx
  22:	83 fa 02             	cmp    $0x2,%edx
  25:	77 35                	ja     5c <main+0x5c>
        printf(1,"Available options for uptime output: \n[\n1=seconds,\n2=days,\n3=years\n]");
    
    uint ut = uptime2(i);

    if(i == 1){
  27:	83 f8 01             	cmp    $0x1,%eax
  2a:	74 19                	je     45 <main+0x45>
        printf(1, "Current Uptime in ticks: %d", ut);
    } else if(i == 2){
  2c:	83 f8 02             	cmp    $0x2,%eax
  2f:	74 3e                	je     6f <main+0x6f>
        printf(1, "Current Uptime in seconds: %d", ut);
    } else if(i == 3){
        printf(1, "Current Uptime in minutes: %d", ut);
  31:	50                   	push   %eax
  32:	6a 00                	push   $0x0
  34:	68 d7 07 00 00       	push   $0x7d7
  39:	6a 01                	push   $0x1
  3b:	e8 f0 03 00 00       	call   430 <printf>
  40:	83 c4 10             	add    $0x10,%esp
  43:	eb 12                	jmp    57 <main+0x57>
        printf(1, "Current Uptime in ticks: %d", ut);
  45:	51                   	push   %ecx
  46:	6a 00                	push   $0x0
  48:	68 9d 07 00 00       	push   $0x79d
  4d:	6a 01                	push   $0x1
  4f:	e8 dc 03 00 00       	call   430 <printf>
  54:	83 c4 10             	add    $0x10,%esp
    }

    exit(); //return 0;
  57:	e8 87 02 00 00       	call   2e3 <exit>
        printf(1,"Available options for uptime output: \n[\n1=seconds,\n2=days,\n3=years\n]");
  5c:	50                   	push   %eax
  5d:	50                   	push   %eax
  5e:	68 58 07 00 00       	push   $0x758
  63:	6a 01                	push   $0x1
  65:	e8 c6 03 00 00       	call   430 <printf>
    } else if(i == 3){
  6a:	83 c4 10             	add    $0x10,%esp
  6d:	eb e8                	jmp    57 <main+0x57>
        printf(1, "Current Uptime in seconds: %d", ut);
  6f:	52                   	push   %edx
  70:	6a 00                	push   $0x0
  72:	68 b9 07 00 00       	push   $0x7b9
  77:	6a 01                	push   $0x1
  79:	e8 b2 03 00 00       	call   430 <printf>
  7e:	83 c4 10             	add    $0x10,%esp
  81:	eb d4                	jmp    57 <main+0x57>
  83:	66 90                	xchg   %ax,%ax
  85:	66 90                	xchg   %ax,%ax
  87:	66 90                	xchg   %ax,%ax
  89:	66 90                	xchg   %ax,%ax
  8b:	66 90                	xchg   %ax,%ax
  8d:	66 90                	xchg   %ax,%ax
  8f:	90                   	nop

00000090 <uptime2>:
int uptime2(int i) {return 0;}
  90:	31 c0                	xor    %eax,%eax
  92:	c3                   	ret
  93:	66 90                	xchg   %ax,%ax
  95:	66 90                	xchg   %ax,%ax
  97:	66 90                	xchg   %ax,%ax
  99:	66 90                	xchg   %ax,%ax
  9b:	66 90                	xchg   %ax,%ax
  9d:	66 90                	xchg   %ax,%ax
  9f:	90                   	nop

000000a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  a0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a1:	31 c0                	xor    %eax,%eax
{
  a3:	89 e5                	mov    %esp,%ebp
  a5:	53                   	push   %ebx
  a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  b0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  b4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  b7:	83 c0 01             	add    $0x1,%eax
  ba:	84 d2                	test   %dl,%dl
  bc:	75 f2                	jne    b0 <strcpy+0x10>
    ;
  return os;
}
  be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  c1:	89 c8                	mov    %ecx,%eax
  c3:	c9                   	leave
  c4:	c3                   	ret
  c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000000d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	53                   	push   %ebx
  d4:	8b 55 08             	mov    0x8(%ebp),%edx
  d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  da:	0f b6 02             	movzbl (%edx),%eax
  dd:	84 c0                	test   %al,%al
  df:	75 17                	jne    f8 <strcmp+0x28>
  e1:	eb 3a                	jmp    11d <strcmp+0x4d>
  e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  e7:	90                   	nop
  e8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  ec:	83 c2 01             	add    $0x1,%edx
  ef:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
  f2:	84 c0                	test   %al,%al
  f4:	74 1a                	je     110 <strcmp+0x40>
    p++, q++;
  f6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
  f8:	0f b6 19             	movzbl (%ecx),%ebx
  fb:	38 c3                	cmp    %al,%bl
  fd:	74 e9                	je     e8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  ff:	29 d8                	sub    %ebx,%eax
}
 101:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 104:	c9                   	leave
 105:	c3                   	ret
 106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 10d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 110:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 114:	31 c0                	xor    %eax,%eax
 116:	29 d8                	sub    %ebx,%eax
}
 118:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 11b:	c9                   	leave
 11c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 11d:	0f b6 19             	movzbl (%ecx),%ebx
 120:	31 c0                	xor    %eax,%eax
 122:	eb db                	jmp    ff <strcmp+0x2f>
 124:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 12b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 12f:	90                   	nop

00000130 <strlen>:

uint
strlen(char *s)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 136:	80 3a 00             	cmpb   $0x0,(%edx)
 139:	74 15                	je     150 <strlen+0x20>
 13b:	31 c0                	xor    %eax,%eax
 13d:	8d 76 00             	lea    0x0(%esi),%esi
 140:	83 c0 01             	add    $0x1,%eax
 143:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 147:	89 c1                	mov    %eax,%ecx
 149:	75 f5                	jne    140 <strlen+0x10>
    ;
  return n;
}
 14b:	89 c8                	mov    %ecx,%eax
 14d:	5d                   	pop    %ebp
 14e:	c3                   	ret
 14f:	90                   	nop
  for(n = 0; s[n]; n++)
 150:	31 c9                	xor    %ecx,%ecx
}
 152:	5d                   	pop    %ebp
 153:	89 c8                	mov    %ecx,%eax
 155:	c3                   	ret
 156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 15d:	8d 76 00             	lea    0x0(%esi),%esi

00000160 <memset>:

void*
memset(void *dst, int c, uint n)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	57                   	push   %edi
 164:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 167:	8b 4d 10             	mov    0x10(%ebp),%ecx
 16a:	8b 45 0c             	mov    0xc(%ebp),%eax
 16d:	89 d7                	mov    %edx,%edi
 16f:	fc                   	cld
 170:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 172:	8b 7d fc             	mov    -0x4(%ebp),%edi
 175:	89 d0                	mov    %edx,%eax
 177:	c9                   	leave
 178:	c3                   	ret
 179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000180 <strchr>:

char*
strchr(const char *s, char c)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	8b 45 08             	mov    0x8(%ebp),%eax
 186:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 18a:	0f b6 10             	movzbl (%eax),%edx
 18d:	84 d2                	test   %dl,%dl
 18f:	75 12                	jne    1a3 <strchr+0x23>
 191:	eb 1d                	jmp    1b0 <strchr+0x30>
 193:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 197:	90                   	nop
 198:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 19c:	83 c0 01             	add    $0x1,%eax
 19f:	84 d2                	test   %dl,%dl
 1a1:	74 0d                	je     1b0 <strchr+0x30>
    if(*s == c)
 1a3:	38 d1                	cmp    %dl,%cl
 1a5:	75 f1                	jne    198 <strchr+0x18>
      return (char*)s;
  return 0;
}
 1a7:	5d                   	pop    %ebp
 1a8:	c3                   	ret
 1a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 1b0:	31 c0                	xor    %eax,%eax
}
 1b2:	5d                   	pop    %ebp
 1b3:	c3                   	ret
 1b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1bf:	90                   	nop

000001c0 <gets>:

char*
gets(char *buf, int max)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	57                   	push   %edi
 1c4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 1c5:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 1c8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 1c9:	31 db                	xor    %ebx,%ebx
{
 1cb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 1ce:	eb 27                	jmp    1f7 <gets+0x37>
    cc = read(0, &c, 1);
 1d0:	83 ec 04             	sub    $0x4,%esp
 1d3:	6a 01                	push   $0x1
 1d5:	56                   	push   %esi
 1d6:	6a 00                	push   $0x0
 1d8:	e8 1e 01 00 00       	call   2fb <read>
    if(cc < 1)
 1dd:	83 c4 10             	add    $0x10,%esp
 1e0:	85 c0                	test   %eax,%eax
 1e2:	7e 1d                	jle    201 <gets+0x41>
      break;
    buf[i++] = c;
 1e4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1e8:	8b 55 08             	mov    0x8(%ebp),%edx
 1eb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1ef:	3c 0a                	cmp    $0xa,%al
 1f1:	74 10                	je     203 <gets+0x43>
 1f3:	3c 0d                	cmp    $0xd,%al
 1f5:	74 0c                	je     203 <gets+0x43>
  for(i=0; i+1 < max; ){
 1f7:	89 df                	mov    %ebx,%edi
 1f9:	83 c3 01             	add    $0x1,%ebx
 1fc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1ff:	7c cf                	jl     1d0 <gets+0x10>
 201:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 203:	8b 45 08             	mov    0x8(%ebp),%eax
 206:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 20a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 20d:	5b                   	pop    %ebx
 20e:	5e                   	pop    %esi
 20f:	5f                   	pop    %edi
 210:	5d                   	pop    %ebp
 211:	c3                   	ret
 212:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000220 <stat>:

int
stat(char *n, struct stat *st)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	56                   	push   %esi
 224:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 225:	83 ec 08             	sub    $0x8,%esp
 228:	6a 00                	push   $0x0
 22a:	ff 75 08             	push   0x8(%ebp)
 22d:	e8 f1 00 00 00       	call   323 <open>
  if(fd < 0)
 232:	83 c4 10             	add    $0x10,%esp
 235:	85 c0                	test   %eax,%eax
 237:	78 27                	js     260 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 239:	83 ec 08             	sub    $0x8,%esp
 23c:	ff 75 0c             	push   0xc(%ebp)
 23f:	89 c3                	mov    %eax,%ebx
 241:	50                   	push   %eax
 242:	e8 f4 00 00 00       	call   33b <fstat>
  close(fd);
 247:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 24a:	89 c6                	mov    %eax,%esi
  close(fd);
 24c:	e8 ba 00 00 00       	call   30b <close>
  return r;
 251:	83 c4 10             	add    $0x10,%esp
}
 254:	8d 65 f8             	lea    -0x8(%ebp),%esp
 257:	89 f0                	mov    %esi,%eax
 259:	5b                   	pop    %ebx
 25a:	5e                   	pop    %esi
 25b:	5d                   	pop    %ebp
 25c:	c3                   	ret
 25d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 260:	be ff ff ff ff       	mov    $0xffffffff,%esi
 265:	eb ed                	jmp    254 <stat+0x34>
 267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 26e:	66 90                	xchg   %ax,%ax

00000270 <atoi>:

int
atoi(const char *s)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	53                   	push   %ebx
 274:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 277:	0f be 02             	movsbl (%edx),%eax
 27a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 27d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 280:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 285:	77 1e                	ja     2a5 <atoi+0x35>
 287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 28e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 290:	83 c2 01             	add    $0x1,%edx
 293:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 296:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 29a:	0f be 02             	movsbl (%edx),%eax
 29d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2a0:	80 fb 09             	cmp    $0x9,%bl
 2a3:	76 eb                	jbe    290 <atoi+0x20>
  return n;
}
 2a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2a8:	89 c8                	mov    %ecx,%eax
 2aa:	c9                   	leave
 2ab:	c3                   	ret
 2ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002b0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	57                   	push   %edi
 2b4:	56                   	push   %esi
 2b5:	8b 45 10             	mov    0x10(%ebp),%eax
 2b8:	8b 55 08             	mov    0x8(%ebp),%edx
 2bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2be:	85 c0                	test   %eax,%eax
 2c0:	7e 13                	jle    2d5 <memmove+0x25>
 2c2:	01 d0                	add    %edx,%eax
  dst = vdst;
 2c4:	89 d7                	mov    %edx,%edi
 2c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2cd:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 2d0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2d1:	39 f8                	cmp    %edi,%eax
 2d3:	75 fb                	jne    2d0 <memmove+0x20>
  return vdst;
}
 2d5:	5e                   	pop    %esi
 2d6:	89 d0                	mov    %edx,%eax
 2d8:	5f                   	pop    %edi
 2d9:	5d                   	pop    %ebp
 2da:	c3                   	ret

000002db <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2db:	b8 01 00 00 00       	mov    $0x1,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret

000002e3 <exit>:
SYSCALL(exit)
 2e3:	b8 02 00 00 00       	mov    $0x2,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret

000002eb <wait>:
SYSCALL(wait)
 2eb:	b8 03 00 00 00       	mov    $0x3,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret

000002f3 <pipe>:
SYSCALL(pipe)
 2f3:	b8 04 00 00 00       	mov    $0x4,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret

000002fb <read>:
SYSCALL(read)
 2fb:	b8 05 00 00 00       	mov    $0x5,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret

00000303 <write>:
SYSCALL(write)
 303:	b8 10 00 00 00       	mov    $0x10,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret

0000030b <close>:
SYSCALL(close)
 30b:	b8 15 00 00 00       	mov    $0x15,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret

00000313 <kill>:
SYSCALL(kill)
 313:	b8 06 00 00 00       	mov    $0x6,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret

0000031b <exec>:
SYSCALL(exec)
 31b:	b8 07 00 00 00       	mov    $0x7,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret

00000323 <open>:
SYSCALL(open)
 323:	b8 0f 00 00 00       	mov    $0xf,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret

0000032b <mknod>:
SYSCALL(mknod)
 32b:	b8 11 00 00 00       	mov    $0x11,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret

00000333 <unlink>:
SYSCALL(unlink)
 333:	b8 12 00 00 00       	mov    $0x12,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret

0000033b <fstat>:
SYSCALL(fstat)
 33b:	b8 08 00 00 00       	mov    $0x8,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret

00000343 <link>:
SYSCALL(link)
 343:	b8 13 00 00 00       	mov    $0x13,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret

0000034b <mkdir>:
SYSCALL(mkdir)
 34b:	b8 14 00 00 00       	mov    $0x14,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret

00000353 <chdir>:
SYSCALL(chdir)
 353:	b8 09 00 00 00       	mov    $0x9,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret

0000035b <dup>:
SYSCALL(dup)
 35b:	b8 0a 00 00 00       	mov    $0xa,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret

00000363 <getpid>:
SYSCALL(getpid)
 363:	b8 0b 00 00 00       	mov    $0xb,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret

0000036b <sbrk>:
SYSCALL(sbrk)
 36b:	b8 0c 00 00 00       	mov    $0xc,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret

00000373 <sleep>:
SYSCALL(sleep)
 373:	b8 0d 00 00 00       	mov    $0xd,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret

0000037b <uptime>:
SYSCALL(uptime)
 37b:	b8 0e 00 00 00       	mov    $0xe,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret
 383:	66 90                	xchg   %ax,%ax
 385:	66 90                	xchg   %ax,%ax
 387:	66 90                	xchg   %ax,%ax
 389:	66 90                	xchg   %ax,%ax
 38b:	66 90                	xchg   %ax,%ax
 38d:	66 90                	xchg   %ax,%ax
 38f:	90                   	nop

00000390 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	57                   	push   %edi
 394:	56                   	push   %esi
 395:	53                   	push   %ebx
 396:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 398:	89 d1                	mov    %edx,%ecx
{
 39a:	83 ec 3c             	sub    $0x3c,%esp
 39d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 3a0:	85 d2                	test   %edx,%edx
 3a2:	0f 89 80 00 00 00    	jns    428 <printint+0x98>
 3a8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3ac:	74 7a                	je     428 <printint+0x98>
    x = -xx;
 3ae:	f7 d9                	neg    %ecx
    neg = 1;
 3b0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 3b5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 3b8:	31 f6                	xor    %esi,%esi
 3ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 3c0:	89 c8                	mov    %ecx,%eax
 3c2:	31 d2                	xor    %edx,%edx
 3c4:	89 f7                	mov    %esi,%edi
 3c6:	f7 f3                	div    %ebx
 3c8:	8d 76 01             	lea    0x1(%esi),%esi
 3cb:	0f b6 92 54 08 00 00 	movzbl 0x854(%edx),%edx
 3d2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 3d6:	89 ca                	mov    %ecx,%edx
 3d8:	89 c1                	mov    %eax,%ecx
 3da:	39 da                	cmp    %ebx,%edx
 3dc:	73 e2                	jae    3c0 <printint+0x30>
  if(neg)
 3de:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3e1:	85 c0                	test   %eax,%eax
 3e3:	74 07                	je     3ec <printint+0x5c>
    buf[i++] = '-';
 3e5:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
    buf[i++] = digits[x % base];
 3ea:	89 f7                	mov    %esi,%edi
 3ec:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 3ef:	8b 75 c0             	mov    -0x40(%ebp),%esi
 3f2:	01 df                	add    %ebx,%edi
 3f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  while(--i >= 0)
    putc(fd, buf[i]);
 3f8:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 3fb:	83 ec 04             	sub    $0x4,%esp
 3fe:	88 45 d7             	mov    %al,-0x29(%ebp)
 401:	8d 45 d7             	lea    -0x29(%ebp),%eax
 404:	6a 01                	push   $0x1
 406:	50                   	push   %eax
 407:	56                   	push   %esi
 408:	e8 f6 fe ff ff       	call   303 <write>
  while(--i >= 0)
 40d:	89 f8                	mov    %edi,%eax
 40f:	83 c4 10             	add    $0x10,%esp
 412:	83 ef 01             	sub    $0x1,%edi
 415:	39 d8                	cmp    %ebx,%eax
 417:	75 df                	jne    3f8 <printint+0x68>
}
 419:	8d 65 f4             	lea    -0xc(%ebp),%esp
 41c:	5b                   	pop    %ebx
 41d:	5e                   	pop    %esi
 41e:	5f                   	pop    %edi
 41f:	5d                   	pop    %ebp
 420:	c3                   	ret
 421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 428:	31 c0                	xor    %eax,%eax
 42a:	eb 89                	jmp    3b5 <printint+0x25>
 42c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000430 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	56                   	push   %esi
 435:	53                   	push   %ebx
 436:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 439:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 43c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 43f:	0f b6 1e             	movzbl (%esi),%ebx
 442:	83 c6 01             	add    $0x1,%esi
 445:	84 db                	test   %bl,%bl
 447:	74 67                	je     4b0 <printf+0x80>
 449:	8d 4d 10             	lea    0x10(%ebp),%ecx
 44c:	31 d2                	xor    %edx,%edx
 44e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 451:	eb 34                	jmp    487 <printf+0x57>
 453:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 457:	90                   	nop
 458:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 45b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 460:	83 f8 25             	cmp    $0x25,%eax
 463:	74 18                	je     47d <printf+0x4d>
  write(fd, &c, 1);
 465:	83 ec 04             	sub    $0x4,%esp
 468:	8d 45 e7             	lea    -0x19(%ebp),%eax
 46b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 46e:	6a 01                	push   $0x1
 470:	50                   	push   %eax
 471:	57                   	push   %edi
 472:	e8 8c fe ff ff       	call   303 <write>
 477:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 47a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 47d:	0f b6 1e             	movzbl (%esi),%ebx
 480:	83 c6 01             	add    $0x1,%esi
 483:	84 db                	test   %bl,%bl
 485:	74 29                	je     4b0 <printf+0x80>
    c = fmt[i] & 0xff;
 487:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 48a:	85 d2                	test   %edx,%edx
 48c:	74 ca                	je     458 <printf+0x28>
      }
    } else if(state == '%'){
 48e:	83 fa 25             	cmp    $0x25,%edx
 491:	75 ea                	jne    47d <printf+0x4d>
      if(c == 'd'){
 493:	83 f8 25             	cmp    $0x25,%eax
 496:	0f 84 24 01 00 00    	je     5c0 <printf+0x190>
 49c:	83 e8 63             	sub    $0x63,%eax
 49f:	83 f8 15             	cmp    $0x15,%eax
 4a2:	77 1c                	ja     4c0 <printf+0x90>
 4a4:	ff 24 85 fc 07 00 00 	jmp    *0x7fc(,%eax,4)
 4ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4af:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4b3:	5b                   	pop    %ebx
 4b4:	5e                   	pop    %esi
 4b5:	5f                   	pop    %edi
 4b6:	5d                   	pop    %ebp
 4b7:	c3                   	ret
 4b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4bf:	90                   	nop
  write(fd, &c, 1);
 4c0:	83 ec 04             	sub    $0x4,%esp
 4c3:	8d 55 e7             	lea    -0x19(%ebp),%edx
 4c6:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4ca:	6a 01                	push   $0x1
 4cc:	52                   	push   %edx
 4cd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4d0:	57                   	push   %edi
 4d1:	e8 2d fe ff ff       	call   303 <write>
 4d6:	83 c4 0c             	add    $0xc,%esp
 4d9:	88 5d e7             	mov    %bl,-0x19(%ebp)
 4dc:	6a 01                	push   $0x1
 4de:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 4e1:	52                   	push   %edx
 4e2:	57                   	push   %edi
 4e3:	e8 1b fe ff ff       	call   303 <write>
        putc(fd, c);
 4e8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4eb:	31 d2                	xor    %edx,%edx
 4ed:	eb 8e                	jmp    47d <printf+0x4d>
 4ef:	90                   	nop
        printint(fd, *ap, 16, 0);
 4f0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4f3:	83 ec 0c             	sub    $0xc,%esp
 4f6:	b9 10 00 00 00       	mov    $0x10,%ecx
 4fb:	8b 13                	mov    (%ebx),%edx
 4fd:	6a 00                	push   $0x0
 4ff:	89 f8                	mov    %edi,%eax
        ap++;
 501:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 504:	e8 87 fe ff ff       	call   390 <printint>
        ap++;
 509:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 50c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 50f:	31 d2                	xor    %edx,%edx
 511:	e9 67 ff ff ff       	jmp    47d <printf+0x4d>
 516:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 51d:	8d 76 00             	lea    0x0(%esi),%esi
        s = (char*)*ap;
 520:	8b 45 d0             	mov    -0x30(%ebp),%eax
 523:	8b 18                	mov    (%eax),%ebx
        ap++;
 525:	83 c0 04             	add    $0x4,%eax
 528:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 52b:	85 db                	test   %ebx,%ebx
 52d:	0f 84 9d 00 00 00    	je     5d0 <printf+0x1a0>
        while(*s != 0){
 533:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 536:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 538:	84 c0                	test   %al,%al
 53a:	0f 84 3d ff ff ff    	je     47d <printf+0x4d>
 540:	8d 55 e7             	lea    -0x19(%ebp),%edx
 543:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 546:	89 de                	mov    %ebx,%esi
 548:	89 d3                	mov    %edx,%ebx
 54a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 550:	83 ec 04             	sub    $0x4,%esp
 553:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 556:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 559:	6a 01                	push   $0x1
 55b:	53                   	push   %ebx
 55c:	57                   	push   %edi
 55d:	e8 a1 fd ff ff       	call   303 <write>
        while(*s != 0){
 562:	0f b6 06             	movzbl (%esi),%eax
 565:	83 c4 10             	add    $0x10,%esp
 568:	84 c0                	test   %al,%al
 56a:	75 e4                	jne    550 <printf+0x120>
      state = 0;
 56c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 56f:	31 d2                	xor    %edx,%edx
 571:	e9 07 ff ff ff       	jmp    47d <printf+0x4d>
 576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 57d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 580:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 583:	83 ec 0c             	sub    $0xc,%esp
 586:	b9 0a 00 00 00       	mov    $0xa,%ecx
 58b:	8b 13                	mov    (%ebx),%edx
 58d:	6a 01                	push   $0x1
 58f:	e9 6b ff ff ff       	jmp    4ff <printf+0xcf>
 594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 598:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 59b:	83 ec 04             	sub    $0x4,%esp
 59e:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 5a1:	8b 03                	mov    (%ebx),%eax
        ap++;
 5a3:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 5a6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5a9:	6a 01                	push   $0x1
 5ab:	52                   	push   %edx
 5ac:	57                   	push   %edi
 5ad:	e8 51 fd ff ff       	call   303 <write>
        ap++;
 5b2:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5b5:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5b8:	31 d2                	xor    %edx,%edx
 5ba:	e9 be fe ff ff       	jmp    47d <printf+0x4d>
 5bf:	90                   	nop
  write(fd, &c, 1);
 5c0:	83 ec 04             	sub    $0x4,%esp
 5c3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5c6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 5c9:	6a 01                	push   $0x1
 5cb:	e9 11 ff ff ff       	jmp    4e1 <printf+0xb1>
 5d0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 5d5:	bb f5 07 00 00       	mov    $0x7f5,%ebx
 5da:	e9 61 ff ff ff       	jmp    540 <printf+0x110>
 5df:	90                   	nop

000005e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e1:	a1 04 0b 00 00       	mov    0xb04,%eax
{
 5e6:	89 e5                	mov    %esp,%ebp
 5e8:	57                   	push   %edi
 5e9:	56                   	push   %esi
 5ea:	53                   	push   %ebx
 5eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 5ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5f8:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5fa:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fc:	39 ca                	cmp    %ecx,%edx
 5fe:	73 30                	jae    630 <free+0x50>
 600:	39 c1                	cmp    %eax,%ecx
 602:	72 04                	jb     608 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 604:	39 c2                	cmp    %eax,%edx
 606:	72 f0                	jb     5f8 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 608:	8b 73 fc             	mov    -0x4(%ebx),%esi
 60b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 60e:	39 f8                	cmp    %edi,%eax
 610:	74 2e                	je     640 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 612:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 615:	8b 42 04             	mov    0x4(%edx),%eax
 618:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 61b:	39 f1                	cmp    %esi,%ecx
 61d:	74 38                	je     657 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 61f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 621:	5b                   	pop    %ebx
  freep = p;
 622:	89 15 04 0b 00 00    	mov    %edx,0xb04
}
 628:	5e                   	pop    %esi
 629:	5f                   	pop    %edi
 62a:	5d                   	pop    %ebp
 62b:	c3                   	ret
 62c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 630:	39 c1                	cmp    %eax,%ecx
 632:	72 d0                	jb     604 <free+0x24>
 634:	eb c2                	jmp    5f8 <free+0x18>
 636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 63d:	8d 76 00             	lea    0x0(%esi),%esi
    bp->s.size += p->s.ptr->s.size;
 640:	03 70 04             	add    0x4(%eax),%esi
 643:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 646:	8b 02                	mov    (%edx),%eax
 648:	8b 00                	mov    (%eax),%eax
 64a:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 64d:	8b 42 04             	mov    0x4(%edx),%eax
 650:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 653:	39 f1                	cmp    %esi,%ecx
 655:	75 c8                	jne    61f <free+0x3f>
    p->s.size += bp->s.size;
 657:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 65a:	89 15 04 0b 00 00    	mov    %edx,0xb04
    p->s.size += bp->s.size;
 660:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 663:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 666:	89 0a                	mov    %ecx,(%edx)
}
 668:	5b                   	pop    %ebx
 669:	5e                   	pop    %esi
 66a:	5f                   	pop    %edi
 66b:	5d                   	pop    %ebp
 66c:	c3                   	ret
 66d:	8d 76 00             	lea    0x0(%esi),%esi

00000670 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	57                   	push   %edi
 674:	56                   	push   %esi
 675:	53                   	push   %ebx
 676:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 679:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 67c:	8b 15 04 0b 00 00    	mov    0xb04,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 682:	8d 78 07             	lea    0x7(%eax),%edi
 685:	c1 ef 03             	shr    $0x3,%edi
 688:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 68b:	85 d2                	test   %edx,%edx
 68d:	0f 84 8d 00 00 00    	je     720 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 693:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 695:	8b 48 04             	mov    0x4(%eax),%ecx
 698:	39 f9                	cmp    %edi,%ecx
 69a:	73 64                	jae    700 <malloc+0x90>
  if(nu < 4096)
 69c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6a1:	39 df                	cmp    %ebx,%edi
 6a3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 6a6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 6ad:	eb 0a                	jmp    6b9 <malloc+0x49>
 6af:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6b0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6b2:	8b 48 04             	mov    0x4(%eax),%ecx
 6b5:	39 f9                	cmp    %edi,%ecx
 6b7:	73 47                	jae    700 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6b9:	89 c2                	mov    %eax,%edx
 6bb:	39 05 04 0b 00 00    	cmp    %eax,0xb04
 6c1:	75 ed                	jne    6b0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 6c3:	83 ec 0c             	sub    $0xc,%esp
 6c6:	56                   	push   %esi
 6c7:	e8 9f fc ff ff       	call   36b <sbrk>
  if(p == (char*)-1)
 6cc:	83 c4 10             	add    $0x10,%esp
 6cf:	83 f8 ff             	cmp    $0xffffffff,%eax
 6d2:	74 1c                	je     6f0 <malloc+0x80>
  hp->s.size = nu;
 6d4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6d7:	83 ec 0c             	sub    $0xc,%esp
 6da:	83 c0 08             	add    $0x8,%eax
 6dd:	50                   	push   %eax
 6de:	e8 fd fe ff ff       	call   5e0 <free>
  return freep;
 6e3:	8b 15 04 0b 00 00    	mov    0xb04,%edx
      if((p = morecore(nunits)) == 0)
 6e9:	83 c4 10             	add    $0x10,%esp
 6ec:	85 d2                	test   %edx,%edx
 6ee:	75 c0                	jne    6b0 <malloc+0x40>
        return 0;
  }
}
 6f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 6f3:	31 c0                	xor    %eax,%eax
}
 6f5:	5b                   	pop    %ebx
 6f6:	5e                   	pop    %esi
 6f7:	5f                   	pop    %edi
 6f8:	5d                   	pop    %ebp
 6f9:	c3                   	ret
 6fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 700:	39 cf                	cmp    %ecx,%edi
 702:	74 4c                	je     750 <malloc+0xe0>
        p->s.size -= nunits;
 704:	29 f9                	sub    %edi,%ecx
 706:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 709:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 70c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 70f:	89 15 04 0b 00 00    	mov    %edx,0xb04
}
 715:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 718:	83 c0 08             	add    $0x8,%eax
}
 71b:	5b                   	pop    %ebx
 71c:	5e                   	pop    %esi
 71d:	5f                   	pop    %edi
 71e:	5d                   	pop    %ebp
 71f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 720:	c7 05 04 0b 00 00 08 	movl   $0xb08,0xb04
 727:	0b 00 00 
    base.s.size = 0;
 72a:	b8 08 0b 00 00       	mov    $0xb08,%eax
    base.s.ptr = freep = prevp = &base;
 72f:	c7 05 08 0b 00 00 08 	movl   $0xb08,0xb08
 736:	0b 00 00 
    base.s.size = 0;
 739:	c7 05 0c 0b 00 00 00 	movl   $0x0,0xb0c
 740:	00 00 00 
    if(p->s.size >= nunits){
 743:	e9 54 ff ff ff       	jmp    69c <malloc+0x2c>
 748:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 74f:	90                   	nop
        prevp->s.ptr = p->s.ptr;
 750:	8b 08                	mov    (%eax),%ecx
 752:	89 0a                	mov    %ecx,(%edx)
 754:	eb b9                	jmp    70f <malloc+0x9f>
