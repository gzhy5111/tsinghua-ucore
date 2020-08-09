
obj/__user_divzero.out:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
.text
.globl _start
_start:
    # set ebp for backtrace
    movl $0x0, %ebp
  800020:	bd 00 00 00 00       	mov    $0x0,%ebp

    # move down the esp register
    # since it may cause page fault in backtrace
    subl $0x20, %esp
  800025:	83 ec 20             	sub    $0x20,%esp

    # call user-program function
    call umain
  800028:	e8 92 03 00 00       	call   8003bf <umain>
1:  jmp 1b
  80002d:	eb fe                	jmp    80002d <_start+0xd>

0080002f <__panic>:
#include <stdio.h>
#include <ulib.h>
#include <error.h>

void
__panic(const char *file, int line, const char *fmt, ...) {
  80002f:	55                   	push   %ebp
  800030:	89 e5                	mov    %esp,%ebp
  800032:	83 ec 28             	sub    $0x28,%esp
    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  800035:	8d 45 14             	lea    0x14(%ebp),%eax
  800038:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("user panic at %s:%d:\n    ", file, line);
  80003b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800042:	8b 45 08             	mov    0x8(%ebp),%eax
  800045:	89 44 24 04          	mov    %eax,0x4(%esp)
  800049:	c7 04 24 60 10 80 00 	movl   $0x801060,(%esp)
  800050:	e8 c3 00 00 00       	call   800118 <cprintf>
    vcprintf(fmt, ap);
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	89 44 24 04          	mov    %eax,0x4(%esp)
  80005c:	8b 45 10             	mov    0x10(%ebp),%eax
  80005f:	89 04 24             	mov    %eax,(%esp)
  800062:	e8 7e 00 00 00       	call   8000e5 <vcprintf>
    cprintf("\n");
  800067:	c7 04 24 7a 10 80 00 	movl   $0x80107a,(%esp)
  80006e:	e8 a5 00 00 00       	call   800118 <cprintf>
    va_end(ap);
    exit(-E_PANIC);
  800073:	c7 04 24 f6 ff ff ff 	movl   $0xfffffff6,(%esp)
  80007a:	e8 71 02 00 00       	call   8002f0 <exit>

0080007f <__warn>:
}

void
__warn(const char *file, int line, const char *fmt, ...) {
  80007f:	55                   	push   %ebp
  800080:	89 e5                	mov    %esp,%ebp
  800082:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  800085:	8d 45 14             	lea    0x14(%ebp),%eax
  800088:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("user warning at %s:%d:\n    ", file, line);
  80008b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80008e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800092:	8b 45 08             	mov    0x8(%ebp),%eax
  800095:	89 44 24 04          	mov    %eax,0x4(%esp)
  800099:	c7 04 24 7c 10 80 00 	movl   $0x80107c,(%esp)
  8000a0:	e8 73 00 00 00       	call   800118 <cprintf>
    vcprintf(fmt, ap);
  8000a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8000af:	89 04 24             	mov    %eax,(%esp)
  8000b2:	e8 2e 00 00 00       	call   8000e5 <vcprintf>
    cprintf("\n");
  8000b7:	c7 04 24 7a 10 80 00 	movl   $0x80107a,(%esp)
  8000be:	e8 55 00 00 00       	call   800118 <cprintf>
    va_end(ap);
}
  8000c3:	c9                   	leave  
  8000c4:	c3                   	ret    

008000c5 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  8000c5:	55                   	push   %ebp
  8000c6:	89 e5                	mov    %esp,%ebp
  8000c8:	83 ec 18             	sub    $0x18,%esp
    sys_putc(c);
  8000cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8000ce:	89 04 24             	mov    %eax,(%esp)
  8000d1:	e8 a1 01 00 00       	call   800277 <sys_putc>
    (*cnt) ++;
  8000d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000d9:	8b 00                	mov    (%eax),%eax
  8000db:	8d 50 01             	lea    0x1(%eax),%edx
  8000de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000e1:	89 10                	mov    %edx,(%eax)
}
  8000e3:	c9                   	leave  
  8000e4:	c3                   	ret    

008000e5 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  8000e5:	55                   	push   %ebp
  8000e6:	89 e5                	mov    %esp,%ebp
  8000e8:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  8000eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  8000f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8000fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800100:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800103:	89 44 24 04          	mov    %eax,0x4(%esp)
  800107:	c7 04 24 c5 00 80 00 	movl   $0x8000c5,(%esp)
  80010e:	e8 b3 04 00 00       	call   8005c6 <vprintfmt>
    return cnt;
  800113:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800116:	c9                   	leave  
  800117:	c3                   	ret    

00800118 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  800118:	55                   	push   %ebp
  800119:	89 e5                	mov    %esp,%ebp
  80011b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  80011e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800121:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int cnt = vcprintf(fmt, ap);
  800124:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800127:	89 44 24 04          	mov    %eax,0x4(%esp)
  80012b:	8b 45 08             	mov    0x8(%ebp),%eax
  80012e:	89 04 24             	mov    %eax,(%esp)
  800131:	e8 af ff ff ff       	call   8000e5 <vcprintf>
  800136:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);

    return cnt;
  800139:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80013c:	c9                   	leave  
  80013d:	c3                   	ret    

0080013e <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  80013e:	55                   	push   %ebp
  80013f:	89 e5                	mov    %esp,%ebp
  800141:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  800144:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  80014b:	eb 13                	jmp    800160 <cputs+0x22>
        cputch(c, &cnt);
  80014d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800151:	8d 55 f0             	lea    -0x10(%ebp),%edx
  800154:	89 54 24 04          	mov    %edx,0x4(%esp)
  800158:	89 04 24             	mov    %eax,(%esp)
  80015b:	e8 65 ff ff ff       	call   8000c5 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  800160:	8b 45 08             	mov    0x8(%ebp),%eax
  800163:	8d 50 01             	lea    0x1(%eax),%edx
  800166:	89 55 08             	mov    %edx,0x8(%ebp)
  800169:	0f b6 00             	movzbl (%eax),%eax
  80016c:	88 45 f7             	mov    %al,-0x9(%ebp)
  80016f:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800173:	75 d8                	jne    80014d <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  800175:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800178:	89 44 24 04          	mov    %eax,0x4(%esp)
  80017c:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800183:	e8 3d ff ff ff       	call   8000c5 <cputch>
    return cnt;
  800188:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80018b:	c9                   	leave  
  80018c:	c3                   	ret    

0080018d <syscall>:
#include <syscall.h>

#define MAX_ARGS            5

