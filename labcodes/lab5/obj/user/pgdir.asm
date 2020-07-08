
obj/__user_pgdir.out:     file format elf32-i386


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
  800028:	e8 15 03 00 00       	call   800342 <umain>
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
  800049:	c7 04 24 e0 0f 80 00 	movl   $0x800fe0,(%esp)
  800050:	e8 c3 00 00 00       	call   800118 <cprintf>
    vcprintf(fmt, ap);
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	89 44 24 04          	mov    %eax,0x4(%esp)
  80005c:	8b 45 10             	mov    0x10(%ebp),%eax
  80005f:	89 04 24             	mov    %eax,(%esp)
  800062:	e8 7e 00 00 00       	call   8000e5 <vcprintf>
    cprintf("\n");
  800067:	c7 04 24 fa 0f 80 00 	movl   $0x800ffa,(%esp)
  80006e:	e8 a5 00 00 00       	call   800118 <cprintf>
    va_end(ap);
    exit(-E_PANIC);
  800073:	c7 04 24 f6 ff ff ff 	movl   $0xfffffff6,(%esp)
  80007a:	e8 27 02 00 00       	call   8002a6 <exit>

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
  800099:	c7 04 24 fc 0f 80 00 	movl   $0x800ffc,(%esp)
  8000a0:	e8 73 00 00 00       	call   800118 <cprintf>
    vcprintf(fmt, ap);
  8000a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8000af:	89 04 24             	mov    %eax,(%esp)
  8000b2:	e8 2e 00 00 00       	call   8000e5 <vcprintf>
    cprintf("\n");
  8000b7:	c7 04 24 fa 0f 80 00 	movl   $0x800ffa,(%esp)
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
  80010e:	e8 36 04 00 00       	call   800549 <vprintfmt>
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

008002a6 <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  8002a6:	55                   	push   %ebp
  8002a7:	89 e5                	mov    %esp,%ebp
  8002a9:	83 ec 18             	sub    $0x18,%esp
    sys_exit(error_code);
  8002ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8002af:	89 04 24             	mov    %eax,(%esp)
  8002b2:	e8 2c ff ff ff       	call   8001e3 <sys_exit>
    cprintf("BUG: exit failed.\n");
  8002b7:	c7 04 24 18 10 80 00 	movl   $0x801018,(%esp)
  8002be:	e8 55 fe ff ff       	call   800118 <cprintf>
    while (1);
  8002c3:	eb fe                	jmp    8002c3 <exit+0x1d>

008002c5 <fork>:
}

int
fork(void) {
  8002c5:	55                   	push   %ebp
  8002c6:	89 e5                	mov    %esp,%ebp
  8002c8:	83 ec 08             	sub    $0x8,%esp
    return sys_fork();
  8002cb:	e8 2e ff ff ff       	call   8001fe <sys_fork>
}
  8002d0:	c9                   	leave  
  8002d1:	c3                   	ret    

008002d2 <wait>:

int
wait(void) {
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	83 ec 18             	sub    $0x18,%esp
    return sys_wait(0, NULL);
  8002d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8002df:	00 
  8002e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002e7:	e8 26 ff ff ff       	call   800212 <sys_wait>
}
  8002ec:	c9                   	leave  
  8002ed:	c3                   	ret    

008002ee <waitpid>:

int
waitpid(int pid, int *store) {
  8002ee:	55                   	push   %ebp
  8002ef:	89 e5                	mov    %esp,%ebp
  8002f1:	83 ec 18             	sub    $0x18,%esp
    return sys_wait(pid, store);
  8002f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fe:	89 04 24             	mov    %eax,(%esp)
  800301:	e8 0c ff ff ff       	call   800212 <sys_wait>
}
  800306:	c9                   	leave  
  800307:	c3                   	ret    

00800308 <yield>:

void
yield(void) {
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
  80030b:	83 ec 08             	sub    $0x8,%esp
    sys_yield();
  80030e:	e8 21 ff ff ff       	call   800234 <sys_yield>
}
  800313:	c9                   	leave  
  800314:	c3                   	ret    

00800315 <kill>:

int
kill(int pid) {
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	83 ec 18             	sub    $0x18,%esp
    return sys_kill(pid);
  80031b:	8b 45 08             	mov    0x8(%ebp),%eax
  80031e:	89 04 24             	mov    %eax,(%esp)
  800321:	e8 22 ff ff ff       	call   800248 <sys_kill>
}
  800326:	c9                   	leave  
  800327:	c3                   	ret    

00800328 <getpid>:

int
getpid(void) {
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	83 ec 08             	sub    $0x8,%esp
    return sys_getpid();
  80032e:	e8 30 ff ff ff       	call   800263 <sys_getpid>
}
  800333:	c9                   	leave  
  800334:	c3                   	ret    

00800335 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  800335:	55                   	push   %ebp
  800336:	89 e5                	mov    %esp,%ebp
  800338:	83 ec 08             	sub    $0x8,%esp
    sys_pgdir();
  80033b:	e8 52 ff ff ff       	call   800292 <sys_pgdir>
}
  800340:	c9                   	leave  
  800341:	c3                   	ret    

00800342 <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  800342:	55                   	push   %ebp
  800343:	89 e5                	mov    %esp,%ebp
  800345:	83 ec 28             	sub    $0x28,%esp
    int ret = main();
  800348:	e8 44 0c 00 00       	call   800f91 <main>
  80034d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    exit(ret);
  800350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800353:	89 04 24             	mov    %eax,(%esp)
  800356:	e8 4b ff ff ff       	call   8002a6 <exit>

0080035b <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
  80035b:	55                   	push   %ebp
  80035c:	89 e5                	mov    %esp,%ebp
  80035e:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
  800361:	8b 45 08             	mov    0x8(%ebp),%eax
  800364:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
  80036a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return (hash >> (32 - bits));
  80036d:	b8 20 00 00 00       	mov    $0x20,%eax
  800372:	2b 45 0c             	sub    0xc(%ebp),%eax
  800375:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800378:	89 c1                	mov    %eax,%ecx
  80037a:	d3 ea                	shr    %cl,%edx
  80037c:	89 d0                	mov    %edx,%eax
}
  80037e:	c9                   	leave  
  80037f:	c3                   	ret    

