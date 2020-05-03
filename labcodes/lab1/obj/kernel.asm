
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 20 fd 10 00       	mov    $0x10fd20,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 bc 32 00 00       	call   1032e8 <memset>

    cons_init();                // init the console
  10002c:	e8 34 15 00 00       	call   101565 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 80 34 10 00 	movl   $0x103480,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 9c 34 10 00 	movl   $0x10349c,(%esp)
  100046:	e8 c7 02 00 00       	call   100312 <cprintf>

    print_kerninfo();
  10004b:	e8 f6 07 00 00       	call   100846 <print_kerninfo>

    grade_backtrace();
  100050:	e8 86 00 00 00       	call   1000db <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 d4 28 00 00       	call   10292e <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 49 16 00 00       	call   1016a8 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 9b 17 00 00       	call   1017ff <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 ef 0c 00 00       	call   100d58 <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 a8 15 00 00       	call   101616 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10007d:	00 
  10007e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100085:	00 
  100086:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10008d:	e8 f8 0b 00 00       	call   100c8a <mon_backtrace>
}
  100092:	c9                   	leave  
  100093:	c3                   	ret    

00100094 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100094:	55                   	push   %ebp
  100095:	89 e5                	mov    %esp,%ebp
  100097:	53                   	push   %ebx
  100098:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10009b:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  10009e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a1:	8d 55 08             	lea    0x8(%ebp),%edx
  1000a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1000a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000af:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000b3:	89 04 24             	mov    %eax,(%esp)
  1000b6:	e8 b5 ff ff ff       	call   100070 <grade_backtrace2>
}
  1000bb:	83 c4 14             	add    $0x14,%esp
  1000be:	5b                   	pop    %ebx
  1000bf:	5d                   	pop    %ebp
  1000c0:	c3                   	ret    

001000c1 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c1:	55                   	push   %ebp
  1000c2:	89 e5                	mov    %esp,%ebp
  1000c4:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1000ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 04 24             	mov    %eax,(%esp)
  1000d4:	e8 bb ff ff ff       	call   100094 <grade_backtrace1>
}
  1000d9:	c9                   	leave  
  1000da:	c3                   	ret    

001000db <grade_backtrace>:

void
grade_backtrace(void) {
  1000db:	55                   	push   %ebp
  1000dc:	89 e5                	mov    %esp,%ebp
  1000de:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e1:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000e6:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000ed:	ff 
  1000ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000f9:	e8 c3 ff ff ff       	call   1000c1 <grade_backtrace0>
}
  1000fe:	c9                   	leave  
  1000ff:	c3                   	ret    

00100100 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100100:	55                   	push   %ebp
  100101:	89 e5                	mov    %esp,%ebp
  100103:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100106:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100109:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10010c:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10010f:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100112:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100116:	0f b7 c0             	movzwl %ax,%eax
  100119:	83 e0 03             	and    $0x3,%eax
  10011c:	89 c2                	mov    %eax,%edx
  10011e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100123:	89 54 24 08          	mov    %edx,0x8(%esp)
  100127:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012b:	c7 04 24 a1 34 10 00 	movl   $0x1034a1,(%esp)
  100132:	e8 db 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100137:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10013b:	0f b7 d0             	movzwl %ax,%edx
  10013e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100143:	89 54 24 08          	mov    %edx,0x8(%esp)
  100147:	89 44 24 04          	mov    %eax,0x4(%esp)
  10014b:	c7 04 24 af 34 10 00 	movl   $0x1034af,(%esp)
  100152:	e8 bb 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100157:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10015b:	0f b7 d0             	movzwl %ax,%edx
  10015e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100163:	89 54 24 08          	mov    %edx,0x8(%esp)
  100167:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016b:	c7 04 24 bd 34 10 00 	movl   $0x1034bd,(%esp)
  100172:	e8 9b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100177:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017b:	0f b7 d0             	movzwl %ax,%edx
  10017e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100183:	89 54 24 08          	mov    %edx,0x8(%esp)
  100187:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018b:	c7 04 24 cb 34 10 00 	movl   $0x1034cb,(%esp)
  100192:	e8 7b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  100197:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019b:	0f b7 d0             	movzwl %ax,%edx
  10019e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ab:	c7 04 24 d9 34 10 00 	movl   $0x1034d9,(%esp)
  1001b2:	e8 5b 01 00 00       	call   100312 <cprintf>
    round ++;
  1001b7:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001bc:	83 c0 01             	add    $0x1,%eax
  1001bf:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c4:	c9                   	leave  
  1001c5:	c3                   	ret    

001001c6 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c6:	55                   	push   %ebp
  1001c7:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001c9:	5d                   	pop    %ebp
  1001ca:	c3                   	ret    

001001cb <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001cb:	55                   	push   %ebp
  1001cc:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001ce:	5d                   	pop    %ebp
  1001cf:	c3                   	ret    

001001d0 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d0:	55                   	push   %ebp
  1001d1:	89 e5                	mov    %esp,%ebp
  1001d3:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001d6:	e8 25 ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001db:	c7 04 24 e8 34 10 00 	movl   $0x1034e8,(%esp)
  1001e2:	e8 2b 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_user();
  1001e7:	e8 da ff ff ff       	call   1001c6 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ec:	e8 0f ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f1:	c7 04 24 08 35 10 00 	movl   $0x103508,(%esp)
  1001f8:	e8 15 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_kernel();
  1001fd:	e8 c9 ff ff ff       	call   1001cb <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100202:	e8 f9 fe ff ff       	call   100100 <lab1_print_cur_status>
}
  100207:	c9                   	leave  
  100208:	c3                   	ret    

00100209 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100209:	55                   	push   %ebp
  10020a:	89 e5                	mov    %esp,%ebp
  10020c:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10020f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100213:	74 13                	je     100228 <readline+0x1f>
        cprintf("%s", prompt);
  100215:	8b 45 08             	mov    0x8(%ebp),%eax
  100218:	89 44 24 04          	mov    %eax,0x4(%esp)
  10021c:	c7 04 24 27 35 10 00 	movl   $0x103527,(%esp)
  100223:	e8 ea 00 00 00       	call   100312 <cprintf>
    }
    int i = 0, c;
  100228:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10022f:	e8 66 01 00 00       	call   10039a <getchar>
  100234:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100237:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10023b:	79 07                	jns    100244 <readline+0x3b>
            return NULL;
  10023d:	b8 00 00 00 00       	mov    $0x0,%eax
  100242:	eb 79                	jmp    1002bd <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100244:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100248:	7e 28                	jle    100272 <readline+0x69>
  10024a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100251:	7f 1f                	jg     100272 <readline+0x69>
            cputchar(c);
  100253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100256:	89 04 24             	mov    %eax,(%esp)
  100259:	e8 da 00 00 00       	call   100338 <cputchar>
            buf[i ++] = c;
  10025e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100261:	8d 50 01             	lea    0x1(%eax),%edx
  100264:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100267:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10026a:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100270:	eb 46                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100272:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100276:	75 17                	jne    10028f <readline+0x86>
  100278:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10027c:	7e 11                	jle    10028f <readline+0x86>
            cputchar(c);
  10027e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100281:	89 04 24             	mov    %eax,(%esp)
  100284:	e8 af 00 00 00       	call   100338 <cputchar>
            i --;
  100289:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10028d:	eb 29                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  10028f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100293:	74 06                	je     10029b <readline+0x92>
  100295:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100299:	75 1d                	jne    1002b8 <readline+0xaf>
            cputchar(c);
  10029b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10029e:	89 04 24             	mov    %eax,(%esp)
  1002a1:	e8 92 00 00 00       	call   100338 <cputchar>
            buf[i] = '\0';
  1002a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002a9:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1002ae:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002b1:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1002b6:	eb 05                	jmp    1002bd <readline+0xb4>
        }
    }
  1002b8:	e9 72 ff ff ff       	jmp    10022f <readline+0x26>
}
  1002bd:	c9                   	leave  
  1002be:	c3                   	ret    

001002bf <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002bf:	55                   	push   %ebp
  1002c0:	89 e5                	mov    %esp,%ebp
  1002c2:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 c1 12 00 00       	call   101591 <cons_putc>
    (*cnt) ++;
  1002d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002d3:	8b 00                	mov    (%eax),%eax
  1002d5:	8d 50 01             	lea    0x1(%eax),%edx
  1002d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002db:	89 10                	mov    %edx,(%eax)
}
  1002dd:	c9                   	leave  
  1002de:	c3                   	ret    

001002df <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002df:	55                   	push   %ebp
  1002e0:	89 e5                	mov    %esp,%ebp
  1002e2:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1002fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100301:	c7 04 24 bf 02 10 00 	movl   $0x1002bf,(%esp)
  100308:	e8 f4 27 00 00       	call   102b01 <vprintfmt>
    return cnt;
  10030d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100310:	c9                   	leave  
  100311:	c3                   	ret    

00100312 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100312:	55                   	push   %ebp
  100313:	89 e5                	mov    %esp,%ebp
  100315:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100318:	8d 45 0c             	lea    0xc(%ebp),%eax
  10031b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10031e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100321:	89 44 24 04          	mov    %eax,0x4(%esp)
  100325:	8b 45 08             	mov    0x8(%ebp),%eax
  100328:	89 04 24             	mov    %eax,(%esp)
  10032b:	e8 af ff ff ff       	call   1002df <vcprintf>
  100330:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100333:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100336:	c9                   	leave  
  100337:	c3                   	ret    

00100338 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100338:	55                   	push   %ebp
  100339:	89 e5                	mov    %esp,%ebp
  10033b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10033e:	8b 45 08             	mov    0x8(%ebp),%eax
  100341:	89 04 24             	mov    %eax,(%esp)
  100344:	e8 48 12 00 00       	call   101591 <cons_putc>
}
  100349:	c9                   	leave  
  10034a:	c3                   	ret    

0010034b <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10034b:	55                   	push   %ebp
  10034c:	89 e5                	mov    %esp,%ebp
  10034e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100351:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100358:	eb 13                	jmp    10036d <cputs+0x22>
        cputch(c, &cnt);
  10035a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10035e:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100361:	89 54 24 04          	mov    %edx,0x4(%esp)
  100365:	89 04 24             	mov    %eax,(%esp)
  100368:	e8 52 ff ff ff       	call   1002bf <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  10036d:	8b 45 08             	mov    0x8(%ebp),%eax
  100370:	8d 50 01             	lea    0x1(%eax),%edx
  100373:	89 55 08             	mov    %edx,0x8(%ebp)
  100376:	0f b6 00             	movzbl (%eax),%eax
  100379:	88 45 f7             	mov    %al,-0x9(%ebp)
  10037c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100380:	75 d8                	jne    10035a <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  100382:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100385:	89 44 24 04          	mov    %eax,0x4(%esp)
  100389:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100390:	e8 2a ff ff ff       	call   1002bf <cputch>
    return cnt;
  100395:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100398:	c9                   	leave  
  100399:	c3                   	ret    

0010039a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10039a:	55                   	push   %ebp
  10039b:	89 e5                	mov    %esp,%ebp
  10039d:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003a0:	e8 15 12 00 00       	call   1015ba <cons_getc>
  1003a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003ac:	74 f2                	je     1003a0 <getchar+0x6>
        /* do nothing */;
    return c;
  1003ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003b1:	c9                   	leave  
  1003b2:	c3                   	ret    

001003b3 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003b3:	55                   	push   %ebp
  1003b4:	89 e5                	mov    %esp,%ebp
  1003b6:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003bc:	8b 00                	mov    (%eax),%eax
  1003be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1003c4:	8b 00                	mov    (%eax),%eax
  1003c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003d0:	e9 d2 00 00 00       	jmp    1004a7 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003db:	01 d0                	add    %edx,%eax
  1003dd:	89 c2                	mov    %eax,%edx
  1003df:	c1 ea 1f             	shr    $0x1f,%edx
  1003e2:	01 d0                	add    %edx,%eax
  1003e4:	d1 f8                	sar    %eax
  1003e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003ec:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003ef:	eb 04                	jmp    1003f5 <stab_binsearch+0x42>
            m --;
  1003f1:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1003fb:	7c 1f                	jl     10041c <stab_binsearch+0x69>
  1003fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100400:	89 d0                	mov    %edx,%eax
  100402:	01 c0                	add    %eax,%eax
  100404:	01 d0                	add    %edx,%eax
  100406:	c1 e0 02             	shl    $0x2,%eax
  100409:	89 c2                	mov    %eax,%edx
  10040b:	8b 45 08             	mov    0x8(%ebp),%eax
  10040e:	01 d0                	add    %edx,%eax
  100410:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100414:	0f b6 c0             	movzbl %al,%eax
  100417:	3b 45 14             	cmp    0x14(%ebp),%eax
  10041a:	75 d5                	jne    1003f1 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  10041c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10041f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100422:	7d 0b                	jge    10042f <stab_binsearch+0x7c>
            l = true_m + 1;
  100424:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100427:	83 c0 01             	add    $0x1,%eax
  10042a:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10042d:	eb 78                	jmp    1004a7 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10042f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100436:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100439:	89 d0                	mov    %edx,%eax
  10043b:	01 c0                	add    %eax,%eax
  10043d:	01 d0                	add    %edx,%eax
  10043f:	c1 e0 02             	shl    $0x2,%eax
  100442:	89 c2                	mov    %eax,%edx
  100444:	8b 45 08             	mov    0x8(%ebp),%eax
  100447:	01 d0                	add    %edx,%eax
  100449:	8b 40 08             	mov    0x8(%eax),%eax
  10044c:	3b 45 18             	cmp    0x18(%ebp),%eax
  10044f:	73 13                	jae    100464 <stab_binsearch+0xb1>
            *region_left = m;
  100451:	8b 45 0c             	mov    0xc(%ebp),%eax
  100454:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100457:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10045c:	83 c0 01             	add    $0x1,%eax
  10045f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100462:	eb 43                	jmp    1004a7 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100464:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100467:	89 d0                	mov    %edx,%eax
  100469:	01 c0                	add    %eax,%eax
  10046b:	01 d0                	add    %edx,%eax
  10046d:	c1 e0 02             	shl    $0x2,%eax
  100470:	89 c2                	mov    %eax,%edx
  100472:	8b 45 08             	mov    0x8(%ebp),%eax
  100475:	01 d0                	add    %edx,%eax
  100477:	8b 40 08             	mov    0x8(%eax),%eax
  10047a:	3b 45 18             	cmp    0x18(%ebp),%eax
  10047d:	76 16                	jbe    100495 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10047f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100482:	8d 50 ff             	lea    -0x1(%eax),%edx
  100485:	8b 45 10             	mov    0x10(%ebp),%eax
  100488:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10048d:	83 e8 01             	sub    $0x1,%eax
  100490:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100493:	eb 12                	jmp    1004a7 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100495:	8b 45 0c             	mov    0xc(%ebp),%eax
  100498:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10049b:	89 10                	mov    %edx,(%eax)
            l = m;
  10049d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004a3:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004ad:	0f 8e 22 ff ff ff    	jle    1003d5 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004b7:	75 0f                	jne    1004c8 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004bc:	8b 00                	mov    (%eax),%eax
  1004be:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c4:	89 10                	mov    %edx,(%eax)
  1004c6:	eb 3f                	jmp    100507 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004c8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004cb:	8b 00                	mov    (%eax),%eax
  1004cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004d0:	eb 04                	jmp    1004d6 <stab_binsearch+0x123>
  1004d2:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1004d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004d9:	8b 00                	mov    (%eax),%eax
  1004db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004de:	7d 1f                	jge    1004ff <stab_binsearch+0x14c>
  1004e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004e3:	89 d0                	mov    %edx,%eax
  1004e5:	01 c0                	add    %eax,%eax
  1004e7:	01 d0                	add    %edx,%eax
  1004e9:	c1 e0 02             	shl    $0x2,%eax
  1004ec:	89 c2                	mov    %eax,%edx
  1004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1004f1:	01 d0                	add    %edx,%eax
  1004f3:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f7:	0f b6 c0             	movzbl %al,%eax
  1004fa:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004fd:	75 d3                	jne    1004d2 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100502:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100505:	89 10                	mov    %edx,(%eax)
    }
}
  100507:	c9                   	leave  
  100508:	c3                   	ret    