static inline int
syscall(int num, ...) {
  80018d:	55                   	push   %ebp
  80018e:	89 e5                	mov    %esp,%ebp
  800190:	57                   	push   %edi
  800191:	56                   	push   %esi
  800192:	53                   	push   %ebx
  800193:	83 ec 20             	sub    $0x20,%esp
    va_list ap;
    va_start(ap, num);
  800196:	8d 45 0c             	lea    0xc(%ebp),%eax
  800199:	89 45 e8             	mov    %eax,-0x18(%ebp)
    uint32_t a[MAX_ARGS];
    int i, ret;
    for (i = 0; i < MAX_ARGS; i ++) {
  80019c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001a3:	eb 16                	jmp    8001bb <syscall+0x2e>
        a[i] = va_arg(ap, uint32_t);
  8001a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001a8:	8d 50 04             	lea    0x4(%eax),%edx
  8001ab:	89 55 e8             	mov    %edx,-0x18(%ebp)
  8001ae:	8b 10                	mov    (%eax),%edx
  8001b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001b3:	89 54 85 d4          	mov    %edx,-0x2c(%ebp,%eax,4)
syscall(int num, ...) {
    va_list ap;
    va_start(ap, num);
    uint32_t a[MAX_ARGS];
    int i, ret;
    for (i = 0; i < MAX_ARGS; i ++) {
  8001b7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  8001bb:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
  8001bf:	7e e4                	jle    8001a5 <syscall+0x18>
    asm volatile (
        "int %1;"
        : "=a" (ret)
        : "i" (T_SYSCALL),
          "a" (num),
          "d" (a[0]),
  8001c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
          "c" (a[1]),
  8001c4:	8b 4d d8             	mov    -0x28(%ebp),%ecx
          "b" (a[2]),
  8001c7:	8b 5d dc             	mov    -0x24(%ebp),%ebx
          "D" (a[3]),
  8001ca:	8b 7d e0             	mov    -0x20(%ebp),%edi
          "S" (a[4])
  8001cd:	8b 75 e4             	mov    -0x1c(%ebp),%esi
    for (i = 0; i < MAX_ARGS; i ++) {
        a[i] = va_arg(ap, uint32_t);
    }
    va_end(ap);

    asm volatile (
  8001d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d3:	cd 80                	int    $0x80
  8001d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
          "c" (a[1]),
          "b" (a[2]),
          "D" (a[3]),
          "S" (a[4])
        : "cc", "memory");
    return ret;
  8001d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8001db:	83 c4 20             	add    $0x20,%esp
  8001de:	5b                   	pop    %ebx
  8001df:	5e                   	pop    %esi
  8001e0:	5f                   	pop    %edi
  8001e1:	5d                   	pop    %ebp
  8001e2:	c3                   	ret    

008001e3 <sys_exit>:

int
sys_exit(int error_code) {
  8001e3:	55                   	push   %ebp
  8001e4:	89 e5                	mov    %esp,%ebp
  8001e6:	83 ec 08             	sub    $0x8,%esp
    return syscall(SYS_exit, error_code);
  8001e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001f7:	e8 91 ff ff ff       	call   80018d <syscall>
}
  8001fc:	c9                   	leave  
  8001fd:	c3                   	ret    

008001fe <sys_fork>:

int
sys_fork(void) {
  8001fe:	55                   	push   %ebp
  8001ff:	89 e5                	mov    %esp,%ebp
  800201:	83 ec 04             	sub    $0x4,%esp
    return syscall(SYS_fork);
  800204:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80020b:	e8 7d ff ff ff       	call   80018d <syscall>
}
  800210:	c9                   	leave  
  800211:	c3                   	ret    

00800212 <sys_wait>:

int
sys_wait(int pid, int *store) {
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	83 ec 0c             	sub    $0xc,%esp
    return syscall(SYS_wait, pid, store);
  800218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80021b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80021f:	8b 45 08             	mov    0x8(%ebp),%eax
  800222:	89 44 24 04          	mov    %eax,0x4(%esp)
  800226:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  80022d:	e8 5b ff ff ff       	call   80018d <syscall>
}
  800232:	c9                   	leave  
  800233:	c3                   	ret    

00800234 <sys_yield>:

int
sys_yield(void) {
  800234:	55                   	push   %ebp
  800235:	89 e5                	mov    %esp,%ebp
  800237:	83 ec 04             	sub    $0x4,%esp
    return syscall(SYS_yield);
  80023a:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800241:	e8 47 ff ff ff       	call   80018d <syscall>
}
  800246:	c9                   	leave  
  800247:	c3                   	ret    

00800248 <sys_kill>:

int
sys_kill(int pid) {
  800248:	55                   	push   %ebp
  800249:	89 e5                	mov    %esp,%ebp
  80024b:	83 ec 08             	sub    $0x8,%esp
    return syscall(SYS_kill, pid);
  80024e:	8b 45 08             	mov    0x8(%ebp),%eax
  800251:	89 44 24 04          	mov    %eax,0x4(%esp)
  800255:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
  80025c:	e8 2c ff ff ff       	call   80018d <syscall>
}
  800261:	c9                   	leave  
  800262:	c3                   	ret    

00800263 <sys_getpid>:

int
sys_getpid(void) {
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	83 ec 04             	sub    $0x4,%esp
    return syscall(SYS_getpid);
  800269:	c7 04 24 12 00 00 00 	movl   $0x12,(%esp)
  800270:	e8 18 ff ff ff       	call   80018d <syscall>
}
  800275:	c9                   	leave  
  800276:	c3                   	ret    

00800277 <sys_putc>:

int
sys_putc(int c) {
  800277:	55                   	push   %ebp
  800278:	89 e5                	mov    %esp,%ebp
  80027a:	83 ec 08             	sub    $0x8,%esp
    return syscall(SYS_putc, c);
  80027d:	8b 45 08             	mov    0x8(%ebp),%eax
  800280:	89 44 24 04          	mov    %eax,0x4(%esp)
  800284:	c7 04 24 1e 00 00 00 	movl   $0x1e,(%esp)
  80028b:	e8 fd fe ff ff       	call   80018d <syscall>
}
  800290:	c9                   	leave  
  800291:	c3                   	ret    

00800292 <sys_pgdir>:

int
sys_pgdir(void) {
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  800295:	83 ec 04             	sub    $0x4,%esp
    return syscall(SYS_pgdir);
  800298:	c7 04 24 1f 00 00 00 	movl   $0x1f,(%esp)
  80029f:	e8 e9 fe ff ff       	call   80018d <syscall>
}
  8002a4:	c9                   	leave  
  8002a5:	c3                   	ret    

008002a6 <sys_gettime>:

int
sys_gettime(void) {
  8002a6:	55                   	push   %ebp
  8002a7:	89 e5                	mov    %esp,%ebp
  8002a9:	83 ec 04             	sub    $0x4,%esp
    return syscall(SYS_gettime);
  8002ac:	c7 04 24 11 00 00 00 	movl   $0x11,(%esp)
  8002b3:	e8 d5 fe ff ff       	call   80018d <syscall>
}
  8002b8:	c9                   	leave  
  8002b9:	c3                   	ret    

008002ba <sys_lab6_set_priority>:

void
sys_lab6_set_priority(uint32_t priority)
{
  8002ba:	55                   	push   %ebp
  8002bb:	89 e5                	mov    %esp,%ebp
  8002bd:	83 ec 08             	sub    $0x8,%esp
    syscall(SYS_lab6_set_priority, priority);
  8002c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002c7:	c7 04 24 ff 00 00 00 	movl   $0xff,(%esp)
  8002ce:	e8 ba fe ff ff       	call   80018d <syscall>
}
  8002d3:	c9                   	leave  
  8002d4:	c3                   	ret    

008002d5 <sys_sleep>:

int
sys_sleep(unsigned int time) {
  8002d5:	55                   	push   %ebp
  8002d6:	89 e5                	mov    %esp,%ebp
  8002d8:	83 ec 08             	sub    $0x8,%esp
    return syscall(SYS_sleep, time);
  8002db:	8b 45 08             	mov    0x8(%ebp),%eax
  8002de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002e2:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
  8002e9:	e8 9f fe ff ff       	call   80018d <syscall>
}
  8002ee:	c9                   	leave  
  8002ef:	c3                   	ret    

008002f0 <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	83 ec 18             	sub    $0x18,%esp
    sys_exit(error_code);
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	89 04 24             	mov    %eax,(%esp)
  8002fc:	e8 e2 fe ff ff       	call   8001e3 <sys_exit>
    cprintf("BUG: exit failed.\n");
  800301:	c7 04 24 98 10 80 00 	movl   $0x801098,(%esp)
  800308:	e8 0b fe ff ff       	call   800118 <cprintf>
    while (1);
  80030d:	eb fe                	jmp    80030d <exit+0x1d>

0080030f <fork>:
}

int
fork(void) {
  80030f:	55                   	push   %ebp
  800310:	89 e5                	mov    %esp,%ebp
  800312:	83 ec 08             	sub    $0x8,%esp
    return sys_fork();
  800315:	e8 e4 fe ff ff       	call   8001fe <sys_fork>
}
  80031a:	c9                   	leave  
  80031b:	c3                   	ret    

0080031c <wait>:

int
wait(void) {
  80031c:	55                   	push   %ebp
  80031d:	89 e5                	mov    %esp,%ebp
  80031f:	83 ec 18             	sub    $0x18,%esp
    return sys_wait(0, NULL);
  800322:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800329:	00 
  80032a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800331:	e8 dc fe ff ff       	call   800212 <sys_wait>
}
  800336:	c9                   	leave  
  800337:	c3                   	ret    

00800338 <waitpid>:

int
waitpid(int pid, int *store) {
  800338:	55                   	push   %ebp
  800339:	89 e5                	mov    %esp,%ebp
  80033b:	83 ec 18             	sub    $0x18,%esp
    return sys_wait(pid, store);
  80033e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800341:	89 44 24 04          	mov    %eax,0x4(%esp)
  800345:	8b 45 08             	mov    0x8(%ebp),%eax
  800348:	89 04 24             	mov    %eax,(%esp)
  80034b:	e8 c2 fe ff ff       	call   800212 <sys_wait>
}
  800350:	c9                   	leave  
  800351:	c3                   	ret    

00800352 <yield>:

void
yield(void) {
  800352:	55                   	push   %ebp
  800353:	89 e5                	mov    %esp,%ebp
  800355:	83 ec 08             	sub    $0x8,%esp
    sys_yield();
  800358:	e8 d7 fe ff ff       	call   800234 <sys_yield>
}
  80035d:	c9                   	leave  
  80035e:	c3                   	ret    

0080035f <kill>:

int
kill(int pid) {
  80035f:	55                   	push   %ebp
  800360:	89 e5                	mov    %esp,%ebp
  800362:	83 ec 18             	sub    $0x18,%esp
    return sys_kill(pid);
  800365:	8b 45 08             	mov    0x8(%ebp),%eax
  800368:	89 04 24             	mov    %eax,(%esp)
  80036b:	e8 d8 fe ff ff       	call   800248 <sys_kill>
}
  800370:	c9                   	leave  
  800371:	c3                   	ret    

00800372 <getpid>:

int
getpid(void) {
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	83 ec 08             	sub    $0x8,%esp
    return sys_getpid();
  800378:	e8 e6 fe ff ff       	call   800263 <sys_getpid>
}
  80037d:	c9                   	leave  
  80037e:	c3                   	ret    

0080037f <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	83 ec 08             	sub    $0x8,%esp
    sys_pgdir();
  800385:	e8 08 ff ff ff       	call   800292 <sys_pgdir>
}
  80038a:	c9                   	leave  
  80038b:	c3                   	ret    

0080038c <gettime_msec>:

unsigned int
gettime_msec(void) {
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	83 ec 08             	sub    $0x8,%esp
    return (unsigned int)sys_gettime();
  800392:	e8 0f ff ff ff       	call   8002a6 <sys_gettime>
}
  800397:	c9                   	leave  
  800398:	c3                   	ret    

00800399 <lab6_set_priority>:

void
lab6_set_priority(uint32_t priority)
{
  800399:	55                   	push   %ebp
  80039a:	89 e5                	mov    %esp,%ebp
  80039c:	83 ec 18             	sub    $0x18,%esp
    sys_lab6_set_priority(priority);
  80039f:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a2:	89 04 24             	mov    %eax,(%esp)
  8003a5:	e8 10 ff ff ff       	call   8002ba <sys_lab6_set_priority>
}
  8003aa:	c9                   	leave  
  8003ab:	c3                   	ret    

008003ac <sleep>:

int
sleep(unsigned int time) {
  8003ac:	55                   	push   %ebp
  8003ad:	89 e5                	mov    %esp,%ebp
  8003af:	83 ec 18             	sub    $0x18,%esp
    return sys_sleep(time);
  8003b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b5:	89 04 24             	mov    %eax,(%esp)
  8003b8:	e8 18 ff ff ff       	call   8002d5 <sys_sleep>
}
  8003bd:	c9                   	leave  
  8003be:	c3                   	ret    

008003bf <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
  8003c2:	83 ec 28             	sub    $0x28,%esp
    int ret = main();
  8003c5:	e8 44 0c 00 00       	call   80100e <main>
  8003ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    exit(ret);
  8003cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003d0:	89 04 24             	mov    %eax,(%esp)
  8003d3:	e8 18 ff ff ff       	call   8002f0 <exit>

008003d8 <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
  8003de:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e1:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
  8003e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return (hash >> (32 - bits));
  8003ea:	b8 20 00 00 00       	mov    $0x20,%eax
  8003ef:	2b 45 0c             	sub    0xc(%ebp),%eax
  8003f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8003f5:	89 c1                	mov    %eax,%ecx
  8003f7:	d3 ea                	shr    %cl,%edx
  8003f9:	89 d0                	mov    %edx,%eax
}
  8003fb:	c9                   	leave  
  8003fc:	c3                   	ret    

008003fd <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  8003fd:	55                   	push   %ebp
  8003fe:	89 e5                	mov    %esp,%ebp
  800400:	83 ec 58             	sub    $0x58,%esp
  800403:	8b 45 10             	mov    0x10(%ebp),%eax
  800406:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800409:	8b 45 14             	mov    0x14(%ebp),%eax
  80040c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  80040f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800412:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800415:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800418:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  80041b:	8b 45 18             	mov    0x18(%ebp),%eax
  80041e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800421:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800424:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800427:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80042a:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80042d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800430:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800433:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800437:	74 1c                	je     800455 <printnum+0x58>
  800439:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80043c:	ba 00 00 00 00       	mov    $0x0,%edx
  800441:	f7 75 e4             	divl   -0x1c(%ebp)
  800444:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800447:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80044a:	ba 00 00 00 00       	mov    $0x0,%edx
  80044f:	f7 75 e4             	divl   -0x1c(%ebp)
  800452:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800455:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800458:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80045b:	f7 75 e4             	divl   -0x1c(%ebp)
  80045e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800461:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800464:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800467:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80046a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80046d:	89 55 ec             	mov    %edx,-0x14(%ebp)
  800470:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800473:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  800476:	8b 45 18             	mov    0x18(%ebp),%eax
  800479:	ba 00 00 00 00       	mov    $0x0,%edx
  80047e:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  800481:	77 56                	ja     8004d9 <printnum+0xdc>
  800483:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  800486:	72 05                	jb     80048d <printnum+0x90>
  800488:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80048b:	77 4c                	ja     8004d9 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  80048d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800490:	8d 50 ff             	lea    -0x1(%eax),%edx
  800493:	8b 45 20             	mov    0x20(%ebp),%eax
  800496:	89 44 24 18          	mov    %eax,0x18(%esp)
  80049a:	89 54 24 14          	mov    %edx,0x14(%esp)
  80049e:	8b 45 18             	mov    0x18(%ebp),%eax
  8004a1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8004a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004ab:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004af:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bd:	89 04 24             	mov    %eax,(%esp)
  8004c0:	e8 38 ff ff ff       	call   8003fd <printnum>
  8004c5:	eb 1c                	jmp    8004e3 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  8004c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004ce:	8b 45 20             	mov    0x20(%ebp),%eax
  8004d1:	89 04 24             	mov    %eax,(%esp)
  8004d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d7:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  8004d9:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  8004dd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8004e1:	7f e4                	jg     8004c7 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  8004e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004e6:	05 c4 11 80 00       	add    $0x8011c4,%eax
  8004eb:	0f b6 00             	movzbl (%eax),%eax
  8004ee:	0f be c0             	movsbl %al,%eax
  8004f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f4:	89 54 24 04          	mov    %edx,0x4(%esp)
  8004f8:	89 04 24             	mov    %eax,(%esp)
  8004fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fe:	ff d0                	call   *%eax
}
  800500:	c9                   	leave  
  800501:	c3                   	ret    

00800502 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  800502:	55                   	push   %ebp
  800503:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  800505:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800509:	7e 14                	jle    80051f <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  80050b:	8b 45 08             	mov    0x8(%ebp),%eax
  80050e:	8b 00                	mov    (%eax),%eax
  800510:	8d 48 08             	lea    0x8(%eax),%ecx
  800513:	8b 55 08             	mov    0x8(%ebp),%edx
  800516:	89 0a                	mov    %ecx,(%edx)
  800518:	8b 50 04             	mov    0x4(%eax),%edx
  80051b:	8b 00                	mov    (%eax),%eax
  80051d:	eb 30                	jmp    80054f <getuint+0x4d>
    }
    else if (lflag) {
  80051f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800523:	74 16                	je     80053b <getuint+0x39>
        return va_arg(*ap, unsigned long);
  800525:	8b 45 08             	mov    0x8(%ebp),%eax
  800528:	8b 00                	mov    (%eax),%eax
  80052a:	8d 48 04             	lea    0x4(%eax),%ecx
  80052d:	8b 55 08             	mov    0x8(%ebp),%edx
  800530:	89 0a                	mov    %ecx,(%edx)
  800532:	8b 00                	mov    (%eax),%eax
  800534:	ba 00 00 00 00       	mov    $0x0,%edx
  800539:	eb 14                	jmp    80054f <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	8d 48 04             	lea    0x4(%eax),%ecx
  800543:	8b 55 08             	mov    0x8(%ebp),%edx
  800546:	89 0a                	mov    %ecx,(%edx)
  800548:	8b 00                	mov    (%eax),%eax
  80054a:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  80054f:	5d                   	pop    %ebp
  800550:	c3                   	ret    

00800551 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  800551:	55                   	push   %ebp
  800552:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  800554:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800558:	7e 14                	jle    80056e <getint+0x1d>
        return va_arg(*ap, long long);
  80055a:	8b 45 08             	mov    0x8(%ebp),%eax
  80055d:	8b 00                	mov    (%eax),%eax
  80055f:	8d 48 08             	lea    0x8(%eax),%ecx
  800562:	8b 55 08             	mov    0x8(%ebp),%edx
  800565:	89 0a                	mov    %ecx,(%edx)
  800567:	8b 50 04             	mov    0x4(%eax),%edx
  80056a:	8b 00                	mov    (%eax),%eax
  80056c:	eb 28                	jmp    800596 <getint+0x45>
    }
    else if (lflag) {
  80056e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800572:	74 12                	je     800586 <getint+0x35>
        return va_arg(*ap, long);
  800574:	8b 45 08             	mov    0x8(%ebp),%eax
  800577:	8b 00                	mov    (%eax),%eax
  800579:	8d 48 04             	lea    0x4(%eax),%ecx
  80057c:	8b 55 08             	mov    0x8(%ebp),%edx
  80057f:	89 0a                	mov    %ecx,(%edx)
  800581:	8b 00                	mov    (%eax),%eax
  800583:	99                   	cltd   
  800584:	eb 10                	jmp    800596 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  800586:	8b 45 08             	mov    0x8(%ebp),%eax
  800589:	8b 00                	mov    (%eax),%eax
  80058b:	8d 48 04             	lea    0x4(%eax),%ecx
  80058e:	8b 55 08             	mov    0x8(%ebp),%edx
  800591:	89 0a                	mov    %ecx,(%edx)
  800593:	8b 00                	mov    (%eax),%eax
  800595:	99                   	cltd   
    }
}
  800596:	5d                   	pop    %ebp
  800597:	c3                   	ret    