00800380 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  800380:	55                   	push   %ebp
  800381:	89 e5                	mov    %esp,%ebp
  800383:	83 ec 58             	sub    $0x58,%esp
  800386:	8b 45 10             	mov    0x10(%ebp),%eax
  800389:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80038c:	8b 45 14             	mov    0x14(%ebp),%eax
  80038f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  800392:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800395:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800398:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80039b:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  80039e:	8b 45 18             	mov    0x18(%ebp),%eax
  8003a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ad:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8003b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8003b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8003ba:	74 1c                	je     8003d8 <printnum+0x58>
  8003bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c4:	f7 75 e4             	divl   -0x1c(%ebp)
  8003c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8003ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d2:	f7 75 e4             	divl   -0x1c(%ebp)
  8003d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003de:	f7 75 e4             	divl   -0x1c(%ebp)
  8003e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8003e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8003ed:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8003f0:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8003f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003f6:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  8003f9:	8b 45 18             	mov    0x18(%ebp),%eax
  8003fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800401:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  800404:	77 56                	ja     80045c <printnum+0xdc>
  800406:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  800409:	72 05                	jb     800410 <printnum+0x90>
  80040b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80040e:	77 4c                	ja     80045c <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  800410:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800413:	8d 50 ff             	lea    -0x1(%eax),%edx
  800416:	8b 45 20             	mov    0x20(%ebp),%eax
  800419:	89 44 24 18          	mov    %eax,0x18(%esp)
  80041d:	89 54 24 14          	mov    %edx,0x14(%esp)
  800421:	8b 45 18             	mov    0x18(%ebp),%eax
  800424:	89 44 24 10          	mov    %eax,0x10(%esp)
  800428:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80042b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80042e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800432:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800436:	8b 45 0c             	mov    0xc(%ebp),%eax
  800439:	89 44 24 04          	mov    %eax,0x4(%esp)
  80043d:	8b 45 08             	mov    0x8(%ebp),%eax
  800440:	89 04 24             	mov    %eax,(%esp)
  800443:	e8 38 ff ff ff       	call   800380 <printnum>
  800448:	eb 1c                	jmp    800466 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  80044a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80044d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800451:	8b 45 20             	mov    0x20(%ebp),%eax
  800454:	89 04 24             	mov    %eax,(%esp)
  800457:	8b 45 08             	mov    0x8(%ebp),%eax
  80045a:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  80045c:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  800460:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800464:	7f e4                	jg     80044a <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  800466:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800469:	05 44 11 80 00       	add    $0x801144,%eax
  80046e:	0f b6 00             	movzbl (%eax),%eax
  800471:	0f be c0             	movsbl %al,%eax
  800474:	8b 55 0c             	mov    0xc(%ebp),%edx
  800477:	89 54 24 04          	mov    %edx,0x4(%esp)
  80047b:	89 04 24             	mov    %eax,(%esp)
  80047e:	8b 45 08             	mov    0x8(%ebp),%eax
  800481:	ff d0                	call   *%eax
}
  800483:	c9                   	leave  
  800484:	c3                   	ret    

00800485 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  800485:	55                   	push   %ebp
  800486:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  800488:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80048c:	7e 14                	jle    8004a2 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  80048e:	8b 45 08             	mov    0x8(%ebp),%eax
  800491:	8b 00                	mov    (%eax),%eax
  800493:	8d 48 08             	lea    0x8(%eax),%ecx
  800496:	8b 55 08             	mov    0x8(%ebp),%edx
  800499:	89 0a                	mov    %ecx,(%edx)
  80049b:	8b 50 04             	mov    0x4(%eax),%edx
  80049e:	8b 00                	mov    (%eax),%eax
  8004a0:	eb 30                	jmp    8004d2 <getuint+0x4d>
    }
    else if (lflag) {
  8004a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004a6:	74 16                	je     8004be <getuint+0x39>
        return va_arg(*ap, unsigned long);
  8004a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ab:	8b 00                	mov    (%eax),%eax
  8004ad:	8d 48 04             	lea    0x4(%eax),%ecx
  8004b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b3:	89 0a                	mov    %ecx,(%edx)
  8004b5:	8b 00                	mov    (%eax),%eax
  8004b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8004bc:	eb 14                	jmp    8004d2 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  8004be:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	8d 48 04             	lea    0x4(%eax),%ecx
  8004c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c9:	89 0a                	mov    %ecx,(%edx)
  8004cb:	8b 00                	mov    (%eax),%eax
  8004cd:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  8004d2:	5d                   	pop    %ebp
  8004d3:	c3                   	ret    

008004d4 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  8004d4:	55                   	push   %ebp
  8004d5:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  8004d7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004db:	7e 14                	jle    8004f1 <getint+0x1d>
        return va_arg(*ap, long long);
  8004dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e0:	8b 00                	mov    (%eax),%eax
  8004e2:	8d 48 08             	lea    0x8(%eax),%ecx
  8004e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8004e8:	89 0a                	mov    %ecx,(%edx)
  8004ea:	8b 50 04             	mov    0x4(%eax),%edx
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	eb 28                	jmp    800519 <getint+0x45>
    }
    else if (lflag) {
  8004f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004f5:	74 12                	je     800509 <getint+0x35>
        return va_arg(*ap, long);
  8004f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	8d 48 04             	lea    0x4(%eax),%ecx
  8004ff:	8b 55 08             	mov    0x8(%ebp),%edx
  800502:	89 0a                	mov    %ecx,(%edx)
  800504:	8b 00                	mov    (%eax),%eax
  800506:	99                   	cltd   
  800507:	eb 10                	jmp    800519 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  800509:	8b 45 08             	mov    0x8(%ebp),%eax
  80050c:	8b 00                	mov    (%eax),%eax
  80050e:	8d 48 04             	lea    0x4(%eax),%ecx
  800511:	8b 55 08             	mov    0x8(%ebp),%edx
  800514:	89 0a                	mov    %ecx,(%edx)
  800516:	8b 00                	mov    (%eax),%eax
  800518:	99                   	cltd   
    }
}
  800519:	5d                   	pop    %ebp
  80051a:	c3                   	ret    