00100509 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100509:	55                   	push   %ebp
  10050a:	89 e5                	mov    %esp,%ebp
  10050c:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10050f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100512:	c7 00 2c 35 10 00    	movl   $0x10352c,(%eax)
    info->eip_line = 0;
  100518:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100522:	8b 45 0c             	mov    0xc(%ebp),%eax
  100525:	c7 40 08 2c 35 10 00 	movl   $0x10352c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10052c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052f:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100536:	8b 45 0c             	mov    0xc(%ebp),%eax
  100539:	8b 55 08             	mov    0x8(%ebp),%edx
  10053c:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10053f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100542:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100549:	c7 45 f4 8c 3d 10 00 	movl   $0x103d8c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100550:	c7 45 f0 b4 b4 10 00 	movl   $0x10b4b4,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100557:	c7 45 ec b5 b4 10 00 	movl   $0x10b4b5,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10055e:	c7 45 e8 a0 d4 10 00 	movl   $0x10d4a0,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100565:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100568:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10056b:	76 0d                	jbe    10057a <debuginfo_eip+0x71>
  10056d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100570:	83 e8 01             	sub    $0x1,%eax
  100573:	0f b6 00             	movzbl (%eax),%eax
  100576:	84 c0                	test   %al,%al
  100578:	74 0a                	je     100584 <debuginfo_eip+0x7b>
        return -1;
  10057a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10057f:	e9 c0 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100584:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10058b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10058e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100591:	29 c2                	sub    %eax,%edx
  100593:	89 d0                	mov    %edx,%eax
  100595:	c1 f8 02             	sar    $0x2,%eax
  100598:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10059e:	83 e8 01             	sub    $0x1,%eax
  1005a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005a7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005ab:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005b2:	00 
  1005b3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005c4:	89 04 24             	mov    %eax,(%esp)
  1005c7:	e8 e7 fd ff ff       	call   1003b3 <stab_binsearch>
    if (lfile == 0)
  1005cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005cf:	85 c0                	test   %eax,%eax
  1005d1:	75 0a                	jne    1005dd <debuginfo_eip+0xd4>
        return -1;
  1005d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005d8:	e9 67 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005f0:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1005f7:	00 
  1005f8:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1005fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ff:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100602:	89 44 24 04          	mov    %eax,0x4(%esp)
  100606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100609:	89 04 24             	mov    %eax,(%esp)
  10060c:	e8 a2 fd ff ff       	call   1003b3 <stab_binsearch>

    if (lfun <= rfun) {
  100611:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100614:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100617:	39 c2                	cmp    %eax,%edx
  100619:	7f 7c                	jg     100697 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10061b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10061e:	89 c2                	mov    %eax,%edx
  100620:	89 d0                	mov    %edx,%eax
  100622:	01 c0                	add    %eax,%eax
  100624:	01 d0                	add    %edx,%eax
  100626:	c1 e0 02             	shl    $0x2,%eax
  100629:	89 c2                	mov    %eax,%edx
  10062b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10062e:	01 d0                	add    %edx,%eax
  100630:	8b 10                	mov    (%eax),%edx
  100632:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100638:	29 c1                	sub    %eax,%ecx
  10063a:	89 c8                	mov    %ecx,%eax
  10063c:	39 c2                	cmp    %eax,%edx
  10063e:	73 22                	jae    100662 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100640:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100643:	89 c2                	mov    %eax,%edx
  100645:	89 d0                	mov    %edx,%eax
  100647:	01 c0                	add    %eax,%eax
  100649:	01 d0                	add    %edx,%eax
  10064b:	c1 e0 02             	shl    $0x2,%eax
  10064e:	89 c2                	mov    %eax,%edx
  100650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100653:	01 d0                	add    %edx,%eax
  100655:	8b 10                	mov    (%eax),%edx
  100657:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10065a:	01 c2                	add    %eax,%edx
  10065c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10065f:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100662:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100665:	89 c2                	mov    %eax,%edx
  100667:	89 d0                	mov    %edx,%eax
  100669:	01 c0                	add    %eax,%eax
  10066b:	01 d0                	add    %edx,%eax
  10066d:	c1 e0 02             	shl    $0x2,%eax
  100670:	89 c2                	mov    %eax,%edx
  100672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100675:	01 d0                	add    %edx,%eax
  100677:	8b 50 08             	mov    0x8(%eax),%edx
  10067a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10067d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100680:	8b 45 0c             	mov    0xc(%ebp),%eax
  100683:	8b 40 10             	mov    0x10(%eax),%eax
  100686:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100689:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10068f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100692:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100695:	eb 15                	jmp    1006ac <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100697:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069a:	8b 55 08             	mov    0x8(%ebp),%edx
  10069d:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006af:	8b 40 08             	mov    0x8(%eax),%eax
  1006b2:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006b9:	00 
  1006ba:	89 04 24             	mov    %eax,(%esp)
  1006bd:	e8 9a 2a 00 00       	call   10315c <strfind>
  1006c2:	89 c2                	mov    %eax,%edx
  1006c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c7:	8b 40 08             	mov    0x8(%eax),%eax
  1006ca:	29 c2                	sub    %eax,%edx
  1006cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006cf:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1006d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006d9:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006e0:	00 
  1006e1:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006e8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f2:	89 04 24             	mov    %eax,(%esp)
  1006f5:	e8 b9 fc ff ff       	call   1003b3 <stab_binsearch>
    if (lline <= rline) {
  1006fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1006fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100700:	39 c2                	cmp    %eax,%edx
  100702:	7f 24                	jg     100728 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  100704:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100707:	89 c2                	mov    %eax,%edx
  100709:	89 d0                	mov    %edx,%eax
  10070b:	01 c0                	add    %eax,%eax
  10070d:	01 d0                	add    %edx,%eax
  10070f:	c1 e0 02             	shl    $0x2,%eax
  100712:	89 c2                	mov    %eax,%edx
  100714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100717:	01 d0                	add    %edx,%eax
  100719:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10071d:	0f b7 d0             	movzwl %ax,%edx
  100720:	8b 45 0c             	mov    0xc(%ebp),%eax
  100723:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100726:	eb 13                	jmp    10073b <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10072d:	e9 12 01 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100732:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100735:	83 e8 01             	sub    $0x1,%eax
  100738:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10073b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10073e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100741:	39 c2                	cmp    %eax,%edx
  100743:	7c 56                	jl     10079b <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100745:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100748:	89 c2                	mov    %eax,%edx
  10074a:	89 d0                	mov    %edx,%eax
  10074c:	01 c0                	add    %eax,%eax
  10074e:	01 d0                	add    %edx,%eax
  100750:	c1 e0 02             	shl    $0x2,%eax
  100753:	89 c2                	mov    %eax,%edx
  100755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100758:	01 d0                	add    %edx,%eax
  10075a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10075e:	3c 84                	cmp    $0x84,%al
  100760:	74 39                	je     10079b <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100762:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100765:	89 c2                	mov    %eax,%edx
  100767:	89 d0                	mov    %edx,%eax
  100769:	01 c0                	add    %eax,%eax
  10076b:	01 d0                	add    %edx,%eax
  10076d:	c1 e0 02             	shl    $0x2,%eax
  100770:	89 c2                	mov    %eax,%edx
  100772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100775:	01 d0                	add    %edx,%eax
  100777:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10077b:	3c 64                	cmp    $0x64,%al
  10077d:	75 b3                	jne    100732 <debuginfo_eip+0x229>
  10077f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100782:	89 c2                	mov    %eax,%edx
  100784:	89 d0                	mov    %edx,%eax
  100786:	01 c0                	add    %eax,%eax
  100788:	01 d0                	add    %edx,%eax
  10078a:	c1 e0 02             	shl    $0x2,%eax
  10078d:	89 c2                	mov    %eax,%edx
  10078f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100792:	01 d0                	add    %edx,%eax
  100794:	8b 40 08             	mov    0x8(%eax),%eax
  100797:	85 c0                	test   %eax,%eax
  100799:	74 97                	je     100732 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10079b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10079e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007a1:	39 c2                	cmp    %eax,%edx
  1007a3:	7c 46                	jl     1007eb <debuginfo_eip+0x2e2>
  1007a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007a8:	89 c2                	mov    %eax,%edx
  1007aa:	89 d0                	mov    %edx,%eax
  1007ac:	01 c0                	add    %eax,%eax
  1007ae:	01 d0                	add    %edx,%eax
  1007b0:	c1 e0 02             	shl    $0x2,%eax
  1007b3:	89 c2                	mov    %eax,%edx
  1007b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b8:	01 d0                	add    %edx,%eax
  1007ba:	8b 10                	mov    (%eax),%edx
  1007bc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007c2:	29 c1                	sub    %eax,%ecx
  1007c4:	89 c8                	mov    %ecx,%eax
  1007c6:	39 c2                	cmp    %eax,%edx
  1007c8:	73 21                	jae    1007eb <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007cd:	89 c2                	mov    %eax,%edx
  1007cf:	89 d0                	mov    %edx,%eax
  1007d1:	01 c0                	add    %eax,%eax
  1007d3:	01 d0                	add    %edx,%eax
  1007d5:	c1 e0 02             	shl    $0x2,%eax
  1007d8:	89 c2                	mov    %eax,%edx
  1007da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007dd:	01 d0                	add    %edx,%eax
  1007df:	8b 10                	mov    (%eax),%edx
  1007e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007e4:	01 c2                	add    %eax,%edx
  1007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007f1:	39 c2                	cmp    %eax,%edx
  1007f3:	7d 4a                	jge    10083f <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  1007f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007f8:	83 c0 01             	add    $0x1,%eax
  1007fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1007fe:	eb 18                	jmp    100818 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100800:	8b 45 0c             	mov    0xc(%ebp),%eax
  100803:	8b 40 14             	mov    0x14(%eax),%eax
  100806:	8d 50 01             	lea    0x1(%eax),%edx
  100809:	8b 45 0c             	mov    0xc(%ebp),%eax
  10080c:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  10080f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100812:	83 c0 01             	add    $0x1,%eax
  100815:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100818:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10081b:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  10081e:	39 c2                	cmp    %eax,%edx
  100820:	7d 1d                	jge    10083f <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100822:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100825:	89 c2                	mov    %eax,%edx
  100827:	89 d0                	mov    %edx,%eax
  100829:	01 c0                	add    %eax,%eax
  10082b:	01 d0                	add    %edx,%eax
  10082d:	c1 e0 02             	shl    $0x2,%eax
  100830:	89 c2                	mov    %eax,%edx
  100832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100835:	01 d0                	add    %edx,%eax
  100837:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10083b:	3c a0                	cmp    $0xa0,%al
  10083d:	74 c1                	je     100800 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  10083f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100844:	c9                   	leave  
  100845:	c3                   	ret    

00100846 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100846:	55                   	push   %ebp
  100847:	89 e5                	mov    %esp,%ebp
  100849:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10084c:	c7 04 24 36 35 10 00 	movl   $0x103536,(%esp)
  100853:	e8 ba fa ff ff       	call   100312 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100858:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10085f:	00 
  100860:	c7 04 24 4f 35 10 00 	movl   $0x10354f,(%esp)
  100867:	e8 a6 fa ff ff       	call   100312 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10086c:	c7 44 24 04 71 34 10 	movl   $0x103471,0x4(%esp)
  100873:	00 
  100874:	c7 04 24 67 35 10 00 	movl   $0x103567,(%esp)
  10087b:	e8 92 fa ff ff       	call   100312 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100880:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100887:	00 
  100888:	c7 04 24 7f 35 10 00 	movl   $0x10357f,(%esp)
  10088f:	e8 7e fa ff ff       	call   100312 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100894:	c7 44 24 04 20 fd 10 	movl   $0x10fd20,0x4(%esp)
  10089b:	00 
  10089c:	c7 04 24 97 35 10 00 	movl   $0x103597,(%esp)
  1008a3:	e8 6a fa ff ff       	call   100312 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008a8:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  1008ad:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008b3:	b8 00 00 10 00       	mov    $0x100000,%eax
  1008b8:	29 c2                	sub    %eax,%edx
  1008ba:	89 d0                	mov    %edx,%eax
  1008bc:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008c2:	85 c0                	test   %eax,%eax
  1008c4:	0f 48 c2             	cmovs  %edx,%eax
  1008c7:	c1 f8 0a             	sar    $0xa,%eax
  1008ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ce:	c7 04 24 b0 35 10 00 	movl   $0x1035b0,(%esp)
  1008d5:	e8 38 fa ff ff       	call   100312 <cprintf>
}
  1008da:	c9                   	leave  
  1008db:	c3                   	ret    

001008dc <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008dc:	55                   	push   %ebp
  1008dd:	89 e5                	mov    %esp,%ebp
  1008df:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008e5:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1008ef:	89 04 24             	mov    %eax,(%esp)
  1008f2:	e8 12 fc ff ff       	call   100509 <debuginfo_eip>
  1008f7:	85 c0                	test   %eax,%eax
  1008f9:	74 15                	je     100910 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1008fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  100902:	c7 04 24 da 35 10 00 	movl   $0x1035da,(%esp)
  100909:	e8 04 fa ff ff       	call   100312 <cprintf>
  10090e:	eb 6d                	jmp    10097d <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100917:	eb 1c                	jmp    100935 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100919:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10091c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10091f:	01 d0                	add    %edx,%eax
  100921:	0f b6 00             	movzbl (%eax),%eax
  100924:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10092a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10092d:	01 ca                	add    %ecx,%edx
  10092f:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100931:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100935:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100938:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10093b:	7f dc                	jg     100919 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  10093d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100946:	01 d0                	add    %edx,%eax
  100948:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  10094b:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10094e:	8b 55 08             	mov    0x8(%ebp),%edx
  100951:	89 d1                	mov    %edx,%ecx
  100953:	29 c1                	sub    %eax,%ecx
  100955:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100958:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10095b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10095f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100965:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100969:	89 54 24 08          	mov    %edx,0x8(%esp)
  10096d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100971:	c7 04 24 f6 35 10 00 	movl   $0x1035f6,(%esp)
  100978:	e8 95 f9 ff ff       	call   100312 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  10097d:	c9                   	leave  
  10097e:	c3                   	ret    

0010097f <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10097f:	55                   	push   %ebp
  100980:	89 e5                	mov    %esp,%ebp
  100982:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100985:	8b 45 04             	mov    0x4(%ebp),%eax
  100988:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  10098b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10098e:	c9                   	leave  
  10098f:	c3                   	ret    

00100990 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100990:	55                   	push   %ebp
  100991:	89 e5                	mov    %esp,%ebp
  100993:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100996:	89 e8                	mov    %ebp,%eax
  100998:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  10099b:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
  10099e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
  1009a1:	e8 d9 ff ff ff       	call   10097f <read_eip>
  1009a6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	// 循环打印，直到 STACKFRAME_DEPTH 栈的深度已经最大，并且还要满足ebp ！= 0
	int i;
	for (i = 0; i < STACKFRAME_DEPTH && ebp != 0; i++) {
  1009a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009b0:	e9 88 00 00 00       	jmp    100a3d <print_stackframe+0xad>
		cprintf("ebp: 0x%08x eip: 0x%08x args: ", ebp, eip);
  1009b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009b8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009c3:	c7 04 24 08 36 10 00 	movl   $0x103608,(%esp)
  1009ca:	e8 43 f9 ff ff       	call   100312 <cprintf>

		// ebp + 2才是第一个参数的地址，具体可以看笔记
		uint32_t *args = (uint32_t *)ebp + 2;
  1009cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009d2:	83 c0 08             	add    $0x8,%eax
  1009d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		// 循环打印4个args
		int j;
		for (j = 0; j < 4; j++) {
  1009d8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1009df:	eb 25                	jmp    100a06 <print_stackframe+0x76>
			cprintf("0x%08x ", args[j]);
  1009e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1009eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1009ee:	01 d0                	add    %edx,%eax
  1009f0:	8b 00                	mov    (%eax),%eax
  1009f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f6:	c7 04 24 27 36 10 00 	movl   $0x103627,(%esp)
  1009fd:	e8 10 f9 ff ff       	call   100312 <cprintf>
		// ebp + 2才是第一个参数的地址，具体可以看笔记
		uint32_t *args = (uint32_t *)ebp + 2;

		// 循环打印4个args
		int j;
		for (j = 0; j < 4; j++) {
  100a02:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a06:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a0a:	7e d5                	jle    1009e1 <print_stackframe+0x51>
			cprintf("0x%08x ", args[j]);
		}
		cprintf("\n");
  100a0c:	c7 04 24 2f 36 10 00 	movl   $0x10362f,(%esp)
  100a13:	e8 fa f8 ff ff       	call   100312 <cprintf>

		// 打印 kern/debug/kdebug.c:305: print_stackframe+22 类似这行的东西，应该是调试信息
		print_debuginfo(eip-1);
  100a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a1b:	83 e8 01             	sub    $0x1,%eax
  100a1e:	89 04 24             	mov    %eax,(%esp)
  100a21:	e8 b6 fe ff ff       	call   1008dc <print_debuginfo>

		// 先把eip指向ebp+1的位置，即函数的返回地址（Return Address）
		eip = *((uint32_t *)ebp + 1);
  100a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a29:	83 c0 04             	add    $0x4,%eax
  100a2c:	8b 00                	mov    (%eax),%eax
  100a2e:	89 45 f0             	mov    %eax,-0x10(%ebp)

		// ebp的内容给ebp回到上层调用函数
		ebp = *((uint32_t *)ebp);
  100a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a34:	8b 00                	mov    (%eax),%eax
  100a36:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();

	// 循环打印，直到 STACKFRAME_DEPTH 栈的深度已经最大，并且还要满足ebp ！= 0
	int i;
	for (i = 0; i < STACKFRAME_DEPTH && ebp != 0; i++) {
  100a39:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a3d:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a41:	7f 0a                	jg     100a4d <print_stackframe+0xbd>
  100a43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a47:	0f 85 68 ff ff ff    	jne    1009b5 <print_stackframe+0x25>
		eip = *((uint32_t *)ebp + 1);

		// ebp的内容给ebp回到上层调用函数
		ebp = *((uint32_t *)ebp);
	}
}
  100a4d:	c9                   	leave  
  100a4e:	c3                   	ret    

00100a4f <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a4f:	55                   	push   %ebp
  100a50:	89 e5                	mov    %esp,%ebp
  100a52:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a5c:	eb 0c                	jmp    100a6a <parse+0x1b>
            *buf ++ = '\0';
  100a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  100a61:	8d 50 01             	lea    0x1(%eax),%edx
  100a64:	89 55 08             	mov    %edx,0x8(%ebp)
  100a67:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  100a6d:	0f b6 00             	movzbl (%eax),%eax
  100a70:	84 c0                	test   %al,%al
  100a72:	74 1d                	je     100a91 <parse+0x42>
  100a74:	8b 45 08             	mov    0x8(%ebp),%eax
  100a77:	0f b6 00             	movzbl (%eax),%eax
  100a7a:	0f be c0             	movsbl %al,%eax
  100a7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a81:	c7 04 24 b4 36 10 00 	movl   $0x1036b4,(%esp)
  100a88:	e8 9c 26 00 00       	call   103129 <strchr>
  100a8d:	85 c0                	test   %eax,%eax
  100a8f:	75 cd                	jne    100a5e <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100a91:	8b 45 08             	mov    0x8(%ebp),%eax
  100a94:	0f b6 00             	movzbl (%eax),%eax
  100a97:	84 c0                	test   %al,%al
  100a99:	75 02                	jne    100a9d <parse+0x4e>
            break;
  100a9b:	eb 67                	jmp    100b04 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100a9d:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100aa1:	75 14                	jne    100ab7 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100aa3:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100aaa:	00 
  100aab:	c7 04 24 b9 36 10 00 	movl   $0x1036b9,(%esp)
  100ab2:	e8 5b f8 ff ff       	call   100312 <cprintf>
        }
        argv[argc ++] = buf;
  100ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aba:	8d 50 01             	lea    0x1(%eax),%edx
  100abd:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100ac0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ac7:	8b 45 0c             	mov    0xc(%ebp),%eax
  100aca:	01 c2                	add    %eax,%edx
  100acc:	8b 45 08             	mov    0x8(%ebp),%eax
  100acf:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ad1:	eb 04                	jmp    100ad7 <parse+0x88>
            buf ++;
  100ad3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  100ada:	0f b6 00             	movzbl (%eax),%eax
  100add:	84 c0                	test   %al,%al
  100adf:	74 1d                	je     100afe <parse+0xaf>
  100ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  100ae4:	0f b6 00             	movzbl (%eax),%eax
  100ae7:	0f be c0             	movsbl %al,%eax
  100aea:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aee:	c7 04 24 b4 36 10 00 	movl   $0x1036b4,(%esp)
  100af5:	e8 2f 26 00 00       	call   103129 <strchr>
  100afa:	85 c0                	test   %eax,%eax
  100afc:	74 d5                	je     100ad3 <parse+0x84>
            buf ++;
        }
    }
  100afe:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100aff:	e9 66 ff ff ff       	jmp    100a6a <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b07:	c9                   	leave  
  100b08:	c3                   	ret    

00100b09 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b09:	55                   	push   %ebp
  100b0a:	89 e5                	mov    %esp,%ebp
  100b0c:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b0f:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b12:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b16:	8b 45 08             	mov    0x8(%ebp),%eax
  100b19:	89 04 24             	mov    %eax,(%esp)
  100b1c:	e8 2e ff ff ff       	call   100a4f <parse>
  100b21:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b28:	75 0a                	jne    100b34 <runcmd+0x2b>
        return 0;
  100b2a:	b8 00 00 00 00       	mov    $0x0,%eax
  100b2f:	e9 85 00 00 00       	jmp    100bb9 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b3b:	eb 5c                	jmp    100b99 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b3d:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b43:	89 d0                	mov    %edx,%eax
  100b45:	01 c0                	add    %eax,%eax
  100b47:	01 d0                	add    %edx,%eax
  100b49:	c1 e0 02             	shl    $0x2,%eax
  100b4c:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b51:	8b 00                	mov    (%eax),%eax
  100b53:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b57:	89 04 24             	mov    %eax,(%esp)
  100b5a:	e8 2b 25 00 00       	call   10308a <strcmp>
  100b5f:	85 c0                	test   %eax,%eax
  100b61:	75 32                	jne    100b95 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b66:	89 d0                	mov    %edx,%eax
  100b68:	01 c0                	add    %eax,%eax
  100b6a:	01 d0                	add    %edx,%eax
  100b6c:	c1 e0 02             	shl    $0x2,%eax
  100b6f:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b74:	8b 40 08             	mov    0x8(%eax),%eax
  100b77:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b7a:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100b7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  100b80:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b84:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100b87:	83 c2 04             	add    $0x4,%edx
  100b8a:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b8e:	89 0c 24             	mov    %ecx,(%esp)
  100b91:	ff d0                	call   *%eax
  100b93:	eb 24                	jmp    100bb9 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b95:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b9c:	83 f8 02             	cmp    $0x2,%eax
  100b9f:	76 9c                	jbe    100b3d <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100ba1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ba8:	c7 04 24 d7 36 10 00 	movl   $0x1036d7,(%esp)
  100baf:	e8 5e f7 ff ff       	call   100312 <cprintf>
    return 0;
  100bb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bb9:	c9                   	leave  
  100bba:	c3                   	ret    

00100bbb <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bbb:	55                   	push   %ebp
  100bbc:	89 e5                	mov    %esp,%ebp
  100bbe:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bc1:	c7 04 24 f0 36 10 00 	movl   $0x1036f0,(%esp)
  100bc8:	e8 45 f7 ff ff       	call   100312 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bcd:	c7 04 24 18 37 10 00 	movl   $0x103718,(%esp)
  100bd4:	e8 39 f7 ff ff       	call   100312 <cprintf>

    if (tf != NULL) {
  100bd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bdd:	74 0b                	je     100bea <kmonitor+0x2f>
        print_trapframe(tf);
  100bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  100be2:	89 04 24             	mov    %eax,(%esp)
  100be5:	e8 cd 0d 00 00       	call   1019b7 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bea:	c7 04 24 3d 37 10 00 	movl   $0x10373d,(%esp)
  100bf1:	e8 13 f6 ff ff       	call   100209 <readline>
  100bf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100bf9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100bfd:	74 18                	je     100c17 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100bff:	8b 45 08             	mov    0x8(%ebp),%eax
  100c02:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c09:	89 04 24             	mov    %eax,(%esp)
  100c0c:	e8 f8 fe ff ff       	call   100b09 <runcmd>
  100c11:	85 c0                	test   %eax,%eax
  100c13:	79 02                	jns    100c17 <kmonitor+0x5c>
                break;
  100c15:	eb 02                	jmp    100c19 <kmonitor+0x5e>
            }
        }
    }
  100c17:	eb d1                	jmp    100bea <kmonitor+0x2f>
}
  100c19:	c9                   	leave  
  100c1a:	c3                   	ret    

00100c1b <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c1b:	55                   	push   %ebp
  100c1c:	89 e5                	mov    %esp,%ebp
  100c1e:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c21:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c28:	eb 3f                	jmp    100c69 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c2d:	89 d0                	mov    %edx,%eax
  100c2f:	01 c0                	add    %eax,%eax
  100c31:	01 d0                	add    %edx,%eax
  100c33:	c1 e0 02             	shl    $0x2,%eax
  100c36:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c3b:	8b 48 04             	mov    0x4(%eax),%ecx
  100c3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c41:	89 d0                	mov    %edx,%eax
  100c43:	01 c0                	add    %eax,%eax
  100c45:	01 d0                	add    %edx,%eax
  100c47:	c1 e0 02             	shl    $0x2,%eax
  100c4a:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c4f:	8b 00                	mov    (%eax),%eax
  100c51:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c55:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c59:	c7 04 24 41 37 10 00 	movl   $0x103741,(%esp)
  100c60:	e8 ad f6 ff ff       	call   100312 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c65:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c6c:	83 f8 02             	cmp    $0x2,%eax
  100c6f:	76 b9                	jbe    100c2a <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c76:	c9                   	leave  
  100c77:	c3                   	ret    

00100c78 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c78:	55                   	push   %ebp
  100c79:	89 e5                	mov    %esp,%ebp
  100c7b:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c7e:	e8 c3 fb ff ff       	call   100846 <print_kerninfo>
    return 0;
  100c83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c88:	c9                   	leave  
  100c89:	c3                   	ret    

00100c8a <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c8a:	55                   	push   %ebp
  100c8b:	89 e5                	mov    %esp,%ebp
  100c8d:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c90:	e8 fb fc ff ff       	call   100990 <print_stackframe>
    return 0;
  100c95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c9a:	c9                   	leave  
  100c9b:	c3                   	ret    

00100c9c <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100c9c:	55                   	push   %ebp
  100c9d:	89 e5                	mov    %esp,%ebp
  100c9f:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100ca2:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100ca7:	85 c0                	test   %eax,%eax
  100ca9:	74 02                	je     100cad <__panic+0x11>
        goto panic_dead;
  100cab:	eb 48                	jmp    100cf5 <__panic+0x59>
    }
    is_panic = 1;
  100cad:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100cb4:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cb7:	8d 45 14             	lea    0x14(%ebp),%eax
  100cba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cc0:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  100cc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ccb:	c7 04 24 4a 37 10 00 	movl   $0x10374a,(%esp)
  100cd2:	e8 3b f6 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cda:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cde:	8b 45 10             	mov    0x10(%ebp),%eax
  100ce1:	89 04 24             	mov    %eax,(%esp)
  100ce4:	e8 f6 f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100ce9:	c7 04 24 66 37 10 00 	movl   $0x103766,(%esp)
  100cf0:	e8 1d f6 ff ff       	call   100312 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100cf5:	e8 22 09 00 00       	call   10161c <intr_disable>
    while (1) {
        kmonitor(NULL);
  100cfa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d01:	e8 b5 fe ff ff       	call   100bbb <kmonitor>
    }
  100d06:	eb f2                	jmp    100cfa <__panic+0x5e>

00100d08 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d08:	55                   	push   %ebp
  100d09:	89 e5                	mov    %esp,%ebp
  100d0b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d0e:	8d 45 14             	lea    0x14(%ebp),%eax
  100d11:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d17:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  100d1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d22:	c7 04 24 68 37 10 00 	movl   $0x103768,(%esp)
  100d29:	e8 e4 f5 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d31:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d35:	8b 45 10             	mov    0x10(%ebp),%eax
  100d38:	89 04 24             	mov    %eax,(%esp)
  100d3b:	e8 9f f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100d40:	c7 04 24 66 37 10 00 	movl   $0x103766,(%esp)
  100d47:	e8 c6 f5 ff ff       	call   100312 <cprintf>
    va_end(ap);
}
  100d4c:	c9                   	leave  
  100d4d:	c3                   	ret    

00100d4e <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d4e:	55                   	push   %ebp
  100d4f:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d51:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100d56:	5d                   	pop    %ebp
  100d57:	c3                   	ret    

00100d58 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d58:	55                   	push   %ebp
  100d59:	89 e5                	mov    %esp,%ebp
  100d5b:	83 ec 28             	sub    $0x28,%esp
  100d5e:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d64:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d68:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d6c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d70:	ee                   	out    %al,(%dx)
  100d71:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d77:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d7b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d7f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d83:	ee                   	out    %al,(%dx)
  100d84:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100d8a:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100d8e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d92:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d96:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d97:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100d9e:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100da1:	c7 04 24 86 37 10 00 	movl   $0x103786,(%esp)
  100da8:	e8 65 f5 ff ff       	call   100312 <cprintf>
    pic_enable(IRQ_TIMER);
  100dad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100db4:	e8 c1 08 00 00       	call   10167a <pic_enable>
}
  100db9:	c9                   	leave  
  100dba:	c3                   	ret    

00100dbb <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dbb:	55                   	push   %ebp
  100dbc:	89 e5                	mov    %esp,%ebp
  100dbe:	83 ec 10             	sub    $0x10,%esp
  100dc1:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dc7:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100dcb:	89 c2                	mov    %eax,%edx
  100dcd:	ec                   	in     (%dx),%al
  100dce:	88 45 fd             	mov    %al,-0x3(%ebp)
  100dd1:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dd7:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100ddb:	89 c2                	mov    %eax,%edx
  100ddd:	ec                   	in     (%dx),%al
  100dde:	88 45 f9             	mov    %al,-0x7(%ebp)
  100de1:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100de7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100deb:	89 c2                	mov    %eax,%edx
  100ded:	ec                   	in     (%dx),%al
  100dee:	88 45 f5             	mov    %al,-0xb(%ebp)
  100df1:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100df7:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100dfb:	89 c2                	mov    %eax,%edx
  100dfd:	ec                   	in     (%dx),%al
  100dfe:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e01:	c9                   	leave  
  100e02:	c3                   	ret    

00100e03 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e03:	55                   	push   %ebp
  100e04:	89 e5                	mov    %esp,%ebp
  100e06:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  100e09:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e13:	0f b7 00             	movzwl (%eax),%eax
  100e16:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e1d:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e25:	0f b7 00             	movzwl (%eax),%eax
  100e28:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e2c:	74 12                	je     100e40 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;
  100e2e:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e35:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e3c:	b4 03 
  100e3e:	eb 13                	jmp    100e53 <cga_init+0x50>
    } else {
        *cp = was;
  100e40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e43:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e47:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e4a:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e51:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e53:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e5a:	0f b7 c0             	movzwl %ax,%eax
  100e5d:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e61:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e65:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e69:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e6d:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100e6e:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e75:	83 c0 01             	add    $0x1,%eax
  100e78:	0f b7 c0             	movzwl %ax,%eax
  100e7b:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e7f:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e83:	89 c2                	mov    %eax,%edx
  100e85:	ec                   	in     (%dx),%al
  100e86:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e89:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e8d:	0f b6 c0             	movzbl %al,%eax
  100e90:	c1 e0 08             	shl    $0x8,%eax
  100e93:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e96:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e9d:	0f b7 c0             	movzwl %ax,%eax
  100ea0:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100ea4:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ea8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100eac:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100eb0:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100eb1:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100eb8:	83 c0 01             	add    $0x1,%eax
  100ebb:	0f b7 c0             	movzwl %ax,%eax
  100ebe:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ec2:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100ec6:	89 c2                	mov    %eax,%edx
  100ec8:	ec                   	in     (%dx),%al
  100ec9:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100ecc:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ed0:	0f b6 c0             	movzbl %al,%eax
  100ed3:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100ed6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ed9:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;
  100ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ee1:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ee7:	c9                   	leave  
  100ee8:	c3                   	ret    

00100ee9 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ee9:	55                   	push   %ebp
  100eea:	89 e5                	mov    %esp,%ebp
  100eec:	83 ec 48             	sub    $0x48,%esp
  100eef:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100ef5:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ef9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100efd:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f01:	ee                   	out    %al,(%dx)
  100f02:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f08:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f0c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f10:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f14:	ee                   	out    %al,(%dx)
  100f15:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f1b:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f1f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f23:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f27:	ee                   	out    %al,(%dx)
  100f28:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f2e:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f32:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f36:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f3a:	ee                   	out    %al,(%dx)
  100f3b:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f41:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f45:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f49:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f4d:	ee                   	out    %al,(%dx)
  100f4e:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f54:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f58:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f5c:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f60:	ee                   	out    %al,(%dx)
  100f61:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f67:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f6b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f6f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f73:	ee                   	out    %al,(%dx)
  100f74:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f7a:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f7e:	89 c2                	mov    %eax,%edx
  100f80:	ec                   	in     (%dx),%al
  100f81:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f84:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f88:	3c ff                	cmp    $0xff,%al
  100f8a:	0f 95 c0             	setne  %al
  100f8d:	0f b6 c0             	movzbl %al,%eax
  100f90:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f95:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f9b:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100f9f:	89 c2                	mov    %eax,%edx
  100fa1:	ec                   	in     (%dx),%al
  100fa2:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100fa5:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100fab:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100faf:	89 c2                	mov    %eax,%edx
  100fb1:	ec                   	in     (%dx),%al
  100fb2:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fb5:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fba:	85 c0                	test   %eax,%eax
  100fbc:	74 0c                	je     100fca <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fbe:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fc5:	e8 b0 06 00 00       	call   10167a <pic_enable>
    }
}
  100fca:	c9                   	leave  
  100fcb:	c3                   	ret    

00100fcc <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fcc:	55                   	push   %ebp
  100fcd:	89 e5                	mov    %esp,%ebp
  100fcf:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fd2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fd9:	eb 09                	jmp    100fe4 <lpt_putc_sub+0x18>
        delay();
  100fdb:	e8 db fd ff ff       	call   100dbb <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fe0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fe4:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100fea:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100fee:	89 c2                	mov    %eax,%edx
  100ff0:	ec                   	in     (%dx),%al
  100ff1:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100ff4:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100ff8:	84 c0                	test   %al,%al
  100ffa:	78 09                	js     101005 <lpt_putc_sub+0x39>
  100ffc:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101003:	7e d6                	jle    100fdb <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101005:	8b 45 08             	mov    0x8(%ebp),%eax
  101008:	0f b6 c0             	movzbl %al,%eax
  10100b:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101011:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101014:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101018:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10101c:	ee                   	out    %al,(%dx)
  10101d:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101023:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101027:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10102b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10102f:	ee                   	out    %al,(%dx)
  101030:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  101036:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  10103a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10103e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101042:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101043:	c9                   	leave  
  101044:	c3                   	ret    