00800598 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  800598:	55                   	push   %ebp
  800599:	89 e5                	mov    %esp,%ebp
  80059b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  80059e:	8d 45 14             	lea    0x14(%ebp),%eax
  8005a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  8005a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ae:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bc:	89 04 24             	mov    %eax,(%esp)
  8005bf:	e8 02 00 00 00       	call   8005c6 <vprintfmt>
    va_end(ap);
}
  8005c4:	c9                   	leave  
  8005c5:	c3                   	ret    

008005c6 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  8005c6:	55                   	push   %ebp
  8005c7:	89 e5                	mov    %esp,%ebp
  8005c9:	56                   	push   %esi
  8005ca:	53                   	push   %ebx
  8005cb:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8005ce:	eb 18                	jmp    8005e8 <vprintfmt+0x22>
            if (ch == '\0') {
  8005d0:	85 db                	test   %ebx,%ebx
  8005d2:	75 05                	jne    8005d9 <vprintfmt+0x13>
                return;
  8005d4:	e9 d1 03 00 00       	jmp    8009aa <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  8005d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005e0:	89 1c 24             	mov    %ebx,(%esp)
  8005e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e6:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8005e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8005eb:	8d 50 01             	lea    0x1(%eax),%edx
  8005ee:	89 55 10             	mov    %edx,0x10(%ebp)
  8005f1:	0f b6 00             	movzbl (%eax),%eax
  8005f4:	0f b6 d8             	movzbl %al,%ebx
  8005f7:	83 fb 25             	cmp    $0x25,%ebx
  8005fa:	75 d4                	jne    8005d0 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  8005fc:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  800600:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80060a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  80060d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800614:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800617:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  80061a:	8b 45 10             	mov    0x10(%ebp),%eax
  80061d:	8d 50 01             	lea    0x1(%eax),%edx
  800620:	89 55 10             	mov    %edx,0x10(%ebp)
  800623:	0f b6 00             	movzbl (%eax),%eax
  800626:	0f b6 d8             	movzbl %al,%ebx
  800629:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80062c:	83 f8 55             	cmp    $0x55,%eax
  80062f:	0f 87 44 03 00 00    	ja     800979 <vprintfmt+0x3b3>
  800635:	8b 04 85 e8 11 80 00 	mov    0x8011e8(,%eax,4),%eax
  80063c:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  80063e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  800642:	eb d6                	jmp    80061a <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  800644:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  800648:	eb d0                	jmp    80061a <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  80064a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  800651:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800654:	89 d0                	mov    %edx,%eax
  800656:	c1 e0 02             	shl    $0x2,%eax
  800659:	01 d0                	add    %edx,%eax
  80065b:	01 c0                	add    %eax,%eax
  80065d:	01 d8                	add    %ebx,%eax
  80065f:	83 e8 30             	sub    $0x30,%eax
  800662:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  800665:	8b 45 10             	mov    0x10(%ebp),%eax
  800668:	0f b6 00             	movzbl (%eax),%eax
  80066b:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  80066e:	83 fb 2f             	cmp    $0x2f,%ebx
  800671:	7e 0b                	jle    80067e <vprintfmt+0xb8>
  800673:	83 fb 39             	cmp    $0x39,%ebx
  800676:	7f 06                	jg     80067e <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  800678:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  80067c:	eb d3                	jmp    800651 <vprintfmt+0x8b>
            goto process_precision;
  80067e:	eb 33                	jmp    8006b3 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	8d 50 04             	lea    0x4(%eax),%edx
  800686:	89 55 14             	mov    %edx,0x14(%ebp)
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  80068e:	eb 23                	jmp    8006b3 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  800690:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800694:	79 0c                	jns    8006a2 <vprintfmt+0xdc>
                width = 0;
  800696:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  80069d:	e9 78 ff ff ff       	jmp    80061a <vprintfmt+0x54>
  8006a2:	e9 73 ff ff ff       	jmp    80061a <vprintfmt+0x54>

        case '#':
            altflag = 1;
  8006a7:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  8006ae:	e9 67 ff ff ff       	jmp    80061a <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  8006b3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8006b7:	79 12                	jns    8006cb <vprintfmt+0x105>
                width = precision, precision = -1;
  8006b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8006bf:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  8006c6:	e9 4f ff ff ff       	jmp    80061a <vprintfmt+0x54>
  8006cb:	e9 4a ff ff ff       	jmp    80061a <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  8006d0:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  8006d4:	e9 41 ff ff ff       	jmp    80061a <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  8006d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dc:	8d 50 04             	lea    0x4(%eax),%edx
  8006df:	89 55 14             	mov    %edx,0x14(%ebp)
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006e7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006eb:	89 04 24             	mov    %eax,(%esp)
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	ff d0                	call   *%eax
            break;
  8006f3:	e9 ac 02 00 00       	jmp    8009a4 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  8006f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fb:	8d 50 04             	lea    0x4(%eax),%edx
  8006fe:	89 55 14             	mov    %edx,0x14(%ebp)
  800701:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  800703:	85 db                	test   %ebx,%ebx
  800705:	79 02                	jns    800709 <vprintfmt+0x143>
                err = -err;
  800707:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800709:	83 fb 18             	cmp    $0x18,%ebx
  80070c:	7f 0b                	jg     800719 <vprintfmt+0x153>
  80070e:	8b 34 9d 60 11 80 00 	mov    0x801160(,%ebx,4),%esi
  800715:	85 f6                	test   %esi,%esi
  800717:	75 23                	jne    80073c <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  800719:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80071d:	c7 44 24 08 d5 11 80 	movl   $0x8011d5,0x8(%esp)
  800724:	00 
  800725:	8b 45 0c             	mov    0xc(%ebp),%eax
  800728:	89 44 24 04          	mov    %eax,0x4(%esp)
  80072c:	8b 45 08             	mov    0x8(%ebp),%eax
  80072f:	89 04 24             	mov    %eax,(%esp)
  800732:	e8 61 fe ff ff       	call   800598 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  800737:	e9 68 02 00 00       	jmp    8009a4 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  80073c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800740:	c7 44 24 08 de 11 80 	movl   $0x8011de,0x8(%esp)
  800747:	00 
  800748:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	89 04 24             	mov    %eax,(%esp)
  800755:	e8 3e fe ff ff       	call   800598 <printfmt>
            }
            break;
  80075a:	e9 45 02 00 00       	jmp    8009a4 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	8d 50 04             	lea    0x4(%eax),%edx
  800765:	89 55 14             	mov    %edx,0x14(%ebp)
  800768:	8b 30                	mov    (%eax),%esi
  80076a:	85 f6                	test   %esi,%esi
  80076c:	75 05                	jne    800773 <vprintfmt+0x1ad>
                p = "(null)";
  80076e:	be e1 11 80 00       	mov    $0x8011e1,%esi
            }
            if (width > 0 && padc != '-') {
  800773:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800777:	7e 3e                	jle    8007b7 <vprintfmt+0x1f1>
  800779:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80077d:	74 38                	je     8007b7 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  80077f:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800782:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800785:	89 44 24 04          	mov    %eax,0x4(%esp)
  800789:	89 34 24             	mov    %esi,(%esp)
  80078c:	e8 ed 03 00 00       	call   800b7e <strnlen>
  800791:	29 c3                	sub    %eax,%ebx
  800793:	89 d8                	mov    %ebx,%eax
  800795:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800798:	eb 17                	jmp    8007b1 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  80079a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80079e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007a5:	89 04 24             	mov    %eax,(%esp)
  8007a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ab:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  8007ad:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  8007b1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8007b5:	7f e3                	jg     80079a <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8007b7:	eb 38                	jmp    8007f1 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  8007b9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007bd:	74 1f                	je     8007de <vprintfmt+0x218>
  8007bf:	83 fb 1f             	cmp    $0x1f,%ebx
  8007c2:	7e 05                	jle    8007c9 <vprintfmt+0x203>
  8007c4:	83 fb 7e             	cmp    $0x7e,%ebx
  8007c7:	7e 15                	jle    8007de <vprintfmt+0x218>
                    putch('?', putdat);
  8007c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007d0:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8007d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007da:	ff d0                	call   *%eax
  8007dc:	eb 0f                	jmp    8007ed <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  8007de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007e5:	89 1c 24             	mov    %ebx,(%esp)
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8007ed:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  8007f1:	89 f0                	mov    %esi,%eax
  8007f3:	8d 70 01             	lea    0x1(%eax),%esi
  8007f6:	0f b6 00             	movzbl (%eax),%eax
  8007f9:	0f be d8             	movsbl %al,%ebx
  8007fc:	85 db                	test   %ebx,%ebx
  8007fe:	74 10                	je     800810 <vprintfmt+0x24a>
  800800:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800804:	78 b3                	js     8007b9 <vprintfmt+0x1f3>
  800806:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80080a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080e:	79 a9                	jns    8007b9 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  800810:	eb 17                	jmp    800829 <vprintfmt+0x263>
                putch(' ', putdat);
  800812:	8b 45 0c             	mov    0xc(%ebp),%eax
  800815:	89 44 24 04          	mov    %eax,0x4(%esp)
  800819:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800820:	8b 45 08             	mov    0x8(%ebp),%eax
  800823:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  800825:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  800829:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80082d:	7f e3                	jg     800812 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  80082f:	e9 70 01 00 00       	jmp    8009a4 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  800834:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800837:	89 44 24 04          	mov    %eax,0x4(%esp)
  80083b:	8d 45 14             	lea    0x14(%ebp),%eax
  80083e:	89 04 24             	mov    %eax,(%esp)
  800841:	e8 0b fd ff ff       	call   800551 <getint>
  800846:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800849:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  80084c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800852:	85 d2                	test   %edx,%edx
  800854:	79 26                	jns    80087c <vprintfmt+0x2b6>
                putch('-', putdat);
  800856:	8b 45 0c             	mov    0xc(%ebp),%eax
  800859:	89 44 24 04          	mov    %eax,0x4(%esp)
  80085d:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800864:	8b 45 08             	mov    0x8(%ebp),%eax
  800867:	ff d0                	call   *%eax
                num = -(long long)num;
  800869:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80086f:	f7 d8                	neg    %eax
  800871:	83 d2 00             	adc    $0x0,%edx
  800874:	f7 da                	neg    %edx
  800876:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800879:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  80087c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  800883:	e9 a8 00 00 00       	jmp    800930 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  800888:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80088b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80088f:	8d 45 14             	lea    0x14(%ebp),%eax
  800892:	89 04 24             	mov    %eax,(%esp)
  800895:	e8 68 fc ff ff       	call   800502 <getuint>
  80089a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80089d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  8008a0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  8008a7:	e9 84 00 00 00       	jmp    800930 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  8008ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008b3:	8d 45 14             	lea    0x14(%ebp),%eax
  8008b6:	89 04 24             	mov    %eax,(%esp)
  8008b9:	e8 44 fc ff ff       	call   800502 <getuint>
  8008be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  8008c4:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  8008cb:	eb 63                	jmp    800930 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  8008cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008d4:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	ff d0                	call   *%eax
            putch('x', putdat);
  8008e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008e7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  8008f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f6:	8d 50 04             	lea    0x4(%eax),%edx
  8008f9:	89 55 14             	mov    %edx,0x14(%ebp)
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800901:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  800908:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  80090f:	eb 1f                	jmp    800930 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  800911:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800914:	89 44 24 04          	mov    %eax,0x4(%esp)
  800918:	8d 45 14             	lea    0x14(%ebp),%eax
  80091b:	89 04 24             	mov    %eax,(%esp)
  80091e:	e8 df fb ff ff       	call   800502 <getuint>
  800923:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800926:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  800929:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  800930:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800934:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800937:	89 54 24 18          	mov    %edx,0x18(%esp)
  80093b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80093e:	89 54 24 14          	mov    %edx,0x14(%esp)
  800942:	89 44 24 10          	mov    %eax,0x10(%esp)
  800946:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800949:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80094c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800950:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800954:	8b 45 0c             	mov    0xc(%ebp),%eax
  800957:	89 44 24 04          	mov    %eax,0x4(%esp)
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	89 04 24             	mov    %eax,(%esp)
  800961:	e8 97 fa ff ff       	call   8003fd <printnum>
            break;
  800966:	eb 3c                	jmp    8009a4 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  800968:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80096f:	89 1c 24             	mov    %ebx,(%esp)
  800972:	8b 45 08             	mov    0x8(%ebp),%eax
  800975:	ff d0                	call   *%eax
            break;
  800977:	eb 2b                	jmp    8009a4 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  800979:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800980:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800987:	8b 45 08             	mov    0x8(%ebp),%eax
  80098a:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  80098c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800990:	eb 04                	jmp    800996 <vprintfmt+0x3d0>
  800992:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800996:	8b 45 10             	mov    0x10(%ebp),%eax
  800999:	83 e8 01             	sub    $0x1,%eax
  80099c:	0f b6 00             	movzbl (%eax),%eax
  80099f:	3c 25                	cmp    $0x25,%al
  8009a1:	75 ef                	jne    800992 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  8009a3:	90                   	nop
        }
    }
  8009a4:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8009a5:	e9 3e fc ff ff       	jmp    8005e8 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  8009aa:	83 c4 40             	add    $0x40,%esp
  8009ad:	5b                   	pop    %ebx
  8009ae:	5e                   	pop    %esi
  8009af:	5d                   	pop    %ebp
  8009b0:	c3                   	ret    