0080051b <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  80051b:	55                   	push   %ebp
  80051c:	89 e5                	mov    %esp,%ebp
  80051e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  800521:	8d 45 14             	lea    0x14(%ebp),%eax
  800524:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  800527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80052a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80052e:	8b 45 10             	mov    0x10(%ebp),%eax
  800531:	89 44 24 08          	mov    %eax,0x8(%esp)
  800535:	8b 45 0c             	mov    0xc(%ebp),%eax
  800538:	89 44 24 04          	mov    %eax,0x4(%esp)
  80053c:	8b 45 08             	mov    0x8(%ebp),%eax
  80053f:	89 04 24             	mov    %eax,(%esp)
  800542:	e8 02 00 00 00       	call   800549 <vprintfmt>
    va_end(ap);
}
  800547:	c9                   	leave  
  800548:	c3                   	ret    

00800549 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  800549:	55                   	push   %ebp
  80054a:	89 e5                	mov    %esp,%ebp
  80054c:	56                   	push   %esi
  80054d:	53                   	push   %ebx
  80054e:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800551:	eb 18                	jmp    80056b <vprintfmt+0x22>
            if (ch == '\0') {
  800553:	85 db                	test   %ebx,%ebx
  800555:	75 05                	jne    80055c <vprintfmt+0x13>
                return;
  800557:	e9 d1 03 00 00       	jmp    80092d <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  80055c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80055f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800563:	89 1c 24             	mov    %ebx,(%esp)
  800566:	8b 45 08             	mov    0x8(%ebp),%eax
  800569:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80056b:	8b 45 10             	mov    0x10(%ebp),%eax
  80056e:	8d 50 01             	lea    0x1(%eax),%edx
  800571:	89 55 10             	mov    %edx,0x10(%ebp)
  800574:	0f b6 00             	movzbl (%eax),%eax
  800577:	0f b6 d8             	movzbl %al,%ebx
  80057a:	83 fb 25             	cmp    $0x25,%ebx
  80057d:	75 d4                	jne    800553 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  80057f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  800583:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80058a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80058d:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  800590:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800597:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80059a:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  80059d:	8b 45 10             	mov    0x10(%ebp),%eax
  8005a0:	8d 50 01             	lea    0x1(%eax),%edx
  8005a3:	89 55 10             	mov    %edx,0x10(%ebp)
  8005a6:	0f b6 00             	movzbl (%eax),%eax
  8005a9:	0f b6 d8             	movzbl %al,%ebx
  8005ac:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005af:	83 f8 55             	cmp    $0x55,%eax
  8005b2:	0f 87 44 03 00 00    	ja     8008fc <vprintfmt+0x3b3>
  8005b8:	8b 04 85 68 11 80 00 	mov    0x801168(,%eax,4),%eax
  8005bf:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  8005c1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  8005c5:	eb d6                	jmp    80059d <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  8005c7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  8005cb:	eb d0                	jmp    80059d <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  8005cd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  8005d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005d7:	89 d0                	mov    %edx,%eax
  8005d9:	c1 e0 02             	shl    $0x2,%eax
  8005dc:	01 d0                	add    %edx,%eax
  8005de:	01 c0                	add    %eax,%eax
  8005e0:	01 d8                	add    %ebx,%eax
  8005e2:	83 e8 30             	sub    $0x30,%eax
  8005e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  8005e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8005eb:	0f b6 00             	movzbl (%eax),%eax
  8005ee:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  8005f1:	83 fb 2f             	cmp    $0x2f,%ebx
  8005f4:	7e 0b                	jle    800601 <vprintfmt+0xb8>
  8005f6:	83 fb 39             	cmp    $0x39,%ebx
  8005f9:	7f 06                	jg     800601 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  8005fb:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  8005ff:	eb d3                	jmp    8005d4 <vprintfmt+0x8b>
            goto process_precision;
  800601:	eb 33                	jmp    800636 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  800603:	8b 45 14             	mov    0x14(%ebp),%eax
  800606:	8d 50 04             	lea    0x4(%eax),%edx
  800609:	89 55 14             	mov    %edx,0x14(%ebp)
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  800611:	eb 23                	jmp    800636 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  800613:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800617:	79 0c                	jns    800625 <vprintfmt+0xdc>
                width = 0;
  800619:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  800620:	e9 78 ff ff ff       	jmp    80059d <vprintfmt+0x54>
  800625:	e9 73 ff ff ff       	jmp    80059d <vprintfmt+0x54>

        case '#':
            altflag = 1;
  80062a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  800631:	e9 67 ff ff ff       	jmp    80059d <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  800636:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80063a:	79 12                	jns    80064e <vprintfmt+0x105>
                width = precision, precision = -1;
  80063c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80063f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800642:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  800649:	e9 4f ff ff ff       	jmp    80059d <vprintfmt+0x54>
  80064e:	e9 4a ff ff ff       	jmp    80059d <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  800653:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  800657:	e9 41 ff ff ff       	jmp    80059d <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8d 50 04             	lea    0x4(%eax),%edx
  800662:	89 55 14             	mov    %edx,0x14(%ebp)
  800665:	8b 00                	mov    (%eax),%eax
  800667:	8b 55 0c             	mov    0xc(%ebp),%edx
  80066a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80066e:	89 04 24             	mov    %eax,(%esp)
  800671:	8b 45 08             	mov    0x8(%ebp),%eax
  800674:	ff d0                	call   *%eax
            break;
  800676:	e9 ac 02 00 00       	jmp    800927 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	8d 50 04             	lea    0x4(%eax),%edx
  800681:	89 55 14             	mov    %edx,0x14(%ebp)
  800684:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  800686:	85 db                	test   %ebx,%ebx
  800688:	79 02                	jns    80068c <vprintfmt+0x143>
                err = -err;
  80068a:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  80068c:	83 fb 18             	cmp    $0x18,%ebx
  80068f:	7f 0b                	jg     80069c <vprintfmt+0x153>
  800691:	8b 34 9d e0 10 80 00 	mov    0x8010e0(,%ebx,4),%esi
  800698:	85 f6                	test   %esi,%esi
  80069a:	75 23                	jne    8006bf <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  80069c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8006a0:	c7 44 24 08 55 11 80 	movl   $0x801155,0x8(%esp)
  8006a7:	00 
  8006a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	89 04 24             	mov    %eax,(%esp)
  8006b5:	e8 61 fe ff ff       	call   80051b <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  8006ba:	e9 68 02 00 00       	jmp    800927 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  8006bf:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8006c3:	c7 44 24 08 5e 11 80 	movl   $0x80115e,0x8(%esp)
  8006ca:	00 
  8006cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d5:	89 04 24             	mov    %eax,(%esp)
  8006d8:	e8 3e fe ff ff       	call   80051b <printfmt>
            }
            break;
  8006dd:	e9 45 02 00 00       	jmp    800927 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	8d 50 04             	lea    0x4(%eax),%edx
  8006e8:	89 55 14             	mov    %edx,0x14(%ebp)
  8006eb:	8b 30                	mov    (%eax),%esi
  8006ed:	85 f6                	test   %esi,%esi
  8006ef:	75 05                	jne    8006f6 <vprintfmt+0x1ad>
                p = "(null)";
  8006f1:	be 61 11 80 00       	mov    $0x801161,%esi
            }
            if (width > 0 && padc != '-') {
  8006f6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8006fa:	7e 3e                	jle    80073a <vprintfmt+0x1f1>
  8006fc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800700:	74 38                	je     80073a <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  800702:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800705:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800708:	89 44 24 04          	mov    %eax,0x4(%esp)
  80070c:	89 34 24             	mov    %esi,(%esp)
  80070f:	e8 ed 03 00 00       	call   800b01 <strnlen>
  800714:	29 c3                	sub    %eax,%ebx
  800716:	89 d8                	mov    %ebx,%eax
  800718:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80071b:	eb 17                	jmp    800734 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  80071d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800721:	8b 55 0c             	mov    0xc(%ebp),%edx
  800724:	89 54 24 04          	mov    %edx,0x4(%esp)
  800728:	89 04 24             	mov    %eax,(%esp)
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  800730:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  800734:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800738:	7f e3                	jg     80071d <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80073a:	eb 38                	jmp    800774 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  80073c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800740:	74 1f                	je     800761 <vprintfmt+0x218>
  800742:	83 fb 1f             	cmp    $0x1f,%ebx
  800745:	7e 05                	jle    80074c <vprintfmt+0x203>
  800747:	83 fb 7e             	cmp    $0x7e,%ebx
  80074a:	7e 15                	jle    800761 <vprintfmt+0x218>
                    putch('?', putdat);
  80074c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800753:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	ff d0                	call   *%eax
  80075f:	eb 0f                	jmp    800770 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  800761:	8b 45 0c             	mov    0xc(%ebp),%eax
  800764:	89 44 24 04          	mov    %eax,0x4(%esp)
  800768:	89 1c 24             	mov    %ebx,(%esp)
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800770:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  800774:	89 f0                	mov    %esi,%eax
  800776:	8d 70 01             	lea    0x1(%eax),%esi
  800779:	0f b6 00             	movzbl (%eax),%eax
  80077c:	0f be d8             	movsbl %al,%ebx
  80077f:	85 db                	test   %ebx,%ebx
  800781:	74 10                	je     800793 <vprintfmt+0x24a>
  800783:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800787:	78 b3                	js     80073c <vprintfmt+0x1f3>
  800789:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  80078d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800791:	79 a9                	jns    80073c <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  800793:	eb 17                	jmp    8007ac <vprintfmt+0x263>
                putch(' ', putdat);
  800795:	8b 45 0c             	mov    0xc(%ebp),%eax
  800798:	89 44 24 04          	mov    %eax,0x4(%esp)
  80079c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8007a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a6:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  8007a8:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  8007ac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8007b0:	7f e3                	jg     800795 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  8007b2:	e9 70 01 00 00       	jmp    800927 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  8007b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007be:	8d 45 14             	lea    0x14(%ebp),%eax
  8007c1:	89 04 24             	mov    %eax,(%esp)
  8007c4:	e8 0b fd ff ff       	call   8004d4 <getint>
  8007c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  8007cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d5:	85 d2                	test   %edx,%edx
  8007d7:	79 26                	jns    8007ff <vprintfmt+0x2b6>
                putch('-', putdat);
  8007d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007e0:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8007e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ea:	ff d0                	call   *%eax
                num = -(long long)num;
  8007ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007f2:	f7 d8                	neg    %eax
  8007f4:	83 d2 00             	adc    $0x0,%edx
  8007f7:	f7 da                	neg    %edx
  8007f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  8007ff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  800806:	e9 a8 00 00 00       	jmp    8008b3 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  80080b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80080e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800812:	8d 45 14             	lea    0x14(%ebp),%eax
  800815:	89 04 24             	mov    %eax,(%esp)
  800818:	e8 68 fc ff ff       	call   800485 <getuint>
  80081d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800820:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  800823:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  80082a:	e9 84 00 00 00       	jmp    8008b3 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  80082f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800832:	89 44 24 04          	mov    %eax,0x4(%esp)
  800836:	8d 45 14             	lea    0x14(%ebp),%eax
  800839:	89 04 24             	mov    %eax,(%esp)
  80083c:	e8 44 fc ff ff       	call   800485 <getuint>
  800841:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800844:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  800847:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  80084e:	eb 63                	jmp    8008b3 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  800850:	8b 45 0c             	mov    0xc(%ebp),%eax
  800853:	89 44 24 04          	mov    %eax,0x4(%esp)
  800857:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	ff d0                	call   *%eax
            putch('x', putdat);
  800863:	8b 45 0c             	mov    0xc(%ebp),%eax
  800866:	89 44 24 04          	mov    %eax,0x4(%esp)
  80086a:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	8d 50 04             	lea    0x4(%eax),%edx
  80087c:	89 55 14             	mov    %edx,0x14(%ebp)
  80087f:	8b 00                	mov    (%eax),%eax
  800881:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800884:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  80088b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  800892:	eb 1f                	jmp    8008b3 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  800894:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800897:	89 44 24 04          	mov    %eax,0x4(%esp)
  80089b:	8d 45 14             	lea    0x14(%ebp),%eax
  80089e:	89 04 24             	mov    %eax,(%esp)
  8008a1:	e8 df fb ff ff       	call   800485 <getuint>
  8008a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  8008ac:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  8008b3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ba:	89 54 24 18          	mov    %edx,0x18(%esp)
  8008be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008c1:	89 54 24 14          	mov    %edx,0x14(%esp)
  8008c5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8008c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008d3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8008d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	89 04 24             	mov    %eax,(%esp)
  8008e4:	e8 97 fa ff ff       	call   800380 <printnum>
            break;
  8008e9:	eb 3c                	jmp    800927 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  8008eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008f2:	89 1c 24             	mov    %ebx,(%esp)
  8008f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f8:	ff d0                	call   *%eax
            break;
  8008fa:	eb 2b                	jmp    800927 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  8008fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  800903:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  80090f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800913:	eb 04                	jmp    800919 <vprintfmt+0x3d0>
  800915:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800919:	8b 45 10             	mov    0x10(%ebp),%eax
  80091c:	83 e8 01             	sub    $0x1,%eax
  80091f:	0f b6 00             	movzbl (%eax),%eax
  800922:	3c 25                	cmp    $0x25,%al
  800924:	75 ef                	jne    800915 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  800926:	90                   	nop
        }
    }
  800927:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800928:	e9 3e fc ff ff       	jmp    80056b <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  80092d:	83 c4 40             	add    $0x40,%esp
  800930:	5b                   	pop    %ebx
  800931:	5e                   	pop    %esi
  800932:	5d                   	pop    %ebp
  800933:	c3                   	ret    