00101045 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101045:	55                   	push   %ebp
  101046:	89 e5                	mov    %esp,%ebp
  101048:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10104b:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10104f:	74 0d                	je     10105e <lpt_putc+0x19>
        lpt_putc_sub(c);
  101051:	8b 45 08             	mov    0x8(%ebp),%eax
  101054:	89 04 24             	mov    %eax,(%esp)
  101057:	e8 70 ff ff ff       	call   100fcc <lpt_putc_sub>
  10105c:	eb 24                	jmp    101082 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  10105e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101065:	e8 62 ff ff ff       	call   100fcc <lpt_putc_sub>
        lpt_putc_sub(' ');
  10106a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101071:	e8 56 ff ff ff       	call   100fcc <lpt_putc_sub>
        lpt_putc_sub('\b');
  101076:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10107d:	e8 4a ff ff ff       	call   100fcc <lpt_putc_sub>
    }
}
  101082:	c9                   	leave  
  101083:	c3                   	ret    

00101084 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101084:	55                   	push   %ebp
  101085:	89 e5                	mov    %esp,%ebp
  101087:	53                   	push   %ebx
  101088:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10108b:	8b 45 08             	mov    0x8(%ebp),%eax
  10108e:	b0 00                	mov    $0x0,%al
  101090:	85 c0                	test   %eax,%eax
  101092:	75 07                	jne    10109b <cga_putc+0x17>
        c |= 0x0700;
  101094:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10109b:	8b 45 08             	mov    0x8(%ebp),%eax
  10109e:	0f b6 c0             	movzbl %al,%eax
  1010a1:	83 f8 0a             	cmp    $0xa,%eax
  1010a4:	74 4c                	je     1010f2 <cga_putc+0x6e>
  1010a6:	83 f8 0d             	cmp    $0xd,%eax
  1010a9:	74 57                	je     101102 <cga_putc+0x7e>
  1010ab:	83 f8 08             	cmp    $0x8,%eax
  1010ae:	0f 85 88 00 00 00    	jne    10113c <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1010b4:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010bb:	66 85 c0             	test   %ax,%ax
  1010be:	74 30                	je     1010f0 <cga_putc+0x6c>
            crt_pos --;
  1010c0:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010c7:	83 e8 01             	sub    $0x1,%eax
  1010ca:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010d0:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010d5:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010dc:	0f b7 d2             	movzwl %dx,%edx
  1010df:	01 d2                	add    %edx,%edx
  1010e1:	01 c2                	add    %eax,%edx
  1010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1010e6:	b0 00                	mov    $0x0,%al
  1010e8:	83 c8 20             	or     $0x20,%eax
  1010eb:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1010ee:	eb 72                	jmp    101162 <cga_putc+0xde>
  1010f0:	eb 70                	jmp    101162 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  1010f2:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010f9:	83 c0 50             	add    $0x50,%eax
  1010fc:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101102:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  101109:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  101110:	0f b7 c1             	movzwl %cx,%eax
  101113:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101119:	c1 e8 10             	shr    $0x10,%eax
  10111c:	89 c2                	mov    %eax,%edx
  10111e:	66 c1 ea 06          	shr    $0x6,%dx
  101122:	89 d0                	mov    %edx,%eax
  101124:	c1 e0 02             	shl    $0x2,%eax
  101127:	01 d0                	add    %edx,%eax
  101129:	c1 e0 04             	shl    $0x4,%eax
  10112c:	29 c1                	sub    %eax,%ecx
  10112e:	89 ca                	mov    %ecx,%edx
  101130:	89 d8                	mov    %ebx,%eax
  101132:	29 d0                	sub    %edx,%eax
  101134:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  10113a:	eb 26                	jmp    101162 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10113c:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101142:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101149:	8d 50 01             	lea    0x1(%eax),%edx
  10114c:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101153:	0f b7 c0             	movzwl %ax,%eax
  101156:	01 c0                	add    %eax,%eax
  101158:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  10115b:	8b 45 08             	mov    0x8(%ebp),%eax
  10115e:	66 89 02             	mov    %ax,(%edx)
        break;
  101161:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101162:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101169:	66 3d cf 07          	cmp    $0x7cf,%ax
  10116d:	76 5b                	jbe    1011ca <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10116f:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101174:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10117a:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10117f:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101186:	00 
  101187:	89 54 24 04          	mov    %edx,0x4(%esp)
  10118b:	89 04 24             	mov    %eax,(%esp)
  10118e:	e8 94 21 00 00       	call   103327 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101193:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10119a:	eb 15                	jmp    1011b1 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  10119c:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011a4:	01 d2                	add    %edx,%edx
  1011a6:	01 d0                	add    %edx,%eax
  1011a8:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011ad:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011b1:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011b8:	7e e2                	jle    10119c <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011ba:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011c1:	83 e8 50             	sub    $0x50,%eax
  1011c4:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011ca:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011d1:	0f b7 c0             	movzwl %ax,%eax
  1011d4:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011d8:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1011dc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1011e0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011e4:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011e5:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011ec:	66 c1 e8 08          	shr    $0x8,%ax
  1011f0:	0f b6 c0             	movzbl %al,%eax
  1011f3:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1011fa:	83 c2 01             	add    $0x1,%edx
  1011fd:	0f b7 d2             	movzwl %dx,%edx
  101200:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101204:	88 45 ed             	mov    %al,-0x13(%ebp)
  101207:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10120b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10120f:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101210:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101217:	0f b7 c0             	movzwl %ax,%eax
  10121a:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  10121e:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101222:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101226:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10122a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10122b:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101232:	0f b6 c0             	movzbl %al,%eax
  101235:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10123c:	83 c2 01             	add    $0x1,%edx
  10123f:	0f b7 d2             	movzwl %dx,%edx
  101242:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  101246:	88 45 e5             	mov    %al,-0x1b(%ebp)
  101249:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10124d:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101251:	ee                   	out    %al,(%dx)
}
  101252:	83 c4 34             	add    $0x34,%esp
  101255:	5b                   	pop    %ebx
  101256:	5d                   	pop    %ebp
  101257:	c3                   	ret    

00101258 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101258:	55                   	push   %ebp
  101259:	89 e5                	mov    %esp,%ebp
  10125b:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10125e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101265:	eb 09                	jmp    101270 <serial_putc_sub+0x18>
        delay();
  101267:	e8 4f fb ff ff       	call   100dbb <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10126c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101270:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101276:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10127a:	89 c2                	mov    %eax,%edx
  10127c:	ec                   	in     (%dx),%al
  10127d:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101280:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101284:	0f b6 c0             	movzbl %al,%eax
  101287:	83 e0 20             	and    $0x20,%eax
  10128a:	85 c0                	test   %eax,%eax
  10128c:	75 09                	jne    101297 <serial_putc_sub+0x3f>
  10128e:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101295:	7e d0                	jle    101267 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101297:	8b 45 08             	mov    0x8(%ebp),%eax
  10129a:	0f b6 c0             	movzbl %al,%eax
  10129d:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012a3:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012a6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012aa:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012ae:	ee                   	out    %al,(%dx)
}
  1012af:	c9                   	leave  
  1012b0:	c3                   	ret    

001012b1 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012b1:	55                   	push   %ebp
  1012b2:	89 e5                	mov    %esp,%ebp
  1012b4:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012b7:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012bb:	74 0d                	je     1012ca <serial_putc+0x19>
        serial_putc_sub(c);
  1012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1012c0:	89 04 24             	mov    %eax,(%esp)
  1012c3:	e8 90 ff ff ff       	call   101258 <serial_putc_sub>
  1012c8:	eb 24                	jmp    1012ee <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012d1:	e8 82 ff ff ff       	call   101258 <serial_putc_sub>
        serial_putc_sub(' ');
  1012d6:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012dd:	e8 76 ff ff ff       	call   101258 <serial_putc_sub>
        serial_putc_sub('\b');
  1012e2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012e9:	e8 6a ff ff ff       	call   101258 <serial_putc_sub>
    }
}
  1012ee:	c9                   	leave  
  1012ef:	c3                   	ret    

001012f0 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012f0:	55                   	push   %ebp
  1012f1:	89 e5                	mov    %esp,%ebp
  1012f3:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012f6:	eb 33                	jmp    10132b <cons_intr+0x3b>
        if (c != 0) {
  1012f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012fc:	74 2d                	je     10132b <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012fe:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101303:	8d 50 01             	lea    0x1(%eax),%edx
  101306:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  10130c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10130f:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101315:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10131a:	3d 00 02 00 00       	cmp    $0x200,%eax
  10131f:	75 0a                	jne    10132b <cons_intr+0x3b>
                cons.wpos = 0;
  101321:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101328:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  10132b:	8b 45 08             	mov    0x8(%ebp),%eax
  10132e:	ff d0                	call   *%eax
  101330:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101333:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101337:	75 bf                	jne    1012f8 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  101339:	c9                   	leave  
  10133a:	c3                   	ret    

0010133b <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10133b:	55                   	push   %ebp
  10133c:	89 e5                	mov    %esp,%ebp
  10133e:	83 ec 10             	sub    $0x10,%esp
  101341:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101347:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10134b:	89 c2                	mov    %eax,%edx
  10134d:	ec                   	in     (%dx),%al
  10134e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101351:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101355:	0f b6 c0             	movzbl %al,%eax
  101358:	83 e0 01             	and    $0x1,%eax
  10135b:	85 c0                	test   %eax,%eax
  10135d:	75 07                	jne    101366 <serial_proc_data+0x2b>
        return -1;
  10135f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101364:	eb 2a                	jmp    101390 <serial_proc_data+0x55>
  101366:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10136c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101370:	89 c2                	mov    %eax,%edx
  101372:	ec                   	in     (%dx),%al
  101373:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101376:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10137a:	0f b6 c0             	movzbl %al,%eax
  10137d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101380:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101384:	75 07                	jne    10138d <serial_proc_data+0x52>
        c = '\b';
  101386:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10138d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101390:	c9                   	leave  
  101391:	c3                   	ret    

00101392 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101392:	55                   	push   %ebp
  101393:	89 e5                	mov    %esp,%ebp
  101395:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101398:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  10139d:	85 c0                	test   %eax,%eax
  10139f:	74 0c                	je     1013ad <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013a1:	c7 04 24 3b 13 10 00 	movl   $0x10133b,(%esp)
  1013a8:	e8 43 ff ff ff       	call   1012f0 <cons_intr>
    }
}
  1013ad:	c9                   	leave  
  1013ae:	c3                   	ret    

001013af <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013af:	55                   	push   %ebp
  1013b0:	89 e5                	mov    %esp,%ebp
  1013b2:	83 ec 38             	sub    $0x38,%esp
  1013b5:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013bb:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013bf:	89 c2                	mov    %eax,%edx
  1013c1:	ec                   	in     (%dx),%al
  1013c2:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013c5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013c9:	0f b6 c0             	movzbl %al,%eax
  1013cc:	83 e0 01             	and    $0x1,%eax
  1013cf:	85 c0                	test   %eax,%eax
  1013d1:	75 0a                	jne    1013dd <kbd_proc_data+0x2e>
        return -1;
  1013d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013d8:	e9 59 01 00 00       	jmp    101536 <kbd_proc_data+0x187>
  1013dd:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013e3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013e7:	89 c2                	mov    %eax,%edx
  1013e9:	ec                   	in     (%dx),%al
  1013ea:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013ed:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013f1:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013f4:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013f8:	75 17                	jne    101411 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013fa:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013ff:	83 c8 40             	or     $0x40,%eax
  101402:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101407:	b8 00 00 00 00       	mov    $0x0,%eax
  10140c:	e9 25 01 00 00       	jmp    101536 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101411:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101415:	84 c0                	test   %al,%al
  101417:	79 47                	jns    101460 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101419:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10141e:	83 e0 40             	and    $0x40,%eax
  101421:	85 c0                	test   %eax,%eax
  101423:	75 09                	jne    10142e <kbd_proc_data+0x7f>
  101425:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101429:	83 e0 7f             	and    $0x7f,%eax
  10142c:	eb 04                	jmp    101432 <kbd_proc_data+0x83>
  10142e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101432:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101435:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101439:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101440:	83 c8 40             	or     $0x40,%eax
  101443:	0f b6 c0             	movzbl %al,%eax
  101446:	f7 d0                	not    %eax
  101448:	89 c2                	mov    %eax,%edx
  10144a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10144f:	21 d0                	and    %edx,%eax
  101451:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101456:	b8 00 00 00 00       	mov    $0x0,%eax
  10145b:	e9 d6 00 00 00       	jmp    101536 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101460:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101465:	83 e0 40             	and    $0x40,%eax
  101468:	85 c0                	test   %eax,%eax
  10146a:	74 11                	je     10147d <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10146c:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101470:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101475:	83 e0 bf             	and    $0xffffffbf,%eax
  101478:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  10147d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101481:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101488:	0f b6 d0             	movzbl %al,%edx
  10148b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101490:	09 d0                	or     %edx,%eax
  101492:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  101497:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10149b:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014a2:	0f b6 d0             	movzbl %al,%edx
  1014a5:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014aa:	31 d0                	xor    %edx,%eax
  1014ac:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014b1:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014b6:	83 e0 03             	and    $0x3,%eax
  1014b9:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014c0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014c4:	01 d0                	add    %edx,%eax
  1014c6:	0f b6 00             	movzbl (%eax),%eax
  1014c9:	0f b6 c0             	movzbl %al,%eax
  1014cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014cf:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014d4:	83 e0 08             	and    $0x8,%eax
  1014d7:	85 c0                	test   %eax,%eax
  1014d9:	74 22                	je     1014fd <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014db:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014df:	7e 0c                	jle    1014ed <kbd_proc_data+0x13e>
  1014e1:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014e5:	7f 06                	jg     1014ed <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014e7:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014eb:	eb 10                	jmp    1014fd <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014ed:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014f1:	7e 0a                	jle    1014fd <kbd_proc_data+0x14e>
  1014f3:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014f7:	7f 04                	jg     1014fd <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014f9:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014fd:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101502:	f7 d0                	not    %eax
  101504:	83 e0 06             	and    $0x6,%eax
  101507:	85 c0                	test   %eax,%eax
  101509:	75 28                	jne    101533 <kbd_proc_data+0x184>
  10150b:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101512:	75 1f                	jne    101533 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101514:	c7 04 24 a1 37 10 00 	movl   $0x1037a1,(%esp)
  10151b:	e8 f2 ed ff ff       	call   100312 <cprintf>
  101520:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101526:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10152a:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10152e:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101532:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101533:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101536:	c9                   	leave  
  101537:	c3                   	ret    

00101538 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101538:	55                   	push   %ebp
  101539:	89 e5                	mov    %esp,%ebp
  10153b:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10153e:	c7 04 24 af 13 10 00 	movl   $0x1013af,(%esp)
  101545:	e8 a6 fd ff ff       	call   1012f0 <cons_intr>
}
  10154a:	c9                   	leave  
  10154b:	c3                   	ret    

0010154c <kbd_init>:

static void
kbd_init(void) {
  10154c:	55                   	push   %ebp
  10154d:	89 e5                	mov    %esp,%ebp
  10154f:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101552:	e8 e1 ff ff ff       	call   101538 <kbd_intr>
    pic_enable(IRQ_KBD);
  101557:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10155e:	e8 17 01 00 00       	call   10167a <pic_enable>
}
  101563:	c9                   	leave  
  101564:	c3                   	ret    

00101565 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101565:	55                   	push   %ebp
  101566:	89 e5                	mov    %esp,%ebp
  101568:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  10156b:	e8 93 f8 ff ff       	call   100e03 <cga_init>
    serial_init();
  101570:	e8 74 f9 ff ff       	call   100ee9 <serial_init>
    kbd_init();
  101575:	e8 d2 ff ff ff       	call   10154c <kbd_init>
    if (!serial_exists) {
  10157a:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  10157f:	85 c0                	test   %eax,%eax
  101581:	75 0c                	jne    10158f <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101583:	c7 04 24 ad 37 10 00 	movl   $0x1037ad,(%esp)
  10158a:	e8 83 ed ff ff       	call   100312 <cprintf>
    }
}
  10158f:	c9                   	leave  
  101590:	c3                   	ret    

00101591 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101591:	55                   	push   %ebp
  101592:	89 e5                	mov    %esp,%ebp
  101594:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  101597:	8b 45 08             	mov    0x8(%ebp),%eax
  10159a:	89 04 24             	mov    %eax,(%esp)
  10159d:	e8 a3 fa ff ff       	call   101045 <lpt_putc>
    cga_putc(c);
  1015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1015a5:	89 04 24             	mov    %eax,(%esp)
  1015a8:	e8 d7 fa ff ff       	call   101084 <cga_putc>
    serial_putc(c);
  1015ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1015b0:	89 04 24             	mov    %eax,(%esp)
  1015b3:	e8 f9 fc ff ff       	call   1012b1 <serial_putc>
}
  1015b8:	c9                   	leave  
  1015b9:	c3                   	ret    

001015ba <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015ba:	55                   	push   %ebp
  1015bb:	89 e5                	mov    %esp,%ebp
  1015bd:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015c0:	e8 cd fd ff ff       	call   101392 <serial_intr>
    kbd_intr();
  1015c5:	e8 6e ff ff ff       	call   101538 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015ca:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015d0:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015d5:	39 c2                	cmp    %eax,%edx
  1015d7:	74 36                	je     10160f <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015d9:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015de:	8d 50 01             	lea    0x1(%eax),%edx
  1015e1:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015e7:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015ee:	0f b6 c0             	movzbl %al,%eax
  1015f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015f4:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015f9:	3d 00 02 00 00       	cmp    $0x200,%eax
  1015fe:	75 0a                	jne    10160a <cons_getc+0x50>
            cons.rpos = 0;
  101600:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101607:	00 00 00 
        }
        return c;
  10160a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10160d:	eb 05                	jmp    101614 <cons_getc+0x5a>
    }
    return 0;
  10160f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101614:	c9                   	leave  
  101615:	c3                   	ret    

00101616 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101616:	55                   	push   %ebp
  101617:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  101619:	fb                   	sti    
    sti();
}
  10161a:	5d                   	pop    %ebp
  10161b:	c3                   	ret    

0010161c <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10161c:	55                   	push   %ebp
  10161d:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  10161f:	fa                   	cli    
    cli();
}
  101620:	5d                   	pop    %ebp
  101621:	c3                   	ret    

00101622 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101622:	55                   	push   %ebp
  101623:	89 e5                	mov    %esp,%ebp
  101625:	83 ec 14             	sub    $0x14,%esp
  101628:	8b 45 08             	mov    0x8(%ebp),%eax
  10162b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  10162f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101633:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101639:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  10163e:	85 c0                	test   %eax,%eax
  101640:	74 36                	je     101678 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101642:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101646:	0f b6 c0             	movzbl %al,%eax
  101649:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10164f:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101652:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101656:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10165a:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10165b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10165f:	66 c1 e8 08          	shr    $0x8,%ax
  101663:	0f b6 c0             	movzbl %al,%eax
  101666:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10166c:	88 45 f9             	mov    %al,-0x7(%ebp)
  10166f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101673:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101677:	ee                   	out    %al,(%dx)
    }
}
  101678:	c9                   	leave  
  101679:	c3                   	ret    

0010167a <pic_enable>:

void
pic_enable(unsigned int irq) {
  10167a:	55                   	push   %ebp
  10167b:	89 e5                	mov    %esp,%ebp
  10167d:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101680:	8b 45 08             	mov    0x8(%ebp),%eax
  101683:	ba 01 00 00 00       	mov    $0x1,%edx
  101688:	89 c1                	mov    %eax,%ecx
  10168a:	d3 e2                	shl    %cl,%edx
  10168c:	89 d0                	mov    %edx,%eax
  10168e:	f7 d0                	not    %eax
  101690:	89 c2                	mov    %eax,%edx
  101692:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  101699:	21 d0                	and    %edx,%eax
  10169b:	0f b7 c0             	movzwl %ax,%eax
  10169e:	89 04 24             	mov    %eax,(%esp)
  1016a1:	e8 7c ff ff ff       	call   101622 <pic_setmask>
}
  1016a6:	c9                   	leave  
  1016a7:	c3                   	ret    

001016a8 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016a8:	55                   	push   %ebp
  1016a9:	89 e5                	mov    %esp,%ebp
  1016ab:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016ae:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016b5:	00 00 00 
  1016b8:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016be:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016c2:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016c6:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016ca:	ee                   	out    %al,(%dx)
  1016cb:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016d1:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016d5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016d9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016dd:	ee                   	out    %al,(%dx)
  1016de:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016e4:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1016e8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1016ec:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1016f0:	ee                   	out    %al,(%dx)
  1016f1:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  1016f7:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  1016fb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1016ff:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101703:	ee                   	out    %al,(%dx)
  101704:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  10170a:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  10170e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101712:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101716:	ee                   	out    %al,(%dx)
  101717:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  10171d:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  101721:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101725:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101729:	ee                   	out    %al,(%dx)
  10172a:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101730:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101734:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101738:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10173c:	ee                   	out    %al,(%dx)
  10173d:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  101743:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  101747:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10174b:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10174f:	ee                   	out    %al,(%dx)
  101750:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101756:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  10175a:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10175e:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101762:	ee                   	out    %al,(%dx)
  101763:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101769:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  10176d:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101771:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101775:	ee                   	out    %al,(%dx)
  101776:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  10177c:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101780:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101784:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101788:	ee                   	out    %al,(%dx)
  101789:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10178f:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101793:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101797:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10179b:	ee                   	out    %al,(%dx)
  10179c:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  1017a2:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1017a6:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017aa:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017ae:	ee                   	out    %al,(%dx)
  1017af:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1017b5:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1017b9:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017bd:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017c1:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017c2:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017c9:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017cd:	74 12                	je     1017e1 <pic_init+0x139>
        pic_setmask(irq_mask);
  1017cf:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017d6:	0f b7 c0             	movzwl %ax,%eax
  1017d9:	89 04 24             	mov    %eax,(%esp)
  1017dc:	e8 41 fe ff ff       	call   101622 <pic_setmask>
    }
}
  1017e1:	c9                   	leave  
  1017e2:	c3                   	ret    

001017e3 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017e3:	55                   	push   %ebp
  1017e4:	89 e5                	mov    %esp,%ebp
  1017e6:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017e9:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1017f0:	00 
  1017f1:	c7 04 24 e0 37 10 00 	movl   $0x1037e0,(%esp)
  1017f8:	e8 15 eb ff ff       	call   100312 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1017fd:	c9                   	leave  
  1017fe:	c3                   	ret    

001017ff <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1017ff:	55                   	push   %ebp
  101800:	89 e5                	mov    %esp,%ebp
  101802:	83 ec 10             	sub    $0x10,%esp
      */
	extern uintptr_t __vectors[];

	// 计算出有多少个IDT，依次遍历他们
	int i;
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i++) {
  101805:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10180c:	e9 c3 00 00 00       	jmp    1018d4 <idt_init+0xd5>

		// 初始化若干IDT
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101811:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101814:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  10181b:	89 c2                	mov    %eax,%edx
  10181d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101820:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101827:	00 
  101828:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10182b:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101832:	00 08 00 
  101835:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101838:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10183f:	00 
  101840:	83 e2 e0             	and    $0xffffffe0,%edx
  101843:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10184a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10184d:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101854:	00 
  101855:	83 e2 1f             	and    $0x1f,%edx
  101858:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10185f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101862:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101869:	00 
  10186a:	83 e2 f0             	and    $0xfffffff0,%edx
  10186d:	83 ca 0e             	or     $0xe,%edx
  101870:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101877:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10187a:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101881:	00 
  101882:	83 e2 ef             	and    $0xffffffef,%edx
  101885:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10188c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10188f:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101896:	00 
  101897:	83 e2 9f             	and    $0xffffff9f,%edx
  10189a:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a4:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018ab:	00 
  1018ac:	83 ca 80             	or     $0xffffff80,%edx
  1018af:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b9:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018c0:	c1 e8 10             	shr    $0x10,%eax
  1018c3:	89 c2                	mov    %eax,%edx
  1018c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c8:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018cf:	00 
      */
	extern uintptr_t __vectors[];

	// 计算出有多少个IDT，依次遍历他们
	int i;
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i++) {
  1018d0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1018d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d7:	3d ff 00 00 00       	cmp    $0xff,%eax
  1018dc:	0f 86 2f ff ff ff    	jbe    101811 <idt_init+0x12>
		// 初始化若干IDT
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
	}

	// T_SWITCH_TOK 的发生时机是在用户空间的，所以对应的dpl需要修改为DPL_USER。
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  1018e2:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  1018e7:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  1018ed:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  1018f4:	08 00 
  1018f6:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  1018fd:	83 e0 e0             	and    $0xffffffe0,%eax
  101900:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101905:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  10190c:	83 e0 1f             	and    $0x1f,%eax
  10190f:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101914:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10191b:	83 e0 f0             	and    $0xfffffff0,%eax
  10191e:	83 c8 0e             	or     $0xe,%eax
  101921:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101926:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10192d:	83 e0 ef             	and    $0xffffffef,%eax
  101930:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101935:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10193c:	83 c8 60             	or     $0x60,%eax
  10193f:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101944:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10194b:	83 c8 80             	or     $0xffffff80,%eax
  10194e:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101953:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101958:	c1 e8 10             	shr    $0x10,%eax
  10195b:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  101961:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  101968:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10196b:	0f 01 18             	lidtl  (%eax)

	// 加载IDT，只有特权级为0才允许执行
	lidt(&idt_pd);
}
  10196e:	c9                   	leave  
  10196f:	c3                   	ret    

00101970 <trapname>:

static const char *
trapname(int trapno) {
  101970:	55                   	push   %ebp
  101971:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101973:	8b 45 08             	mov    0x8(%ebp),%eax
  101976:	83 f8 13             	cmp    $0x13,%eax
  101979:	77 0c                	ja     101987 <trapname+0x17>
        return excnames[trapno];
  10197b:	8b 45 08             	mov    0x8(%ebp),%eax
  10197e:	8b 04 85 40 3b 10 00 	mov    0x103b40(,%eax,4),%eax
  101985:	eb 18                	jmp    10199f <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101987:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  10198b:	7e 0d                	jle    10199a <trapname+0x2a>
  10198d:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101991:	7f 07                	jg     10199a <trapname+0x2a>
        return "Hardware Interrupt";
  101993:	b8 ea 37 10 00       	mov    $0x1037ea,%eax
  101998:	eb 05                	jmp    10199f <trapname+0x2f>
    }
    return "(unknown trap)";
  10199a:	b8 fd 37 10 00       	mov    $0x1037fd,%eax
}
  10199f:	5d                   	pop    %ebp
  1019a0:	c3                   	ret    

001019a1 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019a1:	55                   	push   %ebp
  1019a2:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1019a7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019ab:	66 83 f8 08          	cmp    $0x8,%ax
  1019af:	0f 94 c0             	sete   %al
  1019b2:	0f b6 c0             	movzbl %al,%eax
}
  1019b5:	5d                   	pop    %ebp
  1019b6:	c3                   	ret    

001019b7 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019b7:	55                   	push   %ebp
  1019b8:	89 e5                	mov    %esp,%ebp
  1019ba:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019c4:	c7 04 24 3e 38 10 00 	movl   $0x10383e,(%esp)
  1019cb:	e8 42 e9 ff ff       	call   100312 <cprintf>
    print_regs(&tf->tf_regs);
  1019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1019d3:	89 04 24             	mov    %eax,(%esp)
  1019d6:	e8 a1 01 00 00       	call   101b7c <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  1019db:	8b 45 08             	mov    0x8(%ebp),%eax
  1019de:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  1019e2:	0f b7 c0             	movzwl %ax,%eax
  1019e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019e9:	c7 04 24 4f 38 10 00 	movl   $0x10384f,(%esp)
  1019f0:	e8 1d e9 ff ff       	call   100312 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  1019f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f8:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  1019fc:	0f b7 c0             	movzwl %ax,%eax
  1019ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a03:	c7 04 24 62 38 10 00 	movl   $0x103862,(%esp)
  101a0a:	e8 03 e9 ff ff       	call   100312 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a12:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a16:	0f b7 c0             	movzwl %ax,%eax
  101a19:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a1d:	c7 04 24 75 38 10 00 	movl   $0x103875,(%esp)
  101a24:	e8 e9 e8 ff ff       	call   100312 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a29:	8b 45 08             	mov    0x8(%ebp),%eax
  101a2c:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a30:	0f b7 c0             	movzwl %ax,%eax
  101a33:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a37:	c7 04 24 88 38 10 00 	movl   $0x103888,(%esp)
  101a3e:	e8 cf e8 ff ff       	call   100312 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a43:	8b 45 08             	mov    0x8(%ebp),%eax
  101a46:	8b 40 30             	mov    0x30(%eax),%eax
  101a49:	89 04 24             	mov    %eax,(%esp)
  101a4c:	e8 1f ff ff ff       	call   101970 <trapname>
  101a51:	8b 55 08             	mov    0x8(%ebp),%edx
  101a54:	8b 52 30             	mov    0x30(%edx),%edx
  101a57:	89 44 24 08          	mov    %eax,0x8(%esp)
  101a5b:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a5f:	c7 04 24 9b 38 10 00 	movl   $0x10389b,(%esp)
  101a66:	e8 a7 e8 ff ff       	call   100312 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6e:	8b 40 34             	mov    0x34(%eax),%eax
  101a71:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a75:	c7 04 24 ad 38 10 00 	movl   $0x1038ad,(%esp)
  101a7c:	e8 91 e8 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101a81:	8b 45 08             	mov    0x8(%ebp),%eax
  101a84:	8b 40 38             	mov    0x38(%eax),%eax
  101a87:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a8b:	c7 04 24 bc 38 10 00 	movl   $0x1038bc,(%esp)
  101a92:	e8 7b e8 ff ff       	call   100312 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101a97:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a9e:	0f b7 c0             	movzwl %ax,%eax
  101aa1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa5:	c7 04 24 cb 38 10 00 	movl   $0x1038cb,(%esp)
  101aac:	e8 61 e8 ff ff       	call   100312 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab4:	8b 40 40             	mov    0x40(%eax),%eax
  101ab7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101abb:	c7 04 24 de 38 10 00 	movl   $0x1038de,(%esp)
  101ac2:	e8 4b e8 ff ff       	call   100312 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ac7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101ace:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101ad5:	eb 3e                	jmp    101b15 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  101ada:	8b 50 40             	mov    0x40(%eax),%edx
  101add:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101ae0:	21 d0                	and    %edx,%eax
  101ae2:	85 c0                	test   %eax,%eax
  101ae4:	74 28                	je     101b0e <print_trapframe+0x157>
  101ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ae9:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101af0:	85 c0                	test   %eax,%eax
  101af2:	74 1a                	je     101b0e <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101af7:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101afe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b02:	c7 04 24 ed 38 10 00 	movl   $0x1038ed,(%esp)
  101b09:	e8 04 e8 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b0e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b12:	d1 65 f0             	shll   -0x10(%ebp)
  101b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b18:	83 f8 17             	cmp    $0x17,%eax
  101b1b:	76 ba                	jbe    101ad7 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b20:	8b 40 40             	mov    0x40(%eax),%eax
  101b23:	25 00 30 00 00       	and    $0x3000,%eax
  101b28:	c1 e8 0c             	shr    $0xc,%eax
  101b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b2f:	c7 04 24 f1 38 10 00 	movl   $0x1038f1,(%esp)
  101b36:	e8 d7 e7 ff ff       	call   100312 <cprintf>

    if (!trap_in_kernel(tf)) {
  101b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3e:	89 04 24             	mov    %eax,(%esp)
  101b41:	e8 5b fe ff ff       	call   1019a1 <trap_in_kernel>
  101b46:	85 c0                	test   %eax,%eax
  101b48:	75 30                	jne    101b7a <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4d:	8b 40 44             	mov    0x44(%eax),%eax
  101b50:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b54:	c7 04 24 fa 38 10 00 	movl   $0x1038fa,(%esp)
  101b5b:	e8 b2 e7 ff ff       	call   100312 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b60:	8b 45 08             	mov    0x8(%ebp),%eax
  101b63:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b67:	0f b7 c0             	movzwl %ax,%eax
  101b6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b6e:	c7 04 24 09 39 10 00 	movl   $0x103909,(%esp)
  101b75:	e8 98 e7 ff ff       	call   100312 <cprintf>
    }
}
  101b7a:	c9                   	leave  
  101b7b:	c3                   	ret    

00101b7c <print_regs>:

void
print_regs(struct pushregs *regs) {
  101b7c:	55                   	push   %ebp
  101b7d:	89 e5                	mov    %esp,%ebp
  101b7f:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101b82:	8b 45 08             	mov    0x8(%ebp),%eax
  101b85:	8b 00                	mov    (%eax),%eax
  101b87:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b8b:	c7 04 24 1c 39 10 00 	movl   $0x10391c,(%esp)
  101b92:	e8 7b e7 ff ff       	call   100312 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101b97:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9a:	8b 40 04             	mov    0x4(%eax),%eax
  101b9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba1:	c7 04 24 2b 39 10 00 	movl   $0x10392b,(%esp)
  101ba8:	e8 65 e7 ff ff       	call   100312 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101bad:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb0:	8b 40 08             	mov    0x8(%eax),%eax
  101bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb7:	c7 04 24 3a 39 10 00 	movl   $0x10393a,(%esp)
  101bbe:	e8 4f e7 ff ff       	call   100312 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc6:	8b 40 0c             	mov    0xc(%eax),%eax
  101bc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bcd:	c7 04 24 49 39 10 00 	movl   $0x103949,(%esp)
  101bd4:	e8 39 e7 ff ff       	call   100312 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bdc:	8b 40 10             	mov    0x10(%eax),%eax
  101bdf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be3:	c7 04 24 58 39 10 00 	movl   $0x103958,(%esp)
  101bea:	e8 23 e7 ff ff       	call   100312 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101bef:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf2:	8b 40 14             	mov    0x14(%eax),%eax
  101bf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf9:	c7 04 24 67 39 10 00 	movl   $0x103967,(%esp)
  101c00:	e8 0d e7 ff ff       	call   100312 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c05:	8b 45 08             	mov    0x8(%ebp),%eax
  101c08:	8b 40 18             	mov    0x18(%eax),%eax
  101c0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0f:	c7 04 24 76 39 10 00 	movl   $0x103976,(%esp)
  101c16:	e8 f7 e6 ff ff       	call   100312 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1e:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c21:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c25:	c7 04 24 85 39 10 00 	movl   $0x103985,(%esp)
  101c2c:	e8 e1 e6 ff ff       	call   100312 <cprintf>
}
  101c31:	c9                   	leave  
  101c32:	c3                   	ret    

00101c33 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c33:	55                   	push   %ebp
  101c34:	89 e5                	mov    %esp,%ebp
  101c36:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101c39:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3c:	8b 40 30             	mov    0x30(%eax),%eax
  101c3f:	83 f8 2f             	cmp    $0x2f,%eax
  101c42:	77 21                	ja     101c65 <trap_dispatch+0x32>
  101c44:	83 f8 2e             	cmp    $0x2e,%eax
  101c47:	0f 83 04 01 00 00    	jae    101d51 <trap_dispatch+0x11e>
  101c4d:	83 f8 21             	cmp    $0x21,%eax
  101c50:	0f 84 81 00 00 00    	je     101cd7 <trap_dispatch+0xa4>
  101c56:	83 f8 24             	cmp    $0x24,%eax
  101c59:	74 56                	je     101cb1 <trap_dispatch+0x7e>
  101c5b:	83 f8 20             	cmp    $0x20,%eax
  101c5e:	74 16                	je     101c76 <trap_dispatch+0x43>
  101c60:	e9 b4 00 00 00       	jmp    101d19 <trap_dispatch+0xe6>
  101c65:	83 e8 78             	sub    $0x78,%eax
  101c68:	83 f8 01             	cmp    $0x1,%eax
  101c6b:	0f 87 a8 00 00 00    	ja     101d19 <trap_dispatch+0xe6>
  101c71:	e9 87 00 00 00       	jmp    101cfd <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    ticks++;
  101c76:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101c7b:	83 c0 01             	add    $0x1,%eax
  101c7e:	a3 08 f9 10 00       	mov    %eax,0x10f908
    if (ticks % TICK_NUM == 0) {
  101c83:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101c89:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101c8e:	89 c8                	mov    %ecx,%eax
  101c90:	f7 e2                	mul    %edx
  101c92:	89 d0                	mov    %edx,%eax
  101c94:	c1 e8 05             	shr    $0x5,%eax
  101c97:	6b c0 64             	imul   $0x64,%eax,%eax
  101c9a:	29 c1                	sub    %eax,%ecx
  101c9c:	89 c8                	mov    %ecx,%eax
  101c9e:	85 c0                	test   %eax,%eax
  101ca0:	75 0a                	jne    101cac <trap_dispatch+0x79>
    	print_ticks();
  101ca2:	e8 3c fb ff ff       	call   1017e3 <print_ticks>
    }
        break;
  101ca7:	e9 a6 00 00 00       	jmp    101d52 <trap_dispatch+0x11f>
  101cac:	e9 a1 00 00 00       	jmp    101d52 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101cb1:	e8 04 f9 ff ff       	call   1015ba <cons_getc>
  101cb6:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101cb9:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cbd:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cc1:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc9:	c7 04 24 94 39 10 00 	movl   $0x103994,(%esp)
  101cd0:	e8 3d e6 ff ff       	call   100312 <cprintf>
        break;
  101cd5:	eb 7b                	jmp    101d52 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101cd7:	e8 de f8 ff ff       	call   1015ba <cons_getc>
  101cdc:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101cdf:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101ce3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101ce7:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ceb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cef:	c7 04 24 a6 39 10 00 	movl   $0x1039a6,(%esp)
  101cf6:	e8 17 e6 ff ff       	call   100312 <cprintf>
        break;
  101cfb:	eb 55                	jmp    101d52 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101cfd:	c7 44 24 08 b5 39 10 	movl   $0x1039b5,0x8(%esp)
  101d04:	00 
  101d05:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  101d0c:	00 
  101d0d:	c7 04 24 c5 39 10 00 	movl   $0x1039c5,(%esp)
  101d14:	e8 83 ef ff ff       	call   100c9c <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101d19:	8b 45 08             	mov    0x8(%ebp),%eax
  101d1c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d20:	0f b7 c0             	movzwl %ax,%eax
  101d23:	83 e0 03             	and    $0x3,%eax
  101d26:	85 c0                	test   %eax,%eax
  101d28:	75 28                	jne    101d52 <trap_dispatch+0x11f>
            print_trapframe(tf);
  101d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d2d:	89 04 24             	mov    %eax,(%esp)
  101d30:	e8 82 fc ff ff       	call   1019b7 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101d35:	c7 44 24 08 d6 39 10 	movl   $0x1039d6,0x8(%esp)
  101d3c:	00 
  101d3d:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
  101d44:	00 
  101d45:	c7 04 24 c5 39 10 00 	movl   $0x1039c5,(%esp)
  101d4c:	e8 4b ef ff ff       	call   100c9c <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101d51:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101d52:	c9                   	leave  
  101d53:	c3                   	ret    

00101d54 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101d54:	55                   	push   %ebp
  101d55:	89 e5                	mov    %esp,%ebp
  101d57:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d5d:	89 04 24             	mov    %eax,(%esp)
  101d60:	e8 ce fe ff ff       	call   101c33 <trap_dispatch>
}
  101d65:	c9                   	leave  
  101d66:	c3                   	ret    

00101d67 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101d67:	1e                   	push   %ds
    pushl %es
  101d68:	06                   	push   %es
    pushl %fs
  101d69:	0f a0                	push   %fs
    pushl %gs
  101d6b:	0f a8                	push   %gs
    pushal
  101d6d:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101d6e:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101d73:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101d75:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101d77:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101d78:	e8 d7 ff ff ff       	call   101d54 <trap>

    # pop the pushed stack pointer
    popl %esp
  101d7d:	5c                   	pop    %esp

00101d7e <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101d7e:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101d7f:	0f a9                	pop    %gs
    popl %fs
  101d81:	0f a1                	pop    %fs
    popl %es
  101d83:	07                   	pop    %es
    popl %ds
  101d84:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101d85:	83 c4 08             	add    $0x8,%esp
    iret
  101d88:	cf                   	iret   

00101d89 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101d89:	6a 00                	push   $0x0
  pushl $0
  101d8b:	6a 00                	push   $0x0
  jmp __alltraps
  101d8d:	e9 d5 ff ff ff       	jmp    101d67 <__alltraps>

00101d92 <vector1>:
.globl vector1
vector1:
  pushl $0
  101d92:	6a 00                	push   $0x0
  pushl $1
  101d94:	6a 01                	push   $0x1
  jmp __alltraps
  101d96:	e9 cc ff ff ff       	jmp    101d67 <__alltraps>

00101d9b <vector2>:
.globl vector2
vector2:
  pushl $0
  101d9b:	6a 00                	push   $0x0
  pushl $2
  101d9d:	6a 02                	push   $0x2
  jmp __alltraps
  101d9f:	e9 c3 ff ff ff       	jmp    101d67 <__alltraps>

00101da4 <vector3>:
.globl vector3
vector3:
  pushl $0
  101da4:	6a 00                	push   $0x0
  pushl $3
  101da6:	6a 03                	push   $0x3
  jmp __alltraps
  101da8:	e9 ba ff ff ff       	jmp    101d67 <__alltraps>

00101dad <vector4>:
.globl vector4
vector4:
  pushl $0
  101dad:	6a 00                	push   $0x0
  pushl $4
  101daf:	6a 04                	push   $0x4
  jmp __alltraps
  101db1:	e9 b1 ff ff ff       	jmp    101d67 <__alltraps>

00101db6 <vector5>:
.globl vector5
vector5:
  pushl $0
  101db6:	6a 00                	push   $0x0
  pushl $5
  101db8:	6a 05                	push   $0x5
  jmp __alltraps
  101dba:	e9 a8 ff ff ff       	jmp    101d67 <__alltraps>

00101dbf <vector6>:
.globl vector6
vector6:
  pushl $0
  101dbf:	6a 00                	push   $0x0
  pushl $6
  101dc1:	6a 06                	push   $0x6
  jmp __alltraps
  101dc3:	e9 9f ff ff ff       	jmp    101d67 <__alltraps>

00101dc8 <vector7>:
.globl vector7
vector7:
  pushl $0
  101dc8:	6a 00                	push   $0x0
  pushl $7
  101dca:	6a 07                	push   $0x7
  jmp __alltraps
  101dcc:	e9 96 ff ff ff       	jmp    101d67 <__alltraps>

00101dd1 <vector8>:
.globl vector8
vector8:
  pushl $8
  101dd1:	6a 08                	push   $0x8
  jmp __alltraps
  101dd3:	e9 8f ff ff ff       	jmp    101d67 <__alltraps>

00101dd8 <vector9>:
.globl vector9
vector9:
  pushl $9
  101dd8:	6a 09                	push   $0x9
  jmp __alltraps
  101dda:	e9 88 ff ff ff       	jmp    101d67 <__alltraps>

00101ddf <vector10>:
.globl vector10
vector10:
  pushl $10
  101ddf:	6a 0a                	push   $0xa
  jmp __alltraps
  101de1:	e9 81 ff ff ff       	jmp    101d67 <__alltraps>

00101de6 <vector11>:
.globl vector11
vector11:
  pushl $11
  101de6:	6a 0b                	push   $0xb
  jmp __alltraps
  101de8:	e9 7a ff ff ff       	jmp    101d67 <__alltraps>

00101ded <vector12>:
.globl vector12
vector12:
  pushl $12
  101ded:	6a 0c                	push   $0xc
  jmp __alltraps
  101def:	e9 73 ff ff ff       	jmp    101d67 <__alltraps>

00101df4 <vector13>:
.globl vector13
vector13:
  pushl $13
  101df4:	6a 0d                	push   $0xd
  jmp __alltraps
  101df6:	e9 6c ff ff ff       	jmp    101d67 <__alltraps>

00101dfb <vector14>:
.globl vector14
vector14:
  pushl $14
  101dfb:	6a 0e                	push   $0xe
  jmp __alltraps
  101dfd:	e9 65 ff ff ff       	jmp    101d67 <__alltraps>

00101e02 <vector15>:
.globl vector15
vector15:
  pushl $0
  101e02:	6a 00                	push   $0x0
  pushl $15
  101e04:	6a 0f                	push   $0xf
  jmp __alltraps
  101e06:	e9 5c ff ff ff       	jmp    101d67 <__alltraps>

00101e0b <vector16>:
.globl vector16
vector16:
  pushl $0
  101e0b:	6a 00                	push   $0x0
  pushl $16
  101e0d:	6a 10                	push   $0x10
  jmp __alltraps
  101e0f:	e9 53 ff ff ff       	jmp    101d67 <__alltraps>

00101e14 <vector17>:
.globl vector17
vector17:
  pushl $17
  101e14:	6a 11                	push   $0x11
  jmp __alltraps
  101e16:	e9 4c ff ff ff       	jmp    101d67 <__alltraps>

00101e1b <vector18>:
.globl vector18
vector18:
  pushl $0
  101e1b:	6a 00                	push   $0x0
  pushl $18
  101e1d:	6a 12                	push   $0x12
  jmp __alltraps
  101e1f:	e9 43 ff ff ff       	jmp    101d67 <__alltraps>

00101e24 <vector19>:
.globl vector19
vector19:
  pushl $0
  101e24:	6a 00                	push   $0x0
  pushl $19
  101e26:	6a 13                	push   $0x13
  jmp __alltraps
  101e28:	e9 3a ff ff ff       	jmp    101d67 <__alltraps>

00101e2d <vector20>:
.globl vector20
vector20:
  pushl $0
  101e2d:	6a 00                	push   $0x0
  pushl $20
  101e2f:	6a 14                	push   $0x14
  jmp __alltraps
  101e31:	e9 31 ff ff ff       	jmp    101d67 <__alltraps>

00101e36 <vector21>:
.globl vector21
vector21:
  pushl $0
  101e36:	6a 00                	push   $0x0
  pushl $21
  101e38:	6a 15                	push   $0x15
  jmp __alltraps
  101e3a:	e9 28 ff ff ff       	jmp    101d67 <__alltraps>

00101e3f <vector22>:
.globl vector22
vector22:
  pushl $0
  101e3f:	6a 00                	push   $0x0
  pushl $22
  101e41:	6a 16                	push   $0x16
  jmp __alltraps
  101e43:	e9 1f ff ff ff       	jmp    101d67 <__alltraps>

00101e48 <vector23>:
.globl vector23
vector23:
  pushl $0
  101e48:	6a 00                	push   $0x0
  pushl $23
  101e4a:	6a 17                	push   $0x17
  jmp __alltraps
  101e4c:	e9 16 ff ff ff       	jmp    101d67 <__alltraps>

00101e51 <vector24>:
.globl vector24
vector24:
  pushl $0
  101e51:	6a 00                	push   $0x0
  pushl $24
  101e53:	6a 18                	push   $0x18
  jmp __alltraps
  101e55:	e9 0d ff ff ff       	jmp    101d67 <__alltraps>

00101e5a <vector25>:
.globl vector25
vector25:
  pushl $0
  101e5a:	6a 00                	push   $0x0
  pushl $25
  101e5c:	6a 19                	push   $0x19
  jmp __alltraps
  101e5e:	e9 04 ff ff ff       	jmp    101d67 <__alltraps>

00101e63 <vector26>:
.globl vector26
vector26:
  pushl $0
  101e63:	6a 00                	push   $0x0
  pushl $26
  101e65:	6a 1a                	push   $0x1a
  jmp __alltraps
  101e67:	e9 fb fe ff ff       	jmp    101d67 <__alltraps>

00101e6c <vector27>:
.globl vector27
vector27:
  pushl $0
  101e6c:	6a 00                	push   $0x0
  pushl $27
  101e6e:	6a 1b                	push   $0x1b
  jmp __alltraps
  101e70:	e9 f2 fe ff ff       	jmp    101d67 <__alltraps>

00101e75 <vector28>:
.globl vector28
vector28:
  pushl $0
  101e75:	6a 00                	push   $0x0
  pushl $28
  101e77:	6a 1c                	push   $0x1c
  jmp __alltraps
  101e79:	e9 e9 fe ff ff       	jmp    101d67 <__alltraps>

00101e7e <vector29>:
.globl vector29
vector29:
  pushl $0
  101e7e:	6a 00                	push   $0x0
  pushl $29
  101e80:	6a 1d                	push   $0x1d
  jmp __alltraps
  101e82:	e9 e0 fe ff ff       	jmp    101d67 <__alltraps>

00101e87 <vector30>:
.globl vector30
vector30:
  pushl $0
  101e87:	6a 00                	push   $0x0
  pushl $30
  101e89:	6a 1e                	push   $0x1e
  jmp __alltraps
  101e8b:	e9 d7 fe ff ff       	jmp    101d67 <__alltraps>

00101e90 <vector31>:
.globl vector31
vector31:
  pushl $0
  101e90:	6a 00                	push   $0x0
  pushl $31
  101e92:	6a 1f                	push   $0x1f
  jmp __alltraps
  101e94:	e9 ce fe ff ff       	jmp    101d67 <__alltraps>

00101e99 <vector32>:
.globl vector32
vector32:
  pushl $0
  101e99:	6a 00                	push   $0x0
  pushl $32
  101e9b:	6a 20                	push   $0x20
  jmp __alltraps
  101e9d:	e9 c5 fe ff ff       	jmp    101d67 <__alltraps>

00101ea2 <vector33>:
.globl vector33
vector33:
  pushl $0
  101ea2:	6a 00                	push   $0x0
  pushl $33
  101ea4:	6a 21                	push   $0x21
  jmp __alltraps
  101ea6:	e9 bc fe ff ff       	jmp    101d67 <__alltraps>

00101eab <vector34>:
.globl vector34
vector34:
  pushl $0
  101eab:	6a 00                	push   $0x0
  pushl $34
  101ead:	6a 22                	push   $0x22
  jmp __alltraps
  101eaf:	e9 b3 fe ff ff       	jmp    101d67 <__alltraps>

00101eb4 <vector35>:
.globl vector35
vector35:
  pushl $0
  101eb4:	6a 00                	push   $0x0
  pushl $35
  101eb6:	6a 23                	push   $0x23
  jmp __alltraps
  101eb8:	e9 aa fe ff ff       	jmp    101d67 <__alltraps>

00101ebd <vector36>:
.globl vector36
vector36:
  pushl $0
  101ebd:	6a 00                	push   $0x0
  pushl $36
  101ebf:	6a 24                	push   $0x24
  jmp __alltraps
  101ec1:	e9 a1 fe ff ff       	jmp    101d67 <__alltraps>

00101ec6 <vector37>:
.globl vector37
vector37:
  pushl $0
  101ec6:	6a 00                	push   $0x0
  pushl $37
  101ec8:	6a 25                	push   $0x25
  jmp __alltraps
  101eca:	e9 98 fe ff ff       	jmp    101d67 <__alltraps>

00101ecf <vector38>:
.globl vector38
vector38:
  pushl $0
  101ecf:	6a 00                	push   $0x0
  pushl $38
  101ed1:	6a 26                	push   $0x26
  jmp __alltraps
  101ed3:	e9 8f fe ff ff       	jmp    101d67 <__alltraps>