008009b1 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  8009b1:	55                   	push   %ebp
  8009b2:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  8009b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b7:	8b 40 08             	mov    0x8(%eax),%eax
  8009ba:	8d 50 01             	lea    0x1(%eax),%edx
  8009bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c0:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  8009c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c6:	8b 10                	mov    (%eax),%edx
  8009c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cb:	8b 40 04             	mov    0x4(%eax),%eax
  8009ce:	39 c2                	cmp    %eax,%edx
  8009d0:	73 12                	jae    8009e4 <sprintputch+0x33>
        *b->buf ++ = ch;
  8009d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d5:	8b 00                	mov    (%eax),%eax
  8009d7:	8d 48 01             	lea    0x1(%eax),%ecx
  8009da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009dd:	89 0a                	mov    %ecx,(%edx)
  8009df:	8b 55 08             	mov    0x8(%ebp),%edx
  8009e2:	88 10                	mov    %dl,(%eax)
    }
}
  8009e4:	5d                   	pop    %ebp
  8009e5:	c3                   	ret    

008009e6 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  8009ec:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  8009f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a03:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	89 04 24             	mov    %eax,(%esp)
  800a0d:	e8 08 00 00 00       	call   800a1a <vsnprintf>
  800a12:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  800a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a18:	c9                   	leave  
  800a19:	c3                   	ret    