00800934 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  800937:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093a:	8b 40 08             	mov    0x8(%eax),%eax
  80093d:	8d 50 01             	lea    0x1(%eax),%edx
  800940:	8b 45 0c             	mov    0xc(%ebp),%eax
  800943:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  800946:	8b 45 0c             	mov    0xc(%ebp),%eax
  800949:	8b 10                	mov    (%eax),%edx
  80094b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094e:	8b 40 04             	mov    0x4(%eax),%eax
  800951:	39 c2                	cmp    %eax,%edx
  800953:	73 12                	jae    800967 <sprintputch+0x33>
        *b->buf ++ = ch;
  800955:	8b 45 0c             	mov    0xc(%ebp),%eax
  800958:	8b 00                	mov    (%eax),%eax
  80095a:	8d 48 01             	lea    0x1(%eax),%ecx
  80095d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800960:	89 0a                	mov    %ecx,(%edx)
  800962:	8b 55 08             	mov    0x8(%ebp),%edx
  800965:	88 10                	mov    %dl,(%eax)
    }
}
  800967:	5d                   	pop    %ebp
  800968:	c3                   	ret    

00800969 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
  80096c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  80096f:	8d 45 14             	lea    0x14(%ebp),%eax
  800972:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  800975:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800978:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80097c:	8b 45 10             	mov    0x10(%ebp),%eax
  80097f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800983:	8b 45 0c             	mov    0xc(%ebp),%eax
  800986:	89 44 24 04          	mov    %eax,0x4(%esp)
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	89 04 24             	mov    %eax,(%esp)
  800990:	e8 08 00 00 00       	call   80099d <vsnprintf>
  800995:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  800998:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80099b:	c9                   	leave  
  80099c:	c3                   	ret    