00101ed8 <vector39>:
.globl vector39
vector39:
  pushl $0
  101ed8:	6a 00                	push   $0x0
  pushl $39
  101eda:	6a 27                	push   $0x27
  jmp __alltraps
  101edc:	e9 86 fe ff ff       	jmp    101d67 <__alltraps>

00101ee1 <vector40>:
.globl vector40
vector40:
  pushl $0
  101ee1:	6a 00                	push   $0x0
  pushl $40
  101ee3:	6a 28                	push   $0x28
  jmp __alltraps
  101ee5:	e9 7d fe ff ff       	jmp    101d67 <__alltraps>

00101eea <vector41>:
.globl vector41
vector41:
  pushl $0
  101eea:	6a 00                	push   $0x0
  pushl $41
  101eec:	6a 29                	push   $0x29
  jmp __alltraps
  101eee:	e9 74 fe ff ff       	jmp    101d67 <__alltraps>

00101ef3 <vector42>:
.globl vector42
vector42:
  pushl $0
  101ef3:	6a 00                	push   $0x0
  pushl $42
  101ef5:	6a 2a                	push   $0x2a
  jmp __alltraps
  101ef7:	e9 6b fe ff ff       	jmp    101d67 <__alltraps>

00101efc <vector43>:
.globl vector43
vector43:
  pushl $0
  101efc:	6a 00                	push   $0x0
  pushl $43
  101efe:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f00:	e9 62 fe ff ff       	jmp    101d67 <__alltraps>

00101f05 <vector44>:
.globl vector44
vector44:
  pushl $0
  101f05:	6a 00                	push   $0x0
  pushl $44
  101f07:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f09:	e9 59 fe ff ff       	jmp    101d67 <__alltraps>

00101f0e <vector45>:
.globl vector45
vector45:
  pushl $0
  101f0e:	6a 00                	push   $0x0
  pushl $45
  101f10:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f12:	e9 50 fe ff ff       	jmp    101d67 <__alltraps>

00101f17 <vector46>:
.globl vector46
vector46:
  pushl $0
  101f17:	6a 00                	push   $0x0
  pushl $46
  101f19:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f1b:	e9 47 fe ff ff       	jmp    101d67 <__alltraps>

00101f20 <vector47>:
.globl vector47
vector47:
  pushl $0
  101f20:	6a 00                	push   $0x0
  pushl $47
  101f22:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f24:	e9 3e fe ff ff       	jmp    101d67 <__alltraps>

00101f29 <vector48>:
.globl vector48
vector48:
  pushl $0
  101f29:	6a 00                	push   $0x0
  pushl $48
  101f2b:	6a 30                	push   $0x30
  jmp __alltraps
  101f2d:	e9 35 fe ff ff       	jmp    101d67 <__alltraps>

00101f32 <vector49>:
.globl vector49
vector49:
  pushl $0
  101f32:	6a 00                	push   $0x0
  pushl $49
  101f34:	6a 31                	push   $0x31
  jmp __alltraps
  101f36:	e9 2c fe ff ff       	jmp    101d67 <__alltraps>

00101f3b <vector50>:
.globl vector50
vector50:
  pushl $0
  101f3b:	6a 00                	push   $0x0
  pushl $50
  101f3d:	6a 32                	push   $0x32
  jmp __alltraps
  101f3f:	e9 23 fe ff ff       	jmp    101d67 <__alltraps>

00101f44 <vector51>:
.globl vector51
vector51:
  pushl $0
  101f44:	6a 00                	push   $0x0
  pushl $51
  101f46:	6a 33                	push   $0x33
  jmp __alltraps
  101f48:	e9 1a fe ff ff       	jmp    101d67 <__alltraps>

00101f4d <vector52>:
.globl vector52
vector52:
  pushl $0
  101f4d:	6a 00                	push   $0x0
  pushl $52
  101f4f:	6a 34                	push   $0x34
  jmp __alltraps
  101f51:	e9 11 fe ff ff       	jmp    101d67 <__alltraps>

00101f56 <vector53>:
.globl vector53
vector53:
  pushl $0
  101f56:	6a 00                	push   $0x0
  pushl $53
  101f58:	6a 35                	push   $0x35
  jmp __alltraps
  101f5a:	e9 08 fe ff ff       	jmp    101d67 <__alltraps>

00101f5f <vector54>:
.globl vector54
vector54:
  pushl $0
  101f5f:	6a 00                	push   $0x0
  pushl $54
  101f61:	6a 36                	push   $0x36
  jmp __alltraps
  101f63:	e9 ff fd ff ff       	jmp    101d67 <__alltraps>

00101f68 <vector55>:
.globl vector55
vector55:
  pushl $0
  101f68:	6a 00                	push   $0x0
  pushl $55
  101f6a:	6a 37                	push   $0x37
  jmp __alltraps
  101f6c:	e9 f6 fd ff ff       	jmp    101d67 <__alltraps>

00101f71 <vector56>:
.globl vector56
vector56:
  pushl $0
  101f71:	6a 00                	push   $0x0
  pushl $56
  101f73:	6a 38                	push   $0x38
  jmp __alltraps
  101f75:	e9 ed fd ff ff       	jmp    101d67 <__alltraps>

00101f7a <vector57>:
.globl vector57
vector57:
  pushl $0
  101f7a:	6a 00                	push   $0x0
  pushl $57
  101f7c:	6a 39                	push   $0x39
  jmp __alltraps
  101f7e:	e9 e4 fd ff ff       	jmp    101d67 <__alltraps>

00101f83 <vector58>:
.globl vector58
vector58:
  pushl $0
  101f83:	6a 00                	push   $0x0
  pushl $58
  101f85:	6a 3a                	push   $0x3a
  jmp __alltraps
  101f87:	e9 db fd ff ff       	jmp    101d67 <__alltraps>

00101f8c <vector59>:
.globl vector59
vector59:
  pushl $0
  101f8c:	6a 00                	push   $0x0
  pushl $59
  101f8e:	6a 3b                	push   $0x3b
  jmp __alltraps
  101f90:	e9 d2 fd ff ff       	jmp    101d67 <__alltraps>

00101f95 <vector60>:
.globl vector60
vector60:
  pushl $0
  101f95:	6a 00                	push   $0x0
  pushl $60
  101f97:	6a 3c                	push   $0x3c
  jmp __alltraps
  101f99:	e9 c9 fd ff ff       	jmp    101d67 <__alltraps>

00101f9e <vector61>:
.globl vector61
vector61:
  pushl $0
  101f9e:	6a 00                	push   $0x0
  pushl $61
  101fa0:	6a 3d                	push   $0x3d
  jmp __alltraps
  101fa2:	e9 c0 fd ff ff       	jmp    101d67 <__alltraps>

00101fa7 <vector62>:
.globl vector62
vector62:
  pushl $0
  101fa7:	6a 00                	push   $0x0
  pushl $62
  101fa9:	6a 3e                	push   $0x3e
  jmp __alltraps
  101fab:	e9 b7 fd ff ff       	jmp    101d67 <__alltraps>

00101fb0 <vector63>:
.globl vector63
vector63:
  pushl $0
  101fb0:	6a 00                	push   $0x0
  pushl $63
  101fb2:	6a 3f                	push   $0x3f
  jmp __alltraps
  101fb4:	e9 ae fd ff ff       	jmp    101d67 <__alltraps>

00101fb9 <vector64>:
.globl vector64
vector64:
  pushl $0
  101fb9:	6a 00                	push   $0x0
  pushl $64
  101fbb:	6a 40                	push   $0x40
  jmp __alltraps
  101fbd:	e9 a5 fd ff ff       	jmp    101d67 <__alltraps>

00101fc2 <vector65>:
.globl vector65
vector65:
  pushl $0
  101fc2:	6a 00                	push   $0x0
  pushl $65
  101fc4:	6a 41                	push   $0x41
  jmp __alltraps
  101fc6:	e9 9c fd ff ff       	jmp    101d67 <__alltraps>

00101fcb <vector66>:
.globl vector66
vector66:
  pushl $0
  101fcb:	6a 00                	push   $0x0
  pushl $66
  101fcd:	6a 42                	push   $0x42
  jmp __alltraps
  101fcf:	e9 93 fd ff ff       	jmp    101d67 <__alltraps>

00101fd4 <vector67>:
.globl vector67
vector67:
  pushl $0
  101fd4:	6a 00                	push   $0x0
  pushl $67
  101fd6:	6a 43                	push   $0x43
  jmp __alltraps
  101fd8:	e9 8a fd ff ff       	jmp    101d67 <__alltraps>

00101fdd <vector68>:
.globl vector68
vector68:
  pushl $0
  101fdd:	6a 00                	push   $0x0
  pushl $68
  101fdf:	6a 44                	push   $0x44
  jmp __alltraps
  101fe1:	e9 81 fd ff ff       	jmp    101d67 <__alltraps>

00101fe6 <vector69>:
.globl vector69
vector69:
  pushl $0
  101fe6:	6a 00                	push   $0x0
  pushl $69
  101fe8:	6a 45                	push   $0x45
  jmp __alltraps
  101fea:	e9 78 fd ff ff       	jmp    101d67 <__alltraps>

00101fef <vector70>:
.globl vector70
vector70:
  pushl $0
  101fef:	6a 00                	push   $0x0
  pushl $70
  101ff1:	6a 46                	push   $0x46
  jmp __alltraps
  101ff3:	e9 6f fd ff ff       	jmp    101d67 <__alltraps>

00101ff8 <vector71>:
.globl vector71
vector71:
  pushl $0
  101ff8:	6a 00                	push   $0x0
  pushl $71
  101ffa:	6a 47                	push   $0x47
  jmp __alltraps
  101ffc:	e9 66 fd ff ff       	jmp    101d67 <__alltraps>

00102001 <vector72>:
.globl vector72
vector72:
  pushl $0
  102001:	6a 00                	push   $0x0
  pushl $72
  102003:	6a 48                	push   $0x48
  jmp __alltraps
  102005:	e9 5d fd ff ff       	jmp    101d67 <__alltraps>

0010200a <vector73>:
.globl vector73
vector73:
  pushl $0
  10200a:	6a 00                	push   $0x0
  pushl $73
  10200c:	6a 49                	push   $0x49
  jmp __alltraps
  10200e:	e9 54 fd ff ff       	jmp    101d67 <__alltraps>

00102013 <vector74>:
.globl vector74
vector74:
  pushl $0
  102013:	6a 00                	push   $0x0
  pushl $74
  102015:	6a 4a                	push   $0x4a
  jmp __alltraps
  102017:	e9 4b fd ff ff       	jmp    101d67 <__alltraps>

0010201c <vector75>:
.globl vector75
vector75:
  pushl $0
  10201c:	6a 00                	push   $0x0
  pushl $75
  10201e:	6a 4b                	push   $0x4b
  jmp __alltraps
  102020:	e9 42 fd ff ff       	jmp    101d67 <__alltraps>

00102025 <vector76>:
.globl vector76
vector76:
  pushl $0
  102025:	6a 00                	push   $0x0
  pushl $76
  102027:	6a 4c                	push   $0x4c
  jmp __alltraps
  102029:	e9 39 fd ff ff       	jmp    101d67 <__alltraps>

0010202e <vector77>:
.globl vector77
vector77:
  pushl $0
  10202e:	6a 00                	push   $0x0
  pushl $77
  102030:	6a 4d                	push   $0x4d
  jmp __alltraps
  102032:	e9 30 fd ff ff       	jmp    101d67 <__alltraps>

00102037 <vector78>:
.globl vector78
vector78:
  pushl $0
  102037:	6a 00                	push   $0x0
  pushl $78
  102039:	6a 4e                	push   $0x4e
  jmp __alltraps
  10203b:	e9 27 fd ff ff       	jmp    101d67 <__alltraps>

00102040 <vector79>:
.globl vector79
vector79:
  pushl $0
  102040:	6a 00                	push   $0x0
  pushl $79
  102042:	6a 4f                	push   $0x4f
  jmp __alltraps
  102044:	e9 1e fd ff ff       	jmp    101d67 <__alltraps>

00102049 <vector80>:
.globl vector80
vector80:
  pushl $0
  102049:	6a 00                	push   $0x0
  pushl $80
  10204b:	6a 50                	push   $0x50
  jmp __alltraps
  10204d:	e9 15 fd ff ff       	jmp    101d67 <__alltraps>

00102052 <vector81>:
.globl vector81
vector81:
  pushl $0
  102052:	6a 00                	push   $0x0
  pushl $81
  102054:	6a 51                	push   $0x51
  jmp __alltraps
  102056:	e9 0c fd ff ff       	jmp    101d67 <__alltraps>

0010205b <vector82>:
.globl vector82
vector82:
  pushl $0
  10205b:	6a 00                	push   $0x0
  pushl $82
  10205d:	6a 52                	push   $0x52
  jmp __alltraps
  10205f:	e9 03 fd ff ff       	jmp    101d67 <__alltraps>

00102064 <vector83>:
.globl vector83
vector83:
  pushl $0
  102064:	6a 00                	push   $0x0
  pushl $83
  102066:	6a 53                	push   $0x53
  jmp __alltraps
  102068:	e9 fa fc ff ff       	jmp    101d67 <__alltraps>

0010206d <vector84>:
.globl vector84
vector84:
  pushl $0
  10206d:	6a 00                	push   $0x0
  pushl $84
  10206f:	6a 54                	push   $0x54
  jmp __alltraps
  102071:	e9 f1 fc ff ff       	jmp    101d67 <__alltraps>

00102076 <vector85>:
.globl vector85
vector85:
  pushl $0
  102076:	6a 00                	push   $0x0
  pushl $85
  102078:	6a 55                	push   $0x55
  jmp __alltraps
  10207a:	e9 e8 fc ff ff       	jmp    101d67 <__alltraps>

0010207f <vector86>:
.globl vector86
vector86:
  pushl $0
  10207f:	6a 00                	push   $0x0
  pushl $86
  102081:	6a 56                	push   $0x56
  jmp __alltraps
  102083:	e9 df fc ff ff       	jmp    101d67 <__alltraps>

00102088 <vector87>:
.globl vector87
vector87:
  pushl $0
  102088:	6a 00                	push   $0x0
  pushl $87
  10208a:	6a 57                	push   $0x57
  jmp __alltraps
  10208c:	e9 d6 fc ff ff       	jmp    101d67 <__alltraps>

00102091 <vector88>:
.globl vector88
vector88:
  pushl $0
  102091:	6a 00                	push   $0x0
  pushl $88
  102093:	6a 58                	push   $0x58
  jmp __alltraps
  102095:	e9 cd fc ff ff       	jmp    101d67 <__alltraps>

0010209a <vector89>:
.globl vector89
vector89:
  pushl $0
  10209a:	6a 00                	push   $0x0
  pushl $89
  10209c:	6a 59                	push   $0x59
  jmp __alltraps
  10209e:	e9 c4 fc ff ff       	jmp    101d67 <__alltraps>

001020a3 <vector90>:
.globl vector90
vector90:
  pushl $0
  1020a3:	6a 00                	push   $0x0
  pushl $90
  1020a5:	6a 5a                	push   $0x5a
  jmp __alltraps
  1020a7:	e9 bb fc ff ff       	jmp    101d67 <__alltraps>

001020ac <vector91>:
.globl vector91
vector91:
  pushl $0
  1020ac:	6a 00                	push   $0x0
  pushl $91
  1020ae:	6a 5b                	push   $0x5b
  jmp __alltraps
  1020b0:	e9 b2 fc ff ff       	jmp    101d67 <__alltraps>

001020b5 <vector92>:
.globl vector92
vector92:
  pushl $0
  1020b5:	6a 00                	push   $0x0
  pushl $92
  1020b7:	6a 5c                	push   $0x5c
  jmp __alltraps
  1020b9:	e9 a9 fc ff ff       	jmp    101d67 <__alltraps>

001020be <vector93>:
.globl vector93
vector93:
  pushl $0
  1020be:	6a 00                	push   $0x0
  pushl $93
  1020c0:	6a 5d                	push   $0x5d
  jmp __alltraps
  1020c2:	e9 a0 fc ff ff       	jmp    101d67 <__alltraps>

001020c7 <vector94>:
.globl vector94
vector94:
  pushl $0
  1020c7:	6a 00                	push   $0x0
  pushl $94
  1020c9:	6a 5e                	push   $0x5e
  jmp __alltraps
  1020cb:	e9 97 fc ff ff       	jmp    101d67 <__alltraps>

001020d0 <vector95>:
.globl vector95
vector95:
  pushl $0
  1020d0:	6a 00                	push   $0x0
  pushl $95
  1020d2:	6a 5f                	push   $0x5f
  jmp __alltraps
  1020d4:	e9 8e fc ff ff       	jmp    101d67 <__alltraps>

001020d9 <vector96>:
.globl vector96
vector96:
  pushl $0
  1020d9:	6a 00                	push   $0x0
  pushl $96
  1020db:	6a 60                	push   $0x60
  jmp __alltraps
  1020dd:	e9 85 fc ff ff       	jmp    101d67 <__alltraps>

001020e2 <vector97>:
.globl vector97
vector97:
  pushl $0
  1020e2:	6a 00                	push   $0x0
  pushl $97
  1020e4:	6a 61                	push   $0x61
  jmp __alltraps
  1020e6:	e9 7c fc ff ff       	jmp    101d67 <__alltraps>

001020eb <vector98>:
.globl vector98
vector98:
  pushl $0
  1020eb:	6a 00                	push   $0x0
  pushl $98
  1020ed:	6a 62                	push   $0x62
  jmp __alltraps
  1020ef:	e9 73 fc ff ff       	jmp    101d67 <__alltraps>

001020f4 <vector99>:
.globl vector99
vector99:
  pushl $0
  1020f4:	6a 00                	push   $0x0
  pushl $99
  1020f6:	6a 63                	push   $0x63
  jmp __alltraps
  1020f8:	e9 6a fc ff ff       	jmp    101d67 <__alltraps>

001020fd <vector100>:
.globl vector100
vector100:
  pushl $0
  1020fd:	6a 00                	push   $0x0
  pushl $100
  1020ff:	6a 64                	push   $0x64
  jmp __alltraps
  102101:	e9 61 fc ff ff       	jmp    101d67 <__alltraps>

00102106 <vector101>:
.globl vector101
vector101:
  pushl $0
  102106:	6a 00                	push   $0x0
  pushl $101
  102108:	6a 65                	push   $0x65
  jmp __alltraps
  10210a:	e9 58 fc ff ff       	jmp    101d67 <__alltraps>

0010210f <vector102>:
.globl vector102
vector102:
  pushl $0
  10210f:	6a 00                	push   $0x0
  pushl $102
  102111:	6a 66                	push   $0x66
  jmp __alltraps
  102113:	e9 4f fc ff ff       	jmp    101d67 <__alltraps>

00102118 <vector103>:
.globl vector103
vector103:
  pushl $0
  102118:	6a 00                	push   $0x0
  pushl $103
  10211a:	6a 67                	push   $0x67
  jmp __alltraps
  10211c:	e9 46 fc ff ff       	jmp    101d67 <__alltraps>

00102121 <vector104>:
.globl vector104
vector104:
  pushl $0
  102121:	6a 00                	push   $0x0
  pushl $104
  102123:	6a 68                	push   $0x68
  jmp __alltraps
  102125:	e9 3d fc ff ff       	jmp    101d67 <__alltraps>

0010212a <vector105>:
.globl vector105
vector105:
  pushl $0
  10212a:	6a 00                	push   $0x0
  pushl $105
  10212c:	6a 69                	push   $0x69
  jmp __alltraps
  10212e:	e9 34 fc ff ff       	jmp    101d67 <__alltraps>

00102133 <vector106>:
.globl vector106
vector106:
  pushl $0
  102133:	6a 00                	push   $0x0
  pushl $106
  102135:	6a 6a                	push   $0x6a
  jmp __alltraps
  102137:	e9 2b fc ff ff       	jmp    101d67 <__alltraps>

0010213c <vector107>:
.globl vector107
vector107:
  pushl $0
  10213c:	6a 00                	push   $0x0
  pushl $107
  10213e:	6a 6b                	push   $0x6b
  jmp __alltraps
  102140:	e9 22 fc ff ff       	jmp    101d67 <__alltraps>

00102145 <vector108>:
.globl vector108
vector108:
  pushl $0
  102145:	6a 00                	push   $0x0
  pushl $108
  102147:	6a 6c                	push   $0x6c
  jmp __alltraps
  102149:	e9 19 fc ff ff       	jmp    101d67 <__alltraps>

0010214e <vector109>:
.globl vector109
vector109:
  pushl $0
  10214e:	6a 00                	push   $0x0
  pushl $109
  102150:	6a 6d                	push   $0x6d
  jmp __alltraps
  102152:	e9 10 fc ff ff       	jmp    101d67 <__alltraps>

00102157 <vector110>:
.globl vector110
vector110:
  pushl $0
  102157:	6a 00                	push   $0x0
  pushl $110
  102159:	6a 6e                	push   $0x6e
  jmp __alltraps
  10215b:	e9 07 fc ff ff       	jmp    101d67 <__alltraps>

00102160 <vector111>:
.globl vector111
vector111:
  pushl $0
  102160:	6a 00                	push   $0x0
  pushl $111
  102162:	6a 6f                	push   $0x6f
  jmp __alltraps
  102164:	e9 fe fb ff ff       	jmp    101d67 <__alltraps>

00102169 <vector112>:
.globl vector112
vector112:
  pushl $0
  102169:	6a 00                	push   $0x0
  pushl $112
  10216b:	6a 70                	push   $0x70
  jmp __alltraps
  10216d:	e9 f5 fb ff ff       	jmp    101d67 <__alltraps>

00102172 <vector113>:
.globl vector113
vector113:
  pushl $0
  102172:	6a 00                	push   $0x0
  pushl $113
  102174:	6a 71                	push   $0x71
  jmp __alltraps
  102176:	e9 ec fb ff ff       	jmp    101d67 <__alltraps>

0010217b <vector114>:
.globl vector114
vector114:
  pushl $0
  10217b:	6a 00                	push   $0x0
  pushl $114
  10217d:	6a 72                	push   $0x72
  jmp __alltraps
  10217f:	e9 e3 fb ff ff       	jmp    101d67 <__alltraps>

00102184 <vector115>:
.globl vector115
vector115:
  pushl $0
  102184:	6a 00                	push   $0x0
  pushl $115
  102186:	6a 73                	push   $0x73
  jmp __alltraps
  102188:	e9 da fb ff ff       	jmp    101d67 <__alltraps>

0010218d <vector116>:
.globl vector116
vector116:
  pushl $0
  10218d:	6a 00                	push   $0x0
  pushl $116
  10218f:	6a 74                	push   $0x74
  jmp __alltraps
  102191:	e9 d1 fb ff ff       	jmp    101d67 <__alltraps>

00102196 <vector117>:
.globl vector117
vector117:
  pushl $0
  102196:	6a 00                	push   $0x0
  pushl $117
  102198:	6a 75                	push   $0x75
  jmp __alltraps
  10219a:	e9 c8 fb ff ff       	jmp    101d67 <__alltraps>

0010219f <vector118>:
.globl vector118
vector118:
  pushl $0
  10219f:	6a 00                	push   $0x0
  pushl $118
  1021a1:	6a 76                	push   $0x76
  jmp __alltraps
  1021a3:	e9 bf fb ff ff       	jmp    101d67 <__alltraps>

001021a8 <vector119>:
.globl vector119
vector119:
  pushl $0
  1021a8:	6a 00                	push   $0x0
  pushl $119
  1021aa:	6a 77                	push   $0x77
  jmp __alltraps
  1021ac:	e9 b6 fb ff ff       	jmp    101d67 <__alltraps>

001021b1 <vector120>:
.globl vector120
vector120:
  pushl $0
  1021b1:	6a 00                	push   $0x0
  pushl $120
  1021b3:	6a 78                	push   $0x78
  jmp __alltraps
  1021b5:	e9 ad fb ff ff       	jmp    101d67 <__alltraps>

001021ba <vector121>:
.globl vector121
vector121:
  pushl $0
  1021ba:	6a 00                	push   $0x0
  pushl $121
  1021bc:	6a 79                	push   $0x79
  jmp __alltraps
  1021be:	e9 a4 fb ff ff       	jmp    101d67 <__alltraps>

001021c3 <vector122>:
.globl vector122
vector122:
  pushl $0
  1021c3:	6a 00                	push   $0x0
  pushl $122
  1021c5:	6a 7a                	push   $0x7a
  jmp __alltraps
  1021c7:	e9 9b fb ff ff       	jmp    101d67 <__alltraps>

001021cc <vector123>:
.globl vector123
vector123:
  pushl $0
  1021cc:	6a 00                	push   $0x0
  pushl $123
  1021ce:	6a 7b                	push   $0x7b
  jmp __alltraps
  1021d0:	e9 92 fb ff ff       	jmp    101d67 <__alltraps>

001021d5 <vector124>:
.globl vector124
vector124:
  pushl $0
  1021d5:	6a 00                	push   $0x0
  pushl $124
  1021d7:	6a 7c                	push   $0x7c
  jmp __alltraps
  1021d9:	e9 89 fb ff ff       	jmp    101d67 <__alltraps>

001021de <vector125>:
.globl vector125
vector125:
  pushl $0
  1021de:	6a 00                	push   $0x0
  pushl $125
  1021e0:	6a 7d                	push   $0x7d
  jmp __alltraps
  1021e2:	e9 80 fb ff ff       	jmp    101d67 <__alltraps>

001021e7 <vector126>:
.globl vector126
vector126:
  pushl $0
  1021e7:	6a 00                	push   $0x0
  pushl $126
  1021e9:	6a 7e                	push   $0x7e
  jmp __alltraps
  1021eb:	e9 77 fb ff ff       	jmp    101d67 <__alltraps>