00800a1a <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a29:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	01 d0                	add    %edx,%eax
  800a31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  800a3b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a3f:	74 0a                	je     800a4b <vsnprintf+0x31>
  800a41:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a47:	39 c2                	cmp    %eax,%edx
  800a49:	76 07                	jbe    800a52 <vsnprintf+0x38>
        return -E_INVAL;
  800a4b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a50:	eb 2a                	jmp    800a7c <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a52:	8b 45 14             	mov    0x14(%ebp),%eax
  800a55:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a59:	8b 45 10             	mov    0x10(%ebp),%eax
  800a5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a60:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a63:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a67:	c7 04 24 b1 09 80 00 	movl   $0x8009b1,(%esp)
  800a6e:	e8 53 fb ff ff       	call   8005c6 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  800a73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a76:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  800a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a7c:	c9                   	leave  
  800a7d:	c3                   	ret    

00800a7e <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
  800a7e:	55                   	push   %ebp
  800a7f:	89 e5                	mov    %esp,%ebp
  800a81:	57                   	push   %edi
  800a82:	56                   	push   %esi
  800a83:	53                   	push   %ebx
  800a84:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
  800a87:	a1 00 20 80 00       	mov    0x802000,%eax
  800a8c:	8b 15 04 20 80 00    	mov    0x802004,%edx
  800a92:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
  800a98:	6b f0 05             	imul   $0x5,%eax,%esi
  800a9b:	01 f7                	add    %esi,%edi
  800a9d:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
  800aa2:	f7 e6                	mul    %esi
  800aa4:	8d 34 17             	lea    (%edi,%edx,1),%esi
  800aa7:	89 f2                	mov    %esi,%edx
  800aa9:	83 c0 0b             	add    $0xb,%eax
  800aac:	83 d2 00             	adc    $0x0,%edx
  800aaf:	89 c7                	mov    %eax,%edi
  800ab1:	83 e7 ff             	and    $0xffffffff,%edi
  800ab4:	89 f9                	mov    %edi,%ecx
  800ab6:	0f b7 da             	movzwl %dx,%ebx
  800ab9:	89 0d 00 20 80 00    	mov    %ecx,0x802000
  800abf:	89 1d 04 20 80 00    	mov    %ebx,0x802004
    unsigned long long result = (next >> 12);
  800ac5:	a1 00 20 80 00       	mov    0x802000,%eax
  800aca:	8b 15 04 20 80 00    	mov    0x802004,%edx
  800ad0:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  800ad4:	c1 ea 0c             	shr    $0xc,%edx
  800ad7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ada:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
  800add:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
  800ae4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ae7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800aea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aed:	89 55 e8             	mov    %edx,-0x18(%ebp)
  800af0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800af3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800af6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800afa:	74 1c                	je     800b18 <rand+0x9a>
  800afc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800aff:	ba 00 00 00 00       	mov    $0x0,%edx
  800b04:	f7 75 dc             	divl   -0x24(%ebp)
  800b07:	89 55 ec             	mov    %edx,-0x14(%ebp)
  800b0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b0d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b12:	f7 75 dc             	divl   -0x24(%ebp)
  800b15:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800b18:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b1b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b1e:	f7 75 dc             	divl   -0x24(%ebp)
  800b21:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b24:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800b27:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b2a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b30:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800b33:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
  800b36:	83 c4 24             	add    $0x24,%esp
  800b39:	5b                   	pop    %ebx
  800b3a:	5e                   	pop    %esi
  800b3b:	5f                   	pop    %edi
  800b3c:	5d                   	pop    %ebp
  800b3d:	c3                   	ret    