0080099d <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  80099d:	55                   	push   %ebp
  80099e:	89 e5                	mov    %esp,%ebp
  8009a0:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  8009a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	01 d0                	add    %edx,%eax
  8009b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  8009be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009c2:	74 0a                	je     8009ce <vsnprintf+0x31>
  8009c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8009c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ca:	39 c2                	cmp    %eax,%edx
  8009cc:	76 07                	jbe    8009d5 <vsnprintf+0x38>
        return -E_INVAL;
  8009ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009d3:	eb 2a                	jmp    8009ff <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8009df:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009e3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009ea:	c7 04 24 34 09 80 00 	movl   $0x800934,(%esp)
  8009f1:	e8 53 fb ff ff       	call   800549 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  8009f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009f9:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  8009fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009ff:	c9                   	leave  
  800a00:	c3                   	ret    

00800a01 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
  800a01:	55                   	push   %ebp
  800a02:	89 e5                	mov    %esp,%ebp
  800a04:	57                   	push   %edi
  800a05:	56                   	push   %esi
  800a06:	53                   	push   %ebx
  800a07:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
  800a0a:	a1 00 20 80 00       	mov    0x802000,%eax
  800a0f:	8b 15 04 20 80 00    	mov    0x802004,%edx
  800a15:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
  800a1b:	6b f0 05             	imul   $0x5,%eax,%esi
  800a1e:	01 f7                	add    %esi,%edi
  800a20:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
  800a25:	f7 e6                	mul    %esi
  800a27:	8d 34 17             	lea    (%edi,%edx,1),%esi
  800a2a:	89 f2                	mov    %esi,%edx
  800a2c:	83 c0 0b             	add    $0xb,%eax
  800a2f:	83 d2 00             	adc    $0x0,%edx
  800a32:	89 c7                	mov    %eax,%edi
  800a34:	83 e7 ff             	and    $0xffffffff,%edi
  800a37:	89 f9                	mov    %edi,%ecx
  800a39:	0f b7 da             	movzwl %dx,%ebx
  800a3c:	89 0d 00 20 80 00    	mov    %ecx,0x802000
  800a42:	89 1d 04 20 80 00    	mov    %ebx,0x802004
    unsigned long long result = (next >> 12);
  800a48:	a1 00 20 80 00       	mov    0x802000,%eax
  800a4d:	8b 15 04 20 80 00    	mov    0x802004,%edx
  800a53:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  800a57:	c1 ea 0c             	shr    $0xc,%edx
  800a5a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a5d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
  800a60:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
  800a67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a6d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a70:	89 55 e8             	mov    %edx,-0x18(%ebp)
  800a73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a76:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a79:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800a7d:	74 1c                	je     800a9b <rand+0x9a>
  800a7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a82:	ba 00 00 00 00       	mov    $0x0,%edx
  800a87:	f7 75 dc             	divl   -0x24(%ebp)
  800a8a:	89 55 ec             	mov    %edx,-0x14(%ebp)
  800a8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a90:	ba 00 00 00 00       	mov    $0x0,%edx
  800a95:	f7 75 dc             	divl   -0x24(%ebp)
  800a98:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800a9b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a9e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800aa1:	f7 75 dc             	divl   -0x24(%ebp)
  800aa4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800aa7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800aaa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800aad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800ab0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ab3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800ab6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
  800ab9:	83 c4 24             	add    $0x24,%esp
  800abc:	5b                   	pop    %ebx
  800abd:	5e                   	pop    %esi
  800abe:	5f                   	pop    %edi
  800abf:	5d                   	pop    %ebp
  800ac0:	c3                   	ret    

00800ac1 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
  800ac1:	55                   	push   %ebp
  800ac2:	89 e5                	mov    %esp,%ebp
    next = seed;
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	ba 00 00 00 00       	mov    $0x0,%edx
  800acc:	a3 00 20 80 00       	mov    %eax,0x802000
  800ad1:	89 15 04 20 80 00    	mov    %edx,0x802004
}
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    