001021f0 <vector127>:
.globl vector127
vector127:
  pushl $0
  1021f0:	6a 00                	push   $0x0
  pushl $127
  1021f2:	6a 7f                	push   $0x7f
  jmp __alltraps
  1021f4:	e9 6e fb ff ff       	jmp    101d67 <__alltraps>

001021f9 <vector128>:
.globl vector128
vector128:
  pushl $0
  1021f9:	6a 00                	push   $0x0
  pushl $128
  1021fb:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102200:	e9 62 fb ff ff       	jmp    101d67 <__alltraps>

00102205 <vector129>:
.globl vector129
vector129:
  pushl $0
  102205:	6a 00                	push   $0x0
  pushl $129
  102207:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10220c:	e9 56 fb ff ff       	jmp    101d67 <__alltraps>

00102211 <vector130>:
.globl vector130
vector130:
  pushl $0
  102211:	6a 00                	push   $0x0
  pushl $130
  102213:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102218:	e9 4a fb ff ff       	jmp    101d67 <__alltraps>

0010221d <vector131>:
.globl vector131
vector131:
  pushl $0
  10221d:	6a 00                	push   $0x0
  pushl $131
  10221f:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102224:	e9 3e fb ff ff       	jmp    101d67 <__alltraps>

00102229 <vector132>:
.globl vector132
vector132:
  pushl $0
  102229:	6a 00                	push   $0x0
  pushl $132
  10222b:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102230:	e9 32 fb ff ff       	jmp    101d67 <__alltraps>

00102235 <vector133>:
.globl vector133
vector133:
  pushl $0
  102235:	6a 00                	push   $0x0
  pushl $133
  102237:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10223c:	e9 26 fb ff ff       	jmp    101d67 <__alltraps>

00102241 <vector134>:
.globl vector134
vector134:
  pushl $0
  102241:	6a 00                	push   $0x0
  pushl $134
  102243:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102248:	e9 1a fb ff ff       	jmp    101d67 <__alltraps>

0010224d <vector135>:
.globl vector135
vector135:
  pushl $0
  10224d:	6a 00                	push   $0x0
  pushl $135
  10224f:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102254:	e9 0e fb ff ff       	jmp    101d67 <__alltraps>

00102259 <vector136>:
.globl vector136
vector136:
  pushl $0
  102259:	6a 00                	push   $0x0
  pushl $136
  10225b:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102260:	e9 02 fb ff ff       	jmp    101d67 <__alltraps>

00102265 <vector137>:
.globl vector137
vector137:
  pushl $0
  102265:	6a 00                	push   $0x0
  pushl $137
  102267:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10226c:	e9 f6 fa ff ff       	jmp    101d67 <__alltraps>

00102271 <vector138>:
.globl vector138
vector138:
  pushl $0
  102271:	6a 00                	push   $0x0
  pushl $138
  102273:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102278:	e9 ea fa ff ff       	jmp    101d67 <__alltraps>

0010227d <vector139>:
.globl vector139
vector139:
  pushl $0
  10227d:	6a 00                	push   $0x0
  pushl $139
  10227f:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102284:	e9 de fa ff ff       	jmp    101d67 <__alltraps>

00102289 <vector140>:
.globl vector140
vector140:
  pushl $0
  102289:	6a 00                	push   $0x0
  pushl $140
  10228b:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102290:	e9 d2 fa ff ff       	jmp    101d67 <__alltraps>

00102295 <vector141>:
.globl vector141
vector141:
  pushl $0
  102295:	6a 00                	push   $0x0
  pushl $141
  102297:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10229c:	e9 c6 fa ff ff       	jmp    101d67 <__alltraps>

001022a1 <vector142>:
.globl vector142
vector142:
  pushl $0
  1022a1:	6a 00                	push   $0x0
  pushl $142
  1022a3:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1022a8:	e9 ba fa ff ff       	jmp    101d67 <__alltraps>

001022ad <vector143>:
.globl vector143
vector143:
  pushl $0
  1022ad:	6a 00                	push   $0x0
  pushl $143
  1022af:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1022b4:	e9 ae fa ff ff       	jmp    101d67 <__alltraps>

001022b9 <vector144>:
.globl vector144
vector144:
  pushl $0
  1022b9:	6a 00                	push   $0x0
  pushl $144
  1022bb:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1022c0:	e9 a2 fa ff ff       	jmp    101d67 <__alltraps>

001022c5 <vector145>:
.globl vector145
vector145:
  pushl $0
  1022c5:	6a 00                	push   $0x0
  pushl $145
  1022c7:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1022cc:	e9 96 fa ff ff       	jmp    101d67 <__alltraps>

001022d1 <vector146>:
.globl vector146
vector146:
  pushl $0
  1022d1:	6a 00                	push   $0x0
  pushl $146
  1022d3:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1022d8:	e9 8a fa ff ff       	jmp    101d67 <__alltraps>

001022dd <vector147>:
.globl vector147
vector147:
  pushl $0
  1022dd:	6a 00                	push   $0x0
  pushl $147
  1022df:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1022e4:	e9 7e fa ff ff       	jmp    101d67 <__alltraps>

001022e9 <vector148>:
.globl vector148
vector148:
  pushl $0
  1022e9:	6a 00                	push   $0x0
  pushl $148
  1022eb:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1022f0:	e9 72 fa ff ff       	jmp    101d67 <__alltraps>

001022f5 <vector149>:
.globl vector149
vector149:
  pushl $0
  1022f5:	6a 00                	push   $0x0
  pushl $149
  1022f7:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1022fc:	e9 66 fa ff ff       	jmp    101d67 <__alltraps>

00102301 <vector150>:
.globl vector150
vector150:
  pushl $0
  102301:	6a 00                	push   $0x0
  pushl $150
  102303:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102308:	e9 5a fa ff ff       	jmp    101d67 <__alltraps>

0010230d <vector151>:
.globl vector151
vector151:
  pushl $0
  10230d:	6a 00                	push   $0x0
  pushl $151
  10230f:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102314:	e9 4e fa ff ff       	jmp    101d67 <__alltraps>

00102319 <vector152>:
.globl vector152
vector152:
  pushl $0
  102319:	6a 00                	push   $0x0
  pushl $152
  10231b:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102320:	e9 42 fa ff ff       	jmp    101d67 <__alltraps>

00102325 <vector153>:
.globl vector153
vector153:
  pushl $0
  102325:	6a 00                	push   $0x0
  pushl $153
  102327:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10232c:	e9 36 fa ff ff       	jmp    101d67 <__alltraps>

00102331 <vector154>:
.globl vector154
vector154:
  pushl $0
  102331:	6a 00                	push   $0x0
  pushl $154
  102333:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102338:	e9 2a fa ff ff       	jmp    101d67 <__alltraps>

0010233d <vector155>:
.globl vector155
vector155:
  pushl $0
  10233d:	6a 00                	push   $0x0
  pushl $155
  10233f:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102344:	e9 1e fa ff ff       	jmp    101d67 <__alltraps>

00102349 <vector156>:
.globl vector156
vector156:
  pushl $0
  102349:	6a 00                	push   $0x0
  pushl $156
  10234b:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102350:	e9 12 fa ff ff       	jmp    101d67 <__alltraps>

00102355 <vector157>:
.globl vector157
vector157:
  pushl $0
  102355:	6a 00                	push   $0x0
  pushl $157
  102357:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10235c:	e9 06 fa ff ff       	jmp    101d67 <__alltraps>

00102361 <vector158>:
.globl vector158
vector158:
  pushl $0
  102361:	6a 00                	push   $0x0
  pushl $158
  102363:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102368:	e9 fa f9 ff ff       	jmp    101d67 <__alltraps>

0010236d <vector159>:
.globl vector159
vector159:
  pushl $0
  10236d:	6a 00                	push   $0x0
  pushl $159
  10236f:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102374:	e9 ee f9 ff ff       	jmp    101d67 <__alltraps>

00102379 <vector160>:
.globl vector160
vector160:
  pushl $0
  102379:	6a 00                	push   $0x0
  pushl $160
  10237b:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102380:	e9 e2 f9 ff ff       	jmp    101d67 <__alltraps>

00102385 <vector161>:
.globl vector161
vector161:
  pushl $0
  102385:	6a 00                	push   $0x0
  pushl $161
  102387:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10238c:	e9 d6 f9 ff ff       	jmp    101d67 <__alltraps>

00102391 <vector162>:
.globl vector162
vector162:
  pushl $0
  102391:	6a 00                	push   $0x0
  pushl $162
  102393:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102398:	e9 ca f9 ff ff       	jmp    101d67 <__alltraps>

0010239d <vector163>:
.globl vector163
vector163:
  pushl $0
  10239d:	6a 00                	push   $0x0
  pushl $163
  10239f:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1023a4:	e9 be f9 ff ff       	jmp    101d67 <__alltraps>

001023a9 <vector164>:
.globl vector164
vector164:
  pushl $0
  1023a9:	6a 00                	push   $0x0
  pushl $164
  1023ab:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1023b0:	e9 b2 f9 ff ff       	jmp    101d67 <__alltraps>

001023b5 <vector165>:
.globl vector165
vector165:
  pushl $0
  1023b5:	6a 00                	push   $0x0
  pushl $165
  1023b7:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1023bc:	e9 a6 f9 ff ff       	jmp    101d67 <__alltraps>

001023c1 <vector166>:
.globl vector166
vector166:
  pushl $0
  1023c1:	6a 00                	push   $0x0
  pushl $166
  1023c3:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1023c8:	e9 9a f9 ff ff       	jmp    101d67 <__alltraps>

001023cd <vector167>:
.globl vector167
vector167:
  pushl $0
  1023cd:	6a 00                	push   $0x0
  pushl $167
  1023cf:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1023d4:	e9 8e f9 ff ff       	jmp    101d67 <__alltraps>

001023d9 <vector168>:
.globl vector168
vector168:
  pushl $0
  1023d9:	6a 00                	push   $0x0
  pushl $168
  1023db:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1023e0:	e9 82 f9 ff ff       	jmp    101d67 <__alltraps>

001023e5 <vector169>:
.globl vector169
vector169:
  pushl $0
  1023e5:	6a 00                	push   $0x0
  pushl $169
  1023e7:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1023ec:	e9 76 f9 ff ff       	jmp    101d67 <__alltraps>

001023f1 <vector170>:
.globl vector170
vector170:
  pushl $0
  1023f1:	6a 00                	push   $0x0
  pushl $170
  1023f3:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1023f8:	e9 6a f9 ff ff       	jmp    101d67 <__alltraps>

001023fd <vector171>:
.globl vector171
vector171:
  pushl $0
  1023fd:	6a 00                	push   $0x0
  pushl $171
  1023ff:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102404:	e9 5e f9 ff ff       	jmp    101d67 <__alltraps>

00102409 <vector172>:
.globl vector172
vector172:
  pushl $0
  102409:	6a 00                	push   $0x0
  pushl $172
  10240b:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102410:	e9 52 f9 ff ff       	jmp    101d67 <__alltraps>

00102415 <vector173>:
.globl vector173
vector173:
  pushl $0
  102415:	6a 00                	push   $0x0
  pushl $173
  102417:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10241c:	e9 46 f9 ff ff       	jmp    101d67 <__alltraps>

00102421 <vector174>:
.globl vector174
vector174:
  pushl $0
  102421:	6a 00                	push   $0x0
  pushl $174
  102423:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102428:	e9 3a f9 ff ff       	jmp    101d67 <__alltraps>

0010242d <vector175>:
.globl vector175
vector175:
  pushl $0
  10242d:	6a 00                	push   $0x0
  pushl $175
  10242f:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102434:	e9 2e f9 ff ff       	jmp    101d67 <__alltraps>

00102439 <vector176>:
.globl vector176
vector176:
  pushl $0
  102439:	6a 00                	push   $0x0
  pushl $176
  10243b:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102440:	e9 22 f9 ff ff       	jmp    101d67 <__alltraps>

00102445 <vector177>:
.globl vector177
vector177:
  pushl $0
  102445:	6a 00                	push   $0x0
  pushl $177
  102447:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10244c:	e9 16 f9 ff ff       	jmp    101d67 <__alltraps>

00102451 <vector178>:
.globl vector178
vector178:
  pushl $0
  102451:	6a 00                	push   $0x0
  pushl $178
  102453:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102458:	e9 0a f9 ff ff       	jmp    101d67 <__alltraps>

0010245d <vector179>:
.globl vector179
vector179:
  pushl $0
  10245d:	6a 00                	push   $0x0
  pushl $179
  10245f:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102464:	e9 fe f8 ff ff       	jmp    101d67 <__alltraps>

00102469 <vector180>:
.globl vector180
vector180:
  pushl $0
  102469:	6a 00                	push   $0x0
  pushl $180
  10246b:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102470:	e9 f2 f8 ff ff       	jmp    101d67 <__alltraps>

00102475 <vector181>:
.globl vector181
vector181:
  pushl $0
  102475:	6a 00                	push   $0x0
  pushl $181
  102477:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10247c:	e9 e6 f8 ff ff       	jmp    101d67 <__alltraps>

00102481 <vector182>:
.globl vector182
vector182:
  pushl $0
  102481:	6a 00                	push   $0x0
  pushl $182
  102483:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102488:	e9 da f8 ff ff       	jmp    101d67 <__alltraps>

0010248d <vector183>:
.globl vector183
vector183:
  pushl $0
  10248d:	6a 00                	push   $0x0
  pushl $183
  10248f:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102494:	e9 ce f8 ff ff       	jmp    101d67 <__alltraps>

00102499 <vector184>:
.globl vector184
vector184:
  pushl $0
  102499:	6a 00                	push   $0x0
  pushl $184
  10249b:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1024a0:	e9 c2 f8 ff ff       	jmp    101d67 <__alltraps>

001024a5 <vector185>:
.globl vector185
vector185:
  pushl $0
  1024a5:	6a 00                	push   $0x0
  pushl $185
  1024a7:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1024ac:	e9 b6 f8 ff ff       	jmp    101d67 <__alltraps>

001024b1 <vector186>:
.globl vector186
vector186:
  pushl $0
  1024b1:	6a 00                	push   $0x0
  pushl $186
  1024b3:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1024b8:	e9 aa f8 ff ff       	jmp    101d67 <__alltraps>

001024bd <vector187>:
.globl vector187
vector187:
  pushl $0
  1024bd:	6a 00                	push   $0x0
  pushl $187
  1024bf:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1024c4:	e9 9e f8 ff ff       	jmp    101d67 <__alltraps>

001024c9 <vector188>:
.globl vector188
vector188:
  pushl $0
  1024c9:	6a 00                	push   $0x0
  pushl $188
  1024cb:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1024d0:	e9 92 f8 ff ff       	jmp    101d67 <__alltraps>

001024d5 <vector189>:
.globl vector189
vector189:
  pushl $0
  1024d5:	6a 00                	push   $0x0
  pushl $189
  1024d7:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1024dc:	e9 86 f8 ff ff       	jmp    101d67 <__alltraps>

001024e1 <vector190>:
.globl vector190
vector190:
  pushl $0
  1024e1:	6a 00                	push   $0x0
  pushl $190
  1024e3:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1024e8:	e9 7a f8 ff ff       	jmp    101d67 <__alltraps>

001024ed <vector191>:
.globl vector191
vector191:
  pushl $0
  1024ed:	6a 00                	push   $0x0
  pushl $191
  1024ef:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1024f4:	e9 6e f8 ff ff       	jmp    101d67 <__alltraps>

001024f9 <vector192>:
.globl vector192
vector192:
  pushl $0
  1024f9:	6a 00                	push   $0x0
  pushl $192
  1024fb:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102500:	e9 62 f8 ff ff       	jmp    101d67 <__alltraps>

00102505 <vector193>:
.globl vector193
vector193:
  pushl $0
  102505:	6a 00                	push   $0x0
  pushl $193
  102507:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10250c:	e9 56 f8 ff ff       	jmp    101d67 <__alltraps>

00102511 <vector194>:
.globl vector194
vector194:
  pushl $0
  102511:	6a 00                	push   $0x0
  pushl $194
  102513:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102518:	e9 4a f8 ff ff       	jmp    101d67 <__alltraps>

0010251d <vector195>:
.globl vector195
vector195:
  pushl $0
  10251d:	6a 00                	push   $0x0
  pushl $195
  10251f:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102524:	e9 3e f8 ff ff       	jmp    101d67 <__alltraps>

00102529 <vector196>:
.globl vector196
vector196:
  pushl $0
  102529:	6a 00                	push   $0x0
  pushl $196
  10252b:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102530:	e9 32 f8 ff ff       	jmp    101d67 <__alltraps>

00102535 <vector197>:
.globl vector197
vector197:
  pushl $0
  102535:	6a 00                	push   $0x0
  pushl $197
  102537:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10253c:	e9 26 f8 ff ff       	jmp    101d67 <__alltraps>

00102541 <vector198>:
.globl vector198
vector198:
  pushl $0
  102541:	6a 00                	push   $0x0
  pushl $198
  102543:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102548:	e9 1a f8 ff ff       	jmp    101d67 <__alltraps>

0010254d <vector199>:
.globl vector199
vector199:
  pushl $0
  10254d:	6a 00                	push   $0x0
  pushl $199
  10254f:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102554:	e9 0e f8 ff ff       	jmp    101d67 <__alltraps>

00102559 <vector200>:
.globl vector200
vector200:
  pushl $0
  102559:	6a 00                	push   $0x0
  pushl $200
  10255b:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102560:	e9 02 f8 ff ff       	jmp    101d67 <__alltraps>

00102565 <vector201>:
.globl vector201
vector201:
  pushl $0
  102565:	6a 00                	push   $0x0
  pushl $201
  102567:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10256c:	e9 f6 f7 ff ff       	jmp    101d67 <__alltraps>

00102571 <vector202>:
.globl vector202
vector202:
  pushl $0
  102571:	6a 00                	push   $0x0
  pushl $202
  102573:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102578:	e9 ea f7 ff ff       	jmp    101d67 <__alltraps>

0010257d <vector203>:
.globl vector203
vector203:
  pushl $0
  10257d:	6a 00                	push   $0x0
  pushl $203
  10257f:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102584:	e9 de f7 ff ff       	jmp    101d67 <__alltraps>

00102589 <vector204>:
.globl vector204
vector204:
  pushl $0
  102589:	6a 00                	push   $0x0
  pushl $204
  10258b:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102590:	e9 d2 f7 ff ff       	jmp    101d67 <__alltraps>

00102595 <vector205>:
.globl vector205
vector205:
  pushl $0
  102595:	6a 00                	push   $0x0
  pushl $205
  102597:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10259c:	e9 c6 f7 ff ff       	jmp    101d67 <__alltraps>

001025a1 <vector206>:
.globl vector206
vector206:
  pushl $0
  1025a1:	6a 00                	push   $0x0
  pushl $206
  1025a3:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1025a8:	e9 ba f7 ff ff       	jmp    101d67 <__alltraps>

001025ad <vector207>:
.globl vector207
vector207:
  pushl $0
  1025ad:	6a 00                	push   $0x0
  pushl $207
  1025af:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1025b4:	e9 ae f7 ff ff       	jmp    101d67 <__alltraps>

001025b9 <vector208>:
.globl vector208
vector208:
  pushl $0
  1025b9:	6a 00                	push   $0x0
  pushl $208
  1025bb:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1025c0:	e9 a2 f7 ff ff       	jmp    101d67 <__alltraps>

001025c5 <vector209>:
.globl vector209
vector209:
  pushl $0
  1025c5:	6a 00                	push   $0x0
  pushl $209
  1025c7:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1025cc:	e9 96 f7 ff ff       	jmp    101d67 <__alltraps>

001025d1 <vector210>:
.globl vector210
vector210:
  pushl $0
  1025d1:	6a 00                	push   $0x0
  pushl $210
  1025d3:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1025d8:	e9 8a f7 ff ff       	jmp    101d67 <__alltraps>

001025dd <vector211>:
.globl vector211
vector211:
  pushl $0
  1025dd:	6a 00                	push   $0x0
  pushl $211
  1025df:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1025e4:	e9 7e f7 ff ff       	jmp    101d67 <__alltraps>

001025e9 <vector212>:
.globl vector212
vector212:
  pushl $0
  1025e9:	6a 00                	push   $0x0
  pushl $212
  1025eb:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1025f0:	e9 72 f7 ff ff       	jmp    101d67 <__alltraps>

001025f5 <vector213>:
.globl vector213
vector213:
  pushl $0
  1025f5:	6a 00                	push   $0x0
  pushl $213
  1025f7:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1025fc:	e9 66 f7 ff ff       	jmp    101d67 <__alltraps>

00102601 <vector214>:
.globl vector214
vector214:
  pushl $0
  102601:	6a 00                	push   $0x0
  pushl $214
  102603:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102608:	e9 5a f7 ff ff       	jmp    101d67 <__alltraps>

0010260d <vector215>:
.globl vector215
vector215:
  pushl $0
  10260d:	6a 00                	push   $0x0
  pushl $215
  10260f:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102614:	e9 4e f7 ff ff       	jmp    101d67 <__alltraps>

00102619 <vector216>:
.globl vector216
vector216:
  pushl $0
  102619:	6a 00                	push   $0x0
  pushl $216
  10261b:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102620:	e9 42 f7 ff ff       	jmp    101d67 <__alltraps>

00102625 <vector217>:
.globl vector217
vector217:
  pushl $0
  102625:	6a 00                	push   $0x0
  pushl $217
  102627:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10262c:	e9 36 f7 ff ff       	jmp    101d67 <__alltraps>

00102631 <vector218>:
.globl vector218
vector218:
  pushl $0
  102631:	6a 00                	push   $0x0
  pushl $218
  102633:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102638:	e9 2a f7 ff ff       	jmp    101d67 <__alltraps>

0010263d <vector219>:
.globl vector219
vector219:
  pushl $0
  10263d:	6a 00                	push   $0x0
  pushl $219
  10263f:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102644:	e9 1e f7 ff ff       	jmp    101d67 <__alltraps>

00102649 <vector220>:
.globl vector220
vector220:
  pushl $0
  102649:	6a 00                	push   $0x0
  pushl $220
  10264b:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102650:	e9 12 f7 ff ff       	jmp    101d67 <__alltraps>

00102655 <vector221>:
.globl vector221
vector221:
  pushl $0
  102655:	6a 00                	push   $0x0
  pushl $221
  102657:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10265c:	e9 06 f7 ff ff       	jmp    101d67 <__alltraps>

00102661 <vector222>:
.globl vector222
vector222:
  pushl $0
  102661:	6a 00                	push   $0x0
  pushl $222
  102663:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102668:	e9 fa f6 ff ff       	jmp    101d67 <__alltraps>

0010266d <vector223>:
.globl vector223
vector223:
  pushl $0
  10266d:	6a 00                	push   $0x0
  pushl $223
  10266f:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102674:	e9 ee f6 ff ff       	jmp    101d67 <__alltraps>

00102679 <vector224>:
.globl vector224
vector224:
  pushl $0
  102679:	6a 00                	push   $0x0
  pushl $224
  10267b:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102680:	e9 e2 f6 ff ff       	jmp    101d67 <__alltraps>

00102685 <vector225>:
.globl vector225
vector225:
  pushl $0
  102685:	6a 00                	push   $0x0
  pushl $225
  102687:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10268c:	e9 d6 f6 ff ff       	jmp    101d67 <__alltraps>

00102691 <vector226>:
.globl vector226
vector226:
  pushl $0
  102691:	6a 00                	push   $0x0
  pushl $226
  102693:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102698:	e9 ca f6 ff ff       	jmp    101d67 <__alltraps>

0010269d <vector227>:
.globl vector227
vector227:
  pushl $0
  10269d:	6a 00                	push   $0x0
  pushl $227
  10269f:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1026a4:	e9 be f6 ff ff       	jmp    101d67 <__alltraps>

001026a9 <vector228>:
.globl vector228
vector228:
  pushl $0
  1026a9:	6a 00                	push   $0x0
  pushl $228
  1026ab:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1026b0:	e9 b2 f6 ff ff       	jmp    101d67 <__alltraps>

001026b5 <vector229>:
.globl vector229
vector229:
  pushl $0
  1026b5:	6a 00                	push   $0x0
  pushl $229
  1026b7:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1026bc:	e9 a6 f6 ff ff       	jmp    101d67 <__alltraps>

001026c1 <vector230>:
.globl vector230
vector230:
  pushl $0
  1026c1:	6a 00                	push   $0x0
  pushl $230
  1026c3:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1026c8:	e9 9a f6 ff ff       	jmp    101d67 <__alltraps>

001026cd <vector231>:
.globl vector231
vector231:
  pushl $0
  1026cd:	6a 00                	push   $0x0
  pushl $231
  1026cf:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1026d4:	e9 8e f6 ff ff       	jmp    101d67 <__alltraps>

001026d9 <vector232>:
.globl vector232
vector232:
  pushl $0
  1026d9:	6a 00                	push   $0x0
  pushl $232
  1026db:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1026e0:	e9 82 f6 ff ff       	jmp    101d67 <__alltraps>

001026e5 <vector233>:
.globl vector233
vector233:
  pushl $0
  1026e5:	6a 00                	push   $0x0
  pushl $233
  1026e7:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1026ec:	e9 76 f6 ff ff       	jmp    101d67 <__alltraps>

001026f1 <vector234>:
.globl vector234
vector234:
  pushl $0
  1026f1:	6a 00                	push   $0x0
  pushl $234
  1026f3:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1026f8:	e9 6a f6 ff ff       	jmp    101d67 <__alltraps>

001026fd <vector235>:
.globl vector235
vector235:
  pushl $0
  1026fd:	6a 00                	push   $0x0
  pushl $235
  1026ff:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102704:	e9 5e f6 ff ff       	jmp    101d67 <__alltraps>