00800b3e <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
    next = seed;
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	ba 00 00 00 00       	mov    $0x0,%edx
  800b49:	a3 00 20 80 00       	mov    %eax,0x802000
  800b4e:	89 15 04 20 80 00    	mov    %edx,0x802004
}
  800b54:	5d                   	pop    %ebp
  800b55:	c3                   	ret    

00800b56 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  800b5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  800b63:	eb 04                	jmp    800b69 <strlen+0x13>
        cnt ++;
  800b65:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	8d 50 01             	lea    0x1(%eax),%edx
  800b6f:	89 55 08             	mov    %edx,0x8(%ebp)
  800b72:	0f b6 00             	movzbl (%eax),%eax
  800b75:	84 c0                	test   %al,%al
  800b77:	75 ec                	jne    800b65 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  800b79:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b7c:	c9                   	leave  
  800b7d:	c3                   	ret    

00800b7e <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  800b84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  800b8b:	eb 04                	jmp    800b91 <strnlen+0x13>
        cnt ++;
  800b8d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  800b91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b94:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b97:	73 10                	jae    800ba9 <strnlen+0x2b>
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	8d 50 01             	lea    0x1(%eax),%edx
  800b9f:	89 55 08             	mov    %edx,0x8(%ebp)
  800ba2:	0f b6 00             	movzbl (%eax),%eax
  800ba5:	84 c0                	test   %al,%al
  800ba7:	75 e4                	jne    800b8d <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  800ba9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bac:	c9                   	leave  
  800bad:	c3                   	ret    

00800bae <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	57                   	push   %edi
  800bb2:	56                   	push   %esi
  800bb3:	83 ec 20             	sub    $0x20,%esp
  800bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  800bc2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bc8:	89 d1                	mov    %edx,%ecx
  800bca:	89 c2                	mov    %eax,%edx
  800bcc:	89 ce                	mov    %ecx,%esi
  800bce:	89 d7                	mov    %edx,%edi
  800bd0:	ac                   	lods   %ds:(%esi),%al
  800bd1:	aa                   	stos   %al,%es:(%edi)
  800bd2:	84 c0                	test   %al,%al
  800bd4:	75 fa                	jne    800bd0 <strcpy+0x22>
  800bd6:	89 fa                	mov    %edi,%edx
  800bd8:	89 f1                	mov    %esi,%ecx
  800bda:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  800bdd:	89 55 e8             	mov    %edx,-0x18(%ebp)
  800be0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  800be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  800be6:	83 c4 20             	add    $0x20,%esp
  800be9:	5e                   	pop    %esi
  800bea:	5f                   	pop    %edi
  800beb:	5d                   	pop    %ebp
  800bec:	c3                   	ret    