00800ad9 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  800adf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  800ae6:	eb 04                	jmp    800aec <strlen+0x13>
        cnt ++;
  800ae8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	8d 50 01             	lea    0x1(%eax),%edx
  800af2:	89 55 08             	mov    %edx,0x8(%ebp)
  800af5:	0f b6 00             	movzbl (%eax),%eax
  800af8:	84 c0                	test   %al,%al
  800afa:	75 ec                	jne    800ae8 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  800afc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800aff:	c9                   	leave  
  800b00:	c3                   	ret    

00800b01 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  800b01:	55                   	push   %ebp
  800b02:	89 e5                	mov    %esp,%ebp
  800b04:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  800b07:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  800b0e:	eb 04                	jmp    800b14 <strnlen+0x13>
        cnt ++;
  800b10:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  800b14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b17:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b1a:	73 10                	jae    800b2c <strnlen+0x2b>
  800b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1f:	8d 50 01             	lea    0x1(%eax),%edx
  800b22:	89 55 08             	mov    %edx,0x8(%ebp)
  800b25:	0f b6 00             	movzbl (%eax),%eax
  800b28:	84 c0                	test   %al,%al
  800b2a:	75 e4                	jne    800b10 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  800b2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b2f:	c9                   	leave  
  800b30:	c3                   	ret    

00800b31 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
  800b34:	57                   	push   %edi
  800b35:	56                   	push   %esi
  800b36:	83 ec 20             	sub    $0x20,%esp
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b42:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  800b45:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b4b:	89 d1                	mov    %edx,%ecx
  800b4d:	89 c2                	mov    %eax,%edx
  800b4f:	89 ce                	mov    %ecx,%esi
  800b51:	89 d7                	mov    %edx,%edi
  800b53:	ac                   	lods   %ds:(%esi),%al
  800b54:	aa                   	stos   %al,%es:(%edi)
  800b55:	84 c0                	test   %al,%al
  800b57:	75 fa                	jne    800b53 <strcpy+0x22>
  800b59:	89 fa                	mov    %edi,%edx
  800b5b:	89 f1                	mov    %esi,%ecx
  800b5d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  800b60:	89 55 e8             	mov    %edx,-0x18(%ebp)
  800b63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  800b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  800b69:	83 c4 20             	add    $0x20,%esp
  800b6c:	5e                   	pop    %esi
  800b6d:	5f                   	pop    %edi
  800b6e:	5d                   	pop    %ebp
  800b6f:	c3                   	ret    

00800b70 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  800b7c:	eb 21                	jmp    800b9f <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  800b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b81:	0f b6 10             	movzbl (%eax),%edx
  800b84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b87:	88 10                	mov    %dl,(%eax)
  800b89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b8c:	0f b6 00             	movzbl (%eax),%eax
  800b8f:	84 c0                	test   %al,%al
  800b91:	74 04                	je     800b97 <strncpy+0x27>
            src ++;
  800b93:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  800b97:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800b9b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  800b9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ba3:	75 d9                	jne    800b7e <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  800ba5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ba8:	c9                   	leave  
  800ba9:	c3                   	ret    

00800baa <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	57                   	push   %edi
  800bae:	56                   	push   %esi
  800baf:	83 ec 20             	sub    $0x20,%esp
  800bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  800bbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc4:	89 d1                	mov    %edx,%ecx
  800bc6:	89 c2                	mov    %eax,%edx
  800bc8:	89 ce                	mov    %ecx,%esi
  800bca:	89 d7                	mov    %edx,%edi
  800bcc:	ac                   	lods   %ds:(%esi),%al
  800bcd:	ae                   	scas   %es:(%edi),%al
  800bce:	75 08                	jne    800bd8 <strcmp+0x2e>
  800bd0:	84 c0                	test   %al,%al
  800bd2:	75 f8                	jne    800bcc <strcmp+0x22>
  800bd4:	31 c0                	xor    %eax,%eax
  800bd6:	eb 04                	jmp    800bdc <strcmp+0x32>
  800bd8:	19 c0                	sbb    %eax,%eax
  800bda:	0c 01                	or     $0x1,%al
  800bdc:	89 fa                	mov    %edi,%edx
  800bde:	89 f1                	mov    %esi,%ecx
  800be0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800be3:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  800be6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  800be9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  800bec:	83 c4 20             	add    $0x20,%esp
  800bef:	5e                   	pop    %esi
  800bf0:	5f                   	pop    %edi
  800bf1:	5d                   	pop    %ebp
  800bf2:	c3                   	ret    

00800bf3 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  800bf6:	eb 0c                	jmp    800c04 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  800bf8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800bfc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c00:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  800c04:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c08:	74 1a                	je     800c24 <strncmp+0x31>
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	0f b6 00             	movzbl (%eax),%eax
  800c10:	84 c0                	test   %al,%al
  800c12:	74 10                	je     800c24 <strncmp+0x31>
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	0f b6 10             	movzbl (%eax),%edx
  800c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1d:	0f b6 00             	movzbl (%eax),%eax
  800c20:	38 c2                	cmp    %al,%dl
  800c22:	74 d4                	je     800bf8 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  800c24:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c28:	74 18                	je     800c42 <strncmp+0x4f>
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	0f b6 00             	movzbl (%eax),%eax
  800c30:	0f b6 d0             	movzbl %al,%edx
  800c33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c36:	0f b6 00             	movzbl (%eax),%eax
  800c39:	0f b6 c0             	movzbl %al,%eax
  800c3c:	29 c2                	sub    %eax,%edx
  800c3e:	89 d0                	mov    %edx,%eax
  800c40:	eb 05                	jmp    800c47 <strncmp+0x54>
  800c42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c47:	5d                   	pop    %ebp
  800c48:	c3                   	ret    

00800c49 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	83 ec 04             	sub    $0x4,%esp
  800c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c52:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  800c55:	eb 14                	jmp    800c6b <strchr+0x22>
        if (*s == c) {
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	0f b6 00             	movzbl (%eax),%eax
  800c5d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c60:	75 05                	jne    800c67 <strchr+0x1e>
            return (char *)s;
  800c62:	8b 45 08             	mov    0x8(%ebp),%eax
  800c65:	eb 13                	jmp    800c7a <strchr+0x31>
        }
        s ++;
  800c67:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	0f b6 00             	movzbl (%eax),%eax
  800c71:	84 c0                	test   %al,%al
  800c73:	75 e2                	jne    800c57 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  800c75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c7a:	c9                   	leave  
  800c7b:	c3                   	ret    