00102709 <vector236>:
.globl vector236
vector236:
  pushl $0
  102709:	6a 00                	push   $0x0
  pushl $236
  10270b:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102710:	e9 52 f6 ff ff       	jmp    101d67 <__alltraps>

00102715 <vector237>:
.globl vector237
vector237:
  pushl $0
  102715:	6a 00                	push   $0x0
  pushl $237
  102717:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10271c:	e9 46 f6 ff ff       	jmp    101d67 <__alltraps>

00102721 <vector238>:
.globl vector238
vector238:
  pushl $0
  102721:	6a 00                	push   $0x0
  pushl $238
  102723:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102728:	e9 3a f6 ff ff       	jmp    101d67 <__alltraps>

0010272d <vector239>:
.globl vector239
vector239:
  pushl $0
  10272d:	6a 00                	push   $0x0
  pushl $239
  10272f:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102734:	e9 2e f6 ff ff       	jmp    101d67 <__alltraps>

00102739 <vector240>:
.globl vector240
vector240:
  pushl $0
  102739:	6a 00                	push   $0x0
  pushl $240
  10273b:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102740:	e9 22 f6 ff ff       	jmp    101d67 <__alltraps>

00102745 <vector241>:
.globl vector241
vector241:
  pushl $0
  102745:	6a 00                	push   $0x0
  pushl $241
  102747:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10274c:	e9 16 f6 ff ff       	jmp    101d67 <__alltraps>

00102751 <vector242>:
.globl vector242
vector242:
  pushl $0
  102751:	6a 00                	push   $0x0
  pushl $242
  102753:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102758:	e9 0a f6 ff ff       	jmp    101d67 <__alltraps>

0010275d <vector243>:
.globl vector243
vector243:
  pushl $0
  10275d:	6a 00                	push   $0x0
  pushl $243
  10275f:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102764:	e9 fe f5 ff ff       	jmp    101d67 <__alltraps>

00102769 <vector244>:
.globl vector244
vector244:
  pushl $0
  102769:	6a 00                	push   $0x0
  pushl $244
  10276b:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102770:	e9 f2 f5 ff ff       	jmp    101d67 <__alltraps>

00102775 <vector245>:
.globl vector245
vector245:
  pushl $0
  102775:	6a 00                	push   $0x0
  pushl $245
  102777:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10277c:	e9 e6 f5 ff ff       	jmp    101d67 <__alltraps>

00102781 <vector246>:
.globl vector246
vector246:
  pushl $0
  102781:	6a 00                	push   $0x0
  pushl $246
  102783:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102788:	e9 da f5 ff ff       	jmp    101d67 <__alltraps>

0010278d <vector247>:
.globl vector247
vector247:
  pushl $0
  10278d:	6a 00                	push   $0x0
  pushl $247
  10278f:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102794:	e9 ce f5 ff ff       	jmp    101d67 <__alltraps>

00102799 <vector248>:
.globl vector248
vector248:
  pushl $0
  102799:	6a 00                	push   $0x0
  pushl $248
  10279b:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1027a0:	e9 c2 f5 ff ff       	jmp    101d67 <__alltraps>

001027a5 <vector249>:
.globl vector249
vector249:
  pushl $0
  1027a5:	6a 00                	push   $0x0
  pushl $249
  1027a7:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1027ac:	e9 b6 f5 ff ff       	jmp    101d67 <__alltraps>

001027b1 <vector250>:
.globl vector250
vector250:
  pushl $0
  1027b1:	6a 00                	push   $0x0
  pushl $250
  1027b3:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1027b8:	e9 aa f5 ff ff       	jmp    101d67 <__alltraps>

001027bd <vector251>:
.globl vector251
vector251:
  pushl $0
  1027bd:	6a 00                	push   $0x0
  pushl $251
  1027bf:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1027c4:	e9 9e f5 ff ff       	jmp    101d67 <__alltraps>

001027c9 <vector252>:
.globl vector252
vector252:
  pushl $0
  1027c9:	6a 00                	push   $0x0
  pushl $252
  1027cb:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1027d0:	e9 92 f5 ff ff       	jmp    101d67 <__alltraps>

001027d5 <vector253>:
.globl vector253
vector253:
  pushl $0
  1027d5:	6a 00                	push   $0x0
  pushl $253
  1027d7:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1027dc:	e9 86 f5 ff ff       	jmp    101d67 <__alltraps>

001027e1 <vector254>:
.globl vector254
vector254:
  pushl $0
  1027e1:	6a 00                	push   $0x0
  pushl $254
  1027e3:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1027e8:	e9 7a f5 ff ff       	jmp    101d67 <__alltraps>

001027ed <vector255>:
.globl vector255
vector255:
  pushl $0
  1027ed:	6a 00                	push   $0x0
  pushl $255
  1027ef:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1027f4:	e9 6e f5 ff ff       	jmp    101d67 <__alltraps>

001027f9 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1027f9:	55                   	push   %ebp
  1027fa:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1027fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1027ff:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102802:	b8 23 00 00 00       	mov    $0x23,%eax
  102807:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102809:	b8 23 00 00 00       	mov    $0x23,%eax
  10280e:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102810:	b8 10 00 00 00       	mov    $0x10,%eax
  102815:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102817:	b8 10 00 00 00       	mov    $0x10,%eax
  10281c:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  10281e:	b8 10 00 00 00       	mov    $0x10,%eax
  102823:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102825:	ea 2c 28 10 00 08 00 	ljmp   $0x8,$0x10282c
}
  10282c:	5d                   	pop    %ebp
  10282d:	c3                   	ret    

0010282e <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  10282e:	55                   	push   %ebp
  10282f:	89 e5                	mov    %esp,%ebp
  102831:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102834:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  102839:	05 00 04 00 00       	add    $0x400,%eax
  10283e:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  102843:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  10284a:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  10284c:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  102853:	68 00 
  102855:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  10285a:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  102860:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102865:	c1 e8 10             	shr    $0x10,%eax
  102868:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  10286d:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102874:	83 e0 f0             	and    $0xfffffff0,%eax
  102877:	83 c8 09             	or     $0x9,%eax
  10287a:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10287f:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102886:	83 c8 10             	or     $0x10,%eax
  102889:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10288e:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102895:	83 e0 9f             	and    $0xffffff9f,%eax
  102898:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10289d:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028a4:	83 c8 80             	or     $0xffffff80,%eax
  1028a7:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028ac:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028b3:	83 e0 f0             	and    $0xfffffff0,%eax
  1028b6:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028bb:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028c2:	83 e0 ef             	and    $0xffffffef,%eax
  1028c5:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028ca:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028d1:	83 e0 df             	and    $0xffffffdf,%eax
  1028d4:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028d9:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028e0:	83 c8 40             	or     $0x40,%eax
  1028e3:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028e8:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028ef:	83 e0 7f             	and    $0x7f,%eax
  1028f2:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028f7:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1028fc:	c1 e8 18             	shr    $0x18,%eax
  1028ff:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102904:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10290b:	83 e0 ef             	and    $0xffffffef,%eax
  10290e:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102913:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  10291a:	e8 da fe ff ff       	call   1027f9 <lgdt>
  10291f:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102925:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102929:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  10292c:	c9                   	leave  
  10292d:	c3                   	ret    

0010292e <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  10292e:	55                   	push   %ebp
  10292f:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102931:	e8 f8 fe ff ff       	call   10282e <gdt_init>
}
  102936:	5d                   	pop    %ebp
  102937:	c3                   	ret    

00102938 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102938:	55                   	push   %ebp
  102939:	89 e5                	mov    %esp,%ebp
  10293b:	83 ec 58             	sub    $0x58,%esp
  10293e:	8b 45 10             	mov    0x10(%ebp),%eax
  102941:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102944:	8b 45 14             	mov    0x14(%ebp),%eax
  102947:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  10294a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10294d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102950:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102953:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102956:	8b 45 18             	mov    0x18(%ebp),%eax
  102959:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10295c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10295f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102962:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102965:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102968:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10296b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10296e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102972:	74 1c                	je     102990 <printnum+0x58>
  102974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102977:	ba 00 00 00 00       	mov    $0x0,%edx
  10297c:	f7 75 e4             	divl   -0x1c(%ebp)
  10297f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102982:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102985:	ba 00 00 00 00       	mov    $0x0,%edx
  10298a:	f7 75 e4             	divl   -0x1c(%ebp)
  10298d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102990:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102993:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102996:	f7 75 e4             	divl   -0x1c(%ebp)
  102999:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10299c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10299f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1029a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1029a8:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1029ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1029ae:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1029b1:	8b 45 18             	mov    0x18(%ebp),%eax
  1029b4:	ba 00 00 00 00       	mov    $0x0,%edx
  1029b9:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1029bc:	77 56                	ja     102a14 <printnum+0xdc>
  1029be:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1029c1:	72 05                	jb     1029c8 <printnum+0x90>
  1029c3:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1029c6:	77 4c                	ja     102a14 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  1029c8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1029cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  1029ce:	8b 45 20             	mov    0x20(%ebp),%eax
  1029d1:	89 44 24 18          	mov    %eax,0x18(%esp)
  1029d5:	89 54 24 14          	mov    %edx,0x14(%esp)
  1029d9:	8b 45 18             	mov    0x18(%ebp),%eax
  1029dc:	89 44 24 10          	mov    %eax,0x10(%esp)
  1029e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1029e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1029e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1029ea:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1029ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1029f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1029f8:	89 04 24             	mov    %eax,(%esp)
  1029fb:	e8 38 ff ff ff       	call   102938 <printnum>
  102a00:	eb 1c                	jmp    102a1e <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102a02:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a05:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a09:	8b 45 20             	mov    0x20(%ebp),%eax
  102a0c:	89 04 24             	mov    %eax,(%esp)
  102a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  102a12:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102a14:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102a18:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102a1c:	7f e4                	jg     102a02 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102a1e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102a21:	05 10 3c 10 00       	add    $0x103c10,%eax
  102a26:	0f b6 00             	movzbl (%eax),%eax
  102a29:	0f be c0             	movsbl %al,%eax
  102a2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a2f:	89 54 24 04          	mov    %edx,0x4(%esp)
  102a33:	89 04 24             	mov    %eax,(%esp)
  102a36:	8b 45 08             	mov    0x8(%ebp),%eax
  102a39:	ff d0                	call   *%eax
}
  102a3b:	c9                   	leave  
  102a3c:	c3                   	ret    

00102a3d <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102a3d:	55                   	push   %ebp
  102a3e:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102a40:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102a44:	7e 14                	jle    102a5a <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102a46:	8b 45 08             	mov    0x8(%ebp),%eax
  102a49:	8b 00                	mov    (%eax),%eax
  102a4b:	8d 48 08             	lea    0x8(%eax),%ecx
  102a4e:	8b 55 08             	mov    0x8(%ebp),%edx
  102a51:	89 0a                	mov    %ecx,(%edx)
  102a53:	8b 50 04             	mov    0x4(%eax),%edx
  102a56:	8b 00                	mov    (%eax),%eax
  102a58:	eb 30                	jmp    102a8a <getuint+0x4d>
    }
    else if (lflag) {
  102a5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102a5e:	74 16                	je     102a76 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102a60:	8b 45 08             	mov    0x8(%ebp),%eax
  102a63:	8b 00                	mov    (%eax),%eax
  102a65:	8d 48 04             	lea    0x4(%eax),%ecx
  102a68:	8b 55 08             	mov    0x8(%ebp),%edx
  102a6b:	89 0a                	mov    %ecx,(%edx)
  102a6d:	8b 00                	mov    (%eax),%eax
  102a6f:	ba 00 00 00 00       	mov    $0x0,%edx
  102a74:	eb 14                	jmp    102a8a <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102a76:	8b 45 08             	mov    0x8(%ebp),%eax
  102a79:	8b 00                	mov    (%eax),%eax
  102a7b:	8d 48 04             	lea    0x4(%eax),%ecx
  102a7e:	8b 55 08             	mov    0x8(%ebp),%edx
  102a81:	89 0a                	mov    %ecx,(%edx)
  102a83:	8b 00                	mov    (%eax),%eax
  102a85:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102a8a:	5d                   	pop    %ebp
  102a8b:	c3                   	ret    

00102a8c <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102a8c:	55                   	push   %ebp
  102a8d:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102a8f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102a93:	7e 14                	jle    102aa9 <getint+0x1d>
        return va_arg(*ap, long long);
  102a95:	8b 45 08             	mov    0x8(%ebp),%eax
  102a98:	8b 00                	mov    (%eax),%eax
  102a9a:	8d 48 08             	lea    0x8(%eax),%ecx
  102a9d:	8b 55 08             	mov    0x8(%ebp),%edx
  102aa0:	89 0a                	mov    %ecx,(%edx)
  102aa2:	8b 50 04             	mov    0x4(%eax),%edx
  102aa5:	8b 00                	mov    (%eax),%eax
  102aa7:	eb 28                	jmp    102ad1 <getint+0x45>
    }
    else if (lflag) {
  102aa9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102aad:	74 12                	je     102ac1 <getint+0x35>
        return va_arg(*ap, long);
  102aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab2:	8b 00                	mov    (%eax),%eax
  102ab4:	8d 48 04             	lea    0x4(%eax),%ecx
  102ab7:	8b 55 08             	mov    0x8(%ebp),%edx
  102aba:	89 0a                	mov    %ecx,(%edx)
  102abc:	8b 00                	mov    (%eax),%eax
  102abe:	99                   	cltd   
  102abf:	eb 10                	jmp    102ad1 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac4:	8b 00                	mov    (%eax),%eax
  102ac6:	8d 48 04             	lea    0x4(%eax),%ecx
  102ac9:	8b 55 08             	mov    0x8(%ebp),%edx
  102acc:	89 0a                	mov    %ecx,(%edx)
  102ace:	8b 00                	mov    (%eax),%eax
  102ad0:	99                   	cltd   
    }
}
  102ad1:	5d                   	pop    %ebp
  102ad2:	c3                   	ret    

00102ad3 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102ad3:	55                   	push   %ebp
  102ad4:	89 e5                	mov    %esp,%ebp
  102ad6:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102ad9:	8d 45 14             	lea    0x14(%ebp),%eax
  102adc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ae2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102ae6:	8b 45 10             	mov    0x10(%ebp),%eax
  102ae9:	89 44 24 08          	mov    %eax,0x8(%esp)
  102aed:	8b 45 0c             	mov    0xc(%ebp),%eax
  102af0:	89 44 24 04          	mov    %eax,0x4(%esp)
  102af4:	8b 45 08             	mov    0x8(%ebp),%eax
  102af7:	89 04 24             	mov    %eax,(%esp)
  102afa:	e8 02 00 00 00       	call   102b01 <vprintfmt>
    va_end(ap);
}
  102aff:	c9                   	leave  
  102b00:	c3                   	ret    

00102b01 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102b01:	55                   	push   %ebp
  102b02:	89 e5                	mov    %esp,%ebp
  102b04:	56                   	push   %esi
  102b05:	53                   	push   %ebx
  102b06:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102b09:	eb 18                	jmp    102b23 <vprintfmt+0x22>
            if (ch == '\0') {
  102b0b:	85 db                	test   %ebx,%ebx
  102b0d:	75 05                	jne    102b14 <vprintfmt+0x13>
                return;
  102b0f:	e9 d1 03 00 00       	jmp    102ee5 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b17:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b1b:	89 1c 24             	mov    %ebx,(%esp)
  102b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  102b21:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102b23:	8b 45 10             	mov    0x10(%ebp),%eax
  102b26:	8d 50 01             	lea    0x1(%eax),%edx
  102b29:	89 55 10             	mov    %edx,0x10(%ebp)
  102b2c:	0f b6 00             	movzbl (%eax),%eax
  102b2f:	0f b6 d8             	movzbl %al,%ebx
  102b32:	83 fb 25             	cmp    $0x25,%ebx
  102b35:	75 d4                	jne    102b0b <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102b37:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102b3b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102b42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b45:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102b48:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102b4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b52:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102b55:	8b 45 10             	mov    0x10(%ebp),%eax
  102b58:	8d 50 01             	lea    0x1(%eax),%edx
  102b5b:	89 55 10             	mov    %edx,0x10(%ebp)
  102b5e:	0f b6 00             	movzbl (%eax),%eax
  102b61:	0f b6 d8             	movzbl %al,%ebx
  102b64:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102b67:	83 f8 55             	cmp    $0x55,%eax
  102b6a:	0f 87 44 03 00 00    	ja     102eb4 <vprintfmt+0x3b3>
  102b70:	8b 04 85 34 3c 10 00 	mov    0x103c34(,%eax,4),%eax
  102b77:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102b79:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102b7d:	eb d6                	jmp    102b55 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102b7f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102b83:	eb d0                	jmp    102b55 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102b85:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102b8c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102b8f:	89 d0                	mov    %edx,%eax
  102b91:	c1 e0 02             	shl    $0x2,%eax
  102b94:	01 d0                	add    %edx,%eax
  102b96:	01 c0                	add    %eax,%eax
  102b98:	01 d8                	add    %ebx,%eax
  102b9a:	83 e8 30             	sub    $0x30,%eax
  102b9d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102ba0:	8b 45 10             	mov    0x10(%ebp),%eax
  102ba3:	0f b6 00             	movzbl (%eax),%eax
  102ba6:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102ba9:	83 fb 2f             	cmp    $0x2f,%ebx
  102bac:	7e 0b                	jle    102bb9 <vprintfmt+0xb8>
  102bae:	83 fb 39             	cmp    $0x39,%ebx
  102bb1:	7f 06                	jg     102bb9 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102bb3:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102bb7:	eb d3                	jmp    102b8c <vprintfmt+0x8b>
            goto process_precision;
  102bb9:	eb 33                	jmp    102bee <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102bbb:	8b 45 14             	mov    0x14(%ebp),%eax
  102bbe:	8d 50 04             	lea    0x4(%eax),%edx
  102bc1:	89 55 14             	mov    %edx,0x14(%ebp)
  102bc4:	8b 00                	mov    (%eax),%eax
  102bc6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102bc9:	eb 23                	jmp    102bee <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102bcb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102bcf:	79 0c                	jns    102bdd <vprintfmt+0xdc>
                width = 0;
  102bd1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102bd8:	e9 78 ff ff ff       	jmp    102b55 <vprintfmt+0x54>
  102bdd:	e9 73 ff ff ff       	jmp    102b55 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102be2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102be9:	e9 67 ff ff ff       	jmp    102b55 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102bee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102bf2:	79 12                	jns    102c06 <vprintfmt+0x105>
                width = precision, precision = -1;
  102bf4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102bf7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102bfa:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102c01:	e9 4f ff ff ff       	jmp    102b55 <vprintfmt+0x54>
  102c06:	e9 4a ff ff ff       	jmp    102b55 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102c0b:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102c0f:	e9 41 ff ff ff       	jmp    102b55 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102c14:	8b 45 14             	mov    0x14(%ebp),%eax
  102c17:	8d 50 04             	lea    0x4(%eax),%edx
  102c1a:	89 55 14             	mov    %edx,0x14(%ebp)
  102c1d:	8b 00                	mov    (%eax),%eax
  102c1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c22:	89 54 24 04          	mov    %edx,0x4(%esp)
  102c26:	89 04 24             	mov    %eax,(%esp)
  102c29:	8b 45 08             	mov    0x8(%ebp),%eax
  102c2c:	ff d0                	call   *%eax
            break;
  102c2e:	e9 ac 02 00 00       	jmp    102edf <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102c33:	8b 45 14             	mov    0x14(%ebp),%eax
  102c36:	8d 50 04             	lea    0x4(%eax),%edx
  102c39:	89 55 14             	mov    %edx,0x14(%ebp)
  102c3c:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102c3e:	85 db                	test   %ebx,%ebx
  102c40:	79 02                	jns    102c44 <vprintfmt+0x143>
                err = -err;
  102c42:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102c44:	83 fb 06             	cmp    $0x6,%ebx
  102c47:	7f 0b                	jg     102c54 <vprintfmt+0x153>
  102c49:	8b 34 9d f4 3b 10 00 	mov    0x103bf4(,%ebx,4),%esi
  102c50:	85 f6                	test   %esi,%esi
  102c52:	75 23                	jne    102c77 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102c54:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102c58:	c7 44 24 08 21 3c 10 	movl   $0x103c21,0x8(%esp)
  102c5f:	00 
  102c60:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c63:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c67:	8b 45 08             	mov    0x8(%ebp),%eax
  102c6a:	89 04 24             	mov    %eax,(%esp)
  102c6d:	e8 61 fe ff ff       	call   102ad3 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102c72:	e9 68 02 00 00       	jmp    102edf <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102c77:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102c7b:	c7 44 24 08 2a 3c 10 	movl   $0x103c2a,0x8(%esp)
  102c82:	00 
  102c83:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c86:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  102c8d:	89 04 24             	mov    %eax,(%esp)
  102c90:	e8 3e fe ff ff       	call   102ad3 <printfmt>
            }
            break;
  102c95:	e9 45 02 00 00       	jmp    102edf <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102c9a:	8b 45 14             	mov    0x14(%ebp),%eax
  102c9d:	8d 50 04             	lea    0x4(%eax),%edx
  102ca0:	89 55 14             	mov    %edx,0x14(%ebp)
  102ca3:	8b 30                	mov    (%eax),%esi
  102ca5:	85 f6                	test   %esi,%esi
  102ca7:	75 05                	jne    102cae <vprintfmt+0x1ad>
                p = "(null)";
  102ca9:	be 2d 3c 10 00       	mov    $0x103c2d,%esi
            }
            if (width > 0 && padc != '-') {
  102cae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102cb2:	7e 3e                	jle    102cf2 <vprintfmt+0x1f1>
  102cb4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102cb8:	74 38                	je     102cf2 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102cba:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102cbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102cc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cc4:	89 34 24             	mov    %esi,(%esp)
  102cc7:	e8 15 03 00 00       	call   102fe1 <strnlen>
  102ccc:	29 c3                	sub    %eax,%ebx
  102cce:	89 d8                	mov    %ebx,%eax
  102cd0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102cd3:	eb 17                	jmp    102cec <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102cd5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102cd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cdc:	89 54 24 04          	mov    %edx,0x4(%esp)
  102ce0:	89 04 24             	mov    %eax,(%esp)
  102ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce6:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102ce8:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102cec:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102cf0:	7f e3                	jg     102cd5 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102cf2:	eb 38                	jmp    102d2c <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  102cf4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102cf8:	74 1f                	je     102d19 <vprintfmt+0x218>
  102cfa:	83 fb 1f             	cmp    $0x1f,%ebx
  102cfd:	7e 05                	jle    102d04 <vprintfmt+0x203>
  102cff:	83 fb 7e             	cmp    $0x7e,%ebx
  102d02:	7e 15                	jle    102d19 <vprintfmt+0x218>
                    putch('?', putdat);
  102d04:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d07:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d0b:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102d12:	8b 45 08             	mov    0x8(%ebp),%eax
  102d15:	ff d0                	call   *%eax
  102d17:	eb 0f                	jmp    102d28 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  102d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d20:	89 1c 24             	mov    %ebx,(%esp)
  102d23:	8b 45 08             	mov    0x8(%ebp),%eax
  102d26:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102d28:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102d2c:	89 f0                	mov    %esi,%eax
  102d2e:	8d 70 01             	lea    0x1(%eax),%esi
  102d31:	0f b6 00             	movzbl (%eax),%eax
  102d34:	0f be d8             	movsbl %al,%ebx
  102d37:	85 db                	test   %ebx,%ebx
  102d39:	74 10                	je     102d4b <vprintfmt+0x24a>
  102d3b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d3f:	78 b3                	js     102cf4 <vprintfmt+0x1f3>
  102d41:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102d45:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d49:	79 a9                	jns    102cf4 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102d4b:	eb 17                	jmp    102d64 <vprintfmt+0x263>
                putch(' ', putdat);
  102d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d50:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d54:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5e:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102d60:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102d64:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d68:	7f e3                	jg     102d4d <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  102d6a:	e9 70 01 00 00       	jmp    102edf <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102d6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d72:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d76:	8d 45 14             	lea    0x14(%ebp),%eax
  102d79:	89 04 24             	mov    %eax,(%esp)
  102d7c:	e8 0b fd ff ff       	call   102a8c <getint>
  102d81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d84:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102d87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d8d:	85 d2                	test   %edx,%edx
  102d8f:	79 26                	jns    102db7 <vprintfmt+0x2b6>
                putch('-', putdat);
  102d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d94:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d98:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  102da2:	ff d0                	call   *%eax
                num = -(long long)num;
  102da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102da7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102daa:	f7 d8                	neg    %eax
  102dac:	83 d2 00             	adc    $0x0,%edx
  102daf:	f7 da                	neg    %edx
  102db1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102db4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102db7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102dbe:	e9 a8 00 00 00       	jmp    102e6b <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102dc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102dc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dca:	8d 45 14             	lea    0x14(%ebp),%eax
  102dcd:	89 04 24             	mov    %eax,(%esp)
  102dd0:	e8 68 fc ff ff       	call   102a3d <getuint>
  102dd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dd8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102ddb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102de2:	e9 84 00 00 00       	jmp    102e6b <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102de7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102dea:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dee:	8d 45 14             	lea    0x14(%ebp),%eax
  102df1:	89 04 24             	mov    %eax,(%esp)
  102df4:	e8 44 fc ff ff       	call   102a3d <getuint>
  102df9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dfc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102dff:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102e06:	eb 63                	jmp    102e6b <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  102e08:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e0f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102e16:	8b 45 08             	mov    0x8(%ebp),%eax
  102e19:	ff d0                	call   *%eax
            putch('x', putdat);
  102e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e22:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102e29:	8b 45 08             	mov    0x8(%ebp),%eax
  102e2c:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102e2e:	8b 45 14             	mov    0x14(%ebp),%eax
  102e31:	8d 50 04             	lea    0x4(%eax),%edx
  102e34:	89 55 14             	mov    %edx,0x14(%ebp)
  102e37:	8b 00                	mov    (%eax),%eax
  102e39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102e43:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102e4a:	eb 1f                	jmp    102e6b <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102e4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e53:	8d 45 14             	lea    0x14(%ebp),%eax
  102e56:	89 04 24             	mov    %eax,(%esp)
  102e59:	e8 df fb ff ff       	call   102a3d <getuint>
  102e5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e61:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102e64:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102e6b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102e6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e72:	89 54 24 18          	mov    %edx,0x18(%esp)
  102e76:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102e79:	89 54 24 14          	mov    %edx,0x14(%esp)
  102e7d:	89 44 24 10          	mov    %eax,0x10(%esp)
  102e81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102e87:	89 44 24 08          	mov    %eax,0x8(%esp)
  102e8b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e92:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e96:	8b 45 08             	mov    0x8(%ebp),%eax
  102e99:	89 04 24             	mov    %eax,(%esp)
  102e9c:	e8 97 fa ff ff       	call   102938 <printnum>
            break;
  102ea1:	eb 3c                	jmp    102edf <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102ea3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ea6:	89 44 24 04          	mov    %eax,0x4(%esp)
  102eaa:	89 1c 24             	mov    %ebx,(%esp)
  102ead:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb0:	ff d0                	call   *%eax
            break;
  102eb2:	eb 2b                	jmp    102edf <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ebb:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  102ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ec5:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  102ec7:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102ecb:	eb 04                	jmp    102ed1 <vprintfmt+0x3d0>
  102ecd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102ed1:	8b 45 10             	mov    0x10(%ebp),%eax
  102ed4:	83 e8 01             	sub    $0x1,%eax
  102ed7:	0f b6 00             	movzbl (%eax),%eax
  102eda:	3c 25                	cmp    $0x25,%al
  102edc:	75 ef                	jne    102ecd <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  102ede:	90                   	nop
        }
    }
  102edf:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102ee0:	e9 3e fc ff ff       	jmp    102b23 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  102ee5:	83 c4 40             	add    $0x40,%esp
  102ee8:	5b                   	pop    %ebx
  102ee9:	5e                   	pop    %esi
  102eea:	5d                   	pop    %ebp
  102eeb:	c3                   	ret    