00800bed <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  800bf9:	eb 21                	jmp    800c1c <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  800bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfe:	0f b6 10             	movzbl (%eax),%edx
  800c01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c04:	88 10                	mov    %dl,(%eax)
  800c06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c09:	0f b6 00             	movzbl (%eax),%eax
  800c0c:	84 c0                	test   %al,%al
  800c0e:	74 04                	je     800c14 <strncpy+0x27>
            src ++;
  800c10:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  800c14:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800c18:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  800c1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c20:	75 d9                	jne    800bfb <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c25:	c9                   	leave  
  800c26:	c3                   	ret    

00800c27 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	57                   	push   %edi
  800c2b:	56                   	push   %esi
  800c2c:	83 ec 20             	sub    $0x20,%esp
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800c35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c38:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  800c3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c41:	89 d1                	mov    %edx,%ecx
  800c43:	89 c2                	mov    %eax,%edx
  800c45:	89 ce                	mov    %ecx,%esi
  800c47:	89 d7                	mov    %edx,%edi
  800c49:	ac                   	lods   %ds:(%esi),%al
  800c4a:	ae                   	scas   %es:(%edi),%al
  800c4b:	75 08                	jne    800c55 <strcmp+0x2e>
  800c4d:	84 c0                	test   %al,%al
  800c4f:	75 f8                	jne    800c49 <strcmp+0x22>
  800c51:	31 c0                	xor    %eax,%eax
  800c53:	eb 04                	jmp    800c59 <strcmp+0x32>
  800c55:	19 c0                	sbb    %eax,%eax
  800c57:	0c 01                	or     $0x1,%al
  800c59:	89 fa                	mov    %edi,%edx
  800c5b:	89 f1                	mov    %esi,%ecx
  800c5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c60:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  800c63:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  800c66:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  800c69:	83 c4 20             	add    $0x20,%esp
  800c6c:	5e                   	pop    %esi
  800c6d:	5f                   	pop    %edi
  800c6e:	5d                   	pop    %ebp
  800c6f:	c3                   	ret    

00800c70 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  800c73:	eb 0c                	jmp    800c81 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  800c75:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800c79:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c7d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  800c81:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c85:	74 1a                	je     800ca1 <strncmp+0x31>
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	0f b6 00             	movzbl (%eax),%eax
  800c8d:	84 c0                	test   %al,%al
  800c8f:	74 10                	je     800ca1 <strncmp+0x31>
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	0f b6 10             	movzbl (%eax),%edx
  800c97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9a:	0f b6 00             	movzbl (%eax),%eax
  800c9d:	38 c2                	cmp    %al,%dl
  800c9f:	74 d4                	je     800c75 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  800ca1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca5:	74 18                	je     800cbf <strncmp+0x4f>
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	0f b6 00             	movzbl (%eax),%eax
  800cad:	0f b6 d0             	movzbl %al,%edx
  800cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb3:	0f b6 00             	movzbl (%eax),%eax
  800cb6:	0f b6 c0             	movzbl %al,%eax
  800cb9:	29 c2                	sub    %eax,%edx
  800cbb:	89 d0                	mov    %edx,%eax
  800cbd:	eb 05                	jmp    800cc4 <strncmp+0x54>
  800cbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    

00800cc6 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	83 ec 04             	sub    $0x4,%esp
  800ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccf:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  800cd2:	eb 14                	jmp    800ce8 <strchr+0x22>
        if (*s == c) {
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	0f b6 00             	movzbl (%eax),%eax
  800cda:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cdd:	75 05                	jne    800ce4 <strchr+0x1e>
            return (char *)s;
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	eb 13                	jmp    800cf7 <strchr+0x31>
        }
        s ++;
  800ce4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	0f b6 00             	movzbl (%eax),%eax
  800cee:	84 c0                	test   %al,%al
  800cf0:	75 e2                	jne    800cd4 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  800cf2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf7:	c9                   	leave  
  800cf8:	c3                   	ret    

00800cf9 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	83 ec 04             	sub    $0x4,%esp
  800cff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d02:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  800d05:	eb 11                	jmp    800d18 <strfind+0x1f>
        if (*s == c) {
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	0f b6 00             	movzbl (%eax),%eax
  800d0d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d10:	75 02                	jne    800d14 <strfind+0x1b>
            break;
  800d12:	eb 0e                	jmp    800d22 <strfind+0x29>
        }
        s ++;
  800d14:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  800d18:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1b:	0f b6 00             	movzbl (%eax),%eax
  800d1e:	84 c0                	test   %al,%al
  800d20:	75 e5                	jne    800d07 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d25:	c9                   	leave  
  800d26:	c3                   	ret    