00800c7c <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  800c7c:	55                   	push   %ebp
  800c7d:	89 e5                	mov    %esp,%ebp
  800c7f:	83 ec 04             	sub    $0x4,%esp
  800c82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c85:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  800c88:	eb 11                	jmp    800c9b <strfind+0x1f>
        if (*s == c) {
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	0f b6 00             	movzbl (%eax),%eax
  800c90:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c93:	75 02                	jne    800c97 <strfind+0x1b>
            break;
  800c95:	eb 0e                	jmp    800ca5 <strfind+0x29>
        }
        s ++;
  800c97:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	0f b6 00             	movzbl (%eax),%eax
  800ca1:	84 c0                	test   %al,%al
  800ca3:	75 e5                	jne    800c8a <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ca8:	c9                   	leave  
  800ca9:	c3                   	ret    

00800caa <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  800cb0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  800cb7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  800cbe:	eb 04                	jmp    800cc4 <strtol+0x1a>
        s ++;
  800cc0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	0f b6 00             	movzbl (%eax),%eax
  800cca:	3c 20                	cmp    $0x20,%al
  800ccc:	74 f2                	je     800cc0 <strtol+0x16>
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	0f b6 00             	movzbl (%eax),%eax
  800cd4:	3c 09                	cmp    $0x9,%al
  800cd6:	74 e8                	je     800cc0 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	0f b6 00             	movzbl (%eax),%eax
  800cde:	3c 2b                	cmp    $0x2b,%al
  800ce0:	75 06                	jne    800ce8 <strtol+0x3e>
        s ++;
  800ce2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ce6:	eb 15                	jmp    800cfd <strtol+0x53>
    }
    else if (*s == '-') {
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	0f b6 00             	movzbl (%eax),%eax
  800cee:	3c 2d                	cmp    $0x2d,%al
  800cf0:	75 0b                	jne    800cfd <strtol+0x53>
        s ++, neg = 1;
  800cf2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800cf6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800cfd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d01:	74 06                	je     800d09 <strtol+0x5f>
  800d03:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d07:	75 24                	jne    800d2d <strtol+0x83>
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	0f b6 00             	movzbl (%eax),%eax
  800d0f:	3c 30                	cmp    $0x30,%al
  800d11:	75 1a                	jne    800d2d <strtol+0x83>
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	83 c0 01             	add    $0x1,%eax
  800d19:	0f b6 00             	movzbl (%eax),%eax
  800d1c:	3c 78                	cmp    $0x78,%al
  800d1e:	75 0d                	jne    800d2d <strtol+0x83>
        s += 2, base = 16;
  800d20:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d24:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d2b:	eb 2a                	jmp    800d57 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  800d2d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d31:	75 17                	jne    800d4a <strtol+0xa0>
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	0f b6 00             	movzbl (%eax),%eax
  800d39:	3c 30                	cmp    $0x30,%al
  800d3b:	75 0d                	jne    800d4a <strtol+0xa0>
        s ++, base = 8;
  800d3d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d41:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d48:	eb 0d                	jmp    800d57 <strtol+0xad>
    }
    else if (base == 0) {
  800d4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4e:	75 07                	jne    800d57 <strtol+0xad>
        base = 10;
  800d50:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	0f b6 00             	movzbl (%eax),%eax
  800d5d:	3c 2f                	cmp    $0x2f,%al
  800d5f:	7e 1b                	jle    800d7c <strtol+0xd2>
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	0f b6 00             	movzbl (%eax),%eax
  800d67:	3c 39                	cmp    $0x39,%al
  800d69:	7f 11                	jg     800d7c <strtol+0xd2>
            dig = *s - '0';
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	0f b6 00             	movzbl (%eax),%eax
  800d71:	0f be c0             	movsbl %al,%eax
  800d74:	83 e8 30             	sub    $0x30,%eax
  800d77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d7a:	eb 48                	jmp    800dc4 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	0f b6 00             	movzbl (%eax),%eax
  800d82:	3c 60                	cmp    $0x60,%al
  800d84:	7e 1b                	jle    800da1 <strtol+0xf7>
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	0f b6 00             	movzbl (%eax),%eax
  800d8c:	3c 7a                	cmp    $0x7a,%al
  800d8e:	7f 11                	jg     800da1 <strtol+0xf7>
            dig = *s - 'a' + 10;
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	0f b6 00             	movzbl (%eax),%eax
  800d96:	0f be c0             	movsbl %al,%eax
  800d99:	83 e8 57             	sub    $0x57,%eax
  800d9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d9f:	eb 23                	jmp    800dc4 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
  800da4:	0f b6 00             	movzbl (%eax),%eax
  800da7:	3c 40                	cmp    $0x40,%al
  800da9:	7e 3d                	jle    800de8 <strtol+0x13e>
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	0f b6 00             	movzbl (%eax),%eax
  800db1:	3c 5a                	cmp    $0x5a,%al
  800db3:	7f 33                	jg     800de8 <strtol+0x13e>
            dig = *s - 'A' + 10;
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	0f b6 00             	movzbl (%eax),%eax
  800dbb:	0f be c0             	movsbl %al,%eax
  800dbe:	83 e8 37             	sub    $0x37,%eax
  800dc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  800dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dc7:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dca:	7c 02                	jl     800dce <strtol+0x124>
            break;
  800dcc:	eb 1a                	jmp    800de8 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  800dce:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800dd2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd5:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dd9:	89 c2                	mov    %eax,%edx
  800ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dde:	01 d0                	add    %edx,%eax
  800de0:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  800de3:	e9 6f ff ff ff       	jmp    800d57 <strtol+0xad>

    if (endptr) {
  800de8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dec:	74 08                	je     800df6 <strtol+0x14c>
        *endptr = (char *) s;
  800dee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df1:	8b 55 08             	mov    0x8(%ebp),%edx
  800df4:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  800df6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800dfa:	74 07                	je     800e03 <strtol+0x159>
  800dfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dff:	f7 d8                	neg    %eax
  800e01:	eb 03                	jmp    800e06 <strtol+0x15c>
  800e03:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e06:	c9                   	leave  
  800e07:	c3                   	ret    

00800e08 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	57                   	push   %edi
  800e0c:	83 ec 24             	sub    $0x24,%esp
  800e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e12:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  800e15:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800e19:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e1f:	88 45 f7             	mov    %al,-0x9(%ebp)
  800e22:	8b 45 10             	mov    0x10(%ebp),%eax
  800e25:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  800e28:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e2b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800e2f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e32:	89 d7                	mov    %edx,%edi
  800e34:	f3 aa                	rep stos %al,%es:(%edi)
  800e36:	89 fa                	mov    %edi,%edx
  800e38:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  800e3b:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  800e3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  800e41:	83 c4 24             	add    $0x24,%esp
  800e44:	5f                   	pop    %edi
  800e45:	5d                   	pop    %ebp
  800e46:	c3                   	ret    

00800e47 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  800e47:	55                   	push   %ebp
  800e48:	89 e5                	mov    %esp,%ebp
  800e4a:	57                   	push   %edi
  800e4b:	56                   	push   %esi
  800e4c:	53                   	push   %ebx
  800e4d:	83 ec 30             	sub    $0x30,%esp
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e59:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5f:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  800e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e65:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800e68:	73 42                	jae    800eac <memmove+0x65>
  800e6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e6d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e73:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800e76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800e79:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  800e7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800e7f:	c1 e8 02             	shr    $0x2,%eax
  800e82:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  800e84:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800e87:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e8a:	89 d7                	mov    %edx,%edi
  800e8c:	89 c6                	mov    %eax,%esi
  800e8e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e90:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800e93:	83 e1 03             	and    $0x3,%ecx
  800e96:	74 02                	je     800e9a <memmove+0x53>
  800e98:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800e9a:	89 f0                	mov    %esi,%eax
  800e9c:	89 fa                	mov    %edi,%edx
  800e9e:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  800ea1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800ea4:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  800ea7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800eaa:	eb 36                	jmp    800ee2 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  800eac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800eaf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eb5:	01 c2                	add    %eax,%edx
  800eb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800eba:	8d 48 ff             	lea    -0x1(%eax),%ecx
  800ebd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ec0:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  800ec3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ec6:	89 c1                	mov    %eax,%ecx
  800ec8:	89 d8                	mov    %ebx,%eax
  800eca:	89 d6                	mov    %edx,%esi
  800ecc:	89 c7                	mov    %eax,%edi
  800ece:	fd                   	std    
  800ecf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800ed1:	fc                   	cld    
  800ed2:	89 f8                	mov    %edi,%eax
  800ed4:	89 f2                	mov    %esi,%edx
  800ed6:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800ed9:	89 55 c8             	mov    %edx,-0x38(%ebp)
  800edc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  800edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  800ee2:	83 c4 30             	add    $0x30,%esp
  800ee5:	5b                   	pop    %ebx
  800ee6:	5e                   	pop    %esi
  800ee7:	5f                   	pop    %edi
  800ee8:	5d                   	pop    %ebp
  800ee9:	c3                   	ret    

00800eea <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  800eea:	55                   	push   %ebp
  800eeb:	89 e5                	mov    %esp,%ebp
  800eed:	57                   	push   %edi
  800eee:	56                   	push   %esi
  800eef:	83 ec 20             	sub    $0x20,%esp
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ef8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800efe:	8b 45 10             	mov    0x10(%ebp),%eax
  800f01:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  800f04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f07:	c1 e8 02             	shr    $0x2,%eax
  800f0a:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  800f0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f12:	89 d7                	mov    %edx,%edi
  800f14:	89 c6                	mov    %eax,%esi
  800f16:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f18:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  800f1b:	83 e1 03             	and    $0x3,%ecx
  800f1e:	74 02                	je     800f22 <memcpy+0x38>
  800f20:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800f22:	89 f0                	mov    %esi,%eax
  800f24:	89 fa                	mov    %edi,%edx
  800f26:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  800f29:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800f2c:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  800f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  800f32:	83 c4 20             	add    $0x20,%esp
  800f35:	5e                   	pop    %esi
  800f36:	5f                   	pop    %edi
  800f37:	5d                   	pop    %ebp
  800f38:	c3                   	ret    

00800f39 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  800f45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f48:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  800f4b:	eb 30                	jmp    800f7d <memcmp+0x44>
        if (*s1 != *s2) {
  800f4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f50:	0f b6 10             	movzbl (%eax),%edx
  800f53:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f56:	0f b6 00             	movzbl (%eax),%eax
  800f59:	38 c2                	cmp    %al,%dl
  800f5b:	74 18                	je     800f75 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  800f5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f60:	0f b6 00             	movzbl (%eax),%eax
  800f63:	0f b6 d0             	movzbl %al,%edx
  800f66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f69:	0f b6 00             	movzbl (%eax),%eax
  800f6c:	0f b6 c0             	movzbl %al,%eax
  800f6f:	29 c2                	sub    %eax,%edx
  800f71:	89 d0                	mov    %edx,%eax
  800f73:	eb 1a                	jmp    800f8f <memcmp+0x56>
        }
        s1 ++, s2 ++;
  800f75:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800f79:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  800f7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f80:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f83:	89 55 10             	mov    %edx,0x10(%ebp)
  800f86:	85 c0                	test   %eax,%eax
  800f88:	75 c3                	jne    800f4d <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  800f8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f8f:	c9                   	leave  
  800f90:	c3                   	ret    

00800f91 <main>:
#include <stdio.h>
#include <ulib.h>

int
main(void) {
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	83 e4 f0             	and    $0xfffffff0,%esp
  800f97:	83 ec 10             	sub    $0x10,%esp
    cprintf("I am %d, print pgdir.\n", getpid());
  800f9a:	e8 89 f3 ff ff       	call   800328 <getpid>
  800f9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fa3:	c7 04 24 c0 12 80 00 	movl   $0x8012c0,(%esp)
  800faa:	e8 69 f1 ff ff       	call   800118 <cprintf>
    print_pgdir();
  800faf:	e8 81 f3 ff ff       	call   800335 <print_pgdir>
    cprintf("pgdir pass.\n");
  800fb4:	c7 04 24 d7 12 80 00 	movl   $0x8012d7,(%esp)
  800fbb:	e8 58 f1 ff ff       	call   800118 <cprintf>
    return 0;
  800fc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc5:	c9                   	leave  
  800fc6:	c3                   	ret    