00102eec <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  102eec:	55                   	push   %ebp
  102eed:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  102eef:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ef2:	8b 40 08             	mov    0x8(%eax),%eax
  102ef5:	8d 50 01             	lea    0x1(%eax),%edx
  102ef8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102efb:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  102efe:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f01:	8b 10                	mov    (%eax),%edx
  102f03:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f06:	8b 40 04             	mov    0x4(%eax),%eax
  102f09:	39 c2                	cmp    %eax,%edx
  102f0b:	73 12                	jae    102f1f <sprintputch+0x33>
        *b->buf ++ = ch;
  102f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f10:	8b 00                	mov    (%eax),%eax
  102f12:	8d 48 01             	lea    0x1(%eax),%ecx
  102f15:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f18:	89 0a                	mov    %ecx,(%edx)
  102f1a:	8b 55 08             	mov    0x8(%ebp),%edx
  102f1d:	88 10                	mov    %dl,(%eax)
    }
}
  102f1f:	5d                   	pop    %ebp
  102f20:	c3                   	ret    

00102f21 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  102f21:	55                   	push   %ebp
  102f22:	89 e5                	mov    %esp,%ebp
  102f24:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  102f27:	8d 45 14             	lea    0x14(%ebp),%eax
  102f2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  102f2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f30:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f34:	8b 45 10             	mov    0x10(%ebp),%eax
  102f37:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f42:	8b 45 08             	mov    0x8(%ebp),%eax
  102f45:	89 04 24             	mov    %eax,(%esp)
  102f48:	e8 08 00 00 00       	call   102f55 <vsnprintf>
  102f4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  102f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102f53:	c9                   	leave  
  102f54:	c3                   	ret    

00102f55 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  102f55:	55                   	push   %ebp
  102f56:	89 e5                	mov    %esp,%ebp
  102f58:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  102f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  102f5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f64:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f67:	8b 45 08             	mov    0x8(%ebp),%eax
  102f6a:	01 d0                	add    %edx,%eax
  102f6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  102f76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102f7a:	74 0a                	je     102f86 <vsnprintf+0x31>
  102f7c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102f7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f82:	39 c2                	cmp    %eax,%edx
  102f84:	76 07                	jbe    102f8d <vsnprintf+0x38>
        return -E_INVAL;
  102f86:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  102f8b:	eb 2a                	jmp    102fb7 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  102f8d:	8b 45 14             	mov    0x14(%ebp),%eax
  102f90:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f94:	8b 45 10             	mov    0x10(%ebp),%eax
  102f97:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f9b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  102f9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fa2:	c7 04 24 ec 2e 10 00 	movl   $0x102eec,(%esp)
  102fa9:	e8 53 fb ff ff       	call   102b01 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  102fae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fb1:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  102fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102fb7:	c9                   	leave  
  102fb8:	c3                   	ret    

00102fb9 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102fb9:	55                   	push   %ebp
  102fba:	89 e5                	mov    %esp,%ebp
  102fbc:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102fbf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102fc6:	eb 04                	jmp    102fcc <strlen+0x13>
        cnt ++;
  102fc8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  102fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  102fcf:	8d 50 01             	lea    0x1(%eax),%edx
  102fd2:	89 55 08             	mov    %edx,0x8(%ebp)
  102fd5:	0f b6 00             	movzbl (%eax),%eax
  102fd8:	84 c0                	test   %al,%al
  102fda:	75 ec                	jne    102fc8 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  102fdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102fdf:	c9                   	leave  
  102fe0:	c3                   	ret    

00102fe1 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102fe1:	55                   	push   %ebp
  102fe2:	89 e5                	mov    %esp,%ebp
  102fe4:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102fe7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102fee:	eb 04                	jmp    102ff4 <strnlen+0x13>
        cnt ++;
  102ff0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  102ff4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102ff7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102ffa:	73 10                	jae    10300c <strnlen+0x2b>
  102ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  102fff:	8d 50 01             	lea    0x1(%eax),%edx
  103002:	89 55 08             	mov    %edx,0x8(%ebp)
  103005:	0f b6 00             	movzbl (%eax),%eax
  103008:	84 c0                	test   %al,%al
  10300a:	75 e4                	jne    102ff0 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  10300c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10300f:	c9                   	leave  
  103010:	c3                   	ret    

00103011 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  103011:	55                   	push   %ebp
  103012:	89 e5                	mov    %esp,%ebp
  103014:	57                   	push   %edi
  103015:	56                   	push   %esi
  103016:	83 ec 20             	sub    $0x20,%esp
  103019:	8b 45 08             	mov    0x8(%ebp),%eax
  10301c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10301f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103022:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  103025:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10302b:	89 d1                	mov    %edx,%ecx
  10302d:	89 c2                	mov    %eax,%edx
  10302f:	89 ce                	mov    %ecx,%esi
  103031:	89 d7                	mov    %edx,%edi
  103033:	ac                   	lods   %ds:(%esi),%al
  103034:	aa                   	stos   %al,%es:(%edi)
  103035:	84 c0                	test   %al,%al
  103037:	75 fa                	jne    103033 <strcpy+0x22>
  103039:	89 fa                	mov    %edi,%edx
  10303b:	89 f1                	mov    %esi,%ecx
  10303d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103040:	89 55 e8             	mov    %edx,-0x18(%ebp)
  103043:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  103046:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  103049:	83 c4 20             	add    $0x20,%esp
  10304c:	5e                   	pop    %esi
  10304d:	5f                   	pop    %edi
  10304e:	5d                   	pop    %ebp
  10304f:	c3                   	ret    

00103050 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  103050:	55                   	push   %ebp
  103051:	89 e5                	mov    %esp,%ebp
  103053:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  103056:	8b 45 08             	mov    0x8(%ebp),%eax
  103059:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  10305c:	eb 21                	jmp    10307f <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  10305e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103061:	0f b6 10             	movzbl (%eax),%edx
  103064:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103067:	88 10                	mov    %dl,(%eax)
  103069:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10306c:	0f b6 00             	movzbl (%eax),%eax
  10306f:	84 c0                	test   %al,%al
  103071:	74 04                	je     103077 <strncpy+0x27>
            src ++;
  103073:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  103077:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10307b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  10307f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103083:	75 d9                	jne    10305e <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  103085:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103088:	c9                   	leave  
  103089:	c3                   	ret    

0010308a <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  10308a:	55                   	push   %ebp
  10308b:	89 e5                	mov    %esp,%ebp
  10308d:	57                   	push   %edi
  10308e:	56                   	push   %esi
  10308f:	83 ec 20             	sub    $0x20,%esp
  103092:	8b 45 08             	mov    0x8(%ebp),%eax
  103095:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103098:	8b 45 0c             	mov    0xc(%ebp),%eax
  10309b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  10309e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1030a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030a4:	89 d1                	mov    %edx,%ecx
  1030a6:	89 c2                	mov    %eax,%edx
  1030a8:	89 ce                	mov    %ecx,%esi
  1030aa:	89 d7                	mov    %edx,%edi
  1030ac:	ac                   	lods   %ds:(%esi),%al
  1030ad:	ae                   	scas   %es:(%edi),%al
  1030ae:	75 08                	jne    1030b8 <strcmp+0x2e>
  1030b0:	84 c0                	test   %al,%al
  1030b2:	75 f8                	jne    1030ac <strcmp+0x22>
  1030b4:	31 c0                	xor    %eax,%eax
  1030b6:	eb 04                	jmp    1030bc <strcmp+0x32>
  1030b8:	19 c0                	sbb    %eax,%eax
  1030ba:	0c 01                	or     $0x1,%al
  1030bc:	89 fa                	mov    %edi,%edx
  1030be:	89 f1                	mov    %esi,%ecx
  1030c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1030c3:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1030c6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  1030c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1030cc:	83 c4 20             	add    $0x20,%esp
  1030cf:	5e                   	pop    %esi
  1030d0:	5f                   	pop    %edi
  1030d1:	5d                   	pop    %ebp
  1030d2:	c3                   	ret    

001030d3 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1030d3:	55                   	push   %ebp
  1030d4:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1030d6:	eb 0c                	jmp    1030e4 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  1030d8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1030dc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1030e0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1030e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030e8:	74 1a                	je     103104 <strncmp+0x31>
  1030ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ed:	0f b6 00             	movzbl (%eax),%eax
  1030f0:	84 c0                	test   %al,%al
  1030f2:	74 10                	je     103104 <strncmp+0x31>
  1030f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1030f7:	0f b6 10             	movzbl (%eax),%edx
  1030fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030fd:	0f b6 00             	movzbl (%eax),%eax
  103100:	38 c2                	cmp    %al,%dl
  103102:	74 d4                	je     1030d8 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  103104:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103108:	74 18                	je     103122 <strncmp+0x4f>
  10310a:	8b 45 08             	mov    0x8(%ebp),%eax
  10310d:	0f b6 00             	movzbl (%eax),%eax
  103110:	0f b6 d0             	movzbl %al,%edx
  103113:	8b 45 0c             	mov    0xc(%ebp),%eax
  103116:	0f b6 00             	movzbl (%eax),%eax
  103119:	0f b6 c0             	movzbl %al,%eax
  10311c:	29 c2                	sub    %eax,%edx
  10311e:	89 d0                	mov    %edx,%eax
  103120:	eb 05                	jmp    103127 <strncmp+0x54>
  103122:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103127:	5d                   	pop    %ebp
  103128:	c3                   	ret    

00103129 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  103129:	55                   	push   %ebp
  10312a:	89 e5                	mov    %esp,%ebp
  10312c:	83 ec 04             	sub    $0x4,%esp
  10312f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103132:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103135:	eb 14                	jmp    10314b <strchr+0x22>
        if (*s == c) {
  103137:	8b 45 08             	mov    0x8(%ebp),%eax
  10313a:	0f b6 00             	movzbl (%eax),%eax
  10313d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  103140:	75 05                	jne    103147 <strchr+0x1e>
            return (char *)s;
  103142:	8b 45 08             	mov    0x8(%ebp),%eax
  103145:	eb 13                	jmp    10315a <strchr+0x31>
        }
        s ++;
  103147:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  10314b:	8b 45 08             	mov    0x8(%ebp),%eax
  10314e:	0f b6 00             	movzbl (%eax),%eax
  103151:	84 c0                	test   %al,%al
  103153:	75 e2                	jne    103137 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  103155:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10315a:	c9                   	leave  
  10315b:	c3                   	ret    

0010315c <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  10315c:	55                   	push   %ebp
  10315d:	89 e5                	mov    %esp,%ebp
  10315f:	83 ec 04             	sub    $0x4,%esp
  103162:	8b 45 0c             	mov    0xc(%ebp),%eax
  103165:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103168:	eb 11                	jmp    10317b <strfind+0x1f>
        if (*s == c) {
  10316a:	8b 45 08             	mov    0x8(%ebp),%eax
  10316d:	0f b6 00             	movzbl (%eax),%eax
  103170:	3a 45 fc             	cmp    -0x4(%ebp),%al
  103173:	75 02                	jne    103177 <strfind+0x1b>
            break;
  103175:	eb 0e                	jmp    103185 <strfind+0x29>
        }
        s ++;
  103177:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  10317b:	8b 45 08             	mov    0x8(%ebp),%eax
  10317e:	0f b6 00             	movzbl (%eax),%eax
  103181:	84 c0                	test   %al,%al
  103183:	75 e5                	jne    10316a <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  103185:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103188:	c9                   	leave  
  103189:	c3                   	ret    

0010318a <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  10318a:	55                   	push   %ebp
  10318b:	89 e5                	mov    %esp,%ebp
  10318d:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  103190:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  103197:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  10319e:	eb 04                	jmp    1031a4 <strtol+0x1a>
        s ++;
  1031a0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1031a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1031a7:	0f b6 00             	movzbl (%eax),%eax
  1031aa:	3c 20                	cmp    $0x20,%al
  1031ac:	74 f2                	je     1031a0 <strtol+0x16>
  1031ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1031b1:	0f b6 00             	movzbl (%eax),%eax
  1031b4:	3c 09                	cmp    $0x9,%al
  1031b6:	74 e8                	je     1031a0 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  1031b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1031bb:	0f b6 00             	movzbl (%eax),%eax
  1031be:	3c 2b                	cmp    $0x2b,%al
  1031c0:	75 06                	jne    1031c8 <strtol+0x3e>
        s ++;
  1031c2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1031c6:	eb 15                	jmp    1031dd <strtol+0x53>
    }
    else if (*s == '-') {
  1031c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1031cb:	0f b6 00             	movzbl (%eax),%eax
  1031ce:	3c 2d                	cmp    $0x2d,%al
  1031d0:	75 0b                	jne    1031dd <strtol+0x53>
        s ++, neg = 1;
  1031d2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1031d6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1031dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031e1:	74 06                	je     1031e9 <strtol+0x5f>
  1031e3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1031e7:	75 24                	jne    10320d <strtol+0x83>
  1031e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ec:	0f b6 00             	movzbl (%eax),%eax
  1031ef:	3c 30                	cmp    $0x30,%al
  1031f1:	75 1a                	jne    10320d <strtol+0x83>
  1031f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1031f6:	83 c0 01             	add    $0x1,%eax
  1031f9:	0f b6 00             	movzbl (%eax),%eax
  1031fc:	3c 78                	cmp    $0x78,%al
  1031fe:	75 0d                	jne    10320d <strtol+0x83>
        s += 2, base = 16;
  103200:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  103204:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  10320b:	eb 2a                	jmp    103237 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  10320d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103211:	75 17                	jne    10322a <strtol+0xa0>
  103213:	8b 45 08             	mov    0x8(%ebp),%eax
  103216:	0f b6 00             	movzbl (%eax),%eax
  103219:	3c 30                	cmp    $0x30,%al
  10321b:	75 0d                	jne    10322a <strtol+0xa0>
        s ++, base = 8;
  10321d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103221:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  103228:	eb 0d                	jmp    103237 <strtol+0xad>
    }
    else if (base == 0) {
  10322a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10322e:	75 07                	jne    103237 <strtol+0xad>
        base = 10;
  103230:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  103237:	8b 45 08             	mov    0x8(%ebp),%eax
  10323a:	0f b6 00             	movzbl (%eax),%eax
  10323d:	3c 2f                	cmp    $0x2f,%al
  10323f:	7e 1b                	jle    10325c <strtol+0xd2>
  103241:	8b 45 08             	mov    0x8(%ebp),%eax
  103244:	0f b6 00             	movzbl (%eax),%eax
  103247:	3c 39                	cmp    $0x39,%al
  103249:	7f 11                	jg     10325c <strtol+0xd2>
            dig = *s - '0';
  10324b:	8b 45 08             	mov    0x8(%ebp),%eax
  10324e:	0f b6 00             	movzbl (%eax),%eax
  103251:	0f be c0             	movsbl %al,%eax
  103254:	83 e8 30             	sub    $0x30,%eax
  103257:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10325a:	eb 48                	jmp    1032a4 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  10325c:	8b 45 08             	mov    0x8(%ebp),%eax
  10325f:	0f b6 00             	movzbl (%eax),%eax
  103262:	3c 60                	cmp    $0x60,%al
  103264:	7e 1b                	jle    103281 <strtol+0xf7>
  103266:	8b 45 08             	mov    0x8(%ebp),%eax
  103269:	0f b6 00             	movzbl (%eax),%eax
  10326c:	3c 7a                	cmp    $0x7a,%al
  10326e:	7f 11                	jg     103281 <strtol+0xf7>
            dig = *s - 'a' + 10;
  103270:	8b 45 08             	mov    0x8(%ebp),%eax
  103273:	0f b6 00             	movzbl (%eax),%eax
  103276:	0f be c0             	movsbl %al,%eax
  103279:	83 e8 57             	sub    $0x57,%eax
  10327c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10327f:	eb 23                	jmp    1032a4 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  103281:	8b 45 08             	mov    0x8(%ebp),%eax
  103284:	0f b6 00             	movzbl (%eax),%eax
  103287:	3c 40                	cmp    $0x40,%al
  103289:	7e 3d                	jle    1032c8 <strtol+0x13e>
  10328b:	8b 45 08             	mov    0x8(%ebp),%eax
  10328e:	0f b6 00             	movzbl (%eax),%eax
  103291:	3c 5a                	cmp    $0x5a,%al
  103293:	7f 33                	jg     1032c8 <strtol+0x13e>
            dig = *s - 'A' + 10;
  103295:	8b 45 08             	mov    0x8(%ebp),%eax
  103298:	0f b6 00             	movzbl (%eax),%eax
  10329b:	0f be c0             	movsbl %al,%eax
  10329e:	83 e8 37             	sub    $0x37,%eax
  1032a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1032a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032a7:	3b 45 10             	cmp    0x10(%ebp),%eax
  1032aa:	7c 02                	jl     1032ae <strtol+0x124>
            break;
  1032ac:	eb 1a                	jmp    1032c8 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  1032ae:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1032b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032b5:	0f af 45 10          	imul   0x10(%ebp),%eax
  1032b9:	89 c2                	mov    %eax,%edx
  1032bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032be:	01 d0                	add    %edx,%eax
  1032c0:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  1032c3:	e9 6f ff ff ff       	jmp    103237 <strtol+0xad>

    if (endptr) {
  1032c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1032cc:	74 08                	je     1032d6 <strtol+0x14c>
        *endptr = (char *) s;
  1032ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032d1:	8b 55 08             	mov    0x8(%ebp),%edx
  1032d4:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1032d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1032da:	74 07                	je     1032e3 <strtol+0x159>
  1032dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032df:	f7 d8                	neg    %eax
  1032e1:	eb 03                	jmp    1032e6 <strtol+0x15c>
  1032e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1032e6:	c9                   	leave  
  1032e7:	c3                   	ret    

001032e8 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1032e8:	55                   	push   %ebp
  1032e9:	89 e5                	mov    %esp,%ebp
  1032eb:	57                   	push   %edi
  1032ec:	83 ec 24             	sub    $0x24,%esp
  1032ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032f2:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1032f5:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  1032f9:	8b 55 08             	mov    0x8(%ebp),%edx
  1032fc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  1032ff:	88 45 f7             	mov    %al,-0x9(%ebp)
  103302:	8b 45 10             	mov    0x10(%ebp),%eax
  103305:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  103308:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10330b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  10330f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  103312:	89 d7                	mov    %edx,%edi
  103314:	f3 aa                	rep stos %al,%es:(%edi)
  103316:	89 fa                	mov    %edi,%edx
  103318:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10331b:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  10331e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  103321:	83 c4 24             	add    $0x24,%esp
  103324:	5f                   	pop    %edi
  103325:	5d                   	pop    %ebp
  103326:	c3                   	ret    

00103327 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  103327:	55                   	push   %ebp
  103328:	89 e5                	mov    %esp,%ebp
  10332a:	57                   	push   %edi
  10332b:	56                   	push   %esi
  10332c:	53                   	push   %ebx
  10332d:	83 ec 30             	sub    $0x30,%esp
  103330:	8b 45 08             	mov    0x8(%ebp),%eax
  103333:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103336:	8b 45 0c             	mov    0xc(%ebp),%eax
  103339:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10333c:	8b 45 10             	mov    0x10(%ebp),%eax
  10333f:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  103342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103345:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103348:	73 42                	jae    10338c <memmove+0x65>
  10334a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10334d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103350:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103353:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103356:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103359:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10335c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10335f:	c1 e8 02             	shr    $0x2,%eax
  103362:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  103364:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103367:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10336a:	89 d7                	mov    %edx,%edi
  10336c:	89 c6                	mov    %eax,%esi
  10336e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103370:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  103373:	83 e1 03             	and    $0x3,%ecx
  103376:	74 02                	je     10337a <memmove+0x53>
  103378:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10337a:	89 f0                	mov    %esi,%eax
  10337c:	89 fa                	mov    %edi,%edx
  10337e:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  103381:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103384:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103387:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10338a:	eb 36                	jmp    1033c2 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  10338c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10338f:	8d 50 ff             	lea    -0x1(%eax),%edx
  103392:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103395:	01 c2                	add    %eax,%edx
  103397:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10339a:	8d 48 ff             	lea    -0x1(%eax),%ecx
  10339d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033a0:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  1033a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033a6:	89 c1                	mov    %eax,%ecx
  1033a8:	89 d8                	mov    %ebx,%eax
  1033aa:	89 d6                	mov    %edx,%esi
  1033ac:	89 c7                	mov    %eax,%edi
  1033ae:	fd                   	std    
  1033af:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1033b1:	fc                   	cld    
  1033b2:	89 f8                	mov    %edi,%eax
  1033b4:	89 f2                	mov    %esi,%edx
  1033b6:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1033b9:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1033bc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  1033bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1033c2:	83 c4 30             	add    $0x30,%esp
  1033c5:	5b                   	pop    %ebx
  1033c6:	5e                   	pop    %esi
  1033c7:	5f                   	pop    %edi
  1033c8:	5d                   	pop    %ebp
  1033c9:	c3                   	ret    

001033ca <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1033ca:	55                   	push   %ebp
  1033cb:	89 e5                	mov    %esp,%ebp
  1033cd:	57                   	push   %edi
  1033ce:	56                   	push   %esi
  1033cf:	83 ec 20             	sub    $0x20,%esp
  1033d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1033d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033de:	8b 45 10             	mov    0x10(%ebp),%eax
  1033e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1033e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033e7:	c1 e8 02             	shr    $0x2,%eax
  1033ea:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1033ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1033ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033f2:	89 d7                	mov    %edx,%edi
  1033f4:	89 c6                	mov    %eax,%esi
  1033f6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1033f8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1033fb:	83 e1 03             	and    $0x3,%ecx
  1033fe:	74 02                	je     103402 <memcpy+0x38>
  103400:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103402:	89 f0                	mov    %esi,%eax
  103404:	89 fa                	mov    %edi,%edx
  103406:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103409:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10340c:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  10340f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103412:	83 c4 20             	add    $0x20,%esp
  103415:	5e                   	pop    %esi
  103416:	5f                   	pop    %edi
  103417:	5d                   	pop    %ebp
  103418:	c3                   	ret    

00103419 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  103419:	55                   	push   %ebp
  10341a:	89 e5                	mov    %esp,%ebp
  10341c:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  10341f:	8b 45 08             	mov    0x8(%ebp),%eax
  103422:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103425:	8b 45 0c             	mov    0xc(%ebp),%eax
  103428:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10342b:	eb 30                	jmp    10345d <memcmp+0x44>
        if (*s1 != *s2) {
  10342d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103430:	0f b6 10             	movzbl (%eax),%edx
  103433:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103436:	0f b6 00             	movzbl (%eax),%eax
  103439:	38 c2                	cmp    %al,%dl
  10343b:	74 18                	je     103455 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  10343d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103440:	0f b6 00             	movzbl (%eax),%eax
  103443:	0f b6 d0             	movzbl %al,%edx
  103446:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103449:	0f b6 00             	movzbl (%eax),%eax
  10344c:	0f b6 c0             	movzbl %al,%eax
  10344f:	29 c2                	sub    %eax,%edx
  103451:	89 d0                	mov    %edx,%eax
  103453:	eb 1a                	jmp    10346f <memcmp+0x56>
        }
        s1 ++, s2 ++;
  103455:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  103459:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  10345d:	8b 45 10             	mov    0x10(%ebp),%eax
  103460:	8d 50 ff             	lea    -0x1(%eax),%edx
  103463:	89 55 10             	mov    %edx,0x10(%ebp)
  103466:	85 c0                	test   %eax,%eax
  103468:	75 c3                	jne    10342d <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  10346a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10346f:	c9                   	leave  
  103470:	c3                   	ret    