00800d27 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  800d2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  800d34:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  800d3b:	eb 04                	jmp    800d41 <strtol+0x1a>
        s ++;
  800d3d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	0f b6 00             	movzbl (%eax),%eax
  800d47:	3c 20                	cmp    $0x20,%al
  800d49:	74 f2                	je     800d3d <strtol+0x16>
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	0f b6 00             	movzbl (%eax),%eax
  800d51:	3c 09                	cmp    $0x9,%al
  800d53:	74 e8                	je     800d3d <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	0f b6 00             	movzbl (%eax),%eax
  800d5b:	3c 2b                	cmp    $0x2b,%al
  800d5d:	75 06                	jne    800d65 <strtol+0x3e>
        s ++;
  800d5f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d63:	eb 15                	jmp    800d7a <strtol+0x53>
    }
    else if (*s == '-') {
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	0f b6 00             	movzbl (%eax),%eax
  800d6b:	3c 2d                	cmp    $0x2d,%al
  800d6d:	75 0b                	jne    800d7a <strtol+0x53>
        s ++, neg = 1;
  800d6f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d73:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800d7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7e:	74 06                	je     800d86 <strtol+0x5f>
  800d80:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d84:	75 24                	jne    800daa <strtol+0x83>
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	0f b6 00             	movzbl (%eax),%eax
  800d8c:	3c 30                	cmp    $0x30,%al
  800d8e:	75 1a                	jne    800daa <strtol+0x83>
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	83 c0 01             	add    $0x1,%eax
  800d96:	0f b6 00             	movzbl (%eax),%eax
  800d99:	3c 78                	cmp    $0x78,%al
  800d9b:	75 0d                	jne    800daa <strtol+0x83>
        s += 2, base = 16;
  800d9d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800da1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800da8:	eb 2a                	jmp    800dd4 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  800daa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dae:	75 17                	jne    800dc7 <strtol+0xa0>
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	0f b6 00             	movzbl (%eax),%eax
  800db6:	3c 30                	cmp    $0x30,%al
  800db8:	75 0d                	jne    800dc7 <strtol+0xa0>
        s ++, base = 8;
  800dba:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800dbe:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dc5:	eb 0d                	jmp    800dd4 <strtol+0xad>
    }
    else if (base == 0) {
  800dc7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dcb:	75 07                	jne    800dd4 <strtol+0xad>
        base = 10;
  800dcd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	0f b6 00             	movzbl (%eax),%eax
  800dda:	3c 2f                	cmp    $0x2f,%al
  800ddc:	7e 1b                	jle    800df9 <strtol+0xd2>
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	0f b6 00             	movzbl (%eax),%eax
  800de4:	3c 39                	cmp    $0x39,%al
  800de6:	7f 11                	jg     800df9 <strtol+0xd2>
            dig = *s - '0';
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	0f b6 00             	movzbl (%eax),%eax
  800dee:	0f be c0             	movsbl %al,%eax
  800df1:	83 e8 30             	sub    $0x30,%eax
  800df4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800df7:	eb 48                	jmp    800e41 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	0f b6 00             	movzbl (%eax),%eax
  800dff:	3c 60                	cmp    $0x60,%al
  800e01:	7e 1b                	jle    800e1e <strtol+0xf7>
  800e03:	8b 45 08             	mov    0x8(%ebp),%eax
  800e06:	0f b6 00             	movzbl (%eax),%eax
  800e09:	3c 7a                	cmp    $0x7a,%al
  800e0b:	7f 11                	jg     800e1e <strtol+0xf7>
            dig = *s - 'a' + 10;
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	0f b6 00             	movzbl (%eax),%eax
  800e13:	0f be c0             	movsbl %al,%eax
  800e16:	83 e8 57             	sub    $0x57,%eax
  800e19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e1c:	eb 23                	jmp    800e41 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	0f b6 00             	movzbl (%eax),%eax
  800e24:	3c 40                	cmp    $0x40,%al
  800e26:	7e 3d                	jle    800e65 <strtol+0x13e>
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	0f b6 00             	movzbl (%eax),%eax
  800e2e:	3c 5a                	cmp    $0x5a,%al
  800e30:	7f 33                	jg     800e65 <strtol+0x13e>
            dig = *s - 'A' + 10;
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	0f b6 00             	movzbl (%eax),%eax
  800e38:	0f be c0             	movsbl %al,%eax
  800e3b:	83 e8 37             	sub    $0x37,%eax
  800e3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  800e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e44:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e47:	7c 02                	jl     800e4b <strtol+0x124>
            break;
  800e49:	eb 1a                	jmp    800e65 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  800e4b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800e4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e52:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e56:	89 c2                	mov    %eax,%edx
  800e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e5b:	01 d0                	add    %edx,%eax
  800e5d:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  800e60:	e9 6f ff ff ff       	jmp    800dd4 <strtol+0xad>

    if (endptr) {
  800e65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e69:	74 08                	je     800e73 <strtol+0x14c>
        *endptr = (char *) s;
  800e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e71:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  800e73:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e77:	74 07                	je     800e80 <strtol+0x159>
  800e79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7c:	f7 d8                	neg    %eax
  800e7e:	eb 03                	jmp    800e83 <strtol+0x15c>
  800e80:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e83:	c9                   	leave  
  800e84:	c3                   	ret    

00800e85 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	57                   	push   %edi
  800e89:	83 ec 24             	sub    $0x24,%esp
  800e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8f:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  800e92:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800e96:	8b 55 08             	mov    0x8(%ebp),%edx
  800e99:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e9c:	88 45 f7             	mov    %al,-0x9(%ebp)
  800e9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea2:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  800ea5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800ea8:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800eac:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800eaf:	89 d7                	mov    %edx,%edi
  800eb1:	f3 aa                	rep stos %al,%es:(%edi)
  800eb3:	89 fa                	mov    %edi,%edx
  800eb5:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  800eb8:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  800ebb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  800ebe:	83 c4 24             	add    $0x24,%esp
  800ec1:	5f                   	pop    %edi
  800ec2:	5d                   	pop    %ebp
  800ec3:	c3                   	ret    

00800ec4 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
  800ec7:	57                   	push   %edi
  800ec8:	56                   	push   %esi
  800ec9:	53                   	push   %ebx
  800eca:	83 ec 30             	sub    $0x30,%esp
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ed3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ed9:	8b 45 10             	mov    0x10(%ebp),%eax
  800edc:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  800edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800ee5:	73 42                	jae    800f29 <memmove+0x65>
  800ee7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800eed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ef0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ef3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ef6:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  800ef9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800efc:	c1 e8 02             	shr    $0x2,%eax
  800eff:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  800f01:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f04:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f07:	89 d7                	mov    %edx,%edi
  800f09:	89 c6                	mov    %eax,%esi
  800f0b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f0d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800f10:	83 e1 03             	and    $0x3,%ecx
  800f13:	74 02                	je     800f17 <memmove+0x53>
  800f15:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800f17:	89 f0                	mov    %esi,%eax
  800f19:	89 fa                	mov    %edi,%edx
  800f1b:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  800f1e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800f21:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  800f24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f27:	eb 36                	jmp    800f5f <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  800f29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f2c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f32:	01 c2                	add    %eax,%edx
  800f34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f37:	8d 48 ff             	lea    -0x1(%eax),%ecx
  800f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f3d:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  800f40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f43:	89 c1                	mov    %eax,%ecx
  800f45:	89 d8                	mov    %ebx,%eax
  800f47:	89 d6                	mov    %edx,%esi
  800f49:	89 c7                	mov    %eax,%edi
  800f4b:	fd                   	std    
  800f4c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800f4e:	fc                   	cld    
  800f4f:	89 f8                	mov    %edi,%eax
  800f51:	89 f2                	mov    %esi,%edx
  800f53:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800f56:	89 55 c8             	mov    %edx,-0x38(%ebp)
  800f59:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  800f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  800f5f:	83 c4 30             	add    $0x30,%esp
  800f62:	5b                   	pop    %ebx
  800f63:	5e                   	pop    %esi
  800f64:	5f                   	pop    %edi
  800f65:	5d                   	pop    %ebp
  800f66:	c3                   	ret    

00800f67 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	57                   	push   %edi
  800f6b:	56                   	push   %esi
  800f6c:	83 ec 20             	sub    $0x20,%esp
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  800f81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f84:	c1 e8 02             	shr    $0x2,%eax
  800f87:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  800f89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f8f:	89 d7                	mov    %edx,%edi
  800f91:	89 c6                	mov    %eax,%esi
  800f93:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f95:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  800f98:	83 e1 03             	and    $0x3,%ecx
  800f9b:	74 02                	je     800f9f <memcpy+0x38>
  800f9d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800f9f:	89 f0                	mov    %esi,%eax
  800fa1:	89 fa                	mov    %edi,%edx
  800fa3:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  800fa6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800fa9:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  800fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  800faf:	83 c4 20             	add    $0x20,%esp
  800fb2:	5e                   	pop    %esi
  800fb3:	5f                   	pop    %edi
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    

00800fb6 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  800fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc5:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  800fc8:	eb 30                	jmp    800ffa <memcmp+0x44>
        if (*s1 != *s2) {
  800fca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fcd:	0f b6 10             	movzbl (%eax),%edx
  800fd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd3:	0f b6 00             	movzbl (%eax),%eax
  800fd6:	38 c2                	cmp    %al,%dl
  800fd8:	74 18                	je     800ff2 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  800fda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fdd:	0f b6 00             	movzbl (%eax),%eax
  800fe0:	0f b6 d0             	movzbl %al,%edx
  800fe3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe6:	0f b6 00             	movzbl (%eax),%eax
  800fe9:	0f b6 c0             	movzbl %al,%eax
  800fec:	29 c2                	sub    %eax,%edx
  800fee:	89 d0                	mov    %edx,%eax
  800ff0:	eb 1a                	jmp    80100c <memcmp+0x56>
        }
        s1 ++, s2 ++;
  800ff2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800ff6:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  800ffa:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffd:	8d 50 ff             	lea    -0x1(%eax),%edx
  801000:	89 55 10             	mov    %edx,0x10(%ebp)
  801003:	85 c0                	test   %eax,%eax
  801005:	75 c3                	jne    800fca <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  801007:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80100c:	c9                   	leave  
  80100d:	c3                   	ret    

0080100e <main>:
#include <ulib.h>

int zero;

int
main(void) {
  80100e:	55                   	push   %ebp
  80100f:	89 e5                	mov    %esp,%ebp
  801011:	83 e4 f0             	and    $0xfffffff0,%esp
  801014:	83 ec 10             	sub    $0x10,%esp
    cprintf("value is %d.\n", 1 / zero);
  801017:	8b 0d 08 20 80 00    	mov    0x802008,%ecx
  80101d:	b8 01 00 00 00       	mov    $0x1,%eax
  801022:	99                   	cltd   
  801023:	f7 f9                	idiv   %ecx
  801025:	89 44 24 04          	mov    %eax,0x4(%esp)
  801029:	c7 04 24 40 13 80 00 	movl   $0x801340,(%esp)
  801030:	e8 e3 f0 ff ff       	call   800118 <cprintf>
    panic("FAIL: T.T\n");
  801035:	c7 44 24 08 4e 13 80 	movl   $0x80134e,0x8(%esp)
  80103c:	00 
  80103d:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  801044:	00 
  801045:	c7 04 24 59 13 80 00 	movl   $0x801359,(%esp)
  80104c:	e8 de ef ff ff       	call   80002f <__panic>
